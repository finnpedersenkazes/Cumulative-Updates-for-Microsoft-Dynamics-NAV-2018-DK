OBJECT Report 1305 Standard Sales - Order Conf.
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salg - bekr‘ftelse;
               ENU=Sales - Confirmation];
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
               DataItemTable=Table36;
               DataItemTableView=SORTING(Document Type,No.)
                                 WHERE(Document Type=CONST(Order));
               ReqFilterHeadingML=[DAN=Salgsordre;
                                   ENU=Sales Order];
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

                                  IF NOT CurrReport.PREVIEW THEN
                                    CODEUNIT.RUN(CODEUNIT::"Sales-Printed",Header);

                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  CALCFIELDS("Work Description");
                                  ShowWorkDescription := "Work Description".HASVALUE;

                                  FormatAddr.GetCompanyAddr("Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
                                  FormatAddr.SalesHeaderBillTo(CustAddr,Header);
                                  ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr,CustAddr,Header);

                                  IF NOT Cust.GET("Bill-to Customer No.") THEN
                                    CLEAR(Cust);

                                  IF "Currency Code" <> '' THEN BEGIN
                                    CurrencyExchangeRate.FindCurrency("Posting Date","Currency Code",1);
                                    CalculatedExchRate :=
                                      ROUND(1 / "Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount",0.000001);
                                    ExchangeRateText := STRSUBSTNO(ExchangeRateTxt,CalculatedExchRate,CurrencyExchangeRate."Exchange Rate Amount");
                                  END;

                                  FormatDocumentFields(Header);

                                  IF NOT CurrReport.PREVIEW AND
                                     (CurrReport.USEREQUESTPAGE AND ArchiveDocument OR
                                      NOT CurrReport.USEREQUESTPAGE AND SalesSetup."Archive Quotes and Orders")
                                  THEN
                                    ArchiveManagement.StoreSalesDocument(Header,LogInteraction);

                                  IF LogInteraction AND NOT CurrReport.PREVIEW THEN BEGIN
                                    CALCFIELDS("No. of Archived Versions");
                                    IF "Bill-to Contact No." <> '' THEN
                                      SegManagement.LogDocument(
                                        3,"No.","Doc. No. Occurrence",
                                        "No. of Archived Versions",DATABASE::Contact,"Bill-to Contact No."
                                        ,"Salesperson Code","Campaign No.","Posting Description","Opportunity No.")
                                    ELSE
                                      SegManagement.LogDocument(
                                        3,"No.","Doc. No. Occurrence",
                                        "No. of Archived Versions",DATABASE::Customer,"Bill-to Customer No.",
                                        "Salesperson Code","Campaign No.","Posting Description","Opportunity No.");
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
               SourceExpr="External Document No." }

    { 112 ;1   ;Column  ;YourReference_Lbl   ;
               SourceExpr=FIELDCAPTION("External Document No.") }

    { 40  ;1   ;Column  ;ShipmentMethodDescription;
               SourceExpr=ShipmentMethod.Description }

    { 105 ;1   ;Column  ;ShipmentMethodDescription_Lbl;
               SourceExpr=ShptMethodDescLbl }

    { 103 ;1   ;Column  ;Shipment_Lbl        ;
               SourceExpr=ShipmentLbl }

    { 131 ;1   ;Column  ;ShipmentDate        ;
               SourceExpr=FORMAT("Shipment Date",0,4) }

    { 132 ;1   ;Column  ;ShipmentDate_Lbl    ;
               SourceExpr=FIELDCAPTION("Shipment Date") }

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

    { 32  ;1   ;Column  ;QuoteNo             ;
               SourceExpr="Quote No." }

    { 46  ;1   ;Column  ;QuoteNo_Lbl         ;
               SourceExpr=FIELDCAPTION("Quote No.") }

    { 84  ;1   ;Column  ;PricesIncludingVAT  ;
               SourceExpr="Prices Including VAT" }

    { 120 ;1   ;Column  ;PricesIncludingVAT_Lbl;
               SourceExpr=FIELDCAPTION("Prices Including VAT") }

    { 25  ;1   ;Column  ;PricesIncludingVATYesNo;
               SourceExpr=FORMAT("Prices Including VAT") }

    { 37  ;1   ;Column  ;SalesPerson_Lbl     ;
               SourceExpr=SalespersonLbl }

    { 34  ;1   ;Column  ;SalesPersonText_Lbl ;
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

    { 102 ;1   ;Column  ;Invoice_Lbl         ;
               SourceExpr=SalesConfirmationLbl }

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

    { 177 ;1   ;Column  ;ExtDocNo_SalesHeader;
               SourceExpr="External Document No." }

    { 180 ;1   ;Column  ;ShowWorkDescription ;
               SourceExpr=ShowWorkDescription }

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
                               CompanyInfo.CALCFIELDS(Picture);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Type = Type::"G/L Account" THEN
                                    "No." := '';

                                  IF "Line Discount %" = 0 THEN
                                    LineDiscountPctText := ''
                                  ELSE
                                    LineDiscountPctText := STRSUBSTNO('%1%',-ROUND("Line Discount %",0.1));

                                  IF DisplayAssemblyInformation THEN
                                    AsmInfoExistsForLine := AsmToOrderExists(AsmHeader);

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
               AutoFormatExpr="Currency Code" }

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

    { 146 ;2   ;Column  ;CrossReferenceNo    ;
               SourceExpr="Cross-Reference No." }

    { 144 ;2   ;Column  ;CrossReferenceNo_Lbl;
               SourceExpr=FIELDCAPTION("Cross-Reference No.") }

    { 9462;2   ;DataItem;AssemblyLine        ;
               DataItemTable=Table901;
               DataItemTableView=SORTING(Document No.,Line No.);
               OnPreDataItem=BEGIN
                               IF NOT DisplayAssemblyInformation THEN
                                 CurrReport.BREAK;
                               IF NOT AsmInfoExistsForLine THEN
                                 CurrReport.BREAK;
                               SETRANGE("Document Type",AsmHeader."Document Type");
                               SETRANGE("Document No.",AsmHeader."No.");
                             END;
                              }

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

    { 194 ;1   ;DataItem;WorkDescriptionLines;
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

    { 195 ;2   ;Column  ;WorkDescriptionLineNumber;
               SourceExpr=Number }

    { 196 ;2   ;Column  ;WorkDescriptionLine ;
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

                               VATClauseLine.DELETEALL;
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

      { 3   ;2   ;Field     ;
                  Name=DisplayAsmInformation;
                  CaptionML=[DAN=Vis montagekomponenter;
                             ENU=Show Assembly Components];
                  ToolTipML=[DAN=Angiver, om rapporten skal omfatte oplysninger om komponenter, der blev brugt i sammenk‘dede montageordrer, hvori den eller de solgte varer indgik.;
                             ENU=Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.];
                  ApplicationArea=#Assembly;
                  SourceExpr=DisplayAssemblyInformation }

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
      SalesConfirmationLbl@1004 : TextConst 'DAN=Ordrebekr‘ftelse;ENU=Order Confirmation';
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
      InvNoLbl@1073 : TextConst 'DAN=Ordrenr.;ENU=Order No.';
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
      AsmHeader@1051 : Record 900;
      TempBlobWorkDescription@1099 : Record 99008535;
      FormatAddr@1019 : Codeunit 365;
      FormatDocument@1066 : Codeunit 368;
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
      DisplayAssemblyInformation@1067 : Boolean;
      AsmInfoExistsForLine@1043 : Boolean;
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
      NoFilterSetErr@1054 : TextConst 'DAN=Du skal angive et eller flere filtre for at undg† at udskrive alle dokumenter ved et uheld.;ENU=You must specify one or more filters to avoid accidently printing all documents.';
      GreetingLbl@1058 : TextConst 'DAN=Hej;ENU=Hello';
      ClosingLbl@1057 : TextConst 'DAN=Med venlig hilsen;ENU=Sincerely';
      PmtDiscTxt@1056 : TextConst '@@@="%1 Discount Due Date %2 = value of Payment Discount % ";DAN=Hvis vi modtager betalingen f›r %1, er du berettiget til en betalingsrabat p† 2 %.;ENU=If we receive the payment before %1, you are eligible for a 2% payment discount.';
      BodyLbl@1055 : TextConst 'DAN=Tak for din interesse i vores varer. Din ordrebekr‘ftelse er vedh‘ftet denne meddelelse.;ENU=Thank you for your business. Your order confirmation is attached to this message.';
      PmtDiscText@1060 : Text;
      ShowWorkDescription@1100 : Boolean;
      WorkDescriptionLine@1101 : Text;

    LOCAL PROCEDURE InitLogInteraction@1();
    BEGIN
      LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';
    END;

    LOCAL PROCEDURE DocumentCaption@4() : Text[250];
    BEGIN
      EXIT(SalesConfirmationLbl);
    END;

    PROCEDURE InitializeRequest@5(NewLogInteraction@1002 : Boolean;DisplayAsmInfo@1003 : Boolean);
    BEGIN
      LogInteraction := NewLogInteraction;
      DisplayAssemblyInformation := DisplayAsmInfo;
    END;

    LOCAL PROCEDURE FormatDocumentFields@2(SalesHeader@1000 : Record 36);
    BEGIN
      WITH SalesHeader DO BEGIN
        FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser,"Salesperson Code",SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod,"Payment Method Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");
      END;
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
        <Field Name="ShipmentDate">
          <DataField>ShipmentDate</DataField>
        </Field>
        <Field Name="ShipmentDate_Lbl">
          <DataField>ShipmentDate_Lbl</DataField>
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
        <Field Name="QuoteNo">
          <DataField>QuoteNo</DataField>
        </Field>
        <Field Name="QuoteNo_Lbl">
          <DataField>QuoteNo_Lbl</DataField>
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
        <Field Name="SalesPersonText_Lbl">
          <DataField>SalesPersonText_Lbl</DataField>
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
        <Field Name="Invoice_Lbl">
          <DataField>Invoice_Lbl</DataField>
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
        <Field Name="ShowWorkDescription">
          <DataField>ShowWorkDescription</DataField>
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
        <Field Name="WorkDescriptionLineNumber">
          <DataField>WorkDescriptionLineNumber</DataField>
        </Field>
        <Field Name="WorkDescriptionLine">
          <DataField>WorkDescriptionLine</DataField>
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
                  <Width>18.5cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>22.7897cm</Height>
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
                                          <Textbox Name="Invoice_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Invoice_Lbl.Value</Value>
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
                                            <rd:DefaultName>Invoice_Lbl</rd:DefaultName>
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
                                          <Textbox Name="SalesPersonText_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SalesPersonText_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>SalesPersonText_Lbl</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
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
                                          <Textbox Name="QuoteNo_Lbl">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!QuoteNo_Lbl.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>QuoteNo_Lbl</rd:DefaultName>
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
                                          <Textbox Name="QuoteNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!QuoteNo.Value</Value>
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
                                            <rd:DefaultName>QuoteNo</rd:DefaultName>
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
                                          <Textbox Name="Textbox27">
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
                                            <rd:DefaultName>Textbox27</rd:DefaultName>
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
                                          <Textbox Name="Textbox28">
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
                                            <rd:DefaultName>Textbox28</rd:DefaultName>
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
                                          <Textbox Name="Textbox29">
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
                                            <rd:DefaultName>Textbox29</rd:DefaultName>
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
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!CompanyLegalStatement.Value = ""</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>0.07056cm</Top>
                              <Height>8.85932cm</Height>
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
                                    <Width>5.7cm</Width>
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
                                    <Width>1.3cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.8cm</Width>
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
                                          <rd:Selected>true</rd:Selected>
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
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox30</rd:DefaultName>
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
                              <Top>9.50577cm</Top>
                              <Height>1.89674cm</Height>
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
                              <Top>16.53165cm</Top>
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
                              <Top>14.6292cm</Top>
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
                              <Top>18.19678cm</Top>
                              <Left>0.02485cm</Left>
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
                              <Top>11.52745cm</Top>
                              <Left>11.5cm</Left>
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
                              <Top>22.25375cm</Top>
                              <Left>0.02485cm</Left>
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
                              <Top>9.0041cm</Top>
                              <Left>0.09699cm</Left>
                              <Height>0.4cm</Height>
                              <Width>18.30602cm</Width>
                              <ZIndex>7</ZIndex>
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
            <Height>22.7897cm</Height>
            <Width>18.5cm</Width>
            <Style>
              <Border>
                <Style>None</Style>
              </Border>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>23.01019cm</Height>
        <Style />
      </Body>
      <Width>18.5cm</Width>
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
    UEsDBBQABgAIAAAAIQC/8xrH8wEAAKwNAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzJdPTxsxEMXvlfgOK1+rrAOVUFVlw6HQI0UqSL069g==
    bGLhf7InhHz72utkW9HAbtku4RIp8bz3fh5n48ns4lGr4gF8kNZU5LSckgIMt0KaZUXubr9NPpMiIDOCKWugIlsI5GJ+8mF2u3UQiqg2oSIrRPeF0sBXoFkorQMTV2rrNcP41g==
    L6lj/J4tgZ5Np+eUW4NgcILJg8xnl1CztcLi6jF+nEkW0pDia65LURWROunX5t7YjSH0oMqDCk9kzDklOcO4Th+MeMI22XGVUdnUhJV04WMseCYhrTwfsNN9jw31UkBxwzxeMw==
    HavoxnpBheVrHZXlyzYHOG1dSw6tPrk5bzmEEE9Kq7Jd0UyaPf8hDr4OaPVPrahE0DfeunA6GKc1TX7gUULbw54MZ2/N0JxHwK2C8P9PI/t2xwNiFIwBsHPuRNjA4sdoFH+Ydw==
    gtTWorE4xmm01p0QYMRIDHvnToQVMAF++CP5F0E27pk//HF8bX46rFH2n4175o+w/575uU2fjtz/EfJ79z/msYWCMQh21p0QS2VDYH77Fhf2Pqs/1JFvrd8cx7++WpZ3c4+1RA==
    7+KLjHEgh/w6/Ce1sXkpMlY2w1wc8P0rtr2fxZN64npNcW1itB68P0hjvgDxr9l58hwcn20OhNPmv9b8FwAAAP//AwBQSwMEFAAGAAgAAAAhAJlVfgX+AAAA4QIAAAsACAJfcg==
    ZWxzLy5yZWxzIKIEAiigAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACskk1LAzEQhu+C/yHMvTvbKiLS3V5E6E1k/QFDMvuBmw+Sqbb/3iiKLtS1hx4zeefJM0PWm70d1SvHNHhXwbIoQbHT3gyuqw==
    4Ll5WNyCSkLO0OgdV3DgBJv68mL9xCNJbkr9EJLKFJcq6EXCHWLSPVtKhQ/s8k3royXJx9hhIP1CHeOqLG8w/mZAPWGqrakgbs0VqOYQ+BS2b9tB873XO8tOjjyBvBd2hs0ixA==
    3B9lyNOohmLHUoHx+jGXE1IIRUYDHjdanW7097RoWciQEGofed7nIzEntDzniqaJH5s3Hw2ar/KczfU5bfQuibf/rOcz862Ek49ZvwMAAP//AwBQSwMEFAAGAAgAAAAhAN7uHg==
    XXIBAADwCAAAHAAIAXdvcmQvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHMgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAC8VctOwzAQvCPxD5HvxGkL5aGmvSCkXqFIXN148xCJHdlbIH+PaUlqSrXi4HLccTwzmd1sZouPpo7ewNhKq5SN4oRFoDItK1Wk7Hn1cHHDIotCSVFrBSnrwLLF/Pxs9g==
    CLVAd8mWVWsjx6JsykrE9o5zm5XQCBvrFpQ7ybVpBLrSFLwV2asogI+TZMqNz8HmPzijpUyZWUqnv+pa+Au3zvMqg3udbRpQeESClyAkGMcoTAHoOLf1KHZEjB/XH01CGsi1Rg==
    38CunlAGgupb7GrXwUF/V1Py1yHlQUnlXtgz0CNkC8annwGyBUH1s41F3bw4tcFCHO9RXiE0YzKOaUg76O7C3sq23IH0Z/HfkZBugiby9U0eTOkAkZEEzeT4piAH4yqk/jusnw==
    ANH9B7wcPJBMIqiTotbWCtP1z+zt9Cdcfh+RppLTt4cc0sugi/xXb3qEsnB7+kVKr66gGeRa4Uqsa299DVDvgvs27PwTAAD//wMAUEsDBBQABgAIAGZgyEq2G0HNDxEAAN7cAA==
    ABEAAAB3b3JkL2RvY3VtZW50LnhtbO1d2XLjyJX9FQXnwU9q5r4orHJg7a5wdbdcqmnbMTFRAZGQxCkSYACgVGqHv8wP/iT/wiQ2kgBBFkiBLEDEg0QsmReZN++5S+ZN4D//+g==
    9x//9HU2vXhyg3Die9cD+AMYXLjeyB9PvIfrwSK6vxSDizByvLEz9T33evDihoM/vfvj89XYHy1mrhddKAJeePU8H10PHqNofjUchqNHd+aEP8wmo8AP/fvoh5E/G/r395OROw==
    fPaD8RABCJKjeeCP3DBUTzMc78kJBxm50dd61MaB86wqxwTJcPToBJH7dUUD7k2EDuVQbBJCBxBSPURwkxTemxQbxq3aIEQOIqRatUGJHkaponPsMEpokxI/jBLepCQOo7QhTg==
    s00B9+eup27e+8HMidRp8DCcOcGXxfxSEZ470eRuMp1EL4omYDkZZ+J9OaBFqtaSwgyP96bAhzN/7E7xOKfiK3gH3lVW/3JZP276VVo/+8lrBHX6n1YxM+WQ9HwYuFPFC98LHw==
    J/MlwmeHUlM3H3MiT7s68TSbDpbaCdaEyzb1ZKasXBGs0/yM/7Np2vLdFCGoMSIxiWWNOk0oPjNvyUxJ4erBB7FmjbmwpgLJCaANAix09yNBMxLD8GW2gujz/OF1o/xj4C/mKw==
    apPXUXu/wuyzt18HM2lZl+DwdY25fXTmCsqz0dX7B88PnLupapEa+ws1fBfJCFzEKBnEtv3OH7/Ev9HdNPu5CbKD2+hlqkpePTnT68GnmMqPwUSJ5DC7/1d1TwkmBUB5EurKyw==
    XD1mPopWJXTVLOVvJGf+PCflKe8irjDyp75SNM4i8uPT8PfrQUIonDsjNzlO6Ezd++jAqnd+FPmzAysHk4fHQx888cLJ2P3pVbV/O6j2cIPxd1PDnU5/doI1Zj5nVdMxG391Sg==
    fa6+PyxTU2cffP9L3lBAtKTW/SQIo4++IgLj06mTna1uGv50MfPW7ucXkiKe/5Ou3NDl2W/pGVxrxFJIY5GMDx/UryKSiaSQPOtR4TrBQK4RyetGgbqt3OLxR/VIwDjjQg6ySw==
    n4L4GrIRE2KQFk6fPXK86HaubH4m7cFP7rrAILkaj6xGOI6yn/Q8u3yXyaoRZuWz68504oQ5uf/6xXm6uhj+5DpqXIfGIlRy7QbaeBwoyMMccc5Dsfxt4s0H48+3ztQNP/8aCw==
    xWfD9+6V9wRoLm3jvNIlJoxhjlDOvPlUSdajP1XVsjjgRvlJeXGLU5vbAkouKbGIriOKCTAxNjQLQ6Tn/S9TcSJHn3hx2KEozQP3fvL1Z2c+V+dK76Uq0AvB9R9iC7myjOMXzw==
    UWfhpec8KTdj7gdRONzdweEf4lH8qryzx+vBUNG8Ulz5q4LGx6T632bTuDv/A/83uZfyNj8rs1hdT7AW+YH7PnJn783rwT90U6MQaeCSm8C8JJo60oWglwQzZHPdZjYg/8wHxw==
    /RplDFlKgDqwvHFJGnIwDVZyUbiUS8iwWF8dq45HyndKnjZK/2c4GWW6GolUsou6ergqOc+RcJPIPaFMs43BdnjcbF76aLr3zmIard1JKGcPKFiVX/xbpbwS1yiTlYwZlc1YYw==
    09TxlrI+di7NPw+K4InelQcw6WVaJH1S1u+ckUvmDdeRWgDsLkTGQYD30jQgIeRQUsAkrYVIYpq6ZVGJdWkTouRR4zqBEmsK1ooU6zYiiyw+KiDTEvUgBSFsL6Ser/5vlN9JjA==
    +xGAVhyXvXGWWMjvaIbr21nUEKwRRJBLDERvZ8t2FrUG1mdrKdEpLWVTkIIUQcYoAvUMpaRIEwRTTiQg3KaC68KSAnCkcxMR3G1IFTncGkT1hrIwLm/YUOKGUE0xw5JCyno7WQ==
    5nBrUH22dhKf0k42hahLCBSoIGYM9IayxOLWQKo3lIVxecOGkjTl/iIkIZAQ9paybClJa2B9tpaSnNJSNgWpS2X2EEWS1IPUGRnK9iCqN5SFcXnDhpI2ZSgFJIDyfC2kN5RrLA==
    bg2sz9ZQ0lMayqYgdQkFJlIoUMHeUpZY3BpI9ZayMC4ts5ScNGcpWVOwRoDFHjAl9WB9TqaStQbXZ2sq2SlNZYOYUs4nZqTmyv8Zmcr2QKo3lYVxaZmpbDKo5E3BmjPEABUS9Q==
    lrLM4tbA+mwtJT/AUrZEN3ID2pg2pRv3N/8f3Adn+muy2ebzh7tpYwEzg8q1BrTm1DLRDR1aui4NyyBCYJ0IYiIhdWrrgEGz2/qiktMn1xrVsKsQ3ENMaalzZTxWQ7DKeCZU4w==
    XWL5nh81qqEbPLmDdxcFqq8U9qYmWzFGEECIRC05B5plMW5LISkgwlaSrnEbIm4aSKeU0zcm529WxuvId9kMdcRjFA0hg3JIGAWidxjLDqPoHcbv7TCK7jqMTQbTVSoq/kk3Sg==
    lxrOFER1Umg4IlQHVqHhFsYkTmbdbHhWeM/RT5v4/IrN22u7fNN9xfn9fut2K7Zuf3Be/EW0HCOlwd21QTxoYzcSZLPEsEyvrVu7EaX5ekT5OtpyfXf54fN+W8EFpkBLPZAtGw==
    ur+lcHe4G3/3F8FH994NXK/hkFNdZggjSmp5HNIWQEO2qQHBCZBM6EynOlbelwGI1EWnPY4NJrfG5UhktQqaZWu5xTBmsllhXwyb2GyHfYk5pEYph4rSOdOJ5354mi4VQPNuxw==
    xjgcd0knkaMbpVp975Mar0bRRRSwoBSw3rKObmu6iopNIYXyB9QgImETU7OQkEAK0u0JnQo2twhf6IzwVTESx0XYXxZ+5P7iN4osxBgWEJN6kTKT2MYYaipKRsRkhm5gLjSNQQ==
    YAosiNZpZK2xt0WIOieLtTYCDSDp9e7i7eNkHr8t72c3evTHphuOgsk8fv1eoxAUhKixo6yecaMasE2LG4QgRDi0NGYRwKFhINMwsGl1GoI7Gd4iUFaYubhAFtt9+y1fack3iw==
    453DeMyEhx3BY92osKm1GYaAsqrKca03BW3YNJ5vVoGgQUwJhORcE5hR0wJCk91emynwt0UoPoFpbTqMO1kI94szawoKlwhIjAXist56PFbhmoZ0TaemJBrXNBNgCxmcA4Nryg==
    9HUaCyUWtwgNJwjdmg26Yv6dJOBqyiQIxrmETNSbIxS6tCDhpm2YNrEkFkJARhgVtiWojmSnYZBxtkXi3w1jkPGt3dFRc3lcAlEBmKyFF2hBW7cMyzA0SbgllcwIAHUbKynCyQ==
    8kqH8bKV1y1CUDuDomOGM4eGMqtl7j2MkZKUL2vP/qCiuLAxpFFGiQo6sigR0o7AoponZTgwKQzLYujSJJRcEk6pggMnl9CATDmX0AJS/HPZc9Vq14ni17y7o5hoBTjW4FAewA==
    NXNPBIESiZrZeZTokFiCSQ5NAgVW7q9tcQ4NohGAtmXnVbQ37vbuNt/5/pf44xpqXJLnqyFTUPz8o687oy8x+8aTMHnMWH9Jc1fUIFwPPKUp4ruT8Wo9/pXyW3WxKW8LSRVREw==
    WXMnum0rvlsaNoCkauCoZjGhQYtKYGoYGN1+tW8V63fcq7Qpe4Bom01ZE8GiaqeEM1RMQSpcKqQgpXe2zndtzePaS+VXcKVa2Vc7WznClBXdA07bjUb1U0o5UqXsp/iSNOK8qQ==
    msldeeE8+yX76VOe1t2XPuWpIuUJQtzhlCe5TNopZjBxXJnxJCiousyBrLoMOajMj9pSfBsVQXZnU90EFQ7x5qU8yRtIKQtJ3uWs7nzvzPD5kKzuWF0OY8sRr+Wp4waXy5RHRA==
    CCO03qZ5BomE0lRqjZuEaUxTMgeBqVSgrkMDdTvPKjPVyXGJ2W2JChNoVQWFayqpqJbj7ytNtyk4Uqng1ok9adPJg5cTS0lvncupCZpvxJpra07NLMDNA9+/t4JgybhwrpRo4g==
    rOeqt7IHqedSkoSC17KNthrWZRsanUBNFEFh/a9ZbQApoVhKUXOn39mogyqWt0UnpHa1VwqnVApV8tACzfCXheNFk+ilabUQ7/+FFNF6GTVnoxU22N0WlZC41L1GWNcIVTunjg==
    ryc2JOQISmKLDCSRTy8D+1iFAr/3177/7U1UyabfvUARBFwi3HtkBd1bYHZb9G46OdGD7vsr3oJ49Er37Srd37RPN6Oo8TgYSYgIE6DXugWtW+J2W/RuD7uWqN2SfLQgJI7/aQ==
    M3/hNa8jKEYIx/NlvY5Y1xEVHG+LnkiXfU6pKPZO1+p1yzbdUiFXjeuXLJ/smCuBUKxWHvMihy/2rC38v0pSv59s7XpTzHDFm0oO1Zr6Pm8W1ZkKPG8O1XEez5tDtaY1zptFvQ==
    EPUcejXM6ninTbHoANe01Vxdem57BohNBYMYcRRn0mbJ6Z3J+E958IrYrF6G/9ZIbXu+v+BIKNFA9T78iwXGuvqzkIEIglgYlEsCdURsm+nbdivVT/ffHmoeFilkycW7IgWEeA==
    OVJ4Rc5gYwtSIH5JskA1P8hsYJNjKaRpQkYMJqQNTI4Q0ZOXxLJu77rckjHYlumOygDytVp8+06CdS3eVMpdC2YQy7k+jQGJxPv4KYH1gMQtqlFqCdtkBjGQpQSIQ11HwBaGTg==
    Rbe/rbMr164taKqebOgAnMoMbQGmCnkxDQEKCySBZKBeJjsWwhaW1DQR72GlSONS2Sdu2YJiS+NvB04FVrcFS5WzUh2AUoGZLcBRnObw6/3PrhMugqZwpIZd+XdC1Pw6qmkQLg==
    AUVAswiTULNNzjQENcosbOn2m8FRgdVtwVHlpEoHcFRgZktwlKQLNYQhzjFmRKJ6S8PE1InQlS2yDF2Fq1SY1MYCMqzZOmTg7SwNL9ncFvxUz2x3BEAJJ1sAnvifOQlH8dLsjQ==
    G4wUufT9vQ1Or0EiOCWk3puekGYSk1CMNcGIZgllkwTTdWFKSSG00ZvB0y7OtwViXTVRu3jbAtCtZVo1hTEmiCSAZLHPN+cjFJKYMIXy+iBRLqBkDAFkCKYZ0DAFfDMgW+N0jw==
    qcbSA1sAoVJCUWPzegLFnwSUNXOHgeAccCmEjTmhmq4ZGoC2RSwCNAB4t98/vSMvsC1Y2r7qeuLl0RPZtLUhOFb63Pa7WzZTHC3ZrmIJ7ZRrJW3KiutmX44yUdiiBJhuduU4YQ==
    cz8sfVdaZ5Vbl7SUel2f/MiZhk1Gf1JAAZVBZR1LYNrkRxuTmThTlowjUu8NGueRzNR7Yl3qS++JfdeuvMJCFDKYjmU+CBMYYgzrTR6+6c2QZRZXJTZVlGnFbAiGsDJNP357pg==
    ktLltkTcCGbqTXnUx0yTmVLlEfq+E5YbmM6mcY4FZ4qAgEj27wHcDuctI9AWJLcmgmobyLeMW8cnQ9e7uG3nMcS9C97lvvQueBu7clqXqZ+OO8F03KE6GDEgduvgfhqk433pdQ==
    cKumQTIMBQVKt1Hgr8h8+8N7qROY/rz3RtNFHJH8pn36lHxRpqH5EcmwUqKgnx+5StldOCtz/ahB1D5yMyxWO8IcSlzxOG+faguU9+J2AyFefZ0QvauUvhNM9TSut9Kodr0njQ==
    pYUySAEUtH/NXZXm2uR7p3VXB96Q92q1lnrpDai16vfgtVzZbQrsEWe+sq/elcaJxd/FI9+cN9z6Yb3Nccpfj/H7UmvlnxoLfzfC0sXyAKRdUkXdkULbnk2NF9rjqxrhzIZJmw==
    HhOd8dG9dwPXG7lLPrpPrje4CJIPFAbvx9mbYrYWH6cdXquRa+B7349qPGD5YoFt5TefAOE3GpV8P269AvrGMzYqLB3gh9vfM50DJeAxPx+TTQhYprpkrGovbc6Dgn5M059fDw==
    KEtKJ5hbnqU6aXkaf2svmfFMxi7tzfJm2tbl6cMiSk5zdik1Fq60Fgf5QEWTaOrePKQnyuzFX42LHzXx3JtJNFKtx2z14clEmJLDO3/8khyoOov4u8fv/h9QSwMEFAAGAAgAZg==
    YMhKScgOVhQJAACKSQAAEAAAAHdvcmQvZm9vdGVyMy54bWzlXFtv28oR/iuG+nCeHO79YhzngOSSiXGS1IiDpEBRBLREXRCKFEj6lqK/rA/9Sf0LHVIkJUtyQsu0IqsPMbnc3Q==
    2d1v5tuZWVL577//8/sft9Po6DpMs0kSn/bwK9Q7CuN+MpjEo9PeVT48Vr2jLA/iQRAlcXjauwuz3h+vf785GebpEfSNs5ObWf+0N87z2YllZf1xOA2yV9NJP02yZJi/6idTKw==
    GQ4n/dC6SdKBRRBG5d0sTfphlsFAbhBfB1mvEte/bSdtkAY30LkQyKz+OEjz8HYhAz9aCLe0pdYFkS0EwQoJXhdFHy1KWMWs1gSxrQTBrNYk8e0kbVic2E4SWZckt5NE1yWp7Q==
    JK2Z03TdwJNZGEPlMEmnQQ7FdGRNg/Tb1ewYBM+CfHI5iSb5HchEohYTTOJvW8wIejUSpnTwaAnSmiaDMKKDWkoCzE7jk6r/cdO/mPrJvH91qXukbdY/72KS/tU0jPNy5VYaRg==
    gEUSZ+PJrGH4dFtpUDmuhVz/aBHX06jX7E64JV0e2p7MHMqFwDbTr/CfRvOZ/1giRi00UohoerSZwv0x65lMwQoXA28FzRK4uOUGUgsgawJEFj5OBK9EWNnddEHRm9noaVp+kw==
    JlezhbTJ06SdLTh7Ez9ugZW1LFtw9rTJXIyDGVB52j85G8VJGlxGMCPQ/RGo76jUwFHBkl7h1vPLqLqcp9XNRX4XQYuT6yA67X0qer9JJ2CKVlX/BerAICFygOLdDGQHV3myqA==
    d2AyEGCUpWRWC4ohnCh69JMoSesuNyfZ90pSNgv6YXlfyonCYb5l18skz5Pplp3TyWi87cCTOJsMwrdP6v15q97WGvCX0bvgLrnKGx0NJ7fhkhLdMIreB+kS1PdVOrgNVhCBeg==
    oth6C2tVXjF2knyrF4KYXcodTtIs/5iAGFwUo6AqLSrdJLqaxkv19YOySZy8dSAubUqf5yW8NInGhAuDLW5HcAUh1ew5x9WaVp+TB57/uL11byyIjwEs0OFHmCLChtsu7VWPPg==
    pcUz4iOtdUm7bJBXl/mc0/klCuJRjdsgODZ/1uNU9UE0CbK6wV8+BNcnR9bbMACtW24RhsR378JRAAwO8rBwo7W+g9H9ThdlhJ8Ovl4EUZh9/WthN1/dJB5CWIV4bZCDupNAig==
    MwVbVVUzi8D2xkkEvYriIOmfQ/xUt6a+xEx60vEkYwJj7RuCtXEdxqmQxNRrWpUS5IEziYtMBCTN0hAs9n0wm0EZ9sP51hhn6PS3wnMuPObgLg6glB3HwTWEH7MkzTPrx+uzfg==
    K/RyC1Hb+LRngcwTAOULkOdj2f1v06hYzt/xP8q6Ob51aSPMUFlSMk/S8AwenZnT3j8dY3NMbHQsDTLHzIY7Ryl+zKggvnR84SP2r1pB4W1eodKYBNx48eA8nbeAEsw/h8HK9g==
    /fnfyuD71ZaMESmiz3UOF/Z7AfOuVcTqcfsVZ5dIvmETsJqW1mLU2cPmfr7+6KMJh8FVlC/VlOM+wvjz1xvBL+c0bzc3q2qWNZoNbFZFu6I2vc/Y8zk/Gcb2YsZb0Pjn/Pxsfw==
    +hiOJlmelnHyh+Tru8uoI5piogUimHPZiqeKYGM8boxSLjMudRTTLsfc94jg0riHwNONcO8LXecOZiPZVijW0j7PN7Ra4l1VU0quBrgX6xUIghZrZwjRQzSJw3fXUWNgjUlU3Q==
    0yQZemnarCGbQRgASk1rz7OZYffYvFFF90j90ECAdzOhn5H+UVx9m0zD82AUdslNpZHAlDLdjptCuFh4SmOmGfeoQo5vPI8JxKnxffWiubkM7x5xkeySi0s+cB+4uKySX8u9ag==
    VzgfQ/7TrXdEpX+USrRiIHK1LamHBQbaYeTaQlKMtM+JENIo/qIZuA7yHvFwpz5xz3i4rphfy0bvfTCJuiQhRoIixlE7N0iNYwsqfcczNsNSK+5Sg33IMKWPbPOy3WCD7R5xbw==
    gw/sKEs8SLo2KuycpRuS1N3kox0R/ZhoAqkoZrgV0Y2g2qOQkCLBGCHU1tglyEOOFMQVGL1ooj8E9R7xvqXPfUrKucIjxoXtu71tzn/WgHz0EdA2TKlD5M4IgqhWiDFMWjGEKQ==
    6kqJufZtxjyHKeQbWuSFiHPH1vIQGFJDvEfEaJkUPsWRdUeMGr+d8KGKUbuiA+RWgkmiULv0zLjakZS70jaauR62MWcMGc/XvlZUHgQdKoT3iA3P5SaehQ0VfDshQxkIdkQF2A==
    6RHHsuVJodFCcGZ81/c0M1raLqOuApx9bRtJ7EMgQonuHtHg+bKk/WBOiXcX79WeJWVxgvjbh2DaVSBGGSvYRtv5HYGwI1zlCt84jBkbQjhIWhRCgnKmPHoIdKsB3iPGPc3xtA==
    ehXdzXlCdySstbAT/3Xm2B86POY71lhLJbFQrUjlCscIAMpmrs8g9VewOSjhu46DdBHnHQKpaoT3iFRPy21eJKlqLXRAqs4+2br4cuZ/6pB8gmJFCePtzhU4qMsTylM2kQziRg==
    mxnFsDAKecglDj4E7jUI7xH5/g89WqOGnbi0N5M06fYFMhNUawaRayti+b6xMXGYcT3KfM0cqghybABPEC6pcwjEWmC8R8zaeXb2Ism4UN2OEr1nO1WaD7EBfelin/KH0f+QXA==
    zIJ++cOceyBvl5I6aRD3xx0eiBJJmFAYtfya04OWjusjaSTjjCvfodx4Nnex5yvxsl+Vb4B55xvOZuptMM5tk716Zat83OwQHzWdvPhpUf2TEVByFqbXYe/10cpr6+0M3+73kw==
    qzjv8lWAEFJjydu9O/Y5Y5J7hiEHwz8OPQ11bcE9aYhGB3Mk0+B8eKbfLK2N7d9zUdsednQWEwK8TErd7qDDE47GHoH0zBXMZp6DiCIORIVCM89W+hBMtUB3v6PBToKLn4V2Dw==
    BRfdnmXs3TlGV7wSghJEpGSteGV72nEKPrmeYMTniiGJCcEeJcUP1w4i+Cnh3SNiPVfU/uuJVSK9wzOKjjjDqaZEU9ruV5qQFBDiKOFLJpmrkXaVYkp7jnAM/D2I79vn8O4RZw==
    dv/ieI9pNtfOtqcPxWX+fxesfGK8chrztAMaP0nyMK2/BK5U/73xUvXBTfbdzVYe1guukWuWNoTZ/w9QSwMEFAAGAAgAZmDISlQNZJX+AQAAewgAABAAAAB3b3JkL2Zvb3Rlcg==
    MS54bWyllluO2jAUhrcS+R2cCzA0IoyqolbzVnVW4HEcEo1vsp0E1taHLqlb6ElICFXaUQgvGDD/5//cTH7//LV7PgnuVczYQskEBUsfeUxSlRbymKDSZYst8qwjMiVcSZagMw==
    s+h5v6vjzBkPtNLGtaYJyp3TMcaW5kwQuxQFNcqqzC2pElhlWUEZrpVJcegHfvtOG0WZtXDQFyIrYlGHo6dptNSQGsQNcIVpToxjp4ER3A1Z4094OwaFM0AQYRiMUdHdqA1uXA==
    jUCrWSBwNSKt55H+EdxmHikck57mkaIxaTuPNGonMW5wpZmEzUwZQRx8NEcsiHkv9QLAmrjireCFOwPT3/QYUsj3GY5AdSWIKL2b8ISFShmP0p6iYLKNjDv94qpvrMcXfbf0Cg==
    MyX+i+SgaCmYdG3k2DAOuVDS5oW+TriYS4PNvIdUHwVRCY6ut1MwcVz+dz0dLqkcgFPsd/kX/OL8Y2LgT6hIg7gqplj4+8zeiYAuHA6elZqb5AYTL5AeEI4AG8vuQ6w7BLZnMQ==
    jGitj49V+ZtRpR5oxWO0l2Fma3lfgF233HawfczMa040jLKg8ctRKkPeODiC2ntQPq+tgNdMCWr+1rVXx/AwkP5IkO+HqyD4HKH+qwPLSMndzU6r+G7a5dWdOYDiivAEfVXKMQ==
    gzy83+HuJ83avsKTw/4PUEsDBBQABgAIAGZgyEqkWeeR9wUAANIeAAAQAAAAd29yZC9oZWFkZXIyLnhtbO1Y647aRhR+FeT+iFSJ+IIxBoWNwMBmpWyClm1Sqa1Wgz2AG9tjzQ==
    DJdN1Cfrjz5SX6FnBo+5U/BCf1TRSuu5nW/O7Zs5zN9//vXm7SKOSjNMWUiSpma+NrQSTnwShMm4qU35qOxqJcZREqCIJLipPWOmvb15M29MAloC2YQ15qnf1Cacpw1dZ/4Exw==
    iL2OQ58SRkb8tU9inYxGoY/1OaGBbhmmIVspJT5mDDbyUDJDTMvg/MVpaAFFcxAWgLbuTxDleLHCMM8Gqep13d0FsgoAgYWWuQtVORvK0YVWO0B2ISDQagepWgxpj3FOMSRrFw==
    qVYMqbKL5BZD2kmneDfBSYoTmBwRGiMOXTrWY0S/TNMyAKeIh8MwCvkzYBqOgkFh8qWARiCVI8SV4GyEmh6TAEeVQKEQYDZNGpl8OZcXqjeW8tlHSdBT7F+KdIg/jXHCpeU6xQ==
    EfiCJGwSpjnD46JoMDlRILNjRsziSMtPJ/NEuhw6njpLV64AT1E/838cLTU/jmgaJ0REQOQSp6iwuafSJIYsXG1cyDVrzjVPPEAUgLUD4DB8HkQ1g9DZc7yi6DwdvyzKt5RM0w==
    FVr4MrS7FWfnyXkGZtmynsHsZcoMJigFKsd+426cEIqGEWgEsS9B+EoyAiXBEk1c63wYZZ8+zRoD/hzBisYMRU3tUUjf0hBSUc/mP8McJKRpmHU46mDoOQX8YIFWS9qgD9QYsg==
    R1KFlUBFIQR8EhE4YdCUE9FlX5uaIRsp8rFsS5wIj3hB0SHhnMQFhWk4nhTdOExYGOB3L5L+VEha33H8MPJwFN0juubMeSa6HTNl8/55fRsNeu8J+aIUNeyWlBqFlPEHIpJDdA==
    I5T1VpMeiaZxsjavBuSShLxrQ+mZ9z4te+aaEnmWipwUzTF8AWSpe9Wou5lF+8f1DVlOYRpK4eABtjQ6DnCxo2VDj1SMud2aA2Nysb/8n2ngf16H3uexbGWq9uhLRKtn1Ot1bQ==
    fePNof6eVR08QtOIi5maZ/YqValRutyAZp8N3g44JeLGWeoil+i5BAt49jkPYd5AUYiYWvHDBzRrlPR3GEHO6XfJjMCp9PR+GKmDAI03lw7kDwsaPA1QhNnTR5GrTx5JRlDNGQ==
    VUWCQAmVTdeAv5pdVXNpBBk/IRHIiW5A/D4Ubmq91652rbZr17xex3Ydu23VXdfzbKfS6hk9r65s2UZBHLXDRPwEAqSU4lG4uEdpCn04iJdncsKM5itxZa+u6uA5QdBj5QTNoA==
    7kkJ5Uw/bqH+SkR0AeXipKnpgNkAt3wGyj5I8Z/jSJjzi/mbnFv6VfXW3AtDkv6cUHzHcXzXaWrf2p1W1bRaRrnWMTpluwWttutWy3bFsXq1ds/pGfYfKjB4wTNf5DkAjW4SnA==
    nVHrYtAGUzmUbzJWlJBRl9KcGyyFAwQcRLk6dE5lxnk5ym/WfCWZuJw9rBRYoK38kdug50y5lqbixlfHOCQew3SGtZvSltJXoauqtD+QS7HVNR3XqLqm9Z2sK+d+5+q/cHXlqg==
    S1BVJMw+ypxAhA7i+EJUsF3brTuGaZ7EBLvSaXtWz6n0LNu2qm3XcdutquV061bHcOq9/wUThHevyoXliq203k5ay3Hd4qXXWoZnhVS6meHTIQ95hPOA9Y8k8lFyST03+SEceA==
    LkPSI1fahX2zW5ae5JszeNpH40sWl7ZZMa2qYzrfbyvl2f+enwWZceDa4TfKkitVfUc3P1DLbRdzZ4GOosCbICGStR6l+kM8Fo96ekHUMGGcPopY7Ve537rtlkq//lhqUTQMfQ==
    2bzvPtx2ex8f7luP0qIc47KWMZwiqi7iHWCJ4Ri2V1kvMxLSF/HdLiysKzger1LmfMxD7ta3UwS2HIRxKg9P6eemVvrw070Iy+BYXLRLOUtf02FVU6XryJuPJfJyMDum17X2XQ==
    Dtnig5fD8jjKH8HEGS0fpJqaaasaKlN1uO9FI7/q1BvNC19qDhiYPQZdycDffbVaTp1rtvhQ9cC154Lfis4BEzeHrhlD8Y6pZPOfjOyrx7YGDxo9CejNP1BLAwQUAAYACABmYA==
    yEp7pPaA/gEAAHsIAAAQAAAAd29yZC9oZWFkZXIxLnhtbKWWW47aMBSGtxL5HZwLMDQijKoitfNWdVbgcRwSjW+ynQTW1ocuqVvoSUgIVdpRCC8YMP/n/9xMfv/8tXs+Ce5VzA==
    2ELJBAVLH3lMUpUW8pig0mWLLfKsIzIlXEmWoDOz6Hm/q+M8NR5opY1rTROUO6djjC3NmSB2KQpqlFWZW1IlsMqygjJcK5Pi0A/89p02ijJr4aAvRFbEog5HT9NoqSE1iBvgCg==
    05wYx04DI7gbssaf8HYMCmeAIMIwGKOiu1Eb3LgagVazQOBqRFrPI/0juM08UjgmPc0jRWPSdh5p1E5i3OBKMwmbmTKCOPhojlgQ817qBYA1ccVbwQt3Bqa/6TGkkO8zHIHqSg==
    EFF6N+EJC5UyHqU9RcFkGxl3+sVV31iPL/pu6RVmSvwXyUHRUjDp2sixYRxyoaTNC32dcDGXBpt5D6k+CqISHF1vp2DiuPzvejpcUjkAp9jv8i/4xfnHxMCfUJEGcVVMsfD3mQ==
    vRMBXTgcPCs1N8kNJl4gPSAcATaW3YdYdwhsz2IY0VofH6vyV6NKPdCKx2gvw8zW8r4Au2657WD7mJnXnGgYZUHjl6NUhrxxcAS196B8XlsBr5kS1Pyta6+O4WEg/ZEg3w9XQQ==
    8DlC/VcHlpGSu5udVvHdtMurO3MAxRXhCfrGSMoM8vB+h7ufNGv7Ck8O+z9QSwMEFAAGAAgAZmDISsB2o9c/AgAAvAkAABEAAAB3b3JkL2VuZG5vdGVzLnhtbMWWS5KbMBCGrw==
    QmlvC4wfE8r2LOwkNbupmRNohDDUoEdJwthnyyJHyhXSvJ3guDBeZMND6v70d0vd8OvHz/XziafOkWmTSLFB3tRFDhNUhok4bFBmo8kTcowlIiSpFGyDzsyg5+06D5gIhbTMOA==
    ABAmyBXdoNhaFWBsaMw4MVOeUC2NjOyUSo5lFCWU4VzqEM9czy2flJaUGQOr7Yg4EoNqHD0No4Wa5OBcAOeYxkRbduoY3t2QBf6Cn/qg2QgQRDjz+ij/btQSF6p6oPkoEKjqkQ==
    FuNIV4JbjiPN+qTVOJLfJz2NI/WOE+8fcKmYgMlIak4svOoD5kR/ZmoCYEVs8pGkiT0D0102GJKIzxGKwKslcD+8m7DCXIYs9cOGIqG8tQhq/0nrX0gPKv/61njoIfFXLntJMw==
    zoQtI8eapZALKUycqLbC+VgaTMYN5HgriCNPUdudvIHl8q/2tK9S2QGHyK/zz9NK+W2i5w7YkQLRegyR8OeajRIOp7BbeFRqLpLrDWwgDWDWAywNuw+xqBHYnHlXork6PLbL3w==
    tcxUR0seo710NZuL+wKsT8vlCTaPiXmPiYJS5jR4OQipyUcKimDvHdg+p9wBp6gSdPFtd/LAnhWYGaaIJlZqBEMJNJ+JV9opeIU/h/Btg1x3tfO++QtUD70WQ1/n7m7pN0Nvew==
    FpEstRfGJeRVFzejCAWZYEsiy6DXwJ8I3q5xa1BZNUrqOV1ZlNda9bUAqBQ2EVnZhd7/Dsb9T7FcFXUrru7ZbH8DUEsDBBQABgAIAGZgyEpiH7V2QAIAAMIJAAASAAAAd29yZA==
    L2Zvb3Rub3Rlcy54bWzFlkuS2jAQhq/i0h5kYx4TFzALSFKzm5o5gUaWsWusR0kyhrNlkSPlCmm/SUwoYxbZYCR1f/q7pW7714+f6+cTT50j0yaRYoO8qYscJqgME3HYoMxGkw==
    J+QYS0RIUinYBp2ZQc/bdR5EUlohLTMOEIQJckU3KLZWBRgbGjNOzJQnVEsjIzulkmMZRQllOJc6xDPXc8t/SkvKjIHtdkQciUE1jp6G0UJNcnAugHNMY6ItO3UM727IAn/BTw==
    fdBsBAginHl9lH83aokLVT3QfBQIVPVIi3GkK8Etx5FmfdJqHMnvk57GkXrXifcvuFRMwGIkNScWhvqAOdGfmZoAWBGbfCRpYs/AdJcNhiTic4Qi8GoJ3A/vJqwwlyFL/bChSA==
    qG8tgtp/0voX0oPKv340HnpI/JXLXtKMM2HLyLFmKeRCChMnqq1wPpYGi3EDOd4K4shT1HYnb2C5/Ks97atUdsAh8uv887RSfpvouQNOpEC0HkMk/Llno4TDLew2HpWai+R6Aw==
    G0gDmPUAS8PuQyxqBDZn3pVorg6PnfJ3LTPV0ZLHaC9dzebivgDr23J5g81jYt5joqCUOQ1eDkJq8pGCIjh7B47PKU/AKaoEXb7cnTywZwV2himiiZUawVQC3WfilYYKhvDtEA==
    vm2Q66523jd/geqp12Lq69zdLf1m6m3PIpKl9sK4hLzq4mEUoaATbElkGTQb+BbB2zVuDSqrRkm9piuL8reRfTUEKoVNRFY2ove/w3H/UzRXRd2M7GJgtr8BUEsDBBQABgAIAA==
    AAAhAMfO8qi5AAAAIQEAABsAAAB3b3JkL19yZWxzL2hlYWRlcjMueG1sLnJlbHOMz8EKwjAMBuC74DuU3F03DyKyzosIXkUfILbZVlzT0lbRt7fgRcGDxyT830/a7cNN4k4xWQ==
    zwqaqgZBrL2xPCg4n/aLNYiUkQ1OnknBkxJsu/msPdKEuYTSaEMSReGkYMw5bKRMeiSHqfKBuFx6Hx3mMsZBBtRXHEgu63ol46cB3ZcpDkZBPJgGxOkZ6B/b973VtPP65ojzjw==
    Cmld6S4gxoGyAkfG4nvZVBfLILtWfj3WvQAAAP//AwBQSwMEFAAGAAgAZmDISqCeTGqfBwAASiUAABAAAAB3b3JkL2hlYWRlcjMueG1s7VrrjuI4Fn6VKPtjpJXoXEhCQE2NIA==
    QHVJVT2Iqp1eaXfVMomBbCd25JjbjObJ5sc+0r7CHjtxgIKqhhQ9Uq+mpa74dj6fu08c/vv7f97/uEkTbYVZHlPS1a13pq5hEtIoJvOuvuSzhq9rOUckQgkluKtvca7/ePN+3Q==
    WURMA1qSd1BXX3CedQwjDxc4Rfk7mmECczPKUsShy+ZGxNAaMNPEsE3TM1IUE72kz+KwBgJQ8SXDCgRZzhFIGoeM5nTG34U0NehsFodYwQCIZR6wsc6O2TiJsKYsKshFK2M0xA==
    eQ6QASIrlCu4cHMxP44RLhDjeLPDsC4GcY224R8D2TWAQELbOoZqXgzlGYKrI6DLLSaAgKsjJLce0gnhvHpI9jFSqx5S8xjJr4d05E7pWXGWIvZlmTUAOEM8nsZJzLcy5KpQiw==
    yZcaHAFVhZA2o4sRWkZKI5w0I4VCIUEx0inpGxW9YL1T0JcPRcHOkb8gGdBwmWLCi2TDcAK6oCRfxFkV4WldNJhcKJDVa0Ks0mSXnc5NcC+lp0Ghyh1gjaT7OqJlnmERAVFRnA==
    w8LhnqcOkHU91ewp1zozgSgA+wjAy/FlEG4JYeTbdBei62z+NivfMrrMdmjx29DudjG7JpcJWHrLvgfnb2PmcYEyCOU07NzNCWVomgBHYHsNzKdJC2giSnRRnfBpUj7GrGw88g==
    bQIrOiuUdPUnQX3LYnBFo5z/BHPgkFAAQXebATZacrqb7wMzUCfJHs0UEIGqSFCENKFMkaw7+S8lUp6hEMu2xEnwjNcknVLOaVqTmMXzRd2NY5LHEf7wJuqfa1EbR4qfJgFOkg==
    B8T2lHlotGiDnsl8et54jga9e0q/KEZNpyepZjHL+YQCiCW6CSp7u8mAJsuU7M2rAbmE0A99KJ+r3s9Fz9pjonJR4ZCiOYcngBS8u2bbLyU6PW4c0HIG01DORxPY0rRHtuf7eg==
    OfTE9sbk4rD4W3IQftqHPqWxcmWm9hgXiJ7ttfv6yxuPj4cmAzxDy4SLmVZgjZqu5CgrNziM1pgnWPFQrsgjXj6KPkpilCuCv3xEq45mfMAIPMe4IysKieXz/TRR4Yzmh0sf5Q==
    Kw6LPj+iBOeffxIe9zmgZAYFmekqV44UUcPyrFYbtOQp02QJ+O2CJkAnuhENx1B7qfW+PRwNXN9v+a7vNPtm3+65rZY5bPWGXtOHnKVke4aCOOrHRLyMAVLG8CzePKAsgz7k0g==
    Iq2S3Oz+IE7d3WkbbQmCXt4gaAWlS0YZz43XJTR+EHbZQMW36OoGYHZALZ8g8CaS/O9pIsT5h/UvOVfoVfX21AtDMog5ZfiO4/Ru0NV/7Q96rmX3zEZrYA4aTg9afd93G07Tsw==
    R63+yBuZzm/KMHjDS11UloXGkERjVqyAHnDNoZiSameUzoaMVc6aZxDRICvjKguc66py+5s9YaTDS1bYy1sBZ/qO4Yozo3LQy/YXZ6XKgWDvHLMV1m+0Z6xc4Puq8vxIr+f6ng==
    5TZts+X86fo77X4Hnn+Yfo88fyfLNRxfWLSmqw4Qx1dyVr9pu57le+5Zrur13FHftR3T6QdObzDqtzyrafd9xzJ93zT7/xeuKrT7xzvrua54Xr2w57cn64XH5ZSfKBnqhsxhfA==
    CAVeGiHZKwfElXXztVrqBd1cEKdjNL9mLWU5Tsux2o5j/3meKNV+/6eJkuTbFFGvb/5CEfW8iroIdJZEwQIJkrL1JNmf4rm4hzJqosLLMWdPwlanWR73boea9s+/aj2GpnEomw==
    D8PJ7XD00+Sh9yQlqjCuK1mOM8TUSXwEXJSyphM0JQYrPIzQsbCvoijfKm+sb6B4vHOZyzFfUrdx5CKXmf4ck37824Ow6mMds/4x5rJPKeE1krNMpArC7IRNrnPqF6n04Fyrjg==
    XnXRUe+644LDMRCfTch2rL5OXuedy/abcOK1LXXb8H2cZoe6ePOZVn7xrVV3fktnW3f+Hapheef4rLT6avyUH1mgmUHYJzHBWhTn/EneGYpWv2rdV61JcaOYWU4HkXBB2V3U1Q==
    bTOw+4NhUE7gKOZi2GuPgmAQyKvxrAM5BdSjiQ/UtuWZ8E/Xwi0UYqZfdIxi2WyGQz4sFidyNy7/Mvl3CrBNt1otqjSmxcXNJngZBFJpd81Sa8KPq1uGskUcjhisEMKjznxv5A==
    noZf8jf/qoBQyEFkjntQW4R8d9X6OgNv3XYPCt4QkLZkx99ezv9Vw817aAmPv8pvJAo0sgKLCJlFB1RR2ss8bS+1SJBoIsNgNpFfQVd4gvP4F3lJL4SGhYXdTui9GmKMrhcQMg==
    eWWOffyye8DgNImzUZwkYgvR1lgHp1MMDIOnW3JncOT7nJetQuG/2n7PNNt2vxG4ZtBwzNaw0Ws7rYZ4Q4AXe98KrOA3QQ3hscyFx6FkkMVX+BVJ8dWgEE5ypJ6SR6OQQjAL5w==
    OubhQjRnIOAElFUSVTPGoQZEL4dsok3XDzRSX6YEwGbGUvEEtrSN3H6rmCi08mqUGzuAjOX8FtNUEw3QMTAlN0ArYL9cq9aIcUIFa8U+CTkcMYohQ7FdNuG/nNuLkv1+EaJF/g==
    k9mxSov7BcTL1008LB5MfRH5ygFwrdJiEbGb/wFQSwMEFAAGAAgAZmDISnpKmV1tBAAArg8AABAAAAB3b3JkL2Zvb3RlcjIueG1spZfZbuM2FEB/xVAf5smhJMtLjHEGXuJJ0A==
    WYJkMClQFAEjUbYQihRIekvRL+vDfFJ/oZcSKS9KAlt5sUTdew/vKtH//fvr46d1ShtLImTC2cDxzlynQVjIo4TNBs5Cxc2e05AKswhTzsjA2RDpfLr4uOrHSjTAlsn+KgsHzg==
    XKmsj5AM5yTF8ixNQsElj9VZyFPE4zgJCVpxESHf9dz8LhM8JFLCRmPMllg6Bheuj6NFAq/AWAMDFM6xUGS9ZXgnQ9roHPWqIL8GCCL0vSqqdTKqg7RXFVBQCwReVUjteqQXgg==
    69Qj+VVStx6pVSX16pEq7ZRWG5xnhIEw5iLFCpZihlIsnhZZE8AZVsljQhO1AabbsRicsKcaHoFVSUhb0cmELkp5RGgrshQOky1Y39g3S3vter+wNxdrIY6JvzCZ8HCREqbyyA==
    kSAUcsGZnCdZOeFpXRoI5xayfCuIZUqd8u3kHTkur72eJkUqt8Bj3Df5T2nh+dtEzz2iIhpRWhzjwv6e1pMUunC7ca3U7CTXO/IFYgF+BdCR5DRE2yCQ3KTbEV1ls/dV+bPgiw==
    bEtL3ke73s7sip0WoOmW3Q6W73Pmbo4zGOU07F/PGBf4kYJHUPsGlK+RV6Chp8TRn3X1SM3lRpibO7WhoNFfYjpwfmjrzyKBVkRGfg8yaEg4OcBykwEbLxTfykfgDBww8hXPLA==
    iMFxQluEnHJhTVZ9+WxIMsMhye9zDiWxqmn6yJXiaU1jkczmdTdOmEwicvUu65+1rFEl8Y/0C97whSprFCdrslPEMaH0KxY7qd4vabTGBxkBud8LqhrokKf35vzJBuIGw5wbJw==
    QqpbDhhPLyk2q61wzOkiZTty+yBXYfxqBOfScvWzWHk7TpQtrBtW387gCpDCe8/19be51LZKcLCFKCH5t8B2/al7fn7umEc/xM4zrSwjZS7FZqK4UMxmNuAINye/232MHNMESw==
    q/DbN7zsN9AVwVAuNNbnB7b5QmYYRg8ror9/tlB4tm90lx/NRfRwhymRD991wR/GnMVwHnLbtpMia9T0/J7ntvwg6BlZRqFt5pyCnV5GPLyBo4/VH42CybTX7XW6rhu0xu4wGA==
    DsdTLwhanVa71R3ZqA4pWOFRwvSfCCBlgkCzfcVZBmt4lRVvNSbdwQf90dt+7KINw7CSTYaXcHLIuFASvR0h+qArs4YD13zgIGD2IS330Pe3ufkfKdXh/On9lcuKDNvVi4kGYQ==
    Pk2KC3INj64nA+fv0WTY9vyh2+xO3EkTcuA2R71euwlp8Kfd0bQzdYN/bInIWpmslE0BN5csuhGFBqzAfwWb5fph8Wt6Nbzfa87q+KnQjNXOHL4wp6jURFt69npj31Qf3U5IjA==
    F1QddHxmWHufhW/8Dt4/+ZnGdIQZhxNmQl28WJE8gEKvIJuQbIrLXCIzjVoq7FDvhX2TT6838caXvrObC/fS7XrTvVwcaO3kwii/mosp54oI+7Y0HfBspZ5vJPJ5LA8e2lzY/A==
    ldHCn+2L/wFQSwMECgAAAAAAAAAhADJSfrUKAAAACgAAABUAAAB3b3JkL21lZGlhL2ltYWdlMS5iaW4KialqfI+Jy26tUEsDBBQABgAIAAAAIQCqUiXfIwYAAIsaAAAVAAAAdw==
    b3JkL3RoZW1lL3RoZW1lMS54bWzsWU2LGzcYvhf6H8TcHX/N+GOJN9hjO2mzm4TsJiVHeUaeUawZGUneXRMCJTkWCqVp6aGB3noobQMJ9JL+mm1T2hTyF6rReGzJllnabGApWQ==
    w1ofz/vq0ftKjzSey1dOEgKOEOOYph2neqniAJQGNMRp1HHuHA5LLQdwAdMQEpqijjNH3Lmy++EHl+GOiFGCgLRP+Q7sOLEQ051ymQeyGfJLdIpS2TemLIFCVllUDhk8ln4TUg==
    rlUqjXICceqAFCbS7c3xGAcIHGYund3C+YDIf6ngWUNA2EHmGhkWChtOqtkXn3OfMHAESceR44T0+BCdCAcQyIXs6DgV9eeUdy+Xl0ZEbLHV7Ibqb2G3MAgnNWXHotHS0HU9tw==
    0V36VwAiNnGD5qAxaCz9KQAMAjnTnIuO9XrtXt9bYDVQXrT47jf79aqB1/zXN/BdL/sYeAXKi+4Gfjj0VzHUQHnRs8SkWfNdA69AebGxgW9Wun23aeAVKCY4nWygK16j7hezXQ==
    QsaUXLPC2547bNYW8BWqrK2u3D4V29ZaAu9TNpQAlVwocArEfIrGMJA4HxI8Yhjs4SiWC28KU8plc6VWGVbq8n/2cVVJRQTuIKhZ500B32jK+AAeMDwVHedj6dXRIG9e/vjm5Q==
    c3D66MXpo19OHz8+ffSzxeoaTCPd6vX3X/z99FPw1/PvXj/5yo7nOv73nz777dcv7UChA199/eyPF89effP5nz88scC7DI50+CFOEAc30DG4TRM5McsAaMT+ncVhDLFu0U0jDg==
    U5jZWNADERvoG3NIoAXXQ2YE7zIpEzbg1dl9g/BBzGYCW4DX48QA7lNKepRZ53Q9G0uPwiyN7IOzmY67DeGRbWx/Lb+D2VSud2xz6cfIoHmLyJTDCKVIgKyPThCymN3D2IjrPg==
    DhjldCzAPQx6EFtDcohHxmpaGV3DiczL3EZQ5tuIzf5d0KPE5r6Pjkyk3BWQ2FwiYoTxKpwJmFgZw4ToyD0oYhvJgzkLjIBzITMdIULBIESc22xusrlB97qUF3va98k8MZFM4A==
    iQ25BynVkX068WOYTK2ccRrr2I/4RC5RCG5RYSVBzR2S1WUeYLo13XcxMtJ99t6+I5XVvkCynhmzbQlEzf04J2OIlPPymp4nOD1T3Ndk3Xu3si6F9NW3T+26eyEFvcuwdUetyw==
    +Dbcunj7lIX44mt3H87SW0huFwv0vXS/l+7/vXRv28/nL9grjVaX+OKqrtwkW+/tY0zIgZgTtMeVunM5vXAoG1VFGS0fE6axLC6GM3ARg6oMGBWfYBEfxHAqh6mqESK+cB1xMA==
    pVyeD6rZ6jvrILNkn4Z5a7VaPJlKAyhW7fJ8KdrlaSTy1kZz9Qi2dK9qkXpULghktv+GhDaYSaJuIdEsGs8goWZ2LizaFhatzP1WFuprkRW5/wDMftTw3JyRXG+QoDDLU25fZA==
    99wzvS2Y5rRrlum1M67nk2mDhLbcTBLaMoxhiNabzznX7VVKDXpZKDZpNFvvIteZiKxpA0nNGjiWe67uSTcBnHacsbwZymIylf54ppuQRGnHCcQi0P9FWaaMiz7kcQ5TXfn8Ew==
    LBADBCdyretpIOmKW7XWzOZ4Qcm1KxcvcupLTzIaj1EgtrSsqrIvd2LtfUtwVqEzSfogDo/BiMzYbSgD5TWrWQBDzMUymiFm2uJeRXFNrhZb0fjFbLVFIZnGcHGi6GKew1V5SQ==
    R5uHYro+K7O+mMwoypL01qfu2UZZhyaaWw6Q7NS068e7O+Q1VivdN1jl0r2ude1C67adEm9/IGjUVoMZ1DLGFmqrVpPaOV4ItOGWS3PbGXHep8H6qs0OiOJeqWobrybo6L5c+Q==
    fXldnRHBFVV0Ip8R/OJH5VwJVGuhLicCzBjuOA8qXtf1a55fqrS8Qcmtu5VSy+vWS13Pq1cHXrXS79UeyqCIOKl6+dhD+TxD5os3L6p94+1LUlyzLwU0KVN1Dy4rY/X2pVrb/g==
    9gVgGZkHjdqwXW/3GqV2vTssuf1eq9T2G71Sv+E3+8O+77Xaw4cOOFJgt1v33cagVWpUfb/kNioZ/Va71HRrta7b7LYGbvfhItZy5sV3EV7Fa/cfAAAA//8DAFBLAwQUAAYACA==
    AAAAIQCD0LXl5gAAAK0CAAAlAAAAd29yZC9nbG9zc2FyeS9fcmVscy9kb2N1bWVudC54bWwucmVsc6ySTUvEMBCG74L/IczdpruKiGy6FxH2qvUHZNPpB6aTkBk/+u8NwmoXlw==
    xUOP8w7zvE8gm+3n6NU7Jh4CGVgVJSgkF5qBOgMv9ePVHSgWS431gdDAhAzb6vJi84TeSj7ifoisMoXYQC8S77Vm1+NouQgRKW/akEYreUydjta92g71uixvdZozoDpiql1jIA==
    7ZprUPUU8T/s0LaDw4fg3kYkOVGhP3D/jCL5cZyxNnUoBmZhkYmgT4uslxThPxaH5JzCalEFmTzOBb7nc/U3S9a3gaS2e4+/Bj/RQUIffbLqCwAA//8DAFBLAwQUAAYACAAAAA==
    IQAKPKuvgQMAAAEKAAAaAAAAd29yZC9nbG9zc2FyeS9zZXR0aW5ncy54bWy0VtuO2zgMfV9g/8Hw82Z8SZyLt5liJplsW0y2RZ1+gGzLiTC6GJKcNP36pWRrnHbcIt2iT5Z4yA==
    Q4oiKb96/ZlR74ilIoIv/egm9D3MC1ESvl/6n3ab0dz3lEa8RFRwvPTPWPmvb//849UpVVhrUFMeUHCVsmLpH7Su0yBQxQEzpG5EjTmAlZAMadjKfcCQfGrqUSFYjTTJCSX6HA==
    xGE49TsasfQbydOOYsRIIYUSlTYmqagqUuDu4yzkNX5bk7UoGoa5th4DiSnEILg6kFo5NvZ/2QA8OJLjjw5xZNTpnaLwiuOehCyfLa4JzxjUUhRYKbggRl2AhPeOJy+Inn3fgA==
    7+6IlgrMo9CuLiNPfo4gfkEwVfjnKJKOIlBnhj87IkWvSUkLPZJcItkWXJcPVqRv91xIlFMIB/LiwdE8G51/C1V+JPjkwQeBG24IqR8YeYkr1FC9Q3mmRe00ZnHYwsUBSVRoLA==
    sxoVcAkrwbUU1OmV4l+hV9AEEu6os7AtYVaNwpuHR3QWjb5AsrbdgIEjBqF+1UJbUUI/gKkk1+fUGNhoouQyhG8dCRgPkpR4Z1KU6TPFGzhMRr7gO16+a5QmwGgb6Rci+FEAmA==
    G8/v4VJ35xpvMNINpO03ObM3s6Gk3hIphXzLS+jw3+aMVBWW4IAgjbdQTkSKk83zG4xKmMq/6De4LCuY8aVyi49CaKcahuswuVuv2kgN2iNxkowXXXl8g8yjyXwQSebhfLYYQg==
    FmG0ns4HkTG4GrS5W8xWi66rvkbuk+ndZjqEfP8861m8mg/aPEySMJ4NIvPxw/1g1JswidqTBs/5Zal5CT5ItzLN4rHWYoVYLgnytuatCIxGLp/uCXd4jmFm4Uska3IHjkYtoA==
    YAbRDUwXB9jksLQkql7jyq7pFsl9z9tpyEEpTLJ3z1wFFCOW/0jR1C16kqhum8CpRJNJZ0m4fiTMyVWTZ86Kw5S9gBpevj9Km6c+PadUQzHbYfKIbFNYXcxHn7KuaajMTMHjLQ==
    quu2b/J9tPQp2R90ZEpdw66EXwq7yfdxh8UWi1vMblBhTgba3aKXxU52oTd2snEvmzjZpJclTpb0sqmTTY3sABNLUsKfoIXd0sgrQak44fJNj78QuYemIHDj2Znl/fvxV4tRog==
    YKbU8NRoIR32t8WixL5BegeF8gS5+4ire6Rw2daq+3e7/Q8AAP//AwBQSwMEFAAGAAgAAAAhABtdy5XcCAAAHyIAABEAAAB3b3JkL3NldHRpbmdzLnhtbLRa23LjNhJ936r9Bw==
    l57XEXEnteNJgSS4mdR4k4qcl32jRMhmDS8qkrbH+fptkuL4MkepSVJ5MoUDNPpyuhsk/O77z3V18eC7vmybqxX7Llhd+GbfFmVze7X69Sa7DFcX/ZA3RV61jb9aPfl+9f37fw==
    /uPd46b3w0DT+gsS0fSben+1uhuG42a97vd3vs7779qjbwg8tF2dD/Szu13Xeffp/ni5b+tjPpS7siqHpzUPAr06iWmvVvddszmJuKzLfdf27WEYl2zaw6Hc+9OfZUX3LfvOSw==
    0nZ/X/tmmHZcd74iHdqmvyuP/SKt/rPSCLxbhDz8nhEPdbXMe2TBN5j72HbFlxXfot644Ni1e9/3FKC6WhQsm+eN5VeCvuz9He19MnESRctZMD291Fz9MQH8KwG6939MhDqJWA==
    90+1/7wI6qtvcckMfSx3Xd7NhDv5o95vPtw2bZfvKlKH/HJBpl1M2q3eE8t/a9v64nFz9N2eQk0pEgSr9Qh0vm4f/M+UOm2TVx+aeTei0ws0zQdvm+KmrP00SkFpD9uBRklkfw==
    9FU15dm+8jmp8ri57fKaMmQZmdaMcvvU9+XtLDkfhpyMKW58faxGSd2mLK5W3YeCzQsKf8jvq+Em322H9khSH3JykeEnve+ejne+mTT9H6X0gkuuZnx/l3f5fvDd9pjvSb2kbQ==
    hq6tlnlF+992SCh9O2LXSWLRbe/yo0/njfv379pNPw6cNOkvHjb+M/nOF+VA5eRYFnX++WrFAxmNEtZIxGh4OzTt4H/uXv4iPUZzL0/GvhmebFy/Xeub4qsfb+S8Hl3EvFo41w==
    rOen7Vz/aEmT18SdVzXtui38GNH7rvx2ko8LJiezJRZwIyJW15WFvxk5ux2eKp9RjLblbyPXfrzvh5IkTgH+Cxr8ngJEH9r5J8qym6ejz3w+3BMb/qbNJsJlVXm8Lruu7T40BQ==
    5eHftll5OPiONigps66JiWXXPk5+/sHnBeX6X9x3/ZJG1HSLienjwy/E2GUqVSejTTglx4w+I4HgTp9BlHExREzgXIgRydTJI2+QUEorIGK1VhYiqbI6hYgLDMsQwgIRSg0RZg==
    IgHtYVynWAMmpDXQHjIzMdAeQlzEIaI5S6GvmRYmxhqELIkNRGKyJ4FIyhKHNSA7E6x1qsMA7jN26xDqxoVK7NK+XiOSMRxtLlUcOIjoQGLduGahgTHlmusIxpRrHaUYMSK2MA==
    CjzSPMS6WR6lkG/cipDDKPBYx5iJ3HGrMJIFUYR1y7gOYc4JYQyHfhNKuaVNv0GMFAxqIEIhI2gP5VWIvSMiSb6DiBUshawS1pypOyImlmIkZTyAMRWpjENsqePMYL9lxuAskQ==
    ETFbQsTKFNcDGXOeQY/KWBoHq5iMdeZOrfkNkujAYiTjUkCtFdM6gJFTXGYO6qakiBjkjlL8TB1VWqQJtEcZwRKYJSo0TEEeqEhlBq+JaCPIN2UpS2B8VMYV5o7KlEvOIDpOoA==
    3zTVPg4rn2aBFZBvmnEbQ3s0lb4US1PSaBhTbThXkPHaqCyGPjjf67UxNoWs0iFVRax1KJIERkGH0uHzgY4Ck2F7LLcGr6GukGB7EhHgrqkTqUKYjZrqQYTjk2ppsT3Z2E0QYg==
    GKUJZIhh2nGoNR2EiFcQUed6vdFBZmGtMloxbI+hpMf1zRhqdOcQm2J7IiMCyBBjA8shQ0xM1RJbmrBMYGlOcHx2CalvYmkhUymHNSRkxuH6FvLxiIARHeB+GgoV4CiEgg4iMA==
    2nS4pd6EEUp66DdCXID3UUI4vEbpGFeXMBFRAHMhTI00MAqhI/bASh5mVN+gbpTaPIX7RFxJXC0jIdIYahBJYRmMaSSViCFDIkXdESNkTQDjQ7SOHdYt5JGCmRVFjOPMIsQoWA==
    Q6LRIKxBZEKFpcUyxG8fUTIWeYikKgjPIHSmwB51VKzwPo7TOwtEMs5w5GwQxNEZhNkY1msbyNDByFEzTTDfrOQxPiNZapoZZKIlQMB6YClH8NuHpTMszjkbGY6zxCb03oalZQ==
    zKV4TSalgpUipncwC7Uej5b4JBQLTp0OInQkx1GIpTD4FBAr6jN4jaZ3ccjrmEqsgjGNQzpXQR/EEUssjFwcaTp1QSThgmNLU071EiNC4V5PlIrORMHpGPeSOAsyBnVLOHU6mA==
    WYkgikJeJ5K2gh5NJEsdtCeRhgdQt8RqgU/ESWwCC6OQpCzG3ymSTGYa+i3lLNVQt5QOASn0Tkr2JNAHKZV4DXOOyGY1ZEiqxzMcRAy3+AsGIS6AlqZGWdydU0vRxhpYFQYw2g==
    aSzPnF3STAS4VjnGGD73Os5jA6PghJD4+4GTQYLj4yRjIfSBk3SsgR51Sma4Ozt6ZcHf+Zw21G0hEgUc9x8X0XsB9JuzXGImEmIslkYxYLCKuYRFuGfRq0cSYo+mgTDYHscT/A==
    jcs5JTK4JmOS4S9ZGQ8yA+NDLTjC3KEml+Hvb9RkQo6laW3xl9MsZNZBv2WhDPE5JAu11DC3MytTjS2N6TUQ2xOLFL9rZqm2Xy7KXiOOhWc0GE2FmUWIw98pssyk81vBeob69w==
    7+rNeBU73tnMT+PlyEU9r0jyeteV+cX1eFm7Hmfsuk9x2Sz4zh/azr9Etve7Bby8nIG+zqsq6/L9AkyG1pui7I+pP0zP1XXe3T7LPc3o4GjhDz9+kTXeMvruP117f5zRxy4/zg==
    lx7LFCblaWXZDB/Lehnv73fbZVWTd08voPum+Omhm/z07J7HzXDn6+ny6GM+XYJMc31z+et2dva+6rbjBYe/zo/H+Z5kd8uuVlV5ezew8WpjoF9F3n2afuxu+QnjE8ZnbPqR7w==
    R8to9unheYwvYy/miWVMPI/JZUw+j6llTD2P6WVMj2N3T0ffVWXz6Wr15XEcP7RV1T764odn/Kuh2QnTVeafvds8za7yp/Z+eDV3xMbJx9cSinzIl8uiV4snir/RZbzs3ZdExw==
    7VO9e76j/deseFX2w9Yf8y4f2m7B/j1hTE33vMMNsfgTBfYXf4jz3hdzIi3/2fH+/wAAAP//AwBQSwMEFAAGAAgAAAAhAJrCvMMRDgAAiH8AABoAAAB3b3JkL2dsb3NzYXJ5Lw==
    ZG9jdW1lbnQueG1s5J1bbxw7coDfA+Q/DPQcWrwUySpjfRZVvGz2zchuHvI4lsaWcEYzwszYPkKQ/77Vulh2bG9aOlpMwgiQ1D3drG6yPtaFzeb84Y+/Xa0Xn1a7/eV28+bEvQ==
    sieL1eZse365+fDm5N//2g2eLPaH5eZ8ud5uVm9Oblb7kz/+8s//9IfPrz+st/v9cndTt2cfr1abw0JFbfavP1+fvTm5OByuX5+e7s8uVlfL/aury7Pddr99f3h1tr063b5/fw==
    ebY6/bzdnZ966+zt1vVue7ba7/W6Zbn5tNyf3Is7+22etPPd8rMWngTC6dnFcndY/fYowz1ZSDylU/xekH+GIK2hd9+LCk8WlU6nu/pOEDxLkN7Vd5Li8yT9oHLpeZL895Ly8w==
    JIXvJeHzJH2H09X3gG+vVxs9+H67u1oedHf34fRqufv147VRwdfLw+W7y/Xl4UZl2vQgZnm5+fUZd6Slvki4CudPlpBPr7bnq3U4f5CyfXPycbd5fV/efCk/3frru/L3/x5K7A==
    5tT/rsiDcbit+elutda22G72F5fXX3r41XOl6cGLByGf/l4lPl2tH877fO1mdpefmad615SPAufc/n37X63v7vzvS3R2hkYmEV9KzLmFb6/5cCdXSuHjhZ/VNF81rptpQB4E+A==
    7wSk/eppIuK9iNP9zdVjF/18/eH3aflPu+3H60dpl79P2p8f++znyYs+QdY9LV8TvP99N/OXi+W1duWrs9d//rDZ7pbv1npHqvuFqm9xq4HF1EtOflEff749e6u2b//V9lebbw==
    d9POZnmlJV5/Wq7fnLQce+7oKFOEBiI+BrA1hMItOC8np1OJs+Vh9WG7u/nvpf+02qx2y/XdSR+W6/Vqd/Nw7Hq9PFtdbNfnq910/PRbKYeb69XtTU4bD0XevXu7PvvX84fzvw==
    nPNudbH8dLndfbPzUOhsuzmohbkv882pHz5enj+c9p81FaRevWk9BwMhskHXyRTrWA9Jysz/dS/lm+a635Ht+e2dX6tEjb7O/+3NibUNovX55OGjunq//Lg+TEeqjVzLw5G3Xw==
    fXQr5E709V8ON+sn6eL0S9mpAW4v+nY3Cc8YWqm3wnf3J3wj/O2jOv66+u2hue5PPfxS1pdnvy4uVrvV4rDViPKw2i3Ugx5e3Sri7ty7q3/dQHdt8rg/lzqoVVqLFIQ6ADBzFg==
    cBQ4peBcTuNQB6rUUpw1FmozWlUyUtK0RZw9YyrRH5e6Obr4KXXgg/Cd5fnfTx1FbXDt+BnIQu4Rs2AjtNlLrh7CONRZIa2ga6Z4AgNIzkw1NZ70bwdL3efjUjdHF2NQB1LENQ==
    ESqtAGIQQKgeSWIXm1wdh7oItlNq3lDLrB62N8PdoqmgpsT2XCOlI9u6Gbr4KXX/pzys5dZS7oQULWDXurIaBJ9r8RJjjuNQ16mk6H1VC9eKAZuiQUjB+OJbrQ5LTu641M3RxQ==
    GNRRR8u+V7aY1cskjaolSvDdFwskOA51XiznKM247KIB9mRIKTAiKcRuk80Nj+xhZ+hiDOpa6XFKkrSGBSpZpJwZQ4q1WWQayNaV6gJUsSYSaA6bNJuVUK3xEkBq9S62euQcdg==
    hi7GoE46i3O+ImGAmJG8RtaVm4YTljSsGIc659GTVTPnmrpZqK4b5JJNhG4j6bEO7bjUzdHFGNQFrRl7YYmVgDNztaH5krMtmWvLA1EHSVPB6E0PTrMJkKTOFdXhFtQQ3teiDg==
    7rjUzdHFGNQlCj2oGqCBh5qKlJCROTlbMSDwONQRQeyaEJoSbDKAtRv21hko3TGiz2TLcambo4sxqEOh5iDXXqp6GAqI6BKkiL1hFE/jUBcTFMkejGcWjetcUQ+LwVhwllOdng==
    ARw5h52jizGoi2y7Gu8C4D1k1zg1sNmVoi6nhNrGoS6Ac5wrmVxQbR1oSoE1N9NT9BZDSez6cambo4sxqHPNdWmllcIEuWl+jmid9DB1fmA7DnWgsboXKyZ1IfWwAEaTRN2Nmg==
    XRSsFpocl7o5uhiDuuSAHNXYNdKGxIm1dhpH5JRFXPEDjdepF02eIpus0dM0cqIe1vlmMDkN4ItQbUd+NjFHF2NQFzAE0V/NlTx4F7DETODEQ+9JRrJ1xWHVzNWqX6WJOg3phA==
    SSHEjNBJc8djUzdHFz+lDlOsEJ5NXbvlbLm5Wdy35+JwsTwsbrYfF5+X0952sVtdr5aHf1lcbs7WH6c5zovtQTH9UmD6v9uu968W/6GlzpabxXK93+rp+9VuEne5fzhlsdxtPw==
    bs4Xh2n61GK3/bzXsxbb3fmE+sOFFtfa6PvF9v1ieXfiP6YDaOiSAyHVqjF0SUhd+7lGOHI7AygNlNg0FyhFIlMyTQ/nojp7i96Aa1ValNblyInNHF2MYXZzixxjw15TgeIbsw==
    htIi3nYsEnGg6S+BYlZCquEQuppd3ULJ1hRWO6em11d7ZOrm6GIM6gJix0bMaC3E6DmT9rPcOsbQOA9EXc6TDjWxcWSzJjYhq9vHaqRxE8jZZzhyYjNHF2NQR7VAJhu95QaJHA==
    dw2k2TuOqYUmfRzqKhTNGdSllgSaTveqIWbwwfTkIqbUfbBHfiQ8RxdjUAdVAEX7Vyui8XNE1UxAlwJrmJPsSNNfcnCcgsZ1UlFtnfca14ViGlhrnWuUCI49rfl/1sUY1HmuUA==
    IYbAmIAbav/CJKIpJ0Xnuh/Iw6I4F6WYnqsYKOIM3w4ddkRqFm0qdFzq5uhiDOqyVidpfKMm3YHad0rJW18wcXGlohuHupinLFYxy1I1c21NDENsmle0FkuWQvnI01/m6GIM6g==
    LE5RNmkcGzJEFi5sXW+gfoe1KgM9nIuUU5TA0yNhNpARNJFQ00fT60TowYV45Fc45uhiDOrQt14jYsaIEDTF8xy17i1zSxpTwEAetjI1EjC2QDJALhm1brprK+boq63+yI+E5w==
    6GIM6hLHLtGDBSnAtUtOLnhBcBY1gZdxqCvgSsbWDdRoDSh7BrMvhlXV3Tqm40+6mqGLQaizTlLBkromUKDmAK2rGlrbFCJgG2i8Dh31JOhMitP0lzZNa24sxuZAUkVCJPtk6g==
    vJogjD+i7lseb6m7/+jn1M3QxRjUYXNWI+luc9VYAiJ2bf7aOBbXOqaRJiKUlKoUTSQqT5PpSzQiMZteLBJ51BT36bbuRambo4sxqOtRs6XYKlhx+hvJ5RoKp9hy9WRHeiKm3g==
    ixuTcVHUzfbIZgqbjMSQKYq1thzZ1s3RxRjUlSQ1Je4MpQOT025PmHoRsVRIBnqFI/pWfOhTXKc5BBCn6SVdTSm0/gUAIfPTn4i9KHVzdDEGdS0JueYx+JKAoYk25DQNkxNBYw==
    HGjOiU2Usg3OOJ5G6YoCJ1pDQw7U+eI0d/jItm6OLsagLmrA2hI2ZJ8BHTNUzZlSRdts8TLQKLGmqtQ9e+PEk4HU1dapczXZcc2uh8709OWlXpS6OboYgzpuJDL1K+374HvE6Q==
    pQHvXQte86aRpjWrFQkyTaEHqzkEiGhIV0owrbo8pYsEEo9L3RxdjEFd75WdF03pWoCuLR/Qq03nXpKPOQw0Xtdcg9wpGsqkHrYna9hP6PXQfG6123JkWzdHF2NQpym596Ixaw==
    hgyFNGxFBKQmGtnq34EWv7Douq9STPbdGc0dvGEI3fjpxbBabZNnPId92bhuhi7GoA41gXOpocbUBLEFtNJra5BsDLX3gTxsBWshlGa6T35aXoo1kfAa14GDGKlkdE+fc/Ky4w==
    dTN0MQZ1thDn0FxyWj2nTibl4Cz16FPKFQeydcFam9A6w7lEtXU+qq0raErnVGB6ZS3441I3RxdjUBeqJuYhd2mVwWXCWEKdMrqcu+U6kK3DKE4xcSZRnEaJp8VqW7MmeY+UoQ==
    xpKePqvzRambo4sxqAMMJWcXqTNo9gRoew2TbbcxCtNIo8SghJAtpvC05EoFNqJ5hGlqTyx4V1J4+pyTF6Vuji7GoK5Og94hTusXEZTm2EUAW1unThjyQNR18DGQ2jqhMA2fYA==
    N1LQG9+i9yF2qfXp74i9KHVzdDEIdZRShNpLbwSVMheNuNFx6MQ1+4GWl+LCWdBZU8L0QjgHtXWZk7GOpkmUiekZC3O/LHUzdDEGdRo0OMgtS8sAybnpyyEc1SIQQ8q+jkNd0g==
    jFBCDUbDOKUuQzZo9U90XD0kofSMZQheNq6boYsxqCsS2zRxMJdeAROIJ8RSYHoxyfYy0HNYbzlRtsHYOC0H76QZFiFD6tECa67Y0tMXcFQTVDD9iLpvebyl7v6jn1I3RxdjUA==
    B2Gac9Y1kvaggY9gQmFN1Rv5ahMN9D4s+A7JejDJNaWOJBmKqRuyUgJzqAhPHzl5Uerm6GIM6kQ0kMCMKd+OoVoG5tIdQEghhjzQEzGvkZuoJZlW4p6W0tMIT6YtnNarY43d7Q==
    M7764kWpm6OLMahD72ptsVa15VDL9HycSnSxN59irmUc6mqt4nrKpoYy5bBSDMauKW1VV6YVtkLPeFtHdS34I+q+5fHuvYm7j35K3RxdjEFdTYFa0OraNK1WGZhc8bZZycmX5A==
    RlrUDGvK1Xsj1sH0RXrVMFpvmHPUgE+6d0/3sC9K3RxdjEFdBHHQUJvdVXAYWLRr5ewKMGjCNdATMS7UfSnepJRoegvbGurTirWo7GComis+3cPe/fyIOrKupi883lJ3/9FPqQ==
    m6OLn1InwZXink1du+Xs/+FSer1razfWgIYiIETWpJJdi2QrB1sG+ibJ6Jp3TtMZTXCmNcJB/bzkbtSkgSarQviMyfQv2gHm6OIf1QHuzK626mF5/QLW93F7f7vzYb3d75e7mw==
    ev991r/8DQAA//8DAFBLAwQUAAYACAAAACEA0nc7M/UAAAB1AQAAHAAAAHdvcmQvX3JlbHMvc2V0dGluZ3MueG1sLnJlbHOMkDFPwzAQhXck/oN1EiNx2gGhqk6HFqQOLDTdsg==
    HPYlcevYlm0g/ffcUolKDEynu9P73tNbb+bJiS9K2QavYFHVIMjrYKwfFBzb18dnELmgN+iCJwUXyrBp7u/W7+SwsCiPNmbBFJ8VjKXElZRZjzRhrkIkz58+pAkLr2mQEfUZBw==
    ksu6fpLpNwOaG6bYGwVpbxYg2kuk/7BD31tNu6A/J/LlDwuJpSDrTUtT5DsxG9NARUFvHTFdblfdMXMd3Ql1+Pg+dTvK5xJid7Assb0l87CsD+go87x6VSaU+Qp7C4bjvsyFkg==
    RweyWcubspofAAAA//8DAFBLAwQUAAYACAAAACEAeqhydMUAAAAyAQAAEwAoAGN1c3RvbVhtbC9pdGVtMi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAACsj0FqwzAQRa8iZl/LzSIUYzsEkiyTgtusupHlsS2QZow0Kc7tK0KbE3Q5/Mf7f+rdGrz6xpgcUwOvRQkKyfLgaGrg8+P08gYqiaHBeCZsgBh2bd1XHd+ixaQ69GgFhw==
    Tu4+x1/7933nVpmPg5OsvIyjs3gh7wiLNXlQD/BsQoYzC+r6170FlbdQqvoGZpGl0jrZGYNJBS9IORs5BiP5jJPmh/jA9haQRG/Kcqt713vHUzTLfP+V/YuqrfXz4fYHAAD//w==
    AwBQSwMEFAAGAAgAAAAhAPzVBSXgAAAAVQEAABgAKABjdXN0b21YbWwvaXRlbVByb3BzMi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAnJDBag==
    hDAQhu+FvkOYezZRgtrFuEhdYa+lhV6zMWrAJJLEpaX03RvpaXvsafhmmPl+pj59mAXdlA/aWQ7ZgQJSVrpB24nD22uPK0AhCjuIxVnFwTo4NY8P9RCOg4giROfVJSqDUkOneg==
    6Th85U8FLbqyxG3JGGZV3+I26xk+Z89dXpSUVTT7BpTUNp0JHOYY1yMhQc7KiHBwq7JpODpvREzoJ+LGUUvVObkZZSPJKS2I3JLevJsFmj3P7/aLGsM97tE2r/9ruerrot3kxQ==
    On8CaWryR7Xz3SuaHwAAAP//AwBQSwMEFAAGAAgAAAAhAB8e/OwFAgAAcAcAABMACAFkb2NQcm9wcy9jdXN0b20ueG1sIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAxJVLi9swFIX3hf4H422RLTl+k2SaZwk0JTRpt0GWrycCWzKWkk6m9L9X7jQTvCp4MN1JSDr3O+hcafzwVJXWBRrFpQ==
    mNjEwbYFgsmci8eJ/e2wRrFtKU1FTkspYGJfQdkP0/fvxrtG1tBoDsoyEkJN7JPWdeq6ip2gosoxy8KsFLKpqDbT5tGVRcEZLCU7VyC062EcuuystKxQ/Spnv+ilF91XMpespQ==
    U98P19roTcd/xa9WUWmeT+yfy2CxXAY4QN4qWSCCyRwloyRCOMbYm3uLdTJb/bKtut3s2ZaglbG+3W92x880g/JY+B6lI99DcYRD5HtxjLKcEARZFgdJEmAvZseVoFkJual/0Q==
    aVn/ULqZHpozjN37fOze2N5IOepLuecaNl3IyCuSOM4KFIcFQT6hBUoIzZCXRyzHhOSZHw1iwu9r4isUHQdtbpQJDq25w8VLXkzADZwG1o4c+nxuwGGyave4/81x0PvaQM+vHQ==
    zxekgNNn+bHirJFKFrq1Nwh1+AbqJdXQ4fYwMVVCU+hASBoEKfGdkOA4DMMPeJRiPIiFqK+FL+ZUh/8TCGhoOQhl3JdyVtclZ39C34Hd3rJhzdoGsDb35rB2r90xiJek9zv6pA==
    QeSQH7f79eG4BX2S3fdqdjY/iPHABuEm+Aa+B6G45heuu533jwS4969y+hsAAP//AwBQSwMEFAAGAAgAAAAhAHQ/OXrCAAAAKAEAAB4ACAFjdXN0b21YbWwvX3JlbHMvaXRlbQ==
    MS54bWwucmVscyCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMz7GKwzAMBuD94N7BaG+c3FDKEadLKXQ7Sg==
    DroaR0lMY8tYamnfvuamK3ToKIn/+1G7vYVFXTGzp2igqWpQGB0NPk4Gfvv9agOKxcbBLhTRwB0Ztt3nR3vExUoJ8ewTq6JENjCLpG+t2c0YLFeUMJbLSDlYKWOedLLubCfUXw==
    db3W+b8B3ZOpDoOBfBgaUP094Ts2jaN3uCN3CRjlRYV2FxYKp7D8ZCqNqrd5QjHgBcPfqqmKCbpr9dN/3QMAAP//AwBQSwMEFAAGAAgAAAAhAFyWJyLCAAAAKAEAAB4ACAFjdQ==
    c3RvbVhtbC9fcmVscy9pdGVtMi54bWwucmVscyCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMz8GKwjAQBg==
    4PuC7xDmblM9iCxNvSyCN5EueA3ptA3bZEJmFH17g6cVPHicGf7vZ5rdLczqipk9RQOrqgaF0VHv42jgt9svt6BYbOztTBEN3JFh1y6+mhPOVkqIJ59YFSWygUkkfWvNbsJguQ==
    ooSxXAbKwUoZ86iTdX92RL2u643O/w1oX0x16A3kQ78C1d0TfmLTMHiHP+QuAaO8qdDuwkLhHOZjptKoOptHFANeMDxX66qYoNtGv/zXPgAAAP//AwBQSwMEFAAGAAgAAAAhAA==
    wpXtpAIBAABVAQAAGAAoAGN1c3RvbVhtbC9pdGVtUHJvcHMxLnhtbCCiJAAooCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABckE1rwzAMhu+D/Yfgu2sn/QolTg==
    SRYCPQ3WDXYrJlbaQCwF2ykbY/997nbqTtIjIb2vVOw/7JhcwfmBULF0IVkC2JEZ8KzY22vLc5b4oNHokRAUQ2L78vGhMH5ndNA+kINDAJvEwhDjoVHsq26qdZpVkm8b2fBVFQ==
    szrP13y13GTttm43rVx9syRKY1zjFbuEMO2E8N0FrPYLmgBjsydndYjozoL6fuigoW62gEFkUm5EN0d5+25HVt78/E2/QO/v8WZtdoNis8OdHTpHnvrAzSfqSJ6jvgoHE7ngxQ==
    8fdUZ05HPYI/PTsD7vRE2It0KdeCibIQ/6RufPeK8gcAAP//AwBQSwMEFAAGAAgAAAAhAAj0bRAjFwAApbcAABgAAAB3b3JkL2dsb3NzYXJ5L3N0eWxlcy54bWy8XdlyG0eWfQ==
    n4j5BwSfZh5s5b44Wt2R69jRXtRNefoZAooixiCKA4CWNV8/twogBSqrkMhClcOLRADn5K2866kF/Mvf/nhYz36vtrtVvXl7g79FN7Nqs6iXq83Htze/vo/fqJvZbj/fLOfreg==
    U729+Vztbv7213//t798+m63/7yudjMg2Oy+e1i8vbnf7x+/e/Nmt7ivHua7b+vHagNv3tXbh/keftx+fPMw3/729PjNon54nO9XH1br1f7zG4KQuDnSbC9hqe/uVovK14unhw==
    arNv8W+21RoY683ufvW4e2b7dAnbp3q7fNzWi2q3g4N+WB/4HuarzQsNZgnRw2qxrXf13f5bOJijRS0VwDFq//aw/kLAywhIQiB2VRkFP1K82X1+qP64mT0svvvh46bezj+sgQ==
    CQ5pBlbNWuKbv4I3l/XCV3fzp/V+1/y4fbc9/nj8qf0j1pv9bvbpu/lusVq9ByuA6mEFrN+bzW51A+9U893e7Fbz0zfD8bXm/fvmg53IxW5/8rJdLVc3b5pFd/8Hb/4+X7+9IQ==
    5PkV1xjx6rX1fPPx+bVq882vt6fGnLz0AXjf3sy339yaBvjmeGyHP0+O+PHrn9qFH+eLVbvO/G5fQaxigRrS9apJDcL18w//fGo2ef60r4+LtASHP19o3ySbDiEMAX17yCt4tw==
    uvuxXvxWLW/38Mbbm3YtePHXH95tV/UWcuftjW7XhBdvq4fV96vlstqcfHBzv1pW/7qvNr/uquWX1/8R2/g/vrConzbwdyp5Gwjr3TL8sagem2yCdzfzxic/N4B18+mn1ZfFWw==
    +P8+k+GjJ7rw99W8KSkz/DVFa34RBWkQu5Oj7eZ8+urY208VLUT/rIXYn7UQ/7MWEn/WQvLPWkj9WQu1NFMutNosqz8OiZguk7DmeHqysZinJ9mKeXpyqZinJ1WKeXoyoZinJw==
    0It5euK4mKcnTAt49vWiLwpPgp32RPt53nyPGMabbwnDePMdYBhvvuAP483X92G8+XI+jDdfvYfx5ot1Oe9h1Jr9AGm22V+dZXd1vd/U+2q2r/64nm2+Aa5WZ43D1zS9ajvKQQ==
    jkBzqGzHRnw122Le/pyPkDZJh/fzfaPoZvXd7G718WkL8vxaw6vN79UahPJsvlwC34iE22r/tO3ZkSExva3uqm21WVRjBvZ4pI0SnG2eHj6MEJuP84+jcVWb5cjb98w4SlF4CQ==
    aNDP902SrEYI6of5Yltfb1o9H60+/LjaXb9XDcnMPq3X1UhcP48TYi3X9dqgpbleGrQ01yuDluZ6YXDis7G26Mg20k4d2UbasCPbSPt2iM+x9u3INtK+HdlG2rcj2/X79n61Xw==
    tyX+dOrAl5+7c+u6OTN+tR23q4+bOQwA17eb4znT2bv5dv5xO3+8nzUnprtpT4+5dB1bLz/P3o/R016Yxprr2xBxcNSrzdP1G/qKbazkeuEbKb1e+EZKsBe+61PsJxiTmwHt+w==
    cfTM7dOHfWfStkwXJe3tfP10GGivz7b5/voI+5IAcbXdjZYG3bQjRPDPzTjbuHOMyvfFyusN+8J1fVp9XZVGNe9IOYKV63rx2zhl+PvPj9UWZNlvVzPFer2uP1XL8Rhv99v6EA==
    a6cpT1qXXJTy4eHxfr5btVrpFcXlrf75mvrsp/nj1Qf0bj1fbcbxW/jmYb5az8abIL5//9OPs/f1YyMzm40Zh9DW+339MBrn8Uzgf/yr+vCf4xhoQARvPo90tGak00MtmVuN0A==
    ZA5M9XIkJhgzV5vVKD205ft79flDPd8ux2F7t60Ot7Hsq5EYb+cPj4ehY4Tcgrr4CerPCNNQy/ff8+2qOS80VlK9H4Xs5LTh7unD/1SL60vdz/VslDNDvzzt2/OP7ajbosejuw==
    fkx4RXf9iNB6E9pDE78jHOwruusP9hXdWAfr1vPdbtV7CXUw31iH+8w39vFeL/6OfPW63t49rcfbwGfC0XbwmXC0LazXTw+b3ZhH3PKNeMAt39jHO2LItHwjnJJr+f5ru1qO5g==
    jJZsLE+0ZGO5oSUbywct2agOuP4OnROy62/TOSG7/l6dA9lII8AJ2VhxNmr7H+kqzwnZWHHWko0VZy3ZWHHWko0VZ9TPqrs7GILHazEnlGPF3AnleI1ms68eHuvtfPt5JMqwrg==
    Ps5HOEF6YHu3re+a5xvqzeEm7hEom3PU6xGH7QPdWE7+V/VhNNMarjHtGuGM6Hy9ruuRzq19aTgt8vW9azlY+yTH1Sa8W88X1X29XlbbnmPqx4Jevj08lvG1+a0ZF532/HH18Q==
    fj+7vX85239KI1AW+SzYX8HyC3btuXh+nqUL9lO1XD09PBuaPkwh6OXgNqJfgVke/GWSeIXkFyLTNUUe+WVKfoWUFyLTNdWFyDZPXyHP5YOfb3/rDAR5Ln5eNF5P8MlzUfQC7g==
    XPZcIL0gu0JQnouiV6kyM4tFc7Ug9c5lOdOPvyx5+vElWdTPUpJO/SwX51U/xbkE+2f1+6rp7CVFs13v5e6JpO63Q/RFlfMfT/XhvP2rC06XP9T1AwxOm1016+Shl1+4elVl+g==
    9/HictNPcXHd6ae4uAD1U1xUiXrhRSWpn+Xi2tRPcXGR6qcorlZpRyirVim+rFql+CHVKmUZUq2umAL6KS4eB/opihM1pShO1CsmhX6KokRN4IMSNWUpTtSUojhRU4riRE0HsA==
    skRN8WWJmuKHJGrKMiRRU5biRE0pihM1pShO1JSiOFFTiuJEHTjb98IHJWrKUpyoKUVxoqYUxYnazotXJGqKL0vUFD8kUVOWIYmashQnakpRnKgpRXGiphTFiZpSFCdqSlGUqA==
    CXxQoqYsxYmaUhQnakpRnKiHRw2HJ2qKL0vUFD8kUVOWIYmashQnakpRnKgpRXGiphTFiZpSFCdqSlGUqAl8UKKmLMWJmlIUJ2pKUZyo7cXCKxI1xZclaoofkqgpy5BETVmKEw==
    NaUoTtSUojhRU4riRE0pihM1pShK1AQ+KFFTluJETSmKEzWlOBefx0uUfbfZ4/Kznr137F9+6epo1D9PH+U+paKXUz1b1c91+bMItq5/m3U+eEhbvXEZyerDelW3p6h7Lquf8g==
    trdEFF34/MWdf8LnlP3KL106PgvRXjNNyNmlyOScCjsX8qfIROSxc5F+ikymTnau+p4ikzbIzhXdNi+fb0qBdpSAz5WZEzDugZ+r1ifwdIvP1egTYLrD5yrzCTDd4HP1+ATIZw==
    TXH+Gs0v3Cfxcn9pwnAuHE8YZD/DubBMffVcjtPEuNRp/QyXeq+f4VI39jMU+bOXptyx/VTFHu6nGubqNM1KXT08UfsZSl2dMgxydUIz3NUp1WBXp1TDXJ0WxlJXpwylrh5enA==
    +xkGuTqhGe7qlGqwq1OqYa5OW1mpq1OGUlenDKWuvrIh99IMd3VKNdjVKdUwV6fDXamrU4ZSV6cMpa5OGQa5OqEZ7uqUarCrU6phrk5UcrGrU4ZSV6cMpa5OGQa5OqEZ7uqUag==
    sKtTqnOubs+ivHJ1kYdP4GVD2AmwrCGfAMuK8wlwgFo6QQ9USycMA9VS6qtnn5eppVOn9TNc6r1+hkvd2M9Q5M9emnLH9lMVe7ifapiry9RSl6uHJ2o/Q6mry9RSr6vL1NJZVw==
    l6mls64uU0v9ri5TS12uLlNLXa4eXpz7GQa5ukwtnXV1mVo66+oytdTv6jK11OXqMrXU5eoytdTl6isbci/NcFeXqaWzri5TS/2uLlNLXa4uU0tdri5TS12uLlNLva4uU0tnXQ==
    XaaWzrq6TC31u7pMLXW5ukwtdbm6TC11ubpMLfW6ukwtnXV1mVo66+oytfQTQFYjfAXU7cN8u5+N931x38939/v59V9O+OtmW+3q9e/VclZ8qG8+vfqdVc0a7W+Fg8/v4UCbrw==
    LT95xmh5+NrWI2H7wR+WL79bqgE3Fs2Ov8Xr+HJr+PEa62HFFpgutbiHtRbHL5zqWer4xbEvTz61Xxv79cI93y7bGvIlap4/fdzaL/t1+Nyr3Tpr976J0jM2t1F8do8Ogd5noA==
    PmZuzkKw58P68HvO4C8/bJZA8On4O74Oli7/mB+o4H1Xrdc/zQ+frh/7P7qu7vaHdzFqv2fgq/c/HL4yrxe/bWtrL8Gb18Ycfjz+rrWe/T58if7xon9vSDYFpGO72ztQrt3pCw==
    Y/jFmpPHo9uno782K3l8+rCzc1jtlybPT6P6deiXHch2t2qCov0IQhph/3z30fH3Ay6aQvv8CYWaf45Oev4lez3H/apMLJ52EBJtRfnaL8wHhykLQajAhMOWOW61dcZZoaI6/A==
    ArvTrckCOg7MI268Oxp+pcGGS+WIjw4FxLTQVghYXsRIQvRah8TgLGBigznSUkausIVtozjoEKhiFmmuhLfgz68NzgImNlgTJDQ2CNlowMNGB0MpZpbRyE0IODE4C5jYYK9tEA==
    AVPLGWPOcq0dIlwEFIWSPMi0H+UAExvMEESfoxrWxAzSSBvkGYnOWu6liTpNuhxg6h1myMkYOUNUMhWllkETCEymqIE9TA3OAiY2uFnRUhGxiYIJ5BR2zjqOqWaEaO4Tg7OAqQ==
    k05wFYQLMlhY0UA+YceDdhIHgrQTadLlAFPvsAiEIIuic5x54TVFkpjgGCwvJU2rRBYwscFB8iijwlpqzgKzlnDKkKfUmUAxsYnBWcDUVcJ7GwLX1OoIdcoYIy3DmhohKMYyDQ==
    iSxg6hjmxChGuWQasaaDSauCVuBmKz1hNI3hHGDqHbbO4mCtdhCGSlHLFPNEacujRQKnVSILmNhgBO1UyKiV5gjKKlhgZMREekcs58dfN3xqcBYwdUhEhQyJ3iAlGdJCWWG5pQ==
    BLoZDGNWpSGRA0xdJVzkTYbDuo55jRTMYkZRwX1Ayuh0h7OAiQ2GmctiTLzSijIYdTVRkXkTICqRhuhMDM4CJjaYwnqGWAOji2ZGGuMRDcRJCROD8R3TWhYwscFC0wjzrIEeQA==
    oHHBWEClMkZg5BUM5iYxOAuY2GBldcBMguTxkQVNlVIYhhquYlDcknRaywImNpgbFMGRjsGsxWCAMSIwJGECI9456lNNlwVMbDAOONoATQDEDoPR1sKOIWwj9TAfMJNquixg6g==
    kEAxUBDuRIjIFGn+BXnJLAgeDDNYR0jkAFMnnZeBwLgFUy2MXk5oCXJdcmMQhfHGpXU4C5jYYOmDh5gkxjHJKAoKXCwV5mCHtVinVSILmNhgwpWgXhMdpGCUOGukRsEKJThCTg==
    pwN8FjC1wdD/I4uUMKIYtxCOINCge1HnsBYmpgbnABMb7LgnnDsBPVZCJ+Aw2YKWFMhChYqgMRODs4CpZwkvPbVCMCMM40IbhCD9Q2z6g1OUpLNEDjCxwQYj5jn3mCDDMIIRgQ==
    CYewBtnDhOwIiSxg6k4XHSOgdFCUkjFprFGcwcTrkMUc/kw7XQ4w9Q4LJRElGsMYwLAQGgkPFZZHISUhOJ3WsoCpGwdmGmsPgkx6Jpq4NAgGLykkVFVHUsWRBUw9DytoUPAfjA==
    tFCoMFWOS9g5S1iMwnbMElnA1GWNeklBUXoPQ6ITSkfYLZjDbHvCRKSzRBYwdWsO3HAeVIRZnDkSYCaQ2FqConKWq/S8RBYweUiAVA/aGIUQ45xAo4WNk1BXOQ1GpgZnARMbrA==
    PQwxGnGoqoE11wIi5I8h2HABU6RN63AWMLHBzFsGTcrAKGshbbiC/KcgeqiJFguUVoksYOrhx3jmGafUKOi2QcGGKWGt8lpzjGPamrOAqZMOFhHKNxcJMTQurYUgiDgljMPOqw==
    dLzMAiY2GCkpkdSQSVQyDo3WQR+IAUQ8grFGpiI0C5jYYNVcwOSNaOCKUYssMRwsCtIEAaHJUk2XA0zdmg00WU4YAn3GjIeGKzAlVsEgBmoYpWfgs4CpY9hEzIhFHmvGgpUwJg==
    IqQjiSRgjjquNWcBHQYHxhFpx6LrDfYuWAIyJxoYDUD3KEgdwoPhDhQw5FJicBYwscHBgdrhmFvoAYxRbWHTEHg6EGVp1GmnywImNphhp7UiMMxCSDoMQ00MzfneaLzh1KUxnA==
    BUxssAbZrpvrmiLE5nSZ5qDSwAImsQQdlBqcBUxscFSwY0Iy6FuQ9LQ56W+8t1jFGCzrurCYA0xsMJKOgAY2zkXLNIX/SShU3ERGjFM+bc1ZwMQGY4EDyDItUBRMC6yRMxpBOA==
    YlDBIC3Ts5c5wMQG8yCt4F4oxSwkPTfaC4pA/BgiQWamJwOzgIkNhnmAaoQp91IxBWMN8ZpSRrSS1ruOe36ygIkNdswLTo0hVAemZVNXsXXeKO84qPe002UBU1cJAgOicSKqpg==
    02owwcKAi4RVWEPDTU+kZAETGwzDQPTaCgx9lTkLqytQaxGKrPag0tI6nAVM3emYMdJHpriEKSZAxyVcCIUxx8pJlsZwFjB1lbAe8t1riRsB4STINU9w9EwSBWW14ypSDjD1Dg==
    I8GZZlyiSJiwztgIUekJhfEW8Y4Li1nA1FWCy8g95cEFyhS2CnkbCHcCIap1x52BWcDEBqvmFjmEPSRMgBxq7nnA1OhgowThLtMYzgKmNphy0AyRIAqdFsQMZDwmyFEXHHhapQ==
    VSILmNhgojgIrigDV5hpRZXGhnMJ8oxI+DMVoVnAxAaDPrQwi5voqWNN/QflEEBBgDpzOKh0+MkCJjZYw8ziGSzqOWceEQWDOcWca02IQh3DTxYwscEChpZgnXTcwmiADSxLIw==
    VhgEZojWdMj8HGBqgxG2wimYDTxMi95oyCEPFRUJypkKqQjNAqauEgEjkJMRSQ+DI+MqWpgcG9WOQ1QilflZwNTTGmdM8uAZsiAYLNdYQjYZAXO6JxqlO5wFTD2t+Yg9jZrAFg==
    gbB0mnJLNQsINLykHVUiC5jYYAMVqjkzTQn415EAI62iQtkYqIWBJr1ZNAuYeodhrWAVty4wBsMMLIo4ES4gHiiI43SHc4DJhx/NIiheTRFmhkD6w9hFGukDFRbKbcfwkwFMHQ==
    EsFHEyQsaKEPGAyFiRmEmLUaKYo6npTJAabudERJLxC1IQYmEWtWtdpQiwlI4Y5ZIguYOiSE9RB50TAXmdFYaa2VaEdI7bRNL45nARMbHITVGCYDSpxgEIMWpgNikTUCSpVR6Q==
    pdssYGKDOTTW5kkzBTMNCAhjmFcMCxDuUFmJTRVHFjB50mlrm41yQTASuWruSyQEB0pgNOi4/SALmLo1R8h0YplvJFrUzFJFwL8mOpDvsuO8RBYwdQxHRYiFrJFMMqchcUDEKw==
    kGiQW/D/jju0c4CppzUhHBYBhE6j3QNVyEYfAhOIUx9jx7SWA0xsMHLaSBqas76BYQRjl4TOpSN0WyF9xzOhWcDEBlMPBYnKaIM3DEutuKMeRxqljKDU0h3OAiY2mCnqpMRcQw==
    J4DUB1kJ6rLxM+LcGp02jixgYoN9050ob26418wFbDAM6MiHqCNoeNnxiGUOMLXBWggYYqKLQTen+Ixj1EE/gBHdeNlxfjgLmNhgQRQPRggP+pcJEbTAoH+gH1BjGcbptJYFTA==
    3ZoJBKXn1lODGMy0RlPrGGmeMELQgdOkywKmrhJRYiaDtEGCfsBYR0+w9iCCOBWSpE/KZAFTj5eWh+ZuB+miZ0owS7RSzrHmpiMUO27azwI6DCYKs0OFHqGsQV11JAoaCWOEQw==
    z1XWQBMImngkdHobWBYwscEWxpiopBISZA51yDBjXGxuLBCUU9lxUSYHmNhgRbD3gXsPfoUJjIKzteOYx0AElz49L5EFdBgM5c6p9gTACHVYUA2jLAZ3NjcTUBA9jsAsbqUASQ==
    gdMz8FnAxAYzCcEokUEaQ5uF4h8ia7ZKOBOYUWkdzgK6qoSi4fAs4wh1mFnMghJaYs9wU/3BuTArONBrzTn1tA7nAB0Gf/lqkjEUBywcDGSPBoXDuIHib3DgzR0FFHU86p4FXA==
    aPDz33Z//X8AAAD//wMAUEsDBBQABgAIAGZgyEqw7MdJOgEAAEgCAAARAAgBZG9jUHJvcHMvY29yZS54bWwgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAClUs1OwzAMfpUq9zbJqo2tSjsJECcmIYEE4hYSbwtrkyrx1u3ZOPBIvAJt6YpA3LjZ/n5kf/LH27tYHqsyOoAPxtmc8ISRCKxy2g==
    2E1O9riO52RZCOU83HlXg0cDIWo1NmRa5WSLWGeU1ntfJs5vqFYUSqjAYqA84ZSMXARfhT8FPTIyj8GMrKZpkibteRPGOH1a3d6rLVQyNjagtAoG1agIPRySdlXbImvnK4mhdw==
    qKXayQ10TjNaAUotUdLusrgeTyOF0CpDgyVEtK/D/uUVFA6d8iDR+a7bwalxXocB0RCUNzW2OXaTUgZctTGuDejLUzfxcDBdygUXdKzFEMyXMeioPT/DUw05OSOP6dX1ww0pJg==
    jF/EbBaz+QNbZCzNeJrwxXSRzqfPgv7y+TauhiX+7Xw2KgT9+Q7FJ1BLAwQUAAYACAAAACEA3lCko68PAABSkwAADwAAAHdvcmQvc3R5bGVzLnhtbOydW3PbuBWA3zvT/8DRUw==
    +5C1JMt2nFnvjq3YdaZJ1hs5u88QCVmsKUIlqdjOry9upEAdguQBsd7OtJOHWKTOB+DcgANS5I8/P2+S4BvN8pilF6PJD+NRQNOQRXH6cDH6en/z5u0oyAuSRiRhKb0YvdB89A==
    809//cuPT+/y4iWhecABaf5uE16M1kWxfXd0lIdruiH5D2xLU35yxbINKfjH7OFoQ7LH3fZNyDZbUsTLOImLl6PpeHw60pisD4WtVnFI37Nwt6FpIeWPMppwIkvzdbzNS9pTHw==
    2hPLom3GQprnfNCbRPE2JE4rzGQGQJs4zFjOVsUPfDC6RxLFxSdj+dcm2QNOcIApAJzmFIc40Yij/GVDn0fBJnz34SFlGVkmnMSHFPBeBRI8+olbM2Lhe7oiu6TIxcfsLtMf9Q==
    J/nfDUuLPHh6R/Iwju95LzhqE3Pq7WWaxyN+hpK8uMxj0nhyLf5oPBPmhXH4Ko7i0ZFoMf/OT34jycVoOi2PzEUPascSkj6Ux2j65uvC7IlxaMm5FyOSvVlcCsEjPTD1vzHc7Q==
    4SfZ8JaEsWyHrArKHXVyOhbQJBZxMT05Lz982QkNk13BdCMSoP6vsEdA49x/uTcvVFDxs3T1kYWPNFoU/MTFSLbFD379cJfFLOOBczE6l23ygwu6iW/jKKKp8cV0HUf09zVNvw==
    5jTaH//1Rjq/PhCyXcr/Pj47kV6Q5NH1c0i3IpT42ZQIm3wWAon49i7eNy7F/13CJtoSTfJrSkQ+CSaHCNl9FGIqJHJjtM3M3cHY5bdQDR2/VkOz12ro5LUaOn2ths5eq6G3rw==
    1ZDE/JENxWlEn1UgwmYAtYtjiUY0xxJsaI4lltAcS6igOZZIQHMsjo7mWPwYzbG4KYJTsNDmhYazH1u8vZ3bPUe4cbunBDdu9wzgxu1O+G7c7vzuxu1O527c7uztxu1O1niuWg==
    agUfeJilxeAoWzFWpKygQUGfh9NIylmyyPLDE5MezbwM0gNGZTY9EQ+mhUR+7vYQGaTu83khyrmArYJV/LDLeG0+tOM0/UYTXiUHJIo4zyMwo8Uus2jExaczuqIZTUPq07H9QQ==
    RSUYpLvN0oNvbsmDNxZNI8/qK4lekkLl0Lx+XosgiT049YaEGRveNUa85YePcT5cVwISXO2ShHpiffbjYpI1vDaQmOGlgcQMrwwkZnhhYNjMl4o0zZOmNM2TwjTNk96Uf/rSmw==
    pnnSm6Z50pumDdfbfVwkMsWbq45J/727ecLEtvjgfizih5TwBcDw6UbvmQZ3JCMPGdmuA7Er3Yw1x4xt54pFL8G9jzmtIvla10sXmfNRx+luuEJrNF/BVfE8hVfF8xRgFW94iA==
    feLLZLFAu/VTzyx2y6IxaCWpV9AuSLJTC9rh0UaK4R62D4CbOMu9hUEz1oMHfxbLWWFOH5lv38vhHduzhofVYVby2j2N9NDLhIWPftLw7cuWZrwsexxMumFJwp5o5I+4KDKmfA==
    zQz5qTRJr5C/3mzXJI9lrVRD9J/qywvqwSeyHTygu4TEqR+7Xb/ZkDgJ/K0gbu8/fQzu2VaUmUIxfoBXrCjYxhtT7wT+7Xe6/LufDl7yIjh98TTaS0/bQxI2jz1MMorEIk8kvg==
    zIzT2MscKnn/pC9LRrLID+0uo+oeloJ6Ii7IZqsWHR5ii+fFJ55/PKyGJO83ksViX8hXUN17gRnbhvlu+S8aDk91n1ngZWfol10h9x/lUldK+8MNXybUcMOXCNKafHoQ/uthsA==
    NdzwwdZwvgY7T0iex9ZLqM48X8Mteb7HO7z40zyWsGy1S/wpsAR602AJ9KZCluw2ae5zxJLnccCS53u8Hl1G8jxsyUneP7I48mYMCfNlCQnzZQYJ82UDCfNqgOF36Biw4bfpGA==
    sOH36iiYpyWAAfPlZ16nf09XeQyYLz+TMF9+JmG+/EzCfPnZ8fuArlZ8EexvijGQvnzOQPqbaNKCbrYsI9mLJ+R1Qh+Ihw1SRbvL2Er8uIGl6iZuD0ixR514XGwrnC8j/06X3g==
    uiZYPvvlYUeUJAljnvbW9hOOlKzfu9YlJn/JMbgLdwkJ6ZolEc0sY7LL8np5oX6Wcdh92Y1e254f44d1ESzW1W6/iTkdd0qWBXtNrLvBJp2flr9naRL7RKN4tyk7Cn9McXrcXw==
    WHp0TXjWLbxfSdQkT3pKwjZPuyX3q+Sa5FlPSdjm256SMk5rkm3x8J5kj42OcNbmP1WNZ3G+szYvqoQbm21zpEqyyQXP2ryoFirBZRiKqwXQOv1ixi7fL3js8pgoslMw4WSn9A==
    jis7oi3AvtBvsZjZMUlTtlfdPQHyvlxE98qcv+6Y2revXXDq/6OuD3zhlOY0aOQc979wVcsydj32Tjd2RO+8Y0f0TkB2RK9MZBVHpSQ7pXdusiN6Jyk7Ap2t4IyAy1ZQHpetoA==
    vEu2ghSXbDVgFWBH9F4O2BHoQIUIdKAOWCnYEahABeJOgQop6ECFCHSgQgQ6UOECDBeoUB4XqFDeJVAhxSVQIQUdqBCBDlSIQAcqRKADFSLQgeq4treKOwUqpKADFSLQgQoR6A==
    QJXrxQGBCuVxgQrlXQIVUlwCFVLQgQoR6ECFCHSgQgQ6UCECHagQgQpUIO4UqJCCDlSIQAcqRKADVf3U0D1QoTwuUKG8S6BCikugQgo6UCECHagQgQ5UiEAHKkSgAxUiUIEKxA==
    nQIVUtCBChHoQIUIdKDKi4UDAhXK4wIVyrsEKqS4BCqkoAMVItCBChHoQIUIdKBCBDpQIQIVqEDcKVAhBR2oEIEOVIho8099idJ2m/0Ev+tpvWO//6Ur3akv5k+5TdRxf1TZKw==
    O6v/bxGuGHsMGn94eCzrjX6QeJnETG5RWy6rm1x5SwTqwucv8/Zf+Jj0gQ9d0r+FkNdMAXzWVxLsqczaXN6UBEXerM3TTUmw6py1ZV9TEkyDs7akK+OyvCmFT0dAuC3NGMITiw==
    eFu2NsShittytCEINdyWmQ1BqOC2fGwIngQiOR9Kn/TU02l1fykgtLmjQTizE9rcEtqqTMcwMPoazU7oaz07oa8Z7QSUPa0YvGHtKLSF7Sg3U8Mww5raPVDtBKypIcHJ1ADjbg==
    aohyNjVEuZkaJkasqSEBa2r35GwnOJkaYNxNDVHOpoYoN1PDqQxrakjAmhoSsKYeOCFbMe6mhihnU0OUm6nh4g5rakjAmhoSsKaGBCdTA4y7qSHK2dQQ5WZqUCWjTQ0JWFNDAg==
    1tSQ4GRqgHE3NUQ5mxqi2kwtd1FqpkZZ2BDHLcIMQdyEbAjikrMh6FAtGdKO1ZJBcKyWoK1Km+OqJdNodkJf69kJfc1oJ6DsacXgDWtHoS1sR7mZGlctNZnaPVDtBKypcdWS1Q==
    1LhqqdXUuGqp1dS4aslualy11GRqXLXUZGr35GwnOJkaVy21mhpXLbWaGlct2U2Nq5aaTI2rlppMjauWmkw9cEK2YtxNjauWWk2Nq5bspsZVS02mxlVLTabGVUtNpsZVS1ZT4w==
    qqVWU+OqpVZT46olu6lx1VKTqXHVUpOpcdVSk6lx1ZLV1LhqqdXUuGqp1dS4aukTF4k9PAJqsSFZEfh7XtwtydcFGf5wwq9pRnOWfKNRgB7q0VPtnVWiDflKOP79gg9UPLbc+A==
    jVGkHtuqgfKLH6Lq3VJCWPQo0G/x0odlx/U1Vvl3lvNCWH9nPJ68P7mc62uZtrd0TcfmW7pm1QfrW7pk1zoGU3VfX0KegAHs33kle7ckXG+/CL2D4aXieYkNx4WflMfLZuZrkg==
    qbN7Dy6/o2PUrq3L2fTqWl+FtWnL1NVecUpX9JmEhRJn6glOH78lFd7UYvXCuKX89v4lbhOdisyXuE1kijTexeZigKnVADq6/Rhg2sMA9VjpsMlsfjq+7LSJRedlFNZ13qFteQ==
    bKC2j63a1sHoR9vHvrXdEAGPlG4/8y7JY+LDR67jXKmtMsRSPGyPK0Vljy6zSI8DZml+dyL5V8u7E8XJa31MnK+9PrEmuX99ojh8Vb0+MRSTX2X6m9n7M/m4D/llOTHyDCinRQ==
    mZTlYXGvFged3ZS+Uw1L3/pRewGjPNbtTSE3JE8e6nmAlplAP9e7+mGqfKr3oZ9ZHv5t8RGdfPfTWbPL2PtdiEVES5/lIqN1ClPrEKsTay/u6iHvzzJRfsT/+JAKn37S2Vr1NA==
    eiYKxc/PaZJ8IurbbGv/akJXIhT52clY+UX9/FI90dQqn8mlrxVwVO+M+tjuJ+odJ/qeLOuKQazvGtQtbxAcqukevlC3vtiaB51Ri095Smmyng9Nt7H0t3z8Rj2BXc/G8/I22g==
    PlN413Kn7ldXLItoJhdyym9kq+Lx/3rg33kKlH/wNmn1AlGVRjS58ion2crjnKRLf3QSjnkqjejtMPHf3MRVaFTq7xMpzfPzjXoX1qE76ldkNbmibQpWpNYJ2D4DdzotjyXlZg==
    ZFl+T8xCan7YslwUzm/1BGt8Rxq4+sr5sbovXqhL85rXTt2L+9r8FO5y7oSyqDnMPYZWDnWsTgV7jR0ounF6s6i9S+U2/fYcYDUc/dTxw6How7hRwN6Wb2e2r8dMz6hVDMu5WA==
    gg1ZpTZEgX7fHCYKFOn/UVCPAkMrhzpWp4ZGgTbgK0WB8QAq+fypwzGBB1QNDQzLWqQzNmqr+bdj8U+PtyNMWpYu6g6AwyEb9xuoLzQNuccqprxv+2Bo88n5OWIj4vVWMVc34g==
    nzhglkhLEj4+ZGyXRqBMutJlEn7R49yUyxrJuTGHJZVzW04rsIGtIRdsjq15W999ZuXj7g4j1ngSXtcEZ62TWybqyWQy1/V/6zaV30mm2vI8HK0+GUx8zDSiFWuqbspf5jbSqw==
    bXSq31MdKkIdbRq/OYf22XOTpLaVzkTn8mEbzJNp805xj+0xy/bXgeaPe2q5rx/u9dKo+6EOaBjQrvJO93t17TX7aPXqskNVVSd8eGoJa3XWzpTWoMXazmbPpVVfN6p12qaeoQ==
    zlRXs10rf6omapdSDjVRJvapp8SuS9Ceid28GuP1agpSN+rCh003x550o4sL90nvf/qSBqypxPazrIlOy3sO3qh7Dk6AKTvua2kybY9qq7wpom64t8cn40vtu36qraZydHpzMg==
    O5f3VkBLyLtrGlfFmmSWbzIuvrCnK5JGi/h7pTI9tvIbvAH7N4aUgLPZ2XQuTzYNRFnGoQLrxFprhP2Y74S2lfetxAsvuZakZ7VsnWmKUkyoj4SGfv6wsewbkZ90MO2HYhlYQg==
    /IzLsHvEdmWo/kmDktbixK5R9VWQJ9SSB9DkN5qp/R+o0HxdpZEwoURNXsaVC/5xFSdi2jm/nt7IO2Ol7m7kwcPYF0fv47SQT4Eo9Ynq6i3Lvv9XdXU/O5R/5T/9BwAA//8DAA==
    UEsDBBQABgAIAAAAIQCxP7hiIgEAAE4CAAAUAAAAd29yZC93ZWJTZXR0aW5ncy54bWyU0s1KAzEQAOC74DuE3Ntsiy2ydFsQqQj+gdZ7ms62wSQTMqnb9ekd16pIL+0tk8l8zA==
    JJnMdt6Jd0hkMVRy0C+kgGBwZcO6kouXee9SCso6rLTDAJVsgeRsen42acoGls+QM58kwUqg0ptKbnKOpVJkNuA19TFC4GSNyevMYVorr9PbNvYM+qizXVpnc6uGRTGWeyYdow==
    YF1bA9doth5C7upVAsciBtrYSD9ac4zWYFrFhAaIeB7vvj2vbfhlBhcHkLcmIWGd+zzMvqOO4vJB0a28+wNGpwHDA2BMcBox2hOKWg87Kbwpb9cBk146lngkwV2JDpZTflKM2Q==
    evsBc0xXCRuCpL62+V7bx/B6f9dF2jlsnh5uOFD/fsH0EwAA//8DAFBLAwQUAAYACAAAACEAPufcVsoBAAA8BQAAEgAAAHdvcmQvZm9udFRhYmxlLnhtbLyS22rjMBCG7xf2HQ==
    hO4by86hralTstkGCmUvlvYBFEW2xepgNErcvP2OZScLNYWGlrVByP/MfNL8nrv7V6PJQXpQzhY0nTBKpBVup2xV0JfnzdUNJRC43XHtrCzoUQK9X37/dtfmpbMBCNZbyI0oaA==
    HUKTJwmIWhoOE9dIi8HSecMDfvoqMdz/2TdXwpmGB7VVWoVjkjG2oAPGf4TiylIJ+dOJvZE2xPrES41EZ6FWDZxo7UdorfO7xjshAbBno3ue4cqeMelsBDJKeAeuDBNsZrhRRA==
    YXnK4s7of4D5ZYBsBFiAvAwxHxAJHI18pcSI/LGyzvOtRhK2RPBWJILpcviZpM0tNxhec622XsVAw60DmWLswHVBWcY2bI5r987YtFtp0iWKmnuQHaRPZL1ccqP08aRCqwD6QA==
    o4KoT/qBe9VdrQ+BqjCwhy0r6ANjLFttNrRX0oLOUFmtz0rWnRWfdFCmZ4V1ioicPqOvEpFzzsEzk96BkRPPykggv2RLfjvD7TuOZGyBTszRj86Z6UWO+Mj9nCNrVK5vZtORIw==
    t1/vyDAb5ElVdXh3Qrq5+F8Tsop+PLyZkIxd/xj5Ebv/pB/DBpZ/AQAA//8DAFBLAwQUAAYACAAAACEAq6tnJ3ELAADQbAAAEwAoAGN1c3RvbVhtbC9pdGVtMS54bWwgoiQAKA==
    oCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC0XWtvVEcS7c8r7X9A+Z7NAgGiiHVkICGWeDjgJMsn5PhBrNgYzdgE//nsVnX70o969zhCyczcOlXndN17+1F9Zw==
    /L+/Hqbv0qd0lk7TrfQxHaVVWqeTdJ7ep/+kL9Lt9K/0b3i9BZb36QCOH4L1fXqXrZfpIh2nLwF1Hz59l7bSw/Qi7UOcXwG5Auwr8PuQ31+k/2aWXbDjp1vXrO+Br8Rawftv4Q==
    2AnwrMBnDf8dA/JLiHMFtv1r2xqO4KeP6SvA1fhr+PwaXvfBephZDtNbOLIPLEdgfZte5mPYxrfpcW7jMfjcTnehjffg3RfQgn+mf4C2W9CSHwG5f42vx4vtESg5hX8XEOUxaA==
    X+d3Zxn7At69Tc/Sb2DfciMfAr8/qq3msvHjVbQIib2P0rNiBs8g+5jvq7QNmTrM52MN/24DWrcjoxXBz3fH4Ltj8mEEP99dg++uyYcR/HxfG3xfm3wYwc93z+C7Z/JhBD/ffQ==
    g+++yYcRNL5H+fUP8DrI/dglfLq4vq69SKpBizqnpt7jUY+IOqkn4f0fQZbx3UH6Xc3YiJMV0YgzOqxcSXi/rliecOzD/lLSs9hl/hohwmflYcTZ/L52t2PUUxg9cNQeNXAYyg==
    z0eKckt50LA+Lb58fJ+ewzscRUcF1UL5Wi8t+qKFuwNbG2XoPb0cUjY5jM7py96P+dNRniG+Y+6i0U45aQSNbweu+m3QN/Isx2n86uGJK+VvtMs8vrw9g5a+SzjLfQnz2eM8Rw==
    ptnjUZRbihZXILVfR3sVRXNTVgYX8BmvEBwHZV0Uq6niIuuazsHzHK5SXOOcAL6st6geHsdpkSJqOnZhjEPUEduj9FbKOXr7maTrgkdZzL7rYDdfNbiewfniVwYaV63vwANHAQ==
    nA8s+XyR10O/pbIijPvQtviYNtUqZTziO6fdd3Zep1+hz/sh7RGF1UL5Wy9fdCkPFKGx+dr0C/Tge0qO6B1ne1BVHpbNVEo583vOqI7n2Mqonb9Ytry58WfCavcHwPeM7ZEldg==
    jxqj9DUlrmajIwqLFSXCWio3OsJm5ao3Gr7Ub3SEzcrVcDR8qeLoCJuVq+Ro+FLL0RE2K1fP0fCloqMjbFauqqPhH5isDxysGCXC+o3J+o2DFaPorGV+h7PN07xiX+U7HivUlA==
    X8ZySrTIvaYncPwgj/Blrrv0OXvw+VPCua+FQH47is76JI8XqE6ycCzVyxe99qMWQmOTeuMRX8Yf7igXnRutOIzchnFk0r1HpktAtWeh/Vyi9QjNv9XIHafxJF21llIR9BjG4w==
    kGOsT7kOiCM1VhNeXXNvw51Sr1MPqvB5olEFeB3heSlno+5m9btTXuSixBe1V/MUMOeQKcTiivMgt4Bbr3iRqMYfdU5NPbtRj4g66RoaK1IVJ1mQVfbqo++Aio+AHSsi/HGMLA==
    eWhxn+Q5+kFa9g+2QdvyXuL0+FA9PqaIVhzL1vkui2vWfG3tOnPfhlpL+j7jsIKDY+EVjInYd+p21GJFiPBVlT6czS+3G58l6HO0nff88Z7S89uq3DxKacNNqBlbWPqM0zzjWg==
    5bke7i61azQbU9TZkXpu2ntwfY3Vx6D96vOc4Dm8XuT62yHkAEcMfFbjBM7y0isWlojHoiLGspnKPicznjOqfTnG2cAKPq2dGbbwVKnNsIk+Kbdev7heOa+Iw/t1ne/fA8Bcwg==
    2SlPMJXaC6q0UUWTJ1pcQZsvP9qraJPcvMnWstKI4b3qWoZe30+APc99b7H2nzH+iND8axb44zSelLc6V+5HhGX0kEeGWU/UNs8qqd/N99R6uH90e6+Ej+Dhq0856HaZT3pOgg==
    Ry/rK6udI07mpxFHHUdJe5IPFeiIwm1FibG27fchPSrkHPyee+mlF2/ZeUthk7z06LXSIFm46FJ9QsLJbeBqFnYUndUzD4r7cMo8TJtqlXPn953TbuV7D1B9LZZqlTGtJi2Slw==
    G3dQNKvOR/dfZCzummhWnYnuuchY3CnRrDoT3WeRsbg7oll1Jrq3ImNxR0Sz6kx0P0XG4i6IZtWZ6B6KjMWdD82qM9F9ExmLux2aVWeieyWIPU9/fvb5kMo8s/crnDZuYfdE5A==
    dZRvQPyh9ts2rtVhRRx1XEK/gyN12dVpezTeUrgkrz46npERQY9hRA7ZxyorAb5OJtswtuZpcbxOWJk6gOyVJ8pqXVdjt714XR42TvFSRRw1jccrK/Xg4j4Gy36ey9HYnK3G5w==
    PS2OdhzUrDyPPIoW7A7cj2UuUPLbV+RtTGXVI3HcZVWAazH0GmtpNqZy65E47ldJe+7HxlRuPVKUe2y/B+vTIuXjTb7TVtn3OOcRs4i53FJsyKl5ejmqKhujc0rtW9b5/fFiaw==
    +5myy8hXgZYIMTzqjTJsqrFmYc4vrpnPO9WuVdm4/Nr4UauHYVONfH79fnHNWn4fp/JtzzVzP5T+x0KgHjtKnLmq9iI9SrRcyOvX5dxbCFRgR4kzV9VepEeJloudhLWSs885Ww==
    tPPHkU3y8MauanS7zKW1h9tfbFXqduS0IkQ5q1ofztbgaf+T1Neq+3kPlxGvR6vPzzKrtK0BxxRTT79yjlVuwXgn8MdbdvvewX0SfIoJ72bc5W/Rsg05NM8IT73KbIzOq12vyw==
    up+r3i6qbcyygrcizfBX9X6sT4+Wl72Es3L83Yb2abG2P8BagIUptQE7Esd/lVfTbfbosRKfImm8n8GC1wV+uwxrybh+xtk5omUbxtc8Izw12zZG59XO2+JV92UrXz3Wxm+Rng==
    eLQd1MbH13TrK/PlvHpQ9jpfvko8frUVEbRXlZ2jXchlPzLwx9uaw+jhjT22VbLLXHx72rFotOgV0MVrrMlGfLecOFTpjTirpX/6Ne7j1yg/Z1v04jPKWIdDzGnC75tKbSt4aQ==
    1i/HiXpoa4uo2poFnPnI3j4cnUtF9dDZihzBj+XnQVFt2sgjx5rxssa5qPJfEn6r5eS6/cu3W7Q4UY/S00VZ6N2GtRUP2n9/012q0iO3My1N0U7yP6WtRb6ZOGX1fTOK/q621g==
    se1m491c27XZhM7AP9k+f96j8ewcxBX+3TnwXg+zcW8+J9r1sWDGWLiK5PMb9ZArTRrL5kprq2c9Z5RrucY5BI5/8goBe3cPCpX5oklrAP+ZiOHrGmGTcx2LMK5fZs7zLKNH+w==
    M5g9vDF6rRkvXreH7WZUa3n3e8+2wj4H9fkJ+/r2YKtSX+RNdI25jfjEdPrz6L+O/R5U6ybXrz+GlN+Z63aGNVaVsq/fqJ9VqZq5rqORxnMw6z/fFvt8LJUu+wzYSFo/m8my7Q==
    O+bV7xFRKNf8vHcu93SZ1v66Btf8PChU6Ys2p6LmJoL2qtKuWqmSprUx7qPV7GLZ5KPcmVKse8maLTZrJt8/3zjO4HsrnbmP3t7ZsKw3hpdnv5GM6P2vpTXqZ/f4Pu01jgeLzw==
    AC2/UF+fhV6reelzakeI4UuFMcaga/wh+57lXv8C8Idh1TMRxnbMqfD3hnasWU+tZ5xpAWYCM/IIXk+deYj7oOoZJlnvzwn/cgPejafX6IjyGe+2DXPsY88Q9cBfzijX6wrw3A==
    7wAVHGYY/w5GxYxHkJ2iuLkI/qYN/k4sPqlZkfzxMr/gPWjspwl3Z7BFI1ayYHzZizLswh2OT6yU6mZF8scxuuQxnjn7TLTfe+FH3Wpve6adJP1aQAyPKqMMmkbpuejaej+21w==
    ZkfWdEmt4XRZ2F6XHdnS5dt5GRX6vKhWL5um+kW+riV11Nqr4Lw1tv6XO0bVL+H/9Nr3+vTK/Eya3vKNt/q51TXaen7qGeF5nq8/nDvq51nT442h6/Yr0drH3Zv8Pei71+jqog==
    jUytPQfnHWMrdTmds2As5iVSjJ/Lp4yyNERy3lcmKX9v55jHCONIW/HtKIoW+vuDZe3r+5tiW+n/AAAA//8DAFBLAwQUAAYACAAAACEAk3bWSRgBAABAAgAAHQAAAHdvcmQvZw==
    bG9zc2FyeS93ZWJTZXR0aW5ncy54bWyU0cFKAzEQBuC74DuE3Ntsiy2ydFsQqXgRQX2ANJ1tg5lMyKRu69M7rlURL+0tk2Q+5mdmiz0G9QaZPcVGj4aVVhAdrX3cNPrleTm41g==
    iouNaxsoQqMPwHoxv7yYdXUHqycoRX6yEiVyja7R21JSbQy7LaDlISWI8thSRlukzBuDNr/u0sARJlv8ygdfDmZcVVN9ZPIpCrWtd3BLbocQS99vMgQRKfLWJ/7WulO0jvI6ZQ==
    csAseTB8eWh9/GFGV/8g9C4TU1uGEuY4UU9J+6jqTxh+gcl5wPgfMGU4j5gcCcMHhL1W6Or7TaRsV0EkiaRkKtXDei4rpVQ8+ndYUr7J1DFk83ltQ6Du8eFOCvNn7/MPAAAA/w==
    /wMAUEsDBBQABgAIAAAAIQA+59xWygEAADwFAAAbAAAAd29yZC9nbG9zc2FyeS9mb250VGFibGUueG1svJLbauMwEIbvF/YdhO4by86hralTstkGCmUvlvYBFEW2xepgNErcvA==
    /Y5lJws1hYaWtUHI/8x80vyeu/tXo8lBelDOFjSdMEqkFW6nbFXQl+fN1Q0lELjdce2sLOhRAr1ffv921+alswEI1lvIjShoHUKTJwmIWhoOE9dIi8HSecMDfvoqMdz/2TdXwg==
    mYYHtVVahWOSMbagA8Z/hOLKUgn504m9kTbE+sRLjURnoVYNnGjtR2it87vGOyEBsGeje57hyp4x6WwEMkp4B64ME2xmuFFEYXnK4s7of4D5ZYBsBFiAvAwxHxAJHI18pcSI/A==
    sbLO861GErZE8FYkguly+JmkzS03GF5zrbZexUDDrQOZYuzAdUFZxjZsjmv3zti0W2nSJYqae5AdpE9kvVxyo/TxpEKrAPpAo4KoT/qBe9VdrQ+BqjCwhy0r6ANjLFttNrRX0g==
    gs5QWa3PStadFZ90UKZnhXWKiJw+o68SkXPOwTOT3oGRE8/KSCC/ZEt+O8PtO45kbIFOzNGPzpnpRY74yP2cI2tUrm9m05Ejt1/vyDAb5ElVdXh3Qrq5+F8Tsop+PLyZkIxd/w==
    GPkRu/+kH8MGln8BAAD//wMAUEsDBBQABgAIAGZgyEp7vCHE6QEAAGEEAAAQAAgBZG9jUHJvcHMvYXBwLnhtbCCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJ1UwW7bMAz9FUP3xkk7BEOQuCjaww4bWsBZe+ZkOhFmS4LEGMl+bYd90n5hlOS4yoJdlhP5+PT0KDL+/fPX+v7Yd8WAziujNw==
    YjGbiwK1NI3Su404UHvzURSeQDfQGY0bcUIv7qs12NWLMxYdKfQFa2i/Gmgj9kR2VZZe7rEHP2OG5mJrXA/EqduVpm2VxCcjDz1qKm/n82XZGBnU/Ov2ZFl/1AP7v3p4JNQNNg==
    N3byKKLnLfa2A8KqVhyoVmFT1NBxC2eBWWPouC5zbjxoCLqt6rGap+KUx6eAHfqxkuKAvhnX+Gpxt4x4ygL+uAcHkvjNxyMZEOoPlq1JIJ5I9UVJZ7xpqXiOfRZBJh7KWeEUNw==
    UKM8OEWnUTZHAuOz0pPLFCfvDnYO7J6tjg1MQKjXkt/nkd+xaqHzGCnvWGB8Qgjr8gIqNDDQakBJxhXfwGMY6EYM4BRo4k1SPzi9FYmW0Bh31pOrtoo6vmHKY5jT8lh9CIZTcA==
    SSwnD1W0e2kwTC/c459bbpX+YTkaOBteiMzklb/spr+Ew2xNb0GfUnlK0gS++692a57Cjr2/7SV+uS9viva1BYnXm5OV4tS4gA1vQD61CYtT4zZdFy5jEb3DJmNe18a9fE0fig==
    arGczfl3XsQznPZn+s9VfwBQSwECLQAUAAYACAAAACEAv/Max/MBAACsDQAAEwAAAAAAAAAAAAAAAAAAAAAAW0NvbnRlbnRfVHlwZXNdLnhtbFBLAQItABQABgAIAAAAIQCZVQ==
    fgX+AAAA4QIAAAsAAAAAAAAAAAAAAAAALAQAAF9yZWxzLy5yZWxzUEsBAi0AFAAGAAgAAAAhAN7uHl1yAQAA8AgAABwAAAAAAAAAAAAAAAAAWwcAAHdvcmQvX3JlbHMvZG9jdQ==
    bWVudC54bWwucmVsc1BLAQItABQABgAIAGZgyEq2G0HNDxEAAN7cAAARAAAAAAAAAAAAAAAAAA8KAAB3b3JkL2RvY3VtZW50LnhtbFBLAQItABQABgAIAGZgyEpJyA5WFAkAAA==
    ikkAABAAAAAAAAAAAAAAAAAATRsAAHdvcmQvZm9vdGVyMy54bWxQSwECLQAUAAYACABmYMhKVA1klf4BAAB7CAAAEAAAAAAAAAAAAAAAAACPJAAAd29yZC9mb290ZXIxLnhtbA==
    UEsBAi0AFAAGAAgAZmDISqRZ55H3BQAA0h4AABAAAAAAAAAAAAAAAAAAuyYAAHdvcmQvaGVhZGVyMi54bWxQSwECLQAUAAYACABmYMhKe6T2gP4BAAB7CAAAEAAAAAAAAAAAAA==
    AAAAAOAsAAB3b3JkL2hlYWRlcjEueG1sUEsBAi0AFAAGAAgAZmDISsB2o9c/AgAAvAkAABEAAAAAAAAAAAAAAAAADC8AAHdvcmQvZW5kbm90ZXMueG1sUEsBAi0AFAAGAAgAZg==
    YMhKYh+1dkACAADCCQAAEgAAAAAAAAAAAAAAAAB6MQAAd29yZC9mb290bm90ZXMueG1sUEsBAi0AFAAGAAgAAAAhAMfO8qi5AAAAIQEAABsAAAAAAAAAAAAAAAAA6jMAAHdvcg==
    ZC9fcmVscy9oZWFkZXIzLnhtbC5yZWxzUEsBAi0AFAAGAAgAZmDISqCeTGqfBwAASiUAABAAAAAAAAAAAAAAAAAA3DQAAHdvcmQvaGVhZGVyMy54bWxQSwECLQAUAAYACABmYA==
    yEp6SpldbQQAAK4PAAAQAAAAAAAAAAAAAAAAAKk8AAB3b3JkL2Zvb3RlcjIueG1sUEsBAi0ACgAAAAAAAAAhADJSfrUKAAAACgAAABUAAAAAAAAAAAAAAAAAREEAAHdvcmQvbQ==
    ZWRpYS9pbWFnZTEuYmluUEsBAi0AFAAGAAgAAAAhAKpSJd8jBgAAixoAABUAAAAAAAAAAAAAAAAAgUEAAHdvcmQvdGhlbWUvdGhlbWUxLnhtbFBLAQItABQABgAIAAAAIQCD0A==
    teXmAAAArQIAACUAAAAAAAAAAAAAAAAA10cAAHdvcmQvZ2xvc3NhcnkvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHNQSwECLQAUAAYACAAAACEACjyrr4EDAAABCgAAGgAAAAAAAA==
    AAAAAAAAAABJAAB3b3JkL2dsb3NzYXJ5L3NldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQAbXcuV3AgAAB8iAAARAAAAAAAAAAAAAAAAALlMAAB3b3JkL3NldHRpbmdzLnhtbA==
    UEsBAi0AFAAGAAgAAAAhAJrCvMMRDgAAiH8AABoAAAAAAAAAAAAAAAAAxFUAAHdvcmQvZ2xvc3NhcnkvZG9jdW1lbnQueG1sUEsBAi0AFAAGAAgAAAAhANJ3OzP1AAAAdQEAAA==
    HAAAAAAAAAAAAAAAAAANZAAAd29yZC9fcmVscy9zZXR0aW5ncy54bWwucmVsc1BLAQItABQABgAIAAAAIQB6qHJ0xQAAADIBAAATAAAAAAAAAAAAAAAAADxlAABjdXN0b21YbQ==
    bC9pdGVtMi54bWxQSwECLQAUAAYACAAAACEA/NUFJeAAAABVAQAAGAAAAAAAAAAAAAAAAABaZgAAY3VzdG9tWG1sL2l0ZW1Qcm9wczIueG1sUEsBAi0AFAAGAAgAAAAhAB8e/A==
    7AUCAABwBwAAEwAAAAAAAAAAAAAAAACYZwAAZG9jUHJvcHMvY3VzdG9tLnhtbFBLAQItABQABgAIAAAAIQB0Pzl6wgAAACgBAAAeAAAAAAAAAAAAAAAAANZqAABjdXN0b21YbQ==
    bC9fcmVscy9pdGVtMS54bWwucmVsc1BLAQItABQABgAIAAAAIQBcliciwgAAACgBAAAeAAAAAAAAAAAAAAAAANxsAABjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbHNQSw==
    AQItABQABgAIAAAAIQDCle2kAgEAAFUBAAAYAAAAAAAAAAAAAAAAAOJuAABjdXN0b21YbWwvaXRlbVByb3BzMS54bWxQSwECLQAUAAYACAAAACEACPRtECMXAACltwAAGAAAAA==
    AAAAAAAAAAAAAEJwAAB3b3JkL2dsb3NzYXJ5L3N0eWxlcy54bWxQSwECLQAUAAYACABmYMhKsOzHSToBAABIAgAAEQAAAAAAAAAAAAAAAACbhwAAZG9jUHJvcHMvY29yZS54bQ==
    bFBLAQItABQABgAIAAAAIQDeUKSjrw8AAFKTAAAPAAAAAAAAAAAAAAAAAAyKAAB3b3JkL3N0eWxlcy54bWxQSwECLQAUAAYACAAAACEAsT+4YiIBAABOAgAAFAAAAAAAAAAAAA==
    AAAAAOiZAAB3b3JkL3dlYlNldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQA+59xWygEAADwFAAASAAAAAAAAAAAAAAAAADybAAB3b3JkL2ZvbnRUYWJsZS54bWxQSwECLQAUAA==
    BgAIAAAAIQCrq2cncQsAANBsAAATAAAAAAAAAAAAAAAAADadAABjdXN0b21YbWwvaXRlbTEueG1sUEsBAi0AFAAGAAgAAAAhAJN21kkYAQAAQAIAAB0AAAAAAAAAAAAAAAAAAA==
    qQAAd29yZC9nbG9zc2FyeS93ZWJTZXR0aW5ncy54bWxQSwECLQAUAAYACAAAACEAPufcVsoBAAA8BQAAGwAAAAAAAAAAAAAAAABTqgAAd29yZC9nbG9zc2FyeS9mb250VGFibA==
    ZS54bWxQSwECLQAUAAYACABmYMhKe7whxOkBAABhBAAAEAAAAAAAAAAAAAAAAABWrAAAZG9jUHJvcHMvYXBwLnhtbFBLBQYAAAAAIwAjAC4JAAB1rwAAAAA=
    END_OF_WORDLAYOUT
  }
}

