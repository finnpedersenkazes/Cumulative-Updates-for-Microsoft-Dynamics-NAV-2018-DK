OBJECT Report 1322 Standard Purchase - Order
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
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

    { 139 ;1   ;Column  ;VendorInvoiceNo_Lbl ;
               SourceExpr=VendorInvoiceNoLbl }

    { 160 ;1   ;Column  ;VendorInvoiceNo     ;
               SourceExpr="Vendor Invoice No." }

    { 161 ;1   ;Column  ;VendorOrderNo_Lbl   ;
               SourceExpr=VendorOrderNoLbl }

    { 162 ;1   ;Column  ;VendorOrderNo       ;
               SourceExpr="Vendor Order No." }

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

    { 165 ;2   ;Column  ;UnitPrice_PurchLine ;
               SourceExpr="Unit Price (LCY)" }

    { 176 ;2   ;Column  ;UnitPrice_PurchLine_Lbl;
               SourceExpr=UnitPriceLbl }

    { 164 ;2   ;Column  ;JobNo_PurchLine     ;
               SourceExpr="Job No." }

    { 177 ;2   ;Column  ;JobNo_PurchLine_Lbl ;
               SourceExpr=JobNoLbl }

    { 163 ;2   ;Column  ;JobTaskNo_PurchLine ;
               SourceExpr="Job Task No." }

    { 178 ;2   ;Column  ;JobTaskNo_PurchLine_Lbl;
               SourceExpr=JobTaskNoLbl }

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
      VendorOrderNoLbl@1082 : TextConst 'DAN=Kreditors ordrenr.;ENU=Vendor Order No.';
      VendorInvoiceNoLbl@1084 : TextConst 'DAN=Kreditors fakturanr.;ENU=Vendor Invoice No.';
      UnitPriceLbl@1088 : TextConst 'DAN=Unit Price (LCY);ENU=Unit Price (LCY)';
      JobNoLbl@1094 : TextConst 'DAN=Job No.;ENU=Job No.';
      JobTaskNoLbl@1095 : TextConst 'DAN=Job Task No.;ENU=Job Task No.';

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
    Ftau7MHRBN17pZMvAAAA//8DAFBLAwQUAAYACABOl25MQdHHJIQRAABoEwEAEQAAAHdvcmQvZG9jdW1lbnQueG1s7V3bcqNImn4Vh+ZirtzKcyaOcU0AQl2OqK7xVrmrN2Jjow==
    AkvYZkoCBWC73BPzZHuxj7SvsMlBGCSQkYRkJOWNZU5J5v/n9/2HPPB///O/f/v7z+nk7MkJQtf3LnvwF9A7c7yRP3a9+8veY3R3LnpnYWR7Y3vie85l78UJe3//8Lfni7E/eg==
    nDpedCYL8MKL59nosvcQRbOLfj8cPThTO/xl6o4CP/Tvol9G/rTv3925I6f/7AfjPgIQJP/NAn/khKF8m2l7T3bYy4qbLpfmzxxPXrzzg6kdycPgvj+1gx+Ps3NZ+syO3Ft34g==
    Ri+ybMDmxfiyDYF3kRVxnlcofuQirVD2M38iaPLe9JFBJoHkjf3Amcg6+F744M5em7FpafLiw7yQp1WNeJpOerkKINlOB4PAfpY/rwU2qf44fWg6SWu+ukQIGmgkLiJ/okkVyg==
    75zXZGq73uuLNxJNQbiQrlcAWixgdr+dcn4N/MfZa2nudqVdeT/ysmJcr1FWpuRi08LtKvP1wZ5JBE5HF1f3nh/YtxNZI6myMyn1s7hb92LGufXHL/FvdDvJfq6D7J+v0cvEOQ==
    e754sieXvZv4+V8DV/ahfnb9D3lN9iRJbvLwZSZLtx8j//W6IasjOTA58mfzgjzJePETI3/iB/NHni/CP7OSwpk9cpL/k3Imzl204aO3fhT50w0fDtz7h01f7HqhO3Y+bvX0tw==
    jZ7uLwn+dvLJfvEfo1xHd+5Pp6DET77/Y/4qQPSkyDs3CKMvvtQtjA8ndnb0etH0J49Tr3B9fiK5xfM/GtK45Uff0iNYqGLeyeIuFf97L39lIWmXQhoWWRVL5yEWqOp83f35+Q==
    fuldUSAvS+M8/iKrCDQBB9DqZadugvicRSgYGr305qyuwUen2CcwInnR81tG6d/50R/FWszlP/5p589ld87m1blOXi4spgPYq6/jdXyK6whykN81cO7sx0lUuDkpOXtBCcofHQ==
    O/ZEYCYx2Tkmrud8eprk/WBeweTx+Der7opGpqpp0siOtSccR9lPWrY9ce1w/uRfPttPF2f968dg9GCHzvf4VU7Q/yrdkcjXx+NAUu33T7eTOZ7s+/KTXxMnLxh/z0v4RwzNPg==
    xGjekd3x/JFzyInsVRyAeVNmE4ntB38iH8m8w2s7yHugBg1qCd0wqSAE8YFucQ0PhkwXQ6JjquetXijFjmzD9WKRyZJmgSMZ4Td7NpPH0uKkxscLweVfY5fi1ZUYv3i2PArPPQ==
    +0n6ZTM/iML+qvb1/xor86d0Ih8ue31Z4oUUyR+Smr4kD//ndBI35r/gfyfXFkQ8P70kaXkhYb3ID5yryJleDS57/xpCnVI80M9NPETnxLTYubAG1jmEg4GmEY2zIf/3XEfOzw==
    KBNMrnP5j+WNr4P0Dnlk+l4k3cYWQY0JwsB8C9RDnXOT7gEEseJ9/84KgrwN4cyZSJsvdTI3gZUtSKTwYUkvSdOT8leULoWc1yKHYL8s8X4OyROg08R4rG2SFikrMz/BUMowpg==
    rlEYSX9RCmfqSsfvoy4dinkVguYkZzy+DAN/GusYtsJvEEIqwcg03ojeqCYGA6wbQwoxEZRqFh0wJCGNdNMigBwDvRVlfKjM1gxf0GAWG2yCr8/+V+niJvFuf5Pe/kp5G4Il+g==
    UFRTiei2IrKtXab3l+kbvtRuiCm2PTd+e7x0DgnnXDpRlChiKvhdmYwVL3WWlwpa2oCW9oNWM84jey+Zq9gOYinBWEZKpFmcxAeahWVoBQamQYQx1Ew+RJrswRaxEByAY8Drgg==
    lBVmO4vZBU2tjdsDCRlQW6YZIkgZbAj1UzDNRSErnO8c55UVbyGQQCqQ6E4g0RJbIYkDDUnfRJHVUhyhuKq7PklBSwcSR7QEWAqwBBzQWCPACh0gDQkOgQDEhEw3jIE1pJQQ3Q==
    okzDxwDYBTEr0HYWtAuaOtZAAreCdCigJqMIgFSKryKOwArmBxtHYBVHdCeOaIesJMIEJJhg3swvOQW2KshYkVVnfZKClg4kkGgJsUQDRDCMmgHWxKYYEkSgZpjEHEJNF9AUnA==
    Di0DImaKYwDsgpgVaDsL2gVNHWsgQdpBOmIcCAbyCcfKNBdlrGB+sIEEUYFEdwKJdsgKQsi49CuYGpBYjiMUV3XXJSlo6UDiiJYAixDEmACkNQIsI4RKdGtgqAPCyEAQDgm1hg==
    EJq6VLN2DIBdELMCbWdBu6CpY40jaCtIR5BgDDAVyjRXxBFUwfxg4wiq4ojuxBEtkRUDlGsYUMVVS2GEoqrueiQFLR1IGNEOXqEmsAAaaghYQwyxoSNuYcyJBakOhTUEkOuEUQ==
    DZlHAdgFMSvQdha0C5pqK4wYMqyb6J3DiG/6zWf/RnadluYJCA1BQChpNhjBDMOgWEdM1wUhQBhDQckAaboMQ6BJzWPAeS7hw0P4ci+9Xj5VBHN2ZQ9gbrBZxKZwzxVWAnrdKw==
    19tBYm+g/uLcf/bTPp2ebGmsURNMEESbmfETgfeSrLuC9PWi1ZNE+pLudgD64+XhhVzCiTQ08+fin3SPwlL9uQ50isveLyXQqtzKJ7u5tv7JASxXPvwzz4KAFZV9Vjsoqh0UOw==
    tIMiZHNpbHUec0IKL63eQdHSGCL5rmVpaIUGEBi4MrRq4lNd2y/xvr03TjANB044am2TPYg5BhhpDReUZ+Rx/XrTdxl1UQIgli7WMXhUVZLuikeV9srm2ZFyR6zom29s9ZbdXA==
    ax92v8leoQbRhyrV7CFKajgeKqHQGigJwgIT1nC9w/GDMhfvySIRYDIw94vEFHS56DuCtC/OyHGfnNuXFveZxZggDQGkbGB6uiTjk4Vct4xfSScdwWI8nhhb5N+c6MEft+qXMg==
    zjmACAEFyXyAfVnUXcFmGhadLDarldM6SGtG8vYQbrZjZzWONS4QRgrTlaFmV9C8G0tbHpevQ3NTt3RRdl2xiPbECZOT104Q+t5ne+q0Yw+RAJRz1Gxk+/ixUyXok8UPJLqB1g==
    w0+V/DqCIevnLJLe7iwaRHn3aXEUOd7dGhOgac1mmh8/lOrlfaqAGkqqNcR6gKqXYkdgteyktgMnQDhAgjKVq6yL1LoCo91Eae36dcvS21cYVbWuatswKnBHTnjljSbf9JviNA==
    j9bSJAgASglHUOVJstOrRN4VIDa3ZzUTmuu/izXE3BJ7/i5WFpGtknxHbGA2lzqdeeWGUZB8Tfez397IHZQ9hnKq4rTyOoNKiSs47hCOqwTfLTT+6gZ+mxDEgGGKacM9A04Ggg==
    r2I+Ady9x+chS7h7lfb+pvQ29+/fW55VE1rf0x9vaR6BgPEFRNQAxxvO+NEw0IocUsHyb+1Cd8tgL/kULSWSEKIIYq7s9mrX+QTAIyw4GA7XA0+duLqFndQvaMfeYBYnXjlTsQ==
    ZoWjewIoKTplG7mnB+SavimFvLzcoYx/KlZIVaSw61dIvTXRaKMVUvFCIv/H1A5+JAqSd0u0SLF8/9U37NGPuB7uuLjqKL1ZKqJ0JVXIs1popRZaHdBCq/5z/cIpzcA6y3GYhg==
    fKYFDFod8hVDL0qEJhhBG4deEAgomDSnR7G9yzfHG/vBlffky4ii5axPw10AlmuwsdezYIJbN7qlbndd6HVV5ia9+R0ySxUS3YNv+woyTDRCGRZcQewVYkmh7wiwwvsVvFqAVw==
    QZ57m3iwqdWDGuSYcrz5SMcxIjInyPc1eEeHxg3N1F5N1DkihFFElI2qsFHvaZ9OHA2ZFHZlUWoyHRWNq890vGV432kvmGRUYFmfKkuhshRbZCkks1UlKTDEWtX5+APXVedrig==
    gUigyvM4T9VXn1+VG7EIJqZW9hKpRoSZLUKcbysWfHSKPYsSnhcd5DRaMp+NRs7nx5+kt92f71kWH7S3DJ8ADQONC7UKf+F0LOb5yUXRd2WYI4FCBUuPClxR5stQCn1Sxzykkg==
    eYqFPekT996bF5YWXWvq0/nsC+uJ41M6IxYub/e2YtVxCsF3iE0Xtd6RMc0yKyTrntvnBaoBBBiDG7v0p0ALy7LvCjGkNlUxw46YYVnxneSG/4hedkENWAOACTVhaAUzLEm+Kw==
    xJA61YoYisTwz9H8QhIetk8XS72hk2zx+z9+20WAAbnAXCpKrfxeRRhLwu8KYZxCiPF+64WW1N5JZhi4gTOKfvdc0w+j9jYbI1IdBAKieGFFiLEo+q7wQppu6ywx7JoDdu4zLA==
    Kb6TzPBNv7kay1LdO1cCsn3vATLKCSJYrexdRRIrtNAZukiy7Z2li3fxI3bOISv6RUfYJO6ScZX0qf/otedanEMqOJPAz6fFruYN0+R4SKAhmIaJfNIAjBBs8qHOdTiER8Ecyw==
    olbc0Do3MIsBS6vihuzmznDDcnfY18y78nrndExV1xCn5soxVZiuZXn48jiRlXF+2qNocYx1ixC2MJVh325qWR5vmZj05rZC1ZIatxtNUBJcRXFN0q5HKsHNqKyZXBW0t+2YTQ==
    wvgjleAuO2Yjn0bJ9RTkWu8T7l+uuUu2GKzVzS2NT5nhwsl+fv/aGaN2skIYMQ4ZhVnqGNLDCsUWJLJFCCZbLmvt2JFs51dnFO+9sE5A1lIvKO6OgJgGgQy9t87XYVYddVc0OQ==
    ltxacWgbczyheHOO575AVZoa2taoLadAcAjUrkoN54V2JZtS6RLX5zXggAj6+p3dmrxGeVHD6rkWG/X6tTIYlS3YAnDlqZ57SI3ujRjKE9XaoQYEMCWQI7A9xx8xNZQl3xVyqA==
    zuQodljNDmVdHhM/lGamtUMPRGOYAITViG3T+aFdIYfqJKUih9XkUFLlMXFDaW5aO3G7jCgEJlB9tKTpTNCuUMOeg4rliRSHyAwlTR4TMwzc4HfPjZKZae0yBIIACIKxmiu+eg==
    Tuiy+LvCFNUDSooq3ogwqlR6TJRRMxWtnZBD45RJX1JFHOvPEe0MbVSO6ynaWE0bNUo9JuJI56i17WcIQAhGW+yqeAqUsST6UyULoWMCwKGTxZI6W6eJbHZB/dVqbnl7OHb/0w==
    Q+vmd1T0m6xyFf1mzTm/u5ysebjtaZ6VPIz2HFl3ax7vHUh79rwYQUnqaCSVmb9Fg0YGEABQNmiCccsYrjRoCINdGLBybdK9NxmhOqqSVnZzrbQ++1+lvqS8dm6nOlPt9cxRZw==
    qt3xPlITXt6uHz3e+JE9CdMf62fyTbcbGXW0k50GHDAAGVNbFqSnU2GXjgoy70q4iBitXHwTbwcq+2Y+vRvVgiINwhYwUIOU8qnNkVI337sKGmtFlvX4ij4sqnB/maQtoZ4uYw==
    bGeUGsebmRNGmu1whiHHhDNiUoCJAZgBTWoRyiEysSV07Uhxngq8KxDf67KQbRmifkHIMkNUccAWeSSiUd0SvTcpINXurhJETVI+BmKcvIuHXBFP1G/g/lY8scUG7jtP9HSyVQ==
    W6d7Otmqo+yAW6d+3rdVm+xXkrkc0jtKGbK10AJCIKMLqql92CtdjpLAD8rpeJ8EGDG44Hqli5FeadPFSP2Gkor2EDesGyHk9WsHr4QKJr09NZW1NkLIBa7w+iZe60OCwkrUdg==
    8VrW0b5c/apkuM6Q0Fcvtt1fMjyT9wbpm864+ofSqq1T6Z1s1WF3wN1k5668dhPx55hyDUDSwjYDR2t+CzLvigFWifj1EvEFFR5YIj6reStg1wBBHAitWWSMh4JBnRiGhU0y5A==
    lqGRoUiCa51BA+IjRXtJ7F3Bu8rK7yIrnyl5Vx57/FPxWdPy7mBvpO+ym3fhqSxUiwFkpQ5Xg2plN++mWqEzkkipr1u8V1FylnNqDpJKPCSo/uLcOYHjjZxXpKRV7p0FkgZlHw==
    uxrPl7bc+X7U7In54GXdO5IPfhbuh+CNVyw9kPPx/dc/M7xDDfBkFm68c7tIY5aRP5ZP52Op97/ZSR/1Z5c9ypK7EwzFT+NEWGkEnl+NPxWbH6StyQ/TuuaH949RcjhvimSR8A==
    lTSkDZnzjxtNnOv79EDaj/jbn/GbXM+5dqORrD1mubJTvSb/3vrjl+Qf+czjNAbP/wNQSwMEFAAGAAgATpduTOX2gsdhBwAAbSAAABAAAAB3b3JkL2hlYWRlcjIueG1s7Vnrbg==
    2zYUfhVB+zFggKuLJdsy6hSO5aQBktZIsnXANhS0RNtCJVEgaTvZsCfbjz3SXmGHFClLvqSpnQ0b0B+2eDsfD89d1F9//Pn6zUOWGitMWULygem8sk0D5xGJk3w+MJd81uqZBg==
    4yiPUUpyPDAfMTPfnL1e9xcxNYA2Z300MBecF33LYtECZ4i9IgXOYW5GaIY4dOnciilaA2aWWq5td6wMJbmp6IskOgIBqPiSYg2CHG8HJEsiShiZ8VcRySwymyUR1jAA4tgNNg==
    1sUuG3sR1oTGJbloFZREmDGAHKF8hZiGy551qAzRT8uiBegF4sk0SRP+KM+nYQhogeZ9BdGqGBIk/ZIh9dAU9Dn7liQhiZYZznkpUYpT4IHkbJEUm2MciwaTCw2yeuoQqyzdqA==
    4LlaPKSDsNTuBvAIy3oa0bGfoREBUVE8h4Xmnvu8ZH2caGrCdfwvA3C3AYr5acq5pGRZbNCS09Cu8k8VlohMX4CllFw/GjuNmbsFKsADs6h/Nc8JRdMUOAKVGSB1Q5i1KWImnw==
    puoxoapxxx9TbKz7K5QOzHtBd0kTsB1LzX+AObAg37YhMsPIYwHARcQ3K86BEYjfskcKDZVDtBYEEUkJRAS05ER02a8DUwKxAkVYtiVOimf8SNIp4ZxkRxLTZL44duMkZ0mM3w==
    nkT9w1HU1o7gp+kIp+kNojVhrhVpqbP4AW2def+8tY0GvWtCPmlGbW8oqWYJZfyWAIgjuilSvc3kiKTLLK/N6wG5JCdvzyGtV70fyp5TY6IyUmGSojmHJ4Aokww6jjpRY9xzPQ==
    vwaiaTmFaSgz4lvY0h55bc+WjImheyrGvE47CMPSUaLyX3EQKS9wAzfY9QJrs7I4vMdEDLmBM77w9dBtiGdomXIxE9ht3xvLzQuF1XTNhKdYb6dWsJirR9lHaYKYJvjmHVr1DQ==
    a7Kk0QIx/PEtRmAtlk6SEu/j9TTVjozmTco7WXTR+GOF8F6Ym+W0XVebcKxJWm0v6LY7HU/NFClY64KkQCC6MYkmiFZ+po492Sz62HJ6Pgir7XmVhW9jII7Ok1wUhoBTUDxLHg==
    blBRQB9iZxlGc2YPvhXJcZMU48ccQY+1crSCCqMglDPrqbNZ3wr1PEA5tBiYFiD2QRwfwNVuJfGPWSqO8pPzi5zbEq8e3pEyTEgv5oTiK46zq3Bg/nbhDH2/HQ5bo/aF2/JG4w==
    Tqs3DsctxwnDIACJdi66v2v94AeuBFPpGxrjPJ7QcgX0RiTnsKvUACVkNqa0slZWgEvDwakO3ZU/TKT1n4eu4/fMugGrIbn92c6RpN1LhujhDYE/c8N2xZ9VGW/DKy+Gdm+sUg==
    lciMOuqBthmmK2yeGVu7HuMC70ip97L7Mvbv2K7TDnzHsb96QEnSEPJ/2fx3LL3J+kuYudDlqQE7RBy/kK32ul6v3et0u19ttRGthYj/fUut2+HY98Ng3CgZwqHdbXv7SgY1cw==
    sGS4W075nqrhGa7RjPhCLF/qBcUTIb9oJp7mmW93z/wZMXyucjoghmN8cYLmL1gz9VzH7XpO0PvqhuWwku5/PVnU/I6faab/gWqovs+Bami7HGrQ24Hne0NJP0vj0QKJWdW6lw==
    TE3xXFzwWJ8HgLdVTu+FXPczMhlejg3j5++MIUXTJJLNm/Ht5fji/e3N8F7yWWEczS/DBaI6D+7FCM7bw44tMWip+JxMhC40hXqjO3NOkxzeaHKXvGPbw97TirO2NQfod0lWyA==
    sCUFNTCNd9/fCLneGTviNF/q4FZt51rg1u+/h96C/ZPegtWL9p5YXnsF3xvLt0r2KVNPPS9uPgRuQSC8OY6/uQhQa5UYpnWpbHICPbSk3KSm7+3ssZ/oOTllJK7e88eJ/pzwEg==
    mcW17V7PtT1fpxa2IOISeZJGb2MVAv9XqaEppJMThPp28yU5ouFs7bA7DLvmtuIP+Jy63odmAa6dJjk24oTxe3n1JVrnVeu6aol9TEkCARN4MKIHsOigA+8psCJ6hI7td91uaQ==
    4WLZbIYjPi4XpxKHy38q/6cDM/DdarUoLqiRlBduoFFwZCVcw9FronerS4qKRRJdUFghDoP689rINYk+sZM/wuUEwmo+x0NIkRHf3AA+zcCp29agoL5FxpLufg54/kfAs9fQEg==
    ZvUinxRLtHwFGhFnFh0QhdKXvV9felFJggQHpXr2iLcaopSsF+BorJJ6E8ba4WOaJsVFkqZiC9E2aB9nUwx80avYkVIFe71mXLVKuf7m9oaQotzz1si3Ry3P7o5bw8Drtrr2uA==
    69lezxk5o98FteP1l0wYFkrDInmBb6vlnXV5OMmRfkoerfIUgllGo1sQkFgIHU4xjxaiOYPT6gmrNmM1xSF6DNKIMV3fkBirG3wB8DCjmXgCj8aD5OVRc1SK6EnPtjYABWX8Eg==
    k8wQDRA4MCU3QCs4i1qr14jxnAjWyn3SvDlilUOWZls14Sfnap5R75duWcYwGeGq0FZVE4evP1RZIR5UX87vVAsqsu4pDWox93OlgU7o1b6LmJ79DVBLAwQUAAYACABOl25MQw==
    qAYHFQMAADQOAAAQAAAAd29yZC9mb290ZXIxLnhtbO1XyW7bMBD9FUP3RJTiHXGCxs4GtEUQB+mZlimbCEUSJG0n+bUe+kn9hQ4lavFax0bRSy6mhpx5M4+zEP7989f55WvCag==
    c6I0FbznBafIqxEeiTHlk543M/FJ26tpg/kYM8FJz3sj2ru8OF90Y6NqYMt1dyGjnjc1RnZ9X0dTkmB9mtBICS1icxqJxBdxTCPiL4Qa+yEKUPollYiI1uCoj/kca8/BJetoQg==
    Eg6HsVAJNiCqiZ9g9TKTJ4AusaEjyqh5A2zUzGEEhK9410GcFAFZk24WkFtyC7WP38xkIKJZQrhJPfqKMIhBcD2lsqRxKBocTnOQ+S4S84R5RQqC+nE5GCi8gKUE3Cf8cWaUsA==
    LPLdiAHaIyMWorDYJ4Rln3kkCaa8dHzQ1VQuN2h8DCBcBZCT45Jzq8RMlmj0OLR7/lJg2Zb+AJZLcpWaPi6Y4RRL6MAk6t5PuFB4xCAiSFkNbr1my9qzw8aMmFselPsYmjdGag==
    i+4cs573ZO1uFYXa8d35DziDCmogBCMNdt4kAMvIlBp9wthQ4giiyHSDoNQcv+JS8wpChhGZSkLmTjkMRGsQCSZgduCZEVbU7z0vdakBm6TfKQ4jsTnQdCSMEcmBxopOpoc6pg==
    XNMxuTvK+vkga3/t4rOEfcOqcpkLZ7qas5yzLYBma13DX8UD6asQL3moqP4lxY2p0uZR2NqwIsNOKg/7gs0SXjnPN1IVLu6u4O0spOdMCipBFAVty9d+TmAFEFeSKLRPWqGdKw==
    weMLLOF6Hx/gKhHqtMNOI3WSbtqtYBD0r8N86ylV69fP6ijIWkplniPMzVDC8+mqXd2RasGEYeuDHeOX2CbKfnPJ9WS902qv96Rf0fwX7f7ZxJ9N/H+auNPoNHb2cKU1t7br5g==
    Vtpc75VWktt9PKSDAzXPWv1icAxIjGfMrDiXDmupCb8LNwrydGVK+j1XCJruRL/39cqm7/R9B25XF7ebIPltrZFYnmt/IeGUjyDR3kSifQyJbGIv00iZoWvUCm6WmK1oVZg55Q==
    rcxuhDBEbaUVbqIV7qYFf/ku/gBQSwMEFAAGAAgATpduTP8fDWWzBQAAfCEAABAAAAB3b3JkL2hlYWRlcjEueG1s7Vnrbts2FH4VQ/tRYICriyU5MuoUjmUnAZrUSLJ2wDYUtA==
    RNtaJVIgaSdpsSfbjz3SXmGHkihLvmSOnfUy5I9F8uh858JzDg/lv//869XruyRuLDDjESVdzXxpaA1MAhpGZNrV5mLSPNIaXCASopgS3NXuMddeH7+67cxC1gBewju3adDVZg==
    QqQdXefBDCeIv0yigFFOJ+JlQBOdTiZRgPVbykLdMkwjG6WMBphzENRHZIG4VsAl62g0xQSIE8oSJGDKpnqC2Md52gT0FIloHMWRuAdsw1UwFNRnpFNANEuFJEsnV6h4KA62iw==
    3JzFp8E8wURkEnWGY9CBEj6L0qUZ+6IBcaZAFg8ZsUhirdwC0z5sD3yGbuGxBNxF/TBnSuJc84cRTWOHHZEQJccuKtRlKk0SFJGl4L1cU3Gu6TwOwFoFSKeHbc4po/N0iRYdhg==
    dk4+llgypR+BVWxy1TR+mDLXM5RCBiZB53xKKEPjGDSCLWuA1xsyrDVZbMQ4Lh4jVgyuxX2MG7edBYq72o3kO2URxI5e0N8DDSLIMQwoabBynwJwGojlGyegCBS+bEZTBUWgzA==
    SYaAxhQqApoLKqf8U1fLgHiKApyNM5wYT8SerGMqBE32ZGbRdLav4IjwKMRnB3G/24tbX3P8OO7jOL5ArOLM24I137PwDq3YvJmur6LB7A2lH5Wiht3LuCYR4+KKAogppzEqZg==
    S2KfxvOEVOhqIXuF0LMTOA/L2bt8ZlaUKINUhqQcTuEJIEVIem2vsKi2bltWuwKieAUDMpzP4RWINPp2yzYyxeTSDZNr7bY16LXzRAny30KDoMgCy7O89SzQl2+mSsYoQxyabQ==
    17C0quD60mjDWz6eoHksJMUzWo49yDRKCwH1fI1EjNWu5i+wISWCwwuIB1F0A6UENE0iqAlnPYg4KWUmBxspARfry3mS5Q/+SYm2LGV7JlgvNeShKB6FQl9VL5AXR4gr6g+XaA==
    0WnoozkLZojjD2cYQQrpqnPI/PnhzThW1Q1N65zXWQvHwg8lwluZg7rZKuRCXoeKpWm6dqsNcdY6KmhpDEk8ozGwyGlIgxFiZfnx7COnbVk937Uc2zvqH530LdNzB0PTNnqu4w==
    KsNWUZBAJxGRrSYgpQxPorsLlKYwh0MlP18IN7ovZNew7BbCe4JgxpsELaD1SikTXH/IPv2F3Io76BNnXU0HxA645D3UoKuM+ecklsb8Yv6W0VZcrJbXPA2ErLwJyvC5wMm53w==
    1T4PzZ7jtPxes98aWk27P3CbRwN/0DRN3/c822u7w/Yfao/wnSgcU8YcDAYkHLEiOEKoPESA1GwPGKWTAWNlGvMUah0YztSZxnZN4m8hvMXxmkuzgpS/s91g8I+2dFvpH71M4A==
    78sLso9SZySkAMdsgbXjxoorvsfadEnzZMynT1SYDM+xXa9ttJ4LU7Fcd/NzVTq0KtX9+RQlSQbYLkm8XW/+qc8PykVVan0k8JNkoikTyzMd5zkPVxoE6eIvn4VP275XEnJj+w==
    fj0fiwc6+L0CedmI71tSnjCnls2J3M7HFoH0ge4krW5K/TJ34J3qkl5DG5F9cavuyni/2842xz2u7ozQ9AmvJY4DdcR0Te+56Kjlwr//t2P/36NPHCvbv4Fbww7qbunzVxv9/w==
    WI1JHPZnSAopRjeZi8Z4Kr+X619Mj4hwwW5kzG12y6h3Omg0fv2x0WNoHAXZ8GJwdToYvr266N1kXisxvrb3OE4RU43VmipZnXdtp/fYA4rQkQzl1bC3vomIwct8+hJabIsT/Q==
    OX82+uXypwuZQtfPOfT1cmiL9J0Sqmwi1ff8/Hf1q77RNnf7qr+l2awvVZvNgrK12ax91Pk9UMvZPzQ79J81++SDqX89NtxmTN/sD+rb4buG4fo1W+pLVVsKym62QOcnIaQdcA==
    y7XNDcZUPyCYqk2tXifMzTeb0uhZyI7/AVBLAwQUAAYACABOl25MfAk7IXYEAAD2GwAAEAAAAHdvcmQvZm9vdGVyMi54bWztWNtu4zYQ/RVDfdgnR6IsX7HehePLJkB2aySLTQ==
    gaIIaImyhVCkQNK3Fv2yPvST+gsd6kLLiTfI2m5rbP0SihzO4XBmDmecv/748+37VUwrCyJkxFnXQheOVSHM50HEpl1rrsJqy6pIhVmAKWeka62JtN6/e7vshEpUQJfJzjLxuw==
    1kyppGPb0p+RGMuLOPIFlzxUFz6PbR6GkU/sJReB7TrISb8SwX0iJRzUx2yBpZXDxc/ReEIYCEMuYqxgKqZ2jMXjPKkCeoJVNIlopNaA7TQKGA7mC9bJIarGIK3SyQzKh0JDvA==
    5txMZcD9eUyYSk+0BaFgA2dyFiWba+yLBsJZAbJ46RKLmFomBMg7LAYDgZcwbABfY36QKcU0s/xlROS8IiIawmi8xoTtMwtLYhyxzcF7uabkXFT/NgD3KUAyPSw4HwSfJxu06A==
    MLRr9miwNKW/ASsPcvlq8jBj7mY4AQbGfud6yrjAEwoWQcgq4PWKTmtLPzZqQvNhLPKPO7WmpLLsLDDtWp+13gcRQe7YufweZJBB8J7BdJ0AKp4rvpFfghnw7KUznhRADB45rQ==
    4XPKRaGy7MhfcySZYJ+k3ykOJaHaU3XCleLxnsoims72PThiMgrI1UHaX/bStp85fkJv8JrPlYlRGK1IKYg3nD8WRzleL4UMIyHVLYfYIj2lOJ9thH1O5zEryYuFdAvjV5dQzw==
    zOxLNkMlE02S6ZTSn1MYASRLKQ+hVm7i1jpq13eum/32FibUTwgkePMWTHG8YcNzUoP10meh13r9htNzUwLIQOVDZhumEZaFZ374hBedij2eC3+GJXm4Ihg8bPd1bWTrKx6TMQ==
    npKHmwktPIun27p3aYUXwYPB+FEHyUY11y0CHxQq9WarXXfbXi2XJBRiPOMUFPQ04P4YC5OdAxLiOVXjzaaHKmrV4bI1zzN58RQDK3wZMd2FAE4iCOTFR5wkMIf3Jnt6mHS6bw==
    dEHZFJJgzTDMZJXhBVTlhAsl7ZfuZr/RHl9BCzHrWjYgdsAd95Cgt6nyTzHVV/kZ/ZLKnji4WN7hZxCl2a+4INeKxNeDrvXbCPXq9dqgV+3XRm7V6w8b1dZwMKwiNBi021672Q==
    GDV/LyJEVip3jYk5fAxZMBbZDpj1OVPQNqT7/exvnrn+fTn1CnIFK2zyMN+ZfD0Hx8+XbvNgliQpSI619SRrH0G4ivQBktOIkZsFLTYYwhXqgvNwKIQxVyaEwjMPAShevfRu7w==
    dvg7vVIK9gIUOM8cmTuhcLDxpF2m2r6MG8/gVfzEj0Y4t+HWXISaZ76V+Vby8qnQLasA3yfdSu4+LbYNodmnR+MaqtdbqAZ0c89sK7PNePlUuPY9lzbj7KMzTUvFf9F9HoWc1Q==
    WqPVRi46d547O8//GTX37BdPq3rlZfU49ABqOB5qtVrnVnFXq3gq/PiX2sT9GrzTosfwI1TC45CjrX9CtWvIOXNjq7HTHj4VZpxm5Uhd9E+1Yrb57/bW3Uao2XDcXRfJJV/tTg==
    R5wrIrY6UGNOCCf+DVBLAwQUAAYACABOl25MXnFbbssBAABSBgAAEQAAAHdvcmQvZW5kbm90ZXMueG1sxZTLTuswEIZfJfK+tQMFnRM1ZUERYofgCYzjNBaxx7Kdhj7bWZxH4g==
    FZjcy0VVoQs28W3mm3888bz++7+8etFltJXOKzApieeMRNIIyJTZpKQK+ewPiXzgJuMlGJmSnfTkarWsE2kyA0H6CAHGJ7UVKSlCsAmlXhRScz/XSjjwkIe5AE0hz5WQtAaX0Q==
    MxazdmYdCOk9RrvmZss96XH6Mw2sNHiYg9M84NJtqObuubIzpFse1JMqVdghm10OGMAcnEl6xGwU1LgknaB+GDzcMXE7lzWISksT2ojUyRI1gPGFslMaP6XhYTFAtoeS2OqSjA==
    JYgXp9Vg7XiNwwQ8Rn7WOemyU36YGLMjKtIgRo9jJLyPOSjRXJkp8I+uZu9y44vvAc4+AuzmtOLcOqjsRFOn0e7M88hq3vU3WH2R91Pzp4l5LLjFF6hFcrcx4PhTiYqwZBHeeg==
    1PzWZK/jRHUSdhYNvLTc8QCO4JbKUjKLWzuLS+xn2UNKGPvLzi8WN6Tfum+2bhbs+vJ82HpYy5xXZdgzbiH3rhm85QIFoi3Pg8TmgP2RrpZ0NOisBiX9mess2m+v+qsEBJigTA==
    1baNx4/JsF/K5UtRh/Ka5n71BlBLAwQUAAYACAAAACEAqiYOvrwAAAAhAQAAGwAAAHdvcmQvX3JlbHMvaGVhZGVyMi54bWwucmVsc4zPsYrDMAwG4P2g72C0N046lOOIk6UcZA==
    Le0DCFtxTGPZ2L7j8vY1dGmhw42S+L8f9eOfX8UvpewCK+iaFgSxDsaxVXC9fO8/QeSCbHANTAo2yjAOu4/+TCuWGsqLi1lUhbOCpZT4JWXWC3nMTYjE9TKH5LHUMVkZUd/Qkg==
    PLTtUaZnA4YXU0xGQZpMB+KyRfqPHebZaToF/eOJy5sK6XztriAmS0WBJ+PwseyayBbk0MuXx4Y7AAAA//8DAFBLAwQUAAYACABOl25MPcd58cwBAABYBgAAEgAAAHdvcmQvZg==
    b290bm90ZXMueG1sxZRNTuswEMevEnnf2oGC3ouasqAIsUNwAuM4jUXssWynoWd7i3ckrsDks+FDVaELNnE8nvnNfzzJvP77v7x60WW0lc4rMCmJ54xE0gjIlNmkpAr57A+JfA==
    4CbjJRiZkp305Gq1rJMcIBgI0kdIMD6prUhJEYJNKPWikJr7uVbCgYc8zAVoCnmuhKQ1uIyesZi1b9aBkN5jumtuttyTHqc/08BKg4c5OM0Dbt2Gau6eKztDuuVBPalShR2y2Q==
    5YABLMKZpEfMRkFNSNIJ6pchwh2TtwtZg6i0NKHNSJ0sUQMYXyi7L+OnNDwsBsj2UBFbXZKxBfHitB6sHa9x2QOPkZ91QbrslB8mxuyIjjSIMeIYCe9zDko0V2af+EdXM7nc+A==
    4nuAs48AuzmtObcOKrunqdNod+Z5ZDU/9jdYfZOnpfnTxDwW3OIfqEVytzHg+FOJirBlEd561HzWZDpyojoJO4seXlrueABH0KSylMzi1tHiFida9pASxv6y84vFDelN943pZg==
    wa4vzwfTw1rmvCrDxLmF3Ltm8ZYLVIi+PA8SpwNOSLpa0tGh8xqU9Geu82ifg+wvSxBggjJVOzkeP5bDfqmaL0UdrGyy8as3UEsDBBQABgAIAAAAIQCqUiXfIwYAAIsaAAAVAA==
    AAB3b3JkL3RoZW1lL3RoZW1lMS54bWzsWU2LGzcYvhf6H8TcHX/N+GOJN9hjO2mzm4TsJiVHeUaeUawZGUneXRMCJTkWCqVp6aGB3noobQMJ9JL+mm1T2hTyF6rReGzJllnabA==
    YClZw1ofz/vq0ftKjzSey1dOEgKOEOOYph2neqniAJQGNMRp1HHuHA5LLQdwAdMQEpqijjNH3Lmy++EHl+GOiFGCgLRP+Q7sOLEQ051ymQeyGfJLdIpS2TemLIFCVllUDhk8lg==
    fhNSrlUqjXICceqAFCbS7c3xGAcIHGYund3C+YDIf6ngWUNA2EHmGhkWChtOqtkXn3OfMHAESceR44T0+BCdCAcQyIXs6DgV9eeUdy+Xl0ZEbLHV7Ibqb2G3MAgnNWXHotHS0A==
    dT230V36VwAiNnGD5qAxaCz9KQAMAjnTnIuO9XrtXt9bYDVQXrT47jf79aqB1/zXN/BdL/sYeAXKi+4Gfjj0VzHUQHnRs8SkWfNdA69AebGxgW9Wun23aeAVKCY4nWygK16j7g==
    F7NdQsaUXLPC2547bNYW8BWqrK2u3D4V29ZaAu9TNpQAlVwocArEfIrGMJA4HxI8Yhjs4SiWC28KU8plc6VWGVbq8n/2cVVJRQTuIKhZ500B32jK+AAeMDwVHedj6dXRIG9e/g==
    +Oblc3D66MXpo19OHz8+ffSzxeoaTCPd6vX3X/z99FPw1/PvXj/5yo7nOv73nz777dcv7UChA199/eyPF89effP5nz88scC7DI50+CFOEAc30DG4TRM5McsAaMT+ncVhDLFu0Q==
    TSMOU5jZWNADERvoG3NIoAXXQ2YE7zIpEzbg1dl9g/BBzGYCW4DX48QA7lNKepRZ53Q9G0uPwiyN7IOzmY67DeGRbWx/Lb+D2VSud2xz6cfIoHmLyJTDCKVIgKyPThCymN3D2A==
    iOs+DhjldCzAPQx6EFtDcohHxmpaGV3DiczL3EZQ5tuIzf5d0KPE5r6Pjkyk3BWQ2FwiYoTxKpwJmFgZw4ToyD0oYhvJgzkLjIBzITMdIULBIESc22xusrlB97qUF3va98k8MQ==
    kUzgiQ25BynVkX068WOYTK2ccRrr2I/4RC5RCG5RYSVBzR2S1WUeYLo13XcxMtJ99t6+I5XVvkCynhmzbQlEzf04J2OIlPPymp4nOD1T3Ndk3Xu3si6F9NW3T+26eyEFvcuwdQ==
    R63L+Dbcunj7lIX44mt3H87SW0huFwv0vXS/l+7/vXRv28/nL9grjVaX+OKqrtwkW+/tY0zIgZgTtMeVunM5vXAoG1VFGS0fE6axLC6GM3ARg6oMGBWfYBEfxHAqh6mqESK+cA==
    HXEwpVyeD6rZ6jvrILNkn4Z5a7VaPJlKAyhW7fJ8KdrlaSTy1kZz9Qi2dK9qkXpULghktv+GhDaYSaJuIdEsGs8goWZ2LizaFhatzP1WFuprkRW5/wDMftTw3JyRXG+QoDDLUw==
    bl9k99wzvS2Y5rRrlum1M67nk2mDhLbcTBLaMoxhiNabzznX7VVKDXpZKDZpNFvvIteZiKxpA0nNGjiWe67uSTcBnHacsbwZymIylf54ppuQRGnHCcQi0P9FWaaMiz7kcQ5TXQ==
    +fwTLBADBCdyretpIOmKW7XWzOZ4Qcm1KxcvcupLTzIaj1EgtrSsqrIvd2LtfUtwVqEzSfogDo/BiMzYbSgD5TWrWQBDzMUymiFm2uJeRXFNrhZb0fjFbLVFIZnGcHGi6GKeww==
    VXlJR5uHYro+K7O+mMwoypL01qfu2UZZhyaaWw6Q7NS068e7O+Q1VivdN1jl0r2ude1C67adEm9/IGjUVoMZ1DLGFmqrVpPaOV4ItOGWS3PbGXHep8H6qs0OiOJeqWobrybo6A==
    vlz5fXldnRHBFVV0Ip8R/OJH5VwJVGuhLicCzBjuOA8qXtf1a55fqrS8Qcmtu5VSy+vWS13Pq1cHXrXS79UeyqCIOKl6+dhD+TxD5os3L6p94+1LUlyzLwU0KVN1Dy4rY/X2pQ==
    Wtv+9gVgGZkHjdqwXW/3GqV2vTssuf1eq9T2G71Sv+E3+8O+77Xaw4cOOFJgt1v33cagVWpUfb/kNioZ/Va71HRrta7b7LYGbvfhItZy5sV3EV7Fa/cfAAAA//8DAFBLAwQKAA==
    AAAAAAAAIQBUAQa58gMAAPIDAAAVAAAAd29yZC9tZWRpYS9pbWFnZTEucG5niVBORw0KGgoAAAANSUhEUgAAAMgAAADICAIAAAAiOjnJAAAAAXNSR0IArs4c6QAAAAlwSFlzAA==
    AA7EAAAOxAGVKw4bAAADl0lEQVR4Xu3SsRWCQABEQbgGCOm/O8mwAD0NKIEfMVvABv/NOuc83t/FFLivwL6N9XV+7jv0pMBVYCihQFEArKKqzwUsCJICYCVZnYLFQFIArCSrUw==
    sBhICoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwA==
    SrI6BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxQ==
    QFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWkg==
    1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkg==
    AmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTg==
    wWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUAA==
    K8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFg==
    A0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSQ==
    VqdgMZAUACvJ6hQsBpICYCVZnYLFQFJg7BtbSdknn/5R/QCGbwqx1+bvrQAAAABJRU5ErkJgglBLAwQUAAYACAAAACEAA9mVjWQGAACoKQAAGgAAAHdvcmQvZ2xvc3NhcnkvZA==
    b2N1bWVudC54bWzcmklv48YSx+8B8h0IndNW74sRT9BrMjcjy+GdHmiJtoShSIKk7AhBvnuKWmxrnmYgjfFghD6YbHb1v5f6sbuK9o8//bkqs8ei7ZZ1dTMhV3iSFdWsni+rhw==
    m8kfvyekJ1nX59U8L+uquJlsim7y04fvv/vx6fqhrLsubzehnq1XRdVnIFV110/N7Gay6PvmejrtZotilXdXq+Wsrbv6vr+a1atpfX+/nBXTp7qdTykmeHvXtPWs6Dro1+fVYw==
    3k32cqv/VaubooLK+7pd5T0U24fpKm8/rRsE6k3eL++W5bLfgDaWB5n6ZrJuq+u9BHoe0NDkejeg/eXQoj2n312Twwpse5y2RQljqKtusWxepvGtalC5OIg8fm0Sj6vyYPfUEA==
    /jYfhDZ/gsuL4DnDn+8arcrdyL+uSPAZHhkknlucM4TjPg8jWeXL6qXjb1qaV4tLxGUC9HOB5uFtzvm5rdfNi9rybWofq0/PWsMbfoHW3smvp9a9bTC/LfIG3sDV7PrjQ1W3+Q==
    XQkjApdlsOrZgPXkA+w883p2m7d99+r+1e1tOxSqfFVkT9ePeXkzCcV9vi772zKfFYu6nBftfxHRgmPCOMeT6WA/y/vioW43n7f9uaiKNi93Rg95WRbt5lDXvAgO9dNjlX7TFA==
    2yEON4cmd3e35eyX+cH+2eauWOSPy7o9Khwazeqqhw1h3+bI9GG9nB/M/pLGYy6FRV5phbj2DhnmA0oJY2xJSt6kv/cqR4u1L7h6vh15A4pwIsx/vZlgHCjm1EwOj/ZrOdREow==
    KA5bjwxD3VbftkNNktQmsqvZ9dD+1m/K51V45Ynfiz8PE9ub9h98uZx9ymD+fd5ki6Itsr6GY6kv4AmYX21Xbtdk+7t5PaPdJF7K50JiiBNRW+eF5pyqYKMyLCRpdeKWCTseTA==
    cAoiRawQIT4hnihBhgMmFGaNnaaeissxiZp4Qk5hormwLhxqbl892orspJsjPs7xxeD3PVv/fviE0SEw65KALUkLYaIIkhISqPWRYz4e+JLhwdIgkVPcIM6JQI4oi0xQIRglDQ==
    J/Z94TvHF6OCTwUTmeIMB++4dsl4lahJxEYeKQkjOiCJtDgZxREclB52vuCRE4QChkwO7lXivXe+c3wxKvi0xdRQrQjWmHtwkHMhJiE4t1FIw8YDn9cWzjDmEYGICnGPI3KBcQ==
    pIWM1CdJuHHvC985vhgVfJ55iCgoJ8Z57hMxFpZTK4iOHKHS6/HAB7kORPECIwFnGMAXKNLEwfZHiYpJByEke1/4zvHFqOCTnAsFrxVOFrI2HjRXhIuYICq32GgzHvi0sQL2kw==
    gKTgEg5bxZCxkaLEIJyHXTE5+87wneOLUcHndGLOUhUZRBuRCEt0TBgCcS6FoX5ECYdLLhgtKYrSQsKRbEBWcYDPKWwogbxDv/Oxe44vRgWf9wrefOI0xBRcK+kwvH8MIl2rLA==
    SWRECYfX1GmPYeeL1CKYK0bGGIKkUcxQCPyU4xfD55SCbPQkfJ7roI7h2z36Inzn+GJU8H3tYzCT40EPO6yU9BFFxTHiMRpkMMEoMpqkYDIKfHmuSzgGkVPo7aE8AQn07/Tuww==
    /bdAErc85NUm28886xd5n23qdfaUD6U6a4umyPsfsmU1K9fDny6zugecnhsM17Yuu6vsP9BqlldZXnY1mHdFO8gtu4NJlrf1upoDkHcwwLZ+6sAKCJ0PSB46yhpYni6r77N8Zw==
    +P8B1XAtFKU2SCq40V47D8eVhKCEYyvFiFBNVJAEeSewCRkK99QgjSVD3BLjtXcxynAxqoYLiv0pVD1kuYoe7ZL7R1uRU7vkOb4Y1S7JkpbEcuci8zyp6AxPmmCKlZXEkRF9lg==
    sdZTCPgZClgKxIOgyKWIEfOweRoulbTiYvigFZH8FHwsMvNZfLh/9EX4zvHFuOAjinEluReYcQhIHPEiQoJGqGdR2xFlxpSDd7gySAjmIDlhFllnNPLUQnQopIrKvzN8Z/hiVA==
    8EnnnGCWSms151i7BMFhoMYyAUmf8OOBjwUK7gweEUkj4jIwpFlUSIC3o2ZUY0Uvhk84nrg4BR/WStN4BN/+0RfhO8cXo4LvRHJCsCZaQvgxom8yQeGgImaIMANpsdARaYo1wg==
    znFvsLeQJF9M3u7nFHl7Jk8wYhnRZhf3fTsjb4fj5b7bFj7/18oP/wAAAP//AwBQSwMEFAAGAAgAAAAhANJ3OzP1AAAAdQEAABwAAAB3b3JkL19yZWxzL3NldHRpbmdzLnhtbA==
    LnJlbHOMkDFPwzAQhXck/oN1EiNx2gGhqk6HFqQOLDTdshz2JXHr2JZtIP333FKJSgxMp7vT+97TW2/myYkvStkGr2BR1SDI62CsHxQc29fHZxC5oDfogicFF8qwae7v1u/ksA==
    sCiPNmbBFJ8VjKXElZRZjzRhrkIkz58+pAkLr2mQEfUZB5LLun6S6TcDmhum2BsFaW8WINpLpP+wQ99bTbugPyfy5Q8LiaUg601LU+Q7MRvTQEVBbx0xXW5X3TFzHd0Jdfj4Pg==
    dTvK5xJid7Assb0l87CsD+go87x6VSaU+Qp7C4bjvsyFkkcHslnLm7KaHwAAAP//AwBQSwMEFAAGAAgAAAAhALMhvZqyBAAAfA8AABoAAAB3b3JkL2dsb3NzYXJ5L3NldHRpbg==
    Z3MueG1stFdtk5s2EP7emf4Hjz/3YiSEBG4uGV6bZO6aTnz5ATLItuYAMUI+9/rru4CJL8kmc20mnxD7aN+eXYnl5eu/m3rxoGyvTXu9JC+85UK1pal0u79efrwrrsLloneyrQ==
    ZG1adb18VP3y9atff3l5WvfKOdjWL8BE26+b8np5cK5br1Z9eVCN7F+YTrUA7oxtpINXu1810t4fu6vSNJ10eqtr7R5X1PP48mzGXC+Ptl2fTVw1urSmNzs3qKzNbqdLdX7MGg==
    9jl+J5XMlMdGtW70uLKqhhhM2x9018/Wmv9rDcDDbOThe0k8NPW870S8Z6R7Mrb6pPGc8AaFzppS9T0UqKnnAHV7ccy+MvTJ9wvwfU5xNAXqxBtXTyMP/psB+oWBvn5OJhN0ow==
    t1baqU/OaTTl+u2+NVZua+hKSGcBES1fQVs+aHVawEOCg3YwVS9Xg7xSO3ms3Z3cbpzp5h2CehNcHqSVpVN208kSWEtN66yp532V+dO4FLrWAqlnjbGHh9WxV0V+Ix/N0T1BNg==
    0/kAC61sIMjPev7WVNDAoGr183kcFMZoINXvODJwnq2u1N1AzsY91qqAZDb6HxW31btj7zRYHDv/ByL4XgCqHTy/h3LePXaqUNIdgbaf5GysTFHr7lZba+zbtoIj+dOc6d1OWQ==
    cKClU7fQTtqa08jzGyUruEZ/0O/qaVvBpVz18+KDMW7e6nl5BI2bTZEO6AXxGBeRwBFBMxwJKCtwazzgzEeRUIQ0R5FceGmMIYQQX0QowrzIOzP/BRKzb/ihHg0J6odSShKGIg==
    QogIzYeGXuCjsdFIMJKgSOEVAo2aFpSGKKO+EJlArfkJywUam5/7UYJaYzH3vfNl8DkSUE8QlLcgCliOshMkrGC4tRRAjiGcURGnKCKoYCGOcMLRCHgI1KEc8FQwgcYmfI/nKA==
    oyKB+qB+QsJyjloLaeAx1FpIeZh8C8kZ2okhC2K8cmHKQvw0hrmgCcpbREjsFSjCoN5oFSImOMetxX4UoBHEMTCH8hZnJJ+/mF8gOUkztHIx3Ad4J8YFERzVSQgUAWU0EYIQlA==
    0ST2BN7X6XCGKYrkHgnQU58RTnB2MuoxiutwQgK0q7KIxSFauSzjfoj7KahPUCT3OPQvinBKOFqfnPs8RBnNQ5IS9Bb79lcmT+G6wq1lLON4bBlP8GoXhCR45Qr4MhE0nyLyUw==
    f4xtNUHwpWzWwxD+l51Xw9izaCaNVDZbq+XidhjTV8OOrb1PdDvjWwVzp3qKbI7bGby6moAepsm6gDlxBsbQmnWl+y5Tu3Fd30q7v9g977CoFGbSd59slTBWKPuHNcduQk9Wdg==
    0zgzbyGMnTV16250M8v743Yza7UwKT+Bjm31/sGOPF3oOa0djCXjWHgjx/Fm3Kvaq4+bieyytpthdFG3suumCWi7J9fLWu8PjgxDi4O3Cv7mxpftnp4xOmJ0wsYXWQ6Zwe7z4g==
    IqOz7Mk+f5b5FxmbZewiC2ZZcJHxWcYH2QFmT1vr9h6GsXk5yHemrs1JVW8u+FeiiYRKlRoqvnlstpc/gd8mrNY9TIcd/DQ4Y2fs9xEjwfg34e6gUe6Buw9ql8heVVOvzr/Nrw==
    /gUAAP//AwBQSwMEFAAGAAgAAAAhAIPQteXmAAAArQIAACUAAAB3b3JkL2dsb3NzYXJ5L19yZWxzL2RvY3VtZW50LnhtbC5yZWxzrJJNS8QwEIbvgv8hzN2mu4qIbLoXEfaq9Q==
    B2TT6Qemk5AZP/rvDcJqF5fFQ4/zDvO8TyCb7efo1TsmHgIZWBUlKCQXmoE6Ay/149UdKBZLjfWB0MCEDNvq8mLzhN5KPuJ+iKwyhdhALxLvtWbX42i5CBEpb9qQRit5TJ2O1g==
    vdoO9bosb3WaM6A6YqpdYyDtmmtQ9RTxP+zQtoPDh+DeRiQ5UaE/cP+MIvlxnLE2dSgGZmGRiaBPi6yXFOE/FofknMJqUQWZPM4Fvudz9TdL1reBpLZ7j78GP9FBQh99suoLAA==
    AP//AwBQSwMEFAAGAAgAAAAhAH8zlnppCwAAEjAAABEAAAB3b3JkL3NldHRpbmdzLnhtbLRa23LjNhJ936r9B5ee1zHuF+14UgABbCaV2aRi52XfaIm2WSOJKoq243x9mrqMZw==
    PIep2aTyZJmHaDS6Tze6Qbz59tf16uyx6Xdtt7mc8W/Y7KzZLLplu7m7nP1yXc7d7Gw31Jtlveo2zeXsudnNvn37z3+8eZrvmmGg13ZnJGKzm68Xl7P7YdjOLy52i/tmXe++6Q==
    ts2GwNuuX9cD/dvfXazr/sPD9nzRrbf10N60q3Z4vhCMmdlRTHc5e+g386OI83W76LtddzuMQ+bd7W27aI5/TiP6r5n3MCR1i4d1sxn2M170zYp06Da7+3a7O0lb/1lpBN6fhA==
    PP7RIh7Xq9N7T5x9xXKfun75ccTXqDcO2PbdotntyEHr1UnBdvMysfpC0Me5v6G5j0vci6LhnO1/faq5/v8EiFcCdquvWckB+qG96ev+wJPjMtaL+bu7TdfXNytiJS3njDSavQ==
    JVr+1nXrs6f5tukX5BviNGOzixHom3X32PxEXO829erd5jAP+f8TNNVDEzbL63bd7J+SFbvbq4Geksjdtlmt9oGxWDU1KfE0v+vrNVH69GQ/ph6GmtReXjfr7Woc2c/b5eWsfw==
    t+SHF5bNbf2wGq7rm6uh25KUx5qMYcVRz/vn7X2z2Wv2P4q5E66EPuCL+7qvF0PTX23rBalTdZuh71an95bdf7uhovjqyf1Hicv+6r7eNukw8e7tm26+Gx8cNdmdPc6bX8lWzQ==
    sh0o3rftcl3/ejkTTPlRwgUS8TS/7bph0w3NT/2n/5Ee43LPj4t99Xi/xovXY5vN8ot/Xsn5/OlJzGcDD0nl5dfVIUHRkE29JpZ8lnTed8tm9OBD3349kccBeyPzky/gRESkvg==
    b5fN9cjOq+F51RTy0VX728it7x92Q0sS9w7+Cxr8kQJEH5r5R4qn6+dtU5p6eCA2/E2T7QlXVu32fdv3Xf9us6S4+9sma29vm54maCmy3hMT27572tv5u6ZeUmz/xXkvPqUR7Q==
    iss908cfPxNjT68ylrRKOR8TC6EvCOOyVBIigkVeICJFNvtQ+xLRNkeIGKGLgohlOTuMKK6P9n2FOBHFBCIzx7o5pQJeqTNeBoh4pRVGgjEaI0kHkyCSmZ2waDbMQN1oP1Aezg==
    w5l0ymDEcAO9wLn1EiNCBgu15sIkvFIumbEWIypY6B9yaGXxSrXi+bT5fY4YwRP0KQ/CnDaaV0iUMkFb82gy9g+PZJ0KIpXNFktLvMoCI8rpKcQLyHiejGPYosWEhKUVazCvxw==
    QshBzwlJDoJ2E1KJCsapkLoK0D9C6chgdhGGOws5Sn4zHjJRGOMTRizzFbSbsDIGyBDheSzQc4Tkgm3gjXB4PUF4zCoRpBOQOyKaiONURCsOJcsXSCWCw9ISZxF7O4ug4TySTA==
    zeBKpbRWQGlEA8GxNCUkg7pJrfOpLHyFWCUnpDmmMEOkk8rjebwiH0EkMI/jRwbJ0wRiJ3YzGXnSU0gxMBplJSqP15M47agYUdFhuyUbJrTOglsYC7JYizOS4jZEyGulKU7hPA==
    ykifYLZUdoxuiHjKFTCHKK8D3utVUAnvGCoKUaBFVVQ2Y92iyhnyWkVTMowFFa2zMFuqyjCcLRVF48eG7RVircNeyEYxvNLCjJ9AhJJQmubG4GjUQpUM7aalCXgP1kp6jhHNsw==
    h7GgtZioQ7SRqYL+0VbyCuZR7SzXkInaK1dBL2ivC96dtScVIOM1ZQoPOaoDLwVyVFfKY4boIjTOFLroXE0gJlbQc4aqSwd1M7SnC6gBIRmvx3AWJOSo4SJEaDdDW3rC80gjGA==
    9KlRxmuMWCE0zHxUPmrMEEJCgt42bqwHMUJ1AF6Pk1UFeWAcRTdkLyEZ9zLGae0gQ2iftQXGqQkiWCytkgxXt6ZS2uGV0o7hsU+TUQGvNBMXsUWp+8hYA+I17goIoQoOIZZRkw==
    AbW2zEaclS2nxANjwXKTBeQ1NYfJQlsTUnCGHRHcGVktbYSMt4aVAL1tjebYC5aSMt6draVSdQoJCdvA6YRjznorcWVHiMW1pQ0sCBglI6KxfwJVG3ilkfZ6bNEsBe6mHFW+eA==
    DDU/FlcOjusk4L7giG4F6kZIxjugE2MDAhFJRQ3WQMmCo9EpqgOwtDGNQlsTkhnkgdNSZjxGm4jztTMiK6yBswp31S5IhWsXF7QKWFolPY4sl6yykIku84Q7MJdNmJCWKYIg4w==
    XaHdDNutKO4hez11JgrmRE/7mYUcpUROrRZEhFZ4D/ZSpght4CVlZcgqamWsxGOUDBwy3istI9Za026GEbInwxpYqhxglHjHBbY1IYljizrhNWSV91zgnEiI1VjaaASstaesiA==
    pUUZDNYgKodPsnzFA96DfUX7GbZOZc3EepJmDuY3n6j7wD7NtNFh3bLQE7YufGJH90VwzMTAWPQTCA8R2iAw5TJkVaBaEJ/VUMlZYe4EJSLuwGjz8fjsKWhtcDcVjMq4MwrWFA==
    CT0XKIfh86rgBRWkGFEMZ+VAAYRzVRj7RqzbmBMhRwPlxIgtWnjGnXgoSuGTxlCMqCCrCMkKSouMpwDtFjlLBrI3clEk9NzYvOMOLApjFbRolILqW4goKh0gR6OSFvcLUVOdhg==
    x5jxwwhGpJ5AqHTADIlOJg+9QEjBO1N0Kkzo5qg7xP5xVK9ju3leBbhnRS8KzvHRG4azZayEFNgLSXCcewmh6gUjUuO+hJKBx+yN2URcv8XCCsdaU32Pd4xKWMryEJGm4JOsSg==
    Wof34EqRenge6ktwZI0I7n8qJSfOhCplBYM2qIzSOLtU1nLMqspzhveFKhiJzw+qaDQ+kamiZQGvNPGIY6FKRuMz/CqrXGBkVVmHCOchIib83SxRW5IgQ5KirWEC4QnrRkhx0A==
    oolKMRyNlFqCgT6d/hqbtNbYokkbWWFpZuz6IWJFwKfhhGQG/ZPsWEJOIAH3MoREXEUnxwz+WpECE24KsXgvIaRwbAPqWPD5ASGOwahPUU10oYTQjgqRik1k2FSpCsd2KpLURg==
    SGZS4Y4/c85xJZS5ChF6jgrI5KB/shDRQr5lRWkEap0V57jiypSr8IkmIYZDJmalWYG2zso6fCKTtSo492atk8frMYLjU7ZstMJ3CbKx1ANBxDOBa3JqmISCeZSQgHfNHIQyWA==
    6yBswPNEJcwEoiO+55Ar7nGFn4mjDsZ2Tkzi7z+ZOhZ8Gp4zlZaYO1nLAqUVpi0+/SpccfwdkEhgcK4iJOIvakWwgs8GqTHyOBqpWSj4+3aRNuPvwZQmnMDzKGvwDkglOccVZA==
    MTJUE2NMwDdHCrWnuKct4zk5Xo/jAZ/3Fic9/opdnHI4goszymCfBuZwjVSCSvjUvQRr8VeeEpnBubdEmfDpfkkm4DOukrmb0LoYhXumMroBr4e6Kfw9qxSbDt8KLg7Q7u2b9Q==
    fLx9O94CPPwar9udrQ8jqnp907f12fvxfu7F+MZN/yG2mxN+09x2ffMpcvVwcwLPzw/Abl2vVqWvFydgb4L1fNnutqm53f9eva/7uxe5xzd6+HTZ3H7/UdZ4T7Xp/9N3D9sD+g==
    1NfbwzW60ytcqePIdjP80K5Pz3cPN1enUZu6f/4Eetgsf3zs93Z6Mc/TfLhv1vvriD/U+2t1+3ebzfkvVwdjL1b91Xhlrnlfb7eHm3c3d/xytmrv7gc+XpYb6L9l3X/Y/3NzJw==
    jpjYY+KA7f+pF+PK6O3jj5dn4vTsk/fk6Zl8eaZOz9TLM316pl+emdMzMz67f942/ardfLicffw5Pr/tVqvuqVl+94J/8ehghP3l2D97W/b49qp+7h6Gz94dsfHl7ecSlvVQnw==
    rh9+NnhP8Ve6jNeHFy3R8ep5ffNy6/dfB8VX7W64arZ1Xw9df8L+vce43t8cHq6JxR/IsT83t7HeNctDIJ0u87/9HQAA//8DAFBLAwQUAAYACAAAACEApUe+MeIAAABVAQAAGA==
    ACgAY3VzdG9tWG1sL2l0ZW1Qcm9wczIueG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJyQwWrDMAyG74O9g9E9ddqmyVzilCZh0OvYoFfXURJDbA==
    B9sZG2PvPoeduuNO4pOQvh+Vpw89kXd0XlnDYbtJgaCRtlNm4PD2+pw8AfFBmE5M1iAHY+FUPT6UnT92IggfrMNLQE1iQ8V6aTl8NaxoszrPkn1en5Ns1+wTVmzbpDnUBWPNOQ==
    P2TsG0hUm3jGcxhDmI+UejmiFn5jZzRx2FunRYjoBmr7XklsrVw0mkB3aZpTuUS9vuoJqjXP7/YL9v4e12iLU/+13NRtUnZwYh4/gVYl/aNa+e4V1Q8AAAD//wMAUEsDBBQABg==
    AAgAAAAhAD+9lVUDAQAAUwEAABgAKABjdXN0b21YbWwvaXRlbVByb3BzMS54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAXJBPa8MwDMXvg32H4A==
    u+v8adMmJCmlSaCnjXWD3YqxlSYQ20F2ysbYd5+znbqT+OkhvScV+w81BjdAOxhdkmgVkgC0MHLQ15K8vbZ0RwLruJZ8NBpKog3ZV48PhbS55I5bZxBODlTgG4Ovp7okX2102A==
    bJL6QI9JG9P1sUnprqkbGkV1nWXrbJu2228SeGvt19iS9M5NOWNW9KC4XZkJtBc7g4o7j3hlpusGAbURswLtWByGKROzt1fvaiTVkudv+gU6e49LtBmHksyoczUINNZ0jspPzQ==
    PVmq+Y0hTAadZeffU1FenmcUPbdweUIJyKIkjhlhVcH+GS1894jqBwAA//8DAFBLAwQUAAYACAAAACEAUDpnScsAAAA2AQAAEwAoAGN1c3RvbVhtbC9pdGVtMi54bWwgoiQAKA==
    oCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACsj0FqwzAQRfeF3EHMPpabRSjGTgikWSYFt111I8tjWyDNGGkSnNtXhLYn6PIzjzf/1/sleHXDmBxTA89FCQrJcg==
    72hs4OP9tH4BlcRQbzwTNkAM+93qqe6qlq/RYlIterSCfSt3n4Gvw9uhdYtMr72TLL0Mg7N4Ie8IiyV5UA/wbEKGMwvq8/f7FlRuQ6nqGphE5krrZCcMJhU8I+XbwDEYyTGOmg==
    H+Ij22tAEr0py63uXOcdj9HM0/1H9i+qXa3/Buf13wAAAP//AwBQSwMEFAAGAAgAAAAhAFyWJyLCAAAAKAEAAB4ACAFjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbHMgog==
    BAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMz8GKwjAQBuD7gu8Q5m5TPYgsTb0sgjeRLngN6bQN22RCZhR9ew==
    g6cVPHicGf7vZ5rdLczqipk9RQOrqgaF0VHv42jgt9svt6BYbOztTBEN3JFh1y6+mhPOVkqIJ59YFSWygUkkfWvNbsJguaKEsVwGysFKGfOok3V/dkS9ruuNzv8NaF9MdegN5A==
    Q78C1d0TfmLTMHiHP+QuAaO8qdDuwkLhHOZjptKoOptHFANeMDxX66qYoNtGv/zXPgAAAP//AwBQSwMEFAAGAAgAAAAhAHQ/OXrCAAAAKAEAAB4ACAFjdXN0b21YbWwvX3JlbA==
    cy9pdGVtMS54bWwucmVscyCiBAEooAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMz7GKwzAMBuD94N7BaG+c3FDKEQ==
    p0spdDtKDroaR0lMY8tYamnfvuamK3ToKIn/+1G7vYVFXTGzp2igqWpQGB0NPk4Gfvv9agOKxcbBLhTRwB0Ztt3nR3vExUoJ8ewTq6JENjCLpG+t2c0YLFeUMJbLSDlYKWOedA==
    su5sJ9Rfdb3W+b8B3ZOpDoOBfBgaUP094Ts2jaN3uCN3CRjlRYV2FxYKp7D8ZCqNqrd5QjHgBcPfqqmKCbpr9dN/3QMAAP//AwBQSwMEFAAGAAgAAAAhANmgqI1SDwAADIUAAA==
    GAAAAHdvcmQvZ2xvc3Nhcnkvc3R5bGVzLnhtbLydS5ObSBLH7xux30Gh0+7B0xQUL8f0bPBcO9b2eKY9O2daQt2sEWgBud376TcpkBp1UkBByeGDW4/8VVKZ/6xKENLP//i+Tw==
    V9/iokzy7HZNflLWqzjb5Nske7hd//ElfGOtV2UVZdsozbP4dv0cl+t//PLXv/z89LasntO4XAEgK9/uN7frx6o6vL25KTeP8T4qf8oPcQYv7vJiH1XwsHi42UfF1+PhzSbfHw==
    oiq5T9Kker5RFcVYt5hiCiXf7ZJN7Oeb4z7OKmZ/U8QpEPOsfEwO5Yn2NIX2lBfbQ5Fv4rKEg96nDW8fJdkZQygC7ZNNkZf5rvoJDqb1iKHAnCjsr336AtDFAOoZsN+8ff+Q5Q==
    RXSfwuyDJyuArX+B6d/mGz/eRce0KuuHxeeifdg+Yv+FeVaVq6e3UblJki8wMkD2CfDeOVmZrOGVOCorp0yi7otB+1z9+mP9xl7LTVl1nnaTbbK+qQct/wcvfovS27Wqnp7xag==
    Jy6eS6Ps4fRcnL35467rTOepe+DerqPizZ1TG960x9b83zniw+tHbOBDtEnYONGuiiG5iKHU0DSpc1nV7dOD34/19EbHKm8HYYDm/zP2Bk065Bxk4F0jBHg13n3IN1/j7V0FLw==
    3K7ZWPDkH+8/F0leQLLfrm02Jjx5F++Td8l2G2edN2aPyTb+8zHO/ijj7cvzv4UsYdsnNvkxg781k7BESMtt8H0TH+r0h1ezqI7Jp9ogrd99TF4GZ+b/PcFIG4k++8c4qmvAig==
    vEYw94UQam1Rdo62n3l8dezsXUIDaT9qIPqjBtJ/1EDGjxrI/FEDWT9qIIa55kBJto2/N0LEwyDqGIejRmEOR2zCHI6WhDkcqQhzOEoQ5nASXZjDyWNhDidNBThVvuFlYSfZNQ==
    TrYPc8fXiHnc8SVhHnd8BZjHHS/487jj9X0ed7ycz+OOV+953PFiLc5ttlqr9yCzrFqssl2eV1lexasq/r6cFmXAYo2RHF696MWFlIOUgGkqW7sQL6ZtIvZ4PEOYSOev51Xdyw==
    rfLdapc8HAvop5c6Hmff4hQ621W03QJPIrCIq2PBmZE5OV3Eu7iIs00sM7HlQetOcJUd9/cScvMQPUhjxdlW8vSdiFKKwjmhoX9+rEWSSEjqfbQp8uWu5ZG0+vAhKZfPVQ1ZuQ==
    xzSNJbE+yUkxxlreGzDM8taAYZZ3BgyzvDHoxEzWFLU0STPV0iRNWEuTNG9Nfsqat5Ymad5amqR5a2nL5+1LUqWsxHd3HWT6uTsvzetT2Yv9uEsesgg2AMuXm/ac6epzVEQPRQ==
    dHhc1Sem+7HdYxYdx823z6svMta0M0nWvp6liAdHnWTH5RN6QZMlrjNPkrzOPEkCO/OWS+wjbJPrDdo7Of3M3fG+6hUtI00S7V2UHpsN7XK1RdXyDHsRQJgUpTQZ9GMlZPCneg==
    O1uHU0ble/FyuWMvrOWyel2VpLrXIiV4meabr3LK8LvnQ1xAW/Z1MSnM0zR/irfyiHdVkTe51pW8ykIySfLB/vAYlQnrlS4Q05f600Xw1cfosPiAPqdRksmJW/BmHyXpSt4O4g==
    3ZePH1Zf8kPdZtYTIwfo5lWV76Ux2zOBf/szvv+7HAcdaIKzZ0lH60g6PcRgXiJhkWlI+VYSCbaZSZZIWUMZ71/x830eFVs5tM9F3HzupIolEe+i/aHZdEjQFtTFJ6g/EnZDjA==
    9++oSOrzQrJE9UUKrHPasDze/yfeLC91n/KVlDNDvx4rdv6RbXWZtTzc8m3CBW75FoFFE5aHOn8lHOwFbvnBXuBkHayXRmWZcC+hzubJOtwTT/bxLm/+Wl6e5sXumMqbwBNQ2g==
    DJ6A0qYwT4/7rJR5xIwn8YAZT/bxSkwZxpNwSo7x/lkkW2nBYDBZkWAwWWFgMFkxYDCpAVj+CZ0ObPnHdDqw5Z/VaWCStgAdmKw8k7r8S7rK04HJyjMGk5VnDCYrzxhMVp5p/g==
    Kt7tYBMsb4npIGXlXAcpb6HJqnh/yIuoeJaEDNL4IZJwgrShfS7yXX1DQp41H+KWgKzPUacSN9sNTlaQ/4zvpblWs2T6JeGMaJSmeS7p3NrLgsMsLz+7NmbG7uRY7MLnNNrEjw==
    ebqNC84x8W2hX75rbst47T5zY9Jpzw/Jw2O1uns8n+3vYgxl1PLUsF+YjQ/YN+fG6X6WPrOP8TY57k+O4pspDG26McvoC2M6bvyyk7iw1Cda4jGNccuXXfKFpTnREo9pTbRkOg==
    vbAc0oMfFV97E8Ecyp9zj8dJPnMoi87GvcMOJdLZsi8FzaEsupDKytls6qsFODrTNMO3nyYevr2IivgUETnxKZN1xUcMCez3+FtSr+wiRZONd/70BKr7bBM9qXL+dsyb8/YXFw==
    nKbf1PUeNk5ZGa96Odr0C1cXVYY/j5PLDR8xue7wEZMLEB8xqRJxzYVKEp8yuTbxEZOLFB8hXK3wiiBWrbC9WLXC9nOqFabMqVYLdgF8xOTtAB8hLFSMEBbqgp0CHyEkVGQ+Sw==
    qJgiLFSMEBYqRggLFW/AxISK7cWEiu3nCBVT5ggVU4SFihHCQsUIYaFihLBQMUJYqDP39lzzWULFFGGhYoSwUDFCWKhsv7hAqNheTKjYfo5QMWWOUDFFWKgYISxUjBAWKkYICw==
    FSOEhYoRQkJF5rOEiinCQsUIYaFihLBQm1sN5wsV24sJFdvPESqmzBEqpggLFSOEhYoRwkLFCGGhYoSwUDFCSKjIfJZQMUVYqBghLFSMEBYqu1i4QKjYXkyo2H6OUDFljlAxRQ==
    WKgYISxUjBAWKkYICxUjhIWKEUJCReazhIopwkLFCGGhYsRQfraXKHkfsyfiZz25n9iffumqder37q3cXZQ2HXXyis+afi+Cm+dfV703Hmqs35gGSe7TJGenqDmX1btc9pEIoQ==
    C5+/esN3+HTpC790qb0Xgl0zRXA61RKdU6FDKd+1RE0eHcr0riXaddKh6tu1RMsgHSq6TJenD6XAcoSMh8pMx5hwzIeqdcccT/FQje4Y4hkeqswdQzzBQ/W4Y6iv6uL82lqfOA==
    T8b586WIMJSOHYLJJwylJY7VqRxjYUwNGp8wNXp8wtQw8glC8eRixAPLRwlHmI+aF2osM9FQzxcqnyAaakyYFWqEmR9qjJodaoyaF2pcGEVDjQmioZ5fnPmEWaFGmPmhxqjZoQ==
    xqh5ocZLmWioMUE01JggGuqFCzIXMz/UGDU71Bg1L9R4cycaakwQDTUmiIYaE2aFGmHmhxqjZocao+aFGnXJwqHGBNFQY4JoqDFhVqgRZn6oMWp2qDFqKNTsLMpFqIUi3DEX2w==
    hHUMxRbkjqFYce4YzuiWOtYzu6UOYWa3hGN1irlYt9QNGp8wNXp8wtQw8glC8eRixAPLRwlHmI+aF2qxbqkv1POFyieIhlqsW+KGWqxbGgy1WLc0GGqxbokfarFuqS/UYt1SXw==
    qOcXZz5hVqjFuqXBUIt1S4OhFuuW+KEW65b6Qi3WLfWFWqxb6gv1wgWZi5kfarFuaTDUYt0SP9Ri3VJfqMW6pb5Qi3VLfaEW65a4oRbrlgZDLdYtDYZarFvih1qsW+oLtVi31A==
    F2qxbqkv1GLdEjfUYt3SYKjFuqXBUHO6pZunix9gqtnsN8ngzdXzIa6/g7tzw8y2+Q7S9iIge+P77fmHkmrj2pNV+5NU7dPM4faCYTMiM8RDbR5hrE377UmcodpvQT3fxsO+Aw==
    9fXAnK9KZY68TMHp3e2UvlwKbd53cdlz0O+qnvIBn1lIBueoiRrPQbtNwzEPwZ/7tPnRLvjjfbYFwFP7g1WNp9vvUYOC1704TT9GzbvzA/+tabyrmleJwm6af/X6ffP9b1z7gg==
    FQou4ObSmeZh+8NhnPluvhG+vYLNTclaDT3TzT5OsXSmJ+bw2ZvOvb7sVt/XbqF7gZuZjWC0X2t9d7P6MvXFDqQokzop2FsURXdpeLo83f7Y3aauGqd3WEr9rw3S6RfjOMd9UQ==
    JjbHElKCVZTXcQltzbdVVQ1NL6CGZ9iqrVDqOSSgNjGM5mf5ulMzatBzYIQQzWQzsNxhyw0JUVUbhvKo6oSOQiz4K/Q1LXBCTUEOjxr0OOz4JFBPM73QYc8JTEsnimE6OjXU0A==
    0p1AtS1dtZQwsDQTOTxqcGWHNcfQqOH4vksotYjm6poaugaxXMuknokdHjW4tsO26Sq+SYkbKtRSCYTacxVb8xS1zk6cw6MG13YYko8aimMolk5Vz3JsxyVE93TH9UI9CLDDYw==
    Bld2GKbLCzSiENPWqE11V/eI4xihYwcQa89BDo8aXNlhm7h6YMHs6BalqumDpKBuhYZjhdTRdOzwqEGPwxaF+fflOKzblu9rjhvqRKOWrsM8+YZKiK86UGcVihweNbiyw6ZvBw==
    mkk1xfdcCjXW9sxQtUPiBDRQiY/r8KjBlR22nFrdlgmbHoV6xHBc1w9CXafUCXTD1vDCMWZwZYc9zYPkUymxXY96IbEdi3iWqYeBS1TDs/DCMWZwZYcNSnUTZkaBNZYa1LeoSQ==
    qB7A8us5im3ZyOFRgys77Fqh5jqqGWiQmAHRHWIFIdQshxq6rXpYdKMG104Jz9RCWLYsSD9qmYarwBRqICTHdEhIsOhGDfoc9qjls0V7ucOB6fgh8d1QdX1YBTRbIQ5VCVRWkw==
    2hoxkMOjBld22AWda6Zvub7hUwUkHwahr2uG6tqK41h4aR416HE41EGkkla60DAcxTIVS/MJDWFr4NX/FFsNbOgoDOzwqMHVHVZ0VQ8J9UOXKq5jmxb1iWsoga8Fpu73ODxicA==
    ZYf1wAi1gNi2qymQkmG9vVVVU3VMA/bnioeX5jGDKztsw37AVFUH9gM6tS3Pcr16jwt1FRLU0LHoRg16HK73ys3NDhL2w24AGwHTNnTY5jqhbkHzABoKA2rBGtazNI8a9DgcwA==
    7qi5gWm5w35Ia9UYAdVt6lgWrGC+6gaeTUNDD1XccYwaXNlhLbQMKKSuG2jQ+pqBCwNbRFEV0zGIS3pmeMygx2Et0GxZK51GTI2aBvV0RaOwarnE02HyTKJ6GuzT8V5i1ODKDg==
    qwG0OJ4CyoFm2NdgGQtc2H6Zvm7BNt3CMzxq0OOwH6pwnJJ2a64LhclRDVilKFVgRw69pa/a0O2AGzoua6MGPQ7DQmOpbEmR0HE4DjQNbui7sODbOnFBPbZrWEZIjND3sehGDQ==
    ehx+OQe33GFCTMPTbBIoqgU9pQq7cBWmyoZdGIGFFtfhUYOJDp/+Kn/5PwAAAP//AwBQSwMEFAAGAAgATZduTG1/B5s6AQAASAIAABEACAFkb2NQcm9wcy9jb3JlLnhtbCCiBA==
    ASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKVSzU7DMAx+lSr3Nk3HxqjSTgLEiUlIIIG4hcTbwtokSrx1ezYOPA==
    Eq9AW7oiEDdutr8f2Z/88fbOF4e6ivbgg7amICxJSQRGWqXNuiA7XMVzsii5tB7uvHXgUUOIWo0JuZIF2SC6nFK381Vi/ZoqSaGCGgwGyhJGychF8HX4U9AjI/MQ9MhqmiZpJg==
    PS9LU0aflrf3cgO1iLUJKIyEQTUqQg+HpF3VtMjK+lpg6B2ckFuxhs5pRmtAoQQK2l0Wu/E0UnIlc9RYQUT7OuxeXkHi0EkPAq3vui0cG+tVGBAFQXrtsM2xm1Qi4LKNcaVBXQ==
    HruJh73uUi4Zp2PNh2C+jEFF7fk5Hh0U5IQ8Tq6uH25ImaVsHqeTmJ09sGk+nefZLJlm6ez8gj1z+svn27gelvi388mo5PTnO5SfUEsDBBQABgAIAAAAIQCtwITRZA8AAJeSAA==
    AA8AAAB3b3JkL3N0eWxlcy54bWzsXUtz3DYSvm/V/gfWnHYPjuYlyXJFSUkjae2KrSiWnJwxJEbDiEPMkhzLyq9fvMgBpwmSDWK1qcqWD9aQ7A9Af92NboCP73/8tkmCrzTLYw==
    lp6PJt+NRwFNQxbF6eP56MvDzZu3oyAvSBqRhKX0fPRC89GPP/z9b98/v8uLl4TmAQdI83eb8Hy0Lortu6OjPFzTDcm/Y1ua8pMrlm1IwX9mj0cbkj3ttm9CttmSIl7GSVy8HA==
    Tcfjk5GGyfqgsNUqDukVC3cbmhZS/iijCUdkab6Ot3mJ9twH7Zll0TZjIc1zPuhNovA2JE4rmMkcAG3iMGM5WxXf8cHoHkkoLj4Zy782yR7gGAcwrQA24bsPjynLyDLh2uc9CQ==
    ONjoB67+iIVXdEV2SZGLn9ldpn/qX/K/G5YWefD8juRhHD/wljnIJuZ47y/SPB7xM5TkxUUek8aTa/FH45kwL4zDl3EUj45Ei/kf/ORXkpyPptPyyEL0oHYsIeljeYymb77cmw==
    PTEOLTnu+Yhkb+4vhOCRHpj63xju9vCXbHhLwli2Q1YF5ZY1ORkL0CQWhjw9Pit/fN4J3ZJdwXQjEkD9X8EeAY1zg+Pmd6+8gJ+lq48sfKLRfcFPnI9kW/zglw93Wcwybunnow==
    M9kmP3hPN/H7OIpoalyYruOI/ram6ZecRvvjv9xIa9UHQrZL+d+z04m0giSPrr+FdCtsn59NieDkVggk4updvG9civ+7BJtoJprk15SIABBMDiFk91EQUyGRG6NtxtwdjF1ehQ==
    amj2Wg3NX6uh49dq6OS1Gjp9rYbevlZDEua/2VCcRvSbckTYDEDtwrF4IxrH4mxoHIsvoXEsroLGsXgCGsdi6Ggcix2jcSxmisApWGizQsPYZxZrb8ftniPccLunBDfc7hnADQ==
    tzvgu+F2x3c33O5w7obbHb3dcLuDNR5XpVrBB+5maTHYy1aMFSkraFDQb8PRSMqxZFXkB09MejTzMkgPMCqy6Yl4MFpI5O9uC5FO6j6fF6KQC9gqWMWPu4wX00M7TtOvNOFlbQ==
    QKKI43kEzGixyywacbHpjK5oRtOQ+jRsf6CiEgzS3WbpwTa35NEbFk0jz+orEb0Ehcqgef28Fk4SezDqDQkzNrxrjHiLDx/jfLiuBEhwuUsS6gnr1o+JSazhtYGEGV4aSJjhlQ==
    gYQZXhgYnPlSkUbzpCmN5klhGs2T3pR9+tKbRvOkN43mSW8abbjeHuIikSHezDom/dfuFgkT69jN/TATmeaO9W3mPn5MCc8Phs9Gekk1uCMZeczIdh2IRevO/qPbuWTRS/DgYw==
    yquQfKX90oIWfNRxuhuu0BqaL9+r8Dx5X4Xnyf8qvOEe+Iln0SJ/e++n3LnfLYtGn0Y4G0l2Kt8d7m2kGG5hewe4ibPcmxs0w3qw4FuR7Qo6fWSC+14O79gea7hbHUYlr93TkA==
    HnqZsPDJTxh+/7KlGa/angYj3bAkYc808od4X2RM2Zrp8lNJSS+Xv95s1ySPZSlVg+ifCZQb5MEnsh08oLuExKkf3q7fbEicBP4yiPcPnz4GD2wrqlChGD+Al6wo2MYbpl4o/A==
    x290+U8/HbzgNXL64mm0F55WjyTYIvYwySgkFnlC4mlmnMZe5lCJ9xN9WTKSRX7Q7jKq7kkpqCfEe7LZqqTDg2/xuPjM44+HbEji/UqyWCwb+XKqBy9gxqpivlv+TsPhoe6WBQ==
    XhaOft4VcnlSprpS2h/c8DShBjc8RZBs8ulB2K+Hwdbghg+2BudrsIuE5Hls3WF1xvM13BLP93iHF38ajyUsW+0SfwosAb1psAT0pkKW7DZp7nPEEs/jgCWe7/F6NBmJ52HFTg==
    4v0riyNvZEgwX0xIMF80SDBfHEgwrwQMv4HHABt+F48BNvxWHgXmKQUwwHzZmdfp39MmkAHmy84kmC87k2C+7EyC+bKz2VVAVyueBPubYgxIXzZnQPqbaNKCbrYsI9mLJ8jrhA==
    PhIPC6QK7S5jK/GwAkvVPd4eIMUadeIx2VZwvkj+jS69dU1g+eyXhxVRkiSMeVpb2084UrJ+a1uXmHzQY3AX7hIS0jVLIppZxmSX5fXyvXpq47D7shu9lj0/xo/rIrhfV6v9Jg==
    zMm4U7Is2Gti3Q026fykfNylSewTjeLdpuwofNbiZNZfWFp0TXjeLbzPJGqSxz0lYZsn3ZL7LLkmedpTErb5tqek2u42Jdv84YpkT42GcNpmP1WNZzG+0zYrqoQbm20zpEqyyQ==
    BE/brKjmKsFFGIrdAshOP5+xy/dzHrs8xovsKBh3sqP09is7RJuDfaZfYzGzY4KmbK+6ewLEfZlE94qcv+yYWrevbTj1f+brA0+c0pwGjTiz/htXtShj12PvcGOH6B137BC9Aw==
    kB2iVySyiqNCkh2ld2yyQ/QOUnYIdLSCMwIuWkF5XLSC8i7RCqK4RKsBWYAdonc6YIdAOyqEQDvqgEzBDoFyVCDu5KgQBe2oEALtqBAC7agwAcM5KpTHOSqUd3FUiOLiqBAF7Q==
    qBAC7agQAu2oEALtqBAC7aiOub1V3MlRIQraUSEE2lEhBNpRZb44wFGhPM5RobyLo0IUF0eFKGhHhRBoR4UQaEeFEGhHhRBoR4UQKEcF4k6OClHQjgoh0I4KIdCOqp5EdHdUKA==
    j3NUKO/iqBDFxVEhCtpRIQTaUSEE2lEhBNpRIQTaUSEEylGBuJOjQhS0o0IItKNCCLSjys3CAY4K5XGOCuVdHBWiuDgqREE7KoRAOyqEQDsqhEA7KoRAOyqEQDkqEHdyVIiCdg==
    VAiBdlQI0WafeovSdpv9BL/qab1jv//Wle7UZ/NJbxNq1h+q7JUdq/+zCJeMPQWNzyXOZL3RDyReJjGTS9SWbXUTV94Sgdr4/HnR/oSPiT7wnUz6WQi5ZwrA530lwZrKvM3kTQ==
    SVDkzdss3ZQEWee8LfqakmAanLcFXemX5U0pfDoCwm1hxhCeWMTborUhDlXcFqMNQajhtshsCEIFt8VjQ/A4EMH5UPq4p55OqvtLAUKbORoIp3aENrOEXJXhGDpGX9LsCH3Zsw==
    I/Sl0Y6A4tMKgyfWDoVm2A7lRjV0MyzV7o5qR8BSDRGcqAYw7lRDKGeqIZQb1TAwYqmGCFiq3YOzHcGJagDjTjWEcqYaQrlRDacyLNUQAUs1RMBSPXBCtsK4Uw2hnKmGUG5Uww==
    5A5LNUTAUg0RsFRDBCeqAYw71RDKmWoI5UY1qJLRVEMELNUQAUs1RHCiGsC4Uw2hnKmGUG1Uy1WUGtUohg1xXBJmCOImZEMQF5wNQYdqyZB2rJYMBMdqCXJVco6rlkzS7Ah92Q==
    syP0pdGOgOLTCoMn1g6FZtgO5UY1rlpqotrdUe0IWKpx1ZKValy11Eo1rlpqpRpXLdmpxlVLTVTjqqUmqt2Dsx3BiWpctdRKNa5aaqUaVy3ZqcZVS01U46qlJqpx1VIT1QMnZA==
    K4w71bhqqZVqXLVkpxpXLTVRjauWmqjGVUtNVOOqJSvVuGqplWpctdRKNa5aslONq5aaqMZVS01U46qlJqpx1ZKValy11Eo1rlpqpdpSLR09177PJLDl98r4xcXLlopXdBsPzA==
    ROodpHoTUF74Iaq+oySERU8C/cUqfVh2WG8Yyr+znFd1+prx+Op4fnV9ra6yfZFqOja/SDWvfli/SCW71jGYqvt6P1R9KMocwP77TrJ3S5LT6GehbzC8VLz8r+G4eEleebxsZg==
    sSaZOruno7xGG5xdWxfz6eW13lK0acvU1V5xSlf0GwkLJc7U64g+fk0qeFOL1cfRlvLq/QfLJtqvzA+WTaS/G98dcyFgaiVARyU/BEx7EFDf9O7gZL44GV90cmLRubQtoPMObQ==
    y2MDtT2zalvvkvvR9sy3ths84InS7S3vkjwmfnzkOs6V2ioiluLNcVwpKnp00VIGxzotzd8JJL+3fCdQnLzWx8T52qcCa5L7TwWKw5fVpwJDEckr6m/mV6fy3RXyYhnleQSUMQ==
    XgZleVjceMSBTm9K26mGpe9jqH1sUB7rtqaQE8mDh3q5nWUm0C+prp6ylK+oPrQzy5usLTaig+/+TpVmk7H3uxAzYkuf5YzZOoWpSdVqxNqKu3rI+7NMlB3xPz6kwqafdbRWPQ==
    jb4RBcXPL2iSfCLqara1X5rQlXBFfnYyVnZRP79Ur+e0ymcyj7MCHNU7o36224n6noe+wciaMYhkpUHd8m63oZruYQt19sU6M+iMyqTkKaXJejw0zcbS3/JdEvUAdj0fL8p7Qg==
    +0zhXelO3a4uWRbRTCZyym5kq+JV93rgf/AQKP/gbdLqY5kqjGjkyqqcZCuLc5Iu7dFJOOahNKLvh4n/6iauXKNSfx9PaZ6fb9R3nw7NUX8OqskUbVOwQmqdgO0zcKfRcl9SZg==
    RpbldWIWUvPDluWiCnyrJ1jjGklwdcnZTN3kLdSl8Zpzp+7kvjY/hbucG6Esag5jj6GVQx2rU8FeYweKbpzeLGrvUrlNvz0HWA1Hv0L7cCj6MG4UsLfll4jt+ZhpGbWKYbkQKQ==
    2JAstcEL9LfVMF6gkP7vBXUvMLRyqGN1aqgXaAJfyQuMtynJlykdjgm8bWmoY1hykU7fqGXzb8finx5vh5u0pC5qO/twyMbmubqgacg9spjyJuSDoS0mZ2eIhYjXy2Iub8Q/cQ==
    wCyRliR8eszYLo1AmXSpyyR80uPclEuO5NyYQ0rl3JZTBjawNWTC5tiat/zulpXvbjv0WOO1bl0TnLVObpmoJ5PJQtf/rctUfieZasnzcLT6ZDDxMdOIVqyhuil+mctIr7bQqQ==
    Hg46VIQ62jR+cw7ts+YmkdoynYmO5cMWmCfT5pXiHstjluWvA83Pemq5rx3u9dKo+6EGaBBoV3mn+b269ppttPoO16GqqhM+LLUEazXWzpDWoMXaymbP1KqvGdU6bVPPUGOqqw==
    2a6V/6kmalsph5ooA/vUU2DXJWjPwG7uxnjdTUHqRm182HQz86QbXVy4T3p/6S2N5ghYfhr0kLvyeBNptjinZdrCnKawe/vAHgcn09nF6ZXCAZN2ufE1fduw8xXLbQhR+XAiyg==
    p1x/D0totUyhdPln2wo7vjy7vJJ3sDTZjVeXNlm0WMVQf64ZV18jsVvBX5ElebC51lCnBk/NEkUfZ+FT4xrh2eJ0rKoECwuca5LEy6ym/dpBqfLakTAXWeaG5sEtfQ4+sw1JGw==
    dD0en44X2rFh0cLNqjygC2V8jOzUvkXzqJhp8NgR90xdW+PeiRn2qnXWtmj2J2eo/Cv/4T8AAAD//wMAUEsDBBQABgAIAAAAIQBnDLaGjgEAALsDAAAUAAAAd29yZC93ZWJTZQ==
    dHRpbmdzLnhtbJST30/CMBDH3038H5a+ywaiMYuDhBiNCf6Iou9dd4PGtte0hQl/vcfGAMUHeOr1e71Pv5drb4ffWkULcF6iyVi3k7AIjMBCmmnGPib3Fzcs8oGbgis0kLEleA==
    Nhycn91WaQX5O4RAJ31EFONTLTI2C8GmcezFDDT3HbRgKFmi0zzQ1k1jzd3X3F4I1JYHmUslwzLuJck122DcMRQsSyngDsVcgwl1fexAERGNn0nrW1p1DK1CV1iHArynfrRqeA==
    mkuzxXT7ByAthUOPZehQMxtHNYrKu0kdabUDXJ0G6G0BWqSPU4OO54pGQE4igrEBzaCQC79ZoyqVRcYu+0m/171O6nSOxfKuTi24ovGyeK3SAMZQhlZNtuqbnM7+kSdoD8URhg==
    gPqPTjZGhVtHYVdj6OEw2vjV+tw6sFzAJhaokObN5wEbhNpzdlpl/svRabVuv/NTSuNd003YrvVY2q/UkudGkgDNnWiD1HIF9+hGDisPrrECavliPp/G9Y4rhdXr80Nz1d6XGw==
    /AAAAP//AwBQSwMEFAAGAAgAAAAhAAD0RO7EAQAA7QQAABIAAAB3b3JkL2ZvbnRUYWJsZS54bWy8kl1r2zAUhu8H+w9C941lJ+mHqVNat4HB2MXofoCiyLaYPoyOEi//fsey4w==
    bYSyhEJtMPZ7pMdHD+f+4ZfRZC89KGcLms4YJdIKt1W2LuiP1/XVLSUQuN1y7aws6EECfVh9/nTf5ZWzAQjut5AbUdAmhDZPEhCNNBxmrpUWi5Xzhgf89HViuP+5a6+EMy0Pag==
    o7QKhyRj7JqOGH8OxVWVEvLZiZ2RNsT9iZcaic5Co1o40rpzaJ3z29Y7IQHwzEYPPMOVnTDp4gRklPAOXBVmeJixo4jC7SmLb0b/ASwvA2QTwIj8S22d5xuN8rETgjC6Gu2TLg==
    t9xgoeRabbyKhZZbBzLF2p7rgrKMrdkSn/29YPP+SZN+oWi4B9lD4sKyHOKKG6UPxxQ6BTAUWhVEc8z33Ku+qaEEqsbCDjasoC8Mr2y9pkOSFnSBwWM5JRk2NVzpmMynhPWJiA==
    nGHFXdwlImdag/9MBgMnJl6VkUC+yY58d4bbN4xk7BpNLNFHb2Z+kREfuZcayV7+NlJicnO7mJ8Yufu/kYFzvpFxNshXVTfhzQnp5+KjJuSxbxmF/DshGbt5OvERT//OCRlfYA==
    9RsAAP//AwBQSwMEFAAGAAgATpduTOOTTDd1CwAAlGQAABMAKABjdXN0b21YbWwvaXRlbTEueG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAK1daw==
    TxxHFq3PK+U/WPs9cTwv0IpMZPDGsYRtYibO5pNFYLDRehjEDI7588neqpqiHvdZzQrFzHSde86p293V9Wry918H7kf31a3cZ/fEfXFLd+s27sqt3bX7wf3TPXPfue/h9xMouQ==
    dudw/AJKr93HUHrntu7SfQuoGXz70c3dN+4f7sC9cWfA9RugbwH/DmJvwuet+09QOoFy/+3JTvkaNCPfLXz+Fxy7Aq1biNnAf5eA/BZ47qHsbFe2gSPXQeUp4DL/Br6fwu8zKA==
    vQgqF+4D6Hnmc/cJjmwA/cG9DSW+tk/B/diN4OcpOIg1eAI/B0TUz/Dv2S4uIyP6OdTjM7j4070C7S/wyftcuhfwewOfPrhj9wcg5mbkATiys7ZuVoC9g5htpYyPRhUKXTMeQg==
    +X2oeUbgY56NQlJcPwFi5d6HK+sCrpl1dabqXPdGZB89Ko9z2ealP3KIaz3Ha2B6DugL+PyscleX1OptlIV9xLKPBPaRkX3Mso8F9rGRfcKyTwT2iZF9yrJPBfapkX3Gss8E9g==
    mZF9j2XfE9j3jOz7LPu+wL6P2I9C+U1o+e8fcEtoJTfh+pXLvZLGYNcbKXojVQ/fExJ6rOiNVT18l0joiaI3UfXwfSOhp4reVNXDd5KEnil6M1UP31s1+jD8/i9EnYdeVXz2+g==
    dr5V5pHYg8Q6zE1+uvRG9LjjnmF0/CFk+Sz0Rj+JGWtxvCPMOMSHlisOb/fVl6c3obe8ZP2kcl4/M/ToaXlocbq+rd5HcEVt4Iryx15C//iWuDYoDNanmXq1uTxIWJsXWz7+7Q==
    XsOnK8JBLsF6ZZTMvtrhuHpiBKWGWSTVlAHqvi/LsFIdadXg6kZhZE1b/X4O35ZhhPyRuHfbcqyJGXr0uPpyOF3fVu9XcM8/hzy1uuk41skRFl6uXm05r2OrxzHU+CN8/uzeug==
    S/iJo/VWlUZhbY6t3wFXfxltdWTNzRpi13BlrMMc03Y3z4Q90TjKDcco+TiBp6lHLclWpC7Fmm20XYk7BzRKU7bl/CScoW2YOVhC+VMF/y6c36vwxPF9j5TRN8CwAr04T9Ifgw==
    a2NTeqxXLuc9scO8287PqfsNWpif3AI5zCVYv4yysXN5wAhJzVan99BeLoQc4XtOj8CuLCqPc8nlzB45xHV/jrWM6vnry5Y1N/ZMaPW+Dk8aPyO6gG9HwHDzkLPaiQWZvNhYWw==
    N74lvd2taaQ+TjoDXFlU5CNrDT+37z0t3VfwM2++e64W0cavoc1fQI5vwrOZm+224aKejZHycRd6g36k/yJc6csHZVyStagoG3s+cxpCUuPOf4tfhF7HZ1EXYyhliqnVvnPLKg==
    i+X3yFkj6vg81noFmKxCH/d8XETL+zXcOf7KPg+fXoR1pHb9rL5WhkRFT0PUasf8GEUa51hHNq9C9lfgaxnW6G4hg1TLYsN5ZSsj7eM4rNgumVU+C6r0ILPRDuh+kVRaKlp6VQ==
    CfsLYM+CJ3833RNqHKJU5Flo1V8Be0VmtS0pVXCUzH4Szns93tIxlCLFVGvL66TaymvPKmteicdtL1/mVaRIXUNuL3ojOD89rVKOr/tD9PFaUepBvQ37NG7Cv7G/0R6JXC2qZg==
    wa0e1UZqbaMvvy+etku33T1hNg2zhkpqOpvkYBGytwJ8altbdYzAyhRLnypXdx5pcSHnwPd6bfsi+vDZmV2h9Rf39KxCW6WfLzs6euthp53dh2j5PNqQpSOdFbuJ7fgm7A86Bw==
    zJ1LO7TiCKt2ZEUnV3Z23VmK4K+y3hjOpab0WK9yTm2xw7z353u7GyNqCNnPlhxptk+322JMypdFJT6S00g9z7gTLu2Aex7umfKM9OBrLzYFzl9+GnNzCXZs7Utn1j2lPkmPNw==
    OYbzqCnpXmOPv8epFMH5lFVql3G0uQSU3yP7RzUm4Mu8shSJNS6Ds7jXdlncE3xZ0uAia41TdxbmGDZFRk5c3PUbZyDTir8VeRB23FpZWzdL5/e3xvm3uM4t9xN6I6K7XpXHuQ==
    zOd3aOQQ19xVdQq4q9DbiX2c1873kv1K0kXRy7GgoisLW7+DMmd2tNWRlhuf43KvK328VGsjdN4RwztiefEeQAo1ZnjHLC/e60ehJgzvhOXFe/oo1JThnbK8eO8ehZoxvDOWFw==
    79GjUHsM7x7Li3e+Uqh9hnef5cV7XhNqW6Di/kN8P/GYUk9iarXv4LjHb0PrXyrSJVGHi6rZF1D6FfphFy6NzOLaA/e07sN7J70KrT9+xUheebKvNS2ILOFjiVPOp+/FH+/68g==
    h7s+9zH4+L2I0DFey8KEtRe7XjTdw048bU97aGTyOUxVd1/OgWt+aSznkGPWPbXjcR3DeZBH9nyEJRsUUvZhz8RpuH/PGQdtaauKoymldM3k96+4PmQfPruxK1D+cnt2FVa36w==
    nqGOyT5kJkrb907zuAMfy9w1kuIq9wXIGdaRWdfC2rqJs5dlXw8fiwoYKXONCK4RyYV7gi1iTHCNSS7c+2sRE4JrQnLhHl+LmBJcU5IL9/JaxIzgmpFcuGfXIvYIrj2SC/fmWg==
    xD7BtU9y4R5cPTue71N8tOSTVnsSxr8P61ftub6GDVeqaoySj/Ld1bi6JJdjXczQo8fVm8Pp+pZ61+tzc6Gs1WsjrRp0PfkVRAtTrf27W4eWM8458e2oDec9WBnluecPD/2GGg==
    GdHte9TU0zXH96B9DfrY7e7SrLtcLjmg5u2TZt6/wa3uzE2oqG9hwy7yDA2VKak07neSovvUyv1bOkpTp++e5OIqjK792Yk7MvxuxE3Vy9UxaR+gxsTpp70gOYI+A1Zs9mNjxg==
    vuhVFyrWiox7X6ysmiPuuWdBYSeWp2h00Y4JKe86xjuwMPH6cqtmQZUeetvIVNb23rEDDlGq8yxYmcdKSv8PhXxVaAhJUbq2MBqfH35llcPSq6o8M/b1i4v77qj88WVeV4rs0Q==
    ye50jKwr1TPP3NXr7XO2pJ7va6Mkhby6L81c2rC1C52Z8oV3k+czJZVGbSkaq/0KvdvXDJov80pSZI9OzoWOkXWlrMbrIN1hqUdG79W1Y/MMio2Z80XPKVGZ7cNrs1a2c9fHYA==
    m1WTz/FQxXokhHfTcGOhsjXYKK1FeWbnzPG6FagjrNx8u8ejeN2e9tC/SZCxeT5SQ9TqHIu9raeUaYTU9tuV8V8Ro+7m1o0tCju0qkmu46ph/j4XymoHOFLSoc4EnXtbtvP6Ag==
    lVVcWmtQ0bpauarFq1IoSp1m011YrywdTbnqvZJwJtt1CqqsXiHCkW0rzLetycHRAwue0WqdcquWscyyNhrLbGuhiXWIo3odtX/VdshqrdVpPeK1rNDaVmat+uk5xJfJq599Og==
    Ui3LY5YV1z7ldHYk7YSR1TNTjz7Vh5K8UHjZF63QtgH6fU63BXEHBVfn410v45N759K7nfTxvEMDR3DcaeU7esBrrBIi60ksnDJuXVMe5PJ2HwrFIGvWO1ekvS/ynhfbFUBjyw==
    91D8XzJZw2d6jibiyjdVUrbr8fa8A1u+d2Jh5n2tdv3uL+FvNaZZcc6ZBd2+paOzW91dPrRucjnvIDPYNel3lSiEpEvvr5WVX8KVFf/eXlxHtOEkFy3jUC+260OOsvvsu16odw==
    nOcqonVDs8jKtlFtb0TrbOjYueSgRidyeevCNr6RI8r3jSw43YM0ssOR9PjIhqO99I+46BmIkWEmY2Say2h3H7X69DxErc9hLDMaePdTe59Rz07qbOnjL/ra4EcBfXj+6usZZw==
    aAxUKyGPP6yMQ71Ys9WOUfrYh7rLI44+vN2hNKaxMfjRh9Wfx9q9RWbe1z2K1/qe1gj85rNFRWoJLKMv/xcMt7syqa0/dP4NovsC0x7x6hiFmY7CzpxNyPrHAkkf96xcBOZ+GQ==
    ar8M+amxXInn56Pa7MrZotce8Ngvrk7b/p8gc/c/UEsDBBQABgAIAAAAIQBbbf2TCQEAAPEBAAAdAAAAd29yZC9nbG9zc2FyeS93ZWJTZXR0aW5ncy54bWyU0cFKAzEQBuC74A==
    Oyy5t9kWFVm6LYhUvIigPkCazrbBTCbMpK716R1rrUgv9ZZJMh8z/JPZO8bqDVgCpdaMhrWpIHlahrRqzcvzfHBtKikuLV2kBK3ZgpjZ9Pxs0jc9LJ6gFP0plSpJGvStWZeSGw==
    a8WvAZ0MKUPSx44YXdGSVxYdv27ywBNmV8IixFC2dlzXV2bP8CkKdV3wcEt+g5DKrt8yRBUpyTpk+dH6U7SeeJmZPIjoPhi/PXQhHZjRxRGEwTMJdWWoy+wn2lHaPqp3J4y/wA==
    5f+A8QFA39yvErFbRI1AJ6kUM1PNgHIJGD5gTnzD1Auw/bp2MVL/+HCnhf0T1PQTAAD//wMAUEsDBBQABgAIAAAAIQAA9ETuxAEAAO0EAAAbAAAAd29yZC9nbG9zc2FyeS9mbw==
    bnRUYWJsZS54bWy8kl1r2zAUhu8H+w9C941lJ+mHqVNat4HB2MXofoCiyLaYPoyOEi//fsey422EsoRCbTD2e6THRw/n/uGX0WQvPShnC5rOGCXSCrdVti7oj9f11S0lELjdcg==
    7aws6EECfVh9/nTf5ZWzAQjut5AbUdAmhDZPEhCNNBxmrpUWi5Xzhgf89HViuP+5a6+EMy0PaqO0CockY+yajhh/DsVVlRLy2YmdkTbE/YmXGonOQqNaONK6c2id89vWOyEB8A==
    zEYPPMOVnTDp4gRklPAOXBVmeJixo4jC7SmLb0b/ASwvA2QTwIj8S22d5xuN8rETgjC6Gu2TLrfcYKHkWm28ioWWWwcyxdqe64KyjK3ZEp/9vWDz/kmTfqFouAfZQ+LCshziig==
    G6UPxxQ6BTAUWhVEc8z33Ku+qaEEqsbCDjasoC8Mr2y9pkOSFnSBwWM5JRk2NVzpmMynhPWJiJxhxV3cJSJnWoP/TAYDJyZelZFAvsmOfHeG2zeMZOwaTSzRR29mfpERH7mXGg==
    yV7+NlJicnO7mJ8Yufu/kYFzvpFxNshXVTfhzQnp5+KjJuSxbxmF/DshGbt5OvERT//OCRlfYPUbAAD//wMAUEsDBBQABgAIAE2Xbky32htE6gEAAGEEAAAQAAgBZG9jUHJvcA==
    cy9hcHAueG1sIKIEASigAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJ1UTW/bMAz9K4bujeNgXwgaFUN72GFDCyRrzw==
    nEwnwmxJkJgg2V/bYT9pf2GU5LjKgl2WE/n49PQoMv7989ft3XHoqwP6oK1ZiWY2FxUaZVtttiuxp+7mg6gCgWmhtwZX4oRB3MlbcMsnbx160hgq1jBheaCV2BG5ZV0HtcMBwg==
    jBmGi531AxCnflvbrtMKH6zaD2ioXszn7+rWqqgWnjcnx/qjHrj/1cMjoWmxvXGTR5E8b3BwPRDKteZAdxrbag09t3AWmLWWjrd1yU0HLUG/0QPKeS5OeXoK2GIYKzmO6Iv1bQ==
    kM37JuE5i/j9Djwo4jcfjxRArH90bE0B8UTkF628Dbaj6jH1WUWZdKhkxVPcwBrV3ms6jbIlEhmftZlc5jh797D14HZBLsYGJiDW14rf557fUXbQB0yUVywyPiHEdXkCHRs40A==
    8oCKrK++QcA40JU4gNdgiDdJ/+B0ITItoynuXSAvN5p6vmHKU1jSyli/kU0icHBJrCcPMtm9NBinF+8Jjx23Sv+wnAycDTeiMHnlr7jpL+E4Wzs4MKdcnpI8ge/hq9vYh7hjrw==
    b3uJX+7Li6bd2oHC680pSmlqXMCWN6Cc2oSlqXGbvo+XsYjZYlswr2vjXj7nD4Vs3s7m/Dsv4hnO+zP95+QfUEsBAi0AFAAGAAgAAAAhAPvrw2rZAQAAKwwAABMAAAAAAAAAAA==
    AAAAAAAAAAAAW0NvbnRlbnRfVHlwZXNdLnhtbFBLAQItABQABgAIAAAAIQAekRq37wAAAE4CAAALAAAAAAAAAAAAAAAAABIEAABfcmVscy8ucmVsc1BLAQItABQABgAIAAAAIQ==
    AFT4ZEJjAQAA7gcAABwAAAAAAAAAAAAAAAAAMgcAAHdvcmQvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHNQSwECLQAUAAYACABNl25MQdHHJIQRAABoEwEAEQAAAAAAAAAAAAAAAA==
    ANcJAAB3b3JkL2RvY3VtZW50LnhtbFBLAQItABQABgAIAE2Xbkzl9oLHYQcAAG0gAAAQAAAAAAAAAAAAAAAAAIobAAB3b3JkL2hlYWRlcjIueG1sUEsBAi0AFAAGAAgATZduTA==
    Q6gGBxUDAAA0DgAAEAAAAAAAAAAAAAAAAAAZIwAAd29yZC9mb290ZXIxLnhtbFBLAQItABQABgAIAE2Xbkz/Hw1lswUAAHwhAAAQAAAAAAAAAAAAAAAAAFwmAAB3b3JkL2hlYQ==
    ZGVyMS54bWxQSwECLQAUAAYACABNl25MfAk7IXYEAAD2GwAAEAAAAAAAAAAAAAAAAAA9LAAAd29yZC9mb290ZXIyLnhtbFBLAQItABQABgAIAE2XbkxecVtuywEAAFIGAAARAA==
    AAAAAAAAAAAAAAAA4TAAAHdvcmQvZW5kbm90ZXMueG1sUEsBAi0AFAAGAAgAAAAhAKomDr68AAAAIQEAABsAAAAAAAAAAAAAAAAA2zIAAHdvcmQvX3JlbHMvaGVhZGVyMi54bQ==
    bC5yZWxzUEsBAi0AFAAGAAgATZduTD3HefHMAQAAWAYAABIAAAAAAAAAAAAAAAAA0DMAAHdvcmQvZm9vdG5vdGVzLnhtbFBLAQItABQABgAIAAAAIQCqUiXfIwYAAIsaAAAVAA==
    AAAAAAAAAAAAAAAAzDUAAHdvcmQvdGhlbWUvdGhlbWUxLnhtbFBLAQItAAoAAAAAAAAAIQBUAQa58gMAAPIDAAAVAAAAAAAAAAAAAAAAACI8AAB3b3JkL21lZGlhL2ltYWdlMQ==
    LnBuZ1BLAQItABQABgAIAAAAIQAD2ZWNZAYAAKgpAAAaAAAAAAAAAAAAAAAAAEdAAAB3b3JkL2dsb3NzYXJ5L2RvY3VtZW50LnhtbFBLAQItABQABgAIAAAAIQDSdzsz9QAAAA==
    dQEAABwAAAAAAAAAAAAAAAAA40YAAHdvcmQvX3JlbHMvc2V0dGluZ3MueG1sLnJlbHNQSwECLQAUAAYACAAAACEAsyG9mrIEAAB8DwAAGgAAAAAAAAAAAAAAAAASSAAAd29yZA==
    L2dsb3NzYXJ5L3NldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQCD0LXl5gAAAK0CAAAlAAAAAAAAAAAAAAAAAPxMAAB3b3JkL2dsb3NzYXJ5L19yZWxzL2RvY3VtZW50LnhtbA==
    LnJlbHNQSwECLQAUAAYACAAAACEAfzOWemkLAAASMAAAEQAAAAAAAAAAAAAAAAAlTgAAd29yZC9zZXR0aW5ncy54bWxQSwECLQAUAAYACAAAACEApUe+MeIAAABVAQAAGAAAAA==
    AAAAAAAAAAAAAL1ZAABjdXN0b21YbWwvaXRlbVByb3BzMi54bWxQSwECLQAUAAYACAAAACEAP72VVQMBAABTAQAAGAAAAAAAAAAAAAAAAAD9WgAAY3VzdG9tWG1sL2l0ZW1Qcg==
    b3BzMS54bWxQSwECLQAUAAYACAAAACEAUDpnScsAAAA2AQAAEwAAAAAAAAAAAAAAAABeXAAAY3VzdG9tWG1sL2l0ZW0yLnhtbFBLAQItABQABgAIAAAAIQBcliciwgAAACgBAA==
    AB4AAAAAAAAAAAAAAAAAgl0AAGN1c3RvbVhtbC9fcmVscy9pdGVtMi54bWwucmVsc1BLAQItABQABgAIAAAAIQB0Pzl6wgAAACgBAAAeAAAAAAAAAAAAAAAAAIhfAABjdXN0bw==
    bVhtbC9fcmVscy9pdGVtMS54bWwucmVsc1BLAQItABQABgAIAAAAIQDZoKiNUg8AAAyFAAAYAAAAAAAAAAAAAAAAAI5hAAB3b3JkL2dsb3NzYXJ5L3N0eWxlcy54bWxQSwECLQ==
    ABQABgAIAE2XbkxtfwebOgEAAEgCAAARAAAAAAAAAAAAAAAAABZxAABkb2NQcm9wcy9jb3JlLnhtbFBLAQItABQABgAIAAAAIQCtwITRZA8AAJeSAAAPAAAAAAAAAAAAAAAAAA==
    h3MAAHdvcmQvc3R5bGVzLnhtbFBLAQItABQABgAIAAAAIQBnDLaGjgEAALsDAAAUAAAAAAAAAAAAAAAAABiDAAB3b3JkL3dlYlNldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQ==
    AAD0RO7EAQAA7QQAABIAAAAAAAAAAAAAAAAA2IQAAHdvcmQvZm9udFRhYmxlLnhtbFBLAQItABQABgAIAE6Xbkzjk0w3dQsAAJRkAAATAAAAAAAAAAAAAAAAAMyGAABjdXN0bw==
    bVhtbC9pdGVtMS54bWxQSwECLQAUAAYACAAAACEAW239kwkBAADxAQAAHQAAAAAAAAAAAAAAAACakgAAd29yZC9nbG9zc2FyeS93ZWJTZXR0aW5ncy54bWxQSwECLQAUAAYACA==
    AAAAIQAA9ETuxAEAAO0EAAAbAAAAAAAAAAAAAAAAAN6TAAB3b3JkL2dsb3NzYXJ5L2ZvbnRUYWJsZS54bWxQSwECLQAUAAYACABNl25Mt9obROoBAABhBAAAEAAAAAAAAAAAAA==
    AAAAANuVAABkb2NQcm9wcy9hcHAueG1sUEsFBgAAAAAgACAAcQgAAPuYAAAAAA==
    END_OF_WORDLAYOUT
  }
}

