OBJECT Report 206 Sales - Invoice
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232,NAVDK11.00.00.24232;
  }
  PROPERTIES
  {
    Permissions=TableData 7190=rimd;
    CaptionML=[DAN=Salg - faktura;
               ENU=Sales - Invoice];
    EnableHyperlinks=Yes;
    OnInitReport=BEGIN
                   GLSetup.GET;
                   SalesSetup.GET;
                   CompanyInfo.GET;
                   CompanyInfo.VerifyAndSetPaymentInfo;
                   FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
                 END;

    OnPreReport=BEGIN
                  IF NOT CurrReport.USEREQUESTPAGE THEN
                    InitLogInteraction;
                END;

    PreviewMode=PrintLayout;
  }
  DATASET
  {
    { 5581;    ;DataItem;                    ;
               DataItemTable=Table112;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Bogf�rt salgsfaktura;
                                   ENU=Posted Sales Invoice];
               OnAfterGetRecord=VAR
                                  Handled@1000 : Boolean;
                                BEGIN
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FormatAddressFields("Sales Invoice Header");
                                  FormatDocumentFields("Sales Invoice Header");

                                  IF NOT Cust.GET("Bill-to Customer No.") THEN
                                    CLEAR(Cust);

                                  DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID");

                                  GetLineFeeNoteOnReportHist("No.");

                                  IF LogInteraction THEN
                                    IF NOT IsReportInPreviewMode THEN BEGIN
                                      IF "Bill-to Contact No." <> '' THEN
                                        SegManagement.LogDocument(
                                          SegManagement.SalesInvoiceInterDocType,"No.",0,0,DATABASE::Contact,"Bill-to Contact No.","Salesperson Code",
                                          "Campaign No.","Posting Description",'')
                                      ELSE
                                        SegManagement.LogDocument(
                                          SegManagement.SalesInvoiceInterDocType,"No.",0,0,DATABASE::Customer,"Bill-to Customer No.","Salesperson Code",
                                          "Campaign No.","Posting Description",'');
                                    END;

                                  OnAfterGetRecordSalesInvoiceHeader("Sales Invoice Header");
                                  OnGetReferenceText("Sales Invoice Header",ReferenceText,Handled);

                                  Handled := FALSE;
                                  OnGetDocumentReferenceText("Sales Invoice Header",DocumentReference,DocumentReferenceTxt,Handled);
                                END;

               ReqFilterFields=No.,Sell-to Customer No.,No. Printed }

    { 198 ;1   ;Column  ;No_SalesInvHdr      ;
               SourceExpr="No." }

    { 87  ;1   ;Column  ;InvDiscountAmtCaption;
               SourceExpr=InvDiscountAmtCaptionLbl }

    { 209 ;1   ;Column  ;DocumentDateCaption ;
               SourceExpr=DocumentDateCaptionLbl }

    { 42  ;1   ;Column  ;PaymentTermsDescCaption;
               SourceExpr=PaymentTermsDescCaptionLbl }

    { 43  ;1   ;Column  ;ShptMethodDescCaption;
               SourceExpr=ShptMethodDescCaptionLbl }

    { 44  ;1   ;Column  ;VATPercentageCaption;
               SourceExpr=VATPercentageCaptionLbl }

    { 55  ;1   ;Column  ;TotalCaption        ;
               SourceExpr=TotalCaptionLbl }

    { 59  ;1   ;Column  ;VATBaseCaption      ;
               SourceExpr=VATBaseCaptionLbl }

    { 85  ;1   ;Column  ;VATAmtCaption       ;
               SourceExpr=VATAmtCaptionLbl }

    { 95  ;1   ;Column  ;VATIdentifierCaption;
               SourceExpr=VATIdentifierCaptionLbl }

    { 70  ;1   ;Column  ;HomePageCaption     ;
               SourceExpr=HomePageCaptionLbl }

    { 86  ;1   ;Column  ;EMailCaption        ;
               SourceExpr=EMailCaptionLbl }

    { 304 ;1   ;Column  ;DisplayAdditionalFeeNote;
               SourceExpr=DisplayAdditionalFeeNote }

    { 5701;1   ;DataItem;CopyLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               NoOfLoops := ABS(NoOfCopies) + Cust."Invoice Copies" + 1;
                               IF NoOfLoops <= 0 THEN
                                 NoOfLoops := 1;
                               CopyText := '';
                               SETRANGE(Number,1,NoOfLoops);
                               OutputNo := 1;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number > 1 THEN BEGIN
                                    CopyText := FormatDocument.GetCOPYText;
                                    OutputNo += 1;
                                  END;
                                  CurrReport.PAGENO := 1;

                                  TotalSubTotal := 0;
                                  TotalInvDiscAmount := 0;
                                  TotalAmount := 0;
                                  TotalAmountVAT := 0;
                                  TotalAmountInclVAT := 0;
                                  TotalPaymentDiscOnVAT := 0;
                                END;

               OnPostDataItem=BEGIN
                                IF NOT IsReportInPreviewMode THEN
                                  CODEUNIT.RUN(CODEUNIT::"Sales Inv.-Printed","Sales Invoice Header");
                              END;
                               }

    { 6455;2   ;DataItem;PageLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 65  ;3   ;Column  ;HomePage            ;
               SourceExpr=CompanyInfo."Home Page" }

    { 63  ;3   ;Column  ;EMail               ;
               SourceExpr=CompanyInfo."E-Mail" }

    { 149 ;3   ;Column  ;CompanyInfo2Picture ;
               SourceExpr=CompanyInfo2.Picture }

    { 148 ;3   ;Column  ;CompanyInfo1Picture ;
               SourceExpr=CompanyInfo1.Picture }

    { 147 ;3   ;Column  ;CompanyInfoPicture  ;
               SourceExpr=CompanyInfo.Picture }

    { 16  ;3   ;Column  ;CompanyInfo3Picture ;
               SourceExpr=CompanyInfo3.Picture }

    { 1   ;3   ;Column  ;DocumentCaptionCopyText;
               SourceExpr=STRSUBSTNO(DocumentCaption,CopyText) }

    { 4   ;3   ;Column  ;CustAddr1           ;
               SourceExpr=CustAddr[1] }

    { 5   ;3   ;Column  ;CompanyAddr1        ;
               SourceExpr=CompanyAddr[1] }

    { 6   ;3   ;Column  ;CustAddr2           ;
               SourceExpr=CustAddr[2] }

    { 7   ;3   ;Column  ;CompanyAddr2        ;
               SourceExpr=CompanyAddr[2] }

    { 8   ;3   ;Column  ;CustAddr3           ;
               SourceExpr=CustAddr[3] }

    { 9   ;3   ;Column  ;CompanyAddr3        ;
               SourceExpr=CompanyAddr[3] }

    { 10  ;3   ;Column  ;CustAddr4           ;
               SourceExpr=CustAddr[4] }

    { 11  ;3   ;Column  ;CompanyAddr4        ;
               SourceExpr=CompanyAddr[4] }

    { 12  ;3   ;Column  ;CustAddr5           ;
               SourceExpr=CustAddr[5] }

    { 14  ;3   ;Column  ;CompanyInfoPhoneNo  ;
               SourceExpr=CompanyInfo."Phone No." }

    { 15  ;3   ;Column  ;CustAddr6           ;
               SourceExpr=CustAddr[6] }

    { 19  ;3   ;Column  ;CompanyInfoVATRegNo ;
               SourceExpr=CompanyInfo."VAT Registration No." }

    { 21  ;3   ;Column  ;CompanyInfoGiroNo   ;
               SourceExpr=CompanyInfo."Giro No." }

    { 23  ;3   ;Column  ;CompanyInfoBankName ;
               SourceExpr=CompanyInfo."Bank Name" }

    { 25  ;3   ;Column  ;CompanyInfoBankAccNo;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 1060098;3;Column  ;CompanyInfoIBAN     ;
               SourceExpr=CompanyInfo.IBAN }

    { 27  ;3   ;Column  ;BilltoCustNo_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."Bill-to Customer No." }

    { 28  ;3   ;Column  ;PostingDate_SalesInvHdr;
               SourceExpr=FORMAT("Sales Invoice Header"."Posting Date",0,4) }

    { 29  ;3   ;Column  ;VATNoText           ;
               SourceExpr=VATNoText }

    { 30  ;3   ;Column  ;VATRegNo_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."VAT Registration No." }

    { 32  ;3   ;Column  ;DueDate_SalesInvHdr ;
               SourceExpr=FORMAT("Sales Invoice Header"."Due Date",0,4) }

    { 33  ;3   ;Column  ;SalesPersonText     ;
               SourceExpr=SalesPersonText }

    { 34  ;3   ;Column  ;SalesPurchPersonName;
               SourceExpr=SalesPurchPerson.Name }

    { 37  ;3   ;Column  ;ReferenceText       ;
               SourceExpr=ReferenceText }

    { 38  ;3   ;Column  ;YourReference_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."Your Reference" }

    { 39  ;3   ;Column  ;OrderNoText         ;
               SourceExpr=OrderNoText }

    { 40  ;3   ;Column  ;HdrOrderNo_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."Order No." }

    { 3   ;3   ;Column  ;CustAddr7           ;
               SourceExpr=CustAddr[7] }

    { 48  ;3   ;Column  ;CustAddr8           ;
               SourceExpr=CustAddr[8] }

    { 49  ;3   ;Column  ;CompanyAddr5        ;
               SourceExpr=CompanyAddr[5] }

    { 50  ;3   ;Column  ;CompanyAddr6        ;
               SourceExpr=CompanyAddr[6] }

    { 54  ;3   ;Column  ;DocDate_SalesInvHdr ;
               SourceExpr=FORMAT("Sales Invoice Header"."Document Date",0,4) }

    { 58  ;3   ;Column  ;PricesInclVAT_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."Prices Including VAT" }

    { 154 ;3   ;Column  ;OutputNo            ;
               SourceExpr=OutputNo }

    { 159 ;3   ;Column  ;PricesInclVATYesNo_SalesInvHdr;
               SourceExpr=FORMAT("Sales Invoice Header"."Prices Including VAT") }

    { 160 ;3   ;Column  ;PageCaption         ;
               SourceExpr=PageCaptionCap }

    { 1060021;3;Column  ;SelltoContactEMail_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."Sell-to Contact E-Mail" }

    { 1060020;3;Column  ;SelltoContact_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."Sell-to Contact" }

    { 1060019;3;Column  ;AccountCode_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."Account Code" }

    { 1060018;3;Column  ;EANNo_SalesInvHdr   ;
               SourceExpr="Sales Invoice Header"."EAN No." }

    { 1060017;3;Column  ;EANText             ;
               SourceExpr=EANText }

    { 1060016;3;Column  ;IntAccountCodeText  ;
               SourceExpr=IntAccountCodeText }

    { 26  ;3   ;Column  ;PaymentTermsDesc    ;
               SourceExpr=PaymentTerms.Description }

    { 41  ;3   ;Column  ;ShipmentMethodDesc  ;
               SourceExpr=ShipmentMethod.Description }

    { 13  ;3   ;Column  ;CompanyInfoPhoneNoCaption;
               SourceExpr=CompanyInfoPhoneNoCaptionLbl }

    { 18  ;3   ;Column  ;CompanyInfoVATRegNoCptn;
               SourceExpr=CompanyInfoVATRegNoCptnLbl }

    { 1060012;3;Column  ;SelltoContactPhoneNo_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."Sell-to Contact Phone No." }

    { 20  ;3   ;Column  ;CompanyInfoGiroNoCaption;
               SourceExpr=CompanyInfoGiroNoCaptionLbl }

    { 22  ;3   ;Column  ;CompanyInfoBankNameCptn;
               SourceExpr=CompanyInfoBankNameCptnLbl }

    { 24  ;3   ;Column  ;CompanyInfoBankAccNoCptn;
               SourceExpr=CompanyInfoBankAccNoCptnLbl }

    { 1060099;3;Column  ;CompanyInfoIBANCptn ;
               SourceExpr=IBANCaption }

    { 31  ;3   ;Column  ;SalesInvDueDateCaption;
               SourceExpr=SalesInvDueDateCaptionLbl }

    { 35  ;3   ;Column  ;InvNoCaption        ;
               SourceExpr=InvNoCaptionLbl }

    { 53  ;3   ;Column  ;SalesInvPostingDateCptn;
               SourceExpr=SalesInvPostingDateCptnLbl }

    { 17  ;3   ;Column  ;BilltoCustNo_SalesInvHdrCaption;
               SourceExpr="Sales Invoice Header".FIELDCAPTION("Bill-to Customer No.") }

    { 36  ;3   ;Column  ;PricesInclVAT_SalesInvHdrCaption;
               SourceExpr="Sales Invoice Header".FIELDCAPTION("Prices Including VAT") }

    { 1060000;3;Column  ;DocumentReferenceTxt;
               SourceExpr=DocumentReferenceTxt }

    { 1060001;3;Column  ;DocumentReference   ;
               SourceExpr=DocumentReference }

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

               DataItemLinkReference=Sales Invoice Header }

    { 91  ;4   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 161 ;4   ;Column  ;DimensionLoop1Number;
               SourceExpr=Number }

    { 93  ;4   ;Column  ;HeaderDimCaption    ;
               SourceExpr=HeaderDimCaptionLbl }

    { 1570;3   ;DataItem;                    ;
               DataItemTable=Table113;
               DataItemTableView=SORTING(Document No.,Line No.);
               OnPreDataItem=BEGIN
                               VATAmountLine.DELETEALL;
                               TempVATAmountLineLCY.DELETEALL;
                               VATBaseRemainderAfterRoundingLCY := 0;
                               AmtInclVATRemainderAfterRoundingLCY := 0;
                               SalesShipmentBuffer.RESET;
                               SalesShipmentBuffer.DELETEALL;
                               FirstValueEntryNo := 0;
                               MoreLines := FIND('+');
                               WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                 MoreLines := NEXT(-1) <> 0;
                               IF NOT MoreLines THEN
                                 CurrReport.BREAK;
                               LineNoWithTotal := "Line No.";
                               SETRANGE("Line No.",0,"Line No.");
                               CurrReport.CREATETOTALS("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  InitializeShipmentBuffer;
                                  IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                    "No." := '';

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
                                  VATAmountLine.InsertLine;
                                  CalcVATAmountLineLCY(
                                    "Sales Invoice Header",VATAmountLine,TempVATAmountLineLCY,
                                    VATBaseRemainderAfterRoundingLCY,AmtInclVATRemainderAfterRoundingLCY);

                                  TotalSubTotal += "Line Amount";
                                  TotalInvDiscAmount -= "Inv. Discount Amount";
                                  TotalAmount += Amount;
                                  TotalAmountVAT += "Amount Including VAT" - Amount;
                                  TotalAmountInclVAT += "Amount Including VAT";
                                  TotalPaymentDiscOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
                                END;

               DataItemLinkReference=Sales Invoice Header;
               DataItemLink=Document No.=FIELD(No.) }

    { 56  ;4   ;Column  ;LineAmt_SalesInvLine;
               SourceExpr="Line Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 57  ;4   ;Column  ;Desc_SalesInvLine   ;
               SourceExpr=Description }

    { 64  ;4   ;Column  ;No_SalesInvLine     ;
               SourceExpr="No." }

    { 66  ;4   ;Column  ;Qty_SalesInvLine    ;
               SourceExpr=Quantity }

    { 67  ;4   ;Column  ;UOM_SalesInvLine    ;
               SourceExpr="Unit of Measure" }

    { 68  ;4   ;Column  ;UnitPrice_SalesInvLine;
               SourceExpr="Unit Price";
               AutoFormatType=2;
               AutoFormatExpr=GetCurrencyCode }

    { 69  ;4   ;Column  ;Discount_SalesInvLine;
               SourceExpr="Line Discount %" }

    { 101 ;4   ;Column  ;VATIdentifier_SalesInvLine;
               SourceExpr="VAT Identifier" }

    { 100 ;4   ;Column  ;PostedShipmentDate  ;
               SourceExpr=FORMAT("Shipment Date") }

    { 155 ;4   ;Column  ;Type_SalesInvLine   ;
               SourceExpr=FORMAT(Type) }

    { 88  ;4   ;Column  ;InvDiscLineAmt_SalesInvLine;
               SourceExpr=-"Inv. Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 166 ;4   ;Column  ;TotalSubTotal       ;
               SourceExpr=TotalSubTotal;
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 172 ;4   ;Column  ;TotalInvDiscAmount  ;
               SourceExpr=TotalInvDiscAmount;
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 73  ;4   ;Column  ;TotalText           ;
               SourceExpr=TotalText }

    { 74  ;4   ;Column  ;Amount_SalesInvLine ;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 167 ;4   ;Column  ;TotalAmount         ;
               SourceExpr=TotalAmount;
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 92  ;4   ;Column  ;Amount_AmtInclVAT   ;
               SourceExpr="Amount Including VAT" - Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 94  ;4   ;Column  ;AmtInclVAT_SalesInvLine;
               SourceExpr="Amount Including VAT";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 79  ;4   ;Column  ;VATAmtLineVATAmtText;
               SourceExpr=VATAmountLine.VATAmountText }

    { 80  ;4   ;Column  ;TotalExclVATText    ;
               SourceExpr=TotalExclVATText }

    { 81  ;4   ;Column  ;TotalInclVATText    ;
               SourceExpr=TotalInclVATText }

    { 174 ;4   ;Column  ;TotalAmountInclVAT  ;
               SourceExpr=TotalAmountInclVAT;
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 168 ;4   ;Column  ;TotalAmountVAT      ;
               SourceExpr=TotalAmountVAT;
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 143 ;4   ;Column  ;LineAmtAfterInvDiscAmt;
               SourceExpr=-("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 173 ;4   ;Column  ;VATBaseDisc_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."VAT Base Discount %";
               AutoFormatType=1 }

    { 177 ;4   ;Column  ;TotalPaymentDiscOnVAT;
               SourceExpr=TotalPaymentDiscOnVAT;
               AutoFormatType=1 }

    { 60  ;4   ;Column  ;TotalInclVATText_SalesInvLine;
               SourceExpr=TotalInclVATText }

    { 61  ;4   ;Column  ;VATAmtText_SalesInvLine;
               SourceExpr=VATAmountLine.VATAmountText }

    { 200 ;4   ;Column  ;DocNo_SalesInvLine  ;
               SourceExpr="Document No." }

    { 201 ;4   ;Column  ;LineNo_SalesInvLine ;
               SourceExpr="Line No." }

    { 45  ;4   ;Column  ;UnitPriceCaption    ;
               SourceExpr=UnitPriceCaptionLbl }

    { 46  ;4   ;Column  ;SalesInvLineDiscCaption;
               SourceExpr=SalesInvLineDiscCaptionLbl }

    { 47  ;4   ;Column  ;AmountCaption       ;
               SourceExpr=AmountCaptionLbl }

    { 106 ;4   ;Column  ;PostedShipmentDateCaption;
               SourceExpr=PostedShipmentDateCaptionLbl }

    { 89  ;4   ;Column  ;SubtotalCaption     ;
               SourceExpr=SubtotalCaptionLbl }

    { 84  ;4   ;Column  ;LineAmtAfterInvDiscCptn;
               SourceExpr=LineAmtAfterInvDiscCptnLbl }

    { 62  ;4   ;Column  ;Desc_SalesInvLineCaption;
               SourceExpr=FIELDCAPTION(Description) }

    { 71  ;4   ;Column  ;No_SalesInvLineCaption;
               SourceExpr=FIELDCAPTION("No.") }

    { 72  ;4   ;Column  ;Qty_SalesInvLineCaption;
               SourceExpr=FIELDCAPTION(Quantity) }

    { 90  ;4   ;Column  ;UOM_SalesInvLineCaption;
               SourceExpr=FIELDCAPTION("Unit of Measure") }

    { 96  ;4   ;Column  ;VATIdentifier_SalesInvLineCaption;
               SourceExpr=FIELDCAPTION("VAT Identifier") }

    { 99  ;4   ;Column  ;IsLineWithTotals    ;
               SourceExpr=LineNoWithTotal = "Line No." }

    { 1484;4   ;DataItem;Sales Shipment Buffer;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SalesShipmentBuffer.SETRANGE("Document No.","Sales Invoice Line"."Document No.");
                               SalesShipmentBuffer.SETRANGE("Line No.","Sales Invoice Line"."Line No.");

                               SETRANGE(Number,1,SalesShipmentBuffer.COUNT);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    SalesShipmentBuffer.FIND('-')
                                  ELSE
                                    SalesShipmentBuffer.NEXT;
                                END;
                                 }

    { 144 ;5   ;Column  ;SalesShptBufferPostDate;
               SourceExpr=FORMAT(SalesShipmentBuffer."Posting Date") }

    { 146 ;5   ;Column  ;SalesShptBufferQty  ;
               DecimalPlaces=0:5;
               SourceExpr=SalesShipmentBuffer.Quantity }

    { 145 ;5   ;Column  ;ShipmentCaption     ;
               SourceExpr=ShipmentCaptionLbl }

    { 3591;4   ;DataItem;DimensionLoop2      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;

                               DimSetEntry2.SETRANGE("Dimension Set ID","Sales Invoice Line"."Dimension Set ID");
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

    { 82  ;5   ;Column  ;DimText_DimLoop     ;
               SourceExpr=DimText }

    { 83  ;5   ;Column  ;LineDimCaption      ;
               SourceExpr=LineDimCaptionLbl }

    { 9462;4   ;DataItem;AsmLoop             ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               CLEAR(TempPostedAsmLine);
                               IF NOT DisplayAssemblyInformation THEN
                                 CurrReport.BREAK;
                               CollectAsmInformation;
                               CLEAR(TempPostedAsmLine);
                               SETRANGE(Number,1,TempPostedAsmLine.COUNT);
                             END;

               OnAfterGetRecord=VAR
                                  ItemTranslation@1000 : Record 30;
                                BEGIN
                                  IF Number = 1 THEN
                                    TempPostedAsmLine.FINDSET
                                  ELSE
                                    TempPostedAsmLine.NEXT;

                                  IF ItemTranslation.GET(TempPostedAsmLine."No.",
                                       TempPostedAsmLine."Variant Code",
                                       "Sales Invoice Header"."Language Code")
                                  THEN
                                    TempPostedAsmLine.Description := ItemTranslation.Description;
                                END;
                                 }

    { 179 ;5   ;Column  ;TempPostedAsmLineNo ;
               SourceExpr=BlanksForIndent + TempPostedAsmLine."No." }

    { 183 ;5   ;Column  ;TempPostedAsmLineQuantity;
               DecimalPlaces=0:5;
               SourceExpr=TempPostedAsmLine.Quantity }

    { 184 ;5   ;Column  ;TempPostedAsmLineDesc;
               SourceExpr=BlanksForIndent + TempPostedAsmLine.Description }

    { 178 ;5   ;Column  ;TempPostAsmLineVartCode;
               DecimalPlaces=0:5;
               SourceExpr=BlanksForIndent + TempPostedAsmLine."Variant Code" }

    { 185 ;5   ;Column  ;TempPostedAsmLineUOM;
               DecimalPlaces=0:5;
               SourceExpr=GetUOMText(TempPostedAsmLine."Unit of Measure Code") }

    { 6558;3   ;DataItem;VATCounter          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,VATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(
                                 VATAmountLine."Line Amount",VATAmountLine."Inv. Disc. Base Amount",
                                 VATAmountLine."Invoice Discount Amount",VATAmountLine."VAT Base",VATAmountLine."VAT Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  VATAmountLine.GetLine(Number);
                                END;
                                 }

    { 104 ;4   ;Column  ;VATAmtLineVATBase   ;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Line".GetCurrencyCode }

    { 105 ;4   ;Column  ;VATAmtLineVATAmt    ;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 75  ;4   ;Column  ;VATAmtLineLineAmt   ;
               SourceExpr=VATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 76  ;4   ;Column  ;VATAmtLineInvDiscBaseAmt;
               SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 77  ;4   ;Column  ;VATAmtLineInvDiscAmt;
               SourceExpr=VATAmountLine."Invoice Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 107 ;4   ;Column  ;VATAmtLineVATPer    ;
               DecimalPlaces=0:5;
               SourceExpr=VATAmountLine."VAT %" }

    { 135 ;4   ;Column  ;VATAmtLineVATIdentifier;
               SourceExpr=VATAmountLine."VAT Identifier" }

    { 78  ;4   ;Column  ;VATAmtSpecificationCptn;
               SourceExpr=VATAmtSpecificationCptnLbl }

    { 137 ;4   ;Column  ;InvDiscBaseAmtCaption;
               SourceExpr=InvDiscBaseAmtCaptionLbl }

    { 138 ;4   ;Column  ;LineAmtCaption      ;
               SourceExpr=LineAmtCaptionLbl }

    { 250 ;3   ;DataItem;VATClauseEntryCounter;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               CLEAR(VATClause);
                               SETRANGE(Number,1,VATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(VATAmountLine."VAT Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  VATAmountLine.GetLine(Number);
                                  IF NOT VATClause.GET(VATAmountLine."VAT Clause Code") THEN
                                    CurrReport.SKIP;
                                  VATClause.TranslateDescription("Sales Invoice Header"."Language Code");
                                END;
                                 }

    { 251 ;4   ;Column  ;VATClauseVATIdentifier;
               SourceExpr=VATAmountLine."VAT Identifier" }

    { 252 ;4   ;Column  ;VATClauseCode       ;
               SourceExpr=VATAmountLine."VAT Clause Code" }

    { 253 ;4   ;Column  ;VATClauseDescription;
               SourceExpr=VATClause.Description }

    { 254 ;4   ;Column  ;VATClauseDescription2;
               SourceExpr=VATClause."Description 2" }

    { 255 ;4   ;Column  ;VATClauseAmount     ;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Invoice Header"."Currency Code" }

    { 256 ;4   ;Column  ;VATClausesCaption   ;
               SourceExpr=VATClausesCap }

    { 257 ;4   ;Column  ;VATClauseVATIdentifierCaption;
               SourceExpr=VATIdentifierCaptionLbl }

    { 258 ;4   ;Column  ;VATClauseVATAmtCaption;
               SourceExpr=VATAmtCaptionLbl }

    { 9347;3   ;DataItem;VatCounterLCY       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF (NOT GLSetup."Print VAT specification in LCY") OR
                                  ("Sales Invoice Header"."Currency Code" = '')
                               THEN
                                 CurrReport.BREAK;

                               SETRANGE(Number,1,VATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(VALVATBaseLCY,VALVATAmountLCY);

                               IF GLSetup."LCY Code" = '' THEN
                                 VALSpecLCYHeader := Text007 + Text008
                               ELSE
                                 VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                               CurrExchRate.FindCurrency("Sales Invoice Header"."Posting Date","Sales Invoice Header"."Currency Code",1);
                               CalculatedExchRate := ROUND(1 / "Sales Invoice Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount",0.000001);
                               VALExchRate := STRSUBSTNO(Text009,CalculatedExchRate,CurrExchRate."Exchange Rate Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  TempVATAmountLineLCY.GetLine(Number);
                                  VALVATBaseLCY := TempVATAmountLineLCY."VAT Base";
                                  VALVATAmountLCY := TempVATAmountLineLCY."Amount Including VAT" - TempVATAmountLineLCY."VAT Base";
                                END;
                                 }

    { 152 ;4   ;Column  ;VALSpecLCYHeader    ;
               SourceExpr=VALSpecLCYHeader }

    { 153 ;4   ;Column  ;VALExchRate         ;
               SourceExpr=VALExchRate }

    { 162 ;4   ;Column  ;VALVATBaseLCY       ;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 163 ;4   ;Column  ;VALVATAmountLCY     ;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 164 ;4   ;Column  ;VATPer_VATCounterLCY;
               DecimalPlaces=0:5;
               SourceExpr=TempVATAmountLineLCY."VAT %" }

    { 165 ;4   ;Column  ;VATIdentifier_VATCounterLCY;
               SourceExpr=TempVATAmountLineLCY."VAT Identifier" }

    { 197 ;3   ;DataItem;PaymentReportingArgument;
               DataItemTable=Table1062;
               DataItemTableView=SORTING(Key);
               OnPreDataItem=VAR
                               PaymentServiceSetup@1000 : Record 1060;
                             BEGIN
                               PaymentServiceSetup.CreateReportingArgs(PaymentReportingArgument,"Sales Invoice Header");
                               IF ISEMPTY THEN
                                 CurrReport.BREAK;
                             END;

               Temporary=Yes }

    { 98  ;4   ;Column  ;PaymentServiceLogo  ;
               SourceExpr=Logo }

    { 199 ;4   ;Column  ;PaymentServiceURLText;
               SourceExpr="URL Caption" }

    { 2   ;4   ;Column  ;PaymentServiceURL   ;
               SourceExpr=GetTargetURL }

    { 3476;3   ;DataItem;Total               ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF NOT ShowShippingAddr THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 125 ;4   ;Column  ;SelltoCustNo_SalesInvHdr;
               SourceExpr="Sales Invoice Header"."Sell-to Customer No." }

    { 126 ;4   ;Column  ;ShipToAddr1         ;
               SourceExpr=ShipToAddr[1] }

    { 127 ;4   ;Column  ;ShipToAddr2         ;
               SourceExpr=ShipToAddr[2] }

    { 128 ;4   ;Column  ;ShipToAddr3         ;
               SourceExpr=ShipToAddr[3] }

    { 129 ;4   ;Column  ;ShipToAddr4         ;
               SourceExpr=ShipToAddr[4] }

    { 130 ;4   ;Column  ;ShipToAddr5         ;
               SourceExpr=ShipToAddr[5] }

    { 131 ;4   ;Column  ;ShipToAddr6         ;
               SourceExpr=ShipToAddr[6] }

    { 51  ;4   ;Column  ;ShipToAddr7         ;
               SourceExpr=ShipToAddr[7] }

    { 52  ;4   ;Column  ;ShipToAddr8         ;
               SourceExpr=ShipToAddr[8] }

    { 123 ;4   ;Column  ;ShiptoAddrCaption   ;
               SourceExpr=ShiptoAddrCaptionLbl }

    { 97  ;4   ;Column  ;SelltoCustNo_SalesInvHdrCaption;
               SourceExpr="Sales Invoice Header".FIELDCAPTION("Sell-to Customer No.") }

    { 300 ;3   ;DataItem;LineFee             ;
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

    { 301 ;4   ;Column  ;LineFeeCaptionLbl   ;
               SourceExpr=TempLineFeeNoteOnReportHist.ReportText }

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

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Antal kopier;
                             ENU=No. of Copies];
                  ToolTipML=[DAN=Angiver, hvor mange kopier af bilaget der udskrives.;
                             ENU=Specifies how many copies of the document to print.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=NoOfCopies }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Vis interne oplysninger;
                             ENU=Show Internal Information];
                  ToolTipML=[DAN=Angiver, om den udskrevne rapport skal indeholde oplysninger, der kun er til intern brug.;
                             ENU=Specifies if you want the printed report to show information that is only for internal use.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ShowInternalInfo }

      { 4   ;2   ;Field     ;
                  Name=LogInteraction;
                  CaptionML=[DAN=Logf�r interaktion;
                             ENU=Log Interaction];
                  ToolTipML=[DAN=Angiver, at interaktioner med kontakten er logf�rt.;
                             ENU=Specifies that interactions with the contact are logged.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=LogInteraction;
                  Enabled=LogInteractionEnable }

      { 3   ;2   ;Field     ;
                  Name=DisplayAsmInformation;
                  CaptionML=[DAN=Vis montagekomponenter;
                             ENU=Show Assembly Components];
                  ToolTipML=[DAN=Angiver, om rapporten skal omfatte oplysninger om komponenter, der blev brugt i sammenk�dede montageordrer, hvori den eller de solgte varer indgik.;
                             ENU=Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.];
                  ApplicationArea=#Assembly;
                  SourceExpr=DisplayAssemblyInformation }

      { 303 ;2   ;Field     ;
                  Name=DisplayAdditionalFeeNote;
                  CaptionML=[DAN=Vis bem�rkning om opkr�vningsgebyr;
                             ENU=Show Additional Fee Note];
                  ToolTipML=[DAN=Angiver, at alle noter om yderligere gebyrer er inkluderet i dokumentet.;
                             ENU=Specifies that any notes about additional fees are included on the document.];
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
      Text004@1004 : TextConst '@@@="%1 = Document No.";DAN=Salg - faktura %1;ENU=Sales - Invoice %1';
      PageCaptionCap@1005 : TextConst 'DAN=Side %1 af %2;ENU=Page %1 of %2';
      GLSetup@1007 : Record 98;
      ShipmentMethod@1008 : Record 10;
      PaymentTerms@1009 : Record 3;
      SalesPurchPerson@1010 : Record 13;
      CompanyInfo@1011 : Record 79;
      CompanyInfo1@1045 : Record 79;
      CompanyInfo2@1046 : Record 79;
      CompanyInfo3@1068 : Record 79;
      SalesSetup@1048 : Record 311;
      SalesShipmentBuffer@1000 : TEMPORARY Record 7190;
      Cust@1012 : Record 18;
      VATAmountLine@1013 : TEMPORARY Record 290;
      TempVATAmountLineLCY@1001 : TEMPORARY Record 290;
      DimSetEntry1@1014 : Record 480;
      DimSetEntry2@1015 : Record 480;
      RespCenter@1016 : Record 5714;
      Language@1017 : Record 8;
      CurrExchRate@1054 : Record 330;
      TempPostedAsmLine@1066 : TEMPORARY Record 911;
      VATClause@1069 : Record 560;
      TempLineFeeNoteOnReportHist@1070 : TEMPORARY Record 1053;
      FormatAddr@1019 : Codeunit 365;
      FormatDocument@1074 : Codeunit 368;
      SegManagement@1020 : Codeunit 5051;
      CustAddr@1021 : ARRAY [8] OF Text[50];
      ShipToAddr@1022 : ARRAY [8] OF Text[50];
      CompanyAddr@1023 : ARRAY [8] OF Text[50];
      OrderNoText@1024 : Text[80];
      SalesPersonText@1025 : Text[30];
      VATNoText@1026 : Text[80];
      ReferenceText@1027 : Text[80];
      TotalText@1028 : Text[50];
      TotalExclVATText@1029 : Text[50];
      TotalInclVATText@1030 : Text[50];
      MoreLines@1031 : Boolean;
      NoOfCopies@1032 : Integer;
      NoOfLoops@1033 : Integer;
      CopyText@1034 : Text[30];
      ShowShippingAddr@1035 : Boolean;
      NextEntryNo@1043 : Integer;
      FirstValueEntryNo@1042 : Integer;
      DimText@1037 : Text[120];
      OldDimText@1038 : Text[75];
      ShowInternalInfo@1039 : Boolean;
      Continue@1040 : Boolean;
      LogInteraction@1041 : Boolean;
      VALVATBaseLCY@1052 : Decimal;
      VALVATAmountLCY@1053 : Decimal;
      VALSpecLCYHeader@1055 : Text[80];
      Text007@1049 : TextConst 'DAN="Momsbel�bsspecifikation i ";ENU="VAT Amount Specification in "';
      Text008@1051 : TextConst 'DAN=Lokal valuta;ENU=Local Currency';
      VALExchRate@1047 : Text[50];
      Text009@1056 : TextConst 'DAN=Valutakurs: %1/%2;ENU=Exchange rate: %1/%2';
      CalculatedExchRate@1057 : Decimal;
      Text010@1058 : TextConst 'DAN=Salg - forudbetalingsfaktura %1;ENU=Sales - Prepayment Invoice %1';
      OutputNo@1059 : Integer;
      TotalSubTotal@1061 : Decimal;
      TotalAmount@1062 : Decimal;
      TotalAmountInclVAT@1064 : Decimal;
      TotalAmountVAT@1065 : Decimal;
      TotalInvDiscAmount@1063 : Decimal;
      TotalPaymentDiscOnVAT@1060 : Decimal;
      EANText@1101100020 : Text[30];
      IntAccountCodeText@1101100004 : Text[30];
      CustVatNoText@1101100003 : Text[30];
      LogInteractionEnable@19003940 : Boolean INDATASET;
      DisplayAssemblyInformation@1067 : Boolean;
      CompanyInfoPhoneNoCaptionLbl@6373 : TextConst 'DAN=Telefon;ENU=Phone No.';
      CompanyInfoVATRegNoCptnLbl@4958 : TextConst 'DAN=SE/CVR-nr.;ENU=VAT Reg. No.';
      CompanyInfoGiroNoCaptionLbl@9182 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      CompanyInfoBankNameCptnLbl@3384 : TextConst 'DAN=Bank;ENU=Bank';
      CompanyInfoBankAccNoCptnLbl@5859 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      CompanyInfoIBANCptnLbl@9859 : TextConst 'DAN=IBAN;ENU=IBAN';
      SalesInvDueDateCaptionLbl@9871 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      InvNoCaptionLbl@5320 : TextConst 'DAN=Fakturanr.;ENU=Invoice No.';
      SalesInvPostingDateCptnLbl@9961 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      HeaderDimCaptionLbl@2848 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      UnitPriceCaptionLbl@9823 : TextConst 'DAN=Enhedspris;ENU=Unit Price';
      SalesInvLineDiscCaptionLbl@9173 : TextConst 'DAN=Rabatpct.;ENU=Discount %';
      AmountCaptionLbl@7794 : TextConst 'DAN=Bel�b;ENU=Amount';
      VATClausesCap@1071 : TextConst 'DAN=Momsklausul;ENU=VAT Clause';
      PostedShipmentDateCaptionLbl@1193 : TextConst 'DAN=Bogf�rt leverancedato;ENU=Posted Shipment Date';
      SubtotalCaptionLbl@1782 : TextConst 'DAN=Subtotal;ENU=Subtotal';
      LineAmtAfterInvDiscCptnLbl@2707 : TextConst 'DAN=Moms ved kontantrabat;ENU=Payment Discount on VAT';
      ShipmentCaptionLbl@1672 : TextConst 'DAN=Leverance;ENU=Shipment';
      LineDimCaptionLbl@2096 : TextConst 'DAN=Linjedimensioner;ENU=Line Dimensions';
      VATAmtSpecificationCptnLbl@5492 : TextConst 'DAN=Momsbel�bspecifikation;ENU=VAT Amount Specification';
      InvDiscBaseAmtCaptionLbl@2407 : TextConst 'DAN=Grundbel�b for fakturarabat;ENU=Invoice Discount Base Amount';
      LineAmtCaptionLbl@3126 : TextConst 'DAN=Linjebel�b;ENU=Line Amount';
      ShiptoAddrCaptionLbl@9454 : TextConst 'DAN=Leveringsadresse;ENU=Ship-to Address';
      InvDiscountAmtCaptionLbl@6929 : TextConst 'DAN=Fakturarabatbel�b;ENU=Invoice Discount Amount';
      DocumentDateCaptionLbl@7509 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      PaymentTermsDescCaptionLbl@8637 : TextConst 'DAN=Betalingsbetingelser;ENU=Payment Terms';
      ShptMethodDescCaptionLbl@9827 : TextConst 'DAN=Leveringsform;ENU=Shipment Method';
      VATPercentageCaptionLbl@7196 : TextConst 'DAN=Momspct.;ENU=VAT %';
      TotalCaptionLbl@1909 : TextConst 'DAN=I alt;ENU=Total';
      VATBaseCaptionLbl@5098 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATAmtCaptionLbl@8387 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VATIdentifierCaptionLbl@6906 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      HomePageCaptionLbl@1436 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      EMailCaptionLbl@1638 : TextConst 'DAN=Mail;ENU=Email';
      DocumentReferenceTxt@1060001 : Text;
      DocumentReference@1060002 : Text;
      IBANCaption@6003 : Text[80];
      DisplayAdditionalFeeNote@1072 : Boolean;
      LineNoWithTotal@1073 : Integer;
      VATBaseRemainderAfterRoundingLCY@1002 : Decimal;
      AmtInclVATRemainderAfterRoundingLCY@1003 : Decimal;

    PROCEDURE InitLogInteraction@1();
    BEGIN
      LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
    END;

    LOCAL PROCEDURE IsReportInPreviewMode@18() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    LOCAL PROCEDURE InitializeShipmentBuffer@6();
    VAR
      SalesShipmentHeader@1000 : Record 110;
      TempSalesShipmentBuffer@1001 : TEMPORARY Record 7190;
    BEGIN
      NextEntryNo := 1;
      IF "Sales Invoice Line"."Shipment No." <> '' THEN
        IF SalesShipmentHeader.GET("Sales Invoice Line"."Shipment No.") THEN
          EXIT;

      IF "Sales Invoice Header"."Order No." = '' THEN
        EXIT;

      CASE "Sales Invoice Line".Type OF
        "Sales Invoice Line".Type::Item:
          GenerateBufferFromValueEntry("Sales Invoice Line");
        "Sales Invoice Line".Type::"G/L Account","Sales Invoice Line".Type::Resource,
        "Sales Invoice Line".Type::"Charge (Item)","Sales Invoice Line".Type::"Fixed Asset":
          GenerateBufferFromShipment("Sales Invoice Line");
      END;

      SalesShipmentBuffer.RESET;
      SalesShipmentBuffer.SETRANGE("Document No.","Sales Invoice Line"."Document No.");
      SalesShipmentBuffer.SETRANGE("Line No." ,"Sales Invoice Line"."Line No.");
      IF SalesShipmentBuffer.FIND('-') THEN BEGIN
        TempSalesShipmentBuffer := SalesShipmentBuffer;
        IF SalesShipmentBuffer.NEXT = 0 THEN BEGIN
          SalesShipmentBuffer.GET(
            TempSalesShipmentBuffer."Document No.",TempSalesShipmentBuffer."Line No.",TempSalesShipmentBuffer."Entry No.");
          SalesShipmentBuffer.DELETE;
          EXIT;
        END ;
        SalesShipmentBuffer.CALCSUMS(Quantity);
        IF SalesShipmentBuffer.Quantity <> "Sales Invoice Line".Quantity THEN BEGIN
          SalesShipmentBuffer.DELETEALL;
          EXIT;
        END;
      END;
    END;

    LOCAL PROCEDURE GenerateBufferFromValueEntry@2(SalesInvoiceLine2@1002 : Record 113);
    VAR
      ValueEntry@1000 : Record 5802;
      ItemLedgerEntry@1001 : Record 32;
      TotalQuantity@1003 : Decimal;
      Quantity@1004 : Decimal;
    BEGIN
      TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
      ValueEntry.SETCURRENTKEY("Document No.");
      ValueEntry.SETRANGE("Document No.",SalesInvoiceLine2."Document No.");
      ValueEntry.SETRANGE("Posting Date","Sales Invoice Header"."Posting Date");
      ValueEntry.SETRANGE("Item Charge No.",'');
      ValueEntry.SETFILTER("Entry No.",'%1..',FirstValueEntryNo);
      IF ValueEntry.FIND('-') THEN
        REPEAT
          IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
            IF SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 THEN
              Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
            ELSE
              Quantity := ValueEntry."Invoiced Quantity";
            AddBufferEntry(
              SalesInvoiceLine2,
              -Quantity,
              ItemLedgerEntry."Posting Date");
            TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
          END;
          FirstValueEntryNo := ValueEntry."Entry No." + 1;
        UNTIL (ValueEntry.NEXT = 0) OR (TotalQuantity = 0);
    END;

    LOCAL PROCEDURE GenerateBufferFromShipment@8(SalesInvoiceLine@1000 : Record 113);
    VAR
      SalesInvoiceHeader@1001 : Record 112;
      SalesInvoiceLine2@1002 : Record 113;
      SalesShipmentHeader@1006 : Record 110;
      SalesShipmentLine@1004 : Record 111;
      TotalQuantity@1003 : Decimal;
      Quantity@1005 : Decimal;
    BEGIN
      TotalQuantity := 0;
      SalesInvoiceHeader.SETCURRENTKEY("Order No.");
      SalesInvoiceHeader.SETFILTER("No.",'..%1',"Sales Invoice Header"."No.");
      SalesInvoiceHeader.SETRANGE("Order No.","Sales Invoice Header"."Order No.");
      IF SalesInvoiceHeader.FIND('-') THEN
        REPEAT
          SalesInvoiceLine2.SETRANGE("Document No.",SalesInvoiceHeader."No.");
          SalesInvoiceLine2.SETRANGE("Line No.",SalesInvoiceLine."Line No.");
          SalesInvoiceLine2.SETRANGE(Type,SalesInvoiceLine.Type);
          SalesInvoiceLine2.SETRANGE("No.",SalesInvoiceLine."No.");
          SalesInvoiceLine2.SETRANGE("Unit of Measure Code",SalesInvoiceLine."Unit of Measure Code");
          IF SalesInvoiceLine2.FIND('-') THEN
            REPEAT
              TotalQuantity := TotalQuantity + SalesInvoiceLine2.Quantity;
            UNTIL SalesInvoiceLine2.NEXT = 0;
        UNTIL SalesInvoiceHeader.NEXT = 0;

      SalesShipmentLine.SETCURRENTKEY("Order No.","Order Line No.");
      SalesShipmentLine.SETRANGE("Order No.","Sales Invoice Header"."Order No.");
      SalesShipmentLine.SETRANGE("Order Line No.",SalesInvoiceLine."Line No.");
      SalesShipmentLine.SETRANGE("Line No.",SalesInvoiceLine."Line No.");
      SalesShipmentLine.SETRANGE(Type,SalesInvoiceLine.Type);
      SalesShipmentLine.SETRANGE("No.",SalesInvoiceLine."No.");
      SalesShipmentLine.SETRANGE("Unit of Measure Code",SalesInvoiceLine."Unit of Measure Code");
      SalesShipmentLine.SETFILTER(Quantity,'<>%1',0);

      IF SalesShipmentLine.FIND('-') THEN
        REPEAT
          IF "Sales Invoice Header"."Get Shipment Used" THEN
            CorrectShipment(SalesShipmentLine);
          IF ABS(SalesShipmentLine.Quantity) <= ABS(TotalQuantity - SalesInvoiceLine.Quantity) THEN
            TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity
          ELSE BEGIN
            IF ABS(SalesShipmentLine.Quantity) > ABS(TotalQuantity) THEN
              SalesShipmentLine.Quantity := TotalQuantity;
            Quantity :=
              SalesShipmentLine.Quantity - (TotalQuantity - SalesInvoiceLine.Quantity);

            TotalQuantity := TotalQuantity - SalesShipmentLine.Quantity;
            SalesInvoiceLine.Quantity := SalesInvoiceLine.Quantity - Quantity;

            IF SalesShipmentHeader.GET(SalesShipmentLine."Document No.") THEN
              AddBufferEntry(
                SalesInvoiceLine,
                Quantity,
                SalesShipmentHeader."Posting Date");
          END;
        UNTIL (SalesShipmentLine.NEXT = 0) OR (TotalQuantity = 0);
    END;

    LOCAL PROCEDURE CorrectShipment@7(VAR SalesShipmentLine@1001 : Record 111);
    VAR
      SalesInvoiceLine@1000 : Record 113;
    BEGIN
      SalesInvoiceLine.SETCURRENTKEY("Shipment No.","Shipment Line No.");
      SalesInvoiceLine.SETRANGE("Shipment No.",SalesShipmentLine."Document No.");
      SalesInvoiceLine.SETRANGE("Shipment Line No.",SalesShipmentLine."Line No.");
      IF SalesInvoiceLine.FIND('-') THEN
        REPEAT
          SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
        UNTIL SalesInvoiceLine.NEXT = 0;
    END;

    LOCAL PROCEDURE AddBufferEntry@3(SalesInvoiceLine@1001 : Record 113;QtyOnShipment@1002 : Decimal;PostingDate@1003 : Date);
    BEGIN
      SalesShipmentBuffer.SETRANGE("Document No.",SalesInvoiceLine."Document No.");
      SalesShipmentBuffer.SETRANGE("Line No.",SalesInvoiceLine."Line No.");
      SalesShipmentBuffer.SETRANGE("Posting Date",PostingDate);
      IF SalesShipmentBuffer.FIND('-') THEN BEGIN
        SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
        SalesShipmentBuffer.MODIFY;
        EXIT;
      END;

      WITH SalesShipmentBuffer DO BEGIN
        "Document No." := SalesInvoiceLine."Document No.";
        "Line No." := SalesInvoiceLine."Line No.";
        "Entry No." := NextEntryNo;
        Type := SalesInvoiceLine.Type;
        "No." := SalesInvoiceLine."No.";
        Quantity := QtyOnShipment;
        "Posting Date" := PostingDate;
        INSERT;
        NextEntryNo := NextEntryNo + 1
      END;
    END;

    LOCAL PROCEDURE DocumentCaption@4() : Text[250];
    BEGIN
      IF "Sales Invoice Header"."Prepayment Invoice" THEN
        EXIT(Text010);
      EXIT(Text004);
    END;

    PROCEDURE InitializeRequest@5(NewNoOfCopies@1000 : Integer;NewShowInternalInfo@1001 : Boolean;NewLogInteraction@1002 : Boolean;DisplayAsmInfo@1003 : Boolean);
    BEGIN
      NoOfCopies := NewNoOfCopies;
      ShowInternalInfo := NewShowInternalInfo;
      LogInteraction := NewLogInteraction;
      DisplayAssemblyInformation := DisplayAsmInfo;
    END;

    LOCAL PROCEDURE FormatDocumentFields@13(SalesInvoiceHeader@1000 : Record 112);
    BEGIN
      WITH SalesInvoiceHeader DO BEGIN
        FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
        FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

        OrderNoText := FormatDocument.SetText("Order No." <> '',FIELDCAPTION("Order No."));
        ReferenceText := FormatDocument.SetText("Your Reference" <> '',FIELDCAPTION("Your Reference"));
        VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FIELDCAPTION("VAT Registration No."));
        IBANCaption := FormatDocument.SetText(CompanyInfo.IBAN <> '',CompanyInfoIBANCptnLbl);
        EANText := FormatDocument.SetText("EAN No." <> '',FIELDCAPTION("EAN No."));
        IntAccountCodeText := FormatDocument.SetText("Account Code" <> '',FIELDCAPTION("Account Code"));
        IF AccountCodeLineSpecified THEN
          "Account Code" := '(Linjespecificeret)';
        CustVatNoText := FormatDocument.SetText(Cust."VAT Registration No." <> '',Cust.FIELDCAPTION("VAT Registration No."));
      END;
    END;

    LOCAL PROCEDURE FormatAddressFields@16(SalesInvoiceHeader@1000 : Record 112);
    BEGIN
      FormatAddr.GetCompanyAddr(SalesInvoiceHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
      FormatAddr.SalesInvBillTo(CustAddr,SalesInvoiceHeader);
      ShowShippingAddr := FormatAddr.SalesInvShipTo(ShipToAddr,CustAddr,SalesInvoiceHeader);
    END;

    LOCAL PROCEDURE CollectAsmInformation@9();
    VAR
      ValueEntry@1000 : Record 5802;
      ItemLedgerEntry@1001 : Record 32;
      PostedAsmHeader@1002 : Record 910;
      PostedAsmLine@1004 : Record 911;
      SalesShipmentLine@1003 : Record 111;
    BEGIN
      TempPostedAsmLine.DELETEALL;
      IF "Sales Invoice Line".Type <> "Sales Invoice Line".Type::Item THEN
        EXIT;
      WITH ValueEntry DO BEGIN
        SETCURRENTKEY("Document No.");
        SETRANGE("Document No.","Sales Invoice Line"."Document No.");
        SETRANGE("Document Type","Document Type"::"Sales Invoice");
        SETRANGE("Document Line No.","Sales Invoice Line"."Line No.");
        SETRANGE(Adjustment,FALSE);
        IF NOT FINDSET THEN
          EXIT;
      END;
      REPEAT
        IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN
          IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" THEN BEGIN
            SalesShipmentLine.GET(ItemLedgerEntry."Document No.",ItemLedgerEntry."Document Line No.");
            IF SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN BEGIN
              PostedAsmLine.SETRANGE("Document No.",PostedAsmHeader."No.");
              IF PostedAsmLine.FINDSET THEN
                REPEAT
                  TreatAsmLineBuffer(PostedAsmLine);
                UNTIL PostedAsmLine.NEXT = 0;
            END;
          END;
      UNTIL ValueEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE TreatAsmLineBuffer@10(PostedAsmLine@1000 : Record 911);
    BEGIN
      CLEAR(TempPostedAsmLine);
      TempPostedAsmLine.SETRANGE(Type,PostedAsmLine.Type);
      TempPostedAsmLine.SETRANGE("No.",PostedAsmLine."No.");
      TempPostedAsmLine.SETRANGE("Variant Code",PostedAsmLine."Variant Code");
      TempPostedAsmLine.SETRANGE(Description,PostedAsmLine.Description);
      TempPostedAsmLine.SETRANGE("Unit of Measure Code",PostedAsmLine."Unit of Measure Code");
      IF TempPostedAsmLine.FINDFIRST THEN BEGIN
        TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
        TempPostedAsmLine.MODIFY;
      END ELSE BEGIN
        CLEAR(TempPostedAsmLine);
        TempPostedAsmLine := PostedAsmLine;
        TempPostedAsmLine.INSERT;
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

    PROCEDURE BlanksForIndent@11() : Text[10];
    BEGIN
      EXIT(PADSTR('',2,' '));
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

    LOCAL PROCEDURE CalcVATAmountLineLCY@14(SalesInvoiceHeader@1003 : Record 112;TempVATAmountLine2@1001 : TEMPORARY Record 290;VAR TempVATAmountLineLCY2@1000 : TEMPORARY Record 290;VAR VATBaseRemainderAfterRoundingLCY2@1002 : Decimal;VAR AmtInclVATRemainderAfterRoundingLCY2@1005 : Decimal);
    VAR
      VATBaseLCY@1004 : Decimal;
      AmtInclVATLCY@1006 : Decimal;
    BEGIN
      IF (NOT GLSetup."Print VAT specification in LCY") OR
         (SalesInvoiceHeader."Currency Code" = '')
      THEN
        EXIT;

      TempVATAmountLineLCY2.INIT;
      TempVATAmountLineLCY2 := TempVATAmountLine2;
      WITH SalesInvoiceHeader DO BEGIN
        VATBaseLCY :=
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code",TempVATAmountLine2."VAT Base","Currency Factor") +
          VATBaseRemainderAfterRoundingLCY2;
        AmtInclVATLCY :=
          CurrExchRate.ExchangeAmtFCYToLCY(
            "Posting Date","Currency Code",TempVATAmountLine2."Amount Including VAT","Currency Factor") +
          AmtInclVATRemainderAfterRoundingLCY2;
      END;
      TempVATAmountLineLCY2."VAT Base" := ROUND(VATBaseLCY);
      TempVATAmountLineLCY2."Amount Including VAT" := ROUND(AmtInclVATLCY);
      TempVATAmountLineLCY2.InsertLine;

      VATBaseRemainderAfterRoundingLCY2 := VATBaseLCY - TempVATAmountLineLCY2."VAT Base";
      AmtInclVATRemainderAfterRoundingLCY2 := AmtInclVATLCY - TempVATAmountLineLCY2."Amount Including VAT";
    END;

    [Integration(DEFAULT,TRUE)]
    PROCEDURE OnAfterGetRecordSalesInvoiceHeader@1213(SalesInvoiceHeader@1213 : Record 112);
    BEGIN
    END;

    [Integration]
    PROCEDURE OnGetReferenceText@1214(SalesInvoiceHeader@1000 : Record 112;VAR ReferenceText@1001 : Text[80];VAR Handled@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    PROCEDURE OnGetDocumentReferenceText@1060000(SalesInvoiceHeader@1060000 : Record 112;VAR DocumentReference@1060001 : Text;VAR DocumentReferenceText@1060002 : Text;VAR Handled@1060003 : Boolean);
    BEGIN
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
      <rd:DataSourceID>8a468d3b-c480-4411-94c6-261dc7040a5b</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="No_SalesInvHdr">
          <DataField>No_SalesInvHdr</DataField>
        </Field>
        <Field Name="InvDiscountAmtCaption">
          <DataField>InvDiscountAmtCaption</DataField>
        </Field>
        <Field Name="DocumentDateCaption">
          <DataField>DocumentDateCaption</DataField>
        </Field>
        <Field Name="PaymentTermsDescCaption">
          <DataField>PaymentTermsDescCaption</DataField>
        </Field>
        <Field Name="ShptMethodDescCaption">
          <DataField>ShptMethodDescCaption</DataField>
        </Field>
        <Field Name="VATPercentageCaption">
          <DataField>VATPercentageCaption</DataField>
        </Field>
        <Field Name="TotalCaption">
          <DataField>TotalCaption</DataField>
        </Field>
        <Field Name="VATBaseCaption">
          <DataField>VATBaseCaption</DataField>
        </Field>
        <Field Name="VATAmtCaption">
          <DataField>VATAmtCaption</DataField>
        </Field>
        <Field Name="VATIdentifierCaption">
          <DataField>VATIdentifierCaption</DataField>
        </Field>
        <Field Name="HomePageCaption">
          <DataField>HomePageCaption</DataField>
        </Field>
        <Field Name="EMailCaption">
          <DataField>EMailCaption</DataField>
        </Field>
        <Field Name="DisplayAdditionalFeeNote">
          <DataField>DisplayAdditionalFeeNote</DataField>
        </Field>
        <Field Name="HomePage">
          <DataField>HomePage</DataField>
        </Field>
        <Field Name="EMail">
          <DataField>EMail</DataField>
        </Field>
        <Field Name="CompanyInfo2Picture">
          <DataField>CompanyInfo2Picture</DataField>
        </Field>
        <Field Name="CompanyInfo1Picture">
          <DataField>CompanyInfo1Picture</DataField>
        </Field>
        <Field Name="CompanyInfoPicture">
          <DataField>CompanyInfoPicture</DataField>
        </Field>
        <Field Name="CompanyInfo3Picture">
          <DataField>CompanyInfo3Picture</DataField>
        </Field>
        <Field Name="DocumentCaptionCopyText">
          <DataField>DocumentCaptionCopyText</DataField>
        </Field>
        <Field Name="CustAddr1">
          <DataField>CustAddr1</DataField>
        </Field>
        <Field Name="CompanyAddr1">
          <DataField>CompanyAddr1</DataField>
        </Field>
        <Field Name="CustAddr2">
          <DataField>CustAddr2</DataField>
        </Field>
        <Field Name="CompanyAddr2">
          <DataField>CompanyAddr2</DataField>
        </Field>
        <Field Name="CustAddr3">
          <DataField>CustAddr3</DataField>
        </Field>
        <Field Name="CompanyAddr3">
          <DataField>CompanyAddr3</DataField>
        </Field>
        <Field Name="CustAddr4">
          <DataField>CustAddr4</DataField>
        </Field>
        <Field Name="CompanyAddr4">
          <DataField>CompanyAddr4</DataField>
        </Field>
        <Field Name="CustAddr5">
          <DataField>CustAddr5</DataField>
        </Field>
        <Field Name="CompanyInfoPhoneNo">
          <DataField>CompanyInfoPhoneNo</DataField>
        </Field>
        <Field Name="CustAddr6">
          <DataField>CustAddr6</DataField>
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
        <Field Name="CompanyInfoBankAccNo">
          <DataField>CompanyInfoBankAccNo</DataField>
        </Field>
        <Field Name="CompanyInfoIBAN">
          <DataField>CompanyInfoIBAN</DataField>
        </Field>
        <Field Name="BilltoCustNo_SalesInvHdr">
          <DataField>BilltoCustNo_SalesInvHdr</DataField>
        </Field>
        <Field Name="PostingDate_SalesInvHdr">
          <DataField>PostingDate_SalesInvHdr</DataField>
        </Field>
        <Field Name="VATNoText">
          <DataField>VATNoText</DataField>
        </Field>
        <Field Name="VATRegNo_SalesInvHdr">
          <DataField>VATRegNo_SalesInvHdr</DataField>
        </Field>
        <Field Name="DueDate_SalesInvHdr">
          <DataField>DueDate_SalesInvHdr</DataField>
        </Field>
        <Field Name="SalesPersonText">
          <DataField>SalesPersonText</DataField>
        </Field>
        <Field Name="SalesPurchPersonName">
          <DataField>SalesPurchPersonName</DataField>
        </Field>
        <Field Name="ReferenceText">
          <DataField>ReferenceText</DataField>
        </Field>
        <Field Name="YourReference_SalesInvHdr">
          <DataField>YourReference_SalesInvHdr</DataField>
        </Field>
        <Field Name="OrderNoText">
          <DataField>OrderNoText</DataField>
        </Field>
        <Field Name="HdrOrderNo_SalesInvHdr">
          <DataField>HdrOrderNo_SalesInvHdr</DataField>
        </Field>
        <Field Name="CustAddr7">
          <DataField>CustAddr7</DataField>
        </Field>
        <Field Name="CustAddr8">
          <DataField>CustAddr8</DataField>
        </Field>
        <Field Name="CompanyAddr5">
          <DataField>CompanyAddr5</DataField>
        </Field>
        <Field Name="CompanyAddr6">
          <DataField>CompanyAddr6</DataField>
        </Field>
        <Field Name="DocDate_SalesInvHdr">
          <DataField>DocDate_SalesInvHdr</DataField>
        </Field>
        <Field Name="PricesInclVAT_SalesInvHdr">
          <DataField>PricesInclVAT_SalesInvHdr</DataField>
        </Field>
        <Field Name="OutputNo">
          <DataField>OutputNo</DataField>
        </Field>
        <Field Name="PricesInclVATYesNo_SalesInvHdr">
          <DataField>PricesInclVATYesNo_SalesInvHdr</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="SelltoContactEMail_SalesInvHdr">
          <DataField>SelltoContactEMail_SalesInvHdr</DataField>
        </Field>
        <Field Name="SelltoContact_SalesInvHdr">
          <DataField>SelltoContact_SalesInvHdr</DataField>
        </Field>
        <Field Name="AccountCode_SalesInvHdr">
          <DataField>AccountCode_SalesInvHdr</DataField>
        </Field>
        <Field Name="EANNo_SalesInvHdr">
          <DataField>EANNo_SalesInvHdr</DataField>
        </Field>
        <Field Name="EANText">
          <DataField>EANText</DataField>
        </Field>
        <Field Name="IntAccountCodeText">
          <DataField>IntAccountCodeText</DataField>
        </Field>
        <Field Name="PaymentTermsDesc">
          <DataField>PaymentTermsDesc</DataField>
        </Field>
        <Field Name="ShipmentMethodDesc">
          <DataField>ShipmentMethodDesc</DataField>
        </Field>
        <Field Name="CompanyInfoPhoneNoCaption">
          <DataField>CompanyInfoPhoneNoCaption</DataField>
        </Field>
        <Field Name="CompanyInfoVATRegNoCptn">
          <DataField>CompanyInfoVATRegNoCptn</DataField>
        </Field>
        <Field Name="SelltoContactPhoneNo_SalesInvHdr">
          <DataField>SelltoContactPhoneNo_SalesInvHdr</DataField>
        </Field>
        <Field Name="CompanyInfoGiroNoCaption">
          <DataField>CompanyInfoGiroNoCaption</DataField>
        </Field>
        <Field Name="CompanyInfoBankNameCptn">
          <DataField>CompanyInfoBankNameCptn</DataField>
        </Field>
        <Field Name="CompanyInfoBankAccNoCptn">
          <DataField>CompanyInfoBankAccNoCptn</DataField>
        </Field>
        <Field Name="CompanyInfoIBANCptn">
          <DataField>CompanyInfoIBANCptn</DataField>
        </Field>
        <Field Name="SalesInvDueDateCaption">
          <DataField>SalesInvDueDateCaption</DataField>
        </Field>
        <Field Name="InvNoCaption">
          <DataField>InvNoCaption</DataField>
        </Field>
        <Field Name="SalesInvPostingDateCptn">
          <DataField>SalesInvPostingDateCptn</DataField>
        </Field>
        <Field Name="BilltoCustNo_SalesInvHdrCaption">
          <DataField>BilltoCustNo_SalesInvHdrCaption</DataField>
        </Field>
        <Field Name="PricesInclVAT_SalesInvHdrCaption">
          <DataField>PricesInclVAT_SalesInvHdrCaption</DataField>
        </Field>
        <Field Name="DocumentReferenceTxt">
          <DataField>DocumentReferenceTxt</DataField>
        </Field>
        <Field Name="DocumentReference">
          <DataField>DocumentReference</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="DimensionLoop1Number">
          <DataField>DimensionLoop1Number</DataField>
        </Field>
        <Field Name="HeaderDimCaption">
          <DataField>HeaderDimCaption</DataField>
        </Field>
        <Field Name="LineAmt_SalesInvLine">
          <DataField>LineAmt_SalesInvLine</DataField>
        </Field>
        <Field Name="LineAmt_SalesInvLineFormat">
          <DataField>LineAmt_SalesInvLineFormat</DataField>
        </Field>
        <Field Name="Desc_SalesInvLine">
          <DataField>Desc_SalesInvLine</DataField>
        </Field>
        <Field Name="No_SalesInvLine">
          <DataField>No_SalesInvLine</DataField>
        </Field>
        <Field Name="Qty_SalesInvLine">
          <DataField>Qty_SalesInvLine</DataField>
        </Field>
        <Field Name="Qty_SalesInvLineFormat">
          <DataField>Qty_SalesInvLineFormat</DataField>
        </Field>
        <Field Name="UOM_SalesInvLine">
          <DataField>UOM_SalesInvLine</DataField>
        </Field>
        <Field Name="UnitPrice_SalesInvLine">
          <DataField>UnitPrice_SalesInvLine</DataField>
        </Field>
        <Field Name="UnitPrice_SalesInvLineFormat">
          <DataField>UnitPrice_SalesInvLineFormat</DataField>
        </Field>
        <Field Name="Discount_SalesInvLine">
          <DataField>Discount_SalesInvLine</DataField>
        </Field>
        <Field Name="Discount_SalesInvLineFormat">
          <DataField>Discount_SalesInvLineFormat</DataField>
        </Field>
        <Field Name="VATIdentifier_SalesInvLine">
          <DataField>VATIdentifier_SalesInvLine</DataField>
        </Field>
        <Field Name="PostedShipmentDate">
          <DataField>PostedShipmentDate</DataField>
        </Field>
        <Field Name="Type_SalesInvLine">
          <DataField>Type_SalesInvLine</DataField>
        </Field>
        <Field Name="InvDiscLineAmt_SalesInvLine">
          <DataField>InvDiscLineAmt_SalesInvLine</DataField>
        </Field>
        <Field Name="InvDiscLineAmt_SalesInvLineFormat">
          <DataField>InvDiscLineAmt_SalesInvLineFormat</DataField>
        </Field>
        <Field Name="TotalSubTotal">
          <DataField>TotalSubTotal</DataField>
        </Field>
        <Field Name="TotalSubTotalFormat">
          <DataField>TotalSubTotalFormat</DataField>
        </Field>
        <Field Name="TotalInvDiscAmount">
          <DataField>TotalInvDiscAmount</DataField>
        </Field>
        <Field Name="TotalInvDiscAmountFormat">
          <DataField>TotalInvDiscAmountFormat</DataField>
        </Field>
        <Field Name="TotalText">
          <DataField>TotalText</DataField>
        </Field>
        <Field Name="Amount_SalesInvLine">
          <DataField>Amount_SalesInvLine</DataField>
        </Field>
        <Field Name="Amount_SalesInvLineFormat">
          <DataField>Amount_SalesInvLineFormat</DataField>
        </Field>
        <Field Name="TotalAmount">
          <DataField>TotalAmount</DataField>
        </Field>
        <Field Name="TotalAmountFormat">
          <DataField>TotalAmountFormat</DataField>
        </Field>
        <Field Name="Amount_AmtInclVAT">
          <DataField>Amount_AmtInclVAT</DataField>
        </Field>
        <Field Name="Amount_AmtInclVATFormat">
          <DataField>Amount_AmtInclVATFormat</DataField>
        </Field>
        <Field Name="AmtInclVAT_SalesInvLine">
          <DataField>AmtInclVAT_SalesInvLine</DataField>
        </Field>
        <Field Name="AmtInclVAT_SalesInvLineFormat">
          <DataField>AmtInclVAT_SalesInvLineFormat</DataField>
        </Field>
        <Field Name="VATAmtLineVATAmtText">
          <DataField>VATAmtLineVATAmtText</DataField>
        </Field>
        <Field Name="TotalExclVATText">
          <DataField>TotalExclVATText</DataField>
        </Field>
        <Field Name="TotalInclVATText">
          <DataField>TotalInclVATText</DataField>
        </Field>
        <Field Name="TotalAmountInclVAT">
          <DataField>TotalAmountInclVAT</DataField>
        </Field>
        <Field Name="TotalAmountInclVATFormat">
          <DataField>TotalAmountInclVATFormat</DataField>
        </Field>
        <Field Name="TotalAmountVAT">
          <DataField>TotalAmountVAT</DataField>
        </Field>
        <Field Name="TotalAmountVATFormat">
          <DataField>TotalAmountVATFormat</DataField>
        </Field>
        <Field Name="LineAmtAfterInvDiscAmt">
          <DataField>LineAmtAfterInvDiscAmt</DataField>
        </Field>
        <Field Name="LineAmtAfterInvDiscAmtFormat">
          <DataField>LineAmtAfterInvDiscAmtFormat</DataField>
        </Field>
        <Field Name="VATBaseDisc_SalesInvHdr">
          <DataField>VATBaseDisc_SalesInvHdr</DataField>
        </Field>
        <Field Name="VATBaseDisc_SalesInvHdrFormat">
          <DataField>VATBaseDisc_SalesInvHdrFormat</DataField>
        </Field>
        <Field Name="TotalPaymentDiscOnVAT">
          <DataField>TotalPaymentDiscOnVAT</DataField>
        </Field>
        <Field Name="TotalPaymentDiscOnVATFormat">
          <DataField>TotalPaymentDiscOnVATFormat</DataField>
        </Field>
        <Field Name="TotalInclVATText_SalesInvLine">
          <DataField>TotalInclVATText_SalesInvLine</DataField>
        </Field>
        <Field Name="VATAmtText_SalesInvLine">
          <DataField>VATAmtText_SalesInvLine</DataField>
        </Field>
        <Field Name="DocNo_SalesInvLine">
          <DataField>DocNo_SalesInvLine</DataField>
        </Field>
        <Field Name="LineNo_SalesInvLine">
          <DataField>LineNo_SalesInvLine</DataField>
        </Field>
        <Field Name="UnitPriceCaption">
          <DataField>UnitPriceCaption</DataField>
        </Field>
        <Field Name="SalesInvLineDiscCaption">
          <DataField>SalesInvLineDiscCaption</DataField>
        </Field>
        <Field Name="AmountCaption">
          <DataField>AmountCaption</DataField>
        </Field>
        <Field Name="PostedShipmentDateCaption">
          <DataField>PostedShipmentDateCaption</DataField>
        </Field>
        <Field Name="SubtotalCaption">
          <DataField>SubtotalCaption</DataField>
        </Field>
        <Field Name="LineAmtAfterInvDiscCptn">
          <DataField>LineAmtAfterInvDiscCptn</DataField>
        </Field>
        <Field Name="Desc_SalesInvLineCaption">
          <DataField>Desc_SalesInvLineCaption</DataField>
        </Field>
        <Field Name="No_SalesInvLineCaption">
          <DataField>No_SalesInvLineCaption</DataField>
        </Field>
        <Field Name="Qty_SalesInvLineCaption">
          <DataField>Qty_SalesInvLineCaption</DataField>
        </Field>
        <Field Name="UOM_SalesInvLineCaption">
          <DataField>UOM_SalesInvLineCaption</DataField>
        </Field>
        <Field Name="VATIdentifier_SalesInvLineCaption">
          <DataField>VATIdentifier_SalesInvLineCaption</DataField>
        </Field>
        <Field Name="IsLineWithTotals">
          <DataField>IsLineWithTotals</DataField>
        </Field>
        <Field Name="SalesShptBufferPostDate">
          <DataField>SalesShptBufferPostDate</DataField>
        </Field>
        <Field Name="SalesShptBufferQty">
          <DataField>SalesShptBufferQty</DataField>
        </Field>
        <Field Name="SalesShptBufferQtyFormat">
          <DataField>SalesShptBufferQtyFormat</DataField>
        </Field>
        <Field Name="ShipmentCaption">
          <DataField>ShipmentCaption</DataField>
        </Field>
        <Field Name="DimText_DimLoop">
          <DataField>DimText_DimLoop</DataField>
        </Field>
        <Field Name="LineDimCaption">
          <DataField>LineDimCaption</DataField>
        </Field>
        <Field Name="TempPostedAsmLineNo">
          <DataField>TempPostedAsmLineNo</DataField>
        </Field>
        <Field Name="TempPostedAsmLineQuantity">
          <DataField>TempPostedAsmLineQuantity</DataField>
        </Field>
        <Field Name="TempPostedAsmLineQuantityFormat">
          <DataField>TempPostedAsmLineQuantityFormat</DataField>
        </Field>
        <Field Name="TempPostedAsmLineDesc">
          <DataField>TempPostedAsmLineDesc</DataField>
        </Field>
        <Field Name="TempPostAsmLineVartCode">
          <DataField>TempPostAsmLineVartCode</DataField>
        </Field>
        <Field Name="TempPostedAsmLineUOM">
          <DataField>TempPostedAsmLineUOM</DataField>
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
        <Field Name="VATAmtLineVATPer">
          <DataField>VATAmtLineVATPer</DataField>
        </Field>
        <Field Name="VATAmtLineVATPerFormat">
          <DataField>VATAmtLineVATPerFormat</DataField>
        </Field>
        <Field Name="VATAmtLineVATIdentifier">
          <DataField>VATAmtLineVATIdentifier</DataField>
        </Field>
        <Field Name="VATAmtSpecificationCptn">
          <DataField>VATAmtSpecificationCptn</DataField>
        </Field>
        <Field Name="InvDiscBaseAmtCaption">
          <DataField>InvDiscBaseAmtCaption</DataField>
        </Field>
        <Field Name="LineAmtCaption">
          <DataField>LineAmtCaption</DataField>
        </Field>
        <Field Name="VATClauseVATIdentifier">
          <DataField>VATClauseVATIdentifier</DataField>
        </Field>
        <Field Name="VATClauseCode">
          <DataField>VATClauseCode</DataField>
        </Field>
        <Field Name="VATClauseDescription">
          <DataField>VATClauseDescription</DataField>
        </Field>
        <Field Name="VATClauseDescription2">
          <DataField>VATClauseDescription2</DataField>
        </Field>
        <Field Name="VATClauseAmount">
          <DataField>VATClauseAmount</DataField>
        </Field>
        <Field Name="VATClauseAmountFormat">
          <DataField>VATClauseAmountFormat</DataField>
        </Field>
        <Field Name="VATClausesCaption">
          <DataField>VATClausesCaption</DataField>
        </Field>
        <Field Name="VATClauseVATIdentifierCaption">
          <DataField>VATClauseVATIdentifierCaption</DataField>
        </Field>
        <Field Name="VATClauseVATAmtCaption">
          <DataField>VATClauseVATAmtCaption</DataField>
        </Field>
        <Field Name="VALSpecLCYHeader">
          <DataField>VALSpecLCYHeader</DataField>
        </Field>
        <Field Name="VALExchRate">
          <DataField>VALExchRate</DataField>
        </Field>
        <Field Name="VALVATBaseLCY">
          <DataField>VALVATBaseLCY</DataField>
        </Field>
        <Field Name="VALVATBaseLCYFormat">
          <DataField>VALVATBaseLCYFormat</DataField>
        </Field>
        <Field Name="VALVATAmountLCY">
          <DataField>VALVATAmountLCY</DataField>
        </Field>
        <Field Name="VALVATAmountLCYFormat">
          <DataField>VALVATAmountLCYFormat</DataField>
        </Field>
        <Field Name="VATPer_VATCounterLCY">
          <DataField>VATPer_VATCounterLCY</DataField>
        </Field>
        <Field Name="VATPer_VATCounterLCYFormat">
          <DataField>VATPer_VATCounterLCYFormat</DataField>
        </Field>
        <Field Name="VATIdentifier_VATCounterLCY">
          <DataField>VATIdentifier_VATCounterLCY</DataField>
        </Field>
        <Field Name="PaymentServiceLogo">
          <DataField>PaymentServiceLogo</DataField>
        </Field>
        <Field Name="PaymentServiceURLText">
          <DataField>PaymentServiceURLText</DataField>
        </Field>
        <Field Name="PaymentServiceURL">
          <DataField>PaymentServiceURL</DataField>
        </Field>
        <Field Name="SelltoCustNo_SalesInvHdr">
          <DataField>SelltoCustNo_SalesInvHdr</DataField>
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
        <Field Name="ShiptoAddrCaption">
          <DataField>ShiptoAddrCaption</DataField>
        </Field>
        <Field Name="SelltoCustNo_SalesInvHdrCaption">
          <DataField>SelltoCustNo_SalesInvHdrCaption</DataField>
        </Field>
        <Field Name="LineFeeCaptionLbl">
          <DataField>LineFeeCaptionLbl</DataField>
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
                  <Width>18.15843cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>22.39783cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="TableVAT">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.15128cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.37145cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.69806cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.69806cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.94234cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.37145cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.92578cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.70556cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox661">
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
                                            <rd:DefaultName>Textbox661</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox9">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmtSpecificationCptn.Value)</Value>
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
                                            <rd:DefaultName>textbox9</rd:DefaultName>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATIdentifierCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifierCaption.Value</Value>
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
                                            <rd:DefaultName>VATAmtLineVATIdentifierCaption</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATPercentageCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPercentageCaption.Value</Value>
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
                                            <rd:DefaultName>VATAmtLineVATPercentageCaption</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
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
                                          <Textbox Name="LineAmtCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!LineAmtCaption.Value)</Value>
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
                                            <ZIndex>18</ZIndex>
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
                                          <Textbox Name="InvDiscBaseAmtCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!InvDiscBaseAmtCaption.Value)</Value>
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
                                            <ZIndex>17</ZIndex>
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
                                          <Textbox Name="VATAmtInvDiscCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Replace(Fields!InvDiscountAmtCaption.Value," ",chr(10))</Value>
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
                                            <ZIndex>16</ZIndex>
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
                                          <Textbox Name="VATAmtLineVATBaseCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBaseCaption.Value</Value>
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
                                            <ZIndex>15</ZIndex>
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
                                          <Textbox Name="VATAmtLineVATAmtCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtCaption.Value</Value>
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
                                            <ZIndex>14</ZIndex>
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
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox184">
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
                                            <rd:DefaultName>textbox184</rd:DefaultName>
                                            <Style>
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
                                    <Height>0.17638cm</Height>
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
                                            <rd:DefaultName>textbox177</rd:DefaultName>
                                            <Style>
                                              <TopBorder>
                                                <Color>Black</Color>
                                              </TopBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATIdentifier">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATIdentifier.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmtLineVATIdentifier</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATPercentage">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATPer.Value</Value>
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
                                            <rd:DefaultName>VATAmtLineVATPercentage</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineLineAmt">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineLineAmt.Value</Value>
                                                    <Style>
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
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineInvDiscBaseAmt">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineInvDiscBaseAmt.Value</Value>
                                                    <Style>
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
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineInvDiscAmt">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineInvDiscAmt.Value</Value>
                                                    <Style>
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
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATBase">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATBase.Value</Value>
                                                    <Style>
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
                                            <rd:DefaultName>VATAmtLineVATBase</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATAmt">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATAmt.Value</Value>
                                                    <Style>
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
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox646">
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
                                            <rd:DefaultName>Textbox646</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox647">
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
                                            <rd:DefaultName>Textbox647</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox648">
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
                                            <rd:DefaultName>Textbox648</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox649">
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
                                            <rd:DefaultName>Textbox649</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox650">
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
                                            <rd:DefaultName>Textbox650</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox651">
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
                                            <rd:DefaultName>Textbox651</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox652">
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
                                            <rd:DefaultName>Textbox652</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox639">
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
                                            <rd:DefaultName>Textbox639</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox640">
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
                                            <rd:DefaultName>Textbox640</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox641">
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
                                            <rd:DefaultName>Textbox641</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox642">
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
                                            <rd:DefaultName>Textbox642</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox643">
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
                                            <rd:DefaultName>Textbox643</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox644">
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
                                            <rd:DefaultName>Textbox644</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox645">
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
                                            <rd:DefaultName>Textbox645</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.4064cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLineVATBaseCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalCaption.Value</Value>
                                                    <Style>
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
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineLineAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineLineAmt.Value)</Value>
                                                    <Style>
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
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="VATAmtLineInvDiscBaseAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineInvDiscBaseAmt.Value)</Value>
                                                    <Style>
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
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="VATAmtLineInvDiscAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineInvDiscAmt.Value)</Value>
                                                    <Style>
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
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="VATAmountLineVATBase">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineVATBase.Value)</Value>
                                                    <Style>
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
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="VATAmtLineVATAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineVATAmt.Value)</Value>
                                                    <Style>
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
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Table_VAT_Details_Group">
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
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!VATAmtLineVATIdentifier.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>7.55cm</Top>
                              <Height>2.87582cm</Height>
                              <Width>18.15842cm</Width>
                              <Visibility>
                                <Hidden>=(Fields!VATAmtLineVATIdentifier.Value = "")</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="TableVATLCY">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>4.95414cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>5.03624cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>4.20543cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.96265cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.70556cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox668">
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
                                            <rd:DefaultName>Textbox668</rd:DefaultName>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VALSpecLCYHeader">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VALSpecLCYHeader.Value)</Value>
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
                                            <rd:DefaultName>VALSpecLCYHeader</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VALExchRate">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VALExchRate.Value)</Value>
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
                                            <rd:DefaultName>VALExchRate</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATIdentifieCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifierCaption.Value</Value>
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
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATPercentagCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPercentageCaption.Value</Value>
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
                                            <ZIndex>10</ZIndex>
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
                                          <Textbox Name="VALVATBaseLCYCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBaseCaption.Value</Value>
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
                                            <ZIndex>9</ZIndex>
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
                                          <Textbox Name="VALVATAmountLCYCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtCaption.Value</Value>
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
                                            <ZIndex>8</ZIndex>
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
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox192">
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
                                            <rd:DefaultName>textbox192</rd:DefaultName>
                                            <Style>
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
                                          <ColSpan>4</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox196">
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
                                            <rd:DefaultName>textbox196</rd:DefaultName>
                                            <Style>
                                              <TopBorder>
                                                <Color>Black</Color>
                                              </TopBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.4064cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATIdentif">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifier_VATCounterLCY.Value</Value>
                                                    <Style>
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
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmtLineVATPercentag">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATPer_VATCounterLCY.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATPer_VATCounterLCYFormat.Value</Format>
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
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VALVATBaseLCY">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATBaseLCY.Value</Value>
                                                    <Style>
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
                                            <rd:DefaultName>VALVATBaseLCY</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VALVATAmountLCY">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATAmountLCY.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VALVATAmountLCYFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VALVATAmountLCY</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox653">
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
                                            <rd:DefaultName>Textbox653</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>None</Style>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <BottomBorder>
                                                <Style>None</Style>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox654">
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
                                            <rd:DefaultName>Textbox654</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>None</Style>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <BottomBorder>
                                                <Style>None</Style>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox655">
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
                                            <rd:DefaultName>Textbox655</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>None</Style>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox656">
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
                                            <rd:DefaultName>Textbox656</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>None</Style>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <BottomBorder>
                                                <Style>Solid</Style>
                                              </BottomBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox657">
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
                                            <rd:DefaultName>Textbox657</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox658">
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
                                            <rd:DefaultName>Textbox658</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox659">
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
                                            <rd:DefaultName>Textbox659</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="Textbox660">
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
                                            <rd:DefaultName>Textbox660</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.4064cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VALVATBasLCYCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalCaption.Value</Value>
                                                    <Style>
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
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VALVATBseLCY_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VALVATBaseLCY.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VALVATBaseLCYFormat.Value</Format>
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
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
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
                                          <Textbox Name="VALVATAmtLCY">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VALVATAmountLCY.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VALVATAmountLCYFormat.Value</Format>
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
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Width>1pt</Width>
                                              </TopBorder>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Table_VATLCY_Details_Group">
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
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!VATIdentifier_VATCounterLCY.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>10.44574cm</Top>
                              <Height>3.28222cm</Height>
                              <Width>18.15846cm</Width>
                              <ZIndex>1</ZIndex>
                              <Visibility>
                                <Hidden>=(Fields!VATIdentifier_VATCounterLCY.Value = "")</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="TableLines">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.68358in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.5748in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.71341in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.68871in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.59055in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76772in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.73285in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.64934in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.74803in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesInvLineNoCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_SalesInvLineCaption.Value</Value>
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
                                            <rd:DefaultName>SalesInvLineNoCaption</rd:DefaultName>
                                            <ZIndex>152</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesInvLineDescCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Desc_SalesInvLineCaption.Value</Value>
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
                                          <Textbox Name="PostedShipmentDateCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!PostedShipmentDateCaption.Value)</Value>
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
                                            <rd:DefaultName>PostedShipmentDateCaption</rd:DefaultName>
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
                                          <Textbox Name="SalesInvLineQtyCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Qty_SalesInvLineCaption.Value</Value>
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
                                            <rd:DefaultName>SalesInvLineQtyCaption</rd:DefaultName>
                                            <ZIndex>149</ZIndex>
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
                                          <Textbox Name="SalesInvLineUOMCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UOM_SalesInvLineCaption.Value</Value>
                                                    <Style>
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
                                            <rd:DefaultName>SalesInvLineUOMCaption</rd:DefaultName>
                                            <ZIndex>148</ZIndex>
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
                                          <Textbox Name="UnitPriceCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!UnitPriceCaption.Value)</Value>
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
                                            <rd:DefaultName>UnitPriceCaption</rd:DefaultName>
                                            <ZIndex>147</ZIndex>
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
                                          <Textbox Name="SalesInvLineDiscCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!SalesInvLineDiscCaption.Value)</Value>
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
                                            <rd:DefaultName>SalesInvLineDiscCaption</rd:DefaultName>
                                            <ZIndex>146</ZIndex>
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
                                          <Textbox Name="SalesInvLineVATIdentifierCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATIdentifier_SalesInvLineCaption.Value</Value>
                                                    <Style>
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
                                            <rd:DefaultName>SalesInvLineVATIdentifierCaption</rd:DefaultName>
                                            <ZIndex>145</ZIndex>
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
                                          <Textbox Name="AmountCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AmountCaption.Value)</Value>
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
                                            <rd:DefaultName>AmountCaption</rd:DefaultName>
                                            <ZIndex>144</ZIndex>
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
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox11">
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
                                            <rd:DefaultName>textbox11</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox134">
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
                                            <rd:DefaultName>textbox134</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox144">
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
                                            <rd:DefaultName>textbox144</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox147">
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
                                            <rd:DefaultName>textbox147</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox148">
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
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox148</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox149">
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
                                            <rd:DefaultName>textbox149</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox156">
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
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox156</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox157">
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
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox157</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox158">
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
                                            <rd:DefaultName>textbox158</rd:DefaultName>
                                            <Style>
                                              <BottomBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox164">
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
                                            <rd:DefaultName>textbox164</rd:DefaultName>
                                            <Style>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>None</Style>
                                              </TopBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox4">
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
                                            <rd:DefaultName>textbox4</rd:DefaultName>
                                            <ZIndex>141</ZIndex>
                                            <Style>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox6">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Desc_SalesInvLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox6</rd:DefaultName>
                                            <ZIndex>140</ZIndex>
                                            <Style>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesInvLineNo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_SalesInvLine.Value</Value>
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
                                            <rd:DefaultName>SalesInvLineNo</rd:DefaultName>
                                            <ZIndex>137</ZIndex>
                                            <Style>
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
                                                    <Value>=Fields!Desc_SalesInvLine.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>136</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PostedShipmentDate">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PostedShipmentDate.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PostedShipmentDate</rd:DefaultName>
                                            <ZIndex>135</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesInvLineQty">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Qty_SalesInvLine.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!Qty_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>SalesInvLineQty</rd:DefaultName>
                                            <ZIndex>134</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesInvLineUOM">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UOM_SalesInvLine.Value</Value>
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
                                            <rd:DefaultName>SalesInvLineUOM</rd:DefaultName>
                                            <ZIndex>133</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesInvLineUnitPrice">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!UnitPrice_SalesInvLine.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!UnitPrice_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>SalesInvLineUnitPrice</rd:DefaultName>
                                            <ZIndex>132</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesInvLineDiscount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Discount_SalesInvLine.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!Discount_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>SalesInvLineDiscount</rd:DefaultName>
                                            <ZIndex>131</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesInvLineVATIdentifier">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=IIF(Trim(Fields!Type_SalesInvLine.Value) &lt;&gt; "",Fields!VATIdentifier_SalesInvLine.Value,"")</Value>
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
                                            <rd:DefaultName>SalesInvLineVATIdentifier</rd:DefaultName>
                                            <ZIndex>130</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesInvLineAmt">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!LineAmt_SalesInvLine.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!LineAmt_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>SalesInvLineAmt</rd:DefaultName>
                                            <ZIndex>129</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="textbox39">
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
                                            <rd:DefaultName>textbox39</rd:DefaultName>
                                            <ZIndex>126</ZIndex>
                                            <Style>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipmentCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipmentCaption.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipmentCaption</rd:DefaultName>
                                            <ZIndex>125</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesShptBufferPostingDate">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SalesShptBufferPostDate.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>SalesShptBufferPostingDate</rd:DefaultName>
                                            <ZIndex>124</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SalesShptBufferQty">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SalesShptBufferQty.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!SalesShptBufferQtyFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>SalesShptBufferQty</rd:DefaultName>
                                            <ZIndex>123</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox45</rd:DefaultName>
                                            <ZIndex>122</ZIndex>
                                            <Style>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox46">
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
                                            <rd:DefaultName>textbox46</rd:DefaultName>
                                            <ZIndex>121</ZIndex>
                                            <Style>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox47">
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
                                            <rd:DefaultName>textbox47</rd:DefaultName>
                                            <ZIndex>120</ZIndex>
                                            <Style>
                                              <PaddingRight>0.0625in</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox48">
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
                                            <rd:DefaultName>textbox48</rd:DefaultName>
                                            <ZIndex>119</ZIndex>
                                            <Style>
                                              <PaddingRight>0.0625in</PaddingRight>
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
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox49</rd:DefaultName>
                                            <ZIndex>118</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="LineDimCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineDimCaption.Value &amp; "    " &amp; Fields!DimText_DimLoop.Value</Value>
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
                                            <rd:DefaultName>LineDimCaption</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox133">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TempPostedAsmLineNo.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox133</rd:DefaultName>
                                            <Style>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox135">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TempPostedAsmLineDesc.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox134</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox140">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TempPostAsmLineVartCode.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox140</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox142">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TempPostedAsmLineQuantity.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox142</rd:DefaultName>
                                            <Visibility>
                                              <Hidden>=iif(Fields!TempPostedAsmLineNo.Value &lt;&gt; "",false,true)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox143">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TempPostedAsmLineUOM.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox143</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox141">
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
                                            <rd:DefaultName>textbox141</rd:DefaultName>
                                            <Style>
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
                                          <Textbox Name="textbox145">
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
                                            <rd:DefaultName>textbox144</rd:DefaultName>
                                            <Style>
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
                                          <Textbox Name="textbox150">
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
                                            <rd:DefaultName>textbox147</rd:DefaultName>
                                            <Style>
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
                                          <Textbox Name="textbox151">
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
                                            <rd:DefaultName>textbox148</rd:DefaultName>
                                            <Style>
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
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox92">
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
                                            <rd:DefaultName>textbox92</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingRight>0.0625in</PaddingRight>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Table_Lines_Group2">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!No_SalesInvHdr.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="Table_Lines_Group1">
                                          <GroupExpressions>
                                            <GroupExpression>=Fields!No_SalesInvHdr.Value</GroupExpression>
                                            <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                                            <GroupExpression>=Fields!LineNo_SalesInvLine.Value</GroupExpression>
                                          </GroupExpressions>
                                        </Group>
                                        <SortExpressions>
                                          <SortExpression>
                                            <Value>=Fields!LineNo_SalesInvLine.Value</Value>
                                          </SortExpression>
                                          <SortExpression>
                                            <Value>=Fields!OutputNo.Value</Value>
                                          </SortExpression>
                                          <SortExpression>
                                            <Value>=Fields!No_SalesInvHdr.Value</Value>
                                          </SortExpression>
                                        </SortExpressions>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=Iif(Fields!Type_SalesInvLine.Value = " ", false, true)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=Iif(Fields!Type_SalesInvLine.Value = " ", true, false)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Group Name="Table_Lines_Details_Group">
                                              <DataElementName>Detail</DataElementName>
                                            </Group>
                                            <SortExpressions>
                                              <SortExpression>
                                                <Value>=Fields!OutputNo.Value</Value>
                                              </SortExpression>
                                              <SortExpression>
                                                <Value>=Fields!No_SalesInvHdr.Value</Value>
                                              </SortExpression>
                                            </SortExpressions>
                                            <TablixMembers>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=(Fields!ShipmentCaption.Value="")</Hidden>
                                                </Visibility>
                                              </TablixMember>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=(Fields!DimText_DimLoop.Value = "")</Hidden>
                                                </Visibility>
                                              </TablixMember>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=iif(Fields!TempPostedAsmLineDesc.Value&lt;&gt; "",false,true)</Hidden>
                                                </Visibility>
                                              </TablixMember>
                                            </TablixMembers>
                                            <DataElementName>Detail_Collection</DataElementName>
                                            <DataElementOutput>Output</DataElementOutput>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                        </TablixMembers>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Cstr(Fields!LineNo_SalesInvLine.Value)</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>0.08982cm</Top>
                              <Height>2.82222cm</Height>
                              <Width>7.14899in</Width>
                              <ZIndex>2</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="HeaderDim">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.20937in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>5.93962in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.70556cm</Height>
                                    <TablixCells>
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
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox32">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!HeaderDimCaption.Value</Value>
                                                    <Style>
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
                                          <Textbox Name="textbox33">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText.Value</Value>
                                                    <Style>
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
                                              <VerticalAlign>Top</VerticalAlign>
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
                                          <Textbox Name="textbox34">
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
                                            <ZIndex>1</ZIndex>
                                            <Style>
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
                                    <Visibility>
                                      <Hidden>=IIF(Fields!DimensionLoop1Number.Value=1,False,True)</Hidden>
                                    </Visibility>
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
                              <Top>20.98671cm</Top>
                              <Height>1.41112cm</Height>
                              <Width>7.14899in</Width>
                              <ZIndex>3</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="TableSalesInvLine">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.56459cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CustAddr">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Cstr(Fields!CustAddr1.Value) + Chr(177) + 
Cstr(Fields!CustAddr2.Value) + Chr(177) + 
Cstr(Fields!CustAddr3.Value) + Chr(177) + 
Cstr(Fields!CustAddr4.Value) + Chr(177) + 
Cstr(Fields!CustAddr5.Value) + Chr(177) + 
Cstr(Fields!CustAddr6.Value) + Chr(177) + 
Cstr(Fields!CustAddr7.Value) + Chr(177) + 
Cstr(Fields!CustAddr8.Value) + Chr(177) + 
Cstr(Fields!BilltoCustNo_SalesInvHdr.Value) + Chr(177) + 
Cstr(Fields!VATRegNo_SalesInvHdr.Value) + Chr(177) + 
Cstr(Fields!YourReference_SalesInvHdr.Value) + Chr(177) + 
Cstr(Fields!No_SalesInvHdr.Value) + Chr(177) + 
Cstr(Fields!HdrOrderNo_SalesInvHdr.Value) + Chr(177) + 
Cstr(Fields!PostingDate_SalesInvHdr.Value) + Chr(177) + 
Cstr(Fields!DueDate_SalesInvHdr.Value) + Chr(177) + 
Cstr(Cstr(Fields!PricesInclVATYesNo_SalesInvHdr.Value)) + Chr(177) + 
Cstr(First(Fields!DocDate_SalesInvHdr.Value)) + Chr(177) + 
Cstr(Fields!SalesPurchPersonName.Value) + Chr(177) + 
Cstr(Fields!DocumentCaptionCopyText.Value) + Chr(177) + 
Cstr(Fields!PaymentTermsDesc.Value) + Chr(177) + 
Cstr(Fields!ShipmentMethodDesc.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr1.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr2.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr3.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr4.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr5.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr6.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoPhoneNo.Value) + Chr(177) + 
Cstr(Fields!OrderNoText.Value) + Chr(177) + 
Cstr(Fields!EMail.Value) + Chr(177) + 
Cstr(Fields!HomePage.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoVATRegNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoGiroNo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankName.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankAccNo.Value) + Chr(177) + 
Cstr(Fields!PricesInclVAT_SalesInvHdrCaption.Value) + Chr(177) + 
Cstr(Fields!InvNoCaption.Value) + Chr(177) + 
Cstr(Fields!SalesInvPostingDateCptn.Value) + Chr(177) + 
Cstr(Fields!BilltoCustNo_SalesInvHdrCaption.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankAccNoCptn.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoBankNameCptn.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoGiroNoCaption.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoVATRegNoCptn.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoPhoneNoCaption.Value) + Chr(177) + 
Cstr(Fields!PageCaption.Value) + Chr(177) + 
Cstr(Fields!ReferenceText.Value) + Chr(177) + 
Cstr(Fields!SalesPersonText.Value) + Chr(177) + 
Cstr(Fields!VATNoText.Value) + Chr(177) + 
Cstr(Fields!SalesInvDueDateCaption.Value) + Chr(177) + 
Cstr(Fields!DocumentDateCaption.Value) + Chr(177) + 
Cstr(Fields!PaymentTermsDescCaption.Value) + Chr(177) + 
Cstr(Fields!ShptMethodDescCaption.Value) + Chr(177) + 
Cstr(Fields!EMailCaption.Value) + Chr(177) + 
Cstr(Fields!HomePageCaption.Value) + Chr(177) +
Cstr(Fields!IntAccountCodeText.Value) + Chr(177)+
Cstr(Fields!AccountCode_SalesInvHdr.Value) + Chr(177)+
Cstr(Fields!EANText.Value) + Chr(177) +
Cstr(Fields!EANNo_SalesInvHdr.Value) + Chr(177) +
Cstr(Fields!DocumentReferenceTxt.Value) + Chr(177) +
Cstr(Fields!DocumentReference.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoIBANCptn.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoIBAN.Value)
, 1)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <Border />
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Height>0.42301cm</Height>
                              <Width>0.56459cm</Width>
                              <ZIndex>4</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="list2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>18.15843cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>1.80557in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Rectangle Name="list2_Contents">
                                            <ReportItems>
                                              <Tablix Name="TableShipToAdress">
                                                <TablixBody>
                                                  <TablixColumns>
                                                    <TablixColumn>
                                                      <Width>1.60388in</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>5.54511in</Width>
                                                    </TablixColumn>
                                                  </TablixColumns>
                                                  <TablixRows>
                                                    <TablixRow>
                                                      <Height>0.27778in</Height>
                                                      <TablixCells>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox672">
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
                                                              <rd:DefaultName>Textbox672</rd:DefaultName>
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
                                                            <Textbox Name="ShiptoAddrCaption">
                                                              <CanGrow>true</CanGrow>
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=First(Fields!ShiptoAddrCaption.Value)</Value>
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
                                                              <rd:DefaultName>ShiptoAddrCaption</rd:DefaultName>
                                                              <ZIndex>11</ZIndex>
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
                                                            <Textbox Name="SalesInvSelltoCustNoCaption">
                                                              <CanGrow>true</CanGrow>
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!SelltoCustNo_SalesInvHdrCaption.Value</Value>
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
                                                              <rd:DefaultName>SalesInvSelltoCustNoCaption</rd:DefaultName>
                                                              <ZIndex>10</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Bottom</VerticalAlign>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="SalesInvSelltoCustNo">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=First(Fields!SelltoCustNo_SalesInvHdr.Value)</Value>
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
                                                              <rd:DefaultName>SalesInvSelltoCustNo</rd:DefaultName>
                                                              <ZIndex>9</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Bottom</VerticalAlign>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                            <Textbox Name="textbox70">
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
                                                              <rd:DefaultName>textbox70</rd:DefaultName>
                                                              <ZIndex>8</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="ShipToAddr1">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!ShipToAddr1.Value</Value>
                                                                      <Style>
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
                                                            <Textbox Name="ShipToAddr2">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!ShipToAddr2.Value</Value>
                                                                      <Style>
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
                                                            <Textbox Name="ShipToAddr3">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!ShipToAddr3.Value</Value>
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
                                                              <ZIndex>5</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="ShipToAddr4">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!ShipToAddr4.Value</Value>
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
                                                              <rd:DefaultName>ShipToAddr4</rd:DefaultName>
                                                              <ZIndex>4</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="ShipToAddr5">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!ShipToAddr5.Value</Value>
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
                                                              <rd:DefaultName>ShipToAddr5</rd:DefaultName>
                                                              <ZIndex>3</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="ShipToAddr6">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!ShipToAddr6.Value</Value>
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
                                                              <rd:DefaultName>ShipToAddr6</rd:DefaultName>
                                                              <ZIndex>2</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="ShipToAddr7">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!ShipToAddr7.Value</Value>
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
                                                              <rd:DefaultName>ShipToAddr7</rd:DefaultName>
                                                              <ZIndex>1</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="ShipToAddr8">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!ShipToAddr8.Value</Value>
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>ShipToAddr8</rd:DefaultName>
                                                              <Style>
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
                                                    </TablixMember>
                                                    <TablixMember>
                                                      <KeepWithGroup>After</KeepWithGroup>
                                                      <KeepTogether>true</KeepTogether>
                                                    </TablixMember>
                                                    <TablixMember>
                                                      <Visibility>
                                                        <Hidden>=(First(Fields!SelltoCustNo_SalesInvHdr.Value)= First(Fields!BilltoCustNo_SalesInvHdr.Value))</Hidden>
                                                      </Visibility>
                                                      <KeepWithGroup>After</KeepWithGroup>
                                                      <KeepTogether>true</KeepTogether>
                                                    </TablixMember>
                                                    <TablixMember>
                                                      <Group Name="TableShipToAdress_Details_Group">
                                                        <DataElementName>Detail</DataElementName>
                                                      </Group>
                                                      <TablixMembers>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=(First(Fields!SelltoCustNo_SalesInvHdr.Value, "TableShipToAdress")= First(Fields!BilltoCustNo_SalesInvHdr.Value, "TableShipToAdress"))</Hidden>
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
                                                <Filters>
                                                  <Filter>
                                                    <FilterExpression>=Fields!ShipToAddr1.Value</FilterExpression>
                                                    <Operator>GreaterThan</Operator>
                                                    <FilterValues>
                                                      <FilterValue>=""</FilterValue>
                                                    </FilterValues>
                                                  </Filter>
                                                </Filters>
                                                <Height>1.80557in</Height>
                                                <Width>7.14899in</Width>
                                                <Visibility>
                                                  <Hidden>=(Fields!ShipToAddr1.Value = "")</Hidden>
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
                                    <Group Name="list2_Details_Group">
                                      <GroupExpressions>
                                        <GroupExpression>=1</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <KeepTogether>true</KeepTogether>
                              <Top>6.4486in</Top>
                              <Height>1.80557in</Height>
                              <Width>18.15843cm</Width>
                              <ZIndex>5</ZIndex>
                              <Visibility>
                                <Hidden>=(Fields!ShipToAddr1.Value = "")</Hidden>
                              </Visibility>
                              <Style />
                            </Tablix>
                            <Tablix Name="TableVATClauses">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2.66329cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.74848cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.96865cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.29527cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.29527cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>4.17027cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.88044cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.70556cm</Height>
                                    <TablixCells>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox662">
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
                                            <rd:DefaultName>Textbox661</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox20">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATClauseVATIdentifierCaption.Value)</Value>
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
                                            <rd:DefaultName>textbox9</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox12">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATClausesCaption.Value)</Value>
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
                                            <rd:DefaultName>textbox9</rd:DefaultName>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="VALVATAmountLCYCaption2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATClauseVATAmtCaption.Value</Value>
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
                                            <ZIndex>8</ZIndex>
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
                                    <Height>0.17638cm</Height>
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
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox28</rd:DefaultName>
                                            <Style>
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
                                          <Textbox Name="textbox185">
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
                                            <rd:DefaultName>textbox184</rd:DefaultName>
                                            <Style>
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
                                          <ColSpan>6</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.17638cm</Height>
                                    <TablixCells>
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
                                              <TopBorder>
                                                <Color>Black</Color>
                                              </TopBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox179">
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
                                            <rd:DefaultName>textbox177</rd:DefaultName>
                                            <Style>
                                              <TopBorder>
                                                <Color>Black</Color>
                                              </TopBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATClauseDescription3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATClauseVATIdentifier.Value</Value>
                                                    <Style>
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
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATClauseDescription">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATClauseDescription.Value</Value>
                                                    <Style>
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
                                          <Textbox Name="VATClauseAmount">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATClauseAmount.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATClauseAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <Visibility>
                                              <Hidden>=(Fields!VATClauseDescription2.Value &lt;&gt; "")</Hidden>
                                            </Visibility>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="Textbox51">
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
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATClauseDescription2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATClauseDescription2.Value</Value>
                                                    <Style>
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
                                          <Textbox Name="VATClauseAmount2">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATClauseAmount.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!VATClauseAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Table_VAT_Clauses">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember />
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=Len(Fields!VATClauseDescription2.Value) = 0</Hidden>
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
                                  <FilterExpression>=Len(Fields!VATClauseCode.Value)</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue DataType="Integer">0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>13.77243cm</Top>
                              <Left>0.00138cm</Left>
                              <Height>2.11666cm</Height>
                              <Width>18.02167cm</Width>
                              <ZIndex>6</ZIndex>
                              <Visibility>
                                <Hidden>=(Fields!VATClausesCaption.Value = "")</Hidden>
                              </Visibility>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Tablix>
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
                                          <Textbox Name="Textbox8">
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
                                            <rd:DefaultName>Textbox8</rd:DefaultName>
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
                                                  <Value>=Fields!LineFeeCaptionLbl.Value</Value>
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
                                  <FilterExpression>=Fields!LineFeeCaptionLbl.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>15.93144cm</Top>
                              <Left>0.16301cm</Left>
                              <Height>0.42333cm</Height>
                              <Width>17.88733cm</Width>
                              <ZIndex>7</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
                            </Tablix>
                            <Tablix Name="Tablix1">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>7cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.5cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.34314cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="SubtotalCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SubtotalCaption.Value</Value>
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
                                            <rd:DefaultName>SubtotalCaption</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalSubTotal1">
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
                                                      <Format>=Fields!LineAmt_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalSubTotal1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="InvDiscountAmtCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!InvDiscountAmtCaption.Value</Value>
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
                                            <rd:DefaultName>InvDiscountAmtCaption</rd:DefaultName>
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
                                          <Textbox Name="TotalInvDiscAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalInvDiscAmount.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!InvDiscLineAmt_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalInvDiscAmount</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="TotalText">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalText.Value</Value>
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
                                            <rd:DefaultName>TotalText</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!LineAmt_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmount</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="Textbox2">
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
                                          <Textbox Name="Textbox3">
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
                                            <rd:DefaultName>Textbox3</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="TotalExclVATText">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalExclVATText.Value</Value>
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
                                            <rd:DefaultName>TotalExclVATText</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalAmount1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!LineAmt_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmount1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="VATAmtLineVATAmtText">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATAmtText.Value</Value>
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
                                            <rd:DefaultName>VATAmtLineVATAmtText</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalAmountVAT">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmountVAT.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!Amount_AmtInclVATFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmountVAT</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="Textbox5">
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
                                          <Textbox Name="Textbox7">
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
                                            <rd:DefaultName>Textbox7</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                              <TopBorder>
                                                <Color>Black</Color>
                                                <Style>Solid</Style>
                                                <Width>1pt</Width>
                                              </TopBorder>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="TotalInclVATText">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalInclVATText.Value</Value>
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
                                            <rd:DefaultName>TotalInclVATText</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalAmountInclVAT">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmountInclVAT.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!AmtInclVAT_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmountInclVAT</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.32632cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="LineAmtAfterInvDiscCptn">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineAmtAfterInvDiscCptn.Value</Value>
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
                                            <rd:DefaultName>LineAmtAfterInvDiscCptn</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalPaymentDiscOnVAT">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalPaymentDiscOnVAT.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!AmtInclVAT_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalPaymentDiscOnVAT</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="TotalInclVATText1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalInclVATText.Value</Value>
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
                                            <rd:DefaultName>TotalInclVATText1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalAmountInclVAT1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmountInclVAT.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!AmtInclVAT_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmountInclVAT1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="Textbox1">
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
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
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
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Textbox36</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="VATAmtLineVATAmtText1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATAmtText.Value</Value>
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
                                            <rd:DefaultName>VATAmtLineVATAmtText1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalAmountVAT1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmountVAT.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!Amount_AmtInclVATFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmountVAT1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="TotalExclVATText1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalExclVATText.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <ListLevel>1</ListLevel>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalExclVATText1</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalAmount2">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!LineAmt_SalesInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmount2</rd:DefaultName>
                                            <Style>
                                              <Border>
                                                <Color>LightGrey</Color>
                                                <Style>None</Style>
                                              </Border>
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
                                    <Visibility>
                                      <Hidden>=IIF(Last(Fields!TotalInvDiscAmount.Value)=0,TRUE,FALSE)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF(Last(Fields!TotalInvDiscAmount.Value)=0,TRUE,FALSE)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!TotalAmountInclVAT.Value &lt;&gt; Fields!TotalAmount.Value</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!TotalAmountInclVAT.Value &lt;&gt; Fields!TotalAmount.Value</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!PricesInclVAT_SalesInvHdr.Value OR (Fields!TotalAmountInclVAT.Value = Fields!TotalAmount.Value)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!PricesInclVAT_SalesInvHdr.Value OR (Fields!TotalAmountInclVAT.Value = Fields!TotalAmount.Value)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!PricesInclVAT_SalesInvHdr.Value OR (Fields!TotalAmountInclVAT.Value = Fields!TotalAmount.Value)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!PricesInclVAT_SalesInvHdr.Value OR (Fields!TotalAmountInclVAT.Value = Fields!TotalAmount.Value)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=not((Fields!PricesInclVAT_SalesInvHdr.Value = true) and 
(Sum(Fields!AmtInclVAT_SalesInvLine.Value) &lt;&gt; Sum(Fields!Amount_SalesInvLine.Value)) and
(Fields!VATBaseDisc_SalesInvHdr.Value &lt;&gt; 0))</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Not(Fields!PricesInclVAT_SalesInvHdr.Value = true and 
(Sum(Fields!AmtInclVAT_SalesInvLine.Value) &lt;&gt; Sum(Fields!Amount_SalesInvLine.Value)))</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Not(Fields!PricesInclVAT_SalesInvHdr.Value = true and 
(Sum(Fields!AmtInclVAT_SalesInvLine.Value) &lt;&gt; Sum(Fields!Amount_SalesInvLine.Value)))</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Not(Fields!PricesInclVAT_SalesInvHdr.Value = true and 
(Sum(Fields!AmtInclVAT_SalesInvLine.Value) &lt;&gt; Sum(Fields!Amount_SalesInvLine.Value)))</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Not(Fields!PricesInclVAT_SalesInvHdr.Value = true and 
(Sum(Fields!AmtInclVAT_SalesInvLine.Value) &lt;&gt; Sum(Fields!Amount_SalesInvLine.Value)))</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!IsLineWithTotals.Value</FilterExpression>
                                  <Operator>Equal</Operator>
                                  <FilterValues>
                                    <FilterValue DataType="Boolean">true</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>2.94961cm</Top>
                              <Left>8.55034cm</Left>
                              <Height>4.55004cm</Height>
                              <Width>9.5cm</Width>
                              <ZIndex>8</ZIndex>
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
                                    <Width>2.5cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
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
                                                    <Value>=Fields!PaymentServiceURLText.Value</Value>
                                                    <ActionInfo>
                                                      <Actions>
                                                        <Action>
                                                          <Hyperlink>=Fields!PaymentServiceURL.Value</Hyperlink>
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
                                                  <Hyperlink>=Fields!PaymentServiceURL.Value</Hyperlink>
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
                                  <TablixRow>
                                    <Height>1.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Image Name="Image1">
                                            <Source>Database</Source>
                                            <Value>=Fields!PaymentServiceLogo.Value</Value>
                                            <MIMEType>image/jpeg</MIMEType>
                                            <Sizing>FitProportional</Sizing>
                                            <ActionInfo>
                                              <Actions>
                                                <Action>
                                                  <Hyperlink>=Fields!PaymentServiceURL.Value</Hyperlink>
                                                </Action>
                                              </Actions>
                                            </ActionInfo>
                                            <Style>
                                              <Border>
                                                <Style>None</Style>
                                              </Border>
                                            </Style>
                                          </Image>
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
                                        <GroupExpression>=Fields!PaymentServiceURLText.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <SortExpressions>
                                      <SortExpression>
                                        <Value>=Fields!PaymentServiceURLText.Value</Value>
                                      </SortExpression>
                                    </SortExpressions>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="Details3">
                                          <Filters>
                                            <Filter>
                                              <FilterExpression>=Len(Fields!PaymentServiceURL.Value)</FilterExpression>
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
                              <Top>3.01787cm</Top>
                              <Left>0.16467cm</Left>
                              <Height>2.1cm</Height>
                              <Width>2.5cm</Width>
                              <ZIndex>9</ZIndex>
                              <Style>
                                <Border>
                                  <Style>None</Style>
                                </Border>
                              </Style>
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
                      <GroupExpression>=Fields!No_SalesInvHdr.Value</GroupExpression>
                      <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                      <ResetPageNumber>true</ResetPageNumber>
                    </PageBreak>
                  </Group>
                  <SortExpressions>
                    <SortExpression>
                      <Value>=Fields!OutputNo.Value</Value>
                    </SortExpression>
                    <SortExpression>
                      <Value>=Fields!No_SalesInvHdr.Value</Value>
                    </SortExpression>
                  </SortExpressions>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Left>0.06034cm</Left>
            <Height>22.39783cm</Height>
            <Width>18.15843cm</Width>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>22.39783cm</Height>
        <Style />
      </Body>
      <Width>18.22834cm</Width>
      <Page>
        <PageHeader>
          <Height>11.82256cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="SalesInvPricesInclVATCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(36,1)</Value>
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
              <Top>10.49081cm</Top>
              <Left>0.06033cm</Left>
              <Height>11pt</Height>
              <Width>1.25036in</Width>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvoiceNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(37,1)</Value>
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
              <Top>7.81676cm</Top>
              <Left>0.06034cm</Left>
              <Height>11pt</Height>
              <Width>1.25036in</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvPostingDateCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(38,1)</Value>
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
              <Top>8.64403cm</Top>
              <Left>0.06034cm</Left>
              <Height>11pt</Height>
              <Width>1.25036in</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvBilltoCustNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(39,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>5.94172cm</Top>
              <Left>0.06034cm</Left>
              <Height>11pt</Height>
              <Width>3.17591cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(40,1)</Value>
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
              <Top>8.4679cm</Top>
              <Left>11.45938cm</Left>
              <Height>11pt</Height>
              <Width>2.43423cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankNameCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(41,1)</Value>
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
              <Top>8.07984cm</Top>
              <Left>11.45938cm</Left>
              <Height>11pt</Height>
              <Width>2.43423cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoVATRegNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(43,1)</Value>
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
              <Top>7.28434cm</Top>
              <Left>11.45938cm</Left>
              <Height>11pt</Height>
              <Width>2.43251cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoPhoneNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(44,1)</Value>
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
              <Top>6.12547cm</Top>
              <Left>11.45938cm</Left>
              <Height>11pt</Height>
              <Width>2.43251cm</Width>
              <ZIndex>7</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PageCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Replace(Replace(Code.GetData(45,1), "%1", Globals!PageNumber), "%2", Globals!TotalPages)</Value>
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
              <Top>2.51979cm</Top>
              <Left>12.93933cm</Left>
              <Height>11pt</Height>
              <Width>5.27947cm</Width>
              <ZIndex>8</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvPricesInclVAT">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(16,1)</Value>
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
              <Top>10.48375cm</Top>
              <Left>3.28175cm</Left>
              <Height>11pt</Height>
              <Width>7.6371cm</Width>
              <ZIndex>9</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr6">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(27,1)</Value>
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
              <Top>5.3035cm</Top>
              <Left>12.90973cm</Left>
              <Height>11pt</Height>
              <Width>5.30907cm</Width>
              <ZIndex>10</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr5">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(26,1)</Value>
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
              <Top>4.94699cm</Top>
              <Left>12.90145cm</Left>
              <Height>11pt</Height>
              <Width>5.31734cm</Width>
              <ZIndex>11</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvYourReference">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(11,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.69283cm</Top>
              <Left>3.28175cm</Left>
              <Height>11pt</Height>
              <Width>7.69744cm</Width>
              <ZIndex>12</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ReferenceText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(46,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.68763cm</Top>
              <Left>0.06034cm</Left>
              <Height>11pt</Height>
              <Width>3.17591cm</Width>
              <ZIndex>13</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvoiceNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(12,1)</Value>
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
              <Top>7.81935cm</Top>
              <Left>3.27522cm</Left>
              <Height>11pt</Height>
              <Width>7.70397cm</Width>
              <ZIndex>14</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesPurchPersonName">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(18,1)</Value>
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
              <Top>7.69178cm</Top>
              <Left>13.8919cm</Left>
              <Height>11pt</Height>
              <Width>4.33164cm</Width>
              <ZIndex>15</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesPersonText">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(47,1)</Value>
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
              <Top>7.69178cm</Top>
              <Left>11.45938cm</Left>
              <Height>11pt</Height>
              <Width>2.43251cm</Width>
              <ZIndex>16</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvPostingDate">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(14,1)</Value>
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
              <Top>8.62015cm</Top>
              <Left>3.27522cm</Left>
              <Height>11pt</Height>
              <Width>7.70397cm</Width>
              <ZIndex>17</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvVATRegistrationNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(10,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.34005cm</Top>
              <Left>3.28175cm</Left>
              <Height>11pt</Height>
              <Width>7.69744cm</Width>
              <ZIndex>18</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VATNoText">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(48,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.33476cm</Top>
              <Left>0.06034cm</Left>
              <Height>11pt</Height>
              <Width>3.17591cm</Width>
              <ZIndex>19</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvBilltoCustNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(9,1)</Value>
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
              <Top>5.93789cm</Top>
              <Left>3.28175cm</Left>
              <Height>11pt</Height>
              <Width>7.69744cm</Width>
              <ZIndex>20</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(35,1)</Value>
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
              <Top>8.43262cm</Top>
              <Left>13.89361cm</Left>
              <Height>11pt</Height>
              <Width>4.32519cm</Width>
              <ZIndex>21</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankName">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(34,1)</Value>
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
              <Top>8.07984cm</Top>
              <Left>13.89189cm</Left>
              <Height>11pt</Height>
              <Width>4.32691cm</Width>
              <ZIndex>22</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoVATRegNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(32,1)</Value>
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
              <Top>7.28434cm</Top>
              <Left>13.8919cm</Left>
              <Height>11pt</Height>
              <Width>4.32688cm</Width>
              <ZIndex>23</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoPhoneNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(28,1)</Value>
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
              <Top>6.12018cm</Top>
              <Left>13.92153cm</Left>
              <Height>11pt</Height>
              <Width>4.29725cm</Width>
              <ZIndex>24</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr4">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(25,1)</Value>
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
              <Top>4.53914cm</Top>
              <Left>12.90145cm</Left>
              <Height>11pt</Height>
              <Width>5.31735cm</Width>
              <ZIndex>25</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr3">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(24,1)</Value>
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
              <Top>4.13274cm</Top>
              <Left>12.90145cm</Left>
              <Height>11pt</Height>
              <Width>5.31735cm</Width>
              <ZIndex>26</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(23,1)</Value>
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
              <Top>3.73828cm</Top>
              <Left>12.90973cm</Left>
              <Height>11pt</Height>
              <Width>5.30906cm</Width>
              <ZIndex>27</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(22,1)</Value>
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
              <Top>3.34317cm</Top>
              <Left>12.90973cm</Left>
              <Height>11pt</Height>
              <Width>5.30906cm</Width>
              <ZIndex>28</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ReportCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(19,1)</Value>
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
              <Top>0.72121in</Top>
              <Left>0.06034cm</Left>
              <Height>18.5pt</Height>
              <Width>18.15844cm</Width>
              <ZIndex>29</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvDocDateValue">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(17,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Format>g</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>9.31958cm</Top>
              <Left>3.28175cm</Left>
              <Height>11pt</Height>
              <Width>3.75583cm</Width>
              <ZIndex>30</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="OrderNoText">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(29,1)</Value>
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
              <Top>8.24269cm</Top>
              <Left>0.06034cm</Left>
              <Height>11pt</Height>
              <Width>1.25036in</Width>
              <ZIndex>31</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvHdrOrderNo">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(13,1)</Value>
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
              <Top>8.24269cm</Top>
              <Left>3.28175cm</Left>
              <Height>11pt</Height>
              <Width>7.69744cm</Width>
              <ZIndex>32</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvDueDateCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(49,1)</Value>
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
              <Top>3.54413in</Top>
              <Left>0.06034cm</Left>
              <Height>11pt</Height>
              <Width>1.25036in</Width>
              <ZIndex>33</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvDueDate">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(15,1)</Value>
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
              <Top>3.52848in</Top>
              <Left>3.27522cm</Left>
              <Height>11pt</Height>
              <Width>7.70397cm</Width>
              <ZIndex>34</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox71">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value />
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Color>Red</Color>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Left>0.07274in</Left>
              <Height>0.11479cm</Height>
              <Width>0.95238cm</Width>
              <ZIndex>35</ZIndex>
              <Visibility>
                <Hidden>=Code.SetData(ReportItems!CustAddr.Value,1)</Hidden>
              </Visibility>
              <Style>
                <Border />
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="DocumentDateCaption">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(50,1)</Value>
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
              <Top>9.35079cm</Top>
              <Left>0.06034cm</Left>
              <Height>11pt</Height>
              <Width>1.25036in</Width>
              <ZIndex>36</ZIndex>
              <Style />
            </Textbox>
            <Textbox Name="PaymentTrmsCaption">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(51,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.82468in</Top>
              <Left>0.06034cm</Left>
              <Height>11pt</Height>
              <Width>3.17591cm</Width>
              <ZIndex>37</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PaymentTrmsValue">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(20,1)</Value>
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
              <Top>3.8219in</Top>
              <Left>3.28175cm</Left>
              <Height>11pt</Height>
              <Width>3.75583cm</Width>
              <ZIndex>38</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShptMethodCaption">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(52,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>10.10275cm</Top>
              <Left>0.0854cm</Left>
              <Height>11pt</Height>
              <Width>1.25036in</Width>
              <ZIndex>39</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ShptMethodValue">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(21,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>10.0957cm</Top>
              <Left>3.28175cm</Left>
              <Height>11pt</Height>
              <Width>3.03306in</Width>
              <ZIndex>40</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Rectangle Name="Rectangle1">
              <ReportItems>
                <Textbox Name="CustAddr1">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(1,1)</Value>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>0.02152cm</Top>
                  <Height>11pt</Height>
                  <Width>364pt</Width>
                  <Style>
                    <VerticalAlign>Top</VerticalAlign>
                  </Style>
                </Textbox>
                <Textbox Name="CustAddr2">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(2,1)</Value>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>0.1442in</Top>
                  <Height>11pt</Height>
                  <Width>12.84111cm</Width>
                  <ZIndex>1</ZIndex>
                  <Style>
                    <VerticalAlign>Top</VerticalAlign>
                  </Style>
                </Textbox>
                <Textbox Name="CustAddr3">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(3,1)</Value>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>0.31086in</Top>
                  <Height>11pt</Height>
                  <Width>12.84111cm</Width>
                  <ZIndex>2</ZIndex>
                  <Style>
                    <VerticalAlign>Top</VerticalAlign>
                  </Style>
                </Textbox>
                <Textbox Name="CustAddr4">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(4,1)</Value>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>0.45254in</Top>
                  <Height>11pt</Height>
                  <Width>12.80583cm</Width>
                  <ZIndex>3</ZIndex>
                  <Style>
                    <VerticalAlign>Top</VerticalAlign>
                  </Style>
                </Textbox>
                <Textbox Name="CustAddr5">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(5,1)</Value>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>1.54808cm</Top>
                  <Height>11pt</Height>
                  <Width>12.80583cm</Width>
                  <ZIndex>4</ZIndex>
                  <Style>
                    <VerticalAlign>Top</VerticalAlign>
                  </Style>
                </Textbox>
                <Textbox Name="CustAddr6">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(6,1)</Value>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>1.93966cm</Top>
                  <Height>11pt</Height>
                  <Width>12.80583cm</Width>
                  <ZIndex>5</ZIndex>
                  <Style>
                    <VerticalAlign>Top</VerticalAlign>
                  </Style>
                </Textbox>
                <Textbox Name="CustAddr7">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(7,1)</Value>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.30302cm</Top>
                  <Height>11pt</Height>
                  <Width>12.80583cm</Width>
                  <ZIndex>6</ZIndex>
                  <Style>
                    <VerticalAlign>Top</VerticalAlign>
                  </Style>
                </Textbox>
                <Textbox Name="CustAddr8">
                  <KeepTogether>true</KeepTogether>
                  <Paragraphs>
                    <Paragraph>
                      <TextRuns>
                        <TextRun>
                          <Value>=Code.GetData(8,1)</Value>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                          </Style>
                        </TextRun>
                      </TextRuns>
                      <Style />
                    </Paragraph>
                  </Paragraphs>
                  <Top>2.66991cm</Top>
                  <Height>11pt</Height>
                  <Width>12.80583cm</Width>
                  <ZIndex>7</ZIndex>
                  <Style>
                    <VerticalAlign>Top</VerticalAlign>
                  </Style>
                </Textbox>
              </ReportItems>
              <KeepTogether>true</KeepTogether>
              <Top>2.48769cm</Top>
              <Left>0.06034cm</Left>
              <Height>1.20392in</Height>
              <Width>5.05556in</Width>
              <ZIndex>41</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Rectangle>
            <Textbox Name="EmailCaption">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(53,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.5623in</Top>
              <Left>4.51157in</Left>
              <Height>11pt</Height>
              <Width>2.43251cm</Width>
              <ZIndex>42</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Email">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(30,1)</Value>
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
              <Top>2.55465in</Top>
              <Left>5.46924in</Left>
              <Height>11pt</Height>
              <Width>4.32689cm</Width>
              <ZIndex>43</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="HomePageCaption">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(54,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.72132in</Top>
              <Left>4.51157in</Left>
              <Height>11pt</Height>
              <Width>2.43251cm</Width>
              <ZIndex>44</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Rectangle Name="Rectangle2">
              <ReportItems>
                <Image Name="CompanyInfoPicture1">
                  <Source>Database</Source>
                  <Value>=Convert.ToBase64String(Fields!CompanyInfo3Picture.Value)</Value>
                  <MIMEType>image/bmp</MIMEType>
                  <Sizing>FitProportional</Sizing>
                  <Height>14mm</Height>
                  <Width>60mm</Width>
                  <Visibility>
                    <Hidden>=iif(IsNothing(Fields!CompanyInfo3Picture.Value) = TRUE,TRUE,FALSE)</Hidden>
                  </Visibility>
                  <DataElementOutput>NoOutput</DataElementOutput>
                  <Style />
                </Image>
              </ReportItems>
              <KeepTogether>true</KeepTogether>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>45</ZIndex>
              <Style />
            </Rectangle>
            <Rectangle Name="Rectangle3">
              <ReportItems>
                <Image Name="CompanyInfo1Picture1">
                  <Source>Database</Source>
                  <Value>=Convert.ToBase64String(Fields!CompanyInfo1Picture.Value)</Value>
                  <MIMEType>image/bmp</MIMEType>
                  <Sizing>FitProportional</Sizing>
                  <Height>14mm</Height>
                  <Width>60mm</Width>
                  <Visibility>
                    <Hidden>=iif(IsNothing(Fields!CompanyInfo1Picture.Value)= TRUE,TRUE,FALSE)</Hidden>
                  </Visibility>
                  <DataElementOutput>NoOutput</DataElementOutput>
                  <Style />
                </Image>
              </ReportItems>
              <KeepTogether>true</KeepTogether>
              <Left>6cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>46</ZIndex>
              <Style />
            </Rectangle>
            <Textbox Name="HomePage">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(31,1)</Value>
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
              <Top>2.72132in</Top>
              <Left>5.46924in</Left>
              <Height>11pt</Height>
              <Width>4.32689cm</Width>
              <ZIndex>47</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Rectangle Name="Rectangle4">
              <ReportItems>
                <Image Name="CompanyInfo2Picture1">
                  <Source>Database</Source>
                  <Value>=Convert.ToBase64String(Fields!CompanyInfo2Picture.Value)</Value>
                  <MIMEType>image/bmp</MIMEType>
                  <Sizing>FitProportional</Sizing>
                  <Height>14mm</Height>
                  <Width>60mm</Width>
                  <Visibility>
                    <Hidden>=iif(IsNothing(Fields!CompanyInfo2Picture.Value) = TRUE,TRUE,FALSE)</Hidden>
                  </Visibility>
                  <DataElementOutput>NoOutput</DataElementOutput>
                  <Style />
                </Image>
              </ReportItems>
              <KeepTogether>true</KeepTogether>
              <Left>12cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>48</ZIndex>
              <Style />
            </Rectangle>
            <Textbox Name="SalesInvYourReference2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(56,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.11616cm</Top>
              <Left>3.27522cm</Left>
              <Height>11pt</Height>
              <Width>7.70397cm</Width>
              <ZIndex>49</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ReferenceText2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(57,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.42847cm</Top>
              <Left>0.05381cm</Left>
              <Height>11pt</Height>
              <Width>3.17591cm</Width>
              <ZIndex>50</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesInvVATRegistrationNo2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(58,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.43129cm</Top>
              <Left>3.30681cm</Left>
              <Height>11pt</Height>
              <Width>7.67238cm</Width>
              <ZIndex>51</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VATNoText2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(55,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.07559cm</Top>
              <Left>0.05381cm</Left>
              <Height>11pt</Height>
              <Width>3.17591cm</Width>
              <ZIndex>52</ZIndex>
              <Style>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccNo2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(59,1)</Value>
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
              <Top>9.55445cm</Top>
              <Left>11.46418cm</Left>
              <Height>11pt</Height>
              <Width>2.45735cm</Width>
              <ZIndex>53</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoBankAccNo3">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(60,1)</Value>
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
              <Top>9.55445cm</Top>
              <Left>13.88229cm</Left>
              <Height>11pt</Height>
              <Width>4.33647cm</Width>
              <ZIndex>54</ZIndex>
              <Style>
                <Border />
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoIBANCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(61,1)</Value>
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
              <Top>8.85596cm</Top>
              <Left>11.46418cm</Left>
              <Height>0.73377cm</Height>
              <Width>2.42771cm</Width>
              <ZIndex>55</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoIBAN">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(62,1)</Value>
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
              <Top>8.89123cm</Top>
              <Left>13.89187cm</Left>
              <Height>0.6985cm</Height>
              <Width>4.32689cm</Width>
              <ZIndex>56</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <VerticalAlign>Top</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.71388cm</LeftMargin>
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

Shared Data1 as Object
Shared Data2 as Object
Shared Data3 as Object
Shared Data4 as Object

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

if Group = 4 then
   Return Cstr(Choose(Num, Split(Cstr(Data4),Chr(177))))
End If
End Function

Public Function SetData(NewData as Object,Group as integer)
  If Group = 1 and NewData &gt; "" Then
      Data1 = NewData
  End If

  If Group = 2 and NewData &gt; "" Then
      Data2 = NewData
  End If

  If Group = 3 and NewData &gt; "" Then
      Data3 = NewData
  End If

  If Group = 4 and NewData &gt; "" Then
      Data4 = NewData
  End If

  Return True
End Function


Shared NoOfCopies as integer

Public Function SetNoOfCopies(Value as integer)
NoOfCopies = Value
End Function

Public Function GetNoOfCopies() As integer
   Return  NoOfCopies 
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>ee11569a-1087-4a90-b475-d162e8cf851c</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

