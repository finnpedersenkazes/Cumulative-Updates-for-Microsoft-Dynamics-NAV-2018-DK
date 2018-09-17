OBJECT Report 1307 Standard Sales - Credit Memo
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
    CaptionML=[DAN=Salg - kreditnota;
               ENU=Sales - Credit Memo];
    OnInitReport=BEGIN
                   GLSetup.GET;
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
               DataItemTable=Table114;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Bogf›rt salgskreditnota;
                                   ENU=Posted Sales Credit Memo];
               OnPreDataItem=BEGIN
                               FirstLineHasBeenOutput := FALSE;
                             END;

               OnAfterGetRecord=VAR
                                  CurrencyExchangeRate@1000 : Record 330;
                                BEGIN
                                  IF NOT CurrReport.PREVIEW THEN
                                    CODEUNIT.RUN(CODEUNIT::"Sales Cr. Memo-Printed",Header);

                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

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

                                  IF LogInteraction AND NOT CurrReport.PREVIEW THEN BEGIN
                                    IF "Bill-to Contact No." <> '' THEN
                                      SegManagement.LogDocument(
                                        6,"No.",0,0,DATABASE::Contact,"Bill-to Contact No.","Salesperson Code",
                                        "Campaign No.","Posting Description",'')
                                    ELSE
                                      SegManagement.LogDocument(
                                        6,"No.",0,0,DATABASE::Customer,"Bill-to Customer No.","Salesperson Code",
                                        "Campaign No.","Posting Description",'');
                                  END;

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

    { 112 ;1   ;Column  ;YourReference_Lbl   ;
               SourceExpr=FIELDCAPTION("Your Reference") }

    { 40  ;1   ;Column  ;ShipmentMethodDescription;
               SourceExpr=ShipmentMethod.Description }

    { 105 ;1   ;Column  ;ShipmentMethodDescription_Lbl;
               SourceExpr=ShptMethodDescLbl }

    { 32  ;1   ;Column  ;ShipmentDate        ;
               SourceExpr=FORMAT("Shipment Date",0,4) }

    { 46  ;1   ;Column  ;ShipmentDate_Lbl    ;
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

    { 26  ;1   ;Column  ;BilltoCustumerNo_Lbl;
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

    { 194 ;1   ;Column  ;AppliesToDocument   ;
               SourceExpr=AppliesToText }

    { 195 ;1   ;Column  ;AppliesToDocument_Lbl;
               SourceExpr=AppliesToTextLbl }

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

    { 153 ;1   ;Column  ;ExchangeRateASText  ;
               SourceExpr=ExchangeRateText }

    { 59  ;1   ;Column  ;Page_Lbl            ;
               SourceExpr=PageLbl }

    { 100 ;1   ;Column  ;SalesInvoiceLineDiscount_Lbl;
               SourceExpr=SalesInvLineDiscLbl }

    { 102 ;1   ;Column  ;DocumentTitle_Lbl   ;
               SourceExpr=SalesCreditMemoLbl }

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
               DataItemTable=Table115;
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
                               CompanyInfo.CALCFIELDS(Picture);
                             END;

               OnAfterGetRecord=BEGIN
                                  InitializeSalesShipmentLine;
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

                                  FormatDocument.SetSalesCrMemoLine(Line,FormattedQuantity,FormattedUnitPrice,FormattedVATPct,FormattedLineAmount);

                                  IF FirstLineHasBeenOutput THEN
                                    CLEAR(CompanyInfo.Picture);
                                  FirstLineHasBeenOutput := TRUE;
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

    { 1484;2   ;DataItem;ShipmentLine        ;
               DataItemTable=Table7190;
               DataItemTableView=SORTING(Document No.,Line No.,Entry No.);
               OnPreDataItem=BEGIN
                               SETRANGE("Line No.",Line."Line No.");
                             END;

               Temporary=Yes }

    { 294 ;3   ;Column  ;DocumentNo_ShipmentLine;
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
                                 AssemblyLine,ValueEntry."Document Type"::"Sales Credit Memo",Line."Document No.",Line."Line No.");
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
               OnAfterGetRecord=BEGIN
                                  IF "VAT Clause Code" = '' THEN
                                    CurrReport.SKIP;
                                  IF NOT VATClause.GET("VAT Clause Code") THEN
                                    CurrReport.SKIP;
                                  VATClause.TranslateDescription(Header."Language Code");
                                END;

               Temporary=Yes }

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

    { 209 ;1   ;DataItem;LetterText          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 210 ;2   ;Column  ;GreetingText        ;
               SourceExpr=GreetingLbl }

    { 211 ;2   ;Column  ;BodyText            ;
               SourceExpr=BodyLbl }

    { 212 ;2   ;Column  ;ClosingText         ;
               SourceExpr=ClosingLbl }

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

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      SalesCreditMemoNoLbl@1004 : TextConst 'DAN=Salg - kreditnota %1;ENU=Sales - Credit Memo %1';
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
      InvNoLbl@1073 : TextConst 'DAN=Kreditnotanr.;ENU=Credit Memo No.';
      LineAmtAfterInvDiscLbl@1074 : TextConst 'DAN=Moms ved kontantrabat;ENU=Payment Discount on VAT';
      LocalCurrencyLbl@1076 : TextConst 'DAN=Lokal valuta;ENU=Local Currency';
      PageLbl@1077 : TextConst 'DAN=Side;ENU=Page';
      PaymentTermsDescLbl@1078 : TextConst 'DAN=Betalingsbetingelser;ENU=Payment Terms';
      PaymentMethodDescLbl@1040 : TextConst 'DAN=Betalingsform;ENU=Payment Method';
      PostedShipmentDateLbl@1079 : TextConst 'DAN=Afsendelsesdato;ENU=Shipment Date';
      SalesInvLineDiscLbl@1081 : TextConst 'DAN=Rabatpct.;ENU=Discount %';
      SalesCreditMemoLbl@1082 : TextConst 'DAN=Kreditnota;ENU=Credit Memo';
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
      FormatDocument@1054 : Codeunit 368;
      SegManagement@1020 : Codeunit 5051;
      CustAddr@1021 : ARRAY [8] OF Text[50];
      ShipToAddr@1022 : ARRAY [8] OF Text[50];
      CompanyAddr@1023 : ARRAY [8] OF Text[50];
      SalesPersonText@1025 : Text[30];
      TotalText@1028 : Text[50];
      TotalExclVATText@1029 : Text[50];
      TotalInclVATText@1030 : Text[50];
      LineDiscountPctText@1005 : Text;
      FormattedVATPct@1006 : Text;
      FormattedUnitPrice@1002 : Text;
      FormattedQuantity@1001 : Text;
      FormattedLineAmount@1036 : Text;
      MoreLines@1031 : Boolean;
      CopyText@1034 : Text[30];
      ShowShippingAddr@1035 : Boolean;
      LogInteraction@1041 : Boolean;
      SalesPrepCreditMemoNoLbl@1058 : TextConst 'DAN=Salg - forudbetalingskreditnota %1;ENU=Sales - Prepmt. Credit Memo %1';
      TotalSubTotal@1061 : Decimal;
      TotalAmount@1062 : Decimal;
      TotalAmountInclVAT@1064 : Decimal;
      TotalAmountVAT@1065 : Decimal;
      TotalInvDiscAmount@1063 : Decimal;
      TotalPaymentDiscOnVAT@1053 : Decimal;
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
      AppliesToText@1100 : Text;
      AppliesToTextLbl@1101 : TextConst 'DAN=Afstem med bilag;ENU=Applies to Document';
      NoFilterSetErr@1042 : TextConst 'DAN=Du skal angive et eller flere filtre for at undg† at udskrive alle dokumenter ved et uheld.;ENU=You must specify one or more filters to avoid accidently printing all documents.';
      GreetingLbl@1056 : TextConst 'DAN=Hej;ENU=Hello';
      ClosingLbl@1055 : TextConst 'DAN=Med venlig hilsen;ENU=Sincerely';
      BodyLbl@1043 : TextConst 'DAN=Tak for din interesse i vores varer. Din kreditnota er vedh‘ftet denne meddelelse.;ENU=Thank you for your business. Your credit memo is attached to this message.';

    LOCAL PROCEDURE InitLogInteraction@1();
    BEGIN
      LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
    END;

    LOCAL PROCEDURE InitializeSalesShipmentLine@6() : Date;
    VAR
      ReturnReceiptHeader@1000 : Record 6660;
      SalesShipmentBuffer2@1001 : Record 7190;
    BEGIN
      IF Line."Return Receipt No." <> '' THEN
        IF ReturnReceiptHeader.GET(Line."Return Receipt No.") THEN
          EXIT(ReturnReceiptHeader."Posting Date");
      IF Header."Return Order No." = '' THEN
        EXIT(Header."Posting Date");
      IF Line.Type = Line.Type::" " THEN
        EXIT(0D);

      ShipmentLine.GetLinesForSalesCreditMemoLine(Line,Header);

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
      IF Header."Prepayment Credit Memo" THEN
        EXIT(SalesPrepCreditMemoNoLbl);
      EXIT(SalesCreditMemoNoLbl);
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
          ReportTotalsLine.Add(TotalExclVATText,TotalAmount,TRUE,FALSE,FALSE);
      END;
      IF TotalAmountVAT <> 0 THEN
        ReportTotalsLine.Add(VATAmountLine.VATAmountText,TotalAmountVAT,FALSE,TRUE,FALSE);
    END;

    LOCAL PROCEDURE FormatAddressFields@2(VAR SalesCrMemoHeader@1000 : Record 114);
    BEGIN
      FormatAddr.GetCompanyAddr(SalesCrMemoHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
      FormatAddr.SalesCrMemoBillTo(CustAddr,SalesCrMemoHeader);
      ShowShippingAddr := FormatAddr.SalesCrMemoShipTo(ShipToAddr,CustAddr,SalesCrMemoHeader);
    END;

    LOCAL PROCEDURE FormatDocumentFields@3(SalesCrMemoHeader@1000 : Record 114);
    BEGIN
      WITH SalesCrMemoHeader DO BEGIN
        FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser,"Salesperson Code",SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod,"Payment Method Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

        FormatDocument.SetText("Applies-to Doc. No." <> '',STRSUBSTNO('%1 %2',FORMAT("Applies-to Doc. Type"),"Applies-to Doc. No."));
      END;
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
        <Field Name="YourReference_Lbl">
          <DataField>YourReference_Lbl</DataField>
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
        <Field Name="BilltoCustumerNo_Lbl">
          <DataField>BilltoCustumerNo_Lbl</DataField>
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
        <Field Name="AppliesToDocument">
          <DataField>AppliesToDocument</DataField>
        </Field>
        <Field Name="AppliesToDocument_Lbl">
          <DataField>AppliesToDocument_Lbl</DataField>
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
        <Field Name="ExchangeRateASText">
          <DataField>ExchangeRateASText</DataField>
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
                  <Width>18.52485cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>23.02783cm</Height>
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
                                          <Textbox Name="YourReference_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!YourReference_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>YourReference_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
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
                                          <Textbox Name="EMail_Header_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!EMail_Header_Lbl.Value</Value>
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
                                            <rd:DefaultName>EMail_Header_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
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
                                          <Textbox Name="BilltoCustumerNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BilltoCustumerNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>BilltoCustumerNo_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
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
                                          <Textbox Name="HomePage_Header_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!HomePage_Header_Lbl.Value</Value>
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
                                            <rd:DefaultName>HomePage_Header_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
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
                                          <Textbox Name="AppliesToDocument_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AppliesToDocument_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AppliesToDocument_Lbl</rd:DefaultName>
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
                                          <Textbox Name="AppliesToDocument">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AppliesToDocument.Value</Value>
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
                                            <rd:DefaultName>AppliesToDocument</rd:DefaultName>
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
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>0.07056cm</Top>
                              <Left>0.02485cm</Left>
                              <Height>8.0832cm</Height>
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
                                                <Style />
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
                                                <Style />
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
                                                <Style />
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox27</rd:DefaultName>
                                            <Style>
                                              <Border>
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
                                          <rd:Selected>true</rd:Selected>
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
                                            <Group Name="Details" />
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
                              <Top>8.38923cm</Top>
                              <Left>0.02485cm</Left>
                              <Height>2.2848cm</Height>
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
                                          <Textbox Name="Textbox39">
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
                                          <Textbox Name="Textbox40">
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
                                            <rd:DefaultName>Textbox40</rd:DefaultName>
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
                                          <Textbox Name="Textbox41">
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
                                          <Textbox Name="Textbox42">
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
                              <Top>16.44169cm</Top>
                              <Height>1.55224cm</Height>
                              <Width>16.8cm</Width>
                              <ZIndex>2</ZIndex>
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
                                          <Textbox Name="Textbox43">
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
                                            <rd:DefaultName>Textbox43</rd:DefaultName>
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
                                          <Textbox Name="Textbox44">
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
                                            <rd:DefaultName>Textbox44</rd:DefaultName>
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
                                          <Textbox Name="Textbox45">
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
                                            <rd:DefaultName>Textbox45</rd:DefaultName>
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
                                          <Textbox Name="Textbox46">
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
                                            <rd:DefaultName>Textbox46</rd:DefaultName>
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
                              <Top>14.33287cm</Top>
                              <Left>0.02485cm</Left>
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
                                          <Textbox Name="Textbox49">
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
                                            <rd:DefaultName>Textbox49</rd:DefaultName>
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
                              <Top>18.35349cm</Top>
                              <Height>3.88058cm</Height>
                              <Width>18.02485cm</Width>
                              <ZIndex>4</ZIndex>
                              <Visibility>
                                <Hidden>=NOT (Fields!ShowShippingAddress.Value AND Fields!ShipToAddress1.Value = "")</Hidden>
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
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
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
                                                      <FontWeight>Bold</FontWeight>
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
                                                      <FontWeight>Bold</FontWeight>
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
                                          <Textbox Name="Textbox53">
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
                                            <rd:DefaultName>Textbox53</rd:DefaultName>
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
                              <Top>10.91362cm</Top>
                              <Left>11.52485cm</Left>
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
                              <Top>22.41046cm</Top>
                              <Height>11pt</Height>
                              <Width>18cm</Width>
                              <ZIndex>6</ZIndex>
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
            <Height>23.02783cm</Height>
            <Width>18.52485cm</Width>
            <Style>
              <Border>
                <Style>None</Style>
              </Border>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>27.03528cm</Height>
        <Style />
      </Body>
      <Width>18.52485cm</Width>
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
    UEsDBBQABgAIAJuCnkfoHgdIxwEAALILAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
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
    iuYZPzbvIVm0X+FvG5xdQfMBAAD//wMAUEsDBBQABgAIAJxtN0gQaNVyaQEAAPcHAAAcAAgBd29yZC9fcmVscy9kb2N1bWVudC54bWwucmVscyCiBAEooAABAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAL2VzVKDMBSFX4XJXgKILTql3bjpjG5qF25DuPyMkDDJrdpnc+Ej+QpGKkIqCzdxec9Nbr45CQ==
    h4+399XmtW28Z1C6liIloR8QDwSXeS3KlBywuEjIZr3aQcPQrNBV3WnPbBE6JRVid0Op5hW0TPuyA2E6hVQtQ1OqknaMP7ESaBQEC6qmM4g909sfO/jLRFkUNYdbyQ8tCJwZTA==
    K2A5KOLtmSoBzcy+Dn0ziHjbPCVqmyfEo84AykZqzdRxWDOiDB2af7csqPDSJZXGYwN6ZDnVFoDT80HkQuKUYFAshqVLhkIK3LOsgRHiR7KvInKJwQ8aZfv4dd6A4fujSmuENg==
    snic4hRS4tnV/EgWxcI1xfSzPdW2DWHokuAFsgdANME3cWIiWihXLknmI+zMi8BpWvwyQs+5EP//i7CD/NolAJq9k6joy5NoQ4RObZhJi0G7v+uzIh5pdjyKF1kCWbRMkphx1g==
    k1Hr973+BFBLAwQUAAYACABLclBIlM1NA9kPAACz3QAAEQAAAHdvcmQvZG9jdW1lbnQueG1s7V3ZcuO4Ff0Vl/KQJ4+wL664U1xnutIzcdqdSVKpVBct0bbSFKkiKbs9qXxZHg==
    8kn5hYCbFor2UBKlJiW+SAQJgMAFzt1wAf7vP//93e+/Tr2LJzeMJoF/PYDfgcGF64+C8cR/uB7M4/tLMbiIYscfO17gu9eDFzca/P7d756vxsFoPnX9+EJV4EdXz7PR9eAxjg==
    Z1fDYTR6dKdO9N10MgqDKLiPvxsF02Fwfz8ZucPnIBwPEYAgvZqFwciNIvU2w/GfnGiQVzfdrC2Yub56eB+EUydWyfBhOHXCL/PZpap95sSTu4k3iV9U3YAV1QSqD6F/lVdxuQ==
    aFBS5CprUP5XlAjrvDcrYuYUSN84DF1PtSHwo8fJbNmNXWtTDx+LSp7e6sTT1BsshgCS/cbADJ1n9bessE7zx1mhqZe1/O0aIagxIkkVixJ1mrD+zqIlU2fiL1+8E2lWiAvpdg==
    FaByBbOH/Qbn+zCYz5a1Tfar7b3/ZVFXgust6soHebVr0X6NuX10ZgqB09HV+wc/CJ07T7VIDdmFovpFMq0HCce5C8YvyX985+V/N2F+cRu/eO7F89WT410PPiXlvw8nag4N8w==
    539Rz9RMogAo/qbuvMzUC2ajeJlDVw1SXDBNBbOiKl/xvKTAKPACxRmceRwkyeiX60FaUTRzRm56ndbjuffxjkXvgjgOpjsWDicPj7u+eOJHk7H7w16lf96p9HCD8Hee4Xrejw==
    TrhCzOe8aDZm469Oqc/Vz4fl2lTqQxB8KRoKiJaWup+EUfwxUJXAJOk5eWr50Ai8+dRfeV7cSLP4wQ+6Eo6L1M9ZCq40YjFJkymZXD6of1VJPiWF5HmP1u4TDORKJUXZOFSPlQ==
    sB5/vFH0BQBibAE6KG5u3vq0mi2rIWvQyPHj25mSmDkEwh/c1VmE5HKQ8hLROM7/srTjTZyoyP+bn5ynq4vhD66jRnNozCM1m91QG49DBXFY4Mx5WM9/m2oW4fjzreO50WcjdA==
    x5P484/uNBhCDArCTMZFqUtMGMMcoeLRzFMT6jHw1EtzpeTGCRedMJGFbKALy8YawQxITWMCEUGZAS1g2UUPy7U4saNP/EQHUjXNQvd+8vVHZzZTacXoMp7nR+D6t4kkW0qw8Q==
    i++oVHTpO09KHZgFYRwNf6WHw98mA/VVqS+P14OhqvRK0eUvChIf0/J/nXpJf/4O/5E+y6hbpMpEVvdTjMVB6L6P3el783rwL51LgCQilxgSdkkQYpcSEHBJLSyhlBRwnfy7GA==
    HvdrnFNkMcjqwvLHN2GWQ6WMwI+VmpLmH2W/+Qwf5VwWCSE3uexwmXO25Ry+qchluvfO3ItLk3uWv2BNHvwU3Cq2k2oh+XBnuaqhlHblXZm2afPTwmFWRd6hglgLqgxXcVIbLg==
    iQLrvzSOFgg5VEPMJK0FFwI0joCtCS4MQjgVls40RjFUmNHVk47DZZ3IrUELhLC9aHm++ueoeJJK3G0wtE7wrSGUip7uCj3UFIwRRJBLDEQv9DaEHmoNjE9P6KFjCr3G0AIpgg==
    jFEE6sk8JpQ+yTXN0KUgjOuC25oNbQxtqBOKecfRsk7j1oDlTGTe9gjquMzDTaGYYoYlhZT1Iq8s8nBrUHx6Ig8fU+Q1BpZLCBReIGYM9DKvJPPag5YzkXnbQ6jjMo80prkiJA==
    IZAQ9kJvQ+iR1sD49IQeOabQawwtl4JgRJEk9dByTjKvPWA5E5m3PYI6LvNoYzJPQAIoh7yXeRsyj7YGxqcn8+gxZV5jaLmEAhMpFF5gL/RKQq89aDkTobc9hL6B0OOkOaHHGg==
    gzECLFFeKakH47OSeqw1OD49qceOKfWahItSETEjNRfAz0nqtQctZyL1todQx0093hiMOUMMUCFRL/TKQo+3BsanJ/T4DkKvJUxO15HNjKaY3PaS/IP74Hh/TPdufP5w5zVnxg==
    MqgUYEBr+m4N2yQ6BYZu6wbRNakhwahmMg6ZJdmJCPQSrY/OEGZhENxbYbiY3tHM9TzV77DYJVNbfK3JzVK/1sD42ltVIwfLtlfgM3ztrcmOpGKXiRrxyA2f3MG7i9Jb90JCYw==
    rk+MEQQQIlEPBFjHpoGBDpAgQqcCm4gSKjTCqNQ1dGogOEUANDH5ywKsy7qlaApLlKv5QIHoVcsN1VL0quXBVEvRXdWySfu5iiUlf9k+3VLDuUCckLWGI0J1YK01vJRrpeF55g==
    2g0vmNQvC7lbMInoFyMq3Rzm+dd79rzHluOVvanZbtjieb/huFMbjofl3G3dUKyUQpnTqpn7w+fqDciv6RS6SSyZcZayZpBj0XP8hbwfO5fmH9aw96YC8bdgHn50793Q9Zu2SQ==
    1W2GsOp2PXU8sUSpYQHOKUlEm2DEQqYhsYW5bXRch9ggc2uUiHRWVoGzLCZfkYimzQhDu0jEhEJqmIolu2AeexPf/fDkLVjA24oEtrhhZydZ1MRB/G5jHA67gJNOpBvFHANfVw==
    jfvSLMCIGjwoBay3iqMre5cbmsBcVwDTgaYZJjNtoWaZRZUh3G2AVVG6x9g3wVjVUBwWZtpM2ddu9CkoznxqFGeIcwgkoPXcSljXkU6ErenYIqZpSWZDphkMS02ajHbcrVRJ6Q==
    HmffBGeVY9EA0PZXKs25azpxw+okopARKeu6pJTejAw72buspJ1FhA5tDdscI2lJyES3YbhC4HaDL8mQ23e/fr5UlvNk8boyaE3EPOxgLta1AxtbkWEIYIKUnlpPQ1W6qUAU2A==
    0lDjSnVdBxILYloCIFvnp2QCthu1TUOwacPtaEbbT860MTBcIjWbsUBc1lyk16FpIoEJYJKYkEgdYw0yzjiy1JXVbTSUiNzjYXcjK6Hfke2rpjDBFVEgYjVX7AmEDBBsM6EJAg==
    NVO3bWBzYQJdsxNbq9uI2CByj4l9DaLDoiLX5xpTljhQWMCY4FpgoBqXkgMDa0IQCrGmUUo4w5aAANOuu/Ny2rYbAi0wbpozS3Y1SSrWpXddO18s5eZ//dLw6tTq/tLwB+dFGQ==
    2osxUpzHXRnEk1s4louVz/V1YIRF1X3JaNVtASpvc1BZCcTVtTAEqmupXKqGAvCVbjZ/VnY5CK4IXN4tCO7DxHeHiXj4KficXDfpd+QcEsKUgK3n/CdKDhuEQCIQwQYXNkZM1w==
    pSawiQEi3RbKCW2L6xK52yKoU8xVyekVTrTOjZPPJXiv8TVSyddWK3vSvMmDX1SWVf2NI8229m3uGqib6Q+lmbCmR9QIyW1WJ09ZgelGo3AySz4e0zg/gJRQLJN9kD1DWGMIVQ==
    RG8LV8hEbs8WjskWquZDC3jD7eNklrgGspWYhpnDpcAYISlqHr5zPsyhkupt4Q6p4t0zh2Myh8r50ALu8Ke548eT+KVxzpDsz4QU0XqheufDGDYI3hamIEDPFEpMoWrHyuFZxQ==
    xgw5AJt4ZQ6kPpZ+DmwjGNbovT3//bM/UTkb3x1PEQRcItyrZevcd43cbeG8mQuzh923Z71r0+N4bDf1Vffjf0S2+7P26WYUN+8rQxIiwgTo+e463y3Ruy2cN10N6oH37RlvaQ==
    frTAME5+tGkw9w/AJShGCCde9Z5LrHGJCpq3hVNkC8THZBVbR9r03OU17lIxrxrnMHlw0CFjBqBY7KVbZNl9UXglLmivmbrv3Np9S0v18SslzXCfBbLzJlGdVYLzplAdl+l5Uw==
    qI5D8bwpVMv5c94kquMeOW8K1bFjz5tCtfT3pki0g/LeaqoudNu7IPgydcIvqeKtKlCmourN5+8D3Rl9yYllJ4HGymrNkx+cRWo8iVIbday/ZKfgKcPweuArAy15Ohkv47C3NA==
    1hszzDHiKNlTkkcaQ9olK3ovO1l1VTXTdWLVsVt3lAQxbWM1lwdsSVPBkQBALKKx3/Z1aLamUckYx6rZpsl0ogMbIECxjaSVR3pv+DoqGp/QYCuzfzerjWeHDL5ltSG0jCzfPw==
    0ru5JUKQnB0sUM0P/hpckd+gkFgIE6JDoUkTWtSm3LIty9RPxwm1Quy2OJ8qzfl9JQZ/9XzMVYnRVKB0Czy65fjM5qBEko3ulMB6UAKSabYqo0GuEdPiEksLMSmQKQ1qyI6fRQ==
    /1aEdFvwVO386QCgygRtAao2AhubgpUaJCjUTKh5CNnZLJJsELwtqKr0F3YAVBsEbQGq1mIAm0IUFkgq4QPq7exDBOqGQXWdKi2cQSWuLM3kAjKOCBKw46exvBqS2xY0VfqWjw==
    g6bsBW9/CajBENcWwC2J+/rj/Y+uE83DxuBGMFMGlhA1P7SLbC5taRENCGIYSNgmIBDaFJiajfWOn25RjsFcELstcKtcqOiA8FojZkuQlEZQNoUizjFmRKJ6sTLQQJKYuq5rug==
    JJIYGkg2szNNsw1maPoJCa0FoduCoOqFrFORWAtytwBjyY85iUZJQMuNG45UdZ/UGDaqK0JlSHFKSL1PGSis6Rwlh1+ajEDb0qhhQM0izE4+bIBOSHi9Rfu2ILFyvbQDsuwt2g==
    tgB2KzGqjaGMCSWlAOH1TkDjEpk6RMwEUEFTSs0yDWqracS5LQTr+HGAr8SLtwVVlWvspyLeVujdAqSV4jWbc9QLJIWksub2DGJKjmyoUQY0IoStWwwYDGkmJ8lxzR0/nfmNwA==
    67ZA7vWgjSNHV7QFpqVxahyqeaDH60+r8V2EhahXXawHchwuGLpiWf2Yq6dtilruZl8OslzQojjgbnblIH6wNkXWdrMvBzHpWhSr2s2utEY/OU705xZqfKZ/fgpix4saNZilgA==
    AgJZfFGiOxGamxRpY7QmZ0K9B5F6pzZ1LVpTcKwj2KuVvVrZia70auU37coe4m4t1vRgspAwgVVPYT3n8WlHyJWJXBWCWpGnFW4uxGTldu3khHo1Txcb+nErUbOvT+utEfq2vg==
    6A1U5663gwGaIiAgkv1J228A+pUxaAuWW2MS5rru3jA/rEP7ldFsi2P7gGd5QNzbGV3uS29ntLErXbQzTlIr7B2oFQ7UGuJkvSG926oXJ53rSi9OWuW2ytlBuFbTbRwGy2rCXw==
    NYUz1Tz7e++PvHliPv6sffqUHt7RlD9LMiwIAr0/C1xlBF9Llel+UJN3m5kzXC92AJ9XUvAw52y2BcxbUbsB07s+V4jfVc6+I7jmGudcmbdhtSfNBXIzSAEUtD/St5J3bVK+0w==
    3KsDpwG323/Yena3OWEP6JMsf0680aOZc+e1O1IY2fIFSXRGcpcvT7l6TJH+0b13Q9cfucsJmL13cBGm8b/h+3Fxbsd9EMT1ShS887V3pJ+wXsm/OG/ntVdsFFhsxX64/SVHMg==
    lBmUH9PdOFhmCB2r0gtW/qAAldQZzK4HlKW505m8SGVIXySTj3mnHt4U1llvFg+zti6SD/M4TRZdUcwhWvKC5Tev40nsuTcPWUJJk+QL1cmrJr57M4lHqvWYLThHNtjp5V0wfg==
    SS9UmXlyysW7/wNQSwMEFAAGAAgAS3JQSJzb8T8UBwAA/CEAABAAAAB3b3JkL2hlYWRlcjIueG1s7VnrbuM2Fn4VQfujwAIeXSzLsjFOYct2JkCSNZy0U6C7GNASbWtHIgWStg==
    kyn6ZPujj9RX6CElytckjuNu0WkHmIi38507D03++r9f3n/7kKXGEjOeUNIxnXe2aWAS0Tghs465ENNaYBpcIBKjlBLcMR8xN7+9eL9qz2NmAC3hbdQx50Lkbcvi0RxniL+jOQ==
    JjA3pSxDArpsZsUMrQAzSy3Xtn0rQwkxS/o8iU5AACqxYFiDIMfbA8mSiFFOp+JdRDOLTqdJhDUMgDj2lhirfF+MgwgryuKCXLZyRiPMOUCGiCwR13DZUUpliH1e5DVAz5FIJg==
    SZqIR6WfhqHgBUbaJUStEkiStAuByo+mYMfwLUj6NFpkmIjCogynIAMlfJ7kazVORYPJuQZZPqfEMkvXLjjWi0/5oF94dw14QmQ9j+jYR3hEQlQUx4iwzfNQlqxOM82GcZ3G6w==
    ANxdgHz2NudcMrrI12jJ29CuyOcKS+5Mr8AqnbypGn+bMHdzlEMGZlH7akYoQ5MUJAKXGWB1Q4a1KfdMMUnLz4iVjTvxmGJj1V6itGPeS7pLlkDsWOX8R5iDCIJtGbqPOaCihQ==
    oOv5HogBu7fq0VwDEdirJUVEU8o0yarNv5RIPEcRVm2Fk+KpOJF0QoWg2YnELJnNT2WcEJ7E+MObqL8/idraM/wkDXGa3iC2Ycxtp8UPaEfnw/PWLhr0rin9rAW1va6imiaMiw==
    MQUQR3ZTVPbWkyFNFxnZmNcDagmhH3pQ1Kve90XP2RCiClEZkLI5gy+AFLI37FZQanR43NqiFQym4ZARj4Gl3R/6nu+a5dA92xhTi6PibylB9HET+pDFypW55jFSiK7v+q2e+Q==
    NOPR/tC4j6dokQo50+u5Qz9UEuUlg+1sTUSKtQzlCh6L8lP0UZogrgn+cYuWbcP6gBFEjqXLpYL5dD1JdVKj2TbBnTp+sfjTHUox/xQyHCfi0w3OqOXU7aaO6FhT1RzfabbAWA==
    vvZQnkL4zmkKbGU3ptEIsSrxgmEYOPVBr+F6gdf3vcDtuX0nGNrDRs/uhlVM7KIggXoJkSdFQMoZniYPNyjPoQ+babGvEm53vpHVcl0l40eCoMdrBC3hyJFTJrj1gorWN9I/Dw==
    cESad0wLQNtgmI+QgGNF/0OWSn1+dP6j5gr76t6emWFCpbSgDF8JnF31O+ZPPTCY23K9Wt3x/Jrnun6tZXt2rTGot5xWq2E3e97P2kH4QZQmqfwMjQGJR6xYAb2QEgFclfUZpQ==
    0wFjVejyHPIbVGZC7wnbgbsTkrvZcbGnkkoCJRB7miHIZ67FruSzqqBlx6aPkkJWTr0vgvM5ZktsXhg7opyQD7f0jIngO426aze9vxOhvbbv15MBt/QcoS9deqB+PC3EeerH3Q==
    YiLOU0L6SOBzJU1Qdxu+E/iN41JmEA6afuh3u72h59i9wHfsutsddB2312117a8jZaR9v56kkdr8pdNmhGZnPXA5ntf0nJbnuX+XmbY27p8/X7Qmv8vp6gXmT5yudo9XrwKdpg==
    cThHkqRs3SvxJ3gmb5msE1Hhl7Rg99JXh0UedS8HhvHvfxpdhiZJpJo3g/HlYPiv8U33XmlUYZxXM45zxHRp3AOWGM3AbXrF3QwrIozQkfSvpih/gl44v4Ph8TpkXo/5lLmtvQ==
    EHmd649x6e13N9Krd6e49Q9y10skR7lor+A9X8g2vHWwkBX75lYZKzhY6yuQ0y5CXlELQ/nyQB5H+jXlTL+83KAeBM2Wo28g/iTFa9saby5h5RvVq6rYC+emMgXeFm6r9n8jPQ==
    rO4jd85SL6ZL+WICzRyyPE0INuKEi3t1nyhbvap1XbXGxW1j7nhtRKI5ZVfy/rHvNYf1pp6QrpTDTthwQ7/vm4oFbCFgHiN66Jiu49vwzzSiR1hlB0XHKpZNpzgSg2JxqrgJ9Q==
    l6m/k47p1xvVankqY0ZS3HpCmEEqlX43HL0mul1eMpTPk2jIYIVUHrVnGyPXNPrM3/wOSihsOWSGu3CUiMT6GvZ5Ad7KdgMKfhIgY8H2X2SOf4e9eA8tGfFnedUt0MgSPCJ1lg==
    HTBF6S/7sL/0IkliyC0Gs7F60lziMebJF3WBL5WGhYXfDti9GmKMruaQMrxyxyZ+2d0ScJIm+TBJU8lCtg3WxtkEg8AQ6Y7iDIF8zUXZKgz+kxt0bbvl9mphww5rnt0c1Lotrw==
    WWvag6Zne4ETOuHPkhrSY8FlxKG0nydnePcuXhQK5ZRE+qtktAotpLBQxrGI5rI5BQXHYKySqJqxti0gexx2E2OyuqGxfrWSAA9TlskviGU8KPaPWojCKs9mubUGyBkXl5hmhg==
    bICNQSjFAC1B/HKtXiPHCZWiFXxSsj1iFUOWFrtswn81t5Elm/0iRYv9T+2O1ba4eV54+teziIoP068l/6fDxTxmF78BUEsDBBQABgAIAEtyUEgJNNi4HgQAAAwPAAAQAAAAdw==
    b3JkL2Zvb3RlcjEueG1s5VfbbuM2EP0VQ33YJ0eULF9krLPwLZtgN4sgXuwWKIqAlmhbCEUKJH1L0S/rQz+pv9ChRMrXTR37pUVfTJEzc+bKGfqvP/58/2GV0sqCCJlw1nG8Kw==
    5FQIi3icsGnHmatJteVUpMIsxpQz0nHWRDofrt8v2xMlKiDLZHuZRR1nplTWdl0ZzUiK5VWaRIJLPlFXEU9dPpkkEXGXXMSujzyUf2WCR0RKUNTHbIGlY+DSQzSeEQbECRcpVg==
    sBVTN8XieZ5VAT3DKhknNFFrwEYNC8PBfMHaBqJaGqRF2oVBZrES4hS9hciAR/OUMJVrdAWhYANncpZkGzfORQPizIIsXnNikVKnTIEXXJaDgcBLWDaAp5gfF0IpLSx/HdFDJw==
    ZERDlBKnmLCr01qS4oRtFJ8Vmq3gevW3Afj7ANn0suR8FHyebdCSy9Du2HOJpa/0G7BMkrddk5cZM5rhDG5gGrXvpowLPKZgEaSsAlGv6LJ2dLNRY2qWB2E+RmpNSWXZXmDacQ==
    vmq5jyKB2nEN/TvQoILqCEFLg5N1BsBZpDYcPTAEGl++45mFYtDmtEDEKYeOgOeK66186Tg5kMxwRPLvHIeSiTpTdMyV4umZwiKZzs5VnDCZxOT2IulvZ0m7B4Ef0894zeeqTA==
    0SRZka009gml91hshXppgAv2eIX3IgJ0vxUccrj7eFo358/WERR0c9xJIqR65ADj6S3FZrch9jmdp2yLbg9yFsZvezAvy923YudtGVEWsS5Z/TmFFUCM9fW6Z3w69dx/9dzd0Q==
    BXMbggU5fAQTUW8QDMO6Y46+Cn3W7db7rV5+8WSszFLYLIqFYja1cYtxdfDJ6jF0TBMsLcNPX/CiXXFvCYasu309sdn6M5liuMNYET35bL7xdFdolL88RPw0wpTIp74gcaKe7g==
    Scpdr4aatiJjKxU2/ForQIGlZBSKb8YpKNbbmEcPWJTX5qYZeqhRC/1hawjJr7dCNOyisHvThwgMmqF1ah8FK9xLmH4iAVImCJTsPc4y2EMzLPoik6jzTk+7zZSL1wzDTlYZXg==
    wJMh40JJ9x8cdN/pzKzgiTPrOC6AtiEs3+H6PObyP6dU+/OL92tOKyJsd0cDDcT8UiouyB0c3Q06zm+9Zoj80A+qNS9oVAPfb1RDFKBqfVgLvTCso2Yv+N2miKyUCUtZFPDR5w==
    TAF8zhEVv6bII9OIPb9+pBG7G87MluVDXoStZq3ne86Pa/Xh8OhxQCZ4TtUWJUc2CnZGxhc+gs6UP1BMlk2FHzXjDbWvro9GPne14CvUGedtKMsIuuWt+09HcsfF/7EvmsEMnA==
    rQl1ZIK5Jee/2n29CDtTjpjoDbz+0N8xEQ1R07vZMXGPa8tEw/xDE284V0TYmW8a0IulenYSype+3Du0V/TALfgre/03UEsDBBQABgAIAEtyUEiKcFW6MgUAAOIZAAAQAAAAdw==
    b3JkL2hlYWRlcjEueG1s7VjpbuM2EH4VQ/2xQAGvDssn1llYknMA69SI3U2BtghoibaFUKRA0nayiz5Zf/SR+god6vKZjWM7aLDYP6bI0XzzcQ4OrX///ufDx4eIlOaYi5DRtg==
    Zr43tBKmPgtCOmlrMzkuN7SSkIgGiDCK29ojFtrHsw+L1jTgJdClorWI/bY2lTJu6brwpzhC4n0U+pwJNpbvfRbpbDwOfawvGA90yzCN5CnmzMdCgCEX0TkSWgYXbaOxGFMQjg==
    GY+QhCmf6BHi97O4DOgxkuEoJKF8BGyjlsMwoM9pK4MoF4SUSisllA25Bt/HbqriMX8WYSoTizrHBDgwKqZhvNzGoWggnOYg829tYh4RrQiBaR8XA4+jBQxLwH3oB6lSRFLm3w==
    RjSNPSKiIAqNfSis28yZRCikS8MHuWbFuWb1ZQDWJkA8OS44F5zN4iVaeBzaFb0vsFRJvwArC/Lq1sRxZAZTFEMFRn7rakIZRyMCjCBkJfB6SaW1pg4bOSLZ0OfZw0A+ElxatA==
    5oi0taHSu+Ah5I6eyW9BBhkE5xlMH2NARTPJlnIHaMCxl8xYnANROOSUhs8I47nKoiW+ZEgiRj5OnhMcgsfyQNURk5JFByrzcDI91HBIRRjgy6O0Px+krW85fkRcTEgP8RVnrg==
    By14QBt73i3XN9Fg9omx+5yoYXcSrXHIhbxhAGKqKUHZbCl0GZlFdEWeLySvUHbpQDcsZp/TmblCokhRlZDqcQIjgKTcq0azke1o97q+pis5iKE7Bzdg0nA8u9usatnSkKu1Tg==
    p+o2nLRM/PQ3Y+DfrkLv8lj2Zpzb6PNtKzsM93e85eExmhG5IkmQUwM8G9aKdiA5U/0h5ZK8ohcaIpDZ8DKERQuREIn8jZ+u0bxV0i8xgpzT80Y7DCXBd59GJD8O0GRdYZDceA==
    eHA3QASLO5fjIJR3PRwx3awY9bwWglyrbJmGUTcaZq2SyWICiT9lBMyqacD8PuJFyVa6bsezTK/reee2Ua11vDogOF7H7ZzXTaeab2kTBUnkhFRdzgAp5ngcPvRQHMMcjuH0RA==
    psJov1N9dtlfg0eKYCbKFM3hshIzLoX+zBb1dyqyD3C5mrY1HUBb4JhbKN2bRP+3iKj9/G7+mchS/+azLTeDIDkMJOP4SuLoymtrX51607Call2umHatbFtWrdw0bKNc7VaaZg==
    s1k16o79Vx4g/CAzlxQZAQ8uoxLsJP7mjI27nBdpLmI4C2CTXObnx84kf1luybOtvSV1lL7zNI8uDbQl/4K2XuT5ScipnpyfuJAcAvM51s5KGwxftbKu2clKqlGpNKy6+aOglg==
    BXXNvsNKumanKCEV2x2tzDuv2TXrlK0sXt/bbCTVSVDk1+7utUfleEjiU9UONKOqZTeqdnOv4jEs063YjfOG63Tt6nndgTKq1O1O13WaHc82v4/iUQ5+i+WTpeh6USiyr1IWbw==
    sAL6aHLSy5hp1WoVu2abxo/W0cqd++YzPyf6KvepVUtP3JI2r0lPI4xJ4E6RkmdPw4TYCE/URyd9Hwj4Fy35UHl0N5l+56JbKv3xc6nD0Sj0k8de9+aie/7LTa8zTLgWGEdwFg==
    OEY8bzxbKAqjDncw215t7pT1VUw227l5rP/wMqbPADzlNX0rhi8L1z6Ruf61p4IzOCQ6/1MgnlPZKx5pI9GX3xiO/NJw8j6UHntrXWiNsxp4/nVlx03R9Ey3u35T9GqGUfPW+A==
    rS+t8ssk+/BT2aG6VfJFC/pVdsMqAjJKZ+LLsqNp+ZIrNhY3P50Um54G/Ow/UEsDBBQABgAIAEtyUEhH9hJDYggAABRJAAAQAAAAd29yZC9mb290ZXIyLnhtbO1c227bSBL9FQ==
    Q/swT4r6fjHGGZBsMjEmCYw4SBZYLAxaomQiFJsgaTvOYr9sH/aT5hemKJG0bMuxJDOOLPjFZLO7q6ur6tSlRfqv//3/9z++TZO9iygvYpse9PAr1NuL0qEdxenkoHdejvuqtw==
    V5RhOgoTm0YHvauo6P3x+vfL/XGZ78HctNi/zIYHvbOyzPYHg2J4Fk3D4tU0Hua2sOPy1dBOB3Y8jofR4NLmowFBGM3ustwOo6KAhbwwvQiLXk1uepeazaIUOsc2n4YlNPPJYA==
    GuZfz7M+UM/CMj6Nk7i8AtpINGQssJ+n+zWJfstQNWV/zlB9aWbkq6w7n2Ls8HwapeVsxUEeJcCDTYuzOLvexqbUoPOsIXLxo01cTJNeqwLMHqcDk4eXcLkmuAr7o/mkaTLn/A==
    xxQxWkEjFYl2xios3Fyz4WQaxun1whuJZkG4mK9HgNwmkE0ep5w3uT3PrqnFj6N2mH5taVWQXoNWreTFrRWPY+b4LMwAgdPh/uEktXl4mgBHoLI9kPpeZda9ytmUp0l9Ocrrmw==
    4/IqifYu9y/C5KD3qZr3Jo/BdgZ1/xfoAwviCIFLgydXGRDOhuX1CBcYAcc3a9msIZWCm6smDG1iwSOE56WtmsX3g96MUJGFw2h2P6OTRONyw6mntiztdMPJeTw523ThOC3iUQ==
    9PZRsz9vNHtwR/Cnybvwyp6XrYrG8bdoQY1elCTvw3xB1Jc14fnw0bfwlkSgnyh2d8TgNr1qbWu/NhtBzJnRHcd5UX60QAZXzSSsW9ednk3Op+lCf/NgNiS1b12Il23r87yFFw==
    mGiNuDLZ6nYCVyBSc885rve06nPyw+eDG2tB3AZhgQ4/AotISeqS2UaqR5/y6plURLI58IpRWV/mPOfzSxKmk0Zuo7Bv/mzWqfvDJA6LZsA/PoQX+3uDt1EIWh94VcROr95Fkw==
    EDAcllEV+Rp9h5Obk45nmUc+OjkOk6g48fJoFJcn76OpHWCKZGORo2aWEJpxrlRjq1kCxndmE1i4ao7s8CjMW9hQ4UnNpdBKEeZzojztEIIUkw6VnmTNpm5TCcvQjdMqRQJKWQ==
    HoHJvg+zDNrgDOd+MS3QwW9VtLuOcqOrNIRW0U/DC0gZMpuXxeCBDQ5+qzTzDVKcs4PeAIjug1i+AHw+zub/c5pU+/kX/vesby7hprVU0NA5A2Vp8+gQHh2ag95/XKkR0YT1KQ==
    ZqLPCBF9jRjqc59qrDVH0mX/bVQUfStrsbRGATd+OjrK5yOg5dm0hMVm44fzv7XJD2u3jAlf4pYH1yOzxkiP8rtmusRyj5aMMtE4PE/KhZ6ZCS+lvIZxl6+XinbG/Xzc3Grq/Q==
    NLJqhTJoYbVdwmkX2SXWqgG1v18IEEsCyKAd+ZS7qS75o73yw+72s/PpYzSJizKfVSof7Mm706Qrr9vHXAvOlMRkJb9ruO8Z5jg+cTwmqO8KYgwlxgm4QMLTO+F3l0r8+bnfxw==
    eNqspnUjVa+EBRprLAVSvyROo3cXSTOgxUczPbd27Od5y26RQQ4HCswbhN/v0VtXvVQbNzz2fQuBaFuGHvboayDzrZ1GR+EkOpm3uwQk5uAqOIPcZiU8epRg5CpKkRCMK6Kwxw==
    XcmZH0gREFc+bzwukfMLDJ8ahkuU8GvRV/uFozMoX7uNhpgzirBEAq8EPsSMb7D2fOpihg13BNKKBJK5PnYoR88bfHfF/IK9XxQCF3Twa6Hnvw/j5CdEvT7GCop4TKRYLQ2lrg==
    TwSWJIDk1aNU+Vo7igntM5+BRT5v5N2W8nbjrqMy7blD9bbSOgfqL6s3O4uuEFqV0gDTlTCu3UASFGiEkc8CLRxFKMfaNZ7hcOc8b4zfJ+ztxnrnwP0pBeJWpKdN2txdbooEQw==
    uo5tD9eFMqB+ILCHXEYDCmCCCCsdHhDtIhnsBHgaEb9gZm3MNKLbCqjU6W13yaSQHIG5q9UCDaGYGsONZlgyA8aBA0c4QhGltXLRbmCllvELVDYtvrYCKbMkszOcMC25lIiuFg==
    UnhAEefCkZCNMSqVxgQZH0NIoq4R/jOvuRYFvN0g2YZ6qwtczUT9bKskN0y/fginnaV3fVC2glqHI7USGoXvGIodwnzHYS6BSKV8Qwn3PR8pI3ejOmqEvN2A3MXTjFsK2Irgdw==
    6DofOj3tl5hShDheLf65yAH7qn6ew4SZwCiXuNj4AvvGM4i4O4G4RsYviPtFiGsU8ASI6+yFwOMvh8GnTpHJhBIUo/o9vgcPOwzTzJUCKUIZclzHIMM54oZ6MlAG7wQyWyG/QA==
    c31odvfiYKuGDd4ZXD/kvYlz2+1P3BDtOKKS0JWQFWBHU0c5LDCEEU21lER7gEzfEF8pbyeQdS3k7YbWNhR+2xMor7W2JTXk07tJ1yWB8O5XzAd7nIXD2YdcN+S/WbXr5mE6PA==
    6/KYlkgkQDpktVdPOWYewgY7EipeIX0FoZ4zKbXvCu45Yid80aKgn9wbbYrLJQZ8p4psNrUuWJdH0vX4qD54az5mAgMoovwi6r3eu8XKZqhwhkN7npZdwgJJ0KqSYrXk16cmYA==
    DiIYc808FWhHSwNFKUNICC53BxatpHcKF+2uugDGjeC26RFLZ5kmouDaGV7tXUqHBhop1/MN9Zn2XMeVShHiE06MhECxE2ZciXe7c8wnSRjvy0s6O0B5docnnQUPioWGnEqtBg==
    OuIGGgfaN9ytXrGSrtLYgbySE48jhflOgG4m4BfU3Yu6js9GnvBcpCvUSEQQQEas9smNizhgpPoVAHnMSE8hoajwfY4DJNzgmX9yc0PA242abT0P+anhba6Yn3XkUV3m/69j3Q==
    z2fXEVBgbRnlzZ5rq/jenhY1xwHFd6+49bBxOo1Q262Ngfu/AVBLAwQUAAYACABLclBIdo+b980BAABSBgAAEQAAAHdvcmQvZW5kbm90ZXMueG1sxZRLbtswEIavInBvk3ITow==
    ECwHiN0G2QXJCRiKsoiIHIKkrPpsXeRIuUJHbzcNDCdedCO+Zr75hyPO2+/X1c0vXUZ76bwCk5J4zkgkjYBMmV1KqpDPvpPIB24yXoKRKTlIT27WqzqRJjMQpI8QYHxSW5GSIg==
    BJtQ6kUhNfdzrYQDD3mYC9AU8lwJSWtwGV2wmLUz60BI7zHahps996TH6X9pYKXBwxyc5gGXbkc1dy+VnSHd8qCeVanCAdlsOWAAc3Am6RGzUVDjknSC+mHwcOfE7Vy2ICotTQ==
    aCNSJ0vUAMYXyk5pfJWGh8UA2Z9KYq9LMpYgvrqsBlvHaxwm4Dnys85Jl53y08SYnVGRBjF6nCPh75iDEs2VmQJ/6WqOLje+/hxg8R5gd5cV585BZSeauox2b15GVvOuP8Hqiw==
    fJyav0zMU8EtvkAtkvudAcefS1SEJYvw1qPmtyZHHSeqk3CwaOCl5Y4HcAS3VJaSWdzaWVxiP8seU8LY7e3i53JD+q2HZuvHFdssvw1bj1uZ86oMR8Yt5ME1g7dcoEC05XmQ2A==
    HLA/0vWKjgad1aCkP3OdRfvtVX+UgAATlKnatvH0Phn2n3L5UNSpvKa5X/8BUEsDBBQABgAIAAAAIQDHzvKouQAAACEBAAAbAAAAd29yZC9fcmVscy9oZWFkZXIyLnhtbC5yZQ==
    bHOMz8EKwjAMBuC74DuU3F03DyKyzosIXkUfILbZVlzT0lbRt7fgRcGDxyT830/a7cNN4k4xWc8KmqoGQay9sTwoOJ/2izWIlJENTp5JwZMSbLv5rD3ShLmE0mhDEkXhpGDMOQ==
    bKRMeiSHqfKBuFx6Hx3mMsZBBtRXHEgu63ol46cB3ZcpDkZBPJgGxOkZ6B/b973VtPP65ojzjwppXekuIMaBsgJHxuJ72VQXyyC7Vn491r0AAAD//wMAUEsDBBQABgAIAEtyUA==
    SAsxCBPOAQAAWAYAABIAAAB3b3JkL2Zvb3Rub3Rlcy54bWzFlM1u2zAMx1/F0D2RnLXBYMQp0GQreivaJ1BlORZqiYIkx8uz7dBH6iuM/ozXFUHaHHaxLIr88U/R5tvv19XNLw==
    XUZ76bwCk5J4zkgkjYBMmV1KqpDPvpPIB24yXoKRKTlIT27WqzrJAYKBIH2EBOOT2oqUFCHYhFIvCqm5n2slHHjIw1yAppDnSkhag8vogsWsfbMOhPQe02242XNPepz+lwZWGg==
    PMzBaR5w63ZUc/dS2RnSLQ/qWZUqHJDNlgMGsAhnkh4xGwU1IUknqF+GCHdO3i5kC6LS0oQ2I3WyRA1gfKHssYyv0vCwGCD7U0XsdUnGFsRXl/Vg63iNyxF4jvysC9Jlp/w0MQ==
    Zmd0pEGMEedI+DvnoERzZY6Jv3Q1k8uNrz8HWLwH2N1lzblzUNkjTV1GuzcvI6v5sT/B6ps8Lc1fJuap4Bb/QC2S+50Bx59LVIQti/DWo+azJtORE9VJOFj08NJyxwM4giaVpQ==
    ZBa3jha3ONGyx5Qwdnu7+LnckN700Jh+XLHN8ttgetzKnFdlmDi3kAfXLN5ygQrRl+dB4nTACUnXKzo6dF6Dkv7MdR7tc5D9YQkCTFCmaifH0/ty2H+q5kNRJyubbPz6D1BLAw==
    BBQABgAIAAAAIQCqUiXfIwYAAIsaAAAVAAAAd29yZC90aGVtZS90aGVtZTEueG1s7FlNixs3GL4X+h/E3B1/zfhjiTfYYztps5uE7CYlR3lGnlGsGRlJ3l0TAiU5FgqlaemhgQ==
    3noobQMJ9JL+mm1T2hTyF6rReGzJllnabGApWcNaH8/76tH7So80nstXThICjhDjmKYdp3qp4gCUBjTEadRx7hwOSy0HcAHTEBKaoo4zR9y5svvhB5fhjohRgoC0T/kO7DixEA==
    051ymQeyGfJLdIpS2TemLIFCVllUDhk8ln4TUq5VKo1yAnHqgBQm0u3N8RgHCBxmLp3dwvmAyH+p4FlDQNhB5hoZFgobTqrZF59znzBwBEnHkeOE9PgQnQgHEMiF7Og4FfXnlA==
    dy+Xl0ZEbLHV7Ibqb2G3MAgnNWXHotHS0HU9t9Fd+lcAIjZxg+agMWgs/SkADAI505yLjvV67V7fW2A1UF60+O43+/Wqgdf81zfwXS/7GHgFyovuBn449Fcx1EB50bPEpFnzXQ==
    A69AebGxgW9Wun23aeAVKCY4nWygK16j7hezXULGlFyzwtueO2zWFvAVqqytrtw+FdvWWgLvUzaUAJVcKHAKxHyKxjCQOB8SPGIY7OEolgtvClPKZXOlVhlW6vJ/9nFVSUUE7g==
    IKhZ500B32jK+AAeMDwVHedj6dXRIG9e/vjm5XNw+ujF6aNfTh8/Pn30s8XqGkwj3er191/8/fRT8Nfz714/+cqO5zr+958+++3XL+1AoQNfff3sjxfPXn3z+Z8/PLHAuwyOdA==
    +CFOEAc30DG4TRM5McsAaMT+ncVhDLFu0U0jDlOY2VjQAxEb6BtzSKAF10NmBO8yKRM24NXZfYPwQcxmAluA1+PEAO5TSnqUWed0PRtLj8IsjeyDs5mOuw3hkW1sfy2/g9lUrg==
    d2xz6cfIoHmLyJTDCKVIgKyPThCymN3D2IjrPg4Y5XQswD0MehBbQ3KIR8ZqWhldw4nMy9xGUObbiM3+XdCjxOa+j45MpNwVkNhcImKE8SqcCZhYGcOE6Mg9KGIbyYM5C4yAcw==
    ITMdIULBIESc22xusrlB97qUF3va98k8MZFM4IkNuQcp1ZF9OvFjmEytnHEa69iP+EQuUQhuUWElQc0dktVlHmC6Nd13MTLSffbeviOV1b5Asp4Zs20JRM39OCdjiJTz8pqeJw==
    OD1T3Ndk3Xu3si6F9NW3T+26eyEFvcuwdUety/g23Lp4+5SF+OJrdx/O0ltIbhcL9L10v5fu/710b9vP5y/YK41Wl/jiqq7cJFvv7WNMyIGYE7THlbpzOb1wKBtVRRktHxOmsQ==
    LC6GM3ARg6oMGBWfYBEfxHAqh6mqESK+cB1xMKVcng+q2eo76yCzZJ+GeWu1WjyZSgMoVu3yfCna5Wkk8tZGc/UItnSvapF6VC4IZLb/hoQ2mEmibiHRLBrPIKFmdi4s2hYWrQ==
    zP1WFuprkRW5/wDMftTw3JyRXG+QoDDLU25fZPfcM70tmOa0a5bptTOu55Npg4S23EwS2jKMYYjWm8851+1VSg16WSg2aTRb7yLXmYisaQNJzRo4lnuu7kk3AZx2nLG8GcpiMg==
    lf54ppuQRGnHCcQi0P9FWaaMiz7kcQ5TXfn8EywQAwQncq3raSDpilu11szmeEHJtSsXL3LqS08yGo9RILa0rKqyL3di7X1LcFahM0n6IA6PwYjM2G0oA+U1q1kAQ8zFMpohZg==
    2uJeRXFNrhZb0fjFbLVFIZnGcHGi6GKew1V5SUebh2K6PiuzvpjMKMqS9Nan7tlGWYcmmlsOkOzUtOvHuzvkNVYr3TdY5dK9rnXtQuu2nRJvfyBo1FaDGdQyxhZqq1aT2jleCA==
    tOGWS3PbGXHep8H6qs0OiOJeqWobrybo6L5c+X15XZ0RwRVVdCKfEfziR+VcCVRroS4nAswY7jgPKl7X9WueX6q0vEHJrbuVUsvr1ktdz6tXB1610u/VHsqgiDipevnYQ/k8Qw==
    5os3L6p94+1LUlyzLwU0KVN1Dy4rY/X2pVrb/vYFYBmZB43asF1v9xqldr07LLn9XqvU9hu9Ur/hN/vDvu+12sOHDjhSYLdb993GoFVqVH2/5DYqGf1Wu9R0a7Wu2+y2Bm734Q==
    ItZy5sV3EV7Fa/cfAAAA//8DAFBLAwQKAAAAAAAAACEAMlJ+tQoAAAAKAAAAFQAAAHdvcmQvbWVkaWEvaW1hZ2UxLmJpbgqJqWp8j4nLbq1QSwMEFAAGAAgAAAAhAHf7x0uhDA==
    AACgdgAAGgAAAHdvcmQvZ2xvc3NhcnkvZG9jdW1lbnQueG1s3F1Ncxy5kb07Yv9DB88LMQEkgIRiNI4EErB9U6y9hz22yJbImGZ3R3dTMsPh/+4sfuhj7HHUzOxGzUIHsYoFZA==
    Feo9ZL5EAeB3v//r3Xb1cXM83e53by7sK7hYbXZX++vb3Yc3F//9l27oYnU6r3fX6+1+t3lz8bA5Xfz++//43XefXn/Y7k+n9fFB9lf3d5vdeaWmdqfXnw5Xby5uzufD68vL0w==
    1c3mbn16dXd7ddyf9u/Pr672d5f79+9vrzaXn/bH60sHFh6PDsf91eZ00vvW9e7j+nTxbO7un63tD5udXny/P96tz3p6/HB5tz7+cH8wav2wPt++u93enh/UNsQXM/s3F/fH3Q==
    62cT5vMDTVVePz3Q84+XGsc5932q8vIGHu94edxs9Rn2u9PN7eFLM36pNb1482Lk479rxMe77Uu5TweLvw4DOa4/6Y8vBuc8/vVTpbvt05P/e4sWZiAymfhcY84jfHvPlye5Ww==
    3+6+3PgXvZqvXq4NP8+A+7GBw4dfB84fjvv7wxdrt7/O2p92P3y2NfXwn2HrGeSvm3b6dQ/z55v1QXvg3dXrP33Y7Y/rd1t9IoVspW99NdH64nv1PNf7q7fr4/n01fFXh2+P0w==
    yW59t1l9ev1xvX1zIa65DoVa94w+QmaO5JBCrLZB6xeXU42r9XnzYX98+HHtP2x2m+N6+1Tow3q73RwfXq4dtuurzc1+e705Ttcvv7VyfjhsHh9yOnip8u7d2+3VH69fyn8u8w==
    bnOz/ni7P35z8lLpar87q0t4rvNN0Q/3t9cvxf6WEJNnaaZGLwYpoynBkwloORbng0P792cr37yu55Oyv3588oNa1Jhw/V9vLgCogTi5ePmVbN6v77fn6Qro3QK9XHn71a8ejQ==
    PJk+/Pn8sP1ZWFx+rju9gMebvj1OxhP5VuXR+PG5wDfG336B4y+bv768ruei5+/r9vbqh9XN5rhZnfca586b4+qs5V49AvFU9unuX7+gp3fy5Xwu6xA4OehMiarCEqiVyDF4qw==
    zS16ZRzWaUshCRWTGKzBTmQKVTKUPIUMyK3hsqybg8VPsg6dL/zkeX77rIsUfUrMtWTCmAqlzt12b7stGHwah3XiYqPkusFS9D/rxHDs3dhgKzUbE8e2LOvmYDEG62oXLAFq6Q==
    pWLhzI5iYInJxpbjSKxDRlcSiamtVIOercksyfSMrnVOtmdelnVzsPhJ1v2/irDVFy/VQwFHSCWQFxcwEGMMubAbyNeRdylTNNnHYDC4aJSE3rRsnRKPqtSFfd0cLAZh3dSrQg==
    bZBS0FdPCgs2JzX75lOvA2UTsbseQ9WQ6mM2CL0ZRmIjkFjQA2JdWNfNwWIM1hXyiVyAnmvULlVKgewJpRG4XtJArHOaQHCmZAAsqa+jbNjFYjKpY4mVq0BYlnVzsBiEderVUw==
    ZW1v0f5VQLWsROnkVHsHdfcD6boUUsdojbYyKuuaZhMUxWgEU9neInZYeORkDhZjsK4WK+LII8SMYjEXrzo7pphc06M2DusgspcYk2auNWk2ETSbSKmbHhkbkOLW0sIRdgYWYw==
    sM6X4gpS5+Ibimiu1G3kGn3mLDEMlE1UBcVhyaY1bgZtFw2uuRuIvpIEqih5WdbNwWIM1qG1EdD3qHEGLUvpHXoigcJ9avo4rCMglUpJE4nJ4WHK1rB31YhnT06ajQUWHiWegQ==
    xRisE4Diag/ORtUSTRN229n35F1u2UYayNfVBCrQrak9FYPFR1MkFBMVX7HZeqhl4S9iM7AYg3WBU84JqmdN5YL1zCFgir6RBR9Gyiacy0o39iaF7gy6RKY0TsamEFziVEX8sg==
    rJuDxRis86iNq4gWyaGvibp3sZSsmZR4cDgO6zIEmL70G+jq4TDnaLIIGvJeFbwjyIUW1nUzsBiDddy1R2VVOj47lQ6xYIEODoLv6tdjGId1GqTIMaCxuQZlXfMmA0yDdqWCaA==
    duHKwr5uDhY/yTqKQdD/Yta1R56tdw+r5/e5Ot+sz6uH/f3q03o626+Om8Nmff7P1e3uans/zbxc7c9K088Vpp/H/fb0avU/WutqvVutt6e9Fj9tjpO529NLkdX6uL/fXa/O0w==
    xKnVcf/ppKVW++P1RPWXG60O+tJPq/371fqp4P9NB6hJX20NFpvziMWSZm62hR5S661JGacDWGreos8mT9+FMdVqOLlkPEwarsSWQ194EGcGFmO4XciRu0XHNjFKS9nn5mLW/A==
    Up1TzQNNROjd9UYlGUf5cRDHabAP3VjrAzSp2dmFP87NwWIM1jm0pdZQStDYEq22uLEksjE5dGQHGrDGJtDZeVOLcg1ZcxqukAw421RdVm5Yl2XdHCzGYF10PeWeGzIQ1uqoCw==
    oLU9gHD3ZaB0GooLDE6dW24qMRHBlMjZEGjbNYe1VBb2dXOwGIN1trqMUkrhkjFjZbCIMTL3GiuXgXxdp6IBqyvhiNFgZ02nO4Dh0hO0KGxl4UlXc7AYg3XavJKcjQ4kqtZpHA==
    arUabGKfpv24gXxd9DbZmrppDaZ0eoqwqvQMoW0RQ6kBFv5MMgeLMViXspNiXRSwATFnVl0derbTN3qiONDHOZtV1TnMxumBQRBrVKQnQ763npURNS48EWEOFmOwDiUn1y2HCA==
    jES9tAg1OlWxOM03G2iqX1M3AkHYlJbjtI4jmlLBGZXq1oL4JLjwgPUcLMZgHfVK1rcSHBKqYydXnFjq07cE4GrHYR1y6JyqOjfWzBU5ZlMygSF1KAp0cdgX1nVzsBiEda22FA==
    q0rW0tFCoWjBO25s3bR0ZaBFkuxjQJud0cBlDarr00Si6X+pBF+7jT0s7OvmYDEG66p3U/u8h6iSmhzZGkoK2HqK3ZWBRoltUgCBxDT2zSD6qjlsrIZZY1mSpinjwtnEHCxGYQ==
    Xeq+9WgrFPTd59IthaTRyOUCIy3hYF9idLUabZZG2ArNcPfRxJZK8xlbWHqUeA4WY7BOgj4rMjfHFaOKiuhEvBPuqmljzeOwTriAqjkxVElz2GSLIVXrJrM2n0uVmhfWdXOwGA==
    g3Xan6YNFzJYaNhzZHI+2FykStAjHod1vRWxTWkmPYhBwG6o9W6i5q+BamjSlx6vm4HFGKwDFBXXuTZfLFoJHCGT6wlLs+zDSFuuULFtWpXrJXllnUuGbbamQo9NWdd7XHiR5A==
    HCzGYJ3z1osEyWgTSlYYOsdpVyPKmQoMpOtyAHVokE2tPRokTWQ5ejShxBYToYPgFv76PwOLMVgnvjQXNb/Tno7Ve2o5M2HMDRuWNJCuc9BS8jgN0LlikIuYaU8dIwDCAilHvw==
    cDYxB4sxWBe6hxAiJ1US6BNl60CahZx8kdgGYl3PUjtN69NKcdN4HWoiUbtxFAJ5zWR9WXijnzlYjMG62Fi8ZYeNGYtTV05N8ybNpqaxrTRQNpEwxVyJDHs/+TquGmFV4cXUyg==
    NMGDYeklHHOwGMTXWaxgxXLSlioAhMABU8qat4fKcRzW1UC2ugIm+qS6ThIYbkymQGzdZQ3AfeEZ7HOwGIN1zUtHBmdt0A5PPXNOEm1DgBhDGoh1QdsUI6IhFXjKOilmWu9qQg==
    7qrVRTShWHhp7hwsxmBdAc6AwSW0DqULFVesNG2rVAFXxmFddlRstMWA9WmaXzfpumTV9VGg0ClrKrvwRj8zsBiDdex7BipVBUTDXAuXRORcc8FJcmmg8TqrreqpR+N8VF0nkA==
    Te7TSkkM1dbEtS690c8cLMZgXRXMmpVHIOdVRhQWkBAgiK+pkww008nX1hGyNYjTPskuF0PSyVRMIFZc9H3hUeI5WIzBOld6tj03CWX6CpOK5usMUIKrAcgOtCAcO4aWfTTcpw==
    NWLkxFDq3bAiahmzaqiFWTcHizFY1y1nz8TYxWn/9zkll6u30MQ1ojoO64r02JtLpjJPrPP9aRuCmnxnCxrY/MLfJuZgMQbrCgTtTpN+hYqSKkGchkxbsB1i6QPNrwux+mn6kA==
    cdFVM+27bkp6XDJWQ7ciOdHS24bOwGIM1vlYU9asPKtuxRYc1czOAWFin2rCcVjXqufH7eAdkZ3WTXjD3MDESjW17jXQLjxyMgeLQVjXKovT/FxEtXaILNOiliJcuSdbBtJ1VQ==
    s4gy/ekBrlFZp9HM5BbFeI5QbCipws+PsE///hXrvuXjI+uef/XTrJuBxRisA2erR+pUVcGGnoq22SfkVktmwYFy2NAj2ODFtObIoORmMiYxGtFAA6+E9Av+9MX/KuvmYDEG6w==
    esoWos8qV6edDgJlaAyZu2ruIEPNOUmYqm3NCFZQ1kVncrVi0DclY47ieWHWzcHit866L8enx5Mf/0nZ7/8BAAD//wMAUEsDBBQABgAIAAAAIQDSdzsz9QAAAHUBAAAcAAAAdw==
    b3JkL19yZWxzL3NldHRpbmdzLnhtbC5yZWxzjJAxT8MwEIV3JP6DdRIjcdoBoapOhxakDiw03bIc9iVx69iWbSD999xSiUoMTKe70/ve01tv5smJL0rZBq9gUdUgyOtgrB8UHA==
    29fHZxC5oDfogicFF8qwae7v1u/ksLAojzZmwRSfFYylxJWUWY80Ya5CJM+fPqQJC69pkBH1GQeSy7p+kuk3A5obptgbBWlvFiDaS6T/sEPfW027oD8n8uUPC4mlIOtNS1PkOw==
    MRvTQEVBbx0xXW5X3TFzHd0Jdfj4PnU7yucSYnewLLG9JfOwrA/oKPO8elUmlPkKewuG477MhZJHB7JZy5uymh8AAAD//wMAUEsDBBQABgAIAAAAIQD93rsTLwMAAOIIAAAaAA==
    AAB3b3JkL2dsb3NzYXJ5L3NldHRpbmdzLnhtbLRW23LTMBB9Z4Z/yPiZNM6ttKZpBxrCZRrK4PQDZHudaKqLZyUnhK9nJVt1gE4n0OHJ0p696+wmF1ffpehtAQ3XahYNT+KoBw==
    KtcFV+tZdLda9M+inrFMFUxoBbNoDya6unz54mKXGLCW1EyPXCiTyHwWbaytksHA5BuQzJzoChSBpUbJLF1xPZAM7+uqn2tZMcszLrjdD0ZxfBq1bvQsqlElrYu+5Dlqo0vrTA==
    El2WPIf2EyzwmLiNyVzntQRlfcQBgqActDIbXpngTf6rNwI3wcn2qSK2UgS93TA+otydxuLB4pj0nEGFOgdj6IGkCAly1QWe/OHoIfYJxW5L9K7IfBj702Hm079zMPrNgRHHVA==
    0kA3PEOGDU/aMmSefForjSwTxEoqp0cZRZdEyy2HXY8+jAIo50pEAycvoGS1sCuWpVZXQeP1KG7gfMOQ5RYwrVhOXbvWyqIWQa/QX7S9JtYiNbW18Bx2p9rA4v0N2+vaHiBpMw==
    H+RBMUlJ/sL5pS6IwGSK/Pg+OgOfDZX6RCBN84y8gJVrTmr3AhZUTMp/wFtVfK6N5eTRM/8ZGTyVACgX+Zaec7WvYAHM1tS2/xTMv8xC8GrJETV+UgWN5H8LxssSkAJwZmFJdA==
    4qh3vs8fgRW0Rp8Zd3BIK1rKhQmHb1rboBrH8eT1eHrWZOrQY5BxPJ2fjh9Dzt7H89H8MeR8Mj2fTtrM2nxk4lbdVwwnR66ebCyumcyQs97SLcOB08jw/h1XAc+AphsOkbTOAg==
    2O83gKGZFQuaxgD4EZVJwU01h9KfxZLhuvPbauCjUpr8zw++cno8wA+o66pBd8iqhjRBZTiZtJZc2Rsug9zUWRqsFO2jA6hWxe0WfZ+69uwSS4/vh++GeRJ5XVD9u7QlmcDUEQ==
    BJasqhqeZevhLBJ8vbFDRw1Lt4J+M/0lW49abOSxUYP5C8tdZaTdHjrZKMgO9MZBNu5kkyCbdLJpkE072WmQnTrZhiYcBVf3RPlwdPJSC6F3UHzs8D9EYTHnnF483cus27evGg==
    THBDM1jRarYaA/bGY8Op39l2RUS5p959g/IdM1A0XA1/Ti5/AgAA//8DAFBLAwQUAAYACAAAACEAg9C15eYAAACtAgAAJQAAAHdvcmQvZ2xvc3NhcnkvX3JlbHMvZG9jdW1lbg==
    dC54bWwucmVsc6ySTUvEMBCG74L/IczdpruKiGy6FxH2qvUHZNPpB6aTkBk/+u8NwmoXl8VDj/MO87xPIJvt5+jVOyYeAhlYFSUoJBeagToDL/Xj1R0oFkuN9YHQwIQM2+ryYg==
    84TeSj7ifoisMoXYQC8S77Vm1+NouQgRKW/akEYreUydjta92g71uixvdZozoDpiql1jIO2aa1D1FPE/7NC2g8OH4N5GJDlRoT9w/4wi+XGcsTZ1KAZmYZGJoE+LrJcU4T8Whw==
    5JzCalEFmTzOBb7nc/U3S9a3gaS2e4+/Bj/RQUIffbLqCwAA//8DAFBLAwQUAAYACAAAACEAwdpdKH8IAABTIAAAEQAAAHdvcmQvc2V0dGluZ3MueG1stFrJcuNGEr1PxPyDgg==
    55GJ2gFOqx2FbdyO1thhype5gURRQjS2KIBSy1/vBEi0ln5y9Njhk8B6VVm5vMwsFPTu+89NfXHv/FB17dWKfResLly778qqvb1a/XqTX4ari2Es2rKou9ZdrR7dsPr+/T//8Q==
    7mEzuHGkacMFiWiHTbO/Wt2NY79Zr4f9nWuK4buudy2Bh843xUg//e26KfynY3+575q+GKtdVVfj45oHgV6dxXRXq6NvN2cRl021993QHcZpyaY7HKq9O/9ZVvhv2fe0JO32xw==
    xrXjvOPau5p06NrhruqHRVrzZ6UReLcIuf8jI+6bepn3wIJvMPeh8+WXFd+i3rSg993eDQMFqKkXBav2aWP5laAve39He59NnEXRchbMT881V/+fAP5KwFB/iyUn6GO184U/8Q==
    5GxGs998uG07X+xqYiWZc0Eard4TLX/ruubiYdM7v6fYXK2iYLWexr1runv3M1G9a4v6Q3vahsL/DE2L0dm2vKkaN4+SE7vDdqRRkjj0rq7nvNjXriAdHja3vmiI0cvIvKYYxw==
    grQub1zT19NKv6nKq5X/ULLThNIdimM93hS77dj1JOW+IF8Yftbz7rG/c+2s2f8o5RZccnXC93eFL/aj89u+2JM6SdeOvquXeWX3325MKL08Rf8ssfTbu6J36Wnj4f27bjNMAw==
    Z02Gi/uN+0yucmU1Urr3VdkUn69WPJDRJGGNRDxsDl03tt3ofvbPf5Eek7mXZ2NfDc82rl+vdW351Y9Xcl6OLmJeLDzVlKen7ak+0ZK2aIgkL2rOdVe6KYJHX307j6cFs5PZEg==
    C7gREcn7qnQ3Ezm342PtcorRtvpt4taPx2GsSOIc4L+gwR8pQPShnX+idLp57F3uivFIbPibNpsJl9dVf1153/kPbUlp97dtVh0OztMGFWXWNTGx8t3D7OcfXFFSbv/FfdfPaQ==
    RE2xnJk+PfxCjF2mBgETIgvOJJjQJyQQPNNz2nyNKJPFEDFBloUYkUydPfIKCaW0AiJWa2UhkiqrU4hkgWE5QlggQqkhwkwkoD2M6xRr8LbfmJDWQEvJAYmBljLNWQp9zWLSLQ==
    gUjKkoxjRIeBQcjU/0JoDxcqsUuDeYlIFQcZRDQLDfQo11xH0KNc6yjFiBGxhT7gkeYh1sDyKIXR5laEHPqNxzrGPOAZtwoiQhjDYeSEUtnS8F4hRgqGpYVCRlA3EUmyFiJWsA==
    FMZUWPNGnoqYpQojKeMBjIJIZRxiezLODMxtkRuDmSgj4pWEiJUpzhIZc55Dv8lYmgxmvYx1nsFslIkOLEZyLgXUWjGtAxgfxWWeQd2UFBGDDFGKv1F3lBZpAu1RRrAE8lqFhg==
    KcgDFanc4DURbQTzR9kgimB8VM4V5o7KVZa8geg4gX7TVHk4rDuaBVZAvmnGbQzt0VSSUizNcK4gr7UxNoU80CFVHrxPKJIE+k2HMsMdUEeBySGrtOXW4DWJCHD114lUIcwSTQ==
    efrlheAVoqXFWudTXUaIYURfGDnDdMYhQ6ihU7whooSJYXyMDnILa4jRimF7DCUjrjvGUMt4C7EptoeiLbE9kRG4oxsbWA4ZYmKqb9gHmeC4b4fUgfCakKmUw9wOmclw3Qn51A==
    bCEiqD1DS+nARfUfI5RY0FJCsgD6OlR0FMJrlI5xBocUOA55HSYiCjCSGmlgfMKMOALraJhTdYFaU5ryFO4TcSVxrYqESGOoQSSFZTBykVQihjyIFPUmjJA1AYxcFPJIwSyJIg==
    xnGWEGIUrAfRpDbeJzKhwtJiGeITcZSqIIS8jlLqztg7GZUXLC3jimGtc85wFGwQxNEbCLMxrLA2kGEGo2Cpn0Wwo1PDSjCrrOQxPodYo3MBM9gS3/H52tJpEGeWjQzHjLf0Vg==
    gqNtc5aleE0upYL1IKZ3CQu1ng5p+EwRC069CSJ0uMVRiKUwuDvHijoDXqPpLRCyN6aiqGBM45BOKNAHccQSC+tBHGk6v0AkpoMq3ifhgmMfpJzqJUaEwn07TmWGeU1ki96IXA==
    pmPcMeI8yBm0J+EmYTAbE6FzBhmfSNoKRiGRLM2gpYk0PIC6JVYLfB5NYhNYGLkkZXEEfZDSS7WGGqTUtlPog5S0TqClKRVyDbORaGg15E6qp/MYRAy3+B2dkCzA9hhlcXdOLQ==
    xRRrYFUYwJimsXzjHJLmgsRhREt82sgYYwmMXMZ5bCCvMxkkOD6ZZCzE+0g61kCPZkrmuAdnWkl895RpE0R4TRRw3JmyiE7y0G+Z5VJjSy03FkujGDBY37KERTjrs0QmIcyfLA==
    DYTB9mQ8wbdsWaboBR4hOZMM3+/kPMgNjA815whzh9pfjm+YqP2EHEvT2uLbvDxkNoN+y0MZ5jA+eUjshbmdW5lqbGlML27Ynpje3mG081TTUQQiGQvf0GAyFeYPIRm+C8hzkw==
    hrO09Qka3r9rNtPnu+k7wulpurC/aE4rkqLZ+aq4uJ4+8K2nGTv/Ka7aBd+5Q+fdc2R73C3g5eUJGJqirnNf7BdgNrTZlNXQp+4wP9fXhb99knue4eFo6Q4/fpE1fehy/j++Ow==
    9if0wRf96SJ+mcKkPK+s2vFj1Szjw3G3XVa1hX98Bh3b8qd7P/vpyT0Pm/HONfMHjY/FfDE/z3Xt5a/bk7P3td9Ol+7uuuj709397pZdrerq9m5k03X7SL/Kwn+af+xu+RnjMw==
    xk/Y/KPYT5bR7PPD0xhfxp7NE8uYeBqTy5h8GlPLmHoa08uYnsbuHnvn66r9dLX68jiNH7q67h5c+cMT/tXQyQnz57U/+73tPLsuHrvj+GLuhE2T+5cSymIslg8YLxbPFH+lyw==
    9AFyXxEdt4/N7um74b9OitfVMG5dX/hi7PyC/XvGmJq/PY43xOJPFNhf3CEuBleeEmn5b4D3vwMAAP//AwBQSwMEFAAGAAgAAAAhAHxzapbgAAAAVQEAABgAKABjdXN0b21YbQ==
    bC9pdGVtUHJvcHMyLnhtbCCiJAAooCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACckMFqwzAMhu+DvUPQ3bWTLGEucQqdU+h1bLCr6ziJIbaD7ZSOsXefw07dcQ==
    J/FJSN+PmsPNzNlV+aCdZZDvCGTKStdrOzJ4fzuhZ8hCFLYXs7OKgXVwaB8fmj7sexFFiM6rc1QmSw2d6pkz+CpP3TEvuxrxqivRE+8qRGlNEK04eaE0L2hBvyFLapvOBAZTjA==
    yx7jICdlRNi5Rdk0HJw3Iib0I3bDoKXiTq5G2YgLQmos16Q3H2aGdsvzu/2qhnCPW7TV6/9aLvoyazd6sUyfgNsG/1FtfPeK9gcAAP//AwBQSwMEFAAGAAgAAAAhADVlGFikAA==
    AAD+AAAAEwAoAGN1c3RvbVhtbC9pdGVtMi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArM9NCoMwEIbhfaF3CDmAkS5ciApC3dZCoKtukjiaQA==
    fiQZQW/fIKUn6HL4Hl6YRtY8bFFBIhwsKISJ42Ghpe/+2XOzox4mgyb4cZ6NgtFb46HYk6XkhA/hMs6WkhfElGFLK0p2Z32qZUs14lozlpQGJ1IRVvB5m0N0AvMZFxbO8D2ozQ==
    gUd2K8uKSSOtCUsUqz6+sb+kuob9Hu6ulw8AAAD//wMAUEsDBBQABgAIAAAAIQBcliciwgAAACgBAAAeAAgBY3VzdG9tWG1sL19yZWxzL2l0ZW0yLnhtbC5yZWxzIKIEASigAA==
    AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAjM/BisIwEAbg+4LvEOZuUz2ILE29LII3kS54Dem0DdtkQmYUfXuDpxU8eA==
    nBn+72ea3S3M6oqZPUUDq6oGhdFR7+No4LfbL7egWGzs7UwRDdyRYdcuvpoTzlZKiCefWBUlsoFJJH1rzW7CYLmihLFcBsrBShnzqJN1f3ZEva7rjc7/DWhfTHXoDeRDvwLV3Q==
    E35i0zB4hz/kLgGjvKnQ7sJC4RzmY6bSqDqbRxQDXjA8V+uqmKDbRr/81z4AAAD//wMAUEsDBBQABgAIAAAAIQCCDkVhmRgAAOTBAAAYAAAAd29yZC9nbG9zc2FyeS9zdHlsZQ==
    cy54bWy8XVtzIkeWft+I/Q+EnnYfPJ33i2N6JvK6dozt6Zm2d55phFqsEWgBud376/dkgdSos4okodLhcLQEfF+dynO+c8mqQn/+6+8Py8lv8812sV69vcF/QjeT+Wq2vl2sPg==
    vr355ef4jbqZbHfT1e10uV7N3958nm9v/vqXf/+3P3/6drv7vJxvJ0Cw2n77MHt7c7/bPX775s12dj9/mG7/tH6cr+DNu/XmYbqDXzcf3zxMN78+PX4zWz88TneLD4vlYvf5DQ==
    QUjcHGg257Cs7+4Ws7lfz54e5qtdh3+zmS+Bcb3a3i8et89sn85h+7Te3D5u1rP5dgsn/bDc8z1MF6sXGswyoofFbLPeru92f4KTOVjUUQEco+6nh+UXAl5HQF4IHmbffv9xtQ==
    3kw/LGH1wZIJkN38BZb/dj3z87vp03K3Tb9u3m0Ovx5+6/6J69VuO/n07XQ7Wyx+hiMDycMC+L4zq+3iBt6ZT7c7s11Mj98Mh9fS+/fpg73I2XZ39LJd3C5u3qSDbv8P3vxtug==
    fHtDyPMrLhnx6rXldPXx+bX56ptf3h8bc/TSB+B9ezPdfPPeJOCbw7nt/z0648evf+sO/DidLbrjTO92cwguLFAiXS5SLBOun3/551Na3unTbn04SEew//eF9k226BBzEIHv9w==
    QoB353c/rGe/zm/f7+CNtzfdseDFX75/t1msNxDsb290d0x48f38YfHd4vZ2vjr64Op+cTv/1/189ct2fvvl9X/ELmAPL8zWTyv4mUrcBcJyext+n80fU/jDu6tp8slPCbBMnw==
    flp8OXgH/99nMnzwRB/+fj5NOWCCv6bozK+iIAmxPTrbfs6nr869+1TVgegfdSD2Rx2I/1EHEn/UgeQfdSD1Rx2oo2l5oMXqdv77Xoj5YTLWEs+AGqt5BsRWzTOgpWqeAalU8w==
    DCihmmcg0Kt5BuK4mmcgTCt4duvZUBQeBTsdiPbTvOUacRlvuSRcxluuAJfxlhP+Zbzl/H4ZbzmdX8Zbzt6X8ZaTdT3vvtWafA8yW+2uVtnder1brXfzyW7++/Vs0xVwdYPROA==
    fKnozTejnOQINPvMdijEV7PNpt3v5QjpRHp5Pd+lWW6yvpvcLT4+bWCevtbw+eq3+RIm28n09hb4RiTczHdPm4EVuSSmN/O7+Wa+ms3HDOzxSNMkOFk9PXwYITYfpx9H45qvbg==
    R16+Z8ZRksJLQMP8fJ9EshghqB+ms836etPW09Hyww+L7fVrlUgm9mm5nI/E9dM4IdZxXT8bdDTXjwYdzfWTQUdz/WBw5LOxlujANtJKHdhGWrAD20jrto/PsdbtwDbSuh3YRg==
    WrcD2/Xr9vNit+xS/HHXgc/fu3PLddrKvtqO94uPqyk0ANeXm8Oe6eTddDP9uJk+3k/SxnQ/7fE51x7Hrm8/T34eo6a9MI3V13ch4uCsF6un6xf0FdtY4nrhG0leL3wjCeyF7w==
    eon9CG1yatC+G2eeef/0Ydcr2o7pLNG+ny6f9g3t9Wqb7q6PsC8CiIvNdjQZ9NOOEME/pXY2uXOMzPfFyusN+8J1vay+zkqjmnegHMHK5Xr26zhp+LvPj/MNjGW/Xs0U18vl+g==
    0/x2PMb3u816H2vHkiedS86SfHh4vJ9uF92s9Iri/FL/fBF88uP08eoTerecLlbj+C188zBdLCfjdRDf/fzjD5Of149pzEwLMw6hXe9264fROA87gf/xr/mH/xzHQAND8OrzSA==
    Z2tG2h7qyNxihCKzZ1rfjsQEbeZitRilhnZ8f5t//rCebm7HYXu3me/vO9nNR2J8P3143DcdI2gL8uInyD8jdEMd339PN4u0LzSWqH4ehexo23D79OF/5rPrU91P68koO0N/fw==
    2nX7j12r26HHo7u+TXhFd32L0HkTykOK3xFO9hXd9Sf7im6sk3XL6Xa7GLyEejHfWKf7zDf2+V4//B341sv15u5pOd4CPhOOtoLPhKMt4Xr59LDajnnGHd+IJ9zxjX2+I4ZMxw==
    N8KWXMf3X5vF7WjO6MjG8kRHNpYbOrKxfNCRjeqA6+/QOSK7/jadI7Lr79XZk43UAhyRjRVno5b/ka7yHJGNFWcd2Vhx1pGNFWcd2VhxRv1kfncHTfB4JeaIcqyYO6Icr9Csdg==
    84fH9Wa6+TwSZVjOP05H2CDds73brO/SAwnr1f4m7hEo0x71csRme083lpP/Nf8wmmmJa0y7RtgRnS6X6/VIe2tfCk6HfH3vWgnWPclxtQnvltPZ/H69vJ1vBs5pGAvz8vv9Yw==
    GV+b35lx1rbnD4uP97vJ+/uX3f5jGoGKyOeB/RWsfMC+NRfPz7P0wX6c3y6eHp4NzR+mEPR8cBfRr8CsDP7SSbxC8jOR+TFFGfmlS36FlGci82OqM5GdTl8hT+nBTze/9gaCPA==
    FT8vM95A8MlTUfQC7j3sqUB6QfaFoDwVRa+kMjGzWbpakHvnPM0M488TzzC+RkXDLDVyGmY5W1fDFKcE9s/5b4tU2WuSZne8l7snsrzfNdFnZc5/PK33+/avLjid/1DX99A4rQ==
    tvNJLw89/8LVqywzvI5np5thirPzzjDF2QlomOKsTDQIr0pJwyxn56ZhirOT1DBFdbbKK0Jdtsrxddkqx1+SrXKWS7LVFV3AMMXZ7cAwRbVQc4pqoV7RKQxTVAk1g18k1JylWg==
    qDlFtVBzimqh5g1YnVBzfJ1Qc/wlQs1ZLhFqzlIt1JyiWqg5RbVQc4pqoeYU1UK9sLcfhF8k1JylWqg5RbVQc4pqoXb94hVCzfF1Qs3xlwg1Z7lEqDlLtVBzimqh5hTVQs0pqg==
    hZpTVAs1p6gSaga/SKg5S7VQc4pqoeYU1ULdP2p4uVBzfJ1Qc/wlQs1ZLhFqzlIt1JyiWqg5RbVQc4pqoeYU1ULNKaqEmsEvEmrOUi3UnKJaqDlFtVC7i4VXCDXH1wk1x18i1A==
    nOUSoeYs1ULNKaqFmlNUCzWnqBZqTlEt1JyiSqgZ/CKh5izVQs0pqoWaU5yKz8MlyqHb7HH9rufgHfvnX7o6GPXP40e5j6no+VTPVg1znf8sgl2vf530PnhIu3njPJLFh+Vi3Q==
    bVEPXFY/5u1uiai68Pl3d/oJn2P2K7906fAsRHfNNCNn5yKzPRV2KuSPkdmQx05F+jEy6zrZqex7jMzKIDuVdDtdPt+UAuUoA59KM0dgPAA/la2P4PkSn8rRR8B8hU9l5iNgvg==
    wKfy8RGQT1Jy/hrNz1wn8XJ/acZwKhyPGOQww6mwzH31nI5zYZzrtGGGc703zHCuG4cZqvw5SFPv2GGqag8PU13m6lxmta6+XKjDDLWuzhkucnVGc7mrc6qLXZ1TXebqPDHWug==
    OmeodfXlyXmY4SJXZzSXuzqnutjVOdVlrs5LWa2rc4ZaV+cMta6+siAP0lzu6pzqYlfnVJe5Om/ual2dM9S6OmeodXXOcJGrM5rLXZ1TXezqnOoyV2dTcrWrc4ZaV+cMta7OGQ==
    LnJ1RnO5q3Oqi12dU51ydbeL8srVVR4+gtc1YUfAuoJ8BKxLzkfAC6alI/SF09IRw4XTUu6rZ5/XTUvHThtmONd7wwznunGYocqfgzT1jh2mqvbwMNVlrq6blvpcfblQhxlqXQ==
    XTctDbq6blo66eq6aemkq+umpWFX101Lfa6um5b6XH15ch5muMjVddPSSVfXTUsnXV03LQ27um5a6nN13bTU5+q6aanP1VcW5EGay11dNy2ddHXdtDTs6rppqc/VddNSn6vrpg==
    pT5X101Lg66um5ZOurpuWjrp6rppadjVddNSn6vrpqU+V9dNS32urpuWBl1dNy2ddHXdtHTS1QPT0ptPr/4AU+Lu/iYZfHj3+XGevoP76IGZ2/13kB4uAnYf/P725Q8lJXCyZA==
    cviTVIeXO4MPFwz3R+yA+aFm93Cs2eHbkwYOdfgW1JfHeLrvQP36wANfldoZ8mUJnj99WNIvl0L3n3t12fOk3bu05Cds7lxyco32XhsyUB/CsGQh2PNhuf+jXfDD96tbIPh0+A==
    g1V7S29/n+6p4H03Xy5/nO4/vX4c/uhyfrfbv4tR99D8V+9/2H//2yB+0yWKQYI3r43Z/3r4w2ED673/RvjDFezBkExq6Fnu7naKa1f6zBh+seboWd/uUd+vzcqeBd6v7BSO9g==
    96Tv46h+Hfp1J7LZLlJQdB9BSAXkiT94aR83s5Q1nj+hUPrv4KTnvxg3cN6v0sTsaQsh0WWUr/0SpWWWKRmdwowhYQkLkgdhvAjYBpQtTRHQc2KIScq77H+9wQwrZokwUknCuA==
    Zlp7hJHEDhFDmbGZwUVAY4M94VZjrpG0kkXltIAVUzIoYZgVWOfZsgRobDBR1jProtOSMaqDCt4RhJk2PhrGYmZwEdDYYIusYcpogylEpEXKCGuJFMgyyiFCM4OLgNYrDMuCUQ==
    FJIazKSMimqLldWRWsQiEfkKlwCNDTbMI+OVZlxZFkE4gXCNKcfEW+tpHhJFQGODlZZSCO200pFR4YwiIKIYjfceO+0zg4uAxgYj47CiXlAPohdUWekhEDl3nMaI4/7Pox4bXA==
    BLTOw4RhRz0xGnsmBVMBa4YokQxxL7TJ83AJ0DqGI4+RcUQ1hjzqo+YenKwZlZC6qOmJ4RKgscGYOMKRMU5QAWmVGAtu1ow57ggsXF6ai4DGBlNFhDWOW0cg+dugDIJ8paPByA==
    RB3ytFYENDZYEIwhrUZNLWWcY61h5bCK1ijwu3WZwUVA814ikIisChB/kKWQNkYowhQXDgcU8hguAlpnCWQkQdEoqRxjkqtghRGcYjDCwjt5ligBWoeEElRK0JDViglpodE1kA==
    TimO2DJOZR4SJUBjg12E3osjZ6N1zEJPQ5Tg0IxLLAJEZ25wEdDaYNCOdxTaLqKYshyKGOHQJxgmuLaG5AaXAK0NTsvEXUBSckaU0kqwQLzTNFAYg3LRFQGt+2FFpYJKELUTsA==
    RtZapKliPihEopW5wUVAa4PBwxJaLqissGA2lTAvfIQWTAQOrs8NLgFah4TF3hNFYf7VzKfaRaFwCSkkCfBTyEOiBGhdmmG+gak9GksD8x6EHrFIjYI22guei64IaF04MBaI0Q==
    KBSUVmy8jRFFqTxMbjEZ1DPmFwCtSzNClrjICRYQkgESFY6GRkmJDhoLlZfmEqCxwdxIrSVy1ChoXjA1hnPoy2lQGFHeI7oioHUMMzgkNAWYQS9AnVSRQvtoNaQBTxFheQyXAA==
    jQ02EZZIC5jaNYEIFJZZBLMwggkNfCzyma4IaJ3WJBzFcQzVijJmsQKt48AjlyGG4PONlCKgscFIC2i2GDFYGihXUlMdiNCKeA1Dj86bnyKgscEwA1sHA4/l4FyBwY5gvFRQCQ==
    CHQKOC8cRUDrfphEqWEWYwYp5hxR0SNItZEjbyJU4Z4RqQBobDB2MKJ7aGGM1UwzZxBmTAhjohPO2HyFi4DGBsNBYbDBgiAvGI4BOkeHTWAipt6R5CtcBDQ2WGriLSbCI8wZ0w==
    2gTveNRYp41JJfLSXAS07iW8liRiwwUyTMG0HgRygoCOWOp38364CGhssEoXV2iwHCZ1Bk5WxBKPFTQ03KZ9v3z3sgRobXBwQQoHorGRYWSVgJaAmGAwSRNmPuYXAa1DIiDkIA==
    S8VIMBRZGIitDJ7GECkUMNUTEiVA6+bHRpk2yiIOmkH1Us4QSpVCVFjuSZ7WioDWK6yp8BrC0UpIqsxZG73QICDOpYFsm69wCdA6DzsswJECGlrNaHCGg3xiEr+HHtLnDXwR0A==
    PIahk6EwqSOKGYyVkAEQNAlRBg6J1uchUQS07iXgGCgSHkxEzFgCLRd4OAQN1QH6m57t1hKgteiY0ShIag31zElvYXqHAYilJKu87NnQLgFat5caQT+bkr4wTGpnYmQSxl/ItQ==
    FMb3PA8XAa17CaQso8xzyKVMUWO50pwL6j0KHByd9xIlQOv2EtKpjFwjCpOlgtVThmFDA9TctPGUF44ioLHB1pAQYFhAEIyM+KCJtsHCkAaZyzqfD6FFQOteghoFrS0cP1pYKQ==
    A+slnYC2yzqKEM3TWhHQ2GBOYDojUKU85wxmM0WxhU4m9eIM+rB8CC0CWlc6H3yElhY5KRkiVEWNiNOCaRQ1C3kDXwS0jmEC4aehUMG8wLq7YLhX2gvCKfRlOE9rRUDrSue1SA==
    G2QqDTw8wFgJJQB6RS4hNHHsmZpLgMYGQ94PFlJTwAiaL0SVCJR6bV2AhsH2TBxFQOuQEBYSP5QuDdVKa6csVsGDc2VwXIlcdEVAY4OhG9BUBlggJBg0jNoILIlDICgYKXru+Q==
    KQJat5fEi+BtuhEGw/GRTjlK6wgxKdOVjLy9LAFad2tUMuwxJRxjGCZ42vo1TEOxFVFTnZfmIqCxwZEzS633TkJacjIohDxPtyFxC9Owzle4CGgdw5SkWZ3C2CAYV0RhmDAlhw==
    uUKKSGzPteYSoLnBMtIQBXbp1r5ItY1YwTjJIzQ1qOdKaBHQ2GDoa51nxgQCwQiDpRXEe0q8iVwg4XpuFi0BWvcSNqb7NTQU1cCiFqB+yrG2HjpF+Cm/DawIaGwwYtDMYO0CtQ==
    GNTPjYCWnETJbADh87yXKAIaG0wohumGe82wZF5jjaMR6S4epbWyqOd23BKgdQxTG0iqVVFw5ihVQWsDbZiGsTJt7uQxXAI0NphHimCGNBICklGpNIZxIjU2MMhDScsNLgJatw==
    l8F4ig1hwUBvS8Ct0MpAGQvQKygvc9EVAa1XGEOPCKXWSDi+gMLFkOFMSg35ijuTNz9FQGODA/WRGUQwhjHCwbxjtPQCB4agkvGenZ8ioHU/jIxGjBPoaAjz0StLLPYBLIDEig==
    SN898AVAY4MNhRqgoLv1FPpxZ42FQZiQQDjxksg8DxcBrXsJD1OZlQJBwYJotMZD88UR99TBlOnzEakIaF04bITUr4PnNlVaCfMPNghZThxHMGjmhaMEaN0PY6Np2r6JnjACHQ==
    OMwN2lFoFDwJSuX7w0VAc9FxWJ+kIOSYl04hoagIgeOIBPQ5PaIrABobTIWTGrKRTltNgRPltCEEKSYNlU723EJTArQ2ODjjCeQlD+kVQckFqcNE4Y0zUWKbx3AR0GPwl+fuRg==
    aC8JdpSpqBxoiEdpwRIYM01wVhvP8ixRBDQ2mOughIN0ZCNjTkgrDQ7gYe4corTnrqoioLHBAaqrkgJbD2HICDfQ0gacdqkZhm4mb36KgMYGR041hkB0Lj1tBh1tVChICFPOfQ==
    oCS/97IIaG2wUFBbrdAiKqY1t4ikDV/ovSxHIuYTRxHQOoaxR1hyy4IWLN2nSl10oCuGGAtO5JcMioDWBiNpCU2Z1cKCRWKNscRDBfNGK8d6Jo4SoLHBVDtFEIxk0GgxrFJLEw==
    wbnWYJLa2569tRKgscGa69SRSyU1YRwyP9I0wrgTjFPY92SJIqCxwRB3UXrlEAge2vJ0Pw/EYgQp8Ri567lfogRonSVC5HA4A8KHXoZEqK/OEISFJTChxfx+iSKgdeFQLkDrLQ==
    ovOeIQzjDjVOC+tgcLNc5+1lEdB8hXEMzKT7KRXjzOp0+zVm6RZ8hWVPligCGhvsuYJx16NUYFkM0C1aazgJFkuXnrrv2b0sAJqLLnojYjCYO2gGlBKMBuuIMY6aIHueMigBGg==
    GyxIBBlpBcmJMDi2AfGHdFstDJfO9ZTmIqCxwZIT4UD3PAWk9kpRjmn0EJ/UqthzUaYIaF2aozNcgV4IiB6cbRj8og2UXB/TNnDPZmAB0Fp0jAKfpVikbpFSWCjGMIdmASHetw==
    GVgEtE5rUmMkqIYRPd0lDmuHgkGwYs4YOH5PWisBGhtMBBLQ1HpKYERTmiuviICgVIGK3oenioDm3Zpk0Cj6dEMt0zgqJTHy3ONgTVA2D4kioHVacwI0xENgVDADHUGEShupxA==
    Bub32HdnYAnQ2GDkCA1QryAgLWQpm54/RB5EJTyW2OUhUQQ0Nlh5BH4VKn3dCbNQYU164EFZ5qEWRN7zhRglQOsYllYbUIu0iDJjkILUimCtDIzzYEm+P1wENDbYkqi05QGmHQ==
    zKAxN0SkO+eCJ8pb1HNXVRHQujRTK7XFTChjmeBCM53uNkn/w8zW8w0eRUDrLIEjhabFmcA9s5RroXV6WpJFZ4ntuTheBLQOCeqI1TJEZKHowkQM0wSRjOgIwie0JyRKgNa9hA==
    Tlc2raQEK8a0TI/6Oo8QFTQ90Ndz6bYEaGwwBi4Hczskfs6gG1eeEQQjMaOYWy7y3csioHVaCwilq5jpxknmvNGIx3StxUGqUlr0lOYSoHkMSy+xtA6mnjTxwCyJabpLlQUF8w==
    cF8MFwCNDQ7YGYSMUUIyxrVUVFOYJBxL271C5DFcBDQ22EBn4EVI3yCSnklV0HHB8KMMNxQayZ5vtCsCWhscEIYk6q0I0BpokgoZAbFDOwZG4Fx0RcCZBj//tP3L/wsAAAD//w==
    AwBQSwMEFAAGAAgAm4KeR7HqIYk6AQAASAIAABEACAFkb2NQcm9wcy9jb3JlLnhtbCCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAKVSzU7DMAx+lSr3Nk3HqlGlnQSIE5OQmATiFhJ3C2uTKvHW7dk48Ei8Am3pikDcuNn+fmR/8sfbO18e6yo4gPPampywKCYBGGmVNpuc7LEMF2RZcGkd3A==
    O9uAQw0+6DTGZ0rmZIvYZJQ2e1dF1m2okhQqqMGgpyxilExcBFf7PwUDMjGPXk+stm2jdjbwkjhm9Gl19yC3UItQG4/CSBhVk8IPsI+6VU2HlNbVAv3g0Ai5ExvonVJaAwolUA==
    0P6ysJlOIwVXMkONFQR0qP3+5RUkjp10INC6vtvBqbVO+RFR4KXTDXY59pNKeFx1MZYa1NWpnzg46D7lgnE61XwM5ssYVNCdn+GpgZyckcfZ9c36lhRJzOYhS8JZvGbzLImz+Q==
    RZSmyeIyZc+c/vL5Nq7HJf7tfDYqOP35DsUnUEsDBBQABgAIAAAAIQCTH/Dbdg8AANCRAAAPAAAAd29yZC9zdHlsZXMueG1s7J1bc9s2FoDfd2b/A0dPuw+JdbMdZ+p2bMVeZw==
    mqRu7LTPEAlZrClCS1JxnF+/uJECdQiSB0TdndmdPMQidT4A5wYckCJ/+OnbJgm+0iyPWXo+mrwejwKahiyK04fz0Zf761dvRkFekDQiCUvp+eiZ5qOffvz73354epsXzwnNAw==
    Dkjzt5vwfLQuiu3bo6M8XNMNyV+zLU35yRXLNqTgH7OHow3JHnfbVyHbbEkRL+MkLp6PpuPxyUhjsj4UtlrFIX3Hwt2GpoWUP8powokszdfxNi9pT31oTyyLthkLaZ7zQW8SxQ==
    25A4rTCTOQBt4jBjOVsVr/lgdI8kiotPxvKvTbIHHOMA0wqwCd++f0hZRpYJ1z7vScBhox+5+iMWvqMrskuKXHzMbjP9UX+S/12ztMiDp7ckD+P4nrfMIZuY824u0jwe8TOU5A==
    xUUek8aTa/FH45kwL4zDl3EUj45Ei/l3fvIrSc5H02l5ZCF6UDuWkPShPEbTV1/uzJ4Yh5acez4i2au7CyF4pAem/jeGuz38JBvekjCW7ZBVQblnTU7GAprEwpGnx2flh887oQ==
    W7IrmG5EAtT/FfYIaJw7HHe/OxUF/CxdfWDhI43uCn7ifCTb4ge/vL/NYpZxTz8fnck2+cE7uolv4iiiqfHFdB1H9Pc1Tb/kNNof//Vaeqs+ELJdyv+enU6kFyR5dPUtpFvh+w==
    /GxKhE0+CYFEfHsX7xuX4v8uYRNtiSb5NSUiAQSTQ4TsPgoxFRK5Mdpm5u5g7PJbqIZmL9XQ/KUaOn6phk5eqqHTl2rozUs1JDF/ZkNxGtFvKhBhM4DaxbFEI5pjCTY0xxJLaA==
    jiVU0BxLJKA5FkdHcyx+jOZY3BTBKVho80LD2WcWb2/nds8RbtzuKcGN2z0DuHG7E74btzu/u3G707kbtzt7u3G7kzWeq5ZawXseZmkxOMpWjBUpK2hQ0G/DaSTlLFkV+eGJSQ==
    j2ZeBukBozKbnogH00IiP3d7iAxS9/m8EIVcwFbBKn7YZbyYHtpxmn6lCS9rAxJFnOcRmNFil1k04uLTGV3RjKYh9enY/qCiEgzS3WbpwTe35MEbi6aRZ/WVRC9JoXJoXj+vRQ==
    kMQenHpDwowN7xoj3vLDhzgfrisBCS53SUI9sT75cTHJGl4bSMzw0kBihlcGEjO8MDBs5ktFmuZJU5rmSWGa5klvyj996U3TPOlN0zzpTdOG6+0+LhKZ4s1Vx6T/3t0iYWIfew==
    cD/u4oeU8AXA8OlG75kGtyQjDxnZrgOxK92MNceMbeeSRc/BvY85rSL5WtdLF1nwUcfpbrhCazRfwVXxPIVXxfMUYBVveIh95MtksUC78VPP3O2WRWPQSlKvoL0jyU4taIdHGw==
    KYZ72D4AruMs9xYGzVgPHvxJLGeFOX1kvn0vh3dszxoeVodZyWv3NNJDLxMWPvpJwzfPW5rxsuxxMOmaJQl7opE/4l2RMeVrZshPpUl6hfzVZrsmeSxrpRqi/1RfXgEPPpLt4A==
    Ad0mJE792O3q1YbESeBvBXFz//FDcM+2oswUivEDvGRFwTbemHon8B+/0+U//XTwghfB6bOn0V542h6SsEXsYZJRJBZ5IvFlZpzGXuZQyfuZPi8ZySI/tNuMqptOCuqJeEc2Ww==
    tejwEFs8Lz7x/ONhNSR5v5EsFvtCvoLq3gvM2DbMd8s/aDg81X1igZedoV92hdx/lEtdKe0PN3yZUMMNXyJIa/LpQfivh8HWcMMHW8P5GuwiIXkeWy+hOvN8Dbfk+R7v8OJP8w==
    WMKy1S7xp8AS6E2DJdCbClmy26S5zxFLnscBS57v8Xp0GcnzsCUnef/K4sibMSTMlyUkzJcZJMyXDSTMqwGG36FjwIbfpmPAht+ro2CelgAGzJefeZ3+PV3lMWC+/EzCfPmZhA==
    +fIzCfPlZ7N3AV2t+CLY3xRjIH35nIH0N9GkBd1sWUayZ0/Iq4Q+EA8bpIp2m7GV+DUCS9VN3B6QYo868bjYVjhfRv6dLr11TbB89svDjihJEsY87a3tJxwpWb93rUtM/pJjcA==
    F24TEtI1SyKaWcZkl+X18p36WcZh92U3em17fogf1kVwt652+03MybhTsizYa2LdDTbp/KT8PUuT2EcaxbtN2VH4Y4qTWX9h6dE14Xm38H4lUZM87ikJ2zzpltyvkmuSpz0lYQ==
    m296Sso4rUm2xcM7kj02OsJpm/9UNZ7F+U7bvKgSbmy2zZEqySYXPG3zolqoBBdhKK4WQOv0ixm7fL/gsctjoshOwYSTndI7ruyItgD7TL/GYmbHJE3ZXnX3BMj7chHdK3P+ug==
    Y2rfvnbBqf+Put7zhVOa06CRM+t/4aqWZex67J1u7IjeeceO6J2A7IhemcgqjkpJdkrv3GRH9E5SdgQ6W8EZAZetoDwuW0F5l2wFKS7ZasAqwI7ovRywI9CBChHoQB2wUrAjUA==
    gQrEnQIVUtCBChHoQIUIdKDCBRguUKE8LlChvEugQopLoEIKOlAhAh2oEIEOVIhABypEoAPVcW1vFXcKVEhBBypEoAMVItCBKteLAwIVyuMCFcq7BCqkuAQqpKADFSLQgQoR6A==
    QIUIdKBCBDpQIQIVqEDcKVAhBR2oEIEOVIhAB6r6qaF7oEJ5XKBCeZdAhRSXQIUUdKBCBDpQIQIdqBCBDlSIQAcqRKACFYg7BSqkoAMVItCBChHoQJUXCwcEKpTHBSqUdwlUSA==
    cQlUSEEHKkSgAxUi0IEKEehAhQh0oEIEKlCBuFOgQgo6UCECHagQ0eaf+hKl7Tb7CX7X03rHfv9LV7pTn82fcpuoWX9U2Ss7q/9vES4Zewwaf3g4k/VGP0i8TGImt6gtl9VNrg==
    vCUCdeHzl0X7L3xM+sCHLunfQshrpgA+7ysJ9lTmbS5vSoIib97m6aYkWHXO27KvKQmmwXlb0pVxWd6UwqcjINyWZgzhiUW8LVsb4lDFbTnaEIQabsvMhiBUcFs+NgSPA5GcDw==
    pY976umkur8UENrc0SCc2gltbgltVaZjGBh9jWYn9LWendDXjHYCyp5WDN6wdhTawnaUm6lhmGFN7R6odgLW1JDgZGqAcTc1RDmbGqLcTA0TI9bUkIA1tXtythOcTA0w7qaGKA==
    Z1NDlJup4VSGNTUkYE0NCVhTD5yQrRh3U0OUs6khys3UcHGHNTUkYE0NCVhTQ4KTqQHG3dQQ5WxqiHIzNaiS0aaGBKypIQFrakhwMjXAuJsaopxNDVFtppa7KDVToyxsiOMWYQ==
    hiBuQjYEccnZEHSolgxpx2rJIDhWS9BWpc1x1ZJpNDuhr/XshL5mtBNQ9rRi8Ia1o9AWtqPcTI2rlppM7R6odgLW1LhqyWpqXLXUampctdRqaly1ZDc1rlpqMjWuWmoytXtytg==
    E5xMjauWWk2Nq5ZaTY2rluymxlVLTabGVUtNpsZVS02mHjghWzHupsZVS62mxlVLdlPjqqUmU+OqpSZT46qlJlPjqiWrqXHVUqupcdVSq6lx1ZLd1LhqqcnUuGqpydS4aqnJ1A==
    uGrJampctdRqaly11GpqS7V09FR7AZNgyxeS8S8Xz1sqnsFt/GAmUs8g1RcB5RffR9WLkoSw6EmgX0mlD8sO6wuG8u8s51Wd/s54fDWZTBb68prtlVPTsfnKqXn1wfrKKdm1jg==
    wVTd19dD1ZugzAHsX+Ake7ckOY1+EfoGw0vFw/8ajouH5JXHy2YWa5Kps3tzlN/RDmfX1sV8enmlLynatGXqaq84pSv6jYSFEmfqcUQfviYV3tRi9fazpfz2/o1kEx1X5hvJJg==
    Mt6NF4u5GGBqNYDOSn4MMO1hgPpF7w6bzBcn44tOm1h0Ln0L6LxD2/LYQG3PrNrWV8n9aHvmW9sNEfBI6fYT75I8Jj584DrOldoqQyzFk+O4UlT26DJLmRzrZml+ESD5o+VFgA==
    4uSVPibO194FWJPcvwtQHL6s3gUYikxemf56/u5UPrtCfllmeZ4BZY6XSVkeFjcecdDpdek71bB0oq29TVAe6/amkBuSJw/1cDvLTKAfUl39ylI+ovrQzyxPsrb4iE6++ztVmg==
    Xcbe70LMiC19ljNm6xSmJlWrE2sv7uoh788yUX7E/3ifCp9+0tla9TT6RhSKn1/QJPlI1LfZ1v7VhK5EKPKzk7Hyi/r5pXo8p1U+k+s4K+Co3hn1sd1P1As79A1G1hWDWKw0qA==
    W97tNlTTPXyhbn2xzww6o1ZS8pTSZD0fmm5j6W/5LImDBc98vCjvCe0zhXctd+p+dcmyiGZyIaf8RrYqnmWvB/6dp0D5B2+TVm/DVGlEkyuvcpKtPM5JuvRHJ+GYp9KI3gwT/w==
    zU1chUal/j6R0jw/X6sXOx26o37fU5Mr2qZgRWqdgO0zcKfT8lhSbkaW5ffELKTmhy3LRRX4Rk+wxnekgauvnM3UTd5CXZrXvHbqXtzX5qdwl3MnlEXNYe4xtHKoY3Uq2GvsQA==
    0Y3Tm0XtXSq36bfnAKvh6EdoHw5FH8aNAva2fNVwS/1meEatYlguxBJsyCq1IQr0y9MwUaBI/4+CehQYWjnUsTo1NAq0AV8oCoynKcmHKR2OCTxtaWhgWNYinbFRW82/GYt/eg==
    vB1h0rJ0UZezD4dsXDxXX2gaco9VTHkT8sHQFpOzM8RGxMutYi6vxT9xwCyRliR8fMjYLo1AmXSpyyT8ose5KZc1knNjDksq57acVmADW0Mu2Bxb87a++8TKZ7cdRqzxWLeuCQ==
    zlonD9to/RMmmWrL83C0+mQw8THTiFasqbopf5nbSC+20al+HHSoCHW0afzmHNpnz02S2lY6E53Lh20wT6bNO8U9tscs218Hmp/11HJfP9zrpVH3Qx3QMKBd5Z3u9+Laa/bR6g==
    PVyHqqpO+PDUEtbqrJ0prUGLtZ3Nnkurvm5U67RNPUOdqa5mu1b+Uk3ULqUcaqJM7FNPiV2XoD0Tu3k1xuvVFKRu1IUPm25mnnSjiwv3Se9/+pIGrKnE9rOsiU7KC+iv1AX0Yw==
    YMqOmzSaTNuj2iqv8NcNN5nNrsZeq62mcnR6fTw/kzcKQEvIW0UaV8WaZJZvMi4+s6dLkkZ38fdKZXps5Td4A/ZvDCkB5/PT6UKebBqIsoxDBdaJtdYI+zHfCm0r71uJtzdyLQ==
    Sc9q2TrTFKWYUB8JDf38aWPZNyI/6WDaD8UysIT4GZdh94jtylD9iwYlrcWJXaPqqyBPqCUPoMlvNFP7P1Ch+bpKI2FCiZq8jCsX/OMqTsS0c3Y1vZa3eUrdXcuDh7Evjt7HaQ==
    IR9pUOoT1dUbln3/r+rqfnYo/8p//A8AAAD//wMAUEsDBBQABgAIAAAAIQAk77ZEEwEAAP8BAAAUAAAAd29yZC93ZWJTZXR0aW5ncy54bWyU0V9LAzEMAPB3we9w9H3rbajIsQ==
    20BkIvgPdL73utxWbJrSdJ7z0xvPORFf5lvTND+SZjJ7Q1+8QmJHoVajYakKCJaWLqxqtXiaD85VwdmEpfEUoFZbYDWbHh9NuqqD5hFylpdciBK4Qlurdc6x0prtGtDwkCIESQ==
    tpTQZAnTSqNJL5s4sITRZNc47/JWj8vyTO2YdIhCbessXJLdIITc1+sEXkQKvHaRv7XuEK2jtIyJLDDLPOi/PDQu7JnRyR8InU3E1OahDLPrqKekfFT2J/Q/wOn/gPEeQFtdrw==
    AiXTeFmBdFIIpqayA4rZoXuHOaWLRB1D0p/X8hHb+/B8e9NHxnvqHu6uJNC/1jb9AAAA//8DAFBLAwQUAAYACAAAACEAGY/LP8QBAADtBAAAEgAAAHdvcmQvZm9udFRhYmxlLg==
    eG1svJLbitswEIbvC30HofuNZSfZg1ln2aYbKJRelO0DKIpsi+pgNErcvH1HsuO2hKUJhcog5H9mPo1+5vHph9HkID0oZyuazxgl0gq3U7ap6LfXzc09JRC43XHtrKzoUQJ9Wg==
    vX/32Je1swEI1lsojahoG0JXZhmIVhoOM9dJi8HaecMD/vomM9x/33c3wpmOB7VVWoVjVjB2S0eMv4Ti6loJ+dGJvZE2pPrMS41EZ6FVHZxo/SW03vld552QAPhmowee4cpOmA==
    fHEGMkp4B64OM3zM2FFCYXnO0snoX4DldYBiAhhRfmqs83yr0XzshCCMrkb3SV9abjCw5lptvUqBjlsHMsfYgeuKsoJt2BL3+C3YPO40i4mi5R5khAyJbJBrbpQ+nlToFcAQ6A==
    VBDtST9wr2JTQwhUg4E9bFlFXxiuYrOhg5JXdIHC83pSinhXWvmozCeFRUUkzpDxkKpE4kw5eGc2OHDmxKsyEsgX2ZOvznD7hiMFu0UnluhHdGZ+lSM+ca91pHj53ZE1Knf3iw==
    +ZkjD393ZOBc7sg4G+Szatrw5oTEufhfE/IcW0ZD/pyQgt19OPMjvf4fJ2Q8wOonAAAA//8DAFBLAwQUAAYACAAAACEAW239kwkBAADxAQAAHQAAAHdvcmQvZ2xvc3Nhcnkvdw==
    ZWJTZXR0aW5ncy54bWyU0cFKAzEQBuC74DssubfZFhVZui2IVLyIoD5Ams62wUwmzKSu9ekda61IL/WWSTIfM/yT2TvG6g1YAqXWjIa1qSB5Woa0as3L83xwbSopLi1dpASt2Q==
    gpjZ9Pxs0jc9LJ6gFP0plSpJGvStWZeSG2vFrwGdDClD0seOGF3RklcWHb9u8sATZlfCIsRQtnZc11dmz/ApCnVd8HBLfoOQyq7fMkQVKck6ZPnR+lO0nniZmTyI6D4Yvz10IQ==
    HZjRxRGEwTMJdWWoy+wn2lHaPqp3J4y/wOX/gPEBQN/crxKxW0SNQCepFDNTzYByCRg+YE58w9QLsP26djFS//hwp4X9E9T0EwAA//8DAFBLAwQUAAYACAAAACEAGY/LP8QBAA==
    AO0EAAAbAAAAd29yZC9nbG9zc2FyeS9mb250VGFibGUueG1svJLbitswEIbvC30HofuNZSfZg1ln2aYbKJRelO0DKIpsi+pgNErcvH1HsuO2hKUJhcog5H9mPo1+5vHph9HkIA==
    PShnK5rPGCXSCrdTtqnot9fNzT0lELjdce2srOhRAn1avX/32Je1swEI1lsojahoG0JXZhmIVhoOM9dJi8HaecMD/vomM9x/33c3wpmOB7VVWoVjVjB2S0eMv4Ti6loJ+dGJvQ==
    kTak+sxLjURnoVUdnGj9JbTe+V3nnZAA+GajB57hyk6YfHEGMkp4B64OM3zM2FFCYXnO0snoX4DldYBiAhhRfmqs83yr0XzshCCMrkb3SV9abjCw5lptvUqBjlsHMsfYgeuKsg==
    gm3YEvf4Ldg87jSLiaLlHmSEDIlskGtulD6eVOgVwBDoVBDtST9wr2JTQwhUg4E9bFlFXxiuYrOhg5JXdIHC83pSinhXWvmozCeFRUUkzpDxkKpE4kw5eGc2OHDmxKsyEsgX2Q==
    k6/OcPuGIwW7RSeW6Ed0Zn6VIz5xr3WkePndkTUqd/eL+ZkjD393ZOBc7sg4G+Szatrw5oTEufhfE/IcW0ZD/pyQgt19OPMjvf4fJ2Q8wOonAAAA//8DAFBLAwQUAAYACACbgg==
    nkcxG1X76QEAAGEEAAAQAAgBZG9jUHJvcHMvYXBwLnhtbCCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACdVA==
    wW7bMAz9FUP3xkm7DUWQuBjaww4bWiBZe2Zl2hZqS4LEBMl+bYd90n5hlOS4yoJdlhP5+PT0KDL+/fPX6u4w9MUenVdGr8ViNhcFamlqpdu12FFzdSsKT6Br6I3GtTiiF3fVCg==
    7PLJGYuOFPqCNbRf7mktOiK7LEsvOxzAz5ihudgYNwBx6trSNI2S+GDkbkBN5fV8/qmsjQxq/nl7tKw/6oH9Xz08EOoa6ys7eRTR8xYH2wNhtVEcqEZhXWyg5xZOArPa0GFV5g==
    3HjQEPRbNWA1T8Upj08BLfqxkuKAvhhX+2pxcxvxlAX8vgMHkvjNxyMZEOqfLVuTQDyR6puSznjTUPEY+yyCTDyUs8IpbmCDcucUHUfZHAmMr0pPLlOcvDtoHdiOrY4NTECobw==
    JL/PPb9j1UDvMVLescD4ghDW5QlUaGBPyz1KMq54BY9hoGuxB6dAE2+S+sHptUi0hMa4t55ctVXU8w1THsOclsfqQzCcgnNiOXmoot1zg2F64R7/2HCr9A/L0cDJ8EJkJi/8ZQ==
    N/0lHGZrBgv6mMpTkibw5r/brXkIO/b+tuf4+b68KOo2FiRebk5WilPjAta8AfnUJixOjdt0fbiMRXSLdca8rI17+Zw+FNXi42zOv9MinuC0P9N/rvoDUEsDBBQAAAAIAEtyUA==
    SMex5YwtCwAAaG0AABMAHABjdXN0b21YTUwvaXRlbTQueG1sIKIYACigFAAAAAAAAAAAAAAAAAAAAAAAAAAAAMVda28UNxT150r9D4jvLSVvVemiBApFApqSlJZPaJsEGjUv7Q==
    bij5822vr3fisX2f3kgVomTH555zfMfj8Svbf//ZDU/Cl3ARzsOD8DmchlmYh7NwFS7DD+FheBy+Dd/Bvw+g5DIcw/UTKL0Mn7D0JizCx/ANoLbg05MwCV+Hr8JueBOmwPUboA==
    Z4B/C7HX+PMi/I5KB1AePz1YKl+CZuKbwc/fw7Uz0JpBzBz+fgTkN8BzC2XTZdkcrlyiyiPAZf45fD6Ef6dQeoIqJ+EDXJmCyimUfghPER9rsYBPr+HnC4h9BHVYh5puw08Plw==
    9XgAf3bDT4CYAj5mJl9PZXugew3MZ8h9BDzP4O8x1OMC87WACB2zC5oWJq/2h/Aq/AEIi4cBa/OSmUtP+xBzDn8WgH8K+Dn8lKJm0CauAK8hor7O4lPNbq1IiwsuB0+h7ALyFw==
    W+At5PIE/swwk3NoYxOlPCprDHa9NUVvTdVbc+mtK3rrqt66S29D0dtQ9TZcepuK3qaqt+nS21L0tlS9LUVvH//9C6KOsXe/wec7PWVWZOtBYu1zk582b4THne2ZHuL3IctTfA==
    K/4pZqzG8Y5axh4fWq44vN2XL09v8K19yvoZynn9zODR0/JQ43R9W72Ht0W89gLeIjOibVCYVp9m8mpzeZCwNi+2fPwIo6wpvk1rB7mk1RtHSeyDF+oJHJe1CmWkVYPLJoWRNQ==
    bdn7CT+d4pj5E/EU1eWtZssg6b2EVr8H/mqd4XrLnyMsvFz+6nJex5a3V1DTTzju/xlmEB9x1tBmj0a12hyb3wFXfxltdeTNTZorLXAWNMwz7FjJFcUse7qCyCtopVc4A10sZw==
    oa0fGkd54RglHwfwjouoU7JHKUtbzTrarsS1CxqlKdvawQG2mgXOu0+h/JGCf4t39wzfAzO8uymjb3Bm9MdyjuyPaWtjU1rVK5dzT2yfd9v9OQy/Qa/3HObgtcNc0uqPo2zsXA==
    HlqEpGar0zvow4+EHLXPnB7RurKorOaSy5k9sse1P8daRvX8+bJlzY09E1q9rwFfKo6vDNwlqmbJY9v4dFKrNjIiqWgsHtU1VXXNoEqt30j4dVV13aBKreJI+A1VdcOgSq3lSA==
    +E1VddOgSq3oSPgtVXXLoEqt60j4bVV126C67VTdUVV3DKo7qmoa4S1w3Bnn7DN84k+W430rlnIiMZee6jXyoc85gs9fcPSrIaK+ziKrPluOuVu1oYRSyVE29tyPaghJjeuNaw==
    fHr/UFcpduptRWH4OtRvJjlaVjrCece5mLMWQ6lSTLX2DZSOW8D4c+IsEVL82C91veXjfOWVnA/FblrGa4iopbPUql9wvTKOJ+Kqx9ulyz0YseanyYJK6ha20sELcHUF3mLf8Q==
    Cu8mN4+xIqMTO2ufm5xPb4THHXfX6rUq7l7bcNGRlbH08RL8fobItKryDEfjea9gL1zc/ZwZ/DHRX4+Sx2t8a82xpfo9S7G6d1m5rENeN/oRcbGvi2+9W3j7xZ5KLo9eNAaPXg==
    dmnD6fp8vc9wzWacoz088RBbp5zfscvVWVId7sNNXcPUC5zj2GqGo7q4k3Rb+NcwyZ3OVGrnZ34or69E3hbVstzevYfjiZEFrrWdQA5OMQczyMV1yOuL3ojBhU9lNZdlTnoiew==
    XNtyfITt7QLibRnW8K1TXWEVf1xurXF+v3xeZ8vndY7P7zFgbu7OcKVVlokJlTxZ2PwOxvmyo62OVsnNeyxNcwof3upurFD6y6fWyp536KX5Hrg3chdPz/Wqcu4PQjpVWLZTuQ==
    vHRCM1j09uFa2sPXlFsk74FitbjJ5xjkcl6ZOwlxCNfq02rDGkZqWxoiaWosPtVxzm1Iiws+539in9ieUuRKkhoXJbPnWTRXQrFzc28Ox9eBmo/rLLKqZdThj6Gc+cc3fgY+dw==
    vjHOKsp0HeKZ2nKNs/XKY8aeJCar9mNR9bGi1+5r8Ng1UWlNUWr3Mnjsuqi0rii1+xc8dkNU2lCU2j0LHrspKm0qSu0+BY/dEpW2FKV2b4LHbotK24pSux/BY3dEpR1Fqd2DOA==
    xB7g77uY6+WoroybGHGDuoWx9nEDz3t8Q6ZdinFPQpckLS6qZD8iEO21yEghS6403qVXg/iyyC1FahqHuP5yDLlMZ6SmRC/dE0X7sqhRjoe1stpTfT2rthEU71Mcqd6Q3FRZ5g==
    pyM1jbmoMld0+LdXwr7EVdu0uhbzW67g6pisKjNR2mkUfryMqleMdEzWlpkobfkci+18jP9EjOc0iu/US/85l/f4pM0w9iPmMa0BxhE1XxY1pUirRnalY2RNbT24vJ7Kxv1M2g==
    j6LXOgYGHz795pdPYVWPOQt9cX7PdN5b79JaEpVfHV97tSis6pHOrz3O71nKLz9XGuqrIdKes8biVx7vdduQFidSLl6GdDJ66OsG7/T1tNdGR1i5x3t+UjmvJdWH2jkau5TLuQ==
    vSe5nnKEvDtG19vKyHupV0fLdz2VEWvE2J9dpdfpcKbB77iNtDunVPka1E8CfX2srj87v4Cvacj7t2M0XxY1pEiPTm5lOkbWldqrtFI4uNYx2pojX389yrby2ebDw9z6OgrpNw==
    HefFKZFxfzAxYNJ8WGei9PN5gSF77bXE3yJbvl+hJLaL+DtCr9HHPKTf9pgIZZFfivTo5GzrGFlXum9DVN5xmxDXxvxjpIWvrUdbRvNLvuXZ6HBfLSh9bsu3EkucdZ7dPpE+dg==
    zt1BOK7eDPT18Ty7jrByt/N6upzX8vS9vL9h9EqdP+VZfHj+hKvX53BWOs0Mcr/L83gj0p66V+V+3OY72hvZ455vR9w4gs+DHUuPK7wZtjNIYx5LVnuU2ueyHTvIM/E5rlleIA==
    363hKaZnizyPN0Kak3rdliNmPtqGa8fgXj/tHeYZ7Fi67Xi9SSMWnqsnShsfeZ2/C1NsKan+w2+2SDzeiPSG9KpQz6YNPW5p+t6QvIpiP5ctMd8Pj/ek+P9R1/EK033y3V/d5Q==
    FTn/Wfb+++7l6z1tf5/twKtgbQ+9vPefE/8K5zscwdH59UbwK5CSyupOtZVSPbLHuZTrOEaI7zd+5hjPQVhQ0ZmNjZsb2u+ED8+da/Ddax9DPa/tuc+9ihbvr2B08F7ptXqiaA==
    3xa1+3Et5d0e3VsL/R7ksyR6+7ZgqVMqPe3aEl3n1hPj82nPo70d2yNar6u0XzsHl9+edtuj6lut1NuvN05bwexp114m29qrp733O9DWUPU7oCPbddWeLOux3DqvJ5MelXqmag==
    fXKpk3ZS/fMcW4qzoNJ3YljY+lzk3HjQVlc9p1GkOvpjpDU5XzZplrUux3IU71lT00by5VnPegRflrYj9zraOhrm/frw/OjXkxG5/9W8euP0Ht/mnT6vy2HH3/ifz4XPxbyUOQ==
    1Rl8+Pokm0VB9vgcYy+w1497OCdu1z0MdT36XNh7Q52rN1LqGXtq8Bxj45rPFWBtefDHRNc9SrzfuJ6fzoac37217M57osd16FOvewZvRPyujNReZ4H+9pyE28d3/Pjbr+orUQ==
    vUVRY5H4vTRz9PNphKSvp/EFHdFyv8Ddl9OwaLBcSfqmHC6q3c/QsrVbZJ0+VzSUW87zTpz48vd/bAqSR+4cd669HVt605klX1xtKF8atvSlM2u+bLsjtUNbVOvVqia5foPtmg==
    c9eWli6oaEmt/D6N2vXP8N+27VtjSmd2Jclv+g29/HkilJX6baRH5zW2vzi+k++z5MfKIfu2O5HqRz2b9DNoe9baGcBELC01qGifWlo7kzUTRlMemHz6VD55lObBk/Ny9bDVLw==
    yynlmqF+09Jv0VjS/l/A0vzU9v85m4T/AFBLAQItABQABgAIAJuCnkfoHgdIxwEAALILAAATAAAAAAAAAAAAAAAAAAAAAABbQ29udGVudF9UeXBlc10ueG1sUEsBAi0AFAAGAA==
    CAAAACEAHpEat+8AAABOAgAACwAAAAAAAAAAAAAAAAAABAAAX3JlbHMvLnJlbHNQSwECLQAUAAYACACcbTdIEGjVcmkBAAD3BwAAHAAAAAAAAAAAAAAAAAAgBwAAd29yZC9fcg==
    ZWxzL2RvY3VtZW50LnhtbC5yZWxzUEsBAi0AFAAGAAgAnG03SJTNTQPZDwAAs90AABEAAAAAAAAAAAAAAAAAywkAAHdvcmQvZG9jdW1lbnQueG1sUEsBAi0AFAAGAAgAnG03SA==
    nNvxPxQHAAD8IQAAEAAAAAAAAAAAAAAAAADTGQAAd29yZC9oZWFkZXIyLnhtbFBLAQItABQABgAIAJxtN0gJNNi4HgQAAAwPAAAQAAAAAAAAAAAAAAAAABUhAAB3b3JkL2Zvbw==
    dGVyMS54bWxQSwECLQAUAAYACACcbTdIinBVujIFAADiGQAAEAAAAAAAAAAAAAAAAABhJQAAd29yZC9oZWFkZXIxLnhtbFBLAQItABQABgAIAJxtN0hH9hJDYggAABRJAAAQAA==
    AAAAAAAAAAAAAAAAwSoAAHdvcmQvZm9vdGVyMi54bWxQSwECLQAUAAYACACcbTdIdo+b980BAABSBgAAEQAAAAAAAAAAAAAAAABRMwAAd29yZC9lbmRub3Rlcy54bWxQSwECLQ==
    ABQABgAIAAAAIQDHzvKouQAAACEBAAAbAAAAAAAAAAAAAAAAAE01AAB3b3JkL19yZWxzL2hlYWRlcjIueG1sLnJlbHNQSwECLQAUAAYACACcbTdICzEIE84BAABYBgAAEgAAAA==
    AAAAAAAAAAAAAD82AAB3b3JkL2Zvb3Rub3Rlcy54bWxQSwECLQAUAAYACAAAACEAqlIl3yMGAACLGgAAFQAAAAAAAAAAAAAAAAA9OAAAd29yZC90aGVtZS90aGVtZTEueG1sUA==
    SwECLQAKAAAAAAAAACEAMlJ+tQoAAAAKAAAAFQAAAAAAAAAAAAAAAACTPgAAd29yZC9tZWRpYS9pbWFnZTEuYmluUEsBAi0AFAAGAAgAAAAhAHf7x0uhDAAAoHYAABoAAAAAAA==
    AAAAAAAAAADQPgAAd29yZC9nbG9zc2FyeS9kb2N1bWVudC54bWxQSwECLQAUAAYACAAAACEA0nc7M/UAAAB1AQAAHAAAAAAAAAAAAAAAAACpSwAAd29yZC9fcmVscy9zZXR0aQ==
    bmdzLnhtbC5yZWxzUEsBAi0AFAAGAAgAAAAhAP3euxMvAwAA4ggAABoAAAAAAAAAAAAAAAAA2EwAAHdvcmQvZ2xvc3Nhcnkvc2V0dGluZ3MueG1sUEsBAi0AFAAGAAgAAAAhAA==
    g9C15eYAAACtAgAAJQAAAAAAAAAAAAAAAAA/UAAAd29yZC9nbG9zc2FyeS9fcmVscy9kb2N1bWVudC54bWwucmVsc1BLAQItABQABgAIAAAAIQDB2l0ofwgAAFMgAAARAAAAAA==
    AAAAAAAAAAAAaFEAAHdvcmQvc2V0dGluZ3MueG1sUEsBAi0AFAAGAAgAAAAhAHxzapbgAAAAVQEAABgAAAAAAAAAAAAAAAAAFloAAGN1c3RvbVhtbC9pdGVtUHJvcHMyLnhtbA==
    UEsBAi0AFAAGAAgAAAAhADVlGFikAAAA/gAAABMAAAAAAAAAAAAAAAAAVFsAAGN1c3RvbVhtbC9pdGVtMi54bWxQSwECLQAUAAYACAAAACEAXJYnIsIAAAAoAQAAHgAAAAAAAA==
    AAAAAAAAAFFcAABjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbHNQSwECLQAUAAYACAAAACEAgg5FYZkYAADkwQAAGAAAAAAAAAAAAAAAAABXXgAAd29yZC9nbG9zc2FyeQ==
    L3N0eWxlcy54bWxQSwECLQAUAAYACACbgp5HseohiToBAABIAgAAEQAAAAAAAAAAAAAAAAAmdwAAZG9jUHJvcHMvY29yZS54bWxQSwECLQAUAAYACAAAACEAkx/w23YPAADQkQ==
    AAAPAAAAAAAAAAAAAAAAAJd5AAB3b3JkL3N0eWxlcy54bWxQSwECLQAUAAYACAAAACEAJO+2RBMBAAD/AQAAFAAAAAAAAAAAAAAAAAA6iQAAd29yZC93ZWJTZXR0aW5ncy54bQ==
    bFBLAQItABQABgAIAAAAIQAZj8s/xAEAAO0EAAASAAAAAAAAAAAAAAAAAH+KAAB3b3JkL2ZvbnRUYWJsZS54bWxQSwECLQAUAAYACAAAACEAW239kwkBAADxAQAAHQAAAAAAAA==
    AAAAAAAAAHOMAAB3b3JkL2dsb3NzYXJ5L3dlYlNldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQAZj8s/xAEAAO0EAAAbAAAAAAAAAAAAAAAAALeNAAB3b3JkL2dsb3NzYXJ5Lw==
    Zm9udFRhYmxlLnhtbFBLAQItABQABgAIAJuCnkcxG1X76QEAAGEEAAAQAAAAAAAAAAAAAAAAALSPAABkb2NQcm9wcy9hcHAueG1sUEsBAi0AFAAAAAgAS3JQSMex5YwtCwAAaA==
    bQAAEwAAAAAAAAAAAAAAAADTkgAAY3VzdG9tWE1ML2l0ZW00LnhtbFBLBQYAAAAAHgAeAN8HAABNngAAAAA=
    END_OF_WORDLAYOUT
  }
}

