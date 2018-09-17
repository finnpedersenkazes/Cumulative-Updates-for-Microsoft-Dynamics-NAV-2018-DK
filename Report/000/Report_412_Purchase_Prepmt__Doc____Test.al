OBJECT Report 412 Purchase Prepmt. Doc. - Test
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    CaptionML=[DAN=K�b - forudbetalingsdokument - kontrol;
               ENU=Purchase Prepmt. Doc. - Test];
    OnPreReport=BEGIN
                  PurchHeaderFilter := "Purchase Header".GETFILTERS;

                  IF DocumentType = DocumentType::Invoice THEN
                    PrepmtDocText := Text014
                  ELSE
                    PrepmtDocText := Text015;

                  GLSetup.GET;
                END;

  }
  DATASET
  {
    { 4458;    ;DataItem;                    ;
               DataItemTable=Table38;
               DataItemTableView=WHERE(Document Type=CONST(Order));
               ReqFilterHeadingML=[DAN=K�b - forudbetalingsdokument;
                                   ENU=Purchase Prepayment Document];
               OnAfterGetRecord=VAR
                                  VendLedgEntry@1001 : Record 25;
                                  FormatAddr@1000 : Codeunit 365;
                                  TableID@1003 : ARRAY [10] OF Integer;
                                  No@1002 : ARRAY [10] OF Code[20];
                                BEGIN
                                  FormatAddr.PurchHeaderPayTo(PayToAddr,"Purchase Header");
                                  FormatAddr.PurchHeaderBuyFrom(BuyFromAddr,"Purchase Header");
                                  FormatAddr.PurchHeaderShipTo(ShipToAddr,"Purchase Header");
                                  IF "Currency Code" = '' THEN BEGIN
                                    GLSetup.TESTFIELD("LCY Code");
                                    TotalText := STRSUBSTNO(Text002,GLSetup."LCY Code");
                                    TotalInclVATText := STRSUBSTNO(Text003,GLSetup."LCY Code");
                                    TotalExclVATText := STRSUBSTNO(Text004,GLSetup."LCY Code");
                                  END ELSE BEGIN
                                    TotalText := STRSUBSTNO(Text002,"Currency Code");
                                    TotalInclVATText := STRSUBSTNO(Text003,"Currency Code");
                                    TotalExclVATText := STRSUBSTNO(Text004,"Currency Code");
                                  END;

                                  IF "Document Type" <> "Document Type"::Order THEN
                                    AddError(STRSUBSTNO(Text000,FIELDCAPTION("Document Type")));

                                  IF NOT PurchPostPrepmt.CheckOpenPrepaymentLines("Purchase Header",DocumentType) THEN
                                    AddError(Text005);

                                  IF (DocumentType = DocumentType::Invoice) AND ("Prepayment Due Date" = 0D) THEN
                                    AddError(STRSUBSTNO(Text006,FIELDCAPTION("Prepayment Due Date")));

                                  CheckVend("Buy-from Vendor No.",FIELDCAPTION("Buy-from Vendor No."));
                                  CheckVend("Pay-to Vendor No.",FIELDCAPTION("Pay-to Vendor No."));

                                  CASE TRUE OF
                                    "Posting Date" = 0D:
                                      AddError(STRSUBSTNO(Text006,FIELDCAPTION("Posting Date")));
                                    "Posting Date" <> NORMALDATE("Posting Date"):
                                      AddError(STRSUBSTNO(Text009,FIELDCAPTION("Posting Date")));
                                    GenJnlCheckLine.DateNotAllowed("Posting Date"):
                                      AddError(STRSUBSTNO(Text010,FIELDCAPTION("Posting Date")));
                                  END;

                                  PurchSetup.GET;

                                  CASE DocumentType OF
                                    DocumentType::Invoice:
                                      BEGIN
                                        IF PurchSetup."Ext. Doc. No. Mandatory" AND ("Vendor Invoice No." = '') THEN
                                          AddError(STRSUBSTNO(Text006,FIELDCAPTION("Vendor Invoice No.")));
                                        IF ("Prepayment No." = '') AND ("Prepayment No. Series" = '') THEN
                                          AddError(STRSUBSTNO(Text012,FIELDCAPTION("Prepayment No. Series")));
                                        IF "Vendor Invoice No." <> '' THEN BEGIN
                                          VendLedgEntry.SETRANGE("Document Type","Document Type"::Invoice);
                                          VendLedgEntry.SETRANGE("External Document No.","Vendor Invoice No.");
                                        END;
                                      END;
                                    DocumentType::"Credit Memo":
                                      BEGIN
                                        IF PurchSetup."Ext. Doc. No. Mandatory" AND ("Vendor Cr. Memo No." = '') THEN
                                          AddError(STRSUBSTNO(Text006,FIELDCAPTION("Vendor Cr. Memo No.")));
                                        IF ("Prepmt. Cr. Memo No." = '') AND ("Prepmt. Cr. Memo No. Series" = '') THEN
                                          AddError(STRSUBSTNO(Text012,FIELDCAPTION("Prepmt. Cr. Memo No.")));
                                        IF "Vendor Cr. Memo No." <> '' THEN BEGIN
                                          VendLedgEntry.SETRANGE("Document Type","Document Type"::"Credit Memo");
                                          VendLedgEntry.SETRANGE("External Document No.","Vendor Cr. Memo No.");
                                        END;
                                      END;
                                  END;

                                  IF VendLedgEntry.HASFILTER THEN BEGIN
                                    VendLedgEntry.SETCURRENTKEY("Vendor No.");
                                    VendLedgEntry.SETRANGE("Vendor No.","Pay-to Vendor No.");
                                    IF VendLedgEntry.FINDFIRST THEN
                                      AddError(STRSUBSTNO(Text011,VendLedgEntry."Document Type",VendLedgEntry."External Document No."));
                                  END;

                                  DimSetEntry.SETRANGE("Dimension Set ID","Dimension Set ID");
                                  IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimCombErr);

                                  TableID[1] := DATABASE::Vendor;
                                  No[1] := "Pay-to Vendor No.";
                                  TableID[2] := DATABASE::Job;
                                  // No[2] := "Job No.";
                                  TableID[3] := DATABASE::"Salesperson/Purchaser";
                                  No[3] := "Purchaser Code";
                                  TableID[4] := DATABASE::Campaign;
                                  No[4] := "Campaign No.";
                                  TableID[5] := DATABASE::"Responsibility Center";
                                  No[5] := "Responsibility Center";
                                  IF NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimValuePostingErr);
                                END;

               ReqFilterFields=No. }

    { 176 ;1   ;Column  ;Purchase_Header_Document_Type;
               SourceExpr="Document Type" }

    { 177 ;1   ;Column  ;Purchase_Header_No_ ;
               SourceExpr="No." }

    { 8098;1   ;DataItem;PageCounter         ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 26  ;2   ;Column  ;CurrReport_PAGENO   ;
               SourceExpr=CurrReport.PAGENO }

    { 27  ;2   ;Column  ;FORMAT_TODAY_0_4_   ;
               SourceExpr=FORMAT(TODAY,0,4) }

    { 29  ;2   ;Column  ;COMPANYNAME         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 31  ;2   ;Column  ;STRSUBSTNO_Text001_PurchHeaderFilter_;
               SourceExpr=STRSUBSTNO(Text001,PurchHeaderFilter) }

    { 1000000000;2;Column;PurchHeaderFilter  ;
               SourceExpr=PurchHeaderFilter }

    { 32  ;2   ;Column  ;PrepmtDocText       ;
               SourceExpr=PrepmtDocText }

    { 1   ;2   ;Column  ;ShipToAddr_6_       ;
               SourceExpr=ShipToAddr[6] }

    { 2   ;2   ;Column  ;ShipToAddr_7_       ;
               SourceExpr=ShipToAddr[7] }

    { 3   ;2   ;Column  ;ShipToAddr_8_       ;
               SourceExpr=ShipToAddr[8] }

    { 4   ;2   ;Column  ;ShipToAddr_5_       ;
               SourceExpr=ShipToAddr[5] }

    { 5   ;2   ;Column  ;ShipToAddr_4_       ;
               SourceExpr=ShipToAddr[4] }

    { 6   ;2   ;Column  ;ShipToAddr_3_       ;
               SourceExpr=ShipToAddr[3] }

    { 7   ;2   ;Column  ;ShipToAddr_2_       ;
               SourceExpr=ShipToAddr[2] }

    { 8   ;2   ;Column  ;BuyFromAddr_8_      ;
               SourceExpr=BuyFromAddr[8] }

    { 9   ;2   ;Column  ;BuyFromAddr_7_      ;
               SourceExpr=BuyFromAddr[7] }

    { 10  ;2   ;Column  ;BuyFromAddr_6_      ;
               SourceExpr=BuyFromAddr[6] }

    { 11  ;2   ;Column  ;BuyFromAddr_5_      ;
               SourceExpr=BuyFromAddr[5] }

    { 12  ;2   ;Column  ;BuyFromAddr_4_      ;
               SourceExpr=BuyFromAddr[4] }

    { 13  ;2   ;Column  ;BuyFromAddr_3_      ;
               SourceExpr=BuyFromAddr[3] }

    { 14  ;2   ;Column  ;BuyFromAddr_2_      ;
               SourceExpr=BuyFromAddr[2] }

    { 15  ;2   ;Column  ;ShipToAddr_1_       ;
               SourceExpr=ShipToAddr[1] }

    { 16  ;2   ;Column  ;BuyFromAddr_1_      ;
               SourceExpr=BuyFromAddr[1] }

    { 20  ;2   ;Column  ;Purchase_Header___Sell_to_Customer_No__;
               SourceExpr="Purchase Header"."Sell-to Customer No." }

    { 21  ;2   ;Column  ;Purchase_Header___Buy_from_Vendor_No__;
               SourceExpr="Purchase Header"."Buy-from Vendor No." }

    { 23  ;2   ;Column  ;FORMAT__Purchase_Header___Document_Type____________Purchase_Header___No__;
               SourceExpr=FORMAT("Purchase Header"."Document Type") + ' ' + "Purchase Header"."No." }

    { 30  ;2   ;Column  ;PayToAddr_5_        ;
               SourceExpr=PayToAddr[5] }

    { 33  ;2   ;Column  ;PayToAddr_6_        ;
               SourceExpr=PayToAddr[6] }

    { 34  ;2   ;Column  ;PayToAddr_7_        ;
               SourceExpr=PayToAddr[7] }

    { 35  ;2   ;Column  ;PayToAddr_8_        ;
               SourceExpr=PayToAddr[8] }

    { 36  ;2   ;Column  ;PayToAddr_4_        ;
               SourceExpr=PayToAddr[4] }

    { 37  ;2   ;Column  ;PayToAddr_3_        ;
               SourceExpr=PayToAddr[3] }

    { 38  ;2   ;Column  ;PayToAddr_2_        ;
               SourceExpr=PayToAddr[2] }

    { 39  ;2   ;Column  ;PayToAddr_1_        ;
               SourceExpr=PayToAddr[1] }

    { 40  ;2   ;Column  ;Purchase_Header___Pay_to_Vendor_No__;
               SourceExpr="Purchase Header"."Pay-to Vendor No." }

    { 1000000003;2;Column;ShowPgCounter5     ;
               SourceExpr=NOT ("Purchase Header"."Pay-to Vendor No." IN ['',"Purchase Header"."Buy-from Vendor No."]) }

    { 43  ;2   ;Column  ;Purchase_Header___Purchaser_Code_;
               SourceExpr="Purchase Header"."Purchaser Code" }

    { 45  ;2   ;Column  ;Purchase_Header___Your_Reference_;
               SourceExpr="Purchase Header"."Your Reference" }

    { 47  ;2   ;Column  ;Purchase_Header___Prices_Including_VAT_;
               SourceExpr="Purchase Header"."Prices Including VAT" }

    { 49  ;2   ;Column  ;Purchase_Header___Vendor_Invoice_No__;
               SourceExpr="Purchase Header"."Vendor Invoice No." }

    { 51  ;2   ;Column  ;Purchase_Header___Shipment_Method_Code_;
               SourceExpr="Purchase Header"."Shipment Method Code" }

    { 52  ;2   ;Column  ;Purchase_Header___Payment_Method_Code_;
               SourceExpr="Purchase Header"."Payment Method Code" }

    { 53  ;2   ;Column  ;Purchase_Header___Vendor_Shipment_No__;
               SourceExpr="Purchase Header"."Vendor Shipment No." }

    { 56  ;2   ;Column  ;Purchase_Header___Vendor_Order_No__;
               SourceExpr="Purchase Header"."Vendor Order No." }

    { 64  ;2   ;Column  ;Purchase_Header___Prepayment_Due_Date_;
               SourceExpr=FORMAT("Purchase Header"."Prepayment Due Date") }

    { 65  ;2   ;Column  ;Purchase_Header___Posting_Date_;
               SourceExpr=FORMAT("Purchase Header"."Posting Date") }

    { 68  ;2   ;Column  ;Purchase_Header___Prepmt__Payment_Terms_Code_;
               SourceExpr="Purchase Header"."Prepmt. Payment Terms Code" }

    { 69  ;2   ;Column  ;Purchase_Header___Document_Date_;
               SourceExpr=FORMAT("Purchase Header"."Document Date") }

    { 71  ;2   ;Column  ;Purchase_Header___Expected_Receipt_Date_;
               SourceExpr=FORMAT("Purchase Header"."Expected Receipt Date") }

    { 73  ;2   ;Column  ;Purchase_Header___Vendor_Posting_Group_;
               SourceExpr="Purchase Header"."Vendor Posting Group" }

    { 75  ;2   ;Column  ;Purchase_Header___Order_Date_;
               SourceExpr=FORMAT("Purchase Header"."Order Date") }

    { 123 ;2   ;Column  ;Purchase_Header___Prepmt__Pmt__Discount_Date_;
               SourceExpr=FORMAT("Purchase Header"."Prepmt. Pmt. Discount Date") }

    { 125 ;2   ;Column  ;Purchase_Header___Prepmt__Payment_Discount___;
               SourceExpr="Purchase Header"."Prepmt. Payment Discount %" }

    { 1000000004;2;Column;ShowPgCounter7     ;
               SourceExpr=DocumentType = DocumentType::Invoice }

    { 1000000013;2;Column;PricesIncludingVAT1;
               SourceExpr=FORMAT("Purchase Header"."Prices Including VAT") }

    { 77  ;2   ;Column  ;Purchase_Header___Vendor_Cr__Memo_No__;
               SourceExpr="Purchase Header"."Vendor Cr. Memo No." }

    { 78  ;2   ;Column  ;Purchase_Header___Prices_Including_VAT__Control78;
               SourceExpr="Purchase Header"."Prices Including VAT" }

    { 81  ;2   ;Column  ;Purchase_Header___Posting_Date__Control81;
               SourceExpr=FORMAT("Purchase Header"."Posting Date") }

    { 83  ;2   ;Column  ;Purchase_Header___Document_Date__Control83;
               SourceExpr=FORMAT("Purchase Header"."Document Date") }

    { 87  ;2   ;Column  ;Purchase_Header___Vendor_Posting_Group__Control87;
               SourceExpr="Purchase Header"."Vendor Posting Group" }

    { 1000000005;2;Column;ShowPgCounter8     ;
               SourceExpr=DocumentType = DocumentType::"Credit Memo" }

    { 25  ;2   ;Column  ;CurrReport_PAGENOCaption;
               SourceExpr=CurrReport_PAGENOCaptionLbl }

    { 28  ;2   ;Column  ;Purchase_Prepyament_Document___TestCaption;
               SourceExpr=Purchase_Prepyament_Document___TestCaptionLbl }

    { 17  ;2   ;Column  ;Ship_toCaption      ;
               SourceExpr=Ship_toCaptionLbl }

    { 18  ;2   ;Column  ;Buy_fromCaption     ;
               SourceExpr=Buy_fromCaptionLbl }

    { 19  ;2   ;Column  ;Purchase_Header___Sell_to_Customer_No__Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Sell-to Customer No.") }

    { 22  ;2   ;Column  ;Purchase_Header___Buy_from_Vendor_No__Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Buy-from Vendor No.") }

    { 41  ;2   ;Column  ;Purchase_Header___Pay_to_Vendor_No__Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Pay-to Vendor No.") }

    { 42  ;2   ;Column  ;Pay_toCaption       ;
               SourceExpr=Pay_toCaptionLbl }

    { 44  ;2   ;Column  ;Purchase_Header___Purchaser_Code_Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Purchaser Code") }

    { 46  ;2   ;Column  ;Purchase_Header___Your_Reference_Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Your Reference") }

    { 48  ;2   ;Column  ;Purchase_Header___Prices_Including_VAT_Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Prices Including VAT") }

    { 50  ;2   ;Column  ;Purchase_Header___Vendor_Invoice_No__Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Vendor Invoice No.") }

    { 54  ;2   ;Column  ;Purchase_Header___Vendor_Shipment_No__Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Vendor Shipment No.") }

    { 57  ;2   ;Column  ;Purchase_Header___Vendor_Order_No__Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Vendor Order No.") }

    { 61  ;2   ;Column  ;Purchase_Header___Shipment_Method_Code_Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Shipment Method Code") }

    { 62  ;2   ;Column  ;Purchase_Header___Payment_Method_Code_Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Payment Method Code") }

    { 63  ;2   ;Column  ;Purchase_Header___Prepayment_Due_Date_Caption;
               SourceExpr=Purchase_Header___Prepayment_Due_Date_CaptionLbl }

    { 66  ;2   ;Column  ;Purchase_Header___Posting_Date_Caption;
               SourceExpr=Purchase_Header___Posting_Date_CaptionLbl }

    { 67  ;2   ;Column  ;Purchase_Header___Prepmt__Payment_Terms_Code_Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Prepmt. Payment Terms Code") }

    { 70  ;2   ;Column  ;Purchase_Header___Document_Date_Caption;
               SourceExpr=Purchase_Header___Document_Date_CaptionLbl }

    { 72  ;2   ;Column  ;Purchase_Header___Expected_Receipt_Date_Caption;
               SourceExpr=Purchase_Header___Expected_Receipt_Date_CaptionLbl }

    { 74  ;2   ;Column  ;Purchase_Header___Vendor_Posting_Group_Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Vendor Posting Group") }

    { 76  ;2   ;Column  ;Purchase_Header___Order_Date_Caption;
               SourceExpr=Purchase_Header___Order_Date_CaptionLbl }

    { 124 ;2   ;Column  ;Purchase_Header___Prepmt__Pmt__Discount_Date_Caption;
               SourceExpr=Purchase_Header___Prepmt__Pmt__Discount_Date_CaptionLbl }

    { 126 ;2   ;Column  ;Purchase_Header___Prepmt__Payment_Discount___Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Prepmt. Payment Discount %") }

    { 79  ;2   ;Column  ;Purchase_Header___Vendor_Cr__Memo_No__Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Vendor Cr. Memo No.") }

    { 80  ;2   ;Column  ;Purchase_Header___Prices_Including_VAT__Control78Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Prices Including VAT") }

    { 82  ;2   ;Column  ;Purchase_Header___Posting_Date__Control81Caption;
               SourceExpr=Purchase_Header___Posting_Date__Control81CaptionLbl }

    { 84  ;2   ;Column  ;Purchase_Header___Document_Date__Control83Caption;
               SourceExpr=Purchase_Header___Document_Date__Control83CaptionLbl }

    { 90  ;2   ;Column  ;Purchase_Header___Vendor_Posting_Group__Control87Caption;
               SourceExpr="Purchase Header".FIELDCAPTION("Vendor Posting Group") }

    { 2562;2   ;DataItem;HeaderDimLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowDim THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  DimText := '';
                                  Continue := FALSE;
                                  REPEAT
                                    Continue := MergeText(DimSetEntry);
                                    IF Continue THEN
                                      EXIT;
                                  UNTIL DimSetEntry.NEXT = 0;
                                END;
                                 }

    { 55  ;3   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 1000000010;3;Column;HeaderDimLoop_Number;
               SourceExpr=Number }

    { 58  ;3   ;Column  ;Header_DimensionsCaption;
               SourceExpr=Header_DimensionsCaptionLbl }

    { 3850;2   ;DataItem;HeaderErrorCounter  ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,ErrorCounter);
                             END;

               OnPostDataItem=BEGIN
                                ErrorCounter := 0;
                              END;
                               }

    { 60  ;3   ;Column  ;ErrorText_Number_   ;
               SourceExpr=ErrorText[Number] }

    { 85  ;3   ;Column  ;ErrorText_Number_Caption;
               SourceExpr=ErrorText_Number_CaptionLbl }

    { 5701;2   ;DataItem;CopyLoop            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=VAR
                               TempPurchLineToDeduct@1001 : TEMPORARY Record 39;
                             BEGIN
                               TempPurchLine.RESET;
                               TempPurchLine.DELETEALL;

                               CLEAR(PurchPostPrepmt);
                               TempVATAmountLine.DELETEALL;
                               PurchPostPrepmt.GetPurchLines("Purchase Header",DocumentType,TempPurchLine);
                               IF DocumentType = DocumentType::Invoice THEN BEGIN
                                 PurchPostPrepmt.GetPurchLinesToDeduct("Purchase Header",TempPurchLineToDeduct);
                                 IF NOT TempPurchLineToDeduct.ISEMPTY THEN
                                   PurchPostPrepmt.CalcVATAmountLines(
                                     "Purchase Header",TempPurchLineToDeduct,TempVATAmountLineDeduct,DocumentType::"Credit Memo");
                               END;
                               PurchPostPrepmt.CalcVATAmountLines("Purchase Header",TempPurchLine,TempVATAmountLine,DocumentType);
                               TempVATAmountLine.DeductVATAmountLine(TempVATAmountLineDeduct);
                               PurchPostPrepmt.UpdateVATOnLines("Purchase Header",TempPurchLine,TempVATAmountLine,DocumentType);
                               VATAmount := TempVATAmountLine.GetTotalVATAmount;
                               VATBaseAmount := TempVATAmountLine.GetTotalVATBase;
                             END;
                              }

    { 6547;3   ;DataItem;                    ;
               DataItemTable=Table39;
               DataItemTableView=SORTING(Document Type,Document No.,Line No.);
               OnPreDataItem=BEGIN
                               CurrReport.BREAK;
                             END;

               DataItemLinkReference=Purchase Header;
               DataItemLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.) }

    { 4883;3   ;DataItem;PurchLineLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnAfterGetRecord=VAR
                                  GLAcc@1003 : Record 15;
                                  CurrentErrorCount@1000 : Integer;
                                BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempPurchLine.FIND('-') THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF TempPurchLine.NEXT = 0 THEN
                                      CurrReport.BREAK;
                                  "Purchase Line" := TempPurchLine;
                                  CurrentErrorCount := ErrorCounter;
                                  WITH "Purchase Line" DO BEGIN
                                    IF ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
                                       ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                                    THEN
                                      IF NOT GenPostingSetup.GET(
                                           "Gen. Bus. Posting Group","Gen. Prod. Posting Group")
                                      THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text016,
                                            GenPostingSetup.TABLECAPTION,
                                            "Gen. Bus. Posting Group","Gen. Prod. Posting Group"));

                                    IF GenPostingSetup."Purch. Prepayments Account" = '' THEN
                                      AddError(STRSUBSTNO(Text006,GenPostingSetup.FIELDCAPTION("Purch. Prepayments Account")))
                                    ELSE
                                      IF GLAcc.GET(GenPostingSetup."Purch. Prepayments Account") THEN BEGIN
                                        IF GLAcc.Blocked THEN
                                          AddError(
                                            STRSUBSTNO(
                                              Text008,GLAcc.FIELDCAPTION(Blocked),FALSE,GLAcc.TABLECAPTION,"No."));
                                      END ELSE
                                        AddError(STRSUBSTNO(Text007,GLAcc.TABLECAPTION,GenPostingSetup."Purch. Prepayments Account"));

                                    IF ErrorCounter = CurrentErrorCount THEN
                                      IF PurchPostPrepmt.PrepmtAmount("Purchase Line",DocumentType) <> 0 THEN BEGIN
                                        PurchPostPrepmt.FillInvLineBuffer("Purchase Header","Purchase Line",TempPrepmtInvLineBuf2);
                                        TempPrepmtInvLineBuf.InsertInvLineBuffer(TempPrepmtInvLineBuf2);
                                      END;
                                  END;

                                  TempPrepmtInvLineBuf2.RESET;
                                  TempPrepmtInvLineBuf2.DELETEALL
                                END;
                                 }

    { 86  ;4   ;Column  ;Purchase_Line___Prepmt__Amt__Inv__;
               SourceExpr="Purchase Line"."Prepmt. Amt. Inv." }

    { 88  ;4   ;Column  ;Purchase_Line___Prepmt__Line_Amount_;
               SourceExpr="Purchase Line"."Prepmt. Line Amount" }

    { 89  ;4   ;Column  ;Purchase_Line___Prepayment___;
               SourceExpr="Purchase Line"."Prepayment %" }

    { 91  ;4   ;Column  ;Purchase_Line___Line_Amount_;
               SourceExpr="Purchase Line"."Line Amount" }

    { 92  ;4   ;Column  ;Purchase_Line__Quantity;
               SourceExpr="Purchase Line".Quantity }

    { 93  ;4   ;Column  ;Purchase_Line__Description;
               SourceExpr="Purchase Line".Description }

    { 94  ;4   ;Column  ;Purchase_Line___No__;
               SourceExpr="Purchase Line"."No." }

    { 95  ;4   ;Column  ;Purchase_Line__Type ;
               SourceExpr="Purchase Line".Type }

    { 1000000006;4;Column;Purchase_Line___Line_No__;
               SourceExpr="Purchase Line"."Line No." }

    { 101 ;4   ;Column  ;Purchase_Line___Prepmt__Amt__Inv__Caption;
               SourceExpr="Purchase Line".FIELDCAPTION("Prepmt. Amt. Inv.") }

    { 100 ;4   ;Column  ;Purchase_Line___Prepmt__Line_Amount_Caption;
               SourceExpr="Purchase Line".FIELDCAPTION("Prepmt. Line Amount") }

    { 99  ;4   ;Column  ;Purchase_Line___Prepayment___Caption;
               SourceExpr="Purchase Line".FIELDCAPTION("Prepayment %") }

    { 98  ;4   ;Column  ;Purchase_Line___Line_Amount_Caption;
               SourceExpr="Purchase Line".FIELDCAPTION("Line Amount") }

    { 97  ;4   ;Column  ;Purchase_Line__QuantityCaption;
               SourceExpr="Purchase Line".FIELDCAPTION(Quantity) }

    { 96  ;4   ;Column  ;Purchase_Line__DescriptionCaption;
               SourceExpr="Purchase Line".FIELDCAPTION(Description) }

    { 102 ;4   ;Column  ;Purchase_Line___No__Caption;
               SourceExpr="Purchase Line".FIELDCAPTION("No.") }

    { 103 ;4   ;Column  ;Purchase_Line__TypeCaption;
               SourceExpr="Purchase Line".FIELDCAPTION(Type) }

    { 2217;4   ;DataItem;LineErrorCounter    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,ErrorCounter);
                             END;

               OnPostDataItem=BEGIN
                                ErrorCounter := 0;
                              END;
                               }

    { 104 ;5   ;Column  ;ErrorText_Number__Control104;
               SourceExpr=ErrorText[Number] }

    { 105 ;5   ;Column  ;ErrorText_Number__Control104Caption;
               SourceExpr=ErrorText_Number__Control104CaptionLbl }

    { 9410;2   ;DataItem;Blank               ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 1849;2   ;DataItem;PrepmtLoop          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               SumPrepaymInvLineBufferAmount := 0;

                               CurrReport.CREATETOTALS("Prepayment Inv. Line Buffer".Amount);
                             END;

               OnAfterGetRecord=VAR
                                  TableID@1001 : ARRAY [10] OF Integer;
                                  No@1000 : ARRAY [10] OF Code[20];
                                BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempPrepmtInvLineBuf.FIND('-') THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF TempPrepmtInvLineBuf.NEXT = 0 THEN
                                      CurrReport.BREAK;

                                  LineDimSetEntry.SETRANGE("Dimension Set ID",TempPrepmtInvLineBuf."Dimension Set ID");

                                  "Prepayment Inv. Line Buffer" := TempPrepmtInvLineBuf;

                                  IF NOT DimMgt.CheckDimIDComb(TempPrepmtInvLineBuf."Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimCombErr);
                                  TableID[1] := DimMgt.TypeToTableID3("Purchase Line".Type::"G/L Account");
                                  No[1] := "Prepayment Inv. Line Buffer"."G/L Account No.";
                                  TableID[2] := DATABASE::Job;
                                  No[2] := "Prepayment Inv. Line Buffer"."Job No.";
                                  IF NOT DimMgt.CheckDimValuePosting(TableID,No,TempPrepmtInvLineBuf."Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimValuePostingErr);

                                  SumPrepaymInvLineBufferAmount := SumPrepaymInvLineBufferAmount + "Prepayment Inv. Line Buffer".Amount;
                                END;

               OnPostDataItem=BEGIN
                                TempPrepmtInvLineBuf.RESET;
                                TempPrepmtInvLineBuf.DELETEALL;
                              END;
                               }

    { 106 ;3   ;Column  ;Prepayment_Inv__Line_Buffer___VAT_Identifier_;
               SourceExpr="Prepayment Inv. Line Buffer"."VAT Identifier" }

    { 107 ;3   ;Column  ;Prepayment_Inv__Line_Buffer___VAT___;
               SourceExpr="Prepayment Inv. Line Buffer"."VAT %" }

    { 108 ;3   ;Column  ;Prepayment_Inv__Line_Buffer___VAT_Amount_;
               SourceExpr="Prepayment Inv. Line Buffer"."VAT Amount" }

    { 109 ;3   ;Column  ;Prepayment_Inv__Line_Buffer__Description;
               SourceExpr="Prepayment Inv. Line Buffer".Description }

    { 110 ;3   ;Column  ;Prepayment_Inv__Line_Buffer__Amount;
               SourceExpr="Prepayment Inv. Line Buffer".Amount }

    { 111 ;3   ;Column  ;Prepayment_Inv__Line_Buffer___G_L_Account_No__;
               SourceExpr="Prepayment Inv. Line Buffer"."G/L Account No." }

    { 1000000007;3;Column;PrepmtLoop_PrepmtLoop_Number;
               SourceExpr=Number }

    { 155 ;3   ;Column  ;TotalText           ;
               SourceExpr=TotalText }

    { 1000000008;3;Column;VATAmount___0      ;
               SourceExpr=VATAmount = 0 }

    { 157 ;3   ;Column  ;TotalExclVATText    ;
               SourceExpr=TotalExclVATText }

    { 158 ;3   ;Column  ;VATAmountLine_VATAmountText;
               SourceExpr=TempVATAmountLine.VATAmountText }

    { 159 ;3   ;Column  ;TotalInclVATText    ;
               SourceExpr=TotalInclVATText }

    { 160 ;3   ;Column  ;Prepayment_Inv__Line_Buffer__Amount_Control160;
               SourceExpr="Prepayment Inv. Line Buffer".Amount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 161 ;3   ;Column  ;VATAmount           ;
               SourceExpr=VATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 162 ;3   ;Column  ;Prepayment_Inv__Line_Buffer__Amount___VATAmount;
               SourceExpr="Prepayment Inv. Line Buffer".Amount + VATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 1000000009;3;Column;NOT__Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_;
               SourceExpr=NOT "Purchase Header"."Prices Including VAT" AND (VATAmount <> 0) }

    { 1000000015;3;Column;SumPrepaymInvLineBufferAmount;
               SourceExpr=SumPrepaymInvLineBufferAmount }

    { 165 ;3   ;Column  ;VATBaseAmount___VATAmount;
               SourceExpr=VATBaseAmount + VATAmount;
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 1000000014;3;Column;Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_;
               SourceExpr="Purchase Header"."Prices Including VAT" AND (VATAmount <> 0) }

    { 112 ;3   ;Column  ;Prepayment_Inv__Line_Buffer___VAT_Identifier_Caption;
               SourceExpr="Prepayment Inv. Line Buffer".FIELDCAPTION("VAT Identifier") }

    { 113 ;3   ;Column  ;Prepayment_Inv__Line_Buffer___VAT___Caption;
               SourceExpr="Prepayment Inv. Line Buffer".FIELDCAPTION("VAT %") }

    { 114 ;3   ;Column  ;Prepayment_Inv__Line_Buffer___VAT_Amount_Caption;
               SourceExpr="Prepayment Inv. Line Buffer".FIELDCAPTION("VAT Amount") }

    { 115 ;3   ;Column  ;Prepayment_Inv__Line_Buffer__DescriptionCaption;
               SourceExpr="Prepayment Inv. Line Buffer".FIELDCAPTION(Description) }

    { 116 ;3   ;Column  ;Prepayment_Inv__Line_Buffer__AmountCaption;
               SourceExpr="Prepayment Inv. Line Buffer".FIELDCAPTION(Amount) }

    { 117 ;3   ;Column  ;Prepayment_Inv__Line_Buffer___G_L_Account_No__Caption;
               SourceExpr="Prepayment Inv. Line Buffer".FIELDCAPTION("G/L Account No.") }

    { 4627;3   ;DataItem;                    ;
               DataItemTable=Table461;
               DataItemTableView=SORTING(G/L Account No.,Dimension Set ID,Job No.,Tax Area Code,Tax Liable,Tax Group Code,Invoice Rounding,Adjustment,Line No.);
               OnPreDataItem=BEGIN
                               CurrReport.BREAK;
                             END;
                              }

    { 2690;3   ;DataItem;LineDimLoop         ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowDim THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT LineDimSetEntry.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;
                                  DimText := '';
                                  Continue := FALSE;

                                  REPEAT
                                    Continue := MergeText(LineDimSetEntry);
                                    IF Continue THEN
                                      EXIT;
                                  UNTIL LineDimSetEntry.NEXT = 0;
                                END;
                                 }

    { 118 ;4   ;Column  ;DimText_Control118  ;
               SourceExpr=DimText }

    { 1000000011;4;Column;LineDimLoop_Number ;
               SourceExpr=Number }

    { 1000000025;4;Column;LineDocDim_LineNo  ;
               SourceExpr=LineDimSetEntry."Dimension Set ID" }

    { 119 ;4   ;Column  ;Header_DimensionsCaption_Control119;
               SourceExpr=Header_DimensionsCaption_Control119Lbl }

    { 1979;3   ;DataItem;PrepmtErrorCounter  ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,ErrorCounter);
                             END;

               OnPostDataItem=BEGIN
                                ErrorCounter := 0;
                              END;
                               }

    { 121 ;4   ;Column  ;ErrorText_Number__Control121;
               SourceExpr=ErrorText[Number] }

    { 122 ;4   ;Column  ;ErrorText_Number__Control121Caption;
               SourceExpr=ErrorText_Number__Control121CaptionLbl }

    { 6558;2   ;DataItem;VATCounter          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF VATAmount = 0 THEN
                                 CurrReport.BREAK;
                               SETRANGE(Number,1,TempVATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(
                                 TempVATAmountLine."VAT Base",TempVATAmountLine."VAT Amount",TempVATAmountLine."Amount Including VAT",
                                 TempVATAmountLine."Line Amount",TempVATAmountLine."Invoice Discount Amount");
                             END;

               OnAfterGetRecord=BEGIN
                                  TempVATAmountLine.GetLine(Number);
                                END;
                                 }

    { 139 ;3   ;Column  ;VATAmountLine__VAT_Amount_;
               SourceExpr=TempVATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 140 ;3   ;Column  ;VATAmountLine__VAT_Base_;
               SourceExpr=TempVATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Line"."Currency Code" }

    { 141 ;3   ;Column  ;VATAmountLine__Line_Amount_;
               SourceExpr=TempVATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 128 ;3   ;Column  ;VATAmountLine__VAT_Amount__Control128;
               SourceExpr=TempVATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 129 ;3   ;Column  ;VATAmountLine__VAT_Base__Control129;
               SourceExpr=TempVATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 130 ;3   ;Column  ;VATAmountLine__Line_Amount__Control130;
               SourceExpr=TempVATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 131 ;3   ;Column  ;VATAmountLine__VAT___;
               DecimalPlaces=0:5;
               SourceExpr=TempVATAmountLine."VAT %" }

    { 132 ;3   ;Column  ;VATAmountLine__VAT_Identifier_;
               SourceExpr=TempVATAmountLine."VAT Identifier" }

    { 151 ;3   ;Column  ;VATAmountLine__VAT_Amount__Control151;
               SourceExpr=TempVATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 152 ;3   ;Column  ;VATAmountLine__VAT_Base__Control152;
               SourceExpr=TempVATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Line"."Currency Code" }

    { 153 ;3   ;Column  ;VATAmountLine__Line_Amount__Control153;
               SourceExpr=TempVATAmountLine."Line Amount";
               AutoFormatType=1;
               AutoFormatExpr="Purchase Header"."Currency Code" }

    { 133 ;3   ;Column  ;VATAmountLine__VAT_Amount__Control128Caption;
               SourceExpr=VATAmountLine__VAT_Amount__Control128CaptionLbl }

    { 134 ;3   ;Column  ;VATAmountLine__VAT_Base__Control129Caption;
               SourceExpr=VATAmountLine__VAT_Base__Control129CaptionLbl }

    { 135 ;3   ;Column  ;VATAmountLine__Line_Amount__Control130Caption;
               SourceExpr=VATAmountLine__Line_Amount__Control130CaptionLbl }

    { 136 ;3   ;Column  ;VATAmountLine__VAT___Caption;
               SourceExpr=VATAmountLine__VAT___CaptionLbl }

    { 137 ;3   ;Column  ;VATAmountLine__VAT_Identifier_Caption;
               SourceExpr=VATAmountLine__VAT_Identifier_CaptionLbl }

    { 138 ;3   ;Column  ;VAT_Amount_SpecificationCaption;
               SourceExpr=VAT_Amount_SpecificationCaptionLbl }

    { 142 ;3   ;Column  ;ContinuedCaption    ;
               SourceExpr=ContinuedCaptionLbl }

    { 150 ;3   ;Column  ;ContinuedCaption_Control150;
               SourceExpr=ContinuedCaption_Control150Lbl }

    { 154 ;3   ;Column  ;TotalCaption        ;
               SourceExpr=TotalCaptionLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 5   ;2   ;Field     ;
                  Name=PrepaymentDocumentType;
                  CaptionML=[DAN=Forudbetalingsdokumenttype;
                             ENU=Prepayment Document Type];
                  ToolTipML=[DAN=Angiver typen af forudbetalingsdokument: fakturaen eller kreditnotaen.;
                             ENU=Specifies the type of prepayment document: invoice or credit memo.];
                  OptionCaptionML=[DAN=Faktura,Kreditnota;
                                   ENU=Invoice,Credit Memo];
                  ApplicationArea=#Prepayments;
                  SourceExpr=DocumentType }

      { 1   ;2   ;Field     ;
                  Name=ShowDimensions;
                  CaptionML=[DAN=Vis dimensioner;
                             ENU=Show Dimensions];
                  ToolTipML=[DAN=Angiver, om dimensionsoplysninger for kladdelinjerne skal medtages i rapporten.;
                             ENU=Specifies if you want dimensions information for the journal lines to be included in the report.];
                  ApplicationArea=#Dimensions;
                  SourceExpr=ShowDim }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      GLSetup@1003 : Record 98;
      PurchSetup@1022 : Record 312;
      GenPostingSetup@1038 : Record 252;
      TempPurchLine@1036 : TEMPORARY Record 39;
      TempVATAmountLine@1035 : TEMPORARY Record 290;
      TempVATAmountLineDeduct@1046 : TEMPORARY Record 290;
      TempPrepmtInvLineBuf@1041 : TEMPORARY Record 461;
      TempPrepmtInvLineBuf2@1043 : TEMPORARY Record 461;
      DimSetEntry@1025 : Record 480;
      LineDimSetEntry@1042 : Record 480;
      GenJnlCheckLine@1021 : Codeunit 11;
      PurchPostPrepmt@1004 : Codeunit 444;
      DimMgt@1026 : Codeunit 408;
      DocumentType@1015 : 'Invoice,Credit Memo,Statistic';
      VATAmount@1040 : Decimal;
      VATBaseAmount@1039 : Decimal;
      ErrorCounter@1011 : Integer;
      ErrorText@1012 : ARRAY [99] OF Text[250];
      PurchHeaderFilter@1027 : Text;
      DimText@1034 : Text[120];
      PayToAddr@1002 : ARRAY [8] OF Text[50];
      BuyFromAddr@1001 : ARRAY [8] OF Text[50];
      ShipToAddr@1000 : ARRAY [8] OF Text[50];
      PrepmtDocText@1029 : Text[50];
      TotalText@1007 : Text[50];
      TotalInclVATText@1005 : Text[50];
      TotalExclVATText@1006 : Text[50];
      Text000@1013 : TextConst 'DAN=%1 skal v�re Ordre.;ENU=%1 must be Order.';
      Text001@1028 : TextConst 'DAN=K�bsdokument: %1;ENU=Purchase Document: %1';
      Text002@1010 : TextConst 'DAN=I alt %1;ENU=Total %1';
      Text003@1009 : TextConst 'DAN=I alt %1 inkl. moms;ENU=Total %1 Incl. VAT';
      Text004@1008 : TextConst 'DAN=I alt %1 ekskl. moms;ENU=Total %1 Excl. VAT';
      Text005@1014 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';
      Text006@1016 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      Text007@1017 : TextConst 'DAN=%1 %2 findes ikke.;ENU=%1 %2 does not exist.';
      Text008@1018 : TextConst 'DAN=%1 m� ikke v�re %2 for %3 %4.;ENU=%1 must not be %2 for %3 %4.';
      Text009@1020 : TextConst 'DAN=%1 m� ikke v�re en ultimodato.;ENU=%1 must not be a closing date.';
      Text010@1019 : TextConst 'DAN=%1 er ikke inden for den tilladte bogf�ringsperiode.;ENU=%1 is not within your allowed range of posting dates.';
      Text011@1023 : TextConst 'DAN=K�b %1 %2 findes allerede for denne kreditor.;ENU=Purchase %1 %2 already exists for this vendor.';
      Text012@1024 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be entered.';
      Text014@1031 : TextConst 'DAN=Forudbetalingsfaktura;ENU=Prepayment Invoice';
      Text015@1030 : TextConst 'DAN=Forudbetalingskreditnota;ENU=Prepayment Credit Memo';
      ShowDim@1032 : Boolean;
      Continue@1033 : Boolean;
      Text016@1045 : TextConst 'DAN=%1 %2 %3 findes ikke.;ENU=%1 %2 %3 does not exist.';
      SumPrepaymInvLineBufferAmount@1000000000 : Decimal;
      CurrReport_PAGENOCaptionLbl@8565 : TextConst 'DAN=Side;ENU=Page';
      Purchase_Prepyament_Document___TestCaptionLbl@6018 : TextConst 'DAN=K�b - forudbetalingsdokument - kontrol;ENU=Purchase Prepayment Document - Test';
      Ship_toCaptionLbl@2661 : TextConst 'DAN=Leveres til;ENU=Ship-to';
      Buy_fromCaptionLbl@6701 : TextConst 'DAN=Leverand�r;ENU=Buy-from';
      Pay_toCaptionLbl@9581 : TextConst 'DAN=Faktureres til;ENU=Pay-to';
      Purchase_Header___Prepayment_Due_Date_CaptionLbl@3618 : TextConst 'DAN=Forfaldsdato for forudbetaling;ENU=Prepayment Due Date';
      Purchase_Header___Posting_Date_CaptionLbl@1882 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      Purchase_Header___Document_Date_CaptionLbl@3640 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      Purchase_Header___Expected_Receipt_Date_CaptionLbl@5706 : TextConst 'DAN=Forventet modt.dato;ENU=Expected Receipt Date';
      Purchase_Header___Order_Date_CaptionLbl@1259 : TextConst 'DAN=Ordredato;ENU=Order Date';
      Purchase_Header___Prepmt__Pmt__Discount_Date_CaptionLbl@5488 : TextConst 'DAN=Forudb. - dato for kont.rabat;ENU=Prepmt. Pmt. Discount Date';
      Purchase_Header___Posting_Date__Control81CaptionLbl@5031 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      Purchase_Header___Document_Date__Control83CaptionLbl@5158 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      Header_DimensionsCaptionLbl@4011 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      ErrorText_Number_CaptionLbl@5070 : TextConst 'DAN=Advarsel!;ENU=Warning!';
      ErrorText_Number__Control104CaptionLbl@3603 : TextConst 'DAN=Advarsel!;ENU=Warning!';
      Header_DimensionsCaption_Control119Lbl@9368 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      ErrorText_Number__Control121CaptionLbl@2487 : TextConst 'DAN=Advarsel!;ENU=Warning!';
      VATAmountLine__VAT_Amount__Control128CaptionLbl@8318 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VATAmountLine__VAT_Base__Control129CaptionLbl@1321 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATAmountLine__Line_Amount__Control130CaptionLbl@8174 : TextConst 'DAN=Linjebel�b;ENU=Line Amount';
      VATAmountLine__VAT___CaptionLbl@6736 : TextConst 'DAN=Momspct.;ENU=VAT %';
      VATAmountLine__VAT_Identifier_CaptionLbl@6385 : TextConst 'DAN=Moms-id;ENU=VAT Identifier';
      VAT_Amount_SpecificationCaptionLbl@5688 : TextConst 'DAN=Momsbel�bspecifikation;ENU=VAT Amount Specification';
      ContinuedCaptionLbl@2842 : TextConst 'DAN=Fortsat;ENU=Continued';
      ContinuedCaption_Control150Lbl@4572 : TextConst 'DAN=Fortsat;ENU=Continued';
      TotalCaptionLbl@1909 : TextConst 'DAN=I alt;ENU=Total';

    LOCAL PROCEDURE AddError@1(Text@1000 : Text[250]);
    BEGIN
      ErrorCounter := ErrorCounter + 1;
      ErrorText[ErrorCounter] := Text;
    END;

    LOCAL PROCEDURE CheckVend@3(VendNo@1000 : Code[20];FieldCaption@1001 : Text[30]);
    VAR
      Vend@1002 : Record 23;
    BEGIN
      IF VendNo = '' THEN BEGIN
        AddError(STRSUBSTNO(Text006,FieldCaption));
        EXIT;
      END;
      IF NOT Vend.GET(VendNo) THEN BEGIN
        AddError(STRSUBSTNO(Text007,Vend.TABLECAPTION,VendNo));
        EXIT;
      END;
      IF Vend."Privacy Blocked" THEN
        AddError(Vend.GetPrivacyBlockedGenericErrorText(Vend));

      IF Vend.Blocked IN [Vend.Blocked::All,Vend.Blocked::Payment] THEN
        AddError(
          STRSUBSTNO(Text008,Vend.FIELDCAPTION(Blocked),Vend.Blocked,Vend.TABLECAPTION,VendNo));
    END;

    LOCAL PROCEDURE MergeText@4(DimSetEntry@1000 : Record 480) : Boolean;
    BEGIN
      IF (STRLEN(DimText) + STRLEN(STRSUBSTNO('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")) + 2) >
         MAXSTRLEN(DimText)
      THEN
        EXIT(TRUE);

      IF DimText = '' THEN
        DimText := STRSUBSTNO('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
      ELSE
        DimText :=
          STRSUBSTNO('%1; %2',DimText,STRSUBSTNO('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code"));
      EXIT(FALSE);
    END;

    PROCEDURE InitializeRequest@2(NewDocumentType@1001 : Option;NewShowDim@1003 : Boolean);
    BEGIN
      DocumentType := NewDocumentType;
      ShowDim := NewShowDim;
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
      <rd:DataSourceID>8021b2b3-4d18-4743-a555-af646c37e390</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="Purchase_Header_Document_Type">
          <DataField>Purchase_Header_Document_Type</DataField>
        </Field>
        <Field Name="Purchase_Header_No_">
          <DataField>Purchase_Header_No_</DataField>
        </Field>
        <Field Name="CurrReport_PAGENO">
          <DataField>CurrReport_PAGENO</DataField>
        </Field>
        <Field Name="FORMAT_TODAY_0_4_">
          <DataField>FORMAT_TODAY_0_4_</DataField>
        </Field>
        <Field Name="COMPANYNAME">
          <DataField>COMPANYNAME</DataField>
        </Field>
        <Field Name="STRSUBSTNO_Text001_PurchHeaderFilter_">
          <DataField>STRSUBSTNO_Text001_PurchHeaderFilter_</DataField>
        </Field>
        <Field Name="PurchHeaderFilter">
          <DataField>PurchHeaderFilter</DataField>
        </Field>
        <Field Name="PrepmtDocText">
          <DataField>PrepmtDocText</DataField>
        </Field>
        <Field Name="ShipToAddr_6_">
          <DataField>ShipToAddr_6_</DataField>
        </Field>
        <Field Name="ShipToAddr_7_">
          <DataField>ShipToAddr_7_</DataField>
        </Field>
        <Field Name="ShipToAddr_8_">
          <DataField>ShipToAddr_8_</DataField>
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
        <Field Name="BuyFromAddr_8_">
          <DataField>BuyFromAddr_8_</DataField>
        </Field>
        <Field Name="BuyFromAddr_7_">
          <DataField>BuyFromAddr_7_</DataField>
        </Field>
        <Field Name="BuyFromAddr_6_">
          <DataField>BuyFromAddr_6_</DataField>
        </Field>
        <Field Name="BuyFromAddr_5_">
          <DataField>BuyFromAddr_5_</DataField>
        </Field>
        <Field Name="BuyFromAddr_4_">
          <DataField>BuyFromAddr_4_</DataField>
        </Field>
        <Field Name="BuyFromAddr_3_">
          <DataField>BuyFromAddr_3_</DataField>
        </Field>
        <Field Name="BuyFromAddr_2_">
          <DataField>BuyFromAddr_2_</DataField>
        </Field>
        <Field Name="ShipToAddr_1_">
          <DataField>ShipToAddr_1_</DataField>
        </Field>
        <Field Name="BuyFromAddr_1_">
          <DataField>BuyFromAddr_1_</DataField>
        </Field>
        <Field Name="Purchase_Header___Sell_to_Customer_No__">
          <DataField>Purchase_Header___Sell_to_Customer_No__</DataField>
        </Field>
        <Field Name="Purchase_Header___Buy_from_Vendor_No__">
          <DataField>Purchase_Header___Buy_from_Vendor_No__</DataField>
        </Field>
        <Field Name="FORMAT__Purchase_Header___Document_Type____________Purchase_Header___No__">
          <DataField>FORMAT__Purchase_Header___Document_Type____________Purchase_Header___No__</DataField>
        </Field>
        <Field Name="PayToAddr_5_">
          <DataField>PayToAddr_5_</DataField>
        </Field>
        <Field Name="PayToAddr_6_">
          <DataField>PayToAddr_6_</DataField>
        </Field>
        <Field Name="PayToAddr_7_">
          <DataField>PayToAddr_7_</DataField>
        </Field>
        <Field Name="PayToAddr_8_">
          <DataField>PayToAddr_8_</DataField>
        </Field>
        <Field Name="PayToAddr_4_">
          <DataField>PayToAddr_4_</DataField>
        </Field>
        <Field Name="PayToAddr_3_">
          <DataField>PayToAddr_3_</DataField>
        </Field>
        <Field Name="PayToAddr_2_">
          <DataField>PayToAddr_2_</DataField>
        </Field>
        <Field Name="PayToAddr_1_">
          <DataField>PayToAddr_1_</DataField>
        </Field>
        <Field Name="Purchase_Header___Pay_to_Vendor_No__">
          <DataField>Purchase_Header___Pay_to_Vendor_No__</DataField>
        </Field>
        <Field Name="ShowPgCounter5">
          <DataField>ShowPgCounter5</DataField>
        </Field>
        <Field Name="Purchase_Header___Purchaser_Code_">
          <DataField>Purchase_Header___Purchaser_Code_</DataField>
        </Field>
        <Field Name="Purchase_Header___Your_Reference_">
          <DataField>Purchase_Header___Your_Reference_</DataField>
        </Field>
        <Field Name="Purchase_Header___Prices_Including_VAT_">
          <DataField>Purchase_Header___Prices_Including_VAT_</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Invoice_No__">
          <DataField>Purchase_Header___Vendor_Invoice_No__</DataField>
        </Field>
        <Field Name="Purchase_Header___Shipment_Method_Code_">
          <DataField>Purchase_Header___Shipment_Method_Code_</DataField>
        </Field>
        <Field Name="Purchase_Header___Payment_Method_Code_">
          <DataField>Purchase_Header___Payment_Method_Code_</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Shipment_No__">
          <DataField>Purchase_Header___Vendor_Shipment_No__</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Order_No__">
          <DataField>Purchase_Header___Vendor_Order_No__</DataField>
        </Field>
        <Field Name="Purchase_Header___Prepayment_Due_Date_">
          <DataField>Purchase_Header___Prepayment_Due_Date_</DataField>
        </Field>
        <Field Name="Purchase_Header___Posting_Date_">
          <DataField>Purchase_Header___Posting_Date_</DataField>
        </Field>
        <Field Name="Purchase_Header___Prepmt__Payment_Terms_Code_">
          <DataField>Purchase_Header___Prepmt__Payment_Terms_Code_</DataField>
        </Field>
        <Field Name="Purchase_Header___Document_Date_">
          <DataField>Purchase_Header___Document_Date_</DataField>
        </Field>
        <Field Name="Purchase_Header___Expected_Receipt_Date_">
          <DataField>Purchase_Header___Expected_Receipt_Date_</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Posting_Group_">
          <DataField>Purchase_Header___Vendor_Posting_Group_</DataField>
        </Field>
        <Field Name="Purchase_Header___Order_Date_">
          <DataField>Purchase_Header___Order_Date_</DataField>
        </Field>
        <Field Name="Purchase_Header___Prepmt__Pmt__Discount_Date_">
          <DataField>Purchase_Header___Prepmt__Pmt__Discount_Date_</DataField>
        </Field>
        <Field Name="Purchase_Header___Prepmt__Payment_Discount___">
          <DataField>Purchase_Header___Prepmt__Payment_Discount___</DataField>
        </Field>
        <Field Name="Purchase_Header___Prepmt__Payment_Discount___Format">
          <DataField>Purchase_Header___Prepmt__Payment_Discount___Format</DataField>
        </Field>
        <Field Name="ShowPgCounter7">
          <DataField>ShowPgCounter7</DataField>
        </Field>
        <Field Name="PricesIncludingVAT1">
          <DataField>PricesIncludingVAT1</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Cr__Memo_No__">
          <DataField>Purchase_Header___Vendor_Cr__Memo_No__</DataField>
        </Field>
        <Field Name="Purchase_Header___Prices_Including_VAT__Control78">
          <DataField>Purchase_Header___Prices_Including_VAT__Control78</DataField>
        </Field>
        <Field Name="Purchase_Header___Posting_Date__Control81">
          <DataField>Purchase_Header___Posting_Date__Control81</DataField>
        </Field>
        <Field Name="Purchase_Header___Document_Date__Control83">
          <DataField>Purchase_Header___Document_Date__Control83</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Posting_Group__Control87">
          <DataField>Purchase_Header___Vendor_Posting_Group__Control87</DataField>
        </Field>
        <Field Name="ShowPgCounter8">
          <DataField>ShowPgCounter8</DataField>
        </Field>
        <Field Name="CurrReport_PAGENOCaption">
          <DataField>CurrReport_PAGENOCaption</DataField>
        </Field>
        <Field Name="Purchase_Prepyament_Document___TestCaption">
          <DataField>Purchase_Prepyament_Document___TestCaption</DataField>
        </Field>
        <Field Name="Ship_toCaption">
          <DataField>Ship_toCaption</DataField>
        </Field>
        <Field Name="Buy_fromCaption">
          <DataField>Buy_fromCaption</DataField>
        </Field>
        <Field Name="Purchase_Header___Sell_to_Customer_No__Caption">
          <DataField>Purchase_Header___Sell_to_Customer_No__Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Buy_from_Vendor_No__Caption">
          <DataField>Purchase_Header___Buy_from_Vendor_No__Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Pay_to_Vendor_No__Caption">
          <DataField>Purchase_Header___Pay_to_Vendor_No__Caption</DataField>
        </Field>
        <Field Name="Pay_toCaption">
          <DataField>Pay_toCaption</DataField>
        </Field>
        <Field Name="Purchase_Header___Purchaser_Code_Caption">
          <DataField>Purchase_Header___Purchaser_Code_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Your_Reference_Caption">
          <DataField>Purchase_Header___Your_Reference_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Prices_Including_VAT_Caption">
          <DataField>Purchase_Header___Prices_Including_VAT_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Invoice_No__Caption">
          <DataField>Purchase_Header___Vendor_Invoice_No__Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Shipment_No__Caption">
          <DataField>Purchase_Header___Vendor_Shipment_No__Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Order_No__Caption">
          <DataField>Purchase_Header___Vendor_Order_No__Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Shipment_Method_Code_Caption">
          <DataField>Purchase_Header___Shipment_Method_Code_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Payment_Method_Code_Caption">
          <DataField>Purchase_Header___Payment_Method_Code_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Prepayment_Due_Date_Caption">
          <DataField>Purchase_Header___Prepayment_Due_Date_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Posting_Date_Caption">
          <DataField>Purchase_Header___Posting_Date_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Prepmt__Payment_Terms_Code_Caption">
          <DataField>Purchase_Header___Prepmt__Payment_Terms_Code_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Document_Date_Caption">
          <DataField>Purchase_Header___Document_Date_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Expected_Receipt_Date_Caption">
          <DataField>Purchase_Header___Expected_Receipt_Date_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Posting_Group_Caption">
          <DataField>Purchase_Header___Vendor_Posting_Group_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Order_Date_Caption">
          <DataField>Purchase_Header___Order_Date_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Prepmt__Pmt__Discount_Date_Caption">
          <DataField>Purchase_Header___Prepmt__Pmt__Discount_Date_Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Prepmt__Payment_Discount___Caption">
          <DataField>Purchase_Header___Prepmt__Payment_Discount___Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Cr__Memo_No__Caption">
          <DataField>Purchase_Header___Vendor_Cr__Memo_No__Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Prices_Including_VAT__Control78Caption">
          <DataField>Purchase_Header___Prices_Including_VAT__Control78Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Posting_Date__Control81Caption">
          <DataField>Purchase_Header___Posting_Date__Control81Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Document_Date__Control83Caption">
          <DataField>Purchase_Header___Document_Date__Control83Caption</DataField>
        </Field>
        <Field Name="Purchase_Header___Vendor_Posting_Group__Control87Caption">
          <DataField>Purchase_Header___Vendor_Posting_Group__Control87Caption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="HeaderDimLoop_Number">
          <DataField>HeaderDimLoop_Number</DataField>
        </Field>
        <Field Name="Header_DimensionsCaption">
          <DataField>Header_DimensionsCaption</DataField>
        </Field>
        <Field Name="ErrorText_Number_">
          <DataField>ErrorText_Number_</DataField>
        </Field>
        <Field Name="ErrorText_Number_Caption">
          <DataField>ErrorText_Number_Caption</DataField>
        </Field>
        <Field Name="Purchase_Line___Prepmt__Amt__Inv__">
          <DataField>Purchase_Line___Prepmt__Amt__Inv__</DataField>
        </Field>
        <Field Name="Purchase_Line___Prepmt__Amt__Inv__Format">
          <DataField>Purchase_Line___Prepmt__Amt__Inv__Format</DataField>
        </Field>
        <Field Name="Purchase_Line___Prepmt__Line_Amount_">
          <DataField>Purchase_Line___Prepmt__Line_Amount_</DataField>
        </Field>
        <Field Name="Purchase_Line___Prepmt__Line_Amount_Format">
          <DataField>Purchase_Line___Prepmt__Line_Amount_Format</DataField>
        </Field>
        <Field Name="Purchase_Line___Prepayment___">
          <DataField>Purchase_Line___Prepayment___</DataField>
        </Field>
        <Field Name="Purchase_Line___Prepayment___Format">
          <DataField>Purchase_Line___Prepayment___Format</DataField>
        </Field>
        <Field Name="Purchase_Line___Line_Amount_">
          <DataField>Purchase_Line___Line_Amount_</DataField>
        </Field>
        <Field Name="Purchase_Line___Line_Amount_Format">
          <DataField>Purchase_Line___Line_Amount_Format</DataField>
        </Field>
        <Field Name="Purchase_Line__Quantity">
          <DataField>Purchase_Line__Quantity</DataField>
        </Field>
        <Field Name="Purchase_Line__QuantityFormat">
          <DataField>Purchase_Line__QuantityFormat</DataField>
        </Field>
        <Field Name="Purchase_Line__Description">
          <DataField>Purchase_Line__Description</DataField>
        </Field>
        <Field Name="Purchase_Line___No__">
          <DataField>Purchase_Line___No__</DataField>
        </Field>
        <Field Name="Purchase_Line__Type">
          <DataField>Purchase_Line__Type</DataField>
        </Field>
        <Field Name="Purchase_Line___Line_No__">
          <DataField>Purchase_Line___Line_No__</DataField>
        </Field>
        <Field Name="Purchase_Line___Prepmt__Amt__Inv__Caption">
          <DataField>Purchase_Line___Prepmt__Amt__Inv__Caption</DataField>
        </Field>
        <Field Name="Purchase_Line___Prepmt__Line_Amount_Caption">
          <DataField>Purchase_Line___Prepmt__Line_Amount_Caption</DataField>
        </Field>
        <Field Name="Purchase_Line___Prepayment___Caption">
          <DataField>Purchase_Line___Prepayment___Caption</DataField>
        </Field>
        <Field Name="Purchase_Line___Line_Amount_Caption">
          <DataField>Purchase_Line___Line_Amount_Caption</DataField>
        </Field>
        <Field Name="Purchase_Line__QuantityCaption">
          <DataField>Purchase_Line__QuantityCaption</DataField>
        </Field>
        <Field Name="Purchase_Line__DescriptionCaption">
          <DataField>Purchase_Line__DescriptionCaption</DataField>
        </Field>
        <Field Name="Purchase_Line___No__Caption">
          <DataField>Purchase_Line___No__Caption</DataField>
        </Field>
        <Field Name="Purchase_Line__TypeCaption">
          <DataField>Purchase_Line__TypeCaption</DataField>
        </Field>
        <Field Name="ErrorText_Number__Control104">
          <DataField>ErrorText_Number__Control104</DataField>
        </Field>
        <Field Name="ErrorText_Number__Control104Caption">
          <DataField>ErrorText_Number__Control104Caption</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___VAT_Identifier_">
          <DataField>Prepayment_Inv__Line_Buffer___VAT_Identifier_</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___VAT___">
          <DataField>Prepayment_Inv__Line_Buffer___VAT___</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___VAT___Format">
          <DataField>Prepayment_Inv__Line_Buffer___VAT___Format</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___VAT_Amount_">
          <DataField>Prepayment_Inv__Line_Buffer___VAT_Amount_</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___VAT_Amount_Format">
          <DataField>Prepayment_Inv__Line_Buffer___VAT_Amount_Format</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer__Description">
          <DataField>Prepayment_Inv__Line_Buffer__Description</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer__Amount">
          <DataField>Prepayment_Inv__Line_Buffer__Amount</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer__AmountFormat">
          <DataField>Prepayment_Inv__Line_Buffer__AmountFormat</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___G_L_Account_No__">
          <DataField>Prepayment_Inv__Line_Buffer___G_L_Account_No__</DataField>
        </Field>
        <Field Name="PrepmtLoop_PrepmtLoop_Number">
          <DataField>PrepmtLoop_PrepmtLoop_Number</DataField>
        </Field>
        <Field Name="TotalText">
          <DataField>TotalText</DataField>
        </Field>
        <Field Name="VATAmount___0">
          <DataField>VATAmount___0</DataField>
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
        <Field Name="Prepayment_Inv__Line_Buffer__Amount_Control160">
          <DataField>Prepayment_Inv__Line_Buffer__Amount_Control160</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer__Amount_Control160Format">
          <DataField>Prepayment_Inv__Line_Buffer__Amount_Control160Format</DataField>
        </Field>
        <Field Name="VATAmount">
          <DataField>VATAmount</DataField>
        </Field>
        <Field Name="VATAmountFormat">
          <DataField>VATAmountFormat</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer__Amount___VATAmount">
          <DataField>Prepayment_Inv__Line_Buffer__Amount___VATAmount</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer__Amount___VATAmountFormat">
          <DataField>Prepayment_Inv__Line_Buffer__Amount___VATAmountFormat</DataField>
        </Field>
        <Field Name="NOT__Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_">
          <DataField>NOT__Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_</DataField>
        </Field>
        <Field Name="SumPrepaymInvLineBufferAmount">
          <DataField>SumPrepaymInvLineBufferAmount</DataField>
        </Field>
        <Field Name="SumPrepaymInvLineBufferAmountFormat">
          <DataField>SumPrepaymInvLineBufferAmountFormat</DataField>
        </Field>
        <Field Name="VATBaseAmount___VATAmount">
          <DataField>VATBaseAmount___VATAmount</DataField>
        </Field>
        <Field Name="VATBaseAmount___VATAmountFormat">
          <DataField>VATBaseAmount___VATAmountFormat</DataField>
        </Field>
        <Field Name="Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_">
          <DataField>Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___VAT_Identifier_Caption">
          <DataField>Prepayment_Inv__Line_Buffer___VAT_Identifier_Caption</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___VAT___Caption">
          <DataField>Prepayment_Inv__Line_Buffer___VAT___Caption</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___VAT_Amount_Caption">
          <DataField>Prepayment_Inv__Line_Buffer___VAT_Amount_Caption</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer__DescriptionCaption">
          <DataField>Prepayment_Inv__Line_Buffer__DescriptionCaption</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer__AmountCaption">
          <DataField>Prepayment_Inv__Line_Buffer__AmountCaption</DataField>
        </Field>
        <Field Name="Prepayment_Inv__Line_Buffer___G_L_Account_No__Caption">
          <DataField>Prepayment_Inv__Line_Buffer___G_L_Account_No__Caption</DataField>
        </Field>
        <Field Name="DimText_Control118">
          <DataField>DimText_Control118</DataField>
        </Field>
        <Field Name="LineDimLoop_Number">
          <DataField>LineDimLoop_Number</DataField>
        </Field>
        <Field Name="LineDocDim_LineNo">
          <DataField>LineDocDim_LineNo</DataField>
        </Field>
        <Field Name="Header_DimensionsCaption_Control119">
          <DataField>Header_DimensionsCaption_Control119</DataField>
        </Field>
        <Field Name="ErrorText_Number__Control121">
          <DataField>ErrorText_Number__Control121</DataField>
        </Field>
        <Field Name="ErrorText_Number__Control121Caption">
          <DataField>ErrorText_Number__Control121Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount_">
          <DataField>VATAmountLine__VAT_Amount_</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount_Format">
          <DataField>VATAmountLine__VAT_Amount_Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base_">
          <DataField>VATAmountLine__VAT_Base_</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base_Format">
          <DataField>VATAmountLine__VAT_Base_Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount_">
          <DataField>VATAmountLine__Line_Amount_</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount_Format">
          <DataField>VATAmountLine__Line_Amount_Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control128">
          <DataField>VATAmountLine__VAT_Amount__Control128</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control128Format">
          <DataField>VATAmountLine__VAT_Amount__Control128Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control129">
          <DataField>VATAmountLine__VAT_Base__Control129</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control129Format">
          <DataField>VATAmountLine__VAT_Base__Control129Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control130">
          <DataField>VATAmountLine__Line_Amount__Control130</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control130Format">
          <DataField>VATAmountLine__Line_Amount__Control130Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT___">
          <DataField>VATAmountLine__VAT___</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT___Format">
          <DataField>VATAmountLine__VAT___Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Identifier_">
          <DataField>VATAmountLine__VAT_Identifier_</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control151">
          <DataField>VATAmountLine__VAT_Amount__Control151</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control151Format">
          <DataField>VATAmountLine__VAT_Amount__Control151Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control152">
          <DataField>VATAmountLine__VAT_Base__Control152</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control152Format">
          <DataField>VATAmountLine__VAT_Base__Control152Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control153">
          <DataField>VATAmountLine__Line_Amount__Control153</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control153Format">
          <DataField>VATAmountLine__Line_Amount__Control153Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control128Caption">
          <DataField>VATAmountLine__VAT_Amount__Control128Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control129Caption">
          <DataField>VATAmountLine__VAT_Base__Control129Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__Line_Amount__Control130Caption">
          <DataField>VATAmountLine__Line_Amount__Control130Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT___Caption">
          <DataField>VATAmountLine__VAT___Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Identifier_Caption">
          <DataField>VATAmountLine__VAT_Identifier_Caption</DataField>
        </Field>
        <Field Name="VAT_Amount_SpecificationCaption">
          <DataField>VAT_Amount_SpecificationCaption</DataField>
        </Field>
        <Field Name="ContinuedCaption">
          <DataField>ContinuedCaption</DataField>
        </Field>
        <Field Name="ContinuedCaption_Control150">
          <DataField>ContinuedCaption_Control150</DataField>
        </Field>
        <Field Name="TotalCaption">
          <DataField>TotalCaption</DataField>
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
          <Tablix Name="table5">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>18.15cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox28">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!STRSUBSTNO_Text001_PurchHeaderFilter_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox28</rd:DefaultName>
                          <Style>
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
                  <Visibility>
                    <Hidden>= IIF(Fields!PurchHeaderFilter.Value = "", TRUE, FALSE)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <Height>0.423cm</Height>
            <Width>18.15cm</Width>
            <ZIndex>1</ZIndex>
          </Tablix>
          <Tablix Name="list1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>18.5cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>31.726cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="table7">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>16.65cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox788">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorText_Number_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox788</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox789">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorText_Number_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox789</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                    <Group Name="table7_Details_Group">
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
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!ErrorText_Number_.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>19.035cm</Top>
                              <Height>0.423cm</Height>
                              <Width>18.15cm</Width>
                              <ZIndex>5</ZIndex>
                              <Visibility>
                                <Hidden>=IIf(Fields!ErrorText_Number_.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="table6">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.45cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>14.7cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox728">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Header_DimensionsCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox728</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!HeaderDimLoop_Number.Value = 1,False,True)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox729">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox729</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                    <Group Name="table6_Details_Group">
                                      <DataElementName>Detail</DataElementName>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!HeaderDimLoop_Number.Value &gt; 0,False,True)</Hidden>
                                        </Visibility>
                                      </TablixMember>
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!HeaderDimLoop_Number.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>18.612cm</Top>
                              <Height>0.423cm</Height>
                              <Width>18.15cm</Width>
                              <ZIndex>4</ZIndex>
                              <Visibility>
                                <Hidden>=IIf(Fields!HeaderDimLoop_Number.Value &gt; 0,False,True)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="Table1">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.65cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.95cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.95cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.95cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.15cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.15cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.15cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.15cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.15cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.846cm</Height>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>35</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                          <Textbox Name="textbox57">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox57</rd:DefaultName>
                                            <ZIndex>34</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox29</rd:DefaultName>
                                            <ZIndex>33</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox35</rd:DefaultName>
                                            <ZIndex>32</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox68</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0cm</PaddingLeft>
                                              <PaddingRight>0.075cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                            <rd:DefaultName>textbox31</rd:DefaultName>
                                            <ZIndex>30</ZIndex>
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
                                    <Height>1.269cm</Height>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__Line_Amount__Control130Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__Line_Amount__Control130Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Base__Control129Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__VAT_Base__Control129Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Amount__Control128Caption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!VATAmountLine__VAT_Amount__Control128Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                            <rd:DefaultName>textbox62</rd:DefaultName>
                                            <ZIndex>24</ZIndex>
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
                                          <Textbox Name="textbox54">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox54</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox38</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox69</rd:DefaultName>
                                            <ZIndex>21</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox87</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
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
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT___Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__Line_Amount__Control130">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__Line_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__Line_Amount__Control130Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Base__Control129">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Base_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Base__Control129Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Amount__Control128">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Amount__Control128Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>= Last(Fields!ContinuedCaption_Control150.Value, "Table1")</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox63</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
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
                                                    <Value>=RunningValue(Fields!VATAmountLine__Line_Amount_.Value,SUM,nothing)-Fields!VATAmountLine__Line_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Amount__Control128Format.Value</Format>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox59</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>=RunningValue(Fields!VATAmountLine__VAT_Base_.Value,SUM,nothing)-Fields!VATAmountLine__VAT_Base_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Amount__Control128Format.Value</Format>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox48</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox70">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=RunningValue(Fields!VATAmountLine__VAT_Amount_.Value,SUM,nothing)-Fields!VATAmountLine__VAT_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Amount__Control128Format.Value</Format>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox70</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1">
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
                                            <rd:DefaultName>textbox1</rd:DefaultName>
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
                                    <Height>0.846cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TotalCaption">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!TotalCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="TextBox116">
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
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__Line_Amount__Control153">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLine__Line_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!VATAmountLine__Line_Amount__Control153Format.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Base__Control152">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLine__VAT_Base_.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!VATAmountLine__VAT_Base__Control152Format.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="VATAmountLine__VAT_Amount__Control151">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLine__VAT_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!VATAmountLine__VAT_Amount__Control151Format.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox67">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!VATAmountLine__VAT_Amount__Control151Format.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox67</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox60">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!VATAmountLine__VAT_Amount__Control151Format.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox60</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!VATAmountLine__VAT_Amount__Control151Format.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox53</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!VATAmountLine__VAT_Amount__Control151Format.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox71</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ShowPageFooter">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=ReportItems!TotalCaption.Value &lt;&gt; ""</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Amount__Control128Format.Value</Format>
                                                      <Color>Red</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>10</ZIndex>
                                            <Visibility>
                                              <Hidden>true</Hidden>
                                            </Visibility>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingRight>0cm</PaddingRight>
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
                                    <Group Name="Table1_Details_Group">
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
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!VATAmountLine__VAT_Identifier_.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>28.342cm</Top>
                              <Width>9.75cm</Width>
                              <ZIndex>3</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!VAT_Amount_SpecificationCaption.Value &lt;&gt; "", FALSE, TRUE)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="table4">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.95cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.7cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.95cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.95cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.05cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.65cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.95cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.45cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>1.26923cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox278">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer___G_L_Account_No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox278</rd:DefaultName>
                                            <ZIndex>91</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox279">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer__DescriptionCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox279</rd:DefaultName>
                                            <ZIndex>90</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox285">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer__AmountCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox285</rd:DefaultName>
                                            <ZIndex>89</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox286">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer___VAT_Amount_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox286</rd:DefaultName>
                                            <ZIndex>88</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox294">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer___VAT___Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox294</rd:DefaultName>
                                            <ZIndex>87</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox299">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer___VAT_Identifier_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox299</rd:DefaultName>
                                            <ZIndex>86</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                            <ZIndex>85</ZIndex>
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
                                            <rd:DefaultName>textbox39</rd:DefaultName>
                                            <ZIndex>84</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox22</rd:DefaultName>
                                            <ZIndex>83</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox221">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer___G_L_Account_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>82</ZIndex>
                                            <Style>
                                              <PaddingLeft>0cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer__Description.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>81</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox223">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer__Amount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Prepayment_Inv__Line_Buffer__AmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>80</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox224">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer___VAT_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Prepayment_Inv__Line_Buffer___VAT_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>79</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox225">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer___VAT___.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Prepayment_Inv__Line_Buffer___VAT___Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>78</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox226">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Prepayment_Inv__Line_Buffer___VAT_Identifier_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>77</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                          <Textbox Name="textbox165">
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
                                          <Textbox Name="textbox166">
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
                                            <ZIndex>74</ZIndex>
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
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox136">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Header_DimensionsCaption_Control119.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>73</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!LineDimLoop_Number.Value = 1, FALSE, TRUE)</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox152">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!DimText_Control118.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>72</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox96">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorText_Number__Control121Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Style>
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
                                                    <Value>=Fields!ErrorText_Number__Control121.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox46">
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
                                            <rd:DefaultName>textbox46</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                            <rd:DefaultName>textbox56</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox193</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox211</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox255">
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
                                            <rd:DefaultName>textbox255</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox258">
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
                                            <rd:DefaultName>textbox258</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox12</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>=Fields!TotalText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox329</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox372">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!SumPrepaymInvLineBufferAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!SumPrepaymInvLineBufferAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox372</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox32</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox387">
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
                                            <rd:DefaultName>textbox387</rd:DefaultName>
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox391">
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
                                            <rd:DefaultName>textbox391</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox392">
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
                                            <rd:DefaultName>textbox392</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox395">
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
                                            <rd:DefaultName>textbox395</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox396">
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
                                            <rd:DefaultName>textbox396</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox397">
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
                                            <rd:DefaultName>textbox397</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox13</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox373">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalExclVATText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox373</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox275">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!SumPrepaymInvLineBufferAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!SumPrepaymInvLineBufferAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox275</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox34">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>Fields!Prepayment_Inv__Line_Buffer__Amount_Control160Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox34</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox365">
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
                                            <rd:DefaultName>textbox365</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox366">
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
                                            <rd:DefaultName>textbox366</rd:DefaultName>
                                            <ZIndex>30</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox367">
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
                                            <rd:DefaultName>textbox367</rd:DefaultName>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox368">
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
                                            <rd:DefaultName>textbox368</rd:DefaultName>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox371">
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
                                            <rd:DefaultName>textbox371</rd:DefaultName>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox375">
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
                                            <rd:DefaultName>textbox375</rd:DefaultName>
                                            <ZIndex>26</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox21</rd:DefaultName>
                                            <ZIndex>25</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox385">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine_VATAmountText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox385</rd:DefaultName>
                                            <ZIndex>24</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox390">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox390</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox64</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox378">
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
                                            <rd:DefaultName>textbox378</rd:DefaultName>
                                            <ZIndex>41</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox379">
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
                                            <rd:DefaultName>textbox379</rd:DefaultName>
                                            <ZIndex>40</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox380">
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
                                            <rd:DefaultName>textbox380</rd:DefaultName>
                                            <ZIndex>39</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox381">
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
                                            <rd:DefaultName>textbox381</rd:DefaultName>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox382">
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
                                            <rd:DefaultName>textbox382</rd:DefaultName>
                                            <ZIndex>37</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox383">
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
                                            <rd:DefaultName>textbox383</rd:DefaultName>
                                            <ZIndex>36</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox23</rd:DefaultName>
                                            <ZIndex>35</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox450">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalInclVATText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox450</rd:DefaultName>
                                            <ZIndex>34</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox20">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!SumPrepaymInvLineBufferAmount.Value)+Fields!VATAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!Prepayment_Inv__Line_Buffer__Amount___VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox20</rd:DefaultName>
                                            <ZIndex>33</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox65">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Prepayment_Inv__Line_Buffer__Amount___VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox65</rd:DefaultName>
                                            <ZIndex>32</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
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
                                            <rd:DefaultName>textbox58</rd:DefaultName>
                                            <ZIndex>51</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                            <ZIndex>50</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox75">
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
                                            <rd:DefaultName>textbox75</rd:DefaultName>
                                            <ZIndex>49</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                            <ZIndex>48</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                            <ZIndex>47</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox93</rd:DefaultName>
                                            <ZIndex>46</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox124</rd:DefaultName>
                                            <ZIndex>45</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox433">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!TotalInclVATText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox433</rd:DefaultName>
                                            <ZIndex>44</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox434">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATBaseAmount___VATAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATBaseAmount___VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox434</rd:DefaultName>
                                            <ZIndex>43</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox66">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATBaseAmount___VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox66</rd:DefaultName>
                                            <ZIndex>42</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox328</rd:DefaultName>
                                            <ZIndex>61</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox340">
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
                                            <rd:DefaultName>textbox340</rd:DefaultName>
                                            <ZIndex>60</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox341">
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
                                            <rd:DefaultName>textbox341</rd:DefaultName>
                                            <ZIndex>59</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox342">
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
                                            <rd:DefaultName>textbox342</rd:DefaultName>
                                            <ZIndex>58</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox343">
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
                                            <rd:DefaultName>textbox343</rd:DefaultName>
                                            <ZIndex>57</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox352">
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
                                            <rd:DefaultName>textbox352</rd:DefaultName>
                                            <ZIndex>56</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox41</rd:DefaultName>
                                            <ZIndex>55</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox6</rd:DefaultName>
                                            <ZIndex>54</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox11">
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
                                            <rd:DefaultName>textbox11</rd:DefaultName>
                                            <ZIndex>53</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox150">
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
                                            <rd:DefaultName>textbox150</rd:DefaultName>
                                            <ZIndex>52</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.42308cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox308">
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
                                            <rd:DefaultName>textbox308</rd:DefaultName>
                                            <ZIndex>71</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox310">
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
                                            <rd:DefaultName>textbox310</rd:DefaultName>
                                            <ZIndex>70</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox311">
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
                                            <rd:DefaultName>textbox311</rd:DefaultName>
                                            <ZIndex>69</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox319</rd:DefaultName>
                                            <ZIndex>68</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox320</rd:DefaultName>
                                            <ZIndex>67</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox321</rd:DefaultName>
                                            <ZIndex>66</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox52</rd:DefaultName>
                                            <ZIndex>65</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>=Fields!VATAmountLine_VATAmountText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox411</rd:DefaultName>
                                            <ZIndex>64</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox412">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmount.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox412</rd:DefaultName>
                                            <ZIndex>63</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!VATAmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox151</rd:DefaultName>
                                            <ZIndex>62</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                </TablixMembers>
                              </TablixColumnHierarchy>
                              <TablixRowHierarchy>
                                <TablixMembers>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table4_Group2">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!PrepmtLoop_PrepmtLoop_Number.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Group Name="table4_Group1">
                                          <GroupExpressions>
                                            <GroupExpression>=Fields!LineDocDim_LineNo.Value</GroupExpression>
                                          </GroupExpressions>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!LineDimLoop_Number.Value &gt; 0, FALSE, TRUE)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Group Name="table4_Details_Group">
                                              <DataElementName>Detail</DataElementName>
                                            </Group>
                                            <TablixMembers>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=IIF(Fields!ErrorText_Number__Control121.Value &lt;&gt; "", FALSE, TRUE)</Hidden>
                                                </Visibility>
                                              </TablixMember>
                                            </TablixMembers>
                                            <DataElementName>Detail_Collection</DataElementName>
                                            <DataElementOutput>Output</DataElementOutput>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                        </TablixMembers>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF(Fields!VATAmount___0.Value = TRUE, FALSE, TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF (Fields!NOT__Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_.Value = TRUE, FALSE, TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF (Fields!NOT__Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_.Value = TRUE, FALSE, TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIF (Fields!NOT__Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_.Value = TRUE, FALSE, TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIf(Fields!Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_.Value = TRUE, FALSE, TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIf(Fields!Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_.Value = TRUE, FALSE, TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=IIf(Fields!Purchase_Header___Prices_Including_VAT__AND__VATAmount____0_.Value = TRUE, FALSE, TRUE)</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!PrepmtLoop_PrepmtLoop_Number.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>22.842cm</Top>
                              <Height>5.50003cm</Height>
                              <Width>18.15cm</Width>
                              <ZIndex>2</ZIndex>
                            </Tablix>
                            <Tablix Name="table2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>1.2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.1967cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.6533cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>4.85cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.15cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.15cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.25cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.15cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.15cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.6467cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>1.692cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox818">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Purchase_Line__TypeCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox818</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0cm</PaddingLeft>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox8">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Purchase_Line___No__Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox8</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox820">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Purchase_Line__DescriptionCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox820</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox821">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Purchase_Line__QuantityCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox821</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox822">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=IIF(Fields!Purchase_Header___Prices_Including_VAT_.Value = True,
     Fields!Purchase_Line___Line_Amount_Caption.Value,
     Fields!Purchase_Line___Line_Amount_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox822</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox823">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Purchase_Line___Prepayment___Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox823</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox824">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= IIF(Fields!Purchase_Header___Prices_Including_VAT_.Value = True,
     Fields!Purchase_Line___Prepmt__Line_Amount_Caption.Value,
     Fields!Purchase_Line___Prepmt__Line_Amount_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox824</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox825">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=IIF(Fields!Purchase_Header___Prices_Including_VAT_.Value = True,
     Fields!Purchase_Line___Prepmt__Amt__Inv__Caption.Value,
     Fields!Purchase_Line___Prepmt__Amt__Inv__Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox825</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox37</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>0.423cm</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox819">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Line__Type.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox819</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>=Fields!Purchase_Line___No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox9</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>=Fields!Purchase_Line__Description.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox10</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox24">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Line__Quantity.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Purchase_Line__QuantityFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox24</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>=Fields!Purchase_Line___Line_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Purchase_Line___Line_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox27</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>=Fields!Purchase_Line___Prepayment___.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Purchase_Line___Prepayment___Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox30</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox33">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Line___Prepmt__Line_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>= Fields!Purchase_Line___Prepmt__Line_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox33</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Value>=Fields!Purchase_Line___Prepmt__Amt__Inv__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Purchase_Line___Prepmt__Amt__Inv__Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox61</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Purchase_Line___Prepmt__Amt__Inv__Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox40</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox758">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorText_Number__Control104Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox758</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox759">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorText_Number__Control104.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox759</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table2_Group2">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!Purchase_Line___Line_No__.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Group Name="table2_Details_Group">
                                          <DataElementName>Detail</DataElementName>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIf(Fields!ErrorText_Number__Control104.Value = "",True,False)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                        </TablixMembers>
                                        <DataElementName>Detail_Collection</DataElementName>
                                        <DataElementOutput>Output</DataElementOutput>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!Purchase_Line___Line_No__.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>19.458cm</Top>
                              <Height>2.538cm</Height>
                              <Width>18.3967cm</Width>
                              <ZIndex>1</ZIndex>
                              <Visibility>
                                <Hidden>=IIf(Fields!Purchase_Line___Line_No__.Value = 0,True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="table3">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.45cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.55cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.95cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.4cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>3.02646cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.5cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>5.27354cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.15cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox454">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!PrepmtDocText.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>242</ZIndex>
                                            <Style>
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
                                          <Textbox Name="HeaderInfo">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>241</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Fields!Purchase_Prepyament_Document___TestCaption.Value + Chr(177) + 
Fields!COMPANYNAME.Value + Chr(177) + 
Fields!FORMAT_TODAY_0_4_.Value + Chr(177) + 
Fields!CurrReport_PAGENOCaption.Value)</Hidden>
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
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox998">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!FORMAT__Purchase_Header___Document_Type____________Purchase_Header___No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>240</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <ZIndex>239</ZIndex>
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
                                            <ZIndex>238</ZIndex>
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
                                            <ZIndex>237</ZIndex>
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
                                          <Textbox Name="textbox15">
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
                                            <rd:DefaultName>textbox15</rd:DefaultName>
                                            <ZIndex>236</ZIndex>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Color>#ff0000</Color>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox42</rd:DefaultName>
                                            <ZIndex>235</ZIndex>
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
                                          <Textbox Name="textbox179">
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
                                            <rd:DefaultName>textbox179</rd:DefaultName>
                                            <ZIndex>234</ZIndex>
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
                                    <Height>0.846cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1002">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!Purchase_Header___Buy_from_Vendor_No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>233</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1003">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Buy_from_Vendor_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>232</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox477">
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
                                            <rd:DefaultName>textbox477</rd:DefaultName>
                                            <ZIndex>231</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1004">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Sell_to_Customer_No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>230</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1005">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Sell_to_Customer_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>229</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                    <Value />
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox43</rd:DefaultName>
                                            <ZIndex>228</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox186">
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
                                            <rd:DefaultName>textbox186</rd:DefaultName>
                                            <ZIndex>227</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1010">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Buy_fromCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>226</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox55">
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
                                            <rd:DefaultName>textbox55</rd:DefaultName>
                                            <ZIndex>225</ZIndex>
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
                                          <Textbox Name="textbox892">
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
                                            <rd:DefaultName>textbox892</rd:DefaultName>
                                            <ZIndex>224</ZIndex>
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
                                          <Textbox Name="textbox1011">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Ship_toCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>223</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <rd:DefaultName>textbox45</rd:DefaultName>
                                            <ZIndex>222</ZIndex>
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
                                          <Textbox Name="textbox198">
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
                                            <rd:DefaultName>textbox198</rd:DefaultName>
                                            <ZIndex>221</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1014">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyFromAddr_1_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>220</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <ZIndex>219</ZIndex>
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
                                          <Textbox Name="textbox903">
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
                                            <rd:DefaultName>textbox903</rd:DefaultName>
                                            <ZIndex>218</ZIndex>
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
                                          <Textbox Name="textbox1015">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_1_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>217</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <ZIndex>216</ZIndex>
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
                                          <Textbox Name="textbox249">
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
                                            <rd:DefaultName>textbox249</rd:DefaultName>
                                            <ZIndex>215</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1018">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyFromAddr_2_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>214</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <ZIndex>213</ZIndex>
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
                                          <Textbox Name="textbox914">
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
                                            <rd:DefaultName>textbox914</rd:DefaultName>
                                            <ZIndex>212</ZIndex>
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
                                          <Textbox Name="textbox1019">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_2_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>211</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <ZIndex>210</ZIndex>
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
                                          <Textbox Name="textbox250">
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
                                            <rd:DefaultName>textbox250</rd:DefaultName>
                                            <ZIndex>209</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1022">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyFromAddr_3_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>208</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox106">
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
                                            <rd:DefaultName>textbox106</rd:DefaultName>
                                            <ZIndex>207</ZIndex>
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
                                          <Textbox Name="textbox925">
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
                                            <rd:DefaultName>textbox925</rd:DefaultName>
                                            <ZIndex>206</ZIndex>
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
                                          <Textbox Name="textbox1023">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_3_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>205</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox126">
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
                                            <rd:DefaultName>textbox126</rd:DefaultName>
                                            <ZIndex>204</ZIndex>
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
                                          <Textbox Name="textbox252">
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
                                            <rd:DefaultName>textbox252</rd:DefaultName>
                                            <ZIndex>203</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1026">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyFromAddr_4_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>202</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox191">
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
                                            <rd:DefaultName>textbox191</rd:DefaultName>
                                            <ZIndex>201</ZIndex>
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
                                          <Textbox Name="textbox936">
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
                                            <rd:DefaultName>textbox936</rd:DefaultName>
                                            <ZIndex>200</ZIndex>
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
                                          <Textbox Name="textbox1027">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_4_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>199</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox131">
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
                                            <rd:DefaultName>textbox131</rd:DefaultName>
                                            <ZIndex>198</ZIndex>
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
                                          <Textbox Name="textbox257">
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
                                            <rd:DefaultName>textbox257</rd:DefaultName>
                                            <ZIndex>197</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1030">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyFromAddr_5_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>196</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox202">
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
                                            <rd:DefaultName>textbox202</rd:DefaultName>
                                            <ZIndex>195</ZIndex>
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
                                          <Textbox Name="textbox958">
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
                                            <rd:DefaultName>textbox958</rd:DefaultName>
                                            <ZIndex>194</ZIndex>
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
                                          <Textbox Name="textbox1031">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_5_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>193</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox132">
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
                                            <rd:DefaultName>textbox132</rd:DefaultName>
                                            <ZIndex>192</ZIndex>
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
                                          <Textbox Name="textbox262">
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
                                            <rd:DefaultName>textbox262</rd:DefaultName>
                                            <ZIndex>191</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1034">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyFromAddr_6_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>190</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox460">
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
                                            <rd:DefaultName>textbox460</rd:DefaultName>
                                            <ZIndex>189</ZIndex>
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
                                          <Textbox Name="textbox969">
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
                                            <rd:DefaultName>textbox969</rd:DefaultName>
                                            <ZIndex>188</ZIndex>
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
                                          <Textbox Name="textbox1035">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_6_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>187</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox137">
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
                                            <rd:DefaultName>textbox137</rd:DefaultName>
                                            <ZIndex>186</ZIndex>
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
                                          <Textbox Name="textbox263">
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
                                            <rd:DefaultName>textbox263</rd:DefaultName>
                                            <ZIndex>185</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1038">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyFromAddr_7_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>184</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox469">
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
                                            <rd:DefaultName>textbox469</rd:DefaultName>
                                            <ZIndex>183</ZIndex>
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
                                          <Textbox Name="textbox980">
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
                                            <rd:DefaultName>textbox980</rd:DefaultName>
                                            <ZIndex>182</ZIndex>
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
                                          <Textbox Name="textbox1039">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_7_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>181</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox148">
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
                                            <rd:DefaultName>textbox148</rd:DefaultName>
                                            <ZIndex>180</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox264</rd:DefaultName>
                                            <ZIndex>179</ZIndex>
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
                                    <Height>0.846cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1042">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BuyFromAddr_8_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>178</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox877">
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
                                            <rd:DefaultName>textbox877</rd:DefaultName>
                                            <ZIndex>177</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox991">
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
                                            <rd:DefaultName>textbox991</rd:DefaultName>
                                            <ZIndex>176</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1043">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ShipToAddr_8_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>175</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox154">
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
                                            <rd:DefaultName>textbox154</rd:DefaultName>
                                            <ZIndex>174</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox266</rd:DefaultName>
                                            <ZIndex>173</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1075">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Pay_toCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>172</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox153</rd:DefaultName>
                                            <ZIndex>171</ZIndex>
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
                                          <Textbox Name="textbox1076">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>170</ZIndex>
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
                                            <ZIndex>169</ZIndex>
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
                                            <ZIndex>168</ZIndex>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox82</rd:DefaultName>
                                            <ZIndex>167</ZIndex>
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
                                          <Textbox Name="textbox157">
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
                                            <rd:DefaultName>textbox157</rd:DefaultName>
                                            <ZIndex>166</ZIndex>
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
                                          <Textbox Name="textbox309">
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
                                            <rd:DefaultName>textbox309</rd:DefaultName>
                                            <ZIndex>165</ZIndex>
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
                                    <Height>0.846cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1077">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Pay_to_Vendor_No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>164</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1078">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Pay_to_Vendor_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>163</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <ZIndex>162</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox99</rd:DefaultName>
                                            <ZIndex>161</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                            <ZIndex>160</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox167">
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
                                            <rd:DefaultName>textbox167</rd:DefaultName>
                                            <ZIndex>159</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox312">
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
                                            <rd:DefaultName>textbox312</rd:DefaultName>
                                            <ZIndex>158</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1081">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PayToAddr_1_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>157</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1082">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>156</ZIndex>
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
                                          <Textbox Name="textbox143">
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
                                            <rd:DefaultName>textbox143</rd:DefaultName>
                                            <ZIndex>155</ZIndex>
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
                                          <Textbox Name="textbox144">
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
                                            <rd:DefaultName>textbox144</rd:DefaultName>
                                            <ZIndex>154</ZIndex>
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
                                          <Textbox Name="textbox158">
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
                                            <rd:DefaultName>textbox158</rd:DefaultName>
                                            <ZIndex>153</ZIndex>
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
                                          <Textbox Name="textbox190">
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
                                            <rd:DefaultName>textbox190</rd:DefaultName>
                                            <ZIndex>152</ZIndex>
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
                                          <Textbox Name="textbox314">
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
                                            <rd:DefaultName>textbox314</rd:DefaultName>
                                            <ZIndex>151</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1083">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PayToAddr_2_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>150</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1084">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>149</ZIndex>
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
                                          <Textbox Name="textbox169">
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
                                            <rd:DefaultName>textbox169</rd:DefaultName>
                                            <ZIndex>148</ZIndex>
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
                                          <Textbox Name="textbox170">
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
                                            <rd:DefaultName>textbox170</rd:DefaultName>
                                            <ZIndex>147</ZIndex>
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
                                          <Textbox Name="textbox171">
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
                                            <rd:DefaultName>textbox171</rd:DefaultName>
                                            <ZIndex>146</ZIndex>
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
                                          <Textbox Name="textbox197">
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
                                            <rd:DefaultName>textbox197</rd:DefaultName>
                                            <ZIndex>145</ZIndex>
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
                                          <Textbox Name="textbox315">
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
                                            <rd:DefaultName>textbox315</rd:DefaultName>
                                            <ZIndex>144</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1085">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PayToAddr_3_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>143</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1086">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>142</ZIndex>
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
                                          <Textbox Name="textbox187">
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
                                            <rd:DefaultName>textbox187</rd:DefaultName>
                                            <ZIndex>141</ZIndex>
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
                                          <Textbox Name="textbox188">
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
                                            <rd:DefaultName>textbox188</rd:DefaultName>
                                            <ZIndex>140</ZIndex>
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
                                          <Textbox Name="textbox189">
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
                                            <rd:DefaultName>textbox189</rd:DefaultName>
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
                                          <Textbox Name="textbox201">
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
                                            <rd:DefaultName>textbox201</rd:DefaultName>
                                            <ZIndex>138</ZIndex>
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
                                          <Textbox Name="textbox316">
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
                                            <rd:DefaultName>textbox316</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1087">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PayToAddr_4_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>136</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1088">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox213">
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
                                            <rd:DefaultName>textbox213</rd:DefaultName>
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
                                          <Textbox Name="textbox214">
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
                                            <rd:DefaultName>textbox214</rd:DefaultName>
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
                                          <Textbox Name="textbox215">
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
                                            <rd:DefaultName>textbox215</rd:DefaultName>
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
                                          <Textbox Name="textbox210">
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
                                            <rd:DefaultName>textbox210</rd:DefaultName>
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
                                          <Textbox Name="textbox317">
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
                                            <rd:DefaultName>textbox317</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1089">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PayToAddr_5_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>129</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1090">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox265</rd:DefaultName>
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
                                          <Textbox Name="textbox274">
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
                                            <rd:DefaultName>textbox274</rd:DefaultName>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox280</rd:DefaultName>
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
                                          <Textbox Name="textbox228">
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
                                            <rd:DefaultName>textbox228</rd:DefaultName>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox318</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1091">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PayToAddr_6_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>122</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1092">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox287</rd:DefaultName>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox288</rd:DefaultName>
                                            <ZIndex>119</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox289</rd:DefaultName>
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
                                          <Textbox Name="textbox245">
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
                                            <rd:DefaultName>textbox245</rd:DefaultName>
                                            <ZIndex>117</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox322</rd:DefaultName>
                                            <ZIndex>116</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1093">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PayToAddr_7_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>115</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1094">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
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
                                          <Textbox Name="textbox242">
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
                                            <rd:DefaultName>textbox242</rd:DefaultName>
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
                                          <Textbox Name="textbox243">
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
                                            <rd:DefaultName>textbox243</rd:DefaultName>
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
                                          <Textbox Name="textbox244">
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
                                            <rd:DefaultName>textbox244</rd:DefaultName>
                                            <ZIndex>111</ZIndex>
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
                                          <Textbox Name="textbox246">
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
                                            <rd:DefaultName>textbox246</rd:DefaultName>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox323</rd:DefaultName>
                                            <ZIndex>109</ZIndex>
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
                                    <Height>0.846cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1095">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PayToAddr_8_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>108</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1096">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>107</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox251">
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
                                            <rd:DefaultName>textbox251</rd:DefaultName>
                                            <ZIndex>106</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox253">
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
                                            <rd:DefaultName>textbox253</rd:DefaultName>
                                            <ZIndex>105</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox254">
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
                                            <rd:DefaultName>textbox254</rd:DefaultName>
                                            <ZIndex>104</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox268</rd:DefaultName>
                                            <ZIndex>103</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox324">
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
                                            <rd:DefaultName>textbox324</rd:DefaultName>
                                            <ZIndex>102</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                          <Textbox Name="textbox911">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Your_Reference_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox911</rd:DefaultName>
                                            <ZIndex>101</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox2">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Your_Reference_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox2</rd:DefaultName>
                                            <ZIndex>100</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1108">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Purchaser_Code_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>99</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1109">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Purchaser_Code_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>98</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox269">
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
                                            <rd:DefaultName>textbox269</rd:DefaultName>
                                            <ZIndex>97</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox325">
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
                                            <rd:DefaultName>textbox325</rd:DefaultName>
                                            <ZIndex>96</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                          <Textbox Name="textbox432">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Posting_Group_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox432</rd:DefaultName>
                                            <ZIndex>95</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox483">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Posting_Group_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox483</rd:DefaultName>
                                            <ZIndex>94</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox17">
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
                                            <rd:DefaultName>textbox17</rd:DefaultName>
                                            <ZIndex>93</ZIndex>
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
                                          <Textbox Name="textbox1121">
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
                                            <rd:DefaultName>textbox1121</rd:DefaultName>
                                            <ZIndex>92</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1122">
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
                                            <rd:DefaultName>textbox1122</rd:DefaultName>
                                            <ZIndex>91</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox270</rd:DefaultName>
                                            <ZIndex>90</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox326">
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
                                            <rd:DefaultName>textbox326</rd:DefaultName>
                                            <ZIndex>89</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox525">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prepmt__Payment_Terms_Code_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox525</rd:DefaultName>
                                            <ZIndex>88</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox539">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prepmt__Payment_Terms_Code_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox539</rd:DefaultName>
                                            <ZIndex>87</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox19">
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
                                            <rd:DefaultName>textbox19</rd:DefaultName>
                                            <ZIndex>86</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox954">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!Purchase_Header___Order_Date_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>85</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox978">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Order_Date_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>84</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox271</rd:DefaultName>
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
                                          <Textbox Name="textbox327">
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
                                            <rd:DefaultName>textbox327</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox540">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prepayment_Due_Date_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox540</rd:DefaultName>
                                            <ZIndex>81</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox554">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prepayment_Due_Date_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox554</rd:DefaultName>
                                            <ZIndex>80</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox36</rd:DefaultName>
                                            <ZIndex>79</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1119">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Expected_Receipt_Date_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>78</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1120">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Expected_Receipt_Date_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>77</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox272</rd:DefaultName>
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
                                          <Textbox Name="textbox330">
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
                                            <rd:DefaultName>textbox330</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox555">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prepmt__Pmt__Discount_Date_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox555</rd:DefaultName>
                                            <ZIndex>74</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox584">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prepmt__Pmt__Discount_Date_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox584</rd:DefaultName>
                                            <ZIndex>73</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox88</rd:DefaultName>
                                            <ZIndex>72</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1130">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Document_Date_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>71</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1131">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Document_Date_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>70</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox273">
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
                                            <rd:DefaultName>textbox273</rd:DefaultName>
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
                                          <Textbox Name="textbox333">
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
                                            <rd:DefaultName>textbox333</rd:DefaultName>
                                            <ZIndex>68</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox585">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prepmt__Payment_Discount___Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox585</rd:DefaultName>
                                            <ZIndex>67</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox599">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prepmt__Payment_Discount___.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Purchase_Header___Prepmt__Payment_Discount___Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox599</rd:DefaultName>
                                            <ZIndex>66</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <ZIndex>65</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1141">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Posting_Date_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>64</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1142">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Posting_Date_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>63</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox276">
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
                                            <rd:DefaultName>textbox276</rd:DefaultName>
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
                                          <Textbox Name="textbox334">
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
                                            <rd:DefaultName>textbox334</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox600">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Payment_Method_Code_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox600</rd:DefaultName>
                                            <ZIndex>60</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox623">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Payment_Method_Code_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox623</rd:DefaultName>
                                            <ZIndex>59</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <ZIndex>58</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1152">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Order_No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>57</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1153">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Order_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>56</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                          <Textbox Name="textbox335">
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
                                            <rd:DefaultName>textbox335</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox624">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Shipment_Method_Code_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox624</rd:DefaultName>
                                            <ZIndex>53</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox935">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Shipment_Method_Code_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox935</rd:DefaultName>
                                            <ZIndex>52</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox103">
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
                                            <rd:DefaultName>textbox103</rd:DefaultName>
                                            <ZIndex>51</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1163">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Shipment_No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>50</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1164">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Shipment_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>49</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox283</rd:DefaultName>
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
                                          <Textbox Name="textbox336">
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
                                            <rd:DefaultName>textbox336</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
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
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox4</rd:DefaultName>
                                            <ZIndex>46</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox16</rd:DefaultName>
                                            <ZIndex>45</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                            <ZIndex>44</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
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
                                            <ZIndex>43</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1174">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Invoice_No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>42</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1175">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Invoice_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>41</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox295">
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
                                            <rd:DefaultName>textbox295</rd:DefaultName>
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
                                          <Textbox Name="textbox338">
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
                                            <rd:DefaultName>textbox338</rd:DefaultName>
                                            <ZIndex>39</ZIndex>
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
                                    <Height>0.846cm</Height>
                                    <TablixCells>
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
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox117</rd:DefaultName>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox133</rd:DefaultName>
                                            <ZIndex>37</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox134</rd:DefaultName>
                                            <ZIndex>36</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                          <Textbox Name="textbox1207">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prices_Including_VAT_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>34</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1208">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PricesIncludingVAT1.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>33</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox296">
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
                                            <rd:DefaultName>textbox296</rd:DefaultName>
                                            <ZIndex>32</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox339">
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
                                            <rd:DefaultName>textbox339</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1310">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Posting_Group__Control87Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>30</ZIndex>
                                            <Style>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1311">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Posting_Group_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>29</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
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
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1312">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Document_Date__Control83Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1313">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Document_Date_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>26</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox300</rd:DefaultName>
                                            <ZIndex>25</ZIndex>
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
                                          <Textbox Name="textbox344">
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
                                            <rd:DefaultName>textbox344</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.846cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1314">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox301</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1315">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
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
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1196">
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
                                            <rd:DefaultName>textbox1196</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1316">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Posting_Date__Control81Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>19</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1317">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Posting_Date_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox304">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox304</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox345">
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
                                            <rd:DefaultName>textbox345</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>0.423cm</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
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
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox18</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
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
                                          <Textbox Name="textbox302">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox302</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
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
                                          <Textbox Name="textbox49">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox49</rd:DefaultName>
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
                                          <Textbox Name="textbox135">
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
                                            <rd:DefaultName>textbox135</rd:DefaultName>
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
                                          <Textbox Name="textbox1324">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Cr__Memo_No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1325">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Vendor_Cr__Memo_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox305">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox305</rd:DefaultName>
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
                                          <Textbox Name="textbox346">
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
                                            <rd:DefaultName>textbox346</rd:DefaultName>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox237">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox237</rd:DefaultName>
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
                                          <Textbox Name="textbox303">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox303</rd:DefaultName>
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
                                          <Textbox Name="textbox238">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox238</rd:DefaultName>
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
                                          <Textbox Name="textbox239">
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
                                            <rd:DefaultName>textbox239</rd:DefaultName>
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
                                          <Textbox Name="textbox1328">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Purchase_Header___Prices_Including_VAT__Control78Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox1329">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!PricesIncludingVAT1.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.15cm</PaddingLeft>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox306">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox306</rd:DefaultName>
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
                                          <Textbox Name="textbox347">
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
                                            <rd:DefaultName>textbox347</rd:DefaultName>
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
                                    <Group Name="table3_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!Purchase_Header_Document_Type.Value</GroupExpression>
                                        <GroupExpression>=Fields!Purchase_Header_No_.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
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
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Fields!ShowPgCounter5.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter7.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter7.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter7.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter7.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter7.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter7.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter7.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter7.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter7.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter8.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter8.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter8.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>= IIF(Fields!ShowPgCounter8.Value = TRUE, FALSE, TRUE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>After</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                    </TablixMembers>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Height>18.612cm</Height>
                              <Width>18.3cm</Width>
                              <Style>
                                <Color>White</Color>
                              </Style>
                            </Tablix>
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
                      <GroupExpression>=Fields!Purchase_Header_Document_Type.Value</GroupExpression>
                      <GroupExpression>=Fields!Purchase_Header_No_.Value</GroupExpression>
                    </GroupExpressions>
                  </Group>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <KeepTogether>true</KeepTogether>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>0.423cm</Top>
          </Tablix>
        </ReportItems>
        <Height>32.149cm</Height>
      </Body>
      <Width>18.5cm</Width>
      <Page>
        <PageHeader>
          <Height>1.692cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="textbox86">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= ReportItems!textbox70.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Color>Red</Color>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Left>10.79365cm</Left>
              <Height>0.423cm</Height>
              <Width>0.5cm</Width>
              <ZIndex>8</ZIndex>
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
            <Textbox Name="textbox84">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= ReportItems!textbox48.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Color>Red</Color>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Left>10.15873cm</Left>
              <Height>0.423cm</Height>
              <Width>0.5cm</Width>
              <ZIndex>7</ZIndex>
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
            <Textbox Name="textbox83">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= ReportItems!textbox59.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Color>Red</Color>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <rd:DefaultName>textbox83</rd:DefaultName>
              <Left>9.5cm</Left>
              <Height>0.423cm</Height>
              <Width>0.5cm</Width>
              <ZIndex>6</ZIndex>
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
            <Textbox Name="PageNumberTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Globals!PageNumber</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>17.7cm</Left>
              <Height>0.423cm</Height>
              <Width>0.45cm</Width>
              <ZIndex>5</ZIndex>
              <Visibility>
                <Hidden>=IIf(Code.GetData(4) = "",True,False)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="UserIdTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=User!UserID</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.846cm</Top>
              <Left>14.9cm</Left>
              <Height>0.423cm</Height>
              <Width>3.25cm</Width>
              <ZIndex>4</ZIndex>
              <Visibility>
                <Hidden>=IIf(Code.GetData(4) = "",True,False)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
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
                      <Value>=Code.GetData(3)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>g</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>15cm</Left>
              <Height>0.423cm</Height>
              <Width>3.15cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="COMPANYNAME1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(2)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CurrReport_PAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>16.95cm</Left>
              <Height>0.423cm</Height>
              <Width>0.75cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
        </PageHeader>
        <PageFooter>
          <Height>1.269cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="textbox77">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!textbox63.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Height>0.846cm</Height>
              <Width>1.5cm</Width>
              <ZIndex>3</ZIndex>
              <Visibility>
                <Hidden>=IIF(ReportItems!ShowPageFooter.Value = TRUE, TRUE, FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingLeft>0cm</PaddingLeft>
                <PaddingTop>0.423cm</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="textbox73">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Sum(ReportItems!VATAmountLine__VAT_Amount__Control128.Value)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>N</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Left>7.05cm</Left>
              <Height>0.846cm</Height>
              <Width>1.95cm</Width>
              <ZIndex>2</ZIndex>
              <Visibility>
                <Hidden>=IIF(ReportItems!ShowPageFooter.Value = TRUE, TRUE, FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingLeft>0.15cm</PaddingLeft>
                <PaddingTop>0.423cm</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="textbox72">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Sum(ReportItems!VATAmountLine__VAT_Base__Control129.Value)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>N</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Left>5.1cm</Left>
              <Height>0.846cm</Height>
              <Width>1.95cm</Width>
              <ZIndex>1</ZIndex>
              <Visibility>
                <Hidden>=IIF(ReportItems!ShowPageFooter.Value = TRUE, TRUE, FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingLeft>0.15cm</PaddingLeft>
                <PaddingTop>0.423cm</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="textbox85">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Sum(ReportItems!VATAmountLine__Line_Amount__Control130.Value)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>N</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <rd:DefaultName>textbox85</rd:DefaultName>
              <Left>3.15cm</Left>
              <Height>0.846cm</Height>
              <Width>1.92936cm</Width>
              <Visibility>
                <Hidden>=IIF(ReportItems!ShowPageFooter.Value = TRUE, TRUE, FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <PaddingLeft>0.15cm</PaddingLeft>
                <PaddingTop>0.423cm</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
          </ReportItems>
        </PageFooter>
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

Shared HeaderData As Object

Public Function GetData(Num As Integer) As Object
   Return Cstr(Choose(Num, Split(Cstr(HeaderData),Chr(177))))
End Function

Public Function SetData(NewData As Object)
    If NewData &lt;&gt; "" Then
        HeaderData = NewData
    End If
    Return True
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Invalid</rd:ReportUnitType>
  <rd:ReportID>46ef7f98-08b1-4e13-9307-5a6d38c17e91</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

