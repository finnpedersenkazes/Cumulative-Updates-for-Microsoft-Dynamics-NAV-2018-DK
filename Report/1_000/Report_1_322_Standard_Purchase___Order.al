OBJECT Report 1322 Standard Purchase - Order
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kõb - Ordre;
               ENU=Purchase - Order];
    EnableHyperlinks=Yes;
    OnInitReport=BEGIN
                   GLSetup.GET;
                   CompanyInfo.GET;
                   PurchSetup.GET;
                   CompanyInfo.CALCFIELDS(Picture);
                 END;

    OnPreReport=BEGIN
                  IF NOT CurrReport.USEREQUESTPAGE THEN
                    InitLogInteraction;
                END;

    PreviewMode=PrintLayout;
    DefaultLayout=Word;
    WordMergeDataItem=Purchase Header;
  }
  DATASET
  {
    { 1   ;    ;DataItem;                    ;
               DataItemTable=Table38;
               DataItemTableView=SORTING(Document Type,No.)
                                 WHERE(Document Type=CONST(Order));
               ReqFilterHeadingML=[DAN=Standardkõb - ordre;
                                   ENU=Standard Purchase - Order];
               OnAfterGetRecord=BEGIN
                                  TotalAmount := 0;
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FormatAddressFields("Purchase Header");
                                  FormatDocumentFields("Purchase Header");

                                  IF NOT CurrReport.PREVIEW THEN BEGIN
                                    CODEUNIT.RUN(CODEUNIT::"Purch.Header-Printed","Purchase Header");
                                    IF ArchiveDocument THEN
                                      ArchiveManagement.StorePurchDocument("Purchase Header",LogInteraction);

                                    IF LogInteraction THEN
                                      SegManagement.LogDocument(
                                        13,"No.",0,0,DATABASE::Vendor,"Buy-from Vendor No.",
                                        "Purchaser Code",'',"Posting Description",'');
                                  END;
                                END;

               ReqFilterFields=No.,Buy-from Vendor No.,No. Printed }

    { 117 ;1   ;Column  ;CompanyAddress1     ;
               SourceExpr=CompanyAddr[1] }

    { 114 ;1   ;Column  ;CompanyAddress2     ;
               SourceExpr=CompanyAddr[2] }

    { 113 ;1   ;Column  ;CompanyAddress3     ;
               SourceExpr=CompanyAddr[3] }

    { 111 ;1   ;Column  ;CompanyAddress4     ;
               SourceExpr=CompanyAddr[4] }

    { 109 ;1   ;Column  ;CompanyAddress5     ;
               SourceExpr=CompanyAddr[5] }

    { 108 ;1   ;Column  ;CompanyAddress6     ;
               SourceExpr=CompanyAddr[6] }

    { 40  ;1   ;Column  ;CompanyHomePage_Lbl ;
               SourceExpr=HomePageCaptionLbl }

    { 107 ;1   ;Column  ;CompanyHomePage     ;
               SourceExpr=CompanyInfo."Home Page" }

    { 54  ;1   ;Column  ;CompanyEmail_Lbl    ;
               SourceExpr=EmailIDCaptionLbl }

    { 104 ;1   ;Column  ;CompanyEMail        ;
               SourceExpr=CompanyInfo."E-Mail" }

    { 147 ;1   ;Column  ;CompanyPicture      ;
               SourceExpr=CompanyInfo.Picture }

    { 103 ;1   ;Column  ;CompanyPhoneNo      ;
               SourceExpr=CompanyInfo."Phone No." }

    { 102 ;1   ;Column  ;CompanyPhoneNo_Lbl  ;
               SourceExpr=CompanyInfoPhoneNoCaptionLbl }

    { 101 ;1   ;Column  ;CompanyGiroNo       ;
               SourceExpr=CompanyInfo."Giro No." }

    { 100 ;1   ;Column  ;CompanyGiroNo_Lbl   ;
               SourceExpr=CompanyInfoGiroNoCaptionLbl }

    { 99  ;1   ;Column  ;CompanyBankName     ;
               SourceExpr=CompanyInfo."Bank Name" }

    { 97  ;1   ;Column  ;CompanyBankName_Lbl ;
               SourceExpr=CompanyInfoBankNameCaptionLbl }

    { 152 ;1   ;Column  ;CompanyBankBranchNo ;
               SourceExpr=CompanyInfo."Bank Branch No." }

    { 182 ;1   ;Column  ;CompanyBankBranchNo_Lbl;
               SourceExpr=CompanyInfo.FIELDCAPTION("Bank Branch No.") }

    { 48  ;1   ;Column  ;CompanyBankAccountNo;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 47  ;1   ;Column  ;CompanyBankAccountNo_Lbl;
               SourceExpr=CompanyInfoBankAccNoCaptionLbl }

    { 25  ;1   ;Column  ;CompanyIBAN         ;
               SourceExpr=CompanyInfo.IBAN }

    { 106 ;1   ;Column  ;CompanyIBAN_Lbl     ;
               SourceExpr=CompanyInfo.FIELDCAPTION(IBAN) }

    { 186 ;1   ;Column  ;CompanySWIFT        ;
               SourceExpr=CompanyInfo."SWIFT Code" }

    { 187 ;1   ;Column  ;CompanySWIFT_Lbl    ;
               SourceExpr=CompanyInfo.FIELDCAPTION("SWIFT Code") }

    { 23  ;1   ;Column  ;CompanyLogoPosition ;
               SourceExpr=CompanyLogoPosition }

    { 19  ;1   ;Column  ;CompanyRegistrationNumber;
               SourceExpr=CompanyInfo.GetRegistrationNumber }

    { 168 ;1   ;Column  ;CompanyRegistrationNumber_Lbl;
               SourceExpr=CompanyInfo.GetRegistrationNumberLbl }

    { 17  ;1   ;Column  ;CompanyVATRegNo     ;
               SourceExpr=CompanyInfo.GetVATRegistrationNumber }

    { 21  ;1   ;Column  ;CompanyVATRegNo_Lbl ;
               SourceExpr=CompanyInfo.GetVATRegistrationNumberLbl }

    { 14  ;1   ;Column  ;CompanyVATRegistrationNo;
               SourceExpr=CompanyInfo.GetVATRegistrationNumber }

    { 11  ;1   ;Column  ;CompanyVATRegistrationNo_Lbl;
               SourceExpr=CompanyInfo.GetVATRegistrationNumberLbl }

    { 9   ;1   ;Column  ;CompanyLegalOffice  ;
               SourceExpr=CompanyInfo.GetLegalOffice }

    { 7   ;1   ;Column  ;CompanyLegalOffice_Lbl;
               SourceExpr=CompanyInfo.GetLegalOfficeLbl }

    { 173 ;1   ;Column  ;CompanyCustomGiro   ;
               SourceExpr=CompanyInfo.GetCustomGiro }

    { 5   ;1   ;Column  ;CompanyCustomGiro_Lbl;
               SourceExpr=CompanyInfo.GetCustomGiroLbl }

    { 245 ;1   ;Column  ;DocType_PurchHeader ;
               SourceExpr="Document Type" }

    { 246 ;1   ;Column  ;No_PurchHeader      ;
               SourceExpr="No." }

    { 3   ;1   ;Column  ;DocumentTitle_Lbl   ;
               SourceExpr=DocumentTitleLbl }

    { 45  ;1   ;Column  ;Amount_Lbl          ;
               SourceExpr=AmountCaptionLbl }

    { 78  ;1   ;Column  ;PurchLineInvDiscAmt_Lbl;
               SourceExpr=PurchLineInvDiscAmtCaptionLbl }

    { 105 ;1   ;Column  ;Subtotal_Lbl        ;
               SourceExpr=SubtotalCaptionLbl }

    { 86  ;1   ;Column  ;VATAmtLineVAT_Lbl   ;
               SourceExpr=VATAmtLineVATCaptionLbl }

    { 88  ;1   ;Column  ;VATAmtLineVATAmt_Lbl;
               SourceExpr=VATAmtLineVATAmtCaptionLbl }

    { 31  ;1   ;Column  ;VATAmtSpec_Lbl      ;
               SourceExpr=VATAmtSpecCaptionLbl }

    { 130 ;1   ;Column  ;VATIdentifier_Lbl   ;
               SourceExpr=VATIdentifierCaptionLbl }

    { 134 ;1   ;Column  ;VATAmtLineInvDiscBaseAmt_Lbl;
               SourceExpr=VATAmtLineInvDiscBaseAmtCaptionLbl }

    { 135 ;1   ;Column  ;VATAmtLineLineAmt_Lbl;
               SourceExpr=VATAmtLineLineAmtCaptionLbl }

    { 150 ;1   ;Column  ;VALVATBaseLCY_Lbl   ;
               SourceExpr=VALVATBaseLCYCaptionLbl }

    { 167 ;1   ;Column  ;Total_Lbl           ;
               SourceExpr=TotalCaptionLbl }

    { 110 ;1   ;Column  ;PaymentTermsDesc_Lbl;
               SourceExpr=PaymentTermsDescCaptionLbl }

    { 112 ;1   ;Column  ;ShipmentMethodDesc_Lbl;
               SourceExpr=ShipmentMethodDescCaptionLbl }

    { 220 ;1   ;Column  ;PrepymtTermsDesc_Lbl;
               SourceExpr=PrepymtTermsDescCaptionLbl }

    { 57  ;1   ;Column  ;HomePage_Lbl        ;
               SourceExpr=HomePageCaptionLbl }

    { 58  ;1   ;Column  ;EmailID_Lbl         ;
               SourceExpr=EmailIDCaptionLbl }

    { 16  ;1   ;Column  ;AllowInvoiceDisc_Lbl;
               SourceExpr=AllowInvoiceDiscCaptionLbl }

    { 2   ;1   ;Column  ;CurrRepPageNo       ;
               SourceExpr=STRSUBSTNO(PageLbl,FORMAT(CurrReport.PAGENO)) }

    { 28  ;1   ;Column  ;DocumentDate        ;
               SourceExpr=FORMAT("Document Date",0,4) }

    { 49  ;1   ;Column  ;DueDate             ;
               SourceExpr=FORMAT("Due Date",0,4) }

    { 55  ;1   ;Column  ;ExptRecptDt_PurchaseHeader;
               SourceExpr=FORMAT("Expected Receipt Date",0,4) }

    { 60  ;1   ;Column  ;OrderDate_PurchaseHeader;
               SourceExpr=FORMAT("Order Date",0,4) }

    { 29  ;1   ;Column  ;VATNoText           ;
               SourceExpr=VATNoText }

    { 30  ;1   ;Column  ;VATRegNo_PurchHeader;
               SourceExpr="VAT Registration No." }

    { 33  ;1   ;Column  ;PurchaserText       ;
               SourceExpr=PurchaserText }

    { 34  ;1   ;Column  ;SalesPurchPersonName;
               SourceExpr=SalespersonPurchaser.Name }

    { 37  ;1   ;Column  ;ReferenceText       ;
               SourceExpr=ReferenceText }

    { 38  ;1   ;Column  ;YourRef_PurchHeader ;
               SourceExpr="Your Reference" }

    { 115 ;1   ;Column  ;BuyFrmVendNo_PurchHeader;
               SourceExpr="Buy-from Vendor No." }

    { 90  ;1   ;Column  ;BuyFromAddr1        ;
               SourceExpr=BuyFromAddr[1] }

    { 91  ;1   ;Column  ;BuyFromAddr2        ;
               SourceExpr=BuyFromAddr[2] }

    { 92  ;1   ;Column  ;BuyFromAddr3        ;
               SourceExpr=BuyFromAddr[3] }

    { 93  ;1   ;Column  ;BuyFromAddr4        ;
               SourceExpr=BuyFromAddr[4] }

    { 125 ;1   ;Column  ;BuyFromAddr5        ;
               SourceExpr=BuyFromAddr[5] }

    { 126 ;1   ;Column  ;BuyFromAddr6        ;
               SourceExpr=BuyFromAddr[6] }

    { 127 ;1   ;Column  ;BuyFromAddr7        ;
               SourceExpr=BuyFromAddr[7] }

    { 128 ;1   ;Column  ;BuyFromAddr8        ;
               SourceExpr=BuyFromAddr[8] }

    { 121 ;1   ;Column  ;PricesIncludingVAT_Lbl;
               SourceExpr=PricesIncludingVATCaptionLbl }

    { 82  ;1   ;Column  ;PricesInclVAT_PurchHeader;
               SourceExpr="Prices Including VAT" }

    { 221 ;1   ;Column  ;OutputNo            ;
               SourceExpr=OutputNo }

    { 222 ;1   ;Column  ;VATBaseDisc_PurchHeader;
               SourceExpr="VAT Base Discount %" }

    { 223 ;1   ;Column  ;PricesInclVATtxt    ;
               SourceExpr=PricesInclVATtxtLbl }

    { 42  ;1   ;Column  ;PaymentTermsDesc    ;
               SourceExpr=PaymentTerms.Description }

    { 41  ;1   ;Column  ;ShipmentMethodDesc  ;
               SourceExpr=ShipmentMethod.Description }

    { 51  ;1   ;Column  ;PrepmtPaymentTermsDesc;
               SourceExpr=PrepmtPaymentTerms.Description }

    { 56  ;1   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 35  ;1   ;Column  ;OrderNo_Lbl         ;
               SourceExpr=OrderNoCaptionLbl }

    { 224 ;1   ;Column  ;Page_Lbl            ;
               SourceExpr=PageCaptionLbl }

    { 53  ;1   ;Column  ;DocumentDate_Lbl    ;
               SourceExpr=DocumentDateCaptionLbl }

    { 69  ;1   ;Column  ;BuyFrmVendNo_PurchHeader_Lbl;
               SourceExpr=FIELDCAPTION("Buy-from Vendor No.") }

    { 70  ;1   ;Column  ;PricesInclVAT_PurchHeader_Lbl;
               SourceExpr=FIELDCAPTION("Prices Including VAT") }

    { 18  ;1   ;Column  ;Receiveby_Lbl       ;
               SourceExpr=ReceivebyCaptionLbl }

    { 20  ;1   ;Column  ;Buyer_Lbl           ;
               SourceExpr=BuyerCaptionLbl }

    { 154 ;1   ;Column  ;PayToVendNo_PurchHeader;
               SourceExpr="Pay-to Vendor No." }

    { 149 ;1   ;Column  ;VendAddr8           ;
               SourceExpr=VendAddr[8] }

    { 145 ;1   ;Column  ;VendAddr7           ;
               SourceExpr=VendAddr[7] }

    { 140 ;1   ;Column  ;VendAddr6           ;
               SourceExpr=VendAddr[6] }

    { 136 ;1   ;Column  ;VendAddr5           ;
               SourceExpr=VendAddr[5] }

    { 133 ;1   ;Column  ;VendAddr4           ;
               SourceExpr=VendAddr[4] }

    { 132 ;1   ;Column  ;VendAddr3           ;
               SourceExpr=VendAddr[3] }

    { 131 ;1   ;Column  ;VendAddr2           ;
               SourceExpr=VendAddr[2] }

    { 24  ;1   ;Column  ;VendAddr1           ;
               SourceExpr=VendAddr[1] }

    { 22  ;1   ;Column  ;PaymentDetails_Lbl  ;
               SourceExpr=PaymentDetailsCaptionLbl }

    { 13  ;1   ;Column  ;VendNo_Lbl          ;
               SourceExpr=VendNoCaptionLbl }

    { 52  ;1   ;Column  ;SellToCustNo_PurchHeader;
               SourceExpr="Sell-to Customer No." }

    { 46  ;1   ;Column  ;ShipToAddr1         ;
               SourceExpr=ShipToAddr[1] }

    { 39  ;1   ;Column  ;ShipToAddr2         ;
               SourceExpr=ShipToAddr[2] }

    { 36  ;1   ;Column  ;ShipToAddr3         ;
               SourceExpr=ShipToAddr[3] }

    { 27  ;1   ;Column  ;ShipToAddr4         ;
               SourceExpr=ShipToAddr[4] }

    { 26  ;1   ;Column  ;ShipToAddr5         ;
               SourceExpr=ShipToAddr[5] }

    { 15  ;1   ;Column  ;ShipToAddr6         ;
               SourceExpr=ShipToAddr[6] }

    { 12  ;1   ;Column  ;ShipToAddr7         ;
               SourceExpr=ShipToAddr[7] }

    { 10  ;1   ;Column  ;ShipToAddr8         ;
               SourceExpr=ShipToAddr[8] }

    { 8   ;1   ;Column  ;ShiptoAddress_Lbl   ;
               SourceExpr=ShiptoAddressCaptionLbl }

    { 6   ;1   ;Column  ;SellToCustNo_PurchHeader_Lbl;
               SourceExpr=FIELDCAPTION("Sell-to Customer No.") }

    { 50  ;1   ;Column  ;ItemNumber_Lbl      ;
               SourceExpr=ItemNumberCaptionLbl }

    { 83  ;1   ;Column  ;ItemDescription_Lbl ;
               SourceExpr=ItemDescriptionCaptionLbl }

    { 116 ;1   ;Column  ;ItemQuantity_Lbl    ;
               SourceExpr=ItemQuantityCaptionLbl }

    { 118 ;1   ;Column  ;ItemUnit_Lbl        ;
               SourceExpr=ItemUnitCaptionLbl }

    { 119 ;1   ;Column  ;ItemUnitPrice_Lbl   ;
               SourceExpr=ItemUnitPriceCaptionLbl }

    { 120 ;1   ;Column  ;ItemLineAmount_Lbl  ;
               SourceExpr=ItemLineAmountCaptionLbl }

    { 137 ;1   ;Column  ;ToCaption_Lbl       ;
               SourceExpr=ToCaptionLbl }

    { 129 ;1   ;Column  ;VendorIDCaption_Lbl ;
               SourceExpr=VendorIDCaptionLbl }

    { 98  ;1   ;Column  ;ConfirmToCaption_Lbl;
               SourceExpr=ConfirmToCaptionLbl }

    { 96  ;1   ;Column  ;PurchOrderCaption_Lbl;
               SourceExpr=PurchOrderCaptionLbl }

    { 95  ;1   ;Column  ;PurchOrderNumCaption_Lbl;
               SourceExpr=PurchOrderNumCaptionLbl }

    { 85  ;1   ;Column  ;PurchOrderDateCaption_Lbl;
               SourceExpr=PurchOrderDateCaptionLbl }

    { 247 ;1   ;Column  ;TaxIdentTypeCaption_Lbl;
               SourceExpr=TaxIdentTypeCaptionLbl }

    { 166 ;1   ;Column  ;OrderDate_Lbl       ;
               SourceExpr=OrderDateLbl }

    { 4   ;1   ;DataItem;                    ;
               DataItemTable=Table39;
               DataItemTableView=SORTING(Document Type,Document No.,Line No.);
               OnAfterGetRecord=BEGIN
                                  AllowInvDisctxt := FORMAT("Allow Invoice Disc.");
                                  TotalSubTotal += "Line Amount";
                                  TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                                  TotalAmount += Amount;
                                  IF "Cross-Reference No." <> '' THEN
                                    "No." := "Cross-Reference No.";

                                  FormatDocument.SetPurchaseLine("Purchase Line",FormattedQuanitity,FormattedDirectUnitCost);
                                END;

               DataItemLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.) }

    { 226 ;2   ;Column  ;LineNo_PurchLine    ;
               SourceExpr="Line No." }

    { 227 ;2   ;Column  ;AllowInvDisctxt     ;
               SourceExpr=AllowInvDisctxt }

    { 225 ;2   ;Column  ;Type_PurchLine      ;
               SourceExpr=FORMAT(Type,0,2) }

    { 62  ;2   ;Column  ;No_PurchLine        ;
               SourceExpr="No." }

    { 63  ;2   ;Column  ;Desc_PurchLine      ;
               SourceExpr=Description }

    { 64  ;2   ;Column  ;Qty_PurchLine       ;
               SourceExpr=FormattedQuanitity }

    { 65  ;2   ;Column  ;UOM_PurchLine       ;
               SourceExpr="Unit of Measure" }

    { 66  ;2   ;Column  ;DirUnitCost_PurchLine;
               SourceExpr=FormattedDirectUnitCost;
               AutoFormatType=2;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 67  ;2   ;Column  ;LineDisc_PurchLine  ;
               SourceExpr="Line Discount %" }

    { 68  ;2   ;Column  ;LineAmt_PurchLine   ;
               SourceExpr="Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 84  ;2   ;Column  ;AllowInvDisc_PurchLine;
               SourceExpr="Allow Invoice Disc." }

    { 89  ;2   ;Column  ;VATIdentifier_PurchLine;
               SourceExpr="VAT Identifier" }

    { 79  ;2   ;Column  ;InvDiscAmt_PurchLine;
               SourceExpr=-"Inv. Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 141 ;2   ;Column  ;TotalInclVAT        ;
               SourceExpr="Line Amount" - "Inv. Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 43  ;2   ;Column  ;DirectUniCost_Lbl   ;
               SourceExpr=DirectUniCostCaptionLbl }

    { 44  ;2   ;Column  ;PurchLineLineDisc_Lbl;
               SourceExpr=PurchLineLineDiscCaptionLbl }

    { 80  ;2   ;Column  ;VATDiscountAmount_Lbl;
               SourceExpr=VATDiscountAmountCaptionLbl }

    { 72  ;2   ;Column  ;No_PurchLine_Lbl    ;
               SourceExpr=FIELDCAPTION("No.") }

    { 73  ;2   ;Column  ;Desc_PurchLine_Lbl  ;
               SourceExpr=FIELDCAPTION(Description) }

    { 74  ;2   ;Column  ;Qty_PurchLine_Lbl   ;
               SourceExpr=FIELDCAPTION(Quantity) }

    { 76  ;2   ;Column  ;UOM_PurchLine_Lbl   ;
               SourceExpr=ItemUnitOfMeasureCaptionLbl }

    { 77  ;2   ;Column  ;VATIdentifier_PurchLine_Lbl;
               SourceExpr=FIELDCAPTION("VAT Identifier") }

    { 81  ;2   ;Column  ;AmountIncludingVAT  ;
               SourceExpr="Amount Including VAT" }

    { 142 ;2   ;Column  ;TotalPriceCaption_Lbl;
               SourceExpr=TotalPriceCaptionLbl }

    { 138 ;2   ;Column  ;InvDiscCaption_Lbl  ;
               SourceExpr=InvDiscCaptionLbl }

    { 59  ;1   ;DataItem;Totals              ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnAfterGetRecord=VAR
                                  TempPrepmtPurchLine@1000 : TEMPORARY Record 39;
                                BEGIN
                                  CLEAR(TempPurchLine);
                                  CLEAR(PurchPost);
                                  TempPurchLine.DELETEALL;
                                  TempVATAmountLine.DELETEALL;
                                  PurchPost.GetPurchLines("Purchase Header",TempPurchLine,0);
                                  TempPurchLine.CalcVATAmountLines(0,"Purchase Header",TempPurchLine,TempVATAmountLine);
                                  TempPurchLine.UpdateVATOnLines(0,"Purchase Header",TempPurchLine,TempVATAmountLine);
                                  VATAmount := TempVATAmountLine.GetTotalVATAmount;
                                  VATBaseAmount := TempVATAmountLine.GetTotalVATBase;
                                  VATDiscountAmount :=
                                    TempVATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code","Purchase Header"."Prices Including VAT");
                                  TotalAmountInclVAT := TempVATAmountLine.GetTotalAmountInclVAT;

                                  TempPrepaymentInvLineBuffer.DELETEALL;
                                  PurchasePostPrepayments.GetPurchLines("Purchase Header",0,TempPrepmtPurchLine);
                                  IF NOT TempPrepmtPurchLine.ISEMPTY THEN BEGIN
                                    PurchasePostPrepayments.GetPurchLinesToDeduct("Purchase Header",TempPurchLine);
                                    IF NOT TempPurchLine.ISEMPTY THEN
                                      PurchasePostPrepayments.CalcVATAmountLines("Purchase Header",TempPurchLine,TempPrePmtVATAmountLineDeduct,1);
                                  END;
                                  PurchasePostPrepayments.CalcVATAmountLines("Purchase Header",TempPrepmtPurchLine,TempPrepmtVATAmountLine,0);
                                  TempPrepmtVATAmountLine.DeductVATAmountLine(TempPrePmtVATAmountLineDeduct);
                                  PurchasePostPrepayments.UpdateVATOnLines("Purchase Header",TempPrepmtPurchLine,TempPrepmtVATAmountLine,0);
                                  PurchasePostPrepayments.BuildInvLineBuffer2("Purchase Header",TempPrepmtPurchLine,0,TempPrepaymentInvLineBuffer);
                                  PrepmtVATAmount := TempPrepmtVATAmountLine.GetTotalVATAmount;
                                  PrepmtVATBaseAmount := TempPrepmtVATAmountLine.GetTotalVATBase;
                                  PrepmtTotalAmountInclVAT := TempPrepmtVATAmountLine.GetTotalAmountInclVAT;
                                END;
                                 }

    { 94  ;2   ;Column  ;VATAmountText       ;
               SourceExpr=TempVATAmountLine.VATAmountText }

    { 87  ;2   ;Column  ;TotalVATAmount      ;
               SourceExpr=VATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 75  ;2   ;Column  ;TotalVATDiscountAmount;
               SourceExpr=-VATDiscountAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 71  ;2   ;Column  ;TotalVATBaseAmount  ;
               SourceExpr=VATBaseAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 61  ;2   ;Column  ;TotalAmountInclVAT  ;
               SourceExpr=TotalAmountInclVAT;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 158 ;2   ;Column  ;TotalInclVATText    ;
               SourceExpr=TotalInclVATText }

    { 157 ;2   ;Column  ;TotalExclVATText    ;
               SourceExpr=TotalExclVATText }

    { 124 ;2   ;Column  ;TotalSubTotal       ;
               SourceExpr=TotalSubTotal;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 123 ;2   ;Column  ;TotalInvoiceDiscountAmount;
               SourceExpr=TotalInvoiceDiscountAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 122 ;2   ;Column  ;TotalAmount         ;
               SourceExpr=TotalAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 32  ;2   ;Column  ;TotalText           ;
               SourceExpr=TotalText }

    { 6558;1   ;DataItem;VATCounter          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF VATAmount = 0 THEN
                                 CurrReport.BREAK;
                               SETRANGE(Number,1,TempVATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(
                                 TempVATAmountLine."Line Amount",TempVATAmountLine."Inv. Disc. Base Amount",
                                 TempVATAmountLine."Invoice Discount Amount",TempVATAmountLine."VAT Base",TempVATAmountLine."VAT Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  TempVATAmountLine.GetLine(Number);
                                END;
                                 }

    { 159 ;2   ;Column  ;VATAmtLineVATBase   ;
               SourceExpr=TempVATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 156 ;2   ;Column  ;VATAmtLineVATAmt    ;
               SourceExpr=TempVATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 155 ;2   ;Column  ;VATAmtLineLineAmt   ;
               SourceExpr=TempVATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 153 ;2   ;Column  ;VATAmtLineInvDiscBaseAmt;
               SourceExpr=TempVATAmountLine."Inv. Disc. Base Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 151 ;2   ;Column  ;VATAmtLineInvDiscAmt;
               SourceExpr=TempVATAmountLine."Invoice Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 148 ;2   ;Column  ;VATAmtLineVAT       ;
               DecimalPlaces=0:5;
               SourceExpr=TempVATAmountLine."VAT %" }

    { 146 ;2   ;Column  ;VATAmtLineVATIdentifier;
               SourceExpr=TempVATAmountLine."VAT Identifier" }

    { 2038;1   ;DataItem;VATCounterLCY       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF (NOT GLSetup."Print VAT specification in LCY") OR
                                  ("Purchase Header"."Currency Code" = '') OR
                                  (TempVATAmountLine.GetTotalVATAmount = 0)
                               THEN
                                 CurrReport.BREAK;

                               SETRANGE(Number,1,TempVATAmountLine.COUNT);

                               IF GLSetup."LCY Code" = '' THEN
                                 VALSpecLCYHeader := VATAmountSpecificationLbl + LocalCurrentyLbl
                               ELSE
                                 VALSpecLCYHeader := VATAmountSpecificationLbl + FORMAT(GLSetup."LCY Code");

                               CurrExchRate.FindCurrency("Purchase Header"."Posting Date","Purchase Header"."Currency Code",1);
                               VALExchRate := STRSUBSTNO(ExchangeRateLbl,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  TempVATAmountLine.GetLine(Number);
                                  VALVATBaseLCY :=
                                    TempVATAmountLine.GetBaseLCY(
                                      "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
                                  VALVATAmountLCY :=
                                    TempVATAmountLine.GetAmountLCY(
                                      "Purchase Header"."Posting Date","Purchase Header"."Currency Code","Purchase Header"."Currency Factor");
                                END;
                                 }

    { 195 ;2   ;Column  ;VALExchRate         ;
               SourceExpr=VALExchRate }

    { 194 ;2   ;Column  ;VALSpecLCYHeader    ;
               SourceExpr=VALSpecLCYHeader }

    { 192 ;2   ;Column  ;VALVATAmountLCY     ;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 190 ;2   ;Column  ;VALVATBaseLCY       ;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 1849;1   ;DataItem;PrepmtLoop          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempPrepaymentInvLineBuffer.FIND('-') THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF TempPrepaymentInvLineBuffer.NEXT = 0 THEN
                                      CurrReport.BREAK;

                                  IF "Purchase Header"."Prices Including VAT" THEN
                                    PrepmtLineAmount := TempPrepaymentInvLineBuffer."Amount Incl. VAT"
                                  ELSE
                                    PrepmtLineAmount := TempPrepaymentInvLineBuffer.Amount;
                                END;
                                 }

    { 175 ;2   ;Column  ;PrepmtLineAmount    ;
               SourceExpr=PrepmtLineAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 172 ;2   ;Column  ;PrepmtInvBufGLAccNo ;
               SourceExpr=TempPrepaymentInvLineBuffer."G/L Account No." }

    { 174 ;2   ;Column  ;PrepmtInvBufDesc    ;
               SourceExpr=TempPrepaymentInvLineBuffer.Description }

    { 144 ;2   ;Column  ;TotalInclVATText2   ;
               SourceExpr=TotalInclVATText }

    { 143 ;2   ;Column  ;TotalExclVATText2   ;
               SourceExpr=TotalExclVATText }

    { 183 ;2   ;Column  ;PrepmtInvBufAmt     ;
               SourceExpr=TempPrepaymentInvLineBuffer.Amount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 184 ;2   ;Column  ;PrepmtVATAmountText ;
               SourceExpr=TempPrepmtVATAmountLine.VATAmountText }

    { 185 ;2   ;Column  ;PrepmtVATAmount     ;
               SourceExpr=PrepmtVATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 191 ;2   ;Column  ;PrepmtTotalAmountInclVAT;
               SourceExpr=PrepmtTotalAmountInclVAT;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 193 ;2   ;Column  ;PrepmtVATBaseAmount ;
               SourceExpr=PrepmtVATBaseAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 169 ;2   ;Column  ;PrepmtInvBuDescCaption;
               SourceExpr=PrepmtInvBuDescCaptionLbl }

    { 170 ;2   ;Column  ;PrepmtInvBufGLAccNoCaption;
               SourceExpr=PrepmtInvBufGLAccNoCaptionLbl }

    { 171 ;2   ;Column  ;PrepaymentSpecCaption;
               SourceExpr=PrepaymentSpecCaptionLbl }

    { 3388;1   ;DataItem;PrepmtVATCounter    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,TempPrepmtVATAmountLine.COUNT);
                             END;

               OnAfterGetRecord=BEGIN
                                  TempPrepmtVATAmountLine.GetLine(Number);
                                END;
                                 }

    { 205 ;2   ;Column  ;PrepmtVATAmtLineVATAmt;
               SourceExpr=TempPrepmtVATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 206 ;2   ;Column  ;PrepmtVATAmtLineVATBase;
               SourceExpr=TempPrepmtVATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 207 ;2   ;Column  ;PrepmtVATAmtLineLineAmt;
               SourceExpr=TempPrepmtVATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 208 ;2   ;Column  ;PrepmtVATAmtLineVAT ;
               DecimalPlaces=0:5;
               SourceExpr=TempPrepmtVATAmountLine."VAT %" }

    { 198 ;2   ;Column  ;PrepmtVATAmtLineVATId;
               SourceExpr=TempPrepmtVATAmountLine."VAT Identifier" }

    { 203 ;2   ;Column  ;PrepymtVATAmtSpecCaption;
               SourceExpr=PrepymtVATAmtSpecCaptionLbl }

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

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnInit=BEGIN
               LogInteractionEnable := TRUE;
               ArchiveDocument := PurchSetup."Archive Quotes and Orders";
             END;

      OnOpenPage=BEGIN
                   LogInteractionEnable := LogInteraction;
                 END;

    }
    CONTROLS
    {
      { 6   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 5   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 2   ;2   ;Field     ;
                  Name=ArchiveDocument;
                  CaptionML=[DAN=ArkivÇr dokument;
                             ENU=Archive Document];
                  ToolTipML=[DAN=Angiver, om ordren skal arkiveres.;
                             ENU=Specifies whether to archive the order.];
                  ApplicationArea=#Suite;
                  SourceExpr=ArchiveDocument }

      { 1   ;2   ;Field     ;
                  Name=LogInteraction;
                  CaptionML=[DAN=Logfõr interaktion;
                             ENU=Log Interaction];
                  ToolTipML=[DAN=Angiver, om du vil logfõre denne interaktion.;
                             ENU=Specifies if you want to log this interaction.];
                  ApplicationArea=#Suite;
                  SourceExpr=LogInteraction;
                  Enabled=LogInteractionEnable }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      PageLbl@1040 : TextConst '@@@="%1 = Page No.";DAN=Side %1;ENU=Page %1';
      VATAmountSpecificationLbl@1039 : TextConst 'DAN="Momsbelõbsspecifikation i ";ENU="VAT Amount Specification in "';
      LocalCurrentyLbl@1038 : TextConst 'DAN=Lokal valuta;ENU=Local Currency';
      ExchangeRateLbl@1037 : TextConst '@@@="%1 = CurrExchRate.""Relational Exch. Rate Amount"", %2 = CurrExchRate.""Exchange Rate Amount""";DAN=Valutakurs: %1/%2;ENU=Exchange rate: %1/%2';
      CompanyInfoPhoneNoCaptionLbl@1036 : TextConst 'DAN=Telefonnr.;ENU=Phone No.';
      CompanyInfoGiroNoCaptionLbl@1034 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      CompanyInfoBankNameCaptionLbl@1033 : TextConst 'DAN=Bank;ENU=Bank';
      CompanyInfoBankAccNoCaptionLbl@1032 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      OrderNoCaptionLbl@1031 : TextConst 'DAN=Ordrenr.;ENU=Order No.';
      PageCaptionLbl@1030 : TextConst 'DAN=Side;ENU=Page';
      DocumentDateCaptionLbl@1029 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      DirectUniCostCaptionLbl@1027 : TextConst 'DAN=Enhedspris;ENU=Unit Price';
      PurchLineLineDiscCaptionLbl@1026 : TextConst 'DAN=Rabatprocent;ENU=Discount %';
      VATDiscountAmountCaptionLbl@1025 : TextConst 'DAN=Kontantrabat ved moms;ENU=Payment Discount on VAT';
      PaymentDetailsCaptionLbl@1023 : TextConst 'DAN=Betalingsdetaljer;ENU=Payment Details';
      VendNoCaptionLbl@1022 : TextConst 'DAN=Kreditornummer;ENU=Vendor No.';
      ShiptoAddressCaptionLbl@1021 : TextConst 'DAN=Leveringsadresse;ENU=Ship-to Address';
      PrepmtInvBuDescCaptionLbl@1020 : TextConst 'DAN=Beskrivelse;ENU=Description';
      PrepmtInvBufGLAccNoCaptionLbl@1019 : TextConst 'DAN=Finanskontonr.;ENU=G/L Account No.';
      PrepaymentSpecCaptionLbl@1018 : TextConst 'DAN=Forudbetalingsspecifikation;ENU=Prepayment Specification';
      PrepymtVATAmtSpecCaptionLbl@1017 : TextConst 'DAN=Specifikation af momsbelõb til forudbetaling;ENU=Prepayment VAT Amount Specification';
      AmountCaptionLbl@1016 : TextConst 'DAN=Belõb;ENU=Amount';
      PurchLineInvDiscAmtCaptionLbl@1015 : TextConst 'DAN=Fakturarabatbelõb;ENU=Invoice Discount Amount';
      SubtotalCaptionLbl@1014 : TextConst 'DAN=Subtotal;ENU=Subtotal';
      VATAmtLineVATCaptionLbl@1013 : TextConst 'DAN=Momspct.;ENU=VAT %';
      VATAmtLineVATAmtCaptionLbl@1012 : TextConst 'DAN=Momsbelõb;ENU=VAT Amount';
      VATAmtSpecCaptionLbl@1011 : TextConst 'DAN=Momsbelõbspecifikation;ENU=VAT Amount Specification';
      VATIdentifierCaptionLbl@1010 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      VATAmtLineInvDiscBaseAmtCaptionLbl@1009 : TextConst 'DAN=Grundbelõb for fakturarabat;ENU=Invoice Discount Base Amount';
      VATAmtLineLineAmtCaptionLbl@1008 : TextConst 'DAN=Linjebelõb;ENU=Line Amount';
      VALVATBaseLCYCaptionLbl@1007 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      PricesInclVATtxtLbl@1048 : TextConst 'DAN=Priser inkl. moms;ENU=Prices Including VAT';
      TotalCaptionLbl@1006 : TextConst 'DAN=I alt;ENU=Total';
      PaymentTermsDescCaptionLbl@1005 : TextConst 'DAN=Betalingsbetingelser;ENU=Payment Terms';
      ShipmentMethodDescCaptionLbl@1004 : TextConst 'DAN=Leveringsform;ENU=Shipment Method';
      PrepymtTermsDescCaptionLbl@1003 : TextConst 'DAN=Betalingsbetingelser for forudbetaling;ENU=Prepmt. Payment Terms';
      HomePageCaptionLbl@1002 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      EmailIDCaptionLbl@1001 : TextConst 'DAN=Mail;ENU=Email';
      AllowInvoiceDiscCaptionLbl@1000 : TextConst 'DAN=Tillad fakturarabat;ENU=Allow Invoice Discount';
      GLSetup@1106 : Record 98;
      CompanyInfo@1105 : Record 79;
      ShipmentMethod@1104 : Record 10;
      PaymentTerms@1103 : Record 3;
      PrepmtPaymentTerms@1102 : Record 3;
      SalespersonPurchaser@1101 : Record 13;
      TempVATAmountLine@1100 : TEMPORARY Record 290;
      TempPrepmtVATAmountLine@1099 : TEMPORARY Record 290;
      TempPurchLine@1097 : TEMPORARY Record 39;
      TempPrepaymentInvLineBuffer@1093 : TEMPORARY Record 461;
      TempPrePmtVATAmountLineDeduct@1035 : TEMPORARY Record 290;
      RespCenter@1092 : Record 5714;
      Language@1091 : Record 8;
      CurrExchRate@1090 : Record 330;
      PurchSetup@1089 : Record 312;
      FormatAddr@1087 : Codeunit 365;
      FormatDocument@1086 : Codeunit 368;
      PurchPost@1085 : Codeunit 90;
      SegManagement@1083 : Codeunit 5051;
      PurchasePostPrepayments@1028 : Codeunit 444;
      ArchiveManagement@1065 : Codeunit 5063;
      VendAddr@1081 : ARRAY [8] OF Text[50];
      ShipToAddr@1080 : ARRAY [8] OF Text[50];
      CompanyAddr@1079 : ARRAY [8] OF Text[50];
      BuyFromAddr@1078 : ARRAY [8] OF Text[50];
      PurchaserText@1077 : Text[30];
      VATNoText@1076 : Text[80];
      ReferenceText@1075 : Text[80];
      TotalText@1074 : Text[50];
      TotalInclVATText@1073 : Text[50];
      TotalExclVATText@1072 : Text[50];
      FormattedQuanitity@1064 : Text;
      FormattedDirectUnitCost@1070 : Text;
      OutputNo@1067 : Integer;
      DimText@1066 : Text[120];
      LogInteraction@1061 : Boolean;
      VATAmount@1060 : Decimal;
      VATBaseAmount@1059 : Decimal;
      VATDiscountAmount@1058 : Decimal;
      TotalAmountInclVAT@1057 : Decimal;
      VALVATBaseLCY@1056 : Decimal;
      VALVATAmountLCY@1055 : Decimal;
      VALSpecLCYHeader@1054 : Text[80];
      VALExchRate@1053 : Text[50];
      PrepmtVATAmount@1052 : Decimal;
      PrepmtVATBaseAmount@1051 : Decimal;
      PrepmtTotalAmountInclVAT@1050 : Decimal;
      PrepmtLineAmount@1049 : Decimal;
      AllowInvDisctxt@1047 : Text[30];
      LogInteractionEnable@1024 : Boolean INDATASET;
      TotalSubTotal@1044 : Decimal;
      TotalAmount@1043 : Decimal;
      TotalInvoiceDiscountAmount@1042 : Decimal;
      DocumentTitleLbl@1068 : TextConst 'DAN=Kõbsordre;ENU=Purchase Order';
      CompanyLogoPosition@1069 : Integer;
      ReceivebyCaptionLbl@1071 : TextConst 'DAN=Modtag af;ENU=Receive By';
      BuyerCaptionLbl@1107 : TextConst 'DAN=Kõber;ENU=Buyer';
      ItemNumberCaptionLbl@1108 : TextConst 'DAN=Varenr.;ENU=Item No.';
      ItemDescriptionCaptionLbl@1109 : TextConst 'DAN=Beskrivelse;ENU=Description';
      ItemQuantityCaptionLbl@1110 : TextConst 'DAN=Antal;ENU=Quantity';
      ItemUnitCaptionLbl@1111 : TextConst 'DAN=Enhed;ENU=Unit';
      ItemUnitPriceCaptionLbl@1112 : TextConst 'DAN=Enhedspris;ENU=Unit Price';
      ItemLineAmountCaptionLbl@1113 : TextConst 'DAN=Linjebelõb;ENU=Line Amount';
      PricesIncludingVATCaptionLbl@1114 : TextConst 'DAN=Priser inkl. moms;ENU=Prices Including VAT';
      ItemUnitOfMeasureCaptionLbl@1115 : TextConst 'DAN=Enhed;ENU=Unit';
      ToCaptionLbl@1123 : TextConst 'DAN=Til:;ENU=To:';
      VendorIDCaptionLbl@1122 : TextConst 'DAN=Kreditor-id;ENU=Vendor ID';
      ConfirmToCaptionLbl@1121 : TextConst 'DAN=Bekrëft til;ENU=Confirm To';
      PurchOrderCaptionLbl@1120 : TextConst 'DAN=KùBSORDRE;ENU=PURCHASE ORDER';
      PurchOrderNumCaptionLbl@1119 : TextConst 'DAN=Kõbsordrenummer:;ENU=Purchase Order Number:';
      PurchOrderDateCaptionLbl@1118 : TextConst 'DAN=Kõbsordredato:;ENU=Purchase Order Date:';
      TaxIdentTypeCaptionLbl@1117 : TextConst 'DAN=Skatteregistreringstype;ENU=Tax Ident. Type';
      TotalPriceCaptionLbl@1126 : TextConst 'DAN=Salgsbelõb;ENU=Total Price';
      InvDiscCaptionLbl@1124 : TextConst 'DAN=Fakturarabat:;ENU=Invoice Discount:';
      GreetingLbl@1062 : TextConst 'DAN=Hej;ENU=Hello';
      ClosingLbl@1046 : TextConst 'DAN=Med venlig hilsen;ENU=Sincerely';
      BodyLbl@1045 : TextConst 'DAN=Kõbsordren er vedhëftet denne meddelelse.;ENU=The purchase order is attached to this message.';
      OrderDateLbl@1041 : TextConst 'DAN=Ordredato;ENU=Order Date';
      ArchiveDocument@1063 : Boolean;

    PROCEDURE InitializeRequest@4(LogInteractionParam@1003 : Boolean);
    BEGIN
      LogInteraction := LogInteractionParam;
    END;

    LOCAL PROCEDURE FormatAddressFields@1(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
      FormatAddr.GetCompanyAddr(PurchaseHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
      FormatAddr.PurchHeaderBuyFrom(BuyFromAddr,PurchaseHeader);
      IF PurchaseHeader."Buy-from Vendor No." <> PurchaseHeader."Pay-to Vendor No." THEN
        FormatAddr.PurchHeaderPayTo(VendAddr,PurchaseHeader);
      FormatAddr.PurchHeaderShipTo(ShipToAddr,PurchaseHeader);
    END;

    LOCAL PROCEDURE FormatDocumentFields@2(PurchaseHeader@1000 : Record 38);
    BEGIN
      WITH PurchaseHeader DO BEGIN
        FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
        FormatDocument.SetPurchaser(SalespersonPurchaser,"Purchaser Code",PurchaserText);
        FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
        FormatDocument.SetPaymentTerms(PrepmtPaymentTerms,"Prepmt. Payment Terms Code","Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

        ReferenceText := FormatDocument.SetText("Your Reference" <> '',FIELDCAPTION("Your Reference"));
        VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FIELDCAPTION("VAT Registration No."));
      END;
    END;

    LOCAL PROCEDURE InitLogInteraction@5();
    BEGIN
      LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';
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
      <rd:DataSourceID>10f45945-7138-43aa-a536-5751e9f796ae</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <ReportSections>
    <ReportSection>
      <Body>
        <Height>2in</Height>
        <Style />
      </Body>
      <Width>6.5in</Width>
      <Page>
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
  <rd:ReportUnitType>Inch</rd:ReportUnitType>
  <rd:ReportID>0eeb6585-38ae-40f1-885b-8d50088d51b4</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
  WORDLAYOUT
  {
    UEsDBBQABgAIAAAAIQD768Nq2QEAACsMAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzJZNb9swDIbvA/YfDF2HWGkPwzDE6aHdjluBZcCuqg==
    RDvC9AWRaZt/P8lOvKFLa2Oe214C2CLf96Hp0Fxd3FtT3EJE7V3FzsolK8BJr7RrKvZ983nxgRVIwilhvIOK7QHZxfrtm9VmHwCLlO2wYlui8JFzlFuwAksfwKWT2kcrKF3Ghg==
    ByF/igb4+XL5nkvvCBwtKGuw9eoKarEzVHy6T7c7kuAaVlx2cdmqYtrm/Hyfn8yIYPBBigjBaCkonfNbpx5wLQ5MZcpsY3CrA75LAY845JPHDQ55X9PDjFpBcS0ifRE2RfE7Hw==
    FVde7mzKLJ+WOcHp61pL6POzWoheAmLqkjVlf2KFdkf+Uxxyh+TtD2u4JrDX0Qc8m4zTi2Y9iKShf4YjGc6fm6HtB9LeAP7/bnS6w/ZAlBLmADgoDyLcwc232Sj+EB8Eqb0n5w==
    aY5u9NKDEODUTAxH5UGELQgFcfpf8i+CTnhUH2bx74RH1j99HEyrfwb/kfXXyXIjbgzMQXCQHoRojEcUcf8cH6yj13ioF57avzlefnz3LK9mjvdEr+JFprSMQvc7faS1Mk9Zpg==
    yHaZSctt/Ieyj7tozl6EUVtM75ikJ9cHec1VoE5483bVX/8CAAD//wMAUEsDBBQABgAIAAAAIQAekRq37wAAAE4CAAALAAgCX3JlbHMvLnJlbHMgogQCKKAAAgAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAArJLBasMwDEDvg/2D0b1R2sEYo04vY9DbGNkHCFtJTBPb2GrX/v082NgCXelhR8vS05PQenOcRnXglF3wGpZVDYq9Cdb5XsNb+7x4AJWFvKUxeNZw4gyb5vZm/cojSSnKgw==
    i1kVis8aBpH4iJjNwBPlKkT25acLaSIpz9RjJLOjnnFV1/eYfjOgmTHV1mpIW3sHqj1FvoYdus4ZfgpmP7GXMy2Qj8Lesl3EVOqTuDKNain1LBpsMC8lnJFirAoa8LzR6nqjvw==
    p8WJhSwJoQmJL/t8ZlwSWv7niuYZPzbvIVm0X+FvG5xdQfMBAAD//wMAUEsDBBQABgAIAAAAIQBU+GRCYwEAAO4HAAAcAAgBd29yZC9fcmVscy9kb2N1bWVudC54bWwucmVscw==
    IKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALxVy07DMBC8I/EPke/ESYDyUJNeEFKvECSubrx5iMSO7C2Qvw==
    xzTk0VJZHFyOOxvPjGad9XL12dTeOyhdSRGT0A+IByKTvBJFTF7Sx4tb4mlkgrNaCohJB5qskvOz5RPUDM0hXVat9gyL0DEpEdt7SnVWQsO0L1sQppNL1TA0pSpoy7I3VgCNgg==
    YEHVnIMke5zemsdErbnRT7sW/sIt87zK4EFm2wYEHpGgJTAOyjAyVQAazl0d+oaI0OP64aVLA0UttWaqG76ZrAwdyn9aNlNOPWnsajPV0Ulf2+RvXMqD4ELi3MCAWMcSufSQSw==
    gSnb1DCZGCGbC6cmsq1G2bwatdGE708orRCayJrJf7ux/jgLtwOSeHBLRsgaidNMviXn66OvrTO5dqn/AZtnQDS7eZbDDLQmEZx+kVqTuHK6s37FMCA2C3envwz2t8RpBmjOzg==
    Ftau7MHRBN17pZMvAAAA//8DAFBLAwQUAAYACAD3ai1J1ZeUABoRAACtBAEAEQAAAHdvcmQvZG9jdW1lbnQueG1s7V3dcqNIln4Vh+ZirtzK/0wc45oAhLoqorrGW+Wu3oiNjQ==
    CixhmykJFID/emKebC/2kfYVNvk1CJCRhGQkcWOZBA6Z5+T35TnJyeT//ud///b35/ns7NHyfNt1LgfwFzA4s5yJO7Wdu8vBQ3B7LgZnfmA6U3PmOtbl4MXyB3//8Leni6k7eQ==
    mFtOcCYFOP7F02JyObgPgsXFcOhP7q256f8ytyee67u3wS8Tdz50b2/tiTV8cr3pEAEIov8WnjuxfF8+TTedR9MfJOImz82kTT3zSd4cCiTDyb3pBdbzqwy4thA6VIaiLAhtIA==
    SLYQwbIovLYoNgxrVRJENhIka1WSRDeTVGrcvNwF3IXlyJO3rjc3A3no3Q3npvfzYXEuBS/MwL6xZ3bwImUClopxZcfznItExHlWl/CWi7guyU96h9fkufEto6TbRk8cetZM1g==
    wXX8e3uR9b35ptLkyftUyOOqRjzOZ4MMN7ChIeuAM4rN8iqwSfUTW85ncc1XS4SggUVCEdkdTapQfGZak7lpO68P3kg1OeXChl07FYBKAphvrSeCJiKG/sv8FRpPi7vtrPyr5w==
    PixepdnbSfvk/MxkOes1MOkt+R7sb1eZb/fmQkJ5Prn4dOe4nnkzkzWStj+T5juLLHAWomQQjjo37vQl/A1uZsnPlZf88y14mckrLx7N2eXgOpTyq2fLLjlMzv8hz8mOKQc4eQ==
    +LKQzzAfAvf1vCYrJcfB6MhdpIIcOeqFd0zcmeultzxd+H8mkvyFObGi/yM5M+s22PDWGzcI3PmGN3v23f2mD7Yd355aH7e6+/tGdw9Lir+ZfTZf3Icgs9Gt/WzljPjZdX+mjw==
    AkSNRN7anh98daVtYXg4M5Oj15O6O3uYO7nzaUF0ieN+1KSDkx19j49gropZJwu7VPjvnfyVQuIuhRQskioWyiEWqKq87vqsfFh4VuDJ09JBm36VVQSKgCNoDJKiay8sMwgFYw==
    bRBfnNTV+2jl+wRGJBOdXjKJ/6ZHf+Rrkep/+mxm9yVXLtLqXEUPFwZTARzU1/EqLOIqghxkV42sW/NhFuQujiQnDyhA+aNlht4oTDQmO8fMdqzPj7OsH6QVjG4Pf5PqrmhkbA==
    miaN7Fh7/GmQ/MSyzZlt+umdf/liPl6cDa8ePOmZ+daP8FGWN/wmvZvAVadTTxLuj883sxRP5l3xzm+Ro+9Nf2QS/hFCcwgxSjuyPU1vOYecyF7FAUibsphJbN+7M3lLEiFcSQ==
    /zC9XoEaNYSq6VQQgvhINbiCR2OmijFRMVWzVi9JMQNTs51QZVLSwrMkI/xmLhbyWI478RDk+ODyr6GH8uqZTF8cUx755475KN28hesF/nBV+4Z/DY35LH3S+8vBUEq8kCr5Qw==
    UtPX6Ob/nM/CxvwX/O/o3JKK0+KSpuWJiPUC17M+Bdb80+hy8K8xVCnFI/Vcx2N0TnSDnQtjZJxDOBopClE4G/N/pzaynoNEMZnN5T+GM73y4ivkke46gfRCWwQ1JggD/S1Qjw==
    Vc51ugcQhIZ33VvD87I2+AtrJsd8aZN0CKxsQaSFDyW7RE2P5K+QLpWc1SKD4LCo8WEGyROg02jwWHtIWqasZPjxxlKHIXVN/EB6jVI5c1u6fx9V6VCkVfCak5z28DL23HloYw==
    2Aq/QQipBCNTeCN6o4oYjbCqjSnERFCqGHTEkIQ0UnWDAHIM9JbX8aEyWzN8QY0ZbLQJvr6436SLG4XPw016+yvlbQiW4EPeTAWi24rItnaZ3l+nb/hSuyGmcOy5dtvjpXNIOA==
    59KJoqQnppzflei456XO8lLOShvQ0n7QqofT0s5L4iq2g1hKMJaREmkWJ/GRYmAZWoGRrhGhjRWdj5Eie7BBDARH4BjwuqTlHrOdxeySpdbG7YGEDKitoRkiSBlsCPVTGJrzSg==
    7nG+c5xXVryFQAL1gUR3AomW2ApJHChI+iY9WZXiiJ6ruuuT5Kx0IHFES4ClAEvAAYU1AqxQAVKQ4BAIQHTIVE0bGWNKCVENyhR8DIBdUnMP2s6CdslSxxpI4FaQDgVUZBQBUA==
    P8VXEUfgHuYHG0fgPo7oThzRDllJhAlIMMG8mV9yCmyV03FPVp31SXJWOpBAoiXEEgUQwTBqBlgd62JMEIGKphN9DBVVQF1wOjY0iJgujgGwS2ruQdtZ0C5Z6lgDCdIO0hHjQA==
    MJAlHPdDc17HPcwPNpAgfSDRnUCiHbKCEDIu/QrWv5AoxxE9V3XXJclZ6UDiiJYAixDEmACkNAIsI4RKdCtgrALCyEgQDgk1xhDqqjSzcgyAXVJzD9rOgnbJUscaR9BWkI4gwQ==
    GGAq+qG5Io6gPcwPNo6gfRzRnTiiJbJigHIFA9pzVSmM6Kmqux5JzkoHEka0g1eoCCyAghoCVhNjrKmIGxhzYkCqQmGMAeQqYVRB+lEAdknNPWg7C9olS7UVRowZVnX0zmHEdw==
    9fqLey27Tkt5AkJBEBBKmr2MYJqmUawipqqCECC0saBkhBRVhiFQp/ox4DzT8K4Q3iamy/3yqlyUh29yZg/wbbA9xKYAz0xUgHbdI9fbM2JvMP5q3X1x414cF7b0dlERTBBEmw==
    DdwnAuiSrt8P2+tFpCeJ7ZK1dgDz42XepfmCE2lo4rOFP/E+hIX6cxWoFBc9XEqgUbldT3Jxbf2jA1isvP9nNtMBajBz47o/w41WI5TIqyUVyjb++NXVzMnPsB729DK382B8sQ==
    7NSFM3Gbn/rNFvvNFju02SJkqTa2KseckNxDqzdbNBSGSLbBWRyFoREEGq6Mwpo4Y1fmS7hj8LXlzf2R5U9a248PYo4BRkrDtecJB129XvRDBmiUAIilb3YMrliVpjszkRL1yg==
    5hMpxY5Y0Tff2BUuubh2mNn9fny5GgQfqkyzh/Cq4atTCYXWQEkQFpiwhksjjh+UmXpPFokAk5G+XyTGoMtU3xGkfbUmlv1o3by0uCUtxgQpCKB+DIyLCzo+Wch1a/Ar2KQjWA==
    DF89hiPyb1Zw705b9UsZ5xxAhEAPyexdfFnVXcFmHBadLDarjdM6SGte+u0h3GxnnFU4VrhAGPWYrgw1u4Lm3Yy0xVf4dWhu6pYu664rI6I5s/yo8MryfNf5Ys6tdsZDJADlHA==
    NXsJfvzYqVL0yeIHElVD6+GnSn8dwZDxvAikt7sIRkHWfVp8/RxuhI0JUJRmSenHD6V6fZ8qoMaSajWxHqDqtdgRWJWd1HbgBAgHSFDWz1XWRWpdgdFuorR2/bqy9vYVRlUtwQ==
    2jaM8uyJ5X9yJrPv6nU+W6S1aRIEAKWEI9jPkyTFq1TeFSA2H89qcp/rP6E1xtwQe/6EVhKRrdJ8R8bAJO06TuCy/cCLvuP7xW3vzR2UPYZy2sdpxSUJlRrv4bhDOK5SfLfQ+A==
    q+25bUIQA4Yppg23FzgZCL6q+QRw9x5fkizg7lXb+8sMbu7fv7c+q/Ji39MfbymPQMDwBCL9C443nPGjYaAVc0i5kX9rF7pbA3bJp2hpIgkhiiDm/bi92nU+AfAIA47G4/XAUw==
    p65uYSf2C9oZbzALJ14562PNCkf3BFCSd8o2ck8PyDV9UwuZvMyhDH8qFlpVTGHXL7R6K9Foo4VWsSaftlghFY2VZX0+9Yuk+kVSmy+SkgyY1LC45glipao8/EJUVXmNGIgEqg==
    LMfZAFZdPnxasdSKYKIrxSCRKkToSWpeumbX+2jlexYlPBPtZdS+fjyZHn+Wwe4wXRAcHrSXnE6AgoHCRZ+bvlQcqjktXFZ9Vwb/CAoVLD3JcUWRL32p9Fkd85BK5skLe1Rn9g==
    nZMKi0W/8ZZ3Kcs2LFIZMXBxLfWKXNwYgu8w1bZs9Y54+kVWiLKB2+cFqgAEGIO8p4V6WijrvivEEI+pPTPsiBnKhu8kN/xH8LILasAKAEz002grmKGk+a4QQ+xU98SQJ4Z/Tg==
    0hNReNg+XZR6QyfZ4vd//LaLAANygbk0VJ8PvYowSsrvCmGcQojxflk0JbN3khlGtmdNgt8dW3f9oL0luESag0DQ7GvCJ8oLJdV3hRfi6bbOEsOuOWDnPkPJ8J1khu/q9aeplA==
    at/aEpDtew+QUU4QwX2+6yqSWGGFztBFNNveWbp4Fz9i5xyyol90hE3CLhlWSZ27D057rsU5pIIzCfxsl703viWsczwmUBNMwUTeqQFGCNb5WOUqHMOjYI6yqntuaJ0bmMGAoQ==
    VHFDcnFnuKHcHVqnhJrE22IWcPxOVVUQp/rKd6owzvC4//owk5Wxns1JsPyOdYsQNpfKsG83taiPt4aY+OK2QtWCGbd7m9BrcBXFNZl2PVINbkZlzfTaQ3vbjtkkjD9SDe6yYw==
    NvJper2egl7rfcL96zVzyZaDtbrc0rBI95cKh9n1a88YtTMrhBHjkFGYTB1Delih2JJGtgjBZMtlrS0zkO38Zk3CFQnrBGQt9YL8mgHEFAhk6L31fB1m1VF3RZNDza0Vh7aR4w==
    CcWbOZ77AlUhNbStt7acAsEh6NcaNswL7cpsSqVLXD+vAUdE0NeP2NTMa9R/6qaca7FRr19rBqOyBVsArpjquYep0b0RQzFRrR1qQABTAnnTD6OeKDUUNd8VcqieyenZYTU7FA==
    bXlM/FDITGuHHojCMAEI929sm+aHdoUcqicpe3JYTQ4FUx4TNxRy09qJ22VEITCB/VaeTTNBu0INew4qyokUh8gMBUseEzOMbO93xw6izLR2GQJBAATBuM8VX50TWlZ/V5ii+g==
    hVJPFW9EGFUmPSbKqElFayfkUDhl0pfsI471c0Q7QxuV7/V62lhNGzVGPSbiiHPU2vYzBCAEIyz65e0rKKOk+lMlC6FiAsChk0XJnK3TRJJdUH+2Zk+vN1/H7j89tC6/o6LfJA==
    lavoN2vm/O4yWfNw29N8VvIw2nNk3a15vHcg7dnzYoReU0ejqWT4Wx7QyAgCAIoDmmDc0MYrBzSEwS4GsGJtIm3pjFC10vFJLq7V1hf3m7SX1NfOx6nOVHu94agz1e54H6kJLw==
    b9aPHq/dwJz58Y/xHO10fi2jjnZmpwEHDEDG+i0L4uJY2YWjnM67Ei4iRisX34Tbgcq+maV3ozfCyCUM1CClWLQ5UuryvaugsVZkWY+v4MOyCfc3k7Ql1ONljO28pcaMIkIYaQ==
    tsMZhhwTzohOASYaYBrUqUEoh0jHhlCVI8V5rPCuQHyvy0K2ZYj6BSFlhqjigC3mkYhCVUMM3qSA2Lq7miBqMuWjIcbJu3jIFfFE/Qbub8UTW2zgvvOJnk62auvpnk626ig74A==
    1lM/79uqTfYrSVwO6R3FDNlaaAEhkNEFVfp92CtdjoLCD8rpeJ8JMKJxwdVKFyM+06aLEfsNBRPtIW5YN0LI6tcOXgkVTHp7fSprbYSQKbzH65t4rQ8JcitR28Vr0Ub7cvWrJg==
    w1WGhLp6se3+JsMTfW8wfdMZV/9QWrX1VHonW3XYHXA3s3PJJ0db85bPMeUKgKSFbQaOdvjN6bwrA3A/Eb/eRHzOhAc2EZ/UvBWwK4AgDoTSLDLGY8GgSjTNwDoZc0NTyFhEwQ==
    tcqgBvGRor2g9q7gvZ+V38WsfGLkXXns4U/FZ02Lu4O9MX2XXLwLT2WpWgwgI3a4GlQruXg31fKtiURKfd3CvYqiUs6pPooqcR+h+qt1a3mWM7FekRJXeXDmSRqUfezTNF3acg==
    67pBszvSl5d1z4g++Jm7HoI3HlG6IePju29/JniHCuBRFm64c7uIY5aJO5V3Z+9S734zoz7qLi4HlEVXRxgK78aRsuIIPDsbfio2O4hbkx3Gdc0O7x6C6DBtimQR/5U05BiS8g==
    jx3MrKu7+ECOH+G3P8Mn2Y51ZQcTWXvMMmPHdo3+vXGnL9E/8p6HeQie/wdQSwMEFAAGAAgA92otSXTBVF2nBwAALSMAABAAAAB3b3JkL2hlYWRlcjIueG1s7VrrbuM2Fn4VQQ==
    +6PAAh5dLPmGcQrHdjIBkqmRZNsCbTGgJdoWRhIFkr5t0SfbH/tI+wp7SJGyZNmJY2d3u8D8iMXb+Xh47qLyr3/88+P3myQ2VpiyiKR90/lgmwZOAxJG6bxvLvms0TENxlEaog==
    mKS4b24xM7+/+rjuLUJqAG3KeqhvLjjPepbFggVOEPtAMpzC3IzQBHHo0rkVUrQGzCS2XNtuWQmKUlPRZ1FwBgJQ8SXFGgQ5Xg0kiQJKGJnxDwFJLDKbRQHWMADi2BU21lmdjQ==
    gwhrQsOcXLQySgLMGEAOUbpCTMMFmzfz41nBAlGONzsM580gvtW1OnUg9wwgOKHr1KGab4ZqWYKrGtDbNSaAgKsakn8eUu1wyUmWmCD6dZk1ADhDPJpGccS30ig1DAHXoWlPQQ==
    NApeBEkv50U9NAU9Zd+cZESCZYJTnrsBxTHwQFK2iLLC9pJz0WByoUFWLx1ilcQ7vznV9Y45zihXyw7wjHDwMqJjn6ARAVFQnMJCdc9DoW19nmhKwnVONG0N4NYAWgy/DcJXEA==
    FtsmO9dYZ/PLtHxLyTLboUWXod2lXwus9G0HVNZStmB2GTNPC5SBKydB726eEoqmMXAEujdAfYbUgCG8xBR5k09j9ZhQ1Xji2xhW9FYo7pvPgvqWRmCKlpr/CebAIH3bhuwMIw==
    2wzgs4DvVlwDO5DDZY9kGiqFjC0IAhITCDBoyYnosr/3TQnEMhRg2ZY4MZ7xM0mnhHOSnElMo/ni3I2jlEUh/nQR9Y9nUVs1wU/jIY7jB0RLwlwr0lxn4QbtnfnwvLWPBr17Qg==
    vmpGbW8gqWYRZfyRAIgjujFSvd3kkMTLJC3N6wG5JCWfrqG0K3o/5j2nxERhpMIkRXMOTwBRJtltOepElXHP9fwSiKblFKah1AwfYUt76DU9WzImhp6pGPNaze5olDtKkP8qDg==
    AuUFbtft1r3A2q3Mju8xEUNu1xnf+HrocYRnaBlzMePYLad1LTfPFFbVNSMeY72dWsFCrh55H8URYprgL5/RqmdYkyWFOoPhL58wAmuxdM6VeF/up7F2ZDSvUj7JwpuGXwqEHw==
    hLlZTtN1tQmHmqTR9LrtZqvlqZksBmtdkBgIRDckwQRqHb1aHXuyW/Sl4XR8EFbT8woL38dAHF1HqXg5AJyM4lm0eUBZBn2IoHkwTZnd/07k2l2ODbcpgh5rpGgFBUtGKGfWSw==
    Z7O+E+rZQHW16JsWIPZAHD+Bqz1K4p+TWBzlF+c3ObcnXj1ckzJMSC/mhOI7jpO7Ud/8/cYZ+H5zNGgMmzduwxuOW43OeDRuOM5o1O2CRFs37T+0fvCGK8EU+obGOA0nNF8BvQ==
    IUk57Co1QAmZjSktrJVl4NJwcKpDd+EPE2n91yPX8Ttm2YDVkNz+qnYkafeSIXp8Q+DP3LFd8GcVxlvxypuB3RmrVCXyo456oG2G6QqbV8berue4wGeS6z3vvo/9O7brNLu+4w==
    2N88ICepCPnPbP41S6+y/h5mLnR5acAeIY7fyVY7ba/T7LTa7W+2WonWQsT/fUst2+HY90fdcaVkGA3sdtM7VDKomaMlw9Nyyg9UDSe4RjXiC7G81QuyF0J+Vk081TM/1s/8ig==
    GF6rnI6I4RxfnKD5O9ZMHddx257T7Xxzw3xYSffPnixKfsevNNP/gWqovM+Rami/HKrQ213P9waSfhaHwwUSs6r1LJma4rm4L7JeB4C3VU6fhVwPMzIZ3I4N49e/GgOKplEgmw==
    D+PH2/HND48Pg2fJZ4FxNr8MZ4jqPHgQ46bVHAxdiUFzxadkInShKdQb3ZVzmeTwTpN18pZtDzovK86qae5tajpFJ5//9iDU8mScrI3/kehfIzlJB0XS0e/ux97g/Yve4NUlwQ==
    gTxUuj44mIf2XjemTD31vLi1EbgZgdDsOP7uEkOtVdKYloWzy2f02JJ8k5LW9jPfYaJT8uFQfIVItxP9Oew9sqJr252Oa3u+TotsQcR9+iQOPoUqfP9fpbWqkC5Oburb41vyWw==
    xU2bo/Zg1Db3FX/E9dSXDmhmEDHiKMVGGDH+LK/tROu6aN0XLbGPKUkgvAAPhvge6XRb8I4FK4ItdGy/7bZzCxfLZjMc8HG+OJY4XP5S+Tvtm13fLVaLwogaUX5ZCBoFR1bCNQ==
    HL0m+Ly6pShbRMENhRXiMKg3L43ck+Aru/gjckogHKVzPID0HvDd7eXLDFy6bQkKanNkLGn9g8bpH7GvPkJLmNW7fBLP0dIVaEScWXRAFEpf9mF96UU5CRIc5Oo5IN5iiFKyXg==
    gKOxQupVGKvGxzSOspsojsUWom3QHk6mGPiid6EjpQr2es+4auVy/d3tDKAgcK8bQ98eNjy7PW4Mul670bbHbc/2Os7QGf4hqB2vt2TCsFA8yqJ3+N+A/L49P5zkSD8lj1Z+Cg==
    wSyjwSMISCyEDqeYBwvRnMFp9YRVmrGq4hA9BmnEmK4fSIjV1wcBsJnRRDyBR2MjedlqjnIRvejZ1g4go4zfYpIYogECB6bkBmgFZ1Fr9RoxnhLBWr5PnFZHrHzI0myrJvzJuQ==
    kmeU+7lb5jFMRrgitBX1w/GrG1VWiAfVHxZq1YKKrAdKg1LMfa000Am92HcR0qt/A1BLAwQUAAYACAD3ai1JgKJAF2ADAAA4EAAAEAAAAHdvcmQvZm9vdGVyMS54bWztV9ty2g==
    MBD9FcbviWyH+4RkGshtpu1kQiZ9FkYGT2RJIwkI+bU+9JP6C13Z8gUcUjDT6UtesCXtnt2j3SOZ3z9/nV++xrSxJFJFnA0c79R1GoQFfBqx2cBZ6PCk6zSUxmyKKWdk4KyJcg==
    Li/OV/1Qywb4MtVfiWDgzLUWfYRUMCcxVqdxFEiueKhPAx4jHoZRQNCKyynyXc9N3oTkAVEKAg0xW2LlWLjgdT+0qcQrcDaATRTMsdTktcDwDgZpoR7qVoH8GkDA0PeqUGcHQw==
    tZHJqgLUrAUEWVWQWvWQKuTiagtwQRgshlzGWMNQzlCM5ctCnACwwDqaRDTSa8B02xkMh56TrG8hTvJcjEs/zcU+Mg+5T9zUZcSDRUyYTiIiSSjkwJmaRyLvvbguGizOM5DlRw==
    JJYxdXLdeHsWcpdwRmlZCsB90re1jGma+ceInrtHRQxE7rFPCpsxs0xiHLEicK2tKW2ut2drZwB+BaCtyGEQLQuB1DoupLESs+OqfCv5QhRo0XFo9+wlx2KHEbTdUu5gdVwy4w==
    ORYg5Tjo388Yl3hCISOofQPK10gq0DAqccyFoyfUPh6kfRnrNQWL/hLTgfNkvG9lBK2I7PoPWIOGbLkuXGswsxYALwJdWAwJpWOBA8gltfW8wnL6igvLK0gcrslkxEUWlMGlaA==
    HAJOORxFeKG5Gaq3gZOEVIBNkvcEh5JQ13SdcK15XNNZRrN53cARU9GU3B3l/VzLG1U2Pi3YNyxLm7myrts1yzibBmh3qhZoGw9GXzl/yVJ1m18S3DCSSj9y0xtmSLEdFYtDTg==
    FzErrWcTiQnjd1fw/ZSPntORV0oib2jTvuZ1Bk8AsS3p+uaGzK0zI/gAA5awvY8PsJWu2+v6vVYSJJk0U97IG1772dRTYjZsnjVdL5WUTCMHmOmxgNvYdru8I+WG8f3OgYpBBQ==
    tg7S32xkNdnsdbpVTaKS5b+Q+6eIP0X8f0Tca/VaH2q4JM2dcn1fSu/3e0lKYneMh+TgcNtnnWF+cIxIiBdUbwUXFmtDhN+5PQqycqVG6i0z8Np2Rb0N1dYksvbIgpunzdueIA==
    2W5VSGyea38hYY2PINF9j0T3GBLpib1JI2HmXrsd72aD2ZZViZk13snshnNN5E5a/nu0/I9pwd/+iz9QSwMEFAAGAAgA92otSYpkq3P8BQAAgCMAABAAAAB3b3JkL2hlYWRlcg==
    MS54bWztWetu2zYUfhVD+1FggCtRlmTLqFM4tnMBmtRIsnbANhS0RNtaJVEgacdpsSfbjz3SXmGHkihLvmS+ZL0M+WOJl/Od++Gh/Peff716vYjC2pwwHtC4o6GXhlYjsUf9IA==
    nnS0mRjXW1qNCxz7OKQx6WgPhGuvT17dt6c+qwFtzNv3idfRpkIkbV3n3pREmL+MAo9RTsfipUcjnY7HgUf0e8p83TSQkb4ljHqEc2DUw/Eccy2H8xa7ofkM3wOxBLR0b4qZIA==
    iyUG2hvE1l29tQ5kHgAEGppoHaqxN5SjS6nWgKyDgECqNST7MKQ15aL1EKAJiWFxTFmEBQzZRI8w+zhL6gCcYBGMgjAQD4BpOAqGQsyxuJ1D1AtZJEk7kyV/KAq2C9+MpE+9WQ==
    RGKRctQZCUEGGvNpkBSxFx2KBotTBTJ/TIl5FGpF3qAdHbktcfqZW5aAu4if+zIKM8kfR0TGDh6REAXFLiJUeSpJIhzES8YHmaZkXLRjaCsAcw3A4WQ/CDuH0PlDtEyN+2RynA==
    l88ZnSVLtOA4tMv4Y4EV76dgHi3lCObHCXM7xQmkcuS1LycxZXgUgkTg+xq4r5Z6oCazRJMHjhiF+WPI8pdb8RDCjvYchx3tTlKfswBCUc/X38MaBKRtGHCswcxDAvCJJ5Y7Tg==
    QRw4/NIRTRRUDEedJPBoSKHA4Jmgcsg/dbQUiCfYI+l7ihOSsTiQdESFoNGBxCyYTA9lHMQ88MnFUdTvDqLW1ww/CnskDK8wKxnzPifNfOYv8IrOm9f1VTQYvaH0oxLUsLop1Q==
    OGBc3FAAQXIY4ny0XOzRcBbFpXU1kW6J6cUp9ETF6F02QiUhiiCVISlfJ/AEkDwk3aaba1SZt0yzWQJRtILBMvRo/g2wNHpWwzJSweTUHZNzzaY56DazRPGy31wCL88C0zXd9Q==
    LNCXOxPFY5ginqGmY5hamXF1arhhV5+M8SwUcgUZDnJOU4mSnEE1XwMREuXVbAM7o7HgsAFzLwjuoKCApFEAleGiCxEnuUzly8YVj4v16SzJsgf/pFibptI9ZawXEnJf5I9coA==
    ryoX8AsDzNXqD9d43q7pwxmD5ouTDxcEQwrpqhFJ7fnhzShU1Q1PqpS3aRvP/A8FwluZgzpq5Hwhr31FUkeO1WhCnDVa+VoSQhJPaQgkcuhTbwgtoNrvWi27aZrdvmPaltvqtQ==
    Tnsmcp3BGbKMrmM7SrFVFCzwaRDL6wYgJYyMg8UVThIYw9GSnTIxNzovZBOybD78hxjDiNdjPIdOLqFMcP0x/fQX0hULaDunHU0HxDaY5D3UoJuU+OcolMr8gn5L11ZMrKbXLA==
    DQtpeROUkUtBost+R/t8hrq23eh3673GmVm3egOn3hr0B3WE+n3Xtdymc9b8Q/mILERumCLm4GUQ+0OWB4cPlScWwDX1AaN0PGCsSGOeQK0DxZk609iuSfwthLc4WTNpWpCyPQ==
    2xUG+2hLsxX20YsE/r6sILspdUZCCnDC5kQ7qa2Y4nusTdc0S8Zs+ESFyXBty3GbRuO5MOXTVTM/V6Vjq1LVnk9RkmSA7ZLE2+Xmn3r8qFxUpbaPBXmSTEQysVxk2895uNIgSA==
    E3/5LHza9r2UkBvb99vZSDzSwR8UyMtG/NCS8oQ5tWxOpDv3LQLJI91JUnZK9TJ35J3qmt5CG5F+wCt7ZXTYbWeb4farO0M8ecJriW1DHUEOcp+LjprO7ft/O/b/PfrEidL9Gw==
    uDXsIO6WPn+10f+PxRiHfm+KJZP87S410YhM5Od3/YvJEcRcsDsZc5vNMuyeD2q1X3+sdRkeBV76ejW4OR+cvb256t6lViswvrb1OEkwU43VmihpnXcsu7vvARXToQzl1bA3vw==
    iYghy3z6ElJsixP9OX822uX6pyuZQrfPOfT1cmgL950Sqmgi1ff87Hf1q77RRLt91d/SbFanys1mvrK12ax81PndU9PpPzQ79J8V/eSDqX89NtxmUB/1BlV39B3DcPoVXapTZQ==
    XfKV3XSBzk9CSD3glmuhDcqUPyAg1aaWrxNo882mUHrqs5N/AFBLAwQUAAYACAD3ai1JK49lvsIEAAD6HQAAEAAAAHdvcmQvZm9vdGVyMi54bWztWF9v2zYQ/yqG9tAnh6IsOw==
    slG3SGynCZB2RlI0A4YhoCXKFkKRAkn/27BP1od+pH2FHWVJlmsncBRvM7q8RCSP9+Px7n68c/76+u3t+0XMajMqVSR418IntlWj3BdBxMdda6rDumfVlCY8IExw2rWWVFnv3w==
    vZ13Qi1roMtVZ574XWuiddJBSPkTGhN1Eke+FEqE+sQXMRJhGPkUzYUMkGNjOx0lUvhUKTioR/iMKCuD8xf7oQWSzEHZALrInxCp6WKNgZ8N0kRt5G0DORWA4IYO3oZqPBuqhQ==
    jFVbQG4lILBqC6lZDWnrcvF2CoiEchCGQsZEw1SOUUzkwzSpA3BCdDSKWKSXgGm3chgBOSd5J4OoF7YYlc7KluyTa8h9zl2p9IU/jSnX6YlIUgY2CK4mUVLkXlwVDYSTHGT21A==
    JWYxswre4D0D+Rhx+quwrAH3MT+LZcxWlj+NiO09ImIgCo19TNg8M7ckJhFfH1zJNSXn4j1TOwdwtgBaij4PoplBILWM19SYJ+OXRfmDFNNkjRa9DO2KPxRY/HkXzLKlnMHqZQ==
    xtxOSAJUjv3O1ZgLSUYMLILY1yB8tTQCNcMSyxQcPWLZZyizwa1eMtjRmRHWtT4b7Q8yglREmfwOZJCQUNNgukwAm0y1WMvPwRgofelMJDkQh0JnNHzBhMxV5h31e4akEuLTdA==
    nOIwGuqKqiOhtYgrKstoPKl6cMRVFNDLF2l/qaSNthw/YtdkKaa6iFEYLWgpiNdCPORH2e5ZChlGUukbAbHFZspINlsLe4JNY16S5wvpFi4uz6GnKWZfVjNcMrFIMpNSZjiGLw==
    gKxSysXYy0zcWMft5s71Yj/awIQeCgIJ3rwBU2x30HLt1GCz9FmatbNeyz5zUgKoQGeflW2ERUTlnvnpE5l1amg4lVCZFb2/pAQ8jHqm1PLlpYjpkIzp/fWI5Z4l403d27TLkw==
    wX2B8bMJEsINx8kDH+QqzVOv3XTabiOTJAxiPBEMFMw0EP4Q+oN8d5+GZMr0cL3pvo69Jly24bpFXnyPQTQ5j7jpRAEnkRTy4iNJEpjDq7N6gLiyu29MfVrXpWDJCcxUnZMZFA==
    +URIrdBTd0NvjMcX0JFMuhYCxA644w4S9CZV/iVm5iq/4t9S2XcOzpd3+BlEafZrIemVpvFVv2v9cYHPms1G/6zea1w4dbc3aNW9QX9Qx7jfb7fd9mnr4vTPPEJ0oTPXFDGHwQ==
    gAdDudoBs57gGrqQdL+/+ptlrn9XTr2cXMGCFHmY7Uwez8Hh9tJNFsySJAXJsDaeZOMjCFeePkByFnF6PWP5hoJwuboUIhxIWZirEsrgmYcA5K9eerd3O/ydXikFewIKnFccmQ==
    OSF3cOFJVKZaVcYNJ/AqfhIHI5zTchoOxqevfCvzreTlY6HbqgL8mHQrufu42DaA3w7sYFzDzaaHG0A355VtZbYVXj4Wrv3Ipa1w9sGZZqTyv+g+D0LOeqPltbGDXzvPnZ3n/w==
    jJoV+8Xjql5ZWT0MPYAatos9z3ttFXe1isfCj3+pTazW4B0XPQYfoRIehhxt8xOq3cD2Kzc2Gjvj4WNhxnFWjtRF/1Qrhor/bm/c7QKftmxn10UyyaPd6YUQmsqNDrQwJ4QT/w==
    BlBLAwQUAAYACAD3ai1JWGWPrhYCAABWCAAAEQAAAHdvcmQvZW5kbm90ZXMueG1sxZVLbtswEIavInBvU3JsIRUsB0gcFNkFyQkYirKIiA+QlGWfrYseqVfo6O1WqSHbi270IA==
    Z775RzMj/vrxc/1wELm3Z8ZyJWMUzH3kMUlVwuUuRoVLZ/fIs47IhORKshgdmUUPm3UZMZlI5Zj1ACBtVGoao8w5HWFsacYEsXPBqVFWpW5OlcAqTTlluFQmwQs/8OsnbRRl1g==
    QrQnIvfEohZHD9NoiSElOFfAJaYZMY4dBkZwMWSFv+H7MWhxBQgyXARj1N3FqBBXqkag5VUgUDUira4jjZIT4xZQmknYTJURxMGr2WFBzGehZwDWxPEPnnN3BKYfdhgFjWdk1A==
    Ima9lsolarS0t87DTInbuGwVLQSTro6IDctBg5I247rvPXEtDTazDrI/l8Re5Kifm2BiIf81ONumLANwivy2liJvlJ8nBv6EilSI3mOKhD9jdkoE4XIIfNWnOfm4wcTW7gCLEQ==
    ILTsMsSqRWB7FMNolHp3W5W/G1XogcZvo73Iz54lL0uw7ZbTDra3iXnPiIZRFjR62UllyEcOiqD2HpTPqyvgVVOCTk4dr4zcUYOZZZoY4pRBsMSTGM2C2k7DK5xpyVuMfIgYBg==
    4SNql16rpeel/xTedUtvW5aSIncnxjXk1VQ3qwkFmWBLUsfgXwNnJN6scW/QWHVK2j3TWNTXVvVXCVAlHZdF/Rd6/zsZ/z/l8qWoc3kNz3bzG1BLAwQUAAYACAAAACEAqiYOvg==
    vAAAACEBAAAbAAAAd29yZC9fcmVscy9oZWFkZXIyLnhtbC5yZWxzjM+xisMwDAbg/aDvYLQ3TjqU44iTpRxkLe0DCFtxTGPZ2L7j8vY1dGmhw42S+L8f9eOfX8UvpewCK+iaFg==
    BLEOxrFVcL187z9B5IJscA1MCjbKMA67j/5MK5YayouLWVSFs4KllPglZdYLecxNiMT1MofksdQxWRlR39CSPLTtUaZnA4YXU0xGQZpMB+KyRfqPHebZaToF/eOJy5sK6Xztrg==
    ICZLRYEn4/Cx7JrIFuTQy5fHhjsAAAD//wMAUEsDBBQABgAIAPdqLUmoiAPMFwIAAFwIAAASAAAAd29yZC9mb290bm90ZXMueG1sxZVLbtswEIavInBvU3JsIRUsB0gcFNkFyQ==
    CRiKsoiID5CUZZ+tix6pV+joabVKDdledGOZ5Mw3/2hmxF8/fq4fDiL39sxYrmSMgrmPPCapSrjcxahw6eweedYRmZBcSRajI7PoYbMuo1QpJ5Vj1gOCtFGpaYwy53SEsaUZEw==
    xM4Fp0ZZlbo5VQKrNOWU4VKZBC/8wK//aaMosxbCPRG5Jxa1OHqYRksMKcG5Ai4xzYhx7HBiBBdDVvgbvh+DFleAIMNFMEbdXYwKcaVqBFpeBQJVI9LqOtIoOTFuAaWZhMNUGQ==
    QRwszQ4LYj4LPQOwJo5/8Jy7IzD9sMMo6DwjoxYx67VULlGjpX10HmZK3MZlq2ghmHR1RGxYDhqUtBnXfe+Ja2lwmHWQ/bkk9iJH/dwEEwv5r8HZNmU5AafIb2sp8kb5eWLgTw==
    qEiF6D2mSPgzZqdEEC5Pga96NYOXG0xs7Q6wGAFCyy5DrFoEtkdxGo1S726r8nejCn2i8dtoL/KzZ8nLEmy7ZdjB9jYx7xnRMMqCRi87qQz5yEER1N6D8nl1BbxqStDw2vHKyA==
    HTXYWaaJIU4ZBFs8idEsqA01LOFWS95i5EPIMAgfUbv1Wm09L/2n8K7betuylBS5GxjXkFdTPawmFHSCLUkdg48N3JJ4s8a9QWPVKWnPTGNR/3ayv0yBKum4LOoP0fvf6fj/KQ==
    my9Fnc1ssLCb31BLAwQUAAYACAAAACEAqlIl3yMGAACLGgAAFQAAAHdvcmQvdGhlbWUvdGhlbWUxLnhtbOxZTYsbNxi+F/ofxNwdf834Y4k32GM7abObhOwmJUd5Rp5RrBkZSQ==
    3l0TAiU5Fgqlaemhgd56KG0DCfSS/pptU9oU8heq0XhsyZZZ2mxgKVnDWh/P++rR+0qPNJ7LV04SAo4Q45imHad6qeIAlAY0xGnUce4cDkstB3AB0xASmqKOM0fcubL74QeX4Q==
    johRgoC0T/kO7DixENOdcpkHshnyS3SKUtk3piyBQlZZVA4ZPJZ+E1KuVSqNcgJx6oAUJtLtzfEYBwgcZi6d3cL5gMh/qeBZQ0DYQeYaGRYKG06q2Refc58wcARJx5HjhPT4EA==
    nQgHEMiF7Og4FfXnlHcvl5dGRGyx1eyG6m9htzAIJzVlx6LR0tB1PbfRXfpXACI2cYPmoDFoLP0pAAwCOdOci471eu1e31tgNVBetPjuN/v1qoHX/Nc38F0v+xh4BcqL7gZ+OA==
    9Fcx1EB50bPEpFnzXQOvQHmxsYFvVrp9t2ngFSgmOJ1soCteo+4Xs11CxpRcs8Lbnjts1hbwFaqsra7cPhXb1loC71M2lACVXChwCsR8isYwkDgfEjxiGOzhKJYLbwpTymVzpQ==
    VhlW6vJ/9nFVSUUE7iCoWedNAd9oyvgAHjA8FR3nY+nV0SBvXv745uVzcProxemjX04fPz599LPF6hpMI93q9fdf/P30U/DX8+9eP/nKjuc6/vefPvvt1y/tQKEDX3397I8Xzw==
    Xn3z+Z8/PLHAuwyOdPghThAHN9AxuE0TOTHLAGjE/p3FYQyxbtFNIw5TmNlY0AMRG+gbc0igBddDZgTvMikTNuDV2X2D8EHMZgJbgNfjxADuU0p6lFnndD0bS4/CLI3sg7OZjg==
    uw3hkW1sfy2/g9lUrndsc+nHyKB5i8iUwwilSICsj04Qspjdw9iI6z4OGOV0LMA9DHoQW0NyiEfGaloZXcOJzMvcRlDm24jN/l3Qo8Tmvo+OTKTcFZDYXCJihPEqnAmYWBnDhA==
    6Mg9KGIbyYM5C4yAcyEzHSFCwSBEnNtsbrK5Qfe6lBd72vfJPDGRTOCJDbkHKdWRfTrxY5hMrZxxGuvYj/hELlEIblFhJUHNHZLVZR5gujXddzEy0n323r4jldW+QLKeGbNtCQ==
    RM39OCdjiJTz8pqeJzg9U9zXZN17t7IuhfTVt0/tunshBb3LsHVHrcv4Nty6ePuUhfjia3cfztJbSG4XC/S9dL+X7v+9dG/bz+cv2CuNVpf44qqu3CRb7+1jTMiBmBO0x5W6cw==
    Ob1wKBtVRRktHxOmsSwuhjNwEYOqDBgVn2ARH8RwKoepqhEivnAdcTClXJ4PqtnqO+sgs2SfhnlrtVo8mUoDKFbt8nwp2uVpJPLWRnP1CLZ0r2qRelQuCGS2/4aENphJom4h0Q==
    LBrPIKFmdi4s2hYWrcz9Vhbqa5EVuf8AzH7U8NyckVxvkKAwy1NuX2T33DO9LZjmtGuW6bUzrueTaYOEttxMEtoyjGGI1pvPOdftVUoNelkoNmk0W+8i15mIrGkDSc0aOJZ7rg==
    7kk3AZx2nLG8GcpiMpX+eKabkERpxwnEItD/RVmmjIs+5HEOU135/BMsEAMEJ3Kt62kg6YpbtdbM5nhBybUrFy9y6ktPMhqPUSC2tKyqsi93Yu19S3BWoTNJ+iAOj8GIzNhtKA==
    A+U1q1kAQ8zFMpohZtriXkVxTa4WW9H4xWy1RSGZxnBxouhinsNVeUlHm4diuj4rs76YzCjKkvTWp+7ZRlmHJppbDpDs1LTrx7s75DVWK903WOXSva517ULrtp0Sb38gaNRWgw==
    GdQyxhZqq1aT2jleCLThlktz2xlx3qfB+qrNDojiXqlqG68m6Oi+XPl9eV2dEcEVVXQinxH84kflXAlUa6EuJwLMGO44Dype1/Vrnl+qtLxBya27lVLL69ZLXc+rVwdetdLv1Q==
    HsqgiDipevnYQ/k8Q+aLNy+qfePtS1Jcsy8FNClTdQ8uK2P19qVa2/72BWAZmQeN2rBdb/capXa9Oyy5/V6r1PYbvVK/4Tf7w77vtdrDhw44UmC3W/fdxqBValR9v+Q2Khn9Vg==
    u9R0a7Wu2+y2Bm734SLWcubFdxFexWv3HwAAAP//AwBQSwMECgAAAAAAAAAhAFQBBrnyAwAA8gMAABUAAAB3b3JkL21lZGlhL2ltYWdlMS5wbmeJUE5HDQoaCgAAAA1JSERSAA==
    AADIAAAAyAgCAAAAIjo5yQAAAAFzUkdCAK7OHOkAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAOXSURBVHhe7dKxFYJAAERBuAYI6b87ybAAPQ0ogR8xW8AG/8065zze38UUuK/Avg==
    jfV1fu479KTAVWAooUBRAKyiqs8FLAiSAmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxQ==
    QFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWkg==
    1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkg==
    AmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTg==
    wWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUAA==
    K8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFg==
    A0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSQ==
    VqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSA==
    CoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJVmdgsVAUmDsG1tJ2Sef/lH9AIZvCrHX5u+tAAAAAElFTkSuQmCCUEsDBBQABg==
    AAgAAAAhAM+OHiZ3BgAAjykAABoAAAB3b3JkL2dsb3NzYXJ5L2RvY3VtZW50LnhtbNyaS2/jOBLH7wvsdxB8XsZ8P4JJD/icnVuwM3uY00CRldhoWTIkJWljsd99S34kcSfdkA==
    01gEoxxiUST/LLJ+JKuc/PTzl3WVPZRtt2rqqxm5wLOsrItmsarvrmb//j0hPcu6Pq8XedXU5dVsW3aznz/9/W8/PV7eVU3X5e02NMX9uqz7DKTq7vJxU1zNln2/uZzPu2JZrg==
    8+5ivSrapmtu+4uiWc+b29tVUc4fm3Yxp5jg3dOmbYqy62Bcn9cPeTc7yBVfxqkt2vwROg+CfF4s87YvvzxrkLNFxNzM9Wsh+g4hmCElr6XY2VJyPlj1Soi/SwiseqUk3qf0ag==
    cuvXCDSbsobK26Zd5z0U27v5Om8/328QCG/yfnWzqlb9FjSxPMo0V7P7tr48SKAnW4Yul3tbDh/HHu2YcfddjtjuRpy3ZQU2NHW3XG2e2Fu/Vw0ql0eRh+9N4mFdHds9bshIRw==
    fmvjhL1bngXHmH/w5braW/59RYJHeGSQeOoxxoTTMY+WrPNV/Tzwu5bmxeKSkWgfBegrAdmV50mIg8S8266ft8bj5u7HvPxL29xvntVWP6b2a/35SWs438/QOtDykuDux4z5bQ==
    mW9gK6+Ly1/v6qbNbyqwCHyfgfuynQeyYZfMPsHts2iKazhzuhfPLx6v26FQ52vocfmQV1ezUN7m91V/XeVFuWyqRdn+iYgWHBPGOZ7Nh/ZF3pd3Tbv9uu8vZV22ebVvdJdXVQ==
    2W6PdZtnwaF+fqrSbzflzsTh4djl5ua6Kv65OLZ/anNTLvOHVdOeFI6diqbu4Xw59Dlpene/Whyb/Ucaj7kUFnmlFeLaO2SYDygljLElKXmT/ntQOVmsQ8E1i53lG1CEqGDxrw==
    qxnGgWJOzez46rCWQ000iuKw88hg6q76uh1qkqQ2kX3NfoT2t35bPa3CC0/8Xn45TuzQtP/kq1XxOYP59/kmW5ZtmfUNhCZ9CW+g+cVu5fZddr83L2e0n8RzeSwkhjgRtXVeaA==
    zqkKNirDQpJWJ26ZsNPBBKcgUsQKEeIT4okSZDhgQmHW2GnqqTgfk6iJJ+QtTDQX1oVjzfWLVzuRvfTmhI8xvhj8fmDrrw+fMDoEZl0ScCRpIUwUQVJCArU+csynA18yPFgaJA==
    coobxDkRyBFlkQkqBKOk4cR+LHxjfDEp+FQwkSnOcPCOa5eMV4maRGzkkZIwoQuSSIuTURzBRenh5AseOUEoYMjk4F4lPvrkG+OLScGnLaaGakWwxtyDg5wLMQnBuY1CGjYd+A==
    vLZwhzGPCERUiHsckQuMIy1kpD5Jwo37WPjG+GJS8HnmIaKgnBjnuU/EWFhOrSA6coRKr6cDH+Q6EMULjATcYQBfoEgTB8cfJSomHYSQ7GPhG+OLScEnORcKthVOFrI2HjRXhA==
    i5ggKrfYaDMd+LSxAs6TgKTgEi5bxZCxkaLEIJyHUzE5+8HwjfHFpOBzOjFnqYoMoo1IhCU6JgyBOJfCUD+hhMMlF4yWFEVpIeFINiCrOMDnFDaUQN6hP/jaHeOLScHnvYKdTw==
    nIaYgmslHYb9xyDStcqSRCaUcHhNnfYYTr5ILYK5YmSMIUgaxQyFwE85fjZ8TinIRt+Ez3Md1Cl8+1ffhG+MLyYF3/e+DGZyOuhhh5WSPqKoOEY8RoMMJhhFRpMUTEaBz891CQ==
    xyDyFnoHKN+ABMZ3ev/F/XsgiTse8nqbHWae9cu8z7bNffaYD6Uma8tNmff/yFZ1Ud0Pf77Omh5weuowfLZN1V1kf0CvIq+zvOoaaN6V7SC36o5Nsrxt7usFAHkDBrbNYwetgA==
    0MWA5HGgbAPL02XNbZbvG/5/QDVcC0WpDZIKbrTXzsN1JSEo4dhKMSFUExUkQd4JbEKGwj01SGPJELfEeO1djDKcjarhgmL/FqoeslxFT07Jw6udyFun5BhfTOqUZElLYrlzkQ==
    eZ5UdIYnTTDFykriyIS+lrHWUwj4GQpYCsSDoMiliBHzcHgaLpW04mz4oBeR/C34WGTmq/jw8Oqb8I3xxbTgI4pxJbkXmHEISBzxIkKCRqhnUdsJZcaUg3e4MkgI5iA5YRZZZw==
    NPLUQnQopIrKfzB8I3wxKfikc04wS6W1mnOsXYLgMFBjmYCkT/jpwMcCBXcGj4ikEXEZGNIsKiTA21EzqrGiZ8O3/3kLPqyVpvEEvsOrb8I3xhd/Efien7td4ev/oPz0PwAAAA==
    //8DAFBLAwQUAAYACAAAACEA0nc7M/UAAAB1AQAAHAAAAHdvcmQvX3JlbHMvc2V0dGluZ3MueG1sLnJlbHOMkDFPwzAQhXck/oN1EiNx2gGhqk6HFqQOLDTdshz2JXHr2JZtIA==
    /ffcUolKDEynu9P73tNbb+bJiS9K2QavYFHVIMjrYKwfFBzb18dnELmgN+iCJwUXyrBp7u/W7+SwsCiPNmbBFJ8VjKXElZRZjzRhrkIkz58+pAkLr2mQEfUZB5LLun6S6TcDmg==
    G6bYGwVpbxYg2kuk/7BD31tNu6A/J/LlDwuJpSDrTUtT5DsxG9NARUFvHTFdblfdMXMd3Ql1+Pg+dTvK5xJid7Assb0l87CsD+go87x6VSaU+Qp7C4bjvsyFkkcHslnLm7KaHw==
    AAAA//8DAFBLAwQUAAYACAAAACEA+SKAu74EAACXDwAAGgAAAHdvcmQvZ2xvc3Nhcnkvc2V0dGluZ3MueG1stFdRj5s4EH4/6f5DlOfbDTbGJlG3FQS4ttq9nprtD3DASawFjA==
    jLNp+utvgNCk3dlqe1WfMPN5vhl/Y5vh1ZvPVTl5VLbVpr6ZkmtvOlF1bgpdb2+mn+6zq3A6aZ2sC1maWt1Mj6qdvnn95x+vDotWOQfT2glQ1O2iym+mO+eaxWzW5jtVyfbaNA==
    qgZwY2wlHbza7ayS9mHfXOWmaqTTa11qd5xRz+PTE425me5tvThRXFU6t6Y1G9e5LMxmo3N1eowe9iVxB5fE5PtK1a6POLOqhBxM3e50045s1f9lA3A3kjz+aBGPVTnOOxDvBQ==
    yz0YW3z1eEl6nUNjTa7aFgpUlWOCuj4HZk+Ivsa+htinJfZU4E68fnSZefBzBPQJAW/Vz1EEJ4pZe6zU55GoLV8iyQDd6rWVdthwJz2qfPFuWxsr1yWkA7pMYGmTPrvpa9jljw==
    Wh0m8JAQpu4Iy+mssxdqI/elu5frlTPNOENQb4DznbQyd8quGplDEZamdtaU47zC/GPcEg6BhRqdPPoj0Y32rcrSW3k0e3eBrIbjBgy1rCDVb47QnSngPICr1S/XtHPosyHBZQ==
    Ct8HMnA9WF2o+06ilTuWKoPFrPQXFdXF+33rNDD2B+kXMvhRAqruIn+Aot4fG5Up6fYg228K1lcmK3Vzp6019l1dwAn/bcH0ZqMsBNDSqTvYTtqaQ6/zWyULuJV/Me7sclvBHQ==
    X7Tj4KMxbpzqeekcNm4yZNqhZ8RjXMwFjgia4EhAWYaz8YAzH0VCEdIURVLhLSMMIYT4Yo4izJt7J+W/QyL2TBzq0ZCgcSilJGYoIoSYo+uhoRf4aG50LhiJUSTzMoFmTTNKQw==
    VFFfiESgbH7MUoHm5qf+PEbZWMR973QZfIsE1BME1S2YByxF1QmWXhBzDOGMimiJIoIKFuIIJxyNw0MQCF0pXwom0PUI3+MpqpuIoQponJCwlKNsIQ08hrKFlIfxc0jK0P0Wsg==
    IMLrEy5ZiJ+5MBU0RnWbExJ5GYowqCpahTkTnONskT8P0AyiCJRDdYsSko7fxe+QlCwTtHIRnHp8v0UZERz1iQkUAVU0FoIQVNE48gS+e5fdSaUokkIvgp7thHCCq5NQj1Hchw==
    ExKguyqZsyhEK5ck3A/xOBn1CYqknBKOViHlPg9R3dKQLAl6Iz3/xUiXcPXgbAlLOFrTNOExXtOMkBivTwZfGYKuJ5v7S7/PbTZA8NWrFl1//q8dR10LM6kGj6Ws1lbLyV3XwQ==
    z7oZa/sQ63rE1wo6SXWJrPbrEby6GoAWOsMyg55vBPrUqkWh2yZRm35c3km7PfOeZljUCv3l+69cObQIyv5tzb4Z0IOVzdCajFMIYydPXbtbXY32dr9ejV419L4X0L4uPjzaXg==
    p7M8h4WDFqNv8W5l36r0c1V99Wk1iJ2XdtW1IepONs3Qzay35GZa6u3Oka4BcfBWwI9e/7Le0hNGe4wOWP8i825lMPs0ONvoaLuY5482/2xjo42dbcFoC842Ptp4Z9tBH2lLXQ==
    P0BjNQ47+8aUpTmo4u0Zf2IaRChUrqHiq2O1Pnf11wNW6hY6vQZ+AJyxI/ZXj5Gg/zNw97BRHkC7j2oTy1YVw14d/6hf/wcAAP//AwBQSwMEFAAGAAgAAAAhAIPQteXmAAAArQ==
    AgAAJQAAAHdvcmQvZ2xvc3NhcnkvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHOskk1LxDAQhu+C/yHM3aa7iohsuhcR9qr1B2TT6Qemk5AZP/rvDcJqF5fFQ4/zDvO8TyCb7efo1Q==
    OyYeAhlYFSUoJBeagToDL/Xj1R0oFkuN9YHQwIQM2+ryYvOE3ko+4n6IrDKF2EAvEu+1ZtfjaLkIESlv2pBGK3lMnY7WvdoO9bosb3WaM6A6YqpdYyDtmmtQ9RTxP+zQtoPDhw==
    4N5GJDlRoT9w/4wi+XGcsTZ1KAZmYZGJoE+LrJcU4T8Wh+ScwmpRBZk8zgW+53P1N0vWt4GktnuPvwY/0UFCH32y6gsAAP//AwBQSwMEFAAGAAgAAAAhAD+f3zFxCwAALTAAAA==
    EQAAAHdvcmQvc2V0dGluZ3MueG1stFpbc9s2Fn7fmf0PHj2vY9wvmjgdgAC26TTbTu2+7Bst0TYnkqih6Djur++hJMaJ86mTttMnUfiIg4NzPyBef/dxvTr70PS7tttczvgrNg==
    O2s2i27Zbu4uZ79el3M3O9sN9WZZr7pNczl7anaz7978+1+vH+e7Zhjotd0Zkdjs5uvF5ex+GLbzi4vd4r5Z17tX3bbZEHjb9et6oL/93cW67t8/bM8X3XpbD+1Nu2qHpwvBmA==
    mR3JdJezh34zP5I4X7eLvtt1t8M4Zd7d3raL5vgzzei/Zd3DlNQtHtbNZtiveNE3K+Kh2+zu2+1uorb+q9QIvJ+IfPijTXxYr6b3Hjn7hu0+dv3y04xvYW+csO27RbPbkYLWqw==
    icF287yw+orQp7Vf0drHLe5J0XTO9k+fc67/HAHxFQGza/4cCX0kcbF7WjcfJ0K71beI5AD92N70dX8wuKM81ov527tN19c3K2KH5HJGWzvbczd7Q1b+W9etzx7n26ZfkKrJRQ==
    GJtdjEDfrLsPzc/kOt2mXr3dHFYjc/oMTfXQhM3yul03+1FSSnd7NdAokdxtm9Vq72eLVVMTK4/zu75ek4dMI/s59TDUxPzyullvV+PMft4uL2f92yU/vLBsbuuH1XBd31wN3Q==
    lqh8qEkkVhz5vH/a3jebPWf/JxeecCX0AV/c1329GJr+alsviJ2q2wx9t5reW3b/64aK3LUnazpSXPZX9/W2SYeFd29ed/PdOHDkZHf2Yd58JFk1y3ag8LFtl+v64+VMMOVHCg==
    F4jE4/y264ZNNzQ/95//Iz7G7Z4fN/tieL/Hi5dzm83yqz8v6Hw5OpH5YuIhRj0/XR3iHU3Z1GuylS9i2Ltu2YwafOjbbzfqccJeyHzSBVyIDKnv22VzPdro1fC0agrp6Kr9bQ==
    tK0fHnZDSxT3Cv4bHPwRA2Q+tPJP5FXXT9umNPXwQNbwDy22N7iyarfv2r7v+rebJfndP7ZYe3vb9LRAS571jiyx7bvHvZy/b+ol+fbfXPficzOiJLvcW/r48AtZ7PQqY0mrlA==
    8zGwEPqMMC5LJSEiWOQFIlJks3e1rxFtc4SIEbooiFiWs8OI4voo3xeIE1GcQGTmmDenVMA7dcbLABGvtMJIMEZjJOlgEkQysyckmg0zkDfKB8rDdTiTThmMGG6gFji3XmJEyA==
    YCHXXJiEd8olM9ZiRAUL9UMKrSzeqVY8T8nvS8QInqBOeRBmSjQvkChlgrLm0WSsHx5JOhVEKpstppZ4lQVGlNOnEC+gxfNkHMMSLSYkTK1Yg+16rKsc1JyQpCAoNyGVqKCfCg==
    qasA9SOUjgxGF2G4s9BGSW/GQ0sUxviEEct8BeUmrIwBWojwPBaoOUJywTLwRji8nyA8tioRpBPQdkQ0EfupiFYcSpavkEoEh6klziLWdhZBw3UkiZrBnUpprYDUyAwEx9SUkA==
    DPImtc5TWfgCsUqeoOaYwhYinVQer+MV6QgigXnsPzJInk4g9kQ2k5EnfQopBnqjrETl8X4Sp4yKERUdlluy4QTXWXALfUEWa3FEUtyGCO1aafJTuI4y0icYLZUdvRsinmIFjA==
    IcrrgHO9CirhjKGiEAVKVEVlM+YtqpyhXatoSoa+oKJ1FkZLVRmGo6Uib/zUsL1ArHVYC9kohndamPEnEKEkpKa5MdgbtVAlQ7lpaQLOwVpJzzGiefbQF7QWJ+oQbWSqoH60lQ==
    vIJxVDvLNbRE7ZWroBa01wVnZ+2JBWjxmiKFhzaqAy8F2qiulMcWoovQOFLoonN1AjGxgpozVF06yJuhnC4gB4RkvB/DWZDQRg0XIUK5GUrpCa8jjWBQp0YZrzFihdAw8lH5qA==
    sYUQEhLUtnFjPYgRqgPwfpysKmgHxpF3Q+slJONexjitHbQQyrO2QD81QQSLqVWS4erWVEo7vFPKGB7rNBkV8E4z2SKWKHUfGXNAdo27AkKogkOIZdRkQK4tsxFHZcsp8EBfsA==
    3GQB7Zqaw2ShrAkpOMKOCO6MrJY2Qou3hpUAtW2N5lgLloIyzs7WUql6CgkJy8DphH3OeitxZUeIxbWlDSwI6CUjorF+AlUbeKeRcj2WaJYCd1OOKl88h5ofiysHx3USMC84Mg==
    twJ5IyTjDOjE2IBARFJRgzlQsmBvdIrqAExtDKNQ1oRkBu3AaSkznqNNxPHaGZEV5sBZhbtqF6TCtYsLWgVMrZIee5ZLVlloiS7zhDswl004QS2TB0GLd4WyGZZbUdxD6/WUtQ==
    LLRECtfUUEFEaIUzrZcyRbhTLyn2QtuhhsVKPEfJwKFde6VlxFxrylkYIakxzIGl+gD6gndcYIkSkjjMJd4Jr6HteM8FjnyEWI2pjULAXHuKfZhaVA6fSvmKB5xPfUW5Ccugsg==
    5gTXSTMHY5VP1ElgzWVKWpi3LPQJiRZ+Ijv7Iji2t8BY9CcQHiKUQWDKZWg7geo6fO5C5WOFLSQoEXE3RYnE43OkoLXBnVEwKuMuJ1hTJNRcoHiEz56CF1RcYkQxHGEDuQmOOw==
    YewBMW9jfIO+ECi+RSzRwjPuqkNRCp8ahmJEBa2KkKwgtch4ClBukbNkoPVGLoqEmhsbcdxNRWGsghKNUlCtChFFZQC00aikxbV/1FRz4Tlm/MiBEalPIFQGYAuJTiYPtUBIwQ==
    WSY6FU7w5qjTw/pxVHtjuXleBZiZohcFR/LoDfWBEKmEFFgLSXAcYQmhSgQjUuMeg4KBx9Ybs4m4FouFFY65plod54VKWIryEJGm4FOpSlqHM22liD28DvUY2LNGBPcylZInzg==
    dyplBYMyqIzSOLpU1nJsVZXnDOeFKhiJzwKqaDQ+XamiZQHvNPGIfaFKRuPz+CqrXKBnVVmHCNchQ0z4G1iiFiNBC0mKUsMJhCfMGyHFQYkmKriwN1JoCQbq9PSX1aS1xhJN2g==
    yApTM2MHDxErAj7ZJiQzqJ9kx0LxBBJwX0JIxLVycszgLw8pMOFOIRbnEkIKxzKg7gOfBRDiGPT6FNWJjpIQyqgQqdiJCJsqVWHfTkUS2wjJTCrcvWfOOa6EMlchQs1RAZkc1A==
    TxYiWmhvWVEYgVxnxTmuuDLFKnw6SYjh0BKz0qxAWWdlHT5dyVoVHHuz1snj/RjB8YlZNlrhewHZWOp0IOKZwDU5tUVCwThKSMBZMwehDOY6CBvwOlEJcwLREd9ZyBX3uMLPZA==
    ow76dk5M4m85mToWfLKdM5WW2HaylgVSK0xbfJJVuOL4mx4ZgcGxipCIv44VwQo+56PGyGNvpGah4G/VRdqMv+1SmHACr6OswRmQSnKOK8hiZKhOzDEB3wIp1J7inraMZ954Pw==
    jgd8dluc9PiLdHHKYQ8uziiDdRqYwzVSCSrhE/QSrMVfbEpkBsfeEmXCJ/UlmYDPq0rm7gTXxSjcM5VRDXg/1E3hb1Ol2HQ49784QLs3r9fz8WLueKPv8DRenTtbH2ZU9fqmbw==
    67N349Xdi/GNm/59bDcTftPcdn3zOXL1cDOB5+cHYLeuV6vS14sJ2ItgPV+2u21qbvfPq3d1f/dM9/hGD0eXze0Pn2iNd06b/r9997A9oI99vT1ciZte4UodZ7ab4cd2PY3vHg==
    bq6mWZu6f/oMetgsf/rQ7+X0LJ7H+XDfrPdXC3+s91fk9u82m/Nfrw7CXqz6q/H6W/Ou3m4Pt+hu7vjlbNXe3Q98vPg20L9l3b/f/7m5E0dM7DFxwPZ/6sW4M3r7+PA8Jqaxzw==
    3pPTmHweU9OYeh7T05h+HjPTmBnH7p+2Tb9qN+8vZ58ex/HbbrXqHpvl98/4V0MHIewvuv7Vm6/Ht1f1U/cwfPHuiI0vb7+ksKyHerpK+MXkvYm/4GW8CrxoyRyvntY3zzd4Xw==
    HRhftbvhqtnWfT10/YT9Z49xvb8FPFyTFb8nxf7S3MZ61ywPjjTd83/zOwAAAP//AwBQSwMEFAAGAAgAAAAhADyj+ebhAAAAVQEAABgAKABjdXN0b21YbWwvaXRlbVByb3BzMg==
    LnhtbCCiJAAooCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACckMFKxDAQhu+C7xDmnk03rVWWpsu2NbBXUdhrNk3bQJOUJBVFfHdTPK1HT8M3w8z3M9Xxw8zoXQ==
    +aCdZbDfZYCUla7XdmTw9srxE6AQhe3F7KxiYB0c6/u7qg+HXkQRovPqHJVBqaFTPXcMvk5FzvMTf8T7B17gouEUN03LMc3bkpYdpW3+/A0oqW06ExhMMS4HQoKclBFh5xZl0w==
    cHDeiJjQj8QNg5aqc3I1ykZCs6wkck16czEz1Fue3+0XNYRb3KKtXv/XctXXWbvRi2X6BFJX5I9q45tX1D8AAAD//wMAUEsDBBQABgAIAAAAIQA/vZVVAwEAAFMBAAAYACgAYw==
    dXN0b21YbWwvaXRlbVByb3BzMS54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAXJBPa8MwDMXvg32H4Lvr/GnTJiQppUmgp411g92KsZUmENtBdg==
    ysbYd5+znbqT+OkhvScV+w81BjdAOxhdkmgVkgC0MHLQ15K8vbZ0RwLruJZ8NBpKog3ZV48PhbS55I5bZxBODlTgG4Ovp7okX2102GyS+kCPSRvT9bFJ6a6pGxpFdZ1l62ybtg==
    228SeGvt19iS9M5NOWNW9KC4XZkJtBc7g4o7j3hlpusGAbURswLtWByGKROzt1fvaiTVkudv+gU6e49LtBmHksyoczUINNZ0jspPzT1ZqvmNIUwGnWXn31NRXp5nFD23cHlCCQ==
    yKIkjhlhVcH+GS1894jqBwAA//8DAFBLAwQUAAYACAAAACEAeqhydMUAAAAyAQAAEwAoAGN1c3RvbVhtbC9pdGVtMi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAACsj0FqwzAQRa8iZl/LzSIUYzsEkiyTgtusupHlsS2QZow0Kc7tK0KbE3Q5/Mf7f+rdGrz6xpgcUwOvRQkKyfLgaGrg8+P08gYqiaHBeCZsgBh2bd1XHd+ixQ==
    pDr0aAWHTu4+x1/7933nVpmPg5OsvIyjs3gh7wiLNXlQD/BsQoYzC+r6170FlbdQqvoGZpGl0jrZGYNJBS9IORs5BiP5jJPmh/jA9haQRG/Kcqt713vHUzTLfP+V/YuqrfXz4Q==
    9gcAAP//AwBQSwMEFAAGAAgAAAAhAFyWJyLCAAAAKAEAAB4ACAFjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbHMgogQBKKAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMz8GKwjAQBuD7gu8Q5m5TPYgsTb0sgjeRLngN6bQN22RCZhR9e4OnFTx4nBn+72ea3S3M6oqZPUUDq6oGhdFR7+No4A==
    t9svt6BYbOztTBEN3JFh1y6+mhPOVkqIJ59YFSWygUkkfWvNbsJguaKEsVwGysFKGfOok3V/dkS9ruuNzv8NaF9MdegN5EO/AtXdE35i0zB4hz/kLgGjvKnQ7sJC4RzmY6bSqA==
    OptHFANeMDxX66qYoNtGv/zXPgAAAP//AwBQSwMEFAAGAAgAAAAhAHQ/OXrCAAAAKAEAAB4ACAFjdXN0b21YbWwvX3JlbHMvaXRlbTEueG1sLnJlbHMgogQBKKAAAQAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMz7GKwzAMBuD94N7BaG+c3FDKEadLKXQ7Sg66GkdJTGPLWGpp377mpit06CiJ//tRuw==
    vYVFXTGzp2igqWpQGB0NPk4Gfvv9agOKxcbBLhTRwB0Ztt3nR3vExUoJ8ewTq6JENjCLpG+t2c0YLFeUMJbLSDlYKWOedLLubCfUX3W91vm/Ad2TqQ6DgXwYGlD9PeE7No2jdw==
    uCN3CRjlRYV2FxYKp7D8ZCqNqrd5QjHgBcPfqqmKCbpr9dN/3QMAAP//AwBQSwMEFAAGAAgAAAAhAByC5EEqDwAAkYQAABgAAAB3b3JkL2dsb3NzYXJ5L3N0eWxlcy54bWy8nQ==
    S5ObSBLH7xux34HQaffgaR7FyzE9GzzXjrU9nmnPzplGqJs1Ai0gt3s//RYFUqNOCkgoOXxw65G/Sirzn1UJQvr5H9/3mfQtKau0yG83yk/yRkryuNim+cPt5o8v4RtrI1V1lA==
    b6OsyJPbzXNSbf7xy1//8vPT26p+zpJKooC8eruPbzePdX14e3NTxY/JPqp+Kg5JTl/cFeU+qunD8uFmH5Vfj4c3cbE/RHV6n2Zp/XyjyrKx6TDlHEqx26Vx4hfxcZ/kNbO/KQ==
    k4wSi7x6TA/VifY0h/ZUlNtDWcRJVdGD3mctbx+l+RmjEADap3FZVMWu/okeTOcRQ1FzRWZ/7bMXgI4DqABgVAkOoXeIm+p5n3zfSPv47fuHvCij+4yS6CFJ1CuJgTe/0Ghuiw==
    2E920TGrq+Zh+bnsHnaP2H9hkdeV9PQ2quI0/UK9oKh9SqnvnLxKN/SVJKpqp0qj/otB91zz+mPzxkHLuKp7T7vpNt3cNINW/6Mvfouy242qnp7xGicunsui/OH0XJK/+eOu7w==
    TO+pe8q93UTlmzunMbzpjq39v3fEh9eP2MCHKE7ZONGuTmiuKobcQLO0kYaq26cHvx+bSY6OddENwgDt/2fsDZh0msI0oe9aXdFXk92HIv6abO9q+sLtho1Fn/zj/ecyLUqqnQ==
    243NxqRP3iX79F263SZ57435Y7pN/nxM8j+qZPvy/G8hy//uibg45vRvzdRYImTVNvgeJ4dGTfTVPGpi8qkxyJp3H9OXwZn5f08wpYvEkP1jEjUlRVJeI5j7KITaWFS9ox1mHg==
    Xx07exdqIO1HDUR+1ED6jxrI+FEDmT9qIOtHDcQw1xwozbfJ91aIcBhAneJw1IjmcMSG5nC0hOZwpILmcJSA5nASHc3h5DGaw0lTBKcuYl4W9pJd42T7OHd6jVjGnV4SlnGnVw==
    gGXc6YK/jDtd35dxp8v5Mu509V7GnS7WeG671ZLeU5nl9WqV7Yqizos6kerk+3palFMW67PE8JpFLymFHKQATFvZuoV4NS2O2OPpDGEiXb6e101HJxU7aZc+HEvanq91PMm/JQ==
    GW2UpWi7pTyBwDKpjyVnRpbkdJnskjLJ40RkYouDNp2glB/39wJy8xA9CGMl+Vbw9J2IQorCOaFp//zYiCQVkNT7KC6L9a4VkbD68CGt1s9VA5HcY5YlglifxKQYY63vDRhmfQ==
    a8Aw6zsDhlnfGPRiJmqKOpqgmepogiasowmatzY/Rc1bRxM0bx1N0Lx1tPXz9iWtM1bi+7sOZf65Oy8rmjPjq/24Sx/yiG4A1i833TlT6XNURg9ldHiUmhPTw9j+MWPHcYvtsw==
    9EXEmnYmidrXsxTx6FGn+XH9hF7QRInrzBMkrzNPkMDOvPUS+0i3yc0G7Z2YfubueF8PipaRZon2LsqO7YZ2vdqien2GvQggTMtKmAyGsQIy+FOznW3CKaLyvXi53rEX1npZvQ==
    rkpC3euQArzMivirmDL87vmQlLQt+7qaFBZZVjwlW3HEu7os2lzrS15lIZkl+WB/eIyqlPVKF4j5S/3pmrr0MTqsPqDPWZTmYuIWvNlHaSaJ20G8+/Lxg/SlODRtZjMxYoBuUQ==
    18VeGLM7E/i3P5P7v4tx0KFNcP4s6GgdQaeHGMxLBSwyLanYCiLRbWaap0LWUMb7V/J8X0TlVgztc5m0H2OpE0HEu2h/aDcdArRF6+ITrT8CdkOM9++oTJvzQqJE9UUIrHfasA==
    Ot7/J4nXl7pPhSTkzNCvx5qdf2RbXWYtDrd+m3CBW79FYNGky0OTvwIO9gK3/mAvcKIO1suiqkq5l1AX80Qd7okn+njXN38dr8iKcnfMxE3gCShsBk9AYVNYZMd9Xok8YsYTeA==
    wIwn+ngFpgzjCTglx3j/LNOtsGAwmKhIMJioMDCYqBgwmNAArP+ETg+2/mM6Pdj6z+q0MEFbgB5MVJ4JXf4FXeXpwUTlGYOJyjMGE5VnDCYqzzRfSnY7ugkWt8T0kKJyrocUtw==
    0OR1sj8UZVQ+C0IGWfIQCThB2tI+l8Wuub+hyNsPcQtANueoM4Gb7RYnKsh/JvfCXGtYIv0ScEY0yrKiEHRu7WXBYZaXn12bMmN3cqx24XMWxcljkW2TknNMfFvaL9+1t2W8dg==
    n7kx67Tnh/ThsZbuHs9n+/sYQ560PDXsF2bTAw7NuXG6n2XI7GOyTY/7k6PwZgpDm2/MMvrCmEwbv+wkLiz1mZZwTGPa8mWXfGFpzrSEY1ozLZlOLyzH9OBH5dfBRDDH8ufc4w==
    cZLPHMuis/HgsGOJdLYcSkFzLIsupCI5cdxcLYDRmacZvv088fDtMSriUzBy4lNm64qPGBPY78m3tFnZMUWTjXf+9ASo+2wTPaty/nYs2vP2Fxec5t/U9Z5unPIqkQY52vwLVw==
    F1WGP4+zyw0fMbvu8BGzCxAfMasScc1RJYlPmV2b+IjZRYqPQFcruCLgqhW0x1UraL+kWkHKkmq1YhfAR8zeDvARaKFCBFqoK3YKfARKqMB8kVAhBS1UiEALFSLQQoUbMJxQoQ==
    PU6o0H6JUCFliVAhBS1UiEALFSLQQoUItFAhAi3UhXt7rvkioUIKWqgQgRYqRKCFyvaLK4QK7XFChfZLhAopS4QKKWihQgRaqBCBFipEoIUKEWihQgRKqMB8kVAhBS1UiEALFQ==
    ItBCbW81XC5UaI8TKrRfIlRIWSJUSEELFSLQQoUItFAhAi1UiEALFSJQQgXmi4QKKWihQgRaqBCBFiq7WLhCqNAeJ1Rov0SokLJEqJCCFipEoIUKEWihQgRaqBCBFipEoIQKzA==
    FwkVUtBChQi0UCFiLD+7S5S8j9kr+LOe3E/sz7901Tn1e/9W7j5Km486ecVnzb8XwS2Kr9LgjYca6zfmQdL7LC3YKWrOZfU+l30kAnXh81dv/A6fPn3lly5190Kwa6YATuZagg==
    cypkLOX7lqDJI2OZ3rcEu04yVn37lmAZJGNFl+ny9KEUuhwB47Ey0zNWOOZj1bpnDqd4rEb3DOEMj1XmniGc4LF63DPUpaY4v7bWZ86Tcf58KSCMpWOPYPIJY2kJY3Uqx1AYcw==
    g8YnzI0enzA3jHwCKp5cDD6wfBQ6wnzUslBDmWFDvVyofAI21JCwKNQAszzUELU41BC1LNSwMGJDDQnYUC8vznzColADzPJQQ9TiUEPUslDDpQwbakjAhhoSsKFeuSBzMctDDQ==
    UYtDDVHLQg03d9hQQwI21JCADTUkLAo1wCwPNUQtDjVELQs16JLRoYYEbKghARtqSFgUaoBZHmqIWhxqiBoLNTuLchFqVIR75rhNWM8QtyD3DHHFuWe4oFvqWS/slnqEhd0SjA==
    1SnmuG6pHzQ+YW70+IS5YeQTUPHkYvCB5aPQEeajloUa1y0NhXq5UPkEbKhx3RI31LhuaTTUuG5pNNS4bokfaly3NBRqXLc0FOrlxZlPWBRqXLc0GmpctzQaaly3xA81rlsaCg==
    Na5bGgo1rlsaCvXKBZmLWR5qXLc0Gmpct8QPNa5bGgo1rlsaCjWuWxoKNa5b4oYa1y2NhhrXLY2GGtct8UON65aGQo3rloZCjeuWhkKN65a4ocZ1S6OhxnVLo6HGdUsfqUkq4A==
    K6Du9lFZSwu+L+7m6eKHoZoB2E+v0ffXlNZ8N3jvRp5t+92oHZC98f32/ANOjXHjjtT9VFb3NPO6u5DZjsgM4VDxIx0r7r7ViTNU9+2s59uL2Hezvh6Y8xWuzJGX0Jze3c3ryw==
    fLXvu5itUb/rJhVGfGapMjpHbTbxHLQ7eUx5SP25z9ofE6N/vM+3FPDU/ZBW6+n2e9Si6OtekmUfo/bdxYH/1izZ1e2risxu5n/1+n37vXRc+5IVMC7g5tKZ9mH3g2ac+W6/qQ==
    vruyzk3JRqUD080+5rF2pmfm8Nmb3j3I7Bbk126Be5TbmY3oaL82Iu9n9WXq4w6krNImKdhbZFm2TEsNuii1eRM31ez0Dktu/nVBOv2SHee4L8pEfKxoSrCK8jouoa35tqqqoQ==
    6QXE8AxbtWVCPEcJiK0Yhg6mZtJg4MAURdFMNgPrHbbcUFFU1aZDeUR1QkdWLPpX6Gta4ISaDByeNBhw2PGVQD3N9EqHPScwLV2RDdPRiaGGlu4Eqm3pqiWHgaWZwOFJgys7rA==
    OYZGDMf3XYUQS9FcXVND11As1zKJZ0KHJw2u7bBturJvEsUNZWKpCg2158q25slqk50whycNru0wTT5iyI4hWzpRPcuxHVdRdE93XC/UgwA6PGVwZYfpdHmBpsiKaWvEJrqrew==
    iuMYoWMHNNaeAxyeNLiyw7bi6oFFZ0e3CFFNn0qK1q3QcKyQOJoOHZ40GHDYInT+fTEO67bl+5rjhrqiEUvX6Tz5hqoovurQOisT4PCkwZUdNn070Eyiyb7nElpjbc8MVTtUnA==
    gASq4sM6PGlwZYctp1G3ZdJNj0w8xXBc1w9CXSfECXTDbn8P9WLhmDK4ssOe5tHkU4liux7xQsV2LMWzTD0MXEU1PAsuHFMGV3bYIEQ36czIdI0lBvEtYipED+jy6zmybdnA4Q==
    SYMrO+xaoeY6qhloNDEDRXcUKwhpzXKIoduqB0U3aXDtlPBMLaTLlkXTj1im4cp0CjUqJMd0lFCBops0GHLYI5bPFu31Dgem44eK74aq69NVQLNlxSGqQiurSWxNMYDDkwZXdg==
    2KU610zfcn3DJzKVfBiEvq4ZqmvLjmPBpXnSYMDhUKciFbTShYbh0MZBtjRfISHdGnjNP9lWA1uWdQM6PGlwdYdlXdVDhfihS2TXsU2L+IpryIGvBabuDzg8YXBlh/XACLVAsQ==
    bVeTaUqGzfZWVU3VMQ26P5c9uDRPGVzZYZvuB0xVdeh+QCe25Vmu1+xxaV2lCWroUHSTBgMON3vl9iYMAfthN6AbAdM2dLrNdULdos0D1VAYEIuuYQNL86TBgMMB3R21N1atdw==
    2A9JoxojILpNHMuiK5ivuoFnk9DQQxV2HJMGV3ZYCy2DFlLXDTTa+pqBSwe2FFmVTcdQXGVghqcMBhzWAs0WtdJpiqkR0yCeLmuErlqu4ul08kxF9TS6T4d7iUmDKzusBrTF8Q==
    ZKoc2gz7Gl3GApduv0xft+g23YIzPGkw4LAfqvQ4Be3WXJcWJkc16CpFiEx35LS39FWbdjvUDR2WtUmDAYdfTmm9OHz6q/rl/wAAAP//AwBQSwMEFAAGAAgAQ3EfSVCcaFA6AQ==
    AABIAgAAEQAIAWRvY1Byb3BzL2NvcmUueG1sIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKVSzU7DMAx+lQ==
    Kvc2yYa2UqWdBIgTk5CYBOIWEm8La5Mq8dbt2TjwSLwCbemKQNy42f5+ZH/yx9u7WByrMjqAD8bZnPCEkQisctrYTU72uI5TsiiEch7uvavBo4EQtRobMq1yskWsM0rrvS8T5w==
    N1QrCiVUYDFQnnBKRi6Cr8Kfgh4ZmcdgRlbTNEkz7XkTxjh9Wt49qC1UMjY2oLQKBtWoCD0cknZV2yJr5yuJoXeopdrJDXROM1oBSi1R0u6yuB5PI4XQKkODJUS0r8P+5RUUDg==
    nfIg0fmu28GpcV6HAdEQlDc1tjl2k1IGXLYxrg3oq1M38XAwXcoFF3SsxRDMlzHoqD0/w1MNOTkjj9Prm9UtKSaMz2KWxlO+4pcZZxmbJWk6n1xczp8F/eXzbVwNS/zb+WxUCA==
    +vMdik9QSwMEFAAGAAgAAAAhAPwAvlV/DwAAfpMAAA8AAAB3b3JkL3N0eWxlcy54bWzsXV1z2zYWfd+Z/Q8cPe0+pNaX7ThTt2PL9ibTxHXjpH2GSMhiTRFakort/vrFFylQlw==
    IHlBrLcz3clDLFL3ALjnngtckCK///F5kwTfaJbHLD0fTb4bjwKahiyK04fz0dcvN2/ejoK8IGlEEpbS89ELzUc//vD3v33/9C4vXhKaBxwgzd9twvPRuii2746O8nBNNyT/jg==
    bWnKT65YtiEF/5g9HG1I9rjbvgnZZkuKeBkncfFyNB2PT0YaJuuDwlarOKRXLNxtaFpI+6OMJhyRpfk63uYl2lMftCeWRduMhTTP+aA3icLbkDitYCZzALSJw4zlbFV8xwejew==
    JKG4+WQs/9oke4BjHMAUAJzkFAdxrCGO8pcNfR4Fm/Ddh4eUZWSZcCQ+pID3KpDAox84mxELr+iK7JIiFx+zu0x/1J/kfzcsLfLg6R3Jwzj+wnvBoTYxR31/kebxiJ+hJC8u8g==
    mDSeXIs/Gs+EeWEcvoyjeHQkWsz/4Ce/keR8NJ2WRxaiB7VjCUkfymM0ffP13uyJcWjJcc9HJHtzfyEMj/TA1P/GcLeHn2TDWxLGsh2yKigP1MnJWIAmsdDF9Pis/PB5JzxMdg==
    BdONSAD1fwV7BDzO45dH870SFT9LVx9Z+Eij+4KfOB/JtvjBrx/usphlXDjnozPZJj94Tzfx+ziKaGp8MV3HEf1tTdOvOY32x3+5kcGvD4Rsl/K/Z6czGQVJHl0/h3QrpMTPpg==
    RHByKwwS8e1dvG9cmv+7BJtoJprs15SIfBJMDiFk91EQU2GRG6NtxtwdjF1+C9XQ7LUamr9WQ8ev1dDJazV0+loNvX2thiTMf7OhOI3osxIibAagduFY1IjGsYgNjWPREhrHIg==
    FTSORQloHEugo3EscYzGsYQpAqdgoS0KjWCfWaK9Hbd7jnDD7Z4S3HC7ZwA33O6E74bbnd/dcLvTuRtud/Z2w+1O1nhctdQKPnCZpcVgla0YK1JW0KCgz8PRSMqxZJHlB09Meg==
    NPMySA8wKrPpiXgwWkjk5+4IkSJ1n88LUc4FbBWs4oddxmvzoR2n6Tea8Co5IFHE8TwCZrTYZRaPuMR0Rlc0o2lIfQa2P1BRCQbpbrP0EJtb8uANi6aRZ/eViF6SQhXQvH5eCw==
    kcQegnpDwowN7xoj3vLDxzgf7isBElzukoR6wrr1E2ISa3htIGGGlwYSZnhlIGGGFwYGZ75cpNE8eUqjeXKYRvPkNxWfvvym0Tz5TaN58ptGG+63L3GRyBRvrjom/ffuFgkT2w==
    4s39MBcyzR3r28x9/JASvj4YPhvpLdXgjmTkISPbdSA2rTv7j27nkkUvwRcfU16F5GvZLyNowUcdp7vhDq2h+dJehedJfRWeJ/1VeMMV+ImvosX67b2fcud+tywaNY0QG0l2ag==
    vTtcbaQYHmF7AdzEWe5NBs2wHiL4Vqx2BZ0+VoL7Xg7v2B5ruKwOs5LX7mlID71MWPjoJw2/f9nSjFdtj4ORbliSsCca+UO8LzKmYs2U/FRS0kvy15vtmuSxLKVqEP1XAuX19g==
    4BPZDh7QXULi1A9v1282JE4CfyuI918+fQy+sK2oQoVj/ABesqJgG2+YeqPwH7/R5T/9dPCC18jpi6fRXnjaPZJgi9jDJKOQWOQJiS8z4zT2ModKvJ/oy5KRLPKDdpdRdYtLQQ==
    PSHek81WLTo8aIvnxSeefzyshiTerySLxbaRL1F98QJm7Crmu+XvNBye6m5Z4GXj6OddIbcn5VJXWvuDG75MqMENXyJINvn0IOLXw2BrcMMHW4PzNdhFQvI8tl5hdcbzNdwSzw==
    93iHF38ajyUsW+0Sfw4sAb15sAT05kKW7DZp7nPEEs/jgCWe7/F6DBmJ52HHTuL9K4sjb2RIMF9MSDBfNEgwXxxIMK8EDL+BxwAbfhePATb8Vh4F5mkJYID5ijOv07+ni0AGmA==
    rziTYL7iTIL5ijMJ5ivOZlcBXa34ItjfFGNA+oo5A9LfRJMWdLNlGclePEFeJ/SBeNggVWh3GVuJ3z6wVN3j7QFS7FEnHhfbCs4Xyb/RpbeuCSyf/fKwI0qShDFPe2v7CUda1g==
    b23rMpM/9BjchbuEhHTNkohmljHZbXm9fK9+tXHYfdmNXtueH+OHdRHcr6vdfhPmZNxpWRbsNbPuBpt8flL+3KXJ7BON4t2m7Cj8rcXJrL+xjOia8bzbeL+SqFke97SEbZ50Ww==
    7lfJNcvTnpawzbc9LdXlbtOyTQ9XJHtsDITTtvipajxL8J22RVFl3NhsWyBVlk0heNoWRTWpBBdhKK4WQHb6acZu3088dnuMiuwoGDnZUXrryg7RJrDP9FssZnZM0pTtVXdPgA==
    vC8X0b0y5y87pvbtaxec+v/m6wNfOKU5DRpxZv0vXNWyjN2PvdONHaJ33rFD9E5AdohemchqjkpJdpTeuckO0TtJ2SHQ2QrOCLhsBe1x2Qrau2QriOKSrQasAuwQvZcDdgi0UA==
    IQRaqANWCnYIlFCBuZNQIQpaqBACLVQIgRYqXIDhhArtcUKF9i5ChSguQoUoaKFCCLRQIQRaqBACLVQIgRaq49reau4kVIiCFiqEQAsVQqCFKteLA4QK7XFChfYuQoUoLkKFKA==
    aKFCCLRQIQRaqBACLVQIgRYqhEAJFZg7CRWioIUKIdBChRBooapfIroLFdrjhArtXYQKUVyEClHQQoUQaKFCCLRQIQRaqBACLVQIgRIqMHcSKkRBCxVCoIUKIdBClRcLBwgV2g==
    44QK7V2EClFchApR0EKFEGihQgi0UCEEWqgQAi1UCIESKjB3EipEQQsVQqCFCiHa4lNforTdZj/B73pa79jvf+lKd+qz+UtvE2rWH6rslR2r/28RLhl7DBp/lziT9UY/kHiZxA==
    TG5RWy6rm7jylgjUhc+fF+2/8DHRBz6TSf8WQl4zBeDzvpZgT2XeFvKmJSjy5m2RblqCVee8LfualmAanLclXanL8qYUPh0B47Y0YxhPLOZt2dowhy5uy9GGIfRwW2Y2DKGD2w==
    8rFheByI5HxofdzTTyfV/aUAoS0cDYRTO0JbWEKuynQMhdGXNDtCX/bsCH1ptCOg+LTC4Im1Q6EZtkO5UQ1lhqXaXah2BCzVEMGJagDjTjWEcqYaQrlRDRMjlmqIgKXaPTnbEQ==
    nKgGMO5UQyhnqiGUG9VwKsNSDRGwVEMELNUDJ2QrjDvVEMqZagjlRjVc3GGphghYqiEClmqI4EQ1gHGnGkI5Uw2h3KgGVTKaaoiApRoiYKmGCE5UAxh3qiGUM9UQqo1quYtSow==
    GsWwYY5bhBmGuAnZMMQlZ8PQoVoyrB2rJQPBsVqCXJWc46olkzQ7Ql/27Ah9abQjoPi0wuCJtUOhGbZDuVGNq5aaqHYXqh0BSzWuWrJSjauWWqnGVUutVOOqJTvVuGqpiWpctQ==
    1ES1e3K2IzhRjauWWqnGVUutVOOqJTvVuGqpiWpctdRENa5aaqJ64IRshXGnGlcttVKNq5bsVOOqpSaqcdVSE9W4aqmJaly1ZKUaVy21Uo2rllqpxlVLdqpx1VIT1bhqqYlqXA==
    tdRENa5aslKNq5ZaqcZVS61U46qlT9wk9vAIqPsNyYrA4XlxR0+190aJBuRr2fj3C44mHh1u/JAnUs9G1YDyix+i6v1Owlh0J9Bv0tKHZa/1hUz5d5bzalN/Zzy+Op5fXV+rbw==
    2d6UNR2bb8qaVx+sb8qSXesYTNV9fZ12Agawf++U7N2ScL/9LJwOhpeKhxI2HBdklMfLZhZrkqmz+zApv6OFYPfWxXx6ea0vddq8Zfpq7zjlK/pMwkKZM/WYpI/fkgre9GL10g==
    tqX89v5FahOtd/NFahOZh4z3obkQMLUSoCXkh4BpDwLqWungZL44GV90cmLxeanCus87vC2PDfS2el9bk7f11Xs/3p759naDAh4p3d7yLslj4sNH7uNcua0iYimeaMedorJHFw==
    LTLiAC3N7y8kv7e8v1CcvNbHxPnaKwxrlvtXGIrDl9UrDEMxw1TU38yvTuUzNeSX5ezDM6Cce2RSlofFDVEc6PSmjJ1qWPr+itpLEOWx7mgKOZE8eaiH7llmAv3w7OrXn/LR2Q==
    h3FmecK2JUZ08t1PZ80hY+93IWbqlj7Lmbx1ClOTvTWIdRR39ZD3Z5moOOJ/fEhFTD/pbK16Gj0TBcXPL2iSfCLq22xr/2pCV0KK/OxkrOKifn6pHhtqtc/k+tIKcFTvjPrYHg==
    J+o9I/rGJ+uKQSyiGtwt78Ib6ukesVBnX+x/g86oFZ48pTxZz4dm2Fj6Wz7jop7ArufjRXmvap8pvGu5U4+rS5ZFNJMLORU3slXxCH498D94CpR/8DZp9RJPlUY0chVVTrZVxA==
    OVmX8ehkHPNUGtH3w8x/dTNX0qjc30cpzfPzjXof1WE46tdUNYWibQpWSK0TsH0G7gxariUVZmRZfk/MQmp+2LJcVKdv9QRrfEcSXH3lbKZuPhfu0njNa6fuxX1tfgp3OQ9CWQ==
    1BzmHsMrhz5Wp4K9xw4c3Ti9Wdze5XKbf3sOsBqOfrT34VD0YdwoYG/LNyTb12NmZNQqhuVCLMGGrFIbVKDf+YZRgUL6vwrqKjC8cuhjdWqoCjSBr6QC4ylP8iFPh2MCT4EaKg==
    DMtapFMbtdX827H4p8fbIZOWpYu6zH44ZOOivvpC05B7rGLKm6MPhraYnJ0hNiJebxVzeSP+iQNmibQk4eNDxnZpBMqkS10m4Rc9zk25rJGcG3NYUjm35bQCG9gacsHm2Jq39Q==
    3S0rnyl3qFjjcXNdE5y1Tm6ZqCeTyULX/63bVH4nmWrL83C0+mQw8THTiFasqbopf5nbSK+20al+tHToCHW0afzmHNpnz00ita10JjqXD9tgnkybd4p7bI9Ztr8OPD/r6eW+cQ==
    uPdLo++HBqBBoN3lneH36t5rjtHq/WCHrqpO+IjUEqw1WDtTWoMXazubPZdWfcOo1mmbe4YGU93Ndq/8Tz1Ru5Ry6IkysU89JXZdgvZM7ObVGK9XU5C+URc+bL6ZefKNLi7cJw==
    vb/0JY3mDFi+svSQu/J4E2m2PKdt2tKcprD78oE9D06ms4vTK4UDJu3ywtf0bcOVr1hehhCVDyei/PXt72EJrbYplC//bJfCji/PLq/knTVNceNV0iaLlqgYqudacPUNEnsU/A==
    FVmSB5trDXVq8NQsUfRxFj427hGeLU7HqkqwsMC5Jkm8zGrerx2ULq8dCXOxytzQPLilT8FntiFpg6/H49PxQgsbFi08rMoDulDG58hO71s8j8qZBo8dec/0tTXvnZhpr9pnbQ==
    y2Z/cobKv/If/gMAAP//AwBQSwMEFAAGAAgAAAAhAMEjYBagAQAACgQAABQAAAB3b3JkL3dlYlNldHRpbmdzLnhtbJSTTW/bMAyG7wP2HwzdGztZGgxGnQJB0WFA94G1212W6Q==
    RJgkCqIS1/31Y/zRZMsO9UnkS/ERCVI3t8/WJAcIpNEVYj7LRAJOYaXdthA/n+6vPoqEonSVNOigEC2QuF2/f3fT5A2UjxAj36SEKY5yqwqxi9HnaUpqB1bSDD04DtYYrIzshg==
    bWpl+L33Vwqtl1GX2ujYpossW4kBE95CwbrWCu5Q7S242OWnAQwT0dFOexppzVtoDYbKB1RAxP1Y0/Os1O4VM19egKxWAQnrOONmhoo6FKfPs86y5gS4ngZYXABWBNMQ1wMipQ==
    1sKzSKzKP28dBlkaJnFLCVeVdGCx5pFW+kDDmTS5rgrxYZktF/NV1oVLrNq7LnSQhrdFpEeV5/kAdRzV7FX9obe7/8hP6C/FDcaI9h+dy9hU4WjFU47jPRTs0Mvx3tHwUsFgKw==
    NMjrI/cRe4Q5q2xaZvlXRdNyw3nnU1LTU9O9OZ7dWMafOZL3TrMA/Zvoo7b6Be4xbAI2BKEvBUz7zf368tB50hhsvn/91D919oPXfwAAAP//AwBQSwMEFAAGAAgAAAAhAEtZ7Q==
    XbgBAAA8BQAAEgAAAHdvcmQvZm9udFRhYmxlLnhtbNyS32rbMBTG7wd7B6H7xrITp52pU9augcHYxWgfQFFkW1R/jI4SN2+/I9nJoKHQ3OyiNhjp+6Sfjj6f27tXo8leelDO1g==
    NJ8xSqQVbqtsW9Pnp/XVDSUQuN1y7ays6UECvVt9/XI7VI2zAQjut1AZUdMuhL7KMhCdNBxmrpcWzcZ5wwNOfZsZ7l92/ZVwpudBbZRW4ZAVjC3phPEfobimUUL+cGJnpA1pfw==
    5qVGorPQqR6OtOEjtMH5be+dkAB4Z6NHnuHKnjD54gxklPAOXBNmeJmpooTC7TlLI6P/AcrLAMUZYAnyMkQ5ITI4GPlKiRHVz9Y6zzcaSXglglWRBKar6WeSobLcoP3Atdp4lQ==
    jJ5bBzJHb891TVnB1qzEb3wXbB6/NIsLRcc9yAgZF7JRbrhR+nBUYVAAo9GrILqjvudexdJGC1SLxg42rKaPjLHi+3pNRyXH6qKyuL6flCKelZ5vkzI/KSwqInHSNB85InFOaw==
    8MxsTOAsiSdlJJDfciB/nOH2nUQKtsQkSswjJjO/KBGfuBcn8vg2keub8r8kMvUG+aXaLrzbIbEvPmmHTANY/QUAAP//AwBQSwMEFAAGAAgA92otSVVss8tOCwAAvGIAABMAKA==
    AGN1c3RvbVhtbC9pdGVtMS54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArV1rTxxHFq3PK+U/WPs9cTwv0IpMZPDGsYRtYibO5pNFYLDRegDNDA==
    jvnzyd6qmqIe91nNCsXMdJ17zunb1dX1avL3XwfuR/fVrdxn98R9cUu3dht35W7ctfvB/dM9c9+57+H3Eyi5dudw/AJKr93HUHrntu7SfQuoGXz70c3dN+4f7sC9cWfA9Rug1w==
    gH8Hsbfh89b9JyidQLn/9mSnfA2akW8Nn/8Fx65Aaw0xG/jvEpDfAs89lJ3tyjZw5DqoPAVc5t/A91P4fQalF0Hlwn0APc987j7BkQ2gP7i3ocSf7VNwP3Yj+HkKDuIZPIGfAw==
    Iupn+PdsF5eREf0czuMzuPjTvQLtL/DJ+1y6F/B7A58+uGP3ByDmZuQBOLKztm5WgL2DmG2ljI9GFQpdMx5C+X0484zAxzwbhaS4fgLEyr0PNesC6sxNdaXqXPdGZB89Ko9z2Q==
    5qU/cohrPcc3wPQc0Bfw+Vnlri6p1dsoC/uIZR8J7CMj+5hlHwvsYyP7hGWfCOwTI/uUZZ8K7FMj+4xlnwnsMyP7Hsu+J7DvGdn3WfZ9gX0fsR+F8tvQ8t8/4JbQSm5C/ZXLvQ==
    ksZg1xspeiNVD98TEnqs6I1VPXyXSOiJojdR9fB9I6Gnit5U1cN3koSeKXozVQ/fWzX6MPz+L0Sdh15VfPb6dr5V5pHYg8Q6zE1+uvRG9LjjnmF0/CFk+Sz0Rj+JGWtxvCPMOA==
    xIeWKw5v99WXpzeht7xk/aRyXj8z9OhpeWhxur7tvI+gRm2gRvljL6F/vCbqBoXB+jRTrzaXBwlr82LLx7/da/h0RTjIJVivjJLZVzscd54YQalhFkk1ZYC678syrFRHWjW4cw==
    ozCypu38fg7flmGE/JG4d9tyrIkZevS48+Vwur7tvF/BPf8c8tTqpuNYJ0dYeLnzast5Hdt5HMMZf4TPn91bdwk/cbTeqtIorM2x9Tvgzl9GWx1Zc3MDsTdQM27CHNN2N8+EPQ==
    0TjKDcco+TiBp6lHLclWpC7Fmm20XYm7BjRKU7bl/CRcoW2YOVhC+VMF/y5c36vwxPF9j5TRN8CwAr04T9Ifg8/GpvRYr1zOe2KHebddn1P3G7QwP7kFcphLsH4ZZWPn8oARkg==
    mu2c3kN7uRByhO85PQK7sqg8ziWXM3vkENf9OdYyquevL1vW3NgzoZ33dXjS+BnRBXw7Aobbh5zVTizI5MXG2rrxLel6t6aR+jjpCnBlUZGPrDX83L73tHRfwc+8+e65WkQbfw==
    A23+AnJ8G57N3Gy3DRf1bIyUj7vQG/Qj/Rehpi8flHFJ1qKibOz5ymkISY27/i1+EXodn0VdjKGUKaZW+84tqyyW3yNnjajj81jrFWCyCn3c83ERLe/XcOf4mn0ePr0I60jt+g==
    WV1XhkRFT0PUasf8GEUa51hHNq9C9lfgaxnW6NaQQaplseG8spWR9nEcVmyXzCqfBVV6kNloB3S/SCotFS29qoT9BbBnwZO/m+4JNQ5RKvIstOqvgL0is9qWlCo4SmY/Cde9Hg==
    b+kYSpFiqrXldVJt5bVnlTWvxOO2ly/zKlKkriG3F70RnJ+eVinH1/0h+nitKPWg3oZ9Grfh39jfaI9ErhZVs+BWj2ojtbbRl98XT9ul2+6eMJuGWUMlNZ1NcrAI2VsBPrWtrQ==
    OkZgZYqlT5U7dx5pcSHnwPd6bfsi+vDZmV2h9Rf39KxCW6VfLzs6euthp53dh2j5OtqQpSOdFbuJ7fgm7A86B8ydSzu04girdmRFJ1d2dt1ZiuBrWW8M51JTeqxXOae22GHe+w==
    873djRE1hOxnS44026fbuhiT8mVRiY/kNFLPM+6ESzvgnod7prwiPfjai02B85efxtxcgh1b+9KZdU+pT9LjTY7hPGpKutfY4+9xKkVwPmWV2mUcbS4B5ffI/lGNCfgyryxFYg==
    jcvgLO61XRb3BF+WNLjIWuPUnYU5hk2RkRMXd/3GGci04m9FHoQdt1bW1s3S+f2tcf4trnPL/YTeiOiuV+VxLvP1HRo5xDVXq04BdxV6O7GP89r5XrJfSbooejkWVHRlYet3UA==
    5syOtjrScuNzXO51pY+Xam2EzjtieEcsL94DSKHGDO+Y5cV7/SjUhOGdsLx4Tx+FmjK8U5YX792jUDOGd8by4j16FGqP4d1jefHOVwq1z/Dus7x4z2tCbQtU3H+I7yceU+pJTA==
    rfYdHPf4bWj9S0W6JOpwUTX7Akq/Qj/swqWRWVx74J7WfXjvpFeh9cevGMkrT/a1pgWRJXwsccr59L34411f/nDX5z4GH78XETrGa1mYsPZi14ume9iJp+1pD41MPoep6u7LOQ==
    cM0vjeUccsy6p3Y8rmM4D/LIno+wZINCyj7smTgN9+8546AtbVVxNKWU6kx+/4rrQ/bhsxu7AuUvt2dXYXW77hnqmOxDZqK0fe80jzvwscxdIymucl+AnGEdmXUtrK2bOHtZ9g==
    9fCxqICRMteI4BqRXLgn2CLGBNeY5MK9vxYxIbgmJBfu8bWIKcE1JblwL69FzAiuGcmFe3YtYo/g2iO5cG+uRewTXPskF+7B1bPj+T7FR0s+abUnYfz7sH7Vnutr2HClqsZY+w==
    +D2sDq93cxP8/WbDeR9WRnmO8sPD86VGRnT7vi3VCuf4HjT1Nq/MbneXZmflcskBNb+bNPM6P7cKMDeh2jeNeTbsIo/kqUxJpXFfjBTdp1bu89FRmjp99yQXV2EU5q9OXLn3uw==
    1jZVb0jHpP1iGhOnn/YM5Aj6Clix2Y+NGfuiZ+epWCsy7pGwsmqOuPbRgsJOLK1tdNGOHSjvOsY7sDDx+nKrZkGVHnrbyFTW9vKwAw5RqvMsWJnHSkr/D4VcKzSEpCjVLYzG1w==
    h1+B47D06hvPjH394uL+LCp/fJnXlSJ7dLI7HSPrSueZZ3jqddk5W1LPC7VRkkJeBZZmuGzY2oXOTPnCu47zlZJKo7YUjdV+dW/dawbNl3klKbJHJ+dCx8i6UlZjPUh3WOqR0Q==
    ezrt2DzStjFzvui5ByqzfXhtdsN27foYbLMv8jUeqliPhPCuC24sVLYGG6W1KK/snDletwJ1hJWbb/d4FK/b0x76HecZm+etNEStzrHY23pKmUZIbb9dGf+1Kepubt3YorBDqw==
    muQ6ri7l73OhrHaAIyUd6krQubdlO89DU1nFpbUGFa2rlasfvCqFotRpNt2FtWbpaMpVb03CmWzns6myeiUBR7atMN+2JgdHDyx4Rqt1yq1uxTLLGloss62ZJdYhjur1tv7VvQ==
    Iat6Vqf1iNeykmdbwbPqp+cQXyavkvXpSGdZHrOszPUpp6sjaSeMrJ6ZevSpPpTkhcLLvmiFtg3Q73O6LYgr7dw5H+96GZ/cO5feAaSP55V8HMFxpxXS6AGvxUmIrCexcMq4dQ==
    TXmQy9v9ChSDrFnvcJD2SMh7I2w1gMaW7yv4v3hxA5/pOZqIK99oSNmux9vzDmz5foKFmfe12vW7v4S/6ZdmxTlnFnT7NofObnV3+dC6yeW8g8xg16TfaaEQki69D1NWfgk1Kw==
    /l22+O6XDSe5aBmHerHVDznK7rOvvlDvws5VROuGZpGVbaPa3ojW2dCxc8lBjU7k8taFbXwjR5TvpVhwugdpZIcj6fGRDUd76R9x0TMQI8NMxsg0l9HuUmn16XmIWp/DWGY08A==
    Lpn2PqOendTV0sdfdN3gRwF9eL729YwzNAaqlZDHH1bGoV6s2WrHKH3sQ93lEUcf3u5QGtPYGPzow+rPY+3eIjPv6x7Fa31PawR+Q9aiIrUEltGX/0t3212Z1NYfOv+myX2BaQ==
    j3h1jMJMR2FnziZk/WOBpI97Vi4Cc78MZ78M+amxXInn56Pa7MrZotce8Ngvrk7b/t8Rc/c/UEsDBBQABgAIAAAAIQCTdtZJGAEAAEACAAAdAAAAd29yZC9nbG9zc2FyeS93ZQ==
    YlNldHRpbmdzLnhtbJTRwUoDMRAG4LvgO4Tc22yLLbJ0WxCpeBFBfYA0nW2DmUzIpG7r0zuuVREv7S2TZD7mZ2aLPQb1Bpk9xUaPhpVWEB2tfdw0+uV5ObjWiouNaxsoQqMPwA==
    ejG/vJh1dQerJyhFfrISJXKNrtHbUlJtDLstoOUhJYjy2FJGW6TMG4M2v+7SwBEmW/zKB18OZlxVU31k8ikKta13cEtuhxBL328yBBEp8tYn/ta6U7SO8jplcsAseTB8eWh9/A==
    YUZX/yD0LhNTW4YS5jhRT0n7qOpPGH6ByXnA+B8wZTiPmBwJwweEvVbo6vtNpGxXQSSJpGQq1cN6LiulVDz6d1hSvsnUMWTzeW1DoO7x4U4K82fv8w8AAAD//wMAUEsDBBQABg==
    AAgAAAAhAEtZ7V24AQAAPAUAABsAAAB3b3JkL2dsb3NzYXJ5L2ZvbnRUYWJsZS54bWzckt9q2zAUxu8Heweh+8ayE6edqVPWroHB2MVoH0BRZFtUf4yOEjdvvyPZyaCh0Nzsog==
    Nhjp+6Sfjj6f27tXo8leelDO1jSfMUqkFW6rbFvT56f11Q0lELjdcu2srOlBAr1bff1yO1SNswEI7rdQGVHTLoS+yjIQnTQcZq6XFs3GecMDTn2bGe5fdv2VcKbnQW2UVuGQFQ==
    jC3phPEfobimUUL+cGJnpA1pf+alRqKz0KkejrThI7TB+W3vnZAAeGejR57hyp4w+eIMZJTwDlwTZniZqaKEwu05SyOj/wHKywDFGWAJ8jJEOSEyOBj5SokR1c/WOs83Gkl4JQ==
    glWRBKar6WeSobLcoP3Atdp4lYyeWwcyR2/PdU1ZwdasxG98F2wevzSLC0XHPcgIGReyUW64UfpwVGFQAKPRqyC6o77nXsXSRgtUi8YONqymj4yx4vt6TUclx+qisri+n5Qing==
    lZ5vkzI/KSwqInHSNB85InFOa/DMbEzgLIknZSSQ33Igf5zh9p1ECrbEJErMIyYzvygRn7gXJ/L4NpHrm/K/JDL1Bvml2i682yGxLz5ph0wDWP0FAAD//wMAUEsDBBQABgAIAA==
    Q3EfSarF2lDqAQAAYQQAABAACAFkb2NQcm9wcy9hcHAueG1sIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    nVTBbhoxEP2Vle9hAbVRi8BRlRx6aJVI0OQ88c6C1V3bsgcE/bUe+kn9hY7tZWOKeimnmTfPz288w/7++Wt5d+y76oA+aGtWYjaZigqNso0225XYU3vzQVSBwDTQWYMrccIg7g==
    5BLc4slbh540hoo1TFgcaCV2RG5R10HtsIcwYYbhYmt9D8Sp39a2bbXCB6v2PRqq59Ppbd1YFdXC8+bkWH/QA/e/engkNA02N270KJLnDfauA0K51hzoVmNTraHjFs4Ck8bScQ==
    WZfcdNASdBvdo5zm4pinp4AthqGS44i+WN8EOXv/MeE5i/j9Djwo4jcfjhRArH9ybE0B8UTkV628Dbal6jH1WUWZdKhkxVPcwBrV3ms6DbIlEhlftBld5jh797D14HZBzocGRg==
    INbXit/nnt9RttAFTJQ3LDI+I8R1eQIdGzjQ4oCKrK9eIWAc6EocwGswxJukf3A6F5mW0RR3LpCXG00d3zDmKSxpZazfyVkicHBJrEcPMtm9NBinF+8Jjy23Sv+wnAycDc9EYQ==
    8spfcdNfwnG2tndgTrk8JnkC38M3t7EPccfe3vYSv9yXF027tQOF15tTlNLUuIANb0A5tRFLU+M2fRcvYxGzxaZgXteGvXzOHwo5u51M+XdexDOc92f8z8k/UEsBAi0AFAAGAA==
    CAAAACEA++vDatkBAAArDAAAEwAAAAAAAAAAAAAAAAAAAAAAW0NvbnRlbnRfVHlwZXNdLnhtbFBLAQItABQABgAIAAAAIQAekRq37wAAAE4CAAALAAAAAAAAAAAAAAAAABIEAA==
    AF9yZWxzLy5yZWxzUEsBAi0AFAAGAAgAAAAhAFT4ZEJjAQAA7gcAABwAAAAAAAAAAAAAAAAAMgcAAHdvcmQvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHNQSwECLQAUAAYACABDcQ==
    H0nVl5QAGhEAAK0EAQARAAAAAAAAAAAAAAAAANcJAAB3b3JkL2RvY3VtZW50LnhtbFBLAQItABQABgAIAENxH0l0wVRdpwcAAC0jAAAQAAAAAAAAAAAAAAAAACAbAAB3b3JkLw==
    aGVhZGVyMi54bWxQSwECLQAUAAYACABDcR9JgKJAF2ADAAA4EAAAEAAAAAAAAAAAAAAAAAD1IgAAd29yZC9mb290ZXIxLnhtbFBLAQItABQABgAIAENxH0mKZKtz/AUAAIAjAA==
    ABAAAAAAAAAAAAAAAAAAgyYAAHdvcmQvaGVhZGVyMS54bWxQSwECLQAUAAYACABDcR9JK49lvsIEAAD6HQAAEAAAAAAAAAAAAAAAAACtLAAAd29yZC9mb290ZXIyLnhtbFBLAQ==
    Ai0AFAAGAAgAQ3EfSVhlj64WAgAAVggAABEAAAAAAAAAAAAAAAAAnTEAAHdvcmQvZW5kbm90ZXMueG1sUEsBAi0AFAAGAAgAAAAhAKomDr68AAAAIQEAABsAAAAAAAAAAAAAAA==
    AADiMwAAd29yZC9fcmVscy9oZWFkZXIyLnhtbC5yZWxzUEsBAi0AFAAGAAgAQ3EfSaiIA8wXAgAAXAgAABIAAAAAAAAAAAAAAAAA1zQAAHdvcmQvZm9vdG5vdGVzLnhtbFBLAQ==
    Ai0AFAAGAAgAAAAhAKpSJd8jBgAAixoAABUAAAAAAAAAAAAAAAAAHjcAAHdvcmQvdGhlbWUvdGhlbWUxLnhtbFBLAQItAAoAAAAAAAAAIQBUAQa58gMAAPIDAAAVAAAAAAAAAA==
    AAAAAAAAdD0AAHdvcmQvbWVkaWEvaW1hZ2UxLnBuZ1BLAQItABQABgAIAAAAIQDPjh4mdwYAAI8pAAAaAAAAAAAAAAAAAAAAAJlBAAB3b3JkL2dsb3NzYXJ5L2RvY3VtZW50Lg==
    eG1sUEsBAi0AFAAGAAgAAAAhANJ3OzP1AAAAdQEAABwAAAAAAAAAAAAAAAAASEgAAHdvcmQvX3JlbHMvc2V0dGluZ3MueG1sLnJlbHNQSwECLQAUAAYACAAAACEA+SKAu74EAA==
    AJcPAAAaAAAAAAAAAAAAAAAAAHdJAAB3b3JkL2dsb3NzYXJ5L3NldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQCD0LXl5gAAAK0CAAAlAAAAAAAAAAAAAAAAAG1OAAB3b3JkLw==
    Z2xvc3NhcnkvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHNQSwECLQAUAAYACAAAACEAP5/fMXELAAAtMAAAEQAAAAAAAAAAAAAAAACWTwAAd29yZC9zZXR0aW5ncy54bWxQSwECLQ==
    ABQABgAIAAAAIQA8o/nm4QAAAFUBAAAYAAAAAAAAAAAAAAAAADZbAABjdXN0b21YbWwvaXRlbVByb3BzMi54bWxQSwECLQAUAAYACAAAACEAP72VVQMBAABTAQAAGAAAAAAAAA==
    AAAAAAAAAHVcAABjdXN0b21YbWwvaXRlbVByb3BzMS54bWxQSwECLQAUAAYACAAAACEAeqhydMUAAAAyAQAAEwAAAAAAAAAAAAAAAADWXQAAY3VzdG9tWG1sL2l0ZW0yLnhtbA==
    UEsBAi0AFAAGAAgAAAAhAFyWJyLCAAAAKAEAAB4AAAAAAAAAAAAAAAAA9F4AAGN1c3RvbVhtbC9fcmVscy9pdGVtMi54bWwucmVsc1BLAQItABQABgAIAAAAIQB0Pzl6wgAAAA==
    KAEAAB4AAAAAAAAAAAAAAAAA+mAAAGN1c3RvbVhtbC9fcmVscy9pdGVtMS54bWwucmVsc1BLAQItABQABgAIAAAAIQAcguRBKg8AAJGEAAAYAAAAAAAAAAAAAAAAAABjAAB3bw==
    cmQvZ2xvc3Nhcnkvc3R5bGVzLnhtbFBLAQItABQABgAIAENxH0lQnGhQOgEAAEgCAAARAAAAAAAAAAAAAAAAAGByAABkb2NQcm9wcy9jb3JlLnhtbFBLAQItABQABgAIAAAAIQ==
    APwAvlV/DwAAfpMAAA8AAAAAAAAAAAAAAAAA0XQAAHdvcmQvc3R5bGVzLnhtbFBLAQItABQABgAIAAAAIQDBI2AWoAEAAAoEAAAUAAAAAAAAAAAAAAAAAH2EAAB3b3JkL3dlYg==
    U2V0dGluZ3MueG1sUEsBAi0AFAAGAAgAAAAhAEtZ7V24AQAAPAUAABIAAAAAAAAAAAAAAAAAT4YAAHdvcmQvZm9udFRhYmxlLnhtbFBLAQItABQABgAIAPdqLUlVbLPLTgsAAA==
    vGIAABMAAAAAAAAAAAAAAAAAN4gAAGN1c3RvbVhtbC9pdGVtMS54bWxQSwECLQAUAAYACAAAACEAk3bWSRgBAABAAgAAHQAAAAAAAAAAAAAAAADekwAAd29yZC9nbG9zc2FyeQ==
    L3dlYlNldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQBLWe1duAEAADwFAAAbAAAAAAAAAAAAAAAAADGVAAB3b3JkL2dsb3NzYXJ5L2ZvbnRUYWJsZS54bWxQSwECLQAUAAYACA==
    AENxH0mqxdpQ6gEAAGEEAAAQAAAAAAAAAAAAAAAAACKXAABkb2NQcm9wcy9hcHAueG1sUEsFBgAAAAAgACAAcQgAAEKaAAAAAA==
    END_OF_WORDLAYOUT
  }
}

