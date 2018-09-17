OBJECT Report 1306 Standard Sales - Invoice
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    Permissions=TableData 7190=rimd;
    CaptionML=[DAN=Salg - faktura;
               ENU=Sales - Invoice];
    EnableHyperlinks=Yes;
    OnInitReport=BEGIN
                   GLSetup.GET;
                   CompanyInfo.SETAUTOCALCFIELDS(Picture);
                   CompanyInfo.GET;
                   SalesSetup.GET;
                   CompanyInfo.VerifyAndSetPaymentInfo;
                 END;

    OnPreReport=BEGIN
                  IF Header.GETFILTERS = '' THEN
                    ERROR(NoFilterSetErr);

                  IF NOT CurrReport.USEREQUESTPAGE THEN
                    InitLogInteraction;

                  CompanyLogoPosition := SalesSetup."Logo Position on Documents";
                END;

    PreviewMode=PrintLayout;
    DefaultLayout=Word;
    WordMergeDataItem=Header;
  }
  DATASET
  {
    { 5581;    ;DataItem;Header              ;
               DataItemTable=Table112;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Bogf›rt salgsfaktura;
                                   ENU=Posted Sales Invoice];
               OnPreDataItem=BEGIN
                               FirstLineHasBeenOutput := FALSE;
                             END;

               OnAfterGetRecord=VAR
                                  CurrencyExchangeRate@1000 : Record 330;
                                  PaymentServiceSetup@1001 : Record 1060;
                                  IdentityManagement@1002 : Codeunit 9801;
                                BEGIN
                                  IF "Language Code" = '' THEN
                                    IF IdentityManagement.IsInvAppId THEN BEGIN
                                      "Language Code" := Language.GetUserLanguage;
                                      CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                                    END;

                                  IF NOT IdentityManagement.IsInvAppId THEN BEGIN
                                    IF GLOBALLANGUAGE = Language.GetLanguageID("Language Code") THEN
                                      CurrReport.LANGUAGE := Language.GetLanguageID("Language Code")
                                    ELSE
                                      CurrReport.LANGUAGE := Language.GetLanguageID('ENU');
                                  END;

                                  FillLeftHeader;
                                  FillRightHeader;

                                  IF NOT CurrReport.PREVIEW THEN
                                    CODEUNIT.RUN(CODEUNIT::"Sales Inv.-Printed",Header);

                                  CALCFIELDS("Work Description");
                                  ShowWorkDescription := "Work Description".HASVALUE;

                                  ChecksPayableText := STRSUBSTNO(ChecksPayableLbl,CompanyInfo.Name);

                                  FormatAddressFields(Header);
                                  FormatDocumentFields(Header);

                                  IF NOT Cust.GET("Bill-to Customer No.") THEN
                                    CLEAR(Cust);

                                  IF "Currency Code" <> '' THEN BEGIN
                                    CurrencyExchangeRate.FindCurrency("Posting Date","Currency Code",1);
                                    CalculatedExchRate :=
                                      ROUND(1 / "Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount",0.000001);
                                    ExchangeRateText := STRSUBSTNO(ExchangeRateTxt,CalculatedExchRate,CurrencyExchangeRate."Exchange Rate Amount");
                                  END;

                                  GetLineFeeNoteOnReportHist("No.");

                                  IF LogInteraction AND NOT CurrReport.PREVIEW THEN BEGIN
                                    IF "Bill-to Contact No." <> '' THEN
                                      SegManagement.LogDocument(
                                        4,"No.",0,0,DATABASE::Contact,"Bill-to Contact No.","Salesperson Code",
                                        "Campaign No.","Posting Description",'')
                                    ELSE
                                      SegManagement.LogDocument(
                                        4,"No.",0,0,DATABASE::Customer,"Bill-to Customer No.","Salesperson Code",
                                        "Campaign No.","Posting Description",'');
                                  END;

                                  PaymentServiceSetup.CreateReportingArgs(PaymentReportingArgument,Header);

                                  CALCFIELDS("Amount Including VAT");
                                  RemainingAmount := GetRemainingAmount;
                                  IF RemainingAmount = 0 THEN
                                    RemainingAmountTxt := AlreadyPaidLbl
                                  ELSE
                                    IF RemainingAmount <> "Amount Including VAT" THEN
                                      RemainingAmountTxt := STRSUBSTNO(PartiallyPaidLbl,FORMAT(RemainingAmount,0,'<Precision,2><Standard Format,0>'))
                                    ELSE
                                      RemainingAmountTxt := '';

                                  TotalSubTotal := 0;
                                  TotalInvDiscAmount := 0;
                                  TotalAmount := 0;
                                  TotalAmountVAT := 0;
                                  TotalAmountInclVAT := 0;
                                  TotalPaymentDiscOnVAT := 0;
                                END;

               ReqFilterFields=No.,Sell-to Customer No.,No. Printed }

    { 18  ;1   ;Column  ;CompanyAddress1     ;
               SourceExpr=CompanyAddr[1] }

    { 13  ;1   ;Column  ;CompanyAddress2     ;
               SourceExpr=CompanyAddr[2] }

    { 9   ;1   ;Column  ;CompanyAddress3     ;
               SourceExpr=CompanyAddr[3] }

    { 7   ;1   ;Column  ;CompanyAddress4     ;
               SourceExpr=CompanyAddr[4] }

    { 5   ;1   ;Column  ;CompanyAddress5     ;
               SourceExpr=CompanyAddr[5] }

    { 4   ;1   ;Column  ;CompanyAddress6     ;
               SourceExpr=CompanyAddr[6] }

    { 238 ;1   ;Column  ;CompanyAddress7     ;
               SourceExpr=CompanyAddr[7] }

    { 239 ;1   ;Column  ;CompanyAddress8     ;
               SourceExpr=CompanyAddr[8] }

    { 65  ;1   ;Column  ;CompanyHomePage     ;
               SourceExpr=CompanyInfo."Home Page" }

    { 63  ;1   ;Column  ;CompanyEMail        ;
               SourceExpr=CompanyInfo."E-Mail" }

    { 147 ;1   ;Column  ;CompanyPicture      ;
               SourceExpr=CompanyInfo.Picture }

    { 11  ;1   ;Column  ;CompanyPhoneNo      ;
               SourceExpr=CompanyInfo."Phone No." }

    { 24  ;1   ;Column  ;CompanyPhoneNo_Lbl  ;
               SourceExpr=CompanyInfoPhoneNoLbl }

    { 19  ;1   ;Column  ;CompanyGiroNo       ;
               SourceExpr=CompanyInfo."Giro No." }

    { 22  ;1   ;Column  ;CompanyGiroNo_Lbl   ;
               SourceExpr=CompanyInfoGiroNoLbl }

    { 16  ;1   ;Column  ;CompanyBankName     ;
               SourceExpr=CompanyInfo."Bank Name" }

    { 27  ;1   ;Column  ;CompanyBankName_Lbl ;
               SourceExpr=CompanyInfoBankNameLbl }

    { 152 ;1   ;Column  ;CompanyBankBranchNo ;
               SourceExpr=CompanyInfo."Bank Branch No." }

    { 182 ;1   ;Column  ;CompanyBankBranchNo_Lbl;
               SourceExpr=CompanyInfo.FIELDCAPTION("Bank Branch No.") }

    { 14  ;1   ;Column  ;CompanyBankAccountNo;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 119 ;1   ;Column  ;CompanyBankAccountNo_Lbl;
               SourceExpr=CompanyInfoBankAccNoLbl }

    { 49  ;1   ;Column  ;CompanyIBAN         ;
               SourceExpr=CompanyInfo.IBAN }

    { 106 ;1   ;Column  ;CompanyIBAN_Lbl     ;
               SourceExpr=CompanyInfo.FIELDCAPTION(IBAN) }

    { 186 ;1   ;Column  ;CompanySWIFT        ;
               SourceExpr=CompanyInfo."SWIFT Code" }

    { 187 ;1   ;Column  ;CompanySWIFT_Lbl    ;
               SourceExpr=CompanyInfo.FIELDCAPTION("SWIFT Code") }

    { 42  ;1   ;Column  ;CompanyLogoPosition ;
               SourceExpr=CompanyLogoPosition }

    { 81  ;1   ;Column  ;CompanyRegistrationNumber;
               SourceExpr=CompanyInfo.GetRegistrationNumber }

    { 168 ;1   ;Column  ;CompanyRegistrationNumber_Lbl;
               SourceExpr=CompanyInfo.GetRegistrationNumberLbl }

    { 20  ;1   ;Column  ;CompanyVATRegNo     ;
               SourceExpr=CompanyInfo.GetVATRegistrationNumber }

    { 21  ;1   ;Column  ;CompanyVATRegNo_Lbl ;
               SourceExpr=CompanyInfo.GetVATRegistrationNumberLbl }

    { 169 ;1   ;Column  ;CompanyVATRegistrationNo;
               SourceExpr=CompanyInfo.GetVATRegistrationNumber }

    { 170 ;1   ;Column  ;CompanyVATRegistrationNo_Lbl;
               SourceExpr=CompanyInfo.GetVATRegistrationNumberLbl }

    { 171 ;1   ;Column  ;CompanyLegalOffice  ;
               SourceExpr=CompanyInfo.GetLegalOffice }

    { 172 ;1   ;Column  ;CompanyLegalOffice_Lbl;
               SourceExpr=CompanyInfo.GetLegalOfficeLbl }

    { 173 ;1   ;Column  ;CompanyCustomGiro   ;
               SourceExpr=CompanyInfo.GetCustomGiro }

    { 174 ;1   ;Column  ;CompanyCustomGiro_Lbl;
               SourceExpr=CompanyInfo.GetCustomGiroLbl }

    { 181 ;1   ;Column  ;CompanyLegalStatement;
               SourceExpr=GetLegalStatement }

    { 304 ;1   ;Column  ;DisplayAdditionalFeeNote;
               SourceExpr=DisplayAdditionalFeeNote }

    { 2   ;1   ;Column  ;CustomerAddress1    ;
               SourceExpr=CustAddr[1] }

    { 6   ;1   ;Column  ;CustomerAddress2    ;
               SourceExpr=CustAddr[2] }

    { 8   ;1   ;Column  ;CustomerAddress3    ;
               SourceExpr=CustAddr[3] }

    { 10  ;1   ;Column  ;CustomerAddress4    ;
               SourceExpr=CustAddr[4] }

    { 12  ;1   ;Column  ;CustomerAddress5    ;
               SourceExpr=CustAddr[5] }

    { 15  ;1   ;Column  ;CustomerAddress6    ;
               SourceExpr=CustAddr[6] }

    { 23  ;1   ;Column  ;CustomerAddress7    ;
               SourceExpr=CustAddr[7] }

    { 3   ;1   ;Column  ;CustomerAddress8    ;
               SourceExpr=CustAddr[8] }

    { 192 ;1   ;Column  ;CustomerPostalBarCode;
               SourceExpr=FormatAddr.PostalBarCode(1) }

    { 108 ;1   ;Column  ;YourReference       ;
               SourceExpr="Your Reference" }

    { 112 ;1   ;Column  ;YourReference_Lbl   ;
               SourceExpr=FIELDCAPTION("Your Reference") }

    { 40  ;1   ;Column  ;ShipmentMethodDescription;
               SourceExpr=ShipmentMethod.Description }

    { 105 ;1   ;Column  ;ShipmentMethodDescription_Lbl;
               SourceExpr=ShptMethodDescLbl }

    { 195 ;1   ;Column  ;ShipmentDate        ;
               SourceExpr=FORMAT("Shipment Date",0,4) }

    { 196 ;1   ;Column  ;ShipmentDate_Lbl    ;
               SourceExpr=FIELDCAPTION("Shipment Date") }

    { 103 ;1   ;Column  ;Shipment_Lbl        ;
               SourceExpr=ShipmentLbl }

    { 35  ;1   ;Column  ;ShowShippingAddress ;
               SourceExpr=ShowShippingAddr }

    { 89  ;1   ;Column  ;ShipToAddress_Lbl   ;
               SourceExpr=ShiptoAddrLbl }

    { 93  ;1   ;Column  ;ShipToAddress1      ;
               SourceExpr=ShipToAddr[1] }

    { 91  ;1   ;Column  ;ShipToAddress2      ;
               SourceExpr=ShipToAddr[2] }

    { 83  ;1   ;Column  ;ShipToAddress3      ;
               SourceExpr=ShipToAddr[3] }

    { 82  ;1   ;Column  ;ShipToAddress4      ;
               SourceExpr=ShipToAddr[4] }

    { 78  ;1   ;Column  ;ShipToAddress5      ;
               SourceExpr=ShipToAddr[5] }

    { 52  ;1   ;Column  ;ShipToAddress6      ;
               SourceExpr=ShipToAddr[6] }

    { 53  ;1   ;Column  ;ShipToAddress7      ;
               SourceExpr=ShipToAddr[7] }

    { 39  ;1   ;Column  ;ShipToAddress8      ;
               SourceExpr=ShipToAddr[8] }

    { 54  ;1   ;Column  ;PaymentTermsDescription;
               SourceExpr=PaymentTerms.Description }

    { 190 ;1   ;Column  ;PaymentTermsDescription_Lbl;
               SourceExpr=PaymentTermsDescLbl }

    { 188 ;1   ;Column  ;PaymentMethodDescription;
               SourceExpr=PaymentMethod.Description }

    { 70  ;1   ;Column  ;PaymentMethodDescription_Lbl;
               SourceExpr=PaymentMethodDescLbl }

    { 98  ;1   ;Column  ;DocumentCopyText    ;
               SourceExpr=STRSUBSTNO(DocumentCaption,CopyText) }

    { 29  ;1   ;Column  ;BilltoCustumerNo    ;
               SourceExpr="Bill-to Customer No." }

    { 26  ;1   ;Column  ;BilltoCustomerNo_Lbl;
               SourceExpr=FIELDCAPTION("Bill-to Customer No.") }

    { 51  ;1   ;Column  ;DocumentDate        ;
               SourceExpr=FORMAT("Document Date",0,4) }

    { 17  ;1   ;Column  ;DocumentDate_Lbl    ;
               SourceExpr=FIELDCAPTION("Document Date") }

    { 28  ;1   ;Column  ;DueDate             ;
               SourceExpr=FORMAT("Due Date",0,4) }

    { 140 ;1   ;Column  ;DueDate_Lbl         ;
               SourceExpr=FIELDCAPTION("Due Date") }

    { 50  ;1   ;Column  ;DocumentNo          ;
               SourceExpr="No." }

    { 111 ;1   ;Column  ;DocumentNo_Lbl      ;
               SourceExpr=InvNoLbl }

    { 32  ;1   ;Column  ;OrderNo             ;
               SourceExpr="Order No." }

    { 46  ;1   ;Column  ;OrderNo_Lbl         ;
               SourceExpr=FIELDCAPTION("Order No.") }

    { 84  ;1   ;Column  ;PricesIncludingVAT  ;
               SourceExpr="Prices Including VAT" }

    { 120 ;1   ;Column  ;PricesIncludingVAT_Lbl;
               SourceExpr=FIELDCAPTION("Prices Including VAT") }

    { 25  ;1   ;Column  ;PricesIncludingVATYesNo;
               SourceExpr=FORMAT("Prices Including VAT") }

    { 37  ;1   ;Column  ;SalesPerson_Lbl     ;
               SourceExpr=SalespersonLbl }

    { 34  ;1   ;Column  ;SalesPersonBlank_Lbl;
               SourceExpr=SalesPersonText }

    { 33  ;1   ;Column  ;SalesPersonName     ;
               SourceExpr=SalespersonPurchaser.Name }

    { 48  ;1   ;Column  ;SelltoCustomerNo    ;
               SourceExpr="Sell-to Customer No." }

    { 121 ;1   ;Column  ;SelltoCustomerNo_Lbl;
               SourceExpr=FIELDCAPTION("Sell-to Customer No.") }

    { 30  ;1   ;Column  ;VATRegistrationNo   ;
               SourceExpr=GetCustomerVATRegistrationNumber }

    { 1   ;1   ;Column  ;VATRegistrationNo_Lbl;
               SourceExpr=GetCustomerVATRegistrationNumberLbl }

    { 175 ;1   ;Column  ;GlobalLocationNumber;
               SourceExpr=GetCustomerGlobalLocationNumber }

    { 176 ;1   ;Column  ;GlobalLocationNumber_Lbl;
               SourceExpr=GetCustomerGlobalLocationNumberLbl }

    { 177 ;1   ;Column  ;PaymentReference    ;
               SourceExpr=GetPaymentReference }

    { 240 ;1   ;Column  ;From_Lbl            ;
               SourceExpr=FromLbl }

    { 241 ;1   ;Column  ;BilledTo_Lbl        ;
               SourceExpr=BilledToLbl }

    { 242 ;1   ;Column  ;ChecksPayable_Lbl   ;
               SourceExpr=ChecksPayableText }

    { 180 ;1   ;Column  ;PaymentReference_Lbl;
               SourceExpr=GetPaymentReferenceLbl }

    { 184 ;1   ;Column  ;LegalEntityType     ;
               SourceExpr=Cust.GetLegalEntityType }

    { 185 ;1   ;Column  ;LegalEntityType_Lbl ;
               SourceExpr=Cust.GetLegalEntityTypeLbl }

    { 31  ;1   ;Column  ;Copy_Lbl            ;
               SourceExpr=CopyLbl }

    { 36  ;1   ;Column  ;EMail_Header_Lbl    ;
               SourceExpr=EMailLbl }

    { 43  ;1   ;Column  ;HomePage_Header_Lbl ;
               SourceExpr=HomePageLbl }

    { 44  ;1   ;Column  ;InvoiceDiscountBaseAmount_Lbl;
               SourceExpr=InvDiscBaseAmtLbl }

    { 45  ;1   ;Column  ;InvoiceDiscountAmount_Lbl;
               SourceExpr=InvDiscountAmtLbl }

    { 47  ;1   ;Column  ;LineAmountAfterInvoiceDiscount_Lbl;
               SourceExpr=LineAmtAfterInvDiscLbl }

    { 55  ;1   ;Column  ;LocalCurrency_Lbl   ;
               SourceExpr=LocalCurrencyLbl }

    { 153 ;1   ;Column  ;ExchangeRateAsText  ;
               SourceExpr=ExchangeRateText }

    { 59  ;1   ;Column  ;Page_Lbl            ;
               SourceExpr=PageLbl }

    { 100 ;1   ;Column  ;SalesInvoiceLineDiscount_Lbl;
               SourceExpr=SalesInvLineDiscLbl }

    { 244 ;1   ;Column  ;Questions_Lbl       ;
               SourceExpr=QuestionsLbl }

    { 245 ;1   ;Column  ;Contact_Lbl         ;
               SourceExpr=CompanyInfo.GetContactUsText }

    { 102 ;1   ;Column  ;DocumentTitle_Lbl   ;
               SourceExpr=SalesInvoiceLbl }

    { 218 ;1   ;Column  ;YourDocumentTitle_Lbl;
               SourceExpr=YourSalesInvoiceLbl }

    { 243 ;1   ;Column  ;Thanks_Lbl          ;
               SourceExpr=ThanksLbl }

    { 228 ;1   ;Column  ;ShowWorkDescription ;
               SourceExpr=ShowWorkDescription }

    { 229 ;1   ;Column  ;RemainingAmount     ;
               SourceExpr=RemainingAmount }

    { 230 ;1   ;Column  ;RemainingAmountText ;
               SourceExpr=RemainingAmountTxt }

    { 109 ;1   ;Column  ;Subtotal_Lbl        ;
               SourceExpr=SubtotalLbl }

    { 110 ;1   ;Column  ;Total_Lbl           ;
               SourceExpr=TotalLbl }

    { 113 ;1   ;Column  ;VATAmount_Lbl       ;
               SourceExpr=VATAmtLbl }

    { 115 ;1   ;Column  ;VATBase_Lbl         ;
               SourceExpr=VATBaseLbl }

    { 114 ;1   ;Column  ;VATAmountSpecification_Lbl;
               SourceExpr=VATAmtSpecificationLbl }

    { 116 ;1   ;Column  ;VATClauses_Lbl      ;
               SourceExpr=VATClausesLbl }

    { 117 ;1   ;Column  ;VATIdentifier_Lbl   ;
               SourceExpr=VATIdentifierLbl }

    { 118 ;1   ;Column  ;VATPercentage_Lbl   ;
               SourceExpr=VATPercentageLbl }

    { 161 ;1   ;Column  ;VATClause_Lbl       ;
               SourceExpr=VATClause.TABLECAPTION }

    { 214 ;1   ;Column  ;PackageTrackingNo   ;
               SourceExpr="Package Tracking No." }

    { 215 ;1   ;Column  ;PackageTrackingNo_Lbl;
               SourceExpr=FIELDCAPTION("Package Tracking No.") }

    { 216 ;1   ;Column  ;ShippingAgentCode   ;
               SourceExpr="Shipping Agent Code" }

    { 217 ;1   ;Column  ;ShippingAgentCode_Lbl;
               SourceExpr=FIELDCAPTION("Shipping Agent Code") }

    { 1570;1   ;DataItem;Line                ;
               DataItemTable=Table113;
               DataItemTableView=SORTING(Document No.,Line No.);
               OnPreDataItem=BEGIN
                               VATAmountLine.DELETEALL;
                               VATClauseLine.DELETEALL;
                               ShipmentLine.RESET;
                               ShipmentLine.DELETEALL;
                               MoreLines := FIND('+');
                               WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                 MoreLines := NEXT(-1) <> 0;
                               IF NOT MoreLines THEN
                                 CurrReport.BREAK;
                               SETRANGE("Line No.",0,"Line No.");
                               CurrReport.CREATETOTALS("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount");
                               TransHeaderAmount := 0;
                               PrevLineAmount := 0;
                               FirstLineHasBeenOutput := FALSE;
                             END;

               OnAfterGetRecord=VAR
                                  PermissionManager@1000 : Codeunit 9002;
                                BEGIN
                                  InitializeShipmentLine;
                                  IF Type = Type::"G/L Account" THEN
                                    "No." := '';

                                  IF "Line Discount %" = 0 THEN
                                    LineDiscountPctText := ''
                                  ELSE
                                    LineDiscountPctText := STRSUBSTNO('%1%',-ROUND("Line Discount %",0.1));

                                  VATAmountLine.INIT;
                                  VATAmountLine."VAT Identifier" := "VAT Identifier";
                                  VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                  VATAmountLine."Tax Group Code" := "Tax Group Code";
                                  VATAmountLine."VAT %" := "VAT %";
                                  VATAmountLine."VAT Base" := Amount;
                                  VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                                  VATAmountLine."Line Amount" := "Line Amount";
                                  IF "Allow Invoice Disc." THEN
                                    VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                  VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                                  VATAmountLine."VAT Clause Code" := "VAT Clause Code";
                                  IF ("VAT %" <> 0) OR ("VAT Clause Code" <> '') OR (Amount <> "Amount Including VAT") THEN
                                    VATAmountLine.InsertLine;

                                  TransHeaderAmount += PrevLineAmount;
                                  PrevLineAmount := "Line Amount";
                                  TotalSubTotal += "Line Amount";
                                  TotalInvDiscAmount -= "Inv. Discount Amount";
                                  TotalAmount += Amount;
                                  TotalAmountVAT += "Amount Including VAT" - Amount;
                                  TotalAmountInclVAT += "Amount Including VAT";
                                  TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");

                                  IF FirstLineHasBeenOutput THEN
                                    CLEAR(CompanyInfo.Picture);
                                  FirstLineHasBeenOutput := TRUE;

                                  IF ("Job No." <> '') AND (NOT PermissionManager.SoftwareAsAService) THEN
                                    JobNo := ''
                                  ELSE
                                    JobNo := "Job No.";
                                  IF ("Job Task No." <> '') AND (NOT PermissionManager.SoftwareAsAService) THEN
                                    JobTaskNo := ''
                                  ELSE
                                    JobTaskNo := "Job Task No.";

                                  IF JobTaskNo <> '' THEN BEGIN
                                    JobTaskNoLbl := JobTaskNoLbl2;
                                    JobTaskDescription := GetJobTaskDescription(JobNo,JobTaskNo);
                                  END ELSE BEGIN
                                    JobTaskDescription := '';
                                    JobTaskNoLbl := '';
                                  END;

                                  IF JobNo <> '' THEN
                                    JobNoLbl := JobNoLbl2
                                  ELSE
                                    JobNoLbl := '';

                                  FormatDocument.SetSalesInvoiceLine(Line,FormattedQuantity,FormattedUnitPrice,FormattedVATPct,FormattedLineAmount);
                                END;

               DataItemLinkReference=Header;
               DataItemLink=Document No.=FIELD(No.) }

    { 85  ;2   ;Column  ;LineNo_Line         ;
               SourceExpr="Line No." }

    { 58  ;2   ;Column  ;AmountExcludingVAT_Line;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 123 ;2   ;Column  ;AmountExcludingVAT_Line_Lbl;
               SourceExpr=FIELDCAPTION(Amount) }

    { 41  ;2   ;Column  ;AmountIncludingVAT_Line;
               SourceExpr="Amount Including VAT";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 97  ;2   ;Column  ;AmountIncludingVAT_Line_Lbl;
               SourceExpr=FIELDCAPTION("Amount Including VAT");
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 74  ;2   ;Column  ;Description_Line    ;
               SourceExpr=Description }

    { 124 ;2   ;Column  ;Description_Line_Lbl;
               SourceExpr=FIELDCAPTION(Description) }

    { 57  ;2   ;Column  ;LineDiscountPercent_Line;
               SourceExpr="Line Discount %" }

    { 92  ;2   ;Column  ;LineDiscountPercentText_Line;
               SourceExpr=LineDiscountPctText }

    { 56  ;2   ;Column  ;LineAmount_Line     ;
               SourceExpr=FormattedLineAmount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 125 ;2   ;Column  ;LineAmount_Line_Lbl ;
               SourceExpr=FIELDCAPTION("Line Amount") }

    { 64  ;2   ;Column  ;ItemNo_Line         ;
               SourceExpr="No." }

    { 126 ;2   ;Column  ;ItemNo_Line_Lbl     ;
               SourceExpr=FIELDCAPTION("No.") }

    { 167 ;2   ;Column  ;ShipmentDate_Line   ;
               SourceExpr=FORMAT("Shipment Date") }

    { 69  ;2   ;Column  ;ShipmentDate_Line_Lbl;
               SourceExpr=PostedShipmentDateLbl }

    { 66  ;2   ;Column  ;Quantity_Line       ;
               SourceExpr=FormattedQuantity }

    { 127 ;2   ;Column  ;Quantity_Line_Lbl   ;
               SourceExpr=FIELDCAPTION(Quantity) }

    { 73  ;2   ;Column  ;Type_Line           ;
               SourceExpr=FORMAT(Type) }

    { 88  ;2   ;Column  ;UnitPrice           ;
               SourceExpr=FormattedUnitPrice;
               AutoFormatType=2;
               AutoFormatExpr=GetCurrencyCode }

    { 128 ;2   ;Column  ;UnitPrice_Lbl       ;
               SourceExpr=FIELDCAPTION("Unit Price") }

    { 67  ;2   ;Column  ;UnitOfMeasure       ;
               SourceExpr="Unit of Measure" }

    { 129 ;2   ;Column  ;UnitOfMeasure_Lbl   ;
               SourceExpr=FIELDCAPTION("Unit of Measure") }

    { 101 ;2   ;Column  ;VATIdentifier_Line  ;
               SourceExpr="VAT Identifier" }

    { 130 ;2   ;Column  ;VATIdentifier_Line_Lbl;
               SourceExpr=FIELDCAPTION("VAT Identifier") }

    { 164 ;2   ;Column  ;VATPct_Line         ;
               SourceExpr=FormattedVATPct }

    { 165 ;2   ;Column  ;VATPct_Line_Lbl     ;
               SourceExpr=FIELDCAPTION("VAT %") }

    { 86  ;2   ;Column  ;TransHeaderAmount   ;
               SourceExpr=TransHeaderAmount;
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 221 ;2   ;Column  ;JobTaskNo_Lbl       ;
               SourceExpr=JobTaskNoLbl }

    { 222 ;2   ;Column  ;JobTaskNo           ;
               SourceExpr=JobTaskNo }

    { 223 ;2   ;Column  ;JobTaskDescription  ;
               SourceExpr=JobTaskDescription }

    { 224 ;2   ;Column  ;JobTaskDesc_Lbl     ;
               SourceExpr=JobTaskDescLbl }

    { 219 ;2   ;Column  ;JobNo_Lbl           ;
               SourceExpr=JobNoLbl }

    { 220 ;2   ;Column  ;JobNo               ;
               SourceExpr=JobNo }

    { 231 ;2   ;Column  ;Unit_Lbl            ;
               SourceExpr=UnitLbl }

    { 235 ;2   ;Column  ;Qty_Lbl             ;
               SourceExpr=QtyLbl }

    { 236 ;2   ;Column  ;Price_Lbl           ;
               SourceExpr=PriceLbl }

    { 237 ;2   ;Column  ;PricePer_Lbl        ;
               SourceExpr=PricePerLbl }

    { 1484;2   ;DataItem;ShipmentLine        ;
               DataItemTable=Table7190;
               DataItemTableView=SORTING(Document No.,Line No.,Entry No.);
               OnPreDataItem=BEGIN
                               SETRANGE("Line No.",Line."Line No.");
                             END;

               Temporary=Yes }

    { 194 ;3   ;Column  ;DocumentNo_ShipmentLine;
               SourceExpr="Document No." }

    { 144 ;3   ;Column  ;PostingDate_ShipmentLine;
               SourceExpr="Posting Date" }

    { 131 ;3   ;Column  ;PostingDate_ShipmentLine_Lbl;
               SourceExpr=FIELDCAPTION("Posting Date") }

    { 146 ;3   ;Column  ;Quantity_ShipmentLine;
               DecimalPlaces=0:5;
               SourceExpr=Quantity }

    { 132 ;3   ;Column  ;Quantity_ShipmentLine_Lbl;
               SourceExpr=FIELDCAPTION(Quantity) }

    { 9462;2   ;DataItem;AssemblyLine        ;
               DataItemTable=Table911;
               DataItemTableView=SORTING(Document No.,Line No.);
               OnPreDataItem=VAR
                               ValueEntry@1000 : Record 5802;
                             BEGIN
                               CLEAR(AssemblyLine);
                               IF NOT DisplayAssemblyInformation THEN
                                 CurrReport.BREAK;
                               GetAssemblyLinesForDocument(
                                 AssemblyLine,ValueEntry."Document Type"::"Sales Invoice",Line."Document No.",Line."Line No.");
                             END;

               Temporary=Yes }

    { 179 ;3   ;Column  ;LineNo_AssemblyLine ;
               SourceExpr="No." }

    { 60  ;3   ;Column  ;Description_AssemblyLine;
               SourceExpr=Description }

    { 183 ;3   ;Column  ;Quantity_AssemblyLine;
               DecimalPlaces=0:5;
               SourceExpr=Quantity }

    { 61  ;3   ;Column  ;UnitOfMeasure_AssemblyLine;
               DecimalPlaces=0:5;
               SourceExpr=GetUOMText("Unit of Measure Code") }

    { 178 ;3   ;Column  ;VariantCode_AssemblyLine;
               DecimalPlaces=0:5;
               SourceExpr="Variant Code" }

    { 227 ;1   ;DataItem;WorkDescriptionLines;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..99999));
               OnPreDataItem=BEGIN
                               IF NOT ShowWorkDescription THEN
                                 CurrReport.BREAK;
                               TempBlobWorkDescription.Blob := Header."Work Description";
                             END;

               OnAfterGetRecord=BEGIN
                                  IF NOT TempBlobWorkDescription.MoreTextLines THEN
                                    CurrReport.BREAK;
                                  WorkDescriptionLine := TempBlobWorkDescription.ReadTextLine;
                                END;

               OnPostDataItem=BEGIN
                                CLEAR(TempBlobWorkDescription);
                              END;
                               }

    { 226 ;2   ;Column  ;WorkDescriptionLineNumber;
               SourceExpr=Number }

    { 225 ;2   ;Column  ;WorkDescriptionLine ;
               SourceExpr=WorkDescriptionLine }

    { 6558;1   ;DataItem;VATAmountLine       ;
               DataItemTable=Table290;
               DataItemTableView=SORTING(VAT Identifier,VAT Calculation Type,Tax Group Code,Use Tax,Positive);
               OnPreDataItem=BEGIN
                               CurrReport.CREATETOTALS(
                                 "Line Amount","Inv. Disc. Base Amount",
                                 "Invoice Discount Amount","VAT Base","VAT Amount",
                                 VATBaseLCY,VATAmountLCY);

                               TotalVATBaseLCY := 0;
                               TotalVATAmountLCY := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  VATBaseLCY :=
                                    GetBaseLCY(
                                      Header."Posting Date",Header."Currency Code",
                                      Header."Currency Factor");
                                  VATAmountLCY :=
                                    GetAmountLCY(
                                      Header."Posting Date",Header."Currency Code",
                                      Header."Currency Factor");

                                  TotalVATBaseLCY += VATBaseLCY;
                                  TotalVATAmountLCY += VATAmountLCY;

                                  IF "VAT Clause Code" <> '' THEN BEGIN
                                    VATClauseLine := VATAmountLine;
                                    IF VATClauseLine.INSERT THEN;
                                  END;
                                END;

               Temporary=Yes }

    { 80  ;2   ;Column  ;InvoiceDiscountAmount_VATAmountLine;
               SourceExpr="Invoice Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 133 ;2   ;Column  ;InvoiceDiscountAmount_VATAmountLine_Lbl;
               SourceExpr=FIELDCAPTION("Invoice Discount Amount") }

    { 77  ;2   ;Column  ;InvoiceDiscountBaseAmount_VATAmountLine;
               SourceExpr="Inv. Disc. Base Amount";
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 134 ;2   ;Column  ;InvoiceDiscountBaseAmount_VATAmountLine_Lbl;
               SourceExpr=FIELDCAPTION("Inv. Disc. Base Amount") }

    { 76  ;2   ;Column  ;LineAmount_VatAmountLine;
               SourceExpr="Line Amount";
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 135 ;2   ;Column  ;LineAmount_VatAmountLine_Lbl;
               SourceExpr=FIELDCAPTION("Line Amount") }

    { 75  ;2   ;Column  ;VATAmount_VatAmountLine;
               SourceExpr="VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 163 ;2   ;Column  ;VATAmount_VatAmountLine_Lbl;
               SourceExpr=FIELDCAPTION("VAT Amount") }

    { 122 ;2   ;Column  ;VATAmountLCY_VATAmountLine;
               SourceExpr=VATAmountLCY }

    { 136 ;2   ;Column  ;VATAmountLCY_VATAmountLine_Lbl;
               SourceExpr=VATAmountLCYLbl }

    { 104 ;2   ;Column  ;VATBase_VatAmountLine;
               SourceExpr="VAT Base";
               AutoFormatType=1;
               AutoFormatExpr=Line.GetCurrencyCode }

    { 160 ;2   ;Column  ;VATBase_VatAmountLine_Lbl;
               SourceExpr=FIELDCAPTION("VAT Base") }

    { 38  ;2   ;Column  ;VATBaseLCY_VATAmountLine;
               SourceExpr=VATBaseLCY }

    { 137 ;2   ;Column  ;VATBaseLCY_VATAmountLine_Lbl;
               SourceExpr=VATBaseLCYLbl }

    { 90  ;2   ;Column  ;VATIdentifier_VatAmountLine;
               SourceExpr="VAT Identifier" }

    { 138 ;2   ;Column  ;VATIdentifier_VatAmountLine_Lbl;
               SourceExpr=FIELDCAPTION("VAT Identifier") }

    { 107 ;2   ;Column  ;VATPct_VatAmountLine;
               DecimalPlaces=0:5;
               SourceExpr="VAT %" }

    { 139 ;2   ;Column  ;VATPct_VatAmountLine_Lbl;
               SourceExpr=FIELDCAPTION("VAT %") }

    { 162 ;2   ;Column  ;NoOfVATIdentifiers  ;
               SourceExpr=COUNT }

    { 151 ;1   ;DataItem;VATClauseLine       ;
               DataItemTable=Table290;
               OnPreDataItem=BEGIN
                               IF COUNT = 0 THEN
                                 VATClausesText := ''
                               ELSE
                                 VATClausesText := VATClausesLbl;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF "VAT Clause Code" = '' THEN
                                    CurrReport.SKIP;
                                  IF NOT VATClause.GET("VAT Clause Code") THEN
                                    CurrReport.SKIP;
                                  VATClause.TranslateDescription(Header."Language Code");
                                END;

               Temporary=Yes }

    { 232 ;2   ;Column  ;VATClausesHeader    ;
               SourceExpr=VATClausesText }

    { 158 ;2   ;Column  ;VATIdentifier_VATClauseLine;
               SourceExpr="VAT Identifier" }

    { 154 ;2   ;Column  ;Code_VATClauseLine  ;
               SourceExpr=VATClause.Code }

    { 159 ;2   ;Column  ;Code_VATClauseLine_Lbl;
               SourceExpr=VATClause.FIELDCAPTION(Code) }

    { 155 ;2   ;Column  ;Description_VATClauseLine;
               SourceExpr=VATClause.Description }

    { 156 ;2   ;Column  ;Description2_VATClauseLine;
               SourceExpr=VATClause."Description 2" }

    { 157 ;2   ;Column  ;VATAmount_VATClauseLine;
               SourceExpr="VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 150 ;2   ;Column  ;NoOfVATClauses      ;
               SourceExpr=COUNT }

    { 141 ;1   ;DataItem;ReportTotalsLine    ;
               DataItemTable=Table1150;
               DataItemTableView=SORTING(Line No.);
               OnPreDataItem=BEGIN
                               CreateReportTotalLines;
                             END;

               Temporary=Yes }

    { 142 ;2   ;Column  ;Description_ReportTotalsLine;
               SourceExpr=Description }

    { 143 ;2   ;Column  ;Amount_ReportTotalsLine;
               SourceExpr=Amount }

    { 149 ;2   ;Column  ;AmountFormatted_ReportTotalsLine;
               SourceExpr="Amount Formatted" }

    { 145 ;2   ;Column  ;FontBold_ReportTotalsLine;
               SourceExpr="Font Bold" }

    { 148 ;2   ;Column  ;FontUnderline_ReportTotalsLine;
               SourceExpr="Font Underline" }

    { 300 ;1   ;DataItem;LineFee             ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 ORDER(Ascending)
                                 WHERE(Number=FILTER(1..));
               OnAfterGetRecord=BEGIN
                                  IF NOT DisplayAdditionalFeeNote THEN
                                    CurrReport.BREAK;

                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempLineFeeNoteOnReportHist.FINDSET THEN
                                      CurrReport.BREAK
                                  END ELSE
                                    IF TempLineFeeNoteOnReportHist.NEXT = 0 THEN
                                      CurrReport.BREAK;
                                END;
                                 }

    { 301 ;2   ;Column  ;LineFeeCaptionText  ;
               SourceExpr=TempLineFeeNoteOnReportHist.ReportText }

    { 197 ;1   ;DataItem;PaymentReportingArgument;
               DataItemTable=Table1062;
               DataItemTableView=SORTING(Key);
               Temporary=Yes }

    { 198 ;2   ;Column  ;PaymentServiceLogo  ;
               SourceExpr=Logo }

    { 199 ;2   ;Column  ;PaymentServiceLogo_UrlText;
               SourceExpr="URL Caption" }

    { 200 ;2   ;Column  ;PaymentServiceLogo_Url;
               SourceExpr=GetTargetURL }

    { 202 ;2   ;Column  ;PaymentServiceText_UrlText;
               SourceExpr="URL Caption" }

    { 201 ;2   ;Column  ;PaymentServiceText_Url;
               SourceExpr=GetTargetURL }

    { 203 ;1   ;DataItem;LeftHeader          ;
               DataItemTable=Table823;
               DataItemTableView=SORTING(ID);
               Temporary=Yes }

    { 204 ;2   ;Column  ;LeftHeaderName      ;
               SourceExpr=Name }

    { 205 ;2   ;Column  ;LeftHeaderValue     ;
               SourceExpr=Value }

    { 206 ;1   ;DataItem;RightHeader         ;
               DataItemTable=Table823;
               DataItemTableView=SORTING(ID);
               Temporary=Yes }

    { 207 ;2   ;Column  ;RightHeaderName     ;
               SourceExpr=Name }

    { 208 ;2   ;Column  ;RightHeaderValue    ;
               SourceExpr=Value }

    { 209 ;1   ;DataItem;LetterText          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               PmtDiscText := '';
                               IF Header."Payment Discount %" <> 0 THEN
                                 PmtDiscText := STRSUBSTNO(PmtDiscTxt,Header."Pmt. Discount Date",Header."Payment Discount %");
                             END;
                              }

    { 210 ;2   ;Column  ;GreetingText        ;
               SourceExpr=GreetingLbl }

    { 211 ;2   ;Column  ;BodyText            ;
               SourceExpr=BodyLbl }

    { 212 ;2   ;Column  ;ClosingText         ;
               SourceExpr=ClosingLbl }

    { 213 ;2   ;Column  ;PmtDiscText         ;
               SourceExpr=PmtDiscText }

    { 99  ;1   ;DataItem;Totals              ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF Header."Prices Including VAT" THEN BEGIN
                                 TotalAmountExclInclVATTextValue := TotalExclVATText;
                                 TotalAmountExclInclVATValue := TotalAmount;
                               END ELSE BEGIN
                                 TotalAmountExclInclVATTextValue := TotalInclVATText;
                                 TotalAmountExclInclVATValue := TotalAmountInclVAT;
                               END;
                             END;
                              }

    { 96  ;2   ;Column  ;TotalNetAmount      ;
               SourceExpr=TotalAmount;
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 189 ;2   ;Column  ;TotalVATBaseLCY     ;
               SourceExpr=TotalVATBaseLCY }

    { 95  ;2   ;Column  ;TotalAmountIncludingVAT;
               SourceExpr=TotalAmountInclVAT;
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 87  ;2   ;Column  ;TotalVATAmount      ;
               SourceExpr=TotalAmountVAT;
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 191 ;2   ;Column  ;TotalVATAmountLCY   ;
               SourceExpr=TotalVATAmountLCY }

    { 94  ;2   ;Column  ;TotalInvoiceDiscountAmount;
               SourceExpr=TotalInvDiscAmount;
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 193 ;2   ;Column  ;TotalPaymentDiscountOnVAT;
               SourceExpr=TotalPaymentDiscOnVAT }

    { 72  ;2   ;Column  ;TotalVATAmountText  ;
               SourceExpr=VATAmountLine.VATAmountText }

    { 79  ;2   ;Column  ;TotalExcludingVATText;
               SourceExpr=TotalExclVATText }

    { 71  ;2   ;Column  ;TotalIncludingVATText;
               SourceExpr=TotalInclVATText }

    { 62  ;2   ;Column  ;TotalSubTotal       ;
               SourceExpr=TotalSubTotal;
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

    { 166 ;2   ;Column  ;TotalSubTotalMinusInvoiceDiscount;
               SourceExpr=TotalSubTotal + TotalInvDiscAmount }

    { 68  ;2   ;Column  ;TotalText           ;
               SourceExpr=TotalText }

    { 233 ;2   ;Column  ;TotalAmountExclInclVAT;
               SourceExpr=TotalAmountExclInclVATValue }

    { 234 ;2   ;Column  ;TotalAmountExclInclVATText;
               SourceExpr=TotalAmountExclInclVATTextValue }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnInit=BEGIN
               LogInteractionEnable := TRUE;
             END;

      OnOpenPage=BEGIN
                   InitLogInteraction;
                   LogInteractionEnable := LogInteraction;
                 END;

    }
    CONTROLS
    {
      { 5   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 6   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 4   ;2   ;Field     ;
                  Name=LogInteraction;
                  CaptionML=[DAN=Logf›r interaktion;
                             ENU=Log Interaction];
                  ToolTipML=[DAN=Angiver, at interaktioner med kontakten er logf›rt.;
                             ENU=Specifies that interactions with the contact are logged.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=LogInteraction;
                  Enabled=LogInteractionEnable }

      { 3   ;2   ;Field     ;
                  Name=DisplayAsmInformation;
                  CaptionML=[DAN=Vis montagekomponenter;
                             ENU=Show Assembly Components];
                  ToolTipML=[DAN=Angiver, om rapporten skal omfatte oplysninger om komponenter, der blev brugt i sammenk‘dede montageordrer, hvori den eller de solgte varer indgik.;
                             ENU=Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.];
                  ApplicationArea=#Assembly;
                  SourceExpr=DisplayAssemblyInformation }

      { 1   ;2   ;Field     ;
                  Name=DisplayShipmentInformation;
                  CaptionML=[DAN=Vis leverancer;
                             ENU=Show Shipments];
                  ToolTipML=[DAN=Angiver, at leverancer vises i dokumentet.;
                             ENU=Specifies that shipments are shown on the document.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DisplayShipmentInformation }

      { 303 ;2   ;Field     ;
                  Name=DisplayAdditionalFeeNote;
                  CaptionML=[DAN=Vis bem‘rkning om opkr‘vningsgebyr;
                             ENU=Show Additional Fee Note];
                  ToolTipML=[DAN=Angiver, om du vil have vist noter om yderligere gebyrer i dokumentet.;
                             ENU=Specifies if you want notes about additional fees to be shown on the document.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DisplayAdditionalFeeNote }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      SalesInvoiceNoLbl@1004 : TextConst 'DAN=Salg - faktura %1;ENU=Sales - Invoice %1';
      SalespersonLbl@1003 : TextConst 'DAN=S‘lger;ENU=Salesperson';
      CompanyInfoBankAccNoLbl@1045 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      CompanyInfoBankNameLbl@1046 : TextConst 'DAN=Bank;ENU=Bank';
      CompanyInfoGiroNoLbl@1049 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      CompanyInfoPhoneNoLbl@1050 : TextConst 'DAN=Telefon;ENU=Phone No.';
      CopyLbl@1059 : TextConst 'DAN=Kopi‚r;ENU=Copy';
      EMailLbl@1068 : TextConst 'DAN=Mail;ENU=Email';
      HomePageLbl@1070 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      InvDiscBaseAmtLbl@1071 : TextConst 'DAN=Grundbel›b for fakturarabat;ENU=Invoice Discount Base Amount';
      InvDiscountAmtLbl@1072 : TextConst 'DAN=Fakturarabat;ENU=Invoice Discount';
      InvNoLbl@1073 : TextConst 'DAN=Fakturanr.;ENU=Invoice No.';
      LineAmtAfterInvDiscLbl@1074 : TextConst 'DAN=Moms ved kontantrabat;ENU=Payment Discount on VAT';
      LocalCurrencyLbl@1076 : TextConst 'DAN=Lokal valuta;ENU=Local Currency';
      PageLbl@1077 : TextConst 'DAN=Side;ENU=Page';
      PaymentTermsDescLbl@1078 : TextConst 'DAN=Betalingsbetingelser;ENU=Payment Terms';
      PaymentMethodDescLbl@1040 : TextConst 'DAN=Betalingsform;ENU=Payment Method';
      PostedShipmentDateLbl@1079 : TextConst 'DAN=Afsendelsesdato;ENU=Shipment Date';
      SalesInvLineDiscLbl@1081 : TextConst 'DAN=Rabatpct.;ENU=Discount %';
      SalesInvoiceLbl@1082 : TextConst 'DAN=Faktura;ENU=Invoice';
      YourSalesInvoiceLbl@1001 : TextConst 'DAN=Din faktura;ENU=Your Invoice';
      ShipmentLbl@1084 : TextConst 'DAN=Leverance;ENU=Shipment';
      ShiptoAddrLbl@1085 : TextConst 'DAN=Leveringsadresse;ENU=Ship-to Address';
      ShptMethodDescLbl@1086 : TextConst 'DAN=Leveringsform;ENU=Shipment Method';
      SubtotalLbl@1087 : TextConst 'DAN=Subtotal;ENU=Subtotal';
      TotalLbl@1088 : TextConst 'DAN=I alt;ENU=Total';
      VATAmtSpecificationLbl@1037 : TextConst 'DAN=Momsbel›bspecifikation;ENU=VAT Amount Specification';
      VATAmtLbl@1091 : TextConst 'DAN=Momsbel›b;ENU=VAT Amount';
      VATAmountLCYLbl@1027 : TextConst 'DAN=Momsbel›b (RV);ENU=VAT Amount (LCY)';
      VATBaseLbl@1093 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATBaseLCYLbl@1032 : TextConst 'DAN=Momsgrundlag (RV);ENU=VAT Base (LCY)';
      VATClausesLbl@1094 : TextConst 'DAN=Momsklausul;ENU=VAT Clause';
      VATIdentifierLbl@1095 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      VATPercentageLbl@1096 : TextConst 'DAN=Momspct.;ENU=VAT %';
      TempBlobWorkDescription@1090 : Record 99008535;
      GLSetup@1007 : Record 98;
      ShipmentMethod@1008 : Record 10;
      PaymentTerms@1009 : Record 3;
      PaymentMethod@1038 : Record 289;
      SalespersonPurchaser@1010 : Record 13;
      CompanyInfo@1011 : Record 79;
      SalesSetup@1048 : Record 311;
      Cust@1012 : Record 18;
      RespCenter@1016 : Record 5714;
      Language@1017 : Record 8;
      VATClause@1026 : Record 560;
      TempLineFeeNoteOnReportHist@1075 : TEMPORARY Record 1053;
      FormatAddr@1019 : Codeunit 365;
      FormatDocument@1060 : Codeunit 368;
      SegManagement@1020 : Codeunit 5051;
      JobNo@1098 : Code[20];
      JobTaskNo@1099 : Code[20];
      WorkDescriptionLine@1092 : Text;
      CustAddr@1021 : ARRAY [8] OF Text[50];
      ChecksPayableText@1120 : Text;
      ShipToAddr@1022 : ARRAY [8] OF Text[50];
      CompanyAddr@1023 : ARRAY [8] OF Text[50];
      SalesPersonText@1025 : Text[30];
      TotalText@1028 : Text[50];
      TotalExclVATText@1029 : Text[50];
      TotalInclVATText@1030 : Text[50];
      LineDiscountPctText@1005 : Text;
      PmtDiscText@1057 : Text;
      RemainingAmountTxt@1100 : Text;
      JobNoLbl@1036 : Text;
      JobTaskNoLbl@1069 : Text;
      FormattedVATPct@1111 : Text;
      FormattedUnitPrice@1110 : Text;
      FormattedQuantity@1108 : Text;
      FormattedLineAmount@1121 : Text;
      TotalAmountExclInclVATTextValue@1106 : Text;
      MoreLines@1031 : Boolean;
      ShowWorkDescription@1097 : Boolean;
      CopyText@1034 : Text[30];
      ShowShippingAddr@1035 : Boolean;
      LogInteraction@1041 : Boolean;
      SalesPrepInvoiceNoLbl@1058 : TextConst 'DAN=Salg - forudbetalingsfaktura %1;ENU=Sales - Prepayment Invoice %1';
      TotalSubTotal@1061 : Decimal;
      TotalAmount@1062 : Decimal;
      TotalAmountInclVAT@1064 : Decimal;
      TotalAmountVAT@1065 : Decimal;
      TotalInvDiscAmount@1063 : Decimal;
      TotalPaymentDiscOnVAT@1053 : Decimal;
      RemainingAmount@1101 : Decimal;
      TransHeaderAmount@1039 : Decimal;
      LogInteractionEnable@19003940 : Boolean INDATASET;
      DisplayAssemblyInformation@1067 : Boolean;
      DisplayShipmentInformation@1051 : Boolean;
      CompanyLogoPosition@1000 : Integer;
      FirstLineHasBeenOutput@1089 : Boolean;
      CalculatedExchRate@1013 : Decimal;
      ExchangeRateText@1014 : Text;
      ExchangeRateTxt@1015 : TextConst '@@@=%1 and %2 are both amounts.;DAN=Valutakurs: %1/%2;ENU=Exchange rate: %1/%2';
      VATBaseLCY@1018 : Decimal;
      VATAmountLCY@1024 : Decimal;
      TotalVATBaseLCY@1052 : Decimal;
      TotalVATAmountLCY@1047 : Decimal;
      PrevLineAmount@1033 : Decimal;
      NoFilterSetErr@1042 : TextConst 'DAN=Du skal angive et eller flere filtre for at undg† at udskrive alle dokumenter ved et uheld.;ENU=You must specify one or more filters to avoid accidently printing all documents.';
      TotalAmountExclInclVATValue@1107 : Decimal;
      DisplayAdditionalFeeNote@1080 : Boolean;
      GreetingLbl@1043 : TextConst 'DAN=Hej;ENU=Hello';
      ClosingLbl@1054 : TextConst 'DAN=Med venlig hilsen;ENU=Sincerely';
      PmtDiscTxt@1055 : TextConst '@@@="%1 Discount Due Date %2 = value of Payment Discount % ";DAN=Hvis vi modtager betalingen f›r %1, er du berettiget til en betalingsrabat p† 2 %.;ENU=If we receive the payment before %1, you are eligible for a 2% payment discount.';
      BodyLbl@1056 : TextConst 'DAN=Tak for din interesse i vores varer. Din faktura er vedh‘ftet denne meddelelse.;ENU=Thank you for your business. Your invoice is attached to this message.';
      AlreadyPaidLbl@1102 : TextConst 'DAN=Fakturaen er blevet betalt.;ENU=The invoice has been paid.';
      PartiallyPaidLbl@1103 : TextConst '@@@="%1=an amount";DAN=Fakturaen er blevet delvist betalt. Det resterende bel›b er %1;ENU=The invoice has been partially paid. The remaining amount is %1';
      FromLbl@1119 : TextConst 'DAN=Fra;ENU=From';
      BilledToLbl@1118 : TextConst 'DAN=Faktureret til;ENU=Billed to';
      ChecksPayableLbl@1117 : TextConst '@@@="%1 = company name";DAN=Udbetal checks til %1;ENU=Please make checks payable to %1';
      QuestionsLbl@1115 : TextConst 'DAN=Sp›rgsm†l?;ENU=Questions?';
      ThanksLbl@1114 : TextConst 'DAN=Tak!;ENU=Thank You!';
      JobNoLbl2@1002 : TextConst 'DAN=Sagsnr.;ENU=Job No.';
      JobTaskNoLbl2@1006 : TextConst 'DAN=Sagsopgavenr.;ENU=Job Task No.';
      JobTaskDescription@1066 : Text[50];
      JobTaskDescLbl@1083 : TextConst 'DAN=Sagsopgavebeskrivelse;ENU=Job Task Description';
      UnitLbl@1104 : TextConst 'DAN=Enhed;ENU=Unit';
      VATClausesText@1105 : Text;
      QtyLbl@1109 : TextConst '@@@=Short form of Quantity;DAN=Antal;ENU=Qty';
      PriceLbl@1112 : TextConst 'DAN=Pris;ENU=Price';
      PricePerLbl@1113 : TextConst 'DAN=Pris pr.;ENU=Price per';

    LOCAL PROCEDURE InitLogInteraction@1();
    BEGIN
      LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    END;

    LOCAL PROCEDURE InitializeShipmentLine@6() : Date;
    VAR
      SalesShipmentHeader@1000 : Record 110;
      SalesShipmentBuffer2@1001 : Record 7190;
    BEGIN
      IF Line."Shipment No." <> '' THEN
        IF SalesShipmentHeader.GET(Line."Shipment No.") THEN
          EXIT(SalesShipmentHeader."Posting Date");

      IF Line.Type = Line.Type::" " THEN
        EXIT(0D);

      ShipmentLine.GetLinesForSalesInvoiceLine(Line,Header);

      ShipmentLine.RESET;
      ShipmentLine.SETRANGE("Line No." ,Line."Line No.");
      IF ShipmentLine.FIND('-') THEN BEGIN
        SalesShipmentBuffer2 := ShipmentLine;
        IF NOT DisplayShipmentInformation THEN
          IF ShipmentLine.NEXT = 0 THEN BEGIN
            ShipmentLine.GET(
              SalesShipmentBuffer2."Document No.",SalesShipmentBuffer2."Line No.",SalesShipmentBuffer2."Entry No.");
            ShipmentLine.DELETE;
            EXIT(SalesShipmentBuffer2."Posting Date");
          END;
        ShipmentLine.CALCSUMS(Quantity);
        IF ShipmentLine.Quantity <> Line.Quantity THEN BEGIN
          ShipmentLine.DELETEALL;
          EXIT(Header."Posting Date");
        END;
      END;
      EXIT(Header."Posting Date");
    END;

    LOCAL PROCEDURE DocumentCaption@4() : Text[250];
    BEGIN
      IF Header."Prepayment Invoice" THEN
        EXIT(SalesPrepInvoiceNoLbl);
      EXIT(SalesInvoiceNoLbl);
    END;

    PROCEDURE InitializeRequest@5(NewLogInteraction@1002 : Boolean;DisplayAsmInfo@1003 : Boolean);
    BEGIN
      LogInteraction := NewLogInteraction;
      DisplayAssemblyInformation := DisplayAsmInfo;
    END;

    LOCAL PROCEDURE GetUOMText@12(UOMCode@1000 : Code[10]) : Text[10];
    VAR
      UnitOfMeasure@1001 : Record 204;
    BEGIN
      IF NOT UnitOfMeasure.GET(UOMCode) THEN
        EXIT(UOMCode);
      EXIT(UnitOfMeasure.Description);
    END;

    LOCAL PROCEDURE CreateReportTotalLines@15();
    BEGIN
      ReportTotalsLine.DELETEALL;
      IF (TotalInvDiscAmount <> 0) OR (TotalAmountVAT <> 0) THEN
        ReportTotalsLine.Add(SubtotalLbl,TotalSubTotal,TRUE,FALSE,FALSE);
      IF TotalInvDiscAmount <> 0 THEN BEGIN
        ReportTotalsLine.Add(InvDiscountAmtLbl,TotalInvDiscAmount,FALSE,FALSE,FALSE);
        IF TotalAmountVAT <> 0 THEN
          IF Header."Prices Including VAT" THEN
            ReportTotalsLine.Add(TotalInclVATText,TotalAmountInclVAT,TRUE,FALSE,FALSE)
          ELSE
            ReportTotalsLine.Add(TotalExclVATText,TotalAmount,TRUE,FALSE,FALSE);
      END;
      IF TotalAmountVAT <> 0 THEN
        ReportTotalsLine.Add(VATAmountLine.VATAmountText,TotalAmountVAT,FALSE,TRUE,FALSE);
    END;

    LOCAL PROCEDURE GetLineFeeNoteOnReportHist@1005(SalesInvoiceHeaderNo@1004 : Code[20]);
    VAR
      LineFeeNoteOnReportHist@1000 : Record 1053;
      CustLedgerEntry@1003 : Record 21;
      Customer@1001 : Record 18;
    BEGIN
      TempLineFeeNoteOnReportHist.DELETEALL;
      CustLedgerEntry.SETRANGE("Document Type",CustLedgerEntry."Document Type"::Invoice);
      CustLedgerEntry.SETRANGE("Document No.",SalesInvoiceHeaderNo);
      IF NOT CustLedgerEntry.FINDFIRST THEN
        EXIT;

      IF NOT Customer.GET(CustLedgerEntry."Customer No.") THEN
        EXIT;

      LineFeeNoteOnReportHist.SETRANGE("Cust. Ledger Entry No",CustLedgerEntry."Entry No.");
      LineFeeNoteOnReportHist.SETRANGE("Language Code",Customer."Language Code");
      IF LineFeeNoteOnReportHist.FINDSET THEN BEGIN
        REPEAT
          TempLineFeeNoteOnReportHist.INIT;
          TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
          TempLineFeeNoteOnReportHist.INSERT;
        UNTIL LineFeeNoteOnReportHist.NEXT = 0;
      END ELSE BEGIN
        LineFeeNoteOnReportHist.SETRANGE("Language Code",Language.GetUserLanguage);
        IF LineFeeNoteOnReportHist.FINDSET THEN
          REPEAT
            TempLineFeeNoteOnReportHist.INIT;
            TempLineFeeNoteOnReportHist.COPY(LineFeeNoteOnReportHist);
            TempLineFeeNoteOnReportHist.INSERT;
          UNTIL LineFeeNoteOnReportHist.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE FillLeftHeader@3();
    BEGIN
      LeftHeader.DELETEALL;

      FillNameValueTable(LeftHeader,Header.FIELDCAPTION("External Document No."),Header."External Document No.");
      FillNameValueTable(LeftHeader,Header.FIELDCAPTION("Bill-to Customer No."),Header."Bill-to Customer No.");
      FillNameValueTable(LeftHeader,Header.GetCustomerVATRegistrationNumberLbl,Header.GetCustomerVATRegistrationNumber);
      FillNameValueTable(LeftHeader,Header.GetCustomerGlobalLocationNumberLbl,Header.GetCustomerGlobalLocationNumber);
      FillNameValueTable(LeftHeader,InvNoLbl,Header."No.");
      FillNameValueTable(LeftHeader,Header.FIELDCAPTION("Order No."),Header."Order No.");
      FillNameValueTable(LeftHeader,Header.FIELDCAPTION("Document Date"),FORMAT(Header."Document Date",0,4));
      FillNameValueTable(LeftHeader,Header.FIELDCAPTION("Due Date"),FORMAT(Header."Due Date",0,4));
      FillNameValueTable(LeftHeader,PaymentTermsDescLbl,PaymentTerms.Description);
      FillNameValueTable(LeftHeader,PaymentMethodDescLbl,PaymentMethod.Description);
      FillNameValueTable(LeftHeader,Cust.GetLegalEntityTypeLbl,Cust.GetLegalEntityType);
      FillNameValueTable(LeftHeader,ShptMethodDescLbl,ShipmentMethod.Description);
    END;

    LOCAL PROCEDURE FillRightHeader@7();
    BEGIN
      RightHeader.DELETEALL;

      FillNameValueTable(RightHeader,EMailLbl,CompanyInfo."E-Mail");
      FillNameValueTable(RightHeader,HomePageLbl,CompanyInfo."Home Page");
      FillNameValueTable(RightHeader,CompanyInfoPhoneNoLbl,CompanyInfo."Phone No.");
      FillNameValueTable(RightHeader,CompanyInfo.GetRegistrationNumberLbl,CompanyInfo.GetRegistrationNumber);
      FillNameValueTable(RightHeader,CompanyInfoBankNameLbl,CompanyInfo."Bank Name");
      FillNameValueTable(RightHeader,CompanyInfoGiroNoLbl,CompanyInfo."Giro No.");
      FillNameValueTable(RightHeader,CompanyInfo.FIELDCAPTION(IBAN),CompanyInfo.IBAN);
      FillNameValueTable(RightHeader,CompanyInfo.FIELDCAPTION("SWIFT Code"),CompanyInfo."SWIFT Code");
      FillNameValueTable(RightHeader,Header.GetPaymentReferenceLbl,Header.GetPaymentReference);
    END;

    LOCAL PROCEDURE FillNameValueTable@8(VAR NameValueBuffer@1000 : Record 823;Name@1001 : Text;Value@1002 : Text);
    VAR
      KeyIndex@1003 : Integer;
    BEGIN
      IF Value <> '' THEN BEGIN
        CLEAR(NameValueBuffer);
        IF NameValueBuffer.FINDLAST THEN
          KeyIndex := NameValueBuffer.ID + 1;

        NameValueBuffer.INIT;
        NameValueBuffer.ID := KeyIndex;
        NameValueBuffer.Name := COPYSTR(Name,1,MAXSTRLEN(NameValueBuffer.Name));
        NameValueBuffer.Value := COPYSTR(Value,1,MAXSTRLEN(NameValueBuffer.Value));
        NameValueBuffer.INSERT;
      END;
    END;

    LOCAL PROCEDURE FormatAddressFields@9(VAR SalesInvoiceHeader@1000 : Record 112);
    BEGIN
      FormatAddr.GetCompanyAddr(SalesInvoiceHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
      FormatAddr.SalesInvBillTo(CustAddr,SalesInvoiceHeader);
      ShowShippingAddr := FormatAddr.SalesInvShipTo(ShipToAddr,CustAddr,SalesInvoiceHeader);
    END;

    LOCAL PROCEDURE FormatDocumentFields@10(SalesInvoiceHeader@1000 : Record 112);
    BEGIN
      WITH SalesInvoiceHeader DO BEGIN
        FormatDocument.SetTotalLabels(GetCurrencySymbol,TotalText,TotalInclVATText,TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser,"Salesperson Code",SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod,"Payment Method Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");
      END;
    END;

    LOCAL PROCEDURE GetJobTaskDescription@11(JobNo@1000 : Code[20];JobTaskNo@1001 : Code[20]) : Text[50];
    VAR
      JobTask@1002 : Record 1001;
    BEGIN
      JobTask.SETRANGE("Job No.",JobNo);
      JobTask.SETRANGE("Job Task No.",JobTaskNo);
      IF JobTask.FINDFIRST THEN
        EXIT(JobTask.Description);

      EXIT('');
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
    <?xml version="1.0" encoding="utf-8"?>
<Report xmlns="http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition" xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner">
  <AutoRefresh>0</AutoRefresh>
  <DataSources>
    <DataSource Name="DataSource">
      <ConnectionProperties>
        <DataProvider>SQL</DataProvider>
        <ConnectString />
      </ConnectionProperties>
      <rd:SecurityType>None</rd:SecurityType>
      <rd:DataSourceID>b23244e3-9790-4712-be0f-6041ac5f0e69</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="CompanyAddress1">
          <DataField>CompanyAddress1</DataField>
        </Field>
        <Field Name="CompanyAddress2">
          <DataField>CompanyAddress2</DataField>
        </Field>
        <Field Name="CompanyAddress3">
          <DataField>CompanyAddress3</DataField>
        </Field>
        <Field Name="CompanyAddress4">
          <DataField>CompanyAddress4</DataField>
        </Field>
        <Field Name="CompanyAddress5">
          <DataField>CompanyAddress5</DataField>
        </Field>
        <Field Name="CompanyAddress6">
          <DataField>CompanyAddress6</DataField>
        </Field>
        <Field Name="CompanyHomePage">
          <DataField>CompanyHomePage</DataField>
        </Field>
        <Field Name="CompanyEMail">
          <DataField>CompanyEMail</DataField>
        </Field>
        <Field Name="CompanyPicture">
          <DataField>CompanyPicture</DataField>
        </Field>
        <Field Name="CompanyPhoneNo">
          <DataField>CompanyPhoneNo</DataField>
        </Field>
        <Field Name="CompanyPhoneNo_Lbl">
          <DataField>CompanyPhoneNo_Lbl</DataField>
        </Field>
        <Field Name="CompanyGiroNo">
          <DataField>CompanyGiroNo</DataField>
        </Field>
        <Field Name="CompanyGiroNo_Lbl">
          <DataField>CompanyGiroNo_Lbl</DataField>
        </Field>
        <Field Name="CompanyBankName">
          <DataField>CompanyBankName</DataField>
        </Field>
        <Field Name="CompanyBankName_Lbl">
          <DataField>CompanyBankName_Lbl</DataField>
        </Field>
        <Field Name="CompanyBankBranchNo">
          <DataField>CompanyBankBranchNo</DataField>
        </Field>
        <Field Name="CompanyBankBranchNo_Lbl">
          <DataField>CompanyBankBranchNo_Lbl</DataField>
        </Field>
        <Field Name="CompanyBankAccountNo">
          <DataField>CompanyBankAccountNo</DataField>
        </Field>
        <Field Name="CompanyBankAccountNo_Lbl">
          <DataField>CompanyBankAccountNo_Lbl</DataField>
        </Field>
        <Field Name="CompanyIBAN">
          <DataField>CompanyIBAN</DataField>
        </Field>
        <Field Name="CompanyIBAN_Lbl">
          <DataField>CompanyIBAN_Lbl</DataField>
        </Field>
        <Field Name="CompanySWIFT">
          <DataField>CompanySWIFT</DataField>
        </Field>
        <Field Name="CompanySWIFT_Lbl">
          <DataField>CompanySWIFT_Lbl</DataField>
        </Field>
        <Field Name="CompanyLogoPosition">
          <DataField>CompanyLogoPosition</DataField>
        </Field>
        <Field Name="CompanyRegistrationNumber">
          <DataField>CompanyRegistrationNumber</DataField>
        </Field>
        <Field Name="CompanyRegistrationNumber_Lbl">
          <DataField>CompanyRegistrationNumber_Lbl</DataField>
        </Field>
        <Field Name="CompanyVATRegNo">
          <DataField>CompanyVATRegNo</DataField>
        </Field>
        <Field Name="CompanyVATRegNo_Lbl">
          <DataField>CompanyVATRegNo_Lbl</DataField>
        </Field>
        <Field Name="CompanyVATRegistrationNo">
          <DataField>CompanyVATRegistrationNo</DataField>
        </Field>
        <Field Name="CompanyVATRegistrationNo_Lbl">
          <DataField>CompanyVATRegistrationNo_Lbl</DataField>
        </Field>
        <Field Name="CompanyLegalOffice">
          <DataField>CompanyLegalOffice</DataField>
        </Field>
        <Field Name="CompanyLegalOffice_Lbl">
          <DataField>CompanyLegalOffice_Lbl</DataField>
        </Field>
        <Field Name="CompanyCustomGiro">
          <DataField>CompanyCustomGiro</DataField>
        </Field>
        <Field Name="CompanyCustomGiro_Lbl">
          <DataField>CompanyCustomGiro_Lbl</DataField>
        </Field>
        <Field Name="CompanyLegalStatement">
          <DataField>CompanyLegalStatement</DataField>
        </Field>
        <Field Name="DisplayAdditionalFeeNote">
          <DataField>DisplayAdditionalFeeNote</DataField>
        </Field>
        <Field Name="CustomerAddress1">
          <DataField>CustomerAddress1</DataField>
        </Field>
        <Field Name="CustomerAddress2">
          <DataField>CustomerAddress2</DataField>
        </Field>
        <Field Name="CustomerAddress3">
          <DataField>CustomerAddress3</DataField>
        </Field>
        <Field Name="CustomerAddress4">
          <DataField>CustomerAddress4</DataField>
        </Field>
        <Field Name="CustomerAddress5">
          <DataField>CustomerAddress5</DataField>
        </Field>
        <Field Name="CustomerAddress6">
          <DataField>CustomerAddress6</DataField>
        </Field>
        <Field Name="CustomerAddress7">
          <DataField>CustomerAddress7</DataField>
        </Field>
        <Field Name="CustomerAddress8">
          <DataField>CustomerAddress8</DataField>
        </Field>
        <Field Name="CustomerPostalBarCode">
          <DataField>CustomerPostalBarCode</DataField>
        </Field>
        <Field Name="YourReference">
          <DataField>YourReference</DataField>
        </Field>
        <Field Name="YourReference_Lbl">
          <DataField>YourReference_Lbl</DataField>
        </Field>
        <Field Name="ShipmentMethodDescription">
          <DataField>ShipmentMethodDescription</DataField>
        </Field>
        <Field Name="ShipmentMethodDescription_Lbl">
          <DataField>ShipmentMethodDescription_Lbl</DataField>
        </Field>
        <Field Name="ShipmentDate">
          <DataField>ShipmentDate</DataField>
        </Field>
        <Field Name="ShipmentDate_Lbl">
          <DataField>ShipmentDate_Lbl</DataField>
        </Field>
        <Field Name="Shipment_Lbl">
          <DataField>Shipment_Lbl</DataField>
        </Field>
        <Field Name="ShowShippingAddress">
          <DataField>ShowShippingAddress</DataField>
        </Field>
        <Field Name="ShipToAddress_Lbl">
          <DataField>ShipToAddress_Lbl</DataField>
        </Field>
        <Field Name="ShipToAddress1">
          <DataField>ShipToAddress1</DataField>
        </Field>
        <Field Name="ShipToAddress2">
          <DataField>ShipToAddress2</DataField>
        </Field>
        <Field Name="ShipToAddress3">
          <DataField>ShipToAddress3</DataField>
        </Field>
        <Field Name="ShipToAddress4">
          <DataField>ShipToAddress4</DataField>
        </Field>
        <Field Name="ShipToAddress5">
          <DataField>ShipToAddress5</DataField>
        </Field>
        <Field Name="ShipToAddress6">
          <DataField>ShipToAddress6</DataField>
        </Field>
        <Field Name="ShipToAddress7">
          <DataField>ShipToAddress7</DataField>
        </Field>
        <Field Name="ShipToAddress8">
          <DataField>ShipToAddress8</DataField>
        </Field>
        <Field Name="PaymentTermsDescription">
          <DataField>PaymentTermsDescription</DataField>
        </Field>
        <Field Name="PaymentTermsDescription_Lbl">
          <DataField>PaymentTermsDescription_Lbl</DataField>
        </Field>
        <Field Name="PaymentMethodDescription">
          <DataField>PaymentMethodDescription</DataField>
        </Field>
        <Field Name="PaymentMethodDescription_Lbl">
          <DataField>PaymentMethodDescription_Lbl</DataField>
        </Field>
        <Field Name="DocumentCopyText">
          <DataField>DocumentCopyText</DataField>
        </Field>
        <Field Name="BilltoCustumerNo">
          <DataField>BilltoCustumerNo</DataField>
        </Field>
        <Field Name="BilltoCustomerNo_Lbl">
          <DataField>BilltoCustomerNo_Lbl</DataField>
        </Field>
        <Field Name="DocumentDate">
          <DataField>DocumentDate</DataField>
        </Field>
        <Field Name="DocumentDate_Lbl">
          <DataField>DocumentDate_Lbl</DataField>
        </Field>
        <Field Name="DueDate">
          <DataField>DueDate</DataField>
        </Field>
        <Field Name="DueDate_Lbl">
          <DataField>DueDate_Lbl</DataField>
        </Field>
        <Field Name="DocumentNo">
          <DataField>DocumentNo</DataField>
        </Field>
        <Field Name="DocumentNo_Lbl">
          <DataField>DocumentNo_Lbl</DataField>
        </Field>
        <Field Name="OrderNo">
          <DataField>OrderNo</DataField>
        </Field>
        <Field Name="OrderNo_Lbl">
          <DataField>OrderNo_Lbl</DataField>
        </Field>
        <Field Name="PricesIncludingVAT">
          <DataField>PricesIncludingVAT</DataField>
        </Field>
        <Field Name="PricesIncludingVAT_Lbl">
          <DataField>PricesIncludingVAT_Lbl</DataField>
        </Field>
        <Field Name="PricesIncludingVATYesNo">
          <DataField>PricesIncludingVATYesNo</DataField>
        </Field>
        <Field Name="SalesPerson_Lbl">
          <DataField>SalesPerson_Lbl</DataField>
        </Field>
        <Field Name="SalesPersonBlank_Lbl">
          <DataField>SalesPersonBlank_Lbl</DataField>
        </Field>
        <Field Name="SalesPersonName">
          <DataField>SalesPersonName</DataField>
        </Field>
        <Field Name="SelltoCustomerNo">
          <DataField>SelltoCustomerNo</DataField>
        </Field>
        <Field Name="SelltoCustomerNo_Lbl">
          <DataField>SelltoCustomerNo_Lbl</DataField>
        </Field>
        <Field Name="VATRegistrationNo">
          <DataField>VATRegistrationNo</DataField>
        </Field>
        <Field Name="VATRegistrationNo_Lbl">
          <DataField>VATRegistrationNo_Lbl</DataField>
        </Field>
        <Field Name="GlobalLocationNumber">
          <DataField>GlobalLocationNumber</DataField>
        </Field>
        <Field Name="GlobalLocationNumber_Lbl">
          <DataField>GlobalLocationNumber_Lbl</DataField>
        </Field>
        <Field Name="PaymentReference">
          <DataField>PaymentReference</DataField>
        </Field>
        <Field Name="PaymentReference_Lbl">
          <DataField>PaymentReference_Lbl</DataField>
        </Field>
        <Field Name="LegalEntityType">
          <DataField>LegalEntityType</DataField>
        </Field>
        <Field Name="LegalEntityType_Lbl">
          <DataField>LegalEntityType_Lbl</DataField>
        </Field>
        <Field Name="Copy_Lbl">
          <DataField>Copy_Lbl</DataField>
        </Field>
        <Field Name="EMail_Header_Lbl">
          <DataField>EMail_Header_Lbl</DataField>
        </Field>
        <Field Name="HomePage_Header_Lbl">
          <DataField>HomePage_Header_Lbl</DataField>
        </Field>
        <Field Name="InvoiceDiscountBaseAmount_Lbl">
          <DataField>InvoiceDiscountBaseAmount_Lbl</DataField>
        </Field>
        <Field Name="InvoiceDiscountAmount_Lbl">
          <DataField>InvoiceDiscountAmount_Lbl</DataField>
        </Field>
        <Field Name="LineAmountAfterInvoiceDiscount_Lbl">
          <DataField>LineAmountAfterInvoiceDiscount_Lbl</DataField>
        </Field>
        <Field Name="LocalCurrency_Lbl">
          <DataField>LocalCurrency_Lbl</DataField>
        </Field>
        <Field Name="ExchangeRateAsText">
          <DataField>ExchangeRateAsText</DataField>
        </Field>
        <Field Name="Page_Lbl">
          <DataField>Page_Lbl</DataField>
        </Field>
        <Field Name="SalesInvoiceLineDiscount_Lbl">
          <DataField>SalesInvoiceLineDiscount_Lbl</DataField>
        </Field>
        <Field Name="DocumentTitle_Lbl">
          <DataField>DocumentTitle_Lbl</DataField>
        </Field>
        <Field Name="ShowWorkDescription">
          <DataField>ShowWorkDescription</DataField>
        </Field>
        <Field Name="RemainingAmount">
          <DataField>RemainingAmount</DataField>
        </Field>
        <Field Name="RemainingAmountFormat">
          <DataField>RemainingAmountFormat</DataField>
        </Field>
        <Field Name="RemainingAmountText">
          <DataField>RemainingAmountText</DataField>
        </Field>
        <Field Name="Subtotal_Lbl">
          <DataField>Subtotal_Lbl</DataField>
        </Field>
        <Field Name="Total_Lbl">
          <DataField>Total_Lbl</DataField>
        </Field>
        <Field Name="VATAmount_Lbl">
          <DataField>VATAmount_Lbl</DataField>
        </Field>
        <Field Name="VATBase_Lbl">
          <DataField>VATBase_Lbl</DataField>
        </Field>
        <Field Name="VATAmountSpecification_Lbl">
          <DataField>VATAmountSpecification_Lbl</DataField>
        </Field>
        <Field Name="VATClauses_Lbl">
          <DataField>VATClauses_Lbl</DataField>
        </Field>
        <Field Name="VATIdentifier_Lbl">
          <DataField>VATIdentifier_Lbl</DataField>
        </Field>
        <Field Name="VATPercentage_Lbl">
          <DataField>VATPercentage_Lbl</DataField>
        </Field>
        <Field Name="VATClause_Lbl">
          <DataField>VATClause_Lbl</DataField>
        </Field>
        <Field Name="PackageTrackingNo">
          <DataField>PackageTrackingNo</DataField>
        </Field>
        <Field Name="PackageTrackingNo_Lbl">
          <DataField>PackageTrackingNo_Lbl</DataField>
        </Field>
        <Field Name="ShippingAgentCode">
          <DataField>ShippingAgentCode</DataField>
        </Field>
        <Field Name="ShippingAgentCode_Lbl">
          <DataField>ShippingAgentCode_Lbl</DataField>
        </Field>
        <Field Name="LineNo_Line">
          <DataField>LineNo_Line</DataField>
        </Field>
        <Field Name="AmountExcludingVAT_Line">
          <DataField>AmountExcludingVAT_Line</DataField>
        </Field>
        <Field Name="AmountExcludingVAT_LineFormat">
          <DataField>AmountExcludingVAT_LineFormat</DataField>
        </Field>
        <Field Name="AmountExcludingVAT_Line_Lbl">
          <DataField>AmountExcludingVAT_Line_Lbl</DataField>
        </Field>
        <Field Name="AmountIncludingVAT_Line">
          <DataField>AmountIncludingVAT_Line</DataField>
        </Field>
        <Field Name="AmountIncludingVAT_LineFormat">
          <DataField>AmountIncludingVAT_LineFormat</DataField>
        </Field>
        <Field Name="AmountIncludingVAT_Line_Lbl">
          <DataField>AmountIncludingVAT_Line_Lbl</DataField>
        </Field>
        <Field Name="Description_Line">
          <DataField>Description_Line</DataField>
        </Field>
        <Field Name="Description_Line_Lbl">
          <DataField>Description_Line_Lbl</DataField>
        </Field>
        <Field Name="LineDiscountPercent_Line">
          <DataField>LineDiscountPercent_Line</DataField>
        </Field>
        <Field Name="LineDiscountPercent_LineFormat">
          <DataField>LineDiscountPercent_LineFormat</DataField>
        </Field>
        <Field Name="LineDiscountPercentText_Line">
          <DataField>LineDiscountPercentText_Line</DataField>
        </Field>
        <Field Name="LineAmount_Line">
          <DataField>LineAmount_Line</DataField>
        </Field>
        <Field Name="LineAmount_LineFormat">
          <DataField>LineAmount_LineFormat</DataField>
        </Field>
        <Field Name="LineAmount_Line_Lbl">
          <DataField>LineAmount_Line_Lbl</DataField>
        </Field>
        <Field Name="ItemNo_Line">
          <DataField>ItemNo_Line</DataField>
        </Field>
        <Field Name="ItemNo_Line_Lbl">
          <DataField>ItemNo_Line_Lbl</DataField>
        </Field>
        <Field Name="ShipmentDate_Line">
          <DataField>ShipmentDate_Line</DataField>
        </Field>
        <Field Name="ShipmentDate_Line_Lbl">
          <DataField>ShipmentDate_Line_Lbl</DataField>
        </Field>
        <Field Name="Quantity_Line">
          <DataField>Quantity_Line</DataField>
        </Field>
        <Field Name="Quantity_Line_Lbl">
          <DataField>Quantity_Line_Lbl</DataField>
        </Field>
        <Field Name="Type_Line">
          <DataField>Type_Line</DataField>
        </Field>
        <Field Name="UnitPrice">
          <DataField>UnitPrice</DataField>
        </Field>
        <Field Name="UnitPrice_Lbl">
          <DataField>UnitPrice_Lbl</DataField>
        </Field>
        <Field Name="UnitOfMeasure">
          <DataField>UnitOfMeasure</DataField>
        </Field>
        <Field Name="UnitOfMeasure_Lbl">
          <DataField>UnitOfMeasure_Lbl</DataField>
        </Field>
        <Field Name="VATIdentifier_Line">
          <DataField>VATIdentifier_Line</DataField>
        </Field>
        <Field Name="VATIdentifier_Line_Lbl">
          <DataField>VATIdentifier_Line_Lbl</DataField>
        </Field>
        <Field Name="VATPct_Line">
          <DataField>VATPct_Line</DataField>
        </Field>
        <Field Name="VATPct_Line_Lbl">
          <DataField>VATPct_Line_Lbl</DataField>
        </Field>
        <Field Name="TransHeaderAmount">
          <DataField>TransHeaderAmount</DataField>
        </Field>
        <Field Name="TransHeaderAmountFormat">
          <DataField>TransHeaderAmountFormat</DataField>
        </Field>
        <Field Name="JobTaskNo_Lbl">
          <DataField>JobTaskNo_Lbl</DataField>
        </Field>
        <Field Name="JobTaskNo">
          <DataField>JobTaskNo</DataField>
        </Field>
        <Field Name="JobTaskDescription">
          <DataField>JobTaskDescription</DataField>
        </Field>
        <Field Name="JobTaskDesc_Lbl">
          <DataField>JobTaskDesc_Lbl</DataField>
        </Field>
        <Field Name="JobNo_Lbl">
          <DataField>JobNo_Lbl</DataField>
        </Field>
        <Field Name="JobNo">
          <DataField>JobNo</DataField>
        </Field>
        <Field Name="DocumentNo_ShipmentLine">
          <DataField>DocumentNo_ShipmentLine</DataField>
        </Field>
        <Field Name="PostingDate_ShipmentLine">
          <DataField>PostingDate_ShipmentLine</DataField>
        </Field>
        <Field Name="PostingDate_ShipmentLine_Lbl">
          <DataField>PostingDate_ShipmentLine_Lbl</DataField>
        </Field>
        <Field Name="Quantity_ShipmentLine">
          <DataField>Quantity_ShipmentLine</DataField>
        </Field>
        <Field Name="Quantity_ShipmentLineFormat">
          <DataField>Quantity_ShipmentLineFormat</DataField>
        </Field>
        <Field Name="Quantity_ShipmentLine_Lbl">
          <DataField>Quantity_ShipmentLine_Lbl</DataField>
        </Field>
        <Field Name="LineNo_AssemblyLine">
          <DataField>LineNo_AssemblyLine</DataField>
        </Field>
        <Field Name="Description_AssemblyLine">
          <DataField>Description_AssemblyLine</DataField>
        </Field>
        <Field Name="Quantity_AssemblyLine">
          <DataField>Quantity_AssemblyLine</DataField>
        </Field>
        <Field Name="Quantity_AssemblyLineFormat">
          <DataField>Quantity_AssemblyLineFormat</DataField>
        </Field>
        <Field Name="UnitOfMeasure_AssemblyLine">
          <DataField>UnitOfMeasure_AssemblyLine</DataField>
        </Field>
        <Field Name="VariantCode_AssemblyLine">
          <DataField>VariantCode_AssemblyLine</DataField>
        </Field>
        <Field Name="WorkDescriptionLineNumber">
          <DataField>WorkDescriptionLineNumber</DataField>
        </Field>
        <Field Name="WorkDescriptionLine">
          <DataField>WorkDescriptionLine</DataField>
        </Field>
        <Field Name="InvoiceDiscountAmount_VATAmountLine">
          <DataField>InvoiceDiscountAmount_VATAmountLine</DataField>
        </Field>
        <Field Name="InvoiceDiscountAmount_VATAmountLineFormat">
          <DataField>InvoiceDiscountAmount_VATAmountLineFormat</DataField>
        </Field>
        <Field Name="InvoiceDiscountAmount_VATAmountLine_Lbl">
          <DataField>InvoiceDiscountAmount_VATAmountLine_Lbl</DataField>
        </Field>
        <Field Name="InvoiceDiscountBaseAmount_VATAmountLine">
          <DataField>InvoiceDiscountBaseAmount_VATAmountLine</DataField>
        </Field>
        <Field Name="InvoiceDiscountBaseAmount_VATAmountLineFormat">
          <DataField>InvoiceDiscountBaseAmount_VATAmountLineFormat</DataField>
        </Field>
        <Field Name="InvoiceDiscountBaseAmount_VATAmountLine_Lbl">
          <DataField>InvoiceDiscountBaseAmount_VATAmountLine_Lbl</DataField>
        </Field>
        <Field Name="LineAmount_VatAmountLine">
          <DataField>LineAmount_VatAmountLine</DataField>
        </Field>
        <Field Name="LineAmount_VatAmountLineFormat">
          <DataField>LineAmount_VatAmountLineFormat</DataField>
        </Field>
        <Field Name="LineAmount_VatAmountLine_Lbl">
          <DataField>LineAmount_VatAmountLine_Lbl</DataField>
        </Field>
        <Field Name="VATAmount_VatAmountLine">
          <DataField>VATAmount_VatAmountLine</DataField>
        </Field>
        <Field Name="VATAmount_VatAmountLineFormat">
          <DataField>VATAmount_VatAmountLineFormat</DataField>
        </Field>
        <Field Name="VATAmount_VatAmountLine_Lbl">
          <DataField>VATAmount_VatAmountLine_Lbl</DataField>
        </Field>
        <Field Name="VATAmountLCY_VATAmountLine">
          <DataField>VATAmountLCY_VATAmountLine</DataField>
        </Field>
        <Field Name="VATAmountLCY_VATAmountLineFormat">
          <DataField>VATAmountLCY_VATAmountLineFormat</DataField>
        </Field>
        <Field Name="VATAmountLCY_VATAmountLine_Lbl">
          <DataField>VATAmountLCY_VATAmountLine_Lbl</DataField>
        </Field>
        <Field Name="VATBase_VatAmountLine">
          <DataField>VATBase_VatAmountLine</DataField>
        </Field>
        <Field Name="VATBase_VatAmountLineFormat">
          <DataField>VATBase_VatAmountLineFormat</DataField>
        </Field>
        <Field Name="VATBase_VatAmountLine_Lbl">
          <DataField>VATBase_VatAmountLine_Lbl</DataField>
        </Field>
        <Field Name="VATBaseLCY_VATAmountLine">
          <DataField>VATBaseLCY_VATAmountLine</DataField>
        </Field>
        <Field Name="VATBaseLCY_VATAmountLineFormat">
          <DataField>VATBaseLCY_VATAmountLineFormat</DataField>
        </Field>
        <Field Name="VATBaseLCY_VATAmountLine_Lbl">
          <DataField>VATBaseLCY_VATAmountLine_Lbl</DataField>
        </Field>
        <Field Name="VATIdentifier_VatAmountLine">
          <DataField>VATIdentifier_VatAmountLine</DataField>
        </Field>
        <Field Name="VATIdentifier_VatAmountLine_Lbl">
          <DataField>VATIdentifier_VatAmountLine_Lbl</DataField>
        </Field>
        <Field Name="VATPct_VatAmountLine">
          <DataField>VATPct_VatAmountLine</DataField>
        </Field>
        <Field Name="VATPct_VatAmountLineFormat">
          <DataField>VATPct_VatAmountLineFormat</DataField>
        </Field>
        <Field Name="VATPct_VatAmountLine_Lbl">
          <DataField>VATPct_VatAmountLine_Lbl</DataField>
        </Field>
        <Field Name="NoOfVATIdentifiers">
          <DataField>NoOfVATIdentifiers</DataField>
        </Field>
        <Field Name="VATIdentifier_VATClauseLine">
          <DataField>VATIdentifier_VATClauseLine</DataField>
        </Field>
        <Field Name="Code_VATClauseLine">
          <DataField>Code_VATClauseLine</DataField>
        </Field>
        <Field Name="Code_VATClauseLine_Lbl">
          <DataField>Code_VATClauseLine_Lbl</DataField>
        </Field>
        <Field Name="Description_VATClauseLine">
          <DataField>Description_VATClauseLine</DataField>
        </Field>
        <Field Name="Description2_VATClauseLine">
          <DataField>Description2_VATClauseLine</DataField>
        </Field>
        <Field Name="VATAmount_VATClauseLine">
          <DataField>VATAmount_VATClauseLine</DataField>
        </Field>
        <Field Name="VATAmount_VATClauseLineFormat">
          <DataField>VATAmount_VATClauseLineFormat</DataField>
        </Field>
        <Field Name="NoOfVATClauses">
          <DataField>NoOfVATClauses</DataField>
        </Field>
        <Field Name="Description_ReportTotalsLine">
          <DataField>Description_ReportTotalsLine</DataField>
        </Field>
        <Field Name="Amount_ReportTotalsLine">
          <DataField>Amount_ReportTotalsLine</DataField>
        </Field>
        <Field Name="Amount_ReportTotalsLineFormat">
          <DataField>Amount_ReportTotalsLineFormat</DataField>
        </Field>
        <Field Name="AmountFormatted_ReportTotalsLine">
          <DataField>AmountFormatted_ReportTotalsLine</DataField>
        </Field>
        <Field Name="FontBold_ReportTotalsLine">
          <DataField>FontBold_ReportTotalsLine</DataField>
        </Field>
        <Field Name="FontUnderline_ReportTotalsLine">
          <DataField>FontUnderline_ReportTotalsLine</DataField>
        </Field>
        <Field Name="LineFeeCaptionText">
          <DataField>LineFeeCaptionText</DataField>
        </Field>
        <Field Name="PaymentServiceLogo">
          <DataField>PaymentServiceLogo</DataField>
        </Field>
        <Field Name="PaymentServiceLogo_UrlText">
          <DataField>PaymentServiceLogo_UrlText</DataField>
        </Field>
        <Field Name="PaymentServiceLogo_Url">
          <DataField>PaymentServiceLogo_Url</DataField>
        </Field>
        <Field Name="PaymentServiceText_UrlText">
          <DataField>PaymentServiceText_UrlText</DataField>
        </Field>
        <Field Name="PaymentServiceText_Url">
          <DataField>PaymentServiceText_Url</DataField>
        </Field>
        <Field Name="LeftHeaderName">
          <DataField>LeftHeaderName</DataField>
        </Field>
        <Field Name="LeftHeaderValue">
          <DataField>LeftHeaderValue</DataField>
        </Field>
        <Field Name="RightHeaderName">
          <DataField>RightHeaderName</DataField>
        </Field>
        <Field Name="RightHeaderValue">
          <DataField>RightHeaderValue</DataField>
        </Field>
        <Field Name="GreetingText">
          <DataField>GreetingText</DataField>
        </Field>
        <Field Name="BodyText">
          <DataField>BodyText</DataField>
        </Field>
        <Field Name="ClosingText">
          <DataField>ClosingText</DataField>
        </Field>
        <Field Name="PmtDiscText">
          <DataField>PmtDiscText</DataField>
        </Field>
        <Field Name="TotalNetAmount">
          <DataField>TotalNetAmount</DataField>
        </Field>
        <Field Name="TotalNetAmountFormat">
          <DataField>TotalNetAmountFormat</DataField>
        </Field>
        <Field Name="TotalVATBaseLCY">
          <DataField>TotalVATBaseLCY</DataField>
        </Field>
        <Field Name="TotalVATBaseLCYFormat">
          <DataField>TotalVATBaseLCYFormat</DataField>
        </Field>
        <Field Name="TotalAmountIncludingVAT">
          <DataField>TotalAmountIncludingVAT</DataField>
        </Field>
        <Field Name="TotalAmountIncludingVATFormat">
          <DataField>TotalAmountIncludingVATFormat</DataField>
        </Field>
        <Field Name="TotalVATAmount">
          <DataField>TotalVATAmount</DataField>
        </Field>
        <Field Name="TotalVATAmountFormat">
          <DataField>TotalVATAmountFormat</DataField>
        </Field>
        <Field Name="TotalVATAmountLCY">
          <DataField>TotalVATAmountLCY</DataField>
        </Field>
        <Field Name="TotalVATAmountLCYFormat">
          <DataField>TotalVATAmountLCYFormat</DataField>
        </Field>
        <Field Name="TotalInvoiceDiscountAmount">
          <DataField>TotalInvoiceDiscountAmount</DataField>
        </Field>
        <Field Name="TotalInvoiceDiscountAmountFormat">
          <DataField>TotalInvoiceDiscountAmountFormat</DataField>
        </Field>
        <Field Name="TotalPaymentDiscountOnVAT">
          <DataField>TotalPaymentDiscountOnVAT</DataField>
        </Field>
        <Field Name="TotalPaymentDiscountOnVATFormat">
          <DataField>TotalPaymentDiscountOnVATFormat</DataField>
        </Field>
        <Field Name="TotalVATAmountText">
          <DataField>TotalVATAmountText</DataField>
        </Field>
        <Field Name="TotalExcludingVATText">
          <DataField>TotalExcludingVATText</DataField>
        </Field>
        <Field Name="TotalIncludingVATText">
          <DataField>TotalIncludingVATText</DataField>
        </Field>
        <Field Name="TotalSubTotal">
          <DataField>TotalSubTotal</DataField>
        </Field>
        <Field Name="TotalSubTotalFormat">
          <DataField>TotalSubTotalFormat</DataField>
        </Field>
        <Field Name="TotalSubTotalMinusInvoiceDiscount">
          <DataField>TotalSubTotalMinusInvoiceDiscount</DataField>
        </Field>
        <Field Name="TotalSubTotalMinusInvoiceDiscountFormat">
          <DataField>TotalSubTotalMinusInvoiceDiscountFormat</DataField>
        </Field>
        <Field Name="TotalText">
          <DataField>TotalText</DataField>
        </Field>
      </Fields>
      <rd:DataSetInfo>
        <rd:DataSetName>DataSet</rd:DataSetName>
        <rd:SchemaPath>Report.xsd</rd:SchemaPath>
        <rd:TableName>Result</rd:TableName>
      </rd:DataSetInfo>
    </DataSet>
  </DataSets>
  <ReportSections>
    <ReportSection>
      <Body>
        <ReportItems>
          <Tablix Name="Tablix1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>18.70718cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>21.78252cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="Rectangle1">
                          <ReportItems>
                            <Tablix Name="HeaderTable">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.69334cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.67702cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.23977cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.68518cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>5.05562cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.76298cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustomerPostalBarCode">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustomerPostalBarCode.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>14pt</FontSize>
                                                      <FontWeight>SemiBold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>General</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CustomerPostalBarCode</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="DocumentTitle_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocumentTitle_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>14pt</FontSize>
                                                      <FontWeight>SemiBold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>DocumentTitle_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.33514cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>5</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustomerAddress1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustomerAddress1.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CustomerAddress1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyAddress1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyAddress1.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyAddress1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustomerAddress2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustomerAddress2.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CustomerAddress2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox3">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox3</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyAddress2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyAddress2.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyAddress2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustomerAddress3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustomerAddress3.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CustomerAddress3</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox4">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox4</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyAddress3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyAddress3.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyAddress3</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustomerAddress4">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustomerAddress4.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CustomerAddress4</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox5">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox5</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyAddress4">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyAddress4.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyAddress4</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustomerAddress5">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustomerAddress5.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CustomerAddress5</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox6">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox6</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyAddress5">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyAddress5.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyAddress5</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustomerAddress6">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustomerAddress6.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CustomerAddress6</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox7">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox7</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyAddress6">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyAddress6.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyAddress6</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustomerAddress7">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustomerAddress7.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CustomerAddress7</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox8">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox8</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyLegalOffice_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyLegalOffice_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyLegalOffice_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyLegalOffice">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyLegalOffice.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyLegalOffice</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustomerAddress8">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustomerAddress8.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CustomerAddress8</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox9">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox9</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesPersonBlank_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SalesPersonBlank_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>SalesPersonBlank_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesPersonName">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SalesPersonName.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>SalesPersonName</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Tablix Name="Tablix4">
                                            <TablixBody>
                                              <TablixColumns>
                                                <TablixColumn>
                                                  <Width>3.68518cm</Width>
                                                </TablixColumn>
                                                <TablixColumn>
                                                  <Width>3.68518cm</Width>
                                                </TablixColumn>
                                              </TablixColumns>
                                              <TablixRows>
                                                <TablixRow>
                                                  <Height>0.38806cm</Height>
                                                  <TablixCells>
                                                    <TablixCell>
                                                      <CellContents>
                                                        <Textbox Name="LeftHeaderName">
                                                          <CanGrow>true</CanGrow>
                                                          <KeepTogether>true</KeepTogether>
                                                          <Paragraphs>
                                                            <Paragraph>
                                                              <TextRuns>
                                                                <TextRun>
                                                                  <Value>=Fields!LeftHeaderName.Value</Value>
                                                                  <Style>
                                                                    <FontFamily>Segoe UI</FontFamily>
                                                                    <FontSize>8pt</FontSize>
                                                                  </Style>
                                                                </TextRun>
                                                              </TextRuns>
                                                              <Style>
                                                                <TextAlign>Left</TextAlign>
                                                              </Style>
                                                            </Paragraph>
                                                          </Paragraphs>
                                                          <rd:DefaultName>LeftHeaderName</rd:DefaultName>
                                                          <Style>
                                                            <Border>
                                                              <Style>None</Style>
                                                            </Border>
                                                            <PaddingLeft>5pt</PaddingLeft>
                                                            <PaddingRight>5pt</PaddingRight>
                                                          </Style>
                                                        </Textbox>
                                                      </CellContents>
                                                    </TablixCell>
                                                    <TablixCell>
                                                      <CellContents>
                                                        <Textbox Name="LeftHeaderValue">
                                                          <CanGrow>true</CanGrow>
                                                          <KeepTogether>true</KeepTogether>
                                                          <Paragraphs>
                                                            <Paragraph>
                                                              <TextRuns>
                                                                <TextRun>
                                                                  <Value>=Fields!LeftHeaderValue.Value</Value>
                                                                  <Style>
                                                                    <FontFamily>Segoe UI</FontFamily>
                                                                    <FontSize>8pt</FontSize>
                                                                  </Style>
                                                                </TextRun>
                                                              </TextRuns>
                                                              <Style>
                                                                <TextAlign>Right</TextAlign>
                                                              </Style>
                                                            </Paragraph>
                                                          </Paragraphs>
                                                          <rd:DefaultName>LeftHeaderValue</rd:DefaultName>
                                                          <Style>
                                                            <Border>
                                                              <Style>None</Style>
                                                            </Border>
                                                            <PaddingLeft>5pt</PaddingLeft>
                                                            <PaddingRight>5pt</PaddingRight>
                                                          </Style>
                                                        </Textbox>
                                                      </CellContents>
                                                    </TablixCell>
                                                  </TablixCells>
                                                </TablixRow>
                                              </TablixRows>
                                            </TablixBody>
                                            <TablixColumnHierarchy>
                                              <TablixMembers>
                                                <TablixMember />
                                                <TablixMember />
                                              </TablixMembers>
                                            </TablixColumnHierarchy>
                                            <TablixRowHierarchy>
                                              <TablixMembers>
                                                <TablixMember>
                                                  <Group Name="Details4" />
                                                  <Visibility>
                                                    <Hidden>=Len(Fields!LeftHeaderValue.Value) = 0</Hidden>
                                                  </Visibility>
                                                </TablixMember>
                                              </TablixMembers>
                                            </TablixRowHierarchy>
                                            <DataSetName>DataSet_Result</DataSetName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                            </Style>
                                          </Tablix>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox12">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox12</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Tablix Name="Tablix5">
                                            <TablixBody>
                                              <TablixColumns>
                                                <TablixColumn>
                                                  <Width>3.68987cm</Width>
                                                </TablixColumn>
                                                <TablixColumn>
                                                  <Width>5.05093cm</Width>
                                                </TablixColumn>
                                              </TablixColumns>
                                              <TablixRows>
                                                <TablixRow>
                                                  <Height>0.38806cm</Height>
                                                  <TablixCells>
                                                    <TablixCell>
                                                      <CellContents>
                                                        <Textbox Name="RightHeaderName">
                                                          <CanGrow>true</CanGrow>
                                                          <KeepTogether>true</KeepTogether>
                                                          <Paragraphs>
                                                            <Paragraph>
                                                              <TextRuns>
                                                                <TextRun>
                                                                  <Value>=Fields!RightHeaderName.Value</Value>
                                                                  <Style>
                                                                    <FontFamily>Segoe UI</FontFamily>
                                                                    <FontSize>8pt</FontSize>
                                                                  </Style>
                                                                </TextRun>
                                                              </TextRuns>
                                                              <Style>
                                                                <TextAlign>Left</TextAlign>
                                                              </Style>
                                                            </Paragraph>
                                                          </Paragraphs>
                                                          <rd:DefaultName>RightHeaderName</rd:DefaultName>
                                                          <Style>
                                                            <Border>
                                                              <Style>None</Style>
                                                            </Border>
                                                            <PaddingLeft>5pt</PaddingLeft>
                                                            <PaddingRight>5pt</PaddingRight>
                                                          </Style>
                                                        </Textbox>
                                                      </CellContents>
                                                    </TablixCell>
                                                    <TablixCell>
                                                      <CellContents>
                                                        <Textbox Name="RightHeaderValue">
                                                          <CanGrow>true</CanGrow>
                                                          <KeepTogether>true</KeepTogether>
                                                          <Paragraphs>
                                                            <Paragraph>
                                                              <TextRuns>
                                                                <TextRun>
                                                                  <Value>=Fields!RightHeaderValue.Value</Value>
                                                                  <Style>
                                                                    <FontFamily>Segoe UI</FontFamily>
                                                                    <FontSize>8pt</FontSize>
                                                                  </Style>
                                                                </TextRun>
                                                              </TextRuns>
                                                              <Style>
                                                                <TextAlign>Right</TextAlign>
                                                              </Style>
                                                            </Paragraph>
                                                          </Paragraphs>
                                                          <rd:DefaultName>RightHeaderValue</rd:DefaultName>
                                                          <Style>
                                                            <Border>
                                                              <Style>None</Style>
                                                            </Border>
                                                            <PaddingLeft>5pt</PaddingLeft>
                                                            <PaddingRight>5pt</PaddingRight>
                                                          </Style>
                                                        </Textbox>
                                                      </CellContents>
                                                    </TablixCell>
                                                  </TablixCells>
                                                </TablixRow>
                                              </TablixRows>
                                            </TablixBody>
                                            <TablixColumnHierarchy>
                                              <TablixMembers>
                                                <TablixMember />
                                                <TablixMember />
                                              </TablixMembers>
                                            </TablixColumnHierarchy>
                                            <TablixRowHierarchy>
                                              <TablixMembers>
                                                <TablixMember>
                                                  <Group Name="Details5" />
                                                  <Visibility>
                                                    <Hidden>=Len(Fields!RightHeaderValue.Value) = 0</Hidden>
                                                  </Visibility>
                                                </TablixMember>
                                              </TablixMembers>
                                            </TablixRowHierarchy>
                                            <DataSetName>DataSet_Result</DataSetName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                            </Style>
                                          </Tablix>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.4148cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShippingAgentCode_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShippingAgentCode_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShippingAgentCode_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShippingAgentCode">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShippingAgentCode.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShippingAgentCode</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox13">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox13</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="JobNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!JobNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>JobNo_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="JobNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!JobNo.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>JobNo</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38834cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PackageTrackingNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PackageTrackingNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PackageTrackingNo_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PackageTrackingNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PackageTrackingNo.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PackageTrackingNo</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox18">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox18</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox19">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox19</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox20">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox20</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!CustomerAddress5.Value="" AND Fields!CompanyAddress5.Value=""</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!CustomerAddress6.Value="" AND Fields!CompanyAddress6.Value=""</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!CustomerAddress7.Value="" AND Fields!CompanyLegalOffice.Value=""</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>0.07056cm</Top>
                              <Height>5.3938cm</Height>
                              <Width>18.35093cm</Width>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="LinesTable">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>4cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.8cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.5cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.6cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ItemNo_Line_Lbl2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ItemNo_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ItemNo_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Description_Line_Lbl2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Description_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipmentDate_Line_Lbl2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipmentDate_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipmentDate_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Quantity_Line_Lbl2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Quantity_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Quantity_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="UnitOfMeasure_Lbl2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitOfMeasure_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>UnitOfMeasure_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="UnitPrice_Lbl2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitPrice_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>UnitPrice_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox62">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox62</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATPct_Line_Lbl2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPct_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATPct_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineAmount_Line_Lbl2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineAmount_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>LineAmount_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.6cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ItemNo_Line_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ItemNo_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ItemNo_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Description_Line_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Description_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipmentDate_Line_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipmentDate_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipmentDate_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Quantity_Line_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Quantity_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Quantity_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="UnitOfMeasure_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitOfMeasure_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>UnitOfMeasure_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="UnitPrice_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitPrice_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>UnitPrice_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox28">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox28</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATPct_Line_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPct_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATPct_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineAmount_Line_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineAmount_Line_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>LineAmount_Line_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.49417cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox10">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!JobTaskNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox10</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>10pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox11">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!JobTaskDesc_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox11</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox14">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox14</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox15">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox15</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox16">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox16</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox17">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox17</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox21">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox21</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox24">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox24</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox25">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox25</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox29">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox29</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Description_Line">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_Line.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Description_Line</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>5</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox30">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox30</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox31">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox31</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox32">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox32</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ItemNo_Line">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ItemNo_Line.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ItemNo_Line</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Description_Line_2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_Line.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Description_Line_2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipmentDate_Line">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipmentDate_Line.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>dd-MM-yy</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipmentDate_Line</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Quantity_Line">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Quantity_Line.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Quantity_Line</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="UnitOfMeasure">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitOfMeasure.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>UnitOfMeasure</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="UnitPrice">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitPrice.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>UnitPrice</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineDiscountPercentText_Line">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineDiscountPercentText_Line.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>LineDiscountPercentText_Line</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATPct_Line">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPct_Line.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATPct_Line</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineAmount_Line">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineAmount_Line.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>LineAmount_Line</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="JobTaskNo2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!JobTaskNo.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>JobTaskNo</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>10pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="JobTaskDescription2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!JobTaskDescription.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>JobTaskDescription</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>6</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox22">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox22</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox23">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox23</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox33">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox33</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Shipment_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Shipment_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                  <TextRun>
                                                    <Value xml:space="preserve"> </Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                  <TextRun>
                                                    <Value>=Fields!DocumentNo_ShipmentLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Shipment_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>10pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PostingDate_ShipmentLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PostingDate_ShipmentLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>dd-MM-yy</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PostingDate_ShipmentLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Quantity_ShipmentLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Quantity_ShipmentLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!Quantity_ShipmentLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Quantity_ShipmentLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox34">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox34</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox35">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox35</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox36">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox36</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox37">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox37</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox38">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox38</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.52062cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineNo_AssemblyLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineNo_AssemblyLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>LineNo_AssemblyLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Description_AssemblyLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_AssemblyLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Description_AssemblyLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VariantCode_AssemblyLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VariantCode_AssemblyLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VariantCode_AssemblyLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Quantity_AssemblyLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Quantity_AssemblyLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!Quantity_AssemblyLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Quantity_AssemblyLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="UnitOfMeasure_AssemblyLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitOfMeasure_AssemblyLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>UnitOfMeasure_AssemblyLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox39">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox39</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox40">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox40</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox41">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox41</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox42">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox42</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=(Fields!JobNo.Value) &lt;&gt; ""</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=(Fields!JobNo.Value) = ""</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=(Fields!JobNo.Value) = ""</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="InvoiceNo">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!DocumentNo.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <SortExpressions>
                                      <SortExpression>
                                        <Value>=Fields!DocumentNo.Value</Value>
                                      </SortExpression>
                                    </SortExpressions>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="LineNo">
                                          <GroupExpressions>
                                            <GroupExpression>=Fields!LineNo_Line.Value</GroupExpression>
                                          </GroupExpressions>
                                        </Group>
                                        <SortExpressions>
                                          <SortExpression>
                                            <Value>=Fields!LineNo_Line.Value</Value>
                                          </SortExpression>
                                        </SortExpressions>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=Fields!Type_Line.Value &lt;&gt; " "</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=Fields!Type_Line.Value = " "</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=(Fields!JobTaskNo.Value) = ""</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                          </TablixMember>
                                          <TablixMember>
                                            <Group Name="Details" />
                                            <TablixMembers>
                                              <TablixMember />
                                            </TablixMembers>
                                            <Visibility>
                                              <Hidden>=Fields!Quantity_ShipmentLine.Value = 0</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                        </TablixMembers>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=Fields!Quantity_AssemblyLine.Value = 0</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <RepeatRowHeaders>true</RepeatRowHeaders>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>6.07677cm</Top>
                              <Height>3.76703cm</Height>
                              <Width>18.5cm</Width>
                              <ZIndex>1</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
                            </Tablix>
                            <Tablix Name="VATClauses">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>11.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.8cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATClauses_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATClauses_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATClauses_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox43">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox43</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATIdentifier_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifier_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATIdentifier_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox44">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox44</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATIdentifier_VATClauseLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifier_VATClauseLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATIdentifier_VATClauseLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Description_VATClauseLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_VATClauseLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Description_VATClauseLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmount_VATClauseLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmount_VATClauseLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmount_VATClauseLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmount_VATClauseLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox45">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox45</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Description2_VATClauseLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description2_VATClauseLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Description2_VATClauseLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox46">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>segoe ui</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox46</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!NoOfVATClauses.Value = 0</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Details2" />
                                    <TablixMembers>
                                      <TablixMember />
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=Len(Fields!Description2_VATClauseLine.Value) = 0</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Cstr(Len(Fields!Code_VATClauseLine.Value))</FilterExpression>
                                  <Operator>NotEqual</Operator>
                                  <FilterValues>
                                    <FilterValue>0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>15.74954cm</Top>
                              <Left>0.02032in</Left>
                              <Height>1.55224cm</Height>
                              <Width>16.8cm</Width>
                              <ZIndex>2</ZIndex>
                              <Visibility>
                                <Hidden>=Fields!Code_VATClauseLine.Value = ""</Hidden>
                              </Visibility>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
                            </Tablix>
                            <Tablix Name="VATSpec">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.8cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.8cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.8cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.8cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountSpecification_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountSpecification_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountSpecification_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox47">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox47</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox48">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox48</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox49">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox49</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox50">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox50</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATIdentifier_Lbl_2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifier_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATIdentifier_Lbl_2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATPercentage_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPercentage_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATPercentage_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATBase_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBase_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATBase_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmount_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmount_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmount_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATBaseLCY_VATAmountLine_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBaseLCY_VATAmountLine_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATBaseLCY_VATAmountLine_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLCY_VATAmountLine_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLCY_VATAmountLine_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLCY_VATAmountLine_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATIdentifier_VatAmountLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifier_VatAmountLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATIdentifier_VatAmountLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATPct_VatAmountLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPct_VatAmountLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATPct_VatAmountLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATBase_VatAmountLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBase_VatAmountLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATBase_VatAmountLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATBase_VatAmountLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmount_VatAmountLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmount_VatAmountLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmount_VatAmountLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmount_VatAmountLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATBaseLCY_VATAmountLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBaseLCY_VATAmountLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATBaseLCY_VATAmountLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATBaseLCY_VATAmountLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLCY_VATAmountLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLCY_VATAmountLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmountLCY_VATAmountLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLCY_VATAmountLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.6cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox51">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox51</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox52">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox52</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATBase_VatAmountLine_2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATBase_VatAmountLine.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATBase_VatAmountLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATBase_VatAmountLine_2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmount_VatAmountLine_2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmount_VatAmountLine.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmount_VatAmountLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmount_VatAmountLine_2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATBaseLCY_VATAmountLine_2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATBaseLCY_VATAmountLine.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATBaseLCY_VATAmountLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATBaseLCY_VATAmountLine_2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLCY_VATAmountLine_2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLCY_VATAmountLine.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmountLCY_VATAmountLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLCY_VATAmountLine_2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!VATAmount_VatAmountLine.Value = Fields!VATAmountLCY_VATAmountLine.Value</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!VATAmount_VatAmountLine.Value = Fields!VATAmountLCY_VATAmountLine.Value</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!VATIdentifier_VatAmountLine.Value = ""</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!NoOfVATIdentifiers.Value = 0</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Details1" />
                                    <TablixMembers>
                                      <TablixMember />
                                    </TablixMembers>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!NoOfVATIdentifiers.Value &lt; 2</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Cstr(Len(Fields!VATIdentifier_VatAmountLine.Value))</FilterExpression>
                                  <Operator>NotEqual</Operator>
                                  <FilterValues>
                                    <FilterValue>0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>13.49784cm</Top>
                              <Left>0.02032in</Left>
                              <Height>1.76418cm</Height>
                              <Width>15.2cm</Width>
                              <ZIndex>3</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="Table_ShipToAdress">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>4.67441cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>13.35044cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddress_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!ShipToAddress_Lbl.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <Border />
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SelltoCustomerNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SelltoCustomerNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <Border />
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SelltoCustomerNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!SelltoCustomerNo.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <Border />
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox53">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox53</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddress1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddress1.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <Border />
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddress2">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddress2.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <Border />
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddress3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddress3.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <Border />
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddress4">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddress4.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddress4</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddress5">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddress5.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddress5</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddress6">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddress6.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddress6</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddress7">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddress7.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddress7</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddress8">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddress8.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <FontFamily>Segoe UI</FontFamily>
                                                  <FontSize>8pt</FontSize>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddress8</rd:DefaultName>
                                            <Style>
                                              <FontFamily>Segoe UI</FontFamily>
                                              <FontSize>8pt</FontSize>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=(First(Fields!SelltoCustomerNo.Value) = First(Fields!BilltoCustumerNo.Value))</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Table_ShipToAdress_Details_Group">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!ShipToAddress1.Value</GroupExpression>
                                      </GroupExpressions>
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=(First(Fields!SelltoCustomerNo.Value, "Table_ShipToAdress") = First(Fields!BilltoCustumerNo.Value, "Table_ShipToAdress"))</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                      <TablixMember />
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!ShipToAddress1.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>17.34384cm</Top>
                              <Left>0.02032in</Left>
                              <Height>3.88058cm</Height>
                              <Width>18.02485cm</Width>
                              <ZIndex>4</ZIndex>
                              <Visibility>
                                <Hidden>=NOT Fields!ShowShippingAddress.Value</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="LinesTableTotals">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.8cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Subtotal_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Subtotal_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Subtotal_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalSubTotal">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalSubTotal.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Last(Fields!TotalSubTotalFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalSubTotal</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="InvoiceDiscountAmount_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!InvoiceDiscountAmount_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>InvoiceDiscountAmount_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalInvoiceDiscountAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalInvoiceDiscountAmount.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Last(Fields!TotalInvoiceDiscountAmountFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalInvoiceDiscountAmount</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalExcludingVATText">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalExcludingVATText.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalExcludingVATText</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalSubTotalMinusInvoiceDiscount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalSubTotalMinusInvoiceDiscount.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Last(Fields!TotalNetAmountFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalSubTotalMinusInvoiceDiscount</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmount_Lbl_2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmount_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmount_Lbl_2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalVATAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalVATAmount.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Last(Fields!TotalVATAmountFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalVATAmount</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalIncludingVATText">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalIncludingVATText.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalIncludingVATText</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalAmountIncludingVAT">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmountIncludingVAT.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Last(Fields!TotalAmountIncludingVATFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmountIncludingVAT</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.22958cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox54">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox54</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox55">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox55</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox56">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox56</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox57">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox57</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmount_Lbl_3">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmount_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmount_Lbl_3</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalVATAmount_2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalVATAmount.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Last(Fields!TotalVATAmountFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalVATAmount_2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.38806cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalExcludingVATText_2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalExcludingVATText.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalExcludingVATText_2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalNetAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalNetAmount.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Last(Fields!TotalNetAmountFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalNetAmount</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Last(Fields!TotalInvoiceDiscountAmount.Value) = 0</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=(Last(Fields!TotalInvoiceDiscountAmount.Value) = 0) Or (Fields!PricesIncludingVAT.Value = True)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=(Last(Fields!TotalVATAmount.Value) = 0) Or (Fields!PricesIncludingVAT.Value = True)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember />
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=(LAST(Fields!TotalVATAmount.Value) = 0) OR (Fields!PricesIncludingVAT.Value = FALSE)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=(Last(Fields!TotalVATAmount.Value) = 0) Or (Fields!PricesIncludingVAT.Value = False)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=(Last(Fields!TotalVATAmount.Value) = 0) Or (Fields!PricesIncludingVAT.Value = False)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <RepeatRowHeaders>true</RepeatRowHeaders>
                              <KeepTogether>true</KeepTogether>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>9.98335cm</Top>
                              <Left>11.55097cm</Left>
                              <Height>2.946cm</Height>
                              <Width>7cm</Width>
                              <ZIndex>5</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
                            </Tablix>
                            <Textbox Name="CompanyLegalStatement">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CompanyLegalStatement.Value</Value>
                                      <Style>
                                        <FontFamily>Segoe UI</FontFamily>
                                        <FontSize>8pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>CompanyLegalStatement</rd:DefaultName>
                              <Top>21.27381cm</Top>
                              <Left>0.02032in</Left>
                              <Height>11pt</Height>
                              <Width>18cm</Width>
                              <ZIndex>6</ZIndex>
                              <Visibility>
                                <Hidden>=Fields!CompanyLegalStatement.Value = ""</Hidden>
                              </Visibility>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <PaddingLeft>5pt</PaddingLeft>
                                <PaddingRight>5pt</PaddingRight>
                              </Style>
                            </Textbox>
                            <Tablix Name="Tablix2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.07938cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.42333cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox98">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox98</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Group Name="Group1" />
                                    <TablixHeader>
                                      <Size>17.80795cm</Size>
                                      <CellContents>
                                        <Textbox Name="Group1">
                                          <CanGrow>true</CanGrow>
                                          <KeepTogether>true</KeepTogether>
                                          <Paragraphs>
                                            <Paragraph>
                                              <TextRuns>
                                                <TextRun>
                                                  <Value>=Fields!LineFeeCaptionText.Value</Value>
                                                  <Style>
                                                    <FontStyle>Normal</FontStyle>
                                                    <FontFamily>Segoe UI</FontFamily>
                                                    <FontSize>8pt</FontSize>
                                                  </Style>
                                                </TextRun>
                                              </TextRuns>
                                              <Style />
                                            </Paragraph>
                                          </Paragraphs>
                                          <rd:DefaultName>Group1</rd:DefaultName>
                                          <Visibility>
                                            <Hidden>=Fields!LineFeeCaptionText.Value = ""</Hidden>
                                          </Visibility>
                                          <Style>
                                            <Border>
                                              <Color>LightGrey</Color>
                                              <Style>None</Style>
                                            </Border>
                                            <PaddingLeft>2pt</PaddingLeft>
                                            <PaddingRight>2pt</PaddingRight>
                                            <PaddingTop>2pt</PaddingTop>
                                            <PaddingBottom>2pt</PaddingBottom>
                                          </Style>
                                        </Textbox>
                                      </CellContents>
                                    </TablixHeader>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!LineFeeCaptionText.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>15.28162cm</Top>
                              <Left>0.21461cm</Left>
                              <Height>0.42333cm</Height>
                              <Width>17.88733cm</Width>
                              <ZIndex>7</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
                            </Tablix>
                            <Tablix Name="Tablix3">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.3782cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.8636cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Image Name="Image1">
                                            <Source>Database</Source>
                                            <Value>=Fields!PaymentServiceLogo.Value</Value>
                                            <MIMEType>image/png</MIMEType>
                                            <Sizing>FitProportional</Sizing>
                                            <ActionInfo>
                                              <Actions>
                                                <Action>
                                                  <Hyperlink>=Fields!PaymentServiceLogo_Url.Value</Hyperlink>
                                                </Action>
                                              </Actions>
                                            </ActionInfo>
                                            <Style>
                                              <Border>
                                                <Color>White</Color>
                                                <Style>None</Style>
                                              </Border>
                                            </Style>
                                          </Image>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.6cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PaymentServiceURLText">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PaymentServiceLogo_UrlText.Value</Value>
                                                    <ActionInfo>
                                                      <Actions>
                                                        <Action>
                                                          <Hyperlink>=Fields!PaymentServiceLogo_Url.Value</Hyperlink>
                                                        </Action>
                                                      </Actions>
                                                    </ActionInfo>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Color>#0066dd</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PaymentServiceURLText</rd:DefaultName>
                                            <ActionInfo>
                                              <Actions>
                                                <Action>
                                                  <Hyperlink>=Fields!PaymentServiceLogo_Url.Value</Hyperlink>
                                                </Action>
                                              </Actions>
                                            </ActionInfo>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Group Name="PaymentServiceURLText">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!PaymentServiceLogo_UrlText.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <SortExpressions>
                                      <SortExpression>
                                        <Value>=Fields!PaymentServiceLogo_UrlText.Value</Value>
                                      </SortExpression>
                                    </SortExpressions>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="Details3">
                                          <Filters>
                                            <Filter>
                                              <FilterExpression>=Len(Fields!PaymentServiceLogo_Url.Value)</FilterExpression>
                                              <Operator>GreaterThan</Operator>
                                              <FilterValues>
                                                <FilterValue DataType="Integer">0</FilterValue>
                                              </FilterValues>
                                            </Filter>
                                          </Filters>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember />
                                          <TablixMember />
                                        </TablixMembers>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>10.24373cm</Top>
                              <Left>0.21398cm</Left>
                              <Height>1.4636cm</Height>
                              <Width>3.3782cm</Width>
                              <ZIndex>8</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
                            </Tablix>
                            <Tablix Name="Tablix6">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>18.30602cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.4cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="WorkDescriptionLine">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!WorkDescriptionLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>WorkDescriptionLine</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                </TablixRows>
                              </TablixBody>
                              <TablixColumnHierarchy>
                                <TablixMembers>
                                  <TablixMember />
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <Group Name="Details6">
                                      <Filters>
                                        <Filter>
                                          <FilterExpression>=Fields!WorkDescriptionLineNumber.Value</FilterExpression>
                                          <Operator>Between</Operator>
                                          <FilterValues>
                                            <FilterValue DataType="Integer">1</FilterValue>
                                            <FilterValue DataType="Integer">99999</FilterValue>
                                          </FilterValues>
                                        </Filter>
                                      </Filters>
                                    </Group>
                                    <Visibility>
                                      <Hidden>=Fields!ShowWorkDescription.Value = False</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>5.60621cm</Top>
                              <Left>0.09398cm</Left>
                              <Height>0.4cm</Height>
                              <Width>18.30602cm</Width>
                              <ZIndex>9</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
                            </Tablix>
                            <Textbox Name="PaidStatus">
                              <CanGrow>true</CanGrow>
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!RemainingAmountText.Value</Value>
                                      <Style>
                                        <FontFamily>Segoe UI</FontFamily>
                                        <FontSize>8pt</FontSize>
                                        <FontWeight>Bold</FontWeight>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style>
                                    <TextAlign>Right</TextAlign>
                                  </Style>
                                </Paragraph>
                              </Paragraphs>
                              <Top>13.10574cm</Top>
                              <Left>2.05161cm</Left>
                              <Height>0.5cm</Height>
                              <Width>16.44839cm</Width>
                              <ZIndex>10</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                                <PaddingLeft>5pt</PaddingLeft>
                                <PaddingRight>5pt</PaddingRight>
                              </Style>
                            </Textbox>
                          </ReportItems>
                          <KeepTogether>true</KeepTogether>
                          <OmitBorderOnPageBreak>true</OmitBorderOnPageBreak>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                          </Style>
                        </Rectangle>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
              </TablixRows>
            </TablixBody>
            <TablixColumnHierarchy>
              <TablixMembers>
                <TablixMember />
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <Group Name="Header">
                    <GroupExpressions>
                      <GroupExpression>=Fields!DocumentNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                      <ResetPageNumber>true</ResetPageNumber>
                    </PageBreak>
                  </Group>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>0.22049cm</Top>
            <Height>21.78252cm</Height>
            <Width>18.70718cm</Width>
            <Style>
              <Border>
                <Style>None</Style>
              </Border>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>22.1353cm</Height>
        <Style />
      </Body>
      <Width>18.81301cm</Width>
      <Page>
        <PageHeader>
          <Height>3.8cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Rectangle Name="Rectangle2">
              <ReportItems>
                <Image Name="Image2">
                  <Source>Database</Source>
                  <Value>=System.Convert.ToBase64String(Fields!CompanyPicture.Value)</Value>
                  <MIMEType>image/bmp</MIMEType>
                  <Sizing>FitProportional</Sizing>
                  <Height>14mm</Height>
                  <Width>60mm</Width>
                  <Visibility>
                    <Hidden>=iif(First(Fields!CompanyLogoPosition.Value, "DataSet_Result")=1,false,true)</Hidden>
                  </Visibility>
                  <Style>
                    <Border>
                      <Style>None</Style>
                    </Border>
                  </Style>
                </Image>
                <Line Name="Line1">
                  <Height>0cm</Height>
                  <Width>6cm</Width>
                  <ZIndex>1</ZIndex>
                  <Visibility>
                    <Hidden>true</Hidden>
                  </Visibility>
                  <Style>
                    <Border>
                      <Style>Solid</Style>
                    </Border>
                  </Style>
                </Line>
              </ReportItems>
              <KeepTogether>true</KeepTogether>
              <Height>3cm</Height>
              <Width>6cm</Width>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Rectangle>
            <Rectangle Name="Rectangle3">
              <ReportItems>
                <Image Name="Image4">
                  <Source>Database</Source>
                  <Value>=System.Convert.ToBase64String(Fields!CompanyPicture.Value)</Value>
                  <MIMEType>image/bmp</MIMEType>
                  <Sizing>FitProportional</Sizing>
                  <Height>14mm</Height>
                  <Width>60mm</Width>
                  <Visibility>
                    <Hidden>=iif(First(Fields!CompanyLogoPosition.Value, "DataSet_Result")=3,false,true)</Hidden>
                  </Visibility>
                  <Style>
                    <Border>
                      <Style>None</Style>
                    </Border>
                  </Style>
                </Image>
                <Line Name="Line3">
                  <Height>0cm</Height>
                  <Width>6cm</Width>
                  <ZIndex>1</ZIndex>
                  <Visibility>
                    <Hidden>true</Hidden>
                  </Visibility>
                  <Style>
                    <Border>
                      <Style>Solid</Style>
                    </Border>
                  </Style>
                </Line>
              </ReportItems>
              <KeepTogether>true</KeepTogether>
              <Left>12cm</Left>
              <Height>3cm</Height>
              <Width>6.4cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Rectangle>
            <Rectangle Name="Rectangle4">
              <ReportItems>
                <Image Name="Image3">
                  <Source>Database</Source>
                  <Value>=System.Convert.ToBase64String(Fields!CompanyPicture.Value)</Value>
                  <MIMEType>image/bmp</MIMEType>
                  <Sizing>FitProportional</Sizing>
                  <Height>14mm</Height>
                  <Width>60mm</Width>
                  <Visibility>
                    <Hidden>=iif(First(Fields!CompanyLogoPosition.Value, "DataSet_Result")=2,false,true)</Hidden>
                  </Visibility>
                  <Style>
                    <Border>
                      <Style>None</Style>
                    </Border>
                  </Style>
                </Image>
                <Line Name="Line2">
                  <Height>0cm</Height>
                  <Width>6cm</Width>
                  <ZIndex>1</ZIndex>
                  <Visibility>
                    <Hidden>true</Hidden>
                  </Visibility>
                  <Style>
                    <Border>
                      <Style>Solid</Style>
                    </Border>
                  </Style>
                </Line>
              </ReportItems>
              <KeepTogether>true</KeepTogether>
              <Left>6cm</Left>
              <Height>3cm</Height>
              <Width>6cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Rectangle>
            <Textbox Name="Page_Lbl">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!Page_Lbl.Value, "DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                    <TextRun>
                      <Value xml:space="preserve"> </Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                    <TextRun>
                      <Value>=Globals!PageNumber</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                    <TextRun>
                      <Value> / </Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                    <TextRun>
                      <Value>=Globals!TotalPages</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <rd:DefaultName>Page_Lbl</rd:DefaultName>
              <Top>3.35278cm</Top>
              <Left>13.44125cm</Left>
              <Height>11pt</Height>
              <Width>4.9cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <PaddingLeft>5pt</PaddingLeft>
                <PaddingRight>5pt</PaddingRight>
              </Style>
            </Textbox>
          </ReportItems>
          <Style>
            <Border>
              <Style>None</Style>
            </Border>
          </Style>
        </PageHeader>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <LeftMargin>1.9cm</LeftMargin>
        <RightMargin>0.4cm</RightMargin>
        <TopMargin>0.4cm</TopMargin>
        <BottomMargin>1cm</BottomMargin>
        <ColumnSpacing>1.27cm</ColumnSpacing>
        <Style />
      </Page>
    </ReportSection>
  </ReportSections>
  <Code>Public Function BlankZero(ByVal Value As Decimal)
    if Value = 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankPos(ByVal Value As Decimal)
    if Value &gt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankZeroAndPos(ByVal Value As Decimal)
    if Value &gt;= 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNeg(ByVal Value As Decimal)
    if Value &lt; 0 then
        Return ""
    end if
    Return Value
End Function

Public Function BlankNegAndZero(ByVal Value As Decimal)
    if Value &lt;= 0 then
        Return ""
    end if
    Return Value
End Function
</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>0eeb6585-38ae-40f1-885b-8d50088d51b4</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
  WORDLAYOUT
  {
    UEsDBBQABgAIAAAAIQDerW2v5gEAAGEMAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzJfLbtswEEX3BfoPAreBRSeLoigsZ5HHMg1QF+iWJg==
    RzIRvkCO4/jvS0q2WiRyJFRVko0Bibz3nvHI1Hhx+aRV9gg+SGsKcp7PSQaGWyFNVZCfq9vZV5IFZEYwZQ0UZA+BXC4/f1qs9g5CFtUmFGSD6L5RGvgGNAu5dWDiSmm9ZhgvfQ==
    RR3jD6wCejGff6HcGgSDM0weZLm4hpJtFWY3T/F2Q+JMRbKrZl+KKojUSZ/u007FWppOxdY8GLszJ1QeVHgmY84pyRnGdfpoxLNqZodK8qis94SNdOEsbjiRkFZOBxx032MLvA==
    FJDdM493TMdddGe9oMLyrY7K/HWbDk5blpJDq09uzlsOIcTeapW3K5pJc+Tv4uDbgFb/0opKBH3vrQvno3Fa0+QHHiW03+FAhou3Zqj7EXCvIPz/bjS+/fGAGAVTABycexF2sA==
    /jEZxV/mvSCltWgsTtGN1roXAoyYiOHo3IuwASbAj/9JviBojAf1YZL8xnhg/eOPg3H1T5A/sP4yRq7YWsEUBAfrXohK2RCY37/FC+uYNRzqnU/tPxzvf3y3LB/mHG+JPsSDjA==
    cYSF5nP8kVbbvBYZd9bDTByJ/T+UfZxFk3rmBk0xbWK0Hl0fpDFXgOjIpvUfhOVvAAAA//8DAFBLAwQUAAYACAAAACEAHpEat+8AAABOAgAACwAIAl9yZWxzLy5yZWxzIKIEAg==
    KKAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAKySwWrDMAxA74P9g9G9UdrBGKNOL2PQ2xjZBwhbSUwT29hq1/79PNjYAl3pYUfL0tOT0HpznEZ14JRd8BqWVQ2KvQnW+V7DW/u8eACVhbylMXjWcA==
    4gyb5vZm/cojSSnKg4tZFYrPGgaR+IiYzcAT5SpE9uWnC2kiKc/UYySzo55xVdf3mH4zoJkx1dZqSFt7B6o9Rb6GHbrOGX4KZj+xlzMtkI/C3rJdxFTqk7gyjWop9SwabDAvJQ==
    nJFirAoa8LzR6nqjv6fFiYUsCaEJiS/7fGZcElr+54rmGT827yFZtF/hbxucXUHzAQAA//8DAFBLAwQUAAYACAAAACEABbiHenQBAABzCAAAHAAIAXdvcmQvX3JlbHMvZG9jdQ==
    bWVudC54bWwucmVscyCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC8lstOwzAQRfdI/EPkPXFSoDzUtBuE1A==
    LRSJrRtPHiK2I3sK5O8xhKRuKRYLl+VcJ3OP5k6szBbvooleQZtayYykcUIikLnitSwz8rS6P7smkUEmOWuUhIx0YMhifnoye4CGoX3JVHVrIttFmoxUiO0tpSavQDATqxakPQ==
    KZQWDG2pS9qy/IWVQCdJMqXa7UHmOz2jJc+IXnLrv+pa+EtvVRR1Dncq3wiQeMCC1sJ624ZMl4AZEcBr1otp3MqS0MMM6XlIiEJJXLF144CMUmy7/UYRFMJg19goR4K+9tlfhQ==
    tAfJpUIXYFB8COkkbA7WT7shfNYTH0BQ/3xjUIln6zYixPFWpTWC8NKk/02T+mimobPZW5BR8o4k6EwqYNzdkL72ZnIZ0v8N1o+AaO9iZw6O6J1EUBK07zr31VfZi96dSJPjfw==
    sF6Ai6B35o8sBsWHcHP8jfRnEHQGZaOMYbobntmiDCeUfx8NUHTnV2H+AQAA//8DAFBLAwQUAAYACABkb3RKwbXjETwZAABZNQEAEQAAAHdvcmQvZG9jdW1lbnQueG1s7V3Zcg==
    40h2/RUF/TBPbOa+KKZ6Amt3jaur5aqaHjscjg6IhES6SIIBQFtPzJf5wZ/kX3AmFhIgQQqkQAqQWBElYk1k3nvP3XL7v//53z//5XE2vbj3w2gSzD/04A+gd+HPh8FoMr/90A==
    u4tv+qJ3EcXefORNg7n/offkR72//Pjnh8tRMLyb+fP4QhUwjy69D71xHC8uB4NoOPZnXvRDsPDn6t5NEM68WJ2Gt4NR6D2ogmfTAQKADWbeZN7L3l9MhgeUoN6K70I/L8SDZA==
    o5DZZBgGUXAT/zAMZoPg5mYy9PNiVCEQlKrxsNisRmUJD0E4Sl/XR4swGPpRpIq0vPm9F+XFDR/3rg8ZDMdeGPuPqzLg3oXQgRyIzYLQAQWpFiK4WRTeuyg20LXaKGh/jumCVA==
    rTZKooeVVNE4dlhJaLMkflhJeLMkcVhJG+I0q4WzmRd+v1v0VcELL55cT6aT+CmBXF5MoLRDOL/Miugv66JfuUzrkv3kb4R1vpu+Yme6JQV56E9VHYJ5NJ4slsiaHVqaujnOCw==
    ud/ViPvZdKUV6iqWbWrBTtmyKvAAZbe7RAhqcEQXsXyjThXK36xS3A+HkaZAXFgTuHkBaKMAFvn7FUGzIgbR02wFjYfF7cu4/FMY3C1WpU1eVtrH+fdlWfP9GphJS1GCo5dV5g==
    69hbKCjPhpcfb+dB6F1PVY0U7y8U+y4SDlxolPS0a3AdjJ70b3w9zX6uwuzga/w0VU9e3nvTD71vupSfwokSyUF2/+/qnhJMCoByRNSVp4X6zGIYr54wVbWUu5KcBYu8qLlyTg==
    9AvDYBooRePdxYE+jf740EsKihbe0E+Ok3Km/k184KvXQRwHswNfDie340M/PJlHk5H/84ve/u2gtwcbhL+eWv50+osXFoj5kL2a8mz06K21ufr+YL00dfYpCL7nFQXESN66mQ==
    hFH8JVCFQH069bKz1U0rmN7N5oX7+YXkkXnws6m82OXZb+kZLFRiKaRaJPXhrfpVhaR1JwjhrEWl61QKXCgkfzcO1W3lVY++XCn6AoAAcXFSteSivmQRTMDy0rewcC0tIa3Q0A==
    m8dfF8oAZxAIf/aLUoTkiknZG9Eozn7S8+zydSbAVpQ9n133phMvyov7l8/e/eXF4GffU8weWHeREnY/NEajUOkBmMPQuy0//zWJEMLR71+9qR/9/nF+H2hlArF2GFL5G+Vv9A==
    MWEMc4R4dmsxVbI2Dqbqg1lgcaU8lvxxy7Fd6mCCIWDENJlpSpsQzoDFDaKO8savl+LFnjmZ6zhGlbQI/ZvJ4y/eYqHOlSZMleI8Ah/+pG3mylaOnuaeOov6c+9eOR6LIIyjwQ==
    jtYN/qT596icpPGH3kAVeKno8XeFlC/Ju/8+m+q2/Cf8r+ReStX8bJ246noCvTgI/Y+xP/tof+j9A0AOXGC7fct1UZ9IG/QFR7hvUMMWiGPEgf3PnC3+Y5xRY8l7deDMR2tykA==
    Y6u3kojSpVw2BuX31bEVzGPlSiVfG6Z/M9gMM9WNAJObqnuwenKxJzCu9CWbEttxlk/Z/o13N43XELPIPlAyMp+Dr0qXJZ5SJigZMSqrUSDT1JsvpXzk9e1/7ZVhE/+4zsCklQ==
    6SPpl7J254RcEm9QxGgJqruwqH3x+VOjUISQQ0kVx2gtLFJsuwZkxJJcEsNiwrENYAvTlcRitsU6jMUycY8KxfSJemCSKTTaCaaHy/8e5ncSK38EiJX5sjfCEqvYNntc3+CiJg==
    UI4gglxiIM4Gt0zc1qD83ZpMdEqT2QiYIEWQMYpAPYsJHCiFgxgWDBGHQpMT4TCGTOYCwVaRQwfBVKZta7B0tpglvrw3i4mbADnFDEsKKTsbzBJtWwPyd2sw8SkNZiNY6kOg4A==
    BDFj4Gwxi8RtDZjOFrPEl/dmMUkjbjFCEgIJ4dlklonbGpS/W5NJTmkyGwFTXxCMKJKkHpjei8VsD5bOFrPEl/dmMWkjFlNAAiiH/Gwxy8RtDcrfrcWkp7SYjYCpDwUmUig4wQ==
    s8ksErc1YDqbzBJfumAyOWnOZLJGUK5UsvaMKamH8ndjM1lrYP5ubSY7pc1sCk3K/8SM1BwX8F5sZnvAdLaZJb68N5vJG0E5Z4gBKiSqBXLmcGYZDNsECkIAEg41mOsCBXmLmg==
    EnYY5GvEbQ3K363J5AeYzJaoSgEwdmVTqnJ/P+CTf+tNf01m7Pz+6XraTAjNoPKuAa2ZddZm34EcQcEIkdQwDOI4huka2EaOQe0Oa4pKGp9cX9S2WYfY1LXGrSOxGnzhlo8ncw==
    wPMpQ4qlkR/e+70fL0qlvlDMG0m5YowggBCJWhLuGi5zTAYhQQ6xBTBt6Lo2dzBnhgGA8ZYk/M1Kdx3JXjc9XXYaRRNAoRwSRoGo5zNa0kKWCaXyFiURNjRtgyGDStN2qWvxLg==
    B4ZrtD37jK/tM4ru+oxNhtdVGkv/pBOu1ypum1hCXKp4uZbPVDy7U6h4lFZUPevdxH64mkmYq68/liY3VyHRH6tJhtnFnM3lRj28YNp4YX5xOqM5v3+eNN6KSeOfvKfgLl7ySA==
    KXy/wMSDppRTxjefGKyX19ZJ5YgSmbWpmeuDh+pJ6JsIT70VzlWwxntVPkdNFb3DNfmP4C784t/4oT9vMk7VlxFWTa6X0cIISdOB0ACEYPVjcGERx5aScIdB2l3vZIO8rXFPEg==
    aawC5bplbcAWlY2oppBiUd4/qLTNdDL3P91Pl9Df7aJIQSkF+7koG3w4bldQIkRXSqkGc1NV7ntzwCKKcVAKWK8/yAHSRdh2iBInYhBuMuYQpHPFLjCIFN0FVhWFz9h6FWxVsQ==
    ogF4vdy22Xe+7cUNWjVEISNS1oy5iYskJcyQ0kQkCbwNBgwLKZuGhTQ6bNUKhD1j7lUwV+BAK6B25T3p5fu++eEssv1oGE4WejnApqAHJSYMCVZztqfk3CBAGTqH6b/UZLakjA==
    UctGpgky29lJ5O2gc7uRqB/IAr3nFxtLn3yz4N3BxObGT7g2tvCKJAcEl3WjxkYAzhDABCnvthbAscsYAVI1x7UIMoAQ6gBIqHBPocE7DPASZdsN6e1p2Gdlrz5oq6X68NjvZA==
    cd9nb9YIMvoISIwVY2U924eVj4ogVnCyHMIlMA3OKBfUhMThjJndhcYacc/gaAIca0Q9Ljwyr7URg8EBhghjgmuhAriGowIvCYEDiUEdw7GZIy3AHdPlNu4wKjKantHQBBoyYg==
    HhcFW9y/RowFgVLqhZnrTb6gxDIsyoBBDJOoV00CgUklAUL/2h0eH7aFxu1GSUMxUhuBtYUfzYU7lnJ7DHikcOdX3UH6OWgwkcgYFlAFPPUGuSEuMCImJ5ZLkB4oziwsDYNJhw==
    Sot32HgVCNtuaG7H2bOCd+oExSIMghsnDJdtiBb+dKoYGOYr9FdDJwVqgSMlcG4rV5F3+f1mQ6nxZKFVxi9+PA5GR8gp9pPZE4AloxNqJRUZs5X7CAlQ7zEgXQYFAq6STMM1UQ==
    h1G4k9RnXLYClzt59LpIzWz70YCKBFa8Z7xmr5uJXEd5KKYNEDFsqGykRaTjUORQE9lWd2G6i85nlLYCpbtY1AqQHmGoF2CECMJJvcy9TV1sU9MWhKqoE1uCQoMZRHnlApuG2Q==
    /ZCzQ6O9Go033yaSt48ZawLBr9N5l7n4jWRhBeNcQibqjfO0Dde2EACIEYMwnsSwpilN7nDX4NDtLvgzmrYb711JFmXEbMXAlq1+dzPGkwlERTJTqAZ8LMGFhITZLjSIzaVp2Q==
    EApAle1EwCIdtp1bqXwGVCOdfNvI2wqIbXOaG0EYphIQjGS96cSOYULiMsegxCQ2doUwpStsJkzMoWN2eJrkNiKfAdZg90ar8dXweC3IOSQI1MMVwgYyDAtaynQRZfEMbAghLA==
    ywGWqxzBDs9DWCduu/H09nsYDx/otU8wJiCXLigHYwRyw3R2TdO7zvi3mnmbo6c081asta2QCVV4A7TuJnEZqa9WD/3eh4ISADEhoBpykJ4OdBcv8xd1hYxbxUIrGDWRbDmxAQ==
    K4tQhVQ9hx4MXQsV8yVDXcfH+M6bZpPUsyzHC4Rvr2zKyyU99VQ3GHuCzOkh9X5eKxX33uCSIsFrLtz0hqF75Q2/e7f+t1D9qno10vl/hm59qVxB+oiCr81xBZubc4cbru8O7w==
    +dNk7g/+Glw3OPwHQyEghLxmj8kBuqALnrMmbH68pG+73ecqlbA3+hmBwjXqo78unPfu7yhU5KVme8m/I5jq15pmthdTs4cbZuo6gY4Vn6x0E6MIUc7ROcJYd0Tfr4tSz/Ov8A==
    3U/nt9d3xBFgUEAJZb2dLt+whG94aO9XwveQpWr3+QB/uBWp4ZVz28hAPYoIF7jmtuvvxq99lz5t885rwdM8e5kHkbnKndQ/6VqOe4wgUkj4Xujl0hIfNaFAMBGEgeWA/FMa0g==
    w/FeTYwX4F01W1XZ92LVyK/+UBe6D/q3O/d9zJAEhKCao7V2KGjMtvo+63XXJHhJ/feUw6qLzYzVQRwCxUZ8PM+xq+K+497Jjd+zS8Wkfl+FdnU5kNju7e/bVTS72rvb0u24xw==
    5YeqlXefW1n3CEu6wnSx4o4u6SqX65KWV2hFTFRdhwDBqusS8KrLTIDKUjCjlY+jyseVMFaWwgQqtHNzFdma60mnOSFsAN2ItISMZmsr3+d7jQweDln5PgkwNO51elAdN5VD1w==
    g08II7TePHcpqA0NYVnAlcSFSEKDIwsSB2JsO9YWW9YFbVwMNtbI3JawIwFblQddWHe6vPZ2pAg83baKdVLYxirWxcLujenkdp4Xlhb9TDKh+eXXd0xeKKQQKmuxl+1ZY3oDWQ==
    hefQXJrW1CCkISUUSylqdpG/D0xXEbstwE7N5RnZR0J2FetPAO98rHi6vGiD+O4LrJd5F/yM7xW+K6ndFoCnfu8Z4EcCeCXvT4Dwf7vz5vEkfmoU3XpjQkgRrbmWxrsA9wah2w==
    AuwkcD3jujifeK+Nkg9B+4YwHID0LexMEg5ndm6q6RJV91eUf5tP1JON7t9KEQRcInz2gVZqskTmtqjINFt3BtVJdWRJEhrUj+isH4+hH38zvl0N42aTQErHIaIM2llBrhTkGg==
    nduiIpMeijOsTqoh10ThBNGi/mPMgrt5w0CnGCGsM75noPvF4zVatwXsab/jKdG+9xCrs4JQuqBChPZWEtnQsM1e5ZrLUtXoVYaFXuz8kcO7Dwv7Bb9I6LaLSb257tl6XLXEpA==
    /v7My/EBxUk4CJRYv8Wje0nPzZmo+xG1Vrb8TNT9iFonU3mm6X40rZMuPNN0T/DXSRedibqnoNbI25xpuh9N6wTtZ5ruCf46sVFTRD0gMHpjfFiGJ7vXhrhWpZaCo2cyHY1kNQ==
    VOiNKOH5OOJuzGBJW/+CJMMeM1ZKfMrHhfdWHCtdKohB8f3d80WekYIVs1RrBABiKYfP7CvAiaU3KCXctoly9U0LUwvplcuxbQi4ZfuPPefDNE+dA0N4CRjm1s4QHqHlNqvbBg==
    hr8MkMVx4830vgKMoGI4q8dxy8EGMrFpu8QhrmkalmlBdap3EaTCfiM5xwKRj5prLMhDYvWWYuTqzT0S8zX2Z76VWcThUAkwXV7+Olb1/9Az3T0kf4980kst5PZJRc0uclhg1g==
    CVL/6yNQmwEh0RvaUgLrgRC52DT0OqPANohBqMAu4IQ4hhY8YMi3AcJ1Srcl61+dKOwKWtapegLIbIzpbAIzCGEoJCD11tp9H11lG4RuC2Sq08BdgcwGWU+AmdLIyCbwggWSQA==
    spqb4AIXYi64S4CwiAOwcB3DcTnEjmSG0eXdNbeORW4LViqz+12BSomiJ4CJHhz3680vvhfdhY3AhGCmoiEh6sGEOzbHjmPatuEQizumUAYJEYldzLl0Oryv3vpY1CWR2wKTyg==
    DpuuwKRE0RPBJBlD2gREOMeYEYnqDVKCrsQA24CaAhKALOm4mHGbICFcbMEOL/pROVy7LfCo7nvrEj4Scp4AG/qPPYmGenjQlR8Okx3ZH+PGHC8IieCUkHrrC1muRQQzsClsSQ==
    mKMMka2ifAvakEAobP424LKL5m1BUGVHa1cAtIvAJ8BUYURuIxBigkgCCMf1eiUkF8JUxsYRNhEWFBwgZJoq3Ec2gMYbMTkFGrcFMpX96F2BTIGeJ7I6hSGpzWSRVYgvJJU15w==
    iWBbBfi2RSyX2MRmVNrCBMy0qGkBZYbekKkpELotUNk+POLUW1Gd0CIV+LA3xLIBDtvvbpn9drTR2hVdvSftXTt49P3nIFt8fwnw+qN6jtT38SptOVJS+lXacpyk4as05TiJnQ==
    15Gw4wThr8OWo4RDr9KU47ipryNhrXEjjtn8zPY3OZYq9SK/BbE3jRoLU6WAAgIpWZcGOm5S4t0NeuRMUMARqbdO0/sa9Hj2hM+ecJfacvaEX7Upe+TB1g1PaWjlUewzYQJDjA==
    Yb008tsdM7ZO3KoRlxXPtCJxhpisnPuuF4RX8rlc6ACfLvm8B1oaSaXtYtNxU9cbkM0yekdBK0VAKNS9+6Wvt6F1C+3bAtT2hKZtxPAW5nU/LQ4hPgcDXW7LORhoZVO6GAy0ww==
    hTsnZo+fmD0nl8725GxPutSULtqTXQn+yrw+gpSp/+977+U0uiidpdGH8zicfpwPp78Z3/Tg0MYCx50phLQ2g+3VODR3sBauNp1J0i8eZ1XPI4JuYzv3XaCrxtMq6q25HXU1KA==
    4x+3c7wU9G77zn47V++tKQhk8r3vYltHUbRASZxMQXRged/26I6qRXxfRaM0rk1WKbYtm8JX129nGn3mTeaKdmnlX2L1SttNEc4hwLRe99Zb1WIVxH29/bZTLFKHoHSX511YXA==
    e6qAxexOAYvffX/xealJV+vLXfs3qo1KFJJystXmlks7HYLRsLIp6+/VSXlXMKY63V1t0kt7mJdp9Ywq2598EFXSL1/Ra7lcH8xBWFyuD7JeFSnT5j1U7VVeUqzfvOupr7ewzg==
    Za/GXuZt3E8cAihZ4en8oS3acz+iPjvBxvUbmlNDASIII9qpMX1LCpxmKF+VCmyIzYUFf4QkEBHeopUJK3tDw4utaj5NemYrh+5yPFPoPON5FhZPnU/y/Uem/k28ebXspK6uhw==
    xUxrfnlrdLrnHDclgPmv5SWjFZpydPoIUIwkEazepOq3OzYgo+/aaYHcr+f6NNAb/yJ7u+G6EIENzvaftVYmaH2XpdxHsl8P/SrYKNETItUEu0TP8qUiPbM7WyO45KRq77Otyg==
    O3RVPTXdvWg4mXzoWUoDXIcT/fGxMY/KV3zlURjRxCtdHCrgfJvM/Ojis/9w8SWYefOMo6X1L5WSBFbVUshLAbhbj7jrOgdX3pNeyyvFlnZGw9s7faEJvSQJoIwJ2KmFjrcTpA==
    dc5DZ+SvaKqgsjeMYlJvuRzCqWMgjE0mLIIpENShqirMch0G3G3L5TTgt+xh3LdJTH7jqx/eK8n8FNwGjVh7AQhkkC7zGtE4eFCfvZoOfx5lbekwztbuF4j3Ytu9mAzju9A/2A==
    fFeYm+3mu2BuipidB1c6A7c1SVAEapUNHoWeZrY6XFxO5lNljy9Gkyj+lgSm+shcHn1aHuna95JXlMVWLbsYPmqvWgD1r3cxfNInXAqWSZR67OZGwcZJH07n1cTJXx3+Kxj2Lg==
    rvOD9AUN2/BikkbESoiUm36VURvmzww/3/8UeovxZOiG6gndHk/FyKsrn4Lh9+gilU7V/HEcLy4Hg2g49mde9EOw8Ofq3k0QzrxYnYa3g4wYs+kAASWNOp+ivh5YY0VX34gWqg==
    DasQfXcFXvrZQlG2At/FXTg5oKhMQlVp6kjLa1YtdfTi0ub3iiO6zfpEkSLjF1jnVxpD5A+lr3i6Bil7Ksi7vBSGwcNYoTxaUr1czGCjHtfTycKdTKcXYRD/fRKPv449HeLBhA==
    nvrmRXjpz659VdHw40gkl5UMf4ri7Cgl9D+QMACQyOxbyjz0CeBO35CE9zlwOFGuLrSg9U/9NiSXd5GWNG9qLyY51yHZIO9SK/4wDGaD4OZGK72MwIq8EGTiVpx3ltQo/03qOA==
    SFuhKxuFwy+KYhpOfZkCqi95Aqk+1Ib0OrswSJ6OQz8ejpdEzAmVki1S7unF9cMvwShPful3Hm/Cmf5Vlb14TCr1lFctpdVO2A9WBSzCKP7JVxGyPlCUV9VOPuDdq0Zlz+bP6A==
    6/Mg4WHynem8fGWQX6piG8WMKLaxvmHYvE+ILfqmqY4sy5EEQ0aos2RbNPZGwcOv19FQSemoAc5t4VhO3+xQ/U/uF8BdPE81S6qJEz29VNC1srjNuxnJulZ/Cxvaix5KITGCog==
    XmJBmVwuuQUMZkNiSmgAbDHXtjCmiAETVXtrb89byXnw2h0ta8GwvoQINUHdFMQeIXNFdmLLPj1lf+j5nEM1affKO+w1FyBS2u4q3JOQXxNbWNoTZZwI0Bf/xg/9+dBfpS9T+g==
    KsV/OUnNWh4K3QRBXO+N5cYI2z6S9GgUX4DPfGPjBZQj/vbrH1kaFmbj/cbJWAAs0359bYKWwdztL17StRwsPvQoS/eD0knV5Vmael2e6vxsMkkiGQyQtmZ5M63r8vT2Li7tFg==
    pUJUrSqzEQQc5Evfx5N46l/dZpFQMNQ9LfpTSkNfTZRN/dDDbCmaKbeTw+tg9JSq8GCYgPvH/wdQSwMEFAAGAAgAZG90SlYTtIWyBwAAdyYAABAAAAB3b3JkL2hlYWRlcjIueA==
    bWztWutu47gVfhVB/bFAAY+utmRjnIWvmaBJajjZC9AWA1qibXUkUSDp2y72yfqjj9RX6CElynbkSW3FnXY6/ZGIt/OdO3VE+h9/+/v777dJrK0xZRFJu7r1ztQ1nAYkjNJFVw==
    X/F5w9c1xlEaopikuKvvMNO/v3m/6SxDqgFtyjqoqy85zzqGwYIlThB7RzKcwtyc0ARx6NKFEVK0AcwkNmzTbBkJilK9oM+ioAYCUPEVxQoEWW4FJIkCShiZ83cBSQwyn0cBVg==
    MABimUdibLKqGCcRNoSGObloZZQEmDGAHKB0jZiCC7YXy+MawRJRjrd7DOtikKbRNvwqkF0DCDS0rSqUczFUyxBSVYAu95gAAqkqSM16SCeUa9VDsqtIXj0kp4rk10OqhFNyVg==
    niWIflplDQDOEI9mURzxnUw5BUNgY6Bpp4BolLIIkk4uS/FQFPQcvjnJkASrBKc8T3KKY5CBpGwZZWVmJXXRYHKpQNavKbFO4v2ucO7G8rltYZi7ZQ9YY7N7HdEyz/CIgCgpzg==
    EeGY56mNe1PPNAfGtc5MXAVgVwBaDF8G0SwgDLZL9qmxyRZv8/ItJatsjxa9De0u/VRipZcpWETLYQSztwnztEQZpHISdO4WKaFoFoNE4HsN3KdJD2giS3RRFfBZXDwmtGg88Q==
    XQwrOmsUd/VnQX1LIwhFo5j/CeYgIJumCbUHjOwygM8Cvl/RB3GgQpE9kimoFOoRQRCQmMAGg1aciC77patLIJahAMu2xInxnNcknRHOSVKTmEaLZV3GUcqiEH94E/WPtaiNig==
    4WfxAMfxA6IHxtwUpLnPwi16ofPpeeMlGvTuCfmkBDXdnqSaR5TxKQEQS3RjVPT2kwMSr5L0YF4NyCUp+dCHwrXs/Zj3rAMhyiAVISmaC3gCSBGSba9daHQ07tq2dwCiaDmFaQ==
    KKTDKbA0B67jmlIwMfRMxZjn2aOelydKkP8vJAiKLLDbdruaBcZ+ZaZ4TCSibbpjp+RygvGkOjQd4jlaxVzM+KbjjNtSoqxgcJyvEY+xkqFYwUJePPI+iiPEFMHvHtG6oxkfMA==
    gsgx1PtXwny8n8UqqdHimOBJfmLQ8OMTijH7eJeuidiSLEeUHXk0h4qiYbuOZzcd3y6mshgid0li4Ci6IQkmUPeo5W5/2Oy1rL7VH/Tdpun65tgc2r1mrz8yx67ZL7V7gYI46g==
    R6n4EAKkjOJ5tH1AWQZ92E/zrTVlZvc78ebdv3HDXYqgxxopWkP5khHKmfGKdsZ3wi1bKLWWXd0AwA7Y4yfIu6mk/TmJhS5/sv4i53Kzql7FujAhM5kTiu84Tu6GXf1X0/KExg==
    48ZgPLYbbntoNnzPdhpggaFve47tmcPflF/wlhfmKN0LjVEaTmi+AnoDknLgKi1PCZmPKC0jlmWQ1qAuVds3PTdeJfubikoy9qVA9PMMQT59L3Ypn1HG6mVSiBen2g7B8QzTNQ==
    1m+0F6LUSINHco34d1t+yzGhyP9/+BdW/d+J+0dyjYAX7qwZokPE8VU2acdvubbl+O5ZUdofuP220+73TL8HQWn1/JHtuO2RaY4d0x8Pvv4oFYb98nFauzA4iM6ThcHTasZP1A==
    BhcnhtNy3WbrRRYIW12aB9kr2/8XLpqObAPk+ZrZgBWiyoFa9dQELa5WRnltKG+9VrP9jb9GlE2//peI0uS/qGZ6WTRdBHo6ceDbLw4HSySgitazVGuGF+JsyrgyN/iM5vRZ+A==
    9rSKk97tSNP+/HutR9EsCmTzYTS9HY3/OH3oPUsLlBhfxhIMZ4iqF3mFocAeOtZ4YJ/AFh/KExEwx4z4jfUFPYn3sXk5r8/5yfgGYvHxhwcRjk/fQDza/7F4VNX1v6+4yl9QLw==
    yodTxUNZ96jjpNOHSqZnnXeodPVS6EiTvwZqWB4QnqHfRcXRQNxYpbuJuhi+RonUNG2v6fjFzFdQzRwb4c01TXHLfklZc+oU9MDPB+kszmzT0j0hagz/IKTFiPEei1A5dJSixQ==
    zRg0M9jG4ijFWhgx/iyPeUWrX7buy9Y0PwTOLLeD0mBJ6J04CG557aE/ahYTOIy4GG72fdvv5fcZWQf2SNBLE7f5ttUy5SVFsANiCH3ZMfJl8zkO+ChfHEtuXP6n8v+sq7ecZg==
    uVrU1lSLgJmtaxAbkJWFwzRbrQke17cUZcsoGFNYIZRHncXByD0JPrE3/wQjJbDNpQvcg6Iw4PvT8dcFeCvbAyj41kPailYvzM7/CcjNe2iJUL3KD0pytHQNHhE6iw6YovCX+Q==
    0l+5vdQiQaKJfQHTqby6XuMpZtEv8l5FKA0Lc7+dsHs5RCnZLCGrWemOQ/yieyTgLI6ycRTHgoVoa7SDkxkGgSHSLckZAvme8aKVG/xXiHPTbNv9xqBpDhqu6Y0avbbrNTxz5A==
    ufCNZw2swW+CGtJjxUTEoXiYRVf4yU1+0ZMrJyVSTymjkWshhIU6BfNgKZpzUHAKxiqIyhnj2AKix+Dtoc02DyTExU2XANjOaSKeIJa2lex3SojcKq9mubEHyCjjt5gkmmiAjQ==
    QSjJAK1B/GKtWiPGUyJEy/nE6fGIkQ8ZSuyiCX9y7iBLDvt5iub7n9wdy22xrFE+fzBY1AviQdUl1r8oA2pWL5U6ZRnSm38CUEsDBBQABgAIAGRvdErkeQ7zvQQAAM4TAAAQAA==
    AAB3b3JkL2Zvb3RlcjEueG1s7Vdbb9s2FP4rhvbQJ4e62JZs1C0SKW6CtUUQF+2AYSgYibaFSKRA0rcM+2V72E/aX9iRRMoX2Z4jY9hLX2wd8ZzvXD+S+vvPv96+X6VJa0G4iA==
    GR0a1pVptAgNWRTT6dCYy0nbM1pCYhrhhFEyNNZEGO/fvV0OJpK3wJaKwTILh8ZMymyAkAhnJMXiKo1DzgSbyKuQpYhNJnFI0JLxCNmmZRZPGWchEQIc+ZgusDAUXLg6Dy3ieA==
    CcY5YAeFM8wlWW0wrFeDdFEfeXUguwEQZGhbdSjn1VA9lEdVA+o0AoKoakjdZkgHkus1Q7LrSG4zJKeO5DVDqo1TWh9wlhEKixPGUyxB5FOUYv48z9oAnGEZP8VJLNeAafY0DA==
    A0ZxOlAQ7SqW3GRQxqL+tAU/x29pErBwnhIqC4+IkwRiYFTM4qxiVtoUDRZnGmRxKolFmhjVrmCdOabHtoWgbMsG8JzwVS/TpIz8NKJlntGRHKKyOCeEXZ86khTHdOO4UWm2ig==
    a51JXA1g1wB6grwOoqsgkFinG2oss+llXf7A2TzboMWXod3T5wqLvi5BNS3bEywuC2Y8wxlQOQ0H91PKOH5KICLofQva1yo60MpZYuTHqXxK1N8DVw9juU5AY7DAydD4klt/4A==
    MYwiUuvfYA0GsmuacGjDm3UG8FkoNxo+SZJxhkOIpdS1rI1mtMIbzRsIHC4BhcQy7ZTCkZ8bhCxhsBXhuWS5KF6GRuFSADYpnguchExkQ9MnJiVLGxrzeDpr6jimIo7I3UXWXw==
    G1mjWuHLhn3CfKuYS2W63zOdcz4APbeugfbxQPrI2LMO1excF7iTmAv5yPLZyMUEK2mz6LNkntKtdf2iUKHs7gZuh5X0tZSsrSCqgc7HN3+cwj+AqJE07fyErLS1ElwvIUso7w==
    4wOU0jT7nt3vFk6Kl/krK7D8W1u/+lKo+R2nY1olpXjpOcRUjjM4jdW08zuyPTC27b6SMWiDLcPyV0uKk52+69U5ibY0/wu6/yDxDxL/PyTud/vdkxzeouYxuopIqr/Sl2JYgg==
    CyoW+Ua4Hfys/ah1nMRYaIWfPuPFoIXuCIZ+ID+/idP1RzLFwC4sSX6j1XTB012jcfGRy6PvY5wQ8f2eLlh+tluO2p1gTiJt0bZNF3hodyy1lCUwEzOWgNdcjFj4AB8QWj1wOw==
    ju3cdm89Z9QJbvybvuXYfdfxRr7pup1rndE+Cpb4JqZRuRdlnEzi1SecZSDDxaS8o1BhDt/kV9jN1TVaUwySaFO8gO+AjHEp0Ins0Ju8JSv4ZpkNDQSAA6jHN5jox8L2lzTJcw==
    +dX6rVgrS6ulgxWGxYInknFyD6/ug6Hxu2m55sgMRm1/NLLbnX5gtj3XdtrX3evAs13Hds3gD90bspKqJNU0wMMtjR54qQGSz6gEZyc24cM75dYmnB2fzofiyDF7jutXR05AJg==
    eJ7IvbHNFNbO9v2ZqUNEE10l8aIVLD1U4sUXey/1bKMKfO8oHHlOt19eG88kiXx3sFNFMUq90p0qjy59VWOk6FmcfJrltRLunsf/UkKlfEEJvUMl9A6WcD+3I0mU5d1No8jMvA==
    NV1rtJPZntZWZkr5aGYjxiThR9OyD6Vln05rAgn9A1BLAwQUAAYACABkb3RKL9Y+feAFAACOHwAAEAAAAHdvcmQvaGVhZGVyMS54bWztWG1v2zYQ/iuG9qHAAFeiJEu2UadwJA==
    Ow3QZEaStQO2oaAl2tYqiQLJOM6G/bJ92E/aX9hREuUXOZnsJAWG9ovFt3t4d7yHd+Y/f/395u0qiVtLwnhE04GGXhtai6QBDaN0PtBuxazd1Vpc4DTEMU3JQLsnXHt78uauvw==
    CFkLZFPev8uCgbYQIuvrOg8WJMH8dRIFjHI6E68Dmuh0NosCot9RFuqmgYy8lTEaEM5hIw+nS8y1Ei5YNUMLGb4DYQlo68ECM0FWawx0MEhH7+ndOpB5BBBYaKI6lHUwlKNLrQ==
    akD2UUCgVQ2pcxzSHuOc45DMOpJ7HJJVR+oeh1QLp6Qe4DQjKUzOKEuwgC6b6wlmn2+zNgBnWETTKI7EPWAajoKhwCiW9kuIdqWLFOkXupQfJcGa7FuI+DS4TUgq8h11RmLQgQ==
    pnwRZRWzkmPRYHKhQJaPGbFMYq26FVDDMH3oWvCLY1kDNlG/PMskLjR/HBEZDU5EQlQSTVTY3lNpkuAoXW98lGs2nIsaElcBmDUAh5PDIDolhM7vkzU17rL50075jNHbbI0WPQ==
    De08/VxhpYcZWEbLZgTzpylzvcAZUDkJ+ufzlDI8jUEjOPsWHF8rP4GWZIkm06mYxuVnwsrGtbiPYUV/ieOBdiOlz1gEoaiX8x9hDgKyYxiQtGHkPgP4LBDrFaegDqT2vEczBQ==
    lUIilwIBjSlcMPhWUNnlvw+0HIhnOCB5O8eJyUwcKTqlQtDkSGEWzRfHbhylPArJuydJfzhKWq85fhp7JI4vMNtw5l0pWpxZuMI7Nu+f13fRoPee0s9KUcMe5lKziHFxRQEEyQ==
    bozL3nrSo/Ftkm7Mq4F8SUrfnULFV/U+FD20oUQVpDIkZXMOXwApQ7Ln9kqLtsZt03Q3QJSsYDANFWh4BVsanm3ZRq6YHLphcsx1zdHQLYgSFL+lBkHJArNn9uos0NcrM7XHhA==
    1XfZs/FkzyqfzPBtLORM17CscS/XKCs2YOVni7bXglGZcApd8iV6JcFDUX4OQ7jr4zjCXK347hIv+y39HcEQc7rK3DeRiMmn99NYXQd4vi1wnVf1LPx0jWPCP52nSyovM2TJgg==
    peBBqCQQQl3kmmZHUSSLIeYXNIYdZTekwQQqJrW82xkj1+/2nO7Qsf2hM7THjuMNh17P6JnI8pU1uyhY4NMolf89ACljZBatLnCWQR9u4uJSTrkxeCVz9jpXh/cphh5vp3gJhQ==
    T0aZ4Poj1umv5IGuoEhbDDQdAPvgj4/A2Ktc9qcklrb8jH7N5wq3ql7NuzCR3wGCMnIuSHLuD7Q/DOQaY8Mft73x2GzbPd9od13Tag87Q79rupbpGv6f6lzISpTuqAIBGqM0PA==
    OKw2xaDt0VSAqvlxMUpnI8YqgvAMbhHwEVPZgjWlx2GBKk5qHstJWax5WDWwQ1t7pbJEr0jzUvrK3K9udIhATtiSaCetHaVflLmX9Dko20ZuzzS7HWT1vnG29Os3sjYk6yV9Dg==
    lspo2ceWBhzwsSDPwwLUtTo9w7WcRixwbHd86iHT8g3fHtpet2vaw45h29bI9sce+v+zQHr2RXlQrNgJ6aPrrI1ALqumbCuQL+k1XNbROpbVqkNJZDm23XG0bR5IZx3KhOyRrA==
    dbwf6vXmY36oKD1tVnk+wsgJnj9bGQk5CfVcG3LS115HKq9+eSYeygvTsMfWg8lFnChLXqSs+4/NHyjWdqu1g0AVcTy+nRxncegtsIQqWze5WVMyl+96+jPvFqVcsBt5tvtNnA==
    DM9GrdYv37eGDE+jIG9ejK7ORuMfri6GN7kHKowv4wlOMsxU2q5tKLF9C409cw+2fGSYyIDZrUfML3iSZB2bh+/10DnpX0EsXv54IcPx+ls8vmA8VoWFev8qfndfwQwXNXsFew==
    9kKsyG9lDvktUMP5i2aDmmTLPvlh6pVwS+3Cz8hH3sjc8rPvGIbjb9myPbRpSznTzBYoJCSEtGOgIRvtMUY+BldPZaamhjy+M/ig0YuQnfwLUEsDBBQABgAIAGRvdEqU5XM+yg==
    CAAAP0kAABAAAAB3b3JkL2Zvb3RlcjIueG1s7VzbbttIEv0VQ/swTwr7fjHGGfCaGJMYRhwkCywWAS1RMhGKJEj6lsV+2T7sJ+0vbJEiqWsSWmZsaeAXU83uPt1dVaerukj6fw==
    //nv73/czaKjmyDLwyQ+GeBXaHAUxKNkHMbTk8F1MRmqwVFe+PHYj5I4OBncB/ngj9e/3x5PiuwI+sb58W06OhlcFUV6bBj56CqY+fmrWTjKkjyZFK9GycxIJpNwFBi3STY2CA==
    wqj6lWbJKMhzGMj24xs/H9Rwo7tuaOPMv4XOJSAzRld+VgR3Cwz8YBBuaENtApEdgGCFBG9C0QdDCaOc1QYQ2wkIZrWBxHdD2rI4sRsS2USSuyHRTSS1G9KGOc02DTxJgxgqJw==
    STbzCyhmU2PmZ1+v0yEAp34RXoZRWNwDJhINTAKMyuLjGmLYzqXscjyfS31pemRdxp13cZLR9SyIi2pEIwsimEMS51dh2jJrtisaVF41IDc/WsTNLBq0uwLuaKbf2xacuVoWgA==
    XaZf63IWzWf+Y0SMOmikhGh7dJnC6pjNTGZ+GC8G3kk0S8LFHYnbAJANAJEHD4PgNYSR388W1LhNp4/T8pssuU4XaOHj0E7jry1W/LAF1taybMH54yZzceWnQOXZ6Ph0GieZfw==
    GcGMQPdHoL6jSgNHJUsGpTstLqP6cp7VPy6K+whaHN/40cngY9n7TRaCKRp1/WeoA4PkCIHThjv3KcCno2LRwoLpgGuvSknaQMXgyMsOoyRKYIPxr4ukLObfTgYVUJ76o6D6XQ==
    4UTBpNix62VSFMlsx85ZOL3adeAwzsNx8PZRvT/t1NvYEPxl9M6/T66LVkWT8C5YUqMdRNF7P1sS9W0NPG8+vvPXJAL1RLHNFsY6Xjl2knxtFoKYWeFOwiwvPiQAg8ti5NelRQ==
    pZ1E17N4qb65UTWJk7cWRIRt6dO8hJcm0RpxabLlzylcAaSePee4XlPX++SH942VsSAyBWGBDj/AFJHNKEPVQspbH7PynkaCSrsiXj4u6st8ztn8EvnxtJHb2B86fzbj1PV+FA==
    +nnT4G9n/s3xkfE28EHrhl0GAPH9u2DqA4f9IigdaaNvf7ra6aKKrbPxlws/CvIvp/FNUm4pmJZhw9wax00PrLQQhBOu66o0Asu7SiIYtSyOk9E5xC2tujmTUnkOtRRiFqKauw==
    lLqIMkWItl3drGgdxS98K4zLEwAgpVkA9vreT1Mow3443xrjHJ38VnrOhccc38c+lPJh7N9A+JEmWZEbP1id8VupkjsIla5OBgYAHoM8PgNvPlR9/z6LyrX8A/+zqpuLtiltlQ==
    MFRWbCySLDiFW6fOyeBfCEvkIccb2p5Hhkw7aKgkoUOTm44ikhKJnH83ugnuilokrTXADzcen2fzFlCyk7iAwar2o/nf2tZHP9mPS8u9gGk36mGt5dYI6fet9nzz1gcnmPjXUQ==
    sVRTgaxYcf6ttZ3GnPJvdr52s7FqY9G9GeS8oounKNdzP9WRHsXrrTqqljtvNx+uFkAj9Fa6Rk3MsjZ7NKd/TtZP5scPwTTMi6wKm8+SL+8uo144C9YgtMKiG2e5hUytbMdybQ==
    k3k2tWypsXIcwl3pSU4PnrNbBb0v1MWEb6HuL6JouhLflcICbTVuDuKFKIyDdzdRa0it6rdSVCvOYfK7UHSrSh7M1Aex7m0yC879afBlXu6LbENCNeO4DRZ+zDWqHIqJtLSyMA==
    k7ZpeiYjzOSeIpojWx0u17aI94Viz0KxLZr4tcyqOX1+BYeW/rwYF4gKSRXrRCxTYcfCHtUuQcxhwlTM09zTHlLIFsI6XGJtSveFV1151ZE1v8LDLenr17LPfe+HUe9OTRImmQ==
    xrIT+aSnLG0ji3DqMeRiUxDGpXK0SahrO87hkm9duPtNvbJBnYZZyttsyesYbct9YmuvNFzXXB/HwJWT6dOeDXthNdZCaYG4Fp1ozRmxILQV2KGEuUSZrstdIVxNYGuQrn24tA==
    /p6U95ve27ja0SS7E7i/NMyGdJ8kCm2i3z4IwzBhVArWLY8iJLCFera0EGME25YLPtR1QZcMa6rIwdOlEe0LS3pkSSPUpzyi9eNMsADLRljzTuxgniOZ5VqCaspM5VgInIhlMg==
    R1hIUfeAY8RV2b6QY+15wI5Hr0dQqtbEkzCqCjP74JMSiGrBWLd0BxBPKEtibnuUeUqbFElOkWdR17M0Pvx0RyXX/eZST6etPfZNlRL29vmZ5cdfz/xZL5Eep4JJolC3SM/0OA==
    tqm0XG1zxmxkIWK7nlAS2ZJLlx08+xrR7jcB/7K5izUtPIkjO7XMs77Sh5IgJblWncikLEtSi5ieKxxGiNJKOoTDrkWV7SpHHjyZGsm+kOk5ydRooQcy9fa61sXnU+9jbzl78A==
    P4wR1tGHIWk7noc9EyvEPNM2hcLcNSGQNF2TIH7wtGuF+8K75+Rdq4Yn8WJvwizp7xH0EFPNBceMdXsOZoMHg0MYEdy0GHE4cIsR7UjEmIlM5/DfflyId79J9fIgbIOHC9U95w==
    k7AnTVZxm2lpbtOTQpR6+vt6OksuUn9Ufbazoo7dDqlW5sejq37SrgohrJlo31n/SdIVlYmi8q1OLphDsCIeMzHmHvK0i2zv4DekZfE++ZbUmQ27Hv6ala0zdru3fNB0ivKDow==
    5jMS0HAeZDfB4PXRylC7Grw5GiXXcdHTgwYulRCw8XXLjMJp0jU5dogDztiU0uSE2a7LITYWjLoH/IblNgH/9Wy+XVoXo1/xXrtmPXrJH8JdxgVGnWzU9WxpakvbDIRne8pCjg==
    YEy7EkvX4+Lwt+VSrPsdIf662OJnMeD3Yov+0val9PcuzdEHyzCnAkmNSDeamdThgmhlE2nDEc5UzCWEmxrbxMLIRQdPs0qwLzx7Lp5V4n/CtEZP7wBKrJSiqBuHpOLMdVyMHA==
    mzITKYthKpXjCmGWX4cd/oPmuWj3m0TP8KR5n3k3V9muaYzyMv/HB2uCWVvy4zI9XpIUQbb6EcLSl7FNBmjly1iysuBGcu3SJjD7/wNQSwMEFAAGAAgAZG90SjxqG7AqAgAANA==
    CQAAEQAAAHdvcmQvZW5kbm90ZXMueG1sxZZLkpswEIavQmlvC/yKhzKexThJzW5q5gQaIYxq0KMkYcZnyyJHyhXSvIwTHBfGi2wMSN1f/013C//68XPz+Cky78CM5UpGKJj6yA==
    Y5KqmMt9hHKXTNbIs47ImGRKsggdmUWP200RMhlL5Zj1ACBtWGgaodQ5HWJsacoEsVPBqVFWJW5KlcAqSThluFAmxjM/8Ks7bRRl1kK0JyIPxKIGRz+H0WJDCnAugQtMU2Ic+w==
    7BjBzZAlfsDrPmg2AgQZzoI+an4zaoVLVT3QYhQIVPVIy3GkC8mtxpFmfdKXcaR5n7QeR+q1k+g3uNJMwmaijCAOHs0eC2I+cj0BsCaOv/OMuyMw/VWLUTBWRoYNYnLSUrqEtQ==
    lubSepghcWuXnaK5YNJVEbFhGWhQ0qZcnyZLjKXBZtpCDteSOIgMnU6FYGCb/utY2NVl6YBD5De1FFmt/Dox8AdUpEScPIZI+DNmq0QQLrvAo17N2csNBg5uC5j1ACvLbkMsGw==
    BLZH0Y1Goff3Vfm7UbnuaPw+2rP8OLHkbQk23XLewfY+MW8p0TDKgobPe6kMec9AEdTeg/J5VQW8ckrQ2TfVK0J31GBmmSaGOGUQLPE4QpOgstPwCF/s+DVCvr/25/NvD6hZeg==
    KZe+Lvyn1bxdet2xhOSZOzOuIC+mvFhNKMgEW5I4BmcN/APA2w0+GdRWrZJmz9QW1W+j+lICVEnHZV6dQm9/J+P/p1wuirqWV3dvt78BUEsDBBQABgAIAAAAIQDvZ+zwuQAAAA==
    IQEAABsAAAB3b3JkL19yZWxzL2hlYWRlcjIueG1sLnJlbHOMz8EKwjAMBuC74DuU3F2nBxFZt4sIXkUfILbZVlzT0lbRt7fgRcGDxyT830+a7uEmcaeYrGcFy6oGQay9sTwoOA==
    n/aLDYiUkQ1OnknBkxJ07XzWHGnCXEJptCGJonBSMOYctlImPZLDVPlAXC69jw5zGeMgA+orDiRXdb2W8dOA9ssUB6MgHswSxOkZ6B/b973VtPP65ojzjwppXekuIMaBsgJHxg==
    4nu5qi6WQbaN/HqsfQEAAP//AwBQSwMEFAAGAAgAZG90SvHY7R4qAgAAOgkAABIAAAB3b3JkL2Zvb3Rub3Rlcy54bWzFlkuSmzAQhq9CaW8L/IqHMp7FOEnNbmrmBBohjGrQow==
    JGHGZ8siR8oV0jztBMeF8SIbQFL313/TasGvHz83j58i8w7MWK5khIKpjzwmqYq53Ecod8lkjTzriIxJpiSL0JFZ9LjdFGGilJPKMesBQdqw0DRCqXM6xNjSlAlip4JTo6xK3A==
    lCqBVZJwynChTIxnfuBXT9ooyqyFcE9EHohFDY5+DqPFhhTgXAIXmKbEOPZ5YgQ3Q5b4Aa/7oNkIEGQ4C/qo+c2oFS5V9UCLUSBQ1SMtx5EuJLcaR5r1SV/GkeZ90nocqbedRA==
    f4MrzSQsJsoI4mBo9lgQ85HrCYA1cfydZ9wdgemvWoyCvjIybBCTTkvpEtZamlvrYYbErV12iuaCSVdFxIZloEFJm3LddZYYS4PFtIUcriVxEBnqToVg4Db917Gwq8tyAg6R3w==
    1FJktfLrxMAfUJES0XkMkfBnzFaJIFyeAo96NWcvNxjYuC1g1gOsLLsNsWwQ2B7FqTUKvb+vyt+NyvWJxu+jPcuPjiVvS7DZLec72N4n5i0lGlpZ0PB5L5Uh7xkogtp7UD6vqg==
    gFd2CTr/qHpF6I4a7CzTxBCnDIIpHkdoElSGGobwzY5fI+T7a38+//aAmqmXcurrwn9azdup1x1LSJ65M+MK8mLKm9WEgk6wJYljcNjAPwDebnBnUFu1Spo1U1tU11b2xRSokg==
    jsu8Ooje/k7H/0/ZXBR1NbOzgd3+BlBLAwQUAAYACAAAACEAqlIl3yMGAACLGgAAFQAAAHdvcmQvdGhlbWUvdGhlbWUxLnhtbOxZTYsbNxi+F/ofxNwdf834Y4k32GM7abObhA==
    7CYlR3lGnlGsGRlJ3l0TAiU5Fgqlaemhgd56KG0DCfSS/pptU9oU8heq0XhsyZZZ2mxgKVnDWh/P++rR+0qPNJ7LV04SAo4Q45imHad6qeIAlAY0xGnUce4cDkstB3AB0xASmg==
    oo4zR9y5svvhB5fhjohRgoC0T/kO7DixENOdcpkHshnyS3SKUtk3piyBQlZZVA4ZPJZ+E1KuVSqNcgJx6oAUJtLtzfEYBwgcZi6d3cL5gMh/qeBZQ0DYQeYaGRYKG06q2Refcw==
    nzBwBEnHkeOE9PgQnQgHEMiF7Og4FfXnlHcvl5dGRGyx1eyG6m9htzAIJzVlx6LR0tB1PbfRXfpXACI2cYPmoDFoLP0pAAwCOdOci471eu1e31tgNVBetPjuN/v1qoHX/Nc38A==
    XS/7GHgFyovuBn449Fcx1EB50bPEpFnzXQOvQHmxsYFvVrp9t2ngFSgmOJ1soCteo+4Xs11CxpRcs8Lbnjts1hbwFaqsra7cPhXb1loC71M2lACVXChwCsR8isYwkDgfEjxiGA==
    7OEolgtvClPKZXOlVhlW6vJ/9nFVSUUE7iCoWedNAd9oyvgAHjA8FR3nY+nV0SBvXv745uVzcProxemjX04fPz599LPF6hpMI93q9fdf/P30U/DX8+9eP/nKjuc6/vefPvvt1w==
    L+1AoQNfff3sjxfPXn3z+Z8/PLHAuwyOdPghThAHN9AxuE0TOTHLAGjE/p3FYQyxbtFNIw5TmNlY0AMRG+gbc0igBddDZgTvMikTNuDV2X2D8EHMZgJbgNfjxADuU0p6lFnndA==
    PRtLj8IsjeyDs5mOuw3hkW1sfy2/g9lUrndsc+nHyKB5i8iUwwilSICsj04Qspjdw9iI6z4OGOV0LMA9DHoQW0NyiEfGaloZXcOJzMvcRlDm24jN/l3Qo8Tmvo+OTKTcFZDYXA==
    ImKE8SqcCZhYGcOE6Mg9KGIbyYM5C4yAcyEzHSFCwSBEnNtsbrK5Qfe6lBd72vfJPDGRTOCJDbkHKdWRfTrxY5hMrZxxGuvYj/hELlEIblFhJUHNHZLVZR5gujXddzEy0n323g==
    viOV1b5Asp4Zs20JRM39OCdjiJTz8pqeJzg9U9zXZN17t7IuhfTVt0/tunshBb3LsHVHrcv4Nty6ePuUhfjia3cfztJbSG4XC/S9dL+X7v+9dG/bz+cv2CuNVpf44qqu3CRb7w==
    7WNMyIGYE7THlbpzOb1wKBtVRRktHxOmsSwuhjNwEYOqDBgVn2ARH8RwKoepqhEivnAdcTClXJ4PqtnqO+sgs2SfhnlrtVo8mUoDKFbt8nwp2uVpJPLWRnP1CLZ0r2qRelQuCA==
    ZLb/hoQ2mEmibiHRLBrPIKFmdi4s2hYWrcz9Vhbqa5EVuf8AzH7U8NyckVxvkKAwy1NuX2T33DO9LZjmtGuW6bUzrueTaYOEttxMEtoyjGGI1pvPOdftVUoNelkoNmk0W+8i1w==
    mYisaQNJzRo4lnuu7kk3AZx2nLG8GcpiMpX+eKabkERpxwnEItD/RVmmjIs+5HEOU135/BMsEAMEJ3Kt62kg6YpbtdbM5nhBybUrFy9y6ktPMhqPUSC2tKyqsi93Yu19S3BWoQ==
    M0n6IA6PwYjM2G0oA+U1q1kAQ8zFMpohZtriXkVxTa4WW9H4xWy1RSGZxnBxouhinsNVeUlHm4diuj4rs76YzCjKkvTWp+7ZRlmHJppbDpDs1LTrx7s75DVWK903WOXSva517Q==
    Quu2nRJvfyBo1FaDGdQyxhZqq1aT2jleCLThlktz2xlx3qfB+qrNDojiXqlqG68m6Oi+XPl9eV2dEcEVVXQinxH84kflXAlUa6EuJwLMGO44Dype1/Vrnl+qtLxBya27lVLL6w==
    1ktdz6tXB1610u/VHsqgiDipevnYQ/k8Q+aLNy+qfePtS1Jcsy8FNClTdQ8uK2P19qVa2/72BWAZmQeN2rBdb/capXa9Oyy5/V6r1PYbvVK/4Tf7w77vtdrDhw44UmC3W/fdxg==
    oFVqVH2/5DYqGf1Wu9R0a7Wu2+y2Bm734SLWcubFdxFexWv3HwAAAP//AwBQSwMECgAAAAAAAAAhADJSfrUKAAAACgAAABUAAAB3b3JkL21lZGlhL2ltYWdlMi5iaW4KialqfA==
    j4nLbq1QSwMECgAAAAAAAAAhAP1n+dEkAQAAJAEAABUAAAB3b3JkL21lZGlhL2ltYWdlMS5wbmeJUE5HDQoaCgAAAA1JSERSAAAAdwAAAHcIAwAAAXngHy4AAAABc1JHQgCuzg==
    HOkAAAAEZ0FNQQAAsY8L/GEFAAAACVBMVEXx9f3o8P0AAAB243jmAAAAA3RSTlP//wDXyg1BAAAACXBIWXMAACHVAAAh1QEEnLSdAAAAlUlEQVRYR+3TMQrDMBREQfv+l06TFA==
    EcKsEKwRzDRBfB5LCl/X/Wd4en9/f05/D5ynjj2Pn/PIecp5ynlq7/xMvEi8SLxIvEi86NR4o36r3frH2pw2p81pc9qcNqfNaXPanDanzZ3Y7rDbYbfDbofdDrsddjvsdtjtsA==
    22G3w26H3Q67HXY77HbY7bDbYbfDbsc7u/f9ATqWN00ZcaUOAAAAAElFTkSuQmCCUEsDBBQABgAIAAAAIQDSdzsz9QAAAHUBAAAcAAAAd29yZC9fcmVscy9zZXR0aW5ncy54bQ==
    bC5yZWxzjJAxT8MwEIV3JP6DdRIjcdoBoapOhxakDiw03bIc9iVx69iWbSD999xSiUoMTKe70/ve01tv5smJL0rZBq9gUdUgyOtgrB8UHNvXx2cQuaA36IInBRfKsGnu79bv5A==
    sLAojzZmwRSfFYylxJWUWY80Ya5CJM+fPqQJC69pkBH1GQeSy7p+kuk3A5obptgbBWlvFiDaS6T/sEPfW027oD8n8uUPC4mlIOtNS1PkOzEb00BFQW8dMV1uV90xcx3dCXX4+A==
    PnU7yucSYnewLLG9JfOwrA/oKPO8elUmlPkKewuG477MhZJHB7JZy5uymh8AAAD//wMAUEsDBBQABgAIAAAAIQDyMpDtFRAAAECcAAAaAAAAd29yZC9nbG9zc2FyeS9kb2N1bQ==
    ZW50LnhtbORd244cOXJ9N+B/KPSzOc1LMIIUVrMIksH1vgne9YOfjJruktSY7q5GVWk0guF/d7AvulgzO6ke24mlIaErsyozkpnnMCIOb/mHP/58c735aXc4Xu1vX5657+zZZg==
    d3uxv7y6ffPy7F//2k062xxP29vL7fX+dvfy7MPuePbH7//xH/7w/sWb6/3xuD18aPuLdze729NGTd0eX7y/u3h59vZ0untxfn68eLu72R6/u7m6OOyP+9en7y72N+f716+vLg==
    dufv94fLc2+dvd+6O+wvdsejXrdub3/aHs8ezV38vMza5WH7Xk8eBuH84u32cNr9/MmG+2Yj8Tyfp68N+WcY0jv07mtT4ZtN4fko1VeG4FmGtFRfWYrPs/QLN4fPs+S/tkTPsw==
    FL62lJ5n6Ss63XxN8P3d7lZ/fL0/3GxPunt4c36zPfz47s6o4bvt6eqHq+ur0we1afHJzP7l2bvD7YtHE+ZjWcYpLx7K8vjxdMZhyXUfTnmqlPdXPD/srrUM+9vj26u7jzXr5g==
    udb0x7dPRn76Wzfx083103Hv79xCmv6aW2gPsHwyuKT4j1jeXD+U/G9bdHYBIsPExzOWFOHLaz6V5GZ7dfvpws96NJ89XLew4j4Z8F8ZwOPu20zERxPnxw83n6rG+7s3vw/lPw==
    Hfbv7j5Zu/p91v58++NHWyN6fYOtR7Z8zuDj7yvMX95u77Qq31y8+POb2/1h+8O1lkix3yh8m3sENqOWnH2vsfVyf/FKfc7xs+3PNl8dxs7t9kbPePHT9vrlGQbvcxHn2AIE/Q==
    YEoVpOUMJOji2fk442J72r3ZHz7897P/tLvdHbbXDwe92V5f7w4fnn67u95e7N7ury93h/H7+ZdWTh/udveFHBtPp/zww6vri3++fDr+4zE/7N5uf7raH77YeTrpYn97Ug/zeA==
    zheHvnl3dfl02H/EmlILIZrsORoQAFNadaYn34Pl0GJt//lo5YvH9bhT9pf3Jb9Ti5r1XP7LyzNrXcMu4ezpq7Z7vX13fRq/RAmxyNMvrz776t7Ig+m7v5w+XH8TFucfzx0P4A==
    /qKvDsM4pSC13Rs/PB7whfFXn+D46+7np8f1eOjp+3p9dfHj5u3usNuc9prJnXaHjUau03f3QDwc+3D1zx/QwzP5tL+UdWJz96EJJPLAQAVRwPdusVuGnOZhXQ2xh27FtITFAA==
    cTApcjJSIolrlCTYdVm3BIs5WAfd5wjIORcP1qcMjJar19oVUuaJfJ3H6my30TTKTn2dWMOuJJM4NywJWyBZl3VLsJiDdZmIwWqNEhx/Y8GWI6JGG1+KdTQP6yDYzpiSqey8AQ==
    74IpXVnngvq+ErEGDOuybgkWc7AudESwGZr0Cp5tSrphs9MHEB3TRKzTyFUh5GwiVTbQOJvUsxhGTtnprm1lXdYtwWIS1kWHWu29DVWAsi1MGCnF4kAIsczDOqWIujTVEFnpZw==
    oDcyublspHXKLNgp0sqsW4DFHKzTqCOaOGRnxQFHYWkouVqS0qmFiVgHJTSoms3VLso6YNKUrqu4iK5z6fon4bqsW4LFHKyLULlGTVqBC4DLBZwtMYNN47O1eViHGDoHR0oziA==
    BlLppqSUjabt1VFPEJtfl3VLsJiDdd1rcT0UgtrB25iyptWZGbPEXGmqCCsYWymqXF0xCqo3mTWvi2GgXBRov3LLyRIs5mBd1oShqUd3Kp7Aos0dXfK29+65Fz8R64gIxHrVEA==
    5JrmdZVMidRMjDaLy3XkVGtr2N/GYg7WQVGh3kItzXpgza4lVsgi0UssvtV5WFfJWqASDFYko1oxGB7Nd5Q6iC/WtrxyXrcEizlY12IPLZamaY0GmlCTanRk8MIpaNSZKK9jTQ==
    66x0ryF19E2EkE0OJZtSeozoWo5pZV+3BItJWMe9VW+tR2BAuk8jSsmFhDqT6/OwzmXnmovWaHqXDNQkptg+8jobWRK01NZm3QIs5mBdTZSyA2zdMTTKpTbnkj4g1oyiwkS+zg==
    N9CMPDuTbfAGGqBq2Agm5oJJJWyrYWUNuwSLOVgnXBx0FI5QoIWeUsk9NUwlkJMS5mEdaELO0JVm7GD0w6qucBWNp56zpnq2lbRy7/8CLOZgnQ/smaurWsHAx8SBU0q1ilX1jg==
    NNGYEyexUfRgXLaqYa1qWM6MBhxxKkjVrz3mZAkWc7Aup9gc663ZnqE7nx2Trw7EhdCk4jysY03cuKt8cOriDHgfTMIQdDeCcPfRu5XHnCzBYg7WAUEFr/+oNbDelRpi9UM4hQ==
    xslN1F5XU06qYa1R3yYGYtcIayUZr/wLNtdIBCu3nCzA4ldZlzA2CM9mndzzbHv7YfP4PDent9vT5sP+3eb9duztN4fd3W57+qfN1e3F9bsxe2ezPylNP54wPg/76+N3m3/Tsw==
    Lra3m+31ca+HH3eHYe7q+HTIZnvYv7u93JzGAOXNYf/+qEdt9ofLQfWnC23u9KEfN/vXm+3Dgf87FaCKRpgSSusgmoQVrqU63R0dk1HTm5mCPUJJ6I0lDAZSR5OUkGYMdo5gbQ==
    D3nlYc1LsJjD7foeilZsm2xjYIgpdEug0S94spbzRG4XCUaTtenROjOGlxj2woZiqx6b4t1WdrtLsJiDdba7QIk62DFbwIbUhaWTC5KReaYu4V5Uv9gSzADSqNuzpugdGgWVGQ==
    xUWNqWsPf/ltLOZgHUmjIFJaY4FKomBA8pBDD0RZJuqcIytIkdBgvh/ql1TYAAWDUqVqLAOElYXNEizmYJ3rOdjQbCzJaTJds/SA1MCn1EN1diJf16DlJGSGVDCgwczkTsVEZQ==
    o63SW3Qrd5MswWIO1tVeISGHkloGlJRc07SiuubAudQmGkyP6AqFIadlNOKwbiWPYhCLq5Z6yW5tNbEAizlYB5lSKlqzJDVI1SWy3hfVTuCbdTyRr/OOpXSVrxlF87oRXFNSDQ==
    q3BBh6AQu5XzuiVYzMG60DR9bXUMadQIhDE3Tbmx1Fiq1bo308ShyKhZOZoWOBiQFE3CXoxL3cXuILWQV57CsQCLSXxdGWi44kotEDV7td02z5GLWBVTE2lYBVM6ABpCtmNCOA==
    Ge4+GwcD6qJ5XVrb1y3AYg7WqXYrOeTCNrHemOMkPkCW0WpqU59Iw2LIMdlsjYXh68oY4Cy5GMbgFFPrMq/cXrcEizlYZyMQpd7CkOnFKjISgtigkt3nKjO1ElMIlhEMUmCjeQ==
    UzIp2mQkkCXIrDsra9glWMzBulgs51RbkcrQayiVsuql5qNQpzjRoCs7ml8JxJCr3agqzIZTiWZ4Few2xbz2FI4lWMzBuqBJtPNUciqa4FTmzuCBY08+R1snGnSFyY6m/jCm5g==
    ZgOjvTiji0a4qp/zSK7xympiARZzsI6Ta8X1kMXbMdSXE/Qce9bKb+tUyxCE5KhXG03xlgx0CyZn6Ca43DF3KQgrs24JFnOwjnoqudriY9AAJI7RqxtILbMfd9HmYR0ohM2KRg==
    WOuralj1ddzd6IwtKmo1itm1W06WYDEH6yJ4VekOXQsexCcWiYIo2WuGTTP1w6pfY5tbMRTHYPoG1qRW2EgdQzsCqZNZO69bgMUcrEPSGw29UrEA3tUyFv0QcT6CyyH5eVhXKg==
    +KbRVJ1b8gawa4S1LRrSvwq0zxlXnsKxBIs5WDeWWYKiSU3IAVgr/2hFKAwNi9X7mCjCYuw9MoHBOiZJFsomgU0m1awpXZbxzcqtxAuwmIN1ESymQi7WHqCnzMGqRre9BBn94Q==
    E6kJjKM7M7mxnpRq2MzV5CEp2NoxuKM2m1ePsL+NxRys4x5dDVQk1wigqaym2tIxka0USWAe1vWcKPcaTB7zc8EV0q3OBnuIPqiwjXblxS+WYDEH61IppI+cu2AD75NC03zsKQ==
    hFRlqpFOsY2hw9QMlz6m5vZgivdkOrYOzbJVVbsu65ZgMQfrLNXWx+qFLlkVeZUxuSiszp2Ftf5P5OusuEBejACh0XR9jK8rYKi67ijESn3l8XVLsJiDdVWrlaYOHiMXzXui3g==
    MfjcSFUUW24T9cMCJvG9qpBg0giLXMbyZmJawBZtji71lX3dEizmYB3YkcOObr+I0LxLvgM7F7vteUx/n4d16spkhCvTfRRVE2N5KQINuOxyazlQhbVHOi3AYg7WaSohHF3zTQ==
    KxqPhcc9VJFIAAhBJuqHJSy9llRM86gOLwubnCAZ9mHMAtSQG1dm3RIs5mCd9Eqsqq5CzFB7KrYhKCTkSHrEiXydTb7VljWRS2Nhbuzq5lqyxlPjFFBlYl05wi7BYg7WjVd5oQ==
    z6l6jTBAnEC8j5xd9cVZmWjeBGpyFPS/IZ/ZQKjNFFWGRop+W2uPLa/cN7EEizlYR2OZmybOthoUllRgzARugshjUNdErcSpWSAXgslVmgHnm8kOq0m5M0WPEvza82EXYDEH6w==
    GkHwQaKk0KGVWrILPlNIvVoi4HlYp3rBYmZvUHMnA5Cy4SJiQiTuNpDvvHJetwSLOViXYnfUUsbEqpvGirwdsTLXbLN3YaJ+WM7NSxAy1ZFGWNuKyU35h8K1NCIFe2VftwSLOQ==
    WIdAvVTnQ7Oqm6CmNEavjlelCrRe3Tys69kjRuhGQVUN6zCaZDXgilQuXHouoaw85mQBFnOwTnOcrk8DgrMIpYyFoJtmsmhVToFuTcQ6RI2i6Iw47w1I7SOva8b3VlDz9oprvw==
    hGAJFnOwLobW2SHUTBm4YpLGtiWt+lCx1YnWr0vjBbCqGky4z+vIOcNUxnCn5j2SBCcra9glWPwq68CPZcj+TlhnxeUkHkNCDxJdIUgqmnwZ06YwTTRHrJGXElw0eqPdQNQtJg==
    Gm/TA1dcrrXLyvMmlmAxB+tQSBNWDA1cgvEuaImM4/3jHmpUETUP6yyGkrIjI8Er62i8+kJzPWVdSeCaFM4rs24JFr/Kur+vHjEcYzHIuzSawSMzg4jm1hxU8XGcSMNWH1sNzg==
    G8v3K8QWUNaJGMwdBaLk4Fcec7IEizlY11mfeUHnwKtQSrY013vTLIeQ2dqJ2utK8C6XxCZohmfG2g4myXjDWbJCqm3Zrz2CfQkWc7Cu5uqrpjXqzzOk5kpj9BxzUTnVK02U1w==
    5arcEqvOLSKrhs2a0qlMNEq2wUcbce1Z2EuwmIN1QFHYh1AwVQjRpijRVouaW6PtM63VqYG0ecJiVBxqXqey0BQNY0aIm3Viqxf7zawby5BQ/SXW+a4Oyn3BusevfpV1S7D4jA==
    dc8lmNxT6v/h+wa4JcpUNcNqTmOdYxsqdk27QvRoi5+H665a0VCp0bx35brPyahSYFMB9GZJdYLr63J9CRb/A1x/cKb6AE/bu/+7/t6HJ/NZ0f79/gU71gWVa/OwbLzw1qsqNg==
    rYpmjxmKxvFKpidArNUJPMOjZo5S4y+xLGgctvUhrn4ZcdEpYx7INgVJwlRNx0TjLTpmLD6tYTeMztkyhhqjfu1C8PDtwpatq8S/RJJcVZs+Nqp9SZKqQT7js0kyYdT8tH283w==
    eXO9Px63hw9tf/HuRgv8/X8BAAD//wMAUEsDBBQABgAIAAAAIQCwbjGF9gMAANsLAAAaAAAAd29yZC9nbG9zc2FyeS9zZXR0aW5ncy54bWy0VkuP2zYQvhfofzB0rtd6+9F4Aw==
    WbaaBOumiJ1Lb5RE2cRSpEBSdpxf3xElrr1YJtg0iC+m5pvnR3KGb95+qenohIUknC0d7851RpgVvCTssHQ+77PxzBlJhViJKGd46VywdN7e//7bm/NCYqVATY7ABZOLulg6Rw==
    pZrFZCKLI66RvOMNZgBWXNRIwac4TGokHttmXPC6QYrkhBJ1mfiuGzuDG750WsEWg4txTQrBJa9UZ7LgVUUKPPwZC/GauL3JmhdtjZnSEScCU8iBM3kkjTTe6v/rDcCjcXL6Xg==
    EaeaGr2z576i3DMX5ZPFa9LrDBrBCywlbFBNTYKEXQOHLxw9xb6D2EOJ2hWYe65e3WYe/ZgD/4WDWOIfcxENLibyUuMvxpGkr6Gkhx5ILpDoD9zAR10s3h8YFyinkA7wMoLSRg==
    OjvnHk75ieDzCP4QhGGdQ+pMOnmJK9RStUf5TvHGaEx9t4ePl+aImT5e/8LFMXjoRz1eHJFAhcJi16ACNinlTAlOjV7J/+YqhUsiYA8HC31lulUrcbZ5QBfeqhtk119H8MBQDQ==
    pTy7Yltewn0BU0Fez3lnoLPxTNLWQBzahyAl3ncU7tSF4gyK2ZGvOGHlh1YqAh41Ez+RwfcSAJ4h8kfY9P2lwRlGqgXaflEwvTMZJc2WCMHFe1ZCB/hlwUhVYQEBCFJ4C8eNCA==
    ftY8v8OohK79k3Ent8cKZkApzeIT58qoum60CaLVps+0Q6+I5/phNrUiAfxiK7KOs01gRbI4NYftOeJPw9BfWZFVHAW+FcniJBn4fY4Ea2/lplZk4wZTKxKGnj+zZh2502ATfg==
    A9m4iRX5JqPTmecHVg5mbuyFVg5m82k0tcaZe3Hoz62I765jO5JEm9SawTwN55G10sT1UnsGiQfUWeMkaThbWZHVOo59KzupG8Su9VSlq2kSW3c7XcdpYt25LA4ie6XZ2gsinQ==
    2+TpZtSLbsb/I8yqa3OjurdIUZ0Lgkbb7hUw6TRy8bgizOA5hmmEb5FdmxtwPO4BCdOFZjAXDKCHSb0oiWzWuNJrukXicPU7aAirFGbUhydfBbQRLP4SvG169CxQ07cvo+KF4Q==
    YEmYeiC1kcs23xkrBvPzBmpZ+fEkNE9Xes4LBW1Ij4EHpNuZ1sVs/HnXk11QsetaFd6ipuk7Xn7wlg4lh6Pyuial4KuEx6L+yA/+gPka83tMf6Ciqwy0h8VV5hvZjV5gZMFVFg==
    Gll4lUVGFl1lsZHFnQwmPBaUsEdovmbZyStOKT/j8t0VfyHqSShxQWDHd5c6v07+P3qMEgnToIFHguLCYH9qzIv060Ht4aA8AnefcLVCEpf9WTWv8vv/AAAA//8DAFBLAwQUAA==
    BgAIAAAAIQCD0LXl5gAAAK0CAAAlAAAAd29yZC9nbG9zc2FyeS9fcmVscy9kb2N1bWVudC54bWwucmVsc6ySTUvEMBCG74L/IczdpruKiGy6FxH2qvUHZNPpB6aTkBk/+u8Nwg==
    aheXxUOP8w7zvE8gm+3n6NU7Jh4CGVgVJSgkF5qBOgMv9ePVHSgWS431gdDAhAzb6vJi84TeSj7ifoisMoXYQC8S77Vm1+NouQgRKW/akEYreUydjta92g71uixvdZozoDpiqg==
    XWMg7ZprUPUU8T/s0LaDw4fg3kYkOVGhP3D/jCL5cZyxNnUoBmZhkYmgT4uslxThPxaH5JzCalEFmTzOBb7nc/U3S9a3gaS2e4+/Bj/RQUIffbLqCwAA//8DAFBLAwQUAAYACA==
    AAAAIQBujBnpTgkAAH8kAAARAAAAd29yZC9zZXR0aW5ncy54bWy0Wtty4zYSfd+q/QeXntcxcSe140mBBLCZ1HiTipyXfaNFymYNLyqStsf5+m1S4vgyR6lJUnkSiQM0Gt2nGw==
    DULvvv/c1GcPZT9UXXu5Yt9Fq7Oy3XZF1d5ern69Dufx6mwY87bI664tL1dP5bD6/v0///HucT2U40jdhjMS0Q7rZnu5uhvH/friYtjelU0+fNfty5bAXdc3+Uiv/e1Fk/ef7g==
    9+fbrtnnY3VT1dX4dMGjSK+OYrrL1X3fro8izptq23dDtxunIetut6u25fFnGdF/y7yHIa7b3jdlO84zXvRlTTp07XBX7YdFWvNnpRF4twh5+L1FPDT10u+RRd+w3MeuL76M+A==
    FvWmAfu+25bDQA5q6kXBqn2eWH4l6Mvc39HcxyXOomg4i+anl5qrPyaAfyVAD+UfE6GOIi6Gp6b8vAga6m8xyQH6WN30eX8g3NEezXb94bbt+vymJnXILme0tLNZu9V7YvlvXQ==
    15w9rvdlvyVXU4jwaHUxAX3ZdA/lzxQ6XZvXH9rDbESnF6jLx9K2xXXVlHMrOaXbbUZqJZHDvqzrOc62dZmTKo/r2z5vKEKWlnlMPo45KV9cl82+nkb266q4XPUfCnboUJS7/A==
    vh6v85vN2O1JykNOJjGLnndP+7uynTX7H4XwgkuuDvj2Lu/z7Vj2m32+JXWyrh37rl76Fd1/uzGjcO2JTUeJRb+5y/elO0w8vH/XrYep4ajJcPawLj+TrcqiGil97KuiyT9frg==
    eCSTScIFEvG43nXd2HZj+XP/8o30mJZ7flzsm+Z5jRdvx5Zt8dXLGzmvWxcxrwYectTz0+aQ72hImzfElVc57KorysmD93317aSeBsxGZosv4EREpL6vivJ64uhmfKrLQD7aVA==
    v03c+vF+GCuSODv4L2jwewoQfWjmnyiqrp/2ZSjz8Z7Y8DdNNhMu1NX+qur7rv/QFhR3f9tk1W5X9jRBRZF1RUys+u5xtvMPZV5QbP/FeS9e0og22WJm+vTwCzF26RpFTknn/Q==
    MbEQ+oxETIRMQERwr+eA+hpRxqcQMZH3MUYkU0dbvUFiKS3WINaJsBCxWiuMOGW1g4iPDAsIYZGIpYYIM4mAK2VcWAPnYVw7rBsTkTYGI9IaaB0yWmagdZjmzEH/sJS0ziCSGQ==
    b7ANHMs8x4iOI6x1MBp7btrRY2gDLmipx3T0FlGZXTa/14hUaQTZyzWLDfQc11wn0HNc68RhxIjUQovyRPMYa2B54qBFuRUxh17gqeIca53qFDORe24VRIQwhkMvCKX8l3LiNQ==
    YqRgWFosZAK1FokkO0DERglmiLCCuROIOZFdRMqcwkjGswRr7ahugj4VTqYxtoHnzMBcJYIxOBYkMzaFPJCKmAhXKhNitoSIlQ5HvUw5D3ClMpXGw7xDiPeQBzLVwcOYk5mOcA==
    NMrApYA2UEzrCDJEcRk81FpJkTCom1L8RO5VWrgMrlQZwTIYcyo2TEEvqEQFnPlUQhNBnyridQI9pzKZGJjflJccZzEVuMK8VkH57ASi0wzaWlOO5VADzSIroAaacZtCG2hKsQ==
    DksTmkfQC1qyOOAxhnMFo5G2P+sg33RM2RfrFossg/7RMfEXcocQjysUTZkqQF5ry63BYzIR4Z1WZ1LFMII15Z0Ee8FpafF6wrRrIcQwCiDIA8O055CjVHARezAiLd6ZjBImhQ==
    PjU6ChZmS6MVwys1lChwhjWGttpTiHVYt8SICHLH2MhyyB2TUu7FNvCC4xopnvZnOCamvTZAHlCBZHCOj5lyHGakmGrLAO1GiMd5NOZTYQMRQaUQ1kBK2h0xQkEP7UaIj6B/Yg==
    JYTHY5ROcXaJM5FEMEpiZ6SBPo29Dhpr4IlXMCPFgTIfHJNQHjPQ25QOuIO6JVxJnGETIVwKtaYSyYgTiLAM8iCRSqRYN0X5DSNkgQh6OzHc4xopiXmiIN+ShHEcp4QYBXNVMg==
    LQhrkJhYYWmpjPHJKMlMhOvRxKkohtGYOKpqsEU9JUU8j+eK4fUEzrBPbRSlyQmE2RTmAxvJ2EPP0dacYY5ayVNcpVmjg4DWsRRX+GRkiYo4Ti1RBMePDcy7E4iUCuYQGzTPoA==
    rVM6OVqodcoip6HnprIX12Kp4LSjQoSOJdgLqRQGVxupol0Lj9HTxxKM0HkKI5SWFfR2GlP9Bi1KCGU4iCQsszAjpQkPOLbTRFNFCJGMC47t5jjlcowIhSsUImiCeZB6neI9Kw==
    DVFgULeMm4xB7mRCBwajJBMmxnk0k6QE9E8mmcMno0wKiXemTBoewfVkhs4YkDuZ1QKfF7LURBbyIHOM3AoRL32ArHKcOQ3X46jccdDWTrCQwXmcpASDx5DdMugFR1sWZi8Fjw==
    1dCip79BOj1VxRChwjfACHaGjlmQB4T4CK/UTBvqCcTiSshZYi9ej1VxBNnrUnmignRBkDiEeMZYBrnjOU8NtJuXUYZ54CVjMbSBl1QoQlt7aWJ8XvBKBhxzXiuJv+p6bagWgQ==
    SBJxvDtT4WJxrvKWS41tYLlKTiHG4nnIOwxGsM9Ygvd6n8kshtzxLhL4y4/3tDVi/3glAhwTmGT4i2bgUTDQp1S6JJhVVDYE/DWCNvSYY2nSaJyRgtYWf0EPVL7hyo6QREC+hQ==
    mFkPvRBiGQfIgxBriU8FwUqHvwWElI722DqpcPjLQnCayj6IeBaf0GAyD4xgQjz+XhWCcfEs7eIADe/fNevpqn+6Izw8TZdxZ81hRJY3N32Vn11Nfwa4mHrc9J/Sql3wm3LX9Q==
    5Utkc3+zgOfnB2Bo8roOfb5dgHmhzbqohr0rd/NzfZX3t89yjz162FqUux+/yJpuscv+P313vz+gj32+P1yyLV2YlMeRVTt+rJqlfbi/2Syj2rx/egHdt8VPD/1sp2fzPK7Huw==
    spkvKz/m86Xb3Ldsz3/dHIy9rfvNdKFWXuX7/eFe7uaWXa7q6vZuZNNV2khvRd5/ml9ubvkR4zPGD9j8km+nlVHv48NzG1/aXvQTS5t4bpNLm3xuU0ubem7TS5ue2u6e9mVfVw==
    7afL1ZfHqX3X1XX3WBY/PONfNR2MMF+d/9m79GPvOn/q7sdXfSds6rx/LaHIx3y5nHw1eKb4G12mPxdsK6Lj5qm5ef5PwL8OitfVMG7Kfd7nY9cv2L9njKn5fwXjNbH4Ezn2lw==
    cpfmQ1kcAmn559D7/wMAAP//AwBQSwMEFAAGAAgAAAAhAJcodrTiAAAAVQEAABgAKABjdXN0b21YbWwvaXRlbVByb3BzMi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAACckMFugzAMhu+T+g7I9zQMGLQVoaJlSL1Oq7RrGgxEIglKwrRp2rsvaKfuuJP12bK/Xy6PH2qK3tE6aTSDx20MEWphOqkHBtfXluwgcp7rjk9GIwNt4A==
    WG0eys4dOu6588bixaOKQkOGemkYfCVpfn5OmoIUuywlWVYUpN6fzqSu03rf5MlT22bfEAW1Dmccg9H7+UCpEyMq7rZmRh2GvbGK+4B2oKbvpcDGiEWh9jSJ45yKJejVm5qgWg==
    8/xuv2Dv7nGNtlj5X8tN3iZpBsvn8RNoVdI/qpXvXlH9AAAA//8DAFBLAwQUAAYACAAAACEA2k/RAP0AAABSAQAAGAAoAGN1c3RvbVhtbC9pdGVtUHJvcHMxLnhtbCCiJAAooA==
    IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFyQwWrDMAxA74P9Q/DdtZNsSxbilDITyHXdoLdiEqc1xFKwnbAx9u9ztlN3Ek9CepLq/YedklU7bxAESXecJBp6HA==
    DFwEeX9raUkSHxQMakLQggCSfXN/Vw++GlRQPqDTXdA2iQkTYycF+eJpwVsuW/rSthl9eJaclkWW08PjQZZZkWcFl98kiWqIY7wg1xDmijHfX7VVfoezhlgc0VkVIroLw3E0vQ==
    ltgvVkNgGedPrF+i3p7sRJptn7/uVz36W9xWW5wRZHFQWdM79DgGOnyCiuQpqJU5PaMLnh1/T3XD+agm7c8drBi1LM2jjrCmZv88G9/8ofkBAAD//wMAUEsDBBQABgAIAAAAIQ==
    AHqocnTFAAAAMgEAABMAKABjdXN0b21YbWwvaXRlbTIueG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKyPQWrDMBBFryJmX8vNIhRjOwSSLJOC2w==
    rLqR5bEtkGaMNCnO7StCmxN0OfzH+3/q3Rq8+saYHFMDr0UJCsny4Ghq4PPj9PIGKomhwXgmbIAYdm3dVx3fosWkOvRoBYdO7j7HX/v3fedWmY+Dk6y8jKOzeCHvCIs1eVAP8A==
    bEKGMwvq+te9BZW3UKr6BmaRpdI62RmDSQUvSDkbOQYj+YyT5of4wPYWkERvynKre9d7x1M0y3z/lf2Lqq318+H2BwAA//8DAFBLAwQUAAYACAAAACEAXJYnIsIAAAAoAQAAHg==
    AAgBY3VzdG9tWG1sL19yZWxzL2l0ZW0yLnhtbC5yZWxzIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIzPwQ==
    isIwEAbg+4LvEOZuUz2ILE29LII3kS54Dem0DdtkQmYUfXuDpxU8eJwZ/u9nmt0tzOqKmT1FA6uqBoXRUe/jaOC32y+3oFhs7O1MEQ3ckWHXLr6aE85WSognn1gVJbKBSSR9aw==
    zW7CYLmihLFcBsrBShnzqJN1f3ZEva7rjc7/DWhfTHXoDeRDvwLV3RN+YtMweIc/5C4Bo7yp0O7CQuEc5mOm0qg6m0cUA14wPFfrqpig20a//Nc+AAAA//8DAFBLAwQUAAYACA==
    AAAAIQB0Pzl6wgAAACgBAAAeAAgBY3VzdG9tWG1sL19yZWxzL2l0ZW0xLnhtbC5yZWxzIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAjM+xisMwDAbg/eDewWhvnNxQyhGnSyl0O0oOuhpHSUxjy1hqad++5qYrdOgoif/7Ubu9hUVdMbOnaKCpalAYHQ0+TgZ++/1qA4rFxsEuFNHAHRm23Q==
    50d7xMVKCfHsE6uiRDYwi6RvrdnNGCxXlDCWy0g5WCljnnSy7mwn1F91vdb5vwHdk6kOg4F8GBpQ/T3hOzaNo3e4I3cJGOVFhXYXFgqnsPxkKo2qt3lCMeAFw9+qqYoJumv10w==
    f90DAAD//wMAUEsDBBQABgAIAAAAIQAnPig7HxUAALmqAAAYAAAAd29yZC9nbG9zc2FyeS9zdHlsZXMueG1svF3ZkttGln2fiPkHRj3NPNjKfXG0uiPXkaMtW+2Sx88QiVJhTA==
    EjUky7Lm6+cCZJVYSoJggoBCYRe3c3CR9567YCH/9o+/VsvZn+VmW9Xr1zf4e3QzK9fzelGtP76++e19/E7dzLa7Yr0olvW6fH3zudze/OPv//5vf/v0w3b3eVluZ0Cw3v6wmg==
    v7653+0efnj1aju/L1fF9vv6oVzDm3f1ZlXs4Onm46tVsfnj8eG7eb16KHbVh2pZ7T6/IgiJmwPN5hKW+u6umpe+nj+uyvWuxb/alEtgrNfb++ph+8T26RK2T/Vm8bCp5+V2Cw==
    O71a7vlWRbV+psEsIVpV8029re9238POHCxqqQCOUftotfxCwPMISEIgtmUeBT9QvNp+XpV/3cxW8x9+/LiuN8WHJTDBLs3AqllLfPN38Oainvvyrnhc7rbN0827zeHp4Vn7Jw==
    1uvddvbph2I7r6r3YAVQrSpgfWPW2+oG3imL7c5sq+L4zXB4rXn/vvngSeR8uzt62VaL6uZVs9Ht/8GbfxbL1zeEPL3iGiNevLYs1h+fXivX3/12e2zM0UsfgPf1TbH57tY0wA==
    V4d92/892uOHr5+1G34o5lW7neJuV0KsYoEa0mXVSINw/fTk18dmkYvHXX3YSEuw//tM+ypZdAhhCOjbva7g3fLup3r+R7m43cEbr2/abcGLv/34blPVG9DO6xvdbhNevC1X1Q==
    m2qxKNdHH1zfV4vy9/ty/du2XHx5/V+xjf/DC/P6cQ2PqWRtICy3i/DXvHxo1ATvrovGJz83gGXz6cfqy8Zb+P8+keGDJ07h78uiSSkz/DVFa34WBWkQ26O9Pc35+NW+t5/K2g==
    EP1WG2LfakP8W21IfKsNyW+1IfWtNtTSTLmhar0o/9oLMd1MwtrH06HGbJ4OsWXzdGgpm6dDKtk8HUrI5ukI9GyejjjO5ukI0wyeXT3visKjYKcd0X6et79GDOPtLwnDePsrwA==
    MN7+hD+Mtz+/D+PtT+fDePuz9zDe/mSdz7tvtWY/gszWu6tVdlfXu3W9K2e78q/r2Yo1cLVz1jh8TdErN6Ps5Ag0+8x2KMRXs82L9nl/hLQiHV7Pd81EN6vvZnfVx8cNjOfXGg==
    Xq7/LJcwKM+KxQL4RiTclLvHTceKDInpTXlXbsr1vBwzsMcjbSbB2fpx9WGE2HwoPo7GVa4XIy/fE+MoSeE5oGF+vm9EUo0Q1KtivqmvN60uRssPP1Xb69eqIZnZx+WyHInr5w==
    cUKs5bp+Nmhprh8NWprrJ4OW5vrB4MhnYy3RgW2klTqwjbRgB7aR1m0fn2Ot24FtpHU7sI20bge269ftfbVbtin+uOvAlx+7c8u6OTJ+tR231cd1AQ3A9eXmcMx09q7YFB83xQ==
    w/2sOTB9mvZ4n3O3Y+vF59n7MWraM9NYfX0bIg72ulo/Xr+gL9jGEtcz30jyeuYbSWDPfNdL7C20yU2D9maceeb28cPupGhbpotEe1ssH/cN7fVqK3bXR9gXAcRqsx1NBqdpRw==
    iOCfm3a2cecYme+Lldcb9oXrell9nZVGNe9AOYKVy3r+xzhp+M3nh3IDY9kfVzPFermsP5WL8Rhvd5t6H2vHkietSy6SfFg93Bfbqp2VXlBcXuqfzqnP3hYPV+/Qu2VRrcfxWw==
    +G5VVMvZeB3Em/dvf5q9rx+aMbNZmHEIbb3b1avROA9HAv/j9/LDf45joIEheP15pL01Ix0easlcNUKR2TPVi5GYoM2s1tUoNbTl+2f5+UNdbBbjsL3blPvLWHblSIy3xeph3w==
    dIygLciLnyD/jNANtXz/XWyq5rjQ1WxHR/q2jx/+p5xfn51+rmejHMz55XHXHjJsu9MWPR7d9ZX9Bd31Vf19e5TvtmpCboSdfUF3/c6+oBtrZ92y2G6rzrOeg/nG2t0nvrH39w==
    +nntwFcv683d43K8BXwiHG0FnwhHW8J6+bhab8fc45ZvxB1u+cbe3xFDpuUb4Shay/dfm2oxmjNasrE80ZKN5YaWbCwftGSjOuD6i2qOyK6/suaI7PrLa/ZkI7UAR2Rjxdmo5Q==
    f6QTM0dkY8VZSzZWnLVkY8VZSzZWnFE/K+/uoAker8QcUY4Vc0eU4xWa9a5cPdSbYvN5JMqwLD8WIxzT3LO929R3zS0J9Xp/3fUIlM1h5eWIzfaebiwn/15+GJVrhAOPxXJZ1w==
    Ix3C+lIkWuTLS8T6YO0NE1eb8G5ZzMv7erkoNx371I2FGfd2f/fD1+a3Zlx0dPGn6uP9bnZ7/3xQ/ZhGoF7k05D9Ata/wVNrLp5uGzkFe1suqsfVk6HpPQuCXg5uI/oFmPWDvw==
    VP8XSH4hMt2m6Ed+6WxfIOWFyHSb6kJkq9MXyHN68MXmj5OBIM/Fz/Nc1hF88lwUPYNPbvZcID0jT4WgPBdFL6QyM/N5c1A+9c5lmunGXyaebnyOirpZcuTUzXKxrropzgns1w==
    8s+qqcY5SbPd3vNFCknebxvfizLnvx7r/eHxF+d1Lr936kdodtbbcnaSh15+fuhFlulex4vTTTfFxXmnm+LiBNRNcVEm6oRnpaRulotzUzfFxUmqmyI7W6UVIS9bpfi8bJXihw==
    ZKuUZUi2uqIL6Ka4uB3opsgWakqRLdQrOoVuiiyhJvBBQk1ZsoWaUmQLNaXIFmragOUJNcXnCTXFDxFqyjJEqClLtlBTimyhphTZQk0psoWaUmQLdWBv3wkfJNSUJVuoKUW2UA==
    U4psobb94hVCTfF5Qk3xQ4SasgwRasqSLdSUIluoKUW2UFOKbKGmFNlCTSmyhJrABwk1ZckWakqRLdSUIluo+zv6hgs1xecJNcUPEWrKMkSoKUu2UFOKbKGmFNlCTSmyhZpSZA==
    CzWlyBJqAh8k1JQlW6gpRbZQU4psobYn+K4QaorPE2qKHyLUlGWIUFOWbKGmFNlCTSmyhZpSZAs1pcgWakqRJdQEPkioKUu2UFOKbKGmFOfi83Basetqdpx/1LPzwvjLT10djA==
    +vX4juljKno51ZNV3VyXX/Jv6/qP2cn7+2g7b1xGUn1YVnV7iLrjVPgxb3sZQ9aJz1/c+Rtpjtmv/G6jwy0H7TnThJxdikyOqbBzIX+MTIY8di7Sj5FJ18nOZd9jZFIG2bmk2w==
    6vLpQhIoRwn4XJo5AuMO+LlsfQRPl/hcjj4Cpit8LjMfAdMFPpePj4B81iTnr9H8wnUSz9eEJgznwvGIQXYznAvL1FdP6TgVxqVO62a41HvdDJe6sZshy5+dNPmO7abK9nA31Q==
    MFenMst19XChdjPkujplGOTqhGa4q1Oqwa5OqYa5Ok2Mua5OGXJdPTw5dzMMcnVCM9zVKdVgV6dUw1ydlrJcV6cMua5OGXJdfWVB7qQZ7uqUarCrU6phrk6bu1xXpwy5rk4Zcg==
    XZ0yDHJ1QjPc1SnVYFenVMNcnUzJ2a5OGXJdnTLkujplGOTqhGa4q1Oqwa5Oqc65uj2K8sLVWR4+guc1YUfAvIJ8BMxLzkfAAdPSEXrgtHTEMHBaSn315PO8aenYad0Ml3qvmw==
    4VI3djNk+bOTJt+x3VTZHu6mGubqvGnplKuHC7WbIdfVedNSp6vzpqWzrs6bls66Om9a6nZ13rR0ytV509IpVw9Pzt0Mg1ydNy2ddXXetHTW1XnTUrer86alU67Om5ZOuTpvWg==
    OuXqKwtyJ81wV+dNS2ddnTctdbs6b1o65eq8aemUq/OmpVOuzpuWOl2dNy2ddXXetHTW1XnTUrer86alU67Om5ZOuTpvWjrl6rxpqdPVedPSWVfnTUtnXZ03Lb0FSDXCNy3drg==
    is1uNt7Xsr0ptve7IuM7AF99evE7Tg1x+0tp8PkdWNV8lffRDUGL/VeZHgjbD/64eP69pQbcmDE7/LLV4eXW2sMJ0f0WW2C6qfk9bGt++BKmjk0dvkz1+Tal9qtUv95wxzeutg==
    hnxx8dOnD+v5Zb32n3uxWmft3jUhdcbmNuTOrtE+KrsM1AeZ9VkI9nxY7n/7Cx78uF4AwafD717tLV38Veyp4H1XLpdvi/2n64fujy7Lu93+XYzaG/m/ev/D/mvkOvGbNhF2Eg==
    vHppzP7p4ffHOtZ7/8XyhzP0nSHZqP3EcreXi1y70hfG8LM1R/cyt7cyf21Wcq/zfmUL2NovjbiPo/pl6OftyGZbNUHRfgQh7ZjmhxP3h9/MmzdZ8ekTCjX/Dk56+uG5jv1+kQ==
    JuaPWwiJNqN87Rfro8PKEyKIZIw5o2mIFCOhOKba2WRpegEndowHym04GH6lwUZJJIJh2mvPjJaaEBlZ9Ewb6ZwhicG9gIkNdsRa7H2UkgVmAtVKI2QoDypS5HFIDO4FTGwwFQ==
    TEbiDPdBMcG8DhITHohBPgRqfGJwL2Bigy3HgXtNjQuC8YAVCzpEoRHWVHKVhkQvYOoY9iYIwpmxKjLCjeHBoMCwwFwTFdMV7gVMbLAOFjnObVRCwoJZq4Im1MtArVewmcTgXg==
    wMQGC0qItgFjgxij8MdI5VjwWjMZYNUSg3sBExsckI6wQIEpSZhh0goRGIkRiYggd6nE4F7AxAazSKBYCaO1JQwRpZkRyDgCy0WVNukK9wKmjmEpDUOwREE0/+dWeM2F4M5Dvg==
    RVimMdwHmDoPRyEY0syH6BgkU6XgAdIYzOLYyNTgXsDUBnMsCKYEUReY1MgaKbhU3GIWpBBplugFTGwwiiZA/GmMAmZNTg1eBO2QDDZKT1ODewETG8yh33IcZAOVgDGsLcPIcg==
    zZBq/vq0cPQCJjY4EqkoYVYyB4ULcaWFo9oYoQPXTqYr3AuYPEsI4cG7GJTPkIAkK7AiKMZITLTkRKXrA0ydhy0kKE+d9QjqgMewTjBGhMBJ4JZ4l+bhPsDEBnseqefQBjAOUQ==
    SR3MDUYYRoJR1BqbxnAvYGqDTfSOIEQE1Fkh22i0VlsZZDQSx9TgPsDEBjsllcZM+IgN81Jb5zFWsAkDgelYusK9gKmbHwMZP8KQxpllnkalrI7KC2WpxMHStPnpA0xsMKGGGA==
    47CDFYN+XBlqlFLOBQRZS8i0W+sFTJ3WFPfYwAZR1CxioqEfIA7KLKbQQzqRprU+wNRpDQoAI/BPeg/dIraOckca1VNvFE7zcC9gatHBpEssjDcRpvZorXHWYXjaNAscQjMVXQ==
    H2DqGI6QPaHEKuQhrTKuaESSsWAokQgZncZwH2Dybg1TqWSE5gUmM0RVhP4rSkyDFjCunerWegATGyyDlzQE62F6Zw56RIWYIkzTSKXUIS3NvYCJDcZRU0Q94lZBO0OcDpEK6Q==
    GVEqUodRYnAvYGrRwaCjhKFWec1EUAp7iE6HPWZQwHw6IvUCpk5rWkKtgqUKyjPlsJKIwDQJiZV4hE26wr2AiQ2mHgTkXdONe+YF115ZJKzj1kHpcieG0D7A5P2w50ZgCwXAMg==
    DvpBEXliuLEBQSY4UTj6ABMbbB2zmmoL87qBzUHRDYRCQ45QpEjFNEv0AqbOw5xJqSKMu5CeLKIayCmkV0hVRLuQFo5ewMQGcwvVSTlvgzMsOmod1FjlPeHQkEuetpe9gKlFpw==
    PMVEWq2gzZXOmAh1lxkeFdEcubS97AVMbDA0WN7iSHUgCGQvjGJR86gjNAvu1JGfXsDUpTnCxOCQJZyCxgMMlIRxCUXBEBrciQMpvYCpY5gRyE5YYE8JC0QZGNiDEEETCSXiRA==
    L9ELmNhgIWHzFBK+RYwR7Gxz4CwETDjDmp44KdMLmLpwRC+ZDVZQTZlR3kJzC0kWaphFioY0JHoBk4cEgoFXYu4iZVFpQxHkJhQtDdHqEyNSL2DqLBE5dlTaoB1nDMQEHWOIAg==
    WhonuQwszRJ9gIkNVtZKaomJQUBPS5RWEmpAVJQqF061l72AqUuzdD5GHA2GShuNM0JhHgw42gRDUHpSphcwscEO1gkikAhot6Cj5WAHI9pLSAEGGZ/2Er2AqbMEalTUdAVcMA==
    T7AikRmMeURRNwdz0izRB5i6vbQyGI498bBypjkVRJiDWgCTu2A0pL1EL2BigwOUAKOh2DKuYYqA6cELxpprCmSIXKQr3AuYOq1RzwWBfpFIx5iEViYQwo3GjliMQjrT9QKmbg==
    fhRnwQcMgy8ULgTjZXOcxEN3YJr+Ni0cvYCJDYY6S6HN4kFB8+VhTtOYEi0pDDtISmYSg3sBUzc/DhpbohlWQTFJtLWUm8ioaw5YE5uGRC9gYoMplCwDyoG6ahk42sJ6GegUEQ==
    MkpCh5NOHH2AqQuHccHAzBMZh+lSIMuRgX48CJh8mivS0sLRB5jYYGyhe/EIehdIpJoK5SxM8dYbyF1SqNTgXsDUIUGEi15BF84ik96AU2FwiIQaEQI0C2lI9AEm7yW4N8ZB8w==
    Da0hEjCZKdkeyomyucDgxMHAPsDUWQLZgDm0WeBjRjU805j4QKyPMKrhdKbrBUzdXnLPEVfW6+asFXRcwWijoMFhxjFzIiR6AVOLTrlGNgESE20ufzDBQYOrAldRM4LSIbQXMA==
    scGaCMSdoRKryBhVSgkjrMeRcISdT0ekXsDkpZkjK6QRTGNoEz2sndekaW2DJUqkla4XMHXz4zAkJ0F48NB78Wh9UEZzQ6FNRwKn5+l6ARMbTKQQkihPZIQFg1aXYIo85FOljA==
    g+ktMbgXMLHBMKATYz1q5kgGnrZUag+tF0xAFCGfXvDcC5jYYBVkc8VOYBE1/xmlrfHOQQGG9AWzcDrm9wGmLs0e5keY0QlMaDDoeAsdApLQFRADCtJpWusFTJ0lIoO+FrKURg==
    jjkpmllNwkOhfUCSnMgSfYCpQ4JHLL3SQkGi8s3lRlEIB82ChtXCND0Y2AuYupdgMlqHCfUIpnbmlGqO/zfXMgfW3LGR9hJ9gKm7tdA0LZQ1t44wa5sLpJr8KmCiMAwepd1aHw==
    YGKDOfXRYMGclhraF6GCN8grC42BE96lhaMXMHW3FrCGblxQJQgLHIPoYdwRxIqIlFBpWusFTB3DQYJkBPUwBrPmEvHAjWiuaCfMcRjh0xjuA0xscLMwAUuCVXPACTK/YSEYCw==
    mdaTYHiaJXoBU5dmE0WwAmNGQOUKNY1ibO7KkMIYGN3T0twHmDpLaEecxbq9X0B5DOMv1Cyum4knOpnGcC9gYoOhQwyGUGphXmeUI8UDRw7BZBwEiicuoekFnDCYRFj9p+je3w==
    KLgs1h+fPrAovvP/bKwqi+3ObKvi6aX9Ho5056DxCjoIh4zwmIHYDMzMInpHKYeZxJ64Ea8PMPWePj3a/v3/AQAA//8DAFBLAwQUAAYACACEcVtKLkd8QDkBAABIAgAAEQAIAQ==
    ZG9jUHJvcHMvY29yZS54bWwgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApVLNTsMwDH6VKvc2TYcoVGknAQ==
    4sQkJCaBuIXE28KapEq8dXs2DjwSr0BbuiIQN262vx/Zn/zx9s7nB1NHe/BBO1sSlqQkAiud0nZdkh2u4gsyr7h0Hu69a8CjhhB1GhsKJUuyQWwKSpudrxPn11RJCjUYsBgoSw==
    GCUTF8Gb8KdgQCbmIeiJ1bZt0s4GXpamjD4t7h7kBoyItQ0orIRRNSnCAIekW9V2yMp5IzAMDo2QW7GG3umcGkChBAraXxY302mk4koWqLGGiA512L28gsSxkx4EOt93Wzi2zg==
    qzAiCoL0usEux35Si4CLLsaVBnV17Cce9rpPuWKcTjUfg/kyBhV15xd4bKAkJ+Rxdn2zvCVVlrI8TrM4y5eMFSwr0stkxvKzPGXPnP7y+TY24xL/dj4ZVZz+fIfqE1BLAwQUAA==
    BgAIAAAAIQDf65Kqfg8AAC2TAAAPAAAAd29yZC9zdHlsZXMueG1s7J1bc9s2FoDfd2b/A0dPuw+pJVm240zdji3b60wT142d9hkiIYs1RWhJKrb76xc3UqAOQfKAWG9nupOHWA==
    pM4H4NyAA1Lk9z++rJPgG83ymKVno8l341FA05BFcfp4Nvr6cP3u/SjIC5JGJGEpPRu90nz04w9//9v3zx/y4jWhecABaf5hHZ6NVkWx+XBwkIcruib5d2xDU35yybI1KfjH7A==
    8WBNsqft5l3I1htSxIs4iYvXg+l4fDzSmKwPhS2XcUgvWbhd07SQ8gcZTTiRpfkq3uQl7bkP7Zll0SZjIc1zPuh1onhrEqcVZjIDoHUcZixny+I7PhjdI4ni4pOx/Gud7ABHOA==
    wBQAjnOKQxxpxEH+uqYvo2Adfvj4mLKMLBJO4kMKeK8CCR79wK0ZsfCSLsk2KXLxMbvL9Ef9Sf53zdIiD54/kDyM4wfeC45ax5x6c57m8YifoSQvzvOYNJ5ciT8az4R5YRy+iA==
    o3h0IFrM/+Anv5HkbDSdlkfmoge1YwlJH8tjNH339d7siXFowblnI5K9uz8Xggd6YOp/Y7ib/U+y4Q0JY9kOWRaUO+rkeCygSSziYnp0Wn74shUaJtuC6UYkQP1fYQ+Axrn/cg==
    b75XQcXP0uUnFj7R6L7gJ85Gsi1+8OvHuyxmGQ+cs9GpbJMfvKfr+CaOIpoaX0xXcUR/W9H0a06j3fFfrqXz6wMh26b878OTmfSCJI+uXkK6EaHEz6ZE2ORWCCTi29t417gU/w==
    dwmbaEs0ya8oEfkkmOwjZPdRiKmQyI3RNjO3e2OX30I1dPhWDc3eqqGjt2ro+K0aOnmrht6/VUMS899sKE4j+qICETYDqF0cSzSiOZZgQ3MssYTmWEIFzbFEAppjcXQ0x+LHaA==
    jsVNEZyChTYvNJz90OLt7dzuOcKN2z0luHG7ZwA3bnfCd+N253c3bnc6d+N2Z283bneyxnPVUiv4yMMsLQZH2ZKxImUFDQr6MpxGUs6SRZYfnpj0aOZlkB4wKrPpiXgwLSTycw==
    t4fIIHWfzwtRzgVsGSzjx23Ga/OhHafpN5rwKjkgUcR5HoEZLbaZRSMuPp3RJc1oGlKfju0PKirBIN2uFx58c0MevbFoGnlWX0n0khQqh+b180oESezBqdckzNjwrjHiLT98ig==
    8+G6EpDgYpsk1BPr1o+LSdbw2kBihpcGEjO8MpCY4YWBYTNfKtI0T5rSNE8K0zRPelP+6UtvmuZJb5rmSW+aNlxvD3GRyBRvrjom/ffu5gkT2+LN/TAXMs0d69vMffyYEr4+GA==
    PhvpLdXgjmTkMSObVSA2rTv7j27ngkWvwYOPKa8i+Vr2Sw+a81HH6Xa4Qms0X7FX8TxFX8XzFH8Vb3gEfuaraLF+u/FT7txvF0VjTCOCjSRbtd4dHm2kGO5huwC4jrPcWxg0Yw==
    PXjwrVjtCnP6WAnuejm8YzvW8LDaz0peu6eRHnqZsPDJTxq+ed3QjFdtT4NJ1yxJ2DON/BHvi4wpXzNDfipN0ivkr9abFcljWUrVEP1XAuX19uAz2Qwe0F1C4tSP3a7erUmcBA==
    /lYQNw+fPwUPbCOqUKEYP8ALVhRs7Y2pNwr/8Rtd/NNPB895jZy+ehrtuafdIwmbxx4mGUVikScSX2bGaexlDpW8n+jrgpEs8kO7y6i6xaWgnoj3ZL1Riw4PscXz4jPPPx5WQw==
    kvcryWKxbTSYZmwE5tvF7zQcnp1uWeBlr+fnbSF3FOXqVEr7ww2f2Wu44bP6g9wEvI+Fy3kYbA03fLA1nK/BzhOS57H1oqgzz9dwS57v8Q6v1zSPJSxbbhN/CiyB3jRYAr2pkA==
    Jdt1mvscseR5HLDk+R6vR5eRPA+bbJL3ryyOvBlDwnxZQsJ8mUHCfNlAwrwaYPg9NwZs+I03Bmz43TcK5mkJYMB8+ZnX6d/TdRsD5svPJMyXn0mYLz+TMF9+dngZ0OWSL4L9TQ==
    MQbSl88ZSH8TTVrQ9YZlJHv1hLxK6CPxsKepaHcZW4qfK7BU3ZbtASm2lROPi22F82Xk3+jCK8vDxiNJEsY8bWHtJgkpWb+DrEtM/p5icBfuEhLSFUsimlnGZJflNe69+nHEfg==
    92U3eu0ufoofV0Vwv6o21U3M8bhTsiyya2LdDTbp/Lj8VUmT2Gcaxdt12VH4k4bjw/7C0qNrwrNu4d3sX5M86ikJ2zzultytbGuSJz0lYZvve0qqq8qmZFs8XJLsqdERTtr8pw==
    qsssznfS5kWVcGOzbY5USTa54EmbF9VCJTgPQ7EpD63TL2bs8v2Cxy6PiSI7BRNOdkrvuLIj2gLsC/0Wi9kYkzRle9VNCiDvy4Vvr8z5y5ap7fHadZ3+P636yBc7aU6DRs5h/w==
    60O1LGPXY+90Y0f0zjt2RO8EZEf0ykRWcVRKslN65yY7oneSsiPQ2QrOCLhsBeVx2QrKu2QrSHHJVgNWAXZE7+WAHYEOVIhAB+qAlYIdgQpUIO4UqJCCDlSIQAcqRKADFS7AcA==
    gQrlcYEK5V0CFVJcAhVS0IEKEehAhQh0oEIEOlAhAh2ojmt7q7hToEIKOlAhAh2oEIEOVLleHBCoUB4XqFDeJVAhxSVQIQUdqBCBDlSIQAcqRKADFSLQgQoRqEAF4k6BCinoQA==
    hQh0oEIEOlDVD/7cAxXK4wIVyrsEKqS4BCqkoAMVItCBChHoQIUIdKBCBDpQIQIVqEDcKVAhBR2oEIEOVIhAB6q8wDcgUKE8LlChvEugQopLoEIKOlAhAh2oEIEOVIhABypEoA==
    AxUiUIEKxJ0CFVLQgQoR6ECFiDb/1JcVbXezT/C7ntYb4/tfutKd+mL+oNpEHfZHlb2ys/rf8n/B2FPQ+PO/Q1lv9IPEiyRmcovacinc5MrbGFAXPn+et/+QxqQPfPSR/smBvA==
    Zgrgs76SYE9l1ubypiQo8mZtnm5KglXnrC37mpJgGpy1JV0Zl+WNJHw6AsJtacYQnljE27K1IQ5V3JajDUGo4bbMbAhCBbflY0PwKBDJeV/6qKeejqt7QgGhzR0Nwomd0OaW0A==
    VmU6hoHR12h2Ql/r2Ql9zWgnoOxpxeANa0ehLWxHuZkahhnW1O6BaidgTQ0JTqYGGHdTQ5SzqSHKzdQwMWJNDQlYU7snZzvBydQA425qiHI2NUS5mRpOZVhTQwLW1JCANfXACQ==
    2YpxNzVEOZsaotxMDRd3WFNDAtbUkIA1NSQ4mRpg3E0NUc6mhig3U4MqGW1qSMCaGhKwpoYEJ1MDjLupIcrZ1BDVZmq5i1IzNcrChjhuEWYI4iZkQxCXnA1Bh2rJkHaslgyCYw==
    tQRtVdocVy2ZRrMT+lrPTuhrRjsBZU8rBm9YOwptYTvKzdS4aqnJ1O6BaidgTY2rlqymxlVLrabGVUutpsZVS3ZT46qlJlPjqqUmU7snZzvBydS4aqnV1LhqqdXUuGrJbmpctQ==
    1GRqXLXUZGpctdRk6oETshXjbmpctdRqaly1ZDc1rlpqMjWuWmoyNa5aajI1rlqymhpXLbWaGlcttZoaVy3ZTY2rlppMjauWmkyNq5aaTI2rlqymxlVLrabGVUutpsZVS5+5SA==
    7OFJS/drkhWBv8ey3ZB8VRDEMwAPnmuveRJg+RY1/v2C90o86dv4QVCkHmWqgfKLH6PqdUxCWHQj0C++0odlb/UFUfl3lvOqVX9nPL48ml1eXalv2V5sNR2bL7aaVR+sL7aSXQ==
    6xhM1X19vXcCBrB7TZTs3YJwvf0slA2Gl4pnCDYcF0Ytj5fNzFckU2d37lZ+RweUXVvns+nFlb5katOWqaud4pSu6AsJCyXO1COSPn1LKrypxeodawv57d17zyY6b5jvPZvIfA==
    Zry+zMUAU6sBdCj6McC0hwHqsdJhk9n8eHzeaROLzssorOu8Q9vy2EBtH1q1re8C8KPtQ9/aboiAJ0o3t7xL8pj48InrOFdqqwyxEA+g40pR2aPLLNLjgFmaXzdIfm953aA4eQ==
    pY+J87U3DtYkd28cFIcvqjcOhmKmqkx/Pbs8kc/TkF+WsxjPgHIOk0lZHhY3VnHQyXXpO9Ww9H0atXcWymPd3hRyQ/LkoZ6RZ5kJ9LOuq1+Ryidd7/uZ5YHYFh/RyXc3nTW7jA==
    vd+FmPFb+ixXBK1TmFo0WJ1Ye3FXD3l/FonyI/7Hx1T49LPO1qqn0QtRKH5+TpPkM1HfZhv7VxO6FKHIz07Gyi/q5xfqKZ9W+UyuU62Ag3pn1Md2P1GvBdE3UFlXDGIx1qBueQ==
    N99QTffwhbr1xT466IxaKcpTSpP1fGi6jaW/5bMy6gnsajael/e89pnCu5Y7db+6YFlEM7mQU34jWxVPzNcD/4OnQPkHb5NW79xUaUSTK69ykq08zkm69Ecn4Zin0ojeDBP/1Q==
    TVyFRqX+PpHSPD9fq9dH7bujfqtUkyvapmBFap2A7TNwp9PyWFJuRhbl98QspOaHDctFlfteT7DGd6SBq6+cHqqb2IW6NK957dS9uK/NT+E2504oi5r93GNoZV/H6lSw09ieog==
    G6c3i9q7VG7Tb88BVsPRT+LeH4o+jBsF7G35QmP7esz0jFrFsJiLJdiQVWpDFOhXtGGiQJH+HwX1KDC0sq9jdWpoFGgDvlEUGE+Lkg+L2h8TeJrU0MCwrEU6Y6O2mn8/Fv/0eA==
    O8KkZemiLtfvD9m4OUB9oWnIPVYx5U3We0ObT05PERsRb7eKubgW/8QBs0RakPDpMWPbNAJl0oUuk/CLHuemXNZIzo05LKmc23JagQ1sDblgc2zN2/rulpXPptuPWOOxdV0TnA==
    tU5umagnk8lc1/+t21R+J5lqy3N/tPpkMPEx04hWrKm6KX+Z20hvttGpfvy0rwh1tGn85hzaZ89NktpWOhOdy4dtME+mzTvFPbbHLNtfe5o/7Knlvn6400uj7oc6oGFAu8o73Q==
    78211+yj1eu89lVVnfDhqSWs1Vk7U1qDFms7mz2XVn3dqNZpm3qGOlNdzXat/E81UbuUsq+JMrFPPSV2XYL2TOzm1RivV1OQulEXPmy6OfSkG11cuE96f+lLGs0ZsHzD6L7tyg==
    401Gs+U5LdOW5rQJuy8f2PPgZHp4fnKpOGDSLi98Td83XPmK5WUIUflwQ5S/4v09LNFqm0Lp8s92Kezo4vTiUt6h0+Q3XkPatKLFK4bGc825+jqJ3Qv+ilaSB5trDXVq8NQsKQ==
    +jgLnxr3CE/nJ2NVJViswG1NkniR1bRfOyhVXjsS5mKVuaZ5cEufgy9sTdIGXY/HJ+O5DmxYtHC3Kg/oQhmfIzu1b9E8KmcaduzIe6aurXnv2Ex71T5rWzb7k1uo/Cv/4T8AAA==
    AP//AwBQSwMEFAAGAAgAAAAhANZsXBeWAQAA7QMAABQAAAB3b3JkL3dlYlNldHRpbmdzLnhtbJSTwW7bMAyG7wP2DobujZ0sDQajToGgaFGgW4e1212W6USYJAqiEtd9+jK20w==
    ZMsO9UnkT/2fSYi+un6xJtlBII2uENNJJhJwCivt1oX49Xx78VUkFKWrpEEHhWiBxPXy86erJm+gfIIY+SYlTHGUW1WITYw+T1NSG7CSJujBcbHGYGXkNKxTK8Ofrb9QaL2Mug==
    1EbHNp1l2UIMmPARCta1VnCDamvBxc6fBjBMREcb7elAaz5CazBUPqACIp7Hmp5npXbvmOn8DGS1CkhYxwkPM3TUodg+zbrImiPgchxgdgZYEIxDXA6IlFoLLyKxKr9fOwyyNA==
    TOKREu4q6cBiyU9a6R0NZ9LkuirEl3k2n00XWVcusWpvutJOGt4Wke5Vfs8HqONBzd7Vn3q9+Y/8jP5cXGGMaP/RuY1VFfZRPHoc76HghF739/aBlwqGWKFBXh+5jdgjzEln4w==
    nOVfHY3zhtPJx1jT49B9eDi7Z0EftdWvcIthFbAhCP3XwLSP7ve3hy6TxmDz4/tdTzv5SZdvAAAA//8DAFBLAwQUAAYACAAAACEAUiJijLkBAAA8BQAAEgAAAHdvcmQvZm9udA==
    VGFibGUueG1s3JLfatswFMbvB3sHofvGshOnnalTtqyBwdhF6R5AUWRbTH+MjhI3b78j2clgodDc9KI2COn7pJ+PPp/7hxejyUF6UM7WNJ8xSqQVbqdsW9Pfz5ubO0ogcLvj2g==
    WVnTowT6sPr86X6oGmcDEDxvoTKipl0IfZVlIDppOMxcLy2ajfOGB1z6NjPc/9n3N8KZnge1VVqFY1YwtqQTxr+F4ppGCfndib2RNqTzmZcaic5Cp3o40Ya30Abnd713QgLgnQ==
    jR55hit7xuSLC5BRwjtwTZjhZaaKEgqP5yzNjP4HKK8DFBeAJcjrEOWEyOBo5AslRlQ/Wus832ok4ZUIVkUSmK6mn0mGynKD9pprtfUqGT23DmSO3oHrmrKCbViJY3wXbB5Hmg==
    xY2i4x5khKSN6/UoN9wofTypMCiA0ehVEN1JP3CvYmmjBapFYw9bVtNHxljxdbOho5IjOSqL22+TUmBR4/NlUuZnhUVFJE5a5iNHJM55D34zGxO4SOJZGQnklxzIkzPcvpJIwQ==
    lphEiXnEZOZXJeIT9+pEHv9P5PaufJdEpt4gP1XbhVc7JPbFB+2QaQKrvwAAAP//AwBQSwMEFAAGAAgAZG90SqtrCc0IDQAAIH8AABMAKABjdXN0b21YbWwvaXRlbTEueG1sIA==
    oiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAxV1rbxy3FeXnAv0PRr6nqfWyEagbyE7sOPBDsVSn/mQokiwLth7YXbnWn297Se6Ij/vmCiiMRNrhuecc3g==
    4XA4JGf13//shp/Ct3ARvoQH4Ws4DfOwCOfhKlyGf4TvwsPwt/B3+PkASi7DMRw/gdLLcJZKb8IyfAzfA2oHPv0UZuGv4S9hN7wOR8D1B6DngH8Lsdfp92X4V1Lah/L46cFK+Q==
    EjQz3xx+/xGOnYPWHGIW8N9HQH4PPLdQdrQqW8CRy6TyA+AK/wI+H8DPIyg9SSon4QMcOQKVUyj9EF5AyVdAR5ZTQD8Mm1DDHfjtu5X/B/BvN/wKpUcQHTNSjueyJxD9Bf4tgQ==
    5ym4XqTfLhL2Nfz2IbwMf0L5zIzcBX07q+7mpoqjXdQITr1laVWfJm/XKdO3YQ8ydZLOxAL+PQS0XB4VNQa73oait6Hqbbj0NhW9TVVv06W3pehtqXpbLr1tRW9b1dt26e0oeg==
    O6rejqL3JP38DFHHqRe7gU/LVbu2IrEHiXXMTbnGvREed1xPQsc/gSwfpd7/k5ixHsc7wowjPrRccXi7L1+eXqe70ynrZyrn9QuDR0/LQ4/T9W31ru9Rz+HuMSfaBoXB+jSTVw==
    m8uDhLV5seXjl/AKfjsnHJQSrFdHSeyTF+oKrMuwQhtp1eCySWFkTVv2fl2NdeLY8Iy4ivpyrIkZJL0X0Or3wF+vMx3H/CXCwsvlry/ndWx5ewk1PUvj2zcwUv64Gtf2qjQKaw==
    c2x+B1z9ZbTVkTc3+ZlgCZ8v0pPMUvCFsZIriln2dAWRV9BKr9KT1nL1tIX90DjKC8co+diHe1xEnZI9SluKNftouxLXLmiUpmxrB/up1SzT8+UplP+g4N+ms3ue7gPzdHZzRg==
    X6cnoj9Xz4T+GFwbm9K6Xrmce2LHvNvOz0H4A3q9Z+EQOSwlWL+OsrFzecAISc1Wp3fQhx8KOcLXnB6BXVlU1nPJ5cweOeLan2Mto3r+fNmy5saeCa3e14BvFesjE3eL6lnaWQ==
    JWrWRkZkFY3Fo7qhqm4YVKn5Gwm/qapuGlSpWRwJv6WqbhlUqbkcCb+tqm4bVKkZHQm/o6ruGFSpeR0J/0hVfWRQfeRUfayqPjaoPlZV8whvmcad8Zl9nq74k9V434qlnEjMrQ==
    p59Tj30NuKO7Wbgy5ozxzyAqj86WKd4bEf35VXqXVzDiu7kbk0894yF8/pbG6Boiu9BYZNWfV08GWG0qoVRKlI299PYaQlLj7hk9Pt8lqaMUO3VPpTB8Hfr7pxwtKx2mNvRFzA==
    GcZQqhRTr30DpXULqD9nzhYhxdd+qeOYj/NV5ps+NGtcBa8hopbO0qt+S7OqcdQT52berlzuwVVeriYLKqtb2FoHz8HVFXiLfcfLdDa5py0rMjqxs465Kfn0RnjccWetn1Hjzg==
    tQ0XHVkZWx/tmm2+N5QVjT1gnH4vDP6Y6G9EyeM13lsXqaX6PUuxundZua1Dmd36JeFiXxfverdw94s9lVwevWgMHr3i0obT9fl6n6eZpTpHe2n/QWydcn5rl+uz5Drch5u+hg==
    uRf4kkaA8zT2jOtdt41/DZPd6Uyt9pswX13neVTQfo6cPUKKLyr0cczH+Yp90XH4vOqRDtNcRPyc97lkJzom6lmYvNrFtR1r8yLl46y5SvojE/+ZcC3tp5H7NF56BT+Xaeb2BA==
    2uppaqtz8HIdymy1N2Jy4VNZz2Wbk5HIEde2HMdZpI+ptecr8RS5xAjshmLxqXI54pEWF7YcHKaYC8ihrZVpeOxMV1jHH5c7a5zfL5/X+ereskj3mmPA3Nzt/svzljMTKnuysA==
    +R3U+bKjrY7Wyc37VDrdPTx4q7taofUXr56L9Hx2uYqoxxAzpTzqawwevfJEZsPp+twzXtnn2Y6OppEUP0oajdxN+01HVTn3+yHvw22vT7m8dUIzWPSepDm3uBtIU8ZI3gPFag==
    cVN2RMnlvDK3p+oAjkm7bWcqImtqLD7VOuc2pMUFn/NP6V4w3Stqdbokq3FRMnuZ6eJKKHZufozD8XWg5sx0FlnVMuL0x1DO/GNbPwOfO9/4dh1lug7Xd3eBs1Dm4k+a1sRjag==
    TxKTVxvnS8favGj5OARcu3qEvfCY2oPEZNV+KKo+VPTwijGP3RCVNhQlvErMYzdFpU1FCa8M89gtUWlLUcKrwTx2W1TaVpTwCjCP3RGVdhQlvOrLYx+JSo8UJbzSy2Mfi0qPFQ==
    Jby6e5B6xH8TvUEdNzPiJnULI+0jv6/1WbyP6bjah8bY+7iBfieOXPI6dN2j0SVZi4tq2Q8JBD4WGSlky5Wfv+iZdL4sckuRmsZBmrs+huzlXbBHxN1zJIr2ZVGjHE/rDL2n/g==
    eFHFERTv0/QEcUNyU2WFn47UNBaiykLR4e+iGfsi3eXzykTMb7v6pWOKqsxEaeeno+NVVD+Lq2OKtsxEacs7FW07IP17Hj37DX37Gsd3Mr5PV9qcnG/ly6KmFGnVKK50jKyprQ==
    pbXHc1ndz+S1fHrubWLw4aNfr8K6HksWxuL8num8Y+/S3CaVXx3fe7UorOuRzq89zu9Zyi//DDvVV0Pk/Toai1+5uLYiLU6kXLwI+d2Xqa+bvNPH8z4FOsLKXe+XkMp5Lak+vw==
    hbhjJt9Fyu+Rqy6R4go7Ptby6D4O09iojKB7bq686PAMVs1+1G5B8frSMwDloj4T9TGsIJ+ZGsVlkT5TdCTWofZr1O1bLud2fMhXiBxR3NpwugdL/fv1jnaUSGXEGlH7s6uMOg==
    nVaZ/I5xpN05pcrXoO9D6eO1ut7r/g6+jkLZNVWj+bKoIUV6dEor0zGyrtRepbn/ybWO0VYR+PrrUba1DJwPDzP2lfcKxe/kqfdmtuu/OibPpOhMlH7ZpTdlDx/L/BiJ+f4ZLg==
    U7sode6PRC6M4pnim8ivUo0WIb9TOhPKanYq0qOD68BjZF1LPcsuhBlxrOavkRY+XA9cRvNLvuUZkamFWFD6/Arf3ixx1rkefG372Dl3++G4u8fQx+u5nj7Cyo3nluhyXsvTiw==
    8/4ynn5/hGfx4fk3VLw+pzey8tNp6cF5Hm9E3mfkVbkft+WMjkaOuOfbETci4fNgx9IjFG+G7QzS6MmS1RElfF3iUYg8G7RI8+YXie/WcBXTMxY8jzdCmhfxum3H3ny0DYdH8w==
    Xj/4DPMMdizddrzepBELzzUSpY2PvM7fhaPUUnL9y04Onscbke+QXhXq2rSh65bWl8hru1NUv9rsiZ0ZcdGllXHUS/sunz/G7lF6a9DKgdf48fquPO9qfwtOYr4fHu97ef+Pug==
    1nPS98l3f3WX5/D9bw6On3cv3+i7jffZDrwK1vYwynv/OfHPbL9L4206v94IfuZZUlnfqTZDrkeOOJdyHUd0cTTCP+fH3t2Cis5sbNyTvP1M+PDcTijfufYx9LMQI+d5VNHi/Q==
    JYzl3iu91kgU7duidj+upbzbo0droZ+DsvtMb98WLLWvbaRdW6L73HpifD7tebS3Y3sE9rpO+7VzcPkdabcjqr65Zb39euO0+eaRdu1lss2Ue9r7uANtxls/AzoSz4KPZFmP5Q==
    ZuU9mfSo9E+y1iuX2psr1b/MiEhxFlR0aWMbc1Fy40FbXUmtlpvXlOroj5FmUH3ZpFk2hhzLUbxnTU0bybe7w/sRfFuKR+59tHU0zPv14fnRrycjVF3av7OjIbjd9vxf67Hcew==
    tCx54/R7jS1rdG05bNybPf0dpPIOy0I8I+3Z1Bl8+H7XrUVB9vgsxV6k+01c6ztxux5h6Osx5sLeD+tco5FSnzxSg2cpNs42XQHWlgd/THQ9osT7jes+ubf4cne/tDsfia7rMA==
    pt73DN6I6Xj+5lRp9iwjngJfaR/lOzcsqHpWTGbj1psol9R3D00ZiFHxTcc5/L/svaBq2XIcpPPwNUzf2ZH/lgL+GwH22A9wfucBf4ePjM77GTzs67krZ2AkyuuWPt+667Ib1g==
    ktMerbnE7Ou5s+WUi/K65a+h9a6S/H2M8XsGtVEVhSvftyKV5itdirapvUt93g2rV8o5xZoB90VaHuKo6xxy+cmQLRpZaiyX5x5fZrBq1nXWELyulDlLVvIZzSOoudhDPEnPuw==
    9fdu90eiJkZRz+XxG3EXq+ugIOnj+VmbjsDcz9O+kdO7q6xguZLIz0dRfdFFWN6t9NW9DXU89wR0BNXS5TOx24wx6H3bUzn1JmNcrYw/8/PMzIVu38q3sK/nrmRgJMrrVjrjNA==
    zxSPv0HPh+ed8gqSR+6tVSqfGrb1pjNLvrjaUL40bOtLZ9Z82XZ29A5tUdirVU1y/Tr1FZw7XNq6oKIltXYs07t+A//Hbd8a0zqzK0l+8/eRlM8zoazVx5EenVep/cUZIvk8Sw==
    fqwcsm+7E6l+1LVJX4O2aw3PXs7E0laDivap5XU/WTNjNOWJyadP5ZNHaR48OW9XPrF+W04p9wz96IUemcQSPPrMc+u2v08/C/8DUEsDBBQABgAIAAAAIQCTdtZJGAEAAEACAA==
    AB0AAAB3b3JkL2dsb3NzYXJ5L3dlYlNldHRpbmdzLnhtbJTRwUoDMRAG4LvgO4Tc22yLLbJ0WxCpeBFBfYA0nW2DmUzIpG7r0zuuVREv7S2TZD7mZ2aLPQb1Bpk9xUaPhpVWEA==
    Ha193DT65Xk5uNaKi41rGyhCow/AejG/vJh1dQerJyhFfrISJXKNrtHbUlJtDLstoOUhJYjy2FJGW6TMG4M2v+7SwBEmW/zKB18OZlxVU31k8ikKta13cEtuhxBL328yBBEp8g==
    1if+1rpTtI7yOmVywCx5MHx5aH38YUZX/yD0LhNTW4YS5jhRT0n7qOpPGH6ByXnA+B8wZTiPmBwJwweEvVbo6vtNpGxXQSSJpGQq1cN6LiulVDz6d1hSvsnUMWTzeW1DoO7x4Q==
    TgrzZ+/zDwAAAP//AwBQSwMEFAAGAAgAAAAhAFIiYoy5AQAAPAUAABsAAAB3b3JkL2dsb3NzYXJ5L2ZvbnRUYWJsZS54bWzckt9q2zAUxu8Heweh+8ayE6edqVO2rIHB2EXpHg==
    QFFkW0x/jI4SN2+/I9nJYKHQ3PSiNgjp+6Sfjz6f+4cXo8lBelDO1jSfMUqkFW6nbFvT38+bmztKIHC749pZWdOjBPqw+vzpfqgaZwMQPG+hMqKmXQh9lWUgOmk4zFwvLZqN8w==
    hgdc+jYz3P/Z9zfCmZ4HtVVahWNWMLakE8a/heKaRgn53Ym9kTak85mXGonOQqd6ONGGt9AG53e9d0IC4J2NHnmGK3vG5IsLkFHCO3BNmOFlpooSCo/nLM2M/gcorwMUF4AlyA==
    6xDlhMjgaOQLJUZUP1rrPN9qJOGVCFZFEpiupp9Jhspyg/aaa7X1Khk9tw5kjt6B65qygm1YiWN8F2weR5rFjaLjHmSEpI3r9Sg33Ch9PKkwKIDR6FUQ3Uk/cK9iaaMFqkVjDw==
    W1bTR8ZY8XWzoaOSIzkqi9tvk1JgUePzZVLmZ4VFRSROWuYjRyTOeQ9+MxsTuEjiWRkJ5JccyJMz3L6SSMGWmESJecRk5lcl4hP36kQe/0/k9q58l0Sm3iA/VduFVzsk9sUH7Q==
    kGkCq78AAAD//wMAUEsDBBQABgAIAIRxW0qrZ5+I6gEAAGEEAAAQAAgBZG9jUHJvcHMvYXBwLnhtbCCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAJ1UwW4aMRD9lZXvYQFVUYrAUZUcemiVSNDkPPHOgtVd27IHBP21HvpJ/YWO7WVjinopp5k3z89vPMP+/vlreX/su+qAPmhrVmI2mYoKjQ==
    so0225XYU3tzJ6pAYBrorMGVOGEQ93IJbvHsrUNPGkPFGiYsDrQSOyK3qOugdthDmDDDcLG1vgfi1G9r27Za4aNV+x4N1fPp9LZurIpq4WVzcqw/6IH7Xz08EpoGmxs3ehTJ8w==
    BnvXAaFcaw50q7Gp1tBxC2eBSWPpuKxLbjpoCbqN7lFOc3HM01PAFsNQyXFEX61vgpzdfUx4ziL+sAMPivjNhyMFEOufHFtTQDwR+VUrb4NtqXpKfVZRJh0qWfEUN7BGtfeaTg==
    g2yJRMYXbUaXOc7ePWw9uF2Q86GBEYj1teL3eeB3lC10ARPlHYuMzwhxXZ5BxwYOtDigIuurNwgYB7oSB/AaDPEm6R+czkWmZTTFnQvk5UZTxzeMeQpLWhnrD3KWCBxcEuvRgw==
    THYvDcbpxXvCU8ut0j8sJwNnwzNRmLzyV9z0l3Ccre0dmFMuj0mewPfwzW3sY9yx97e9xC/35VXTbu1A4fXmFKU0NS5gwxtQTm3E0tS4Td/Fy1jEbLEpmNe1YS9f8odCzm4nUw==
    /p0X8Qzn/Rn/c/IPUEsBAi0AFAAGAAgAAAAhAN6tba/mAQAAYQwAABMAAAAAAAAAAAAAAAAAAAAAAFtDb250ZW50X1R5cGVzXS54bWxQSwECLQAUAAYACAAAACEAHpEat+8AAA==
    AE4CAAALAAAAAAAAAAAAAAAAAB8EAABfcmVscy8ucmVsc1BLAQItABQABgAIAAAAIQAFuId6dAEAAHMIAAAcAAAAAAAAAAAAAAAAAD8HAAB3b3JkL19yZWxzL2RvY3VtZW50Lg==
    eG1sLnJlbHNQSwECLQAUAAYACACEcVtKwbXjETwZAABZNQEAEQAAAAAAAAAAAAAAAAD1CQAAd29yZC9kb2N1bWVudC54bWxQSwECLQAUAAYACACEcVtKVhO0hbIHAAB3JgAAEA==
    AAAAAAAAAAAAAAAAAGAjAAB3b3JkL2hlYWRlcjIueG1sUEsBAi0AFAAGAAgAhHFbSuR5DvO9BAAAzhMAABAAAAAAAAAAAAAAAAAAQCsAAHdvcmQvZm9vdGVyMS54bWxQSwECLQ==
    ABQABgAIAIRxW0ov1j594AUAAI4fAAAQAAAAAAAAAAAAAAAAACswAAB3b3JkL2hlYWRlcjEueG1sUEsBAi0AFAAGAAgAhHFbSpTlcz7KCAAAP0kAABAAAAAAAAAAAAAAAAAAOQ==
    NgAAd29yZC9mb290ZXIyLnhtbFBLAQItABQABgAIAIRxW0o8ahuwKgIAADQJAAARAAAAAAAAAAAAAAAAADE/AAB3b3JkL2VuZG5vdGVzLnhtbFBLAQItABQABgAIAAAAIQDvZw==
    7PC5AAAAIQEAABsAAAAAAAAAAAAAAAAAikEAAHdvcmQvX3JlbHMvaGVhZGVyMi54bWwucmVsc1BLAQItABQABgAIAIRxW0rx2O0eKgIAADoJAAASAAAAAAAAAAAAAAAAAHxCAA==
    AHdvcmQvZm9vdG5vdGVzLnhtbFBLAQItABQABgAIAAAAIQCqUiXfIwYAAIsaAAAVAAAAAAAAAAAAAAAAANZEAAB3b3JkL3RoZW1lL3RoZW1lMS54bWxQSwECLQAKAAAAAAAAAA==
    IQAyUn61CgAAAAoAAAAVAAAAAAAAAAAAAAAAACxLAAB3b3JkL21lZGlhL2ltYWdlMi5iaW5QSwECLQAKAAAAAAAAACEA/Wf50SQBAAAkAQAAFQAAAAAAAAAAAAAAAABpSwAAdw==
    b3JkL21lZGlhL2ltYWdlMS5wbmdQSwECLQAUAAYACAAAACEA0nc7M/UAAAB1AQAAHAAAAAAAAAAAAAAAAADATAAAd29yZC9fcmVscy9zZXR0aW5ncy54bWwucmVsc1BLAQItAA==
    FAAGAAgAAAAhAPIykO0VEAAAQJwAABoAAAAAAAAAAAAAAAAA700AAHdvcmQvZ2xvc3NhcnkvZG9jdW1lbnQueG1sUEsBAi0AFAAGAAgAAAAhALBuMYX2AwAA2wsAABoAAAAAAA==
    AAAAAAAAAAA8XgAAd29yZC9nbG9zc2FyeS9zZXR0aW5ncy54bWxQSwECLQAUAAYACAAAACEAg9C15eYAAACtAgAAJQAAAAAAAAAAAAAAAABqYgAAd29yZC9nbG9zc2FyeS9fcg==
    ZWxzL2RvY3VtZW50LnhtbC5yZWxzUEsBAi0AFAAGAAgAAAAhAG6MGelOCQAAfyQAABEAAAAAAAAAAAAAAAAAk2MAAHdvcmQvc2V0dGluZ3MueG1sUEsBAi0AFAAGAAgAAAAhAA==
    lyh2tOIAAABVAQAAGAAAAAAAAAAAAAAAAAAQbQAAY3VzdG9tWG1sL2l0ZW1Qcm9wczIueG1sUEsBAi0AFAAGAAgAAAAhANpP0QD9AAAAUgEAABgAAAAAAAAAAAAAAAAAUG4AAA==
    Y3VzdG9tWG1sL2l0ZW1Qcm9wczEueG1sUEsBAi0AFAAGAAgAAAAhAHqocnTFAAAAMgEAABMAAAAAAAAAAAAAAAAAq28AAGN1c3RvbVhtbC9pdGVtMi54bWxQSwECLQAUAAYACA==
    AAAAIQBcliciwgAAACgBAAAeAAAAAAAAAAAAAAAAAMlwAABjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbHNQSwECLQAUAAYACAAAACEAdD85esIAAAAoAQAAHgAAAAAAAA==
    AAAAAAAAAM9yAABjdXN0b21YbWwvX3JlbHMvaXRlbTEueG1sLnJlbHNQSwECLQAUAAYACAAAACEAJz4oOx8VAAC5qgAAGAAAAAAAAAAAAAAAAADVdAAAd29yZC9nbG9zc2FyeQ==
    L3N0eWxlcy54bWxQSwECLQAUAAYACACEcVtKLkd8QDkBAABIAgAAEQAAAAAAAAAAAAAAAAAqigAAZG9jUHJvcHMvY29yZS54bWxQSwECLQAUAAYACAAAACEA3+uSqn4PAAAtkw==
    AAAPAAAAAAAAAAAAAAAAAJqMAAB3b3JkL3N0eWxlcy54bWxQSwECLQAUAAYACAAAACEA1mxcF5YBAADtAwAAFAAAAAAAAAAAAAAAAABFnAAAd29yZC93ZWJTZXR0aW5ncy54bQ==
    bFBLAQItABQABgAIAAAAIQBSImKMuQEAADwFAAASAAAAAAAAAAAAAAAAAA2eAAB3b3JkL2ZvbnRUYWJsZS54bWxQSwECLQAUAAYACABkb3RKq2sJzQgNAAAgfwAAEwAAAAAAAA==
    AAAAAAAAAPafAABjdXN0b21YbWwvaXRlbTEueG1sUEsBAi0AFAAGAAgAAAAhAJN21kkYAQAAQAIAAB0AAAAAAAAAAAAAAAAAV60AAHdvcmQvZ2xvc3Nhcnkvd2ViU2V0dGluZw==
    cy54bWxQSwECLQAUAAYACAAAACEAUiJijLkBAAA8BQAAGwAAAAAAAAAAAAAAAACqrgAAd29yZC9nbG9zc2FyeS9mb250VGFibGUueG1sUEsBAi0AFAAGAAgAhHFbSqtnn4jqAQ==
    AABhBAAAEAAAAAAAAAAAAAAAAACcsAAAZG9jUHJvcHMvYXBwLnhtbFBLBQYAAAAAIQAhALQIAAC8swAAAAA=
    END_OF_WORDLAYOUT
  }
}

