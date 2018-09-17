OBJECT Report 216 Archived Sales Order
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Arkiveret salgsordre;
               ENU=Archived Sales Order];
    OnInitReport=BEGIN
                   GLSetup.GET;
                   CompanyInfo.GET;
                   SalesSetup.GET;

                   CASE SalesSetup."Logo Position on Documents" OF
                     SalesSetup."Logo Position on Documents"::"No Logo":
                       ;
                     SalesSetup."Logo Position on Documents"::Left:
                       CompanyInfo.CALCFIELDS(Picture);
                     SalesSetup."Logo Position on Documents"::Center:
                       BEGIN
                         CompanyInfo1.GET;
                         CompanyInfo1.CALCFIELDS(Picture);
                       END;
                     SalesSetup."Logo Position on Documents"::Right:
                       BEGIN
                         CompanyInfo2.GET;
                         CompanyInfo2.CALCFIELDS(Picture);
                       END;
                   END;
                 END;

  }
  DATASET
  {
    { 3260;    ;DataItem;                    ;
               DataItemTable=Table5107;
               DataItemTableView=SORTING(Document Type,No.,Doc. No. Occurrence,Version No.)
                                 WHERE(Document Type=CONST(Order));
               ReqFilterHeadingML=[DAN=Arkiveret salgsordre;
                                   ENU=Archived Sales Order];
               OnAfterGetRecord=BEGIN
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                                  FormatAddressFields("Sales Header Archive");
                                  FormatDocumentFields("Sales Header Archive");

                                  DimSetEntry1.SETRANGE("Dimension Set ID","Dimension Set ID");

                                  CALCFIELDS("No. of Archived Versions");
                                END;

               ReqFilterFields=No.,Sell-to Customer No.,No. Printed,Version No. }

    { 182 ;1   ;Column  ;Sales_Header_Archive_Document_Type;
               SourceExpr="Document Type" }

    { 183 ;1   ;Column  ;Sales_Header_Archive_No_;
               SourceExpr="No." }

    { 184 ;1   ;Column  ;Sales_Header_Archive_Doc__No__Occurrence;
               SourceExpr="Doc. No. Occurrence" }

    { 185 ;1   ;Column  ;Sales_Header_Archive_Version_No_;
               SourceExpr="Version No." }

    { 5701;1   ;DataItem;CopyLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               NoOfLoops := ABS(NoOfCopies) + 1;
                               CopyText := '';
                               SETRANGE(Number,1,NoOfLoops);
                               OutputNo := 1;
                             END;

               OnAfterGetRecord=VAR
                                  TempSalesHeader@1001 : TEMPORARY Record 36;
                                  TempSalesLine@1000 : TEMPORARY Record 37;
                                BEGIN
                                  InitTempLines(TempSalesHeader,TempSalesLine);

                                  VATAmount := VATAmountLine.GetTotalVATAmount;
                                  VATBaseAmount := VATAmountLine.GetTotalVATBase;
                                  VATDiscountAmount :=
                                    VATAmountLine.GetTotalVATDiscount(TempSalesHeader."Currency Code",TempSalesHeader."Prices Including VAT");
                                  TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                                  IF Number > 1 THEN BEGIN
                                    CopyText := FormatDocument.GetCOPYText;
                                    OutputNo += 1;
                                  END;
                                  CurrReport.PAGENO := 1;
                                END;

               OnPostDataItem=BEGIN
                                IF NOT IsReportInPreviewMode THEN
                                  CODEUNIT.RUN(CODEUNIT::"SalesCount-PrintedArch","Sales Header Archive");
                              END;
                               }

    { 6455;2   ;DataItem;PageLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 142 ;3   ;Column  ;CompanyInfo2_Picture;
               SourceExpr=CompanyInfo2.Picture }

    { 140 ;3   ;Column  ;CompanyInfo_Picture ;
               SourceExpr=CompanyInfo.Picture }

    { 141 ;3   ;Column  ;CompanyInfo1_Picture;
               SourceExpr=CompanyInfo1.Picture }

    { 1   ;3   ;Column  ;STRSUBSTNO_Text004_CopyText_;
               SourceExpr=STRSUBSTNO(Text004,CopyText) }

    { 2   ;3   ;Column  ;STRSUBSTNO_Text005_FORMAT_CurrReport_PAGENO__;
               SourceExpr=STRSUBSTNO(Text005,FORMAT(CurrReport.PAGENO)) }

    { 4   ;3   ;Column  ;CustAddr_1_         ;
               SourceExpr=CustAddr[1] }

    { 5   ;3   ;Column  ;CompanyAddr_1_      ;
               SourceExpr=CompanyAddr[1] }

    { 6   ;3   ;Column  ;CustAddr_2_         ;
               SourceExpr=CustAddr[2] }

    { 7   ;3   ;Column  ;CompanyAddr_2_      ;
               SourceExpr=CompanyAddr[2] }

    { 8   ;3   ;Column  ;CustAddr_3_         ;
               SourceExpr=CustAddr[3] }

    { 9   ;3   ;Column  ;CompanyAddr_3_      ;
               SourceExpr=CompanyAddr[3] }

    { 10  ;3   ;Column  ;CustAddr_4_         ;
               SourceExpr=CustAddr[4] }

    { 11  ;3   ;Column  ;CompanyAddr_4_      ;
               SourceExpr=CompanyAddr[4] }

    { 12  ;3   ;Column  ;CustAddr_5_         ;
               SourceExpr=CustAddr[5] }

    { 14  ;3   ;Column  ;CompanyInfo__Phone_No__;
               SourceExpr=CompanyInfo."Phone No." }

    { 15  ;3   ;Column  ;CustAddr_6_         ;
               SourceExpr=CustAddr[6] }

    { 17  ;3   ;Column  ;CompanyInfo__Fax_No__;
               SourceExpr=CompanyInfo."Fax No." }

    { 19  ;3   ;Column  ;CompanyInfo__VAT_Registration_No__;
               SourceExpr=CompanyInfo."VAT Registration No." }

    { 21  ;3   ;Column  ;CompanyInfo__Giro_No__;
               SourceExpr=CompanyInfo."Giro No." }

    { 23  ;3   ;Column  ;CompanyInfo__Bank_Name_;
               SourceExpr=CompanyInfo."Bank Name" }

    { 25  ;3   ;Column  ;CompanyInfo__Bank_Account_No__;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 27  ;3   ;Column  ;Sales_Header_Archive___Bill_to_Customer_No__;
               SourceExpr="Sales Header Archive"."Bill-to Customer No." }

    { 28  ;3   ;Column  ;FORMAT__Sales_Header_Archive___Document_Date__0_4_;
               SourceExpr=FORMAT("Sales Header Archive"."Document Date",0,4) }

    { 29  ;3   ;Column  ;VATNoText           ;
               SourceExpr=VATNoText }

    { 30  ;3   ;Column  ;Sales_Header_Archive___VAT_Registration_No__;
               SourceExpr="Sales Header Archive"."VAT Registration No." }

    { 32  ;3   ;Column  ;Sales_Header_Archive___Shipment_Date_;
               SourceExpr=FORMAT("Sales Header Archive"."Shipment Date") }

    { 33  ;3   ;Column  ;SalesPersonText     ;
               SourceExpr=SalesPersonText }

    { 34  ;3   ;Column  ;SalesPurchPerson_Name;
               SourceExpr=SalesPurchPerson.Name }

    { 36  ;3   ;Column  ;Sales_Header_Archive___No__;
               SourceExpr="Sales Header Archive"."No." }

    { 37  ;3   ;Column  ;ReferenceText       ;
               SourceExpr=ReferenceText }

    { 38  ;3   ;Column  ;Sales_Header_Archive___Your_Reference_;
               SourceExpr="Sales Header Archive"."Your Reference" }

    { 3   ;3   ;Column  ;CustAddr_7_         ;
               SourceExpr=CustAddr[7] }

    { 46  ;3   ;Column  ;CustAddr_8_         ;
               SourceExpr=CustAddr[8] }

    { 47  ;3   ;Column  ;CompanyAddr_5_      ;
               SourceExpr=CompanyAddr[5] }

    { 48  ;3   ;Column  ;CompanyAddr_6_      ;
               SourceExpr=CompanyAddr[6] }

    { 57  ;3   ;Column  ;Sales_Header_Archive___Prices_Including_VAT_;
               SourceExpr="Sales Header Archive"."Prices Including VAT" }

    { 215 ;3   ;Column  ;STRSUBSTNO_Text011__Sales_Header_Archive___Version_No____Sales_Header_Archive___No__of_Archived_Versions__;
               SourceExpr=STRSUBSTNO(Text011,"Sales Header Archive"."Version No.","Sales Header Archive"."No. of Archived Versions") }

    { 162 ;3   ;Column  ;VATBaseDiscountPercent;
               SourceExpr="Sales Header Archive"."VAT Base Discount %" }

    { 163 ;3   ;Column  ;PricesInclVAT_YesNo ;
               SourceExpr=FORMAT("Sales Header Archive"."Prices Including VAT") }

    { 164 ;3   ;Column  ;PageCaption         ;
               SourceExpr=STRSUBSTNO(Text005,'') }

    { 165 ;3   ;Column  ;OutputNo            ;
               SourceExpr=OutputNo }

    { 186 ;3   ;Column  ;PageLoop_Number     ;
               SourceExpr=Number }

    { 13  ;3   ;Column  ;CompanyInfo__Phone_No__Caption;
               SourceExpr=CompanyInfo__Phone_No__CaptionLbl }

    { 16  ;3   ;Column  ;CompanyInfo__Fax_No__Caption;
               SourceExpr=CompanyInfo__Fax_No__CaptionLbl }

    { 18  ;3   ;Column  ;CompanyInfo__VAT_Registration_No__Caption;
               SourceExpr=CompanyInfo__VAT_Registration_No__CaptionLbl }

    { 20  ;3   ;Column  ;CompanyInfo__Giro_No__Caption;
               SourceExpr=CompanyInfo__Giro_No__CaptionLbl }

    { 22  ;3   ;Column  ;CompanyInfo__Bank_Name_Caption;
               SourceExpr=CompanyInfo__Bank_Name_CaptionLbl }

    { 24  ;3   ;Column  ;CompanyInfo__Bank_Account_No__Caption;
               SourceExpr=CompanyInfo__Bank_Account_No__CaptionLbl }

    { 26  ;3   ;Column  ;Sales_Header_Archive___Bill_to_Customer_No__Caption;
               SourceExpr="Sales Header Archive".FIELDCAPTION("Bill-to Customer No.") }

    { 31  ;3   ;Column  ;Sales_Header_Archive___Shipment_Date_Caption;
               SourceExpr=Sales_Header_Archive___Shipment_Date_CaptionLbl }

    { 35  ;3   ;Column  ;Order_No_Caption    ;
               SourceExpr=Order_No_CaptionLbl }

    { 56  ;3   ;Column  ;Sales_Header_Archive___Prices_Including_VAT_Caption;
               SourceExpr="Sales Header Archive".FIELDCAPTION("Prices Including VAT") }

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

               DataItemLinkReference=Sales Header Archive }

    { 78  ;4   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 80  ;4   ;Column  ;DimText_Control80   ;
               SourceExpr=DimText }

    { 187 ;4   ;Column  ;DimensionLoop1_Number;
               SourceExpr=Number }

    { 79  ;4   ;Column  ;Header_DimensionsCaption;
               SourceExpr=Header_DimensionsCaptionLbl }

    { 6985;3   ;DataItem;                    ;
               DataItemTable=Table5108;
               DataItemTableView=SORTING(Document Type,Document No.,Line No.);
               OnPreDataItem=BEGIN
                               CurrReport.BREAK;
                             END;

               DataItemLinkReference=Sales Header Archive;
               DataItemLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.) }

    { 7551;3   ;DataItem;RoundLoop           ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               MoreLines := TempSalesLineArchive.FIND('+');
                               WHILE MoreLines AND (TempSalesLineArchive.Description = '') AND (TempSalesLineArchive."Description 2" = '') AND
                                     (TempSalesLineArchive."No." = '') AND (TempSalesLineArchive.Quantity = 0) AND
                                     (TempSalesLineArchive.Amount = 0)
                               DO
                                 MoreLines := TempSalesLineArchive.NEXT(-1) <> 0;
                               IF NOT MoreLines THEN
                                 CurrReport.BREAK;
                               TempSalesLineArchive.SETRANGE("Line No.",0,TempSalesLineArchive."Line No.");
                               SETRANGE(Number,1,TempSalesLineArchive.COUNT);
                               CurrReport.CREATETOTALS(TempSalesLineArchive."Line Amount",TempSalesLineArchive."Inv. Discount Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    TempSalesLineArchive.FIND('-')
                                  ELSE
                                    TempSalesLineArchive.NEXT;
                                  "Sales Line Archive" := TempSalesLineArchive;

                                  IF NOT "Sales Header Archive"."Prices Including VAT" AND
                                     (TempSalesLineArchive."VAT Calculation Type" = TempSalesLineArchive."VAT Calculation Type"::"Full VAT")
                                  THEN
                                    TempSalesLineArchive."Line Amount" := 0;

                                  IF (TempSalesLineArchive.Type = TempSalesLineArchive.Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                    "Sales Line Archive"."No." := '';
                                END;

               OnPostDataItem=BEGIN
                                TempSalesLineArchive.DELETEALL;
                              END;
                               }

    { 54  ;4   ;Column  ;SalesLineArch__Line_Amount_;
               SourceExpr=TempSalesLineArchive."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 55  ;4   ;Column  ;Sales_Line_Archive__Description;
               SourceExpr="Sales Line Archive".Description }

    { 170 ;4   ;Column  ;RoundLoopBody3Visibility;
               SourceExpr=TempSalesLineArchive.Type = 0 }

    { 62  ;4   ;Column  ;Sales_Line_Archive___No__;
               SourceExpr="Sales Line Archive"."No." }

    { 63  ;4   ;Column  ;Sales_Line_Archive__Description_Control63;
               SourceExpr="Sales Line Archive".Description }

    { 64  ;4   ;Column  ;Sales_Line_Archive__Quantity;
               SourceExpr="Sales Line Archive".Quantity }

    { 65  ;4   ;Column  ;Sales_Line_Archive___Unit_of_Measure_;
               SourceExpr="Sales Line Archive"."Unit of Measure" }

    { 66  ;4   ;Column  ;Sales_Line_Archive___Unit_Price_;
               SourceExpr="Sales Line Archive"."Unit Price";
               AutoFormatType=2;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 67  ;4   ;Column  ;Sales_Line_Archive___Line_Discount___;
               SourceExpr="Sales Line Archive"."Line Discount %" }

    { 68  ;4   ;Column  ;Sales_Line_Archive___Line_Amount_;
               SourceExpr="Sales Line Archive"."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 58  ;4   ;Column  ;Sales_Line_Archive___Allow_Invoice_Disc__;
               SourceExpr="Sales Line Archive"."Allow Invoice Disc." }

    { 59  ;4   ;Column  ;Sales_Line_Archive___VAT_Identifier_;
               SourceExpr="Sales Line Archive"."VAT Identifier" }

    { 166 ;4   ;Column  ;SalesLineType       ;
               SourceExpr=FORMAT("Sales Line Archive".Type) }

    { 167 ;4   ;Column  ;AllowInvoiceDis_YesNo;
               SourceExpr=FORMAT("Sales Line Archive"."Allow Invoice Disc.") }

    { 168 ;4   ;Column  ;SalesLineNo         ;
               SourceExpr=FORMAT("Sales Line Archive"."Line No.") }

    { 169 ;4   ;Column  ;RoundLoopBody4Visibility;
               SourceExpr=TempSalesLineArchive.Type > 0 }

    { 84  ;4   ;Column  ;SalesLineArch__Line_Amount__Control84;
               SourceExpr=TempSalesLineArchive."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 86  ;4   ;Column  ;SalesLineArch__Inv__Discount_Amount_;
               SourceExpr=TempSalesLineArchive."Inv. Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 70  ;4   ;Column  ;SalesLineArch__Line_Amount__Control70;
               SourceExpr=TempSalesLineArchive."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 137 ;4   ;Column  ;TotalText           ;
               SourceExpr=TotalText }

    { 138 ;4   ;Column  ;SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount_;
               SourceExpr=TempSalesLineArchive."Line Amount" - TempSalesLineArchive."Inv. Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 76  ;4   ;Column  ;TotalExclVATText    ;
               SourceExpr=TotalExclVATText }

    { 51  ;4   ;Column  ;VATAmountLine_VATAmountText;
               SourceExpr=VATAmountLine.VATAmountText }

    { 77  ;4   ;Column  ;TotalInclVATText    ;
               SourceExpr=TotalInclVATText }

    { 88  ;4   ;Column  ;SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount__Control88;
               SourceExpr=TempSalesLineArchive."Line Amount" - TempSalesLineArchive."Inv. Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 90  ;4   ;Column  ;VATAmount           ;
               SourceExpr=VATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 92  ;4   ;Column  ;SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount____VATAmount;
               SourceExpr=TempSalesLineArchive."Line Amount" - TempSalesLineArchive."Inv. Discount Amount" + VATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 139 ;4   ;Column  ;VATDiscountAmount   ;
               SourceExpr=-VATDiscountAmount;
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 131 ;4   ;Column  ;TotalExclVATText_Control131;
               SourceExpr=TotalExclVATText }

    { 132 ;4   ;Column  ;VATBaseAmount       ;
               SourceExpr=VATBaseAmount;
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 133 ;4   ;Column  ;VATAmountLine_VATAmountText_Control133;
               SourceExpr=VATAmountLine.VATAmountText }

    { 134 ;4   ;Column  ;VATAmount_Control134;
               SourceExpr=VATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 135 ;4   ;Column  ;TotalInclVATText_Control135;
               SourceExpr=TotalInclVATText }

    { 136 ;4   ;Column  ;TotalAmountInclVAT  ;
               SourceExpr=TotalAmountInclVAT;
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 188 ;4   ;Column  ;RoundLoop_Number    ;
               SourceExpr=Number }

    { 39  ;4   ;Column  ;Sales_Line_Archive___No__Caption;
               SourceExpr="Sales Line Archive".FIELDCAPTION("No.") }

    { 40  ;4   ;Column  ;Sales_Line_Archive__Description_Control63Caption;
               SourceExpr="Sales Line Archive".FIELDCAPTION(Description) }

    { 41  ;4   ;Column  ;Sales_Line_Archive__QuantityCaption;
               SourceExpr="Sales Line Archive".FIELDCAPTION(Quantity) }

    { 42  ;4   ;Column  ;Sales_Line_Archive___Unit_of_Measure_Caption;
               SourceExpr="Sales Line Archive".FIELDCAPTION("Unit of Measure") }

    { 43  ;4   ;Column  ;Unit_PriceCaption   ;
               SourceExpr=Unit_PriceCaptionLbl }

    { 44  ;4   ;Column  ;Sales_Line_Archive___Line_Discount___Caption;
               SourceExpr=Sales_Line_Archive___Line_Discount___CaptionLbl }

    { 45  ;4   ;Column  ;AmountCaption       ;
               SourceExpr=AmountCaptionLbl }

    { 60  ;4   ;Column  ;Sales_Line_Archive___VAT_Identifier_Caption;
               SourceExpr="Sales Line Archive".FIELDCAPTION("VAT Identifier") }

    { 61  ;4   ;Column  ;Sales_Line_Archive___Allow_Invoice_Disc__Caption;
               SourceExpr="Sales Line Archive".FIELDCAPTION("Allow Invoice Disc.") }

    { 53  ;4   ;Column  ;ContinuedCaption    ;
               SourceExpr=ContinuedCaptionLbl }

    { 83  ;4   ;Column  ;ContinuedCaption_Control83;
               SourceExpr=ContinuedCaption_Control83Lbl }

    { 85  ;4   ;Column  ;SalesLineArch__Inv__Discount_Amount_Caption;
               SourceExpr=SalesLineArch__Inv__Discount_Amount_CaptionLbl }

    { 69  ;4   ;Column  ;SubtotalCaption     ;
               SourceExpr=SubtotalCaptionLbl }

    { 89  ;4   ;Column  ;VATDiscountAmountCaption;
               SourceExpr=VATDiscountAmountCaptionLbl }

    { 3591;4   ;DataItem;DimensionLoop2      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowInternalInfo THEN
                                 CurrReport.BREAK;

                               DimSetEntry2.SETRANGE("Dimension Set ID","Sales Line Archive"."Dimension Set ID");
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

    { 82  ;5   ;Column  ;DimText_Control82   ;
               SourceExpr=DimText }

    { 189 ;5   ;Column  ;DimensionLoop2_Number;
               SourceExpr=Number }

    { 87  ;5   ;Column  ;Line_DimensionsCaption;
               SourceExpr=Line_DimensionsCaptionLbl }

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

    { 102 ;4   ;Column  ;VATAmountLine__VAT_Base_;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 103 ;4   ;Column  ;VATAmountLine__VAT_Amount_;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 97  ;4   ;Column  ;VATAmountLine__Line_Amount_;
               SourceExpr=VATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 98  ;4   ;Column  ;VATAmountLine__Inv__Disc__Base_Amount_;
               SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 99  ;4   ;Column  ;VATAmountLine__Invoice_Discount_Amount_;
               SourceExpr=VATAmountLine."Invoice Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 105 ;4   ;Column  ;VATAmountLine__VAT___;
               DecimalPlaces=0:5;
               SourceExpr=VATAmountLine."VAT %" }

    { 106 ;4   ;Column  ;VATAmountLine__VAT_Base__Control106;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 107 ;4   ;Column  ;VATAmountLine__VAT_Amount__Control107;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 71  ;4   ;Column  ;VATAmountLine__VAT_Identifier_;
               SourceExpr=VATAmountLine."VAT Identifier" }

    { 72  ;4   ;Column  ;VATAmountLine__Line_Amount__Control72;
               SourceExpr=VATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 73  ;4   ;Column  ;VATAmountLine__Inv__Disc__Base_Amount__Control73;
               SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 74  ;4   ;Column  ;VATAmountLine__Invoice_Discount_Amount__Control74;
               SourceExpr=VATAmountLine."Invoice Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 110 ;4   ;Column  ;VATAmountLine__VAT_Base__Control110;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 111 ;4   ;Column  ;VATAmountLine__VAT_Amount__Control111;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 100 ;4   ;Column  ;VATAmountLine__Line_Amount__Control100;
               SourceExpr=VATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 104 ;4   ;Column  ;VATAmountLine__Inv__Disc__Base_Amount__Control104;
               SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 108 ;4   ;Column  ;VATAmountLine__Invoice_Discount_Amount__Control108;
               SourceExpr=VATAmountLine."Invoice Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 114 ;4   ;Column  ;VATAmountLine__VAT_Base__Control114;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 115 ;4   ;Column  ;VATAmountLine__VAT_Amount__Control115;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 112 ;4   ;Column  ;VATAmountLine__Line_Amount__Control112;
               SourceExpr=VATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 116 ;4   ;Column  ;VATAmountLine__Inv__Disc__Base_Amount__Control116;
               SourceExpr=VATAmountLine."Inv. Disc. Base Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 130 ;4   ;Column  ;VATAmountLine__Invoice_Discount_Amount__Control130;
               SourceExpr=VATAmountLine."Invoice Discount Amount";
               AutoFormatType=1;
               AutoFormatExpr="Sales Header Archive"."Currency Code" }

    { 190 ;4   ;Column  ;VATCounter_Number   ;
               SourceExpr=Number }

    { 93  ;4   ;Column  ;VATAmountLine__VAT___Caption;
               SourceExpr=VATAmountLine__VAT___CaptionLbl }

    { 94  ;4   ;Column  ;VATAmountLine__VAT_Base__Control106Caption;
               SourceExpr=VATAmountLine__VAT_Base__Control106CaptionLbl }

    { 95  ;4   ;Column  ;VATAmountLine__VAT_Amount__Control107Caption;
               SourceExpr=VATAmountLine__VAT_Amount__Control107CaptionLbl }

    { 52  ;4   ;Column  ;VAT_Amount_SpecificationCaption;
               SourceExpr=VAT_Amount_SpecificationCaptionLbl }

    { 75  ;4   ;Column  ;VATAmountLine__Inv__Disc__Base_Amount__Control73Caption;
               SourceExpr=VATAmountLine__Inv__Disc__Base_Amount__Control73CaptionLbl }

    { 81  ;4   ;Column  ;VATAmountLine__Line_Amount__Control72Caption;
               SourceExpr=VATAmountLine__Line_Amount__Control72CaptionLbl }

    { 91  ;4   ;Column  ;VATAmountLine__Invoice_Discount_Amount__Control74Caption;
               SourceExpr=VATAmountLine__Invoice_Discount_Amount__Control74CaptionLbl }

    { 96  ;4   ;Column  ;VATAmountLine__VAT_Identifier_Caption;
               SourceExpr=VATAmountLine__VAT_Identifier_CaptionLbl }

    { 101 ;4   ;Column  ;VATAmountLine__VAT_Base_Caption;
               SourceExpr=VATAmountLine__VAT_Base_CaptionLbl }

    { 109 ;4   ;Column  ;VATAmountLine__VAT_Base__Control110Caption;
               SourceExpr=VATAmountLine__VAT_Base__Control110CaptionLbl }

    { 113 ;4   ;Column  ;VATAmountLine__VAT_Base__Control114Caption;
               SourceExpr=VATAmountLine__VAT_Base__Control114CaptionLbl }

    { 2038;3   ;DataItem;VATCounterLCY       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF (NOT GLSetup."Print VAT specification in LCY") OR
                                  ("Sales Header Archive"."Currency Code" = '') OR
                                  (VATAmountLine.GetTotalVATAmount = 0)
                               THEN
                                 CurrReport.BREAK;

                               SETRANGE(Number,1,VATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(VALVATBaseLCY,VALVATAmountLCY);

                               IF GLSetup."LCY Code" = '' THEN
                                 VALSpecLCYHeader := Text007 + Text008
                               ELSE
                                 VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                               CurrExchRate.FindCurrency("Sales Header Archive"."Posting Date","Sales Header Archive"."Currency Code",1);
                               VALExchRate := STRSUBSTNO(Text009,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  VATAmountLine.GetLine(Number);
                                  VALVATBaseLCY :=
                                    VATAmountLine.GetBaseLCY(
                                      "Sales Header Archive"."Posting Date","Sales Header Archive"."Currency Code",
                                      "Sales Header Archive"."Currency Factor");
                                  VALVATAmountLCY :=
                                    VATAmountLine.GetAmountLCY(
                                      "Sales Header Archive"."Posting Date","Sales Header Archive"."Currency Code",
                                      "Sales Header Archive"."Currency Factor");
                                END;
                                 }

    { 145 ;4   ;Column  ;VALExchRate         ;
               SourceExpr=VALExchRate }

    { 148 ;4   ;Column  ;VALSpecLCYHeader    ;
               SourceExpr=VALSpecLCYHeader }

    { 154 ;4   ;Column  ;VALVATBaseLCY       ;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 155 ;4   ;Column  ;VALVATAmountLCY     ;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 149 ;4   ;Column  ;VALVATAmountLCY_Control149;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 150 ;4   ;Column  ;VALVATBaseLCY_Control150;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 151 ;4   ;Column  ;VATAmountLine__VAT____Control151;
               DecimalPlaces=0:5;
               SourceExpr=VATAmountLine."VAT %" }

    { 152 ;4   ;Column  ;VATAmountLine__VAT_Identifier__Control152;
               SourceExpr=VATAmountLine."VAT Identifier" }

    { 156 ;4   ;Column  ;VALVATAmountLCY_Control156;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 157 ;4   ;Column  ;VALVATBaseLCY_Control157;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 159 ;4   ;Column  ;VALVATAmountLCY_Control159;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 160 ;4   ;Column  ;VALVATBaseLCY_Control160;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 191 ;4   ;Column  ;VATCounterLCY_Number;
               SourceExpr=Number }

    { 143 ;4   ;Column  ;VALVATAmountLCY_Control149Caption;
               SourceExpr=VALVATAmountLCY_Control149CaptionLbl }

    { 144 ;4   ;Column  ;VALVATBaseLCY_Control150Caption;
               SourceExpr=VALVATBaseLCY_Control150CaptionLbl }

    { 146 ;4   ;Column  ;VATAmountLine__VAT____Control151Caption;
               SourceExpr=VATAmountLine__VAT____Control151CaptionLbl }

    { 147 ;4   ;Column  ;VATAmountLine__VAT_Identifier__Control152Caption;
               SourceExpr=VATAmountLine__VAT_Identifier__Control152CaptionLbl }

    { 153 ;4   ;Column  ;VALVATBaseLCYCaption;
               SourceExpr=VALVATBaseLCYCaptionLbl }

    { 158 ;4   ;Column  ;VALVATBaseLCY_Control157Caption;
               SourceExpr=VALVATBaseLCY_Control157CaptionLbl }

    { 161 ;4   ;Column  ;VALVATBaseLCY_Control160Caption;
               SourceExpr=VALVATBaseLCY_Control160CaptionLbl }

    { 3476;3   ;DataItem;Total               ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 118 ;4   ;Column  ;PaymentTerms_Description;
               SourceExpr=PaymentTerms.Description }

    { 120 ;4   ;Column  ;ShipmentMethod_Description;
               SourceExpr=ShipmentMethod.Description }

    { 192 ;4   ;Column  ;Total_Number        ;
               SourceExpr=Number }

    { 117 ;4   ;Column  ;PaymentTerms_DescriptionCaption;
               SourceExpr=PaymentTerms_DescriptionCaptionLbl }

    { 119 ;4   ;Column  ;ShipmentMethod_DescriptionCaption;
               SourceExpr=ShipmentMethod_DescriptionCaptionLbl }

    { 3363;3   ;DataItem;Total2              ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF NOT ShowShippingAddr THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 123 ;4   ;Column  ;Sales_Header_Archive___Sell_to_Customer_No__;
               SourceExpr="Sales Header Archive"."Sell-to Customer No." }

    { 50  ;4   ;Column  ;ShipToAddr_8_       ;
               SourceExpr=ShipToAddr[8] }

    { 49  ;4   ;Column  ;ShipToAddr_7_       ;
               SourceExpr=ShipToAddr[7] }

    { 129 ;4   ;Column  ;ShipToAddr_6_       ;
               SourceExpr=ShipToAddr[6] }

    { 128 ;4   ;Column  ;ShipToAddr_5_       ;
               SourceExpr=ShipToAddr[5] }

    { 127 ;4   ;Column  ;ShipToAddr_4_       ;
               SourceExpr=ShipToAddr[4] }

    { 126 ;4   ;Column  ;ShipToAddr_3_       ;
               SourceExpr=ShipToAddr[3] }

    { 125 ;4   ;Column  ;ShipToAddr_2_       ;
               SourceExpr=ShipToAddr[2] }

    { 124 ;4   ;Column  ;ShipToAddr_1_       ;
               SourceExpr=ShipToAddr[1] }

    { 193 ;4   ;Column  ;Total2_Number       ;
               SourceExpr=Number }

    { 121 ;4   ;Column  ;Ship_to_AddressCaption;
               SourceExpr=Ship_to_AddressCaptionLbl }

    { 122 ;4   ;Column  ;Sales_Header_Archive___Sell_to_Customer_No__Caption;
               SourceExpr="Sales Header Archive".FIELDCAPTION("Sell-to Customer No.") }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Antal kopier;
                             ENU=No. of Copies];
                  ToolTipML=[DAN=Angiver, hvor mange kopier af bilaget der udskrives.;
                             ENU=Specifies how many copies of the document to print.];
                  ApplicationArea=#Advanced;
                  SourceExpr=NoOfCopies }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Vis interne oplysninger;
                             ENU=Show Internal Information];
                  ToolTipML=[DAN=Angiver, om rapport skal indeholde oplysninger, der kun er til intern brug.;
                             ENU=Specifies if you want the report to show information that is only for internal use.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ShowInternalInfo }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text004@1004 : TextConst '@@@="%1 = Document No.";DAN=Salgsordre arkiveret %1;ENU=Sales Order Archived %1';
      Text005@1005 : TextConst 'DAN=Side %1;ENU=Page %1';
      GLSetup@1007 : Record 98;
      ShipmentMethod@1008 : Record 10;
      PaymentTerms@1009 : Record 3;
      PrepmtPaymentTerms@1067 : Record 3;
      SalesPurchPerson@1010 : Record 13;
      CompanyInfo@1011 : Record 79;
      CompanyInfo1@1047 : Record 79;
      CompanyInfo2@1048 : Record 79;
      SalesSetup@1050 : Record 311;
      VATAmountLine@1012 : TEMPORARY Record 290;
      TempSalesLineArchive@1013 : TEMPORARY Record 5108;
      DimSetEntry1@1014 : Record 480;
      DimSetEntry2@1015 : Record 480;
      RespCenter@1016 : Record 5714;
      Language@1017 : Record 8;
      CurrExchRate@1056 : Record 330;
      FormatAddr@1019 : Codeunit 365;
      FormatDocument@1020 : Codeunit 368;
      CustAddr@1021 : ARRAY [8] OF Text[50];
      ShipToAddr@1022 : ARRAY [8] OF Text[50];
      CompanyAddr@1023 : ARRAY [8] OF Text[50];
      SalesPersonText@1024 : Text[30];
      VATNoText@1025 : Text[80];
      ReferenceText@1026 : Text[80];
      TotalText@1027 : Text[50];
      TotalExclVATText@1028 : Text[50];
      TotalInclVATText@1029 : Text[50];
      MoreLines@1030 : Boolean;
      NoOfCopies@1031 : Integer;
      NoOfLoops@1032 : Integer;
      CopyText@1033 : Text[30];
      ShowShippingAddr@1034 : Boolean;
      DimText@1036 : Text[120];
      OldDimText@1037 : Text[75];
      ShowInternalInfo@1038 : Boolean;
      Continue@1039 : Boolean;
      VATAmount@1040 : Decimal;
      VATBaseAmount@1043 : Decimal;
      VATDiscountAmount@1042 : Decimal;
      TotalAmountInclVAT@1041 : Decimal;
      VALVATBaseLCY@1049 : Decimal;
      VALVATAmountLCY@1051 : Decimal;
      VALSpecLCYHeader@1052 : Text[80];
      Text007@1055 : TextConst 'DAN="Momsbel�bsspecifikation i ";ENU="VAT Amount Specification in "';
      Text008@1054 : TextConst 'DAN=Lokal valuta;ENU=Local Currency';
      Text009@1053 : TextConst 'DAN=Valutakurs: %1/%2;ENU=Exchange rate: %1/%2';
      VALExchRate@1057 : Text[50];
      Text011@1060 : TextConst 'DAN=Version %1 af %2;ENU=Version %1 of %2';
      OutputNo@1061 : Integer;
      CompanyInfo__Phone_No__CaptionLbl@2240 : TextConst 'DAN=Telefon;ENU=Phone No.';
      CompanyInfo__Fax_No__CaptionLbl@9851 : TextConst 'DAN=Telefax;ENU=Fax No.';
      CompanyInfo__VAT_Registration_No__CaptionLbl@4406 : TextConst 'DAN=SE/CVR-nr.;ENU=VAT Reg. No.';
      CompanyInfo__Giro_No__CaptionLbl@6756 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      CompanyInfo__Bank_Name_CaptionLbl@4354 : TextConst 'DAN=Bank;ENU=Bank';
      CompanyInfo__Bank_Account_No__CaptionLbl@6132 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      Sales_Header_Archive___Shipment_Date_CaptionLbl@8961 : TextConst 'DAN=Afsendelsesdato;ENU=Shipment Date';
      Order_No_CaptionLbl@9142 : TextConst 'DAN=Ordrenr.;ENU=Order No.';
      Header_DimensionsCaptionLbl@4011 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      Unit_PriceCaptionLbl@9609 : TextConst 'DAN=Enhedspris;ENU=Unit Price';
      Sales_Line_Archive___Line_Discount___CaptionLbl@2863 : TextConst 'DAN=Rabatpct.;ENU=Disc. %';
      AmountCaptionLbl@7794 : TextConst 'DAN=Bel�b;ENU=Amount';
      ContinuedCaptionLbl@2842 : TextConst 'DAN=Fortsat;ENU=Continued';
      ContinuedCaption_Control83Lbl@2940 : TextConst 'DAN=Fortsat;ENU=Continued';
      SalesLineArch__Inv__Discount_Amount_CaptionLbl@7943 : TextConst 'DAN=Fakturarabatbel�b;ENU=Inv. Discount Amount';
      SubtotalCaptionLbl@1782 : TextConst 'DAN=Subtotal;ENU=Subtotal';
      VATDiscountAmountCaptionLbl@6738 : TextConst 'DAN=Moms ved kontantrabat;ENU=Payment Discount on VAT';
      Line_DimensionsCaptionLbl@3103 : TextConst 'DAN=Linjedimensioner;ENU=Line Dimensions';
      VATAmountLine__VAT___CaptionLbl@6736 : TextConst 'DAN=Momspct.;ENU=VAT %';
      VATAmountLine__VAT_Base__Control106CaptionLbl@8607 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATAmountLine__VAT_Amount__Control107CaptionLbl@5283 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VAT_Amount_SpecificationCaptionLbl@5688 : TextConst 'DAN=Momsbel�bspecifikation;ENU=VAT Amount Specification';
      VATAmountLine__Inv__Disc__Base_Amount__Control73CaptionLbl@6582 : TextConst 'DAN=Fakturarabatgrundlag - bel�b;ENU=Inv. Disc. Base Amount';
      VATAmountLine__Line_Amount__Control72CaptionLbl@9183 : TextConst 'DAN=Linjebel�b;ENU=Line Amount';
      VATAmountLine__Invoice_Discount_Amount__Control74CaptionLbl@9415 : TextConst 'DAN=Fakturarabatbel�b;ENU=Invoice Discount Amount';
      VATAmountLine__VAT_Identifier_CaptionLbl@6385 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      VATAmountLine__VAT_Base_CaptionLbl@8090 : TextConst 'DAN=Fortsat;ENU=Continued';
      VATAmountLine__VAT_Base__Control110CaptionLbl@3684 : TextConst 'DAN=Fortsat;ENU=Continued';
      VATAmountLine__VAT_Base__Control114CaptionLbl@1974 : TextConst 'DAN=I alt;ENU=Total';
      VALVATAmountLCY_Control149CaptionLbl@9444 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VALVATBaseLCY_Control150CaptionLbl@2856 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATAmountLine__VAT____Control151CaptionLbl@5516 : TextConst 'DAN=Momspct.;ENU=VAT %';
      VATAmountLine__VAT_Identifier__Control152CaptionLbl@9939 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      VALVATBaseLCYCaptionLbl@7003 : TextConst 'DAN=Fortsat;ENU=Continued';
      VALVATBaseLCY_Control157CaptionLbl@9984 : TextConst 'DAN=Fortsat;ENU=Continued';
      VALVATBaseLCY_Control160CaptionLbl@3686 : TextConst 'DAN=I alt;ENU=Total';
      PaymentTerms_DescriptionCaptionLbl@5890 : TextConst 'DAN=Betalingsbetingelser;ENU=Payment Terms';
      ShipmentMethod_DescriptionCaptionLbl@1316 : TextConst 'DAN=Leveringsform;ENU=Shipment Method';
      Ship_to_AddressCaptionLbl@7560 : TextConst 'DAN=Leveringsadresse;ENU=Ship-to Address';

    LOCAL PROCEDURE IsReportInPreviewMode@8() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    LOCAL PROCEDURE FormatAddressFields@1(VAR SalesHeaderArchive@1000 : Record 5107);
    BEGIN
      FormatAddr.GetCompanyAddr(SalesHeaderArchive."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
      FormatAddr.SalesHeaderArchBillTo(CustAddr,SalesHeaderArchive);
      ShowShippingAddr := FormatAddr.SalesHeaderArchShipTo(ShipToAddr,CustAddr,SalesHeaderArchive);
    END;

    LOCAL PROCEDURE FormatDocumentFields@2(SalesHeaderArchive@1000 : Record 5107);
    BEGIN
      WITH SalesHeaderArchive DO BEGIN
        FormatDocument.SetTotalLabels("Currency Code",TotalText,TotalInclVATText,TotalExclVATText);
        FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms,"Payment Terms Code","Language Code");
        FormatDocument.SetPaymentTerms(PrepmtPaymentTerms,"Prepmt. Payment Terms Code","Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");

        ReferenceText := FormatDocument.SetText("Your Reference" <> '',FIELDCAPTION("Your Reference"));
        VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FIELDCAPTION("VAT Registration No."));
      END;
    END;

    LOCAL PROCEDURE InitTempLines@3(VAR TempSalesHeader@1002 : TEMPORARY Record 36;VAR TempSalesLine@1001 : TEMPORARY Record 37);
    BEGIN
      TempSalesLineArchive.CopyTempLines("Sales Header Archive",TempSalesLine);

      VATAmountLine.DELETEALL;
      TempSalesHeader.TRANSFERFIELDS("Sales Header Archive");
      TempSalesLine."Prepayment Line" := TRUE;  // used as flag in CalcVATAmountLines -> not invoice rounding
      TempSalesLine.CalcVATAmountLines(0,TempSalesHeader,TempSalesLine,VATAmountLine);
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
      <rd:DataSourceID>1ea0b85e-d805-44f4-89c0-992e3deab0a5</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="Sales_Header_Archive_Document_Type">
          <DataField>Sales_Header_Archive_Document_Type</DataField>
        </Field>
        <Field Name="Sales_Header_Archive_No_">
          <DataField>Sales_Header_Archive_No_</DataField>
        </Field>
        <Field Name="Sales_Header_Archive_Doc__No__Occurrence">
          <DataField>Sales_Header_Archive_Doc__No__Occurrence</DataField>
        </Field>
        <Field Name="Sales_Header_Archive_Version_No_">
          <DataField>Sales_Header_Archive_Version_No_</DataField>
        </Field>
        <Field Name="CompanyInfo2_Picture">
          <DataField>CompanyInfo2_Picture</DataField>
        </Field>
        <Field Name="CompanyInfo_Picture">
          <DataField>CompanyInfo_Picture</DataField>
        </Field>
        <Field Name="CompanyInfo1_Picture">
          <DataField>CompanyInfo1_Picture</DataField>
        </Field>
        <Field Name="STRSUBSTNO_Text004_CopyText_">
          <DataField>STRSUBSTNO_Text004_CopyText_</DataField>
        </Field>
        <Field Name="STRSUBSTNO_Text005_FORMAT_CurrReport_PAGENO__">
          <DataField>STRSUBSTNO_Text005_FORMAT_CurrReport_PAGENO__</DataField>
        </Field>
        <Field Name="CustAddr_1_">
          <DataField>CustAddr_1_</DataField>
        </Field>
        <Field Name="CompanyAddr_1_">
          <DataField>CompanyAddr_1_</DataField>
        </Field>
        <Field Name="CustAddr_2_">
          <DataField>CustAddr_2_</DataField>
        </Field>
        <Field Name="CompanyAddr_2_">
          <DataField>CompanyAddr_2_</DataField>
        </Field>
        <Field Name="CustAddr_3_">
          <DataField>CustAddr_3_</DataField>
        </Field>
        <Field Name="CompanyAddr_3_">
          <DataField>CompanyAddr_3_</DataField>
        </Field>
        <Field Name="CustAddr_4_">
          <DataField>CustAddr_4_</DataField>
        </Field>
        <Field Name="CompanyAddr_4_">
          <DataField>CompanyAddr_4_</DataField>
        </Field>
        <Field Name="CustAddr_5_">
          <DataField>CustAddr_5_</DataField>
        </Field>
        <Field Name="CompanyInfo__Phone_No__">
          <DataField>CompanyInfo__Phone_No__</DataField>
        </Field>
        <Field Name="CustAddr_6_">
          <DataField>CustAddr_6_</DataField>
        </Field>
        <Field Name="CompanyInfo__Fax_No__">
          <DataField>CompanyInfo__Fax_No__</DataField>
        </Field>
        <Field Name="CompanyInfo__VAT_Registration_No__">
          <DataField>CompanyInfo__VAT_Registration_No__</DataField>
        </Field>
        <Field Name="CompanyInfo__Giro_No__">
          <DataField>CompanyInfo__Giro_No__</DataField>
        </Field>
        <Field Name="CompanyInfo__Bank_Name_">
          <DataField>CompanyInfo__Bank_Name_</DataField>
        </Field>
        <Field Name="CompanyInfo__Bank_Account_No__">
          <DataField>CompanyInfo__Bank_Account_No__</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___Bill_to_Customer_No__">
          <DataField>Sales_Header_Archive___Bill_to_Customer_No__</DataField>
        </Field>
        <Field Name="FORMAT__Sales_Header_Archive___Document_Date__0_4_">
          <DataField>FORMAT__Sales_Header_Archive___Document_Date__0_4_</DataField>
        </Field>
        <Field Name="VATNoText">
          <DataField>VATNoText</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___VAT_Registration_No__">
          <DataField>Sales_Header_Archive___VAT_Registration_No__</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___Shipment_Date_">
          <DataField>Sales_Header_Archive___Shipment_Date_</DataField>
        </Field>
        <Field Name="SalesPersonText">
          <DataField>SalesPersonText</DataField>
        </Field>
        <Field Name="SalesPurchPerson_Name">
          <DataField>SalesPurchPerson_Name</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___No__">
          <DataField>Sales_Header_Archive___No__</DataField>
        </Field>
        <Field Name="ReferenceText">
          <DataField>ReferenceText</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___Your_Reference_">
          <DataField>Sales_Header_Archive___Your_Reference_</DataField>
        </Field>
        <Field Name="CustAddr_7_">
          <DataField>CustAddr_7_</DataField>
        </Field>
        <Field Name="CustAddr_8_">
          <DataField>CustAddr_8_</DataField>
        </Field>
        <Field Name="CompanyAddr_5_">
          <DataField>CompanyAddr_5_</DataField>
        </Field>
        <Field Name="CompanyAddr_6_">
          <DataField>CompanyAddr_6_</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___Prices_Including_VAT_">
          <DataField>Sales_Header_Archive___Prices_Including_VAT_</DataField>
        </Field>
        <Field Name="STRSUBSTNO_Text011__Sales_Header_Archive___Version_No____Sales_Header_Archive___No__of_Archived_Versions__">
          <DataField>STRSUBSTNO_Text011__Sales_Header_Archive___Version_No____Sales_Header_Archive___No__of_Archived_Versions__</DataField>
        </Field>
        <Field Name="VATBaseDiscountPercent">
          <DataField>VATBaseDiscountPercent</DataField>
        </Field>
        <Field Name="VATBaseDiscountPercentFormat">
          <DataField>VATBaseDiscountPercentFormat</DataField>
        </Field>
        <Field Name="PricesInclVAT_YesNo">
          <DataField>PricesInclVAT_YesNo</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="OutputNo">
          <DataField>OutputNo</DataField>
        </Field>
        <Field Name="PageLoop_Number">
          <DataField>PageLoop_Number</DataField>
        </Field>
        <Field Name="CompanyInfo__Phone_No__Caption">
          <DataField>CompanyInfo__Phone_No__Caption</DataField>
        </Field>
        <Field Name="CompanyInfo__Fax_No__Caption">
          <DataField>CompanyInfo__Fax_No__Caption</DataField>
        </Field>
        <Field Name="CompanyInfo__VAT_Registration_No__Caption">
          <DataField>CompanyInfo__VAT_Registration_No__Caption</DataField>
        </Field>
        <Field Name="CompanyInfo__Giro_No__Caption">
          <DataField>CompanyInfo__Giro_No__Caption</DataField>
        </Field>
        <Field Name="CompanyInfo__Bank_Name_Caption">
          <DataField>CompanyInfo__Bank_Name_Caption</DataField>
        </Field>
        <Field Name="CompanyInfo__Bank_Account_No__Caption">
          <DataField>CompanyInfo__Bank_Account_No__Caption</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___Bill_to_Customer_No__Caption">
          <DataField>Sales_Header_Archive___Bill_to_Customer_No__Caption</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___Shipment_Date_Caption">
          <DataField>Sales_Header_Archive___Shipment_Date_Caption</DataField>
        </Field>
        <Field Name="Order_No_Caption">
          <DataField>Order_No_Caption</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___Prices_Including_VAT_Caption">
          <DataField>Sales_Header_Archive___Prices_Including_VAT_Caption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="DimText_Control80">
          <DataField>DimText_Control80</DataField>
        </Field>
        <Field Name="DimensionLoop1_Number">
          <DataField>DimensionLoop1_Number</DataField>
        </Field>
        <Field Name="Header_DimensionsCaption">
          <DataField>Header_DimensionsCaption</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount_">
          <DataField>SalesLineArch__Line_Amount_</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount_Format">
          <DataField>SalesLineArch__Line_Amount_Format</DataField>
        </Field>
        <Field Name="Sales_Line_Archive__Description">
          <DataField>Sales_Line_Archive__Description</DataField>
        </Field>
        <Field Name="RoundLoopBody3Visibility">
          <DataField>RoundLoopBody3Visibility</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___No__">
          <DataField>Sales_Line_Archive___No__</DataField>
        </Field>
        <Field Name="Sales_Line_Archive__Description_Control63">
          <DataField>Sales_Line_Archive__Description_Control63</DataField>
        </Field>
        <Field Name="Sales_Line_Archive__Quantity">
          <DataField>Sales_Line_Archive__Quantity</DataField>
        </Field>
        <Field Name="Sales_Line_Archive__QuantityFormat">
          <DataField>Sales_Line_Archive__QuantityFormat</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Unit_of_Measure_">
          <DataField>Sales_Line_Archive___Unit_of_Measure_</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Unit_Price_">
          <DataField>Sales_Line_Archive___Unit_Price_</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Unit_Price_Format">
          <DataField>Sales_Line_Archive___Unit_Price_Format</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Line_Discount___">
          <DataField>Sales_Line_Archive___Line_Discount___</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Line_Discount___Format">
          <DataField>Sales_Line_Archive___Line_Discount___Format</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Line_Amount_">
          <DataField>Sales_Line_Archive___Line_Amount_</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Line_Amount_Format">
          <DataField>Sales_Line_Archive___Line_Amount_Format</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Allow_Invoice_Disc__">
          <DataField>Sales_Line_Archive___Allow_Invoice_Disc__</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___VAT_Identifier_">
          <DataField>Sales_Line_Archive___VAT_Identifier_</DataField>
        </Field>
        <Field Name="SalesLineType">
          <DataField>SalesLineType</DataField>
        </Field>
        <Field Name="AllowInvoiceDis_YesNo">
          <DataField>AllowInvoiceDis_YesNo</DataField>
        </Field>
        <Field Name="SalesLineNo">
          <DataField>SalesLineNo</DataField>
        </Field>
        <Field Name="RoundLoopBody4Visibility">
          <DataField>RoundLoopBody4Visibility</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__Control84">
          <DataField>SalesLineArch__Line_Amount__Control84</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__Control84Format">
          <DataField>SalesLineArch__Line_Amount__Control84Format</DataField>
        </Field>
        <Field Name="SalesLineArch__Inv__Discount_Amount_">
          <DataField>SalesLineArch__Inv__Discount_Amount_</DataField>
        </Field>
        <Field Name="SalesLineArch__Inv__Discount_Amount_Format">
          <DataField>SalesLineArch__Inv__Discount_Amount_Format</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__Control70">
          <DataField>SalesLineArch__Line_Amount__Control70</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__Control70Format">
          <DataField>SalesLineArch__Line_Amount__Control70Format</DataField>
        </Field>
        <Field Name="TotalText">
          <DataField>TotalText</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount_">
          <DataField>SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount_</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount_Format">
          <DataField>SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount_Format</DataField>
        </Field>
        <Field Name="TotalExclVATText">
          <DataField>TotalExclVATText</DataField>
        </Field>
        <Field Name="VATAmountLine_VATAmountText">
          <DataField>VATAmountLine_VATAmountText</DataField>
        </Field>
        <Field Name="TotalInclVATText">
          <DataField>TotalInclVATText</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount__Control88">
          <DataField>SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount__Control88</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount__Control88Format">
          <DataField>SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount__Control88Format</DataField>
        </Field>
        <Field Name="VATAmount">
          <DataField>VATAmount</DataField>
        </Field>
        <Field Name="VATAmountFormat">
          <DataField>VATAmountFormat</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount____VATAmount">
          <DataField>SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount____VATAmount</DataField>
        </Field>
        <Field Name="SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount____VATAmountFormat">
          <DataField>SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount____VATAmountFormat</DataField>
        </Field>
        <Field Name="VATDiscountAmount">
          <DataField>VATDiscountAmount</DataField>
        </Field>
        <Field Name="VATDiscountAmountFormat">
          <DataField>VATDiscountAmountFormat</DataField>
        </Field>
        <Field Name="TotalExclVATText_Control131">
          <DataField>TotalExclVATText_Control131</DataField>
        </Field>
        <Field Name="VATBaseAmount">
          <DataField>VATBaseAmount</DataField>
        </Field>
        <Field Name="VATBaseAmountFormat">
          <DataField>VATBaseAmountFormat</DataField>
        </Field>
        <Field Name="VATAmountLine_VATAmountText_Control133">
          <DataField>VATAmountLine_VATAmountText_Control133</DataField>
        </Field>
        <Field Name="VATAmount_Control134">
          <DataField>VATAmount_Control134</DataField>
        </Field>
        <Field Name="VATAmount_Control134Format">
          <DataField>VATAmount_Control134Format</DataField>
        </Field>
        <Field Name="TotalInclVATText_Control135">
          <DataField>TotalInclVATText_Control135</DataField>
        </Field>
        <Field Name="TotalAmountInclVAT">
          <DataField>TotalAmountInclVAT</DataField>
        </Field>
        <Field Name="TotalAmountInclVATFormat">
          <DataField>TotalAmountInclVATFormat</DataField>
        </Field>
        <Field Name="RoundLoop_Number">
          <DataField>RoundLoop_Number</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___No__Caption">
          <DataField>Sales_Line_Archive___No__Caption</DataField>
        </Field>
        <Field Name="Sales_Line_Archive__Description_Control63Caption">
          <DataField>Sales_Line_Archive__Description_Control63Caption</DataField>
        </Field>
        <Field Name="Sales_Line_Archive__QuantityCaption">
          <DataField>Sales_Line_Archive__QuantityCaption</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Unit_of_Measure_Caption">
          <DataField>Sales_Line_Archive___Unit_of_Measure_Caption</DataField>
        </Field>
        <Field Name="Unit_PriceCaption">
          <DataField>Unit_PriceCaption</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Line_Discount___Caption">
          <DataField>Sales_Line_Archive___Line_Discount___Caption</DataField>
        </Field>
        <Field Name="AmountCaption">
          <DataField>AmountCaption</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___VAT_Identifier_Caption">
          <DataField>Sales_Line_Archive___VAT_Identifier_Caption</DataField>
        </Field>
        <Field Name="Sales_Line_Archive___Allow_Invoice_Disc__Caption">
          <DataField>Sales_Line_Archive___Allow_Invoice_Disc__Caption</DataField>
        </Field>
        <Field Name="ContinuedCaption">
          <DataField>ContinuedCaption</DataField>
        </Field>
        <Field Name="ContinuedCaption_Control83">
          <DataField>ContinuedCaption_Control83</DataField>
        </Field>
        <Field Name="SalesLineArch__Inv__Discount_Amount_Caption">
          <DataField>SalesLineArch__Inv__Discount_Amount_Caption</DataField>
        </Field>
        <Field Name="SubtotalCaption">
          <DataField>SubtotalCaption</DataField>
        </Field>
        <Field Name="VATDiscountAmountCaption">
          <DataField>VATDiscountAmountCaption</DataField>
        </Field>
        <Field Name="DimText_Control82">
          <DataField>DimText_Control82</DataField>
        </Field>
        <Field Name="DimensionLoop2_Number">
          <DataField>DimensionLoop2_Number</DataField>
        </Field>
        <Field Name="Line_DimensionsCaption">
          <DataField>Line_DimensionsCaption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base_">
          <DataField>VATAmountLine__VAT_Base_</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base_Format">
          <DataField>VATAmountLine__VAT_Base_Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount_">
          <DataField>VATAmountLine__VAT_Amount_</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount_Format">
          <DataField>VATAmountLine__VAT_Amount_Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount_">
          <DataField>VATAmountLine__Line_Amount_</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount_Format">
          <DataField>VATAmountLine__Line_Amount_Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Inv__Disc__Base_Amount_">
          <DataField>VATAmountLine__Inv__Disc__Base_Amount_</DataField>
        </Field>
        <Field Name="VATAmountLine__Inv__Disc__Base_Amount_Format">
          <DataField>VATAmountLine__Inv__Disc__Base_Amount_Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Invoice_Discount_Amount_">
          <DataField>VATAmountLine__Invoice_Discount_Amount_</DataField>
        </Field>
        <Field Name="VATAmountLine__Invoice_Discount_Amount_Format">
          <DataField>VATAmountLine__Invoice_Discount_Amount_Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT___">
          <DataField>VATAmountLine__VAT___</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT___Format">
          <DataField>VATAmountLine__VAT___Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control106">
          <DataField>VATAmountLine__VAT_Base__Control106</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control106Format">
          <DataField>VATAmountLine__VAT_Base__Control106Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control107">
          <DataField>VATAmountLine__VAT_Amount__Control107</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control107Format">
          <DataField>VATAmountLine__VAT_Amount__Control107Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Identifier_">
          <DataField>VATAmountLine__VAT_Identifier_</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control72">
          <DataField>VATAmountLine__Line_Amount__Control72</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control72Format">
          <DataField>VATAmountLine__Line_Amount__Control72Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Inv__Disc__Base_Amount__Control73">
          <DataField>VATAmountLine__Inv__Disc__Base_Amount__Control73</DataField>
        </Field>
        <Field Name="VATAmountLine__Inv__Disc__Base_Amount__Control73Format">
          <DataField>VATAmountLine__Inv__Disc__Base_Amount__Control73Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Invoice_Discount_Amount__Control74">
          <DataField>VATAmountLine__Invoice_Discount_Amount__Control74</DataField>
        </Field>
        <Field Name="VATAmountLine__Invoice_Discount_Amount__Control74Format">
          <DataField>VATAmountLine__Invoice_Discount_Amount__Control74Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control110">
          <DataField>VATAmountLine__VAT_Base__Control110</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control110Format">
          <DataField>VATAmountLine__VAT_Base__Control110Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control111">
          <DataField>VATAmountLine__VAT_Amount__Control111</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control111Format">
          <DataField>VATAmountLine__VAT_Amount__Control111Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control100">
          <DataField>VATAmountLine__Line_Amount__Control100</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control100Format">
          <DataField>VATAmountLine__Line_Amount__Control100Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Inv__Disc__Base_Amount__Control104">
          <DataField>VATAmountLine__Inv__Disc__Base_Amount__Control104</DataField>
        </Field>
        <Field Name="VATAmountLine__Inv__Disc__Base_Amount__Control104Format">
          <DataField>VATAmountLine__Inv__Disc__Base_Amount__Control104Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Invoice_Discount_Amount__Control108">
          <DataField>VATAmountLine__Invoice_Discount_Amount__Control108</DataField>
        </Field>
        <Field Name="VATAmountLine__Invoice_Discount_Amount__Control108Format">
          <DataField>VATAmountLine__Invoice_Discount_Amount__Control108Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control114">
          <DataField>VATAmountLine__VAT_Base__Control114</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control114Format">
          <DataField>VATAmountLine__VAT_Base__Control114Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control115">
          <DataField>VATAmountLine__VAT_Amount__Control115</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control115Format">
          <DataField>VATAmountLine__VAT_Amount__Control115Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control112">
          <DataField>VATAmountLine__Line_Amount__Control112</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control112Format">
          <DataField>VATAmountLine__Line_Amount__Control112Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Inv__Disc__Base_Amount__Control116">
          <DataField>VATAmountLine__Inv__Disc__Base_Amount__Control116</DataField>
        </Field>
        <Field Name="VATAmountLine__Inv__Disc__Base_Amount__Control116Format">
          <DataField>VATAmountLine__Inv__Disc__Base_Amount__Control116Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Invoice_Discount_Amount__Control130">
          <DataField>VATAmountLine__Invoice_Discount_Amount__Control130</DataField>
        </Field>
        <Field Name="VATAmountLine__Invoice_Discount_Amount__Control130Format">
          <DataField>VATAmountLine__Invoice_Discount_Amount__Control130Format</DataField>
        </Field>
        <Field Name="VATCounter_Number">
          <DataField>VATCounter_Number</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT___Caption">
          <DataField>VATAmountLine__VAT___Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control106Caption">
          <DataField>VATAmountLine__VAT_Base__Control106Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control107Caption">
          <DataField>VATAmountLine__VAT_Amount__Control107Caption</DataField>
        </Field>
        <Field Name="VAT_Amount_SpecificationCaption">
          <DataField>VAT_Amount_SpecificationCaption</DataField>
        </Field>
        <Field Name="VATAmountLine__Inv__Disc__Base_Amount__Control73Caption">
          <DataField>VATAmountLine__Inv__Disc__Base_Amount__Control73Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control72Caption">
          <DataField>VATAmountLine__Line_Amount__Control72Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__Invoice_Discount_Amount__Control74Caption">
          <DataField>VATAmountLine__Invoice_Discount_Amount__Control74Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Identifier_Caption">
          <DataField>VATAmountLine__VAT_Identifier_Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base_Caption">
          <DataField>VATAmountLine__VAT_Base_Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control110Caption">
          <DataField>VATAmountLine__VAT_Base__Control110Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control114Caption">
          <DataField>VATAmountLine__VAT_Base__Control114Caption</DataField>
        </Field>
        <Field Name="VALExchRate">
          <DataField>VALExchRate</DataField>
        </Field>
        <Field Name="VALSpecLCYHeader">
          <DataField>VALSpecLCYHeader</DataField>
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
        <Field Name="VALVATAmountLCY_Control149">
          <DataField>VALVATAmountLCY_Control149</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control149Format">
          <DataField>VALVATAmountLCY_Control149Format</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control150">
          <DataField>VALVATBaseLCY_Control150</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control150Format">
          <DataField>VALVATBaseLCY_Control150Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT____Control151">
          <DataField>VATAmountLine__VAT____Control151</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT____Control151Format">
          <DataField>VATAmountLine__VAT____Control151Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Identifier__Control152">
          <DataField>VATAmountLine__VAT_Identifier__Control152</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control156">
          <DataField>VALVATAmountLCY_Control156</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control156Format">
          <DataField>VALVATAmountLCY_Control156Format</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control157">
          <DataField>VALVATBaseLCY_Control157</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control157Format">
          <DataField>VALVATBaseLCY_Control157Format</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control159">
          <DataField>VALVATAmountLCY_Control159</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control159Format">
          <DataField>VALVATAmountLCY_Control159Format</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control160">
          <DataField>VALVATBaseLCY_Control160</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control160Format">
          <DataField>VALVATBaseLCY_Control160Format</DataField>
        </Field>
        <Field Name="VATCounterLCY_Number">
          <DataField>VATCounterLCY_Number</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control149Caption">
          <DataField>VALVATAmountLCY_Control149Caption</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control150Caption">
          <DataField>VALVATBaseLCY_Control150Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT____Control151Caption">
          <DataField>VATAmountLine__VAT____Control151Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Identifier__Control152Caption">
          <DataField>VATAmountLine__VAT_Identifier__Control152Caption</DataField>
        </Field>
        <Field Name="VALVATBaseLCYCaption">
          <DataField>VALVATBaseLCYCaption</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control157Caption">
          <DataField>VALVATBaseLCY_Control157Caption</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control160Caption">
          <DataField>VALVATBaseLCY_Control160Caption</DataField>
        </Field>
        <Field Name="PaymentTerms_Description">
          <DataField>PaymentTerms_Description</DataField>
        </Field>
        <Field Name="ShipmentMethod_Description">
          <DataField>ShipmentMethod_Description</DataField>
        </Field>
        <Field Name="Total_Number">
          <DataField>Total_Number</DataField>
        </Field>
        <Field Name="PaymentTerms_DescriptionCaption">
          <DataField>PaymentTerms_DescriptionCaption</DataField>
        </Field>
        <Field Name="ShipmentMethod_DescriptionCaption">
          <DataField>ShipmentMethod_DescriptionCaption</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___Sell_to_Customer_No__">
          <DataField>Sales_Header_Archive___Sell_to_Customer_No__</DataField>
        </Field>
        <Field Name="ShipToAddr_8_">
          <DataField>ShipToAddr_8_</DataField>
        </Field>
        <Field Name="ShipToAddr_7_">
          <DataField>ShipToAddr_7_</DataField>
        </Field>
        <Field Name="ShipToAddr_6_">
          <DataField>ShipToAddr_6_</DataField>
        </Field>
        <Field Name="ShipToAddr_5_">
          <DataField>ShipToAddr_5_</DataField>
        </Field>
        <Field Name="ShipToAddr_4_">
          <DataField>ShipToAddr_4_</DataField>
        </Field>
        <Field Name="ShipToAddr_3_">
          <DataField>ShipToAddr_3_</DataField>
        </Field>
        <Field Name="ShipToAddr_2_">
          <DataField>ShipToAddr_2_</DataField>
        </Field>
        <Field Name="ShipToAddr_1_">
          <DataField>ShipToAddr_1_</DataField>
        </Field>
        <Field Name="Total2_Number">
          <DataField>Total2_Number</DataField>
        </Field>
        <Field Name="Ship_to_AddressCaption">
          <DataField>Ship_to_AddressCaption</DataField>
        </Field>
        <Field Name="Sales_Header_Archive___Sell_to_Customer_No__Caption">
          <DataField>Sales_Header_Archive___Sell_to_Customer_No__Caption</DataField>
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
                  <Width>17.77778cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>25.50528cm</Height>
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
                                  <TablixColumn>
                                    <Width>0.3cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.3cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.31746cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="CompanyInfo_Picture">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Convert.ToBase64String(Fields!CompanyInfo_Picture.Value)</Value>
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="CompanyInfo1_Picture">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Convert.ToBase64String(Fields!CompanyInfo1_Picture.Value)</Value>
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="CompanyInfo2_Picture">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Convert.ToBase64String(Fields!CompanyInfo2_Picture.Value)</Value>
                                                    <Style>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Left>2.85714cm</Left>
                              <Height>0.31746cm</Height>
                              <Width>0.9cm</Width>
                              <ZIndex>8</ZIndex>
                            </Tablix>
                            <Tablix Name="Table_Lines">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.5873cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>4.7619cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.6cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.90476cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.95238cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.3cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.6cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.07937cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.07937cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.846cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Sales_Line___No__Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Sales_Line_Archive___No__Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___No__Caption</rd:DefaultName>
                                            <ZIndex>150</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Sales_Line__DescriptionCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Sales_Line_Archive__Description_Control63Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line__DescriptionCaption</rd:DefaultName>
                                            <ZIndex>149</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Sales_Line__QuantityCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Sales_Line_Archive__QuantityCaption.Value)</Value>
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
                                            <rd:DefaultName>Sales_Line__QuantityCaption</rd:DefaultName>
                                            <ZIndex>148</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Sales_Line___Unit_of_Measure_Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Sales_Line_Archive___Unit_of_Measure_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___Unit_of_Measure_Caption</rd:DefaultName>
                                            <ZIndex>147</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Unit_PriceCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Unit_PriceCaption.Value)</Value>
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
                                            <rd:DefaultName>Unit_PriceCaption</rd:DefaultName>
                                            <ZIndex>146</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Sales_Line___Line_Discount___Caption_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Sales_Line_Archive___Line_Discount___Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___Line_Discount___Caption_1</rd:DefaultName>
                                            <ZIndex>145</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Sales_Line___Allow_Invoice_Disc__Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Sales_Line_Archive___Allow_Invoice_Disc__Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___Allow_Invoice_Disc__Caption</rd:DefaultName>
                                            <ZIndex>144</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Sales_Line___VAT_Identifier_Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Sales_Line_Archive___VAT_Identifier_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___VAT_Identifier_Caption</rd:DefaultName>
                                            <ZIndex>143</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                            <rd:DefaultName>AmountCaption</rd:DefaultName>
                                            <ZIndex>142</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox12</rd:DefaultName>
                                            <ZIndex>141</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox3</rd:DefaultName>
                                            <ZIndex>140</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox43">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox43</rd:DefaultName>
                                            <ZIndex>139</ZIndex>
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
                                          <Textbox Name="textbox46">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Sales_Line_Archive__Description.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox46</rd:DefaultName>
                                            <ZIndex>138</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox53">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox53</rd:DefaultName>
                                            <ZIndex>137</ZIndex>
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
                                          <Textbox Name="textbox86">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox86</rd:DefaultName>
                                            <ZIndex>136</ZIndex>
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
                                          <Textbox Name="textbox87">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox87</rd:DefaultName>
                                            <ZIndex>135</ZIndex>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Sales_Line___No__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Sales_Line_Archive___No__.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___No__</rd:DefaultName>
                                            <ZIndex>134</ZIndex>
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
                                          <Textbox Name="textbox175">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Sales_Line_Archive__Description.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>133</ZIndex>
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
                                          <Textbox Name="Sales_Line__Quantity">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Sales_Line_Archive__Quantity.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Sales_Line_Archive__QuantityFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line__Quantity</rd:DefaultName>
                                            <ZIndex>132</ZIndex>
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
                                          <Textbox Name="Sales_Line___Unit_of_Measure_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Sales_Line_Archive___Unit_of_Measure_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___Unit_of_Measure_</rd:DefaultName>
                                            <ZIndex>131</ZIndex>
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
                                          <Textbox Name="Sales_Line___Unit_Price_">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Sales_Line_Archive___Unit_Price_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Sales_Line_Archive___Unit_Price_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___Unit_Price_</rd:DefaultName>
                                            <ZIndex>130</ZIndex>
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
                                          <Textbox Name="Sales_Line___Line_Discount___">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Sales_Line_Archive___Line_Discount___.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Sales_Line_Archive___Line_Discount___Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___Line_Discount___</rd:DefaultName>
                                            <ZIndex>129</ZIndex>
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
                                          <Textbox Name="AllowInvoiceDis_YesNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=IIF(Trim(Fields!SalesLineType.Value) &lt;&gt; "", Fields!AllowInvoiceDis_YesNo.Value, "")</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AllowInvoiceDis_YesNo</rd:DefaultName>
                                            <ZIndex>128</ZIndex>
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
                                          <Textbox Name="Sales_Line___VAT_Identifier_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=IIF(Trim(Fields!SalesLineType.Value) &lt;&gt; "",Fields!Sales_Line_Archive___VAT_Identifier_.Value,"")</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___VAT_Identifier_</rd:DefaultName>
                                            <ZIndex>127</ZIndex>
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
                                          <Textbox Name="Sales_Line___Line_Amount_">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Sales_Line_Archive___Line_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Sales_Line_Archive___Line_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Line___Line_Amount_</rd:DefaultName>
                                            <ZIndex>126</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox37</rd:DefaultName>
                                            <ZIndex>125</ZIndex>
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
                                          <Textbox Name="textbox42">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox42</rd:DefaultName>
                                            <ZIndex>124</ZIndex>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Line_DimensionsCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Line_DimensionsCaption.Value &amp; "    " &amp; Fields!DimText_Control82.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Line_DimensionsCaption</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox128">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox128</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
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
                                          <Textbox Name="textbox24">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox24</rd:DefaultName>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox10">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox10</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
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
                                          <Textbox Name="textbox16">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox16</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
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
                                          <Textbox Name="textbox67">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox67</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
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
                                          <Textbox Name="textbox68">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox68</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
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
                                          <Textbox Name="textbox179">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox179</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
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
                                          <Textbox Name="textbox277">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox277</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
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
                                          <Textbox Name="textbox180">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox180</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
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
                                          <Textbox Name="textbox182">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox182</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
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
                                          <Textbox Name="textbox228">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>F2</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox228</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
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
                                          <Textbox Name="textbox229">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox229</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="textbox25">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox25</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>21</ZIndex>
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
                                          <Textbox Name="textbox31">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>20</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>19</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>18</ZIndex>
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
                                          <Textbox Name="textbox40">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>17</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox41">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=SUM(Fields!Sales_Line_Archive___Line_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!Sales_Line_Archive___Line_Amount_Format.Value</Format>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>29</ZIndex>
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
                                          <Textbox Name="textbox56">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>28</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>27</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>26</ZIndex>
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
                                          <Textbox Name="textbox59">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SalesLineArch__Inv__Discount_Amount_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>25</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox60">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=-SUM(Fields!SalesLineArch__Inv__Discount_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!SalesLineArch__Inv__Discount_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>24</ZIndex>
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
                                          <Textbox Name="textbox61">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="textbox62">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox15</rd:DefaultName>
                                            <ZIndex>37</ZIndex>
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
                                          <Textbox Name="textbox174">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox174</rd:DefaultName>
                                            <ZIndex>36</ZIndex>
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
                                          <Textbox Name="textbox14">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox14</rd:DefaultName>
                                            <ZIndex>35</ZIndex>
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
                                          <Textbox Name="textbox23">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox23</rd:DefaultName>
                                            <ZIndex>34</ZIndex>
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
                                          <Textbox Name="Total">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=(Fields!TotalText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>33</ZIndex>
                                            <Style>
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
                                          <Textbox Name="VATBaseAmount">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=SUM(Fields!Sales_Line_Archive___Line_Amount_.Value)-SUM(Fields!SalesLineArch__Inv__Discount_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATBaseAmount</rd:DefaultName>
                                            <ZIndex>32</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox119</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="textbox26">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox26</rd:DefaultName>
                                            <ZIndex>30</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox17">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox17</rd:DefaultName>
                                            <ZIndex>48</ZIndex>
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
                                          <Textbox Name="textbox18">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox18</rd:DefaultName>
                                            <ZIndex>47</ZIndex>
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
                                          <Textbox Name="textbox21">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox21</rd:DefaultName>
                                            <ZIndex>46</ZIndex>
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
                                          <Textbox Name="textbox30">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox30</rd:DefaultName>
                                            <ZIndex>45</ZIndex>
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
                                          <Textbox Name="textbox32">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox32</rd:DefaultName>
                                            <ZIndex>44</ZIndex>
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
                                          <Textbox Name="textbox33">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox33</rd:DefaultName>
                                            <ZIndex>43</ZIndex>
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
                                          <Textbox Name="textbox34">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox34</rd:DefaultName>
                                            <ZIndex>42</ZIndex>
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
                                          <Textbox Name="textbox35">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox35</rd:DefaultName>
                                            <ZIndex>41</ZIndex>
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
                                          <Textbox Name="textbox36">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>F2</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox36</rd:DefaultName>
                                            <ZIndex>40</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox47</rd:DefaultName>
                                            <ZIndex>39</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="textbox48">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox48</rd:DefaultName>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox1</rd:DefaultName>
                                            <ZIndex>56</ZIndex>
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
                                          <Textbox Name="textbox20">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox20</rd:DefaultName>
                                            <ZIndex>55</ZIndex>
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
                                          <Textbox Name="textbox5">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox5</rd:DefaultName>
                                            <ZIndex>54</ZIndex>
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
                                          <Textbox Name="textbox7">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox7</rd:DefaultName>
                                            <ZIndex>53</ZIndex>
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
                                          <Textbox Name="TotalExclVAT">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=(Fields!TotalExclVATText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>52</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox13">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=SUM(Fields!Sales_Line_Archive___Line_Amount_.Value)-SUM(Fields!SalesLineArch__Inv__Discount_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>51</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox120</rd:DefaultName>
                                            <ZIndex>50</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="textbox27">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox27</rd:DefaultName>
                                            <ZIndex>49</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox19">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox19</rd:DefaultName>
                                            <ZIndex>64</ZIndex>
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
                                          <Textbox Name="textbox8">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox8</rd:DefaultName>
                                            <ZIndex>63</ZIndex>
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
                                          <Textbox Name="textbox177">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox177</rd:DefaultName>
                                            <ZIndex>62</ZIndex>
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
                                          <Textbox Name="textbox178">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox178</rd:DefaultName>
                                            <ZIndex>61</ZIndex>
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
                                          <Textbox Name="VATAmount">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=(Fields!VATAmountLine_VATAmountText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>60</ZIndex>
                                            <Style>
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
                                          <Textbox Name="VATAmount_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmount_1</rd:DefaultName>
                                            <ZIndex>59</ZIndex>
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
                                          <Textbox Name="textbox183">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox183</rd:DefaultName>
                                            <ZIndex>58</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="textbox28">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox28</rd:DefaultName>
                                            <ZIndex>57</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox63">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox63</rd:DefaultName>
                                            <ZIndex>72</ZIndex>
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
                                          <Textbox Name="textbox176">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox176</rd:DefaultName>
                                            <ZIndex>71</ZIndex>
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
                                          <Textbox Name="textbox65">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox65</rd:DefaultName>
                                            <ZIndex>70</ZIndex>
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
                                          <Textbox Name="textbox66">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox66</rd:DefaultName>
                                            <ZIndex>69</ZIndex>
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
                                          <Textbox Name="TotalInclVAT">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=(Fields!TotalInclVATText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>68</ZIndex>
                                            <Style>
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
                                          <Textbox Name="TotalAmountInclVAT">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=(SUM(Fields!Sales_Line_Archive___Line_Amount_.Value)-SUM(Fields!SalesLineArch__Inv__Discount_Amount_.Value))+Fields!VATAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!SalesLineArch__Line_Amount__SalesLineArch__Inv__Discount_Amount____VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmountInclVAT</rd:DefaultName>
                                            <ZIndex>67</ZIndex>
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
                                          <Textbox Name="textbox121">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox121</rd:DefaultName>
                                            <ZIndex>66</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="textbox29">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox29</rd:DefaultName>
                                            <ZIndex>65</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox6</rd:DefaultName>
                                            <ZIndex>83</ZIndex>
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
                                          <Textbox Name="textbox79">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox79</rd:DefaultName>
                                            <ZIndex>82</ZIndex>
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
                                          <Textbox Name="textbox80">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox80</rd:DefaultName>
                                            <ZIndex>81</ZIndex>
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
                                          <Textbox Name="textbox81">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox81</rd:DefaultName>
                                            <ZIndex>80</ZIndex>
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
                                          <Textbox Name="textbox82">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox82</rd:DefaultName>
                                            <ZIndex>79</ZIndex>
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
                                          <Textbox Name="textbox93">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox93</rd:DefaultName>
                                            <ZIndex>78</ZIndex>
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
                                          <Textbox Name="textbox94">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox94</rd:DefaultName>
                                            <ZIndex>77</ZIndex>
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
                                          <Textbox Name="textbox95">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox95</rd:DefaultName>
                                            <ZIndex>76</ZIndex>
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
                                          <Textbox Name="textbox103">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalAmountInclVATFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox103</rd:DefaultName>
                                            <ZIndex>75</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox104</rd:DefaultName>
                                            <ZIndex>74</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox105</rd:DefaultName>
                                            <ZIndex>73</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox49</rd:DefaultName>
                                            <ZIndex>91</ZIndex>
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
                                          <Textbox Name="textbox50">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox50</rd:DefaultName>
                                            <ZIndex>90</ZIndex>
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
                                          <Textbox Name="textbox51">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox51</rd:DefaultName>
                                            <ZIndex>89</ZIndex>
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
                                          <Textbox Name="textbox52">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox52</rd:DefaultName>
                                            <ZIndex>88</ZIndex>
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
                                          <Textbox Name="textbox54">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATDiscountAmountCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox54</rd:DefaultName>
                                            <ZIndex>87</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox72">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=sum(Fields!VATDiscountAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATDiscountAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox72</rd:DefaultName>
                                            <ZIndex>86</ZIndex>
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
                                          <Textbox Name="textbox73">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox73</rd:DefaultName>
                                            <ZIndex>85</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="textbox74">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox74</rd:DefaultName>
                                            <ZIndex>84</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox75">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox75</rd:DefaultName>
                                            <ZIndex>99</ZIndex>
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
                                          <Textbox Name="textbox76">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox76</rd:DefaultName>
                                            <ZIndex>98</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox77</rd:DefaultName>
                                            <ZIndex>97</ZIndex>
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
                                          <Textbox Name="textbox78">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox78</rd:DefaultName>
                                            <ZIndex>96</ZIndex>
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
                                          <Textbox Name="textbox64">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=(Fields!TotalInclVATText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>95</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox83">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalAmountInclVAT.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!TotalAmountInclVATFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox83</rd:DefaultName>
                                            <ZIndex>94</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox84</rd:DefaultName>
                                            <ZIndex>93</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox85</rd:DefaultName>
                                            <ZIndex>92</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox88</rd:DefaultName>
                                            <ZIndex>107</ZIndex>
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
                                          <Textbox Name="textbox89">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox89</rd:DefaultName>
                                            <ZIndex>106</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox90</rd:DefaultName>
                                            <ZIndex>105</ZIndex>
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
                                          <Textbox Name="textbox91">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox91</rd:DefaultName>
                                            <ZIndex>104</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox92</rd:DefaultName>
                                            <ZIndex>103</ZIndex>
                                            <Style>
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
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox96</rd:DefaultName>
                                            <ZIndex>102</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox97</rd:DefaultName>
                                            <ZIndex>101</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox98</rd:DefaultName>
                                            <ZIndex>100</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox99</rd:DefaultName>
                                            <ZIndex>115</ZIndex>
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
                                          <Textbox Name="textbox100">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox100</rd:DefaultName>
                                            <ZIndex>114</ZIndex>
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
                                          <Textbox Name="textbox101">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox101</rd:DefaultName>
                                            <ZIndex>113</ZIndex>
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
                                          <Textbox Name="textbox102">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox102</rd:DefaultName>
                                            <ZIndex>112</ZIndex>
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
                                          <Textbox Name="textbox69">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=(Fields!VATAmountLine_VATAmountText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>111</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox107">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=last(Fields!VATAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox107</rd:DefaultName>
                                            <ZIndex>110</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox108</rd:DefaultName>
                                            <ZIndex>109</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox109</rd:DefaultName>
                                            <ZIndex>108</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox110">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox110</rd:DefaultName>
                                            <ZIndex>123</ZIndex>
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
                                          <Textbox Name="textbox111">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox111</rd:DefaultName>
                                            <ZIndex>122</ZIndex>
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
                                          <Textbox Name="textbox112">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox112</rd:DefaultName>
                                            <ZIndex>121</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox113</rd:DefaultName>
                                            <ZIndex>120</ZIndex>
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
                                          <Textbox Name="textbox114">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox114</rd:DefaultName>
                                            <ZIndex>119</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox123">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=last(Fields!VATBaseAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATBaseAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox123</rd:DefaultName>
                                            <ZIndex>118</ZIndex>
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
                                          <Textbox Name="textbox124">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox124</rd:DefaultName>
                                            <ZIndex>117</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="textbox125">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox125</rd:DefaultName>
                                            <ZIndex>116</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Group Name="Table_Lines_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!Sales_Header_Archive_Document_Type.Value</GroupExpression>
                                        <GroupExpression>=Fields!Sales_Header_Archive_No_.Value</GroupExpression>
                                        <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                                        <GroupExpression>=Fields!SalesLineNo.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <SortExpressions>
                                      <SortExpression>
                                        <Value>=Fields!Sales_Header_Archive_Document_Type.Value</Value>
                                      </SortExpression>
                                      <SortExpression>
                                        <Value>=Fields!Sales_Header_Archive_No_.Value</Value>
                                      </SortExpression>
                                      <SortExpression>
                                        <Value>=Fields!OutputNo.Value</Value>
                                      </SortExpression>
                                      <SortExpression>
                                        <Value>=Fields!SalesLineNo.Value</Value>
                                      </SortExpression>
                                    </SortExpressions>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!RoundLoopBody3Visibility.Value,false,true)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=iif(Fields!RoundLoopBody4Visibility.Value,false,true)</Hidden>
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
                                            <Value>=Fields!Sales_Header_Archive_Document_Type.Value</Value>
                                          </SortExpression>
                                          <SortExpression>
                                            <Value>=Fields!Sales_Header_Archive_No_.Value</Value>
                                          </SortExpression>
                                          <SortExpression>
                                            <Value>=Fields!OutputNo.Value</Value>
                                          </SortExpression>
                                        </SortExpressions>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=(Fields!DimText_Control82.Value = "")</Hidden>
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
                                      <Hidden>=IIF(SUM(Fields!SalesLineArch__Inv__Discount_Amount_.Value)=0,TRUE,FALSE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF(SUM(Fields!SalesLineArch__Inv__Discount_Amount_.Value)=0,TRUE,FALSE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF(Last(Fields!VATAmount.Value = 0),FALSE,TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF(Last(Fields!VATAmount.Value = 0),FALSE,TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF((Last(Fields!VATAmount.Value &lt;&gt; 0)) And (Not Fields!Sales_Header_Archive___Prices_Including_VAT_.Value),FALSE,TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF((Last(Fields!VATAmount.Value &lt;&gt; 0)) And (Not Fields!Sales_Header_Archive___Prices_Including_VAT_.Value),FALSE,TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF((Last(Fields!VATAmount.Value &lt;&gt; 0)) And (Not Fields!Sales_Header_Archive___Prices_Including_VAT_.Value),FALSE,TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF((Last(Fields!VATAmount.Value &lt;&gt; 0)) And (Not Fields!Sales_Header_Archive___Prices_Including_VAT_.Value),FALSE,TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif((Fields!VATAmount.Value&lt;&gt;0 and Fields!VATDiscountAmount.Value&lt;&gt;0)and Fields!Sales_Header_Archive___Prices_Including_VAT_.Value and (Fields!VATBaseDiscountPercent.Value &lt;&gt; 0),false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!Sales_Header_Archive___Prices_Including_VAT_.Value and Fields!VATAmount.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!Sales_Header_Archive___Prices_Including_VAT_.Value and Fields!VATAmount.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!Sales_Header_Archive___Prices_Including_VAT_.Value and Fields!VATAmount.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=iif(Fields!Sales_Header_Archive___Prices_Including_VAT_.Value and Fields!VATAmount.Value&lt;&gt;0,false,true)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!SalesLineNo.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>1.26984cm</Top>
                              <Left>0.31746cm</Left>
                              <Height>9.346cm</Height>
                              <Width>17.36508cm</Width>
                              <ZIndex>7</ZIndex>
                            </Tablix>
                            <Tablix Name="table3">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.2cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.1cm</Height>
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
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>8</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Fields!CustAddr_1_.Value + Chr(177) + Fields!CustAddr_2_.Value + Chr(177)+ Fields!CustAddr_3_.Value + Chr(177)+ Fields!CustAddr_4_.Value + Chr(177)+ Fields!CustAddr_5_.Value+Chr(177)+ Fields!CustAddr_6_.Value + Chr(177)+ Fields!CustAddr_7_.Value+Chr(177)+ Fields!CustAddr_8_.Value, 1)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="CompanyAddr">
                                            <CanGrow>true</CanGrow>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>7</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Fields!CompanyAddr_1_.Value + Chr(177) + Fields!CompanyAddr_2_.Value + Chr(177)+ Fields!CompanyAddr_3_.Value + Chr(177)+ Fields!CompanyAddr_4_.Value + Chr(177)+ Fields!CompanyAddr_5_.Value + Chr(177)+ Fields!CompanyAddr_6_.Value + Chr(177) + Fields!STRSUBSTNO_Text004_CopyText_.Value + Chr(177) + Fields!PageCaption.Value + Chr(177)+ Fields!STRSUBSTNO_Text011__Sales_Header_Archive___Version_No____Sales_Header_Archive___No__of_Archived_Versions__.Value, 2)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="CompanyInfo">
                                            <CanGrow>true</CanGrow>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Fields!CompanyInfo__Phone_No__Caption.Value + Chr(177) + Fields!CompanyInfo__Phone_No__.Value + Chr(177) + Fields!CompanyInfo__Fax_No__Caption.Value + Chr(177) + Fields!CompanyInfo__Fax_No__.Value + Chr(177)+ Fields!CompanyInfo__VAT_Registration_No__Caption.Value + Chr(177)+ Fields!CompanyInfo__VAT_Registration_No__.Value + Chr(177)+ Fields!CompanyInfo__Giro_No__Caption.Value + Chr(177)+ Fields!CompanyInfo__Giro_No__.Value + Chr(177)+ Fields!CompanyInfo__Bank_Name_Caption.Value + Chr(177)+ Fields!CompanyInfo__Bank_Name_.Value + Chr(177)+ Fields!CompanyInfo__Bank_Account_No__Caption.Value + Chr(177)+ Fields!CompanyInfo__Bank_Account_No__.Value + Chr(177) + Fields!Sales_Header_Archive___Bill_to_Customer_No__Caption.Value + Chr(177) + Fields!Sales_Header_Archive___Bill_to_Customer_No__.Value + Chr(177)+ Fields!VATNoText.Value + Chr(177)+ Fields!Sales_Header_Archive___VAT_Registration_No__.Value + Chr(177)+ Fields!ReferenceText.Value + Chr(177)+ Fields!Sales_Header_Archive___Your_Reference_.Value + Chr(177)+ Fields!Sales_Header_Archive___Shipment_Date_Caption.Value + Chr(177) +  Fields!Sales_Header_Archive___Shipment_Date_.Value+ Chr(177)+ Fields!Order_No_Caption.Value + Chr(177)+ Fields!Sales_Header_Archive___No__.Value + Chr(177)+ Fields!Sales_Header_Archive___Prices_Including_VAT_Caption.Value + Chr(177)+ Fields!PricesInclVAT_YesNo.Value + Chr(177) + Fields!SalesPersonText.Value + Chr(177) + Fields!SalesPurchPerson_Name.Value + Chr(177) + Fields!FORMAT__Sales_Header_Archive___Document_Date__0_4_.Value, 3)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                          <Textbox Name="OutputNo">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!OutputNo.Value</Value>
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
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
                                          <Textbox Name="FORMAT__Sales_Header___Document_Date__0_4_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!FORMAT__Sales_Header_Archive___Document_Date__0_4_.Value)</Value>
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>4</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
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
                                          <Textbox Name="SalesPersonText">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SalesPersonText.Value</Value>
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
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
                                          <Textbox Name="SalesPurchPerson_Name">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!SalesPurchPerson_Name.Value</Value>
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
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
                                          <Textbox Name="PageCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PageCaption.Value</Value>
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
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
                                          <Textbox Name="NewPage">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.IsNewPage(Fields!Sales_Header_Archive_Document_Type.Value,Fields!Sales_Header_Archive_No_.Value,Fields!OutputNo.Value)</Value>
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Left>0.63492cm</Left>
                              <Height>0.1cm</Height>
                              <Width>1.8cm</Width>
                              <ZIndex>6</ZIndex>
                              <Visibility>
                                <Hidden>true</Hidden>
                              </Visibility>
                            </Tablix>
                            <Tablix Name="Table_VATLCY">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.1746cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.22222cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.53968cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.53968cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.95238cm</Height>
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
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VALSpecLCYHeader</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>8pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                    <Height>0.95238cm</Height>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VALExchRate</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.95238cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Identifier__Control152Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__VAT_Identifier__Control152Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLine__VAT_Identifier__Control152Caption</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
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
                                          <Textbox Name="VATAmountLine__VAT____Control151Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__VAT____Control151Caption.Value)</Value>
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
                                            <ZIndex>10</ZIndex>
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
                                          <Textbox Name="VALVATBaseLCY_Control150Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VALVATBaseLCY_Control150Caption.Value)</Value>
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
                                            <ZIndex>9</ZIndex>
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
                                          <Textbox Name="VALVATAmountLCY_Control149Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VALVATAmountLCY_Control149Caption.Value)</Value>
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
                                            <ZIndex>8</ZIndex>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Identifier__Control152">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Identifier__Control152.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLine__VAT_Identifier__Control152</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
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
                                          <Textbox Name="VATAmountLine__VAT____Control151">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT____Control151.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
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
                                          <Textbox Name="VALVATBaseLCY">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATBaseLCY.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
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
                                          <Textbox Name="VALVATAmountLCY">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATAmountLCY.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VALVATBaseLCY_Control160Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VALVATBaseLCY_Control160Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VALVATBaseLCY_Control160Caption</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
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
                                          <Textbox Name="textbox122">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
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
                                          <Textbox Name="VALVATBaseLCY_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VALVATBaseLCY.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
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
                                            <rd:DefaultName>VALVATBaseLCY_1</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
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
                                          <Textbox Name="VALVATAmountLCY_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VALVATAmountLCY.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
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
                                            <rd:DefaultName>VALVATAmountLCY_1</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!VATAmountLine__VAT_Identifier__Control152.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>13.96827cm</Top>
                              <Left>0.31746cm</Left>
                              <Height>3.85714cm</Height>
                              <Width>10.47618cm</Width>
                              <ZIndex>5</ZIndex>
                              <Visibility>
                                <Hidden>=(Fields!VATAmountLine__VAT_Identifier__Control152.Value = "")</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <FontSize>9pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="Table_VAT">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.1746cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.22222cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.53968cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.53968cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.22222cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.22222cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>1cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VAT_Amount_SpecificationCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VAT_Amount_SpecificationCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VAT_Amount_SpecificationCaption</rd:DefaultName>
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>8pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
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
                                    <Height>1cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Identifier_Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__VAT_Identifier_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLine__VAT_Identifier_Caption</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT___Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__VAT___Caption.Value)</Value>
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
                                            <rd:DefaultName>VATAmountLine__VAT___Caption</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__Line_Amount__Control72Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__Line_Amount__Control72Caption.Value)</Value>
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
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__Inv__Disc__Base_Amount__Control73Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__Inv__Disc__Base_Amount__Control73Caption.Value)</Value>
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
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__Invoice_Discount_Amount__Control74Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__Invoice_Discount_Amount__Control74Caption.Value)</Value>
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
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Base__Control106Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__VAT_Base__Control106Caption.Value)</Value>
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
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Amount__Control107Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__VAT_Amount__Control107Caption.Value)</Value>
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
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.52646cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Identifier_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Identifier_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLine__VAT_Identifier_</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
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
                                          <Textbox Name="VATAmountLine__VAT___">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT___.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT___Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLine__VAT___</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
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
                                          <Textbox Name="VATAmountLine__Line_Amount_">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__Line_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__Line_Amount__Control72Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLine__Line_Amount_</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
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
                                          <Textbox Name="VATAmountLine__Inv__Disc__Base_Amount_">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__Inv__Disc__Base_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__Inv__Disc__Base_Amount_Format.Value</Format>
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
                                          <Textbox Name="VATAmountLine__Invoice_Discount_Amount__Control74">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__Invoice_Discount_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__Invoice_Discount_Amount_Format.Value</Format>
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
                                          <Textbox Name="VATAmountLine__VAT_Base_">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Base_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Base_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLine__VAT_Base_</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
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
                                          <Textbox Name="VATAmountLine__VAT_Amount__Control107">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
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
                                    <Height>0.52646cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Base__Control114Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__VAT_Base__Control114Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLine__VAT_Base__Control114Caption</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox118</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
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
                                          <Textbox Name="VATAmountLine__Line_Amount__Control72_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLine__Line_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmountLine__Line_Amount_Format.Value</Format>
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
                                          <Textbox Name="VATAmountLine__Inv__Disc__Base_Amount_Sum">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLine__Inv__Disc__Base_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmountLine__Inv__Disc__Base_Amount_Format.Value</Format>
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
                                          <Textbox Name="VATAmountLine__Invoice_Discount_Amount__Control74_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLine__Invoice_Discount_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmountLine__Invoice_Discount_Amount_Format.Value</Format>
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
                                          <Textbox Name="VATAmountLine__VAT_Base__1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLine__VAT_Base_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmountLine__VAT_Base_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>VATAmountLine__VAT_Base__1</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
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
                                          <Textbox Name="VATAmountLine__VAT_Amount__Control107_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLine__VAT_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmountLine__VAT_Amount_Format.Value</Format>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!VATAmountLine__VAT_Identifier_.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>10.79365cm</Top>
                              <Left>0.31746cm</Left>
                              <Height>3.05292cm</Height>
                              <Width>16.92062cm</Width>
                              <ZIndex>4</ZIndex>
                              <Visibility>
                                <Hidden>=(Fields!VATAmountLine__VAT_Identifier_.Value = "")</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <FontSize>9pt</FontSize>
                              </Style>
                            </Tablix>
                            <Tablix Name="Table_ShipToAdress">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>4.12698cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>13.01587cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.95238cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Ship_to_AddressCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Ship_to_AddressCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Ship_to_AddressCaption</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>8pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.63492cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Sales_Header___Sell_to_Customer_No__Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Sales_Header_Archive___Sell_to_Customer_No__Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Header___Sell_to_Customer_No__Caption</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
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
                                          <Textbox Name="Sales_Header___Sell_to_Customer_No__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Sales_Header_Archive___Sell_to_Customer_No__.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Sales_Header___Sell_to_Customer_No__</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
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
                                    <Height>0.5cm</Height>
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
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox70</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddr_1__1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_1_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddr_1__1</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddr_2__1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_2_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddr_2__1</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddr_3__1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_3_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddr_3__1</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.52646cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddr_4_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_4_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddr_4_</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.52646cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddr_5_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_5_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddr_5_</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddr_6_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_6_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddr_6_</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddr_7_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_7_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddr_7_</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipToAddr_8_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_8_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipToAddr_8_</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                      <Hidden>=(First(Fields!Sales_Header_Archive___Sell_to_Customer_No__.Value)= First(Fields!Sales_Header_Archive___Bill_to_Customer_No__.Value))</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="Table_ShipToAdress_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=(First(Fields!Sales_Header_Archive___Sell_to_Customer_No__.Value, "Table_ShipToAdress")= First(Fields!Sales_Header_Archive___Bill_to_Customer_No__.Value, "Table_ShipToAdress"))</Hidden>
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
                                  <FilterExpression>=Fields!ShipToAddr_1_.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>19.36506cm</Top>
                              <Left>0.31746cm</Left>
                              <Width>17.14285cm</Width>
                              <ZIndex>3</ZIndex>
                              <Visibility>
                                <Hidden>=(Fields!ShipToAddr_1_.Value = "")</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="Table_PaymentShipment">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>5.25cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>11.9cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="PaymentTerms_DescriptionCaption_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PaymentTerms_DescriptionCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PaymentTerms_DescriptionCaption_1</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
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
                                          <Textbox Name="PaymentTerms_Description_1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PaymentTerms_Description.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>PaymentTerms_Description_1</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
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
                                    <Height>0.5cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShipmentMethod_DescriptionCaption_1">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipmentMethod_DescriptionCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipmentMethod_DescriptionCaption_1</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
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
                                          <Textbox Name="ShipmentMethod_Description_1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipmentMethod_Description.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>ShipmentMethod_Description_1</rd:DefaultName>
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
                                    <Group Name="Table_PaymentShipment_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
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
                                  <FilterExpression>=Fields!ShipmentMethod_Description.Value</FilterExpression>
                                  <Operator>NotEqual</Operator>
                                  <FilterValues>
                                    <FilterValue>=Fields!PaymentTerms_Description.Value</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>18.09523cm</Top>
                              <Left>0.31746cm</Left>
                              <Height>1cm</Height>
                              <Width>17.15cm</Width>
                              <ZIndex>2</ZIndex>
                              <Visibility>
                                <Hidden>=Fields!ShipmentMethod_Description.Value = Fields!PaymentTerms_Description.Value</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Textbox Name="textbox11">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=First(Fields!DimText.Value)</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>0.31746cm</Top>
                              <Left>3.67746cm</Left>
                              <Height>0.423cm</Height>
                              <Width>13.33333cm</Width>
                              <ZIndex>1</ZIndex>
                              <Visibility>
                                <Hidden>=(First(Fields!DimText.Value)= "")</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox9">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=First(Fields!Header_DimensionsCaption.Value)</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>0.31746cm</Top>
                              <Left>0.31746cm</Left>
                              <Height>0.423cm</Height>
                              <Width>3.1746cm</Width>
                              <Visibility>
                                <Hidden>=(First(Fields!DimText.Value)= "")</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <VerticalAlign>Middle</VerticalAlign>
                              </Style>
                            </Textbox>
                          </ReportItems>
                          <KeepTogether>true</KeepTogether>
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
                      <GroupExpression>=Fields!Sales_Header_Archive_Document_Type.Value</GroupExpression>
                      <GroupExpression>=Fields!Sales_Header_Archive_No_.Value</GroupExpression>
                      <GroupExpression>=Fields!STRSUBSTNO_Text011__Sales_Header_Archive___Version_No____Sales_Header_Archive___No__of_Archived_Versions__.Value</GroupExpression>
                      <GroupExpression>=Fields!OutputNo.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <SortExpressions>
                    <SortExpression>
                      <Value>=Fields!Sales_Header_Archive_Document_Type.Value</Value>
                    </SortExpression>
                    <SortExpression>
                      <Value>=Fields!Sales_Header_Archive_No_.Value</Value>
                    </SortExpression>
                    <SortExpression>
                      <Value>=Fields!OutputNo.Value</Value>
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
            <Left>0.03166in</Left>
            <Width>17.77778cm</Width>
            <Style>
              <FontSize>9pt</FontSize>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>25.50528cm</Height>
      </Body>
      <Width>17.93857cm</Width>
      <Page>
        <PageHeader>
          <Height>9.17303cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="DataPictureRight">
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
                </Paragraph>
              </Paragraphs>
              <Left>6.3492cm</Left>
              <Height>0.31746cm</Height>
              <Width>0.95238cm</Width>
              <ZIndex>53</ZIndex>
              <Visibility>
                <Hidden>=Code.SetPicture(ReportItems!CompanyInfo2_Picture.Value,3)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="DataPictureCenter">
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
                </Paragraph>
              </Paragraphs>
              <Left>5.07937cm</Left>
              <Height>0.31746cm</Height>
              <Width>0.95238cm</Width>
              <ZIndex>52</ZIndex>
              <Visibility>
                <Hidden>=Code.SetPicture(ReportItems!CompanyInfo1_Picture.Value,2)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="DataPictureLeft">
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
                </Paragraph>
              </Paragraphs>
              <Left>3.80952cm</Left>
              <Height>0.31746cm</Height>
              <Width>0.95238cm</Width>
              <ZIndex>51</ZIndex>
              <Visibility>
                <Hidden>=Code.SetPicture(ReportItems!CompanyInfo_Picture.Value,1)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="textbox71">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=code.GetData(9,2)</Value>
                      <Style />
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.71429cm</Top>
              <Left>14.28571cm</Left>
              <Height>0.423cm</Height>
              <Width>3.00889cm</Width>
              <ZIndex>50</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox2">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(27,3)</Value>
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
              <Top>6.98413cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>4.41cm</Width>
              <ZIndex>46</ZIndex>
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
                      <Value>=Code.GetGroupPageNumber(ReportItems!NewPage.Value,Globals!PageNumber)</Value>
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
              <Top>0.70713cm</Top>
              <Left>12.69841cm</Left>
              <Height>0.423cm</Height>
              <Width>1.36016cm</Width>
              <ZIndex>45</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="STRSUBSTNO_Text004_CopyText_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(7,2)</Value>
                      <Style>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.28413cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>44</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr_1_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(1,2)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>1.55313cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>43</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr_2_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(2,2)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>1.97613cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>42</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr_3_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(3,2)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>2.39913cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>41</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr_4_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4,2)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>2.82213cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>40</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Phone_No__1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(2,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>4.09113cm</Top>
              <Left>13.73857cm</Left>
              <Height>0.423cm</Height>
              <ZIndex>39</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Fax_No__1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>4.51413cm</Top>
              <Left>13.73857cm</Left>
              <Height>0.423cm</Height>
              <ZIndex>38</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__VAT_Registration_No__1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(6,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>4.93713cm</Top>
              <Left>13.73857cm</Left>
              <Height>0.423cm</Height>
              <ZIndex>37</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Giro_No__1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(8,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>5.36013cm</Top>
              <Left>13.73857cm</Left>
              <Height>0.423cm</Height>
              <ZIndex>36</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Bank_Name_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(10,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>5.78313cm</Top>
              <Left>13.73857cm</Left>
              <Height>0.423cm</Height>
              <ZIndex>35</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Bank_Account_No__1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(12,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>6.20613cm</Top>
              <Left>13.73857cm</Left>
              <Height>0.423cm</Height>
              <ZIndex>34</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___Shipment_Date_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(20,3)</Value>
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
              <Top>7.89813cm</Top>
              <Left>14.78857cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>33</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___No__1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(22,3)</Value>
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
              <Top>8.32113cm</Top>
              <Left>14.78857cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>32</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr_5_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(5,2)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>3.24513cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>31</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr_6_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(6,2)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>3.66813cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>30</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___Prices_Including_VAT_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(24,3)</Value>
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
              <Top>8.74413cm</Top>
              <Left>14.78857cm</Left>
              <Width>2.1cm</Width>
              <ZIndex>29</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PageCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(8,2)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.70713cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>1.05905cm</Width>
              <ZIndex>28</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Phone_No__Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(1,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>4.09113cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>27</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Fax_No__Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(3,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>4.51413cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>26</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__VAT_Registration_No__Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(5,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>4.93713cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>25</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Giro_No__Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(7,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>5.36013cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>24</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Bank_Name_Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(9,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>5.78313cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>23</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfo__Bank_Account_No__Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(11,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>6.20613cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>22</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___Shipment_Date_Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(19,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>7.89813cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>21</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___No__Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(21,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>8.32113cm</Top>
              <Left>11.42857cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>20</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___Prices_Including_VAT_Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(23,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>8.74413cm</Top>
              <Left>11.42857cm</Left>
              <Width>3.15cm</Width>
              <ZIndex>19</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_1_1">
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
                </Paragraph>
              </Paragraphs>
              <Top>1.55397cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>18</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_2_1">
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
                </Paragraph>
              </Paragraphs>
              <Top>1.97697cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>17</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_3_1">
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
                </Paragraph>
              </Paragraphs>
              <Top>2.39997cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>16</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_4_1">
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
                </Paragraph>
              </Paragraphs>
              <Top>2.82297cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>15</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_5_1">
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
                </Paragraph>
              </Paragraphs>
              <Top>3.24597cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>14</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_6_1">
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
                </Paragraph>
              </Paragraphs>
              <Top>3.66897cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>13</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___Bill_to_Customer_No__1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(14,3)</Value>
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
              <Top>6.98413cm</Top>
              <Left>3.67746cm</Left>
              <Height>0.423cm</Height>
              <Width>2.1cm</Width>
              <ZIndex>12</ZIndex>
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
                      <Value>=Code.GetData(15,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>7.89813cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>11</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___VAT_Registration_No__1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(16,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>7.89813cm</Top>
              <Left>3.67746cm</Left>
              <Height>0.423cm</Height>
              <Width>4.2cm</Width>
              <ZIndex>10</ZIndex>
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
                      <Value>=Code.GetData(25,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>8.32113cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>9</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SalesPurchPerson_Name1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(26,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>8.32113cm</Top>
              <Left>3.67746cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>8</ZIndex>
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
                      <Value>=Code.GetData(17,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>8.74413cm</Top>
              <Left>0.31746cm</Left>
              <Width>3.15cm</Width>
              <ZIndex>7</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___Your_Reference_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(18,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>8.74413cm</Top>
              <Left>3.67746cm</Left>
              <Width>6.3cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_7_1">
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
                </Paragraph>
              </Paragraphs>
              <Top>4.09197cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_8_1">
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
                </Paragraph>
              </Paragraphs>
              <Top>4.51497cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Sales_Header___Bill_to_Customer_No__Caption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(13,3)</Value>
                      <Style>
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>6.98413cm</Top>
              <Left>0.31746cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Image Name="CompanyInfo_Picture1">
              <Source>Database</Source>
              <Value>=Convert.FromBase64String(Code.GetPicture(1))</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Top>1cm</Top>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>2</ZIndex>
              <Visibility>
                <Hidden>=iif(Code.GetPicture(1) = "",true,false)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style />
            </Image>
            <Image Name="CompanyInfo1_Picture1">
              <Source>Database</Source>
              <Value>=Convert.FromBase64String(Code.GetPicture(2))</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Top>1cm</Top>
              <Left>6cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>1</ZIndex>
              <Visibility>
                <Hidden>=iif(Code.GetPicture(2) = "",true,false)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style />
            </Image>
            <Image Name="CompanyInfo2_Picture1">
              <Source>Database</Source>
              <Value>=Convert.FromBase64String(Code.GetPicture(3))</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Top>1cm</Top>
              <Left>12cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <Visibility>
                <Hidden>=iif(Code.GetPicture(3) = "",true,false)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style />
            </Image>
          </ReportItems>
        </PageHeader>
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.5cm</LeftMargin>
        <TopMargin>2cm</TopMargin>
        <BottomMargin>2cm</BottomMargin>
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

REM Reset Page Number:

Shared offset as Integer
Shared newPage as Object
Shared currentgroup1 as Object
Shared currentgroup2 as Object
Shared currentgroup3 as Object

Public Function GetGroupPageNumber(NewPage as Boolean, pagenumber as Integer) as Object
  If NewPage
    offset = pagenumber - 1
  End If
  Return pagenumber - offset
End Function

Public Function IsNewPage(group1 as Object, group2 as Object, group3 as Object) As Boolean
newPage = FALSE
If Not (group1 = currentgroup1)
    newPage = TRUE
    currentgroup1 = group1
    currentgroup2 = group2
    currentgroup3 = group3
     ELSE 
      If Not (group2 = currentgroup2)
        newPage = TRUE 
        currentgroup2 = group2
        currentgroup3 = group3
        ELSE
          If Not (group3 = currentgroup3)
          newPage = TRUE 
          currentgroup3 = group3
         End If
     End If
  End If
Return newPage
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
End Function

Shared PictureData1 as Object
Shared PictureData2 as Object
Shared PictureData3 as Object

Public Function GetPicture(Group as integer) as Object
if Group = 1 then
   Return PictureData1
End If

if Group = 2 then
   Return PictureData2
End If

if Group = 3 then
   Return PictureData3
End If
End Function

Public Function SetPicture(NewData as Object,Group as integer)
  If Group = 1 and NewData &gt; "" Then
      PictureData1 = NewData
  End If

  If Group = 2 and NewData &gt; "" Then
      PictureData2 = NewData
  End If

  If Group = 3 and NewData &gt; "" Then
      PictureData3 = NewData
  End If

  Return True
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Invalid</rd:ReportUnitType>
  <rd:ReportID>71886081-bb8d-469f-9350-de1d7a068a58</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

