OBJECT Report 1303 Standard Sales - Draft Invoice
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kladdefaktura;
               ENU=Draft Invoice];
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
                                 WHERE(Document Type=CONST(Invoice));
               ReqFilterHeadingML=[DAN=Kladdefaktura;
                                   ENU=Draft Invoice];
               OnPreDataItem=BEGIN
                               FirstLineHasBeenOutput := FALSE;
                             END;

               OnAfterGetRecord=VAR
                                  CurrencyExchangeRate@1000 : Record 330;
                                  PaymentServiceSetup@1003 : Record 1060;
                                  ArchiveManagement@1001 : Codeunit 5063;
                                  SalesPost@1002 : Codeunit 80;
                                  IdentityManagement@1004 : Codeunit 9801;
                                BEGIN
                                  FirstLineHasBeenOutput := FALSE;
                                  CLEAR(Line);
                                  VATAmountLine.DELETEALL;
                                  VATClauseLine.DELETEALL;
                                  Line.DELETEALL;
                                  CLEAR(SalesPost);
                                  SalesPost.GetSalesLines(Header,Line,0);
                                  Line.CalcVATAmountLines(0,Header,Line,VATAmountLine);
                                  Line.UpdateVATOnLines(0,Header,Line,VATAmountLine);

                                  IF "Language Code" = '' THEN
                                    IF IdentityManagement.IsInvAppId THEN
                                      "Language Code" := Language.GetUserLanguage;

                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  CALCFIELDS("Work Description");
                                  ShowWorkDescription := "Work Description".HASVALUE;

                                  FormatAddr.GetCompanyAddr("Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
                                  FormatAddr.SalesHeaderBillTo(CustAddr,Header);
                                  ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr,CustAddr,Header);
                                  DocumentTitleText := SalesConfirmationLbl;
                                  YourDocumentTitleText := STRSUBSTNO(YourDocLbl,SalesConfirmationLbl);
                                  InvoiceNoText := InvNoLbl;
                                  BodyContentText := BodyLbl;
                                  ChecksPayableText := STRSUBSTNO(ChecksPayableLbl,CompanyInfo.Name);
                                  IF IdentityManagement.IsInvAppId THEN BEGIN
                                    DocumentTitleText := RealInvoiceLbl;
                                    YourDocumentTitleText := STRSUBSTNO(YourDocLbl,RealInvoiceLbl);
                                    InvoiceNoText := RealInvNoLbl;
                                    BodyContentText := RealBodyLbl;
                                  END;

                                  IF NOT Cust.GET("Bill-to Customer No.") THEN
                                    CLEAR(Cust);

                                  IF "Currency Code" <> '' THEN BEGIN
                                    CurrencyExchangeRate.FindCurrency("Posting Date","Currency Code",1);
                                    CalculatedExchRate :=
                                      ROUND(1 / "Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount",0.000001);
                                    ExchangeRateText := STRSUBSTNO(ExchangeRateTxt,CalculatedExchRate,CurrencyExchangeRate."Exchange Rate Amount");
                                  END;

                                  PaymentServiceSetup.CreateReportingArgs(PaymentReportingArgument,Header);

                                  FormatDocumentFields(Header);

                                  IF NOT CurrReport.PREVIEW AND ArchiveDocument THEN
                                    ArchiveManagement.StoreSalesDocument(Header,FALSE);

                                  TotalSubTotal := 0;
                                  TotalInvDiscAmount := 0;
                                  TotalAmount := 0;
                                  TotalAmountVAT := 0;
                                  TotalAmountInclVAT := 0;
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

    { 131 ;1   ;Column  ;CompanyAddress7     ;
               SourceExpr=CompanyAddr[7] }

    { 132 ;1   ;Column  ;CompanyAddress8     ;
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
               SourceExpr=InvoiceNoText }

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

    { 144 ;1   ;Column  ;From_Lbl            ;
               SourceExpr=FromLbl }

    { 146 ;1   ;Column  ;BilledTo_Lbl        ;
               SourceExpr=BilledToLbl }

    { 177 ;1   ;Column  ;ChecksPayable_Lbl   ;
               SourceExpr=ChecksPayableText }

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

    { 180 ;1   ;Column  ;Questions_Lbl       ;
               SourceExpr=QuestionsLbl }

    { 178 ;1   ;Column  ;Contact_Lbl         ;
               SourceExpr=CompanyInfo.GetContactUsText }

    { 102 ;1   ;Column  ;DocumentTitle_Lbl   ;
               SourceExpr=DocumentTitleText }

    { 98  ;1   ;Column  ;YourDocumentTitle_Lbl;
               SourceExpr=YourDocumentTitleText }

    { 179 ;1   ;Column  ;Thanks_Lbl          ;
               SourceExpr=ThanksLbl }

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

                                  IF "VAT Clause Code" <> '' THEN
                                    IF VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0) THEN BEGIN
                                      VATAmountLine."VAT Clause Code" := "VAT Clause Code";
                                      VATAmountLine.MODIFY;
                                    END;

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

    { 301 ;2   ;Column  ;VATClausesHeader    ;
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
               SourceExpr=BodyContentText }

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
               ArchiveDocument := SalesSetup."Archive Quotes and Orders";
             END;

    }
    CONTROLS
    {
      { 5   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 6   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  Name=ArchiveDocument;
                  CaptionML=[DAN=Arkiver dokument;
                             ENU=Archive Document];
                  ToolTipML=[DAN=Angiver, om bilaget arkiveres, efter du har udskrevet det.;
                             ENU=Specifies if the document is archived after you print it.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ArchiveDocument }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      SalesConfirmationLbl@1004 : TextConst 'DAN=Kladdefaktura;ENU=Draft Invoice';
      RealInvoiceLbl@1075 : TextConst 'DAN=Faktura;ENU=Invoice';
      YourDocLbl@1069 : TextConst '@@@=Your Draft Invoice or Your Invoice;DAN=Din %1;ENU=Your %1';
      SalespersonLbl@1003 : TextConst 'DAN=S‘lger;ENU=Sales person';
      CompanyInfoBankAccNoLbl@1045 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      CompanyInfoBankNameLbl@1046 : TextConst 'DAN=Bank;ENU=Bank';
      CompanyInfoGiroNoLbl@1049 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      CompanyInfoPhoneNoLbl@1050 : TextConst 'DAN=Telefon;ENU=Phone No.';
      CopyLbl@1059 : TextConst 'DAN=Kopi‚r;ENU=Copy';
      EMailLbl@1068 : TextConst 'DAN=Mailadresse;ENU=Email';
      HomePageLbl@1070 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      InvDiscBaseAmtLbl@1071 : TextConst 'DAN=Grundbel›b for fakturarabat;ENU=Invoice Discount Base Amount';
      InvDiscountAmtLbl@1072 : TextConst 'DAN=Fakturarabat;ENU=Invoice Discount';
      InvNoLbl@1073 : TextConst 'DAN=Kladdefakturanr.;ENU=Draft Invoice No.';
      RealInvNoLbl@1092 : TextConst 'DAN=Fakturanr.;ENU=Invoice No.';
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
      WorkDescriptionLine@1001 : Text;
      CustAddr@1021 : ARRAY [8] OF Text[50];
      ChecksPayableText@1103 : Text;
      ShipToAddr@1022 : ARRAY [8] OF Text[50];
      CompanyAddr@1023 : ARRAY [8] OF Text[50];
      SalesPersonText@1025 : Text[30];
      TotalText@1028 : Text[50];
      TotalExclVATText@1029 : Text[50];
      TotalInclVATText@1030 : Text[50];
      LineDiscountPctText@1005 : Text;
      FormattedVATPct@1041 : Text;
      FormattedUnitPrice@1036 : Text;
      FormattedQuantity@1034 : Text;
      FormattedLineAmount@1104 : Text;
      MoreLines@1031 : Boolean;
      ShowWorkDescription@1006 : Boolean;
      ShowShippingAddr@1035 : Boolean;
      ArchiveDocument@1042 : Boolean;
      TotalSubTotal@1061 : Decimal;
      TotalAmount@1062 : Decimal;
      TotalAmountInclVAT@1064 : Decimal;
      TotalAmountVAT@1065 : Decimal;
      TotalInvDiscAmount@1063 : Decimal;
      TotalPaymentDiscOnVAT@1053 : Decimal;
      TransHeaderAmount@1039 : Decimal;
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
      YourDocumentTitleText@1080 : Text;
      FromLbl@1082 : TextConst 'DAN=Fra;ENU=From';
      BilledToLbl@1083 : TextConst 'DAN=Faktureret til;ENU=Billed to';
      ChecksPayableLbl@1090 : TextConst '@@@="%1 = company name";DAN=Udbetal checks til %1;ENU=Please make checks payable to %1';
      QuestionsLbl@1102 : TextConst 'DAN=Sp›rgsm†l?;ENU=Questions?';
      ThanksLbl@1100 : TextConst 'DAN=Tak!;ENU=Thank You!';
      GreetingLbl@1057 : TextConst 'DAN=Hej;ENU=Hello';
      ClosingLbl@1056 : TextConst 'DAN=Med venlig hilsen;ENU=Sincerely';
      PmtDiscTxt@1055 : TextConst '@@@="%1 = Discount Due Date %2 = value of Payment Discount % ";DAN=Hvis vi modtager betalingen f›r %1, er du berettiget til en betalingsrabat p† %2 %.;ENU=If we receive the payment before %1, you are eligible for a %2% payment discount.';
      BodyLbl@1054 : TextConst 'DAN=Tak for din interesse i vores varer. Din kladdefaktura er vedh‘ftet denne meddelelse.;ENU=Thank you for your business. Your draft invoice is attached to this message.';
      RealBodyLbl@1098 : TextConst 'DAN=Tak for din interesse i vores varer. Din faktura er vedh‘ftet denne meddelelse.;ENU=Thank you for your business. Your invoice is attached to this message.';
      DocumentTitleText@1121 : Text;
      InvoiceNoText@1122 : Text;
      VATClausesText@1099 : Text;
      BodyContentText@1123 : Text;
      UnitLbl@1020 : TextConst 'DAN=Enhed;ENU=Unit';
      QtyLbl@1067 : TextConst '@@@=Short form of Quantity;DAN=Antal;ENU=Qty';
      PriceLbl@1066 : TextConst 'DAN=Pris;ENU=Price';
      PricePerLbl@1060 : TextConst 'DAN=Pris pr.;ENU=Price per';

    LOCAL PROCEDURE FormatDocumentFields@2(SalesHeader@1000 : Record 36);
    BEGIN
      WITH SalesHeader DO BEGIN
        FormatDocument.SetTotalLabels(GetCurrencySymbol,TotalText,TotalInclVATText,TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser,"Salesperson Code",SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod,"Payment Method Code");
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
                          <PageBreak>
                            <BreakLocation>End</BreakLocation>
                          </PageBreak>
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
                  <Height>3cm</Height>
                  <Width>6cm</Width>
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
                  <Left>0.4cm</Left>
                  <Height>3cm</Height>
                  <Width>6cm</Width>
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
                  <Height>3cm</Height>
                  <Width>6cm</Width>
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
    UEsDBBQABgAIABuCEknoHgdIxwEAALILAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzZbPbtNAEMZfxfK1ijftASGUpAfgCpXogetmd5ysug==
    /7Qzbppn48Aj8QqM7cSgKo0NriEXS/bMfN/Ps9Z4fnz7vrh9cjZ7hIQm+GV+XczzDLwK2vjNMq+onL3Nb1eL+30EzDjV4zLfEsV3QqDagpNYhAieI2VIThLfpo2IUj3IDYib+Q==
    /I1QwRN4mlGtka8WH6CUlaXs4xM/bm3XxufZ+zavtlrmxtX1lX/wYccxcbIsgcVndTJGa5QkjotHr5/BzQ5gBVc2Obg1Ea844SWLJvSiw7HwMzcwGQ3ZnUz0STpOE7uQtNBBVQ==
    jkuL8zonSENZGgVdfa0WU1CAyCfjbNFFnDT+6hyIqpCC++qsMATuLoWIN6N5OtFaDxIZwLMQTTeQ9hbw9XvR6g7wByKumILgoNzPsIP1l8kwfhPvJylDIB9oigPppPspwOuJIA==
    jsr9DFuQGtL16yO0wsOOYhKAVnhoB8aPhZEdmABgaAdK9ryXawtTIByk+yk2NiDKtP8XP46j1x9Q/e8B/gvkAiZ5B3M5I71DuoyvmXhBhPY6frY1Mmc9ObXZbnjjTH/x4sfdsA==
    rp7FYWtNZ8nao98Q6rVTgz5lLpoNfPUTUEsDBBQABgAIAAAAIQAekRq37wAAAE4CAAALAAgCX3JlbHMvLnJlbHMgogQCKKAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKySwWrDMAxA74P9g9G9UQ==
    2sEYo04vY9DbGNkHCFtJTBPb2GrX/v082NgCXelhR8vS05PQenOcRnXglF3wGpZVDYq9Cdb5XsNb+7x4AJWFvKUxeNZw4gyb5vZm/cojSSnKg4tZFYrPGgaR+IiYzcAT5SpE9g==
    5acLaSIpz9RjJLOjnnFV1/eYfjOgmTHV1mpIW3sHqj1FvoYdus4ZfgpmP7GXMy2Qj8Lesl3EVOqTuDKNain1LBpsMC8lnJFirAoa8LzR6nqjv6fFiYUsCaEJiS/7fGZcElr+5w==
    iuYZPzbvIVm0X+FvG5xdQfMBAAD//wMAUEsDBBQABgAIABuCEkltSNfbagEAAPcHAAAcAAgBd29yZC9fcmVscy9kb2N1bWVudC54bWwucmVscyCiBAEooAABAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL2VzVKDMBSFX4XJXgKltuCUduOmM7qpXbhNyeVnhIRJbtU+mwsfyVcwFhFSWbiJy3tucvPNSQ==
    OHy8va82r03tPYPSlRQpCf2AeCAyyStRpOSI+VVMNuvVDmqGZoUuq1Z7ZovQKSkR2xtKdVZCw7QvWxCmk0vVMDSlKmjLsidWAJ0FwYKq8Qxiz/T2pxb+MlHmeZXBrcyODQicGA==
    TEtgHBTx9kwVgGbmuQ59M4h4W54SteUx8agzgKKWWjN16tcMKH2H8u+WBRVGLqk0nmrQA0tXWwBOzwfBhcQxQa9YDEuXDLkUuGeHGgaIH8m+iplLjOyoUTaPX+f1GL4/qLRCaA==
    ZhaPU5xcSry4mh/Joli4phh/tl1t2xCGLgle4PAAiCb4Rk6MRAvl2iXJdIRdeBE4TYtfRugpF+b//yLsIE9cAqDZO4qKc9mJNkTo1IaJtOi1+7tzVkQDzW7JM76I4iiJk2ieJw==
    3TOl1u97/QlQSwMEFAAGAAgAw1Y2S3DUxR6ZEQAAddsAABEAAAB3b3JkL2RvY3VtZW50LnhtbO1dWXPbSnb+KyrlYZ502fuiGnkK61zX+HoU27mTVCrlgklIYkwCLACSrZvKLw==
    y0N+Uv5CDhYuAEEKJEEJkPhCYutG9+nzna1PN/7vf/73z3/5OZ2cPfhRPA6Dq3P8Czo/84NhOBoHt1fn98nNhTo/ixMvGHmTMPCvzh/9+Pwv7/7843IUDu+nfpCcQQVBfPljNg==
    vDq/S5LZ5WAQD+/8qRf/Mh0PozAOb5JfhuF0EN7cjIf+4EcYjQYEYZQdzaJw6McxvM3yggcvPi+qG/5sVtso8n5A4bRCNhjeeVHi/5zXMV1vUTjzA7h5E0ZTL4HT6HYw9aLv9w==
    swuoc+Yl42/jyTh5hOqQmFcTAh2i4LKo4mLRjLTIZd6M4m9eImry3ryIXVAxe+Mg8ifQhjCI78azBSmm+9YGN+/mlTxs68TDdHK+GEbMDhtHOx+RZYVNml8M43SSt3x7jRg1GA==
    kbSKRYkmTSi/c96SqTcOli/eizQrxMV8twrIWgUi9nerghdVDOLH6RIaP2a3h43yX6PwfrasbXxYbe+D74u6gt06WHDLKgfHhzXm8503AyhPh5fvb4Mw8r5NoEUw9mcwfGfZCA==
    nKUoOU+F4Ldw9Jj+J98mxd91VBx8Th4n8OTlgze5Ov+S1vLXaAwsOSju/wPuAWNyhEDkwpXHGbxmNkyWT5jQLBDM2Vk4m1cVgBhOCwzDSQiCxrtPwvQ0/uPqPKsonnlDPzvO6g==
    mfg3yZ5Fv4VJEk73LByNb+/2ffE4iMcj/9eDSv++V+nBGuG/TSx/MvnNi1aI+aMomo/Z6KdX6XP9/UG1Njj7EIbf5w1FzMhK3YyjOPkUQiU4PZ14xdnyphVO7qfByv35heyRIA==
    /NUEfb04+z0/wyuNWDBpypLp4S38QyUFS2JEix7VXx+UyiYR3Ab7YfTpGuiLEGHcRM75/GJ6iVtEUmt+6Uv2mG1KLt0MRckw/y2aNSygQXgdNAbLJ2c7vvh65b3zp2z/xrufJA==
    6R2GsClF1qJZ8YISiD+Gn4FXMk2Ut6N4Kh4lxV9+HuV/3woUWXHxeHHdm4y9eF7nP330Hi7PBr/6HnDcwLqPAXF+ZIxGEQgjPJcF3m35+c+ZQRaNvn72Jn78FRTkTfL1ffAQpg==
    cg3TxfCNR/NyF5QJQSUhsrg1mwDb34UTeG1hzV2D8TR/HCvHsk3mSMoZY4QpIYjtEBNTuO4UlQzWa/ESzxwHqfEINc0i/2b88zdvNoNzEMq5fA5idPWnVH0v1fboMfDgLL4IvA==
    B7CBZmGUxIMn+zj4UzqIP8Fqu7s6H0C1l0CbfwB0P2U1/Ot0kvbo3/F/ZPdyCs/PqoSG65ksSMLIf5/40/f21fl/Ca0sxxHkwmacXTDJ+YWpJLvAFhaGjbCDtPrv+RD5P5OCJg==
    Cz6AAycYVXhiDvbzJXeULs35ZFAuD8dWGCRg22W1NWX8rGnvqr3NMJS/av6iReWDgp/TwS3A1luI/rj8z+H8Tiab53J6G0A343obcFPvIXg8Am4xllhzJDRvBFyuXaoYpVo5kg==
    UZcZlhKWIxByubC0q3sP3DKhj4rb/InDkFdu7s7AS/+ik5LdEYxlcUfaQyPBBEtNkWqmRYlLmePYEgllMVspw0XENrhjW47LXPnatCjpPBor7X3berAFRdcitDAnWAhOUDM9Zw==
    akMRrbg0lcuIZRnScAV3uW1g8KMY6T20ynTuPLLKzT3puRfQc7Q9MHIqqOaYi2ZY5FzZgD0uwVN0JFfIJRalhgQaco6d3mOxQufOg7HS3pOaO1DNtYisC4wAXJgKgRphy3Et5A==
    2tg0pbQYZpbhGLbDTYu6StjIcXuPrTKhOw+tcnNPeu4F9Bxr0egkRGOkMW6m6LCyAXxCgpVqMECmplKB6cksJR1m2/0HY4XQnUdjpb0nRXegomsRWheKUcKJZs2gZbmE2KZG2A==
    5oIxgbRt2toUCOxQZLm6/6GSMp07j6xyc0967gX0HG9RzynMEJdYNtRzJgXlJrhBDJfZ0lamSaRSWDrKRAZlvQdjhdCdR2OlvSc9d6CeaxFaF1hRlgYiMW7m0BmGq2zmAKAcBg==
    P4ZNELKQIMp0Tc3M3mOrTOjOQ6vc3JOiewFFJ1pEI0EitTs5a4hGKilzKEon5ZhjYa0QocJ1TE616RhW79FYoXTn4Vhp70nTHajp2sUW2JBUsIaz38ySlulSZXHHYJZwlDIVkQ==
    QjlcuODi0d5jq0zozkOr3NyTpnsBTSdbRKMURCCuNGkERmFz5KQ5nFwiZlvU4AL0nG0YBtDLMo3eg7FC6G6jsUhAnHjBgg9G3oX9t1IGaI0+lCd9uK8+/ODfepO/Zys/vn74Ng==
    adMBFBhsTsQbRjq5JJQRxKQDatHgWpkIY5dwl4MbiehryVyp0Pu14LG2c01Quau+TlczzdemwGjHfvTgn787K73qQBy0GF+klGBgY6KaJYwQmo68ZTkYIGBjQ8FQM8eVDrIcQw==
    9j9hZI3Ur5b9+2hG7m+/qfYgwyVmgiPVzHzTXFi2xYilHcyw4RqWdoF9DNdFDpyo3iOmQudnx0vL1s4KuHZyLeoxcYjJqKoInW3DaadMxt2IuN1krJNB6V++brfScGRzQ9hPNQ==
    vHzp8NHPm/jjtJZ4rfDrWUv8wXsM75PFEIE49leGca+VxkSx9ScG1fq6utaYcD6P1De9TrZeH/zYtja5gtlNRsYKgHcwFv4tvI8++Td+5AfgF7TsZXIhlAKbQTdLp2GISJsJZg==
    cpspzA1kWkLy1M+kXLi9dzLXSf3sFsMGJYlBS+6iJJ/kyCd0DaNYc3uzrknpBsM3BxNIn8k48D88TBaioGqC7GRtrA9Evb1RqN16z3jDAvqotiPWnRfNlUq5NVugmfHgNcjhMA==
    MKFT31sGJ2GMK0Zks0lHACB3laPTNbmMuoYhsU5dYEO4SjGz92mkdcR+rgX2T/DMnFkG5cKdRPZTVuTOyJ5FYXjjRNGiD/EMDARghWixML62BwdAMnlXxwyVIFZ9u2BwFu3fXQ==
    hGyRBdfeY7pH1hc/msa2Hw+j8Szdc6ttkYAUyGYiUTMHHyPMqOMqEAmaWZKboKhNl0ktiANgwH2XCVuI/lY1d6fwnbzbMkIvi9fPd+NZ2rLf/OQuHB0PsUqDz0F4wxC2LaTkhg==
    dC0rTYhg2pUIfm3blpa0aO/nU7cSvduITR8ovN6nN+TKn3wzIN86rK3D/NBY/2rT25HZzUKSW7yt5Sz2voGBFqcQCNJIUt7M6zCRRUwwSVxqU2YhpJgtNfTUZoRo4th9l1glIg==
    v5L5tlKf9sj92EXLLu30j960RS4VTDLEGGqWHaGkIJZrCIQcgylmgVJ2EBWcco01Vr3fv6pC5m5r0uPJ0VUw1Na8E0wqRG0hArW7+9iiIUo5EVxq3DCzjxGtXEExUjYDyBi2xQ==
    LUm1LWzTFAj1HTEb6H1CThU5WhENbdkJORuI214M96km7OP3tQc1KZDUBLimmW6yuLaJdjBmBgOcKWFpsL4w2FKKgTHWd6RtJHi3sdaqv9cteG4ckZ0BupbyUMXrakIrF5whpQ==
    C78C8/6wMDz2fYVMH8CXjg9iXeg8NNz3knRjeH+YVprz3BbBVd+IQ2RWBTcrSNk8jBhsAayJapiTWfDw9fKhrxdYAR9gyqioF201xElpvHeLASCUMt1wlfq2FrPeC+M6Jtpyrw==
    NRG9M2fXXTwWt8/2lsvYxcTkeyTk7SSva0ixU/rdDpebJK0VnT4mhU5Ja6ektT2S1jCmPU5a02Kuoco5aFrpuutKy9rLWNVdxlTXfn1DUlZ7GdXXItFqfzbmwzGq86HYGognSA==
    mpTmgfhC2A29IPk8m4wLpZFEv/qrDL9cDQVvz7XHvDXRzln4qRwdpFrtY/g1PW534k9KzJhgDcPoxFHU0S4zDcKYiYTJbJPbBAsqLFCovZ/4K4yJ7LhC8q64gRn81sVLMlwRWw==
    ZdGdftZpskkIslohuFrZgzEZ3wbzyvKqn0oOeApYB+a+P8O8Yd6D3LCpcMLLJgRk4qA0d9m6TMCccaq1arim8y0JhTrCd0Uy5Br4JBqeUzTU8UMH5MM/34OBMk4ejyAc0vXemA==
    E97wIyBvSDasEb0rgiEzwU9yYVUu1H8a69jSYo1DjiAqNvFA6m+deGAX3bB/Okkmg/8lGMOTR9hxgxOcTtzRk3VWlcAlkndF+uYhjRP0Xl78ltjj+URvFrs6jf8zit7fjS/Xww==
    5BieMdGYMKEa5vO9JdlboXlXpG8WIT6B7+WFb4U/OuAkpz/GNLwPjiIpOCWEpnG0k6SoSIoaundFWuQTR88pLnbO3jpJmE0SpoavWpcyRSZZzVxis701dp9LxGq5tcc81WL/mQ==
    oZVMgoMYdwurHXnN2LZMjMGSNrUUahQhf9skahIrfOMUahBJe9sUahTxeNskahITeOMUauC4vW0KNTJW2yLRHpZqp6m6MOR29Bpb9BApkYQzKYoUtj6tNMgp0f7Kgqbu2+Y0eg==
    JYlCSJFmHxh2EVGEUQTuNmMuIxopimxNlLIxs+mG71E1z/zf7H/u5z6s7HfW0H0gRFbdhwNyD9ucxkLprtmKNPwUtO2km/lxKagymUlNw7awdLirqAXj5LyqAMkKwbsSGKn1LQ==
    DxXw5Qz9TQL+oC0/VkjZgYhjNVuoTTgxgjTlDDeDEyKu5QoQf9hRTAumLalsZUuukKOo7v2OW9ty9rqCqfpoRA9AVSXoM2ax1EUnDqWYTRi2aym2/tmW1j7Msp6m154woAoMGQ==
    LVCznH5sMcY40tpGEvheKddWhqOphW3XUKT3G3JuTNF7/m3290RdDf/mQCx1Z1cU1gNvtxY0+U5LC2lUf7/5zffi+6hFjDAqwPpUqhlGhC0MsDmVFIZgWFDtSoMT4VLTNVzT7A==
    /XrbahLVguBd0ZW1QdceqMoSMTtggS5SoNpDkpSUggFJmk10O4blCMywZMgFztGmMg1DIRe8cDBHce+/5VKbjtgVFNUH5nsCo4ySHYBQ+mOP42E60XztR8NsB6GfScs2HMZMSQ==
    DpZZs/QRxmxs2kpbls0YMUxpmchhiCuHuGDJvSZUbaN/V4BWO73TA5xto20HoLeSQ9Yi0oRimiEmaSOoyXSLcs2pEMpmxOWaIhMrBxkGQ6bEvd+jcUNOZ2eQVTct2ANkrZCyAw==
    QKqkSrUZh1RpWIvrhhnSlJnpt5gV+FSUYSwNV1oWpYoIwpFBXxWaKkTvCqI2TyM/83zvM+m3lSE4Vnrg5rsbop3PlUxYMxv4nBM+Xcr662dfjhIA71AeXT+7chy/ukOZaT3tyg==
    MWzFruV6vfWkrNwI+xIm3iRu2THUIKIw0lr0L0FrnSpdTNaSQnEkCWu2l8ibTNY6mWd96svJPHvRrhygNkq5WUfUKUwoiinFzYKNr31ZaJXQdSlbNc90Im5CFOV1Jlm6Eynw6g==
    YoEmbQU5zYIjzZHTZg5YdYReNsC5huwi4HNEUHOCFCb6tF/iVlBvGIeu4LkzLlbXoL5h3N5c8BRjerLO+9yXk3Xexa48rx11Ct89Q/juNJ91EsknkdyDrlTdqgJDUammz0kULg==
    q3n604W5iZj/vQ+Gk/vUZfnd+JJmkrUZSdGCKkbQKZKSnuVEL51VaX9UR2sX7hmUix0h2pIWPM6OXV0B9E7UbsENbC4Zkne13PcMQaHWpVfu+a72pM20U4E5woqfNgjcIL/WqQ==
    32sJ1oO9Bbsj3Op3EOy4yFtn2CPGyIpvDj71UcjNi5vXh+S7788+Lr6EGecDAiUB5z4QZ/459UW34z+Wwqy4E/9hxZWL1UHJuwmP+kNA4Obmp5P1Fa/wLhMZn/wbP/KDob/k5A==
    vFfnZxEIWGCZ96P5Z+FuwjBpVmIuhje9I/u03srzi40WNr1ircBiqent5z8KkYA1yvyfu2wZAtU51EdQeqEVbgGZaZ3h7Oqci+zpDBKLs1xkLE7TzxBmscpMPuS9WdzM27o4vQ==
    vU+y03lXQMrES6Gy/LheMk4m/vVtfgKKKf2gXvqqceBfj5MhtJ6KhQjKxzU7/BaOHrMDKHOffsr53f8DUEsDBBQABgAIAMNWNkuuC9baxQcAALslAAAQAAAAd29yZC9oZWFkZQ==
    cjIueG1s7VrvburIFX8Vy/2wUiWuPcbGBl2yAgO5UZMUkXS3UltdDfYA7rU91swAya72yfqhj9RX6Jmxx0AguUCS3e52P4Dn3/md/zOHMf/5178/fvuQpcaKMJ7QvGuiD7ZpkA==
    PKJxks+75lLMGoFpcIHzGKc0J13zkXDz24uP684iZgbQ5ryDu+ZCiKJjWTxakAzzD7QgOczNKMuwgC6bWzHDa8DMUsux7ZaV4SQ3K/oiic5AACqxZESDYOTugWRJxCinM/Ehog==
    mUVnsyQiGgZAkL0jxrrYF+MgwpqyuCSXrYLRiHAOkCHOV5hruOjhZHlcK1pgJsiDxsiOMkyG2Zdl0QDMAotkmqSJeFQ20jAUPMnyTgXRqMWQJJ1SjOqhKdgxfEuSAY2WGclF6Q==
    FUZSkIHmfJEUtSmyc9FgcqFBVi8pscrSjRuPjYTn/DgoPbIBPCM6X0ZE9hEekRA1xTEi7PI8lGnr80yzZVzknQbg7AG0ODkNwqsgLP6YbVJjXcxf5+VLRpfFBi15HdpV/qXGyg==
    T1OwipbtCOavE+ZugQtI5SzqXM1zyvA0BYnA9wa4z1AeMGSWmHIbF9O0eoxZ1bgTjyms6Kxw2jXvJfUlSyAUrWr+e5iDgPRsGw4LGHksAL6IxGZFH8SBI0X1aKGhcjhAJEFEUw==
    ChsMXgoqu/yHrqmAeIEjotoKJyUzcSbplApBszOJWTJfnMs4yXkSk0+vov7uLGprz/DTNCRpeoPZljHXFWnps/gBP9H58Lz1FA1615R+0YLabk9RzRLGxYQCCJLdFFe9zWRI0w==
    ZZZvzesBtSSnn/pQadS978oe2hKiDlIZkrI5hyeAVCGJ7Gal0eFxa4dWMJiGyieeAEvbCx2/GZrV0D1TY66DQq9MlKj8riSIqixwvENZYG1WFprHWCEOEUKhaz7PeLw/NBmQGQ==
    XqZCzrg26vstJVFRMdjN10SkRMtQreCxqB5lH6cJ5prgD7d41TGsTwRD5Fj6/FUwn6+nqU5qPN8luFM1IYs/3+GU8M9wws3E56t8ReXGhJq1H5JY0zUC23dbQTtoV1NFCvG7oA==
    KfCV3ZhGY6h+9HK3P/Q93w2GvotcFDjtntcPXdf3bHeAekOn1vEJCha4n+SyfgWkgpFZ8nCDiwL6sKuWG2zO7e438vzdnLvxY46hxxs5XkERU1AmuPVVHa1vpIseoOxadE0LYA==
    O2Cb7yEHJwrhr1kqNfob+oeaK02se3uWhgmV1YIyciVIdjXomj+22kE4HLacxsD13AZo7zX6ge82UIhavYGNhnY7+En7iDyIyii1q6ExzOMxK1dAL6S5AK7K/ozS2ZCxOnp5AQ==
    KQ5KM72Vs2NjV7G/2FNJ5YESiD3PEOQzN2LX8ll13J4mhTxE9dYI7ueErYh5YTwR5WlKsOqxn0shlORaPnZ0/tzSt0sc5HitZtP2mt7vibOVOLf0XTPmxKiwdinfNdNOCtZNWg==
    3tK3yEcZOQfONbfvOKPW+51rd8upOOJoO2gaTXteKg+wIG95CvpNx/F8JzgqmZv9oDXs93rwPXIdfxS02+2wF/bt0Bu1Az/4rSSzNPIvk87PBscvntEvhO0mqaXhfvtp/UKajg==
    8fyNC9Wg7QYtBLIflaH2ADl+uzfsh07ftZ1R24Eqd9Bu+aNmK2z77q89Q7V9//fL0+djtUwZrcm7VKVfYf5MVfq0LD0JtNoLpiHf3RxmaSy3DKNu3Su1pmQubwKtN+aW5Fywew==
    6dvDKo57l0PD+PsfjR7D0yRSzZvh5HI4+vPkpnevLFBj/DyW4KTATJ/qewwlNhohp+8dwJbXEmMZME/3Y/QzepJsYvN0Xs/5yfo/iMXbv9zIcLz7PR7fMR73KomTi4YtSQ4WDQ==
    5QFVX5rKg1tdYMJPZRfps6FS4UlFV4xrCa3NnV75ffbN3jMKDsLWyPbOqYp2FPxnpIeVkkfod1L9FMrXhvnjWL9OfbMfOqjZhNMfIUfP/WpKnl2TvLrwqd5Un1L7HLqY3vL6Vg==
    zstr9Lx2Vowbgz9JaQnmoscTXA/t5HH1shKaBeRPmuTEiBMu7tXNu2z169Z13ZqU9/IFcjs4jxaUXcmbereFep7fqyZInAg53ETIG6Jyxyo6sJGCXoZ8I+6glq3eG0WPkK12UA==
    dqxy2WxGIjEsF6eKm1DfTH1Pu2ar6dWrZRnOjASYOaYBEQI5WjnMcPSa6HZ1yXCxSKIRgxVSedyZb41c0+gLf/XfGHIKe2E+Jz2oHCOxeWHxsgCvZbsFBT8CsbFk++8wj/8bxQ==
    xUdoyVB9kz9llGj5CjwidZYdMEXlL/upv0p76UWSxJC7A2ET9W+CFZkQnvygXnVJpWFh6bcDdq+HGKPrBWQ1r92xjV91dwScpkkxStJUspBtg3VINiUgMEQ6UpwhkK+5qFqlwQ==
    f3SCnm23nX4j9Oyw4dr+sNFru37Dt4e+a7sB7AjhT5Ia0mPJZcThdFAkb/C3lfLnZ6mckkg/lYxWqYUUFooZIqKFbM5AwQkYqyKqZ6xdC8geh7PEmK5vaEyql48S4GHGMvkEsQ==
    jAfF/lELUVrlxSy3NgAF4+KS0MyQDbAxCKUY4BWIX63Va+R4TqVoJZ803x2xyiFLi1014aPmtrJku1+maLn/qd2x3hbrQub5m5KqepAPpt8rfqUoOLPE2ataFjG7+C9QSwMEFA==
    AAYACADDVjZLaFmnWlAEAAB5DQAAEAAAAHdvcmQvZm9vdGVyMS54bWylV9tu2zgQ/RVD+9Anh6Is2ZZRp4gtpwl6QRAX7QKLRcBItC2EIgWSvmWxX7YP+0n7CzuSSFl2ktZxXg==
    Yg05c2Z45kLmv3/+ff9hk7HWikqVCj508JnrtCiPRZLy+dBZ6lm777SUJjwhTHA6dLZUOR/O368HMy1bYMvVYJ3HQ2ehdT5ASMULmhF1lqWxFErM9FksMiRmszSmaC1kgjwXuw==
    5VcuRUyVAkdjwldEOQYu3hyHlkiyBuMC0EfxgkhNNxYjexqRyCmHzZmQGdEgyjnKiHxY5m3AzIlO71OW6i3AuV0LI4ACyQcGol2HUZgMqjDMj7WQx/itTCIRLzPKdekRScogBg==
    wdUizWsqslPRYHNhQVY/O8QqY06dRuy/LY9RlZEd4DHhmzRmrIr854jYPSIjBURtcUwI+z5tJBlJ+c7xSdQ0yMXB6wC8JwBdRV8HERgIpLbZrjXW+fxtWf4oxTLfoaVvQ7vmDw==
    NRZ/3QFNtTQrWL0tmOmC5NDKWTy4nnMhyT2DiCD3LUhfq8xAq+gSp5h/+p6ZnxtpPqZ6y0BjsCJs6HwrrD/KFEoRmf0fsAcFGbguTFlY2eYAn8d6pzGCcGAWl5LILRSHyVsYxA==
    ggkYMGSpRSGqx6FTAqmcxLT8LnEYnekTTe+F1iI70Vim88WpjlOu0oRevcn6+0nW6Anx9+wz2YqlrlM0Sze0kcYxZewLkQ2q1wa4Uk825IAR2Pf6/lMNdIhX+BbiwR7E9S9K3A==
    WSqVvhUAgwuRESPtNseCLTPe2LcLpQoXVyO4wmvpeyXhRhB1ERclW3zO4RdAquix6xW3Yq1tleANAKcE8m9vgGjXDfteGJROysViKfJ8HAV26ZtsrFUIleeYcD3N4QY2NMsr2g==
    LCfP69XujYWOq79W+lV3xYbjRlKeSRqqNdEOXCXa/FSyiYARPrcBJqQdfbIIZp+wlCir8NtXshq00BUlUGhoXLw5+PYznRMYG0TT4u62kZL5vtG0fH/J5G5KGFV3cCnO9N01Xw==
    iWKW4Y7bsW2QWLs29rpBpxeGPd/s5QxqfiEYOC/ERMQ38GKy+r2w4wbBxO2Fl6GPu3jUjUbdYNTDF3jidqPQHuwQhWgySnnxWASkXFLolC8kz0GGSVwNZa7c4bvizt7d1cmWEw==
    kFSbkxU8fHIhtUK/PCR6V2RrA0+1xdBBADsAcn5A396WCL9nrDjRH/jPcq/i2UrP0g2b5TTQQtJrWLqOhs5f3bA/nky6XjvyA7/t94KgPer3/DYe4+5F5AIdYf9vmyi60YaYug==
    NOBjwpMbWWmANBZcg7MyBy/3xc3TpduIzsiS6YOGySs/+d5l81VMYaaVLyXUKFD1aBVw3+yox7E6WLQFi2rwg64O/E6IO84rKl+fP8t42VOVXuXOcleThEyzoaq/y3a3Q2ePwg==
    KjIc4fHE25s3LlQxvtzj9UCrwatRfpHXSyE0lS+S6j1HqvcsqfVp4f+m8/8BUEsDBBQABgAIAMNWNku/J+8pvAUAAEYeAAAQAAAAd29yZC9oZWFkZXIxLnhtbO1Y6Y7bNhB+FQ==
    Q/0RoICjw5J8IN7AOrxZILsxdrdJgbZY0BJtq5FEgaSPTdEn648+Ul+hQ0mU78T2elO0zR+L13ycGc43HPOvP/589XqRxLUZpiwiaVfRX2pKDacBCaN03FWmfFRvKTXGURqimA==
    pLirPGKmvL54Ne9MQloD2ZR15lnQVSacZx1VZcEEJ4i9TKKAEkZG/GVAEpWMRlGA1TmhoWpoupa3MkoCzBhs5KJ0hphSwgWLw9BCiuYgLABNNZggyvFCYiTbGpEMpzA5IjRBHA==
    unSsJoh+nGZ1wMwQj4ZRHPFHgNNsCUPABTTtlBD1Sg0h0inUKD9Sgh6ybyHikWCa4JTnO6oUx6ADSdkkyipXJKeiweREgsw+Z8QsiZXqGHXzaefoFSeyBDxE/fIYk7jQ/POIug==
    dsCJCIhK4hAV1veUmiQoSpcbn+SaFefq1nEAxhaAzfBxEFYJobLHZEmNeTZ+2ilfUjLNlmjR09Cu0o8VVnqcgWW0rEYwe5oydxOUAZWToHM1TglFwxg0grOvwfHV8hOoCZYoIg==
    //FhXH4GtGzc8ccYVnRmKO4q90L6kkYQimo5/wHmICB1TW9DioGhxwzwwwVaLnFAH0jGeY9kEiuF1CsEAhITyDBoyonosk9dRcsbGQpw3s5xYjziJ4oOCeckOVGYRuPJqRtHKQ==
    i0L85knS70+SVrccP4xdHMfXiK44c16Kbp6ZtHn3vLqJBr23hHyUimpmL5caRZTxWyKCQ3RjVPaWky6Jp0m6Mi8H8iUpeePAHV313hc9fUWJKkpFTIrmGL4AUuhuae1WadHucQ==
    dU2WU5iGmiG8hS01zwYueko5dE/FWMtv2jCWLw6K31KD4MMq9C6PlSszuccgR/QMU/csZW3jtaHBjlUeHqFpzMWMqelO0841yooNaPlZ4+0dp0TcOIUu+RK1kmAhLz/HIcw7KA==
    jhCTK767QbNOTX2DEcScKq/u+4jH+OHtMJbpAI3XBe7yOoyGD3coxuwBLscRf7hKZ0TkNL2hNSQbQimna7ZumpZl2+VUFkPkT0gM+4puSIIBFE5yuWsa7YbZ69m9tmv2nKbT7A==
    9fu6YTqG2bY905M2baIgjpwoFTUjIGUUj6LFNcoy6ENCLnJzyrTuC3F1L6/s8DFF0GP1FM2g/skI5Uz9oo3qC3G4C6jYJl1FBdgO+OYDsPc2R/gxiYVFP+m/5HOFi2Vvy9MwkQ==
    5wNOKL7iOLnyuspvdrvl+r5t1D3TMutm07LqTqtp1nVXt3uepvsQuL/LM8ILXjqlCgpo+Gl4dIitikHbJSkHVfNDo4SMfEorsrAMMgp4inKZhQ6lynFByy+2PJYTtFizXzWwQw==
    WXqlskStCPRc+opCQGZ3iEOG6QwrF7UNpZ+VxTfkjPS1zIYgb8v4Rt8V+t6Qb7w9kLc35ByEFTGz40aGwDL69jlv5GzdtumQi7xTxe0xl3Ap604QPZ7EHuL4jDTW9UbDMMxW8w==
    IBrbjb5rtxy77TTbputqvb7hNDSjqZu257XM9n+FxsLJ/xCR9wXHeensw8G75nF03h+2S1ILxz0LrbeL+XMyuLJkeFhx/RmeDtD4zJVyHdjVbgFRLesgkvb7tmF5TcNquqbp9w==
    TMexda+tG0BeS/P83r+dpNLDz0rQYsUTWbb/FipYIy15lsr1C5vvqUc3C9KjQCWJXLaeH0ZxKLJGrWrd52YN8Vi8Y6pn3i1KGaf34mx3mzjoXfq12s/f13oUDaMgb177t5d+/w==
    3e117z73QIXxdTzBcIaovNi3NhTYhtZ0Go0d2OJNZSACZjMl61/xJPEyNo/fa985qf+DWLz54VqE4923eHzGeCyKCXX53Ff8nvzot6cWKd8Vd9Qi5eK9tUhxv1UPxuLmzx9voQ==
    Pjf1cvjXQK7Opw4oW9bMFh8q30p3/GHSPd31DeULJq4PndvEVWPEk3j1J0W+MbBPLtsY3Gv0JKQXfwNQSwMEFAAGAAgAw1Y2S8SmQhP8BQAAlyoAABAAAAB3b3JkL2Zvb3Rlcg==
    Mi54bWztWt1u2kgUfhXkvegVtcc/2KDSCjBpoqYVClW70moVTcwAVu0Za2Yg0NU+2V7sI+0r7PHPGBNIAoS2acVN8Pycb86cc74zZ+z898+/r94s4qg2J1yEjLY19NLQaoQGbA==
    FNJJW5vJcd3TakJiOsIRo6StLYnQ3rx+ddsaS14DWSpat0nQ1qZSJi1dF8GUxFi8jMOAM8HG8mXAYp2Nx2FA9FvGR7ppICN7SjgLiBCwUA/TORZaARcsdkMbcXwLwimgrQdTzA==
    JVkojHhTI5YQCoNjxmMsockneoz5l1lSB8wEy/AmjEK5BDijoWAYmIDTVgFRL9VIRVq5GsWPkuC7rJuL+CyYxYTKbEWdkwh0YFRMw6Q0RXwoGgxOFcj8oU3M40gr3Yjsp/nRzw==
    PbIC3EX9wo1xlGv+MCIydvBIClFK7KLC+ppKkxiHdLXwQaapGBc5+wGYGwANQfaDcAoIXSzjFTVuk8nTvPyWs1myQgufhnZBv5RYdL8NFtFSjWDxNGWGU5wAleOgdTGhjOObCA==
    NALf18B9tcwDtZQlWpr/5E1U/Ax48TCUywhmtOY4amsfU+m3PIRQ1IvxzzAGAekYBmRZ6FkmAJ8EcjWjC+pALs5aLFFQFDJvKhCwiEGCwTPJ0qb42tYyIJHggGTPGU5ExvJA0Q==
    GyYliw8U5uFkeujCIRXhiJw/SfrTQdL6huFvoku8ZDNZumgcLkjFjT0SRe8xr5j6tgDOp48W+I5FYNz07M0Z+l28dG3GvqiNGHYnwx2HXMgrBjAobUa4aK0GeyyaxbQyrjqyKQ==
    lJ134QgvW5/yFqooUQZxGrLp4wR+AaTQ3nFQsadd+80H+/W1taCUAGOBD68G4C/DaHpm08l0zTrTLqdnulZPdX3MpjVM0zizcjbyfAMBpnKYwEFeeIufk2pUmqZbLl9IyCD/qw==
    Wo+QNN3OMMFUIdoqLoLChRWfb4kJvZyprxYVI1n85O1CswjTiVpmhOv+O4VQjOMoxEJN+O0Dnrdq+jnBEMd6Ly1p6PKSTDBkJSxJWhooTfFkXWiYlXd8dD3EERHXcOaO5fUFnQ==
    szRVIsuwFMtGSq6OTMtyPcN11PaTCCg1ZREsnjZHLBhAQabmI9Rvoo7fb3g92/YaqOsbXt/wEOp4TdS0fbWxuyhY4m5I01oUkBJOgIjvcZJAGxJ9nvOpMNov0pJgVQqMlhRDSw==
    1CmeQ12VMC6F/ugm9ReptxZQCU7bmg6wLTDOZ0gLVxnC73GU7ugP9Gc2lttZtbaaGwazZCMZJxfQdeG3tb8aTa/X7zfMum87dt12Hafe9Vy7jnqo0fEN1IfY/1s5iixkYZgyNA==
    4KFPRwOez4BWj1EJi2U+uJ8vg82uK5+M8SySlZEMZC0ExdfShV6hlfjaE3c6VUjqK/F1Pju21UQ5UXeMbfl6q00z1uTz8uWUdUoz6AWd9JzZGdG3pZg7xvimKeYuvx8n7qfOxw==
    KzIJheTZpeADu768iY7KX8/0jKbjNHfi71nD8A0TgYzft22j020YHcc981DXcW3fMn8R/m61+nen8T0HEjKdLQdS5RRJ9gzwvXNCslbfphYER6pjHuqlKKTkch6VyaGMikKcMw==
    Nu5zXu5BJFD4gF+5Opm2U3QtHWx10VpWuG8hsHepUDU9bEsee1H2nMVkgCfkG1DUNpwGMk8UTVsVK58o+SwoWXXJj6VgkRwGU7j4Hf+s9GzPNQzk7lbr/upE3LT1iY7Pgo6bjg==
    +bGk7L/HYXRsLjqu51oNz3JPXIRWaeLnTcGnvR35tVlbuvDoZL3/6pvfxn+Wq+/x0gdCXgO5ltN0TtnjgVvv804mD2SGx+J6UAnrAzLDBzZMcJB9jlxLAMd72bXhiu3vu45cNg==
    qzr+iEQzms0mMpHdOBFtRTRl5xO/fhS/lAe+C62KQvx4rDIN23I9s3wTfyLVysonTu3JqUPoU9j6u7Anq4uPxx0rfYVjONbpe0eFO5mNnzdzjnt1/JnIljlnb6oVl7783yu2mA==
    wDdt5DsPmGCf/Z4xJglXl9yNL8bqCr32xdhc26+yUbm1MWj/P1BLAwQUAAYACADDVjZLkCYKS+4BAADlBgAAEQAAAHdvcmQvZW5kbm90ZXMueG1sxZRLbtswEIavInBvk0odtw==
    ECwHaFwU2QXJCRiKsoiIQ4KkLPtsXfRIvUJHTztNYMjxohtRJGe++YdDzp9fv1d3e11GO+m8MpCSeM5IJEGYTME2JVXIZ99I5AOHjJcGZEoO0pO79apOJGRggvQRAsAntRUpKQ==
    QrAJpV4UUnM/10o4400e5sJoavJcCUlr4zJ6w2LW/llnhPQeo91z2HFPepzYT6Nljtfo3AAXVBTcBbkfGPq9ImMl4GZunOYBp25LNXevlZ0h0/KgXlSpwgFxbDlgDJ6Dg6RHzA==
    RhmNS9LJ6IfBw02J27lsjKi0hNBGpE6WqMGAL5Qdj0J/loabxQDZnUtip0syljFeXFfHTVeRI3CK/L6MuuyUnyfGbEJFGsToMUXC25iDEs0VHAN/6mhODje+vQxw8w6w9PIyxA==
    bY+g/qCPT6O22+uq/NOZyh5p6jraA7yOLLgswf62nN5gf52Y54JbfMpaJA9bMI6/lKgIax9h+aK2AlHzSshJE4zqJBwsmnlpuePBOIJLKkvJLG7tLE6xxWZPKWFsweLvX5ekXw==
    emyWfizY/fLLsPS0kTmvynBi3EIeXTN4ywXKRFueB4m9Bls2Xa/oaNBZDUr6PddZtN9e9UcJCANBQdV2oed/k2H/KZcPRZ3L6/jv138BUEsDBBQABgAIAAAAIQDHzvKouQAAAA==
    IQEAABsAAAB3b3JkL19yZWxzL2hlYWRlcjIueG1sLnJlbHOMz8EKwjAMBuC74DuU3F03DyKyzosIXkUfILbZVlzT0lbRt7fgRcGDxyT830/a7cNN4k4xWc8KmqoGQay9sTwoOA==
    n/aLNYiUkQ1OnknBkxJsu/msPdKEuYTSaEMSReGkYMw5bKRMeiSHqfKBuFx6Hx3mMsZBBtRXHEgu63ol46cB3ZcpDkZBPJgGxOkZ6B/b973VtPP65ojzjwppXekuIMaBsgJHxg==
    4nvZVBfLILtWfj3WvQAAAP//AwBQSwMEFAAGAAgAw1Y2S1FVIoHuAQAA6wYAABIAAAB3b3JkL2Zvb3Rub3Rlcy54bWzFlEtu2zAQhq8icG+TSh23ECwHaFwU2QXJCRiKsoiIHA==
    gqQs+2xd9Ei9QkdPK01g2PGiG1EkZ775h0POn1+/V3d7XUY76bwCk5J4zkgkjYBMmW1KqpDPvpHIB24yXoKRKTlIT+7WqzrJAYKBIH2EBOOT2oqUFCHYhFIvCqm5n2slHHjIww==
    XICmkOdKSFqDy+gNi1n7Zx0I6T2Gu+dmxz3pcWJ/Hi1zvEbnBrigouAuyP3A0O8VgZUGN3Nwmgecui3V3L1WdoZMy4N6UaUKB8Sx5YABPAhnkh4xG2U0Lkknox8GD3dO3M5lAw==
    otLShDYidbJEDWB8oex4FPqzNNwsBsjuVBI7XZKxjPHiujpuuoocgefI78uoy075aWLMzqhIgxg9zpHwNuagRHNljoE/dTSTw41vLwPcvAMsvbwMcdsjqD/o49Oo7fa6Kv90UA==
    2SNNXUd7MK8jy1yWYH9bpjfYXyfmueAWn7IWycPWgOMvJSrC2kdYvqitQNS8EjLtglGdhINFOy8tdzyAI7ikspTM4tbQ4hSbbPaUEsYWLP7+dUn6pcdm6ceC3S+/DEtPG5nzqg==
    DBPjFvLomsFbLlAn2vI8SGw22LTpekVHg85qUNLvuc6i/Q6yP0xBgAnKVG0jev43HfafsvlQ1MnMJhO//gtQSwMEFAAGAAgAAAAhAKpSJd8jBgAAixoAABUAAAB3b3JkL3RoZQ==
    bWUvdGhlbWUxLnhtbOxZTYsbNxi+F/ofxNwdf834Y4k32GM7abObhOwmJUd5Rp5RrBkZSd5dEwIlORYKpWnpoYHeeihtAwn0kv6abVPaFPIXqtF4bMmWWdpsYClZw1ofz/vq0Q==
    +0qPNJ7LV04SAo4Q45imHad6qeIAlAY0xGnUce4cDkstB3AB0xASmqKOM0fcubL74QeX4Y6IUYKAtE/5Duw4sRDTnXKZB7IZ8kt0ilLZN6YsgUJWWVQOGTyWfhNSrlUqjXICcQ==
    6oAUJtLtzfEYBwgcZi6d3cL5gMh/qeBZQ0DYQeYaGRYKG06q2Refc58wcARJx5HjhPT4EJ0IBxDIhezoOBX155R3L5eXRkRssdXshupvYbcwCCc1Zcei0dLQdT230V36VwAiNg==
    cYPmoDFoLP0pAAwCOdOci471eu1e31tgNVBetPjuN/v1qoHX/Nc38F0v+xh4BcqL7gZ+OPRXMdRAedGzxKRZ810Dr0B5sbGBb1a6fbdp4BUoJjidbKArXqPuF7NdQsaUXLPC2w==
    njts1hbwFaqsra7cPhXb1loC71M2lACVXChwCsR8isYwkDgfEjxiGOzhKJYLbwpTymVzpVYZVuryf/ZxVUlFBO4gqFnnTQHfaMr4AB4wPBUd52Pp1dEgb17++Oblc3D66MXpow==
    X04fPz599LPF6hpMI93q9fdf/P30U/DX8+9eP/nKjuc6/vefPvvt1y/tQKEDX3397I8Xz1598/mfPzyxwLsMjnT4IU4QBzfQMbhNEzkxywBoxP6dxWEMsW7RTSMOU5jZWNADEQ==
    G+gbc0igBddDZgTvMikTNuDV2X2D8EHMZgJbgNfjxADuU0p6lFnndD0bS4/CLI3sg7OZjrsN4ZFtbH8tv4PZVK53bHPpx8igeYvIlMMIpUiArI9OELKY3cPYiOs+DhjldCzAPQ==
    DHoQW0NyiEfGaloZXcOJzMvcRlDm24jN/l3Qo8Tmvo+OTKTcFZDYXCJihPEqnAmYWBnDhOjIPShiG8mDOQuMgHMhMx0hQsEgRJzbbG6yuUH3upQXe9r3yTwxkUzgiQ25BynVkQ==
    fTrxY5hMrZxxGuvYj/hELlEIblFhJUHNHZLVZR5gujXddzEy0n323r4jldW+QLKeGbNtCUTN/TgnY4iU8/Kanic4PVPc12Tde7eyLoX01bdP7bp7IQW9y7B1R63L+Dbcunj7lA==
    hfjia3cfztJbSG4XC/S9dL+X7v+9dG/bz+cv2CuNVpf44qqu3CRb7+1jTMiBmBO0x5W6czm9cCgbVUUZLR8TprEsLoYzcBGDqgwYFZ9gER/EcCqHqaoRIr5wHXEwpVyeD6rZ6g==
    O+sgs2SfhnlrtVo8mUoDKFbt8nwp2uVpJPLWRnP1CLZ0r2qRelQuCGS2/4aENphJom4h0SwazyChZnYuLNoWFq3M/VYW6muRFbn/AMx+1PDcnJFcb5CgMMtTbl9k99wzvS2Y5g==
    tGuW6bUzrueTaYOEttxMEtoyjGGI1pvPOdftVUoNelkoNmk0W+8i15mIrGkDSc0aOJZ7ru5JNwGcdpyxvBnKYjKV/nimm5BEaccJxCLQ/0VZpoyLPuRxDlNd+fwTLBADBCdyrQ==
    62kg6YpbtdbM5nhBybUrFy9y6ktPMhqPUSC2tKyqsi93Yu19S3BWoTNJ+iAOj8GIzNhtKAPlNatZAEPMxTKaIWba4l5FcU2uFlvR+MVstUUhmcZwcaLoYp7DVXlJR5uHYro+Kw==
    s76YzCjKkvTWp+7ZRlmHJppbDpDs1LTrx7s75DVWK903WOXSva517ULrtp0Sb38gaNRWgxnUMsYWaqtWk9o5Xgi04ZZLc9sZcd6nwfqqzQ6I4l6pahuvJujovlz5fXldnRHBFQ==
    VXQinxH84kflXAlUa6EuJwLMGO44Dype1/Vrnl+qtLxBya27lVLL69ZLXc+rVwdetdLv1R7KoIg4qXr52EP5PEPmizcvqn3j7UtSXLMvBTQpU3UPLitj9falWtv+9gVgGZkHjQ==
    2rBdb/capXa9Oyy5/V6r1PYbvVK/4Tf7w77vtdrDhw44UmC3W/fdxqBValR9v+Q2Khn9VrvUdGu1rtvstgZu9+Ei1nLmxXcRXsVr9x8AAAD//wMAUEsDBAoAAAAAAAAAIQAyUg==
    frUKAAAACgAAABUAAAB3b3JkL21lZGlhL2ltYWdlMS5iaW4KialqfI+Jy26tUEsDBBQABgAIAAAAIQCd6dJgtwwAAJ90AAAaAAAAd29yZC9nbG9zc2FyeS9kb2N1bWVudC54bQ==
    bORdTW8kOXK9G/B/KOhsjoJkkIxobM+CDJLrvTW868OeFtWl6pYwpSqhqrp7BMP/3ZH66I/dnXFqZoy06UZDyqwkI5N8jy8iSFbqd7//8Xa3+rg9nm4O+9cX9ju4WG33m8PVzQ==
    /v3ri3//czd0sTqd1/ur9e6w376+uN+eLn7//T//0+8+vXq/O5xO6+N9PWw+3G7355Wa2p9efbrbvL64Pp/vXl1enjbX29v16bvbm83xcDq8O3+3OdxeHt69u9lsLz8djleXDg==
    LDwc3R0Pm+3ppPeV9f7j+nTxZG7z4zxrV8f1J608GcTLzfX6eN7++Gzj9u+f6HC33evFd4fj7fqsp8f3l7fr4w8f7ozavFufb97e7G7O92oO4rOZw+uLD8f9qycT5vNjTFVePQ==
    PsbTr+caxzn3fazy3IsPd7w8bnf6DIf96frm7nNX3P5Sa3rx+tnIx59rxMfb3XO5T3cWfx2O9RGRLwbnPP4TjLe7xyf/eYsWZiAymfhcY84jfHvP5ye5Xd/sv9z4F3XNV51rww==
    ywy4vzMQT9uXmQhPJi5P97dfhsanu/e/DuU/HA8f7r5Yu/l11v64/+GzrUluXmDriS1fM/j06x7mT9frOx3Kt5tXf3y/PxzXb3f6RIr9SuFbPSCwmkbJxfcqhleHzRvVnNNXxw==
    Xx2+OU4n+/Wt1nj1cb1TpaUmtWBLPiCiQ4rR1eaK9fp5c+nicqqxWZ+37w/H+7+t/Yftfntc7x4LvV/vdtvj/fO1u916s70+7K62x+n65bdWzvd324eHnA6eq7x9+2a3+der5w==
    8p/LvN1erz/eHI7fnDxX2hz2Z1WYpzrfFH3/4ebqudh/uJgku5pMdzkZ1LaZEqI1yWVqvnUMzP/5ZOWb7no6KYerhye/U4vqpq7+7fUFQI2phn7x/FHdvlt/2J2nK6lDK/B85Q==
    zVcfPRh5NH33p/P97kVYXH6uO3XAw03fHB+M01TqwfjxqcA3xt98gePP2x+fu+up6Pl72d1sflhdb4/b1fmgrve8Pa7Uc52/ewDisezj3b/uoMc++XI+l3WBuyf0nqkl9B2zUA==
    lBYBeojCncdhXedMhXsxrYRqsBMZqhWMcEyp2Eje07Ksm4PFT7IOnS/5UXn+97POdY+t1QSRBCtR7uBqDq2Kjv6eBtK6kqV0l5zpNhWDNmv87CWY6nsjvVYw5GVZNweLMbSuqA==
    AjimkAp1dCI55R5DDzVbwIxuHNYhO5bYgqFW0SBGNqWo4HX1XqEiQ0m4LOvmYDGG1pUQSPsthKSBREuBoDvxPieHIQTbBorrLJETFwwWcgbJgVGPlg30nILi2zP2hVk3A4sxtA==
    rnWBXm0pKQlalNyyDv0ivlOs0Po4rLOxsxIvmmohq4et3bBYMqDtRNvIxbKwh52DxRhaZzWibiGm4CCjNpt9ItV2FEoNax2JdZaixSmaq109LGAxbPWHVTnhHJsL6JbOYf97LA==
    xtA66c7VwmBriBrrANdSuUSInkE6D5RNMIvjQGxCn1gXklUPW4sJyN4WlyqCX5Z1c7AYROuK10EVQ3a5Y02VigJAZFOjAtnjOKxL2KAWxwZSUw+rIbpmEx4Mka+tMdoYYWGtmw==
    gcUYWtdy7lSnOVNqqD9ydQAC0VHphbGMwzoVD9SIDkwS1myiizclE5gi2dYCKXlaeL5uDhZjaF3zyWPzME0LYRPLBM7H3krwXFqWcVhXEkCk6Ex20ozmiNHkIGy8VN84qYvtCw==
    a90cLMbQOpQkpXuS0DRsjY2okEuRNKrtGlv4cVjnM+aoLTW1Oausi8Vk69XXcoy+pxQ0Yl+WdXOwGEPrYg3QpuW+kACr+ByiDq+ac05epORxWMch5lJKM5pMqIdFsSYX8KbmkA==
    UoaeOpZlWTcHizG0LiTn0QGmpuMrB9a41druQtfUjsAPtDYBULg5nmhWlHUpBJM1RTSpTaFTdlbywh52DhZjsK44zyRNpFltabWZbANsPTWQltNAaxMcMHECa6SIqF9VmcsweQ==
    2OC71ahJFWbptYkZWIzBOvU7UgWdcLPTingW7pEpd+0hPaGB4jrQdiXVutggGqyWlXV2SmS7xlFFs1gvy7JuDhZjsM41fVrWkCY7xAKxYC2hOqsRhehIGyiucyWJB29Nc6kb1A==
    OMlwm46IfQo9llgXniWeg8UYrOvgyKEHbSGihtkM5KGyI6oWqx9ovq7GrpFdjIaUY9PqfzWF8+Rwc3bQwFNcWOvmYPGTrKMYKvpfzLr2wLP1/n711J+r8/X6vLo/fFh9Wk9nhw==
    1XF7t12f/2V1s9/sPkxft1gdzkrTzxWm38fD7vTd6i9aa7Per9a700GLn7bHydzN6bnIan08fNhfrc7TBuXV8fDppKVWh+PVRPXnG63utNNPq8O71fqx4P/MAKjTdksMKXoqWA==
    fMlVbGqh0zSjVtpAslsrMksh46LTAZBIExtAMb52V0OpjSQtOwDmYDGG7ILr0lWQnG2EHJElUaU67fhR18N2HNYpQ8hZRmVdLwYhdpM7iJGYOFZrncWFN9PPwWIM1llBxADMFQ==
    Emr7qFfKjb3Y2jO5gba/9KLgKUeMCINBbaOhmFE9fu+WmWywC08dzsFiDNbFGrNqOaWYI2oIzT3loGrgS89dc8xxWBday0TkjDrYbDAjGs1WxbTiWwYKlpbedDUHizFYN82ZRQ==
    izYhdB1fXEjj/Gk/LXrVejvQJE6XWNjabjxZp1pH1lCPwVRh5ImELi2c2MzBYgzWOcRqSyUW0RzO5ZKkQEMI1FxXbR+Hda4kFRKoJmCsBn1LhioWo592ccI217bwJM4MLMZgXQ==
    iozCwceoELge2EOx1CBnhJLsQF+SdJyhNUmPOQT63kwBJBMradykqlfDwhsR5mAxBus8lmm5mzSM8Ghtyj2JeE8uugDZD8Q6EFU0Dc4NkBIOmZV17KsBpwF7yComLSzLujlYjA==
    wTosLYWE01eQNaIgFYRQNJVKAVTtcxtoI0KGNM2dBBO6BncYu1Ot62wweaVcxIB94S8OzcFiEK0rFNsUtMbWNZ7uxMySNZ6Q0JnSSNkExsS2BkOpFYNVj0pEZ3xMuUaxrrWFNw==
    IszBYgzWQbUucW5FXEFwnV3SYJtj0uEvnHAc1vlcbY/qYV1qfXr5RTfknBgN2ruvkGxoC2vdHCzGYJ217SF7m963gBQ1hQKNX8naTGwZ6zisIwRkK8q6SKp10VUlHIppnZuNtQ==
    R5CFWTcHizFYp51dwWkQQbUhQi4RclBxt0UjjDrSBtMAIUf9r1wLmsMGda6llGpEtaVC7bnZhVk3B4ufZJ31Llj5P8I6USlPFSNOC89kQ4YiMYVpN60PGnGPwzqNz1u2tZlphw==
    idFme1OaeBOgYYJClXDhV67MwWIMrdPWhE6Npxdnoe85J8vTdtocOxGWgdZhg/easoIzzrdmkHI2RL0blb+YUBpAtwtvpp+BxRiss2DRNw2twzRFmULRcVU6Jo5Oo5080NpEiA==
    KnYNVeZ6nLY1k50205PRAK8jaR6LcekXOM7AYgzWFe23FHLqIlH7Hrkn0J+11iRJ/ED767oUC0GysRoiGRQCw7bh9HqpXlwTlrrwF8LnYDEI60DTdFA999WjABDWxEFcRefYtQ==
    gXLYPEXqHbvxYFXwhL3JPpJJjB69CKelv642B4sxWEcpOuk5ArSMpArAoYGPGr5qsm5poBWxWGNjCclQjsWg05SCI0TTvBUuPdu89It+5mAxBusiOqYevQWqqE3NVYIkzzXWog==
    mftA++tcwRySnfYSMxvNFKvhANPaRCUGTR9Ljgvvr5uBxSBaJ4Gr42bttMUsV4rqeoK1qu+EwQ3Eut5abahJqzoyZV0oyTBmNpXEQXNeil94vm4OFmOwTnR8ecw5ZhbMJZXptQ==
    rdZhccixjrQ2YVtmF8vDXs4ph2XlH4IYxapw6F0d2cvjulYjtfSPWPctHx9Y9/TRT7JuDhZjsC76LpFK5KJRtQjk7ooHp54o1ko4UlyXYvHOJ9NheqlZlK7ZhPdGso0izbOzLw==
    39X5m7JuDhZjsK736EJNLiRB1CBWAwhb2TrtgQB1pG8mwjTZT8UZG4AMMmleoVRTD2tl2sGbA7x8beI3Zd0cLMZgXWIPQVOlxH16c6YtGrlGjXlstg1iHUjriqYSmho2E9wU1w==
    +SyqddhNytkl9b2B08vn635T1s3BYgzWPfXTV8/0V2MpIFiPPg6kdFVZN/3hgVY4aS5hmynZB1NcZo2kauf4cv/6+O8fcY6s5+weOfAtO4q3IvYXs6M98OH/4+sCfoaoOFDSKw==
    tgapQTnqpnfvgWVTbBdj+7QFRKg6ePnC7QJEfZQxbf95ffcbqNmX49PDyd/+RdHv/wsAAP//AwBQSwMEFAAGAAgAAAAhANJ3OzP1AAAAdQEAABwAAAB3b3JkL19yZWxzL3NldA==
    dGluZ3MueG1sLnJlbHOMkDFPwzAQhXck/oN1EiNx2gGhqk6HFqQOLDTdshz2JXHr2JZtIP333FKJSgxMp7vT+97TW2/myYkvStkGr2BR1SDI62CsHxQc29fHZxC5oDfogicFFw==
    yrBp7u/W7+SwsCiPNmbBFJ8VjKXElZRZjzRhrkIkz58+pAkLr2mQEfUZB5LLun6S6TcDmhum2BsFaW8WINpLpP+wQ99bTbugPyfy5Q8LiaUg601LU+Q7MRvTQEVBbx0xXW5X3Q==
    MXMd3Ql1+Pg+dTvK5xJid7Assb0l87CsD+go87x6VSaU+Qp7C4bjvsyFkkcHslnLm7KaHwAAAP//AwBQSwMEFAAGAAgAAAAhAKRHygOFAwAABwoAABoAAAB3b3JkL2dsb3NzYQ==
    cnkvc2V0dGluZ3MueG1stFZLj9s4DL4X2P8Q+LwZP2I7qbeZIjOJ+8CkXdTpZW+yLSfC6GFIctL015eWrXGKcYt0i54s8SM/UhRJ+dXrL4xOjlgqIvjS8W88Z4J5IUrC90vn8w==
    Lp0unInSiJeICo6Xzhkr5/XtXy9enRKFtQY1NQEKrhJWLJ2D1nXiuqo4YIbUjagxB7ASkiENW7l3GZKPTT0tBKuRJjmhRJ/dwPNip6cRS6eRPOkppowUUihR6dYkEVVFCtx/rA==
    hbzGb2eyFkXDMNfGoysxhRgEVwdSK8vG/i8bgAdLcvzZIY6MWr2T711x3JOQ5ZPFNeG1BrUUBVYKLohRGyDhg+PwGdGT7xvw3R/RUIG575nVZeTRrxEEzwhihX+NIuopXHVm+A==
    iyVS9JqUdNADySWSXcH1+WBF8m7PhUQ5hXAgLxM42sRE59xClR8JPk3gg8ANbwmp47byEleooXqH8kyL2mrMA6+DD+f6gLkpr/+gcSweBlGHFwckUaGxzGpUwCXdC66loFavFA==
    H4S+hyaRcIe9hWmZdtUonG4e0Fk0+gLJunYEBo4YHOW7FtuKEvoFTCW5PuetgYnGt0GPOhIwPiQp8a5NYabPFKdwmIx8xStevm+UJsBoMvEbEfwsAMgzeP4Il7471zjFSDeQtg==
    P+TM3ExKSb0lUgr5jpcwAf6YM1JVWIIDgjTeQrkRKU4mz28xKmFq/6Zf97Ks4A0olV18EkJbVc+bp97mrq/sFh2QYOV56WIMCT1/FcU/QubBGPJjPwt/9nI1arOIvDgNx5DVKg==
    XHizMWQdz9dROoZs5vF8No6s48VmPopsAn9h/LhPWWRJ+x78K+2qbYkJ6yzuEcslQZNt+2K4rUYuH+8It3iOYXLhSyRrcgtOpx2gYBLRFGaIBUzaWFISVa9xZdZ0i+R+4O015A==
    qBTm2fsnrgJKDss3UjR1h54kqrtStyp+GPaWhOsHwqxcNXlmrTjM2guo4eXHozR5GtJzSjSUrBkZD8iUvtHFfPo561uDyqwta7xFdd11R773lw4l+4P224LWsCvhx8Js8n3QYw==
    gcGCDjMbVLQnA+1+McgCK7vQm1nZbJCFVhYOssjKokEWW1ncyuA1wJIS/giNapetvBKUihMu3w74M5F9bgoCN56dWT68En93GCUKJkcND4oW0mL/GMyPzEujd1Aoj5C7T7i6Qw==
    Cpddrdo/uNtvAAAA//8DAFBLAwQUAAYACAAAACEAg9C15eYAAACtAgAAJQAAAHdvcmQvZ2xvc3NhcnkvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHOskk1LxDAQhu+C/yHM3aa7ig==
    iGy6FxH2qvUHZNPpB6aTkBk/+u8NwmoXl8VDj/MO87xPIJvt5+jVOyYeAhlYFSUoJBeagToDL/Xj1R0oFkuN9YHQwIQM2+ryYvOE3ko+4n6IrDKF2EAvEu+1ZtfjaLkIESlv2g==
    kEYreUydjta92g71uixvdZozoDpiql1jIO2aa1D1FPE/7NC2g8OH4N5GJDlRoT9w/4wi+XGcsTZ1KAZmYZGJoE+LrJcU4T8Wh+ScwmpRBZk8zgW+53P1N0vWt4GktnuPvwY/0Q==
    QUIffbLqCwAA//8DAFBLAwQUAAYACAAAACEAiY03DNAIAACSIQAAEQAAAHdvcmQvc2V0dGluZ3MueG1stFrJcuNGEr1PxPyDgueRidoBTqsdhW3cjtbYYcqXuYFEUUI0tiiAUg==
    y18/CZBoLf3kaNvhk8B6VVm5vMwsoPTu+89NfXHv/FB17dWKfResLly778qqvb1a/XqTX4ari2Es2rKou9ZdrR7dsPr+/T//8e5hM7hxpGnDBYloh02zv1rdjWO/Wa+H/Z1rig==
    4buudy2Bh843xUg//e26KfynY3+575q+GKtdVVfj45oHgV6dxXRXq6NvN2cRl021993QHcZpyaY7HKq9O/9ZVvhv2fe0JO32x8a147zj2ruadOja4a7qh0Va82elEXi3CLn/PQ==
    I+6bepn3wIJvMPeh8+WXFd+i3rSg993eDQMFqKkXBav2aWP5laAve39He59NnEXRchbMT881V39MAP9KgB7cHxOhziLWw2PjPi+ChvpbXHKCPlY7X/gT4c7+aPabD7dt54tdTQ==
    6pBfLsi0i1m71Xti+W9d11w8bHrn9xRqSpEgWK0nwLumu3c/U+p0bVF/aE+7EZ2eoWkxOtuWN1Xj5lEKSnfYjjRKIofe1fWcZ/vaFaTKw+bWFw1lyDIyrynGsSDlyxvX9PW00g==
    b6ryauU/lOw0oXSH4liPN8VuO3Y9SbkvyCWGn/W8e+zvXDtr9j9K4QWXXJ3w/V3hi/3o/LYv9qRO0rWj7+plXtn9txsTSldPbDpLLP32ruhdetp4eP+u2wzTwFmT4eJ+4z6Trw==
    XFmNVD76qmyKz1crHshokrBGIh42h64b2250P/vnv0iPydzLs7Gvhmcb16/Xurb86scrOS9HFzEvFp5q1NPT9lTvaElbNMSVFzXsuivdFMGjr76d1NOC2clsiQXciIjkfVW6mw==
    iaPb8bF2OcVoW/02cevH4zBWJHEO8F/Q4PcUIPrQzj9RVt089i53xXgkNvxNm82Ey+uqv6687/yHtqS8+9s2qw4H52mDijLrmphY+e5h9vMPrigpt//ivuvnNKImW85Mnx5+IQ==
    xi5Tg0Al3IjkXFgIfUICpk2ylJyXiOCZnhPqa0SZLIaICbIsxIhk6uyrV0gopRUQsVorC5FUWZ1CJAsMyxHCAhFKDRFmIgHtYVynWAMmpDXQHjIzMdAepjlLoUdZTBrA+LCUJQ==
    GceIDgMDkZzx+JzyL5Gp04bQHh6YWECtuVCJhQzhUsVBBhHNQgN9zTXXEfQ11zpKMWJEbKHfeKR5iDWwPEohD7gVIYe+5rGOMUN4xq2CiBDGcOg3oVS2NMlXiJGCYWmhkBHUTQ==
    RJKshYgVLIU8ENa8kcEiZqnCSMp4AKMgUhmH2J6MMwOzXuTGYPbKifPQB+SbSMHclhFxUULEyhRno4w5z/E+sTQZ3ifWeQbzRyY6sBjJuRTQUsW0DmBMFZd5BnVTkrME7qOkiA==
    GOSbUvyN+qa0SBNoqTKCJTBLVGiYgqxSkcoNXhPRRjAblQ2iCEbu7c6kcq4wR1WusuQNRMcJlKapwnFY+TQLrIC81ozbGFqqOQ9yGAVNRTHF+8ggxFVZG84VzDltjE3xmpD8hg==
    dQtFksAo6FBmuG/rKDA5ZK+23Bq8JhEB7mY6kSqE2aiphkTY16mWFmudTz0DIYZRMsBoG6YzDvlGxxDiCESUMDGMnNFBbmF9M1oxbI+hpMc10RhqZ28hNsX2REYEkAfGBpZDHg==
    mJiqJbY0ExznXEg9EK8JmUo5rAchMxmuYiGf2j1EBB0QYHzoMEgdCCOUWNBSQrIAejRUQmR4jdIxzu3Q6iCGuR0mIgogr8PUSAPjE2bEBFh7w5zqDtSakpGncJ+IU2eAHI2ESA==
    cXWJpLAMRi6SSsSQB5GiTocRzSLMg4jsDGBMo5BHCmZJFDGOs4QQo2A9iCaD8D6RCRWWFssQn+OjVFFZxgidArClGZUXLC3jimGtc85wfGwQxNEbCLMxrLA2kGEG40OtLMGssg==
    ksf4VGONzgXMYEt8xyd8S+dRnFk2Mhwz3uYsS99ApFQw62N6z7FQt+lgh08bseDUZyBCh2js0VgKgzttrKjK4zWa3kMhE2MqfQrGJw7phAJ9EEcssTDr40jT+QUiCRccW5pyhQ==
    3+fiVCjcaYke0RtRyHSMa3ycBzmDutHBLmEwSxKhcwY5mkjaCno0kSzNoD2JNDyAuiWKDuswcolSb5x3EqsFPqkmsQksjFySsjiC0lJ6Z8PZmHJ6f4f2pNS2U+jRlJMTIEdTAg==
    ErwPlXgN85SoazXkW6qn8xhEDLf4mwMhWYB9YJTFfTu1xB2sgVVhALmTxvKNE0qa6ByfkdJc0EYIyRhjCYx2xnlsYJZkMkhw5DLJWAh9kEk68ECPZkrmuDtnWkn8xSzTJojwmg==
    KOC4M2URneSh3zLLpcaWWm4slkYxYDCzsoRFuJtliUxCmKdZGgiD7cl4gr8NZpkSOVyTM8nwl4WcXtoMjA815wgzhBpjjr9+UcsKOZamtcXfIPOQ2Qz6LQ9lmMP45KGWGuZ2bg==
    ZaqxpTG9uGF7YpHit8M81fbL5dNLJGPhGxpMpsL8ISTDXxby3KThLG19gob375rNdL053YucnqYLiIvmtCIpmp2viovr6QJ0Pc3Y+U9x1S74zh06754j2+NuAS8vT8DQFHWd+w==
    Yr8As6HNpqyGPnWH+bm+Lvztk9zzDA9HS3f48Yus6ebO+f/47tif0Adf9KeLhWUKk/K8smrHj1WzjA/H3XZZ1Rb+8Rl0bMuf7v3spyf3PGzGO9fMFzQfi/miYZ7r2stftydn7w==
    a7+dLhHcddH3p7uI3S27WtXV7d3IpuuDkX6Vhf80/9jd8jPGZ4yfsPlHsZ8so9nnh6cxvow9myeWMfE0Jpcx+TSmljH1NKaXMT2N3T32ztdV++lq9eVxGj90dd09uPKHJ/yroQ==
    kxPm68I/e394nl0Xj91xfDF3wqbJ/UsJZTEWy4XMi8UzxV/pMl2o7iui4/ax2T3dg/7rpHhdDePW9YUvxs4v2L9njMlN2e0/UCbR04mLml4Gl++rTM1XreMNkfwTxf0Xd4iLwQ==
    lac8W/6Z4v3/AQAA//8DAFBLAwQUAAYACAAAACEAtOCUGeAAAABVAQAAGAAoAGN1c3RvbVhtbC9pdGVtUHJvcHMyLnhtbCCiJAAooCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAJyQwUrEMBCG74LvEOaeTZMNbV2aLm4XYa+i4DWbpm2gSUqSiiK+uyme1qOn4Zth5vuZ5vhhZ/SuQzTeCaC7ApB2yvfGjQJeX55wDSgm6Xo5e6cFOA/H9v6u6Q==
    46GXScbkg74kbVFumFwvZwFf9QPjp7IrcFXzDnNeM/xYVhxXnDG6p5TyuvsGlNUun4kCppSWAyFRTdrKuPOLdnk4+GBlyhhG4ofBKH32arXaJcKKoiRqzXr7Zmdotzy/2896iA==
    t7hFW4P5r+VqrrPxY5DL9Amkbcgf1cY3r2h/AAAA//8DAFBLAwQUAAYACAAAACEAeqhydMUAAAAyAQAAEwAoAGN1c3RvbVhtbC9pdGVtMi54bWwgoiQAKKAgAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAACsj0FqwzAQRa8iZl/LzSIUYzsEkiyTgtusupHlsS2QZow0Kc7tK0KbE3Q5/Mf7f+rdGrz6xpgcUwOvRQkKyfLgaGrg8+P08gYqiaHBeA==
    JmyAGHZt3Vcd36LFpDr0aAWHTu4+x1/7933nVpmPg5OsvIyjs3gh7wiLNXlQD/BsQoYzC+r6170FlbdQqvoGZpGl0jrZGYNJBS9IORs5BiP5jJPmh/jA9haQRG/Kcqt713vHUw==
    NMt8/5X9i6qt9fPh9gcAAP//AwBQSwMEFAAGAAgAAAAhAFyWJyLCAAAAKAEAAB4ACAFjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbHMgogQBKKAAAQAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMz8GKwjAQBuD7gu8Q5m5TPYgsTb0sgjeRLngN6bQN22RCZhR9e4OnFTx4nBn+72ea3S3M6oqZPQ==
    RQOrqgaF0VHv42jgt9svt6BYbOztTBEN3JFh1y6+mhPOVkqIJ59YFSWygUkkfWvNbsJguaKEsVwGysFKGfOok3V/dkS9ruuNzv8NaF9MdegN5EO/AtXdE35i0zB4hz/kLgGjvA==
    qdDuwkLhHOZjptKoOptHFANeMDxX66qYoNtGv/zXPgAAAP//AwBQSwMEFAAGAAgAAAAhAOsr9MjpEwAAFqMAABgAAAB3b3JkL2dsb3NzYXJ5L3N0eWxlcy54bWy8XduS2ziSfQ==
    34j9B0U9zT50FwDi2jHuCdy47Zi+eLrc088sieXiWhJrdWnb+/WbpKQqlSGKAgU6HFHW7RwkkXkSmSAp/f0fnxfzyV/lal3Vyzc3+Ht0MymX03pWLT+8ufnjff6dvJmsN8VyVg==
    zOtl+ebmS7m++ceP//kff//0w3rzZV6uJ0CwXP+wmL65edxsnn64vV1PH8tFsf6+fiqX8OZDvVoUG3i6+nC7KFYft0/fTevFU7Gp7qt5tflySxDiN3ua1SUs9cNDNS1dPd0uyg==
    5abF367KOTDWy/Vj9bQ+sH26hO1TvZo9reppuV7DQS/mO75FUS2faTANiBbVdFWv64fN93Awe4taKoBj1D5azF8IWBwBCQj4uoyjYHuK2/WXRfn5ZrKY/vD2w7JeFfdzYIJDmg==
    gFWTlvjmR/DmrJ668qHYzjfr5unq3Wr/dP+s/S+vl5v15NMPxXpaVe/BCqBaVMD6k16uqxt4pyzWG72uiuM3/f615v3H5oMnkdP15uhlU82qm9tm0PX/wZt/FfM3N4QcXrGNEQ==
    r16bF8sPh9fK5Xd/3B0bc/TSPfC+uSlW393pBni7P7bd/0dH/PT1s3bgp2JateMUD5sSYhVz1JDOq0YahKnDk9+3zSQX2029H6Ql2P3/THsbTDqEMAT03U5X8G758HM9/VjO7g==
    NvDGm5t2LHjxj7fvVlW9Au28uVHtmPDiXbmofqpms3J59MHlYzUr/3wsl3+sy9nL6//K2/jfvzCtt0t4nAncBsJ8PfOfp+VToyZ4d1k0Pvm1AcybT2+rl8Fb+P8eyPDeE6fwjw==
    ZdGklAn+mqI1P4qCNIj10dGe5tx+deztp6IGyr7VQPRbDcS+1UD8Ww0kvtVA8lsN1NKMOVC1nJWfd0IMhwlY+3g61BjN0yG2aJ4OLUXzdEglmqdDCdE8HYEezdMRx9E8HWEawQ==
    s6mnXVF4FOxZR7Sf5+1fI4bx9i8Jw3j7V4BhvP0Jfxhvf34fxtufzofx9mfvYbz9yTqed1dqTd6CzJabq1X2UNebZb0pJ5vy8/VsxRK42j4rDV+z6JWrJAeZgGaX2fYL8dVs0w==
    on3eHyGtSIev55umo5vUD5OH6sN2Be35tYaXy7/KOTTKk2I2A76EhKtys111zMiQmF6VD+WqXE7LlIGdjrTpBCfL7eI+QWw+FR+ScZXLWeLpOzAmSQrPAQ3982MjkipBUC+K6Q==
    qr7etLpIlh9+rtbXz1VDMjHb+bxMxPVrmhBrua7vDVqa61uDlub6zqClub4xOPJZqinasyWaqT1bognbsyWat118ppq3PVuieduzJZq3Pdv18/a+2szbFH9cdeDL9+7svG52xg==
    r7bjrvqwLKAAuH652e+ZTt4Vq+LDqnh6nDQb06dpj485dhxTz75M3qdY056ZUtX1bYhYOOpqub1+Ql+xpRLXM18ieT3zJRLYM9/1EvsFyuSmQPspTT9zt73fnBRty3SRaO+K+Q==
    dlfQXq+2YnN9hL0IIK9W62QyOE2bIIJ/bcrZxp0pMt+Lldcb9sJ1vay+zkpJzdtTJrByXk8/pknDP315KlfQln28mimv5/P6UzlLx3i3WdW7WDuWPGldcpHk/eLpsVhXba/0ig==
    4vKl/nBOffJL8XT1Ab2bF9Uyjd/8d4uimk/SVRA/vf/l58n7+qlpM5uJSUNo6s2mXiTj3O8E/u3P8v6/0hiooQlefkl0tDrR9lBLZqsEi8yOqZ4lYoIys1pWSdbQlu+f5Zf7ug==
    WM3SsL1blbvLWDZlIsa7YvG0KzoSaAvy4ifIPwmqoZbv38WqavaFUonqfRKyo23D9fb+f8rp9anu13qSZGfot+2m3X9sS90WnY7u+jLhFd31JULrTVgemvhNcLCv6K4/2Fd0qQ==
    DtbOi/W66jyFOpgv1eEe+FIf7/XN356vnterh+083QQeCJPN4IEw2RTW8+1iuU55xC1fwgNu+VIfb8KQafkSbMm1fP+9qmbJnNGSpfJES5bKDS1ZKh+0ZEkdcP0VOkdk11+mcw==
    RHb9tTo7skQlwBFZqjhLuvwnOstzRJYqzlqyVHHWkqWKs5YsVZxlblI+PEARnG6JOaJMFXNHlOkWmuWmXDzVq2L1JRGln5cfigQbpDu2d6v6obm/oV7uLuJOQNnsUc8TFts7ug==
    VE7+s7xPZlrDldKuBDuixXxe14n21l4WnBb5+tq1Plh7J8fVJrybF9PysZ7PylXHMXVjoV++292W8bX5rRkXbXv+XH143EzuHp93+49pOOpFHhr2V7D+AU/NOT/cz3IK9ks5qw==
    touDoeHNFDy7HNxG9Csw7Qe/VBKvkOxCZDgm70e+VMmvkOJCZDimvBDZ6vQV8pweXLH6eDIQxLn4ee7xOoJPnIuiZ/DJYc8F0jPyVAiKc1H0SioTPZ02ZwtC71ymmW78ZeLpxg==
    x6iomyVGTt0sF+uqm+KcwH4v/6qalT0mabbjPV89EeT9toi+KHP+a1vv9u1fnXC6/Kaut1A4Ldfl5CRPdvmJq1dZpnseL0433RQX551uiosTUDfFRZmoEx6VkrpZLs5N3RQXJw==
    qW6K6GwVrghx2SrEx2WrED8kW4UsQ7LVFVVAN8XF5UA3RbRQQ4pooV5RKXRTRAk1gA8SasgSLdSQIlqoIUW0UMMCLE6oIT5OqCF+iFBDliFCDVmihRpSRAs1pIgWakgRLdSQIg==
    WqgDa/tO+CChhizRQg0pooUaUkQLta0XrxBqiI8TaogfItSQZYhQQ5ZooYYU0UINKaKFGlJECzWkiBZqSBEl1AA+SKghS7RQQ4pooYYU0ULd3Wo4XKghPk6oIX6IUEOWIUINWQ==
    ooUaUkQLNaSIFmpIES3UkCJaqCFFlFAD+CChhizRQg0pooUaUkQLtT1ZeIVQQ3ycUEP8EKGGLEOEGrJECzWkiBZqSBEt1JAiWqghRbRQQ4oooQbwQUINWaKFGlJECzWkOBef+w==
    U5Rdl9nj+F3Pziv2Lz91tTfq9+NbuY+pssupDlZ1c11+L4Kp64+TkzceZm2/cRlJdT+v6naLuuO0+jFve0lE1InP3+z5O3yO2a/80qX9vRDtOdOAnF6KDPZU6LmQP0YGTR49Fw==
    6cfIoOqk57LvMTJYBum5pNvq8nBRCixHAfhcmjkC4w74uWx9BA+n+FyOPgKGM3wuMx8Bwwk+l4+PgGzSJOev0ezCeeLP15cGDOfC8YhBdDOcC8vQV4d0HArjUqd1M1zqvW6GSw==
    3djNEOXPTpp4x3ZTRXu4m2qYq0OZxbp6uFC7GWJdHTIMcnVAM9zVIdVgV4dUw1wdJsZYV4cMsa4enpy7GQa5OqAZ7uqQarCrQ6phrg6XslhXhwyxrg4ZYl195YLcSTPc1SHVYA==
    V4dUw1wdFnexrg4ZYl0dMsS6OmQY5OqAZrirQ6rBrg6phrk66JKjXR0yxLo6ZIh1dcgwyNUBzXBXh1SDXR1SnXN1u4vyytVRHj6CxxVhR8C4BfkIGJecj4ADuqUj9MBu6YhhYA==
    txT66uDzuG7p2GndDJd6r5vhUjd2M0T5s5Mm3rHdVNEe7qYa5uq4bumUq4cLtZsh1tVx3VKnq+O6pbOujuuWzro6rlvqdnVct3TK1XHd0ilXD0/O3QyDXB3XLZ11dVy3dNbVcQ==
    3VK3q+O6pVOujuuWTrk6rls65eorF+ROmuGujuuWzro6rlvqdnVct3TK1XHd0ilXx3VLp1wd1y11ujquWzrr6rhu6ayr47qlblfHdUunXB3XLZ1ydVy3dMrVcd1Sp6vjuqWzrg==
    juuWzrq6o1u6/fTqB5ga7vYnzuDDmy9PZfMd3Ec3zMx230G6PwnYfvDt7PmHkhpwY8lk/5NU+5dbg/cnDHcjtsBwqOkjjDXdf3tSx1D7b0F9vo2n/Q7Urwfu+KrU1pCXKTh8eg==
    P6Uvp0J3n3t12vOs3Ztmys/Y3Lrk7BztvNZloNqHYZ+FYM/9fPejXfDg7XIGBJ/2P1i1s3T2udhRwfu2nM9/KXafrp+6PzovHza7dzFqb5r/6v373fe/deJXbaLoJLh9bczu6Q==
    /ofDOuZ7943w+zPYnSHZqOHEdLeXU1w70xfG8LM1R/f6trf6fm1WcC/wbmYLGO23Rt/HUf069OMOZLWumqBoP4KQxJnS+4S//7G7aZM1Dp+QqPm3d9LhF+M6jvtVmphu1xASbQ==
    RvnaL1h66wz1ImOUUkIl58R5YnAGr3sigqnpBZw4MJEjbw6GX2kwU3kmaZYp6QXNcqqt5NZzhHLGrcpVYHAvYGSDSZ5R751AXFrqpNQ5Ik4z76zPaS7CGe4FjGywUVoSJZkwMg==
    p8RaLXTOWc6cxohqSgKDewFjG8yYdDAeExCPXjCJcmKzTAtCGWPYhwb3AUY22OcW5Q4bI4SlmFrttfPM2CyX3CGfBwb3AkY2GEsH43HBCNIUjFGZkOBnaqXw1LnQ4F7AyAbbnA==
    EGcUwo5xSjlSzjhlOOKZQjZXoeh6AWPPsMlgljjTROfUCSeNIUJKLLw0SGc0nOE+wNgxrHUuHYWMLz2FP9oRhCziRJrcKGrCGO4DjG1wJiCvZqjJpNRbrCQiGc+9YZkyXtvQ4A==
    PsDIBlMrrIG1yzIPwuFeSiOJ4BJ0lUOIZoHBvYCRDeaOId9UA0wg6mymGYf5clprkVlrdGBwL2DsWkKQjBJEhYcJ00yBcjDOCawMFJydhStdL2DslY5AGWO9tR7D+A5riT2C/A==
    KjyyXosTK10fYGSDFdRYzkJRoDymWOcaKi6uoKSBMeCJDAzuBYxsMCxXkmSgIa0yiqFaxLAeaA3q1z7DIiwvewGji45g6OMyWLtg4VJeCaZF7nJBm/U2QydE1wMY2WCNtbI4Qw==
    TYFIJbjWCZJzKHBZJmHVDWO4FzCywTKjAnzrsCSGWu9BUw5KXOPB3Zbl4dLcCxjZYKJwxpTKCEYCLEEKWwZ/CNPSQnbd/cL2q46jDzB2SCAYhNLGx1AIZMhAgnJGQoEjlFbIhQ==
    IdEHGH2GMyaZE9QxSXOitMDMYAylbe6tIvzEDPcARjY448wqyRGWCnp37ZQVHioZzHIpHJdhHu4FjD3DXmZe5dRoQqlB3FBnGGQuKBAsLGFhLdELGNlgaNIlgfQJ41IKbbCCFA==
    i5wiUjpMXRbWw72AkQ12UMg6ygTPpAENGe0sNA/g38zC6D6c4V7A2EszyW3OYdqwl1RxCiEpnXRN+w6+V2Fa6wWMbDC2lFJIpMo1aZVJmTupvcosdrmW5ETX3AcYvZbgGvwqBQ==
    15yCclQuNCM8z0yuc2NO1RI9gJENhi7Mc6gTBUU5TJgy0mjd7OZQ6CMgd51oQnsAY6c1CmWBcVJZC6on2kDHhjxFTHqSg5/DtNYHGNlgwRW1imWcQ+9OcqYgYWEJ+VRTZAQO6w==
    4V7A2CsdNU0XKSEaoR7HQufCWqjPCScM6Sw0uBcwssHUeMEEbXanITAl1AbMQB4QDFpirH3YhPYCxp5hI7lvZMM9LFsil0opqyEsobZVUpyoJfoAYy8cDhOoC72xUI/DoqCIoA==
    3CkucqgNlAgL+F7A2AsH9gpr55sTAFRy0D8CBUkM7bvCiob1cC9g7OKHIwfLrCTSeUqRNhxpBo7GBgLVndhI6QWMHcMgG8pUsyetqJKsmSrKGUVWY29PzHAvYGSDLSdeawOdGg==
    gTYSii6JLLTBWgmNCRYsMLgXMHYtkTGEkEEIJAPrVqYhKI2jmVUKkcyHu5e9gLFnWGOEs4wDK4dkSmWuMujkoayxIH4dLhy9gLFjmDmJc044g2oxh8ZSGM200wIWYERNWEv0Ag==
    xjZYM5QZq6Cx9NQ6qL6gGvdN7+Dy3PBw56cXMLLBxmbKaJMrqAqgQbOSYIOh08FGNjtm4SmDXsDY5SWC1lEQ4r2y1Npc5QgmjWqSKUX5iSa0FzCywQrqcVA3VLZQzeQ0N0QzZw==
    coYs/IVEEO4P9wFGNlgrKAYwd46AyjOiJLGZUOBkS9vKPNyq6gOMvnBQlkP+RIhAi+YZdDzOZxhbqTNmRJiHewEjG+w9dOcWxsLQ5yjNNTxDzvCcWswwD2uJXsDYxQ9uriPxTA==
    ONKcZVNGUMWhHiPOeyxcWF72AsauhzPocbDLibcZ9aByZ3SeIZphzzV14e5lL2Bkgx1UAJxBHa5hfeUOK4uV80g55DnlPDyb3wsY2WCcmcxCw2szw2kuiCJQ0jiOHYZll5owhg==
    ewEjGyyZQiyzMGcSZIOENNAEE4ygWrDQP4QLRy9g7FoCQ/NAjHCYQgMB6ys8tbJpK5srpviJJrQPMHYMQ7dANFbMC0mNwRLWLpsjpHIND23YcfQCRq/WYGqgZSDwgBrws885hA==
    aXPhHOIGh6LrBYy9cEiXM59LprmioH2VZQQRR5ChXNIs3NDuBYy9NFNEIN1z2uyrS8w0MpYL1lxQkDGeh1miFzCywTAGNJJeNZdO0izXWmDVXFGgObSX1IQb2r2AsfMwlLcZeA==
    GIaHHkcwAxNlcioUNMeYnzgT2gsY2WDjuGjPx1sowyTUBbmAXk0554QV9kQM9wLGNhhZYqASyDOXwTqAJLQTilniKIFFzIdprRcw9konYIXKNWQlr6mksAQwjzIOAlJYYRm2+Q==
    vYCRDebQSMqcZxhJR8EA7SyzIlOOO9Mk13AjpQ8w9gxbphxRHmOqKYwuodqF4hyDryVlJDS4FzB6HiYqoxo6B2iCtRFG6DzHBMouqMvdic3AXsAJg0GnjrUJL8XeWm65NBw6Bw==
    yFIW6ZyYDJYGDLWukzSM4V7AyAbnUBYyJwgTllKQEcQhdtDwgF0MuRPnmnsBIxssVIYY6FyoXFHMsQHtcOh+scYecXfitFcf4EKDD4/WP/6/AAAAAP//AwBQSwMEFAAGAAgAjg==
    dOxIKQDwpDsBAABIAgAAEQAIAWRvY1Byb3BzL2NvcmUueG1sIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    pVLNTsMwDH6VKvc2TYe6rWo7CRAnJiExCcQtJN4W1iRV4q3bs3HgkXgF2tJ1AnHjZvv7kf3Jn+8f+eKoq+AAzitrCsKimARghJXKbAqyx3U4I4syF9bBg7M1OFTgg1ZjfCZFQQ==
    toh1Rmm9d1Vk3YZKQaECDQY9ZRGjZOQiOO3/FPTIyDx6NbKapomaSc9L4pjR5+X9o9iC5qEyHrkRMKhGhe9hH7WrmhZZW6c5+t6h5mLHN9A5pVQDcsmR0+6ysB5PI2UuRYYKKw==
    CGhf+/3rGwgcOuGAo3Vdt4NTY530AyLBC6dqbHPsJhX3uGxjXCuQ16du4uCgupRLltOxzodgvo1BBu35GZ5qKMgZeZrc3K7uSJnELA3jaciSFUuySZol82h+NU1n8+lLTn/5XA==
    jPWwxL+dz0ZlTn++Q/kFUEsDBBQABgAIAAAAIQBtp+Jgow4AAAGMAAAPAAAAd29yZC9zdHlsZXMueG1s7J1bc9u4FYDfO9P/wNFT+5BYN9tJZp0dW7HrTHPxxs7mGSIhi2uKUA==
    SSq299cXN1KgDkHygKj70E4eYpE8H4FzAw54++XXp00S/KRZHrP0bDR5PR4FNA1ZFKf3Z6Pvd1ev3oyCvCBpRBKW0rPRM81Hv77/619+eXyXF88JzQMOSPN3m/BstC6K7bujow==
    PFzTDclfsy1N+c4Vyzak4D+z+6MNyR5221ch22xJES/jJC6ej6bj8clIY7I+FLZaxSH9wMLdhqaFlD/KaMKJLM3X8TYvaY99aI8si7YZC2me805vEsXbkDitMJM5AG3iMGM5Ww==
    Fa95Z3SLJIqLT8byr02yBxzjAFMAOMkpDnGsEUf584Y+jYJN+O7jfcoyskw4iXcp4K0KJHj0nlszYuEHuiK7pMjFz+wm0z/1L/nfFUuLPHh8R/Iwju94KzhqE3Pq9XmaxyO+hw==
    krw4z2PSuHMt/mjcE+aFsfkijuLRkThj/iff+ZMkZ6PptNyyEC2obUtIel9uo+mr77dmS4xNS849G5Hs1e25EDzSHVP/G93dHv6SJ96SMJbnIauCckednIwFNIlFXEyP35Y/vg==
    7YSGya5g+iQSoP6vsEdA49x/uTffqqDie+nqEwsfaHRb8B1nI3kuvvH7x5ssZhkPnLPRW3lOvvGWbuLrOIpoahyYruOI/ljT9HtOo/32366k8+sNIdul/O/Z6UR6QZJHl08h3Q==
    ilDie1MibPJFCCTi6F28P7kU/1cJm2hLNMmvKRH5JJgcImTzUYipkMiN3jYzdwd9l0ehTjR7qRPNX+pExy91opOXOtHpS53ozUudSGL+kyeK04g+qUCEpwHULo4lGtEcS7ChOQ==
    llhCcyyhguZYIgHNsTg6mmPxYzTH4qYITsFCmxcazj6zeHs7t3uMcON2Dwlu3O4RwI3bnfDduN353Y3bnc7duN3Z243bnazxXDXVCj7yMEuLwVG2YqxIWUGDgj4Np5GUs2SR5Q==
    hycGPZp56aQHjMpseiAeTAuJ/N3tITJI3cfzQpRzAVsFq/h+l/HafGjDafqTJrxKDkgUcZ5HYEaLXWbRiItPZ3RFM5qG1Kdj+4OKSjBId5ulB9/ckntvLJpGntVXEr0khcqheQ==
    /bwWQRJ7cOoNCTM2vGmMeMsPn+J8uK4EJLjYJQn1xPrix8Uka3htIDHDSwOJGV4ZSMzwwsCwmS8VaZonTWmaJ4Vpmie9Kf/0pTdN86Q3TfOkN00brre7uEhkijdnHZP+a3eLhA==
    iWXxwe24je9TwicAw4cbvWYa3JCM3Gdkuw7EqnQz1uwz9jwXLHoO7nyMaRXJ17xeusiC9zpOd8MVWqP5Cq6K5ym8Kp6nAKt4w0PsM58miwnatZ965na3LBqDVpJ6Be0tSXZqQg==
    OzzaSDHcw/YBcBVnubcwaMZ68OAvYjorzOkj8+1bObxhe9bwsDrMSl6bp5EeWpmw8MFPGr5+3tKMl2UPg0lXLEnYI438EW+LjClfM0N+Kk3SK+QvN9s1yWNZK9UQ/Yf68oJ68A==
    mWwHd+gmIXHqx26XrzYkTgJ/M4jru8+fgju2FWWmUIwf4AUrCrbxxtQrgX/7QZd/99PAc14Ep8+eenvuaXlIwhaxh0FGkVjkicSnmXEaexlDJe+f9HnJSBb5od1kVN3DUlBPxA==
    W7LZqkmHh9jiefGR5x8PsyHJ+51ksVgX8hVUd15gxrJhvlv+QcPhqe4LC7ysDH3dFXL9UU51pbQ/3PBpQg03fIogrcmHB+G/Hjpbww3vbA3nq7OLhOR5bL2E6szz1d2S57u/ww==
    iz/NYwnLVrvEnwJLoDcNlkBvKmTJbpPmPnsseR47LHm+++vRZSTPw5Kc5P0jiyNvxpAwX5aQMF9mkDBfNpAwrwYYfoeOARt+m44BG36vjoJ5mgIYMF9+5nX493SVx4D58jMJ8w==
    5WcS5svPJMyXn80+BHS14pNgf0OMgfTlcwbS30CTFnSzZRnJnj0hLxN6TzwskCraTcZW4uEGlqqbuD0gxRp14nGyrXC+jPyDLr01TbB8tsvDiihJEsY8ra3tBxwpWb93rUtMPg==
    yTG4CTcJCemaJRHNLH2yy/J6+VY9lnHYfNmMXsuen+L7dRHcrqvVfhNzMu6ULAv2mlj3CZt0flI+z9Ik9plG8W5TNhQ+THEy6y8sPbomPO8W3s8kapLHPSXhOU+6Jfez5JrkaQ==
    T0l4zjc9JWWc1iTb4uEDyR4aHeG0zX+qGs/ifKdtXlQJN562zZEqySYXPG3zolqoBOdhKK4WQOv0ixm7fL/gsctjoshOwYSTndI7ruyItgD7Rn/GYmTHJE15vuruCZD35SS6Vw==
    5vxtx9S6fe2CU/+Huj7yiVOa06CRM+t/4aqWZex67J1u7IjeeceO6J2A7IhemcgqjkpJdkrv3GRH9E5SdgQ6W8ERAZetoDwuW0F5l2wFKS7ZasAswI7oPR2wI9CBChHoQB0wUw==
    sCNQgQrEnQIVUtCBChHoQIUIdKDCCRguUKE8LlChvEugQopLoEIKOlAhAh2oEIEOVIhABypEoAPVcW5vFXcKVEhBBypEoAMVItCBKueLAwIVyuMCFcq7BCqkuAQqpKADFSLQgQ==
    ChHoQIUIdKBCBDpQIQIVqEDcKVAhBR2oEIEOVIhAB6p61NA9UKE8LlChvEugQopLoEIKOlAhAh2oEIEOVIhABypEoAMVIlCBCsSdAhVS0IEKEehAhQh0oMqLhQMCFcrjAhXKuw==
    BCqkuAQqpKADFSLQgQoR6ECFCHSgQgQ6UCECFahA3ClQIQUdqBCBDlSIaPNPfYnSdpv9BL/qab1jv/+lK92ob+aj3CZq1h9VtsrO6v8swgVjD0Hjg4czWW/0g8TLJGZyidpyWQ==
    3eTKWyJQFz6/Ltqf8DHpA1+6pJ+FkNdMAXzeVxKsqczbXN6UBEXevM3TTUkw65y3ZV9TEgyD87akK+OyvCmFD0dAuC3NGMITi3hbtjbEoYrbcrQhCDXclpkNQajgtnxsCB4HIg==
    OR9KH/fU00l1fykgtLmjQTi1E9rcEtqqTMcwMPoazU7oaz07oa8Z7QSUPa0YvGHtKLSF7Sg3U8Mww5raPVDtBKypIcHJ1ADjbmqIcjY1RLmZGiZGrKkhAWtq9+RsJziZGmDcTQ==
    DVHOpoYoN1PDoQxrakjAmhoSsKYeOCBbMe6mhihnU0OUm6nh5A5rakjAmhoSsKaGBCdTA4y7qSHK2dQQ5WZqUCWjTQ0JWFNDAtbUkOBkaoBxNzVEOZsaotpMLVdRaqZGWdgQxw==
    TcIMQdyAbAjikrMh6FAtGdKO1ZJBcKyWoK1Km+OqJdNodkJf69kJfc1oJ6DsacXgDWtHoS1sR7mZGlctNZnaPVDtBKypcdWS1dS4aqnV1LhqqdXUuGrJbmpctdRkaly11GRq9w==
    5GwnOJkaVy21mhpXLbWaGlct2U2Nq5aaTI2rlppMjauWmkw9cEC2YtxNjauWWk2Nq5bspsZVS02mxlVLTabGVUtNpsZVS1ZT46qlVlPjqqVWU+OqJbupcdVSk6lx1VKTqXHVUg==
    k6lx1ZLV1LhqqdXUuGqp1dSWaunosfYBJsGW3zfjBxfPWyrewW08MBOpd5Dqi4DywI9R9aEkISxaEuhPUunNssH6gqH8O8t5VaePGY+PF9PT2UIdZfvk1HRsfnJqXv2wfnJKNg==
    raMzVfP19VD1JSizA/sPOMnWLUlOo69C36B7qXj5X8N28ZK8cnt5msWaZGrv3hzlMdrh7No6n08vLvUlRZu2TF3tFad0RZ9IWChxpl5H9OlnUuFNLVZfP1vKo/dfJJvouDK/SA==
    NpHxbnxYzMUAU6sBdFbyY4BpDwPUL3p32GS+OBmfd9rEonPpW0DnHdqW2wZqe2bVtr5K7kfbM9/aboiAB0q3X3iT5Dbx4xPXca7UVhliKd4cx5WiskeXWcrkWDdL84cAyR8tHw==
    AhQ7L/U2sb/2LcCa5P5bgGLzRfUtwFBk8sr0V/MPp/LdFfJgmeV5BpQ5XiZluVnceMRBp1el71Td0vcx1L4mKLd1e1PIDcmTh3q5nWUk0C+prp6ylK+oPvQzy5usLT6ik+/+Tg==
    lWaXsbe7ECNiS5vliNk6hKlB1erE2ou7Wsjbs0yUH/E/PqbCpx91tlYtjZ6IQvH9C5okn4k6mm3thyZ0JUKR752MlV/U9y/V6zmt8pmcx1kBR/XGqJ/tfqI+2KFvMLLOGMRkpQ==
    Qd3ybrehmu7hC3Xri3Vm0Bg1k5K7lCbr+dB0G0t7y3dJ1BPY5Xy8KO8J7TOEd0136n51wbKIZnIip/xGnlW8y153/E+eAuUf/Jy0+hqmSiOaXHmVk2zlcU7SpT86Ccc8lUb0eg==
    mPjvbuIqNCr194mU5vH5Sn3Y6dAd9feemlzRNgQrUusAbB+BO52Wx5JyM7IsjxOjkBoftiwXVeAbPcAax0gDV4e8nambvIW6NK957tQ9ua+NT+Eu504oi5rD3GNo5VDHalew1w==
    2IGiG4c3i9q7VG7Tb88OVt3Rr9A+7IrejOsFbG35qWH7fMz0jFrFsFyIKdiQWWpDFOiPp2GiQJH+HwX1KDC0cqhjtWtoFGgDvlAUGG9Tki9TOuwTeNvS0MCwzEU6Y6M2m38zFg==
    /3R/O8KkZeqiLmcfdtm4eK4OaOpyj1lMeRPyQdcWk7dvEQsRLzeLubgS/8QGs0RakvDhPmO7NAJl0oUuk/CTHudTucyRnE/mMKVyPpfTDGzg2ZATNsezeZvffWHlu9sOI9Z4rQ==
    W9cAZ62TWwbqyWSy0PV/6zKV30GmWvI87K3eGUx8jDTiLNZU3ZS/zGWkF1voVA8HHSpCbW3qvzmG9llzk6S2mc5E5/JhC8yTafNKcY/lMcvy14HmZz213NcP93pp1P1QBzQMaA==
    V3mn+7249pp9tPoO16Gqqh0+PLWEtTprZ0pr0GJtZbPn1KqvG9UabVPPUGeqq9mulf+qJmqXUg41USb2qafErkvQnondvBrj9WoKUjfqwodNNzNPutHFhfug9z91SaP8K3//bw==
    AAAA//8DAFBLAwQUAAYACAAAACEAsT+4YiIBAABOAgAAFAAAAHdvcmQvd2ViU2V0dGluZ3MueG1slNLNSgMxEADgu+A7hNzbbIstsnRbEKkI/oHWe5rOtsEkEzKp2/XpHdeqSA==
    L+0tk8l8zCSZzHbeiXdIZDFUctAvpIBgcGXDupKLl3nvUgrKOqy0wwCVbIHkbHp+NmnKBpbPkDOfJMFKoNKbSm5yjqVSZDbgNfUxQuBkjcnrzGFaK6/T2zb2DPqos11aZ3Orhg==
    RTGWeyYdo2BdWwPXaLYeQu7qVQLHIgba2Eg/WnOM1mBaxYQGiHge7749r234ZQYXB5C3JiFhnfs8zL6jjuLyQdGtvPsDRqcBwwNgTHAaMdoTiloPOym8KW/XAZNeOpZ4JMFdiQ==
    DpZTflKM2Xr7AXNMVwkbgqS+tvle28fwen/XRdo5bJ4ebjhQ/37B9BMAAP//AwBQSwMEFAAGAAgAAAAhAJRA96XTAQAAPAUAABIAAAB3b3JkL2ZvbnRUYWJsZS54bWy8km9r2w==
    MBDG3w/2HYTeN5adP21NnZJlDQzGXpTuAyiKbItZktEpcfPtd5KdbMyUJhRmg5Cfu/vp9PgeHl91Qw7SgbKmoOmEUSKNsDtlqoL+fNnc3FECnpsdb6yRBT1KoI/Lz58eury0xg==
    A8F6A7kWBa29b/MkAVFLzWFiW2kwWFqnucdPVyWau1/79kZY3XKvtqpR/phkjC3ogHGXUGxZKiG/WrHX0vhYnzjZINEaqFULJ1p3Ca2zbtc6KyQA3lk3PU9zZc6YdDYCaSWcBQ==
    W/oJXmboKKKwPGVxp5s/gPl1gGwEWIC8DjEfEAkctXylRIv8W2Ws49sGSXglgl2RCKbL4WeSLjdcY3jNG7V1KgZabizIFGMH3hSUZWzD5riGd8amYaVJSBQ1dyADpE9kvVxyrQ==
    muNJhU4B9IFWeVGf9AN3KrTWh0BVGNjDlhX0ieGTbTa0V9KCzlBYrc9KFs6KTzoo07PCgiIip8+4j1Uics45eGbSOzBy4kVpCeSH7Miz1dy84UjGFujEHP0IzkyvcsRF7rWOZA==
    q78dWaNyezebjhy5f9+RnnO5I8NskO+qqv2bExLm4n9NyCq0nD39MyEZu/0y8iPe/oMTMmxg+RsAAP//AwBQSwMEFAAGAAgAAAAhAJN21kkYAQAAQAIAAB0AAAB3b3JkL2dsbw==
    c3Nhcnkvd2ViU2V0dGluZ3MueG1slNHBSgMxEAbgu+A7hNzbbIstsnRbEKl4EUF9gDSdbYOZTMikbuvTO65VES/tLZNkPuZnZos9BvUGmT3FRo+GlVYQHa193DT65Xk5uNaKiw==
    jWsbKEKjD8B6Mb+8mHV1B6snKEV+shIlco2u0dtSUm0Muy2g5SEliPLYUkZbpMwbgza/7tLAESZb/MoHXw5mXFVTfWTyKQq1rXdwS26HEEvfbzIEESny1if+1rpTtI7yOmVywA==
    LHkwfHloffxhRlf/IPQuE1NbhhLmOFFPSfuo6k8YfoHJecD4HzBlOI+YHAnDB4S9Vujq+02kbFdBJImkZCrVw3ouK6VUPPp3WFK+ydQxZPN5bUOg7vHhTgrzZ+/zDwAAAP//Aw==
    AFBLAwQUAAYACAAAACEAlED3pdMBAAA8BQAAGwAAAHdvcmQvZ2xvc3NhcnkvZm9udFRhYmxlLnhtbLySb2vbMBDG3w/2HYTeN5adP21NnZJlDQzGXpTuAyiKbItZktEpcfPtdw==
    kp1szJQmFGaDkJ+7++n0+B4eX3VDDtKBsqag6YRRIo2wO2Wqgv582dzcUQKemx1vrJEFPUqgj8vPnx66vLTGA8F6A7kWBa29b/MkAVFLzWFiW2kwWFqnucdPVyWau1/79kZY3Q==
    cq+2qlH+mGSMLeiAcZdQbFkqIb9asdfS+FifONkg0RqoVQsnWncJrbNu1zorJADeWTc9T3Nlzph0NgJpJZwFW/oJXmboKKKwPGVxp5s/gPl1gGwEWIC8DjEfEAkctXylRIv8Ww==
    Zazj2wZJeCWCXZEIpsvhZ5IuN1xjeM0btXUqBlpuLMgUYwfeFJRlbMPmuIZ3xqZhpUlIFDV3IAOkT2S9XHKtmuNJhU4B9IFWeVGf9AN3KrTWh0BVGNjDlhX0ieGTbTa0V9KCzg==
    UFitz0oWzopPOijTs8KCIiKnz7iPVSJyzjl4ZtI7MHLiRWkJ5IfsyLPV3LzhSMYW6MQc/QjOTK9yxEXutY5kq78dWaNyezebjhy5f9+RnnO5I8NskO+qqv2bExLm4n9NyCq0nA==
    Pf0zIRm7/TLyI97+gxMybGD5GwAA//8DAFBLAwQUAAYACACOdOxIQunoXukBAABhBAAAEAAIAWRvY1Byb3BzL2FwcC54bWwgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACdVMFu2zAM/RVD98ZOWxRDkLgY2sMOG1ogWXtmZToWakuCxATJfm2HfdJ+YZTkuMqCXZYT+fj09Cgy/v3z1/L+MA==
    9MUenVdGr8R8VokCtTSN0tuV2FF79UkUnkA30BuNK3FEL+7rJdjFszMWHSn0BWtov9jTSnREdlGWXnY4gJ8xQ3OxNW4A4tRtS9O2SuKjkbsBNZXXVXVXNkYGNf+yOVrWH/XA/g==
    rx4eCHWDzZWdPIroeYOD7YGwXisOVKuwKdbQcwsngVlj6LAsc248aAj6jRqwrlJxyuNTwBb9WElxQF+Na3w9v7mNeMoC/tCBA0n85uORDAj1z5atSSCeSP1NSWe8aal4in0WQQ==
    Jh7KWeEUN7BGuXOKjqNsjgTGV6UnlylO3h1sHdiOrY4NTECoryW/zwO/Y91C7zFSPrDA+IIQ1uUZVGhgT4s9SjKueAOPYaArsQenQBNvkvrB6bVItITGuLeeXL1R1PMNUx7DnA==
    lsfqNhhOwTmxnDzU0e65wTC9cI9/arlV+oflaOBkeC4ykxf+spv+Eg6zNYMFfUzlKUkTePff7cY8hh37eNtz/HxfXhV1awsSLzcnK8WpcQEb3oB8ahMWp8Ztuj5cxiJ6i03GvA==
    rI17+ZI+FPX8blbx77SIJzjtz/Sfq/8AUEsDBBQAAAAIAMNWNkvv/H8CqAsAAJhuAAATABwAY3VzdG9tWE1ML2l0ZW0zLnhtbCCiGAAooBQAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AMVda28UORb155X2P6D5PssknZdG2R4lMDBIkMmQDCyfopA0EJGXujsM+fO7c21Xxa/7dEdaIUjavvec41sul33tLv733133i/vurtyle+K+uZmbu4W7cDfu2v3b/eDW3L/cTw==
    8PMJ1Fy7Myg/h9pr9znU3rml++R+BKst+PSLm7p/un+4XXfgTgHrPVjPwf4t+N6G35fuP4HpEOr9pycD8zVwRrw5/P4zlF0A1xx8FvD3E1j+CDj3UHc61C2g5DqwPAW7hL+Azw==
    R/DzFGrPA8u5O4GSU2CZQe2Jew5lpwHzxL0Cq2/g6RFn4LnmJtDaCfz2w9CWJ/Bn1/0GtaeA5KOTymPdPnhfBvRzdwxYJ+61+wifp2TNLuDTXjj6EmyeQXwW4beroOQAZZMscw==
    dhlVVnOX+eEqcguKvUQpWZ+5L1B35r6Cpe859/D3Y4hd0inbeGYNUs3t43Ib+tO924OrdR762wL+rAVerj5y8gh6vnWBb13kWzfxTQS+icg3MfFtCHwbIt+GiW9T4NsU+TZNfA==
    WwLflsi3ZeLbFvi2Rb5tE9+OwLcj8u0IfPvh51fwOgvPojv4tBzGDK1lq4FD7VOTj0s2D4s63Zg1+u+H555/hn9hI1bb0YpaxB4dUqwoe70uW5wOwhxjRuoZ62n+hGDhk+JQ2w==
    yfy6dufP/5fwZJ4jfQOzaflxJCs3FQfOVqdFF49f3Rv47QJRkGpavtyLQx+1YHdgXtcylJ5aDiqamA3PqYveb8M80s+uPiN3UV3fcrYIHN8r6PV7oK/mGctb/OShwaXiV9fTPA==
    uri9hpZ+DquU32Ft8mlYkdSsuFXLTaHZFVDt5621iqyxiSu7JXy+CuvRJaOrteVUYci8phvwvIFeehPWy8thzdzqwe0wLRQip+MQnnHeaoaOKGVty1l765mofoFbScy6fnAYeg==
    zTJkCWZQ/1Swfxuu7kV4DszD1Y0RPQirzY/Dat7u07ZGx7SqVirmFt8+7brrc+Tew6j3wh03ClNNy5976dCpOLQWHJuuTe9gDD9mYtTec7JHq0rDsppKKmZ6zx7V9hhLEZXjZw==
    i5Y2NvpISO2+Dk+as5B/zHnb8pEH82hxb0FHiZiXjFilVY1SZgKxbBdvEVkkFAvrusi6rmDF8l6c/URknShYsewXZ78hsm4oWLEcGGe/KbJuKlixTBhnvyWybilYsXwYZ78tsg==
    bitYsawYZ78jsu4oWLHcWGkfZ47LMJ/1uYB5uOPPh3WE1hZTwiGXmp5D+dmQzffj1vNhVj0lazwf7aVDTyOaZMGxUeNibR+fMFgpho49jzAbug31s4f35pmOw8riko1Za4OxYg==
    SDX3HdTmPSD/HDFLC84/14uVt3iUrpSrSRZtmcfDLGus7yHP6OcBPlvxduDeg/vlGH5+DytJjVXk06CVCl6EDM1VprAu8citVYnyEspuoMbf4a/DlaZWMVpLz6pH7VOTWmP1sA==
    qKNiVmeqkh1V41lprxK93Jt+HmbYKf+/Bxjj7wnB7uMV9TBZtPonxiL0YrtmzlfWzjOXbUi5oF+DnR/d7uGuu4c5sx+b+HqvRUKw8CWVOjuZn273RcjD5DHaC+cjfN/n45urXA==
    HSW24THU1C2M9/ZlmNfMw4zK7w7dF/olm6hORiq527scGxOksSCeVRifvG/g5zLkz84hBrMQgznE4talnKHVY1RhY1lNZRmTHs8e1boYH4f+dgX+ughL9q1SmWEVfVRstX52vQ==
    dFznw/26CPfvGdjcPZwii5mTqcoqatKg2RXk8dJbaxWtEpsPoTauImz2WnU5Q6nvjzCfXjxc40XWErrO83KeJUc6m1eO7uOTgB7lez13wxnBXlZK/aGLZyfLe4GvL5XgCBq+fQ==
    KIt7/xJza0lrwFA1atL5B76eZqZOUBxBGXducSpaRE4Jxcaax1xnqVFBx/xLGHfHcTlnx2siG+XFo2tmAXYfTJF9vmFHoGNlm3Oswoy3wZ8BLvN9rVbaJtfEIWm511jWNYGvzQ==
    8dO26yzTusDU5vVp2wnLNBGY2lw+bbvBMm0ITG3+nrbdZJk2BaY2Z0/bbrFMWwJTm6enbbdZpm2Bqc3N07Y7LNOOwNTm44/CCPDXg8/tMMsq/aZKu5Fdg4jriN+/+MqO27Jdrg==
    Q0KsddzBuOOfanHnIB/R8JrIRXmV6MdDnvRrMcJhpR4Vt64RW862LKJJ6uLMGs870XUem/OUOI5CpucMrkc8YXWKPH96vHBdGjZM8ZiVqzXV5Ym19cBwn4X56h2KjdUlfNxT4g==
    WLAsC4GH7ofR9lXYX4t5PB/fMhMt2yRWHgnjjnPxs8Grzk3JNombR8K4+VMwutM19vM0lrMstjMz/adkPoQ7ba7aedPbek0WZFyTb8+ncG1jBnSWaWjrck7MU8txgrSYs+J5Tw==
    yFaOWYCyPNblI2Dcr8PzPSOCzd4rtjKsqjFFoc/PrhmPe6udy6dh8ZXta60ahlU14vHV+9k1c/Gl16djeyWLuNMuodiZ8x1+naVGCReLVy6e+B5H4VE7Xh73G3EPLXa+78nV0w==
    XFx7sN2zXCVfT+2/8e3kPfgdQrzdWkRaS529LWchWES0Hrk+PUuv0vHMh11x66lXjrHSLajvBLw8Z5fvnbRrge3L4LsvXL9IVrGlGGpZU2LXXi3DH25Z7AKXn+OOyJLcJx4x7g==
    whp13LnPY0TXjbstlKeFJ9cv2fC8XDvr7Gl7XkuywHKw/KkvmXmMl2wjsdORP3bxm6mL4o0S+Tg3VdjEDISMhPGnsyCjyrYs4reWLd6fUHNRZCjqEo/VWtFI/tthb0KLFi5+zw==
    Z8rU5eiYp4WnbQNtw/Nq2pnGlilSluPnlhq8th34yMl5tjx8JmHsIRorOS9B9zeNnzZH0o5mNnRK3aEbv6lRRqUuz3MktYcWu83J4PU0F7UCfkqo2RVywKNXnZW2+E6Vdl6lFg==
    sVdLeUrV7qPXyJ2H1WK0ewFt1pZfs+hPgnLIj4NjPZv6/2hrvp57TLzHazu//rWfnu2/7la83vO9j9kPrAza/tCL+/gxsecT3oW5Lh5fqwe93udYVlcq5SVkzx7lXKz9qtjPJQ==
    6VmIH901Vl6ZDo2aZ+ivhM2e2t+0XWsbQj1H6rnOvYwa7a/dM/dBGLV6vHDdGrbHUc3FXe/d2wr5GqQ9Zbl/a2yx3eqefq3xrmNr8bHp1MdR34/1Hq3WVfqvHoOKb0+/7WG1rQ==
    fOX+a/WTVsM9/dqKpFvHW/p7vwJpPS5fAdmyXaP3RFn2pXIGlkhaWOqVrPbOxU7ccO0fv5F+wvpprMZ3ZchofSpSbCzWWlU9e79cG+0+3K6sLZo4ynqXYt6L1iyxSTP58sxXPQ==
    gy9r25l77a2dDdN6bfb07NcSEawt5Tu1JQvqDB39Zm7Ns0eKktVPftboooa3lrLN36+eTqYu2CtSXk0ZwWZfn1jRMPAaXwTfq/C88fts52bVPQh1O/pU6MdhGavXkxuTe1rwwg==
    xfdS7cPPS2Uc7D7xzRV2Jlqv3/WKo8Xlw/NSr7zHO29DH3s9Mlg9yu/x5t7e3n+bYA7/plOg+AmKHOMotOGbG78zGd9c2b6RUe97ArGZu/b7yrx1+y1lCX01dekdLD1eVrX4Gw==
    X2TV6fyOJqa1taSyRV9NnS6mlJdVLfUWnRrFepfE93nEp8KcvXL7YQ5/n9nUJV5Na4WtNfz7axaDvmSJl8f1A+7RYr8MJxlmD61PtlSNx6e9sD5y5ZYPuxd5L8DK4xXCPdqdaw==
    6UrsFuMmflJmrNecvJ0a7cvvEOkYOI3UievUer1tqU1G5nRRrcF0SbalLhlZ0qXbWa0V6rxarVo2TvVB6NeUura2VIF5c2zleFir/h3+bfu+1qdUpmfi9MbvDabPU6au5G89LQ==
    PG9C//MrNP46c3q0GLxuvRKufdi9id+DunutzR5M2dqSA/O2scW8O88ZbSTmEcnGj8WTtpI0WGJe7jy0/GU9xlwj1E9a/Cnqa9q8TMxt6f5fuKn7G1BLAQItABQABgAIABuCEg==
    SegeB0jHAQAAsgsAABMAAAAAAAAAAAAAAAAAAAAAAFtDb250ZW50X1R5cGVzXS54bWxQSwECLQAUAAYACAAAACEAHpEat+8AAABOAgAACwAAAAAAAAAAAAAAAAAABAAAX3JlbA==
    cy8ucmVsc1BLAQItABQABgAIABuCEkltSNfbagEAAPcHAAAcAAAAAAAAAAAAAAAAACAHAAB3b3JkL19yZWxzL2RvY3VtZW50LnhtbC5yZWxzUEsBAi0AFAAGAAgAG4ISSXDUxQ==
    HpkRAAB12wAAEQAAAAAAAAAAAAAAAADMCQAAd29yZC9kb2N1bWVudC54bWxQSwECLQAUAAYACAAbghJJrgvW2sUHAAC7JQAAEAAAAAAAAAAAAAAAAACUGwAAd29yZC9oZWFkZQ==
    cjIueG1sUEsBAi0AFAAGAAgAG4ISSWhZp1pQBAAAeQ0AABAAAAAAAAAAAAAAAAAAhyMAAHdvcmQvZm9vdGVyMS54bWxQSwECLQAUAAYACAAbghJJvyfvKbwFAABGHgAAEAAAAA==
    AAAAAAAAAAAAAAUoAAB3b3JkL2hlYWRlcjEueG1sUEsBAi0AFAAGAAgAG4ISScSmQhP8BQAAlyoAABAAAAAAAAAAAAAAAAAA7y0AAHdvcmQvZm9vdGVyMi54bWxQSwECLQAUAA==
    BgAIABuCEkmQJgpL7gEAAOUGAAARAAAAAAAAAAAAAAAAABk0AAB3b3JkL2VuZG5vdGVzLnhtbFBLAQItABQABgAIAAAAIQDHzvKouQAAACEBAAAbAAAAAAAAAAAAAAAAADY2AA==
    AHdvcmQvX3JlbHMvaGVhZGVyMi54bWwucmVsc1BLAQItABQABgAIABuCEklRVSKB7gEAAOsGAAASAAAAAAAAAAAAAAAAACg3AAB3b3JkL2Zvb3Rub3Rlcy54bWxQSwECLQAUAA==
    BgAIAAAAIQCqUiXfIwYAAIsaAAAVAAAAAAAAAAAAAAAAAEY5AAB3b3JkL3RoZW1lL3RoZW1lMS54bWxQSwECLQAKAAAAAAAAACEAMlJ+tQoAAAAKAAAAFQAAAAAAAAAAAAAAAA==
    AJw/AAB3b3JkL21lZGlhL2ltYWdlMS5iaW5QSwECLQAUAAYACAAAACEAnenSYLcMAACfdAAAGgAAAAAAAAAAAAAAAADZPwAAd29yZC9nbG9zc2FyeS9kb2N1bWVudC54bWxQSw==
    AQItABQABgAIAAAAIQDSdzsz9QAAAHUBAAAcAAAAAAAAAAAAAAAAAMhMAAB3b3JkL19yZWxzL3NldHRpbmdzLnhtbC5yZWxzUEsBAi0AFAAGAAgAAAAhAKRHygOFAwAABwoAAA==
    GgAAAAAAAAAAAAAAAAD3TQAAd29yZC9nbG9zc2FyeS9zZXR0aW5ncy54bWxQSwECLQAUAAYACAAAACEAg9C15eYAAACtAgAAJQAAAAAAAAAAAAAAAAC0UQAAd29yZC9nbG9zcw==
    YXJ5L19yZWxzL2RvY3VtZW50LnhtbC5yZWxzUEsBAi0AFAAGAAgAAAAhAImNNwzQCAAAkiEAABEAAAAAAAAAAAAAAAAA3VIAAHdvcmQvc2V0dGluZ3MueG1sUEsBAi0AFAAGAA==
    CAAAACEAtOCUGeAAAABVAQAAGAAAAAAAAAAAAAAAAADcWwAAY3VzdG9tWG1sL2l0ZW1Qcm9wczIueG1sUEsBAi0AFAAGAAgAAAAhAHqocnTFAAAAMgEAABMAAAAAAAAAAAAAAA==
    AAAaXQAAY3VzdG9tWG1sL2l0ZW0yLnhtbFBLAQItABQABgAIAAAAIQBcliciwgAAACgBAAAeAAAAAAAAAAAAAAAAADheAABjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbA==
    c1BLAQItABQABgAIAAAAIQDrK/TI6RMAABajAAAYAAAAAAAAAAAAAAAAAD5gAAB3b3JkL2dsb3NzYXJ5L3N0eWxlcy54bWxQSwECLQAUAAYACACOdOxIKQDwpDsBAABIAgAAEQ==
    AAAAAAAAAAAAAAAAAF10AABkb2NQcm9wcy9jb3JlLnhtbFBLAQItABQABgAIAAAAIQBtp+Jgow4AAAGMAAAPAAAAAAAAAAAAAAAAAM92AAB3b3JkL3N0eWxlcy54bWxQSwECLQ==
    ABQABgAIAAAAIQCxP7hiIgEAAE4CAAAUAAAAAAAAAAAAAAAAAJ+FAAB3b3JkL3dlYlNldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQCUQPel0wEAADwFAAASAAAAAAAAAAAAAA==
    AAAA84YAAHdvcmQvZm9udFRhYmxlLnhtbFBLAQItABQABgAIAAAAIQCTdtZJGAEAAEACAAAdAAAAAAAAAAAAAAAAAPaIAAB3b3JkL2dsb3NzYXJ5L3dlYlNldHRpbmdzLnhtbA==
    UEsBAi0AFAAGAAgAAAAhAJRA96XTAQAAPAUAABsAAAAAAAAAAAAAAAAASYoAAHdvcmQvZ2xvc3NhcnkvZm9udFRhYmxlLnhtbFBLAQItABQABgAIAI507EhC6ehe6QEAAGEEAA==
    ABAAAAAAAAAAAAAAAAAAVYwAAGRvY1Byb3BzL2FwcC54bWxQSwECLQAUAAAACADDVjZL7/x/AqgLAACYbgAAEwAAAAAAAAAAAAAAAAB0jwAAY3VzdG9tWE1ML2l0ZW0zLnhtbA==
    UEsFBgAAAAAeAB4A3wcAAGmbAAAAAA==
    END_OF_WORDLAYOUT
  }
}

