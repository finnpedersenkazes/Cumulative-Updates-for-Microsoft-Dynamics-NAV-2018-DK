OBJECT Report 6641 Return Order
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Returvareordre;
               ENU=Return Order];
    OnInitReport=BEGIN
                   GLSetup.GET;
                   CompanyInfo.GET;
                 END;

    OnPreReport=BEGIN
                  IF NOT CurrReport.USEREQUESTPAGE THEN
                    InitLogInteraction;
                END;

    PreviewMode=PrintLayout;
  }
  DATASET
  {
    { 4458;    ;DataItem;                    ;
               DataItemTable=Table38;
               DataItemTableView=SORTING(Document Type,No.)
                                 WHERE(Document Type=CONST(Return Order));
               ReqFilterHeadingML=[DAN=K�bsreturvareordre;
                                   ENU=Purchase Return Order];
               OnAfterGetRecord=BEGIN
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FormatAddressFields("Purchase Header");
                                  FormatDocumentFields("Purchase Header");

                                  DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID");

                                  IF LogInteraction THEN
                                    IF NOT IsReportInPreviewMode THEN BEGIN
                                      IF "Buy-from Contact No." <> '' THEN
                                        SegManagement.LogDocument(
                                          22,"No.",0,0,DATABASE::Contact,"Buy-from Contact No.","Purchaser Code",'',"Posting Description",'')
                                      ELSE
                                        SegManagement.LogDocument(
                                          22,"No.",0,0,DATABASE::Vendor,"Buy-from Vendor No.","Purchaser Code",'',"Posting Description",'')
                                    END;
                                END;

               ReqFilterFields=No.,Buy-from Vendor No.,No. Printed }

    { 175 ;1   ;Column  ;No_PurchHdr         ;
               SourceExpr="No." }

    { 2   ;1   ;Column  ;DiscPercentCaption  ;
               SourceExpr=DiscPercentCaptionLbl }

    { 3   ;1   ;Column  ;AllowInvoiceDiscCaption;
               SourceExpr=AllowInvoiceDiscCaptionLbl }

    { 51  ;1   ;Column  ;VATIdentifierCaption1;
               SourceExpr=VATIdentifierCaption1Lbl }

    { 52  ;1   ;Column  ;VATPctCaption       ;
               SourceExpr=VATPctCaptionLbl }

    { 53  ;1   ;Column  ;VATBaseCaption2     ;
               SourceExpr=VATBaseCaption2Lbl }

    { 56  ;1   ;Column  ;VATAmountCaption    ;
               SourceExpr=VATAmountCaptionLbl }

    { 57  ;1   ;Column  ;TotalCaption1       ;
               SourceExpr=TotalCaption1Lbl }

    { 5701;1   ;DataItem;CopyLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               NoOfLoops := ABS(NoOfCopies) + 1;
                               CopyText := '';
                               SETRANGE(Number,1,NoOfLoops);
                               OutputNo := 1;
                             END;

               OnAfterGetRecord=BEGIN
                                  CLEAR(PurchLine);
                                  CLEAR(PurchPost);
                                  PurchLine.DELETEALL;
                                  VATAmountLine.DELETEALL;
                                  PurchPost.GetPurchLines("Purchase Header",PurchLine,0);
                                  PurchLine.CalcVATAmountLines(0,"Purchase Header",PurchLine,VATAmountLine);
                                  PurchLine.UpdateVATOnLines(0,"Purchase Header",PurchLine,VATAmountLine);
                                  VATAmount := VATAmountLine.GetTotalVATAmount;
                                  VATBaseAmount := VATAmountLine.GetTotalVATBase;
                                  VATDiscountAmount :=
                                    VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code","Purchase Header"."Prices Including VAT");
                                  TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                                  IF Number > 1 THEN BEGIN
                                    CopyText := FormatDocument.GetCOPYText;
                                    OutputNo += 1;
                                  END;
                                  CurrReport.PAGENO := 1;

                                  TotalSubTotal := 0;
                                  TotalInvoiceDiscountAmount := 0;
                                  TotalAmount := 0;
                                END;

               OnPostDataItem=BEGIN
                                IF NOT IsReportInPreviewMode THEN
                                  CODEUNIT.RUN(CODEUNIT::"Purch.Header-Printed","Purchase Header");
                              END;
                               }

    { 6455;2   ;DataItem;PageLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 17  ;3   ;Column  ;DirectUnitCostCaption;
               SourceExpr=DirectUnitCostCaptionLbl }

    { 27  ;3   ;Column  ;AmtCaption          ;
               SourceExpr=AmtCaptionLbl }

    { 40  ;3   ;Column  ;PurchLineInvDiscAmtCaption;
               SourceExpr=PurchLineInvDiscAmtCaptionLbl }

    { 39  ;3   ;Column  ;SubtotalCaption     ;
               SourceExpr=SubtotalCaptionLbl }

    { 32  ;3   ;Column  ;VATDiscAmtCaption   ;
               SourceExpr=VATDiscAmtCaptionLbl }

    { 41  ;3   ;Column  ;TotalText           ;
               SourceExpr=TotalText }

    { 1   ;3   ;Column  ;ReturnOrderCopyText ;
               SourceExpr=STRSUBSTNO(Text004,CopyText) }

    { 5   ;3   ;Column  ;CompanyAddr1        ;
               SourceExpr=CompanyAddr[1] }

    { 7   ;3   ;Column  ;CompanyAddr2        ;
               SourceExpr=CompanyAddr[2] }

    { 9   ;3   ;Column  ;CompanyAddr3        ;
               SourceExpr=CompanyAddr[3] }

    { 11  ;3   ;Column  ;CompanyAddr4        ;
               SourceExpr=CompanyAddr[4] }

    { 14  ;3   ;Column  ;CompanyInfoPhoneNo  ;
               SourceExpr=CompanyInfo."Phone No." }

    { 10  ;3   ;Column  ;CompanyInfoHomePage ;
               SourceExpr=CompanyInfo."Home Page" }

    { 16  ;3   ;Column  ;CompanyInfoEmail    ;
               SourceExpr=CompanyInfo."E-Mail" }

    { 19  ;3   ;Column  ;CompanyInfoVATRegNo ;
               SourceExpr=CompanyInfo."VAT Registration No." }

    { 21  ;3   ;Column  ;CompanyInfoGiroNo   ;
               SourceExpr=CompanyInfo."Giro No." }

    { 23  ;3   ;Column  ;CompanyInfoBankName ;
               SourceExpr=CompanyInfo."Bank Name" }

    { 25  ;3   ;Column  ;CompanyInfoBankAccountNo;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 28  ;3   ;Column  ;DocumentDate_PurchHdr;
               SourceExpr=FORMAT("Purchase Header"."Document Date",0,4) }

    { 29  ;3   ;Column  ;VATNoText           ;
               SourceExpr=VATNoText }

    { 30  ;3   ;Column  ;VATRegNo_PurchHdr   ;
               SourceExpr="Purchase Header"."VAT Registration No." }

    { 33  ;3   ;Column  ;PurchaserText       ;
               SourceExpr=PurchaserText }

    { 34  ;3   ;Column  ;SalesPurchPersonName;
               SourceExpr=SalesPurchPerson.Name }

    { 36  ;3   ;Column  ;No1_PurchHdr        ;
               SourceExpr="Purchase Header"."No." }

    { 37  ;3   ;Column  ;ReferenceText       ;
               SourceExpr=ReferenceText }

    { 38  ;3   ;Column  ;yourReference_PurchHdr;
               SourceExpr="Purchase Header"."Your Reference" }

    { 47  ;3   ;Column  ;CompanyAddr5        ;
               SourceExpr=CompanyAddr[5] }

    { 48  ;3   ;Column  ;CompanyAddr6        ;
               SourceExpr=CompanyAddr[6] }

    { 115 ;3   ;Column  ;BuyfromVendNo_PurchHdr;
               SourceExpr="Purchase Header"."Buy-from Vendor No." }

    { 90  ;3   ;Column  ;BuyFromAddr1        ;
               SourceExpr=BuyFromAddr[1] }

    { 91  ;3   ;Column  ;BuyFromAddr2        ;
               SourceExpr=BuyFromAddr[2] }

    { 92  ;3   ;Column  ;BuyFromAddr3        ;
               SourceExpr=BuyFromAddr[3] }

    { 93  ;3   ;Column  ;BuyFromAddr4        ;
               SourceExpr=BuyFromAddr[4] }

    { 125 ;3   ;Column  ;BuyFromAddr5        ;
               SourceExpr=BuyFromAddr[5] }

    { 126 ;3   ;Column  ;BuyFromAddr6        ;
               SourceExpr=BuyFromAddr[6] }

    { 127 ;3   ;Column  ;BuyFromAddr7        ;
               SourceExpr=BuyFromAddr[7] }

    { 128 ;3   ;Column  ;BuyFromAddr8        ;
               SourceExpr=BuyFromAddr[8] }

    { 82  ;3   ;Column  ;PricesIncVAT_PurchHdr;
               SourceExpr="Purchase Header"."Prices Including VAT" }

    { 153 ;3   ;Column  ;PrsInclVATYesNo_PurchHdr;
               SourceExpr=FORMAT("Purchase Header"."Prices Including VAT") }

    { 154 ;3   ;Column  ;OutputNo            ;
               SourceExpr=OutputNo }

    { 163 ;3   ;Column  ;PageCaption         ;
               SourceExpr=STRSUBSTNO(Text005,'') }

    { 13  ;3   ;Column  ;PhoneNoCaption      ;
               SourceExpr=PhoneNoCaptionLbl }

    { 18  ;3   ;Column  ;VATRegNoCaption     ;
               SourceExpr=VATRegNoCaptionLbl }

    { 20  ;3   ;Column  ;GiroNoCaption       ;
               SourceExpr=GiroNoCaptionLbl }

    { 22  ;3   ;Column  ;BankNameCaption     ;
               SourceExpr=BankNameCaptionLbl }

    { 24  ;3   ;Column  ;BankAccNoCaption    ;
               SourceExpr=BankAccNoCaptionLbl }

    { 35  ;3   ;Column  ;ReturnOrderNoCaption;
               SourceExpr=ReturnOrderNoCaptionLbl }

    { 42  ;3   ;Column  ;DocumentDateCaption ;
               SourceExpr=DocumentDateCaptionLbl }

    { 4   ;3   ;Column  ;EmailCaption        ;
               SourceExpr=EmailCaptionLbl }

    { 8   ;3   ;Column  ;HomePageCaption     ;
               SourceExpr=HomePageCaptionLbl }

    { 58  ;3   ;Column  ;BuyfromVendNo_PurchHdrCaption;
               SourceExpr="Purchase Header".FIELDCAPTION("Buy-from Vendor No.") }

    { 59  ;3   ;Column  ;PricesIncVAT_PurchHdrCaption;
               SourceExpr="Purchase Header".FIELDCAPTION("Prices Including VAT") }

    { 7574;3   ;DataItem;DimensionLoop1      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry1.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  CLEAR(DimText);
                                  Continue := FALSE;
                                  REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                      DimText := STRSUBSTNO('%1 %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
                                    ELSE
                                      DimText :=
                                        STRSUBSTNO(
                                          '%1, %2 %3',DimText,
                                          DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                      DimText := OldDimText;
                                      Continue := TRUE;
                                      EXIT;
                                    END;
                                  UNTIL DimSetEntry1.NEXT = 0;
                                END;

               DataItemLinkReference=Purchase Header }

    { 70  ;4   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 155 ;4   ;Column  ;DimensionLoop1Number;
               SourceExpr=Number }

    { 71  ;4   ;Column  ;HdrDimsCaption      ;
               SourceExpr=HdrDimsCaptionLbl }

    { 6547;3   ;DataItem;                    ;
               DataItemTable=Table39;
               DataItemTableView=SORTING(Document Type,Document No.,Line No.);
               OnPreDataItem=BEGIN
                               CurrReport.BREAK;
                             END;

               DataItemLinkReference=Purchase Header;
               DataItemLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.) }

    { 7551;3   ;DataItem;RoundLoop           ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               MoreLines := PurchLine.FIND('+');
                               WHILE MoreLines AND (PurchLine.Description = '') AND (PurchLine."Description 2" = '') AND
                                     (PurchLine."No." = '') AND (PurchLine.Quantity = 0) AND
                                     (PurchLine.Amount = 0)
                               DO
                                 MoreLines := PurchLine.NEXT(-1) <> 0;
                               IF NOT MoreLines THEN
                                 CurrReport.BREAK;
                               PurchLine.SETRANGE("Line No.",0,PurchLine."Line No.");
                               SETRANGE(Number,1,PurchLine.COUNT);
                               CurrReport.CREATETOTALS(PurchLine."Line Amount",PurchLine."Inv. Discount Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    PurchLine.FIND('-')
                                  ELSE
                                    PurchLine.NEXT;
                                  "Purchase Line" := PurchLine;

                                  IF (PurchLine.Type = PurchLine.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                    "Purchase Line"."No." := '';

                                  TypeInt := "Purchase Line".Type;
                                  TotalSubTotal += "Purchase Line"."Line Amount";
                                  TotalInvoiceDiscountAmount -= "Purchase Line"."Inv. Discount Amount";
                                  TotalAmount += "Purchase Line".Amount;
                                END;

               OnPostDataItem=BEGIN
                                PurchLine.DELETEALL;
                              END;
                               }

    { 157 ;4   ;Column  ;TypeInt             ;
               SourceExpr=TypeInt }

    { 54  ;4   ;Column  ;LineAmt_PurchLine   ;
               SourceExpr=PurchLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Line"."Currency Code" }

    { 55  ;4   ;Column  ;Description_PurchLine;
               SourceExpr="Purchase Line".Description }

    { 883 ;4   ;Column  ;Description_PurchLineCaption;
               SourceExpr="Purchase Line".FIELDCAPTION(Description) }

    { 62  ;4   ;Column  ;No_PurchLine        ;
               SourceExpr="Purchase Line"."No." }

    { 43  ;4   ;Column  ;No_PurchLineCaption ;
               SourceExpr="Purchase Line".FIELDCAPTION("No.") }

    { 64  ;4   ;Column  ;Quantity_PurchLine  ;
               SourceExpr="Purchase Line".Quantity }

    { 884 ;4   ;Column  ;Quantity_PurchLineCaption;
               SourceExpr="Purchase Line".FIELDCAPTION(Quantity) }

    { 65  ;4   ;Column  ;UnitofMeasure_PurchLine;
               SourceExpr="Purchase Line"."Unit of Measure" }

    { 885 ;4   ;Column  ;UnitofMeasure_PurchLineCaption;
               SourceExpr="Purchase Line".FIELDCAPTION("Unit of Measure") }

    { 66  ;4   ;Column  ;DirectUnitCost_PurchLine;
               SourceExpr="Purchase Line"."Direct Unit Cost";
               AutoFormatType=2;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 67  ;4   ;Column  ;LineDiscount_PurchLine;
               SourceExpr="Purchase Line"."Line Discount %" }

    { 84  ;4   ;Column  ;AllowInvDisc_PurchLine;
               SourceExpr="Purchase Line"."Allow Invoice Disc." }

    { 89  ;4   ;Column  ;VATIdentifier_PurchLine;
               SourceExpr="Purchase Line"."VAT Identifier" }

    { 886 ;4   ;Column  ;VATIdentifier_PurchLineCaption;
               SourceExpr="Purchase Line".FIELDCAPTION("VAT Identifier") }

    { 160 ;4   ;Column  ;AllInvDiscYesNo_PurchLine;
               SourceExpr=FORMAT("Purchase Line"."Allow Invoice Disc.") }

    { 79  ;4   ;Column  ;PurchLineInvDiscountAmt;
               SourceExpr=-PurchLine."Inv. Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Line"."Currency Code" }

    { 141 ;4   ;Column  ;PurchLineLnAmtInvDiscAmt;
               SourceExpr=PurchLine."Line Amount" - PurchLine."Inv. Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 142 ;4   ;Column  ;TotalInclVATText    ;
               SourceExpr=TotalInclVATText }

    { 46  ;4   ;Column  ;TotalSubTotal       ;
               SourceExpr=TotalSubTotal;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 45  ;4   ;Column  ;TotalInvoiceDiscountAmount;
               SourceExpr=TotalInvoiceDiscountAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 44  ;4   ;Column  ;TotalAmount         ;
               SourceExpr=TotalAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 143 ;4   ;Column  ;VATAmtLineVATAmtText;
               SourceExpr=VATAmountLine.VATAmountText }

    { 144 ;4   ;Column  ;VATAmt              ;
               SourceExpr=VATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 145 ;4   ;Column  ;PurchLnLnAmtInvDiscAmtVATAmt;
               SourceExpr=PurchLine."Line Amount" - PurchLine."Inv. Discount Amount" + VATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 146 ;4   ;Column  ;TotalExclVATText    ;
               SourceExpr=TotalExclVATText }

    { 148 ;4   ;Column  ;VATDiscountAmt      ;
               SourceExpr=-VATDiscountAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 159 ;4   ;Column  ;VATBaseDisc_PurchHdr;
               SourceExpr="Purchase Header"."VAT Base Discount %" }

    { 81  ;4   ;Column  ;VATBaseAmt          ;
               SourceExpr=VATBaseAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 85  ;4   ;Column  ;TotalAmtInclVAT     ;
               SourceExpr=TotalAmountInclVAT;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 60  ;4   ;Column  ;AllowInvDisc_PurchLineCaption;
               SourceExpr="Purchase Line".FIELDCAPTION("Allow Invoice Disc.") }

    { 3591;4   ;DataItem;DimensionLoop2      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;

                               DimSetEntry2.SETRANGE("Dimension Set ID","Purchase Line"."Dimension Set ID");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  CLEAR(DimText);
                                  Continue := FALSE;
                                  REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                      DimText := STRSUBSTNO('%1 %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
                                    ELSE
                                      DimText :=
                                        STRSUBSTNO(
                                          '%1, %2 %3',DimText,
                                          DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                      DimText := OldDimText;
                                      Continue := TRUE;
                                      EXIT;
                                    END;
                                  UNTIL DimSetEntry2.NEXT = 0;
                                END;
                                 }

    { 74  ;5   ;Column  ;DimText1            ;
               SourceExpr=DimText }

    { 158 ;5   ;Column  ;DimensionLoop2Number;
               SourceExpr=Number }

    { 75  ;5   ;Column  ;LineDimsCaption     ;
               SourceExpr=LineDimsCaptionLbl }

    { 6558;3   ;DataItem;VATCounter          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF VATAmount = 0 THEN
                                 CurrReport.BREAK;
                               SETRANGE(Number,1,VATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(
                                 VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
                                 VATAmountLine."Invoice Discount Amount",VATAmountLine."VAT Base",VATAmountLine."VAT Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  VATAmountLine.GetLine(Number);
                                END;
                                 }

    { 95  ;4   ;Column  ;VATAmtLineVATBase   ;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 96  ;4   ;Column  ;VATAmtLineVATAmt    ;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 137 ;4   ;Column  ;VATAmtLineLineAmt   ;
               SourceExpr=VATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 138 ;4   ;Column  ;VATAmtLineInvDiscBaseAmt;
               SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 139 ;4   ;Column  ;VATAmtLineInvDiscAmt;
               SourceExpr=VATAmountLine."Invoice Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 98  ;4   ;Column  ;VATAmtLineVAT       ;
               DecimalPlaces=0:5;
               SourceExpr=VATAmountLine."VAT %" }

    { 129 ;4   ;Column  ;VATAmtLineVATIdentifier;
               SourceExpr=VATAmountLine."VAT Identifier" }

    { 86  ;4   ;Column  ;VATPercentCaption   ;
               SourceExpr=VATPercentCaptionLbl }

    { 87  ;4   ;Column  ;VATBaseCaption      ;
               SourceExpr=VATBaseCaptionLbl }

    { 88  ;4   ;Column  ;VATAmtCaption       ;
               SourceExpr=VATAmtCaptionLbl }

    { 31  ;4   ;Column  ;VATAmtSpecCaption   ;
               SourceExpr=VATAmtSpecCaptionLbl }

    { 130 ;4   ;Column  ;VATIdentifierCaption;
               SourceExpr=VATIdentifierCaptionLbl }

    { 134 ;4   ;Column  ;InvDiscBaseAmtCaption;
               SourceExpr=InvDiscBaseAmtCaptionLbl }

    { 135 ;4   ;Column  ;LineAmtCaption      ;
               SourceExpr=LineAmtCaptionLbl }

    { 136 ;4   ;Column  ;InvDisAmtCaption    ;
               SourceExpr=InvDisAmtCaptionLbl }

    { 106 ;4   ;Column  ;VATBaseCaption1     ;
               SourceExpr=VATBaseCaption1Lbl }

    { 2038;3   ;DataItem;VATCounterLCY       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF (NOT GLSetup."Print VAT specification in LCY") OR
                                  ("Purchase Header"."Currency Code" = '') OR
                                  (VATAmountLine.GetTotalVATAmount = 0)
                               THEN
                                 CurrReport.BREAK;

                               SETRANGE(Number,1,VATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(VALVATBaseLCY,VALVATAmountLCY);

                               IF GLSetup."LCY Code" = '' THEN
                                 VALSpecLCYHeader := Text007 + Text008
                               ELSE
                                 VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                               CurrExchRate.FindCurrency("Purchase Header"."Posting Date","Purchase Header"."Currency Code",1);
                               VALExchRate := STRSUBSTNO(Text009,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  VATAmountLine.GetLine(Number);

                                  VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                        "Purchase Header"."Posting Date","Purchase Header"."Currency Code",
                                        VATAmountLine."VAT Base","Purchase Header"."Currency Factor"));
                                  VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                        "Purchase Header"."Posting Date","Purchase Header"."Currency Code",
                                        VATAmountLine."VAT Amount","Purchase Header"."Currency Factor"));
                                END;
                                 }

    { 6   ;4   ;Column  ;VALExchRate         ;
               SourceExpr=VALExchRate }

    { 12  ;4   ;Column  ;VALSpecLCYHdr       ;
               SourceExpr=VALSpecLCYHeader }

    { 15  ;4   ;Column  ;VALVATAmtLCY        ;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 26  ;4   ;Column  ;VALVATBaseLCY       ;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 110 ;4   ;Column  ;VATAmtLineVAT1      ;
               DecimalPlaces=0:5;
               SourceExpr=VATAmountLine."VAT %" }

    { 111 ;4   ;Column  ;VATAmtLineVATIdentifier1;
               SourceExpr=VATAmountLine."VAT Identifier" }

    { 3476;3   ;DataItem;Total               ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF "Purchase Header"."Buy-from Vendor No." = "Purchase Header"."Pay-to Vendor No." THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 3363;3   ;DataItem;Total2              ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF ("Purchase Header"."Sell-to Customer No." = '') AND (ShipToAddr[1] = '') THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 118 ;4   ;Column  ;SelltoCustNo_PurchHdr;
               SourceExpr="Purchase Header"."Sell-to Customer No." }

    { 119 ;4   ;Column  ;ShipToAddr1         ;
               SourceExpr=ShipToAddr[1] }

    { 120 ;4   ;Column  ;ShipToAddr2         ;
               SourceExpr=ShipToAddr[2] }

    { 121 ;4   ;Column  ;ShipToAddr3         ;
               SourceExpr=ShipToAddr[3] }

    { 122 ;4   ;Column  ;ShipToAddr4         ;
               SourceExpr=ShipToAddr[4] }

    { 123 ;4   ;Column  ;ShipToAddr5         ;
               SourceExpr=ShipToAddr[5] }

    { 124 ;4   ;Column  ;ShipToAddr6         ;
               SourceExpr=ShipToAddr[6] }

    { 49  ;4   ;Column  ;ShipToAddr7         ;
               SourceExpr=ShipToAddr[7] }

    { 50  ;4   ;Column  ;ShipToAddr8         ;
               SourceExpr=ShipToAddr[8] }

    { 116 ;4   ;Column  ;ShiptoAddressCaption;
               SourceExpr=ShiptoAddressCaptionLbl }

    { 61  ;4   ;Column  ;SelltoCustNo_PurchHdrCaption;
               SourceExpr="Purchase Header".FIELDCAPTION("Sell-to Customer No.") }

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
      { 3   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 5   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Antal kopier;
                             ENU=No. of Copies];
                  ToolTipML=[DAN=Angiver, hvor mange kopier af bilaget der udskrives.;
                             ENU=Specifies how many copies of the document to print.];
                  ApplicationArea=#PurchReturnOrder;
                  SourceExpr=NoOfCopies }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Vis interne oplysninger;
                             ENU=Show Internal Information];
                  ToolTipML=[DAN=Angiver, om den udskrevne rapport skal indeholde oplysninger, der kun er til intern brug.;
                             ENU=Specifies if you want the printed report to show information that is only for internal use.];
                  ApplicationArea=#PurchReturnOrder;
                  SourceExpr=ShowInternalInfo }

      { 4   ;2   ;Field     ;
                  Name=LogInteraction;
                  CaptionML=[DAN=Logf�r interaktion;
                             ENU=Log Interaction];
                  ToolTipML=[DAN=Angiver, om du vil registrere de rapporter, der udskrives som interaktioner.;
                             ENU=Specifies if you want to record the reports that you print as interactions.];
                  ApplicationArea=#PurchReturnOrder;
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
      Text004@1004 : TextConst '@@@="%1 = Document No.";DAN=Returvareordre %1;ENU=Return Order %1';
      Text005@1005 : TextConst 'DAN=Side %1;ENU=Page %1';
      GLSetup@1007 : Record 98;
      CompanyInfo@1008 : Record 79;
      SalesPurchPerson@1011 : Record 13;
      VATAmountLine@1012 : TEMPORARY Record 290;
      PurchLine@1013 : TEMPORARY Record 39;
      DimSetEntry1@1014 : Record 480;
      DimSetEntry2@1015 : Record 480;
      RespCenter@1016 : Record 5714;
      Language@1017 : Record 8;
      CurrExchRate@1050 : Record 330;
      FormatAddr@1019 : Codeunit 365;
      FormatDocument@1056 : Codeunit 368;
      PurchPost@1020 : Codeunit 90;
      SegManagement@1010 : Codeunit 5051;
      VendAddr@1021 : ARRAY [8] OF Text[50];
      ShipToAddr@1022 : ARRAY [8] OF Text[50];
      CompanyAddr@1023 : ARRAY [8] OF Text[50];
      BuyFromAddr@1024 : ARRAY [8] OF Text[50];
      PurchaserText@1025 : Text[30];
      VATNoText@1026 : Text[80];
      ReferenceText@1027 : Text[80];
      TotalText@1028 : Text[50];
      TotalInclVATText@1029 : Text[50];
      TotalExclVATText@1030 : Text[50];
      MoreLines@1031 : Boolean;
      NoOfCopies@1032 : Integer;
      NoOfLoops@1033 : Integer;
      CopyText@1034 : Text[30];
      DimText@1035 : Text[120];
      OldDimText@1036 : Text[75];
      ShowInternalInfo@1037 : Boolean;
      Continue@1038 : Boolean;
      VATAmount@1039 : Decimal;
      VATBaseAmount@1042 : Decimal;
      VATDiscountAmount@1041 : Decimal;
      TotalAmountInclVAT@1040 : Decimal;
      LogInteraction@1009 : Boolean;
      VALVATBaseLCY@1046 : Decimal;
      VALVATAmountLCY@1045 : Decimal;
      VALSpecLCYHeader@1044 : Text[80];
      VALExchRate@1043 : Text[50];
      Text007@1049 : TextConst 'DAN="Momsbel�bsspecifikation i ";ENU="VAT Amount Specification in "';
      Text008@1048 : TextConst 'DAN=Lokal valuta;ENU=Local Currency';
      Text009@1047 : TextConst 'DAN=Valutakurs: %1/%2;ENU=Exchange rate: %1/%2';
      OutputNo@1051 : Integer;
      TypeInt@1052 : Integer;
      LogInteractionEnable@19003940 : Boolean INDATASET;
      DirectUnitCostCaptionLbl@6248 : TextConst 'DAN=K�bspris;ENU=Direct Unit Cost';
      AmtCaptionLbl@9683 : TextConst 'DAN=Bel�b;ENU=Amount';
      PurchLineInvDiscAmtCaptionLbl@7903 : TextConst 'DAN=Fakturarabatbel�b;ENU=Invoice Discount Amount';
      SubtotalCaptionLbl@1782 : TextConst 'DAN=Subtotal;ENU=Subtotal';
      VATDiscAmtCaptionLbl@9045 : TextConst 'DAN=Moms ved kontantrabat;ENU=Payment Discount on VAT';
      PhoneNoCaptionLbl@6169 : TextConst 'DAN=Telefon;ENU=Phone No.';
      VATRegNoCaptionLbl@2224 : TextConst 'DAN=SE/CVR-nr.;ENU=VAT Reg. No.';
      GiroNoCaptionLbl@7839 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      BankNameCaptionLbl@5585 : TextConst 'DAN=Bank;ENU=Bank';
      BankAccNoCaptionLbl@1535 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      ReturnOrderNoCaptionLbl@4670 : TextConst 'DAN=Returvareordrenr.;ENU=Return Order No.';
      DocumentDateCaptionLbl@7509 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      EmailCaptionLbl@7682 : TextConst 'DAN=Mail;ENU=Email';
      HomePageCaptionLbl@1436 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      HdrDimsCaptionLbl@2756 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      LineDimsCaptionLbl@6798 : TextConst 'DAN=Linjedimensioner;ENU=Line Dimensions';
      VATPercentCaptionLbl@6226 : TextConst 'DAN=Momspct.;ENU=VAT %';
      VATBaseCaptionLbl@5098 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATAmtCaptionLbl@8387 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VATAmtSpecCaptionLbl@3447 : TextConst 'DAN=Momsbel�bspecifikation;ENU=VAT Amount Specification';
      VATIdentifierCaptionLbl@6906 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      InvDiscBaseAmtCaptionLbl@2407 : TextConst 'DAN=Grundbel�b for fakturarabat;ENU=Invoice Discount Base Amount';
      LineAmtCaptionLbl@3126 : TextConst 'DAN=Linjebel�b;ENU=Line Amount';
      InvDisAmtCaptionLbl@1286 : TextConst 'DAN=Fakturarabatbel�b;ENU=Invoice Discount Amount';
      VATBaseCaption1Lbl@7419 : TextConst 'DAN=I alt;ENU=Total';
      ShiptoAddressCaptionLbl@8743 : TextConst 'DAN=Leveringsadresse;ENU=Ship-to Address';
      TotalSubTotal@1055 : Decimal;
      TotalAmount@1053 : Decimal;
      TotalInvoiceDiscountAmount@1054 : Decimal;
      DiscPercentCaptionLbl@1947 : TextConst 'DAN=Rabatpct.;ENU=Discount %';
      AllowInvoiceDiscCaptionLbl@2017 : TextConst 'DAN=Tillad fakturarabat;ENU=Allow Invoice Discount';
      VATIdentifierCaption1Lbl@6907 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      VATPctCaptionLbl@8044 : TextConst 'DAN=Momspct.;ENU=VAT %';
      VATBaseCaption2Lbl@6467 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATAmountCaptionLbl@4595 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      TotalCaption1Lbl@2351 : TextConst 'DAN=I alt;ENU=Total';

    LOCAL PROCEDURE IsReportInPreviewMode@8() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    LOCAL PROCEDURE InitLogInteraction@6();
    BEGIN
      LogInteraction := SegManagement.FindInteractTmplCode(22) <> '';
    END;

    LOCAL PROCEDURE FormatAddressFields@1(PurchaseHeader@1000 : Record 38);
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
        FormatDocument.SetPurchaser(SalesPurchPerson,"Purchaser Code",PurchaserText);

        ReferenceText := FormatDocument.SetText("Your Reference" <> '',FIELDCAPTION("Your Reference"));
        VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FIELDCAPTION("VAT Registration No."));
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
      <rd:DataSourceID>8eb86d8b-e6d2-4906-9a0b-69c0de7867b0</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="No_PurchHdr">
          <DataField>No_PurchHdr</DataField>
        </Field>
        <Field Name="DiscPercentCaption">
          <DataField>DiscPercentCaption</DataField>
        </Field>
        <Field Name="AllowInvoiceDiscCaption">
          <DataField>AllowInvoiceDiscCaption</DataField>
        </Field>
        <Field Name="VATIdentifierCaption1">
          <DataField>VATIdentifierCaption1</DataField>
        </Field>
        <Field Name="VATPctCaption">
          <DataField>VATPctCaption</DataField>
        </Field>
        <Field Name="VATBaseCaption2">
          <DataField>VATBaseCaption2</DataField>
        </Field>
        <Field Name="VATAmountCaption">
          <DataField>VATAmountCaption</DataField>
        </Field>
        <Field Name="TotalCaption1">
          <DataField>TotalCaption1</DataField>
        </Field>
        <Field Name="DirectUnitCostCaption">
          <DataField>DirectUnitCostCaption</DataField>
        </Field>
        <Field Name="AmtCaption">
          <DataField>AmtCaption</DataField>
        </Field>
        <Field Name="PurchLineInvDiscAmtCaption">
          <DataField>PurchLineInvDiscAmtCaption</DataField>
        </Field>
        <Field Name="SubtotalCaption">
          <DataField>SubtotalCaption</DataField>
        </Field>
        <Field Name="VATDiscAmtCaption">
          <DataField>VATDiscAmtCaption</DataField>
        </Field>
        <Field Name="TotalText">
          <DataField>TotalText</DataField>
        </Field>
        <Field Name="ReturnOrderCopyText">
          <DataField>ReturnOrderCopyText</DataField>
        </Field>
        <Field Name="CompanyAddr1">
          <DataField>CompanyAddr1</DataField>
        </Field>
        <Field Name="CompanyAddr2">
          <DataField>CompanyAddr2</DataField>
        </Field>
        <Field Name="CompanyAddr3">
          <DataField>CompanyAddr3</DataField>
        </Field>
        <Field Name="CompanyAddr4">
          <DataField>CompanyAddr4</DataField>
        </Field>
        <Field Name="CompanyInfoPhoneNo">
          <DataField>CompanyInfoPhoneNo</DataField>
        </Field>
        <Field Name="CompanyInfoHomePage">
          <DataField>CompanyInfoHomePage</DataField>
        </Field>
        <Field Name="CompanyInfoEmail">
          <DataField>CompanyInfoEmail</DataField>
        </Field>
        <Field Name="CompanyInfoVATRegNo">
          <DataField>CompanyInfoVATRegNo</DataField>
        </Field>
        <Field Name="CompanyInfoGiroNo">
          <DataField>CompanyInfoGiroNo</DataField>
        </Field>
        <Field Name="CompanyInfoBankName">
          <DataField>CompanyInfoBankName</DataField>
        </Field>
        <Field Name="CompanyInfoBankAccountNo">
          <DataField>CompanyInfoBankAccountNo</DataField>
        </Field>
        <Field Name="DocumentDate_PurchHdr">
          <DataField>DocumentDate_PurchHdr</DataField>
        </Field>
        <Field Name="VATNoText">
          <DataField>VATNoText</DataField>
        </Field>
        <Field Name="VATRegNo_PurchHdr">
          <DataField>VATRegNo_PurchHdr</DataField>
        </Field>
        <Field Name="PurchaserText">
          <DataField>PurchaserText</DataField>
        </Field>
        <Field Name="SalesPurchPersonName">
          <DataField>SalesPurchPersonName</DataField>
        </Field>
        <Field Name="No1_PurchHdr">
          <DataField>No1_PurchHdr</DataField>
        </Field>
        <Field Name="ReferenceText">
          <DataField>ReferenceText</DataField>
        </Field>
        <Field Name="yourReference_PurchHdr">
          <DataField>yourReference_PurchHdr</DataField>
        </Field>
        <Field Name="CompanyAddr5">
          <DataField>CompanyAddr5</DataField>
        </Field>
        <Field Name="CompanyAddr6">
          <DataField>CompanyAddr6</DataField>
        </Field>
        <Field Name="BuyfromVendNo_PurchHdr">
          <DataField>BuyfromVendNo_PurchHdr</DataField>
        </Field>
        <Field Name="BuyFromAddr1">
          <DataField>BuyFromAddr1</DataField>
        </Field>
        <Field Name="BuyFromAddr2">
          <DataField>BuyFromAddr2</DataField>
        </Field>
        <Field Name="BuyFromAddr3">
          <DataField>BuyFromAddr3</DataField>
        </Field>
        <Field Name="BuyFromAddr4">
          <DataField>BuyFromAddr4</DataField>
        </Field>
        <Field Name="BuyFromAddr5">
          <DataField>BuyFromAddr5</DataField>
        </Field>
        <Field Name="BuyFromAddr6">
          <DataField>BuyFromAddr6</DataField>
        </Field>
        <Field Name="BuyFromAddr7">
          <DataField>BuyFromAddr7</DataField>
        </Field>
        <Field Name="BuyFromAddr8">
          <DataField>BuyFromAddr8</DataField>
        </Field>
        <Field Name="PricesIncVAT_PurchHdr">
          <DataField>PricesIncVAT_PurchHdr</DataField>
        </Field>
        <Field Name="PrsInclVATYesNo_PurchHdr">
          <DataField>PrsInclVATYesNo_PurchHdr</DataField>
        </Field>
        <Field Name="OutputNo">
          <DataField>OutputNo</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="PhoneNoCaption">
          <DataField>PhoneNoCaption</DataField>
        </Field>
        <Field Name="VATRegNoCaption">
          <DataField>VATRegNoCaption</DataField>
        </Field>
        <Field Name="GiroNoCaption">
          <DataField>GiroNoCaption</DataField>
        </Field>
        <Field Name="BankNameCaption">
          <DataField>BankNameCaption</DataField>
        </Field>
        <Field Name="BankAccNoCaption">
          <DataField>BankAccNoCaption</DataField>
        </Field>
        <Field Name="ReturnOrderNoCaption">
          <DataField>ReturnOrderNoCaption</DataField>
        </Field>
        <Field Name="DocumentDateCaption">
          <DataField>DocumentDateCaption</DataField>
        </Field>
        <Field Name="EmailCaption">
          <DataField>EmailCaption</DataField>
        </Field>
        <Field Name="HomePageCaption">
          <DataField>HomePageCaption</DataField>
        </Field>
        <Field Name="BuyfromVendNo_PurchHdrCaption">
          <DataField>BuyfromVendNo_PurchHdrCaption</DataField>
        </Field>
        <Field Name="PricesIncVAT_PurchHdrCaption">
          <DataField>PricesIncVAT_PurchHdrCaption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="DimensionLoop1Number">
          <DataField>DimensionLoop1Number</DataField>
        </Field>
        <Field Name="HdrDimsCaption">
          <DataField>HdrDimsCaption</DataField>
        </Field>
        <Field Name="TypeInt">
          <DataField>TypeInt</DataField>
        </Field>
        <Field Name="LineAmt_PurchLine">
          <DataField>LineAmt_PurchLine</DataField>
        </Field>
        <Field Name="LineAmt_PurchLineFormat">
          <DataField>LineAmt_PurchLineFormat</DataField>
        </Field>
        <Field Name="Description_PurchLine">
          <DataField>Description_PurchLine</DataField>
        </Field>
        <Field Name="Description_PurchLineCaption">
          <DataField>Description_PurchLineCaption</DataField>
        </Field>
        <Field Name="No_PurchLine">
          <DataField>No_PurchLine</DataField>
        </Field>
        <Field Name="No_PurchLineCaption">
          <DataField>No_PurchLineCaption</DataField>
        </Field>
        <Field Name="Quantity_PurchLine">
          <DataField>Quantity_PurchLine</DataField>
        </Field>
        <Field Name="Quantity_PurchLineFormat">
          <DataField>Quantity_PurchLineFormat</DataField>
        </Field>
        <Field Name="Quantity_PurchLineCaption">
          <DataField>Quantity_PurchLineCaption</DataField>
        </Field>
        <Field Name="UnitofMeasure_PurchLine">
          <DataField>UnitofMeasure_PurchLine</DataField>
        </Field>
        <Field Name="UnitofMeasure_PurchLineCaption">
          <DataField>UnitofMeasure_PurchLineCaption</DataField>
        </Field>
        <Field Name="DirectUnitCost_PurchLine">
          <DataField>DirectUnitCost_PurchLine</DataField>
        </Field>
        <Field Name="DirectUnitCost_PurchLineFormat">
          <DataField>DirectUnitCost_PurchLineFormat</DataField>
        </Field>
        <Field Name="LineDiscount_PurchLine">
          <DataField>LineDiscount_PurchLine</DataField>
        </Field>
        <Field Name="LineDiscount_PurchLineFormat">
          <DataField>LineDiscount_PurchLineFormat</DataField>
        </Field>
        <Field Name="AllowInvDisc_PurchLine">
          <DataField>AllowInvDisc_PurchLine</DataField>
        </Field>
        <Field Name="VATIdentifier_PurchLine">
          <DataField>VATIdentifier_PurchLine</DataField>
        </Field>
        <Field Name="VATIdentifier_PurchLineCaption">
          <DataField>VATIdentifier_PurchLineCaption</DataField>
        </Field>
        <Field Name="AllInvDiscYesNo_PurchLine">
          <DataField>AllInvDiscYesNo_PurchLine</DataField>
        </Field>
        <Field Name="PurchLineInvDiscountAmt">
          <DataField>PurchLineInvDiscountAmt</DataField>
        </Field>
        <Field Name="PurchLineInvDiscountAmtFormat">
          <DataField>PurchLineInvDiscountAmtFormat</DataField>
        </Field>
        <Field Name="PurchLineLnAmtInvDiscAmt">
          <DataField>PurchLineLnAmtInvDiscAmt</DataField>
        </Field>
        <Field Name="PurchLineLnAmtInvDiscAmtFormat">
          <DataField>PurchLineLnAmtInvDiscAmtFormat</DataField>
        </Field>
        <Field Name="TotalInclVATText">
          <DataField>TotalInclVATText</DataField>
        </Field>
        <Field Name="TotalSubTotal">
          <DataField>TotalSubTotal</DataField>
        </Field>
        <Field Name="TotalSubTotalFormat">
          <DataField>TotalSubTotalFormat</DataField>
        </Field>
        <Field Name="TotalInvoiceDiscountAmount">
          <DataField>TotalInvoiceDiscountAmount</DataField>
        </Field>
        <Field Name="TotalInvoiceDiscountAmountFormat">
          <DataField>TotalInvoiceDiscountAmountFormat</DataField>
        </Field>
        <Field Name="TotalAmount">
          <DataField>TotalAmount</DataField>
        </Field>
        <Field Name="TotalAmountFormat">
          <DataField>TotalAmountFormat</DataField>
        </Field>
        <Field Name="VATAmtLineVATAmtText">
          <DataField>VATAmtLineVATAmtText</DataField>
        </Field>
        <Field Name="VATAmt">
          <DataField>VATAmt</DataField>
        </Field>
        <Field Name="VATAmtFormat">
          <DataField>VATAmtFormat</DataField>
        </Field>
        <Field Name="PurchLnLnAmtInvDiscAmtVATAmt">
          <DataField>PurchLnLnAmtInvDiscAmtVATAmt</DataField>
        </Field>
        <Field Name="PurchLnLnAmtInvDiscAmtVATAmtFormat">
          <DataField>PurchLnLnAmtInvDiscAmtVATAmtFormat</DataField>
        </Field>
        <Field Name="TotalExclVATText">
          <DataField>TotalExclVATText</DataField>
        </Field>
        <Field Name="VATDiscountAmt">
          <DataField>VATDiscountAmt</DataField>
        </Field>
        <Field Name="VATDiscountAmtFormat">
          <DataField>VATDiscountAmtFormat</DataField>
        </Field>
        <Field Name="VATBaseDisc_PurchHdr">
          <DataField>VATBaseDisc_PurchHdr</DataField>
        </Field>
        <Field Name="VATBaseDisc_PurchHdrFormat">
          <DataField>VATBaseDisc_PurchHdrFormat</DataField>
        </Field>
        <Field Name="VATBaseAmt">
          <DataField>VATBaseAmt</DataField>
        </Field>
        <Field Name="VATBaseAmtFormat">
          <DataField>VATBaseAmtFormat</DataField>
        </Field>
        <Field Name="TotalAmtInclVAT">
          <DataField>TotalAmtInclVAT</DataField>
        </Field>
        <Field Name="TotalAmtInclVATFormat">
          <DataField>TotalAmtInclVATFormat</DataField>
        </Field>
        <Field Name="AllowInvDisc_PurchLineCaption">
          <DataField>AllowInvDisc_PurchLineCaption</DataField>
        </Field>
        <Field Name="DimText1">
          <DataField>DimText1</DataField>
        </Field>
        <Field Name="DimensionLoop2Number">
          <DataField>DimensionLoop2Number</DataField>
        </Field>
        <Field Name="LineDimsCaption">
          <DataField>LineDimsCaption</DataField>
        </Field>
        <Field Name="VATAmtLineVATBase">
          <DataField>VATAmtLineVATBase</DataField>
        </Field>
        <Field Name="VATAmtLineVATBaseFormat">
          <DataField>VATAmtLineVATBaseFormat</DataField>
        </Field>
        <Field Name="VATAmtLineVATAmt">
          <DataField>VATAmtLineVATAmt</DataField>
        </Field>
        <Field Name="VATAmtLineVATAmtFormat">
          <DataField>VATAmtLineVATAmtFormat</DataField>
        </Field>
        <Field Name="VATAmtLineLineAmt">
          <DataField>VATAmtLineLineAmt</DataField>
        </Field>
        <Field Name="VATAmtLineLineAmtFormat">
          <DataField>VATAmtLineLineAmtFormat</DataField>
        </Field>
        <Field Name="VATAmtLineInvDiscBaseAmt">
          <DataField>VATAmtLineInvDiscBaseAmt</DataField>
        </Field>
        <Field Name="VATAmtLineInvDiscBaseAmtFormat">
          <DataField>VATAmtLineInvDiscBaseAmtFormat</DataField>
        </Field>
        <Field Name="VATAmtLineInvDiscAmt">
          <DataField>VATAmtLineInvDiscAmt</DataField>
        </Field>
        <Field Name="VATAmtLineInvDiscAmtFormat">
          <DataField>VATAmtLineInvDiscAmtFormat</DataField>
        </Field>
        <Field Name="VATAmtLineVAT">
          <DataField>VATAmtLineVAT</DataField>
        </Field>
        <Field Name="VATAmtLineVATFormat">
          <DataField>VATAmtLineVATFormat</DataField>
        </Field>
        <Field Name="VATAmtLineVATIdentifier">
          <DataField>VATAmtLineVATIdentifier</DataField>
        </Field>
        <Field Name="VATPercentCaption">
          <DataField>VATPercentCaption</DataField>
        </Field>
        <Field Name="VATBaseCaption">
          <DataField>VATBaseCaption</DataField>
        </Field>
        <Field Name="VATAmtCaption">
          <DataField>VATAmtCaption</DataField>
        </Field>
        <Field Name="VATAmtSpecCaption">
          <DataField>VATAmtSpecCaption</DataField>
        </Field>
        <Field Name="VATIdentifierCaption">
          <DataField>VATIdentifierCaption</DataField>
        </Field>
        <Field Name="InvDiscBaseAmtCaption">
          <DataField>InvDiscBaseAmtCaption</DataField>
        </Field>
        <Field Name="LineAmtCaption">
          <DataField>LineAmtCaption</DataField>
        </Field>
        <Field Name="InvDisAmtCaption">
          <DataField>InvDisAmtCaption</DataField>
        </Field>
        <Field Name="VATBaseCaption1">
          <DataField>VATBaseCaption1</DataField>
        </Field>
        <Field Name="VALExchRate">
          <DataField>VALExchRate</DataField>
        </Field>
        <Field Name="VALSpecLCYHdr">
          <DataField>VALSpecLCYHdr</DataField>
        </Field>
        <Field Name="VALVATAmtLCY">
          <DataField>VALVATAmtLCY</DataField>
        </Field>
        <Field Name="VALVATAmtLCYFormat">
          <DataField>VALVATAmtLCYFormat</DataField>
        </Field>
        <Field Name="VALVATBaseLCY">
          <DataField>VALVATBaseLCY</DataField>
        </Field>
        <Field Name="VALVATBaseLCYFormat">
          <DataField>VALVATBaseLCYFormat</DataField>
        </Field>
        <Field Name="VATAmtLineVAT1">
          <DataField>VATAmtLineVAT1</DataField>
        </Field>
        <Field Name="VATAmtLineVAT1Format">
          <DataField>VATAmtLineVAT1Format</DataField>
        </Field>
        <Field Name="VATAmtLineVATIdentifier1">
          <DataField>VATAmtLineVATIdentifier1</DataField>
        </Field>
        <Field Name="SelltoCustNo_PurchHdr">
          <DataField>SelltoCustNo_PurchHdr</DataField>
        </Field>
        <Field Name="ShipToAddr1">
          <DataField>ShipToAddr1</DataField>
        </Field>
        <Field Name="ShipToAddr2">
          <DataField>ShipToAddr2</DataField>
        </Field>
        <Field Name="ShipToAddr3">
          <DataField>ShipToAddr3</DataField>
        </Field>
        <Field Name="ShipToAddr4">
          <DataField>ShipToAddr4</DataField>
        </Field>
        <Field Name="ShipToAddr5">
          <DataField>ShipToAddr5</DataField>
        </Field>
        <Field Name="ShipToAddr6">
          <DataField>ShipToAddr6</DataField>
        </Field>
        <Field Name="ShipToAddr7">
          <DataField>ShipToAddr7</DataField>
        </Field>
        <Field Name="ShipToAddr8">
          <DataField>ShipToAddr8</DataField>
        </Field>
        <Field Name="ShiptoAddressCaption">
          <DataField>ShiptoAddressCaption</DataField>
        </Field>
        <Field Name="SelltoCustNo_PurchHdrCaption">
          <DataField>SelltoCustNo_PurchHdrCaption</DataField>
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
          <Tablix Name="list1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>7.13105in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>8.05484in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="tableHeaderDim">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.22651in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>5.90056in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.25in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox219">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>Textbox219</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox32">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!HdrDimsCaption.Value</Value>
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
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox33">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText.Value</Value>
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
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox34">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox89">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText.Value</Value>
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
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table3_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!DimensionLoop1Number.Value=1,False,True)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!DimensionLoop1Number.Value&gt;1,False,True)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!DimensionLoop1Number.Value</FilterExpression>
                                  <Operator>GreaterThanOrEqual</Operator>
                                  <FilterValues>
                                    <FilterValue>=1</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>541.94849pt</Top>
                              <Left>0pt</Left>
                              <Height>1.34056cm</Height>
                              <Width>18.10276cm</Width>
                              <Style />
                            </Tablix>
                            <Tablix Name="tableShipToAddr">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.25105in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.87599in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.25in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox222">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox222</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox48">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShiptoAddressCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox51">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SelltoCustNo_PurchHdrCaption.Value</Value>
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
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox52">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SelltoCustNo_PurchHdr.Value</Value>
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
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox566">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox56</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox60">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox60</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox78">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr1.Value</Value>
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
                                            <rd:DefaultName>textbox78</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox79">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox79</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox50">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr2.Value</Value>
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
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox767">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox76</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox75">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr3.Value</Value>
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
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox68">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox68</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox67">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr4.Value</Value>
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
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox74">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox74</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox73">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr5.Value</Value>
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
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox72">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox72</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox71">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr6.Value</Value>
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
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox70">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox70</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox69">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr7.Value</Value>
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
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox66">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox66</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox618">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr8.Value</Value>
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
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox55">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                    <KeepWithGroup>After</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table5_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember />
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!SelltoCustNo_PurchHdr.Value&lt;&gt;"",false,true)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!SelltoCustNo_PurchHdr.Value&lt;&gt;"",false,true)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr1.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr2.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr3.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr4.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr5.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr6.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr7.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShipToAddr8.Value="",True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!ShiptoAddressCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>14.52358cm</Top>
                              <Left>0pt</Left>
                              <Height>1.77779in</Height>
                              <Width>18.10268cm</Width>
                              <ZIndex>1</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="table2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.15104in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.19618in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="BuyFromAddr">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Cstr(Fields!BuyFromAddr1.Value) + Chr(177) + 
Cstr(Fields!BuyFromAddr2.Value) + Chr(177) + 
Cstr(Fields!BuyFromAddr3.Value) + Chr(177) + 
Cstr(Fields!BuyFromAddr4.Value) + Chr(177) + 
Cstr(Fields!BuyFromAddr5.Value) + Chr(177) + 
Cstr(Fields!BuyFromAddr6.Value) + Chr(177) + 
Cstr(Fields!BuyFromAddr7.Value) + Chr(177) + 
Cstr(Fields!BuyFromAddr8.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr1.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr2.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr3.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr4.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr5.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr6.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoPhoneNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoVATRegNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoGiroNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankName.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankAccountNo.Value) + Chr(177) + 
Cstr(Fields!ReturnOrderCopyText.Value) + Chr(177) + 
Cstr(Fields!DocumentDate_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!No1_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!PrsInclVATYesNo_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!BuyfromVendNo_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!VATRegNo_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!SalesPurchPersonName.Value) + Chr(177) + 
Cstr(Fields!yourReference_PurchHdr.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoHomePage.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoEmail.Value) + Chr(177) + 
Cstr(Fields!PricesIncVAT_PurchHdrCaption.Value) + Chr(177) + 
Cstr(Fields!BuyfromVendNo_PurchHdrCaption.Value) + Chr(177) + 
Cstr(Fields!ReturnOrderNoCaption.Value) + Chr(177) + 
Cstr(Fields!BankAccNoCaption.Value) + Chr(177) + 
Cstr(Fields!BankNameCaption.Value) + Chr(177) + 
Cstr(Fields!GiroNoCaption.Value) + Chr(177) + 
Cstr(Fields!VATRegNoCaption.Value) + Chr(177) + 
Cstr(Fields!PhoneNoCaption.Value) + Chr(177) + 
Cstr(Fields!ReferenceText.Value) + Chr(177) + 
Cstr(Fields!PurchaserText.Value) + Chr(177) + 
Cstr(Fields!PageCaption.Value) + Chr(177) + 
Cstr(Fields!OutputNo.Value) + Chr(177) + 
Cstr(Fields!VATNoText.Value) + Chr(177) + 
Cstr(Fields!DocumentDateCaption.Value) + Chr(177) + 
Cstr(Fields!HomePageCaption.Value) + Chr(177) + 
Cstr(Fields!EmailCaption.Value)
, 1)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="NewPage">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=IIF(Code.IsNewPage(),TRUE,FALSE)</Value>
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Height>0.35278cm</Height>
                              <Width>0.88194cm</Width>
                              <ZIndex>2</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="tablePurchLine">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.89989in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.34063in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.60368in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.60368in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.8449in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.73622in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.74984in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.67164in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.68057in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox27">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!No_PurchLineCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>157</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox29">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!Description_PurchLineCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>156</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox30">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Quantity_PurchLineCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>155</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox31">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!UnitofMeasure_PurchLineCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>154</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox5">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=FIRST( Fields!DirectUnitCostCaption.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox5</rd:DefaultName>
                                            <ZIndex>153</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox42">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DiscPercentCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox42</rd:DefaultName>
                                            <ZIndex>152</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox53">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AllowInvoiceDiscCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox53</rd:DefaultName>
                                            <ZIndex>151</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox64">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!VATIdentifier_PurchLineCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox64</rd:DefaultName>
                                            <ZIndex>150</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox86">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!AmtCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox86</rd:DefaultName>
                                            <ZIndex>149</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox465">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox465</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>9</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox456">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox456</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>9</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox6">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox6</rd:DefaultName>
                                            <ZIndex>133</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox8">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_PurchLine.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox8</rd:DefaultName>
                                            <ZIndex>132</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox43">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox43</rd:DefaultName>
                                            <ZIndex>131</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox54">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox54</rd:DefaultName>
                                            <ZIndex>130</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox65">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox65</rd:DefaultName>
                                            <ZIndex>129</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox87">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox87</rd:DefaultName>
                                            <ZIndex>128</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox9">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_PurchLine.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox9</rd:DefaultName>
                                            <ZIndex>127</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox10">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_PurchLine.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox10</rd:DefaultName>
                                            <ZIndex>126</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox11">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Quantity_PurchLine.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!Quantity_PurchLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox11</rd:DefaultName>
                                            <ZIndex>125</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox12">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UnitofMeasure_PurchLine.Value</Value>
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
                                            <rd:DefaultName>textbox12</rd:DefaultName>
                                            <ZIndex>124</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox13">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!DirectUnitCost_PurchLine.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!DirectUnitCost_PurchLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox13</rd:DefaultName>
                                            <ZIndex>123</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox14">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!LineDiscount_PurchLine.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!LineDiscount_PurchLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox14</rd:DefaultName>
                                            <ZIndex>122</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox15">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AllInvDiscYesNo_PurchLine.Value</Value>
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
                                            <rd:DefaultName>textbox15</rd:DefaultName>
                                            <ZIndex>121</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox16">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifier_PurchLine.Value</Value>
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
                                            <rd:DefaultName>textbox16</rd:DefaultName>
                                            <ZIndex>120</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox17">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!LineAmt_PurchLine.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!LineAmt_PurchLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox17</rd:DefaultName>
                                            <ZIndex>119</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineDimsCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox1</rd:DefaultName>
                                            <ZIndex>118</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox4">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText1.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox4</rd:DefaultName>
                                            <ZIndex>117</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>8</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox18">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineDimsCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox25">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText1.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox25</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>8</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox36">
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
                                            <rd:DefaultName>textbox36</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox37">
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
                                            <rd:DefaultName>textbox37</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox38">
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
                                            <rd:DefaultName>textbox38</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox39">
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
                                            <rd:DefaultName>textbox39</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox40">
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
                                            <rd:DefaultName>textbox40</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox411">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox41</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox62">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox62</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox912">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox91</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox100">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!LineAmt_PurchLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox100</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox182">
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
                                            <rd:DefaultName>Textbox182</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>8</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox217">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox217</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox47">
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
                                            <rd:DefaultName>textbox47</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox49">
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
                                            <rd:DefaultName>textbox49</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox57">
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
                                            <rd:DefaultName>textbox57</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox58">
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
                                            <rd:DefaultName>textbox58</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox59">
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
                                            <rd:DefaultName>textbox59</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox46">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SubtotalCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox127">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=LAST(Fields!TotalSubTotal.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!LineAmt_PurchLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox83">
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
                                            <rd:DefaultName>textbox83</rd:DefaultName>
                                            <ZIndex>24</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox84">
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
                                            <rd:DefaultName>textbox84</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox85">
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
                                            <rd:DefaultName>textbox85</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox88">
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
                                            <rd:DefaultName>textbox88</rd:DefaultName>
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox90">
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
                                            <rd:DefaultName>textbox90</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox82">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PurchLineInvDiscAmtCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox128">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=lAST(Fields!TotalInvoiceDiscountAmount.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!PurchLineInvDiscountAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>18</ZIndex>
                                            <Visibility>
                                              <Hidden>=iif(Fields!PurchLineInvDiscountAmt.Value&lt;&gt;0,false,true)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox161">
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
                                            <rd:DefaultName>Textbox161</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox162">
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
                                            <rd:DefaultName>Textbox162</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox166">
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
                                            <rd:DefaultName>Textbox166</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox187">
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
                                            <rd:DefaultName>Textbox187</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox188">
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
                                            <rd:DefaultName>Textbox188</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox189">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox189</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox190">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox190</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox191">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox191</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox192">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox192</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox193">
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
                                            <rd:DefaultName>Textbox193</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox194">
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
                                            <rd:DefaultName>Textbox194</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox195">
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
                                            <rd:DefaultName>Textbox195</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox196">
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
                                            <rd:DefaultName>Textbox196</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox197">
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
                                            <rd:DefaultName>Textbox197</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox198">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox198</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="Textbox210">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox210</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox95">
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
                                            <rd:DefaultName>textbox95</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox96">
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
                                            <rd:DefaultName>textbox96</rd:DefaultName>
                                            <ZIndex>30</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox97">
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
                                            <rd:DefaultName>textbox97</rd:DefaultName>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox98">
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
                                            <rd:DefaultName>textbox98</rd:DefaultName>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox99">
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
                                            <rd:DefaultName>textbox99</rd:DefaultName>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox94">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!TotalText.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>26</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox129">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!PurchLineLnAmtInvDiscAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>25</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox44">
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
                                            <rd:DefaultName>textbox44</rd:DefaultName>
                                            <ZIndex>40</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox45">
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
                                            <rd:DefaultName>textbox45</rd:DefaultName>
                                            <ZIndex>39</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox63">
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
                                            <rd:DefaultName>textbox63</rd:DefaultName>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox77">
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
                                            <rd:DefaultName>textbox77</rd:DefaultName>
                                            <ZIndex>37</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox92">
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
                                            <rd:DefaultName>textbox92</rd:DefaultName>
                                            <ZIndex>36</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox93">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox93</rd:DefaultName>
                                            <ZIndex>35</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1213">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox121</rd:DefaultName>
                                            <ZIndex>34</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox123">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox123</rd:DefaultName>
                                            <ZIndex>33</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox125">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!PurchLineLnAmtInvDiscAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox125</rd:DefaultName>
                                            <ZIndex>32</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox107">
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
                                            <rd:DefaultName>textbox107</rd:DefaultName>
                                            <ZIndex>47</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox108">
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
                                            <rd:DefaultName>textbox108</rd:DefaultName>
                                            <ZIndex>46</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox109">
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
                                            <rd:DefaultName>textbox109</rd:DefaultName>
                                            <ZIndex>45</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox110">
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
                                            <rd:DefaultName>textbox110</rd:DefaultName>
                                            <ZIndex>44</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1114">
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
                                            <rd:DefaultName>textbox111</rd:DefaultName>
                                            <ZIndex>43</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox106">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalExclVATText.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>42</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox130">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!PurchLineLnAmtInvDiscAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>41</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox116">
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
                                            <rd:DefaultName>textbox116</rd:DefaultName>
                                            <ZIndex>54</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox117">
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
                                            <rd:DefaultName>textbox117</rd:DefaultName>
                                            <ZIndex>53</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox118">
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
                                            <rd:DefaultName>textbox118</rd:DefaultName>
                                            <ZIndex>52</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox119">
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
                                            <rd:DefaultName>textbox119</rd:DefaultName>
                                            <ZIndex>51</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox120">
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
                                            <rd:DefaultName>textbox120</rd:DefaultName>
                                            <ZIndex>50</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox112">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATAmtText.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox112</rd:DefaultName>
                                            <ZIndex>49</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox115">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmt.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox115</rd:DefaultName>
                                            <ZIndex>48</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox138">
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
                                            <rd:DefaultName>Textbox138</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox139">
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
                                            <rd:DefaultName>Textbox139</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox140">
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
                                            <rd:DefaultName>Textbox140</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox141">
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
                                            <rd:DefaultName>Textbox141</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox143">
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
                                            <rd:DefaultName>Textbox143</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox144">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox144</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox146">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox146</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox147">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox147</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox148">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox148</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox150">
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
                                            <rd:DefaultName>Textbox150</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox151">
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
                                            <rd:DefaultName>Textbox151</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox152">
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
                                            <rd:DefaultName>Textbox152</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox154">
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
                                            <rd:DefaultName>Textbox154</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox155">
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
                                            <rd:DefaultName>Textbox155</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox156">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox156</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="Textbox159">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox159</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox104">
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
                                            <rd:DefaultName>textbox104</rd:DefaultName>
                                            <ZIndex>61</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox105">
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
                                            <rd:DefaultName>textbox105</rd:DefaultName>
                                            <ZIndex>60</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox113">
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
                                            <rd:DefaultName>textbox113</rd:DefaultName>
                                            <ZIndex>59</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox114">
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
                                            <rd:DefaultName>textbox114</rd:DefaultName>
                                            <ZIndex>58</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox122">
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
                                            <rd:DefaultName>textbox122</rd:DefaultName>
                                            <ZIndex>57</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox124">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalInclVATText.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>56</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox1315">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=sum(Fields!PurchLineLnAmtInvDiscAmt.Value) + Fields!VATAmt.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!PurchLnLnAmtInvDiscAmtVATAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>55</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox320">
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
                                            <rd:DefaultName>textbox320</rd:DefaultName>
                                            <ZIndex>70</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox321">
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
                                            <rd:DefaultName>textbox321</rd:DefaultName>
                                            <ZIndex>69</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox322">
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
                                            <rd:DefaultName>textbox322</rd:DefaultName>
                                            <ZIndex>68</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox323">
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
                                            <rd:DefaultName>textbox323</rd:DefaultName>
                                            <ZIndex>67</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox328">
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
                                            <rd:DefaultName>textbox328</rd:DefaultName>
                                            <ZIndex>66</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox329">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox329</rd:DefaultName>
                                            <ZIndex>65</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox330">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox330</rd:DefaultName>
                                            <ZIndex>64</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox331">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
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
                                            <rd:DefaultName>textbox331</rd:DefaultName>
                                            <ZIndex>63</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox332">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATDiscountAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox332</rd:DefaultName>
                                            <ZIndex>62</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox270">
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
                                            <rd:DefaultName>textbox270</rd:DefaultName>
                                            <ZIndex>77</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox271">
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
                                            <rd:DefaultName>textbox271</rd:DefaultName>
                                            <ZIndex>76</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox272">
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
                                            <rd:DefaultName>textbox272</rd:DefaultName>
                                            <ZIndex>75</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox318">
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
                                            <rd:DefaultName>textbox318</rd:DefaultName>
                                            <ZIndex>74</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox319">
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
                                            <rd:DefaultName>textbox319</rd:DefaultName>
                                            <ZIndex>73</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox136">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATDiscAmtCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>72</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox327">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATDiscountAmt.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATDiscountAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>71</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox21</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox22</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox23</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox24</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox26</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                      <FontStyle>Normal</FontStyle>
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
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                      <FontStyle>Normal</FontStyle>
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
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                      <FontStyle>Normal</FontStyle>
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
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox56</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox61">
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
                                            <rd:DefaultName>Textbox61</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox76">
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
                                            <rd:DefaultName>Textbox76</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox81">
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
                                            <rd:DefaultName>Textbox81</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox91">
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
                                            <rd:DefaultName>Textbox91</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox101">
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
                                            <rd:DefaultName>Textbox101</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox102">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox102</rd:DefaultName>
                                            <Style>
                                              <Border />
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="Textbox121">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox121</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox264">
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
                                            <rd:DefaultName>textbox264</rd:DefaultName>
                                            <ZIndex>84</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox265">
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
                                            <rd:DefaultName>textbox265</rd:DefaultName>
                                            <ZIndex>83</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox266">
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
                                            <rd:DefaultName>textbox266</rd:DefaultName>
                                            <ZIndex>82</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox267">
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
                                            <rd:DefaultName>textbox267</rd:DefaultName>
                                            <ZIndex>81</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox268">
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
                                            <rd:DefaultName>textbox268</rd:DefaultName>
                                            <ZIndex>80</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox142">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalInclVATText.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox142</rd:DefaultName>
                                            <ZIndex>79</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox145">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalAmtInclVAT.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalAmtInclVATFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox145</rd:DefaultName>
                                            <ZIndex>78</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox279">
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
                                            <rd:DefaultName>textbox279</rd:DefaultName>
                                            <ZIndex>93</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox280">
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
                                            <rd:DefaultName>textbox280</rd:DefaultName>
                                            <ZIndex>92</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox281">
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
                                            <rd:DefaultName>textbox281</rd:DefaultName>
                                            <ZIndex>91</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox282">
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
                                            <rd:DefaultName>textbox282</rd:DefaultName>
                                            <ZIndex>90</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox283">
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
                                            <rd:DefaultName>textbox283</rd:DefaultName>
                                            <ZIndex>89</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox284">
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
                                            <rd:DefaultName>textbox284</rd:DefaultName>
                                            <ZIndex>88</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox285">
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
                                            <rd:DefaultName>textbox285</rd:DefaultName>
                                            <ZIndex>87</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox286">
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
                                            <rd:DefaultName>textbox286</rd:DefaultName>
                                            <ZIndex>86</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox287">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox287</rd:DefaultName>
                                            <ZIndex>85</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox288">
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
                                            <rd:DefaultName>textbox288</rd:DefaultName>
                                            <ZIndex>100</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox289">
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
                                            <rd:DefaultName>textbox289</rd:DefaultName>
                                            <ZIndex>99</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox290">
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
                                            <rd:DefaultName>textbox290</rd:DefaultName>
                                            <ZIndex>98</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox291">
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
                                            <rd:DefaultName>textbox291</rd:DefaultName>
                                            <ZIndex>97</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox292">
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
                                            <rd:DefaultName>textbox292</rd:DefaultName>
                                            <ZIndex>96</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox149">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATAmtText.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox149</rd:DefaultName>
                                            <ZIndex>95</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox153">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmt.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox153</rd:DefaultName>
                                            <ZIndex>94</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox297">
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
                                            <rd:DefaultName>textbox297</rd:DefaultName>
                                            <ZIndex>107</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox298">
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
                                            <rd:DefaultName>textbox298</rd:DefaultName>
                                            <ZIndex>106</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox299">
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
                                            <rd:DefaultName>textbox299</rd:DefaultName>
                                            <ZIndex>105</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox300">
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
                                            <rd:DefaultName>textbox300</rd:DefaultName>
                                            <ZIndex>104</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox301">
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
                                            <rd:DefaultName>textbox301</rd:DefaultName>
                                            <ZIndex>103</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox160">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalExclVATText.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox160</rd:DefaultName>
                                            <ZIndex>102</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox163">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBaseAmt.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATBaseAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox163</rd:DefaultName>
                                            <ZIndex>101</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table1_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!TypeInt.Value = 0,False,True)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= Fields!TypeInt.Value =0</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!DimensionLoop2Number.Value=1,false,true)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!DimensionLoop2Number.Value &gt; 1,false,true)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PurchLineInvDiscountAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PurchLineInvDiscountAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PurchLineInvDiscountAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PurchLineInvDiscountAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value=0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value=0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value=0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value&lt;&gt;0 and not(Fields!PricesIncVAT_PurchHdr.Value),false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value&lt;&gt;0 and not(Fields!PricesIncVAT_PurchHdr.Value),false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value&lt;&gt;0 and not(Fields!PricesIncVAT_PurchHdr.Value),false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value&lt;&gt;0 and not(Fields!PricesIncVAT_PurchHdr.Value),false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value&lt;&gt;0 and not(Fields!PricesIncVAT_PurchHdr.Value),false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value&lt;&gt;0 and not(Fields!PricesIncVAT_PurchHdr.Value),false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!VATAmt.Value&lt;&gt;0 and not(Fields!PricesIncVAT_PurchHdr.Value),false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif((Fields!VATDiscountAmt.Value&lt;&gt;0 and Fields!VATAmt.Value&lt;&gt;0) and Fields!PricesIncVAT_PurchHdr.Value and Fields!VATBaseDisc_PurchHdr.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PricesIncVAT_PurchHdr.Value and Fields!VATAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PricesIncVAT_PurchHdr.Value and Fields!VATAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PricesIncVAT_PurchHdr.Value and Fields!VATAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PricesIncVAT_PurchHdr.Value and Fields!VATAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PricesIncVAT_PurchHdr.Value and Fields!VATAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!PricesIncVAT_PurchHdr.Value and Fields!VATAmt.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!No_PurchLineCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>0pt</Top>
                              <Left>0pt</Left>
                              <Height>8.29023cm</Height>
                              <Width>18.11287cm</Width>
                              <ZIndex>3</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="tableVATAmtSpec">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.8682in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.75528in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.99727in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.11819in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.23522in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.28467in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.86822in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.25in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox235">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox235</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>7</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox177">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtSpecCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>46</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="textbox178">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>45</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox200">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox200</rd:DefaultName>
                                            <ZIndex>44</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox207">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox207</rd:DefaultName>
                                            <ZIndex>43</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox214">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox214</rd:DefaultName>
                                            <ZIndex>42</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox183">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifierCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>34</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox184">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPercentCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>33</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox185">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineAmtCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>32</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox186">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!InvDiscBaseAmtCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>31</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox202">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!InvDisAmtCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox202</rd:DefaultName>
                                            <ZIndex>30</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox209">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBaseCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox209</rd:DefaultName>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox216">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>textbox216</rd:DefaultName>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox499">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox499</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>7</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox492">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox492</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>7</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox173">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATIdentifier.Value</Value>
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
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox174">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVAT.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmtLineVATFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox175">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineLineAmt.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmtLineLineAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox176">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineInvDiscBaseAmt.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmtLineInvDiscBaseAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox204">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineInvDiscAmt.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmtLineInvDiscAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox204</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox211">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATBase.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmtLineVATBaseFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox211</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox218">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATAmt.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmtLineVATAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox218</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox132">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox132</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox133">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox133</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox134">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox134</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox135">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox135</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox137">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox137</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox157">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox157</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox158">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox158</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox164">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox164</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox165">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox165</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox167">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox167</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox168">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox168</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox179">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox179</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox180">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox180</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox181">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox181</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox169">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBaseCaption1.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox171">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineLineAmt.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineLineAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox172">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineInvDiscBaseAmt.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineInvDiscBaseAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox206">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=sum(Fields!VATAmtLineInvDiscAmt.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineInvDiscAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox206</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox213">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=sum(Fields!VATAmtLineVATBase.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineVATBaseFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox213</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox220">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=sum(Fields!VATAmtLineVATAmt.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineVATAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox220</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table4_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=1</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="table4_Details_Group">
                                          <DataElementName>Detail</DataElementName>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember />
                                        </TablixMembers>
                                        <DataElementName>Detail_Collection</DataElementName>
                                        <DataElementOutput>Output</DataElementOutput>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!VATIdentifierCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>8.41355cm</Top>
                              <Height>2.75163cm</Height>
                              <Width>7.12705in</Width>
                              <ZIndex>4</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!VATIdentifierCaption.Value="",true,false)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="tableVATSpecLCY">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.74848in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.75255in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.75255in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.87347in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.25in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox224">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox224</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox237">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALSpecLCYHdr.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox238">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALExchRate.Value</Value>
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
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox243">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifierCaption1.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox244">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPctCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox245">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBaseCaption2.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox246">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountCaption.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox511">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox511</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox507">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox507</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox229">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATIdentifier1.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>#,##0.00</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox230">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVAT1.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATAmtLineVAT1Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox231">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATBaseLCY.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VALVATBaseLCYFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox232">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATAmtLCY.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VALVATAmtLCYFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
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
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox7</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
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
                                              <VerticalAlign>Top</VerticalAlign>
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
                                                      <FontStyle>Normal</FontStyle>
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
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox80">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox80</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.06944in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox103">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox103</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox111">
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
                                            <rd:DefaultName>Textbox111</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox126">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox126</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox131">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <rd:DefaultName>Textbox131</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Style>Solid</Style>
                                              </TopBorder>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.13889in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox225">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalCaption1.Value</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
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
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox227">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VALVATBaseLCY.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VALVATBaseLCYFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox228">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=sum(Fields!VALVATAmtLCY.Value)</Value>
                                                    <Style>
                                                      <FontStyle>Normal</FontStyle>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VALVATAmtLCYFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Top</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table6_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=1</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="table6_Details_Group">
                                          <DataElementName>Detail</DataElementName>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember />
                                        </TablixMembers>
                                        <DataElementName>Detail_Collection</DataElementName>
                                        <DataElementOutput>Output</DataElementOutput>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!VALSpecLCYHdr.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>11.28864cm</Top>
                              <Left>0pt</Left>
                              <Height>3.10441cm</Height>
                              <Width>18.10271cm</Width>
                              <ZIndex>5</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!VALSpecLCYHdr.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                          </ReportItems>
                          <KeepTogether>true</KeepTogether>
                          <Style />
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
                  <Group Name="list1_Details_Group">
                    <GroupExpressions>
                      <GroupExpression>=Fields!No_PurchHdr.Value</GroupExpression>
                      <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <SortExpressions>
                    <SortExpression>
                      <Value>=Fields!OutputNo.Value</Value>
                    </SortExpression>
                    <SortExpression>
                      <Value>=Fields!No_PurchHdr.Value</Value>
                    </SortExpression>
                  </SortExpressions>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Left>0.00401in</Left>
            <Height>20.45929cm</Height>
            <Width>18.11287cm</Width>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>20.45929cm</Height>
        <Style />
      </Body>
      <Width>18.12305cm</Width>
      <Page>
        <PageHeader>
          <Height>7.1106cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="PurchaseHeaderPricesIncludingVATCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(30,1)</Value>
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
              <Top>160pt</Top>
              <Height>11pt</Height>
              <Width>3.36362cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaseHeaderBuyfromVendorNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(31,1)</Value>
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
              <Top>109.3pt</Top>
              <Height>11pt</Height>
              <Width>3.36362cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ReturnOrderNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(32,1)</Value>
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
              <Top>140pt</Top>
              <Height>11pt</Height>
              <Width>3.36362cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccountNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(33,1)</Value>
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
              <Top>160pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>2.54578cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankNameCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(34,1)</Value>
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
              <Top>150pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>2.54578cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoGiroNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(35,1)</Value>
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
              <Top>140pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>2.54578cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoVATRegistrationNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(36,1)</Value>
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
              <Top>130pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>2.54578cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoPhoneNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(37,1)</Value>
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
              <Top>100pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>2.54578cm</Width>
              <ZIndex>7</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaseHeaderPricesIncludingVAT1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(23,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>160pt</Top>
              <Left>3.37017cm</Left>
              <Height>11pt</Height>
              <Width>9.35906cm</Width>
              <ZIndex>8</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BuyFromAddr81">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(8,1)</Value>
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
              <Top>90pt</Top>
              <Height>11pt</Height>
              <Width>12.72268cm</Width>
              <ZIndex>9</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BuyFromAddr71">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(7,1)</Value>
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
              <Top>80pt</Top>
              <Height>11pt</Height>
              <Width>12.72268cm</Width>
              <ZIndex>10</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BuyFromAddr61">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(6,1)</Value>
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
              <Top>70pt</Top>
              <Height>11pt</Height>
              <Width>12.72268cm</Width>
              <ZIndex>11</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BuyFromAddr51">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(5,1)</Value>
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
              <Top>60pt</Top>
              <Height>11pt</Height>
              <Width>12.72268cm</Width>
              <ZIndex>12</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BuyFromAddr41">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4,1)</Value>
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
              <Top>50pt</Top>
              <Height>11pt</Height>
              <Width>12.72268cm</Width>
              <ZIndex>13</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BuyFromAddr31">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(3,1)</Value>
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
              <Top>40pt</Top>
              <Height>11pt</Height>
              <Width>12.72268cm</Width>
              <ZIndex>14</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BuyFromAddr21">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(2,1)</Value>
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
              <Top>30pt</Top>
              <Height>11pt</Height>
              <Width>12.72268cm</Width>
              <ZIndex>15</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BuyFromAddr11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(1,1)</Value>
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
              <Top>20pt</Top>
              <Height>11pt</Height>
              <Width>12.72268cm</Width>
              <ZIndex>16</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaseHeaderBuyfromVendorNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(24,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>109.3pt</Top>
              <Left>3.37017cm</Left>
              <Height>11pt</Height>
              <Width>9.35906cm</Width>
              <ZIndex>17</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr61">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(14,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>90pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>5.38368cm</Width>
              <ZIndex>18</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr51">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(13,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>80pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>5.38368cm</Width>
              <ZIndex>19</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaseHeaderYourReference1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(27,1)</Value>
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
              <Top>120pt</Top>
              <Left>3.37017cm</Left>
              <Height>11pt</Height>
              <Width>9.35906cm</Width>
              <ZIndex>20</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ReferenceText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(38,1)</Value>
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
              <Top>120pt</Top>
              <Height>11pt</Height>
              <Width>3.36362cm</Width>
              <ZIndex>21</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaseHeaderNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(22,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>140pt</Top>
              <Left>3.37017cm</Left>
              <Height>11pt</Height>
              <Width>9.35906cm</Width>
              <ZIndex>22</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesPurchPersonName1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(26,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>170pt</Top>
              <Left>15.27501cm</Left>
              <Height>11pt</Height>
              <Width>2.8379cm</Width>
              <ZIndex>23</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaserText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(39,1)</Value>
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
              <Top>170pt</Top>
              <Left>5.01151in</Left>
              <Height>11pt</Height>
              <Width>2.54578cm</Width>
              <ZIndex>24</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccountNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(19,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>160pt</Top>
              <Left>15.27501cm</Left>
              <Height>11pt</Height>
              <Width>2.8379cm</Width>
              <ZIndex>25</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankName1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(18,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>150pt</Top>
              <Left>15.27501cm</Left>
              <Height>11pt</Height>
              <Width>2.8379cm</Width>
              <ZIndex>26</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoGiroNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(17,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>140pt</Top>
              <Left>15.27501cm</Left>
              <Height>11pt</Height>
              <Width>2.8379cm</Width>
              <ZIndex>27</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoVATRegistrationNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(16,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>130pt</Top>
              <Left>15.27501cm</Left>
              <Height>11pt</Height>
              <Width>2.8379cm</Width>
              <ZIndex>28</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoPhoneNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(15,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>100pt</Top>
              <Left>15.27501cm</Left>
              <Height>11pt</Height>
              <Width>2.8379cm</Width>
              <ZIndex>29</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr41">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(12,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>70pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>5.38368cm</Width>
              <ZIndex>30</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr31">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(11,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>60pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>5.38368cm</Width>
              <ZIndex>31</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr21">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(10,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>50pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>5.38368cm</Width>
              <ZIndex>32</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(9,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>40pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>5.38368cm</Width>
              <ZIndex>33</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="STRSUBSTNOText004CopyText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(20,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>14pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>1.32947cm</Left>
              <Height>20pt</Height>
              <Width>16.78344cm</Width>
              <ZIndex>34</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ExecutionTimeTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(21,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Format>D</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>150pt</Top>
              <Left>3.37017cm</Left>
              <Height>11pt</Height>
              <Width>9.35906cm</Width>
              <ZIndex>35</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PageNumberTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetGroupPageNumber(Code.GetData(40,1),ReportItems!NewPage.Value,Globals!PageNumber)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>20pt</Top>
              <Left>12.72923cm</Left>
              <Height>11pt</Height>
              <Width>5.38368cm</Width>
              <ZIndex>36</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox3">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(41,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Color>#ffff00</Color>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Left>0pt</Left>
              <Height>0.16in</Height>
              <Width>0.02646cm</Width>
              <ZIndex>37</ZIndex>
              <Visibility>
                <Hidden>true</Hidden>
              </Visibility>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PurchaseHeaderVATRegistrationNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(25,1)</Value>
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
              <Top>131.59998pt</Top>
              <Left>3.37017cm</Left>
              <Height>11pt</Height>
              <Width>9.35906cm</Width>
              <ZIndex>39</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VATNoText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(42,1)</Value>
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
              <Top>131.59998pt</Top>
              <Height>11pt</Height>
              <Width>3.36cm</Width>
              <ZIndex>40</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="DocumentDateCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(43,1)</Value>
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
              <Top>150pt</Top>
              <Height>11pt</Height>
              <Width>3.36362cm</Width>
              <ZIndex>41</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="HomePageCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(44,1)</Value>
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
              <Top>110pt</Top>
              <Left>12.72926cm</Left>
              <Height>11pt</Height>
              <Width>2.54578cm</Width>
              <ZIndex>42</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="HomePage1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(28,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>110pt</Top>
              <Left>15.27504cm</Left>
              <Height>11pt</Height>
              <Width>2.8379cm</Width>
              <ZIndex>43</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="EmailCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(45,1)</Value>
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
              <Top>120pt</Top>
              <Left>12.73276cm</Left>
              <Height>11pt</Height>
              <Width>2.54578cm</Width>
              <ZIndex>44</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Email1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(29,1)</Value>
                      <Style>
                        <FontStyle>Normal</FontStyle>
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
              <Top>120pt</Top>
              <Left>15.27854cm</Left>
              <Height>11pt</Height>
              <Width>2.8379cm</Width>
              <ZIndex>45</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.76388cm</LeftMargin>
        <RightMargin>1.05834cm</RightMargin>
        <TopMargin>1.05834cm</TopMargin>
        <BottomMargin>1.48166cm</BottomMargin>
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

Shared offset as Integer
Shared newPage as Object

Public Function GetGroupPageNumber(PageCaption as Object, NewPage as Boolean, pagenumber as Integer) as Object
  If NewPage
    offset = pagenumber - 1
    NewPage = FALSE
  End If
  Return PageCaption &amp; " " &amp; pagenumber - offset
End Function

Public Function IsNewPage() as Boolean
  NewPage = TRUE
  Return NewPage
End Function

Shared Data1 as Object
Shared Data2 as Object
Shared Data3 as Object

Public Function GetData(Num as Integer, Group as integer) as Object
if Group = 1 then
   Return Cstr(Choose(Num, Split(Cstr(Data1),Chr(177))))
End If

if Group = 2 then
   Return Cstr(Choose(Num, Split(Cstr(Data2),Chr(177))))
End If

if Group = 3 then
   Return Cstr(Choose(Num, Split(Cstr(Data3),Chr(177))))
End If
End Function

Public Function SetData(NewData as Object,Group as integer)
  If Group = 1 and NewData &lt;&gt; "" Then
      Data1 = NewData
  End If

  If Group = 2 and NewData &lt;&gt; "" Then
      Data2 = NewData
  End If

  If Group = 3 and NewData &lt;&gt; "" Then
      Data3 = NewData
  End If
  Return True
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>bdf3410f-048d-4652-b341-b4da7150c7f7</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

