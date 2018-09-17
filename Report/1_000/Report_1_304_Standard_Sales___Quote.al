OBJECT Report 1304 Standard Sales - Quote
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salg - tilbud;
               ENU=Sales - Quote];
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
               DataItemTable=Table36;
               DataItemTableView=SORTING(Document Type,No.)
                                 WHERE(Document Type=CONST(Quote));
               ReqFilterHeadingML=[DAN=Salgstilbud;
                                   ENU=Sales Quote];
               OnPreDataItem=BEGIN
                               FirstLineHasBeenOutput := FALSE;
                             END;

               OnAfterGetRecord=VAR
                                  CurrencyExchangeRate@1000 : Record 330;
                                  ArchiveManagement@1001 : Codeunit 5063;
                                  SalesPost@1002 : Codeunit 80;
                                BEGIN
                                  FirstLineHasBeenOutput := FALSE;
                                  CLEAR(Line);
                                  CLEAR(SalesPost);
                                  VATAmountLine.DELETEALL;
                                  Line.DELETEALL;
                                  SalesPost.GetSalesLines(Header,Line,0);
                                  Line.CalcVATAmountLines(0,Header,Line,VATAmountLine);
                                  Line.UpdateVATOnLines(0,Header,Line,VATAmountLine);

                                  IF NOT IsReportInPreviewMode THEN
                                    CODEUNIT.RUN(CODEUNIT::"Sales-Printed",Header);
                                  IF "Language Code" = '' THEN
                                    IF IdentityManagement.IsInvAppId THEN
                                      "Language Code" := Language.GetUserLanguage;

                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  CALCFIELDS("Work Description");
                                  ShowWorkDescription := "Work Description".HASVALUE;

                                  FormatAddr.GetCompanyAddr("Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
                                  FormatAddr.SalesHeaderBillTo(CustAddr,Header);
                                  ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr,CustAddr,Header);

                                  TotalSubTotal := 0;
                                  TotalInvDiscAmount := 0;
                                  TotalAmount := 0;
                                  TotalAmountVAT := 0;
                                  TotalAmountInclVAT := 0;

                                  IF NOT Cust.GET("Bill-to Customer No.") THEN
                                    CLEAR(Cust);

                                  IF "Currency Code" <> '' THEN BEGIN
                                    CurrencyExchangeRate.FindCurrency("Posting Date","Currency Code",1);
                                    CalculatedExchRate :=
                                      ROUND(1 / "Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount",0.000001);
                                    ExchangeRateText := STRSUBSTNO(ExchangeRateTxt,CalculatedExchRate,CurrencyExchangeRate."Exchange Rate Amount");
                                  END;

                                  FormatDocumentFields(Header);

                                  IF NOT IsReportInPreviewMode AND
                                     (CurrReport.USEREQUESTPAGE AND ArchiveDocument OR
                                      NOT CurrReport.USEREQUESTPAGE AND SalesSetup."Archive Quotes and Orders")
                                  THEN
                                    ArchiveManagement.StoreSalesDocument(Header,LogInteraction);

                                  IF LogInteraction AND NOT IsReportInPreviewMode THEN BEGIN
                                    CALCFIELDS("No. of Archived Versions");
                                    IF "Bill-to Contact No." <> '' THEN
                                      SegManagement.LogDocument(
                                        1,"No.","Doc. No. Occurrence",
                                        "No. of Archived Versions",DATABASE::Contact,"Bill-to Contact No.",
                                        "Salesperson Code","Campaign No.","Posting Description","Opportunity No.")
                                    ELSE
                                      SegManagement.LogDocument(
                                        1,"No.","Doc. No. Occurrence",
                                        "No. of Archived Versions",DATABASE::Customer,"Bill-to Customer No.",
                                        "Salesperson Code","Campaign No.","Posting Description","Opportunity No.");
                                  END;
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

    { 151 ;1   ;Column  ;CompanyAddress7     ;
               SourceExpr=CompanyAddr[7] }

    { 154 ;1   ;Column  ;CompanyAddress8     ;
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

    { 112 ;1   ;Column  ;YourReference__Lbl  ;
               SourceExpr=FIELDCAPTION("Your Reference") }

    { 40  ;1   ;Column  ;ShipmentMethodDescription;
               SourceExpr=ShipmentMethod.Description }

    { 105 ;1   ;Column  ;ShipmentMethodDescription_Lbl;
               SourceExpr=ShptMethodDescLbl }

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

    { 146 ;1   ;Column  ;QuoteValidToDate    ;
               SourceExpr=FORMAT("Quote Valid Until Date",0,4) }

    { 144 ;1   ;Column  ;QuoteValidToDate_Lbl;
               SourceExpr=QuoteValidToDateLbl }

    { 50  ;1   ;Column  ;DocumentNo          ;
               SourceExpr="No." }

    { 111 ;1   ;Column  ;DocumentNo_Lbl      ;
               SourceExpr=InvNoLbl }

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

    { 184 ;1   ;Column  ;LegalEntityType     ;
               SourceExpr=Cust.GetLegalEntityType }

    { 185 ;1   ;Column  ;LegalEntityType_Lbl ;
               SourceExpr=Cust.GetLegalEntityTypeLbl }

    { 31  ;1   ;Column  ;Copy_Lbl            ;
               SourceExpr=CopyLbl }

    { 36  ;1   ;Column  ;EMail_Lbl           ;
               SourceExpr=EMailLbl }

    { 131 ;1   ;Column  ;Estimate_Lbl        ;
               SourceExpr=EstimateLbl }

    { 150 ;1   ;Column  ;YourEstimate_Lbl    ;
               SourceExpr=YourEstimateLbl }

    { 132 ;1   ;Column  ;EstimateBody_Lbl    ;
               SourceExpr=EstimateBodyLbl }

    { 155 ;1   ;Column  ;From_Lbl            ;
               SourceExpr=FromLbl }

    { 156 ;1   ;Column  ;EstimateFor_Lbl     ;
               SourceExpr=EstimateForLbl }

    { 157 ;1   ;Column  ;Questions_Lbl       ;
               SourceExpr=QuestionsLbl }

    { 158 ;1   ;Column  ;Contact_Lbl         ;
               SourceExpr=CompanyInfo.GetContactUsText }

    { 159 ;1   ;Column  ;Thanks_Lbl          ;
               SourceExpr=ThanksLbl }

    { 43  ;1   ;Column  ;HomePage_Lbl        ;
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

    { 102 ;1   ;Column  ;DocumentTitle_Lbl   ;
               SourceExpr=SalesConfirmationLbl }

    { 61  ;1   ;Column  ;ShowWorkDescription ;
               SourceExpr=ShowWorkDescription }

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

    { 1570;1   ;DataItem;Line                ;
               DataItemTable=Table37;
               DataItemTableView=SORTING(Document No.,Line No.);
               OnPreDataItem=BEGIN
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

               OnAfterGetRecord=BEGIN
                                  IF Type = Type::"G/L Account" THEN
                                    "No." := '';

                                  IF "Line Discount %" = 0 THEN
                                    LineDiscountPctText := ''
                                  ELSE
                                    LineDiscountPctText := STRSUBSTNO('%1%',-ROUND("Line Discount %",0.1));

                                  TransHeaderAmount += PrevLineAmount;
                                  PrevLineAmount := "Line Amount";
                                  TotalSubTotal += "Line Amount";
                                  TotalInvDiscAmount -= "Inv. Discount Amount";
                                  TotalAmount += Amount;
                                  TotalAmountVAT += "Amount Including VAT" - Amount;
                                  TotalAmountInclVAT += "Amount Including VAT";
                                  TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");

                                  FormatDocument.SetSalesLine(Line,FormattedQuantity,FormattedUnitPrice,FormattedVATPct,FormattedLineAmount);

                                  IF FirstLineHasBeenOutput THEN
                                    CLEAR(CompanyInfo.Picture);
                                  FirstLineHasBeenOutput := TRUE;
                                END;

               DataItemLinkReference=Header;
               DataItemLink=Document No.=FIELD(No.);
               Temporary=Yes }

    { 85  ;2   ;Column  ;LineNo_Line         ;
               SourceExpr="Line No." }

    { 58  ;2   ;Column  ;AmountExcludingVAT_Line;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 123 ;2   ;Column  ;AmountExcludingVAT_Line_Lbl;
               SourceExpr=FIELDCAPTION(Amount) }

    { 41  ;2   ;Column  ;AmountIncludingVAT_Line;
               SourceExpr="Amount Including VAT";
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 97  ;2   ;Column  ;AmountIncludingVAT_Line_Lbl;
               SourceExpr=FIELDCAPTION("Amount Including VAT");
               AutoFormatType=1;
               AutoFormatExpr=Header."Currency Code" }

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
               AutoFormatExpr="Currency Code" }

    { 125 ;2   ;Column  ;LineAmount_Line_Lbl ;
               SourceExpr=FIELDCAPTION("Line Amount") }

    { 64  ;2   ;Column  ;ItemNo_Line         ;
               SourceExpr="No." }

    { 126 ;2   ;Column  ;ItemNo_Line_Lbl     ;
               SourceExpr=FIELDCAPTION("No.") }

    { 167 ;2   ;Column  ;ShipmentDate_Line   ;
               SourceExpr=FORMAT("Shipment Date") }

    { 69  ;2   ;Column  ;ShipmentDate_Lbl    ;
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
               AutoFormatExpr="Currency Code" }

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
               AutoFormatExpr="Currency Code" }

    { 300 ;2   ;Column  ;Unit_Lbl            ;
               SourceExpr=UnitLbl }

    { 235 ;2   ;Column  ;Qty_Lbl             ;
               SourceExpr=QtyLbl }

    { 236 ;2   ;Column  ;Price_Lbl           ;
               SourceExpr=PriceLbl }

    { 237 ;2   ;Column  ;PricePer_Lbl        ;
               SourceExpr=PricePerLbl }

    { 32  ;1   ;DataItem;WorkDescriptionLines;
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

    { 60  ;2   ;Column  ;WorkDescriptionLineNumber;
               SourceExpr=Number }

    { 46  ;2   ;Column  ;WorkDescriptionLine ;
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
               AutoFormatExpr=Header."Currency Code" }

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
                                 WHERE(Number=CONST(1)) }

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

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnInit=BEGIN
               LogInteractionEnable := TRUE;
               ArchiveDocument := SalesSetup."Archive Quotes and Orders";
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

      { 1   ;2   ;Field     ;
                  Name=ArchiveDocument;
                  CaptionML=[DAN=Arkiver dokument;
                             ENU=Archive Document];
                  ToolTipML=[DAN=Angiver, om bilaget arkiveres, efter du har udskrevet det.;
                             ENU=Specifies if the document is archived after you print it.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ArchiveDocument;
                  OnValidate=BEGIN
                               IF NOT ArchiveDocument THEN
                                 LogInteraction := FALSE;
                             END;
                              }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      SalesConfirmationLbl@1004 : TextConst 'DAN=Salgstilbud;ENU=Sales Quote';
      YourEstimateLbl@1097 : TextConst 'DAN=Dit estimat;ENU=Your Estimate';
      EstimateLbl@1060 : TextConst 'DAN=Estimat;ENU=Estimate';
      SalespersonLbl@1003 : TextConst 'DAN=S‘lger;ENU=Sales person';
      CompanyInfoBankAccNoLbl@1045 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      CompanyInfoBankNameLbl@1046 : TextConst 'DAN=Bank;ENU=Bank';
      CompanyInfoGiroNoLbl@1049 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      CompanyInfoPhoneNoLbl@1050 : TextConst 'DAN=Telefon;ENU=Phone No.';
      CopyLbl@1059 : TextConst 'DAN=Kopi‚r;ENU=Copy';
      EMailLbl@1068 : TextConst 'DAN=Mail;ENU=Email';
      HomePageLbl@1070 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      InvDiscBaseAmtLbl@1071 : TextConst 'DAN=Grundbel›b for fakturarabat;ENU=Invoice Discount Base Amount';
      InvDiscountAmtLbl@1072 : TextConst 'DAN=Fakturarabat;ENU=Invoice Discount';
      InvNoLbl@1073 : TextConst 'DAN=Nr.;ENU=No.';
      LineAmtAfterInvDiscLbl@1074 : TextConst 'DAN=Moms ved kontantrabat;ENU=Payment Discount on VAT';
      LocalCurrencyLbl@1076 : TextConst 'DAN=Lokal valuta;ENU=Local Currency';
      PageLbl@1077 : TextConst 'DAN=Side;ENU=Page';
      PaymentTermsDescLbl@1078 : TextConst 'DAN=Betalingsbetingelser;ENU=Payment Terms';
      PaymentMethodDescLbl@1040 : TextConst 'DAN=Betalingsform;ENU=Payment Method';
      PostedShipmentDateLbl@1079 : TextConst 'DAN=Afsendelsesdato;ENU=Shipment Date';
      SalesInvLineDiscLbl@1081 : TextConst 'DAN=Rabatpct.;ENU=Discount %';
      ShipmentLbl@1084 : TextConst 'DAN=Leverance;ENU=Shipment';
      ShiptoAddrLbl@1085 : TextConst 'DAN=Leveringsadresse;ENU=Ship-to Address';
      ShptMethodDescLbl@1086 : TextConst 'DAN=Leveringsform;ENU=Shipment Method';
      SubtotalLbl@1087 : TextConst 'DAN=Subtotal;ENU=Subtotal';
      TotalLbl@1088 : TextConst 'DAN=Total;ENU=Total';
      UnitLbl@1066 : TextConst 'DAN=Enhed;ENU=Unit';
      VATAmtSpecificationLbl@1037 : TextConst 'DAN=Momsbel›bspecifikation;ENU=VAT Amount Specification';
      VATAmtLbl@1091 : TextConst 'DAN=Momsbel›b;ENU=VAT Amount';
      VATAmountLCYLbl@1027 : TextConst 'DAN=Momsbel›b (RV);ENU=VAT Amount (LCY)';
      VATBaseLbl@1093 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATBaseLCYLbl@1032 : TextConst 'DAN=Momsgrundlag (RV);ENU=VAT Base (LCY)';
      VATClausesLbl@1094 : TextConst 'DAN=Momsklausul;ENU=VAT Clause';
      VATIdentifierLbl@1095 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      VATPercentageLbl@1096 : TextConst 'DAN=Momspct.;ENU=VAT %';
      TempBlobWorkDescription@1002 : Record 99008535;
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
      FormatAddr@1019 : Codeunit 365;
      FormatDocument@1058 : Codeunit 368;
      SegManagement@1020 : Codeunit 5051;
      IdentityManagement@1036 : Codeunit 9801;
      WorkDescriptionLine@1001 : Text;
      CustAddr@1021 : ARRAY [8] OF Text[50];
      ShipToAddr@1022 : ARRAY [8] OF Text[50];
      CompanyAddr@1023 : ARRAY [8] OF Text[50];
      SalesPersonText@1025 : Text[30];
      TotalText@1028 : Text[50];
      TotalExclVATText@1029 : Text[50];
      TotalInclVATText@1030 : Text[50];
      LineDiscountPctText@1005 : Text;
      FormattedVATPct@1082 : Text;
      FormattedUnitPrice@1080 : Text;
      FormattedQuantity@1075 : Text;
      FormattedLineAmount@1100 : Text;
      MoreLines@1031 : Boolean;
      ShowWorkDescription@1006 : Boolean;
      CopyText@1034 : Text[30];
      ShowShippingAddr@1035 : Boolean;
      ArchiveDocument@1042 : Boolean;
      LogInteraction@1041 : Boolean;
      TotalSubTotal@1061 : Decimal;
      TotalAmount@1062 : Decimal;
      TotalAmountInclVAT@1064 : Decimal;
      TotalAmountVAT@1065 : Decimal;
      TotalInvDiscAmount@1063 : Decimal;
      TotalPaymentDiscOnVAT@1053 : Decimal;
      TransHeaderAmount@1039 : Decimal;
      LogInteractionEnable@19003940 : Boolean INDATASET;
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
      NoFilterSetErr@1043 : TextConst 'DAN=Du skal angive et eller flere filtre for at undg† at udskrive alle dokumenter ved et uheld.;ENU=You must specify one or more filters to avoid accidently printing all documents.';
      PmtDiscText@1051 : Text;
      FromLbl@1103 : TextConst 'DAN=Fra;ENU=From';
      EstimateForLbl@1102 : TextConst 'DAN=Estimat for;ENU=Estimate for';
      QuestionsLbl@1099 : TextConst 'DAN=Sp›rgsm†l?;ENU=Questions?';
      ThanksLbl@1098 : TextConst 'DAN=Tak!;ENU=Thank You!';
      GreetingLbl@1057 : TextConst 'DAN=Hej;ENU=Hello';
      ClosingLbl@1056 : TextConst 'DAN=Med venlig hilsen;ENU=Sincerely';
      PmtDiscTxt@1055 : TextConst '@@@="%1 = Discount Due Date %2 = value of Payment Discount % ";DAN=Hvis vi modtager betalingen f›r %1, er du berettiget til en betalingsrabat p† 2 %.;ENU=If we receive the payment before %1, you are eligible for a 2% payment discount.';
      BodyLbl@1054 : TextConst 'DAN=Tak for din interesse i vores varer. Dit tilbud er vedh‘ftet denne meddelelse.;ENU=Thank you for your business. Your quote is attached to this message.';
      EstimateBodyLbl@1067 : TextConst 'DAN=Her har du som lovet vores estimat. Detaljerne kan ses i det vedh‘ftede estimat.;ENU=As promised, here''s our estimate. Please see the attached estimate for details.';
      QuoteValidToDateLbl@1069 : TextConst 'DAN=Gyldig indtil;ENU=Valid until';
      QtyLbl@1092 : TextConst '@@@=Short form of Quantity;DAN=Antal;ENU=Qty';
      PriceLbl@1090 : TextConst 'DAN=Pris;ENU=Price';
      PricePerLbl@1083 : TextConst 'DAN=Pris pr.;ENU=Price per';

    LOCAL PROCEDURE InitLogInteraction@1();
    BEGIN
      LogInteraction := SegManagement.FindInteractTmplCode(1) <> '';
    END;

    LOCAL PROCEDURE DocumentCaption@4() : Text[250];
    BEGIN
      EXIT(SalesConfirmationLbl);
    END;

    PROCEDURE InitializeRequest@5(NewLogInteraction@1002 : Boolean);
    BEGIN
      LogInteraction := NewLogInteraction;
    END;

    LOCAL PROCEDURE IsReportInPreviewMode@3() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    LOCAL PROCEDURE FormatDocumentFields@2(SalesHeader@1000 : Record 36);
    BEGIN
      WITH SalesHeader DO BEGIN
        FormatDocument.SetTotalLabels(GetCurrencySymbol,TotalText,TotalInclVATText,TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser,"Salesperson Code",SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod,"Payment Method Code","Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");
      END;
    END;

    LOCAL PROCEDURE CreateReportTotalLines@15();
    BEGIN
      ReportTotalsLine.DELETEALL;
      IF (TotalInvDiscAmount <> 0) OR (TotalAmountVAT <> 0) THEN
        ReportTotalsLine.Add(SubtotalLbl,TotalSubTotal,TRUE,FALSE,FALSE);
      IF TotalInvDiscAmount <> 0 THEN BEGIN
        ReportTotalsLine.Add(InvDiscountAmtLbl,TotalInvDiscAmount,FALSE,FALSE,FALSE);
        IF TotalAmountVAT <> 0 THEN
          ReportTotalsLine.Add(TotalExclVATText,TotalAmount,TRUE,FALSE,FALSE);
      END;
      IF TotalAmountVAT <> 0 THEN
        ReportTotalsLine.Add(VATAmountLine.VATAmountText,TotalAmountVAT,FALSE,TRUE,FALSE);
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
        <Field Name="YourReference__Lbl">
          <DataField>YourReference__Lbl</DataField>
        </Field>
        <Field Name="ShipmentMethodDescription">
          <DataField>ShipmentMethodDescription</DataField>
        </Field>
        <Field Name="ShipmentMethodDescription_Lbl">
          <DataField>ShipmentMethodDescription_Lbl</DataField>
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
        <Field Name="LegalEntityType">
          <DataField>LegalEntityType</DataField>
        </Field>
        <Field Name="LegalEntityType_Lbl">
          <DataField>LegalEntityType_Lbl</DataField>
        </Field>
        <Field Name="Copy_Lbl">
          <DataField>Copy_Lbl</DataField>
        </Field>
        <Field Name="EMail_Lbl">
          <DataField>EMail_Lbl</DataField>
        </Field>
        <Field Name="HomePage_Lbl">
          <DataField>HomePage_Lbl</DataField>
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
        <Field Name="ShipmentDate_Lbl">
          <DataField>ShipmentDate_Lbl</DataField>
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
                  <Width>18.5994cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>21.59908cm</Height>
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
                                    <Width>3.82609cm</Width>
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
                                          <Textbox Name="YourReference__Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!YourReference__Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>YourReference__Lbl</rd:DefaultName>
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
                                          <Textbox Name="YourReference">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!YourReference.Value</Value>
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
                                            <rd:DefaultName>YourReference</rd:DefaultName>
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
                                          <Textbox Name="Textbox10">
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
                                            <rd:DefaultName>Textbox10</rd:DefaultName>
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
                                          <Textbox Name="EMail_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!EMail_Lbl.Value</Value>
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
                                            <rd:DefaultName>EMail_Lbl</rd:DefaultName>
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
                                          <Textbox Name="CompanyEMail">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyEMail.Value</Value>
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
                                            <rd:DefaultName>CompanyEMail</rd:DefaultName>
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
                                          <Textbox Name="BilltoCustomerNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BilltoCustomerNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>BilltoCustomerNo_Lbl</rd:DefaultName>
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
                                          <Textbox Name="BilltoCustumerNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BilltoCustumerNo.Value</Value>
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
                                            <rd:DefaultName>BilltoCustumerNo</rd:DefaultName>
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
                                          <Textbox Name="Textbox11">
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
                                            <rd:DefaultName>Textbox11</rd:DefaultName>
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
                                          <Textbox Name="HomePage_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!HomePage_Lbl.Value</Value>
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
                                            <rd:DefaultName>HomePage_Lbl</rd:DefaultName>
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
                                          <Textbox Name="CompanyHomePage">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyHomePage.Value</Value>
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
                                            <rd:DefaultName>CompanyHomePage</rd:DefaultName>
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
                                          <Textbox Name="VATRegistrationNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATRegistrationNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATRegistrationNo_Lbl</rd:DefaultName>
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
                                          <Textbox Name="VATRegistrationNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATRegistrationNo.Value</Value>
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
                                            <rd:DefaultName>VATRegistrationNo</rd:DefaultName>
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
                                          <Textbox Name="Textbox12">
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
                                          <Textbox Name="CompanyPhoneNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyPhoneNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyPhoneNo_Lbl</rd:DefaultName>
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
                                          <Textbox Name="CompanyPhoneNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyPhoneNo.Value</Value>
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
                                            <rd:DefaultName>CompanyPhoneNo</rd:DefaultName>
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
                                          <Textbox Name="GlobalLocationNumber_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GlobalLocationNumber_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>GlobalLocationNumber_Lbl</rd:DefaultName>
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
                                          <Textbox Name="GlobalLocationNumber">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GlobalLocationNumber.Value</Value>
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
                                            <rd:DefaultName>GlobalLocationNumber</rd:DefaultName>
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
                                          <Textbox Name="Textbox13">
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
                                          <Textbox Name="CompanyRegistrationNumber_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyRegistrationNumber_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyRegistrationNumber_Lbl</rd:DefaultName>
                                            <Visibility>
                                              <Hidden>=Fields!CompanyVATRegistrationNo.Value=""</Hidden>
                                            </Visibility>
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
                                          <Textbox Name="CompanyRegistrationNumber">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyRegistrationNumber.Value</Value>
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
                                            <rd:DefaultName>CompanyRegistrationNumber</rd:DefaultName>
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
                                          <Textbox Name="DocumentNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocumentNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>DocumentNo_Lbl</rd:DefaultName>
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
                                          <Textbox Name="DocumentNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocumentNo.Value</Value>
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
                                            <rd:DefaultName>DocumentNo</rd:DefaultName>
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox14</rd:DefaultName>
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
                                          <Textbox Name="CompanyBankName">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyBankName.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyBankName</rd:DefaultName>
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
                                          <Textbox Name="CompanyBankBranchNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyBankBranchNo.Value</Value>
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
                                                    <Value>=Fields!CompanyBankAccountNo.Value</Value>
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
                                            <rd:DefaultName>CompanyBankBranchNo</rd:DefaultName>
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
                                          <Textbox Name="DocumentDate_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocumentDate_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>DocumentDate_Lbl</rd:DefaultName>
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
                                          <Textbox Name="DocumentDate">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DocumentDate.Value</Value>
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
                                            <rd:DefaultName>DocumentDate</rd:DefaultName>
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox15</rd:DefaultName>
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
                                          <Textbox Name="CompanyGiroNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyGiroNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyGiroNo_Lbl</rd:DefaultName>
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
                                          <Textbox Name="CompanyGiroNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyGiroNo.Value</Value>
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
                                            <rd:DefaultName>CompanyGiroNo</rd:DefaultName>
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
                                          <Textbox Name="DueDate_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DueDate_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>DueDate_Lbl</rd:DefaultName>
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
                                          <Textbox Name="DueDate">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DueDate.Value</Value>
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
                                            <rd:DefaultName>DueDate</rd:DefaultName>
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox16</rd:DefaultName>
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
                                          <Textbox Name="CompanyIBAN_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyIBAN_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>CompanyIBAN_Lbl</rd:DefaultName>
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
                                          <Textbox Name="CompanyIBAN">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanyIBAN.Value</Value>
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
                                            <rd:DefaultName>CompanyIBAN</rd:DefaultName>
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
                                          <Textbox Name="PaymentTermsDescription_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PaymentTermsDescription_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe uI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PaymentTermsDescription_Lbl</rd:DefaultName>
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
                                          <Textbox Name="PaymentTermsDescription">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PaymentTermsDescription.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe uI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PaymentTermsDescription</rd:DefaultName>
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
                                          <Textbox Name="Textbox17">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>segoe uI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox17</rd:DefaultName>
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
                                          <Textbox Name="CompanySWIFT_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanySWIFT_Lbl.Value</Value>
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
                                            <rd:DefaultName>CompanySWIFT_Lbl</rd:DefaultName>
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
                                          <Textbox Name="CompanySWIFT">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CompanySWIFT.Value</Value>
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
                                            <rd:DefaultName>CompanySWIFT</rd:DefaultName>
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
                                          <Textbox Name="PaymentMethodDescription_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PaymentMethodDescription_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe uI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PaymentMethodDescription_Lbl</rd:DefaultName>
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
                                          <Textbox Name="PaymentMethodDescription">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PaymentMethodDescription.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe uI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PaymentMethodDescription</rd:DefaultName>
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
                                          <Textbox Name="Textbox18">
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
                                            <rd:DefaultName>Textbox19</rd:DefaultName>
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
                                          <Textbox Name="Textbox20">
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
                                            <rd:DefaultName>Textbox20</rd:DefaultName>
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
                                          <Textbox Name="LegalEntityType_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LegalEntityType_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe uI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>LegalEntityType_Lbl</rd:DefaultName>
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
                                          <Textbox Name="LegalEntityType">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LegalEntityType.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe uI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>LegalEntityType</rd:DefaultName>
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox21</rd:DefaultName>
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
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
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
                                          <Textbox Name="ShipmentMethodDescription_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipmentMethodDescription_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe uI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipmentMethodDescription_Lbl</rd:DefaultName>
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
                                          <Textbox Name="ShipmentMethodDescription">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipmentMethodDescription.Value</Value>
                                                    <Style>
                                                      <FontFamily>segoe uI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipmentMethodDescription</rd:DefaultName>
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox24</rd:DefaultName>
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox25</rd:DefaultName>
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
                                          <Textbox Name="Textbox26">
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
                                            <rd:DefaultName>Textbox26</rd:DefaultName>
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
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember />
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!LegalEntityType.Value = " "</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember />
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>0.40942cm</Top>
                              <Left>0.07455cm</Left>
                              <Height>8.47126cm</Height>
                              <Width>18.5cm</Width>
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
                                    <Width>4.97515cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.55756cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.46729cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.79214cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
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
                                          <Textbox Name="Textbox27">
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
                                            <rd:DefaultName>Textbox27</rd:DefaultName>
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox28</rd:DefaultName>
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
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
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
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
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
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=Fields!Type_Line.Value = " "</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                        </TablixMembers>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <RepeatRowHeaders>true</RepeatRowHeaders>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>9.63346cm</Top>
                              <Left>0.0497cm</Left>
                              <Height>1.37612cm</Height>
                              <Width>18.49214cm</Width>
                              <ZIndex>1</ZIndex>
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
                                                      <FontWeight>Bold</FontWeight>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
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
                                                      <FontWeight>Bold</FontWeight>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                                      <FontWeight>Bold</FontWeight>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                                      <FontWeight>Bold</FontWeight>
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
                                          <Textbox Name="VATIdentifier_Lbl">
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
                                            <rd:DefaultName>VATIdentifier_Lbl</rd:DefaultName>
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
                              <Top>14.70397cm</Top>
                              <Left>0.0497cm</Left>
                              <Height>1.76418cm</Height>
                              <Width>15.2cm</Width>
                              <ZIndex>2</ZIndex>
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
                                          <Textbox Name="Textbox38">
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
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox38</rd:DefaultName>
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
                              <Top>16.8196cm</Top>
                              <Left>0.02485cm</Left>
                              <Height>3.88058cm</Height>
                              <Width>18.02485cm</Width>
                              <ZIndex>3</ZIndex>
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
                                                      <FontWeight>Bold</FontWeight>
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
                                                      <FontWeight>Bold</FontWeight>
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
                                                      <FontWeight>Bold</FontWeight>
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
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox42</rd:DefaultName>
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
                                  <TablixMember />
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
                              <Top>11.39055cm</Top>
                              <Left>11.5497cm</Left>
                              <Height>2.946cm</Height>
                              <Width>7cm</Width>
                              <ZIndex>4</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
                            </Tablix>
                            <Textbox Name="CompanyLegalStatement">
                              <CanGrow>true</CanGrow>
                              <CanShrink>true</CanShrink>
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
                              <Top>20.84129cm</Top>
                              <Height>11pt</Height>
                              <Width>18cm</Width>
                              <ZIndex>5</ZIndex>
                              <Visibility>
                                <Hidden>=Fields!CompanyLegalStatement.Value &lt;&gt; ""</Hidden>
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
                                    <Group Name="Details">
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
                                      <Hidden>=Fields!ShowWorkDescription.Value = false</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>9.05707cm</Top>
                              <Left>0.09398cm</Left>
                              <Height>0.4cm</Height>
                              <Width>18.30602cm</Width>
                              <ZIndex>6</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
                            </Tablix>
                          </ReportItems>
                          <KeepTogether>true</KeepTogether>
                          <OmitBorderOnPageBreak>true</OmitBorderOnPageBreak>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                          </Style>
                        </Rectangle>
                        <rd:Selected>true</rd:Selected>
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
            <Height>21.59908cm</Height>
            <Width>18.5994cm</Width>
            <Style>
              <Border>
                <Style>None</Style>
              </Border>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>21.97832cm</Height>
        <Style />
      </Body>
      <Width>18.5994cm</Width>
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
            <Textbox Name="Textbox193">
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
              <rd:DefaultName>Textbox193</rd:DefaultName>
              <Top>3.35278cm</Top>
              <Left>13.6cm</Left>
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
    UEsDBBQABgAIAAAAIQAs1xQN3QEAAC8MAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzJZNb9pAEIbvlfofrL1WeEkOURVhcsjHsY1UKvW67A==
    jmGV/dLOEMK/z9oGp0pIbNV1kgsS7Lzv+4wHlpldPFiT3UNE7V3BTvIpy8BJr7RbFez34mbynWVIwilhvIOC7QDZxfzrl9liFwCzpHZYsDVROOcc5RqswNwHcOmk9NEKSm/jig==
    ByHvxAr46XR6xqV3BI4mVHmw+ewKSrExlF0/pI8bkqV2LLts6qqogmlb6TfuzvmtY/yoKoLBZzIRgtFSUDrn9049Y5vsufKkrGtwrQN+SwWvJFQnrwfsdT/TA41aQXYrIv0QNg==
    VfGtj4orLzc2KfO3bY5w+rLUElp95Rail4CYJmVN3p5Yod2B/xiH3CB5+8cargnsbfQBTwbjtKaVH0TS0D7Dngyn781QzwNpZwD//zQa3+54IEqCMQD2zp0IW1j+Go3iL/NOkA==
    0ntynsaYRmvdCQFOjcRwcO5EWINQEIf/JF8QNMa95jBKfmPcs//h18Gw/kfI79l/mSIXYmlgDIK9dSfEynhEEXfv8Yd1yOoP9cG39hPHx1/fLcunucdbok/xRaa0kELzOvxKqw==
    bd6KTJX1MpMW3PgPbR920Uo9Cb22mDYxWQ/uD6o1V4E6ks3rdX/+CAAA//8DAFBLAwQUAAYACAAAACEAHpEat+8AAABOAgAACwAIAl9yZWxzLy5yZWxzIKIEAiigAAIAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAKySwWrDMAxA74P9g9G9UdrBGKNOL2PQ2xjZBwhbSUwT29hq1/79PNjYAl3pYUfL0tOT0HpznEZ14JRd8BqWVQ2KvQnW+V7DW/u8eACVhbylMXjWcOIMm+b2Zv3KIw==
    SSnKg4tZFYrPGgaR+IiYzcAT5SpE9uWnC2kiKc/UYySzo55xVdf3mH4zoJkx1dZqSFt7B6o9Rb6GHbrOGX4KZj+xlzMtkI/C3rJdxFTqk7gyjWop9SwabDAvJZyRYqwKGvC80Q==
    6nqjv6fFiYUsCaEJiS/7fGZcElr+54rmGT827yFZtF/hbxucXUHzAQAA//8DAFBLAwQUAAYACAAAACEAVPhkQmMBAADuBwAAHAAIAXdvcmQvX3JlbHMvZG9jdW1lbnQueG1sLg==
    cmVscyCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC8VctOwzAQvCPxD5HvxEmA8lCTXhBSrxAkrm68eYjEjg==
    7C2Qv8c05NFSWRxcjjsbz4xmnfVy9dnU3jsoXUkRk9APiAcik7wSRUxe0seLW+JpZIKzWgqISQearJLzs+UT1AzNIV1WrfYMi9AxKRHbe0p1VkLDtC9bEKaTS9UwNKUqaMuyNw==
    VgCNgmBB1ZyDJHuc3prHRK250U+7Fv7CLfO8yuBBZtsGBB6RoCUwDsowMlUAGs5dHfqGiNDj+uGlSwNFLbVmqhu+mawMHcp/WjZTTj1p7Goz1dFJX9vkb1zKg+BC4tzAgFjHEg==
    ufSQS4Ep29QwmRghmwunJrKtRtm8GrXRhO9PKK0QmsiayX+7sf44C7cDknhwS0bIGonTTL4l5+ujr60zuXap/wGbZ0A0u3mWwwy0JhGcfpFak7hyurN+xTAgNgt3p78M9rfEaQ==
    BmjOzhbWruzB0QTde6WTLwAAAP//AwBQSwMEFAAGAAgASYeaSj93bMqPEQAAldgAABEAAAB3b3JkL2RvY3VtZW50LnhtbO1dWXPbSnb+KyrmYZ502fuiGnkK61xXfD0a27mTVA==
    KuWCSUhiTBIsAJKsm8ovy0N+Uv5CDjaSAEEKJCEJsPhCYutG9+nzna1PN/7vf/73z3/5MZue3fthNAnmlwP8Cxqc+fNRMJ7Mby4Hd/H1uRqcRbE3H3vTYO5fDh79aPCXd39+uA==
    GAeju5k/j8+ggnl08bAYXQ5u43hxMRxGo1t/5kW/zCajMIiC6/iXUTAbBtfXk5E/fAjC8ZAgjNKjRRiM/CiCt1ne/N6LBnl1ox/NahuH3gMUTipkw9GtF8b+j6KO2WaLgoU/hw==
    m9dBOPNiOA1vhjMv/H63OIc6F148+TaZTuJHqA6JopoA6BDOL/IqzpfNSIpcZM3I/4oSYZP3ZkXsnIrpG4ehP4U2BPPodrJYkmJ2aG1w87ao5H5XJ+5n08FyGDE7bhztbERWFQ==
    Nml+Poyzadby3TVi1GBEkiqWJZo0ofzOoiUzbzJfvfgg0qwRF/P9KiAbFYjI368KnlcxjB5nK2g8LG6OG+W/hsHdYlXb5Lja3s+/L+ua79fBnFvWOTg6rjGfb70FQHk2unh/Mw==
    D0Lv2xRaBGN/BsN3lo7AWYKSQSIEvwXjx+Q//jbN/67C/OBz/DiFJy/uvenl4EtSy1/DCbDkML//D7gHjMkRApELVx4X8JrFKF49YUKzQDCnZ8GiqGoOYjgpMAqmAQga7y4Okg==
    0+iPy0FaUbTwRn56nNYz9a/jA4t+C+I4mB1YOJzc3B764sk8moz9X48q/ftBpYcbhP82tfzp9DcvXCPmQ140G7PxD6/S5/r7w2ptcPYhCL4XDUXMSEtdT8Io/hRAJTg5nXr52Q==
    6qYVTO9m87X7xYX0kXnwqwn6enn2e3aG1xqxZNKEJZPDG/iHSnKWxIjmPaq/PiyVjUO4DfbD+NMV0BchwriJnEFxMbnELSKpVVz6kj5mm5JLN0VRPMp+82aNcmgQXgeN4erJxQ==
    ni++Wntv8ZTtX3t30zi5wxA2pUhbtMhfUALxx+Az8EqqibJ25E9F4zj/y87D7O9bjiIryh/Pr3vTiRcVdf7TR+/+4mz4q+8Bxw2tuwgQ54fGeByCMMKFLPBuys9/Tg2ycPz1sw==
    N/Wjr3+/C2J/iCliBQTGxfPnlAlBJSEyv7WYArvfBlN4XW7FXYHRVDyOlWPZJnMk5YwxwpQQxHaIiSlcd/JKhpu1eLFnTuaJ0Qg1LUL/evLjN2+xgHMQxplcnkfo8k+J2l6p6w==
    8ePcg7PofO7dg+2zCMI4Gm7t2/BPyaD9ACvt9nIwhOougBb/AKh+Skv+62ya9OTf8X+k9zKKFmdVwsL1FPtxEPrvY3/23r4c/JfQynIcQc5txtk5k5yfm0qyc2xhYdgIO0ir/w==
    LobE/xHntFiOOxw483GFBwpwD1bcULpU8MWwXB6OrWAegy2X1taU0dOmvav2NsVM9qriRcvKhzn/JoOag6u3kHy4+M9RcSeVxYVc3gXI7TjeBdTEW5g/tohTjCXWHAnNGwGVaw==
    lypGqVaOZNRlhqWE5QiEXC4s7ereArVM2GfFafbEcUgrN3dvoCV/4UmJ7gm+sngjx6OPYIKlpkg105LEpcxxbImEspitlOEiYhvcsS3HZa78WbQk6Tz6Ku1923quBUXWApQwJw==
    WAhOUDM9ZmpDEa24NJXLiGUZ0nAFd7ltYPCHGOktlMp07TySys096bFX0GP0ePBxKqjmmItm2ONc2YA1LsHTcyRXyCUWpYYE2nGOnd5ir0LXzoOv0t6TGjtSjbWApHOMAEyYCg==
    gRphyXEt5NrYNKW0GGaW4Ri2w02LukrYyHF7i6UyYTsPpXJzT3rsFfQYa8GIJERjpDFupsiwsgFsQoLVaTBAoqZSgSnJLCUdZtv9BV+FsJ1HX6W9J0V2pCJrAUrnilHCiWbNoA==
    ZLmE2KZG2OaCMYG0bdraFAjsSmS5ur+hjTJdO4+kcnNPeuwV9BhvQY8pzBCXWDbUYyYF5SW4QQyX2dJWpkmkUlg6ykQGZb0FX4WwnUdfpb0nPXakHmsBSudYUZYECjFu5pAZhg==
    q2zmAIAcBj+GTRCykCDKdE3NzN5iqUzYzkOp3NyTInsFRSZaQB9BIrEjOWuIPiopcyhKJsWYY2GtEKHCdUxOtekYVm/RV6Fs5+FXae9Jkx2pydrBEtiEVLCGs83MkpbpUmVxxw==
    YJZwlDIVkUI5XLjgotHeYqlM2M5DqdzckyZ7BU0mW0CfFEQgrjRpBD5hc+QkOZBcImZb1OAC9JhtGAbQyTKN3oKvQthuoy9P4Jt68+W4j71z+59LGZQ1+k6e9N2h+u6Df+NN/w==
    lq6U+Prh27QNB05gsCERbxiJ5JJQRhCTDqg9g2tlIoxdwl0ObiCifc8MqdD3Z8FfbeeaoHBffZys9inWbsAoR3547w/enZVedSTftxD/o5RgYFuimiVkEJqMuGU5GFjexoaCIQ==
    Zo4rHWQ5huxvQsYGaX9adu+jWXi4PaaOhwiXmAmOVDNzTHNh2RYjlnYww4ZrWNoFtjFcFzlwonqLkApdXxwfLVsva2DayzWox8AxJqCqInKxC5edMgH3I+JuE7BO5iR/2brVSg==
    w5HNDWE/1fDypeNHP2viw2kt7Ubhn2ct7QfvMbiLl0MEYthfG8aDVtoSxTafGFbr6+paW8J5EVFvep3svD582LU2t4LZbUbFGoD3MA7+LbgLP/nXfujPwe5vyWvkQigFNoJulg==
    vsIQkTYTzOQ2U5gbyLSE5InfSLlwe+s0bpL2xS2ELUoRg1bcRyk+yYFP6BZGseb2dt2S0A2GrQAPSJvpZO5/uJ8uoV81OfayLjYHot6+yNVsvae7ZcF4WNsR69YLCyVSbs0OKA==
    prx3BXI3mJvQqe8tgZEwxhUjstkkIACOu8rRyZpURl3DkFgnLq0hXKWY2du0zDrivtSC8id4pGCOYblwJ5H8lJW4N5IXYRBcO2G47EO0AAMAWCBcLgSv7cEREIzf1TFDJQhV3w==
    LhicZfv3Fxk7sH/lPSZ7QH3xw1lk+9EonCySPaXaEgFIgQwmEjVz2DHCjDquAhGgmSW5CYrYdJnUgjgAAtxXGbCDyG9VM3cKz/G7HSP0uvj8fDtZJC37zY9vg3H7CFUafAfCGw==
    hpxtISU3pGtZSUIC065E8GvbtrSkRXs7v7mTyN1GaPJA7rU+vaFU9uSbAfXOYW0d1sfG5teb3o6MbhZS3OE9rWaVD3XsWwj5E6SRpLyZF2Eii5hgcrjUpsxCSDFbauihzQjRxA==
    sfsqoUpE/Unmw0p9OiD3Yh8turK7P3qzFrhSMMkQY6hZdoKSgliuIRByDKaYBUrXQVRwyjXWWPV2/6UKWbutKZ9PTq4zf23Ne8GiQtQWIkb7u38tGJaUE8Glxg0z5xjRyhUUIw==
    ZTOAiGFb3JJU28I2TYFQXxGyhb4npFSRohXR0Ja9kLKFuO3FWJ9qwiF+2/HQkgJJTYBbmukei2ubaAdjZjDAlRKWBmsKg22kGBhXfUXWVgJ3G1ut+mvdguPWEdkbkBspB1V8rg==
    J4pywRlSOvcPMO8+68Jj39fI8wF84OgoloVOQ4N9L042JPdHSaUZr+0QUPWNOEQ2VXCyhoztw4ZBx2NNVMNcx5xnr1YPfT3HCsYdU0ZFvQirIUpC24NbDICglOmGq7N3tZj1Vg==
    6NYxzY57rYnivTm57mLb3L04WO5iFxOTH5Dwtpc8riHBXulte1xukhSWd/o5KXRKCjslhR2QFIYx7XFSmBaFRirneGml664rLWsvY1V3GVNd+3UHSVntZVRfi0Tr/dmab8aozg==
    hmJnoJwgaVKaBcpzYTfy5vHnxXSSK4s4/NVfZ/jVKiJ4e6Y1itaEe2e1J3J0mGizj8HX5LidiTgpMWOCNQxzE0dRR7vMNAhjJhIms01uEyyosECB9nYiLjca0uMKibvi1qVw2w==
    FCfxaE1MlUV18pmg6Tahx2qF3npl98Z0cjMvKsuqfmpy/ikgHZlL/gLzeFkPMkOmwgmvOyGfwr80l9iaDMCccaq1arjm8S0IgTpCd0USZBr2JApeUhTU8UMH5MHf78AAmcSPLQ==
    CoNk/TPmhDf8yMQbkAUbRO6KIEhN6pMcWJcD9Z9Wem7psMEhzyAatvFA4j+deGAfXXB4Okcqc/9lPoEnW9xxghOcTKzRk/VVHJdI3BVpm4UkTlB7fXFbYo+XE7Vp7Ok0/i8oag==
    fze+XI3iNj1dojFhQjXMn3sLsrZC465I2zSiewLb6wvbCn90wOlNfoxZcDdvVTJwSghN4mAnybB2XKFzV6RDNrHzkuJh7+ypk0TZJlFq+Kp1qZJnctXM9TXbW2L/uT6sVltbFA==
    qRCHz+SszfQfxbg7WO2Z11ztypQYrmhTS6FGEe63TaImsb83TqEGkbG3TaFGEY23TaImPv8bp1ADR+1tU6iRsdoWiQ6wVDtN1aUht6eX2IJHSIkknEmRp5b1IcM/63n7Gf1N3Q==
    te1p7EoShZAizT5U6yKiCKMI3GrGXEY0UhTZmihlY2bTLd9Fap55v93fPMxdWNvvq6G7QIisugtH5AK2MQ2Fkl2gFWn4KWHbSTav41JQZTKTmoZtYelwV1ELxsf5KQIgawTuSg==
    4KPWdzxWgJcz5LcJ8KO2xFgjZQciiNVsnjbgwwjSlDPcDD6IuJYrQMxhRzEtmLakspWdfN7eUVT3dsepXTl0XcFQfXShByCqEvQFs0zqog3HUswmDNu1FNv8rEhrHw7ZTJs7Hg==
    /FSBgaIFapZDjy3GGEda20gCvyvl2spwNLWw7RqK9HbDya0pcy+/TfyBKKvh1wx4pe7si7p6oO3XgibfEWkhrelv17/5XnQXtoAJRgVYk0o1w4SwhQE2pJLCEAwLql1pcCJcag==
    uoZrmr1dt1pNaloSuCu6sDZI2gNVWCJmByzKZUrS8ciRklIwCEmziWjHsByBGZYMucAx2lSmYSjkgvcM5iXu7bdGatMBu4Ka+sB5T2CTUrIDkEl+7Ek0SiaCr/xwlO6o8yNuyQ==
    JsOYKcnB0mqWzsGYjU1bacuyGSOGKS0TOQxx5RAXLLOfAUW76N0VYNVOt/QAV7to2wGoreVwtYAsoZhmiEnaCFoy2VJbcyqEshlxuabIxMpBhsGQKXFv9yDckkPZGSTVTcv1AA==
    SWuk7ABwKqlKbcQJVRJ+4rphBjJlZvItXwU+EWUYS8OVlkWpIoJwZNCfAj0VIncFQdunbV94fvWF9NfaEDxXOt72u1uikS+VvFczG/eSEzBdyrLrZ1+eJUDdoby1fnblefzkDg==
    ZYL1tCvPYRt2LbfqrSdBZUbYlyD2plFLjp8G0YSR1qI/CVGbVOhicpQUiiNJWLM9N95kctTJHOtTX07m2Kt25Qg1UcqNegYdwoSimFLcLHj4sy6zrBK2LmWq5plOxEWIorzO5A==
    SnbeBN5cLnikLxhybI6UNnOwqiP0ugHLDSTnAZ1nADEnSGGi3/h+gdtAvIXuXcFvZ1ymrkF7y7i9uWAoxvRkffe5Lyfru4tdeVm76RSOe4Fw3Gl+6iSSTyK5B12pulE5hsJSTQ==
    n+MwWFXz9Kf2MhMx+3s/H03vElfld+NLkvnVRqREC6oYQW87UpIRuXRWpfWzOlb7cMuwXOwZoilJwefZ4aorAN6L2i24fc0lQfyulvteIOjTurTKPN31nrSRFiowR1jxt72BXg==
    jbzapHavJVYP9t7rjjCr32Gv4yJuk2GfMQaWfzPvqY8abl8svDkk331/8XH5BccoGxAo6V3HPhCn+Kz3stvRHyshlt+J/rCiysXqoGTdhEf9ESBwe/OTyfaK13ebioxP/rUf+g==
    85G/4uSsV4OzEAQrsMz7cfFZs+sAhFOjEoX43faO9NNwa88vNyzY9oqNAsslnTef/8hFAtYo9W9u0+UBVGdQH0PppTa4AWQmdQaLywEX6dMpJJZnmchYniaf0Utjkal8yHqzvA==
    mbV1eXpzF6enRVdAykQrobL6OFw8iaf+1U12Agop+SBc8qrJ3L+axCNoPRVLEZSNa3r4LRg/pgdQ5i751PC7/wdQSwMEFAAGAAgASYeaShc+5re/BwAAayUAABAAAAB3b3JkLw==
    aGVhZGVyMi54bWztWm1z6rgV/ise98POdIZry9jYMJfsgIHczCYpJeluZ9rOHWELcK9teSRBkt3ZX9YP/Un9Cz2SLQMBskCSfWn3A1hv5znv0kHmP//698evH7PUWBHGE5p3TQ==
    9ME2DZJHNE7yeddcilkjMA0ucB7jlOakaz4Rbn598fGhs4iZAbQ57+CuuRCi6FgWjxYkw/wDLUgOczPKMiygy+ZWzPADYGap5dh2y8pwkpsVfZFEZyAAlVgyokEwcndAsiRilA==
    05n4ENHMorNZEhENAyDI3hLjodgVYy/CA2VxSS5bBaMR4RwgQ5yvMNdw0ePJ8rhWtMBMkEeNkR1lmAyzL8uiAZgFFsk0SRPxpGykYSh4kuWdCqJRiyFJOqUY1UNTsGP4liQDGg==
    LTOSi9IrjKQgA835IilqU2TnosHkQoOsXlJilaVrNx4bCYf8OCg9sgY8IzpfRkT2ER6REDXFMSJs89yXaQ/nmWbDuMg7DcDZAWhxchqEV0FY/Clbp8ZDMX+dly8ZXRZrtOR1aA==
    V/mXGis/TcEqWjYjmL9OmLsFLiCVs6hzNc8pw9MUJALfG+A+Q3nAkFliym1cTNPqMWZV4048pbCis8Jp17yX1JcsgVC0qvnvYA4C0rNtOCxg5KkA+CIS6xV9EAeOFNWjhYbK4Q==
    AJEEEU0pbDB4Kajs8u+7pgLiBY6IaiuclMzEmaRTKgTNziRmyXxxLuMk50lMPr2K+tuzqK0dw0/TkKTpDWYbxnyoSEufxY/4mc77563naNC7pvSLFtR2e4pqljAuJhRAkOymuA==
    6q0nQ5ous3xjXg+oJTn91IdKo+59W/bQhhB1kMqQlM05PAGkCklkNyuN9o9bW7SCwTRUPvEEWNpe6PjN0KyG7pkacx0UemWiROV3JUFUZYHj7csCa72y0DzGCnGIEApd8zDj8Q==
    7tBkQGZ4mQo549qo77eUREXFYDtfE5ESLUO1gseiepR9nCaYa4I/3OJVx7A+EQyRY+nzV8F8vp6mOqnxfJvgTtWELP58h1PCP/95SQWxUNN2dSzHen0jsH23FbSDdjVVpBC3Cw==
    mgI/2Y1pNIaqRy93+0Pf891g6LvIRYHT7nn90HV9z3YHqDd0at2eoWCB+0ku61ZAKhiZJY83uCigD7tpubHm3O5+Jc/d9XkbP+UYeryR4xUULwVlglsHdbO+ki55hDJr0TUtgA==
    64AtvoOcmyjKv2ap1ORv6B9qrjSp7u1YFiZUFgvKyJUg2dWga/7QagfhcNhyGgPXcxugtdfoB77bQCFq9QY2Gtrt4EftE/IoKmPUroXGMI/HrFwBvZDmArgquzNKZ0PG6mjlBQ==
    pDQoy/TWzY6NVcX+YkclFfdKIHaYIchnrsWu5bPqOD1NCnlo6q0Q3M4JWxHzwngmyvMUYNVjN3dCKMG1fOzofLmlr08U5HitZtP2mt7viaJM+q4ZcmIUWNuU75pZJwXnOg1v6Q==
    W+SfjJg955bbd5xR6/3OrbvlVBxxdO01jaY9L3UHWJC3OOX8puN4vhMclbzNftAa9ns9+B65jj8K2u122Av7duiN2oEf/NaTVxr1l0nfg8Hwi2fwC2G6TmJpuP/9NH4hLcd4/g==
    RoVn0HaDFrLrmZcz0h4gx2/3hv3Q6bu2M2o7ULUO2i1/1GyFbd/9rWaktuevv9w8HJtlimhN3qXK/AnmB6rM52XmSaBV7k9Dvr0ZzNJYbhFG3bpXak3JXN7kWW/MLcm5YPfStw==
    +1Uc9y6HhvH3Pxo9hqdJpJo3w8nlcPSnyU3vXlmgxvh5LMFJgZk+tXcYSmw0Qk7f24MtrxXGMmCe77/oZ/QkWcfm6bwO+cn6P4jF27/cyHC8+z0e3zEedyqHk4uEDUn2FgnlAQ==
    VV96ygNbXUDCT2AX6bOhUuFZBVeMawmt9Z1c+X32zdwBBQdha2R751RBWwr+M9LDSskj9DupXgrla7/8aaxfh776hwxqNuHUR8jRV6m/+hJn2wSvLnSqN8un1Dr7LpI3vLyR4w==
    8to7r50T48bgGyktwVz0eILroa28rV4uQrOAfEmTnBhxwsW9uimXrX7duq5bk/IevUBuB+fRgrIrebPutlDP83vVBIkTIYebCHlDVO5QRQc2TtDLkG+wHdSy1Xue6Amy0w7Kjg==
    VS6bzUgkhuXiVHET6pup72nXbDW9erUst5mRADPHNCAyICcrhxmOXhPdri4ZLhZJNGKwQiqPO/ONkWsafeGv/ttBTmHvy+ekB5ViJNYvGF4W4LVsN6DgRx42lmz3nePxf3u4+A==
    CC0Zqm/yJ4oSLV+BR6TOsgOmqPxlP/dXaS+9SJIYclcgbKLe/q/IhPDke/VqSioNC0u/7bF7PcQYfVhAVvPaHZv4VXdLwGmaFKMkTSUL2TZYh2RTAgJDpCPFGQL5mouqVRr8Bw==
    J+jZdtvpN0LPDhuu7Q8bvbbrN3x76Lu2G8COEP4oqSE9llxGHE4HRfIGfzMpf2aWyimJ9FPJaJVaSGGheCEiWsjmDBScgLEqonrG2raA7HE4O4zpww2NSfWyUAI8zlgmnyCW8Q==
    qNg/aSFKq7yY5dYaoGBcXBKaGbIBNgahFAO8AvGrtXqNHM+pFK3kk+bbI1Y5ZGmxqyZ81NxGlmz2yxQt9z+1O9bbYl24HL4JqaoF+WD6PeBPFAFnljQ7VcoiZhf/BVBLAwQUAA==
    BgAIAEmHmkp0nrYUSQQAAGkNAAAQAAAAd29yZC9mb290ZXIxLnhtbKVX227bOBD9FUP70CeHoiLZllGniC2nCXpBNi7aBRaLgpFoWwhFEiR9y2K/rA/9pP2FHV0oy5d0E+cl1g==
    cGbODM/MkMy/P36+fbfOWGtJlU4FHzj4zHValMciSfls4CzMtN1zWtoQnhAmOB04G6qddxdvV/2pUS3w5bq/kvHAmRsj+wjpeE4zos+yNFZCi6k5i0WGxHSaxhSthEqQ52K3+A==
    kkrEVGsINCJ8SbRTwcXr56EliqzAOQf0UTwnytC1xcgOMxKSclBOhcqIAVHNUEbUw0K2AVMSk96nLDUbgHM7FkYABYr3K4h2nUbu0i/TqH6sh3pO3NIlEvEio9wUEZGiDHIQXA==
    z1NZU5GdigbKuQVZ/moTy4w5dRmx/7o6RmVFtoDPSb8qY8bKzH+NiN1nVCSHqD2ek8JuTJtJRlK+DXwSNQ1ycfAyAO8AoKPpyyCCCgLpTbYdjZWcva7K75VYyC1a+jq0G/5QYw==
    8ZdtsOqWZgfr1yUzmRMJo5zF/ZsZF4rcM8gIat+C8rWKCrTyKXHy88/cs+rnVlUfE7NhYNFfEjZwvuTe71UKrYgq/TfQQUMGrgunLKxsJMDL2GwthpAOnMWFJKSF4nDy5g6xYA==
    Ag4YsjAiF/XjwCmAtCQxLb4LHEan5kTXe2GMyE50VulsfmrglOs0odev8v56kjc6IP6efSQbsTB1iabpmjbKOKKMfSKqQfWqAi7NkzXZYwT0Xs8/tED7eHlsIR7sRlz/ssCdpg==
    Sps7ATA4FxmppK1yJNgi4w29XShMuLgewhVeS19LCTeSqJs4b9n8cwa/AFJmj10vvxVra2sEbwDYJZB/dwtEu27Y88KgCFIs5kuR5+MosEtfVGOtRCgjx4SbiYQbuKJZXdNmOw==
    eV63Dl95mLj8a6X/m6644rhRlCNFQ7Ul2oLrxFQ/pVxlwAif2QQT0o4+WIRKT1hKtDX47TNZ9lvomhJoNDTK3xx885HOCBwbxND87raZktmu06R4f6nk+4Qwqr//vhCGInzu+g==
    tv0Ta9/GXic474Zh1+okg16fCwZBczER8S28lKx9Nzx3g2DsdsOr0McdPOxEw04w7OJLPHY7UWg3tI9CDBmmPH8kApJUFCbkE5ESZDiBy8OYa3fwJr+rt3d0suEEJN3mZAkPHg==
    KZTR6MnNoTd5ddbwNJsPHARwfSDjG8zpXeH5R8bynfyJ/yp0Ja9WOkovKIvpN0LRG1i6iQbO352wNxqPO1478gO/7XeDoD3sdf02HuHOZeQCDWHvH1sYujYVIXUrwMeYJ7eqtA==
    AGkkuIFgBfdPz8Ht4dJdRKdkwczegMgyjty5XD6LCZxhxcsINRpSP1oD3Ks0+nGk9xZtg6IafG+KA/88xOfOCzrdXBxlvJih0q4MZ7mrSULVcKFynovxtofMDoVlZjjCo7G3cw==
    vrjQvfhqh9c9qwavlfGTvF4J6D71JKneMVK9o6TWu4X/ky7+A1BLAwQUAAYACABJh5pKfGYI9LMFAAAGHgAAEAAAAHdvcmQvaGVhZGVyMS54bWztWOtu2zYUfhVD+1FggKuLKQ==
    +YI6hS3ZaYAm85KsGbANBS3RtlZJFEj6kg57sv3YI+0VdiiJ8r21HadDsf6xeDsfz+0jj/nPX3+/er2Io8qMMB7SpK2ZLw2tQhKfBmEybmtTMao2tAoXOAlwRBPS1h4J115fvA==
    mrcmAauAbMJb89RvaxMh0pauc39CYsxfxqHPKKcj8dKnsU5Ho9An+pyyQLcM08haKaM+4Rw2cnEyw1wr4PzFYWgBw3MQloBI9yeYCbJQGPG2RjQlCUyOKIuxgC4b6zFmH6ZpFQ==
    MFMswmEYheIR4AxHwVBwAUtaBUS1VEOKtHI1io+SYIfsm4t41J/GJBHZjjojEehAEz4J09IV8aloMDlRILNPGTGLI60Mo4meFkcvj8gS8BD1izDGUa75pxFN44CISIhS4hAV1g==
    91SaxDhMlhuf5JoV55r2cQDWFoDDyXEQdgGh88d4SY15On5alC8ZnaZLtPBpaFfJhxIrOc7AIltWM5g/TZm7CU6ByrHfuhonlOFhBBpB7CsQvkoWgYpkiSbPPzGMis+AFY078Q==
    GMGK1gxHbe1eSl+yEFJRL+YfYA4S0jTMJhwxMPSYAn6wwMslXdAHDuOsR1OFlcDRKwV8GlE4YfBUUNnlH9uakTVS7JOsneFEZCROFB1SIWh8ojALx5NTNw4THgbkzZOk350krQ==
    bzl+GLkkiq4xW3HmvBDdjJmyefe8vokGvbeUflCKGqiTSY1CxsUtlckhuxEuestJl0bTOFmZVwPZkoS+6cIdXfbe5T1zRYkyS2VOyuYYvgCS624bzUZh0e5xfU1WMJiGmiG4hQ==
    LQ3PAS56WjF0z+RYo1d3YCxb7Oe/hQb+wyr0Lo8VK1O1xyBD9Cxkera2tvHa0GDHKo+M8DQScgYZZrfuZBql+Qas+Kzx9k4wKm+cXJdsiV5K8EAUn+MQ5i0chZirFd/d4Fmrog==
    vyEYck5XV/d9KCLy/u0wUscBHq8L3GV1GAve3+GI8Pc/TqkgulkzkGJBoNabhmMiZNuOU0ylEWT8hEawn+wG1B9AwaSWu8hq1lCn43SaLup06916p983LdS1UNPxkKds2UTBAg==
    d8NE1oqAlDIyChfXOE2hDwdxfiYn3Gi/kFf28qoOHhMMPV5N8AzqnpQywfW9tukvZDAXUKFN2poOcC3wxQOw9TaT/DmOpCW/mL9lc7lLVW/LszCR8V9QRq4Eia+8tvaH02y4vQ==
    nmNVPWSjKqrbdrXbqKOq6ZpOxzPMHiTqnyomZCEKZ5RJAI1eEhydUqti0HZpIkDVLFiM0lGPsZIcPIUTBDzEhDp1DqXGcUkqLrY8lhEyX7NfNbBDW3qltEQvCfNc+sqLX53mkA==
    f5ywGdEuKhtKPytrb+gZ6GqjmiRrw/pG18yl33h6IE9v6DkIKnNlx40LCWX1nXPeuOm6bdOhkOdMma/HXLKFrAt//I8nrYcFOQNtTbNWsyzUqB9EW6fWd51G12l2603kukanbw==
    dWuGVTeR43kN1PzaaSud+h8Rd18ynJe+PQi4i46j7/40XZJYOu5ZaLxdnJ+TsaUlw8OK5U/wcoDHZ6p8q8CmZgOIadsHkbLfdyzbq1t23UWo10HdrmN6TdMCstqG1+t8raRUHg==
    fVZC5iueyKr9t0zOEmXJs1Sin9l8T325WWAeBapI4/L182AUBfKUqJSt+8ysIRnLd0j9zLuFCRfsXsZ2t4mDzmWvUvn1+0qH4WHoZ83r3u1lr//D7XXnPvNAifFlPMFJipm6uA==
    tzaU2JZR79ZqO7Dlm8hAJszmEWx+wUiSZW4ev9e+OOn/g1y8+elapuPdt3x8xnzMiwd9+VyX/578aLen9ijeBXfUHsXivbVHfr+VD77yxs8eX6EOR2Yx/LuvVmdTB5Qpa2bLDw==
    U2+dO/4QmZ7p9iztMyauD53bxFVj5JN2+WdEvR3wjy7fGNxr9CRgF/8CUEsDBBQABgAIAEmHmkpU4y818QUAAAcqAAAQAAAAd29yZC9mb290ZXIyLnhtbO1a227bOBD9FUP70A==
    J1eirJuNuoVtOU3QtPDGRbvAYlEwMm0LlUiBpB27i/2yfdhP2l/Y0YWyHDupb9umTV5i8TKHw5k5w6GUf//+58WrRRzV5oSLkNG2hp4bWo3QgI1COmlrMzmue1pNSExHOGKUtA==
    tSUR2quXL25aY8lrIEtF6yYJ2tpUyqSl6yKYkhiL53EYcCbYWD4PWKyz8TgMiH7D+Eg3DWRkTwlnARECFuphOsdCK+CCxW5oI45vQDgFtPRgirkkC4URb2rEEkJhcMx4jCU0+Q==
    RI8x/zxL6oCZYBleh1EolwBnOAqGgQk4bRUQ9VKNVKSVq1H8KAm+y7q5iM+CWUyozFbUOYlAB0bFNExKU8SHosHgVIHM79vEPI600o3IOs6Pfu6RFeAu6hdujKNc8/sRkbGDRw==
    UohSYhcV1tdUmsQ4pKuFDzJNxbjI3g/A3ABwBNkPwi4gdLGMV9S4SSbHefk1Z7NkhRYeh3ZBP5dYdL8NFtFSjWBxnDLDKU6AynHQuphQxvF1BBqB72vgvlrmgVrKEi3Nf/I6Kg==
    fga8eBjKZQQzWnMctbX3qfRrHkIo6sX4RxiDgLQNA7Is9CwTgE8CuZrRBXUgF2ctligoCpk3FQhYxCDB4JlkaVN8aWsZkEhwQLLnDCciY3mg6DWTksUHCvNwMj104ZCKcETOjw==
    kv5wkLS+Yfjr6BIv2UyWLhqHC1JxY49E0VvMK6a+KYDz6aMFvmURGDc9a3OGfhsvXZuxz2ojhtXJcMchF/KKAQxKmxEuWqvBHotmMa2Mq45sCmXnXTjCy9aHvIUqSpRBnIZs+g==
    OIFfACm0t21U7GnXfvPefn1tLSglwFjgw6sB+Mswmp7ZtDNds860y+6ZbqOnut5n0xzTNM4aORt5voEAUzlM4CAvvMXPSTUqTdMtly8kZJD/Va2vkDTdzjDBVCFaKi6CwoUVnw==
    b4kJvZyprxYVI1n85O1CswjTiVpmhOv+G4VQjOMoxEJN+OUdnrdq+jnBEMd6Ly1p6PKSTDBkJSxJWhooTfFkXWiYlXd89GmIIyI+/TpjkuioYaithSM1v47MRsP1DNdWY0kEVA==
    mrIIFk2bIxYMoBBT8xHqN1HH7ztez7I8B3V9w+sbHkIdr4malq82dBsFS9wNaVqDAlLCCRDwLU4SaEOCz3M9FUb7WVoKrEqA0ZJiaIk6xXOopxLGpdDv3Jz+LPXOAiq/aVvTAQ==
    rgXG+Ahp4CqT/C2O0p38jv7IxnK7qtZW88Jgllwk4+QCui78tvan0/R6/b5j1n3LtuqWa9v1rudaddRDTsc3UB9i/S/lGLKQhUHKUICHPh0NeD4DWj1GJSyW2f5ufgw2u658Mg==
    xrNIVkYykLWQE19K13mFVuJLT9zqVCGor8TX+WtbjSbKibljLMuXW22asSSfly+nrFOaQS/oo+dMzoi9LaXcMsb/mlJu8/nrRP3QeX9FJqGQPLsEvGOfLq+jk/DVMz2jadvNnQ==
    +HrmGL5hIpDx+5ZldLqO0bHdMw91bdfyG+YPztetVv7mtL3jwEGmveXAqZwSyZ4BvXcOSNbq19SC4EB1jEM9FIWUXM6jMhmU0VCIc8bGfc7LPYgEChvwJ1cnz3ZKrtF/q4vWsg==
    wF0Lgb1LharpYFuy2Iui5ywmAzwhJ6SkZdgOMh81JatWfaLgg6Bg1SXfl3JFMhhM4SJ3urPQszzXMJC7W+36sxJv07ZP9HsQ9Nt0zPclYf8tDqNTcc92PbfheA33UXOvNOnDpg==
    3HFvM35ulpYuPDk577665rfpH+Xqeny6QMhzkNuwm/ajzhZ3GfhhJ497MsHX4nhQCeMDMsE7NkxwkH0uXCP86V5Obbhi+/upE5fBqi4/AbGMZrOJTGQ5T8Ra2fWJT9+LT8oD3w==
    hEZFYX08i0zDarieWb4hf9QkKqz6xKE9OXQIXQpbfxO2ZHXu8VxppK9cDLvx9P1B2fRhM+W0V78fiVyZc/amVnFpy/+dYYsJfNNCvn2PCfbZ7xmDYOTqkrrxxVZdgde+2Jpr+w==
    VTYqtzYG7f8DUEsDBBQABgAIAEmHmkqQJgpL7gEAAOUGAAARAAAAd29yZC9lbmRub3Rlcy54bWzFlEtu2zAQhq8icG+TSh23ECwHaFwU2QXJCRiKsoiIQ4KkLPtsXfRIvUJHTw==
    O01gyPGiG1EkZ775h0POn1+/V3d7XUY76bwykJJ4zkgkQZhMwTYlVchn30jkA4eMlwZkSg7Sk7v1qk4kZGCC9BECwCe1FSkpQrAJpV4UUnM/10o4400e5sJoavJcCUlr4zJ6ww==
    Ytb+WWeE9B6j3XPYcU96nNhPo2WO1+jcABdUFNwFuR8Y+r0iYyXgZm6c5gGnbks1d6+VnSHT8qBeVKnCAXFsOWAMnoODpEfMRhmNS9LJ6IfBw02J27lsjKi0hNBGpE6WqMGALw==
    lB2PQn+WhpvFANmdS2KnSzKWMV5cV8dNV5EjcIr8voy67JSfJ8ZsQkUaxOgxRcLbmIMSzRUcA3/qaE4ON769DHDzDrD08jLEbY+g/qCPT6O22+uq/NOZyh5p6jraA7yOLLgswQ==
    /rac3mB/nZjnglt8ylokD1swjr+UqAhrH2H5orYCUfNKyEkTjOokHCyaeWm548E4gksqS8ksbu0sTrHFZk8pYWzB4u9fl6RfemyWfizY/fLLsPS0kTmvynBi3EIeXTN4ywXKRA==
    W54Hib0GWzZdr+ho0FkNSvo911m03171RwkIA0FB1Xah53+TYf8plw9Fncvr+O/XfwFQSwMEFAAGAAgAAAAhAMfO8qi5AAAAIQEAABsAAAB3b3JkL19yZWxzL2hlYWRlcjIueA==
    bWwucmVsc4zPwQrCMAwG4LvgO5TcXTcPIrLOiwheRR8gttlWXNPSVtG3t+BFwYPHJPzfT9rtw03iTjFZzwqaqgZBrL2xPCg4n/aLNYiUkQ1OnknBkxJsu/msPdKEuYTSaEMSRQ==
    4aRgzDlspEx6JIep8oG4XHofHeYyxkEG1FccSC7reiXjpwHdlykORkE8mAbE6RnoH9v3vdW08/rmiPOPCmld6S4gxoGyAkfG4nvZVBfLILtWfj3WvQAAAP//AwBQSwMEFAAGAA==
    CABJh5pKUVUige4BAADrBgAAEgAAAHdvcmQvZm9vdG5vdGVzLnhtbMWUS27bMBCGryJwb5NKHbcQLAdoXBTZBckJGIqyiIgcgqQs+2xd9Ei9QkdPK01g2PGiG1EkZ775h0POnw==
    X79Xd3tdRjvpvAKTknjOSCSNgEyZbUqqkM++kcgHbjJegpEpOUhP7tarOskBgoEgfYQE45PaipQUIdiEUi8KqbmfayUceMjDXICmkOdKSFqDy+gNi1n7Zx0I6T2Gu+dmxz3pcQ==
    Yn8eLXO8RucGuKCi4C7I/cDQ7xWBlQY3c3CaB5y6LdXcvVZ2hkzLg3pRpQoHxLHlgAE8CGeSHjEbZTQuSSejHwYPd07czmUDotLShDYidbJEDWB8oex4FPqzNNwsBsjuVBI7XQ==
    krGM8eK6Om66ihyB58jvy6jLTvlpYszOqEiDGD3OkfA25qBEc2WOgT91NJPDjW8vA9y8Ayy9vAxx2yOoP+jj06jt9roq/3RQ2SNNXUd7MK8jy1yWYH9bpjfYXyfmueAWn7IWyQ==
    w9aA4y8lKsLaR1i+qK1A1LwSMu2CUZ2Eg0U7Ly13PIAjuKSylMzi1tDiFJts9pQSxhYs/v51Sfqlx2bpx4LdL78MS08bmfOqDBPjFvLomsFbLlAn2vI8SGw22LTpekVHg85qUA==
    0u+5zqL9DrI/TEGACcpUbSN6/jcd9p+y+VDUycwmE7/+C1BLAwQUAAYACAAAACEAqlIl3yMGAACLGgAAFQAAAHdvcmQvdGhlbWUvdGhlbWUxLnhtbOxZTYsbNxi+F/ofxNwdfw==
    zfhjiTfYYztps5uE7CYlR3lGnlGsGRlJ3l0TAiU5Fgqlaemhgd56KG0DCfSS/pptU9oU8heq0XhsyZZZ2mxgKVnDWh/P++rR+0qPNJ7LV04SAo4Q45imHad6qeIAlAY0xGnUcQ==
    7hwOSy0HcAHTEBKaoo4zR9y5svvhB5fhjohRgoC0T/kO7DixENOdcpkHshnyS3SKUtk3piyBQlZZVA4ZPJZ+E1KuVSqNcgJx6oAUJtLtzfEYBwgcZi6d3cL5gMh/qeBZQ0DYQQ==
    5hoZFgobTqrZF59znzBwBEnHkeOE9PgQnQgHEMiF7Og4FfXnlHcvl5dGRGyx1eyG6m9htzAIJzVlx6LR0tB1PbfRXfpXACI2cYPmoDFoLP0pAAwCOdOci471eu1e31tgNVBetA==
    +O43+/Wqgdf81zfwXS/7GHgFyovuBn449Fcx1EB50bPEpFnzXQOvQHmxsYFvVrp9t2ngFSgmOJ1soCteo+4Xs11CxpRcs8Lbnjts1hbwFaqsra7cPhXb1loC71M2lACVXChwCg==
    xHyKxjCQOB8SPGIY7OEolgtvClPKZXOlVhlW6vJ/9nFVSUUE7iCoWedNAd9oyvgAHjA8FR3nY+nV0SBvXv745uVzcProxemjX04fPz599LPF6hpMI93q9fdf/P30U/DX8+9ePw==
    +cqO5zr+958+++3XL+1AoQNfff3sjxfPXn3z+Z8/PLHAuwyOdPghThAHN9AxuE0TOTHLAGjE/p3FYQyxbtFNIw5TmNlY0AMRG+gbc0igBddDZgTvMikTNuDV2X2D8EHMZgJbgA==
    1+PEAO5TSnqUWed0PRtLj8IsjeyDs5mOuw3hkW1sfy2/g9lUrndsc+nHyKB5i8iUwwilSICsj04Qspjdw9iI6z4OGOV0LMA9DHoQW0NyiEfGaloZXcOJzMvcRlDm24jN/l3Qow==
    xOa+j45MpNwVkNhcImKE8SqcCZhYGcOE6Mg9KGIbyYM5C4yAcyEzHSFCwSBEnNtsbrK5Qfe6lBd72vfJPDGRTOCJDbkHKdWRfTrxY5hMrZxxGuvYj/hELlEIblFhJUHNHZLVZQ==
    HmC6Nd13MTLSffbeviOV1b5Asp4Zs20JRM39OCdjiJTz8pqeJzg9U9zXZN17t7IuhfTVt0/tunshBb3LsHVHrcv4Nty6ePuUhfjia3cfztJbSG4XC/S9dL+X7v+9dG/bz+cv2A==
    K41Wl/jiqq7cJFvv7WNMyIGYE7THlbpzOb1wKBtVRRktHxOmsSwuhjNwEYOqDBgVn2ARH8RwKoepqhEivnAdcTClXJ4PqtnqO+sgs2SfhnlrtVo8mUoDKFbt8nwp2uVpJPLWRg==
    c/UItnSvapF6VC4IZLb/hoQ2mEmibiHRLBrPIKFmdi4s2hYWrcz9Vhbqa5EVuf8AzH7U8NyckVxvkKAwy1NuX2T33DO9LZjmtGuW6bUzrueTaYOEttxMEtoyjGGI1pvPOdftVQ==
    Sg16WSg2aTRb7yLXmYisaQNJzRo4lnuu7kk3AZx2nLG8GcpiMpX+eKabkERpxwnEItD/RVmmjIs+5HEOU135/BMsEAMEJ3Kt62kg6YpbtdbM5nhBybUrFy9y6ktPMhqPUSC2tA==
    rKqyL3di7X1LcFahM0n6IA6PwYjM2G0oA+U1q1kAQ8zFMpohZtriXkVxTa4WW9H4xWy1RSGZxnBxouhinsNVeUlHm4diuj4rs76YzCjKkvTWp+7ZRlmHJppbDpDs1LTrx7s75A==
    NVYr3TdY5dK9rnXtQuu2nRJvfyBo1FaDGdQyxhZqq1aT2jleCLThlktz2xlx3qfB+qrNDojiXqlqG68m6Oi+XPl9eV2dEcEVVXQinxH84kflXAlUa6EuJwLMGO44Dype1/Vrng==
    X6q0vEHJrbuVUsvr1ktdz6tXB1610u/VHsqgiDipevnYQ/k8Q+aLNy+qfePtS1Jcsy8FNClTdQ8uK2P19qVa2/72BWAZmQeN2rBdb/capXa9Oyy5/V6r1PYbvVK/4Tf7w77vtQ==
    2sOHDjhSYLdb993GoFVqVH2/5DYqGf1Wu9R0a7Wu2+y2Bm734SLWcubFdxFexWv3HwAAAP//AwBQSwMECgAAAAAAAAAhADJSfrUKAAAACgAAABUAAAB3b3JkL21lZGlhL2ltYQ==
    Z2UxLmJpbgqJqWp8j4nLbq1QSwMEFAAGAAgAAAAhAJ3p0mC3DAAAn3QAABoAAAB3b3JkL2dsb3NzYXJ5L2RvY3VtZW50LnhtbORdTW8kOXK9G/B/KOhsjoJkkIxobM+CDJLrvQ==
    Nbzrw54W1aXqljClKqGqunsEw//dkfroj92dcWpmjLTpRkPKrCQjk3yPLyJIVup3v//xdrf6uD2ebg771xf2O7hYbfebw9XN/v3ri3//czd0sTqd1/ur9e6w376+uN+eLn7//Q==
    P//T7z69er87nE7r4309bD7cbvfnlZran159utu8vrg+n+9eXV6eNtfb2/Xpu9ubzfFwOrw7f7c53F4e3r272WwvPx2OV5cOLDwc3R0Pm+3ppPeV9f7j+nTxZG7z4zxrV8f1Jw==
    rTwZxMvN9fp43v74bOP275/ocLfd68V3h+Pt+qynx/eXt+vjDx/ujNq8W59v3t7sbs73ag7is5nD64sPx/2rJxPm82NMVV49PsbTr+caxzn3fazy3IsPd7w8bnf6DIf96frm7g==
    c1fc/lJrevH62cjHn2vEx9vdc7lPdxZ/HY71EZEvBuc8/hOMt7vHJ/95ixZmIDKZ+FxjziN8e8/nJ7ld3+y/3PgXdc1XnWvDywy4vzMQT9uXmQhPJi5P97dfhsanu/e/DuU/HA==
    Dx/uvli7+XXW/rj/4bOtSW5eYOuJLV8z+PTrHuZP1+s7Hcq3m1d/fL8/HNdvd/pEiv1K4Vs9ILCaRsnF9yqGV4fNG9Wc01fHXx2+OU4n+/Wt1nj1cb1TpaUmtWBLPiCiQ4rR1Q==
    5or1+nlz6eJyqrFZn7fvD8f7v639h+1+e1zvHgu9X+922+P987W73XqzvT7srrbH6frlt1bO93fbh4ecDp6rvH37Zrf516vn8p/LvN1erz/eHI7fnDxX2hz2Z1WYpzrfFH3/4Q==
    5uq52H+4mCS7mkx3ORnUtpkSojXJZWq+dQzM//lk5Zvuejoph6uHJ79Ti+qmrv7t9QVAjamGfvH8Ud2+W3/YnacrqUMr8HzlzVcfPRh5NH33p/P97kVYXH6uO3XAw03fHB+M0w==
    VOrB+PGpwDfG33yB48/bH5+766no+XvZ3Wx+WF1vj9vV+aCu97w9rtRznb97AOKx7OPdv+6gxz75cj6XdYG7J/SeqSX0HbNQlBYBeojCncdhXedMhXsxrYRqsBMZqhWMcEyp2A==
    SN7Tsqybg8VPsg6dL/lRef73s851j63VBJEEK1Hu4GoOrYqO/p4G0rqSpXSXnOk2FYM2a/zsJZjqeyO9VjDkZVk3B4sxtK6oAjimkAp1dCI55R5DDzVbwIxuHNYhO5bYgqFW0Q==
    IEY2pajgdfVeoSJDSbgs6+ZgMYbWlRBI+y2EpIFES4GgO/E+J4chBNsGiusskRMXDBZyBsmBUY+WDfScguLbM/aFWTcDizG0rnWBXm0pKQlalNyyDv0ivlOs0Po4rLOxsxIvmg==
    aiGrh63dsFgyoO1E28jFsrCHnYPFGFpnNaJuIabgIKM2m30i1XYUSg1rHYl1lqLFKZqrXT0sYDFs9YdVOeEcmwvols5h/3ssxtA66c7VwmBriBrrANdSuUSInkE6D5RNMIvjQA==
    bEKfWBeSVQ9biwnI3haXKoJflnVzsBhE64rXQRVDdrljTZWKAkBkU6MC2eM4rEvYoBbHBlJTD6shumYTHgyRr60x2hhhYa2bgcUYWtdy7lSnOVNqqD9ydQAC0VHphbGMwzoVDw==
    1IgOTBLWbKKLNyUTmCLZ1gIpeVp4vm4OFmNoXfPJY/MwTQthE8sEzsfeSvBcWpZxWFcSQKToTHbSjOaI0eQgbLxU3zipi+0La90cLMbQOpQkpXuS0DRsjY2okEuRNKrtGlv4cQ==
    WOcz5qgtNbU5q6yLxWTr1ddyjL6nFDRiX5Z1c7AYQ+tiDdCm5b6QAKv4HKIOr5pzTl6k5HFYxyHmUkozmkyoh0WxJhfwpuaQUoaeOpZlWTcHizG0LiTn0QGmpuMrB9a41druQg==
    19SOwA+0NgFQuDmeaFaUdSkEkzVFNKlNoVN2VvLCHnYOFmOwrjjPJE2kWW1ptZlsA2w9NZCW00BrExwwcQJrpIioX1WZyzB52OC71ahJFWbptYkZWIzBOvU7UgWdcLPTingW7g==
    kSl37SE9oYHiOtB2JdW62CAarJaVdXZKZLvGUUWzWC/Lsm4OFmOwzjV9WtaQJjvEArFgLaE6qxGF6EgbKK5zJYkHb01zqRvUOMlwm46IfQo9llgXniWeg8UYrOvgyKEHbSGihg==
    2QzkobIjqharH2i+rsaukV2MhpRj0+p/NYXz5HBzdtDAU1xY6+Zg8ZOsoxgq+l/MuvbAs/X+fvXUn6vz9fq8uj98WH1aT2eH1XF7t12f/2V1s9/sPkxft1gdzkrTzxWm38fD7g==
    9N3qL1prs96v1rvTQYuftsfJ3M3puchqfTx82F+tztMG5dXx8OmkpVaH49VE9ecbre6000+rw7vV+rHg/8wAqNN2SwwpeipYfMlVbGqh0zSjVtpAslsrMksh46LTAZBIExtAMQ==
    vnZXQ6mNJC07AOZgMYbsguvSVZCcbYQckSVRpTrt+FHXw3Yc1ilDyFlGZV0vBiF2kzuIkZg4VmudxYU308/BYgzWWUHEAMwVEmr7qFfKjb3Y2jO5gba/9KLgKUeMCINBbaOhmA==
    UT1+75aZbLALTx3OwWIM1sUas2o5pZgjagjNPeWgauBLz11zzHFYF1rLROSMOthsMCMazVbFtOJbBgqWlt50NQeLMVg3zZlFizYhdB1fXEjj/Gk/LXrVejvQJE6XWNjabjxZpw==
    WkfWUI/BVGHkiYQuLZzYzMFiDNY5xGpLJRbRHM7lkqRAQwjUXFdtH4d1riQVEqgmYKwGfUuGKhajn3ZxwjbXtvAkzgwsxmBdiozCwceoELge2EOx1CBnhJLsQF+SdJyhNUmPOQ==
    BPreTAEkEytp3KSqV8PCGxHmYDEG6zyWabmbNIzwaG3KPYl4Ty66ANkPxDoQVTQNzg2QEg6ZlXXsqwGnAXvIKiYtLMu6OViMwTosLYWE01eQNaIgFYRQNJVKAVTtcxtoI0KGNA==
    zZ0EE7oGdxi7U63rbDB5pVzEgH3hLw7NwWIQrSsU2xS0xtY1nu7EzJI1npDQmdJI2QTGxLYGQ6kVg1WPSkRnfEy5RrGutYU3IszBYgzWQbUucW5FXEFwnV3SYJtj0uEvnHAc1g==
    +Vxtj+phXWp9evlFN+ScGA3au6+QbGgLa90cLMZgnbXtIXub3reAFDWFAo1fydpMbBnrOKwjBGQryrpIqnXRVSUcimmdm421R5CFWTcHizFYp51dwWkQQbUhQi4RclBxt0UjjA==
    OtIG0wAhR/2vXAuawwZ1rqWUakS1pULtudmFWTcHi59knfUuWPk/wjpRKU8VI04Lz2RDhiIxhWk3rQ8acY/DOo3PW7a1mWmHidFme1OaeBOgYYJClXDhV67MwWIMrdPWhE6Npw==
    F2eh7zkny9N22hw7EZaB1mGD95qygjPOt2aQcjZEvRuVv5hQGkC3C2+mn4HFGKyzYNE3Da3DNEWZQtFxVTomjk6jnTzQ2kSIKnYNVeZ6nLY1k50205PRAK8jaR6LcekXOM7AYg==
    DNYV7bcUcuoiUfseuSfQn7XWJEn8QPvruhQLQbKxGiIZFALDtuH0eqleXBOWuvAXwudgMQjrQNN0UD331aMAENbEQVxF59i1gXLYPEXqHbvxYFXwhL3JPpJJjB69CKelv642Bw==
    izFYRyk66TkCtIykCsChgY8avmqybmmgFbFYY2MJyVCOxaDTlIIjRNO8FS4927z0i37mYDEG6yI6ph69BaqoTc1VgiTPNdaimftA++tcwRySnfYSMxvNFKvhANPaRCUGTR9Ljg==
    C++vm4HFIFongavjZu20xSxXiup6grWq74TBDcS63lptqEmrOjJlXSjJMGY2lcRBc16KX3i+bg4WY7BOdHx5zDlmFswllem1rdZhccixjrQ2YVtmF8vDXs4ph2XlH4IYxapw6A==
    XR3Zy+O6ViO19I9Y9y0fH1j39NFPsm4OFmOwLvoukUrkolG1COTuigennijWSjhSXJdi8c4n02F6qVmUrtmE90ayjSLNs7Mv39X5m7JuDhZjsK736EJNLiRB1CBWAwhb2TrtgQ==
    AHWkbybCNNlPxRkbgAwyaV6hVFMPa2XawZsDvHxt4jdl3RwsxmBdYg9BU6XEfXpzpi0auUaNeWy2DWIdSOuKphKaGjYT3BTX+SyqddhNytkl9b2B08vn635T1s3BYgzWPfXTVw==
    z/RXYykgWI8+DqR0VVk3/eGBVjhpLmGbKdkHU1xmjaRq5/hy//r47x9xjqzn7B458C07irci9hezoz3w4f/j6wJ+hqg4UNIrtgapQTnqpnfvgWVTbBdj+7QFRKg6ePnC7QJEfQ==
    lDFt/3l99xuo2Zfj08PJ3/5F0e//CwAA//8DAFBLAwQUAAYACAAAACEA0nc7M/UAAAB1AQAAHAAAAHdvcmQvX3JlbHMvc2V0dGluZ3MueG1sLnJlbHOMkDFPwzAQhXck/oN1Eg==
    I3HaAaGqTocWpA4sNN2yHPYlcevYlm0g/ffcUolKDEynu9P73tNbb+bJiS9K2QavYFHVIMjrYKwfFBzb18dnELmgN+iCJwUXyrBp7u/W7+SwsCiPNmbBFJ8VjKXElZRZjzRhrg==
    QiTPnz6kCQuvaZAR9RkHksu6fpLpNwOaG6bYGwVpbxYg2kuk/7BD31tNu6A/J/LlDwuJpSDrTUtT5DsxG9NARUFvHTFdblfdMXMd3Ql1+Pg+dTvK5xJid7Assb0l87CsD+go8w==
    vHpVJpT5CnsLhuO+zIWSRweyWcubspofAAAA//8DAFBLAwQUAAYACAAAACEApEfKA4UDAAAHCgAAGgAAAHdvcmQvZ2xvc3Nhcnkvc2V0dGluZ3MueG1stFZLj9s4DL4X2P8Q+A==
    vBk/Yjupt5kiM4n7wKRd1Ollb7ItJ8LoYUhy0vTXl5atcYpxi3SLnizxIz9SFEn51esvjE6OWCoi+NLxbzxngnkhSsL3S+fzLp0unInSiJeICo6Xzhkr5/XtXy9enRKFtQY1NQ==
    AQquElYsnYPWdeK6qjhghtSNqDEHsBKSIQ1buXcZko9NPS0Eq5EmOaFEn93A82KnpxFLp5E86SmmjBRSKFHp1iQRVUUK3H+shbzGb2eyFkXDMNfGoysxhRgEVwdSK8vG/i8bgA==
    B0ty/NkhjoxavZPvXXHck5Dlk8U14bUGtRQFVgouiFEbIOGD4/AZ0ZPvG/DdH9FQgbnvmdVl5NGvEQTPCGKFf40i6ilcdWb4iyVS9JqUdNADySWSXcH1+WBF8m7PhUQ5hXAgLw==
    EzjaxETn3EKVHwk+TeCDwA1vCanjtvISV6iheofyTIvaaswDr4MP5/qAuSmv/6BxLB4GUYcXByRRobHMalTAJd0LrqWgVq8UH4S+hyaRcIe9hWmZdtUonG4e0Fk0+gLJunYEBg==
    jhgc5bsW24oS+gVMJbk+562Bica3QY86EjA+JCnxrk1hps8Up3CYjHzFK16+b5QmwGgy8RsR/CwAyDN4/giXvjvXOMVIN5C2P+TM3ExKSb0lUgr5jpcwAf6YM1JVWIIDgjTeQg==
    uREpTibPbzEqYWr/pl/3sqzgDSiVXXwSQltVz5un3uaur+wWHZBg5XnpYgwJPX8VxT9C5sEY8mM/C3/2cjVqs4i8OA3HkNUqXHizMWQdz9dROoZs5vF8No6s48VmPopsAn9h/A==
    uE9ZZEn7Hvwr7aptiQnrLO4RyyVBk237YritRi4f7wi3eI5hcuFLJGtyC06nHaBgEtEUZogFTNpYUhJVr3Fl1nSL5H7g7TXkqBTm2fsnrgJKDss3UjR1h54kqrtStyp+GPaWhA==
    6wfCrFw1eWatOMzaC6jh5cejNHka0nNKNJSsGRkPyJS+0cV8+jnrW4PKrC1rvEV13XVHvveXDiX7g/bbgtawK+HHwmzyfdBjgcGCDjMbVLQnA+1+McgCK7vQm1nZbJCFVhYOsg==
    yMqiQRZbWdzK4DXAkhL+CI1ql628EpSKEy7fDvgzkX1uCgI3np1ZPrwSf3cYJQomRw0PihbSYv8YzI/MS6N3UCiPkLtPuLpDCpddrdo/uNtvAAAA//8DAFBLAwQUAAYACAAAAA==
    IQCD0LXl5gAAAK0CAAAlAAAAd29yZC9nbG9zc2FyeS9fcmVscy9kb2N1bWVudC54bWwucmVsc6ySTUvEMBCG74L/IczdpruKiGy6FxH2qvUHZNPpB6aTkBk/+u8NwmoXl8VDjw==
    8w7zvE8gm+3n6NU7Jh4CGVgVJSgkF5qBOgMv9ePVHSgWS431gdDAhAzb6vJi84TeSj7ifoisMoXYQC8S77Vm1+NouQgRKW/akEYreUydjta92g71uixvdZozoDpiql1jIO2aaw==
    UPUU8T/s0LaDw4fg3kYkOVGhP3D/jCL5cZyxNnUoBmZhkYmgT4uslxThPxaH5JzCalEFmTzOBb7nc/U3S9a3gaS2e4+/Bj/RQUIffbLqCwAA//8DAFBLAwQUAAYACAAAACEAiQ==
    jTcM0AgAAJIhAAARAAAAd29yZC9zZXR0aW5ncy54bWy0Wsly40YSvU/E/IOC55GJ2gFOqx2FbdyO1thhype5gURRQjS2KIBSy18/CZBoLf3kaNvhk8B6VVm5vMwsoPTu+89NfQ==
    ce/8UHXt1Yp9F6wuXLvvyqq9vVr9epNfhquLYSzasqi71l2tHt2w+v79P//x7mEzuHGkacMFiWiHTbO/Wt2NY79Zr4f9nWuK4buudy2Bh843xUg//e26KfynY3+575q+GKtdVQ==
    V+PjmgeBXp3FdFero283ZxGXTbX33dAdxmnJpjscqr07/1lW+G/Z97Qk7fbHxrXjvOPau5p06NrhruqHRVrzZ6UReLcIuf89I+6bepn3wIJvMPeh8+WXFd+i3rSg993eDQMFqA==
    qRcFq/ZpY/mVoC97f0d7n02cRdFyFsxPzzVXf0wA/0qAHtwfE6HOItbDY+M+L4KG+ltccoI+Vjtf+BPhzv5o9psPt23ni11N6pBfLsi0i1m71Xti+W9d11w8bHrn9xRqSpEgWA==
    rSfAu6a7dz9T6nRtUX9oT7sRnZ6haTE625Y3VePmUQpKd9iONEoih97V9Zxn+9oVpMrD5tYXDWXIMjKvKcaxIOXLG9f09bTSb6ryauU/lOw0oXSH4liPN8VuO3Y9SbkvyCWGnw==
    9bx77O9cO2v2P0rhBZdcnfD9XeGL/ej8ti/2pE7StaPv6mVe2f23GxNKV09sOkss/fau6F162nh4/67bDNPAWZPh4n7jPpOvXFmNVD76qmyKz1crHshokrBGIh42h64b2250Pw==
    ++e/SI/J3Muzsa+GZxvXr9e6tvzqxys5L0cXMS8WnmrU09P2VO9oSVs0xJUXNey6K90UwaOvvp3U04LZyWyJBdyIiOR9VbqbiaPb8bF2OcVoW/02cevH4zBWJHEO8F/Q4PcUIA==
    +tDOP1FW3Tz2LnfFeCQ2/E2bzYTL66q/rrzv/Ie2pLz72zarDgfnaYOKMuuamFj57mH28w+uKCm3/+K+6+c0oiZbzkyfHn4hxi5Tg0Al3IjkXFgIfUICpk2ylJyXiOCZnhPqaw==
    RJkshogJsizEiGTq7KtXSCilFRCxWisLkVRZnUIkCwzLEcICEUoNEWYiAe1hXKdYAyakNdAeMjMx0B6mOUuhR1lMGsD4sJQlGceIDgMDkZzx+JzyL5Gp04bQHh6YWECtuVCJhQ==
    DOFSxUEGEc1CA33NNdcR9DXXOkoxYkRsod94pHmINbA8SiEPuBUhh77msY4xQ3jGrYKIEMZw6DehVLY0yVeIkYJhaaGQEdRNRJKshYgVLIU8ENa8kcEiZqnCSMp4AKMgUhmH2A==
    nowzA7Ne5MZg9sqJ89AH5JtIwdyWEXFRQsTKFGejjDnP8T6xNBneJ9Z5BvNHJjqwGMm5FNBSxbQOYEwVl3kGdVOSswTuo6SIGOSbUvyN+qa0SBNoqTKCJTBLVGiYgqxSkcoNXg==
    E9FGMBuVDaIIRu7tzqRyrjBHVa6y5A1ExwmUpqnCcVj5NAusgLzWjNsYWqo5D3IYBU1FMcX7yCDEVVkbzhXMOW2MTfGakPyGdQtFksAo6FBmuG/rKDA5ZK+23Bq8JhEB7mY6kQ==
    KoTZqKmGRNjXqZYWa51PPQMhhlEywGgbpjMO+UbHEOIIRJQwMYyc0UFuYX0zWjFsj6GkxzXRGGpnbyE2xfZERgSQB8YGlkMemJiqJbY0ExznXEg9EK8JmUo5rAchMxmuYiGf2g==
    PUQEHRBgfOgwSB0II5RY0FJCsgB6NFRCZHiN0jHO7dDqIIa5HSYiCiCvw9RIA+MTZsQEWHvDnOoO1JqSkadwn4hTZ4AcjYRIcXWJpLAMRi6SSsSQB5GiTocRzSLMg4jsDGBMow==
    kEcKZkkUMY6zhBCjYD2IJoPwPpEJFZYWyxCf46NUUVnGCJ0CsKUZlRcsLeOKYa1zznB8bBDE0RsIszGssDaQYQbjQ60swayyksf4VGONzgXMYEt8xyd8S+dRnFk2Mhwz3uYsSw==
    30CkVDDrY3rPsVC36WCHTxux4NRnIEKHaOzRWAqDO22sqMrjNZreQyETYyp9CsYnDumEAn0QRyyxMOvjSNP5BSIJFxxbmnKF3+fiVCjcaYke0RtRyHSMa3ycBzmDutHBLmEwSw==
    EqFzBjmaSNoKejSRLM2gPYk0PIC6JYoO6zByiVJvnHcSqwU+qSaxCSyMXJKyOILSUnpnw9mYcnp/h/ak1LZT6NGUkxMgR1MCErwPlXgN85SoazXkW6qn8xhEDLf4mwMhWYB9YA==
    lMV9O7XEHayBVWEAuZPG8o0TSproHJ+R0lzQRgjJGGMJjHbGeWxglmQySHDkMslYCH2QSTrwQI9mSua4O2daSfzFLNMmiPCaKOC4M2URneSh3zLLpcaWWm4slkYxYDCzsoRFuA==
    m2WJTEKYp1kaCIPtyXiCvw1mmRI5XJMzyfCXhZxe2gyMDzXnCDOEGmOOv35Rywo5lqa1xd8g85DZDPotD2WYw/jkoZYa5nZuZaqxpTG9uGF7YpHit8M81fbL5dNLJGPhGxpMpg==
    wvwhJMNfFvLcpOEsbX2Chvfvms10vTndi5yepguIi+a0Iimana+Ki+vpAnQ9zdj5T3HVLvjOHTrvniPb424BLy9PwNAUdZ37Yr8As6HNpqyGPnWH+bm+Lvztk9zzDA9HS3f48Q==
    i6zp5s75//ju2J/QB1/0p4uFZQqT8ryyasePVbOMD8fddlnVFv7xGXRsy5/u/eynJ/c8bMY718wXNB+L+aJhnuvay1+3J2fva7+dLhHcddH3p7uI3S27WtXV7d3IpuuDkX6VhQ==
    /zT/2N3yM8ZnjJ+w+Uexnyyj2eeHpzG+jD2bJ5Yx8TQmlzH5NKaWMfU0ppcxPY3dPfbO11X76Wr15XEaP3R13T248ocn/KuhkxPm68I/e394nl0Xj91xfDF3wqbJ/UsJZTEWyw==
    hcyLxTPFX+kyXajuK6Lj9rHZPd2D/uukeF0N49b1hS/Gzi/Yv2eMyU3Z7T9QJtHTiYuaXgaX76tMzVet4w2R/BPF/Rd3iIvBlac8W/6Z4v3/AQAA//8DAFBLAwQUAAYACAAAAA==
    IQC04JQZ4AAAAFUBAAAYACgAY3VzdG9tWG1sL2l0ZW1Qcm9wczIueG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJyQwUrEMBCG74LvEOaeTZMNbQ==
    XZoubhdhr6LgNZumbaBJSpKKIr67KZ7Wo6fhm2Hm+5nm+GFn9K5DNN4JoLsCkHbK98aNAl5fnnANKCbpejl7pwU4D8f2/q7p46GXScbkg74kbVFumFwvZwFf9QPjp7IrcFXzDg==
    c14z/FhWHFecMbqnlPK6+waU1S6fiQKmlJYDIVFN2sq484t2eTj4YGXKGEbih8EoffZqtdolwoqiJGrNevtmZ2i3PL/bz3qIt7hFW4P5r+VqrrPxY5DL9Amkbcgf1cY3r2h/AA==
    AAD//wMAUEsDBBQABgAIAAAAIQAOrXrPAAEAAFABAAAYACgAY3VzdG9tWG1sL2l0ZW1Qcm9wczEueG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    XJBBa8MwDIXvg/2H4Ltrp0vSNMQpW9NBj1s32K0YW2kDsRVsp2yM/fc526k9iU8P6T2p3nyaIbmA8z1aQdIFJwlYhbq3J0He355pSRIfpNVyQAuCWCSb5v6u1r7SMkgf0ME+gA==
    SWKjj3XfCvJdrMvtblcsaZvlGc1WeU6fylVG021aPLY83fF1+UOSaG3jGi/IOYSxYsyrMxjpFziCjWKHzsgQ0Z0Ydl2voEU1GbCBLTkvmJqivfkwA2nmPP/Tr9D5a5yjTa4XZA==
    crYyvXLosQtUf1kZyVMrL8zBiC54dvg71enjQQ7gjy8TBmDpA88YYU3NblxmvvpC8wsAAP//AwBQSwMEFAAGAAgAAAAhAHqocnTFAAAAMgEAABMAKABjdXN0b21YbWwvaXRlbQ==
    Mi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArI9BasMwEEWvImZfy80iFGM7BJIsk4LbrLqR5bEtkGaMNCnO7StCmxN0OfzH+3/q3Rq8+saYHA==
    UwOvRQkKyfLgaGrg8+P08gYqiaHBeCZsgBh2bd1XHd+ixaQ69GgFh07uPsdf+/d951aZj4OTrLyMo7N4Ie8IizV5UA/wbEKGMwvq+te9BZW3UKr6BmaRpdI62RmDSQUvSDkbOQ==
    BiP5jJPmh/jA9haQRG/Kcqt713vHUzTLfP+V/YuqrfXz4fYHAAD//wMAUEsDBBQABgAIAAAAIQBcliciwgAAACgBAAAeAAgBY3VzdG9tWG1sL19yZWxzL2l0ZW0yLnhtbC5yZQ==
    bHMgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjM/BisIwEAbg+4LvEOZuUz2ILE29LII3kS54Dem0DdtkQg==
    ZhR9e4OnFTx4nBn+72ea3S3M6oqZPUUDq6oGhdFR7+No4LfbL7egWGzs7UwRDdyRYdcuvpoTzlZKiCefWBUlsoFJJH1rzW7CYLmihLFcBsrBShnzqJN1f3ZEva7rjc7/DWhfTA==
    degN5EO/AtXdE35i0zB4hz/kLgGjvKnQ7sJC4RzmY6bSqDqbRxQDXjA8V+uqmKDbRr/81z4AAAD//wMAUEsDBBQABgAIAAAAIQB0Pzl6wgAAACgBAAAeAAgBY3VzdG9tWG1sLw==
    X3JlbHMvaXRlbTEueG1sLnJlbHMgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjM+xisMwDAbg/eDewWhvnA==
    3FDKEadLKXQ7Sg66GkdJTGPLWGpp377mpit06CiJ//tRu72FRV0xs6dooKlqUBgdDT5OBn77/WoDisXGwS4U0cAdGbbd50d7xMVKCfHsE6uiRDYwi6RvrdnNGCxXlDCWy0g5WA==
    KWOedLLubCfUX3W91vm/Ad2TqQ6DgXwYGlD9PeE7No2jd7gjdwkY5UWFdhcWCqew/GQqjaq3eUIx4AXD36qpigm6a/XTf90DAAD//wMAUEsDBBQABgAIAAAAIQDrK/TI6RMAAA==
    FqMAABgAAAB3b3JkL2dsb3NzYXJ5L3N0eWxlcy54bWy8XduS2ziSfd+I/QdFPc0+dBcA4tox7gncuO2Yvni63NPPLInl4loSa3Vp2/v1m6SkKpUhigIFOhxR1u0cJJF5EpkgKQ==
    /f0fnxfzyV/lal3Vyzc3+Ht0MymX03pWLT+8ufnjff6dvJmsN8VyVszrZfnm5ku5vvnHj//5H3//9MN682VeridAsFz/sJi+uXncbJ5+uL1dTx/LRbH+vn4ql/DmQ71aFBt4ug==
    +nC7KFYft0/fTevFU7Gp7qt5tflySxDiN3ua1SUs9cNDNS1dPd0uyuWmxd+uyjkw1sv1Y/W0PrB9uoTtU72aPa3qablew0Ev5ju+RVEtn2kwDYgW1XRVr+uHzfdwMHuLWiqAYw==
    1D5azF8IWBwBCQj4uoyjYHuK2/WXRfn5ZrKY/vD2w7JeFfdzYIJDmoBVk5b45kfw5qyeuvKh2M436+bp6t1q/3T/rP0vr5eb9eTTD8V6WlXvwQqgWlTA+pNerqsbeKcs1hu9rg==
    iuM3/f615v3H5oMnkdP15uhlU82qm9tm0PX/wZt/FfM3N4QcXrGNEa9emxfLD4fXyuV3f9wdG3P00j3wvrkpVt/d6QZ4uz+23f9HR/z09bN24KdiWrXjFA+bEmIVc9SQzqtGGg==
    hKnDk9+3zSQX2029H6Ql2P3/THsbTDqEMAT03U5X8G758HM9/VjO7jbwxpubdix48Y+371ZVvQLtvLlR7Zjw4l25qH6qZrNyefTB5WM1K/98LJd/rMvZy+v/ytv4378wrbdLeA==
    nAncBsJ8PfOfp+VToyZ4d1k0Pvm1AcybT2+rl8Fb+P8eyPDeE6fwj2XRpJQJ/pqiNT+KgjSI9dHRnubcfnXs7aeiBsq+1UD0Ww3EvtVA/FsNJL7VQPJbDdTSjDlQtZyVn3dCDA==
    hwlY+3g61BjN0yG2aJ4OLUXzdEglmqdDCdE8HYEezdMRx9E8HWEawbOpp11ReBTsWUe0n+ftXyOG8fYvCcN4+1eAYbz9CX8Yb39+H8bbn86H8fZn72G8/ck6nndXak3egsyWmw==
    q1X2UNebZb0pJ5vy8/VsxRK42j4rDV+z6JWrJAeZgGaX2fYL8dVs06J93h8hrUiHr+ebpqOb1A+Th+rDdgXt+bWGl8u/yjk0ypNiNgO+hISrcrNddczIkJhelQ/lqlxOy5SBnQ==
    jrTpBCfL7eI+QWw+FR+ScZXLWeLpOzAmSQrPAQ3982MjkipBUC+K6aq+3rS6SJYffq7W189VQzIx2/m8TMT1a5oQa7mu7w1amutbg5bm+s6gpbm+MTjyWaop2rMlmqk9W6IJ2w==
    syWat118ppq3PVuieduzJZq3Pdv18/a+2szbFH9cdeDL9+7svG52xq+24676sCygALh+udnvmU7eFaviw6p4epw0G9OnaY+POXYcU8++TN6nWNOemVLV9W2IWDjqarm9fkJfsQ==
    pRLXM18ieT3zJRLYM9/1EvsFyuSmQPspTT9zt73fnBRty3SRaO+K+XZX0F6vtmJzfYS9CCCvVutkMjhNmyCCf23K2cadKTLfi5XXG/bCdb2svs5KSc3bUyawcl5PP6ZJwz99eQ==
    KlfQln28mimv5/P6UzlLx3i3WdW7WDuWPGldcpHk/eLpsVhXba/0iuLypf5wTn3yS/F09QG9mxfVMo3f/HeLoppP0lUQP73/5efJ+/qpaTObiUlDaOrNpl4k49zvBP7tz/L+vw==
    0hiooQlefkl0tDrR9lBLZqsEi8yOqZ4lYoIys1pWSdbQlu+f5Zf7uljN0rC9W5W7y1g2ZSLGu2LxtCs6EmgL8uInyD8JqqGW79/Fqmr2hVKJ6n0SsqNtw/X2/n/K6fWp7td6kg==
    ZGfot+2m3X9sS90WnY7u+jLhFd31JULrTVgemvhNcLCv6K4/2Fd0qQ7Wzov1uuo8hTqYL9XhHvhSH+/1zd+er57Xq4ftPN0EHgiTzeCBMNkU1vPtYrlOecQtX8IDbvlSH2/CkA==
    afkSbMm1fP+9qmbJnNGSpfJES5bKDS1ZKh+0ZEkdcP0VOkdk11+mc0R2/bU6O7JEJcARWao4S7r8JzrLc0SWKs5aslRx1pKlirOWLFWcZW5SPjxAEZxuiTmiTBVzR5TpFprlpg==
    XDzVq2L1JRGln5cfigQbpDu2d6v6obm/oV7uLuJOQNnsUc8TFts7ulRO/rO8T2Zaw5XSrgQ7osV8XteJ9tZeFpwW+fratT5YeyfH1Sa8mxfT8rGez8pVxzF1Y6FfvtvdlvG1+Q==
    rRkXbXv+XH143EzuHp93+49pOOpFHhr2V7D+AU/NOT/cz3IK9ks5q7aLg6HhzRQ8uxzcRvQrMO0Hv1QSr5DsQmQ4Ju9HvlTJr5DiQmQ4prwQ2er0FfKcHlyx+ngyEMS5+Hnu8Q==
    OoJPnIuiZ/DJYc8F0jPyVAiKc1H0SioTPZ02ZwtC71ymmW78ZeLpxseoqJslRk7dLBfrqpvinMB+L/+qmpU9Jmm24z1fPRHk/baIvihz/mtb7/btX51wuvymrrdQOC3X5eQkTw==
    dvmJq1dZpnseL0433RQX551uiosTUDfFRZmoEx6VkrpZLs5N3RQXJ6luiuhsFa4IcdkqxMdlqxA/JFuFLEOy1RVVQDfFxeVAN0W0UEOKaKFeUSl0U0QJNYAPEmrIEi3UkCJaqA==
    IUW0UMMCLE6oIT5OqCF+iFBDliFCDVmihRpSRAs1pIgWakgRLdSQIlqoA2v7TvggoYYs0UINKaKFGlJEC7WtF68QaoiPE2qIHyLUkGWIUEOWaKGGFNFCDSmihRpSRAs1pIgWag==
    SBEl1AA+SKghS7RQQ4pooYYU0ULd3Wo4XKghPk6oIX6IUEOWIUINWaKFGlJECzWkiBZqSBEt1JAiWqghRZRQA/ggoYYs0UINKaKFGlJEC7U9WXiFUEN8nFBD/BChhixDhBqyRA==
    CzWkiBZqSBEt1JAiWqghRbRQQ4oooQbwQUINWaKFGlJECzWkOBef+1OUXZfZ4/hdz84r9i8/dbU36vfjW7mPqbLLqQ5WdXNdfi+CqeuPk5M3HmZtv3EZSXU/r+p2i7rjtPoxbw==
    e0lE1InP3+z5O3yO2a/80qX9vRDtOdOAnF6KDPZU6LmQP0YGTR49F+nHyKDqpOey7zEyWAbpuaTb6vJwUQosRwH4XJo5AuMO+LlsfQQPp/hcjj4ChjN8LjMfAcMJPpePj4Bs0g==
    JOev0ezCeeLP15cGDOfC8YhBdDOcC8vQV4d0HArjUqd1M1zqvW6GS93YzRDlz06aeMd2U0V7uJtqmKtDmcW6erhQuxliXR0yDHJ1QDPc1SHVYFeHVMNcHSbGWFeHDLGuHp6cuw==
    GQa5OqAZ7uqQarCrQ6phrg6XslhXhwyxrg4ZYl195YLcSTPc1SHVYFeHVMNcHRZ3sa4OGWJdHTLEujpkGOTqgGa4q0Oqwa4OqYa5OuiSo10dMsS6OmSIdXXIMMjVAc1wV4dUgw==
    XR1SnXN1u4vyytVRHj6CxxVhR8C4BfkIGJecj4ADuqUj9MBu6YhhYLcU+urg87hu6dhp3QyXeq+b4VI3djNE+bOTJt6x3VTRHu6mGubquG7plKuHC7WbIdbVcd1Sp6vjuqWzrg==
    juuWzro6rlvqdnVct3TK1XHd0ilXD0/O3QyDXB3XLZ11dVy3dNbVcd1St6vjuqVTro7rlk65Oq5bOuXqKxfkTprhro7rls66Oq5b6nZ1XLd0ytVx3dIpV8d1S6dcHdctdbo6rg==
    Wzrr6rhu6ayr47qlblfHdUunXB3XLZ1ydVy3dMrVcd1Sp6vjuqWzro7rls66uqNbuv306geYGu72J87gw5svT2XzHdxHN8zMdt9Buj8J2H7w7ez5h5IacGPJZP+TVPuXW4P3Jw==
    DHcjtsBwqOkjjDXdf3tSx1D7b0F9vo2n/Q7Urwfu+KrU1pCXKTh8ej+lL6dCd597ddrzrN2bZsrP2Ny65Owc7bzWZaDah2GfhWDP/Xz3o13w4O1yBgSf9j9YtbN09rnYUcH7tg==
    nM9/KXafrp+6PzovHza7dzFqb5r/6v373fe/deJXbaLoJLh9bczu6f6Hwzrme/eN8Psz2J0h2ajhxHS3l1NcO9MXxvCzNUf3+ra3+n5tVnAv8G5mCxjtt0bfx1H9OvTjDmS1rg==
    mqBoP4KQxJnS+4S//7G7aZM1Dp+QqPm3d9LhF+M6jvtVmphu1xASbUb52i9YeusM9SJjlFJCJefEeWJwBq97IoKp6QWcODCRI28Ohl9pMFN5JmmWKekFzXKqreTWc4Ryxq3KVQ==
    YHAvYGSDSZ5R751AXFrqpNQ5Ik4z76zPaS7CGe4FjGywUVoSJZkwMqfEWi10zlnOnMaIakoCg3sBYxvMmHQwHhMQj14wiXJis0wLQhlj2IcG9wFGNtjnFuUOGyOEpZha7bXzzA==
    2CyX3CGfBwb3AkY2GEsH43HBCNIUjFGZkOBnaqXw1LnQ4F7AyAbbnBBnFMKOcUo5Us44ZTjimUI2V6HoegFjz7DJYJY400Tn1AknjSFCSiy8NEhnNJzhPsDYMax1Lh2FjC89hQ==
    P9oRhCziRJrcKGrCGO4DjG1wJiCvZqjJpNRbrCQiGc+9YZkyXtvQ4D7AyAZTK6yBtcsyD8LhXkojieASdJVDiGaBwb2AkQ3mjiHfVANMIOpsphmH+XJaa5FZa3RgcC9g7FpCkA==
    jBJEhYcJ00yBcjDOCawMFJydhStdL2DslY5AGWO9tR7D+A5riT2C/Co8sl6LEytdH2BkgxXUWM5CUaA8pljnGiourqCkgTHgiQwM7gWMbDAsV5JkoCGtMoqhWsSwHmgN6tc+ww==
    IiwvewGji45g6OMyWLtg4VJeCaZF7nJBm/U2QydE1wMY2WCNtbI4Q02BSCW41gmScyhwWSZh1Q1juBcwssEyowJ867AkhlrvQVMOSlzjwd2W5eHS3AsY2WCicMaUyghGAixBCg==
    WwZ/CNPSQnbd/cL2q46jDzB2SCAYhNLGx1AIZMhAgnJGQoEjlFbIhSHRBxh9hjMmmRPUMUlzorTAzGAMpW3urSL8xAz3AEY2OOPMKskRlgp6d+2UFR4qGcxyKRyXYR7uBYw9ww==
    XmZe5dRoQqlB3FBnGGQuKBAsLGFhLdELGNlgaNIlgfQJ41IKbbCCFIucIlI6TF0W1sO9gJENdlDIOsoEz6QBDRntLDQP4N/Mwug+nOFewNhLM8ltzmHasJdUcQohKZ10TfsOvg==
    V2Fa6wWMbDC2lFJIpMo1aZVJmTupvcosdrmW5ETX3AcYvZbgGvwqBdecgnJULjQjPM9MrnNjTtUSPYCRDYYuzHOoEwVFOUyYMtJo3ezmUOgjIHedaEJ7AGOnNQplgXFSWQuqJw==
    2kDHhjxFTHqSg5/DtNYHGNlgwRW1imWcQ+9OcqYgYWEJ+VRTZAQO6+FewNgrHTVNFykhGqEex0LnwlqozwknDOksNLgXMLLB1HjBBG12pyEwJdQGzEAeEAxaYqx92IT2AsaeYQ==
    I7lvZMM9LFsil0opqyEsobZVUpyoJfoAYy8cDhOoC72xUI/DoqCIoNwpLnKoDZQIC/hewNgLB/YKa+ebEwBUctA/AgVJDO27woqG9XAvYOzihyMHy6wk0nlKkTYcaQaOxgYC1Q==
    ndhI6QWMHcMgG8pUsyetqJKsmSrKGUVWY29PzHAvYGSDLSdeawOdGoE2EoouiSy0wVoJjQkWLDC4FzB2LZExhJBBCCQD61amISiNo5lVCpHMh7uXvYCxZ1hjhLOMAyuHZEplrg==
    MujkoayxIH4dLhy9gLFjmDmJc044g2oxh8ZSGM200wIWYERNWEv0AsY2WDOUGaugsfTUOqi+oBr3Te/g8tzwcOenFzCywcZmymiTK6gKoEGzkmCDodPBRjY7ZuEpg17A2OUlgg==
    1lEQ4r2y1Npc5QgmjWqSKUX5iSa0FzCywQrqcVA3VLZQzeQ0N0QzZ3KGLPyFRBDuD/cBRjZYKygGMHeOgMozoiSxmVDgZEvbyjzcquoDjL5wUJZD/kSIQIvmGXQ8zmcYW6kzZg==
    RJiHewEjG+w9dOcWxsLQ5yjNNTxDzvCcWswwD2uJXsDYxQ9uriPxTDjSnGVTRlDFoR4jznssXFhe9gLGrocz6HGwy4m3GfWgcmd0niGaYc81deHuZS9gZIMdVACcQR2uYX3lDg==
    K4uV80g55DnlPDyb3wsY2WCcmcxCw2szw2kuiCJQ0jiOHYZll5owhnsBIxssmUIsszBnEmSDhDTQBBOMoFqw0D+EC0cvYOxaAkPzQIxwmEIDAesrPLWyaSubK6b4iSa0DzB2DA==
    Q7dANFbMC0mNwRLWLpsjpHIND23YcfQCRq/WYGqgZSDwgBrws885hGlz4RziBoei6wWMvXBIlzOfS6a5oqB9lWUEEUeQoVzSLNzQ7gWMvTRTRCDdc9rsq0vMNDKWC9ZcUJAxng==
    h1miFzCywTAGNJJeNZdO0izXWmDVXFGgObSX1IQb2r2AsfMwlLcZeBiGhx5HMAMTZXIqFDTHmJ84E9oLGNlg47hoz8dbKMMk1AW5gF5NOeeEFfZEDPcCxjYYWWKgEsgzl8E6gA==
    JLQTilniKIFFzIdprRcw9konYIXKNWQlr6mksAQwjzIOAlJYYRm2+b2AkQ3m0EjKnGcYSUfBAO0ssyJTjjvTJNdwI6UPMPYMW6YcUR5jqimMLqHaheIcg68lZSQ0uBcweh4mKg==
    oxo6B2iCtRFG6DzHBMouqMvdic3AXsAJg0GnjrUJL8XeWm65NBw6B8hSFumcmAyWBgy1rpM0jOFewMgG51AWMicIE5ZSkBHEIXbQ8IBdDLkT55p7ASMbLFSGGOhcqFxRzLEB7Q==
    cOh+scYecXfitFcf4EKDD4/WP/6/AAAAAP//AwBQSwMEFAAGAAgAjnTsSCkA8KQ7AQAASAIAABEACAFkb2NQcm9wcy9jb3JlLnhtbCCiBAEooAABAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKVSzU7DMAx+lSr3Nk2Huq1qOwkQJyYhMQnELSTeFtYkVeKt27Nx4JF4BdrSdQJx42b7+5H9yZ/vH/niqA==
    q+AAzitrCsKimARghJXKbAqyx3U4I4syF9bBg7M1OFTgg1ZjfCZFQbaIdUZpvXdVZN2GSkGhAg0GPWURo2TkIjjt/xT0yMg8ejWymqaJmknPS+KY0efl/aPYguahMh65ETCoRg==
    he9hH7WrmhZZW6c5+t6h5mLHN9A5pVQDcsmR0+6ysB5PI2UuRYYKKwhoX/v96xsIHDrhgKN1XbeDU2Od9AMiwQunamxz7CYV97hsY1wrkNenbuLgoLqUS5bTsc6HYL6NQQbt+Q==
    GZ5qKMgZeZrc3K7uSJnELA3jaciSFUuySZol82h+NU1n8+lLTn/5XIz1sMS/nc9GZU5/vkP5BVBLAwQUAAYACAAAACEAbafiYKMOAAABjAAADwAAAHdvcmQvc3R5bGVzLnhtbA==
    7J1bc9u4FYDfO9P/wNFT+5BYN9tJZp0dW7HrTHPxxs7mGSIhi2uKUEkqtvfXFzdSoA5B8oCo+9BOHmKRPB+BcwMOePvl16dNEvykWR6z9Gw0eT0eBTQNWRSn92ej73dXr96Mgg==
    vCBpRBKW0rPRM81Hv77/619+eXyXF88JzQMOSPN3m/BstC6K7bujozxc0w3JX7MtTfnOFcs2pOA/s/ujDckedttXIdtsSREv4yQuno+m4/HJSGOyPhS2WsUh/cDC3YamhZQ/yg==
    aMKJLM3X8TYvaY99aI8si7YZC2me805vEsXbkDitMJM5AG3iMGM5WxWveWd0iySKi0/G8q9Nsgcc4wBTADjJKQ5xrBFH+fOGPo2CTfju433KMrJMOIl3KeCtCiR49J5bM2LhBw==
    uiK7pMjFz+wm0z/1L/nfFUuLPHh8R/Iwju94KzhqE3Pq9XmaxyO+h5K8OM9j0rhzLf5o3BPmhbH5Io7i0ZE4Y/4n3/mTJGej6bTcshAtqG1LSHpfbqPpq++3ZkuMTUvOPRuR7A==
    1e25EDzSHVP/G93dHv6SJ96SMJbnIauCckednIwFNIlFXEyP35Y/vu2EhsmuYPokEqD+r7BHQOPcf7k336qg4nvp6hMLH2h0W/AdZyN5Lr7x+8ebLGYZD5yz0Vt5Tr7xlm7i6w==
    OIpoahyYruOI/ljT9HtOo/32366k8+sNIdul/O/Z6UR6QZJHl08h3YpQ4ntTImzyRQgk4uhdvD+5FP9XCZtoSzTJrykR+SSYHCJk81GIqZDIjd42M3cHfZdHoU40e6kTzV/qRA==
    xy91opOXOtHpS53ozUudSGL+kyeK04g+qUCEpwHULo4lGtEcS7ChOZZYQnMsoYLmWCIBzbE4Oppj8WM0x+KmCE7BQpsXGs4+s3h7O7d7jHDjdg8JbtzuEcCN253w3bjd+d2N2w==
    nc7duN3Z243bnazxXDXVCj7yMEuLwVG2YqxIWUGDgj4Np5GUs2SR5YcnBj2aeemkB4zKbHogHkwLifzd7SEySN3H80KUcwFbBav4fpfx2nxow2n6kya8Sg5IFHGeR2BGi11m0Q==
    iItPZ3RFM5qG1Kdj+4OKSjBId5ulB9/ckntvLJpGntVXEr0khcqhef28FkESe3DqDQkzNrxpjHjLD5/ifLiuBCS42CUJ9cT64sfFJGt4bSAxw0sDiRleGUjM8MLAsJkvFWmaJw==
    TWmaJ4Vpmie9Kf/0pTdN86Q3TfOkN00brre7uEhkijdnHZP+a3eLhIll8cHtuI3vU8InAMOHG71mGtyQjNxnZLsOxKp0M9bsM/Y8Fyx6Du58jGkVyde8XrrIgvc6TnfDFVqj+Q==
    Cq6K5ym8Kp6nAKt4w0PsM58miwnatZ965na3LBqDVpJ6Be0tSXZqQjs82kgx3MP2AXAVZ7m3MGjGevDgL2I6K8zpI/PtWzm8YXvW8LA6zEpem6eRHlqZsPDBTxq+ft7SjJdlDw==
    g0lXLEnYI438EW+LjClfM0N+Kk3SK+QvN9s1yWNZK9UQ/Yf68oJ68JlsB3foJiFx6sdul682JE4CfzOI67vPn4I7thVlplCMH+AFKwq28cbUK4F/+0GXf/fTwHNeBKfPnnp77g==
    aXlIwhaxh0FGkVjkicSnmXEaexlDJe+f9HnJSBb5od1kVN3DUlBPxFuy2apJh4fY4nnxkecfD7MhyfudZLFYF/IVVHdeYMayYb5b/kHD4anuCwu8rAx93RVy/VFOdaW0P9zwaQ==
    Qg03fIogrcmHB+G/Hjpbww3vbA3nq7OLhOR5bL2E6szz1d2S57u/w4s/zWMJy1a7xJ8CS6A3DZZAbypkyW6T5j57LHkeOyx5vvvr0WUkz8OSnOT9I4sjb8aQMF+WkDBfZpAwXw==
    NpAwrwYYfoeOARt+m44BG36vjoJ5mgIYMF9+5nX493SVx4D58jMJ8+VnEubLzyTMl5/NPgR0teKTYH9DjIH05XMG0t9AkxZ0s2UZyZ49IS8Tek88LJAq2k3GVuLhBpaqm7g9IA==
    xRp14nGyrXC+jPyDLr01TbB8tsvDiihJEsY8ra3tBxwpWb93rUtMPskxuAk3CQnpmiURzSx9ssvyevlWPZZx2HzZjF7Lnp/i+3UR3K6r1X4TczLulCwL9ppY9wmbdH5SPs/SJA==
    9plG8W5TNhQ+THEy6y8sPbomPO8W3s8kapLHPSXhOU+6Jfez5JrkaU9JeM43PSVlnNYk2+LhA8keGh3htM1/qhrP4nynbV5UCTeets2RKskmFzxt86JaqATnYSiuFkDr9IsZuw==
    fL/gsctjoshOwYSTndI7ruyItgD7Rn/GYmTHJE15vuruCZD35SS6V+b8bcfUun3tglP/h7o+8olTmtOgkTPrf+GqlmXseuydbuyI3nnHjuidgOyIXpnIKo5KSXZK79xkR/ROUg==
    dgQ6W8ERAZetoDwuW0F5l2wFKS7ZasAswI7oPR2wI9CBChHoQB0wU7AjUIEKxJ0CFVLQgQoR6ECFCHSgwgkYLlChPC5QobxLoEKKS6BCCjpQIQIdqBCBDlSIQAcqRKAD1XFubw==
    FXcKVEhBBypEoAMVItCBKueLAwIVyuMCFcq7BCqkuAQqpKADFSLQgQoR6ECFCHSgQgQ6UCECFahA3ClQIQUdqBCBDlSIQAeqetTQPVChPC5QobxLoEKKS6BCCjpQIQIdqBCBDg==
    VIhABypEoAMVIlCBCsSdAhVS0IEKEehAhQh0oMqLhQMCFcrjAhXKuwQqpLgEKqSgAxUi0IEKEehAhQh0oEIEOlAhAhWoQNwpUCEFHagQgQ5UiGjzT32J0nab/QS/6mm9Y7//pQ==
    K92ob+aj3CZq1h9VtsrO6v8swgVjD0Hjg4czWW/0g8TLJGZyidpyWd3kylsiUBc+vy7an/Ax6QNfuqSfhZDXTAF83lcSrKnM21zelARF3rzN001JMOuct2VfUxIMg/O2pCvjsg==
    vCmFD0dAuC3NGMITi3hbtjbEoYrbcrQhCDXclpkNQajgtnxsCB4HIjkfSh/31NNJdX8pILS5o0E4tRPa3BLaqkzHMDD6Gs1O6Gs9O6GvGe0ElD2tGLxh7Si0he0oN1PDMMOa2g==
    PVDtBKypIcHJ1ADjbmqIcjY1RLmZGiZGrKkhAWtq9+RsJziZGmDcTQ1RzqaGKDdTw6EMa2pIwJoaErCmHjggWzHupoYoZ1NDlJup4eQOa2pIwJoaErCmhgQnUwOMu6khytnUEA==
    5WZqUCWjTQ0JWFNDAtbUkOBkaoBxNzVEOZsaotpMLVdRaqZGWdgQx03CDEHcgGwI4pKzIehQLRnSjtWSQXCslqCtSpvjqiXTaHZCX+vZCX3NaCeg7GnF4A1rR6EtbEe5mRpXLQ==
    NZnaPVDtBKypcdWS1dS4aqnV1LhqqdXUuGrJbmpctdRkaly11GRq9+RsJziZGlcttZoaVy21mhpXLdlNjauWmkyNq5aaTI2rlppMPXBAtmLcTY2rllpNjauW7KbGVUtNpsZVSw==
    TabGVUtNpsZVS1ZT46qlVlPjqqVWU+OqJbupcdVSk6lx1VKTqXHVUpOpcdWS1dS4aqnV1LhqqdXUlmrp6LH2ASbBlt834wcXz1sq3sFtPDATqXeQ6ouA8sCPUfWhJCEsWhLoTw==
    UunNssH6gqH8O8t5VaePGY+PF9PT2UIdZfvk1HRsfnJqXv2wfnJKNq2jM1Xz9fVQ9SUoswP7DzjJ1i1JTqOvQt+ge6l4+V/DdvGSvHJ7eZrFmmRq794c5THa4ezaOp9PLy71JQ==
    RZu2TF3tFad0RZ9IWChxpl5H9OlnUuFNLVZfP1vKo/dfJJvouDK/SDaR8W58WMzFAFOrAXRW8mOAaQ8D1C96d9hkvjgZn3faxKJz6VtA5x3altsGantm1ba+Su5H2zPf2m6IgA==
    B0q3X3iT5Dbx4xPXca7UVhliKd4cx5WiskeXWcrkWDdL84cAyR8tHwIUOy/1NrG/9i3AmuT+W4Bi80X1LcBQZPLK9FfzD6fy3RXyYJnleQaUOV4mZblZ3HjEQadXpe9U3dL3MQ==
    1L4mKLd1e1PIDcmTh3q5nWUk0C+prp6ylK+oPvQzy5usLT6ik+/+TpVml7G3uxAjYkub5YjZOoSpQdXqxNqLu1rI27NMlB/xPz6mwqcfdbZWLY2eiELx/QuaJJ+JOppt7YcmdA==
    JUKR752MlV/U9y/V6zmt8pmcx1kBR/XGqJ/tfqI+2KFvMLLOGMRkpUHd8m63oZru4Qt164t1ZtAYNZOSu5Qm6/nQdBtLe8t3SdQT2OV8vCjvCe0zhHdNd+p+dcGyiGZyIqf8Rg==
    nlW8y153/E+eAuUf/Jy0+hqmSiOaXHmVk2zlcU7SpT86Ccc8lUb0epj4727iKjQq9feJlObx+Up92OnQHfX3nppc0TYEK1LrAGwfgTudlseScjOyLI8To5AaH7YsF1XgGz3AGg==
    x0gDV4e8nambvIW6NK957tQ9ua+NT+Eu504oi5rD3GNo5VDHalew19iBohuHN4vau1Ru02/PDlbd0a/QPuyK3ozrBWxt+alh+3zM9IxaxbBciCnYkFlqQxToj6dhokCR/h8F9Q==
    KDC0cqhjtWtoFGgDvlAUGG9Tki9TOuwTeNvS0MCwzEU6Y6M2m38zFv90fzvCpGXqoi5nH3bZuHiuDmjqco9ZTHkT8kHXFpO3bxELES83i7m4Ev/EBrNEWpLw4T5juzQCZdKFLg==
    k/CTHudTucyRnE/mMKVyPpfTDGzg2ZATNsezeZvffWHlu9sOI9Z4rVvXAGetk1sG6slkstD1f+syld9BplryPOyt3hlMfIw04izWVN2Uv8xlpBdb6FQPBx0qQm1t6r85hvZZcw==
    k6S2mc5E5/JhC8yTafNKcY/lMcvy14HmZz213NcP93pp1P1QBzQMaFd5p/u9uPaafbT6DtehqqodPjy1hLU6a2dKa9BibWWz59SqrxvVGm1Tz1BnqqvZrpX/qiZql1IONVEm9g==
    qafErkvQnondvBrj9WoKUjfqwodNNzNPutHFhfug9z91SaP8K3//bwAAAP//AwBQSwMEFAAGAAgAAAAhALE/uGIiAQAATgIAABQAAAB3b3JkL3dlYlNldHRpbmdzLnhtbJTSzQ==
    SgMxEADgu+A7hNzbbIstsnRbEKkI/oHWe5rOtsEkEzKp2/XpHdeqSC/tLZPJfMwkmcx23ol3SGQxVHLQL6SAYHBlw7qSi5d571IKyjqstMMAlWyB5Gx6fjZpygaWz5AznyTBSg==
    oNKbSm5yjqVSZDbgNfUxQuBkjcnrzGFaK6/T2zb2DPqos11aZ3OrhkUxlnsmHaNgXVsD12i2HkLu6lUCxyIG2thIP1pzjNZgWsWEBoh4Hu++Pa9t+GUGFweQtyYhYZ37PMy+ow==
    juLyQdGtvPsDRqcBwwNgTHAaMdoTiloPOym8KW/XAZNeOpZ4JMFdiQ6WU35SjNl6+wFzTFcJG4Kkvrb5XtvH8Hp/10XaOWyeHm44UP9+wfQTAAD//wMAUEsDBBQABgAIAAAAIQ==
    AJRA96XTAQAAPAUAABIAAAB3b3JkL2ZvbnRUYWJsZS54bWy8km9r2zAQxt8P9h2E3jeWnT9tTZ2SZQ0Mxl6U7gMoimyLWZLRKXHz7XeSnWzMlCYUZoOQn7v76fT4Hh5fdUMO0g==
    gbKmoOmEUSKNsDtlqoL+fNnc3FECnpsdb6yRBT1KoI/Lz58eury0xgPBegO5FgWtvW/zJAFRS81hYltpMFhap7nHT1clmrtf+/ZGWN1yr7aqUf6YZIwt6IBxl1BsWSohv1qx1w==
    0vhYnzjZINEaqFULJ1p3Ca2zbtc6KyQA3lk3PU9zZc6YdDYCaSWcBVv6CV5m6CiisDxlcaebP4D5dYBsBFiAvA4xHxAJHLV8pUSL/FtlrOPbBkl4JYJdkQimy+Fnki43XGN4zQ==
    G7V1KgZabizIFGMH3hSUZWzD5riGd8amYaVJSBQ1dyADpE9kvVxyrZrjSYVOAfSBVnlRn/QDdyq01odAVRjYw5YV9Inhk202tFfSgs5QWK3PShbOik86KNOzwoIiIqfPuI9VIg==
    cs45eGbSOzBy4kVpCeSH7Miz1dy84UjGFujEHP0IzkyvcsRF7rWOZKu/HVmjcns3m44cuX/fkZ5zuSPDbJDvqqr9mxMS5uJ/TcgqtJw9/TMhGbv9MvIj3v6DEzJsYPkbAAD//w==
    AwBQSwMEFAAGAAgASYeaSvnrOpQRCwAAwGcAABMAKABjdXN0b21YbWwvaXRlbTEueG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMVd224cNxLl8w==
    AvsPRt6zju7CQjuBZMeOAVuRLcVZPwmKNHYE64aZUWL9/O4WyWnxUvceAQsh0QxZdc5hNZtNFtnyf/+zF34M38J1uArPwp9hGmZhHi7DbbgJ/wrfhbXwj/AD/H4GNTfhHMovoA==
    9iZ8SbX3YRE+h+/Bahu+/Rgm4e/hb2EvHIYzwPoNrGdg/wF879LnRfh3YjqC+vjt2ZL5Bjgz3gw+/xPKLoFrBj5z+O8zWH4POA9Qd7asm0PJTWJ5DnYFfw7fj+H3GdReJJaLcA==
    CiVnwDKF2tPwHlhuwWIKlmthA1q3CZ++W2p/Bj974WeoPQPPGI1SnusOgP8KfhaA8gKw5unTdbI9hE+n4W34HeonZss94Lej6mruKz9aRW3BsbcoLeuLpO0uRfkh7EOkLtJVmA==
    w88aWMv1kVFDsPOtK3zrKt+6i29D4dtQ+TZcfJsK36bKt+ni21L4tlS+LRfftsK3rfJtu/h2FL4dlW/Hxber8O2qfLsK30H6/RW8ztMIfQ/fFsv71mqJNUio49SUMczr4VHHjQ==
    lLT/AUT5LD3Z/hAj1tvxijDiGB1arDh7uy5fnA7Tk3fK6hnqef6C4OHT4tDb6fy2dtfP4NfwdJwRfYOywfw0kpebi4Nka9Nii8dP4R18uiQUlBrMV3tJ6IMW6g6s6zBD62nl4A==
    oknZyJy26P28nMvFee8X4i7q6zEnRpD43kCv3wd9Pc9QjvGLhwWXi19fz/PY4vYWWvolzd1/gVXA5zTzx9GjrTA3h+ZXwLVftrYq8sYmr3fiiuY6rdIWgi5sK6mikGVNt+B5Cw==
    vfQ2rSIXy5Uk1kPbUVo4REnHETzjotWUHFHaWszZe9uZuH5BW2nMtn5wlHrNIq2dp1D/XLH/kK7uZXoOzNLVzRE9TCu+35drXr8Pbo2NaVWtXMw9vuO0267PcfgNRr1X4QQpLA==
    NZi/9rKhc3HAFhKbrU0fYQw/EWKE7zndA6uysKymkouZ3XOMan+MtYjq8fNFyxobeyS0dt+kJ00cx1peXD7wUB4Y9w50tIh1yYDVWvUobTaOynbJFplFQ/Gwrqus6wZWKu8l2Q==
    b6isGwZWKvsl2W+qrJsGVioHJtlvqaxbBlYqEybZb6us2wZWKh8m2e+orDsGViorJtnvqqy7BlYqN9ba55njIs1nYy5glu74i+U6wmpLKZGQW00vofx8mVGP49Yw5pzA929pVg==
    rVlEfh1FZn25nMtjtqGGYileNvQyjmoWEhs3Gvf2+blGlVLo1FOQsuHb0D/xZG+Z6SStZ67EmGEbipVC6rnvobbuAfX3jNlaSP61Xqoc43G6SoaoWOCyiEdZ9ljzNM+6RpxcTQ==
    xuW8ZPSDdK8/CCy9BcWGUWTWV+G2WXnI9RRjj9DzfUsZ4jiDi3mmD0uvfUAp44zFKnNb0FoFr1Ju7bpS2JdEZGzVoryGsluoiWPz23S3cOtPq2VktaOOU1Na4/XwqONi1ucYiw==
    HVcTWXmvFv0NqPgTbHOO62VaG5Wdm33AGD4XBL9PVDSGyaM1PuvnqRf7NUu+unaZuW1DyeL9lOziEyLOFR5gzhDHd7k+atEQPHxFpc1O5+fbfZkyaHWM9tMZktj35fjWKldHyQ==
    bXgKNX0L8719lWakszQXjvt6D41+zSar05FabnyXU2OCNhbE+ofH2cs7+L1Imc8LiME0xWAGsbh7HL0mbo9BhY9lNZVtTMZ4jlFti/FJ6m/X4G+LsGaPleoMq+jjYmv18+vl4w==
    Olver/N0/56Dzf3jqbic85qYrLImC5pfQR0vu7VV0Sqx+ZRq80rMZ29VVzO0+t6nNcn88RrPq5bwdZFX8sQc+XzhxzSyXoK6EygpKyvNYuCTUXysbTstlhYVXAzKecv2CTc8DQ==
    +SfdWM+9dO5zLCun/ijk87DteCDXt0poBAvfAZTlkysaM7bkNVCoFjXl9I5czzNz53+OoUw6+TpRLTKnhuJjrWNus7So4GP+R3r2DM+mmp2uyWycl4xumQn5fShF/jmXH4GPlQ==
    b961CjPdhjhSttlqrJW3qTVJSFbuNZF1TeHDO1S87brItK4w4V0p3nZDZNpQmPBOFG+7KTJtKkx494m33RKZthQmvOPE226LTNsKE95l4m13RKYdhQnvLPG2uyLTrsKEd5OO0w==
    CPDXo8/dcqbZ+k2MdgO7BZHWkd+p+SqO27pdrUND7HXcw7izSLPC+JSvRzS6JnNxXi36yTJX/LUZ4ajSiEpb94iYE5dlNE1dXl3QuTe+LmJLnhrHccp2ncP1yOcDz4jnzxgvWg==
    l4WNUjxkJntNfXlhxR4U7os0X70nsam6gk97ahxzkWWu8PD9MNu+SbvDOZcZ49tm43WbwiojUdx5Ln6+9Orzc7pN4ZaRKG75DJftbJj/NJjnJJbvxNf4M16f0p02E3YdNYvIrw==
    o9CsUfHndPVynnda8eG6monytHKcEq2TrGTeU7aVwzq/Lc919RiXdyXprNaA4LOPir0Mq2osURjn59dMxx1rl7KGVHx1+16rhWFVjXR87X5+zVJ8+RXo0F7NIp/J0FD8zEW11Q==
    0qJEisWbkN9IGMbZQTtdnndVaQ8rdr27K9XzXFJ7qD3CWqVcz+0yyu2UPeR9ULrdVkReS5+fbecZVESsHrU+O8tYpcPJFr9i7GlXTrHyLejvBLq8ZtfvnbI3Q+0+0XtMUr8oVg==
    uaUUalvTYvdemOF9WDR73e33vAOyYHfDB4z7tAodzifUMeLrht0VztPDU+vXbGReqZ19fhTvAWkWVJZV3knSmYd46TYaOx/5k5DfnJ43fxekHucmBpucY9CRKP5y4mVQicsyPg==
    tsR4v0LNZZOD6EsiFrbikeLbi+9Si+Yhv4c2EepqdMrTw4PbwNvIvJZ2lrFlQpTV+LWlBQ+3gx45JU/MI+cKhh5isdIzD3x/s/hZsyB4NPOhc+qOwvAmURuVvrzOgvQeVmycdQ==
    oet5Lm4F/JxRs6dkeQevPu/s8Z0Y7aJKK+JYLe1ZXL+PXaN06teKgbP9OC8rr1ns510l5KfB8Z7A/X+0tV7PPSXe07VdXv/6zwiPv+5evLGnmJ+yH3gZrP1hLO7Tx8SfT/iY5g==
    unR8vR78el9iWV2plpfQPccol2IdV8VxLsnPQuLobrGKymxo3DzDfiV89twOpu9a+xD6OdKY6zyW0aL9bXgRPimj1hgvWreF7WlUS3G3e49thX4Nyq6x3r8tttR+9Jh+bfHuYw==
    6/Hx6bTH0d6P7R5Y6yr9147BxXdMvx3D6lv56v3X66ethsf0ay+SbR3v6e/jFWjrcf0K6JZ4jT4myrovlzPwRNLD0q9krXfuXvPXnsuZqrkYhfYZrSP47PudWAuDrDG/Q51PXQ==
    xPzxhVv1GIS+HeNU2Hd4dayxntIO8JgWvAr57wHFt+mvjHHw++T3zv1MvN6Yzc17AFePd6Bd+Rjvug3j2PuRwesR3+rN/XX2uGdJxWj4ywjFpi+J7NgKI8UTevmvB8ZTF8WSLg==
    j6icB8Z+nfYOpqn/trZcTX5Tn/OidkGvw+IxX1As6fK8A0p74FyxdiX2mitK700N9ZazLhOnfXsu18YgaeTOOJXW221bbTqypItrDaVLs2116ciaLlsus1do88JarWyS6sPUrw==
    OXW4tlVBeUts7VvFvepf4P+471t9WmV2JklvPotfvk+EupYfe3p43qX+F89Jy9dZ0mPFkHXblUjto+5N+h603Wt4hj0Ra1sOytvHlle6Mme20ZgHJB8/FU/eStPgiXm71sf8bQ==
    PcXcI/RPWvopGmvwvzST88C2fz9nEv4HUEsDBBQABgAIAAAAIQCTdtZJGAEAAEACAAAdAAAAd29yZC9nbG9zc2FyeS93ZWJTZXR0aW5ncy54bWyU0cFKAzEQBuC74DuE3Ntsiw==
    LbJ0WxCpeBFBfYA0nW2DmUzIpG7r0zuuVREv7S2TZD7mZ2aLPQb1Bpk9xUaPhpVWEB2tfdw0+uV5ObjWiouNaxsoQqMPwHoxv7yYdXUHqycoRX6yEiVyja7R21JSbQy7LaDlIQ==
    JYjy2FJGW6TMG4M2v+7SwBEmW/zKB18OZlxVU31k8ikKta13cEtuhxBL328yBBEp8tYn/ta6U7SO8jplcsAseTB8eWh9/GFGV/8g9C4TU1uGEuY4UU9J+6jqTxh+gcl5wPgfMA==
    ZTiPmBwJwweEvVbo6vtNpGxXQSSJpGQq1cN6LiulVDz6d1hSvsnUMWTzeW1DoO7x4U4K82fv8w8AAAD//wMAUEsDBBQABgAIAAAAIQCUQPel0wEAADwFAAAbAAAAd29yZC9nbA==
    b3NzYXJ5L2ZvbnRUYWJsZS54bWy8km9r2zAQxt8P9h2E3jeWnT9tTZ2SZQ0Mxl6U7gMoimyLWZLRKXHz7XeSnWzMlCYUZoOQn7v76fT4Hh5fdUMO0oGypqDphFEijbA7ZaqC/g==
    fNnc3FECnpsdb6yRBT1KoI/Lz58eury0xgPBegO5FgWtvW/zJAFRS81hYltpMFhap7nHT1clmrtf+/ZGWN1yr7aqUf6YZIwt6IBxl1BsWSohv1qx19L4WJ842SDRGqhVCydadw==
    Ca2zbtc6KyQA3lk3PU9zZc6YdDYCaSWcBVv6CV5m6CiisDxlcaebP4D5dYBsBFiAvA4xHxAJHLV8pUSL/FtlrOPbBkl4JYJdkQimy+Fnki43XGN4zRu1dSoGWm4syBRjB94UlA==
    ZWzD5riGd8amYaVJSBQ1dyADpE9kvVxyrZrjSYVOAfSBVnlRn/QDdyq01odAVRjYw5YV9Inhk202tFfSgs5QWK3PShbOik86KNOzwoIiIqfPuI9VInLOOXhm0jswcuJFaQnkhw==
    7Miz1dy84UjGFujEHP0IzkyvcsRF7rWOZKu/HVmjcns3m44cuX/fkZ5zuSPDbJDvqqr9mxMS5uJ/TcgqtJw9/TMhGbv9MvIj3v6DEzJsYPkbAAD//wMAUEsDBBQABgAIAI507A==
    SELp6F7pAQAAYQQAABAACAFkb2NQcm9wcy9hcHAueG1sIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJ1UwQ==
    btswDP0VQ/fGTlsUQ5C4GNrDDhtaIFl7ZmU6FmpLgsQEyX5th33SfmGU5LjKgl2WE/n49PQoMv7989fy/jD0xR6dV0avxHxWiQK1NI3S25XYUXv1SRSeQDfQG40rcUQv7usl2A==
    xbMzFh0p9AVraL/Y00p0RHZRll52OICfMUNzsTVuAOLUbUvTtkrio5G7ATWV11V1VzZGBjX/sjla1h/1wP6vHh4IdYPNlZ08iuh5g4PtgbBeKw5Uq7Ap1tBzCyeBWWPosCxzbg==
    PGgI+o0asK5SccrjU8AW/VhJcUBfjWt8Pb+5jXjKAv7QgQNJ/ObjkQwI9c+WrUkgnkj9TUlnvGmpeIp9FkEmHspZ4RQ3sEa5c4qOo2yOBMZXpSeXKU7eHWwd2I6tjg1MQKivJQ==
    v88Dv2PdQu8xUj6wwPiCENblGVRoYE+LPUoyrngDj2GgK7EHp0ATb5L6wem1SLSExri3nly9UdTzDVMew5yWx+o2GE7BObGcPNTR7rnBML1wj39quVX6h+Vo4GR4LjKTF/6ymw==
    /hIOszWDBX1M5SlJE3j33+3GPIYd+3jbc/x8X14VdWsLEi83JyvFqXEBG96AfGoTFqfGbbo+XMYieotNxrysjXv5kj4U9fxuVvHvtIgnOO3P9J+r/wBQSwECLQAUAAYACAAAAA==
    IQAs1xQN3QEAAC8MAAATAAAAAAAAAAAAAAAAAAAAAABbQ29udGVudF9UeXBlc10ueG1sUEsBAi0AFAAGAAgAAAAhAB6RGrfvAAAATgIAAAsAAAAAAAAAAAAAAAAAFgQAAF9yZQ==
    bHMvLnJlbHNQSwECLQAUAAYACAAAACEAVPhkQmMBAADuBwAAHAAAAAAAAAAAAAAAAAA2BwAAd29yZC9fcmVscy9kb2N1bWVudC54bWwucmVsc1BLAQItABQABgAIAI907Eg/dw==
    bMqPEQAAldgAABEAAAAAAAAAAAAAAAAA2wkAAHdvcmQvZG9jdW1lbnQueG1sUEsBAi0AFAAGAAgAjnTsSBc+5re/BwAAayUAABAAAAAAAAAAAAAAAAAAmRsAAHdvcmQvaGVhZA==
    ZXIyLnhtbFBLAQItABQABgAIAI507Eh0nrYUSQQAAGkNAAAQAAAAAAAAAAAAAAAAAIYjAAB3b3JkL2Zvb3RlcjEueG1sUEsBAi0AFAAGAAgAjnTsSHxmCPSzBQAABh4AABAAAA==
    AAAAAAAAAAAAAAD9JwAAd29yZC9oZWFkZXIxLnhtbFBLAQItABQABgAIAI507EhU4y818QUAAAcqAAAQAAAAAAAAAAAAAAAAAN4tAAB3b3JkL2Zvb3RlcjIueG1sUEsBAi0AFA==
    AAYACACOdOxIkCYKS+4BAADlBgAAEQAAAAAAAAAAAAAAAAD9MwAAd29yZC9lbmRub3Rlcy54bWxQSwECLQAUAAYACAAAACEAx87yqLkAAAAhAQAAGwAAAAAAAAAAAAAAAAAaNg==
    AAB3b3JkL19yZWxzL2hlYWRlcjIueG1sLnJlbHNQSwECLQAUAAYACACOdOxIUVUige4BAADrBgAAEgAAAAAAAAAAAAAAAAAMNwAAd29yZC9mb290bm90ZXMueG1sUEsBAi0AFA==
    AAYACAAAACEAqlIl3yMGAACLGgAAFQAAAAAAAAAAAAAAAAAqOQAAd29yZC90aGVtZS90aGVtZTEueG1sUEsBAi0ACgAAAAAAAAAhADJSfrUKAAAACgAAABUAAAAAAAAAAAAAAA==
    AACAPwAAd29yZC9tZWRpYS9pbWFnZTEuYmluUEsBAi0AFAAGAAgAAAAhAJ3p0mC3DAAAn3QAABoAAAAAAAAAAAAAAAAAvT8AAHdvcmQvZ2xvc3NhcnkvZG9jdW1lbnQueG1sUA==
    SwECLQAUAAYACAAAACEA0nc7M/UAAAB1AQAAHAAAAAAAAAAAAAAAAACsTAAAd29yZC9fcmVscy9zZXR0aW5ncy54bWwucmVsc1BLAQItABQABgAIAAAAIQCkR8oDhQMAAAcKAA==
    ABoAAAAAAAAAAAAAAAAA200AAHdvcmQvZ2xvc3Nhcnkvc2V0dGluZ3MueG1sUEsBAi0AFAAGAAgAAAAhAIPQteXmAAAArQIAACUAAAAAAAAAAAAAAAAAmFEAAHdvcmQvZ2xvcw==
    c2FyeS9fcmVscy9kb2N1bWVudC54bWwucmVsc1BLAQItABQABgAIAAAAIQCJjTcM0AgAAJIhAAARAAAAAAAAAAAAAAAAAMFSAAB3b3JkL3NldHRpbmdzLnhtbFBLAQItABQABg==
    AAgAAAAhALTglBngAAAAVQEAABgAAAAAAAAAAAAAAAAAwFsAAGN1c3RvbVhtbC9pdGVtUHJvcHMyLnhtbFBLAQItABQABgAIAAAAIQAOrXrPAAEAAFABAAAYAAAAAAAAAAAAAA==
    AAAA/lwAAGN1c3RvbVhtbC9pdGVtUHJvcHMxLnhtbFBLAQItABQABgAIAAAAIQB6qHJ0xQAAADIBAAATAAAAAAAAAAAAAAAAAFxeAABjdXN0b21YbWwvaXRlbTIueG1sUEsBAg==
    LQAUAAYACAAAACEAXJYnIsIAAAAoAQAAHgAAAAAAAAAAAAAAAAB6XwAAY3VzdG9tWG1sL19yZWxzL2l0ZW0yLnhtbC5yZWxzUEsBAi0AFAAGAAgAAAAhAHQ/OXrCAAAAKAEAAA==
    HgAAAAAAAAAAAAAAAACAYQAAY3VzdG9tWG1sL19yZWxzL2l0ZW0xLnhtbC5yZWxzUEsBAi0AFAAGAAgAAAAhAOsr9MjpEwAAFqMAABgAAAAAAAAAAAAAAAAAhmMAAHdvcmQvZw==
    bG9zc2FyeS9zdHlsZXMueG1sUEsBAi0AFAAGAAgAjnTsSCkA8KQ7AQAASAIAABEAAAAAAAAAAAAAAAAApXcAAGRvY1Byb3BzL2NvcmUueG1sUEsBAi0AFAAGAAgAAAAhAG2n4g==
    YKMOAAABjAAADwAAAAAAAAAAAAAAAAAXegAAd29yZC9zdHlsZXMueG1sUEsBAi0AFAAGAAgAAAAhALE/uGIiAQAATgIAABQAAAAAAAAAAAAAAAAA54gAAHdvcmQvd2ViU2V0dA==
    aW5ncy54bWxQSwECLQAUAAYACAAAACEAlED3pdMBAAA8BQAAEgAAAAAAAAAAAAAAAAA7igAAd29yZC9mb250VGFibGUueG1sUEsBAi0AFAAGAAgASYeaSvnrOpQRCwAAwGcAAA==
    EwAAAAAAAAAAAAAAAAA+jAAAY3VzdG9tWG1sL2l0ZW0xLnhtbFBLAQItABQABgAIAAAAIQCTdtZJGAEAAEACAAAdAAAAAAAAAAAAAAAAAKiXAAB3b3JkL2dsb3NzYXJ5L3dlYg==
    U2V0dGluZ3MueG1sUEsBAi0AFAAGAAgAAAAhAJRA96XTAQAAPAUAABsAAAAAAAAAAAAAAAAA+5gAAHdvcmQvZ2xvc3NhcnkvZm9udFRhYmxlLnhtbFBLAQItABQABgAIAI507A==
    SELp6F7pAQAAYQQAABAAAAAAAAAAAAAAAAAAB5sAAGRvY1Byb3BzL2FwcC54bWxQSwUGAAAAACAAIABxCAAAJp4AAAAA
    END_OF_WORDLAYOUT
  }
}

