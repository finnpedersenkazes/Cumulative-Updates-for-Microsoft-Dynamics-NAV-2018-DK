OBJECT Report 5911 Service - Invoice
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
    CaptionML=[DAN=Service - faktura;
               ENU=Service - Invoice];
    OnInitReport=BEGIN
                   GLSetup.GET;
                   CompanyInfo.GET;
                   ServiceSetup.GET;
                   FormatDocument.SetLogoPosition(ServiceSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
                 END;

  }
  DATASET
  {
    { 5614;    ;DataItem;                    ;
               DataItemTable=Table5992;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Bogf�rt servicefaktura;
                                   ENU=Posted Service Invoice];
               OnAfterGetRecord=BEGIN
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FormatAddressFields("Service Invoice Header");
                                  FormatDocumentFields("Service Invoice Header");

                                  IF NOT Cust.GET("Bill-to Customer No.") THEN
                                    CLEAR(Cust);

                                  GetLineFeeNoteOnReportHist("No.");

                                  IF "EAN No." = '' THEN
                                    EANText :=''
                                  ELSE
                                    EANText := FIELDCAPTION("EAN No.");

                                  IF "Account Code" = '' THEN
                                    IntAccountCodeText :=''
                                  ELSE
                                    IntAccountCodeText := FIELDCAPTION("Account Code");

                                  IF AccountCodeLineSpecified THEN
                                    "Account Code" := '(Linjespecificeret)';

                                  IF Cust."VAT Registration No." = '' THEN
                                    CustVatNoText :=''
                                  ELSE
                                    CustVatNoText := Cust.FIELDCAPTION("VAT Registration No.");

                                  IF "Contact Name" = '' THEN
                                    ContNameText := ''
                                  ELSE
                                    ContNameText := FIELDCAPTION("Contact Name");

                                  IF "Phone No." = '' THEN
                                    PhoneText := ''
                                  ELSE
                                    PhoneText := FIELDCAPTION("Phone No.");

                                  IF "E-Mail" = '' THEN
                                    EMailText := ''
                                  ELSE
                                    EMailText := FIELDCAPTION("E-Mail");
                                END;

               ReqFilterFields=No.,Customer No.,No. Printed }

    { 168 ;1   ;Column  ;No_ServiceInvHeader ;
               SourceExpr="No." }

    { 200 ;1   ;Column  ;DisplayAdditionalFeeNote;
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
                                END;

               OnPostDataItem=BEGIN
                                IF NOT IsReportInPreviewMode THEN
                                  CODEUNIT.RUN(CODEUNIT::"Service Inv.-Printed","Service Invoice Header");
                              END;
                               }

    { 6455;2   ;DataItem;PageLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 149 ;3   ;Column  ;CompanyInfo2Picture ;
               SourceExpr=CompanyInfo2.Picture }

    { 148 ;3   ;Column  ;CompanyInfo1Picture ;
               SourceExpr=CompanyInfo1.Picture }

    { 147 ;3   ;Column  ;CompanyInfoPicture  ;
               SourceExpr=CompanyInfo3.Picture }

    { 1   ;3   ;Column  ;ReportTitleCopyText ;
               SourceExpr=STRSUBSTNO(Text004,CopyText) }

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

    { 17  ;3   ;Column  ;CompanyInfoFaxNo    ;
               SourceExpr=CompanyInfo."Fax No." }

    { 19  ;3   ;Column  ;CompanyInfoVATRegNo ;
               SourceExpr=CompanyInfo."VAT Registration No." }

    { 21  ;3   ;Column  ;CompanyInfoGiroNo   ;
               SourceExpr=CompanyInfo."Giro No." }

    { 23  ;3   ;Column  ;CompanyInfoBankName ;
               SourceExpr=CompanyInfo."Bank Name" }

    { 25  ;3   ;Column  ;CompanyInfoBankAccountNo;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 27  ;3   ;Column  ;BillToCustNo_ServInvHeader;
               SourceExpr="Service Invoice Header"."Bill-to Customer No." }

    { 28  ;3   ;Column  ;PostingDate_ServInvHeader;
               SourceExpr=FORMAT("Service Invoice Header"."Posting Date") }

    { 29  ;3   ;Column  ;VATNoText           ;
               SourceExpr=VATNoText }

    { 30  ;3   ;Column  ;VATRegNo_ServInvHeader;
               SourceExpr="Service Invoice Header"."VAT Registration No." }

    { 32  ;3   ;Column  ;DueDate_ServInvHeader;
               SourceExpr=FORMAT("Service Invoice Header"."Due Date") }

    { 33  ;3   ;Column  ;SalesPersonText     ;
               SourceExpr=SalesPersonText }

    { 34  ;3   ;Column  ;SalesPurchPersonName;
               SourceExpr=SalesPurchPerson.Name }

    { 36  ;3   ;Column  ;No1_ServiceInvHeader;
               SourceExpr="Service Invoice Header"."No." }

    { 37  ;3   ;Column  ;ReferenceText       ;
               SourceExpr=ReferenceText }

    { 38  ;3   ;Column  ;YorRef_ServInvHeader;
               SourceExpr="Service Invoice Header"."Your Reference" }

    { 39  ;3   ;Column  ;OrderNoText         ;
               SourceExpr=OrderNoText }

    { 40  ;3   ;Column  ;OrderNo_ServInvHeader;
               SourceExpr="Service Invoice Header"."Order No." }

    { 3   ;3   ;Column  ;CustAddr7           ;
               SourceExpr=CustAddr[7] }

    { 48  ;3   ;Column  ;CustAddr8           ;
               SourceExpr=CustAddr[8] }

    { 49  ;3   ;Column  ;CompanyAddr5        ;
               SourceExpr=CompanyAddr[5] }

    { 50  ;3   ;Column  ;CompanyAddr6        ;
               SourceExpr=CompanyAddr[6] }

    { 54  ;3   ;Column  ;DocDate_ServInvHeader;
               SourceExpr=FORMAT("Service Invoice Header"."Document Date",0,4) }

    { 58  ;3   ;Column  ;PricesInclVAT_ServInvHeader;
               SourceExpr="Service Invoice Header"."Prices Including VAT" }

    { 1060011;3;Column  ;EANNo_ServInvHeader ;
               SourceExpr="Service Invoice Header"."EAN No." }

    { 1060010;3;Column  ;AccountCode_ServInvHeader;
               SourceExpr="Service Invoice Header"."Account Code" }

    { 1060009;3;Column  ;ContactName_ServInvHeader;
               SourceExpr="Service Invoice Header"."Contact Name" }

    { 1060008;3;Column  ;EANText             ;
               SourceExpr=EANText }

    { 1060007;3;Column  ;IntAccountCodeText  ;
               SourceExpr=IntAccountCodeText }

    { 1060006;3;Column  ;ContNameText        ;
               SourceExpr=ContNameText }

    { 1060005;3;Column  ;PhoneNo_ServInvHeader;
               SourceExpr="Service Invoice Header"."Phone No." }

    { 1060004;3;Column  ;PhoneText           ;
               SourceExpr=PhoneText }

    { 1060003;3;Column  ;EMail_ServInvHeader ;
               SourceExpr="Service Invoice Header"."E-Mail" }

    { 1060002;3;Column  ;EMailText           ;
               SourceExpr=EMailText }

    { 1060001;3;Column  ;CompanyInfoSWIFTCode;
               SourceExpr=CompanyInfo."SWIFT Code" }

    { 121 ;3   ;Column  ;PageCaption         ;
               SourceExpr=STRSUBSTNO(Text005,'') }

    { 156 ;3   ;Column  ;OutputNo            ;
               SourceExpr=OutputNo }

    { 275 ;3   ;Column  ;PricesInclVAT1_ServInvHeader;
               SourceExpr=FORMAT("Service Invoice Header"."Prices Including VAT") }

    { 13  ;3   ;Column  ;CompanyInfoPhoneNoCaption;
               SourceExpr=CompanyInfoPhoneNoCaptionLbl }

    { 16  ;3   ;Column  ;CompanyInfoFaxNoCaption;
               SourceExpr=CompanyInfoFaxNoCaptionLbl }

    { 18  ;3   ;Column  ;CompanyInfoVATRegistrationNoCaption;
               SourceExpr=CompanyInfoVATRegistrationNoCaptionLbl }

    { 20  ;3   ;Column  ;CompanyInfoGiroNoCaption;
               SourceExpr=CompanyInfoGiroNoCaptionLbl }

    { 22  ;3   ;Column  ;CompanyInfoBankNameCaption;
               SourceExpr=CompanyInfoBankNameCaptionLbl }

    { 24  ;3   ;Column  ;CompanyInfoBankAccountNoCaption;
               SourceExpr=CompanyInfoBankAccountNoCaptionLbl }

    { 26  ;3   ;Column  ;BillToCustNo_ServInvHeaderCaption;
               SourceExpr="Service Invoice Header".FIELDCAPTION("Bill-to Customer No.") }

    { 31  ;3   ;Column  ;ServiceInvoiceHeaderDueDateCaption;
               SourceExpr=ServiceInvoiceHeaderDueDateCaptionLbl }

    { 35  ;3   ;Column  ;InvoiceNoCaption    ;
               SourceExpr=InvoiceNoCaptionLbl }

    { 53  ;3   ;Column  ;ServiceInvoiceHeaderPostingDateCaption;
               SourceExpr=ServiceInvoiceHeaderPostingDateCaptionLbl }

    { 59  ;3   ;Column  ;PricesInclVAT_ServInvHeaderCaption;
               SourceExpr="Service Invoice Header".FIELDCAPTION("Prices Including VAT") }

    { 1060012;3;Column  ;CompanyInfoSWIFTCodeCaption;
               SourceExpr=CompanyInfoSWIFTCodeCaptionLbl }

    { 7574;3   ;DataItem;DimensionLoop1      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;
                               FindDimTxt("Service Invoice Header"."Dimension Set ID");
                               SETRANGE(Number,1,DimTxtArrLength);
                             END;

               OnAfterGetRecord=BEGIN
                                  DimText := DimTxtArr[Number];
                                END;

               DataItemLinkReference=Service Invoice Header }

    { 91  ;4   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 122 ;4   ;Column  ;Number_IntegerLine  ;
               SourceExpr=Number }

    { 93  ;4   ;Column  ;HeaderDimensionsCaption;
               SourceExpr=HeaderDimensionsCaptionLbl }

    { 2800;3   ;DataItem;                    ;
               DataItemTable=Table5993;
               DataItemTableView=SORTING(Document No.,Line No.);
               OnPreDataItem=BEGIN
                               VATAmountLine.DELETEALL;
                               ServiceShipmentBuffer.RESET;
                               ServiceShipmentBuffer.DELETEALL;
                               FirstValueEntryNo := 0;
                               MoreLines := FIND('+');
                               WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                 MoreLines := NEXT(-1) <> 0;
                               IF NOT MoreLines THEN
                                 CurrReport.BREAK;
                               SETRANGE("Line No.",0,"Line No.");
                               CurrReport.CREATETOTALS("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount");

                               TotalLineAmount := 0;
                               TotalAmount := 0;
                               TotalAmountInclVAT := 0;
                               TotalInvDiscAmount := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  PostedShipmentDate := 0D;
                                  IF Quantity <> 0 THEN
                                    PostedShipmentDate := FindPostedShipmentDate;

                                  IsServiceContractLine := (Type = Type::"G/L Account") AND ("Service Item No." <> '') AND ("Contract No." <> '');
                                  IF IsServiceContractLine THEN BEGIN
                                    AccNo := "No.";
                                    "No." := "Service Item No.";
                                  END;

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

                                  TotalLineAmount += "Line Amount";
                                  TotalAmount += Amount;
                                  TotalAmountInclVAT += "Amount Including VAT";
                                  TotalInvDiscAmount += "Inv. Discount Amount";
                                  TypeInt := Type;
                                END;

               DataItemLinkReference=Service Invoice Header;
               DataItemLink=Document No.=FIELD(No.) }

    { 150 ;4   ;Column  ;TypeInt             ;
               SourceExpr=TypeInt }

    { 151 ;4   ;Column  ;BaseDisc_ServInvHeader;
               SourceExpr="Service Invoice Header"."VAT Base Discount %" }

    { 152 ;4   ;Column  ;TotalLineAmount     ;
               SourceExpr=TotalLineAmount }

    { 153 ;4   ;Column  ;TotalAmount         ;
               SourceExpr=TotalAmount }

    { 154 ;4   ;Column  ;TotalAmountInclVAT  ;
               SourceExpr=TotalAmountInclVAT }

    { 155 ;4   ;Column  ;TotalInvDiscAmount  ;
               SourceExpr=TotalInvDiscAmount }

    { 157 ;4   ;Column  ;LineNo_ServInvLine  ;
               SourceExpr="Line No." }

    { 56  ;4   ;Column  ;LineAmt_ServInvLine ;
               SourceExpr="Line Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 57  ;4   ;Column  ;Description_ServInvLine;
               SourceExpr=Description }

    { 64  ;4   ;Column  ;No_ServInvLine      ;
               SourceExpr="No." }

    { 66  ;4   ;Column  ;Quantity_ServInvLine;
               SourceExpr=Quantity }

    { 67  ;4   ;Column  ;UOM_ServInvLine     ;
               SourceExpr="Unit of Measure" }

    { 68  ;4   ;Column  ;UnitPrice_ServInvLine;
               SourceExpr="Unit Price";
               AutoFormatType=2;
               AutoFormatExpr=GetCurrencyCode }

    { 69  ;4   ;Column  ;LineDisc_ServInvLine;
               SourceExpr="Line Discount %" }

    { 101 ;4   ;Column  ;VATIdentifier_ServInvLine;
               SourceExpr="VAT Identifier" }

    { 100 ;4   ;Column  ;PostedShipmentDate  ;
               SourceExpr=FORMAT(PostedShipmentDate) }

    { 1060013;4;Column  ;AccountCodeCaptionAccountCode;
               SourceExpr=STRSUBSTNO('%1 %2', FIELDCAPTION("Account Code"), "Account Code") }

    { 1060000;4;Column  ;AccountCode_ServInvLine;
               SourceExpr="Account Code" }

    { 88  ;4   ;Column  ;InvDiscountAmount   ;
               SourceExpr=-"Inv. Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 73  ;4   ;Column  ;TotalText           ;
               SourceExpr=TotalText }

    { 74  ;4   ;Column  ;Amount_ServInvLine  ;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 92  ;4   ;Column  ;AmtInclVATAmount    ;
               SourceExpr="Amount Including VAT" - Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 94  ;4   ;Column  ;AmtInclVAT_ServInvLine;
               SourceExpr="Amount Including VAT";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 79  ;4   ;Column  ;VATAmtLineVATAmtText;
               SourceExpr=VATAmountLine.VATAmountText }

    { 80  ;4   ;Column  ;TotalExclVATText    ;
               SourceExpr=TotalExclVATText }

    { 81  ;4   ;Column  ;TotalInclVATText    ;
               SourceExpr=TotalInclVATText }

    { 143 ;4   ;Column  ;LineAmtInvDiscAmtAmtInclVAT;
               SourceExpr=-("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");
               AutoFormatType=1;
               AutoFormatExpr="Service Invoice Header"."Currency Code" }

    { 41  ;4   ;Column  ;No_ServInvLineCaption;
               SourceExpr=FIELDCAPTION("No.") }

    { 42  ;4   ;Column  ;Description_ServInvLineCaption;
               SourceExpr=FIELDCAPTION(Description) }

    { 43  ;4   ;Column  ;Quantity_ServInvLineCaption;
               SourceExpr=FIELDCAPTION(Quantity) }

    { 44  ;4   ;Column  ;UOM_ServInvLineCaption;
               SourceExpr=FIELDCAPTION("Unit of Measure") }

    { 45  ;4   ;Column  ;UnitPriceCaption    ;
               SourceExpr=UnitPriceCaptionLbl }

    { 46  ;4   ;Column  ;ServiceInvoiceLineLineDiscountCaption;
               SourceExpr=ServiceInvoiceLineLineDiscountCaptionLbl }

    { 47  ;4   ;Column  ;AmountCaption       ;
               SourceExpr=AmountCaptionLbl }

    { 102 ;4   ;Column  ;ServiceInvoiceLineVATIdentifierCaption;
               SourceExpr=FIELDCAPTION("VAT Identifier") }

    { 106 ;4   ;Column  ;PostedShipmentDateCaption;
               SourceExpr=PostedShipmentDateCaptionLbl }

    { 87  ;4   ;Column  ;InvDiscountAmountCaption;
               SourceExpr=InvDiscountAmountCaptionLbl }

    { 89  ;4   ;Column  ;SubtotalCaption     ;
               SourceExpr=SubtotalCaptionLbl }

    { 84  ;4   ;Column  ;LineAmountInvDiscountAmountAmountIncludingVATCaption;
               SourceExpr=LineAmountInvDiscountAmountAmountIncludingVATCaptionLbl }

    { 9516;4   ;DataItem;Service Shipment Buffer;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               ServiceShipmentBuffer.SETRANGE("Document No.","Service Invoice Line"."Document No.");
                               ServiceShipmentBuffer.SETRANGE("Line No.","Service Invoice Line"."Line No.");

                               SETRANGE(Number,1,ServiceShipmentBuffer.COUNT);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    ServiceShipmentBuffer.FIND('-')
                                  ELSE
                                    ServiceShipmentBuffer.NEXT;
                                END;
                                 }

    { 144 ;5   ;Column  ;ServShptBufferPostingDate;
               SourceExpr=FORMAT(ServiceShipmentBuffer."Posting Date") }

    { 146 ;5   ;Column  ;ServShptBufferQuantity;
               DecimalPlaces=0:5;
               SourceExpr=ServiceShipmentBuffer.Quantity }

    { 145 ;5   ;Column  ;ShipmentCaption     ;
               SourceExpr=ShipmentCaptionLbl }

    { 3591;4   ;DataItem;DimensionLoop2      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;

                               FindDimTxt("Service Invoice Line"."Dimension Set ID");
                               IF IsServiceContractLine THEN
                                 SETRANGE(Number,1,DimTxtArrLength + 1)
                               ELSE
                                 SETRANGE(Number,1,DimTxtArrLength);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number <= DimTxtArrLength THEN
                                    DimText := DimTxtArr[Number]
                                  ELSE
                                    DimText := FORMAT("Service Invoice Line".Type) + ' ' + AccNo;
                                END;
                                 }

    { 82  ;5   ;Column  ;DimText1            ;
               SourceExpr=DimText }

    { 83  ;5   ;Column  ;LineDimensionsCaption;
               SourceExpr=LineDimensionsCaptionLbl }

    { 6558;3   ;DataItem;VATCounter          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF VATAmountLine.GetTotalVATAmount = 0 THEN
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

    { 104 ;4   ;Column  ;VATAmtLineVATBase   ;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Service Invoice Line".GetCurrencyCode }

    { 105 ;4   ;Column  ;VATAmtLineVATAmount ;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Service Invoice Header"."Currency Code" }

    { 75  ;4   ;Column  ;VATAmtLineLineAmount;
               SourceExpr=VATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Service Invoice Header"."Currency Code" }

    { 76  ;4   ;Column  ;VATAmtLineInvDiscBaseAmt;
               SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
               AutoFormatType=1;
               AutoFormatExpr="Service Invoice Header"."Currency Code" }

    { 77  ;4   ;Column  ;VATAmtLineInvDiscAmount;
               SourceExpr=VATAmountLine."Invoice Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Service Invoice Header"."Currency Code" }

    { 107 ;4   ;Column  ;VATAmountLineVAT    ;
               DecimalPlaces=0:5;
               SourceExpr=VATAmountLine."VAT %" }

    { 135 ;4   ;Column  ;VATAmtLineVATIdentifier;
               SourceExpr=VATAmountLine."VAT Identifier" }

    { 95  ;4   ;Column  ;VATAmountLineVATCaption;
               SourceExpr=VATAmountLineVATCaptionLbl }

    { 96  ;4   ;Column  ;VATAmountLineVATBaseControl108Caption;
               SourceExpr=VATAmountLineVATBaseControl108CaptionLbl }

    { 97  ;4   ;Column  ;VATAmountLineVATAmountControl109Caption;
               SourceExpr=VATAmountLineVATAmountControl109CaptionLbl }

    { 78  ;4   ;Column  ;VATAmountSpecificationCaption;
               SourceExpr=VATAmountSpecificationCaptionLbl }

    { 136 ;4   ;Column  ;VATAmountLineVATIdentifierCaption;
               SourceExpr=VATAmountLineVATIdentifierCaptionLbl }

    { 137 ;4   ;Column  ;VATAmountLineInvDiscBaseAmountControl141Caption;
               SourceExpr=VATAmountLineInvDiscBaseAmountControl141CaptionLbl }

    { 138 ;4   ;Column  ;VATAmountLineLineAmountControl140Caption;
               SourceExpr=VATAmountLineLineAmountControl140CaptionLbl }

    { 139 ;4   ;Column  ;VATAmountLineInvDiscAmtCaption;
               SourceExpr=VATAmountLineInvDiscAmtCaptionLbl }

    { 115 ;4   ;Column  ;VATAmountLineVATBaseControl116Caption;
               SourceExpr=VATAmountLineVATBaseControl116CaptionLbl }

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
                                  VATClause.TranslateDescription("Service Invoice Header"."Language Code");
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
               AutoFormatExpr="Service Invoice Header"."Currency Code" }

    { 256 ;4   ;Column  ;VATClausesCaption   ;
               SourceExpr=VATClausesCap }

    { 257 ;4   ;Column  ;VATClauseVATIdentifierCaption;
               SourceExpr=VATAmountLineVATIdentifierCaptionLbl }

    { 258 ;4   ;Column  ;VATClauseVATAmtCaption;
               SourceExpr=VATAmountLineVATAmountControl109CaptionLbl }

    { 3476;3   ;DataItem;Total               ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 120 ;4   ;Column  ;PaymentTermsDescription;
               SourceExpr=PaymentTerms.Description }

    { 119 ;4   ;Column  ;PaymentTermsDescriptionCaption;
               SourceExpr=PaymentTermsDescriptionCaptionLbl }

    { 3363;3   ;DataItem;Total2              ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF NOT ShowShippingAddr THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 125 ;4   ;Column  ;CustNo_ServInvHeader;
               SourceExpr="Service Invoice Header"."Customer No." }

    { 124 ;4   ;Column  ;CustNo_ServInvHeaderCaption;
               SourceExpr="Service Invoice Header".FIELDCAPTION("Customer No.") }

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

    { 123 ;4   ;Column  ;ShiptoAddressCaption;
               SourceExpr=ShiptoAddressCaptionLbl }

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
    }
    CONTROLS
    {
      { 4   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 3   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Antal kopier;
                             ENU=No. of Copies];
                  ToolTipML=[DAN=Angiver, hvor mange kopier af bilaget der udskrives.;
                             ENU=Specifies how many copies of the document to print.];
                  ApplicationArea=#Service;
                  SourceExpr=NoOfCopies }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Vis interne oplysninger;
                             ENU=Show Internal Information];
                  ToolTipML=[DAN=Angiver, om den udskrevne rapport skal indeholde oplysninger, der kun er til intern brug.;
                             ENU=Specifies if you want the printed report to show information that is only for internal use.];
                  ApplicationArea=#Service;
                  SourceExpr=ShowInternalInfo }

      { 5   ;2   ;Field     ;
                  Name=DisplayAdditionalFeeNote;
                  CaptionML=[DAN=Vis bem�rkning om opkr�vningsgebyr;
                             ENU=Show Additional Fee Note];
                  ToolTipML=[DAN=Angiver, om du vil have vist noter om yderligere gebyrer i bilaget.;
                             ENU=Specifies if you want notes about additional fees to be shown on the document.];
                  ApplicationArea=#Service;
                  SourceExpr=DisplayAdditionalFeeNote }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text004@1004 : TextConst 'DAN=Service - faktura %1;ENU=Service - Invoice %1';
      Text005@1005 : TextConst 'DAN=Side %1;ENU=Page %1';
      GLSetup@1007 : Record 98;
      PaymentTerms@1009 : Record 3;
      SalesPurchPerson@1010 : Record 13;
      CompanyInfo@1011 : Record 79;
      CompanyInfo1@1045 : Record 79;
      CompanyInfo2@1046 : Record 79;
      CompanyInfo3@1060001 : Record 79;
      ServiceSetup@1048 : Record 5911;
      Cust@1012 : Record 18;
      DimSetEntry@1015 : Record 480;
      VATAmountLine@1013 : TEMPORARY Record 290;
      VATClause@1014 : Record 560;
      RespCenter@1016 : Record 5714;
      Language@1017 : Record 8;
      ServiceShipmentBuffer@1008 : TEMPORARY Record 5909;
      TempLineFeeNoteOnReportHist@1070 : TEMPORARY Record 1053;
      FormatAddr@1019 : Codeunit 365;
      FormatDocument@1040 : Codeunit 368;
      PostedShipmentDate@1044 : Date;
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
      OutputNo@1050 : Integer;
      TypeInt@1051 : Integer;
      DimText@1037 : Text[120];
      ShowInternalInfo@1039 : Boolean;
      TotalLineAmount@1020 : Decimal;
      TotalAmount@1041 : Decimal;
      TotalAmountInclVAT@1047 : Decimal;
      TotalInvDiscAmount@1049 : Decimal;
      DimTxtArrLength@1102601000 : Integer;
      DimTxtArr@1102601001 : ARRAY [500] OF Text[50];
      IsServiceContractLine@1059 : Boolean;
      AccNo@1038 : Code[20];
      EANText@1101100000 : Text[30];
      IntAccountCodeText@1101100001 : Text[30];
      CustVatNoText@1101100002 : Text[30];
      ContNameText@1101100003 : Text[80];
      PhoneText@1101100004 : Text[80];
      EMailText@1101100005 : Text[80];
      CompanyInfoPhoneNoCaptionLbl@2240 : TextConst 'DAN=Telefon;ENU=Phone No.';
      CompanyInfoFaxNoCaptionLbl@9851 : TextConst 'DAN=Telefax;ENU=Fax No.';
      CompanyInfoVATRegistrationNoCaptionLbl@4406 : TextConst 'DAN=SE/CVR-nr.;ENU=VAT Reg. No.';
      CompanyInfoGiroNoCaptionLbl@6756 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      CompanyInfoBankNameCaptionLbl@4354 : TextConst 'DAN=Bank;ENU=Bank';
      CompanyInfoBankAccountNoCaptionLbl@6132 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      ServiceInvoiceHeaderDueDateCaptionLbl@6931 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      InvoiceNoCaptionLbl@9494 : TextConst 'DAN=Fakturanr.;ENU=Invoice No.';
      ServiceInvoiceHeaderPostingDateCaptionLbl@7471 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      CompanyInfoSWIFTCodeCaptionLbl@1138105726 : TextConst 'DAN=SWIFT-kode;ENU=SWIFT Code';
      HeaderDimensionsCaptionLbl@4011 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      UnitPriceCaptionLbl@9609 : TextConst 'DAN=Enhedspris;ENU=Unit Price';
      ServiceInvoiceLineLineDiscountCaptionLbl@3093 : TextConst 'DAN=Rabatpct.;ENU=Disc. %';
      AmountCaptionLbl@7794 : TextConst 'DAN=Bel�b;ENU=Amount';
      PostedShipmentDateCaptionLbl@1193 : TextConst 'DAN=Bogf�rt leverancedato;ENU=Posted Shipment Date';
      InvDiscountAmountCaptionLbl@1060000 : TextConst 'DAN=Fakturarabatbel�b;ENU=Inv. Discount Amount';
      SubtotalCaptionLbl@1782 : TextConst 'DAN=Subtotal;ENU=Subtotal';
      LineAmountInvDiscountAmountAmountIncludingVATCaptionLbl@6010 : TextConst 'DAN=Moms ved kontantrabat;ENU=Payment Discount on VAT';
      ShipmentCaptionLbl@1672 : TextConst 'DAN=Leverance;ENU=Shipment';
      LineDimensionsCaptionLbl@3103 : TextConst 'DAN=Linjedimensioner;ENU=Line Dimensions';
      VATClausesCap@1071 : TextConst 'DAN=Momsklausul;ENU=VAT Clause';
      VATAmountLineVATCaptionLbl@6736 : TextConst 'DAN=Momspct.;ENU=VAT %';
      VATAmountLineVATBaseControl108CaptionLbl@7178 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATAmountLineVATAmountControl109CaptionLbl@3854 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VATAmountSpecificationCaptionLbl@5688 : TextConst 'DAN=Momsbel�bspecifikation;ENU=VAT Amount Specification';
      VATAmountLineVATIdentifierCaptionLbl@6385 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      VATAmountLineInvDiscBaseAmountControl141CaptionLbl@7036 : TextConst 'DAN=Fakturarabatgrundlag - bel�b;ENU=Inv. Disc. Base Amount';
      VATAmountLineLineAmountControl140CaptionLbl@9004 : TextConst 'DAN=Linjebel�b;ENU=Line Amount';
      VATAmountLineInvDiscAmtCaptionLbl@4745 : TextConst 'DAN=Fakturarabatbel�b;ENU=Invoice Discount Amount';
      VATAmountLineVATBaseControl116CaptionLbl@9437 : TextConst 'DAN=I alt;ENU=Total';
      PaymentTermsDescriptionCaptionLbl@5890 : TextConst 'DAN=Betalingsbetingelser;ENU=Payment Terms';
      ShiptoAddressCaptionLbl@7560 : TextConst 'DAN=Leveringsadresse;ENU=Ship-to Address';
      DisplayAdditionalFeeNote@1052 : Boolean;

    PROCEDURE FindPostedShipmentDate@6() : Date;
    VAR
      ServiceShipmentHeader@1000 : Record 5990;
      ServiceShipmentBuffer2@1001 : TEMPORARY Record 5909;
    BEGIN
      NextEntryNo := 1;
      IF "Service Invoice Line"."Shipment No." <> '' THEN
        IF ServiceShipmentHeader.GET("Service Invoice Line"."Shipment No.") THEN
          EXIT(ServiceShipmentHeader."Posting Date");

      IF "Service Invoice Header"."Order No." = '' THEN
        EXIT("Service Invoice Header"."Posting Date");

      CASE "Service Invoice Line".Type OF
        "Service Invoice Line".Type::Item:
          GenerateBufferFromValueEntry("Service Invoice Line");
        "Service Invoice Line".Type::"G/L Account","Service Invoice Line".Type::Resource,
        "Service Invoice Line".Type::Cost:
          GenerateBufferFromShipment("Service Invoice Line");
        "Service Invoice Line".Type::" ":
          EXIT(0D);
      END;

      ServiceShipmentBuffer.RESET;
      ServiceShipmentBuffer.SETRANGE("Document No.","Service Invoice Line"."Document No.");
      ServiceShipmentBuffer.SETRANGE("Line No." ,"Service Invoice Line"."Line No.");
      IF ServiceShipmentBuffer.FIND('-') THEN BEGIN
        ServiceShipmentBuffer2 := ServiceShipmentBuffer;
        IF ServiceShipmentBuffer.NEXT = 0 THEN BEGIN
          ServiceShipmentBuffer.GET(
            ServiceShipmentBuffer2."Document No.",ServiceShipmentBuffer2."Line No.",ServiceShipmentBuffer2."Entry No.");
          ServiceShipmentBuffer.DELETE;
          EXIT(ServiceShipmentBuffer2."Posting Date");
        END ;
        ServiceShipmentBuffer.CALCSUMS(Quantity);
        IF ServiceShipmentBuffer.Quantity <> "Service Invoice Line".Quantity THEN BEGIN
          ServiceShipmentBuffer.DELETEALL;
          EXIT("Service Invoice Header"."Posting Date");
        END;
      END ELSE
        EXIT("Service Invoice Header"."Posting Date");
    END;

    PROCEDURE GenerateBufferFromValueEntry@2(ServiceInvoiceLine2@1002 : Record 5993);
    VAR
      ValueEntry@1000 : Record 5802;
      ItemLedgerEntry@1001 : Record 32;
      TotalQuantity@1003 : Decimal;
      Quantity@1004 : Decimal;
    BEGIN
      TotalQuantity := ServiceInvoiceLine2."Quantity (Base)";
      ValueEntry.SETCURRENTKEY("Document No.");
      ValueEntry.SETRANGE("Document No.",ServiceInvoiceLine2."Document No.");
      ValueEntry.SETRANGE("Posting Date","Service Invoice Header"."Posting Date");
      ValueEntry.SETRANGE("Item Charge No.",'');
      ValueEntry.SETFILTER("Entry No.",'%1..',FirstValueEntryNo);
      IF ValueEntry.FIND('-') THEN
        REPEAT
          IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
            IF ServiceInvoiceLine2."Qty. per Unit of Measure" <> 0 THEN
              Quantity := ValueEntry."Invoiced Quantity" / ServiceInvoiceLine2."Qty. per Unit of Measure"
            ELSE
              Quantity := ValueEntry."Invoiced Quantity";
            AddBufferEntry(
              ServiceInvoiceLine2,
              -Quantity,
              ItemLedgerEntry."Posting Date");
            TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
          END;
          FirstValueEntryNo := ValueEntry."Entry No." + 1;
        UNTIL (ValueEntry.NEXT = 0) OR (TotalQuantity = 0);
    END;

    PROCEDURE GenerateBufferFromShipment@8(ServiceInvoiceLine@1000 : Record 5993);
    VAR
      ServiceInvoiceHeader@1001 : Record 5992;
      ServiceInvoiceLine2@1002 : Record 5993;
      ServiceShipmentHeader@1006 : Record 5990;
      ServiceShipmentLine@1004 : Record 5991;
      TotalQuantity@1003 : Decimal;
      Quantity@1005 : Decimal;
    BEGIN
      TotalQuantity := 0;
      ServiceInvoiceHeader.SETCURRENTKEY("Order No.");
      ServiceInvoiceHeader.SETFILTER("No.",'..%1',"Service Invoice Header"."No.");
      ServiceInvoiceHeader.SETRANGE("Order No.","Service Invoice Header"."Order No.");
      IF ServiceInvoiceHeader.FIND('-') THEN
        REPEAT
          ServiceInvoiceLine2.SETRANGE("Document No.",ServiceInvoiceHeader."No.");
          ServiceInvoiceLine2.SETRANGE("Line No.",ServiceInvoiceLine."Line No.");
          ServiceInvoiceLine2.SETRANGE(Type,ServiceInvoiceLine.Type);
          ServiceInvoiceLine2.SETRANGE("No.",ServiceInvoiceLine."No.");
          ServiceInvoiceLine2.SETRANGE("Unit of Measure Code",ServiceInvoiceLine."Unit of Measure Code");
          IF ServiceInvoiceLine2.FIND('-') THEN
            REPEAT
              TotalQuantity := TotalQuantity + ServiceInvoiceLine2.Quantity;
            UNTIL ServiceInvoiceLine2.NEXT = 0;
        UNTIL ServiceInvoiceHeader.NEXT = 0;

      ServiceShipmentLine.SETCURRENTKEY("Order No.","Order Line No.");
      ServiceShipmentLine.SETRANGE("Order No.","Service Invoice Header"."Order No.");
      ServiceShipmentLine.SETRANGE("Order Line No.",ServiceInvoiceLine."Line No.");
      ServiceShipmentLine.SETRANGE("Line No.",ServiceInvoiceLine."Line No.");
      ServiceShipmentLine.SETRANGE(Type,ServiceInvoiceLine.Type);
      ServiceShipmentLine.SETRANGE("No.",ServiceInvoiceLine."No.");
      ServiceShipmentLine.SETRANGE("Unit of Measure Code",ServiceInvoiceLine."Unit of Measure Code");
      ServiceShipmentLine.SETFILTER(Quantity,'<>%1',0);

      IF ServiceShipmentLine.FIND('-') THEN
        REPEAT
          IF ABS(ServiceShipmentLine.Quantity) <= ABS(TotalQuantity - ServiceInvoiceLine.Quantity) THEN
            TotalQuantity := TotalQuantity - ServiceShipmentLine.Quantity
          ELSE BEGIN
            IF ABS(ServiceShipmentLine.Quantity) > ABS(TotalQuantity) THEN
              ServiceShipmentLine.Quantity := TotalQuantity;
            Quantity :=
              ServiceShipmentLine.Quantity - (TotalQuantity - ServiceInvoiceLine.Quantity);

            TotalQuantity := TotalQuantity - ServiceShipmentLine.Quantity;
            ServiceInvoiceLine.Quantity := ServiceInvoiceLine.Quantity - Quantity;

            IF ServiceShipmentHeader.GET(ServiceShipmentLine."Document No.") THEN
              AddBufferEntry(
                ServiceInvoiceLine,
                Quantity,
                ServiceShipmentHeader."Posting Date");
          END;
        UNTIL (ServiceShipmentLine.NEXT = 0) OR (TotalQuantity = 0);
    END;

    PROCEDURE AddBufferEntry@3(ServiceInvoiceLine@1001 : Record 5993;QtyOnShipment@1002 : Decimal;PostingDate@1003 : Date);
    BEGIN
      ServiceShipmentBuffer.SETRANGE("Document No.",ServiceInvoiceLine."Document No.");
      ServiceShipmentBuffer.SETRANGE("Line No.",ServiceInvoiceLine."Line No.");
      ServiceShipmentBuffer.SETRANGE("Posting Date",PostingDate);
      IF ServiceShipmentBuffer.FIND('-') THEN BEGIN
        ServiceShipmentBuffer.Quantity := ServiceShipmentBuffer.Quantity + QtyOnShipment;
        ServiceShipmentBuffer.MODIFY;
        EXIT;
      END;

      WITH ServiceShipmentBuffer DO BEGIN
        "Document No." := ServiceInvoiceLine."Document No.";
        "Line No." := ServiceInvoiceLine."Line No.";
        "Entry No." := NextEntryNo;
        Type := ServiceInvoiceLine.Type;
        "No." := ServiceInvoiceLine."No.";
        Quantity := QtyOnShipment;
        "Posting Date" := PostingDate;
        INSERT;
        NextEntryNo := NextEntryNo + 1
      END;
    END;

    PROCEDURE FindDimTxt@1102601000(DimSetID@1000 : Integer);
    VAR
      Separation@1102601001 : Text[5];
      i@1102601002 : Integer;
      TxtToAdd@1102601003 : Text[120];
      StartNewLine@1102601004 : Boolean;
    BEGIN
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      DimTxtArrLength := 0;
      FOR i := 1 TO ARRAYLEN(DimTxtArr) DO
        DimTxtArr[i] := '';
      IF NOT DimSetEntry.FINDSET THEN
        EXIT;
      Separation := '; ';
      REPEAT
        TxtToAdd := DimSetEntry."Dimension Code" + ' - ' + DimSetEntry."Dimension Value Code";
        IF DimTxtArrLength = 0 THEN
          StartNewLine := TRUE
        ELSE
          StartNewLine := STRLEN(DimTxtArr[DimTxtArrLength]) + STRLEN(Separation) + STRLEN(TxtToAdd) > MAXSTRLEN(DimTxtArr[1]);
        IF StartNewLine THEN BEGIN
          DimTxtArrLength += 1;
          DimTxtArr[DimTxtArrLength] := TxtToAdd
        END ELSE
          DimTxtArr[DimTxtArrLength] := DimTxtArr[DimTxtArrLength] + Separation + TxtToAdd;
      UNTIL DimSetEntry.NEXT = 0;
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

      IF NOT Customer.GET("Service Invoice Header"."Bill-to Customer No.") THEN
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

    LOCAL PROCEDURE IsReportInPreviewMode@5() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    LOCAL PROCEDURE FormatAddressFields@1(VAR ServiceInvoiceHeader@1000 : Record 5992);
    BEGIN
      FormatAddr.GetCompanyAddr(ServiceInvoiceHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
      FormatAddr.ServiceInvBillTo(CustAddr,ServiceInvoiceHeader);
      ShowShippingAddr := FormatAddr.ServiceInvShipTo(ShipToAddr,CustAddr,ServiceInvoiceHeader);
    END;

    LOCAL PROCEDURE FormatDocumentFields@4(ServiceInvoiceHeader@1000 : Record 5992);
    BEGIN
      WITH ServiceInvoiceHeader DO BEGIN
        FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
        FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");

        OrderNoText := FormatDocument.SetText("Order No." <> '',FIELDCAPTION("Order No."));
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
      <rd:DataSourceID>335db80f-cf16-4139-8a25-d7efd9a6db41</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="No_ServiceInvHeader">
          <DataField>No_ServiceInvHeader</DataField>
        </Field>
        <Field Name="DisplayAdditionalFeeNote">
          <DataField>DisplayAdditionalFeeNote</DataField>
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
        <Field Name="ReportTitleCopyText">
          <DataField>ReportTitleCopyText</DataField>
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
        <Field Name="CompanyInfoFaxNo">
          <DataField>CompanyInfoFaxNo</DataField>
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
        <Field Name="BillToCustNo_ServInvHeader">
          <DataField>BillToCustNo_ServInvHeader</DataField>
        </Field>
        <Field Name="PostingDate_ServInvHeader">
          <DataField>PostingDate_ServInvHeader</DataField>
        </Field>
        <Field Name="VATNoText">
          <DataField>VATNoText</DataField>
        </Field>
        <Field Name="VATRegNo_ServInvHeader">
          <DataField>VATRegNo_ServInvHeader</DataField>
        </Field>
        <Field Name="DueDate_ServInvHeader">
          <DataField>DueDate_ServInvHeader</DataField>
        </Field>
        <Field Name="SalesPersonText">
          <DataField>SalesPersonText</DataField>
        </Field>
        <Field Name="SalesPurchPersonName">
          <DataField>SalesPurchPersonName</DataField>
        </Field>
        <Field Name="No1_ServiceInvHeader">
          <DataField>No1_ServiceInvHeader</DataField>
        </Field>
        <Field Name="ReferenceText">
          <DataField>ReferenceText</DataField>
        </Field>
        <Field Name="YorRef_ServInvHeader">
          <DataField>YorRef_ServInvHeader</DataField>
        </Field>
        <Field Name="OrderNoText">
          <DataField>OrderNoText</DataField>
        </Field>
        <Field Name="OrderNo_ServInvHeader">
          <DataField>OrderNo_ServInvHeader</DataField>
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
        <Field Name="DocDate_ServInvHeader">
          <DataField>DocDate_ServInvHeader</DataField>
        </Field>
        <Field Name="PricesInclVAT_ServInvHeader">
          <DataField>PricesInclVAT_ServInvHeader</DataField>
        </Field>
        <Field Name="EANNo_ServInvHeader">
          <DataField>EANNo_ServInvHeader</DataField>
        </Field>
        <Field Name="AccountCode_ServInvHeader">
          <DataField>AccountCode_ServInvHeader</DataField>
        </Field>
        <Field Name="ContactName_ServInvHeader">
          <DataField>ContactName_ServInvHeader</DataField>
        </Field>
        <Field Name="EANText">
          <DataField>EANText</DataField>
        </Field>
        <Field Name="IntAccountCodeText">
          <DataField>IntAccountCodeText</DataField>
        </Field>
        <Field Name="ContNameText">
          <DataField>ContNameText</DataField>
        </Field>
        <Field Name="PhoneNo_ServInvHeader">
          <DataField>PhoneNo_ServInvHeader</DataField>
        </Field>
        <Field Name="PhoneText">
          <DataField>PhoneText</DataField>
        </Field>
        <Field Name="EMail_ServInvHeader">
          <DataField>EMail_ServInvHeader</DataField>
        </Field>
        <Field Name="EMailText">
          <DataField>EMailText</DataField>
        </Field>
        <Field Name="CompanyInfoSWIFTCode">
          <DataField>CompanyInfoSWIFTCode</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="OutputNo">
          <DataField>OutputNo</DataField>
        </Field>
        <Field Name="PricesInclVAT1_ServInvHeader">
          <DataField>PricesInclVAT1_ServInvHeader</DataField>
        </Field>
        <Field Name="CompanyInfoPhoneNoCaption">
          <DataField>CompanyInfoPhoneNoCaption</DataField>
        </Field>
        <Field Name="CompanyInfoFaxNoCaption">
          <DataField>CompanyInfoFaxNoCaption</DataField>
        </Field>
        <Field Name="CompanyInfoVATRegistrationNoCaption">
          <DataField>CompanyInfoVATRegistrationNoCaption</DataField>
        </Field>
        <Field Name="CompanyInfoGiroNoCaption">
          <DataField>CompanyInfoGiroNoCaption</DataField>
        </Field>
        <Field Name="CompanyInfoBankNameCaption">
          <DataField>CompanyInfoBankNameCaption</DataField>
        </Field>
        <Field Name="CompanyInfoBankAccountNoCaption">
          <DataField>CompanyInfoBankAccountNoCaption</DataField>
        </Field>
        <Field Name="BillToCustNo_ServInvHeaderCaption">
          <DataField>BillToCustNo_ServInvHeaderCaption</DataField>
        </Field>
        <Field Name="ServiceInvoiceHeaderDueDateCaption">
          <DataField>ServiceInvoiceHeaderDueDateCaption</DataField>
        </Field>
        <Field Name="InvoiceNoCaption">
          <DataField>InvoiceNoCaption</DataField>
        </Field>
        <Field Name="ServiceInvoiceHeaderPostingDateCaption">
          <DataField>ServiceInvoiceHeaderPostingDateCaption</DataField>
        </Field>
        <Field Name="PricesInclVAT_ServInvHeaderCaption">
          <DataField>PricesInclVAT_ServInvHeaderCaption</DataField>
        </Field>
        <Field Name="CompanyInfoSWIFTCodeCaption">
          <DataField>CompanyInfoSWIFTCodeCaption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="Number_IntegerLine">
          <DataField>Number_IntegerLine</DataField>
        </Field>
        <Field Name="HeaderDimensionsCaption">
          <DataField>HeaderDimensionsCaption</DataField>
        </Field>
        <Field Name="TypeInt">
          <DataField>TypeInt</DataField>
        </Field>
        <Field Name="BaseDisc_ServInvHeader">
          <DataField>BaseDisc_ServInvHeader</DataField>
        </Field>
        <Field Name="BaseDisc_ServInvHeaderFormat">
          <DataField>BaseDisc_ServInvHeaderFormat</DataField>
        </Field>
        <Field Name="TotalLineAmount">
          <DataField>TotalLineAmount</DataField>
        </Field>
        <Field Name="TotalLineAmountFormat">
          <DataField>TotalLineAmountFormat</DataField>
        </Field>
        <Field Name="TotalAmount">
          <DataField>TotalAmount</DataField>
        </Field>
        <Field Name="TotalAmountFormat">
          <DataField>TotalAmountFormat</DataField>
        </Field>
        <Field Name="TotalAmountInclVAT">
          <DataField>TotalAmountInclVAT</DataField>
        </Field>
        <Field Name="TotalAmountInclVATFormat">
          <DataField>TotalAmountInclVATFormat</DataField>
        </Field>
        <Field Name="TotalInvDiscAmount">
          <DataField>TotalInvDiscAmount</DataField>
        </Field>
        <Field Name="TotalInvDiscAmountFormat">
          <DataField>TotalInvDiscAmountFormat</DataField>
        </Field>
        <Field Name="LineNo_ServInvLine">
          <DataField>LineNo_ServInvLine</DataField>
        </Field>
        <Field Name="LineAmt_ServInvLine">
          <DataField>LineAmt_ServInvLine</DataField>
        </Field>
        <Field Name="LineAmt_ServInvLineFormat">
          <DataField>LineAmt_ServInvLineFormat</DataField>
        </Field>
        <Field Name="Description_ServInvLine">
          <DataField>Description_ServInvLine</DataField>
        </Field>
        <Field Name="No_ServInvLine">
          <DataField>No_ServInvLine</DataField>
        </Field>
        <Field Name="Quantity_ServInvLine">
          <DataField>Quantity_ServInvLine</DataField>
        </Field>
        <Field Name="Quantity_ServInvLineFormat">
          <DataField>Quantity_ServInvLineFormat</DataField>
        </Field>
        <Field Name="UOM_ServInvLine">
          <DataField>UOM_ServInvLine</DataField>
        </Field>
        <Field Name="UnitPrice_ServInvLine">
          <DataField>UnitPrice_ServInvLine</DataField>
        </Field>
        <Field Name="UnitPrice_ServInvLineFormat">
          <DataField>UnitPrice_ServInvLineFormat</DataField>
        </Field>
        <Field Name="LineDisc_ServInvLine">
          <DataField>LineDisc_ServInvLine</DataField>
        </Field>
        <Field Name="LineDisc_ServInvLineFormat">
          <DataField>LineDisc_ServInvLineFormat</DataField>
        </Field>
        <Field Name="VATIdentifier_ServInvLine">
          <DataField>VATIdentifier_ServInvLine</DataField>
        </Field>
        <Field Name="PostedShipmentDate">
          <DataField>PostedShipmentDate</DataField>
        </Field>
        <Field Name="AccountCodeCaptionAccountCode">
          <DataField>AccountCodeCaptionAccountCode</DataField>
        </Field>
        <Field Name="AccountCode_ServInvLine">
          <DataField>AccountCode_ServInvLine</DataField>
        </Field>
        <Field Name="InvDiscountAmount">
          <DataField>InvDiscountAmount</DataField>
        </Field>
        <Field Name="InvDiscountAmountFormat">
          <DataField>InvDiscountAmountFormat</DataField>
        </Field>
        <Field Name="TotalText">
          <DataField>TotalText</DataField>
        </Field>
        <Field Name="Amount_ServInvLine">
          <DataField>Amount_ServInvLine</DataField>
        </Field>
        <Field Name="Amount_ServInvLineFormat">
          <DataField>Amount_ServInvLineFormat</DataField>
        </Field>
        <Field Name="AmtInclVATAmount">
          <DataField>AmtInclVATAmount</DataField>
        </Field>
        <Field Name="AmtInclVATAmountFormat">
          <DataField>AmtInclVATAmountFormat</DataField>
        </Field>
        <Field Name="AmtInclVAT_ServInvLine">
          <DataField>AmtInclVAT_ServInvLine</DataField>
        </Field>
        <Field Name="AmtInclVAT_ServInvLineFormat">
          <DataField>AmtInclVAT_ServInvLineFormat</DataField>
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
        <Field Name="LineAmtInvDiscAmtAmtInclVAT">
          <DataField>LineAmtInvDiscAmtAmtInclVAT</DataField>
        </Field>
        <Field Name="LineAmtInvDiscAmtAmtInclVATFormat">
          <DataField>LineAmtInvDiscAmtAmtInclVATFormat</DataField>
        </Field>
        <Field Name="No_ServInvLineCaption">
          <DataField>No_ServInvLineCaption</DataField>
        </Field>
        <Field Name="Description_ServInvLineCaption">
          <DataField>Description_ServInvLineCaption</DataField>
        </Field>
        <Field Name="Quantity_ServInvLineCaption">
          <DataField>Quantity_ServInvLineCaption</DataField>
        </Field>
        <Field Name="UOM_ServInvLineCaption">
          <DataField>UOM_ServInvLineCaption</DataField>
        </Field>
        <Field Name="UnitPriceCaption">
          <DataField>UnitPriceCaption</DataField>
        </Field>
        <Field Name="ServiceInvoiceLineLineDiscountCaption">
          <DataField>ServiceInvoiceLineLineDiscountCaption</DataField>
        </Field>
        <Field Name="AmountCaption">
          <DataField>AmountCaption</DataField>
        </Field>
        <Field Name="ServiceInvoiceLineVATIdentifierCaption">
          <DataField>ServiceInvoiceLineVATIdentifierCaption</DataField>
        </Field>
        <Field Name="PostedShipmentDateCaption">
          <DataField>PostedShipmentDateCaption</DataField>
        </Field>
        <Field Name="InvDiscountAmountCaption">
          <DataField>InvDiscountAmountCaption</DataField>
        </Field>
        <Field Name="SubtotalCaption">
          <DataField>SubtotalCaption</DataField>
        </Field>
        <Field Name="LineAmountInvDiscountAmountAmountIncludingVATCaption">
          <DataField>LineAmountInvDiscountAmountAmountIncludingVATCaption</DataField>
        </Field>
        <Field Name="ServShptBufferPostingDate">
          <DataField>ServShptBufferPostingDate</DataField>
        </Field>
        <Field Name="ServShptBufferQuantity">
          <DataField>ServShptBufferQuantity</DataField>
        </Field>
        <Field Name="ServShptBufferQuantityFormat">
          <DataField>ServShptBufferQuantityFormat</DataField>
        </Field>
        <Field Name="ShipmentCaption">
          <DataField>ShipmentCaption</DataField>
        </Field>
        <Field Name="DimText1">
          <DataField>DimText1</DataField>
        </Field>
        <Field Name="LineDimensionsCaption">
          <DataField>LineDimensionsCaption</DataField>
        </Field>
        <Field Name="VATAmtLineVATBase">
          <DataField>VATAmtLineVATBase</DataField>
        </Field>
        <Field Name="VATAmtLineVATBaseFormat">
          <DataField>VATAmtLineVATBaseFormat</DataField>
        </Field>
        <Field Name="VATAmtLineVATAmount">
          <DataField>VATAmtLineVATAmount</DataField>
        </Field>
        <Field Name="VATAmtLineVATAmountFormat">
          <DataField>VATAmtLineVATAmountFormat</DataField>
        </Field>
        <Field Name="VATAmtLineLineAmount">
          <DataField>VATAmtLineLineAmount</DataField>
        </Field>
        <Field Name="VATAmtLineLineAmountFormat">
          <DataField>VATAmtLineLineAmountFormat</DataField>
        </Field>
        <Field Name="VATAmtLineInvDiscBaseAmt">
          <DataField>VATAmtLineInvDiscBaseAmt</DataField>
        </Field>
        <Field Name="VATAmtLineInvDiscBaseAmtFormat">
          <DataField>VATAmtLineInvDiscBaseAmtFormat</DataField>
        </Field>
        <Field Name="VATAmtLineInvDiscAmount">
          <DataField>VATAmtLineInvDiscAmount</DataField>
        </Field>
        <Field Name="VATAmtLineInvDiscAmountFormat">
          <DataField>VATAmtLineInvDiscAmountFormat</DataField>
        </Field>
        <Field Name="VATAmountLineVAT">
          <DataField>VATAmountLineVAT</DataField>
        </Field>
        <Field Name="VATAmountLineVATFormat">
          <DataField>VATAmountLineVATFormat</DataField>
        </Field>
        <Field Name="VATAmtLineVATIdentifier">
          <DataField>VATAmtLineVATIdentifier</DataField>
        </Field>
        <Field Name="VATAmountLineVATCaption">
          <DataField>VATAmountLineVATCaption</DataField>
        </Field>
        <Field Name="VATAmountLineVATBaseControl108Caption">
          <DataField>VATAmountLineVATBaseControl108Caption</DataField>
        </Field>
        <Field Name="VATAmountLineVATAmountControl109Caption">
          <DataField>VATAmountLineVATAmountControl109Caption</DataField>
        </Field>
        <Field Name="VATAmountSpecificationCaption">
          <DataField>VATAmountSpecificationCaption</DataField>
        </Field>
        <Field Name="VATAmountLineVATIdentifierCaption">
          <DataField>VATAmountLineVATIdentifierCaption</DataField>
        </Field>
        <Field Name="VATAmountLineInvDiscBaseAmountControl141Caption">
          <DataField>VATAmountLineInvDiscBaseAmountControl141Caption</DataField>
        </Field>
        <Field Name="VATAmountLineLineAmountControl140Caption">
          <DataField>VATAmountLineLineAmountControl140Caption</DataField>
        </Field>
        <Field Name="VATAmountLineInvDiscAmtCaption">
          <DataField>VATAmountLineInvDiscAmtCaption</DataField>
        </Field>
        <Field Name="VATAmountLineVATBaseControl116Caption">
          <DataField>VATAmountLineVATBaseControl116Caption</DataField>
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
        <Field Name="PaymentTermsDescription">
          <DataField>PaymentTermsDescription</DataField>
        </Field>
        <Field Name="PaymentTermsDescriptionCaption">
          <DataField>PaymentTermsDescriptionCaption</DataField>
        </Field>
        <Field Name="CustNo_ServInvHeader">
          <DataField>CustNo_ServInvHeader</DataField>
        </Field>
        <Field Name="CustNo_ServInvHeaderCaption">
          <DataField>CustNo_ServInvHeaderCaption</DataField>
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
                  <Width>18.04804cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>22.85434cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="table1">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.3cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.31745cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Addr">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Fields!CustAddr1.Value + Chr(177) +
Fields!CustAddr2.Value + Chr(177) +
Fields!CustAddr3.Value + Chr(177) +
Fields!CustAddr4.Value + Chr(177) +
Fields!CustAddr5.Value + Chr(177) +
Fields!CustAddr6.Value + Chr(177) +
Fields!CustAddr7.Value + Chr(177) +
Fields!CustAddr8.Value + Chr(177) +
Fields!CompanyAddr1.Value + Chr(177) +
Fields!CompanyAddr2.Value + Chr(177) +
Fields!CompanyAddr3.Value + Chr(177) +
Fields!CompanyAddr4.Value + Chr(177) +
Fields!CompanyAddr5.Value + Chr(177) +
Fields!CompanyAddr6.Value + Chr(177) +
Fields!CompanyInfoPhoneNo.Value + Chr(177) +
Fields!CompanyInfoFaxNo.Value + Chr(177) +
Fields!CompanyInfoVATRegNo.Value + Chr(177) +
Fields!CompanyInfoGiroNo.Value + Chr(177) +
Fields!CompanyInfoBankName.Value + Chr(177) +
Fields!CompanyInfoBankAccountNo.Value + Chr(177) +
Fields!CompanyInfoSWIFTCode.Value + Chr(177) +
Fields!BillToCustNo_ServInvHeader.Value + Chr(177) +
Fields!VATNoText.Value + Chr(177) +
Fields!VATRegNo_ServInvHeader.Value + Chr(177) +
Fields!SalesPersonText.Value + Chr(177) +
Fields!SalesPurchPersonName.Value + Chr(177) +
Fields!ReferenceText.Value + Chr(177) +
Fields!YorRef_ServInvHeader.Value + Chr(177) +
Fields!DocDate_ServInvHeader.Value + Chr(177) +
Fields!No1_ServiceInvHeader.Value + Chr(177) +
Fields!OrderNoText.Value + Chr(177) +
Fields!OrderNo_ServInvHeader.Value + Chr(177) +
Fields!PostingDate_ServInvHeader.Value + Chr(177) +
Fields!DueDate_ServInvHeader.Value + Chr(177) +
Fields!PricesInclVAT1_ServInvHeader.Value + Chr(177) +
Fields!EANText.Value + Chr(177) +
Fields!EANNo_ServInvHeader.Value + Chr(177) +
Fields!IntAccountCodeText.Value + Chr(177) +
Fields!AccountCode_ServInvHeader.Value + Chr(177) +
Fields!ContNameText.Value + Chr(177) +
Fields!ContactName_ServInvHeader.Value + Chr(177) +
Fields!PhoneText.Value + Chr(177) +
Fields!PhoneNo_ServInvHeader.Value + Chr(177) +
Fields!EMailText.Value + Chr(177) +
Fields!EMail_ServInvHeader.Value + Chr(177) +
Fields!No_ServiceInvHeader.Value, 1)</Hidden>
                                            </Visibility>
                                            <Style />
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
                              <DataSetName>DataSet_Result</DataSetName>
                              <Left>0.01602cm</Left>
                              <Height>0.31745cm</Height>
                              <Width>0.3cm</Width>
                              <Style />
                            </Tablix>
                            <Textbox Name="NewPage">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=IIF(Code.IsNewPage(),TRUE,FALSE)</Value>
                                      <Style>
                                        <Color>Red</Color>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Left>0.65086cm</Left>
                              <Height>0.31746cm</Height>
                              <Width>0.95238cm</Width>
                              <ZIndex>1</ZIndex>
                              <Visibility>
                                <Hidden>true</Hidden>
                              </Visibility>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                              </Style>
                            </Textbox>
                            <Tablix Name="table2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.45054in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>5.63607in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox7">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!HeaderDimensionsCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox7</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!Number_IntegerLine.Value = 1,False,True)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox9">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox9</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                    <Group Name="table2_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
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
                                  <FilterExpression>=Fields!Number_IntegerLine.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Left>0.01602cm</Left>
                              <Height>0.42301cm</Height>
                              <Width>7.08661in</Width>
                              <ZIndex>2</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!Number_IntegerLine.Value &gt; 0,False,True)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="table3">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.19999cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.8cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.47cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.47cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.68001cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.52255cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>1.26901cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox24">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_ServInvLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox24</rd:DefaultName>
                                            <ZIndex>173</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox25">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_ServInvLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox25</rd:DefaultName>
                                            <ZIndex>172</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox26">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PostedShipmentDateCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox26</rd:DefaultName>
                                            <ZIndex>171</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox27">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Quantity_ServInvLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox27</rd:DefaultName>
                                            <ZIndex>170</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox28">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!UOM_ServInvLineCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox28</rd:DefaultName>
                                            <ZIndex>169</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Fields!UnitPriceCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox29</rd:DefaultName>
                                            <ZIndex>168</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Fields!ServiceInvoiceLineLineDiscountCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox30</rd:DefaultName>
                                            <ZIndex>167</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Fields!ServiceInvoiceLineVATIdentifierCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox31</rd:DefaultName>
                                            <ZIndex>166</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox32">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AmountCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox32</rd:DefaultName>
                                            <ZIndex>165</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox3">
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
                                            <rd:DefaultName>textbox3</rd:DefaultName>
                                            <ZIndex>164</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox54</rd:DefaultName>
                                            <ZIndex>163</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox5">
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
                                            <rd:DefaultName>textbox5</rd:DefaultName>
                                            <ZIndex>162</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox22">
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
                                            <rd:DefaultName>textbox22</rd:DefaultName>
                                            <ZIndex>161</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox20">
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
                                            <rd:DefaultName>textbox20</rd:DefaultName>
                                            <ZIndex>160</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox18">
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
                                            <rd:DefaultName>textbox18</rd:DefaultName>
                                            <ZIndex>159</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox16</rd:DefaultName>
                                            <ZIndex>158</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox14">
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
                                            <rd:DefaultName>textbox14</rd:DefaultName>
                                            <ZIndex>157</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox12</rd:DefaultName>
                                            <ZIndex>156</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Textbox4">
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
                                            <rd:DefaultName>Textbox4</rd:DefaultName>
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
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox511">
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
                                            <rd:DefaultName>textbox51</rd:DefaultName>
                                            <ZIndex>154</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Fields!Description_ServInvLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox52</rd:DefaultName>
                                            <ZIndex>153</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                          <Textbox Name="textbox57">
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
                                            <rd:DefaultName>textbox57</rd:DefaultName>
                                            <ZIndex>152</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox58</rd:DefaultName>
                                            <ZIndex>151</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox59</rd:DefaultName>
                                            <ZIndex>150</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox42">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!No_ServInvLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox42</rd:DefaultName>
                                            <ZIndex>149</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox43">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Description_ServInvLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox43</rd:DefaultName>
                                            <ZIndex>148</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox44">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PostedShipmentDate.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox44</rd:DefaultName>
                                            <ZIndex>147</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox45">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Quantity_ServInvLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Quantity_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox45</rd:DefaultName>
                                            <ZIndex>146</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Fields!UOM_ServInvLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox46</rd:DefaultName>
                                            <ZIndex>145</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox47">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!UnitPrice_ServInvLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!UnitPrice_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox47</rd:DefaultName>
                                            <ZIndex>144</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox48">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!LineDisc_ServInvLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!LineDisc_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox48</rd:DefaultName>
                                            <ZIndex>143</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Fields!VATIdentifier_ServInvLine.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox49</rd:DefaultName>
                                            <ZIndex>142</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox50">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!LineAmt_ServInvLine.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!LineAmt_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox50</rd:DefaultName>
                                            <ZIndex>141</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox250">
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
                                            <rd:DefaultName>textbox250</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox2512">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AccountCodeCaptionAccountCode.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox251</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                          <Textbox Name="textbox257">
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
                                            <rd:DefaultName>textbox257</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox258">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!UnitPrice_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox258</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox259">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!LineDisc_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox259</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox260">
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
                                            <rd:DefaultName>textbox260</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox2613">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!LineAmt_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox261</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox60</rd:DefaultName>
                                            <ZIndex>140</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox195">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipmentCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox195</rd:DefaultName>
                                            <ZIndex>139</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox62">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServShptBufferPostingDate.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox62</rd:DefaultName>
                                            <ZIndex>138</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox63">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ServShptBufferQuantity.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!ServShptBufferQuantityFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox63</rd:DefaultName>
                                            <ZIndex>137</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox64">
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
                                            <rd:DefaultName>textbox64</rd:DefaultName>
                                            <ZIndex>136</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox65</rd:DefaultName>
                                            <ZIndex>135</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox66</rd:DefaultName>
                                            <ZIndex>134</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox67">
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
                                            <rd:DefaultName>textbox67</rd:DefaultName>
                                            <ZIndex>133</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox68</rd:DefaultName>
                                            <ZIndex>132</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox8">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineDimensionsCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox8</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox10">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText1.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox10</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox186">
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
                                            <rd:DefaultName>textbox186</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox197">
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
                                            <rd:DefaultName>textbox197</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox187">
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
                                            <rd:DefaultName>textbox187</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox188">
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
                                            <rd:DefaultName>textbox188</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox189">
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
                                            <rd:DefaultName>textbox189</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox190">
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
                                            <rd:DefaultName>textbox190</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox191">
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
                                            <rd:DefaultName>textbox191</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox192">
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
                                            <rd:DefaultName>textbox192</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox193">
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
                                            <rd:DefaultName>textbox193</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox194">
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
                                            <rd:DefaultName>textbox194</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox177">
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
                                            <rd:DefaultName>textbox177</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox198">
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
                                            <rd:DefaultName>textbox198</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox178</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox179">
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
                                            <rd:DefaultName>textbox179</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox180">
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
                                            <rd:DefaultName>textbox180</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1814">
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
                                            <rd:DefaultName>textbox181</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox182">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SubtotalCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox182</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox185">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalLineAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!LineAmt_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox185</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox168">
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
                                            <rd:DefaultName>textbox168</rd:DefaultName>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox199">
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
                                            <rd:DefaultName>textbox199</rd:DefaultName>
                                            <ZIndex>26</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox169">
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
                                            <rd:DefaultName>textbox169</rd:DefaultName>
                                            <ZIndex>25</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox170">
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
                                            <rd:DefaultName>textbox170</rd:DefaultName>
                                            <ZIndex>24</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox171">
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
                                            <rd:DefaultName>textbox171</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox172">
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
                                            <rd:DefaultName>textbox172</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox173">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!InvDiscountAmountCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox173</rd:DefaultName>
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox176">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=-Last(Fields!TotalInvDiscAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!InvDiscountAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox176</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox159">
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
                                            <rd:DefaultName>textbox159</rd:DefaultName>
                                            <ZIndex>35</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox200</rd:DefaultName>
                                            <ZIndex>34</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox160</rd:DefaultName>
                                            <ZIndex>33</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1615">
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
                                            <rd:DefaultName>textbox161</rd:DefaultName>
                                            <ZIndex>32</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox162">
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
                                            <rd:DefaultName>textbox162</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox163">
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
                                            <rd:DefaultName>textbox163</rd:DefaultName>
                                            <ZIndex>30</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox164">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalText.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox164</rd:DefaultName>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox167">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!Amount_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox167</rd:DefaultName>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox150">
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
                                            <rd:DefaultName>textbox150</rd:DefaultName>
                                            <ZIndex>45</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox2016">
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
                                            <rd:DefaultName>textbox201</rd:DefaultName>
                                            <ZIndex>44</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox151">
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
                                            <rd:DefaultName>textbox151</rd:DefaultName>
                                            <ZIndex>43</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox152">
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
                                            <rd:DefaultName>textbox152</rd:DefaultName>
                                            <ZIndex>42</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox153">
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
                                            <rd:DefaultName>textbox153</rd:DefaultName>
                                            <ZIndex>41</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox154">
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
                                            <rd:DefaultName>textbox154</rd:DefaultName>
                                            <ZIndex>40</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox155">
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
                                            <rd:DefaultName>textbox155</rd:DefaultName>
                                            <ZIndex>39</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox156">
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
                                            <rd:DefaultName>textbox156</rd:DefaultName>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox157">
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
                                            <rd:DefaultName>textbox157</rd:DefaultName>
                                            <ZIndex>37</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox158">
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
                                            <rd:DefaultName>textbox158</rd:DefaultName>
                                            <ZIndex>36</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1417">
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
                                            <rd:DefaultName>textbox141</rd:DefaultName>
                                            <ZIndex>53</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox202">
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
                                            <rd:DefaultName>textbox202</rd:DefaultName>
                                            <ZIndex>52</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox142</rd:DefaultName>
                                            <ZIndex>51</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox143">
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
                                            <rd:DefaultName>textbox143</rd:DefaultName>
                                            <ZIndex>50</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox144">
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
                                            <ZIndex>49</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox145">
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
                                            <rd:DefaultName>textbox145</rd:DefaultName>
                                            <ZIndex>48</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox146">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalExclVATText.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox146</rd:DefaultName>
                                            <ZIndex>47</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox149">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!Amount_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox149</rd:DefaultName>
                                            <ZIndex>46</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox132">
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
                                            <rd:DefaultName>textbox132</rd:DefaultName>
                                            <ZIndex>61</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox203">
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
                                            <rd:DefaultName>textbox203</rd:DefaultName>
                                            <ZIndex>60</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox133">
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
                                            <rd:DefaultName>textbox133</rd:DefaultName>
                                            <ZIndex>59</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox134">
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
                                            <rd:DefaultName>textbox134</rd:DefaultName>
                                            <ZIndex>58</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox135">
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
                                            <rd:DefaultName>textbox135</rd:DefaultName>
                                            <ZIndex>57</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox136">
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
                                            <rd:DefaultName>textbox136</rd:DefaultName>
                                            <ZIndex>56</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox137">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!VATAmtLineVATAmtText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox137</rd:DefaultName>
                                            <ZIndex>55</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox140">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmountInclVAT.Value) - Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!AmtInclVATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox140</rd:DefaultName>
                                            <ZIndex>54</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox123</rd:DefaultName>
                                            <ZIndex>69</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox204">
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
                                            <rd:DefaultName>textbox204</rd:DefaultName>
                                            <ZIndex>68</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox124</rd:DefaultName>
                                            <ZIndex>67</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox125">
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
                                            <rd:DefaultName>textbox125</rd:DefaultName>
                                            <ZIndex>66</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox126">
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
                                            <rd:DefaultName>textbox126</rd:DefaultName>
                                            <ZIndex>65</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox127">
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
                                            <rd:DefaultName>textbox127</rd:DefaultName>
                                            <ZIndex>64</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox128">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalInclVATText.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox128</rd:DefaultName>
                                            <ZIndex>63</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox131">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmountInclVAT.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!AmtInclVAT_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox131</rd:DefaultName>
                                            <ZIndex>62</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox114">
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
                                            <rd:DefaultName>textbox114</rd:DefaultName>
                                            <ZIndex>79</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox205">
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
                                            <rd:DefaultName>textbox205</rd:DefaultName>
                                            <ZIndex>78</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox115">
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
                                            <rd:DefaultName>textbox115</rd:DefaultName>
                                            <ZIndex>77</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox116">
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
                                            <rd:DefaultName>textbox116</rd:DefaultName>
                                            <ZIndex>76</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox117</rd:DefaultName>
                                            <ZIndex>75</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox118</rd:DefaultName>
                                            <ZIndex>74</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox119</rd:DefaultName>
                                            <ZIndex>73</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox120</rd:DefaultName>
                                            <ZIndex>72</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1218">
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
                                            <rd:DefaultName>textbox121</rd:DefaultName>
                                            <ZIndex>71</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox122</rd:DefaultName>
                                            <ZIndex>70</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox105">
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
                                            <rd:DefaultName>textbox105</rd:DefaultName>
                                            <ZIndex>87</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox206">
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
                                            <rd:DefaultName>textbox206</rd:DefaultName>
                                            <ZIndex>86</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox106</rd:DefaultName>
                                            <ZIndex>85</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox107">
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
                                            <rd:DefaultName>textbox107</rd:DefaultName>
                                            <ZIndex>84</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox108</rd:DefaultName>
                                            <ZIndex>83</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox109</rd:DefaultName>
                                            <ZIndex>82</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox110">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!LineAmountInvDiscountAmountAmountIncludingVATCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox110</rd:DefaultName>
                                            <ZIndex>81</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox113">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=-(Last(Fields!TotalLineAmount.Value) - Last(Fields!TotalInvDiscAmount.Value) - Last(Fields!TotalAmountInclVAT.Value))</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!LineAmtInvDiscAmtAmtInclVATFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox113</rd:DefaultName>
                                            <ZIndex>80</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox96">
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
                                            <rd:DefaultName>textbox96</rd:DefaultName>
                                            <ZIndex>95</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox207</rd:DefaultName>
                                            <ZIndex>94</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox97</rd:DefaultName>
                                            <ZIndex>93</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox98</rd:DefaultName>
                                            <ZIndex>92</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox99</rd:DefaultName>
                                            <ZIndex>91</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox100">
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
                                            <rd:DefaultName>textbox100</rd:DefaultName>
                                            <ZIndex>90</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox101">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalInclVATText.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox101</rd:DefaultName>
                                            <ZIndex>89</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1049">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmountInclVAT.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!AmtInclVAT_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox104</rd:DefaultName>
                                            <ZIndex>88</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox87</rd:DefaultName>
                                            <ZIndex>105</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox208">
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
                                            <rd:DefaultName>textbox208</rd:DefaultName>
                                            <ZIndex>104</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox88</rd:DefaultName>
                                            <ZIndex>103</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox89</rd:DefaultName>
                                            <ZIndex>102</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox90</rd:DefaultName>
                                            <ZIndex>101</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox9110">
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
                                            <rd:DefaultName>textbox91</rd:DefaultName>
                                            <ZIndex>100</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox92</rd:DefaultName>
                                            <ZIndex>99</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox93</rd:DefaultName>
                                            <ZIndex>98</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox94</rd:DefaultName>
                                            <ZIndex>97</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox95">
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
                                            <rd:DefaultName>textbox95</rd:DefaultName>
                                            <ZIndex>96</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox78">
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
                                            <rd:DefaultName>textbox78</rd:DefaultName>
                                            <ZIndex>113</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox209">
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
                                            <rd:DefaultName>textbox209</rd:DefaultName>
                                            <ZIndex>112</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox79</rd:DefaultName>
                                            <ZIndex>111</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox80">
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
                                            <rd:DefaultName>textbox80</rd:DefaultName>
                                            <ZIndex>110</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox81">
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
                                            <rd:DefaultName>textbox81</rd:DefaultName>
                                            <ZIndex>109</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox82">
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
                                            <rd:DefaultName>textbox82</rd:DefaultName>
                                            <ZIndex>108</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox83">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!VATAmtLineVATAmtText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox83</rd:DefaultName>
                                            <ZIndex>107</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox86">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmountInclVAT.Value) - Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!AmtInclVATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox86</rd:DefaultName>
                                            <ZIndex>106</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox69">
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
                                            <rd:DefaultName>textbox69</rd:DefaultName>
                                            <ZIndex>121</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox210">
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
                                            <rd:DefaultName>textbox210</rd:DefaultName>
                                            <ZIndex>120</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox70</rd:DefaultName>
                                            <ZIndex>119</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox7111">
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
                                            <rd:DefaultName>textbox71</rd:DefaultName>
                                            <ZIndex>118</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox72</rd:DefaultName>
                                            <ZIndex>117</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox73">
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
                                            <rd:DefaultName>textbox73</rd:DefaultName>
                                            <ZIndex>116</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Fields!TotalExclVATText.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox74</rd:DefaultName>
                                            <ZIndex>115</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox77">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Amount_ServInvLineFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox77</rd:DefaultName>
                                            <ZIndex>114</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox33">
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
                                            <rd:DefaultName>textbox33</rd:DefaultName>
                                            <ZIndex>131</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox211">
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
                                            <rd:DefaultName>textbox211</rd:DefaultName>
                                            <ZIndex>130</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox34</rd:DefaultName>
                                            <ZIndex>129</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox35">
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
                                            <rd:DefaultName>textbox35</rd:DefaultName>
                                            <ZIndex>128</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox36">
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
                                            <rd:DefaultName>textbox36</rd:DefaultName>
                                            <ZIndex>127</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox37</rd:DefaultName>
                                            <ZIndex>126</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox38</rd:DefaultName>
                                            <ZIndex>125</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox39</rd:DefaultName>
                                            <ZIndex>124</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox40</rd:DefaultName>
                                            <ZIndex>123</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox41">
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
                                            <rd:DefaultName>textbox41</rd:DefaultName>
                                            <ZIndex>122</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                    <Group Name="table3_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=1</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="table3_Group2">
                                          <GroupExpressions>
                                            <GroupExpression>=Fields!LineNo_ServInvLine.Value</GroupExpression>
                                          </GroupExpressions>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!TypeInt.Value = 0,False,True)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!TypeInt.Value &gt; 0,False,True)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=Not((Fields!AccountCode_ServInvLine.Value&lt;&gt;"")AND(Fields!AccountCode_ServInvLine.Value&lt;&gt;Fields!AccountCode_ServInvHeader.Value))</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Group Name="table3_Details_Group">
                                              <DataElementName>Detail</DataElementName>
                                            </Group>
                                            <TablixMembers>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=IIF(Fields!ShipmentCaption.Value = "",True,False)</Hidden>
                                                </Visibility>
                                              </TablixMember>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=IIF(Fields!LineDimensionsCaption.Value = "",True,False)</Hidden>
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
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Last(Fields!TotalInvDiscAmount.Value) = 0,True,False)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Last(Fields!TotalInvDiscAmount.Value) = 0,True,False)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(not Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(not Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(not Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(not Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)) and
         not (Fields!BaseDisc_ServInvHeader.Value = 0),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!PricesInclVAT_ServInvHeader.Value and not (Last(Fields!TotalAmountInclVAT.Value) = Last(Fields!TotalAmount.Value)),False,True)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!No_ServInvLineCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>0.47619cm</Top>
                              <Left>0.01602cm</Left>
                              <Height>10.15225cm</Height>
                              <Width>17.84253cm</Width>
                              <ZIndex>3</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!No_ServInvLineCaption.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="table4">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.31cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.69999cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.69999cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.69999cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.69999cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.52001cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox76">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountSpecificationCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox76</rd:DefaultName>
                                            <ZIndex>39</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox216">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox216</rd:DefaultName>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox184">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox184</rd:DefaultName>
                                            <ZIndex>37</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox148">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox148</rd:DefaultName>
                                            <ZIndex>36</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox112</rd:DefaultName>
                                            <ZIndex>35</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>1.26901cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox56">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLineVATIdentifierCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox56</rd:DefaultName>
                                            <ZIndex>34</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox61">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLineVATCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox61</rd:DefaultName>
                                            <ZIndex>33</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox75">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLineLineAmountControl140Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox75</rd:DefaultName>
                                            <ZIndex>32</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox217">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLineInvDiscBaseAmountControl141Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox217</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox196">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLineInvDiscAmtCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox196</rd:DefaultName>
                                            <ZIndex>30</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox165">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLineVATBaseControl108Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox165</rd:DefaultName>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox129">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLineVATAmountControl109Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox129</rd:DefaultName>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox11">
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
                                            <rd:DefaultName>textbox11</rd:DefaultName>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox13">
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
                                            <rd:DefaultName>textbox13</rd:DefaultName>
                                            <ZIndex>26</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox15</rd:DefaultName>
                                            <ZIndex>25</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox218">
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
                                            <rd:DefaultName>textbox218</rd:DefaultName>
                                            <ZIndex>24</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox212">
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
                                            <rd:DefaultName>textbox212</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox166">
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
                                            <rd:DefaultName>textbox166</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox130">
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
                                            <rd:DefaultName>textbox130</rd:DefaultName>
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox17">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATIdentifier.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox17</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox19">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLineVAT.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLineVATFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox19</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox21">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineLineAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmtLineLineAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox21</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox219">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineInvDiscBaseAmt.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmtLineInvDiscBaseAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox219</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Fields!VATAmtLineInvDiscAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmtLineInvDiscAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox213</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Fields!VATAmtLineVATBase.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmtLineVATBaseFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox174</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox138">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmtLineVATAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmtLineVATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox138</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox102">
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
                                            <rd:DefaultName>textbox102</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox103">
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
                                            <rd:DefaultName>textbox103</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox111">
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
                                            <rd:DefaultName>textbox111</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox220">
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
                                            <rd:DefaultName>textbox220</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox214</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox175">
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
                                            <rd:DefaultName>textbox175</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox139">
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
                                            <rd:DefaultName>textbox139</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox23">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLineVATBaseControl116Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox23</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox53">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox53</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox55">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineLineAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineLineAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox55</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox22112">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineInvDiscBaseAmt.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineInvDiscBaseAmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox221</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox215">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineInvDiscAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineInvDiscAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox215</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox183">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmtLineVATBase.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineVATBaseFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox183</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                                    <Value>=Sum(Fields!VATAmtLineVATAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmtLineVATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox147</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                        <KeepTogether>true</KeepTogether>
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
                                  <FilterExpression>=Fields!VATAmountSpecificationCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>10.71428cm</Top>
                              <Left>0.01602cm</Left>
                              <Height>3.38407cm</Height>
                              <Width>17.82999cm</Width>
                              <ZIndex>4</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!VATAmountSpecificationCaption.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="table5">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>4.19999cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>10.5cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox226">
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
                                            <rd:DefaultName>textbox226</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox228">
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
                                            <rd:DefaultName>textbox228</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42301cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox8413">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PaymentTermsDescriptionCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox84</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox222">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PaymentTermsDescription.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox222</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.846cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox223">
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
                                            <rd:DefaultName>textbox223</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox225">
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
                                            <rd:DefaultName>textbox225</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                    <Group Name="table5_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
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
                                  <FilterExpression>=Fields!PaymentTermsDescriptionCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>16.42779cm</Top>
                              <Left>0.01602cm</Left>
                              <Height>1.69202cm</Height>
                              <Width>14.7cm</Width>
                              <ZIndex>5</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!PaymentTermsDescriptionCaption.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="table6">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.19999cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.2cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox246">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShiptoAddressCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox246</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox244">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustNo_ServInvHeaderCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox244</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox245">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!CustNo_ServInvHeader.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox245</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox242">
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
                                            <rd:DefaultName>textbox242</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox243">
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
                                            <rd:DefaultName>textbox243</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox240">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr1.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox240</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox238">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr2.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox238</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox236">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr3.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox236</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox234">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr4.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox234</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox232">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr5.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox232</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox227">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr6.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox227</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox85">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr7.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox85</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox229">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr8.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox229</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                    <Group Name="table6_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember />
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!BillToCustNo_ServInvHeader.Value = Fields!CustNo_ServInvHeader.Value,True,False)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!BillToCustNo_ServInvHeader.Value = Fields!CustNo_ServInvHeader.Value,True,False)</Hidden>
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
                                  <FilterExpression>=Fields!ShiptoAddressCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>18.19037cm</Top>
                              <Left>0.01602cm</Left>
                              <Height>1.83194in</Height>
                              <Width>5.39999cm</Width>
                              <ZIndex>6</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!ShiptoAddressCaption.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style />
                            </Tablix>
                            <Tablix Name="TableVATClauses">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2.5543cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.63949cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.85966cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.18628cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.18628cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>4.06131cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.5447cm</Width>
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
                                          <Textbox Name="textbox51">
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
                                          <Textbox Name="textbox71">
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
                                          <Textbox Name="textbox201">
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
                                          <Textbox Name="textbox181">
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
                                            <CanGrow>true</CanGrow>
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
                                            <CanGrow>true</CanGrow>
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
                                          <Hidden>=Microsoft.VisualBasic.Strings.Len(Fields!VATClauseDescription2.Value) = 0</Hidden>
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
                                  <FilterExpression>=Microsoft.VisualBasic.Strings.Len(Fields!VATClauseCode.Value)</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue DataType="Integer">0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>14.2053cm</Top>
                              <Left>0.01602cm</Left>
                              <Height>2.11666cm</Height>
                              <Width>18.03202cm</Width>
                              <ZIndex>7</ZIndex>
                              <Visibility>
                                <Hidden>=(Fields!VATClausesCaption.Value = "")</Hidden>
                              </Visibility>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
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
                      <GroupExpression>=Fields!No_ServiceInvHeader.Value</GroupExpression>
                      <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <Height>22.85434cm</Height>
            <Width>18.04804cm</Width>
            <Style />
          </Tablix>
          <Tablix Name="Tablix3">
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
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Filters>
              <Filter>
                <FilterExpression>=Fields!LineFeeCaptionLbl.Value</FilterExpression>
                <Operator>GreaterThan</Operator>
                <FilterValues>
                  <FilterValue>=""</FilterValue>
                </FilterValues>
              </Filter>
            </Filters>
            <Top>22.55034cm</Top>
            <Left>0.02483cm</Left>
            <Height>0.42333cm</Height>
            <Width>17.88733cm</Width>
            <ZIndex>8</ZIndex>
            <Style>
              <Border>
                <Style>None</Style>
              </Border>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>22.93371cm</Height>
        <Style />
      </Body>
      <Width>18cm</Width>
      <Page>
        <PageHeader>
          <Height>11.00501cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="ServiceInvoiceHeaderPricesIncludingVATCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!PricesInclVAT_ServInvHeaderCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>9.73377cm</Top>
              <Left>11.55cm</Left>
              <Height>0.16656in</Height>
              <Width>3.15cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Image Name="CompanyInfo2Picture1">
              <Source>Database</Source>
              <Value>=Convert.FromBase64String(Convert.ToBase64String(Fields!CompanyInfo2Picture.Value))</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Top>1cm</Top>
              <Left>12cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>1</ZIndex>
              <Visibility>
                <Hidden>=iif((IsNothing(Fields!CompanyInfo2Picture.Value)) = TRUE,TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style />
            </Image>
            <Textbox Name="ServiceInvoiceHeaderPostingDateCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!ServiceInvoiceHeaderPostingDateCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>8.88777cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Image Name="CompanyInfo1Picture1">
              <Source>Database</Source>
              <Value>=Convert.FromBase64String(Convert.ToBase64String(Fields!CompanyInfo1Picture.Value))</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Top>1cm</Top>
              <Left>6cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>3</ZIndex>
              <Visibility>
                <Hidden>=iif((IsNothing(Fields!CompanyInfo1Picture.Value)) = TRUE,TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style />
            </Image>
            <Textbox Name="InvoiceNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!InvoiceNoCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>8.037cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Image Name="CompanyInfoPicture1">
              <Source>Database</Source>
              <Value>=Convert.FromBase64String(Convert.ToBase64String(Fields!CompanyInfoPicture.Value))</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Top>1cm</Top>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>5</ZIndex>
              <Visibility>
                <Hidden>=iif((IsNothing(Fields!CompanyInfoPicture.Value)) = TRUE,TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style />
            </Image>
            <Textbox Name="ServiceInvoiceHeaderDueDateCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!ServiceInvoiceHeaderDueDateCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>9.31078cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceInvoiceHeaderBilltoCustomerNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!BillToCustNo_ServInvHeaderCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.768cm</Top>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>7</ZIndex>
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
                      <Value>=Fields!CompanyInfoBankAccountNoCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.00136cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>8</ZIndex>
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
                      <Value>=Fields!CompanyInfoBankNameCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>5.57837cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>9</ZIndex>
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
                      <Value>=Fields!CompanyInfoGiroNoCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>5.15537cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>10</ZIndex>
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
                      <Value>=Fields!CompanyInfoVATRegistrationNoCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>4.73236cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>11</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoFaxNoCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!CompanyInfoFaxNoCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>4.30937cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>12</ZIndex>
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
                      <Value>=Fields!CompanyInfoPhoneNoCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.88637cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>13</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceInvoiceHeaderPricesIncludingVAT1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(35,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>9.73377cm</Top>
              <Left>14.91cm</Left>
              <Height>0.16656in</Height>
              <Width>1.68cm</Width>
              <ZIndex>14</ZIndex>
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
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.46336cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>15</ZIndex>
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
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.04036cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>16</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr81">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(8,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>4.30937cm</Top>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>17</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr71">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(7,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.88637cm</Top>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>18</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceInvoiceHeaderOrderNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(32,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>8.46477cm</Top>
              <Left>14.91cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>19</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="OrderNoText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(31,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>8.46477cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>20</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceInvoiceHeaderYourReference1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(28,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>8.46cm</Top>
              <Left>3.36cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>21</ZIndex>
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
                      <Value>=Code.GetData(27,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>8.43061cm</Top>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>22</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceInvoiceHeaderNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(30,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>8.037cm</Top>
              <Left>14.91cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>23</ZIndex>
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
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>8.03699cm</Top>
              <Left>3.36cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>24</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesPersonText1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(25,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>8.03699cm</Top>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>25</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceInvoiceHeaderDueDate1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(34,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                        <Format>d</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>9.31078cm</Top>
              <Left>14.91cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>26</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceInvoiceHeaderVATRegistrationNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(24,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.614cm</Top>
              <Left>3.36cm</Left>
              <Height>0.423cm</Height>
              <Width>4.2cm</Width>
              <ZIndex>27</ZIndex>
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
                      <Value>=Code.GetData(23,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.614cm</Top>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>28</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceInvoiceHeaderPostingDate1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(33,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                        <Format>d</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>8.88777cm</Top>
              <Left>14.91cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>29</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ServiceInvoiceHeaderBilltoCustomerNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(22,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>6.768cm</Top>
              <Left>3.36cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>30</ZIndex>
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
                      <Value>=Code.GetData(20,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.00136cm</Top>
              <Left>13.86cm</Left>
              <Height>0.423cm</Height>
              <Width>4.21085cm</Width>
              <ZIndex>31</ZIndex>
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
                      <Value>=Code.GetData(19,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>5.57837cm</Top>
              <Left>13.86cm</Left>
              <Height>0.423cm</Height>
              <Width>4.21085cm</Width>
              <ZIndex>32</ZIndex>
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
                      <Value>=Code.GetData(18,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>5.15537cm</Top>
              <Left>13.86cm</Left>
              <Height>0.423cm</Height>
              <Width>4.21085cm</Width>
              <ZIndex>33</ZIndex>
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
                      <Value>=Code.GetData(17,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>4.73236cm</Top>
              <Left>13.86cm</Left>
              <Height>0.423cm</Height>
              <Width>4.21085cm</Width>
              <ZIndex>34</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoFaxNo1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(16,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>4.30937cm</Top>
              <Left>13.86cm</Left>
              <Height>0.423cm</Height>
              <Width>4.21085cm</Width>
              <ZIndex>35</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr61">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(6,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.46336cm</Top>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>36</ZIndex>
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
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.88637cm</Top>
              <Left>13.86cm</Left>
              <Height>0.423cm</Height>
              <Width>4.21085cm</Width>
              <ZIndex>37</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr51">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(5,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.04036cm</Top>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>38</ZIndex>
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
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.61737cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>39</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr41">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.61737cm</Top>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>40</ZIndex>
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
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.19437cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>41</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr31">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(3,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>2.19437cm</Top>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>42</ZIndex>
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
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>1.77136cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>43</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr21">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(2,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>1.77136cm</Top>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>44</ZIndex>
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
                        <FontSize>9pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>1.34837cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>45</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(1,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>1.34837cm</Top>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>46</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CopyText">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!ReportTitleCopyText.Value</Value>
                      <Style>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.07937cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>47</ZIndex>
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
                      <Value>=Code.GetData(29,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                        <Format>g</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>7.191cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>4.41cm</Width>
              <ZIndex>48</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PageNumberTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetGroupPageNumber(Fields!PageCaption.Value,ReportItems!NewPage.Value,Globals!PageNumber)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.50237cm</Top>
              <Left>11.55cm</Left>
              <Height>0.423cm</Height>
              <Width>1.68cm</Width>
              <ZIndex>49</ZIndex>
              <Visibility>
                <Hidden>=IsNothing(Code.GetData(46,1))</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox231">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(37,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>8.88889cm</Top>
              <Left>3.36cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>50</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox230">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(36,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>8.88889cm</Top>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>51</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox235">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(39,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>9.31217cm</Top>
              <Left>3.36cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>52</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox233">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(38,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>9.31217cm</Top>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>53</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox247">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(41,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>9.73545cm</Top>
              <Left>3.36cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>54</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox24114">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(40,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>9.73545cm</Top>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>55</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox239">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(43,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>10.15873cm</Top>
              <Left>3.36cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>56</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox237">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(42,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>10.15873cm</Top>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>57</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox255">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(45,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>10.58201cm</Top>
              <Left>3.36cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>58</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox254">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(44,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>10.58201cm</Top>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>59</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox249">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!CompanyInfoSWIFTCodeCaption.Value</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.42857cm</Top>
              <Left>11.56085cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>60</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox248">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(21,1)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>6.42857cm</Top>
              <Left>13.87085cm</Left>
              <Height>0.423cm</Height>
              <Width>4.2cm</Width>
              <ZIndex>61</ZIndex>
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
        <LeftMargin>1.5cm</LeftMargin>
        <TopMargin>2cm</TopMargin>
        <BottomMargin>2cm</BottomMargin>
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

Public Function GetData(Num as Integer, Group as integer) as Object
if Group = 1 then
   Return Cstr(Choose(Num, Split(Cstr(Data1),Chr(177))))
End If
End Function

Public Function SetData(NewData as Object,Group as integer)
  If Group = 1 and NewData &gt; "" Then
      Data1 = NewData
  End If
  Return True
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>7e8ab066-018d-43c0-bff6-baba551cd7c6</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

