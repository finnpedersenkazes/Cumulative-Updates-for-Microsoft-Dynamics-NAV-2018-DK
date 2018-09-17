OBJECT Report 1306 Standard Sales - Invoice
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
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

                                  IF NOT IdentityManagement.IsInvAppId THEN
                                    CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FillLeftHeader;
                                  FillRightHeader;

                                  IF NOT IsReportInPreviewMode THEN
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

                                  IF LogInteraction AND NOT IsReportInPreviewMode THEN BEGIN
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

    LOCAL PROCEDURE IsReportInPreviewMode@2() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
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
        FormatDocument.SetPaymentMethod(PaymentMethod,"Payment Method Code","Language Code");
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
    sF6Ai6B35o8sBsWHcHP8jfRnEHQGZaOMYbobntmiDCeUfx8NUHTnV2H+AQAA//8DAFBLAwQUAAYACABaYRhNNffPvTocAAAJYgEAEQAAAHdvcmQvZG9jdW1lbnQueG1s7V3pcg==
    28h2fhWV8uP+4rD3RXU9KaxjJx6PYvt6kkqlpiAKkhiTBAuEJGtu3SfLjzxSXiHdWEiABCiAAilQhKssYm10n3O+s/X2f//zv3/95x/TydmDHy7GwezdOfwJnJ/5s1FwPZ7dvg==
    O7+Pbgbi/GwRebNrbxLM/HfnT/7i/J9//uvjxXUwup/6s+hMFTBbXHjvzu+iaH4xHC5Gd/7UW/wUzP2ZuncThFMvUqfh7fA69B5VwdPJEAHAhlNvPDtP35+PRzuUoN6K7kM/Kw==
    xINko5DpeBQGi+Am+mkUTIfBzc145GfFqEIgKFTjcb5ZjdISHoPwOnldH83DYOQvFqpIy5s9eIusuGmtRk298Pv9fKBKn3vR+Go8GUdPcfuyYgLFinB2kRYxWFZIv3KRVCj9yQ==
    3gjrfDd5xU4ZmVA09CeqDsFscTeer5qxa2nq5l1WyMO2RjxMJysW1OViFQ/shLurAneQrO0lQlCDI7qI5Rt1qlD8ZhlKHncjTY64kDYrAK0XML99GXN+CYP7+aq08ctK+zD7vg==
    LEurpwZlpUzON23xssp8ufPmCoHT0cWH21kQelcTVSPFsjNF9TMt1udacV4F10/6N7qapD+XYXrwJXqa+GePFw/e5N35V/3+L+FYydAwvf+7uqckiQKg1LS68jRXH5iPotUTpg==
    qpBS5vFZMM+KminVrV8YBZNAaQbvPgr06eLPd+dxQYu5N/Lj47iciX8T7fjqVRBFwXTHl8Px7d2uHx7PFuNr//2L3v6209vDDcJfTSx/MvnVC3PEfExfTXh2/cNba3P5/eF6aQ==
    6uxjEHzPKgqIEb91Mw4X0edAFQL16cRLz1Y3rWByP53l7mcX4kdmwXtT2fjl2bfkDOYqsRRSLZL68Fb9qkKSuhOEcNqiwnUqBc4Vkr0bheq28jmuP18q+gKAAHFxXLX4or5kEQ==
    TMDy0tcwdy0pIanQyJtFX+bKYqYQCN/7eSlCcsWk9I3FdZT+JOfp5atUgK1F+nx63ZuMvUVW3D998h4uzobvfU8xe2jdL5Sw+6FxfR0qDQAzGHq3xee/xP5TeP3HF2/iL/74MA==
    ewi0GoFYW/hE/q6zNwaYMIY5Qjy9NZ8oWbsLJuqDqdt16YXL9lmO7VIHEwwBI6bJTFPahHAGLG4QdZQ1fr0UL/LM8Ux7eaqkeejfjH/86s3n6lzpwEQdzhbg3V+0kVsZt+unmQ==
    p84Wg5n3oDyFeRBGi+GW1g3/ovn3Q3k1d+/Oh6rAC0WP3xVSPsfv/vt0otvyn/C/4nsJVbOzdeKq6zH0oiD0P0T+9IP97vzvAHLgAtsdWK6LBkTaYCA4wgODGrZAHCMO7H9kbA==
    8X9EKTWWvFcHzux6TQ4ybJ2vJKJwKZONYfF9dWwFs0j5PvHXRsnfFDajVHUjwOSm6h6unpw3BMalvmRTYjvO8inbv/HuJ9EaYubpBwpG5lPwRemy2LVJBSUlRmk1cmSaeLOllA==
    X3sD+1/Pi7CJfl5nYNzK5JHkS2m7M0IuiTfMY7QA1W1Y1M7z7KlVKELIoaSKY7QWFim2XQMyYkkuiWEx4dgGsIXpSmIx22JHjMUicfcKxeSJemCSCTS6CabHi/8eZXdiK78HiA==
    FfnSGGGxVeyaPa5vcFEbKEcQQS4xEL3BLRK3Myg/WZOJDmkyWwETpAgyRhGoZzGBA6VwEMOCIeJQaHIiHMaQyVwg2CpyOEIwFWnbGSz1FrPAl1OzmLgNkFPMsKSQst5gFmjbGQ==
    kJ+swcSHNJitYGkAgYITxIyB3mLmidsZMPUWs8CXU7OYpBW3GCEJgYSwN5lF4nYG5SdrMskhTWYrYBoIghFFktQD06lYzO5gqbeYBb6cmsWkrVhMAQmgHPLeYhaJ2xmUn6zFpA==
    h7SYrYBpAAUmUig4wd5k5onbGTD1JrPAl2MwmZy0ZzJZKyhXKll7xpTUQ/nJ2EzWGZifrM1kh7SZbaFJ+Z+YkZrjAk7FZnYHTL3NLPDl1GwmbwXlnCEGqJCoFsiZw5llMGwTKA==
    CAFIONRgrgsU5C1qSnjEIF8jbmdQfrImk+9gMjuiKqUJhUXbUpXN/YCP/q03+S2eq/PHx6tJOyE0g8q7BrRm1lmbfQdyBAUjRFLDMIjjGKZrYBs5BrWPWFOU0vjg+qK2zdrFpg==
    rjVuHYnl4AsrPh7PkM2mDCmWLvzwwT//+axQ6gvFvJWUK8YIAgiRqCXhruEyx2QQEuQQWwDThq5rcwdzZhgAGG9Jwt+sdNeR7HXTc8xOo2gDKJRDwigQ9XxGS1rIMqFU3qIkwg==
    hqZtMGRQadoudS1+zIHhGm17n/G1fUZxvD5jm+F1mcbSP8mE67WK2yaWEBcqXqzlMxVP7+Qqvkgqqp71biI/XM0kzNTXn0uTm6mQxZ+rSYbpxYzNxUY9vmDaeG5+cTKjObvfTw==
    Gu/EpPGP3lNwHy15pBS+n2PiTlPKKeObTwzXy+vqpHJEiUzb1M714WP5JPRNhCfeCucqWOPnZT5HTRW9xTX5j+A+/Ozf+KE/azNO1ZcRVk2ul9HCCEnTgdAAhGD1Y3BhEceWkg==
    cIdBerzeyQZ5O+OexNJYBsp1y9qCLSoaUU0hxaKsf1Bpm8l45n98mCyhv91FkYJSCpq5KBt82G9XUCxEl0qpBjNTVe57e8AiinFQClivP8gB0kXYdogSJ2IQbjLmEKRzxS4wiA==
    FMcLrDIK99h6FWyVsaIFeL3cttn3vu1FLVo1RCEjUtaMuYmLJCXMkNJEJA68DQYMCymbhoU0jtiq5QjbY+5VMJfjQCegduk96fX2vvrhdGH7i1E4nuv1+9qCHpSYMCRYzdmekg==
    c4MAZegcpv9Sk9mSMkYtG5kmSG3nUSJvC527jUT9QBroPb/YWPLkmwXvFia2N37CtbGFVyTZIbisGzW2AnCGACZIebe1AI5dxgiQqjmuRZABhFAHQEKFewoNfsQAL1C225CuTg==
    wz4re/VBWy7Vu8d+B4v7PnnTVpAxQEBirBgr69k+rHxUBLGCk+UQLoFpcEa5oCYkDmfMPF5orBG3B0cb4Fgj6n7hkXqtrRgMDjBEGBNcCxXANRwVeEkIHEgM6hiOzRxpAe6YLg==
    t/ERoyKlaY+GNtCQEnO/KKhw/1oxFgRKqRdmrjf5ghLLsCgDBjFMol41CQQmlQQI/Wsf8fiwChp3GyUtxUhdBFYFP9oLdyzl9hhwT+HOb7qD9FPQYiKRMSygCnjqDXJDXGBETA==
    TiyXID1QnFlYGgaTDpUWP2LjlSNst6FZjbNnBe/QCYp5GAQ3Thgu27CY+5OJYmCYrdBfDp0EqDmOFMBZVa4i7/L77YZSd+O5Vhm/+tFdcL2HnOIgnj0BWDw6oVZSkTFbuY+QAA==
    9R4D0mVQIOAqyTRcEx0xCreSusdlJ3C5lUevi9TUtu8NqEhgxXvGa/a6mch1lIdi2gARw4bKRlpEOg5FDjWRbR0vTLfRuUdpJ1C6jUWdAOkehnoBRoggnNTL3NvUxTY1bUGoig==
    OrElKDSYQZRXLrBpmMcfch7RaK9W4823ieTqMWNtIPh1Ou9SF7+VLKxgnEvIRL1xnrbh2hYCADFiEMbjGNY0pckd7hocuscL/pSm3cb7sSSLUmJ2YmBLpd/djvFkAlERzxSqAQ==
    H0twISFhtgsNYnNpWjaEAlBlOxGwyBHbzkoq94BqpZOvirydgFiV09wKwjCVgGAk600ndgwTEpc5BiUmsbErhCldYTNhYg4d84inSVYRuQdYi90bncZXy+O1IOeQIFAPVwgbyA==
    MCxoKdNFlMUzsCGEsCwHWK5yBI94HsI6cbuNp7ffw7j7QK8mwZiAXLqgGIwRyA3T2TZN7yrl32rmbYaewsxbsda2XCZU4Q3QupvEpaS+XD30xwAKSgDEhIByyEF6ONCdvcxf1A==
    FTJuFQut4LqNZMuBDVhRhEqk6hn0EAFsbubzJSNdxx/RvTdJJ6mnWY4XCF+jbMrLJT3xVDcYe4DM6S71fl4r5ffe4JIiwWsu3PSGoXvpjb57t/7XUP2qerXS+d9Dt75UriC9Rw==
    wdfmuITN7bnDLdd3i/f8cTzzh/8SXLU4/AdDISCEvGaPyQ664Bg8Z03Y7HhJ3267z2UqoTH6GYHCNeqjvy6cG/d35CryUrO95N8eTPVrTTNrxNT04ZaZuk6gfcUnK93EKEKUcw==
    1EcY647o6boo9Tz/Et/9cH57fUccAQYFlFDW2+nyDUv4hod2uhLeQJbK3ecd/OFOpIZXzm0rA/UoIlzgmtuun4xfe5I+bfvOa87T7L3Mnchc5k7qn2QtxwYjiBQSvud6ubTELw==
    2lAgmAjCwHJA/iEN6e54LyfGC/Cumq2q7HuRauQXf6QLbYL+aud+gBmSgBBUc7TWFgWNWaXvs153TYKX1L+hHJZdbGesDuIQKDbi/XmOxyruW+4d3Pg9t1RM6veVaFeXA4nt8w==
    5r5dSbPLvbuKbscGlx/LVt59bmXdPSzpCpPFio90SVe5XJe0uEIrYqLsOgQIll2XgJddZgKUloIZLX0clT6uhLG0FCZQrp2bq8jWXE86yQlhA+hGJCWkNFtb+T7ba2T4uMvK9w==
    cYChca/Tg+q4rRy6HnxCGKH15rlLQW1oCMsCriQuRBIaHFmQOBBj27EqbNkxaON8sLFG5q6EHTHYyjzo3LrTxbW3F4rAk6pVrOPCNlaxzhf2YEzGt7OssKToZ5IJ7S+/vmXyQg==
    LoVQWotGtmeN6S1kFZ5Dc2FaU4uQhpRQLKWo2UV+GpguI3ZXgJ2Yyx7Ze0J2GesPAO9srHiyvGiL+B4IrJd5F7zH9wrfpdTuCsATv7cH+J4AXsr7AyD83+69WTSOnlpFt96YEA==
    UkRrrqVxEuDeIHRXgB0Hrj2u8/OJG22UvAvaN4RhB6RXsDNOOPTs3FTTBao2V5R/m43Vk63u30oRBFwi3PtAKzVZIHNXVGSSretBdVAdWZCEFvUj6vXjPvTjN+Pr5ShqNwmkdA==
    HCLKoPUKcqUg1+jcFRUZ91D0sDqohlwThQNEi/qPMQ3uZy0DnWKEsM749kD388drtO4K2JN+x0OivfEQq15BKF1QIkKNlUQ6NGyzV7nmslQ1epVhrhc7e2T37sPcfsEvErpqMQ==
    qTfXPV2Pq5aY1N+feTk+ID8JB4EC6ys8upf03PREbUbUWtnynqjNiFonU9nTtBlN66QLe5o2BH+ddFFP1IaCWiNv09O0GU3rBO09TRuCv05s1BZRdwiM3hgfluHJ9rUhrlSpww==
    4ic3Zq4/k/xoJdGhonFECc+GFh/HpJak9S/IOzSYxFJgXTZU/HzFxMKlnGTk398+haS5YKz4pxooABBLaX1m9wFOLL2NKeG2TVRAYFqYWkivb45tQ8CKTUIazpppn2A7BvoSMA==
    zK2tgT5Cy81Yq4aPtw7b/IDzdrptAUZQyQCrJwSWgw1kYtN2iUNc0zQs04LqVG8/SIX9RpKVOSLvNUmZE5HYXC4ly9W7gsR2786f+lZqSkcjJdN0efnLnar/u3PTbQCGBomoag==
    07o2z6jCtFbPRto0rRsWtHKxtrC0KtvKaDjUvIV+h+da03wgejtQJ3q/XUpgPagjF5uGXgYV2AYxCBXYBZwQx9DiDQz5NqC+TumudEqU5zFPCZPrnOkEMDcGtraBTIQwFFLRrQ==
    7y+sHj3eFWCW58JPCZgbrOkEMguDUNtAJRZIAslq7jcMXIi54C4BwiIOwMJ1DMflEDuSGcYxb2RaOey7K4gs7Uh5KSCFRByyeoAs6/l+fZgWeNUJiOoxkL/d/Op7i/uwFYgSzA==
    VOwqRD2Icsfm2HFM2zYcYnHHFIrUiEjsYs6lc8TbJ64POV4SuSsQLe2XOyWbWeBKZ8AYD0huA4icY8yIRPVGvEFXYoBtQE0BCUCWdFzMuE2QEC624BGvIFM69r8rICzvyO0N5Q==
    klGdwKX+Y48XIz3O7dIPdcrvq+J/a24thERwSki9hbIs1yKCGdgUtiTMUabWVkS3oA0JhMLmbwOq22jeFfSWjhg4JRO6jUmdQG5uAHsrQGWCSAIIx/W65yQXwlTm1BE2ERYUHA==
    IGSaFiTIBtB4I0Y1R+OuALN02MkpATPHk07gcG2ceDt9JwJJIamsOXkL24K7tkUsl9jEZlTawgTMtKhpAWVS35DZzBG6K4CsHrPU2uCiU3GN1zjcGN7Dx2wl3oq7FZNd9zY5ow==
    ZMxGO33iLe4YWDrZ5lOQ7rWxVB2X6zxorS+xy21p2v3S5bY0TFx3uSkNE3xdbkrTNEmX29IwaOxyUxq62V1uygEclA40P7X9NQdF1nLvE//0axB5k0VrYbYUUEAgZXrrOAYxbw==
    UuJND2heSUeuz4EJCjgi9ZZlO63Ry70n3HvCx9SW3hN+1aY0WDhl3fAUhirvxT4TJjDEGNZLg7/d0ZHrxC0bwVzyTCdScojJ0qUu9P4PSj6X65rgVtDSJHleBy0b2bW0Gjlz3w==
    bDjzOptaSJs3gWya0dsLWikCQqHu5Fe6r0JrBe27AtTOhKZNcufbMNxwXaJdkF3B0uNPlkOI+xDhmNvShwidbMoxhgidcOz6dO0B0rV9yqm3J709OaamHKM92Zb2r9UXlDjayQ==
    T+KBOz9Gkw+z0eSb8VUPDG0jnOUIUqb+n/a27wmpC2elFO9KENvMKdEv7meh3z1CEEPXQvVj4DJ0rWLgmjvUl0M0+rlaIAohcNV3mm1mv1+90YrOIJDJU99Ku47K6Iq6OIL1vw==
    u6NJto5TPaR+aV23rNJv6T7kL1Y1n/2pN54p2iWVb8spYYRzCDCt1yH2VjVMCXEPrlDWsEgdgpJt4Ldhce2pHBbTOzksfvf9+ae0Uo+5BSiv/BvVRiUKcTnpcpTLJdx2wWhY2g==
    lPX36qTDSxhTngqvSGcn4MtvdF9QSF+9q4mv94bPeHY1+X1DgybqeAsx1FvlC5jOglmVXgcbel2Rw7+Jdny1aFEavhzm8yoN3x3PFJ/99y96+9tObw83CH81+eg9BffRknNK0Q==
    +DnWWkqJp7YyJXW5qaxjSgul6S8HwfesGYAkkLwZh4voc6C9An068dKz1U0rmNxPZ7n72YX4kVnw3lTqbnn2LTmDuUosxVoLcRaWqELS2GW1PFvhOqVIlF1HiIpc4VmZqyTeZg==
    h3iSryMOdBnYnq9bxr0VfWj1lr0smXmyZV3crRZV2X1r4t0vlB1pa7MewSnlAPB6IT62bcYpVKRDgmCXCJM6jLomMWzTQeiIl/kpknZfprTGdEqJSzfwWA/eUXq9uDGOnhXshw==
    zyXAJDdB0WcuIuQyB5ASO52bXFXTTkNUaqhfgpNG7nVp+1+O1HjuZ05q9hDvV2bVac2s+qtzN0dUVkJUyErZ+lzfzFtT6x+uFePHN2MVnrS1I62gGDFCRL04iXHHtCxLGuovMQ==
    TSQAUWqNQa7KMDCkR63Zi9Q9HuV+qA0Xe7NxcLNRFMnXthyH7QR4ddFp0yY1X8Ahp6MxFED9x0c1+Wrp9Oxr5lW9GOglY3arNfeL2IkE16u4gXpzskpSkxAIKJigXJTb2/oTsg==
    tkyisg3omsYWRb7pSumw3fmRHray9U0xd9T45RdpqLX8UeO31zJIO77/bcf3y7JIpXkiJUzPZIpKn1jLFQ2L7E+FfjfXebdVbQqIX3OWW9EGBQwrh5khAFg9DEtAgASOy7BtEQ==
    6RCTEAdwiwniui6B5Kjd5hVly33p9Uc60Z2ZZBCfcXDyGe/xpEQhra6u5amX14sp6PRy3QEQz6rgZybybDpE9ZfKaez4ppWth+N157YgI4cbENGGpslPWWpdz0iB9SgJUXOT9A==
    01IzlZR/vdA96YDo1cqrqZVKmTgupaLO0glT7bsukGCkXBdI6y1ue2JKpYLyr6dSaqViepWyV0+lTCL2NbSqj8T7SPzgkfgJREmvkTYuV1kFZXCo2ATtwZPgFEqOIKznSABsAQ==
    RjnVW0YRYhumdKQ0HRuov8qPOO6+w63RCeqKL9GHJ8/4Eq0FH2iLs7D/nrkjYWFHVXLqiFW7aVXeWzIo97kOzOppBl3qwHxsfYxxVweTQgAlyz2dPfS8Xa5B1GcX4nf9lqJ6Cg==
    EEEY0aPqJF5SoP3u4bodBC2xObdRrZAEIsLrzW07yJKbpR0jhVFyZYsVcI4cI12soGqqO0x3YO+UNWqw7FcqgNmv5cXWu61JSAMEKFbermA1c21vdqWvlL5rpzlyv960pIoZSA==
    L9tcpoG93fA6icAGZ82W19okaLnLWeW6tOz2QKSaYBfoWbyUp2d6J0fP4uzK+GRpzws+SoXyDl1VT013bzEaj9+dW0oDXIVj/fE7Y7YoXvGVR2Esxl7h4kgB5+t46i/OPvmPZw==
    n4OpN0s5Gud8lk4M4MAC1bx+vLhfzxrVdQ4uvSe9f3SCLT1RLLy91xda6VYkgDImsoGIx+ErVBOkc87D0chf3lRBZW8YxaReXzPh1DEQxiYTFsEUCOpQVRVmuQ4DbtX2pC34LQ==
    DYx7lcRkN7744YOSzI/BbdCKtReAQAbpcs7x4i54VJ+9nIzeX6dtOWKcrd3PEe/Ftns+HkX3ob+z+S4xN9XmO2du8pidBZe6C6eIj+vQ0xxUh/OL8WyijOzZ9XgRfY2jTX1kLg==
    jz4uj3SVzuNXlBlW1T0b/YhT90D9Oz8bPekTLgVLxUQ9dnOjsOAkD0/icqL4r47pFbbOz66yg+QFjcXwbJyEuUoylO99mZIQZs+MPj38Enrzu/HIDdUTuj2eCnxXVz4Go++Lsw==
    ROSU8rmLovnFcLgY3flTb/FTMPdn6t5NEE69SJ2Gt8OUGNPJUI98G+oJzOrrgXWnvBPfWMxVG1Zx9/YKvPSzuaJshaiz+3C8Q1Gp2KnS1JEWwrRa6ujFpc0eFEd0m/WJIkXKLw==
    sM6vJDDIHkpe8XQNEvaUkHd5KQyDxzsF3cWS6sVihhv1uJqM5+54MjkLg+j3cXT35c7TcRuM6alvnoUX/vTKVxUNP1yL+LKS4Y+LKD1KCP13JAwAJDIHltL5AwK4MzAk4QMOHA==
    ThT0oAWtf+i3IbnQGdBg5E3s+TjjOiQb5F2qup9GwXQY3NxoTZYSWJEXglTcEquXtDauUfYb13GYtEJXdhGOPiuKaTgNZAKogeQxpAZQW8er9MIwfjoK/Wh0tyRiRqiEbAvlcw==
    nl09/hpcZxkt/c6Pm3Cqf1Vlz37ElXrKqpbQaivsh6sC5uEi+sVXYa8+UJRX1Y4/4D2oRqXPZs/o67Mg5mH8ncmseGWYXSpjG8WMKLaxgWHYfECILQamqY4sy5EEQ0aos2Tb4g==
    zrsOHn+7WoyUlF63wLkKjmX0TQ/V//h+Dtz580SzJJo41tNLBV0jztmH7xBvrvu3sJ25eBBKITGCol62QNlRLrkFDGZDYkpoAGwx17YwpogBEx1vtqCZC5Lx4LVXNlmLcPUlRA==
    aG42XH3H5Lk4uCTlUDmFLe/kPJ9IKCdto2RCo4W5F0rbXYYNCfkltoXKBAGGuRVT7C4WoM/+jR/6s5G/ykkm9FWK/2KcmLUsvrkJgqjeG8vFJqo+EndT5F+Az3xj44VsLuf89g==
    y59pbhWmi2/exYtvYZkMONEmaBmh3f7qxQOOgvm7c8rip+NM6fIsyacuT3XSNV6xPB6lkrRmeTOp6/L09j6KT7O2q7hTq8p0aAsH2STGaBxN/MvbNLwJRrr7RH9KaejLsbKp7w==
    zjFbimbC7fjwKrh+SlR4MIrB/fP/A1BLAwQUAAYACABaYRhNjdUkJ0QHAABqIwAAEAAAAHdvcmQvaGVhZGVyMi54bWztWutu4zYWfhVB/VFgAY8uli3ZGKewZTsTIEkNJ70Auw==
    iwEt0bY6kiiQtJ206JP1Rx+pr9BDipSvk7Ud77Szsz8m4u18504ek/PHb7+//eYpS40lpiwhecd03timgfOIxEk+65gLPq0FpsE4ymOUkhx3zGfMzG+u3q7a85gaQJuzNuqYcw==
    zou2ZbFojjPE3pAC5zA3JTRDHLp0ZsUUrQAzSy3XtptWhpLcVPRFEp2BAFR8QbEGQY63B5IlESWMTPmbiGQWmU6TCGsYAHHsLTFWxb4YBxFWhMYluWgVlESYMYAMUb5ETMNlRw==
    KZUh+mFR1AC9QDyZJGnCn6V+GoaAF2jeVhC1SiBB0i4FUh9NQY/hW5L0SbTIcM5Li1KcggwkZ/OkWKtxLhpMzjXI8iUlllm6dsGxXvyYD/qld9eAZ0TWy4iOfYRHBERFcYwI2w==
    PA9lyeo802wY12mcBuDuAhSz1znnmpJFsUZLXod2k3+osMTOdAKWcvKmaux1wjzMUQEZmEXtm1lOKJqkIBG4zACrGyKsTbFn8kmqPiOqGg/8OcXGqr1Eacd8FHTXNIHYsdT8Dw==
    MAcR1LBt2Jlh5LkA4CLi6xU9EAT2b9kjhYbKYbcWBBFJCewIaMGJ6LKfO6YEYgWKsGxLnBRP+ZmkE8I5yc4kpslsfi7jJGdJjN+9ivr7s6itPcNP0hCn6R2iG8ZcKdLSZ/ET2g==
    0fnwvLWLBr1bQj5oQW2vK6mmCWV8TADEEd0Uqd56MiTpIss35vWAXJKTdz041qve92XP2RCiClIRkqI5gy+AqJBs+S2l0da457r+Boim5RSmocyIx8DSDr26Z0vBxNAjFWO+7w==
    Drp+mShR+VdJEKkscFtuaz8LrPXKQvMYSUTX9ob1issBxqP9oXEfT9Ei5WKm1XOCsCElKhSD7XxNeIq1DGoFi7n6lH2UJohpgq/u0bJtWO8wgsix9IEpYd7fTlKd1Gi2TfAgCw==
    MBq/f0ApZu9v8iURm5FTF3VCGc2xpqi5Xt13G/XAVVNFCpE7JylwFN2YRCNEq5zzev1Gt+n0nF7Y8xq2F9hDu+92G93ewB56dq/SbgcFcdRLclEmAlJB8TR5ukNFAX3YSctNNQ==
    Z3bna3FUro/I+DlH0GO1HC2h3igI5cx6QTvra+GWJ6iN5h3TAsA22OMHyLuxpP0xS4Uu/3T+LedKs+rennVhQmYyJxTfcJzd9DvmL7bjC42HtXA4dGteq2/XAt+t18AC/cD16w==
    rm/3f9V+wU9cmaNyLzQGeTyi5QrohSTnwFVanhIyHVBaRSwrIK1BXaq3b3psvEr2V3sqydiXAtGPMwT5zLXYlXxWFaunSSGOTL0dguMZpktsXhk7opyRBvfkEvHvNYNm3bad5g==
    /8NfWfV/J+7vySUCXrjzzBDtI44vsknXg6bnOvXAOypKe6HXa9Vbva4ddCEonW4wcOtea2Dbw7odDMPPP0qFYT99nJ5dGGxE58HC4GEx4Qdqg5MTo970vEZzJwuErU7Ng+KF7Q==
    /xMXTVu2AfJyzSRkSlQ5cFY9NUKzi5VRfgvKW7/ZaH3hx4i26ed/iGhN/kY1027RdBLo4cSB335pHM6RgFKtR6nWBM/EZZJ1YW7wM5rTR+HbwyqOutcDw/jXP4wuRZMkks27wQ==
    +How/HZ8132UFqgwPo0lGC4Q1Qf5HkOBHbRc32kewBY/lEciYLYZ8SvnE3oSr2PzdF4f85P1BcTi/Xd3IhwfvoB4dP+yeNTV9X+vuCoPqJ3y4VDxUNU9+jrp8KWS7TvHXSpdvA==
    FNrS5KdID8sLwiP0O6k4CsUTU/480s9mlyiRGrbrN+qBmvkMqpltI7y6plFvkKeUNYduQTf8fDCd1fsUNAvYm9Ikx0acMP4o725Fq1e1bqvWuLzZLRyvjfJoTuiNuN1t+q1+MA==
    aKgJHCdcDDd6gRt0y0eKog0bHwhrRE+QG07Tli8P0TMQ20HZscpl0ymO+KBcnEpuXP6l8u+kYzbrjWq1KJipkQAz1zTA4ZBqyguGq9dE98triop5Eg0prBDKo/ZsY+SWRB/Yqw==
    X51zAntXPsNdqPQivr7yflmA17LdgIIfcMhY0P33r+Nfva/eQkvE30Xe0Eu0fAkeETqLDphC+cve9VdpL71IkBgi2TEdywfkJR5jlvwsH0uE0rCw9NsBu1dDlJLVHFKVVe7YxA==
    V90tASdpUgyTNBUsRNugbZxNMAgMke5IzhDIt4yrVmnwXyDOYV92e7WwYYc1z/YHtW7L82u+PfA9+OHmhE74q6CG9FgwEXEo7RfJBf6XQfl6UyonJdJfKaNVaiGEheID82gumg==
    U1BwDMZSRNWMtW0B0WNwJBiT1R2JsXq+EgBPU5qJL4hlPEn2z1qI0iovZrm1Bigo49eYZIZogI1BKMkALUF8tVavEeM5EaKVfNJ8e8QqhywttmrCPzm3kSWb/TJFy/1P7o7Vtg==
    WBUeH7/tU0WA+FD9MvUfzvYzS5K94mMe06s/AVBLAwQUAAYACABaYRhNz75ubWAEAADsEAAAEAAAAHdvcmQvZm9vdGVyMS54bWztV91u2zYUfhVDu+iVI0qyI9uoWyRS3ARriw==
    IC7aAcNQMBJlC6FIgaT/MuzJdrFH2ivsUCLlnzheYmPYTW9MHfKc7/wf0n//+dfb98uCtuZEyJyzoeOdIadFWMLTnE2Gzkxl7Z7TkgqzFFPOyNBZEem8f/d2MciUaIEsk4NFmQ==
    DJ2pUuXAdWUyJQWWZ0WeCC55ps4SXrg8y/KEuAsuUtdHHqq+SsETIiUoijCbY+kYuOIpGi8Jg8OMiwIrIMXELbB4mJVtQC+xyu9zmqsVYKNzC8PBfMEGBqLdGKRFBrVBZrES4g==
    JXprkZgns4IwVWl0BaFgA2dympdrN45Fg8OpBZkfcmJeUKdJgdc5LQexwAtY1oAvMT+thQpaW34Y0UMvyIiGaCReYsK2TmtJgXO2VnxUaDaC63VfB+DvApST05LzQfBZuUbLTw==
    Q7thDw2WbulXYJkkb7omTzNmPMUldGCRDG4mjAt8T8EiSFkLot7SZe3oYaPuqVluhfkYqxUlrcVgjunQ+aLlPogcasc159/gDCqoixCMNNhZlQBcJmrNERFKxyVOwIqa1/PWnA==
    6RKvOS/BZBiRFcVLq5TBQNQCCaccZgeeKa5J+Th0KpUSsEn1XeFQkqkjRe+5Urw4Uljkk+mxinMm85RcnyT99Shp90ng64R9wmIjmAsjupsz67MugPPwKYe7iwfUR84frKmocw==
    UeFmuZDqjuva0CTFhlofRpzOCrZxbjcqFsavL+HubKivNeVtGNEUtC5f/TmBFUBMSSJfX2kNt2WCyxe8hPDe3UIoEer3/H63UlJt6i0v9qIr3259qdiiTtBBXt1SotacYKbGJQ==
    XJ+m2sU12SwY3w9f2THuGlsl9a+lTE92+mHvaU+6G5z/Rbv/aOIfTfz/NHG/2+8e7OGN1nyuXWWqzFLrMh1GcdWKlb8pbsc/Wz3mHNMcS8vw02c8H7Tca4IhH26kn85s9ZFMMA==
    dBdWRD9BbbvgybbQuPoLINLvY0yJ/H7D5lzf6l5gphPUSWol2j4KoQ/9jmeOSgo1MeUUtGoy5cktFk01x2En8IOr7lUvGHXiy+iy7wV+Pwx6owiFYefCerSLghW+zFlaz6JSkA==
    LF9+wmUJNDxJ6tcJk2j4Rr8512/NdMUwULLN8Bwe7iUXSroHvHPf6JQs4U/GdOi4ADiAeHyDir6rZH8pqPblV++36qwOraX2RhgOqz5RXJAb2LqJh87vyAvRCMWjdjQa+e1OPw==
    Ru1e6Afti+5F3PPDwA9R/IfNDVkqE5KmGuDjiqW3ouYAKuJMgbIDQ3j/pNwYwuXz1XlbXTnoPAij5sqJSYZnVO2UbWmwtsb3Z24uEdvoxolHy+DZopKPkdzZtLXtNuA7V+GoFw==
    dPv1s/GFTaLe7c1UFYyar1ZnwmND38TYNe1Z3Xy2y5+EcPs+/pcQGuYTQtjbF8Le3hDu+vaME3V4t92oPENXKPRGW57tcG14Zpif9WzEuSLiWbf8fW75h93KwKF/AFBLAwQUAA==
    BgAIAFphGE0NXdcWgwUAAKwcAAAQAAAAd29yZC9oZWFkZXIxLnhtbO1YbW/bNhD+K4b2ocAAV6IsW5JRp1AkOw3QZEactQO2oaAl2tYqiQJJ28mG/bJ92E/aX9hREuXXZLaTFA==
    GNovEt/u4d3xHt6B//z195u3d2nSWBDGY5r1NPTa0BokC2kUZ9OeNheTpqM1uMBZhBOakZ52T7j29uzNsjuLWANkM95d5mFPmwmRd3WdhzOSYv46jUNGOZ2I1yFNdTqZxCHRlw==
    lEW6aSCjaOWMhoRz2MjH2QJzrYJLd9FoTjKYnFCWYgFdNtVTzD7P8yag51jE4ziJxT1gGx0FQ0F9lnUriGatkBTplgpVPyXBDtm3FAloOE9JJooddUYS0IFmfBbnKzNORYPJmQ==
    Alk8ZsQiTbT6CJD1tDMIGF7CbwV4iPpRKZQmpeaPIyLjgBORELXEISps7qk0SXGcrTY+yTVrzkXt4wDMbYB8+rTDuWB0nq/Q4qehXWafayxJ6SOwqkNeN40/TZnRDOfAwDTsXg==
    TjPK8DgBjeDIGuD1hgxrTV42YpxUvyGrGiNxn5DGsrvASU+7lXIXLIbY0av5jzAHEdQ2DLjSYOQ+B+A8FKsV56AIXHxFj+YKKoNrTgqENKFwI+C5oLLLf+9pBRDPcUiKdoGTkA==
    iThRdEyFoOmJwiyezk7dOM54HJF3T5L+cJK0vuP4ceKTJLnCbM2Zy0q0PLPoDm/ZvH9e30aD3ntKPytFDcsrpCYx4+KGAgiS3QRXvdWkT5N5mq3Nq4FiSUbfnUM+rHsfyh5aUw==
    og5SGZKyOYU/gFQh6dpuZdHGuGWa9hqIkhUMpiE/RzewpeFbLcsoFJNDt0yO2bbZ9+ySKGH5rTQIKxaYrunuskBfrczVHkO2u8uejYd7VgVkgueJkDPuOXL8dqFRXm7Aqt8GbQ==
    R4JRmSFKXYolei3BI1H9jkNYdnESY65WfHeNF92G/o5giDldpdrbWCTk0/txoq4DPN0UGBU1D4s+jXBC+KfLbEHlNYZassIoeRApCYSQg2zTbCuK5AnE/IwmsKPsRjQcYlaz1Q==
    aQ+QHThux/E6VuB1PGvQ6fie57uGa6JWoKzZRsECn8eZrMwAKWdkEt9d4TyHPtzB5XWccaP3SibZVXKN7jMMPd7M8AIqlZwywfVHrNNfyQO9g6pq1tN0AOyCPz4CY28K2Z/SRA==
    2vIz+rWYK92qejvehYniDhCUkUtB0sugp/1hINsYGMGg6Q8GZtNyA6Pp2Gar6bW9wDHtlmkbwZ/qXMidqNxRBwI0+ll0dFiti0Hbp5kAVYvjYpRO+ozVBOE53CLgI6ayBTuUHg==
    xwWqONvxWEHKcs3DqoEd2sortSV6TZqX0ldmfXWjQwRywhZEO2tsKf2izL2mz0HZJrJd03TaqOV+42zl129kPZCs1/Q5WCqjZR9bDuBAgAV5HhYgp9V2DbvVOYgFHcsenPvIbA==
    BUZgeZbvOKbltQ3LavWtYOCj/z8LpGdflAfliq2QPrnOWgvkqmrKNwL5mo7gso5XsaxWHUuiVsey2h1tkwfSWccyIX8ka53uh9168zE/1JQeH1Z5PsLIIZ4+WxkJOQm5tgU56Q==
    a68jlVe/PBOP5YVpWIPWg8lFnClLXqSs+4/NHyjWtqu1o0AVcXy+mRwnSeTPsISqWreFWWMylQ9x+jPvFmdcsFt5tvtNHHoX/Ubjl+8bHsPjOCyaV/2bi/7gh5sr77bwQI3xZQ==
    PMFJjplK2zsbSmzHNW3U2YMtHxmGMmC26xHzC54kWcXm8Xs9dE76VxCL1z9eyXAcfYvHF4zHurBQ71/ld/sVzLDRYa9gz16IlfmtyiG/hWq4eNE8oCbZsE/+mHol3FC79DMKkA==
    3zc3/Bx0DKMTbNiyObRuSzVzmC1QSEgIaUdPQxbaY4x8DK6fykxNDfl8a/BBo2cRO/sXUEsDBBQABgAIAFphGE1iEpLlbggAAF1GAAAQAAAAd29yZC9mb290ZXIyLnhtbO1c3Q==
    bts6En6VwHtxrlzz/yc46YFEUW1w2iJoinaBxaJgbNkRKkuCpPx1sU+2F/tI+wpLyZJiO26qOGpiH+QmMklxSH4zH2c4kvK///z39z+u59HBZZDlYRIfDeArMDgI4nEyCePZ0Q==
    4KKYDsXgIC9MPDFREgdHg5sgH/zx+verw2mRHdi+cX54lY6PBudFkR6ORvn4PJib/NU8HGdJnkyLV+NkPkqm03AcjK6SbDJCAILqV5ol4yDP7UDKxJcmH9Ti5nelJWkQ28Zpkg==
    zU1hi9lsNDfZt4t0aKWnpgjPwigsbqxswBoxiZ1+Fh/WIobthMouh4sJ1ZemR9Zl3EUXLxlfzIO4qEYcZUFk55DE+XmY3i5jW2m28bwRcnnfIi7n0aBVASSP04GXmSt7uRXYZQ==
    +pNFp3m0mPn9EiHooJFSRNujyxRWx2xmMjdhfDvwVtAsgQvpwwSgdQHp7HHKeZMlF+mttPBx0o7jb62sktIPkFUreXlp+eMmc3puUsvA+fjweBYnmTmL7Iysyg4s6gelWQ/KzQ==
    pjiL6stJVv84LW6i4ODq8NJER4NPZb83WWhtZ1S3f7Ft1oIoAHZLszU3qRWcjovbO1w7EbvxVaUkbUTFdpsrO4yTKLE7grkokrKYfz8aVILy1IyD6nclJwqmxZZdz5KiSOZbdg==
    zsLZ+bYDh3EeToK3j+r9eaveozvAn0XvzE1yUbQqmobXwZIaVRBF7022BPVVLXhx++TarCFi25Egd+8Yrcsrx06Sb81CAHEqudMwy4uPiRUDy2Jk6tJto0qii3m81N5UVLfEyQ==
    W9f6y7b0eVGCS5Nojbg02fLnzF6tkHr2lMJ6TV3r0b31o5WxrN+2YFkdfrRTBIpgAqqFlFWfsrJOAoa5qoiXT4r6sphztrhEJp41uE3M0PuzGaduN1Fo8uaGv30wl4cHo7eBsQ==
    Wh+p0mPHN++CmbEcNkVQer5G32a22um0ijyyyddTEwX51+P4Mik3E4hLP7+wxknTAwrJGKKIyropjazlnSeRHbUsTpLxiclazgBKOBe+h10BiAuwpBpjDTARCEmlZbOidSmmMA==
    bhiX8ZGVlGaBtdf3Jk1t2e6Ei00xzsHRb6Wru3Vxk5vY2FI+jM2ljRfSJCvy0T2rG/1WquTaxjbnR4ORFXho8fhiefOx6vv3eVSu5R/wn1XbAtqmtBFh21ixsUiy4NhWHXtHgw==
    fwHIgQ88f6h8Hw2J9MBQcISHDnU8gThGHHj/bnQTXBc1JK012B86npxkiztsSSVxYQer7h8v/ta2Pv7Jflxa7qmddqMe0lpuLSH9sdWe3K366AVTcxEVSy2VkBUrzr+3ttOYUw==
    /l3la5WNVY9uuzeDnFR08QWmcuGnOtKjeL1RR9VyF/cthqsBaEBv0R3VxCxbs0dz+udk/ex8+hjMwrzIqjj3Q/L13VnUC2etNTApIOvGWeoCRwrluVo5xFfYVVxC4XmIau5zig==
    956zG4HeFepCRDdQ9xdRNF2J70qwrLYaN2fjhSiMg3eXUWtIreo3UlQKSu3kt6HoRpU8mKkPYt3bZB6cmFnwdVHui2xDhCWhsA0W7ucaFh6GiLtSuJBw5Ti+QxBxqC+QpECJ/Q==
    5doGeF8o9iwU26CJX8usmtMn5/bQ0p8XowxgxrEgnYjlCOi50MdSI0A8whxBfEl96QMBFGPu/hLrLrovvOrKq46s+RUebklfv5Z9+r0Jo96dGkeEEwl5J/JxX7hSARdR7BOgoQ==
    wxChXHjSQVgrz9tf8q2Du9vUK2+o0zBLeZsNeZ1Re+cusbVXGq5rro9j4MrJ9GnPhr2wGkomJANUsk60pgS5NrRl0MOIaCQcralmTEtktwau1f7S+kco7za9N3G1o0l2J3B/aQ==
    mDvoPkkU2kS/fRCGQEQwZ6RbHoVxyxbsK+4CQhBUrrY+VGurSwIlFmjv6dJA+8KSHlnSgPqUR7R+nAlk1rIBlLQTO4jvceJql2GJiSM8F1gn4jrEYy4QWO9xjLiK7Qs51p4HbA==
    efR6BKVqTTwJo6owsw8+CQawZIR0S3dY4jHhckiVj4kvpIMBpxj4Lta+K+H+pzsqXHebSz2dtnbYN1VK2NnnZ66Jv30w814iPYoZ4UiAbpGe41OoMHe1VJQQBVyAlPaZ4EBxyg==
    Ndl79jXQ7jYB/7K5izUtPIkjO3adD32lDzkCglMpOpFJuC7HLnJ8zTyCkJCCe4jaXQsLpYXH955MDbIvZHpOMjVa6IFMvb2udfrl2P/UW87e+h9CEOnowwBXnu9D34ECEN9RDg==
    E5BqxwaSjnYQoHtPuxbcF949J+9aNTyJF3sTZkl/j6CHEEvKKCSk23MwZT2YPYQhRh2XII9abhEkPQ4IcYDj7f/bj7fw7japXh6E3eHhreqe80nYkyarqCKSO5v0JF0oFP2xng==
    PiSnqRlX39msqGO7Q6qbmXh83k/aVQAAJWHtO+s/SbqCMlFUvtVJGfEQFMgnDoTUB77UQPl7vyEtw/vkW1JnNmx7+GtWts7Yzd7yQdMpyk+Nms9IrIbzILsMBq8PVoba1uCd8Q==
    OLmIi54eNFAuGLMbX7fMqD1NaodCD3nWGTucOxQRpTW1sTEjWO/xG5abAP7r2Xy7tC5Gv+K9ts169JI/tLWEMgg62aj2FXekKxWx4ClfuMBjhEjNIdc+Zfu/LZew7naE+Otiiw==
    n8WAP4ot+kvbl+jvXJqjD5ZBihngEqBuNHOwRxmSQiGu7BHOEUQjRB0JFXIh0GDvaVYB+8Kz5+JZBf8TpjV6egeQQyEEBt04xAUl2tMQeAoTBwiXQMyFpxlzyq/D9v9B8wLa3Q==
    JtEzPGneZd4tVLZtGqO8LP7xwRowa0t+XKbHT5IiyFY/Qlj6MrbJAK18GYtWFtwg1y5tamf/f1BLAwQUAAYACABaYRhN2RRoLswBAABSBgAAEQAAAHdvcmQvZW5kbm90ZXMueA==
    bWzFlNtO4zAQhl8l8n1rh5MgaopEu1pxh+AJjOM0FrHHsp1m+2x7wSPxCkzOhUVVoRd7E59mvvnHE8/b39fF7R9dRlvpvAKTknjOSCSNgEyZTUqqkM+uSeQDNxkvwciU7KQntw==
    y0WdSJMZCNJHCDA+qa1ISRGCTSj1opCa+7lWwoGHPMwFaAp5roSkNbiMnrGYtTPrQEjvMdqKmy33pMfpf2lgpcHDHJzmAZduQzV3L5WdId3yoJ5VqcIO2exqwADm4EzSI2ajoA==
    xiXpBPXD4OGOidu5rEFUWprQRqROlqgBjC+UndL4KQ0PiwGyPZTEVpdkLEF8cVoN1o7XOEzAY+RnnZMuO+WHiTE7oiINYvQ4RsLHmIMSzZWZAv/oavYuN778HuDsM8BuTivObw==
    B5WdaOo02r15GVnNu/4Gqy/yfmr+NDFPBbf4ArVI7jcGHH8uURGWLMJbj5rfmux1nKhOws6igZeWOx7AEdxSWUpmcWtncYn9LHtMCWM3d/H16pL0Ww/N1q8Ltro6H7Ye1zLnVQ==
    GfaMW8iDawZvuUCBaMvzILE5YH+kywUdDTqrQUl/5jqL9tur/ioBASYoU7Vt4+lzMuw/5fKlqEN5TXO/fAdQSwMEFAAGAAgAAAAhAO9n7PC5AAAAIQEAABsAAAB3b3JkL19yZQ==
    bHMvaGVhZGVyMi54bWwucmVsc4zPwQrCMAwG4LvgO5TcXacHEVm3iwheRR8gttlWXNPSVtG3t+BFwYPHJPzfT5ru4SZxp5isZwXLqgZBrL2xPCg4n/aLDYiUkQ1OnknBkxJ07Q==
    fNYcacJcQmm0IYmicFIw5hy2UiY9ksNU+UBcLr2PDnMZ4yAD6isOJFd1vZbx04D2yxQHoyAezBLE6RnoH9v3vdW08/rmiPOPCmld6S4gxoGyAkfG4nu5qi6WQbaN/HqsfQEAAA==
    //8DAFBLAwQUAAYACABaYRhNsDsMOM0BAABYBgAAEgAAAHdvcmQvZm9vdG5vdGVzLnhtbMWUzU7jMBDHXyXyvbXDlyBqikS7WnFD8ATGcRqL2GPZTrN9tj3wSLwCk88GFlWFHg==
    9hLH45nf/MeTzNvf18XtH11GW+m8ApOSeM5IJI2ATJlNSqqQz65J5AM3GS/ByJTspCe3y0Wd5ADBQJA+QoLxSW1FSooQbEKpF4XU3M+1Eg485GEuQFPIcyUkrcFl9IzFrH2zDg==
    hPQe06242XJPepz+lwZWGjzMwWkecOs2VHP3UtkZ0i0P6lmVKuyQza4GDGARziQ9YjYKakKSTlC/DBHumLxdyBpEpaUJbUbqZIkawPhC2X0ZP6XhYTFAtoeK2OqSjC2IL07rwQ==
    2vEalz3wGPlZF6TLTvlhYsyO6EiDGCOOkfAx56BEc2X2iX90NZPLjS+/Bzj7DLCb05rz20Fl9zR1Gu3evIys5sf+Bqtv8rQ0f5qYp4Jb/AO1SO43Bhx/LlERtizCW4+az5pMRw==
    TlQnYWfRw0vLHQ/gCJpUlpJZ3Dpa3OJEyx5TwtjNXXy9uiS96aEx/bpgq6vzwfS4ljmvyjBxbiEPrlm85QIVoi/Pg8TpgBOSLhd0dOi8BiX9mes82ucg+8sSBJigTNVOjqfP5Q==
    sP9UzZeiDlY22fjlO1BLAwQUAAYACAAAACEAqlIl3yMGAACLGgAAFQAAAHdvcmQvdGhlbWUvdGhlbWUxLnhtbOxZTYsbNxi+F/ofxNwdf834Y4k32GM7abObhOwmJUd5Rp5RrA==
    GRlJ3l0TAiU5Fgqlaemhgd56KG0DCfSS/pptU9oU8heq0XhsyZZZ2mxgKVnDWh/P++rR+0qPNJ7LV04SAo4Q45imHad6qeIAlAY0xGnUce4cDkstB3AB0xASmqKOM0fcubL74Q==
    B5fhjohRgoC0T/kO7DixENOdcpkHshnyS3SKUtk3piyBQlZZVA4ZPJZ+E1KuVSqNcgJx6oAUJtLtzfEYBwgcZi6d3cL5gMh/qeBZQ0DYQeYaGRYKG06q2Refc58wcARJx5HjhA==
    9PgQnQgHEMiF7Og4FfXnlHcvl5dGRGyx1eyG6m9htzAIJzVlx6LR0tB1PbfRXfpXACI2cYPmoDFoLP0pAAwCOdOci471eu1e31tgNVBetPjuN/v1qoHX/Nc38F0v+xh4BcqL7g==
    Bn449Fcx1EB50bPEpFnzXQOvQHmxsYFvVrp9t2ngFSgmOJ1soCteo+4Xs11CxpRcs8Lbnjts1hbwFaqsra7cPhXb1loC71M2lACVXChwCsR8isYwkDgfEjxiGOzhKJYLbwpTyg==
    ZXOlVhlW6vJ/9nFVSUUE7iCoWedNAd9oyvgAHjA8FR3nY+nV0SBvXv745uVzcProxemjX04fPz599LPF6hpMI93q9fdf/P30U/DX8+9eP/nKjuc6/vefPvvt1y/tQKEDX3397A==
    jxfPXn3z+Z8/PLHAuwyOdPghThAHN9AxuE0TOTHLAGjE/p3FYQyxbtFNIw5TmNlY0AMRG+gbc0igBddDZgTvMikTNuDV2X2D8EHMZgJbgNfjxADuU0p6lFnndD0bS4/CLI3sgw==
    s5mOuw3hkW1sfy2/g9lUrndsc+nHyKB5i8iUwwilSICsj04Qspjdw9iI6z4OGOV0LMA9DHoQW0NyiEfGaloZXcOJzMvcRlDm24jN/l3Qo8Tmvo+OTKTcFZDYXCJihPEqnAmYWA==
    GcOE6Mg9KGIbyYM5C4yAcyEzHSFCwSBEnNtsbrK5Qfe6lBd72vfJPDGRTOCJDbkHKdWRfTrxY5hMrZxxGuvYj/hELlEIblFhJUHNHZLVZR5gujXddzEy0n323r4jldW+QLKeGQ==
    s20JRM39OCdjiJTz8pqeJzg9U9zXZN17t7IuhfTVt0/tunshBb3LsHVHrcv4Nty6ePuUhfjia3cfztJbSG4XC/S9dL+X7v+9dG/bz+cv2CuNVpf44qqu3CRb7+1jTMiBmBO0xw==
    lbpzOb1wKBtVRRktHxOmsSwuhjNwEYOqDBgVn2ARH8RwKoepqhEivnAdcTClXJ4PqtnqO+sgs2SfhnlrtVo8mUoDKFbt8nwp2uVpJPLWRnP1CLZ0r2qRelQuCGS2/4aENphJog==
    biHRLBrPIKFmdi4s2hYWrcz9Vhbqa5EVuf8AzH7U8NyckVxvkKAwy1NuX2T33DO9LZjmtGuW6bUzrueTaYOEttxMEtoyjGGI1pvPOdftVUoNelkoNmk0W+8i15mIrGkDSc0aOA==
    lnuu7kk3AZx2nLG8GcpiMpX+eKabkERpxwnEItD/RVmmjIs+5HEOU135/BMsEAMEJ3Kt62kg6YpbtdbM5nhBybUrFy9y6ktPMhqPUSC2tKyqsi93Yu19S3BWoTNJ+iAOj8GIzA==
    2G0oA+U1q1kAQ8zFMpohZtriXkVxTa4WW9H4xWy1RSGZxnBxouhinsNVeUlHm4diuj4rs76YzCjKkvTWp+7ZRlmHJppbDpDs1LTrx7s75DVWK903WOXSva517ULrtp0Sb38gaA==
    1FaDGdQyxhZqq1aT2jleCLThlktz2xlx3qfB+qrNDojiXqlqG68m6Oi+XPl9eV2dEcEVVXQinxH84kflXAlUa6EuJwLMGO44Dype1/Vrnl+qtLxBya27lVLL69ZLXc+rVwdetQ==
    0u/VHsqgiDipevnYQ/k8Q+aLNy+qfePtS1Jcsy8FNClTdQ8uK2P19qVa2/72BWAZmQeN2rBdb/capXa9Oyy5/V6r1PYbvVK/4Tf7w77vtdrDhw44UmC3W/fdxqBValR9v+Q2Kg==
    Gf1Wu9R0a7Wu2+y2Bm734SLWcubFdxFexWv3HwAAAP//AwBQSwMECgAAAAAAAAAhADJSfrUKAAAACgAAABUAAAB3b3JkL21lZGlhL2ltYWdlMi5iaW4KialqfI+Jy26tUEsDBA==
    CgAAAAAAAAAhAP1n+dEkAQAAJAEAABUAAAB3b3JkL21lZGlhL2ltYWdlMS5wbmeJUE5HDQoaCgAAAA1JSERSAAAAdwAAAHcIAwAAAXngHy4AAAABc1JHQgCuzhzpAAAABGdBTQ==
    QQAAsY8L/GEFAAAACVBMVEXx9f3o8P0AAAB243jmAAAAA3RSTlP//wDXyg1BAAAACXBIWXMAACHVAAAh1QEEnLSdAAAAlUlEQVRYR+3TMQrDMBREQfv+l06TFBHCrBCsEcw0QQ==
    fB5LCl/X/Wd4en9/f05/D5ynjj2Pn/PIecp5ynlq7/xMvEi8SLxIvEi86NR4o36r3frH2pw2p81pc9qcNqfNaXPanDanzZ3Y7rDbYbfDbofdDrsddjvsdtjtsNtht8Nuh90Ouw==
    HXY77HbY7bDbYbfDbsc7u/f9ATqWN00ZcaUOAAAAAElFTkSuQmCCUEsDBBQABgAIAAAAIQDSdzsz9QAAAHUBAAAcAAAAd29yZC9fcmVscy9zZXR0aW5ncy54bWwucmVsc4yQMQ==
    T8MwEIV3JP6DdRIjcdoBoapOhxakDiw03bIc9iVx69iWbSD999xSiUoMTKe70/ve01tv5smJL0rZBq9gUdUgyOtgrB8UHNvXx2cQuaA36IInBRfKsGnu79bv5LCwKI82ZsEUnw==
    FYylxJWUWY80Ya5CJM+fPqQJC69pkBH1GQeSy7p+kuk3A5obptgbBWlvFiDaS6T/sEPfW027oD8n8uUPC4mlIOtNS1PkOzEb00BFQW8dMV1uV90xcx3dCXX4+D51O8rnEmJ3sA==
    LLG9JfOwrA/oKPO8elUmlPkKewuG477MhZJHB7JZy5uymh8AAAD//wMAUEsDBBQABgAIAAAAIQAVrcKw2RAAAN6lAAAaAAAAd29yZC9nbG9zc2FyeS9kb2N1bWVudC54bWzkXQ==
    244cuZF9X2D/odDPyxEvwWBQsMYIkkGv34S198FPRk13SWpMd1ejqiRZWPjfN9gXSe3VeFKaWSdMq4WqzKpMVmaekxHn8Ja/+e1frq8273aH4+X+5sWZ+86ebXY35/uLy5vXLw==
    zv77j93Q2eZ42t5cbK/2N7sXZx92x7Pffv/v//ab989fX+2Px+3hQ9ufv73e3Zw2WtTN8fn72/MXZ29Op9vnz54dz9/srrfH764vzw/74/7V6bvz/fWz/atXl+e7Z+/3h4tn3g==
    Onu3dHvYn++OR/3dur15tz2ePRR3/X9L29/ubvTLV/vD9fakq4fXz663hx/f3hot/XZ7uvzh8ury9EHLtvhYzP7F2dvDzfOHIszHAxq7PL8/oIe3xz0OS373fpfHK3D3i88Ouw==
    Kz2G/c3xzeXtp9P41tL0yzePhbz7eyfx7vrqcbv3tw5+GQbtsH2vb58KXHL4F/c7XV/dH/nfL9HZBYiMIj7useQQnv7m45Fcby9vPv3wN12azy6ui19XgP/bAm5f/zJwfnfYvw==
    vf1U2uUvK+33Nz9+LGvc4V9R1gPIn5/a8ZcdzB/ebG/1Drw+f/771zf7w/aHKz0ihWyjV30zaH32vUaei/35y+3hdPxs+bPFl4excrO93m3eP3+3vXpxhsH7XMQ5tgBB3zhRBQ==
    aTlDEnTx7NnY43x72r3eHz787d6/293sDtur+41eb6+udocPj9/dXm3Pd2/2Vxe7w/j+2dNSTh9ud3cHORYed/nhh5dX5/958bj9x21+2L3ZvrvcH56sPO50vr85aUh42OfJpg==
    r99eXjxu9j+xErUQosmeowEBMKVVZzr5HiyHFmv760MpTy7Xw0rZX9wd+a2WqDnh4r9enFnrGnYJZ48ftd2r7dur0/gmSohFHr95+dlHd4XcF337h9OHq6/C4tnHfccFuPvRlw==
    h1F4oiC13RV+eNjgSeEvP8Hxx91fHi/Xw6an7+vV5fmPmze7w25z2mueO+0Om5Nu990dEPfb3v/65xfo/pp8Wl/KOrG5+9AEKHlgSAVRwPdusVuGTPOwrobYQ7diGmExkDgYig==
    TEZKTOJaIgl2XdYtwWIO1kH3OQJyzsWD9ZSB0XL1encFyjxRrPNYne02mpay01gn1rArZIhzw0LYQpJ1WbcEizlYl1NisHpHCY7XWLDliKjZxpdiXZqHdRBsZyQylZ034F0wpQ==
    K+tc0NhXItaAYV3WLcFiDtaFjgg2Q5NewbMl0gWbnV6A6DhNxDrNXBVCziamygYaZ0M9i2Fkyk5XbSvrsm4JFpOwLjrU297bUAVStoUTxkSxOJCEWOZhnVJEQ5p6iKz0M9BbMg==
    ublspPWUWbCnmFZm3QIs5mCdZh1R4ZCdFQcchaWh5GqTlJ5amIh1UEKDqmqudlHWASeVdF3NRXSdS9cXwnVZtwSLOVgXoXKNKlqBC4DLBZwtMYOl8d7aPKxDDJ2DS0oziAaodA==
    U4iyUdleXeoEsfl1WbcEizlY170eroeSoHbwNlJWWZ2ZMUvMNU2VYQVjK0WdqytGQfUms+q6GAbKRYH2K9ecLMFiDtZlFQxNI7pT8wQWbe7oyNveu+de/ESsSymBWK8eIrmmug==
    riZTYmomRpvF5To01doe9uexmIN1UNSot1BLsx5Y1bXEClkkeonFtzoP62qyFlIJBismo14xGB7Vd4k6iC/WtryyrluCxRysa7GHFktTWaOJJlRSj44MXpiCZp2JdB2rrLPSvQ==
    ptTRNhFCNjmUbErpMaJrOdLKsW4JFpOwjnur3lqPwIDpTkaUkkuS1Dm5Pg/rXHauuWiNyjsyUElMsX3oOhtZCBq1tVm3AIs5WFcpUXaArTuGlnKpzTnSC8SqKCpMFOt8A1Xk2Q==
    mWyDN9AA1cNGMDEXJLWwrYaVPewSLOZgnXBx0FE4QoEWOlHJnRpSCclJCfOwDlSQM3SlGTsY7bDqK1xF41PPWaWebYVWbv1fgMUcrPOBPXN1VW8w8JE4MBHVKlbdO6aJ+pw4iQ==
    LUUPxmWrHtaqh+XMaMAlpoKp+rX7nCzBYg7WZYrNsZ6a7Rm689lx8tWBuBCaVJyHdazCjbvaB6chzoD3wRCGoKsRhLuP3q3c52QJFnOwDhJU8PqXWgPrXakhVj+MU2hMbqL6ug==
    SpnUw1qjsU0MxK4Z1goZr/wLNteYEqxcc7IAi59kHWFsEL6ZdXLHs+3Nh83D9dyc3mxPmw/7t5v327G23xx2t7vt6T82lzfnV2/H2IbN/qQ0/bjDeD/sr47fbf6ke51vbzbbqw==
    4143P+4Oo7jL4+Mmm+1h//bmYnMaXZM3h/37o2612R8uBtUff2hzqxf9uNm/2mzvN/z/uQGqaIYpobQOoiKscC3V6epomIwqb2ZK9giF0BubMBigjoaUkGZ0do5gbQ955W7NSw==
    sJgj7Poeit7YlmxjYIgUuk2g2S/4ZC3nicIuJhhV1qZH68zoXmLYC5sUW/XYFO+2cthdgsUcrLPdhUSpgx2jBWygLiw9uSAZmWdqEu5F/YstwQwgjYY9a4qeoVFQmVFc1Jy6dg==
    95efx2IO1iVpKYiU1ligJlEwgDzk0ENKWSZqnEtWMMWEBvNdVz9SYwMpGJQqVXMZIKxsbJZgMQfrXM/BhmZjIadiumbpAVMDT9RDdXaiWNegZZJkhlUwoMnM5J6KicpGW6W36A==
    Vm4mWYLFHKyrvQIhh0ItAwqRayorqmsOnKM2UWd6RFdSGHZaRiUO6xJ5FINYXLWpl+zWdhMLsJiDdZATUdE7S6gBVUfJel/UO4Fv1vFEsc47ltLVvmYU1XUjuRKph1W4oENQiA==
    3cq6bgkWc7AuNJWvrY4ujZqBMOamkhtLjaVavfdmGjgUGVWVo2mBgwGhaAh7MY66i90BtZBXHsKxAItJYl0ZaLjiSi0QVb3abpvnyEWsmqmJPKyCKR0ATUK2Y0B4Mtx9Ng4G1A==
    RXUdrR3rFmAxB+vUu5UccmFLrCfmmMQHyDJqTS31iTwshhzJZmssjFhXRgdnycUwBqeYWpd55fq6JVjMwTobISXqLQybXqwiIyGIDWrZfa4yUy1xCsEygsEU2KhuIkPRkpGQbA==
    gsy6srKHXYLFHKyLxXKm2opUhl5DqSmrX2o+SuopTtTpyo7q1wRikqvdqCvMhqlEM6IKdksxrz2EYwkWc7AuqIh2PpVMRQVOZe4MHjh28jnaOlGnKyQ7qvrDGJqbDYz64owuGg==
    4apxzmNyjVd2EwuwmIN1TK4V10MWb0dXXyboOfasN7+tU01DEMilXm00xdtkoFswOUM3weWOuUtBWJl1S7CYg3WpU8nVFh+DJiBxjF7DALXMfpxFm4d1oBA2K5phra/qYTXWcQ==
    d6Mxtqip1Sxm1645WYLFHKyL4NWlO3QteBBPLBIFUbJXhZ1maofVuMY2t2JSHJ3pG1hDrbCROrp2hKRBZm1dtwCLOViHSU809JqKBfCuljHph4jzEVwO5OdhXangm2ZTDW7kDQ==
    YNcMa1s0SV8VaJ8zrjyEYwkWc7BuTLMERUVNyAFYb/5Ri1AYGhar5zFRhsXYe+QEBusYJFlSNgSWDNWski7L+GTlWuIFWMzBuggWqSQXaw/QKXOw6tFtL0FGe/hEbgLjaM4kNw==
    5pNSD5u5mjwsBVs7OnfUZvPqGfbnsZiDddyjqyEVyTUCqJRVqS0dKdmaYhKYh3U9U8q9BpPH+FxwJelSZ4M9RB/U2Ea78uQXS7CYg3VUStJLzl2wgfek0DQfO4VAVabq6RTb6A==
    Opya4dLH0NweTPE+mY6tQ7Ns1dWuy7olWMzBOptq62P2QkdWTV5lJBeFNbizsN7/E8U6Ky4kL0YgoVG5PvrXFTCpuu5SiDX1lfvXLcFiDtZVva1UOniMXFT3RD1j8LkldVFsuQ==
    TdQOC0jie1UjwUkzLHIZ05uJaQFbtDk66ivHuiVYzME6sEPDjma/iNC8I9+BnYvd9jyGv8/DOg1lMtKV6T6KuokxvVQCTbjscms5pApr93RagMUcrFMpIRxd801vNB4Tj3uoIg==
    MQEgBJmoHTZh6bVQMc2jBrwsbDIBGfZhjALUlBtXZt0SLOZgnfSaWF1dhZihdiq2ISgkySXpESeKdZZ8qy2rkKMxMTd2DXONrPGpMQVUm1hXzrBLsJiDdeNRXugzVa8ZBhITiA==
    95Gzq744KxONm0AVR0H/m+QzGwi1maLO0EjRT2vtseWV2yaWYDEH69KY5qaJs60GhYUKjJHATRB5dOqaqJaYmoXkQjC5SjPgfDPZYTWUO6foUYJfezzsAizmYF1LEHyQKBQ6tA==
    Ukt2wecUqFebEvA8rFO/YDGzN6jayQBQNlxETIiJuw3Jd15Z1y3BYg7WUewuNcpIrL5pzMjbEStzzTZ7FyZqh+XcvARJprqkGda2YnJT/qFwLS0lBXvlWLcEizlYh5B6qc6HZg==
    1TdBJRq9V8ejUgVar24e1vXsESN0o6Cqh3UYDVlNuCKVC5eeSygr9zlZgMUcrFON0/VqQHAWoZQxEXRTJYtW7RTo0kSsQ9Qsis6I896A1D50XTO+t4Kq2yuu/RCCJVjMwboYWg==
    Z4dQc8rAFUka20Z660PFVieav47GA2DVNZhwp+uSc4ZTGd2dmveYJDhZ2cMuweInWQd+TEP2T8I6Ky6TeAyEHiS6koDUNPkyhk0hTTRGrCUvJbho9ES7gahLnNJ4mh644nKtXQ==
    Vh43sQSLOViHklSwYmjgCMazoCUyjuePe6hRTdQ8rLMYCmWXjASvrEvj0Req9ZR1hcA1KZxXZt0SLH6Sdf9cLWI4+mIk72hUg0dmBhHV1hzU8XGcyMNWH1sNzhvLdzPEFlDWiQ==
    GMwdBaLk4Ffuc7IEizlY11mveUHnwKtRIlua672pyknIbO1E9XUleJcLsQmq8MyY28GQjCeckZWk3pb92j3Yl2AxB+tqrr6qrNF4noGaK43Rc8xF7VSvaSJdl6tyS6wGt4isHg==
    NqukU5tolGyDjzbi2qOwl2AxB+sgRWEfQkGqEKKlKNFWi6qt0faZ5urURNp8wmLUHKquU1toiqYxI4mbdWKrF/vVrBvTkKT6Jdb5rgHKPWHdw0c/ybolWHzGum8lmNxR6l/weQ==
    A9wo5VRVYTWnuc6xDRW7yq4QPdri5+G6q1Y0VWo271257jMZdQpsKoCebFKf4Pq6XF+Cxa/A9ftgqhfwtL39x7X33l+Zzw7tz3cP2LEuqF2bh2XjgbdeXbFpVVQ9Ziiax2synQ==
    ALFWJ/ANETVzlBq/xLKgedjW+7z6NOOiU8bck20KkoSpqo5TGk/RMWPyaU27YTTOltHVGPVjF4KHrze2bF1N/CWS5Kre9KFS7SlJqib5jN9Mkn/ZrBlawxSd6+gJQgcqUTD2Ag==
    rDD6mR4r37hK7NhNqjIeettHr+RApsdcSxH1neXr51+8//clqmKBJP5J1nz46K6QL2XNJVh8ljWf3gAcfSm/NEr+4+aukFJrzayvUIonC5EbujSe9xvcRKPNKLkG7L0Jccyr7Q==
    XTSjacNEYqWdz1k957qsW4LFHKzLFmy20jG0ejeBA6iESWoYQXU0uIn6EWD1AQMq17yGOWhqEwq6OmKd8o01VYavT8u/KuuWYDEH69T6WIwpBvIZoHHJknORZvVVT3SmkbUkgg==
    TN10GRl2PEiA03j8qLfggtRM5esdw6/KuiVYzMG6LxgQZ8kRUkwTDTUTV7FUKya0gCrqarufyj0Vb71UGyl9fTe9n6XcF8gxtFqx30yOCf3Hp+Xj3crrq/3xuD18aPvzt9d6wA==
    3/+vAAAAAP//AwBQSwMEFAAGAAgAAAAhAFv5SOjyAwAAwAsAABoAAAB3b3JkL2dsb3NzYXJ5L3NldHRpbmdzLnhtbLRWS4/bNhC+F+h/MHSu13r70XgDW7aaBOumiJxLb5RE2Q==
    xFKkQFJ23V/fESWuvQ0TuA3ii6n55vlpNMM3b/+q6eiEhSScLR3vwXVGmBW8JOywdD7v0/HMGUmFWIkoZ3jpXLB03j7+/NOb80JipUBNjsAFk4u6WDpHpZrFZCKLI66RfOANZg==
    AFZc1EjBozhMaiSe22Zc8LpBiuSEEnWZ+K4bO4MbvnRawRaDi3FNCsElr1RnsuBVRQo8/BkLcU/c3mTDi7bGTOmIE4Ep5MCZPJJGGm/1//UG4NE4OX2riFNNjd7Zc+8o98xF+Q==
    YnFPep1BI3iBpYQXVFOTIGHXwOEXjl5iP0DsoUTtCsw9V59uM4/+mwP/Xw4kvaeSHnoiuUCi75OhjLpYvD8wLlBOoSuhnBFk5DxCW54IPo/gD0EA1rmizqSTl7hCLVV7lGeKNw==
    RmPquz18vDRHzHQ//AmdbvDQj3q8OCKBCoVF1qACWE04U4JTo1fy37lKoKsFkD5Y6B7vTq3E6fYJXXirbpCs/37AA0M1FPHqm9jxEhocTAW5n+fOQGfjmaStgTh874KUeN+Rlw==
    qQvFKRSTkb/xipUfWqkIeNRMfEcG30oAeIbIH+F17y8NTjFSLdD2g4LpN5NS0uyIEFy8ZyV8sj8sGKkqLCAAQQrvoN2I4GfN8zuMShiz3xl3cttWMLRLaQ6fOFdG1XWjbRCttw==
    faYdekU81w/TqRUJ4BdbkU2cbgMrksaJabbXiD8NQ39tRdZxFPhWJI1Xq4Hf10iw8dZuYkW2bjC1ImHo+TNr1pE7DbbhV5Ctu7IiX2U0XofTrbWe6czzAys7Mzf2Qis7s/k0mg==
    WjOYe3Hoz62I725iOzKPktDKwXwVbRNrbvMknEdWdlaul9hzW3lAtzWDVRLO1lZkvYlj38po4gaxa+3EZD1dxdYOSTZxsrJWmsZBZK803XhBpHOb9BB8TfWiW+R/CHPqRuOo7g==
    LRJU54Kg0a5b9ZNOIxfPa8IMnmPYXfgWydrcgONxD0jYSDSFXWIAvYDqRUlks8GVPtMdEoer30FDWKWw1z68+Cpg9GDxm+Bt06NngZp+5BkVLwwHS8LUE6mNXLZ5ZqwYbNsbqA==
    ZeXHk9A8Xek5LxSMLr06npAegVoXs/HnrCe7oCLrxhveoabpp2R+8JYOJYej8rrBpuCphBuhfsgP/oD5GvN7TD+goqsMtIfDVeYb2Y1eYGTBVRYaWXiVRUYWXWWxkcWdDG4FWA==
    UMKeYWCbYyevOKX8jMt3V/wLUU9CiQsCbzy71Pn1tvBLj1EiYYM0cLFQXBjsV415kb5xqD00yjNw9wlXayRx2fequXo//gMAAP//AwBQSwMEFAAGAAgAAAAhAIPQteXmAAAArQ==
    AgAAJQAAAHdvcmQvZ2xvc3NhcnkvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHOskk1LxDAQhu+C/yHM3aa7iohsuhcR9qr1B2TT6Qemk5AZP/rvDcJqF5fFQ4/zDvO8TyCb7efo1Q==
    OyYeAhlYFSUoJBeagToDL/Xj1R0oFkuN9YHQwIQM2+ryYvOE3ko+4n6IrDKF2EAvEu+1ZtfjaLkIESlv2pBGK3lMnY7WvdoO9bosb3WaM6A6YqpdYyDtmmtQ9RTxP+zQtoPDhw==
    4N5GJDlRoT9w/4wi+XGcsTZ1KAZmYZGJoE+LrJcU4T8Wh+ScwmpRBZk8zgW+53P1N0vWt4GktnuPvwY/0UFCH32y6gsAAP//AwBQSwMEFAAGAAgAAAAhAJf67ChNCQAAfSQAAA==
    EQAAAHdvcmQvc2V0dGluZ3MueG1stFrbcuM2En3fqv0Hl57XMXEnteNJgQSwmdR4k4qcl32jRcpmDS8qkrbH+fo0KXF8maPUbFJ5EokDNBrdpxsNQu++/9zUZw9lP1Rde7li3w==
    Rauzst12RdXeXq5+vQ7n8epsGPO2yOuuLS9XT+Ww+v79P//x7nE9lONI3YYzEtEO62Z7ubobx/364mLY3pVNPnzX7cuWwF3XN/lIr/3tRZP3n+7359uu2edjdVPV1fh0waNIrw==
    jmK6y9V9366PIs6batt3Q7cbpyHrbrertuXxZxnRf8u8hyGu2943ZTvOM170ZU06dO1wV+2HRVrzZ6UReLcIefijRTw09dLvkUXfsNzHri++jPgW9aYB+77blsNADmrqRcGqfQ==
    nlh+JejL3N/R3MclzqJoOIvmp5eaq/9PAH8jYKi/ZSUH6GN10+f9gSfHZTTb9Yfbtuvzm5pYScs5I41W74mWv3Vdc/a43pf9lnxzuUqi1cXU3pdN91D+TFTv2rz+0B6mIfe/QA==
    XT6Wti2uq6acW8mI3W4zUitJHPZlXc9xsa3LnHR4XN/2eUOMXlrmMfk45qR1cV02+3oa2a+r4nLVfyjYoUNR7vL7erzObzZjtycpDznZwvCjnndP+7uynTX7H4XcgkuuDvj2Lg==
    7/PtWPabfb4ldbKuHfuuXvoV3X+7MaPw6sn7R4lFv7nL96U7TDy8f9eth6nhqMlw9rAuP5OpyqIaKdz3VdHkny9XPJLJJOECiXhc77pubLux/Ll/+UZ6TMs9Py72TfO8xou3Yw==
    y7b46uWNnNeti5hXAw855flpc8hPNKTNGyLJq5xz1RXl5MH7vvp2Hk8DZiOzxRdwIiJS31dFeT2RczM+1WUgH22q3yZu/Xg/jBVJnB38FzT4IwWIPjTzTxRO10/7MpT5eE9s+A==
    myabCRfqan9V9X3Xf2gLCru/bbJqtyt7mqCiyLoiJlZ99zjb+YcyLyi2/+K8Fy9pRJtiMTN9eviFGLt0jSKnpPP+mFgIfUYiJkImICK413NAfY0o41OImMj7GCOSqaOt3iCxlA==
    FmsQ60RYiFitFUacstpBxEeGBYSwSMRSQ4SZRMCVMi6sgfMwrh3WjYlIG4MRaQ20DhktM9A6THPmoH9YSlpnEMmMN9gGjmWeY0THEdY6GI09N+3AMbQBF7TUYzp6i6jMLpvfaw==
    RKo0guzlmsUGeo5rrhPoOa514jBiRGqhRXmieYw1sDxx0KLciphDL/BUcY61TnWKmcg9twoiQhjDoReEUn7Zpt8gRgqGpcVCJlBrkUiyA0RslGCGCCuYO4GYE9lFpMwpjGQ8Sw==
    sNaO8Qj6VDiZxtgGnjMDc5UIxuBYkMzYFPJAKmIiXKmMI2egbjIhzkuIWOlwPpAp5wHaQKbSeJiRCPEeMkSmOngYjTLTEY5TGbgU0DqKaR1B7igug4daKykSBnVTip/IykoLlw==
    wZUqI1gGo1HFhinoH5WogHOiSmgi6G1FjE+g51QmEwMzn/KS4/ymAleY8Soon51AdJpBW2vKvhxqoFlkBdRAM25TaANNyddhaULzCHpBSxYHPMZwrmAs0MZoHeSbjikvY91ikQ==
    ZdA/Oib+Qu4Q4nHtoimHBchrbbnFEawzEeE9WGdSxTCCNWWkL4e8N4iWFq8nTPsZQgyjAII8MEx7DjlKpRixByPS4j3LKGFS6FOjo2BhHjVaMbxSQ4kC515jaBM+hViHdUuMiA==
    IHeMjSyH3DEp5V5sAy84rp7iaeeGY2LahQPkAZVOBuf4mCnHYUaKqeoM0G6EeJxHYz6VPBARVCRhDaSkfRMjFPTQboT4CPonVkJ4PEbpFGeXOOEG1yFxJpIIxk/sjDTQ27HXQQ==
    Y908MQ7mqjhQToRjEspwBvKAEgV3ULeEK4lzbyKES6HWVFYZcQIRlkGGJFKJFOumKPNhhCwQQR4khntcVyUxTxRkYpIwjiOYEKNgFkumBWENEhMrLC1lcYatk8oYn7OSzESYVQ==
    iVNRDCM4cVQJYVt7SqR4Hs8VwysNnGFv2yhKkxMIsynMIZZqSA99Stt5htlrJU9xZWeNDgJax1LE4XOWJZLi2LZEHhxZNjDvTiBSKph3bNA8g7ZO6RxqodYpi5yGnptKZVy/pQ==
    gtMuDBE65GAvpFIYXKGkinY6PEZPn14wQqczjFAqV9DbaUw1H7QoIZT7IJKwzMJclSY84KhPE01VJEQyLji2m+OU/zEiFK5qiKAJ5kHqdYr3uTREgUHdMm4yBrmTCR0YjJJMmA==
    GGfYTJIS0D+ZZA6fpjIpJN6zMml4BNeTGTqXQO5kVgt8xshSE1nIg8wxcitEvPQBsspx5jRcj6MSyUFbO8FCBudxkhIMHkN2y6AXHG1mmL0UPFZDi57+oun0VElDhIrlACPYGQ==
    OppBHhDiI7xSM221JxCLqydnib14PVbFEWSvS+WJqtMFQeIQ4hljGeSO5zw10G5eRhnmgZeMxdAGXlJxCW3tpYnxGcMrGXDMea0k/kbstaEqBSJJxPHuTCWNxbnKWy41toHlKg==
    OYUYi+ch7zAYwT5jCd7rfSazGHLHu0jg70je09aI/eOVCHBMYJLh76OBR8FAn1LpkmBWUdkQ8BcM2tBjjqVJo3FGClpb/D0+UPmGKztCEgH5FmJmPfRCiGUcIA9CrCU+LwQrHQ==
    /n4Q0kjj/TSkwuGvEcFpKvsg4ll8QoPJPDCCCfH4G1cIxsWztIsDNLx/16yni/7pxvHwNF3tnTWHEVne3PRVfnY1/RXgYupx039Kq3bBb8pd15cvkc39zQKenx+AocnrOvT5dg==
    AeaFNuuiGvau3M3P9VXe3z7LPfboYWtR7n78Imu6Ei/7//Td/f6APvb5/nBlt3RhUh5HVu34sWqW9uH+ZrOMavP+6QV03xY/PfSznZ7N87ge78pmvvr8mM9XeHPfsj3/dXMw9g==
    tu430/VceZXv94dbvptbdrmqq9u7kU0XcyO9FXn/aX65ueVHjM8YP2DzS76dVka9jw/PbXxpe9FPLG3iuU0ubfK5TS1t6rlNL216art72pd9XbWfLldfHqf2XVfX3WNZ/PCMfw==
    1XQwwnwR/2dv5o+96/ypux9f9Z2wqfP+tYQiH/PlqvPV4Jnib3SZ/qqwrYiOm6fm5vkfBv86KF5Xw7gp93mfj12/YP+eMabmfymM18TiT+TYX8pdmg9lcQik5X9D738HAAD//w==
    AwBQSwMEFAAGAAgAAAAhAArpCLbhAAAAVQEAABgAKABjdXN0b21YbWwvaXRlbVByb3BzMi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnJDBag==
    wzAMhu+DvUPQ3bXTJV1S4pRuptDr2KBX11ESQ2wH2xkbY+8+h526407ik5C+HzWHDzNl7+iDdpZDvmGQoVWu03bg8PZ6IhVkIUrbyclZ5GAdHNr7u6YL+05GGaLzeI5ostTQqQ==
    ngWHLyaqY16zgpSi3JLi4VSTY/VYEJGLZ1GIp6oud9+QJbVNZwKHMcZ5T2lQIxoZNm5Gm4a980bGhH6gru+1QuHUYtBGumVsR9WS9OZiJmjXPL/bL9iHW1yjLV7/13LV10m7wQ==
    y3n8BNo29I9q5ZtXtD8AAAD//wMAUEsDBBQABgAIAAAAIQDaT9EA/QAAAFIBAAAYACgAY3VzdG9tWG1sL2l0ZW1Qcm9wczEueG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAXJDBasMwDEDvg/1D8N21k2xLFuKUMhPIdd2gt2ISpzXEUrCdsDH273O2U3cST0J6kur9h52SVTtvEARJd5wkGnocDFwEeX9raUkSHxQMakLQggCSfQ==
    c39XD74aVFA+oNNd0DaJCRNjJwX54mnBWy5b+tK2GX14lpyWRZbTw+NBllmRZwWX3ySJaohjvCDXEOaKMd9ftVV+h7OGWBzRWRUiugvDcTS9ltgvVkNgGedPrF+i3p7sRJptnw==
    v+5XPfpb3FZbnBFkcVBZ0zv0OAY6fIKK5CmolTk9owueHX9PdcP5qCbtzx2sGLUszaOOsKZm/zwb3/yh+QEAAP//AwBQSwMEFAAGAAgAAAAhAFA6Z0nLAAAANgEAABMAKABjdQ==
    c3RvbVhtbC9pdGVtMi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArI9BasMwEEX3hdxBzD6Wm0Uoxk4IpFkmBbdddSPLY1sgzRhpEpzbV4S2Jw==
    6PIzjzf/1/sleHXDmBxTA89FCQrJcu9obODj/bR+AZXEUG88EzZADPvd6qnuqpav0WJSLXq0gn0rd5+Br8PboXWLTK+9kyy9DIOzeCHvCIsleVAP8GxChjML6vP3+xZUbkOp6g==
    GphE5krrZCcMJhU8I+XbwDEYyTGOmh/iI9trQBK9Kcut7lznHY/RzNP9R/Yvql2t/wbn9d8AAAD//wMAUEsDBBQABgAIAAAAIQBcliciwgAAACgBAAAeAAgBY3VzdG9tWG1sLw==
    X3JlbHMvaXRlbTIueG1sLnJlbHMgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjM/BisIwEAbg+4LvEOZuUw==
    PYgsTb0sgjeRLngN6bQN22RCZhR9e4OnFTx4nBn+72ea3S3M6oqZPUUDq6oGhdFR7+No4LfbL7egWGzs7UwRDdyRYdcuvpoTzlZKiCefWBUlsoFJJH1rzW7CYLmihLFcBsrBSg==
    GfOok3V/dkS9ruuNzv8NaF9MdegN5EO/AtXdE35i0zB4hz/kLgGjvKnQ7sJC4RzmY6bSqDqbRxQDXjA8V+uqmKDbRr/81z4AAAD//wMAUEsDBBQABgAIAAAAIQB0Pzl6wgAAAA==
    KAEAAB4ACAFjdXN0b21YbWwvX3JlbHMvaXRlbTEueG1sLnJlbHMgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AACMz7GKwzAMBuD94N7BaG+c3FDKEadLKXQ7Sg66GkdJTGPLWGpp377mpit06CiJ//tRu72FRV0xs6dooKlqUBgdDT5OBn77/WoDisXGwS4U0cAdGbbd50d7xMVKCfHsE6uiRA==
    NjCLpG+t2c0YLFeUMJbLSDlYKWOedLLubCfUX3W91vm/Ad2TqQ6DgXwYGlD9PeE7No2jd7gjdwkY5UWFdhcWCqew/GQqjaq3eUIx4AXD36qpigm6a/XTf90DAAD//wMAUEsDBA==
    FAAGAAgAAAAhAPFvOEfiFQAAq68AABgAAAB3b3JkL2dsb3NzYXJ5L3N0eWxlcy54bWzMXVlz28aWfp+q+Q8sPc08JO59SV3nVq+T1M3iGzuTZ5iELE4oQkNScXx//RyAlEy5CQ==
    NhsEUlOpWNy+rw/OfhoA+be//3m/mv1Rb7bLZv36Bn+Nbmb1et4slusPr29+fRe/Ujez7a5aL6pVs65f33yqtzd///bf/+1vH7/Z7j6t6u0MCNbbb+7nr2/udruHb1692s7v6g==
    +2r7dfNQr+HN22ZzX+3g6ebDq/tq8/vjw1fz5v6h2i3fL1fL3adXBCFxc6DZXMLS3N4u57Vv5o/39XrX4V9t6hUwNuvt3fJh+8T28RK2j81m8bBp5vV2Cwd9v9rz3VfL9TMNZg==
    CdH9cr5pts3t7ms4mINEHRXAMeoe3a8+E/AyAvJMcD//5vsP62ZTvV+B9kGSGZDdfAvqXzRzX99Wj6vdtn26ebM5PD086/7EZr3bzj5+U23ny+U7WBlI7pfA951Zb5c38E5dbQ==
    d2a7rI7fDIfX2vfv2g+eRM63u6OX7XKxvHnVLrr9F7z5R7V6fUPI0yuuFeLFa6tq/eHptXr91a9vj4U5euk98L6+qTZfvTUt8NXh2PZ/j4744ctn3cIP1XzZrVPd7mpwLixQSw==
    ulq2vky4fnryy2Or3upx1xwW6Qj2f59pXyVKB58DD3y7DwR4t779oZn/Xi/e7uCN1zfdWvDir9+/2SybDTj76xvdrQkvvq3vl98tF4t6ffTB9d1yUf92V69/3daLz6//M3YOew==
    eGHePK7hMZW4c4TVdhH+nNcPrfvDu+uqtclPLWDVfvpx+XnxDv6/T2T4YIlT+Lu6anPADH9J0YlfREFaxPboaE9zPn5x7N2nihaif9VC7K9aiP9VC4m/aiH5Vy2k/qqFOpopFw==
    Wq4X9Z/7QEyXSVhzPD3RWMzTE2zFPD2xVMzTEyrFPD2RUMzT4+jFPD1+XMzT46YFPLtm3ueFR85Oe7z9PG++RgzjzZeEYbz5CjCMN5/wh/Hm8/sw3nw6H8abz97DePPJupx33w==
    as2+hzBb766Ostum2a2bXT3b1X9ez1atgasbjMbha4tevRnlIEeg2We2QyG+mm1edc/zHtIF6fB6vmtnuVlzO7tdfnjcwDx9reD1+o96BZPtrFosgG9Ewk29e9z0aGSIT2/q2w==
    elOv5/WYjj0eaTsJztaP9+9H8M2H6sNoXPV6MbL6nhhHSQrPDg3z810bJMsRnPq+mm+a60VrqtHyww/L7fW6aklm9nG1qkfi+mkcF+u4rp8NOprrR4OO5vrJoKO5fjA4stlYKg==
    OrCNpKkD20gKO7CNpLe9f46ltwPbSHo7sI2ktwPb9Xp7t9ytuhR/3HXgy/fu3Kppt7KvluPt8sO6ggbg+nJz2DOdvak21YdN9XA3azemT9MeH3PpOrZZfJq9G6OmPTON1dd3Lg==
    4uCol+vH6xX6gm2s4HrmGym8nvlGCrBnvutD7Edok9sG7btx5pm3j+93J4O2Y7ooaN9Wq8d9Q3t9tFW76z3scwDE5WY7Whicph3Bg39q29nWnGNkvs9SXi/YZ67rw+rLrDSqeA==
    B8oRpFw189/HScPffXqoNzCW/X41U2xWq+ZjvRiP8e1u0+x97TjkSWeSi0I+3D/cVdtlNyu9oLi81D+dBJ/9WD1cfUBvVtVyPY7dwlf31XI1G6+D+O7djz/M3jUP7ZjZKmYcQg==
    2+x2zf1onIedwP/4rX7/n+MIaGAIXn8a6WjNSNtDHZlbjlBk9kzNYiQmaDOX6+UoNbTj+0f96X1TbRbjsL3Z1PvrTnb1SIxvq/uHfdMxQmxBXvwI+WeEbqjj++9qs2z3hcYKqg==
    d6OQHW0bbh/f/089vz7V/dTMRtkZ+vlx1+0/dq1uhx6P7vo24QXd9S1CZ00oD63/jnCwL+iuP9gXdGMdrFtV2+2y9xTqYL6xDveJb+zjvX74O/A1q2Zz+7gaT4FPhKNp8IlwNA==
    FTarx/v1dswj7vhGPOCOb+zjHdFlOr4RtuQ6vv/aLBejGaMjG8sSHdlYZujIxrJBRzaqAa6/QueI7PrLdI7Irr9WZ082UgtwRDaWn41a/kc6y3NENpafdWRj+VlHNpafdWRj+Q==
    GfWz+vYWmuDxSswR5Vg+d0Q5XqFZ7+r7h2ZTbT6NRBlW9YdqhA3SPdubTXPb3pDQrPcXcY9A2e5Rr0Zstvd0Yxn5t/r9aKK1XGPKNcKOaLVaNc1Ie2ufC06HfHntWg7W3clxtQ==
    CG9W1by+a1aLetNzTP1YmJff7m/L+FL8ToyLtj1/WH64283e3j3v9h/TCJRFPg3sL2D5BU/pXDzdz3IK9mO9WD7ePwma3kwh6OXgzqNfgFke/LmTeIHkFyLTNUUe+blLfoGUFw==
    ItM11YXILk5fIM/Fg682v590BHnOf55nvB7nk+e86Bl8ctlzjvSMPOWC8pwXvQiVmZnP27MFqXUui5l+/GXB048viaJ+lpJw6me5OK76Kc4F2C/1H8u2spckzW6956snkrzfNQ==
    0Rdlzn8+Nvt9+xcnnC6/qet7aJzW23p2kodefuLqRZbp1+PF6aaf4uK8009xcQLqp7goE/XCi1JSP8vFuamf4uIk1U9RnK3SilCWrVJ8WbZK8UOyVcoyJFtd0QX0U1zcDvRTFA==
    B2pKURyoV3QK/RRFgZrABwVqylIcqClFcaCmFMWBmjZgZYGa4ssCNcUPCdSUZUigpizFgZpSFAdqSlEcqClFcaCmFMWBOrC374UPCtSUpThQU4riQE0pigO16xevCNQUXxaoKQ==
    fkigpixDAjVlKQ7UlKI4UFOK4kBNKYoDNaUoDtSUoihQE/igQE1ZigM1pSgO1JSiOFD3txoOD9QUXxaoKX5IoKYsQwI1ZSkO1JSiOFBTiuJATSmKAzWlKA7UlKIoUBP4oEBNWQ==
    igM1pSgO1JSiOFC7k4VXBGqKLwvUFD8kUFOWIYGashQHakpRHKgpRXGgphTFgZpSFAdqSlEUqAl8UKCmLMWBmlIUB2pKcc4/D6co+y6zx+W7nr1X7F9+6uog1C/Ht3IfU9HLqQ==
    nqTq57r8XgTbNL/PTt54SLt54zKS5fvVsum2qHtOqx/zdpdEFJ34/Nmdv8PnmP3KL1063AvRnTNNyNmlyGRPhZ1z+WNkMuSxc55+jEy6TnYu+x4jkzLIziXdLi6fLkqBcpSAzw==
    pZkjMO6Bn8vWR/BUxedy9BEw1fC5zHwETBV8Lh8fAfmsTc5fovmFehLP15cmDOfc8YhB9jOcc8vUVk/pOA2MS43Wz3Cp9foZLjVjP0ORPXtpyg3bT1Vs4X6qYaZOw6zU1MMDtQ==
    n6HU1CnDIFMnNMNNnVINNnVKNczUaWIsNXXKUGrq4cm5n2GQqROa4aZOqQabOqUaZuq0lJWaOmUoNXXKUGrqKwtyL81wU6dUg02dUg0zddrclZo6ZSg1dcpQauqUYZCpE5rhpg==
    TqkGmzqlGmbqZEouNnXKUGrqlKHU1CnDIFMnNMNNnVINNnVKdc7U3S7KC1MXWfgIXtaEHQHLCvIRsCw5HwEHTEtH6IHT0hHDwGkptdWTzcumpWOj9TNcar1+hkvN2M9QZM9emg==
    csP2UxVbuJ9qmKnLpqVTph4eqP0MpaYum5Z6TV02LZ01ddm0dNbUZdNSv6nLpqVTpi6blk6Zenhy7mcYZOqyaemsqcumpbOmLpuW+k1dNi2dMnXZtHTK1GXT0ilTX1mQe2mGmw==
    umxaOmvqsmmp39Rl09IpU5dNS6dMXTYtnTJ12bTUa+qyaemsqcumpbOmLpuW+k1dNi2dMnXZtHTK1GXT0ilTl01LvaYum5bOmrpsWjpr6p5p6dXHFz/A1HJ3v0kGH959eqjb7w==
    4D66YWax/w7Sw0nA7oPfL55/KKkFt5LMDj9JdXi5E/hwwnC/YgdMl5rfwVrzw7cn9Sx1+BbU59t4uu9A/XLhnq9K7QT5rIKnTx9U+vlU6P5zL057npV716r8jMydSc7qaG+1Pg==
    AfXBDXMSgjzvV/sf7YIH368XQPDx8INVe0kXf1Z7Knjf1avVj9X+081D/0dX9e1u/y5G3U3zX7z/fv/9b734TZcoeglevRRm//Tww2E9+t5/I/zhDHavS7bRcELd3eUU12r6Qg==
    H36W5uhe3+5W3y/FSu4F3mu2gtV+buP72Ktfun7ZgWy2y9Ypuo8gJCyT4ZDwDz92N2+zxtMnFGr/Oxjp6Rfjeo77RZqYP27BJbqM8qVdrI8OK0+IIJIx5oymIVKMhOKYamcT1Q==
    ZAEnDowHym04CH6lwEZJJIJh2mvPjJaaEBlZ9Ewb6ZwhicBZwMQCO2It9j5KyQIzgWqlETKUBxUp8jgkAmcBEwtMBZOROMN9UEwwr4PEhAdikA+BGp8InAVMLLDlOHCvqXFBMA==
    HrBiQYcoNMKaSq5Sl8gCpvZhb4IgnBmrIiPcGB4MCgwLzDVRMdVwFjCxwDpY5Di3UQkJCrNWBU2ol4Far2CZROAsYGKBBSVE24CxQYxR+GOkcix4rSHFisOvjR4LnAVMLHBAOg==
    goICU5Iww6QVIjASIxIRQe5SicBZwMQCs0g0Z8JobQlDRGlmBDKOgLqo0ibVcBYwtQ9LaRgCFQXR/sut8JoLwZ2HfIuwTH04B5g6D0chGNLMh+gYJFOl4AHSGMTi2MhU4Cxgag==
    gTkWBFOCqAtMamSNFFwqbjELUog0S2QBEwuMogngfxqjgFmbU4MXQTskg43S01TgLGBigTn0W45D2EAlYAxryzCyXDOk2r8+LRxZwMQCRyIVJcxK5qBwIa60cFQbI3Tg2slUww==
    WcDkWUIID9bFEPkMCUiyAiuCYozEREtOVLocYOo8bCFBeeqsR1AHPAY9OaZD4CRwS7xL83AOMLHAnkfqObQBjINXUgdzgxGGkWAUtcamPpwFTC2wid4RhIiAOitk543WaiuDjA==
    RuKYCpwDTCywU1JpzISP2DAvtXUeYwVLGHBMx1INZwFTNz8GMn6EIY0zyzyNSlkdlRfKUomDpWnzkwNMLDChhhjjsAONQT+uDDVKKecCgqwlZNqtZQFTpzXFPTawIIqaRUw09A==
    A8RBmcUUekgn0rSWA0yd1qAAMAL/Se+hW8TWUe5IG/XUG4XTPJwFTB10MOkSC+NNhKk9WmucdRiets0CB9dMgy4HmNqHI2RPKLEKeUirjCsakWQsGEokQkanPpwDTN6tYSqVjA==
    0LzAZIaoitB/RYlp0ALGtVPdWgYwscAyeElDsB6md+agR1SIKcI0jVRKHdLSnAVMLDCOmiLqEbcK2hnidIhUSM+IUpE6jBKBs4Cpgw4GHSUMtcprJoJS2IN3OuwxgwLm0xEpCw==
    mDqtaQm1ClQVlGfKYSURgWkSEivxCJtUw1nAxAJTDwHkXduNe+YF115ZJKzj1kHpcieG0Bxg8n7YcyOwhQJgGYf4QRF5YrixAUEmOFE4coCJBbaOWU21hXndwHJQdAOh0JAjFA==
    KVIxzRJZwNR5mDMpVYRxF9KTRVQDOYX0CqmKaBfSwpEFTCwwt1CdlPM2OMOio9ZBjVXeEw4NueRpe5kFTB10ylNMpNUK2lzpjIlQd5nhURHNkUvbyyxgYoGhwfIWR6oDQRD2wg==
    KBY1jzpCs+BO7fxkAVOX5ggTg0OWcAoxHmCgJIxLKAqG0OBObKRkAVP7MCOQnbDAnhIWiDIwsAchgiYSSsSJXiILmFhgIWF5CgnfIsYIdrbdOAsBE86wpidOymQBUxeO6CWzwQ==
    CqopM8pbaG4hyUINs0jRkLpEFjC5SyAYeCXmLlIWlTYUQW5C0dIQrT4xImUBU2eJyLGj0gbtOGMQTNAxhiigpXGSy8DSLJEDTCywslZSS0wMAnpaorSSUAOiolS5cKq9zAKmLg==
    zdL5GHE0GCptNM4IhXkwYGgTDEHpSZksYGKBHegJPJAIaLego+UgByPaS0gBBhmf9hJZwNRZArVR1HYFXDBPsCKRGYx5RFG3mzlplsgBpm4vrQyGY088aM60p4IIc1ALYHIXjA==
    hrSXyAImFjhACTAaii3jGqYImB68YKy9pkCGyEWq4Sxg6rRGPRcE+kUiHWMSWplACDcaO2IxCulMlwVM3fwozoIPGAZfKFwIxst2n8RDd2Da/jYtHFnAxAJDnaXQZvGgoPnyMA==
    p2lMiZYUhh0kJTOJwFnA1M2Pg8aWaIZVUEwSbS3lJjLq2g1rYlOXyAImFphCyTIQOVBXLQNDW9CXgU4RIaMkdDjpxJEDTF04jAsGZp7IOEyXAlmODPTjQcDk016RlhaOHGBigQ==
    sYXuxSPoXSCRaiqUszDFW28gd0mhUoGzgKldgggXvYIunEUmvQGjwuAQCTUiBGgWUpfIASbvJbg3xkHzDa0hEjCZKdlt5UTZXmBwYjMwB5g6SyAbMIc2C2zMqIZnGhMfiPURRg==
    NZzOdFnA1O0l9xxxZb1uz1pBxxWMNgoaHGYcMydcIguYOuiUa8MmQGKi7eUPJjhocFXgKmpGUDqEZgETC6yJQNwZKrGKjFGllDDCehwJR9j5dETKAiYvzRxZIY1gGkOb6EF3Xg==
    k7a1DZYokVa6LGDq5sdhSE6C8OCh9+LR+qCM5oZCm44ETs/TZQETC0ykEJIoT2QEhUGrSzBFHvKpUsbB9JYInAVMLDAM6MRYj9o5koGlLZXaQ+sFExBFyKcXPGcBEwusgmyv2A==
    CSyi9n+jtDXeOSjAkL5gFk7H/Bxg6tLsYX6EGZ3AhAaDjrfQISAJXQExEEE6TWtZwNRZIjLoayFLaeSYk6Kd1SQ8FNoHJMmJLJEDTO0SPGLplRYKEpVvLzeKQjhoFjRoC9N0Mw==
    MAuYupdgMlqHCfUIpnbmlGr3/9trmQNr79hIe4kcYOpuLbRNC2XtrSPM2vYCqTa/CpgoDINHabeWA0wsMKc+GiyY01JD+yJU8AZ5ZaExcMK7tHBkAVN3awFr6MYFVYKwwDEEPQ==
    jDuCWBGREipNa1nA1D4cJISMoB7GYNZeIh64Ee0V7YQ5DiN86sM5wMQCt4oJWBKs2g0nyPyGhWAsZFpPguFplsgCpi7NJopgBcaMQJQr1DaKsb0rQwpjYHRPS3MOMHWW0I44iw==
    dXe/gPIYxl+oWVy3E090MvXhLGBigaFDDIZQamFeZ5QjxQNHDsFkHASKJy6hyQJOCEwiaP/Ju/c3Cq6q9YenDyyqr/w/Wqnqarsz22X19NL+CEe6c9B4BR2EQ0Z4zCDYDMzMIg==
    ekcph5nEnrgRLwf4/3qkuD0ZYpRU0OQxZKLGTnPCOA06WMnTLfQs4MSRfr75c4z+UMF0ZaBLhdLIYeSm2sE/FsOA5YhME2kWMLHAFjI4gbGKOhDEe28UpHVvYbyiCIcTmT8LmA==
    WGDHsQ9CwnSFJSgMaQcFPVConfAOYunWTRYwuUt4ITnGURDFaGTK8iBgmGXG20BO3NeQBUwssJDBOgdeCP9Cu0cUArV5AcVTwFxw6g6+HGBigTViSKMQoR1p76dgljEYVaDtYw==
    MUaGT2zd5AATCwzpFwkuOVVEM5hZrA5a2+CRbm8TYidOFucAFwr89Gj77f8JAAAA//8DAFBLAwQUAAYACABZYRhNEFfRpTkBAABIAgAAEQAIAWRvY1Byb3BzL2NvcmUueG1sIA==
    ogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApVLNTsMwDH6VKvc2ycZQqdpOAsSJSUhMAnELibeFNUmVeOv2bA==
    HHgkXoG2dJ1A3LjZ/n5kf/Ln+0c+P5gq2oMP2tmC8ISRCKx0Stt1QXa4ilMyL3PpPDx4V4NHDSFqNTZkShZkg1hnlNY7XyXOr6mSFCowYDFQnnBKRi6CN+FPQY+MzEPQI6tpmg==
    pJn2vAljnD4v7h/lBoyItQ0orIRBNSpCD4ekXdW2yMp5IzD0DrWQW7GGzumSGkChBAraXRbX42mkzJXMUGMFEe3rsHt9A4lDJz0IdL7rtnBsnFdhQBQE6XWNbY7dpBIBF22MKw==
    Der62E087HWXcslzOtb5EMy3MaioPT/DYw0FOSFP05vb5R0pJ4ynMUvjycWSXWWcZTOezPiUc5a+5PSXz9nYDEv82/lkVOb05zuUX1BLAwQUAAYACAAAACEArcCE0WQPAACXkg==
    AAAPAAAAd29yZC9zdHlsZXMueG1s7F1Lc9w2Er5v1f4H1px2D47mJclyRUlJI2ntiq0olpycMSRGw4hDzJIcy8qvX7zIAacJkg1itanKlg/WkOwPQH/djW6Aj+9//LZJgq80yw==
    Y5aejybfjUcBTUMWxenj+ejLw82bt6MgL0gakYSl9Hz0QvPRjz/8/W/fP7/Li5eE5gEHSPN3m/B8tC6K7bujozxc0w3Jv2NbmvKTK5ZtSMF/Zo9HG5I97bZvQrbZkiJexklcvA==
    HE3H45ORhsn6oLDVKg7pFQt3G5oWUv4oowlHZGm+jrd5ifbcB+2ZZdE2YyHNcz7oTaLwNiROK5jJHABt4jBjOVsV3/HB6B5JKC4+Gcu/Nske4BgHMK0ANuG7D48py8gy4drnPQ==
    CTjY6Aeu/oiFV3RFdkmRi5/ZXaZ/6l/yvxuWFnnw/I7kYRw/8JY5yCbmeO8v0jwe8TOU5MVFHpPGk2vxR+OZMC+Mw5dxFI+ORIv5H/zkV5Kcj6bT8shC9KB2LCHpY3mMpm++3A==
    mz0xDi057vmIZG/uL4TgkR6Y+t8Y7vbwl2x4S8JYtkNWBeWWNTkZC9AkFoY8PT4rf3zeCd2SXcF0IxJA/V/BHgGNc4Pj5nevvICfpauPLHyi0X3BT5yPZFv84JcPd1nMMm7p5w==
    ozPZJj94Tzfx+ziKaGpcmK7jiP62pumXnEb747/cSGvVB0K2S/nfs9OJtIIkj66/hXQrbJ+fTYng5FYIJOLqXbxvXIr/uwSbaCaa5NeUiAAQTA4hZPdREFMhkRujbcbcHYxdXg==
    hWpo9loNzV+roePXaujktRo6fa2G3r5WQxLmv9lQnEb0m3JE2AxA7cKxeCMax+JsaByLL6FxLK6CxrF4AhrHYuhoHIsdo3EsZorAKVhos0LD2GcWa2/H7Z4j3HC7pwQ33O4ZwA==
    Dbc74Lvhdsd3N9zucO6G2x293XC7gzUeV6VawQfuZmkx2MtWjBUpK2hQ0G/D0UjKsWRV5AdPTHo08zJIDzAqsumJeDBaSOTvbguRTuo+nxeikAvYKljFj7uMF9NDO07TrzThZQ==
    bUCiiON5BMxoscssGnGx6YyuaEbTkPo0bH+gohIM0t1m6cE2t+TRGxZNI8/qKxG9BIXKoHn9vBZOEnsw6g0JMza8a4x4iw8f43y4rgRIcLlLEuoJ69aPiUms4bWBhBleGkiY4Q==
    lYGEGV4YGJz5UpFG86QpjeZJYRrNk96UffrSm0bzpDeN5klvGm243h7iIpEh3sw6Jv3X7hYJE+vYzf0wE5nmjvVt5j5+TAnPD4bPRnpJNbgjGXnMyHYdiEXrzv6j27lk0Uvw4A==
    Y8qrkHyl/dKCFnzUcbobrtAami/fq/A8eV+F58n/KrzhHviJZ9Eif3vvp9y53y2LRp9GOBtJdirfHe5tpBhuYXsHuImz3JsbNMN6sOBbke0KOn1kgvteDu/YHmu4Wx1GJa/d0w==
    kB56mbDwyU8Yfv+ypRmv2p4GI92wJGHPNPKHeF9kTNma6fJTSUkvl7/ebNckj2UpVYPonwmUG+TBJ7IdPKC7hMSpH96u32xInAT+Moj3D58+Bg9sK6pQoRg/gJesKNjGG6ZeKA==
    /MdvdPlPPx284DVy+uJptBeeVo8k2CL2MMkoJBZ5QuJpZpzGXuZQifcTfVkykkV+0O4yqu5JKagnxHuy2aqkw4Nv8bj4zOOPh2xI4v1KslgsG/lyqgcvYMaqYr5b/k7D4aHulg==
    BV4Wjn7eFXJ5Uqa6Utof3PA0oQY3PEWQbPLpQdivh8HW4IYPtgbna7CLhOR5bN1hdcbzNdwSz/d4hxd/Go8lLFvtEn8KLAG9abAE9KZCluw2ae5zxBLP44Alnu/xejQZiedhxQ==
    TuL9K4sjb2RIMF9MSDBfNEgwXxxIMK8EDL+BxwAbfhePATb8Vh4F5ikFMMB82ZnX6d/TJpAB5svOJJgvO5NgvuxMgvmys9lVQFcrngT7m2IMSF82Z0D6m2jSgm62LCPZiyfI6w==
    hD4SDwukCu0uYyvxsAJL1T3eHiDFGnXiMdlWcL5I/o0uvXVNYPnsl4cVUZIkjHlaW9tPOFKyfmtbl5h80GNwF+4SEtI1SyKaWcZkl+X18r16auOw+7IbvZY9P8aP6yK4X1er/Q==
    JszJuFOyLNhrYt0NNun8pHzcpUnsE43i3absKHzW4mTWX1hadE143i28zyRqksc9JWGbJ92S+yy5JnnaUxK2+banpNruNiXb/OGKZE+NhnDaZj9VjWcxvtM2K6qEG5ttM6RKsg==
    yQRP26yo5irBRRiK3QLITj+fscv3cx67PMaL7CgYd7Kj9PYrO0Sbg32mX2Mxs2OCpmyvunsCxH2ZRPeKnL/smFq3r2049X/m6wNPnNKcBo04s/4bV7UoY9dj73Bjh+gdd+wQvQ==
    A5AdolcksoqjQpIdpXdsskP0DlJ2CHS0gjMCLlpBeVy0gvIu0QqiuESrAVmAHaJ3OmCHQDsqhEA76oBMwQ6BclQg7uSoEAXtqBAC7agQAu2oMAHDOSqUxzkqlHdxVIji4qgQBQ==
    7agQAu2oEALtqBAC7agQAu2ojrm9VdzJUSEK2lEhBNpRIQTaUWW+OMBRoTzOUaG8i6NCFBdHhShoR4UQaEeFEGhHhRBoR4UQaEeFEChHBeJOjgpR0I4KIdCOCiHQjqqeRHR3VA==
    KI9zVCjv4qgQxcVRIQraUSEE2lEhBNpRIQTaUSEE2lEhBMpRgbiTo0IUtKNCCLSjQgi0o8rNwgGOCuVxjgrlXRwVorg4KkRBOyqEQDsqhEA7KoRAOyqEQDsqhEA5KhB3clSIgg==
    dlQIgXZUCNFmn3qL0nab/QS/6mm9Y7//1pXu1GfzSW8TatYfquyVHav/swiXjD0Fjc8lzmS90Q8kXiYxk0vUlm11E1feEoHa+Px50f6Ej4k+8J1M+lkIuWcKwOd9JcGayrzN5A==
    TUlQ5M3bLN2UBFnnvC36mpJgGpy3BV3pl+VNKXw6AsJtYcYQnljE26K1IQ5V3BajDUGo4bbIbAhCBbfFY0PwOBDB+VD6uKeeTqr7SwFCmzkaCKd2hDazhFyV4Rg6Rl/S7Ah92Q==
    syP0pdGOgOLTCoMn1g6FZtgO5UY1dDMs1e6OakfAUg0RnKgGMO5UQyhnqiGUG9UwMGKphghYqt2Dsx3BiWoA4041hHKmGkK5UQ2nMizVEAFLNUTAUj1wQrbCuFMNoZyphlBuVA==
    w+QOSzVEwFINEbBUQwQnqgGMO9UQyplqCOVGNaiS0VRDBCzVEAFLNURwohrAuFMNoZyphlBtVMtVlBrVKIYNcVwSZgjiJmRDEBecDUGHasmQdqyWDATHaglyVXKOq5ZM0uwIfQ==
    2bMj9KXRjoDi0wqDJ9YOhWbYDuVGNa5aaqLa3VHtCFiqcdWSlWpctdRKNa5aaqUaVy3ZqcZVS01U46qlJqrdg7MdwYlqXLXUSjWuWmqlGlct2anGVUtNVOOqpSaqcdVSE9UDJw==
    ZCuMO9W4aqmValy1ZKcaVy01UY2rlpqoxlVLTVTjqiUr1bhqqZVqXLXUSjWuWrJTjauWmqjGVUtNVOOqpSaqcdWSlWpctdRKNa5aaqXaUi0dPde+zySw5ffK+MXFy5aKV3QbDw==
    zETqHaR6E1Be+CGqvqMkhEVPAv3FKn1YdlhvGMq/s5xXdfqa8fjqeH51fa2usn2Rajo2v0g1r35Yv0glu9YxmKr7ej9UfSjKHMD++06yd0uS0+hnoW8wvFS8/K/huHhJXnm8bA==
    ZrEmmTq7p6O8RhucXVsX8+nltd5StGnL1NVecUpX9BsJCyXO1OuIPn5NKnhTi9XH0Zby6v0Hyybar8wPlk2kvxvfHXMhYGolQEclPwRMexBQ3/Tu4GS+OBlfdHJi0bm0LaDzDg==
    bctjA7U9s2pb75L70fbMt7YbPOCJ0u0t75I8Jn585DrOldoqIpbizXFcKSp6dNFSBsc6Lc3fCSS/t3wnUJy81sfE+dqnAmuS+08FisOX1acCQxHJK+pv5len8t0V8mIZ5XkElA==
    MV4GZXlY3HjEgU5vStuphqXvY6h9bFAe67amkBPJg4d6uZ1lJtAvqa6espSvqD60M8ubrC02ooPv/k6VZpOx97sQM2JLn+WM2TqFqUnVasTairt6yPuzTJQd8T8+pMKmn3W0Vg==
    PY2+EQXFzy9oknwi6mq2tV+a0JVwRX52MlZ2UT+/VK/ntMpnMo+zAhzVO6N+ttuJ+p6HvsHImjGIZKVB3fJut6Ga7mELdfbFOjPojMqk5CmlyXo8NM3G0t/yXRL1AHY9Hy/Kew==
    QvtM4V3pTt2uLlkW0UwmcspuZKviVfd64H/wECj/4G3S6mOZKoxo5MqqnGQri3OSLu3RSTjmoTSi74eJ/+omrlyjUn8fT2men2/Ud58OzVF/DqrJFG1TsEJqnYDtM3Cn0XJfUg==
    ZkaW5XViFlLzw5blogp8qydY4xpJcHXJ2Uzd5C3UpfGac6fu5L42P4W7nBuhLGoOY4+hlUMdq1PBXmMHim6c3ixq71K5Tb89B1gNR79C+3Ao+jBuFLC35ZeI7fmYaRm1imG5EA==
    KdiQLLXBC/S31TBeoJD+7wV1LzC0cqhjdWqoF2gCX8kLjLcpyZcpHY4JvG1pqGNYcpFO36hl82/H4p8eb4ebtKQuajv7cMjG5rm6oGnIPbKY8ibkg6EtJmdniIWI18tiLm/EPw==
    ccAskZYkfHrM2C6NQJl0qcskfNLj3JRLjuTcmENK5dyWUwY2sDVkwubYmrf87paV72479FjjtW5dE5y1Tm6ZqCeTyULX/63LVH4nmWrJ83C0+mQw8THTiFasobopfpnLSK+20A==
    qR4OOlSEOto0fnMO7bPmJpHaMp2JjuXDFpgn0+aV4h7LY5blrwPNz3pqua8d7vXSqPuhBmgQaFd5p/m9uvaabbT6DtehqqoTPiy1BGs11s6Q1qDF2spmz9SqrxnVOm1Tz1Bjqg==
    q9mulf+pJmpbKYeaKAP71FNg1yVoz8Bu7sZ43U1B6kZtfNh0M/OkG11cuE96f+ktjeYIWH4a9JC78ngTabY4p2XawpymsHv7wB4HJ9PZxemVwgGTdrnxNX3bsPMVy20IUflwIg==
    yqdcfw9LaLVMoXT5Z9sKO748u7ySd7A02Y1XlzZZtFjFUH+uGVdfI7FbwV+RJXmwudZQpwZPzRJFH2fhU+Ma4dnidKyqBAsLnGuSxMuspv3aQany2pEwF1nmhubBLX0OPrMNSQ==
    G3Q9Hp+OF9qxYdHCzao8oAtlfIzs1L5F86iYafDYEfdMXVvj3okZ9qp11rZo9idnqPwr/+E/AAAA//8DAFBLAwQUAAYACAAAACEA7lagJYMBAACeAwAAFAAAAHdvcmQvd2ViUw==
    ZXR0aW5ncy54bWyUk8luwjAQhu+V+g6R75BAaVVFBCSEqCrRRd3ujjMBq7bHsg0pPH2HhK3LAU6e+cfzeUZ/0h9+aRUtwXmJJmOddsIiMAILaWYZe3+btG5Z5AM3BVdoIGMr8A==
    bDi4vOhXaQX5K4RAN31EFONTLTI2D8GmcezFHDT3bbRgqFii0zxQ6max5u5zYVsCteVB5lLJsIq7SXLDthh3CgXLUgoYo1hoMKHujx0oIqLxc2n9jladQqvQFdahAO9pH60ang==
    5tLsMZ3eH5CWwqHHMrRpme1ENYraO0kdaXUAXJ8H6O4BWqT3M4OO54osoEkigrEBeVDIpd+eUZXKImNXvaTX7dwkdTnHYjWuS0uuyF4Wb1QyYApl2KnJXn2Rs/k/8hvav+IIQw==
    QP1LpzFGhdtE4dBj6MNhlPj15t4msFzANhaokPzmi4ANQh1Ndl5n/mOi83rd8ebntMaHpZtwd9a2oA1SyzVM0I0cVh5c8xqo1ZP5eJjWGVcKq+fHu4Z29FcNvgEAAP//AwBQSw==
    AwQUAAYACAAAACEAGY/LP8QBAADtBAAAEgAAAHdvcmQvZm9udFRhYmxlLnhtbLyS24rbMBCG7wt9B6H7jWUn2YNZZ9mmGyiUXpTtAyiKbIvqYDRK3Lx9R7LjtoSlCYXKIOR/Zg==
    Po1+5vHph9HkID0oZyuazxgl0gq3U7ap6LfXzc09JRC43XHtrKzoUQJ9Wr1/99iXtbMBCNZbKI2oaBtCV2YZiFYaDjPXSYvB2nnDA/76JjPcf993N8KZjge1VVqFY1YwdktHjA==
    v4Ti6loJ+dGJvZE2pPrMS41EZ6FVHZxo/SW03vld552QAPhmowee4cpOmHxxBjJKeAeuDjN8zNhRQmF5ztLJ6F+A5XWAYgIYUX5qrPN8q9F87IQgjK5G90lfWm4wsOZabb1KgQ==
    jlsHMsfYgeuKsoJt2BL3+C3YPO40i4mi5R5khAyJbJBrbpQ+nlToFcAQ6FQQ7Uk/cK9iU0MIVIOBPWxZRV8YrmKzoYOSV3SBwvN6Uop4V1r5qMwnhUVFJM6Q8ZCqROJMOXhnNg==
    OHDmxKsyEsgX2ZOvznD7hiMFu0UnluhHdGZ+lSM+ca91pHj53ZE1Knf3i/mZIw9/d2TgXO7IOBvks2ra8OaExLn4XxPyHFtGQ/6ckILdfTjzI73+HydkPMDqJwAAAP//AwBQSw==
    AwQUAAYACABaYRhNAPe2Ub4NAAC4gwAAEwAoAGN1c3RvbVhtbC9pdGVtMS54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAxV1rbxy3FeXnAv0PRg==
    vqep9UahKrCcOHHgh2KpTvzJkCVZFqyHsbtyrT/f9pLcER/3zRVQBI60w3PPObzD4XBIzuq//9kNP4Zv4SpchkfhazgLszAPF+EmXId/hu/C4/C38Hf4+QhKrsMJHD+F0utwng==
    Sm/DInwM3wNqCz79GPbCX8Nfwm54FY6B6w9AzwD/BmK/pN8X4c+kdADl8dOjpfI1aGa+Gfz+Dzh2AVoziJnDv4+A/B547qDseFk2hyPXSeUHwBX+OXw+hJ/HUHqaVE7DezhyDA==
    KmdQ+j48h5KvgI4sZ4B+HNahhlvw23dL/4/gv93wK5QeQ3TMSDmey/Yh+jIxnoYj4HofXoQP8HmPLdkFfj6KZl8A5inkZJ5+u0pOXpFqGrJW11l1N7dVHO2iRnDqLUur+jR8gg==
    spPwGZCxtdzBvw8pd8WnjonKFqZeO+blS2pDd+EJnK3T1Mbm8N/jpCuVZ02Zwa63puitqXprLr11RW9d1Vt36W0oehuq3oZLb1PR21T1Nl16W4relqq35dLbVvS2Vb1tl96Oog==
    t6Pq7Sh6++nnZ4g6SfefW/i0WPYZViT2ILGOuan7JV+Ex52tz5ri9yHLx+m+/UnMWI/jHWHGER9arji83ZcvT6/SuOKM9TOV8/qFwaOn5aHH6fq2etf3/1/gzjwj2gaFwfo0kw==
    V5vLg4S1ebHl4+fwEn67IByUEqxXR0nskxfqCqzLsEIbadXgsklhZE1b9n5djiPj6OqcuIr6cqyJGSS959Dqn4C/Xmc6jvlLhIWXy19fzuvY8vYCanqenkxewzPOx+UTSa9Kow==
    sDbH5nfA1V9GWx15c5Of5hbw+So9gy4EXxgruaKYZU83EHkDrfQmPSMvls/J2A+No7xwjJKPA7jHRdQZ2aO0pVizj7Yrce2CRmnKtnZwkFrNIs0MnEH5Dwr+TTq7F+k+MEtnNw==
    Z/RVetr8sHya98fg2tiUVvXK5dwTO+bddn4Owx/Q6z0LR8hhKcH6dZSNncsDRkhqtjq9hT78SMgRvub0COzKorKaSy5n9sgR1/4caxnV8+fLljU39kxo9b5Od5rYj7W6+PikQw==
    RWDeL+CjZayPTFwtqmdpZwKp2S4ZkVU0Fo/qmqq6ZlCl5r0k/Lqqum5QpWa/JPyGqrphUKXmwCT8pqq6aVClZsIk/JaqumVQpebDJPy2qrptUKVmxST8jqq6Y1Cl5sZafB45Lg==
    0ng2zgXM0hV/unyOsGIpJxJz6+mndCf4Arjj+9m9MpaN8c8gKo/6FineGxH9+VV6lzfQn97ej/WnnvEIPn9LY38NkV1oLLLqT8snDqw2lVAqJcrGXnp7DSGpcfeMHp/vvtRRig==
    nbpXUxi+Dv19WY6WlY5SG7oUc4YxlCrF1GvfQmndAurPmbNFSPG1X+o45uN8lXms982qZ8FriKils/Sq39JsbRxNxTmfN0uXT+AqL1eTBZXVLWytg2dpnuuqctgficwY1bL8Ag==
    x26gJPZAL1Kb4J4Frcioamcdc1Nq443wuONy1s/3cS3GhouOrIytj3YvQL7DlPWWJ8A4/V4Y/DHR34iSx2u8Q89Te/d7lmJ177JyW4cy9/ZzwsUeM9477+AeGvs7uTx60Rg8eg==
    xaUNp+vz9b5I8151jp6kfS2xdcr5rV2uzpLr8BBu+hrmXuAyjSNnaQQbV+PuGv8aJrvTmVrt12G2vM7z2KL9HDl7hBRfVOjjmI/zdZCe4D8ve6SjNFMSP+f9U9mJjol6Fiavdg==
    cW3H2rxI+ThvrpL+yMR/LlxLeQ/PNOp6CT8XaV75FNrqWWqrM/DyJZS5dG/E5MKnsprLNicjkSOubTmOc1wfU2vPV+IZcokR2A3F4lPlcsQjLS5sOThKMVeQQ1sr0/DYma6wig==
    Py531ji/Xz6vs+W9ZZ7uNSeAuQ3TrtI8q7pnQmVPFja/gzpfdrTV0Sq5eZdKp7uHB291Vyu0/n5Pz5Pz+3M8r2rCl0VdKbLViFfoVXqSvF66qscpe0p51NIYPHrl2dGG0/W5pw==
    0bJHuR2BTaM1fiQ2Grmb9kqPqnLuD0LeQ972AXJ564RmsOjtp9nBuB9KU8ZI3gPFanFT9oTJ5bwyt6vsEI5Je7n3VETW1Fh8qnXObUiLCz7nn9L9Zrof1ep0SVbjomT2MifHlQ==
    UOzcTB6H4+tAze7pLLKqZVTrj6Gc+cfPfgY+d74x9CrKdB2+3N8FzkNZNThtWhOPqT1JTF5tnC8da/Oi5SO++9Kuc2EvPKb2IDFZtR+Lqo8VPby2zWPXRKU1RQmvZ/PYdVFpXQ==
    UcJr2Dx2Q1TaUJTwujWP3RSVNhUlvFbNY7dEpS1FCa9P89htUWlbUcJr0jx2R1TaUZTwOvRh6hH/TfQGddyeETepWxhpH/ldw8/ifUzH1T40xt7HLfQ7ceSSV8zrHo0uyVpcVA==
    y360XNn63PRw1NHISqN7RqyJj2U2zV1+aqTn//myyC1FahqHacb9BM5H3ll8TNyPR6JoXxY1yvG0OtJ76o8XVRxB8T5NzyS3JDdVVvjpSE1jLqrMFR2+HWbs8zRuyOspMb/tmg==
    nY4pqjITpZ2ft06WUf3cs44p2jITpS3v/rTtKvXvI/Xs4fTtFR3fHfouXWkz064KOzZ68jDTnqiZa76s1tTnvHkkrq88z21holcl2+O5rO778t4KehZzYvDho1+vwqoeSxbG4g==
    /J7pvGPv0iwxlV8d33u1KKzqkc6vPc7vWcov/6Q+1VdD5P1TGotfubi2Ii1OpFw8D/kdp6n/nbzTx/OODzrCyl3cyOW8llSf30Lce5TvbOX3yFWXSHGFHR9reXQfR2m8Vp4Teg==
    bq686PAMVs3+2cSC4vWlJx3KRX0m6mNYQT4zNYrLIn2m6EisQ+18qdu3XM7tnZGvEDmiuLXhdA+W+verOu3IlcqINaL2Z1cZdTqtpfkd40i7c0qVr0Hfh9LHa3W91y2ruOVs4w==
    Y+16r9QuCirXlGJtS1ruPgor/B4WzQ6u9nNeIV6we7wmjts0rzHtuqtzxJdNq89cpEen9q9hZF2pntK6zuRax2grRHz99Sg8X69jbX6kvOS9ZnHvQL23t13b1zF5TktnovTLLg==
    zyl7+Fjmx0jM969wndpFqXN/JHJhFM8U37N/mWo0D/mN6T2hrGanIj06uA48Rta11LP0PHvEsZq/Rlr4cD3oflWKxDry3NTUQiwofaaLb2+WOOusG762feycu4MwvfPaZqU/Xg==
    z7r1EVZuPMtHl/Nanl6c95fx9FtMPIsPz78n5fU5vReYn8lLD87zeCPy2MKr8jBu65HPWOSIe74dcSMSPg92LD1C8WbYziCNnixZHVHC1yUehchzYPO0gnGV+O4MVzE9T8PzeA==
    I6TZIK/b9omDj7bh8DOM1w8+wzyDHUu3Ha83acTCc41EaeMjr/O34Ti1lFz/skuH5/FG5DukV4W6Nm3ouqX1JfK6/RTV7yTwxO4ZcdGllXHUS/suqD/G7lF669TKgfdv4JV2eQ==
    ttn+FqXE/DA83vc6/x91rWfiH5Lv4eour1z43zwdP+9evtF3Yx+yHXgVrO1hlPfhc+Kfz3+bxtt0fr0R/Hy7pLK6U21dQI8ccS7lOo7o4miEf86PvbsFFZ3Z2LgnefuZ8OG5PQ==
    ab5z7WPoZyFGzvOoosX7CxjLvVN6rZEo2rdF7WFcS3m3R4/WQj8HZR+g3r4tWGqH4Ui7tkT3ufXE+Hza82hvx/YI7HWV9mvn4PI70m5HVH1zy3r79cZp880j7drLZJsp97T3cQ==
    B9qMt34GdCSeBR/Jsh7Lzcp7MulR6Z9krVcutUtaqn+ZEZHiLKjo0sY25qLkxoO2upJaLTevKdXRHyPNoPqySbOsDTmWo3jPmpo2km/36fcj+LYUj9z7aOtomPfrw/OjX09GqA==
    urR//0tDcO898H9FzHLv0bLkjdPvNbas0bXlsHFH+vT32crbRHPxjLRnU2fw4fu9xhYF2eOzFHuV7jdxre/U7XqEoa/HmAt7P6xzjUZKffJIDZ6F/B3a+/Dz0pgHf0x0PaLE+w==
    jes+ube4vL9f2p2PRNd1GFPvewZvxHQ8f3+vNHuWEU+Br7SP8n0qFlQ9KyazcetNlEvqu6umDMSo+BbrDP5f9l7QuzBrjsN0Hr6G6ftY8l8KwX8Bwx77Hs7vLODvgJLReT+Dhw==
    fTV35QyMRHnd0udbd132AFty2qM1l5h9NXe2nHJRXrf8NbTaVZK/zzN+T6U2qqJw5bt0pNJ8pUvRNrW3qc+7ZfVKOadYM+C+SMtDHHVdQC4/GbJFI0uN5fLc48sMVs26zhqC1w==
    lTJnyUo+o3kENRN7iP30vFt/+3t/JGpiFPVcHr9Reb68DgqSPp6ftekIzP1L2jdydn+VFSxXEvn5KKovugqL+5W+urehjueegI6gWrp8JnabMQa9b3sqp97fjKuV8Wd+ntlzoQ==
    2+9HsLCv5q5kYCTK61Y64zTPFI+/gdGH553yCpJH7l1dKp8atvWmM0u+uNpQvjRs60tn1nzZdnb0Dm1R2KtVTXL9KvUVnDtc2rqgoiW1dizTu34N/8dt3xrTOrMrSX7zd82Uzw==
    e0JZq48jPTovU/uLM0TyeZb8WDlk33YnUv2oa5O+Bm3XGp693BNLWw0q2qeW1/1kzYzRlCcmnz6VTx6lefDkvF35xPptOaXcM/SjF3pkEkvw6DPPrR9Du8x7KU+b56M/oY65Jw==
    mKXa/Q9QSwMEFAAGAAgAAAAhAFtt/ZMJAQAA8QEAAB0AAAB3b3JkL2dsb3NzYXJ5L3dlYlNldHRpbmdzLnhtbJTRwUoDMRAG4LvgOyy5t9kWFVm6LYhUvIigPkCazrbBTCbMpA==
    rvXpHWutSC/1lkkyHzP8k9k7xuoNWAKl1oyGtakgeVqGtGrNy/N8cG0qKS4tXaQErdmCmNn0/GzSNz0snqAU/SmVKkka9K1Zl5Iba8WvAZ0MKUPSx44YXdGSVxYdv27ywBNmVw==
    wiLEULZ2XNdXZs/wKQp1XfBwS36DkMqu3zJEFSnJOmT50fpTtJ54mZk8iOg+GL89dCEdmNHFEYTBMwl1ZajL7CfaUdo+qncnjL/A5f+A8QFA39yvErFbRI1AJ6kUM1PNgHIJGA==
    PmBOfMPUC7D9unYxUv/4cKeF/RPU9BMAAP//AwBQSwMEFAAGAAgAAAAhABmPyz/EAQAA7QQAABsAAAB3b3JkL2dsb3NzYXJ5L2ZvbnRUYWJsZS54bWy8ktuK2zAQhu8LfQeh+w==
    jWUn2YNZZ9mmGyiUXpTtAyiKbIvqYDRK3Lx9R7LjtoSlCYXKIOR/Zj6Nfubx6YfR5CA9KGcrms8YJdIKt1O2qei3183NPSUQuN1x7ays6FECfVq9f/fYl7WzAQjWWyiNqGgbQg==
    V2YZiFYaDjPXSYvB2nnDA/76JjPcf993N8KZjge1VVqFY1YwdktHjL+E4upaCfnRib2RNqT6zEuNRGehVR2caP0ltN75XeedkAD4ZqMHnuHKTph8cQYySngHrg4zfMzYUUJheQ==
    ztLJ6F+A5XWAYgIYUX5qrPN8q9F87IQgjK5G90lfWm4wsOZabb1KgY5bBzLH2IHrirKCbdgS9/gt2DzuNIuJouUeZIQMiWyQa26UPp5U6BXAEOhUEO1JP3CvYlNDCFSDgT1sWQ==
    RV8YrmKzoYOSV3SBwvN6Uop4V1r5qMwnhUVFJM6Q8ZCqROJMOXhnNjhw5sSrMhLIF9mTr85w+4YjBbtFJ5boR3RmfpUjPnGvdaR4+d2RNSp394v5mSMPf3dk4FzuyDgb5LNq2g==
    8OaExLn4XxPyHFtGQ/6ckILdfTjzI73+HydkPMDqJwAAAP//AwBQSwMEFAAGAAgAWWEYTR6tLxzqAQAAYQQAABAACAFkb2NQcm9wcy9hcHAueG1sIKIEASigAAEAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnVTBbhoxEP2Vle9hgTZVhcBRlRx6aJVI0OQ88c6C1V3bsgcE/bUe+kn9hY7tZWOKeimnmQ==
    N8/PbzzD/v75a3l37LvqgD5oa1ZiNpmKCo2yjTbbldhTe/NRVIHANNBZgytxwiDu5BLc4slbh540hoo1TFgcaCV2RG5R10HtsIcwYYbhYmt9D8Sp39a2bbXCB6v2PRqq59Pphw==
    urEqqoXnzcmx/qAH7n/18EhoGmxu3OhRJM8b7F0HhHKtOdCtxqZaQ8ctnAUmjaXjsi656aAl6Da6RznNxTFPTwFbDEMlxxF9sb4Jcj6/TXjOIn6/Aw+K+M2HIwUQ658cW1NAPA==
    EflVK2+Dbal6TH1WUSYdKlnxFDewRrX3mk6DbIlExhdtRpc5zt49bD24XZDvhgZGINbXit/nnt9RttAFTJQ3LDI+I8R1eQIdGzjQ4oCKrK9eIWAc6EocwGswxJukf3A6F5mW0Q==
    FHcukJcbTR3fMOYpLGllrN/LWSJwcEmsRw8y2b00GKcX7wmPLbdK/7CcDJwNz0Rh8spfcdNfwnG2tndgTrk8JnkC38M3t7EPccfe3vYSv9yXF027tQOF15tTlNLUuIANb0A5tQ==
    EUtT4zZ9Fy9jEbPFpmBe14a9fM4fCjm7nUz5d17EM5z3Z/zPyT9QSwECLQAUAAYACAAAACEA3q1tr+YBAABhDAAAEwAAAAAAAAAAAAAAAAAAAAAAW0NvbnRlbnRfVHlwZXNdLg==
    eG1sUEsBAi0AFAAGAAgAAAAhAB6RGrfvAAAATgIAAAsAAAAAAAAAAAAAAAAAHwQAAF9yZWxzLy5yZWxzUEsBAi0AFAAGAAgAAAAhAAW4h3p0AQAAcwgAABwAAAAAAAAAAAAAAA==
    AAA/BwAAd29yZC9fcmVscy9kb2N1bWVudC54bWwucmVsc1BLAQItABQABgAIAFphGE0198+9OhwAAAliAQARAAAAAAAAAAAAAAAAAPUJAAB3b3JkL2RvY3VtZW50LnhtbFBLAQ==
    Ai0AFAAGAAgAWWEYTY3VJCdEBwAAaiMAABAAAAAAAAAAAAAAAAAAXiYAAHdvcmQvaGVhZGVyMi54bWxQSwECLQAUAAYACABZYRhNz75ubWAEAADsEAAAEAAAAAAAAAAAAAAAAA==
    ANAtAAB3b3JkL2Zvb3RlcjEueG1sUEsBAi0AFAAGAAgAWWEYTQ1d1xaDBQAArBwAABAAAAAAAAAAAAAAAAAAXjIAAHdvcmQvaGVhZGVyMS54bWxQSwECLQAUAAYACABZYRhNYg==
    EpLlbggAAF1GAAAQAAAAAAAAAAAAAAAAAA84AAB3b3JkL2Zvb3RlcjIueG1sUEsBAi0AFAAGAAgAWWEYTdkUaC7MAQAAUgYAABEAAAAAAAAAAAAAAAAAq0AAAHdvcmQvZW5kbg==
    b3Rlcy54bWxQSwECLQAUAAYACAAAACEA72fs8LkAAAAhAQAAGwAAAAAAAAAAAAAAAACmQgAAd29yZC9fcmVscy9oZWFkZXIyLnhtbC5yZWxzUEsBAi0AFAAGAAgAWWEYTbA7DA==
    OM0BAABYBgAAEgAAAAAAAAAAAAAAAACYQwAAd29yZC9mb290bm90ZXMueG1sUEsBAi0AFAAGAAgAAAAhAKpSJd8jBgAAixoAABUAAAAAAAAAAAAAAAAAlUUAAHdvcmQvdGhlbQ==
    ZS90aGVtZTEueG1sUEsBAi0ACgAAAAAAAAAhADJSfrUKAAAACgAAABUAAAAAAAAAAAAAAAAA60sAAHdvcmQvbWVkaWEvaW1hZ2UyLmJpblBLAQItAAoAAAAAAAAAIQD9Z/nRJA==
    AQAAJAEAABUAAAAAAAAAAAAAAAAAKEwAAHdvcmQvbWVkaWEvaW1hZ2UxLnBuZ1BLAQItABQABgAIAAAAIQDSdzsz9QAAAHUBAAAcAAAAAAAAAAAAAAAAAH9NAAB3b3JkL19yZQ==
    bHMvc2V0dGluZ3MueG1sLnJlbHNQSwECLQAUAAYACAAAACEAFa3CsNkQAADepQAAGgAAAAAAAAAAAAAAAACuTgAAd29yZC9nbG9zc2FyeS9kb2N1bWVudC54bWxQSwECLQAUAA==
    BgAIAAAAIQBb+Ujo8gMAAMALAAAaAAAAAAAAAAAAAAAAAL9fAAB3b3JkL2dsb3NzYXJ5L3NldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQCD0LXl5gAAAK0CAAAlAAAAAAAAAA==
    AAAAAAAA6WMAAHdvcmQvZ2xvc3NhcnkvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHNQSwECLQAUAAYACAAAACEAl/rsKE0JAAB9JAAAEQAAAAAAAAAAAAAAAAASZQAAd29yZC9zZQ==
    dHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQAK6Qi24QAAAFUBAAAYAAAAAAAAAAAAAAAAAI5uAABjdXN0b21YbWwvaXRlbVByb3BzMi54bWxQSwECLQAUAAYACAAAACEA2k/RAA==
    /QAAAFIBAAAYAAAAAAAAAAAAAAAAAM1vAABjdXN0b21YbWwvaXRlbVByb3BzMS54bWxQSwECLQAUAAYACAAAACEAUDpnScsAAAA2AQAAEwAAAAAAAAAAAAAAAAAocQAAY3VzdA==
    b21YbWwvaXRlbTIueG1sUEsBAi0AFAAGAAgAAAAhAFyWJyLCAAAAKAEAAB4AAAAAAAAAAAAAAAAATHIAAGN1c3RvbVhtbC9fcmVscy9pdGVtMi54bWwucmVsc1BLAQItABQABg==
    AAgAAAAhAHQ/OXrCAAAAKAEAAB4AAAAAAAAAAAAAAAAAUnQAAGN1c3RvbVhtbC9fcmVscy9pdGVtMS54bWwucmVsc1BLAQItABQABgAIAAAAIQDxbzhH4hUAAKuvAAAYAAAAAA==
    AAAAAAAAAAAAWHYAAHdvcmQvZ2xvc3Nhcnkvc3R5bGVzLnhtbFBLAQItABQABgAIAFlhGE0QV9GlOQEAAEgCAAARAAAAAAAAAAAAAAAAAHCMAABkb2NQcm9wcy9jb3JlLnhtbA==
    UEsBAi0AFAAGAAgAAAAhAK3AhNFkDwAAl5IAAA8AAAAAAAAAAAAAAAAA4I4AAHdvcmQvc3R5bGVzLnhtbFBLAQItABQABgAIAAAAIQDuVqAlgwEAAJ4DAAAUAAAAAAAAAAAAAA==
    AAAAcZ4AAHdvcmQvd2ViU2V0dGluZ3MueG1sUEsBAi0AFAAGAAgAAAAhABmPyz/EAQAA7QQAABIAAAAAAAAAAAAAAAAAJqAAAHdvcmQvZm9udFRhYmxlLnhtbFBLAQItABQABg==
    AAgAWmEYTQD3tlG+DQAAuIMAABMAAAAAAAAAAAAAAAAAGqIAAGN1c3RvbVhtbC9pdGVtMS54bWxQSwECLQAUAAYACAAAACEAW239kwkBAADxAQAAHQAAAAAAAAAAAAAAAAAxsA==
    AAB3b3JkL2dsb3NzYXJ5L3dlYlNldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQAZj8s/xAEAAO0EAAAbAAAAAAAAAAAAAAAAAHWxAAB3b3JkL2dsb3NzYXJ5L2ZvbnRUYWJsZQ==
    LnhtbFBLAQItABQABgAIAFlhGE0erS8c6gEAAGEEAAAQAAAAAAAAAAAAAAAAAHKzAABkb2NQcm9wcy9hcHAueG1sUEsFBgAAAAAhACEAtAgAAJK2AAAAAA==
    END_OF_WORDLAYOUT
  }
}

