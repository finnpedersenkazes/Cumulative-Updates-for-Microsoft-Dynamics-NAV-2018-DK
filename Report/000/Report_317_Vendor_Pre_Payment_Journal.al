OBJECT Report 317 Vendor Pre-Payment Journal
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Forudbetalingskladde for kreditor;
               ENU=Vendor Pre-Payment Journal];
    OnPreReport=BEGIN
                  GenJnlLineFilter := "Gen. Journal Line".GETFILTERS;
                  CompanyInformation.GET;
                END;

  }
  DATASET
  {
    { 3502;    ;DataItem;                    ;
               DataItemTable=Table232;
               DataItemTableView=SORTING(Journal Template Name,Name);
               OnPreDataItem=BEGIN
                               GLSetup.GET;
                               SalesSetup.GET;
                               PurchSetup.GET;
                             END;

               OnAfterGetRecord=BEGIN
                                  CurrReport.PAGENO := 1;
                                  GenJnlTemplate.GET("Journal Template Name");
                                END;
                                 }

    { 2007;1   ;Column  ;Gen__Journal_Batch_Journal_Template_Name;
               SourceExpr="Journal Template Name" }

    { 2008;1   ;Column  ;Gen__Journal_Batch_Name;
               SourceExpr=Name }

    { 5444;1   ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               LastDocumentNo := '';
                             END;
                              }

    { 2   ;2   ;Column  ;FORMAT_TODAY_0_4_   ;
               SourceExpr=FORMAT(TODAY,0,4) }

    { 3   ;2   ;Column  ;CompanyInformation_Name;
               SourceExpr=CompanyInformation.Name }

    { 5   ;2   ;Column  ;CurrReport_PAGENO   ;
               SourceExpr=CurrReport.PAGENO }

    { 6   ;2   ;Column  ;USERID              ;
               SourceExpr=USERID }

    { 8   ;2   ;Column  ;Gen__Journal_Batch___Journal_Template_Name_;
               SourceExpr="Gen. Journal Batch"."Journal Template Name" }

    { 10  ;2   ;Column  ;Gen__Journal_Batch__Name;
               SourceExpr="Gen. Journal Batch".Name }

    { 3000;2   ;Column  ;TIME                ;
               SourceExpr=TIME }

    { 53  ;2   ;Column  ;Gen__Journal_Line__TABLECAPTION__________GenJnlLineFilter;
               SourceExpr="Gen. Journal Line".TABLECAPTION + ': ' + GenJnlLineFilter }

    { 3055;2   ;Column  ;GenJnlLineFilter    ;
               SourceExpr=GenJnlLineFilter }

    { 3001;2   ;Column  ;USE001Err           ;
               SourceExpr=USE001Lbl }

    { 3057;2   ;Column  ;GenJnlTemplate__Force_Doc__Balance_;
               SourceExpr=GenJnlTemplate."Force Doc. Balance" }

    { 2009;2   ;Column  ;Integer_Number      ;
               SourceExpr=Number }

    { 1   ;2   ;Column  ;Payment_Journal___Pre_Check_TestCaption;
               SourceExpr=Payment_Journal___Pre_Check_TestCaptionLbl }

    { 4   ;2   ;Column  ;CurrReport_PAGENOCaption;
               SourceExpr=CurrReport_PAGENOCaptionLbl }

    { 7   ;2   ;Column  ;Gen__Journal_Batch___Journal_Template_Name_Caption;
               SourceExpr="Gen. Journal Batch".FIELDCAPTION("Journal Template Name") }

    { 9   ;2   ;Column  ;Gen__Journal_Batch__NameCaption;
               SourceExpr=Gen__Journal_Batch__NameCaptionLbl }

    { 11  ;2   ;Column  ;Gen__Journal_Line__Posting_Date_Caption;
               SourceExpr="Gen. Journal Line".FIELDCAPTION("Posting Date") }

    { 12  ;2   ;Column  ;Gen__Journal_Line__Document_Type_Caption;
               SourceExpr=Gen__Journal_Line__Document_Type_CaptionLbl }

    { 13  ;2   ;Column  ;Gen__Journal_Line__Document_No__Caption;
               SourceExpr=Gen__Journal_Line__Document_No__CaptionLbl }

    { 14  ;2   ;Column  ;Gen__Journal_Line__Account_Type_Caption;
               SourceExpr=Gen__Journal_Line__Account_Type_CaptionLbl }

    { 15  ;2   ;Column  ;Gen__Journal_Line__Account_No__Caption;
               SourceExpr=Gen__Journal_Line__Account_No__CaptionLbl }

    { 17  ;2   ;Column  ;Gen__Journal_Line_DescriptionCaption;
               SourceExpr="Gen. Journal Line".FIELDCAPTION(Description) }

    { 21  ;2   ;Column  ;Gen__Journal_Line_AmountCaption;
               SourceExpr="Gen. Journal Line".FIELDCAPTION(Amount) }

    { 22  ;2   ;Column  ;Gen__Journal_Line__Bal__Account_No__Caption;
               SourceExpr=Gen__Journal_Line__Bal__Account_No__CaptionLbl }

    { 3003;2   ;Column  ;Gen__Journal_Line__Bal__Account_Type_Caption;
               SourceExpr=Gen__Journal_Line__Bal__Account_Type_CaptionLbl }

    { 3005;2   ;Column  ;Gen__Journal_Line__Bank_Payment_Type_Caption;
               SourceExpr="Gen. Journal Line".FIELDCAPTION("Bank Payment Type") }

    { 3010;2   ;Column  ;DocumentCaption     ;
               SourceExpr=DocumentCaptionLbl }

    { 3011;2   ;Column  ;AccountCaption      ;
               SourceExpr=AccountCaptionLbl }

    { 3013;2   ;Column  ;Bal__AccountCaption ;
               SourceExpr=Bal__AccountCaptionLbl }

    { 7024;2   ;DataItem;                    ;
               DataItemTable=Table81;
               DataItemTableView=SORTING(Journal Template Name,Journal Batch Name,Posting Date,Document No.);
               OnPreDataItem=BEGIN
                               LastDocumentNo := '';
                               AmountBalLcy := 0;
                               AmountLcy := 0;
                               TotalAmount := 0;

                               GenJnlTemplate.GET("Gen. Journal Batch"."Journal Template Name");
                               IF GenJnlTemplate.Recurring THEN BEGIN
                                 IF GETFILTER("Posting Date") <> '' THEN
                                   AddError(
                                     STRSUBSTNO(
                                       E000Err,
                                       FIELDCAPTION("Posting Date")));
                                 SETRANGE("Posting Date",0D,WORKDATE);
                                 IF GETFILTER("Expiration Date") <> '' THEN
                                   AddError(
                                     STRSUBSTNO(
                                       E000Err,
                                       FIELDCAPTION("Expiration Date")));
                                 SETFILTER("Expiration Date",'%1 | %2..',0D,WORKDATE);
                               END;

                               IF "Gen. Journal Batch"."No. Series" <> '' THEN BEGIN
                                 NoSeries.GET("Gen. Journal Batch"."No. Series");
                                 LastEntrdDocNo := '';
                                 LastEntrdDate := 0D;
                               END;

                               CurrentCustomerVendors := 0;
                               VATEntryCreated := FALSE;

                               GenJnlLine2.RESET;
                               GenJnlLine2.COPYFILTERS("Gen. Journal Line");

                               TempGLAccNetChange.DELETEALL;
                               CurrReport.CREATETOTALS("Amount (LCY)","Balance (LCY)",
                                 TotalAmountDiscounted,TotalAmountPmtTolerance,TotalAmountPmtDiscTolerance,AmountApplied);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF "Document No." = LastDocumentNo THEN
                                    TotalAmount := TotalAmount + Amount
                                  ELSE BEGIN
                                    TotalAmount := Amount;
                                    AmountApplied := 0;
                                    TotalAmountDiscounted := 0;
                                    TotalAmountPmtTolerance := 0;
                                    TotalAmountPmtDiscTolerance := 0;
                                  END;
                                  AmountBalLcy := AmountBalLcy + "Balance (LCY)";
                                  AmountLcy := AmountLcy + "Amount (LCY)";

                                  IF "Currency Code" = '' THEN
                                    "Amount (LCY)" := Amount;

                                  // UpdateLineBalance;

                                  AccName := '';
                                  BalAccName := '';

                                  IF NOT EmptyLine THEN BEGIN
                                    MakeRecurringTexts("Gen. Journal Line");
                                    AmountError := FALSE;
                                    CheckGenJnlLineErrors("Gen. Journal Line");
                                  END;

                                  CheckBalance;

                                  AmountDiscounted := 0;
                                  AmountPmtTolerance := 0;
                                  AmountPmtDiscTolerance := 0;
                                  FOR Sign := Sign::Negative TO Sign::Positive DO BEGIN
                                    TotalCustAmount[Sign] := 0;
                                    TotalVendAmount[Sign] := 0;
                                  END;
                                  AmountPaid := Amount;
                                  ShowApplyToOutput := FALSE;
                                  IF "Applies-to Doc. No." <> '' THEN BEGIN
                                    ShowApplyToOutput := TRUE;
                                    CASE "Account Type" OF
                                      "Account Type"::Customer:
                                        CheckOldCustomer;
                                      "Account Type"::Vendor:
                                        CheckOldVendor;
                                      ELSE
                                        ShowApplyToOutput := FALSE;
                                    END;
                                  END ELSE
                                    CalcAppliesToIDTotals;
                                  IF "Document No." <> LastDocumentNo THEN BEGIN
                                    LastDocumentNo := "Document No.";
                                    CASE "Account Type" OF
                                      "Account Type"::Customer:
                                        IF Cust.GET("Account No.") THEN
                                          CustVendName := Cust.Name;
                                      "Account Type"::Vendor:
                                        IF Vend.GET("Account No.") THEN
                                          CustVendName := Vend.Name;
                                    END;
                                  END;
                                END;

               ReqFilterFields=Posting Date;
               DataItemLinkReference=Gen. Journal Batch;
               DataItemLink=Journal Template Name=FIELD(Journal Template Name),
                            Journal Batch Name=FIELD(Name) }

    { 24  ;3   ;Column  ;Gen__Journal_Line__Posting_Date_;
               SourceExpr="Posting Date" }

    { 25  ;3   ;Column  ;Gen__Journal_Line__Document_Type_;
               SourceExpr="Document Type" }

    { 26  ;3   ;Column  ;Gen__Journal_Line__Document_No__;
               SourceExpr="Document No." }

    { 3004;3   ;Column  ;Gen__Journal_Line__Bank_Payment_Type_;
               SourceExpr="Bank Payment Type" }

    { 27  ;3   ;Column  ;Gen__Journal_Line__Account_Type_;
               SourceExpr="Account Type" }

    { 28  ;3   ;Column  ;Gen__Journal_Line__Account_No__;
               SourceExpr="Account No." }

    { 30  ;3   ;Column  ;Gen__Journal_Line_Description;
               SourceExpr=Description }

    { 3002;3   ;Column  ;Gen__Journal_Line__Bal__Account_Type_;
               SourceExpr="Bal. Account Type" }

    { 36  ;3   ;Column  ;Gen__Journal_Line__Bal__Account_No__;
               SourceExpr="Bal. Account No." }

    { 3006;3   ;Column  ;Gen__Journal_Line__Applies_to_Doc__Type_;
               SourceExpr="Applies-to Doc. Type" }

    { 3008;3   ;Column  ;Gen__Journal_Line__Applies_to_Doc__No__;
               SourceExpr="Applies-to Doc. No." }

    { 3012;3   ;Column  ;Gen__Journal_Line__Due_Date_;
               SourceExpr="Due Date" }

    { 3015;3   ;Column  ;Gen__Journal_Line_Description_Control3015;
               SourceExpr=Description }

    { 3017;3   ;Column  ;AmountDue           ;
               SourceExpr=AmountDue;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3019;3   ;Column  ;AmountDiscounted    ;
               SourceExpr=AmountDiscounted;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3021;3   ;Column  ;AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance;
               SourceExpr=AmountPaid - AmountDiscounted - AmountPmtDiscTolerance - AmountPmtTolerance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3042;3   ;Column  ;Gen__Journal_Line__Currency_Code_;
               SourceExpr="Currency Code" }

    { 3030;3   ;Column  ;AmountPmtDiscTolerance;
               SourceExpr=AmountPmtDiscTolerance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3047;3   ;Column  ;AmountPmtTolerance  ;
               SourceExpr=AmountPmtTolerance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3056;3   ;Column  ;ShowApplyToOutput   ;
               SourceExpr=ShowApplyToOutput }

    { 3058;3   ;Column  ;TotalAmount         ;
               SourceExpr=TotalAmount }

    { 3024;3   ;Column  ;Amount___TotalAmountDiscounted___TotalAmountPmtDiscTolerance___TotalAmountPmtTolerance___AmountApplied;
               SourceExpr=Amount + TotalAmountDiscounted + TotalAmountPmtDiscTolerance + TotalAmountPmtTolerance + AmountApplied;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3059;3   ;Column  ;AmountApplied       ;
               SourceExpr=AmountApplied }

    { 34  ;3   ;Column  ;Gen__Journal_Line_Amount;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 35  ;3   ;Column  ;Gen__Journal_Line__Currency_Code__Control35;
               SourceExpr="Currency Code" }

    { 3026;3   ;Column  ;STRSUBSTNO_USE003Err__Document_Type___Document_No___;
               SourceExpr=STRSUBSTNO(USE003Lbl,"Document Type","Document No.") }

    { 3028;3   ;Column  ;TotalAmountDiscounted;
               SourceExpr=TotalAmountDiscounted;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3053;3   ;Column  ;TotalAmountPmtDiscTolerance;
               SourceExpr=TotalAmountPmtDiscTolerance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3054;3   ;Column  ;TotalAmountPmtTolerance;
               SourceExpr=TotalAmountPmtTolerance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 39  ;3   ;Column  ;Gen__Journal_Line__Amount__LCY__;
               SourceExpr="Amount (LCY)" }

    { 40  ;3   ;Column  ;Gen__Journal_Line__Balance__LCY__;
               SourceExpr="Balance (LCY)" }

    { 3045;3   ;Column  ;STRSUBSTNO_USE002Err__Journal_Template_Name___Journal_Batch_Name__;
               SourceExpr=STRSUBSTNO(USE002Lbl,"Journal Template Name","Journal Batch Name") }

    { 3060;3   ;Column  ;AmountLcy           ;
               SourceExpr=AmountLcy }

    { 3061;3   ;Column  ;AmountBalLcy        ;
               SourceExpr=AmountBalLcy }

    { 2010;3   ;Column  ;Gen__Journal_Line_Journal_Template_Name;
               SourceExpr="Journal Template Name" }

    { 2011;3   ;Column  ;Gen__Journal_Line_Journal_Batch_Name;
               SourceExpr="Journal Batch Name" }

    { 2012;3   ;Column  ;Gen__Journal_Line_Line_No_;
               SourceExpr="Line No." }

    { 2016;3   ;Column  ;Gen__Journal_Line_Applies_to_ID;
               SourceExpr="Applies-to ID" }

    { 3007;3   ;Column  ;Gen__Journal_Line__Applies_to_Doc__Type_Caption;
               SourceExpr=FIELDCAPTION("Applies-to Doc. Type") }

    { 3009;3   ;Column  ;Gen__Journal_Line__Applies_to_Doc__No__Caption;
               SourceExpr=FIELDCAPTION("Applies-to Doc. No.") }

    { 3014;3   ;Column  ;Gen__Journal_Line__Due_Date_Caption;
               SourceExpr=FIELDCAPTION("Due Date") }

    { 3016;3   ;Column  ;Description___Caption;
               SourceExpr=Description___CaptionLbl }

    { 3018;3   ;Column  ;AmountDueCaption    ;
               SourceExpr=AmountDueCaptionLbl }

    { 3020;3   ;Column  ;AmountDiscountedCaption;
               SourceExpr=AmountDiscountedCaptionLbl }

    { 3046;3   ;Column  ;AmountPmtDiscToleranceCaption;
               SourceExpr=AmountPmtDiscToleranceCaptionLbl }

    { 3048;3   ;Column  ;AmountPmtToleranceCaption;
               SourceExpr=AmountPmtToleranceCaptionLbl }

    { 3022;3   ;Column  ;Unapplied_AmountsCaption;
               SourceExpr=Unapplied_AmountsCaptionLbl }

    { 38  ;3   ;Column  ;Gen__Journal_Line__Amount__LCY__Caption;
               SourceExpr=CAPTIONCLASSTRANSLATE('101,0,Total (%1)') }

    { 3032;3   ;Column  ;Gen__Journal_Line__Balance__LCY__Caption;
               SourceExpr=CAPTIONCLASSTRANSLATE('101,0,Balance (%1)') }

    { 3062;3   ;Column  ;Cust_Vend_Name      ;
               SourceExpr=CustVendName }

    { 8503;3   ;DataItem;                    ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.,Open,Positive,Due Date,Currency Code);
               OnPreDataItem=BEGIN
                               IF ("Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Customer) OR
                                  ("Gen. Journal Line"."Applies-to ID" = '')
                               THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=BEGIN
                                  CALCFIELDS("Remaining Amount");

                                  InitPmtDisc(-"Accepted Payment Tolerance",-"Remaining Amount");
                                  CalcPmtDisc(
                                    Positive,"Remaining Pmt. Disc. Possible",
                                    "Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date","Accepted Pmt. Disc. Tolerance",
                                    TotalCustAmount);

                                  AmountPaid := AmountPaid + AmountPmtTolerance + AmountDiscounted + AmountPmtDiscTolerance;
                                  IF "Currency Code" = "Gen. Journal Line"."Currency Code" THEN BEGIN
                                    TotalAmountDiscounted := TotalAmountDiscounted + AmountDiscounted;
                                    AmountApplied := AmountApplied + "Amount to Apply";
                                    TotalAmountPmtTolerance := TotalAmountPmtTolerance + AmountPmtTolerance;
                                    TotalAmountPmtDiscTolerance := TotalAmountPmtDiscTolerance + AmountPmtDiscTolerance;
                                  END ELSE BEGIN
                                    TotalAmountDiscounted :=
                                      TotalAmountDiscounted +
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        "Gen. Journal Line"."Posting Date",
                                        "Currency Code",
                                        "Gen. Journal Line"."Currency Code",
                                        AmountDiscounted);
                                    AmountApplied :=
                                      AmountApplied +
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        "Gen. Journal Line"."Posting Date",
                                        "Currency Code",
                                        "Gen. Journal Line"."Currency Code",
                                        "Amount to Apply");
                                    TotalAmountPmtTolerance :=
                                      TotalAmountPmtTolerance +
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        "Gen. Journal Line"."Posting Date",
                                        "Currency Code",
                                        "Gen. Journal Line"."Currency Code",
                                        AmountPmtTolerance);
                                    TotalAmountPmtDiscTolerance :=
                                      TotalAmountPmtDiscTolerance +
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        "Gen. Journal Line"."Posting Date",
                                        "Currency Code",
                                        "Gen. Journal Line"."Currency Code",
                                        AmountPmtDiscTolerance);
                                  END;
                                END;

               DataItemLink=Customer No.=FIELD(Account No.),
                            Applies-to ID=FIELD(Applies-to ID) }

    { 3023;4   ;Column  ;Cust__Ledger_Entry__Document_Type_;
               SourceExpr="Document Type" }

    { 3025;4   ;Column  ;Cust__Ledger_Entry__Document_No__;
               SourceExpr="Document No." }

    { 3027;4   ;Column  ;Cust__Ledger_Entry_Description;
               SourceExpr=Description }

    { 3029;4   ;Column  ;Cust__Ledger_Entry__Due_Date_;
               SourceExpr="Due Date" }

    { 3031;4   ;Column  ;Remaining_Amount_   ;
               SourceExpr=-"Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3033;4   ;Column  ;AmountDiscounted_Control3033;
               SourceExpr=AmountDiscounted;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3034;4   ;Column  ;Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_;
               SourceExpr=-("Amount to Apply" + AmountDiscounted + AmountPmtDiscTolerance + AmountPmtTolerance);
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3043;4   ;Column  ;Cust__Ledger_Entry__Currency_Code_;
               SourceExpr="Currency Code" }

    { 3049;4   ;Column  ;AmountPmtTolerance_Control3049;
               SourceExpr=AmountPmtTolerance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3050;4   ;Column  ;AmountPmtDiscTolerance_Control3050;
               SourceExpr=AmountPmtDiscTolerance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 2013;4   ;Column  ;Cust__Ledger_Entry_Entry_No_;
               SourceExpr="Entry No." }

    { 2014;4   ;Column  ;Cust__Ledger_Entry_Customer_No_;
               SourceExpr="Customer No." }

    { 2015;4   ;Column  ;Cust__Ledger_Entry_Applies_to_ID;
               SourceExpr="Applies-to ID" }

    { 4114;3   ;DataItem;                    ;
               DataItemTable=Table25;
               DataItemTableView=SORTING(Vendor No.,Open,Positive,Due Date,Currency Code);
               OnPreDataItem=BEGIN
                               IF ("Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."Account Type"::Vendor) OR
                                  ("Gen. Journal Line"."Applies-to ID" = '')
                               THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=BEGIN
                                  CALCFIELDS("Remaining Amount");

                                  InitPmtDisc(-"Accepted Payment Tolerance",-"Remaining Amount");
                                  CalcPmtDisc(
                                    Positive,"Remaining Pmt. Disc. Possible",
                                    "Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date","Accepted Pmt. Disc. Tolerance",
                                    TotalVendAmount);

                                  AmountPaid := AmountPaid + AmountPmtTolerance + AmountDiscounted + AmountPmtDiscTolerance;
                                  IF "Currency Code" = "Gen. Journal Line"."Currency Code" THEN BEGIN
                                    TotalAmountDiscounted := TotalAmountDiscounted + AmountDiscounted;
                                    AmountApplied := AmountApplied + "Amount to Apply";
                                    TotalAmountPmtTolerance := TotalAmountPmtTolerance + AmountPmtTolerance;
                                    TotalAmountPmtDiscTolerance := TotalAmountPmtDiscTolerance + AmountPmtDiscTolerance;
                                  END ELSE BEGIN
                                    TotalAmountDiscounted :=
                                      TotalAmountDiscounted +
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        "Gen. Journal Line"."Posting Date",
                                        "Currency Code",
                                        "Gen. Journal Line"."Currency Code",
                                        AmountDiscounted);
                                    AmountApplied :=
                                      AmountApplied +
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        "Gen. Journal Line"."Posting Date",
                                        "Currency Code",
                                        "Gen. Journal Line"."Currency Code",
                                        "Amount to Apply");
                                    TotalAmountPmtTolerance :=
                                      TotalAmountPmtTolerance +
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        "Gen. Journal Line"."Posting Date",
                                        "Currency Code",
                                        "Gen. Journal Line"."Currency Code",
                                        AmountPmtTolerance);
                                    TotalAmountPmtDiscTolerance :=
                                      TotalAmountPmtDiscTolerance +
                                      CurrExchRate.ExchangeAmtFCYToFCY(
                                        "Gen. Journal Line"."Posting Date",
                                        "Currency Code",
                                        "Gen. Journal Line"."Currency Code",
                                        AmountPmtDiscTolerance);
                                  END;
                                END;

               DataItemLink=Vendor No.=FIELD(Account No.),
                            Applies-to ID=FIELD(Applies-to ID) }

    { 3035;4   ;Column  ;Remaining_Amount__Control3035;
               SourceExpr=-"Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3036;4   ;Column  ;Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036;
               SourceExpr=-("Amount to Apply" + AmountDiscounted + AmountPmtDiscTolerance + AmountPmtTolerance);
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3037;4   ;Column  ;AmountDiscounted_Control3037;
               SourceExpr=AmountDiscounted;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3038;4   ;Column  ;Vendor_Ledger_Entry_Description;
               SourceExpr=Description }

    { 3039;4   ;Column  ;Vendor_Ledger_Entry__Due_Date_;
               SourceExpr="Due Date" }

    { 3040;4   ;Column  ;Vendor_Ledger_Entry__Document_No__;
               SourceExpr="Document No." }

    { 3041;4   ;Column  ;Vendor_Ledger_Entry__Document_Type_;
               SourceExpr="Document Type" }

    { 3044;4   ;Column  ;Vendor_Ledger_Entry__Currency_Code_;
               SourceExpr="Currency Code" }

    { 3051;4   ;Column  ;AmountPmtTolerance_Control3051;
               SourceExpr=AmountPmtTolerance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 3052;4   ;Column  ;AmountPmtDiscTolerance_Control3052;
               SourceExpr=AmountPmtDiscTolerance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 2017;4   ;Column  ;Vendor_Ledger_Entry_Entry_No_;
               SourceExpr="Entry No." }

    { 2018;4   ;Column  ;Vendor_Ledger_Entry_Vendor_No_;
               SourceExpr="Vendor No." }

    { 2019;4   ;Column  ;Vendor_Ledger_Entry_Applies_to_ID;
               SourceExpr="Applies-to ID" }

    { 1162;3   ;DataItem;ErrorLoop           ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,ErrorCounter);
                             END;

               OnPostDataItem=BEGIN
                                ErrorCounter := 0;
                              END;
                               }

    { 43  ;4   ;Column  ;ErrorText_Number_   ;
               SourceExpr=ErrorText[Number] }

    { 2020;4   ;Column  ;ErrorLoop_Number    ;
               SourceExpr=Number }

    { 42  ;4   ;Column  ;ErrorText_Number_Caption;
               SourceExpr=ErrorText_Number_CaptionLbl }

    { 5127;2   ;DataItem;ReconcileLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,TempGLAccNetChange.COUNT);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    TempGLAccNetChange.FIND('-')
                                  ELSE
                                    TempGLAccNetChange.NEXT;
                                END;

               OnPostDataItem=BEGIN
                                TempGLAccNetChange.DELETEALL;
                              END;
                               }

    { 49  ;3   ;Column  ;GLAccNetChange__No__;
               SourceExpr=TempGLAccNetChange."No." }

    { 50  ;3   ;Column  ;GLAccNetChange_Name ;
               SourceExpr=TempGLAccNetChange.Name }

    { 51  ;3   ;Column  ;GLAccNetChange__Net_Change_in_Jnl__;
               SourceExpr=TempGLAccNetChange."Net Change in Jnl." }

    { 52  ;3   ;Column  ;GLAccNetChange__Balance_after_Posting_;
               SourceExpr=TempGLAccNetChange."Balance after Posting" }

    { 2021;3   ;Column  ;ReconcileLoop_Number;
               SourceExpr=Number }

    { 44  ;3   ;Column  ;ReconciliationCaption;
               SourceExpr=ReconciliationCaptionLbl }

    { 45  ;3   ;Column  ;GLAccNetChange__No__Caption;
               SourceExpr=GLAccNetChange__No__CaptionLbl }

    { 46  ;3   ;Column  ;GLAccNetChange_NameCaption;
               SourceExpr=GLAccNetChange_NameCaptionLbl }

    { 47  ;3   ;Column  ;GLAccNetChange__Net_Change_in_Jnl__Caption;
               SourceExpr=GLAccNetChange__Net_Change_in_Jnl__CaptionLbl }

    { 48  ;3   ;Column  ;GLAccNetChange__Balance_after_Posting_Caption;
               SourceExpr=GLAccNetChange__Balance_after_Posting_CaptionLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      E000Err@1000 : TextConst '@@@="%1=Posting date field caption";DAN=Der kan ikke s�ttes filter p� %1, n�r du bogf�rer gentagelseskladder.;ENU=%1 cannot be filtered when you post recurring journals.';
      E001Err@1001 : TextConst '@@@="%1=Account No. field caption; %2=Bal. Account No. field caption";DAN=%1 og %2 skal indtastes.;ENU=%1 or %2 must be specified.';
      E002Err@1002 : TextConst '@@@="%1=Gen. Posting Type field caption";DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      E003Err@1003 : TextConst '@@@="%1=VAT Amount field caption;%2=VAT Base Amount field caption;%3=Amount field caption";DAN=%1 + %2 skal v�re %3.;ENU=%1 + %2 must be %3.';
      E004Err@1004 : TextConst '@@@="%1=Gen. Posting Type field caption;%2=Account Type field caption;%3=Account Type";DAN=%1 skal v�re " " n�r %2 er %3.;ENU=%1 must be " " when %2 is %3.';
      E005Err@1005 : TextConst '@@@="%1=Gen. Bus. Posting Group field caption;%2=Gen. Prod. Posting Group field caption;%3=VAT Bus. Posting Group field caption;%4=VAT Prod. Posting Group field caption;%5=Account Type field caption;%6=Account Type";DAN=%1, %2, %3 eller %4 m� ikke v�ret angivet, n�r %5 er %6.;ENU=%1, %2, %3 or %4 must not be completed when %5 is %6.';
      E006Err@1006 : TextConst '@@@="%1=Amount field caption";DAN=%1 skal v�re negativ.;ENU=%1 must be negative.';
      E007Err@1007 : TextConst '@@@="%1=Amount field caption";DAN=%1 skal v�re positiv.;ENU=%1 must be positive.';
      E008Err@1008 : TextConst '@@@="%1=Sales/Purch. (LCY) field caption;%2=Amount field caption";DAN=%1 skal have samme fortegn som %2.;ENU=%1 must have the same sign as %2.';
      E009Err@1009 : TextConst '@@@="%1=Job No. field caption";DAN=%1 kan ikke indtastes.;ENU=%1 cannot be specified.';
      E011Err@1011 : TextConst '@@@="%1=Bal. VAT Amount field caption;%2=Bal. VAT Base Amount field caption;%3=Amount field caption";DAN=%1 + %2 skal v�re -%3.;ENU=%1 + %2 must be -%3.';
      E012Err@1012 : TextConst '@@@="%1=Sales/Purch. (LCY) field caption;%2=Amount field caption";DAN=%1 skal have et andet fortegn end %2.;ENU=%1 must have a different sign than %2.';
      E013Err@1013 : TextConst '@@@="%1=Posting Date field caption";DAN=%1 m� kun v�re en ultimodato for finansposter.;ENU=%1 must only be a closing date for G/L entries.';
      E014Err@1014 : TextConst '@@@="%1=Posting Date format";DAN=%1 er ikke inden for den tilladte bogf�ringsperiode.;ENU=%1 is not within your allowed range of posting dates.';
      E015Err@1015 : TextConst 'DAN=Linjerne er ikke sorteret efter bogf�ringsdato, fordi de ikke blev indtastet i den r�kkef�lge.;ENU=The lines are not listed according to Posting Date because they were not entered in that order.';
      E016Err@1016 : TextConst 'DAN=Der er et hul i nummerserien.;ENU=There is a gap in the number series.';
      E017Err@1017 : TextConst '@@@="%1=Account Type field caption;%2=Bal. Account Type field caption";DAN=%1 eller %2 skal v�re Finanskonto eller Bankkonto.;ENU=%1 or %2 must be G/L Account or Bank Account.';
      E018Err@1018 : TextConst '@@@="%1=Payment Discount % field caption";DAN=%1 skal v�re 0.;ENU=%1 must be 0.';
      E019Err@1019 : TextConst '@@@="%1=Bal. Account No. field caption";DAN=%1 m� ikke indtastes, n�r man bruger gentagelseskladder.;ENU=%1 cannot be specified when using recurring journals.';
      E020Err@1020 : TextConst '@@@="%1=Recurring Method field caption;%2=Recurring Method;%3=Account Type field caption;%4=Account Type";DAN="%1 m� ikke v�re %2, n�r %3 = %4.";ENU="%1 must not be %2 when %3 = %4."';
      E021Err@1021 : TextConst 'DAN=Fordelinger kan kun bruges i forbindelse med gentagelseskladder.;ENU=Allocations can only be used with recurring journals.';
      E022Err@1022 : TextConst '@@@="%1=Account No. field caption;%2=GenJnlAlloc record count";DAN=%1 skal indtastes i %2 fordelingslinjer.;ENU=Please specify %1 in the %2 allocation lines.';
      E023Err@1023 : TextConst 'DAN=<M�nedstekst>;ENU=<Month Text>';
      E024Err@1024 : TextConst '@@@="%1=Document Type;%2=Document No.;%3=Posting Date";DAN=%1 %2 med bogf�ringsdatoen %3 skal v�re adskilt med en tom linje;ENU=%1 %2 posted on %3, must be separated by an empty line';
      E025Err@1025 : TextConst '@@@="%1=LastDocType;%2=LastDocNo; %3=DocBalance";DAN=%1 %2 stemmer ikke med %3.;ENU=%1 %2 is out of balance by %3.';
      E026Err@1026 : TextConst '@@@="%1=LastDocType;%2=LastDocNo;%3=DocBalanceReverse";DAN=Tilbagef�rselslinjerne i %1 %2 stemmer ikke med %3.;ENU=The reversing entries for %1 %2 are out of balance by %3.';
      E027Err@1027 : TextConst '@@@="%1=LastDate;%2=DateBalance";DAN=Linjerne stemmer ikke med %2 pr. %1.;ENU=As of %1, the lines are out of balance by %2.';
      E028Err@1028 : TextConst '@@@="%1=LastDate;%2=DateBalanceReverse";DAN=Tilbagef�ringsposterne stemmer ikke med %2 pr. %1.;ENU=As of %1, the reversing entries are out of balance by %2.';
      E029Err@1029 : TextConst '@@@="%1=Total balance";DAN=Saldoen p� linjerne stemmer ikke med %1.;ENU=The total of the lines is out of balance by %1.';
      E030Err@1030 : TextConst '@@@="%1=TotalBalanceReverse";DAN=I alt stemmer tilbagef�rselslinjerne ikke med %1.;ENU=The total of the reversing entries is out of balance by %1.';
      E031Err@1031 : TextConst '@@@="%1=G/L Account table caption;%2=Account No.";DAN=%1 %2 findes ikke.;ENU=%1 %2 does not exist.';
      E032Err@1032 : TextConst '@@@="%1=Blocked field caption;%2=FALSE;%3=G/L Account table caption;%4=Account No.";DAN=%1 skal v�re %2 for %3 %4.;ENU=%1 must be %2 for %3 %4.';
      E036Err@1033 : TextConst '@@@="%1=VAT Posting Setup table caption;%2=VAT Bus. Posting Group;%3=VAT Prod. Posting Group";DAN=%1 %2 %3 findes ikke.;ENU=%1 %2 %3 does not exist.';
      E037Err@1034 : TextConst '@@@="%1=VAT Calculation Type field caption;%2=VAT Calculation Type";DAN=%1 skal v�re %2.;ENU=%1 must be %2.';
      E038Err@1035 : TextConst '@@@="%1=Currency Code";DAN=Valutaen %1 kan ikke findes. Se i valutatabellen.;ENU=The currency %1 cannot be found. Please check the currency table.';
      E039Err@1036 : TextConst '@@@="%1=Document Type;%2=Document No.";DAN=Salg %1 %2 findes allerede.;ENU=Sales %1 %2 already exists.';
      E040Err@1037 : TextConst '@@@="%1=Document Type;%2=Document No.";DAN=K�b %1 %2 findes allerede.;ENU=Purchase %1 %2 already exists.';
      E041Err@1038 : TextConst '@@@="%1=External Document No. field caption";DAN=%1 skal indtastes.;ENU=%1 must be entered.';
      E042Err@1039 : TextConst '@@@="%1=Bank Payment Type field caption;%2=Currency Code field caption;%3=Table caption;%4=Bank Account table caption";DAN=%1 m� ikke udfyldes, n�r %2 er forskellig fra %3 og %4.;ENU=%1 must not be filled when %2 is different in %3 and %4.';
      E043Err@1040 : TextConst '@@@="%1=Fixed Asset table caption;%2=Account No.;%3=Budgeted Asset field caption;%4=TRUE";DAN="%1 %2 m� ikke have %3 = %4.";ENU="%1 %2 must not have %3 = %4."';
      E044Err@1041 : TextConst '@@@="%1=Job No.";DAN=%1 m� ikke indtastes p� kladdelinjer i anl�gsaktiver.;ENU=%1 must not be specified in fixed asset journal lines.';
      E045Err@1042 : TextConst '@@@="%1=Depreciation Book Code field caption";DAN=%1 skal indtastes p� kladdelinjer i anl�gsaktiver.;ENU=%1 must be specified in fixed asset journal lines.';
      E046Err@1043 : TextConst '@@@="%1=Depreciation Book Code field caption;%2=Duplicate in Depreciation Book field caption";DAN=%1 skal v�re forskellig fra %2.;ENU=%1 must be different than %2.';
      E047Err@1044 : TextConst '@@@="%1=Account Type field caption;%2=Bal. Account Type field caption;%3=Account Type";DAN=%1 og %2 m� ikke begge v�re %3.;ENU=%1 and %2 must not both be %3.';
      E048Err@1045 : TextConst '@@@="%1=Gen. Posting Type field caption;%2=FA Posting Type field caption;%3=FA Posting Type";DAN="%1 m� ikke indtastes, n�r %2 = %3.";ENU="%1  must not be specified when %2 = %3."';
      E049Err@1046 : TextConst '@@@="%1=Gen. Bus. Posting Group field caption;%2=FA Posting Type field caption;%3=FA Posting Type";DAN="%1 m� ikke indtastes, n�r %2 = %3.";ENU="%1 must not be specified when %2 = %3."';
      E050Err@1047 : TextConst '@@@="%1=FA Posting Type field caption;%2=FA Posting Type";DAN="m� ikke indtastes, n�r %1 = %2.";ENU="must not be specified together with %1 = %2."';
      E051Err@1048 : TextConst '@@@="%1=Posting Date field caption;%2=FA Posting Date field caption";DAN=%1 skal v�re lig med %2.;ENU=%1 must be identical to %2.';
      E052Err@1049 : TextConst '@@@="%1=FA Posting Date field caption";DAN=%1 m� ikke v�re en ultimodato.;ENU=%1 cannot be a closing date.';
      E053Err@1050 : TextConst '@@@="%1=FA Posting Date field caption";DAN=%1 er ikke inden for den tilladte bogf�ringsperiode.;ENU=%1 is not within your range of allowed posting dates.';
      E054Err@1051 : TextConst '@@@="Depreciation Book Code field caption;%2=Depreciation Book Code";DAN=Forsikringsintegration er ikke aktiveret for %1 %2.;ENU=Insurance integration is not activated for %1 %2.';
      E055Err@1052 : TextConst '@@@=FA Error Entry No. field caption;DAN=m� ikke indtastes, n�r %1 er udfyldt.;ENU=must not be specified when %1 is specified.';
      E056Err@1053 : TextConst '@@@="%1=FA Posting Type";DAN=N�r finansintegration ikke er aktiv, m� %1 ikke bogf�res i finanskladden.;ENU=When G/L integration is not activated, %1 must not be posted in the general journal.';
      E057Err@1054 : TextConst '@@@="%1=Some field caption";DAN=N�r finansintegration ikke er aktiv, m� %1 ikke indtastes i finanskladden.;ENU=When G/L integration is not activated, %1 must not be specified in the general journal.';
      E058Err@1055 : TextConst '@@@="%1=Some field caption";DAN=%1 m� ikke indtastes.;ENU=%1 must not be specified.';
      E059Err@1056 : TextConst 'DAN=Kombinationen Kontotype Debitor og Bogf�ringstype K�b er ikke tilladt.;ENU=The combination of Customer and Gen. Posting Type Purchase is not allowed.';
      E060Err@1057 : TextConst 'DAN=Kombinationen Kontotype Kreditor og Bogf�ringstype Salg er ikke tilladt.;ENU=The combination of Vendor and Gen. Posting Type Sales is not allowed.';
      E061Err@1058 : TextConst 'DAN=Gentagelsesmetoderne Balance og Omvendt balance kan kun anvendes i forbindelse med fordelinger.;ENU=The Balance and Reversing Balance recurring methods can be used only with Allocations.';
      E062Err@1059 : TextConst '@@@="%1=Amount field caption";DAN=%1 m� ikke v�re 0.;ENU=%1 must not be 0.';
      E063Err@1123 : TextConst 'DAN=Dokument,Betaling,Faktura,Kreditnota,Rentenota,Rykker,Refusion;ENU=Document,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
      E064Err@1124 : TextConst '@@@="%1=External Document No. field caption;%2=External Document No.;%3=Line No.;%4=Document No. field caption;%5=Document No.";DAN=%1 %2 bruges allerede i linje %3 (%4 %5).;ENU=%1 %2 is already used in line %3 (%4 %5).';
      E065Err@1126 : TextConst '@@@="%1=Account Type;%2=Whether customer is blocked;%3=Document Type field caption;%4=Document Type";DAN=%1 m� ikke v�re sp�rret med typen %2, n�r %3 er %4;ENU=%1 must not be blocked with type %2 when %3 is %4';
      E066Err@1129 : TextConst '@@@="%1=Account No. field caption;%2=Bal. Account No. field caption";DAN=Du kan ikke angive finanskonto eller bankkonto i b�de %1 og %2.;ENU=You cannot enter G/L Account or Bank Account in both %1 and %2.';
      E067Err@1130 : TextConst '@@@="%1=Customer table caption;%2=Account No.%3=IC Partner table caption;%4=IC Partner Code";DAN=%1 %2 er knyttet til %3 %4.;ENU=%1 %2 is linked to %3 %4.';
      E069Err@1134 : TextConst '@@@="%1=IC Partner G/L Acc. No. field caption;%2=IC Direction field caption;%3=IC Direction format";DAN=%1 m� ikke angives, n�r %2 er %3.;ENU=%1 must not be specified when %2 is %3.';
      E070Err@1135 : TextConst '@@@="%1=IC Partner G/L Acc. No. field caption";DAN=%1 m� ikke angives, n�r dokumentet ikke er en intercompany-transaktion.;ENU=%1 must not be specified when the document is not an intercompany transaction.';
      USE001Lbl@3001 : TextConst 'DAN=Advarsel! Du kan ikke annullere og tilbagef�re checks, n�r Afstem pr. bilag er angivet til Nej i kladdeskabelonen.;ENU=Warning:  Checks cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.';
      USE002Lbl@3007 : TextConst '@@@="%1=Journal Template Name;%2=Journal Batch Name";DAN=Totaler for kladden %1, k�rsel %2;ENU=Totals for Journal %1, Batch %2';
      USE003Lbl@3008 : TextConst '@@@="%1=Document Type;%2=Document No.";DAN=Totale bel�b, %1 %2;ENU=Total Amount, %1 %2';
      Payment_Journal___Pre_Check_TestCaptionLbl@6726 : TextConst 'DAN=Betalingskladde - indledende test;ENU=Payment Journal - Pre-Check Test';
      CurrReport_PAGENOCaptionLbl@8565 : TextConst 'DAN=Side;ENU=Page';
      Gen__Journal_Batch__NameCaptionLbl@3422 : TextConst 'DAN=Kladdenavn;ENU=Journal Batch';
      Gen__Journal_Line__Document_Type_CaptionLbl@7853 : TextConst 'DAN=Type;ENU=Type';
      Gen__Journal_Line__Document_No__CaptionLbl@1464 : TextConst 'DAN=Nummer;ENU=Number';
      Gen__Journal_Line__Account_Type_CaptionLbl@5964 : TextConst 'DAN=Type;ENU=Type';
      Gen__Journal_Line__Account_No__CaptionLbl@5056 : TextConst 'DAN=Nummer;ENU=Number';
      Gen__Journal_Line__Bal__Account_No__CaptionLbl@6397 : TextConst 'DAN=Nummer;ENU=Number';
      Gen__Journal_Line__Bal__Account_Type_CaptionLbl@7222 : TextConst 'DAN=Type;ENU=Type';
      DocumentCaptionLbl@9873 : TextConst 'DAN=Bilag;ENU=Document';
      AccountCaptionLbl@7417 : TextConst 'DAN=Konto;ENU=Account';
      Bal__AccountCaptionLbl@8705 : TextConst 'DAN=Modkonto;ENU=Bal. Account';
      Description___CaptionLbl@4943 : TextConst 'DAN=Beskrivelse;ENU=Description';
      AmountDueCaptionLbl@1271 : TextConst 'DAN=ForfaldentBel�b;ENU=AmountDue';
      AmountDiscountedCaptionLbl@5877 : TextConst 'DAN=Kontantrabat;ENU=Payment Discount';
      AmountPmtDiscToleranceCaptionLbl@3372 : TextConst 'DAN=Kont.rabattolerance;ENU=Pmt. Discount Tolerance';
      AmountPmtToleranceCaptionLbl@1592 : TextConst 'DAN=Betalingstolerance;ENU=Payment Tolerance';
      Unapplied_AmountsCaptionLbl@5189 : TextConst 'DAN=Ikke-udlignede bel�b;ENU=Unapplied Amounts';
      ErrorText_Number_CaptionLbl@5070 : TextConst 'DAN=Advarsel!;ENU=Warning!';
      ReconciliationCaptionLbl@4137 : TextConst 'DAN=Afstemning;ENU=Reconciliation';
      GLAccNetChange__No__CaptionLbl@4841 : TextConst 'DAN=Nummer;ENU=No.';
      GLAccNetChange_NameCaptionLbl@3866 : TextConst 'DAN=Navn;ENU=Name';
      GLAccNetChange__Net_Change_in_Jnl__CaptionLbl@9374 : TextConst 'DAN=Bev�gelse i kladde;ENU=Net Change in Jnl.';
      GLAccNetChange__Balance_after_Posting_CaptionLbl@5926 : TextConst 'DAN=Saldo efter bogf�ring;ENU=Balance after Posting';
      GLSetup@1145 : Record 98;
      SalesSetup@1144 : Record 311;
      PurchSetup@1143 : Record 312;
      UserSetup@1142 : Record 91;
      AccountingPeriod@1141 : Record 50;
      GLAcc@1140 : Record 15;
      Currency@1139 : Record 4;
      Cust@1138 : Record 18;
      Vend@1137 : Record 23;
      BankAccPostingGr@1136 : Record 277;
      BankAcc@1133 : Record 270;
      GenJnlTemplate@1132 : Record 80;
      GenJnlLine2@1131 : Record 81;
      TempGenJnlLine@1128 : TEMPORARY Record 81;
      GenJnlAlloc@1127 : Record 221;
      OldCustLedgEntry@1125 : Record 21;
      OldVendLedgEntry@1122 : Record 25;
      VATPostingSetup@1121 : Record 325;
      NoSeries@1120 : Record 308;
      FA@1119 : Record 5600;
      ICPartner@1118 : Record 413;
      DeprBook@1117 : Record 5611;
      FADeprBook@1116 : Record 5612;
      FASetup@1115 : Record 5603;
      TempGLAccNetChange@1114 : TEMPORARY Record 269;
      CompanyInformation@1113 : Record 79;
      CurrExchRate@1112 : Record 330;
      GenJnlLineFilter@1110 : Text;
      AllowPostingFrom@1109 : Date;
      AllowPostingTo@1108 : Date;
      AllowFAPostingFrom@1107 : Date;
      AllowFAPostingTo@1106 : Date;
      LastDate@1105 : Date;
      LastDocType@1104 : 'Document,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder';
      LastDocNo@1103 : Code[20];
      LastEntrdDocNo@1102 : Code[20];
      LastEntrdDate@1101 : Date;
      DocBalance@1100 : Decimal;
      DocBalanceReverse@1099 : Decimal;
      DateBalance@1098 : Decimal;
      DateBalanceReverse@1097 : Decimal;
      TotalBalance@1096 : Decimal;
      TotalBalanceReverse@1095 : Decimal;
      AccName@1094 : Text[30];
      LastLineNo@1093 : Integer;
      Day@1092 : Integer;
      Week@1091 : Integer;
      Month@1090 : Integer;
      MonthText@1089 : Text[30];
      AmountError@1088 : Boolean;
      ErrorCounter@1087 : Integer;
      ErrorText@1086 : ARRAY [50] OF Text[250];
      TempErrorText@1085 : Text[250];
      BalAccName@1084 : Text[30];
      CustVendName@1083 : Text[50];
      CurrentCustomerVendors@1082 : Integer;
      VATEntryCreated@1081 : Boolean;
      CustPosting@1080 : Boolean;
      VendPosting@1079 : Boolean;
      SalesPostingType@1078 : Boolean;
      PurchPostingType@1077 : Boolean;
      CurrentICPartner@1076 : Code[20];
      AmountDiscounted@1075 : Decimal;
      AmountPmtTolerance@1074 : Decimal;
      AmountPmtDiscTolerance@1073 : Decimal;
      AmountDue@1072 : Decimal;
      AmountPaid@1071 : Decimal;
      TotalAmountDiscounted@1070 : Decimal;
      TotalAmountPmtTolerance@1069 : Decimal;
      TotalAmountPmtDiscTolerance@1068 : Decimal;
      AmountApplied@1067 : Decimal;
      TotalAmount@1066 : Decimal;
      ShowApplyToOutput@1065 : Boolean;
      AmountLcy@1064 : Decimal;
      LastDocumentNo@1063 : Code[20];
      AmountBalLcy@1062 : Decimal;
      TotalCustAmount@1061 : ARRAY [2] OF Decimal;
      TotalVendAmount@1060 : ARRAY [2] OF Decimal;
      Sign@1010 : ' ,Negative,Positive';

    LOCAL PROCEDURE CheckRecurringLine@5(GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO
        IF GenJnlTemplate.Recurring THEN BEGIN
          IF "Recurring Method" = 0 THEN
            AddError(STRSUBSTNO(E002Err,FIELDCAPTION("Recurring Method")));
          IF FORMAT("Recurring Frequency") = '' THEN
            AddError(STRSUBSTNO(E002Err,FIELDCAPTION("Recurring Frequency")));
          IF "Bal. Account No." <> '' THEN
            AddError(
              STRSUBSTNO(
                E019Err,
                FIELDCAPTION("Bal. Account No.")));
          CASE "Recurring Method" OF
            "Recurring Method"::"V  Variable","Recurring Method"::"RV Reversing Variable",
            "Recurring Method"::"F  Fixed","Recurring Method"::"RF Reversing Fixed":
              WarningIfZeroAmt("Gen. Journal Line");
            "Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance":
              WarningIfNonZeroAmt("Gen. Journal Line");
          END;
          IF "Recurring Method" > "Recurring Method"::"V  Variable" THEN BEGIN
            IF "Account Type" = "Account Type"::"Fixed Asset" THEN
              AddError(
                STRSUBSTNO(
                  E020Err,
                  FIELDCAPTION("Recurring Method"),"Recurring Method",
                  FIELDCAPTION("Account Type"),"Account Type"));
            IF "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" THEN
              AddError(
                STRSUBSTNO(
                  E020Err,
                  FIELDCAPTION("Recurring Method"),"Recurring Method",
                  FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));
          END;
        END ELSE BEGIN
          IF "Recurring Method" <> 0 THEN
            AddError(STRSUBSTNO(E009Err,FIELDCAPTION("Recurring Method")));
          IF FORMAT("Recurring Frequency") <> '' THEN
            AddError(STRSUBSTNO(E009Err,FIELDCAPTION("Recurring Frequency")));
        END;
    END;

    LOCAL PROCEDURE CheckAllocations@6(GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO BEGIN
        IF "Recurring Method" IN
           ["Recurring Method"::"B  Balance",
            "Recurring Method"::"RB Reversing Balance"]
        THEN BEGIN
          GenJnlAlloc.RESET;
          GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
          GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
          GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
          IF NOT GenJnlAlloc.FINDFIRST THEN
            AddError(E061Err);
        END;

        GenJnlAlloc.RESET;
        GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
        GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
        GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
        GenJnlAlloc.SETFILTER(Amount,'<>0');
        IF GenJnlAlloc.FINDFIRST THEN
          IF NOT GenJnlTemplate.Recurring THEN
            AddError(E021Err)
          ELSE BEGIN
            GenJnlAlloc.SETRANGE("Account No.",'');
            IF GenJnlAlloc.FINDFIRST THEN
              AddError(
                STRSUBSTNO(
                  E022Err,
                  GenJnlAlloc.FIELDCAPTION("Account No."),GenJnlAlloc.COUNT));
          END;
      END;
    END;

    LOCAL PROCEDURE MakeRecurringTexts@1(VAR GenJnlLine2@1000 : Record 81);
    BEGIN
      WITH GenJnlLine2 DO
        IF ("Posting Date" <> 0D) AND ("Account No." <> '') AND ("Recurring Method" <> 0) THEN BEGIN
          Day := DATE2DMY("Posting Date",1);
          Week := DATE2DWY("Posting Date",2);
          Month := DATE2DMY("Posting Date",2);
          MonthText := FORMAT("Posting Date",0,E023Err);
          AccountingPeriod.SETRANGE("Starting Date",0D,"Posting Date");
          IF NOT AccountingPeriod.FINDLAST THEN
            AccountingPeriod.Name := '';
          "Document No." :=
            DELCHR(
              PADSTR(
                STRSUBSTNO("Document No.",Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN("Document No.")),
              '>');
          Description :=
            DELCHR(
              PADSTR(
                STRSUBSTNO(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
                MAXSTRLEN(Description)),
              '>');
        END;
    END;

    LOCAL PROCEDURE CheckBalance@7();
    VAR
      GenJnlLine@1000 : Record 81;
      NextGenJnlLine@1001 : Record 81;
    BEGIN
      GenJnlLine := "Gen. Journal Line";
      LastLineNo := "Gen. Journal Line"."Line No.";
      IF "Gen. Journal Line".NEXT = 0 THEN;
      NextGenJnlLine := "Gen. Journal Line";
      MakeRecurringTexts(NextGenJnlLine);
      "Gen. Journal Line" := GenJnlLine;
      WITH GenJnlLine DO
        IF NOT EmptyLine THEN BEGIN
          DocBalance := DocBalance + "Balance (LCY)";
          DateBalance := DateBalance + "Balance (LCY)";
          TotalBalance := TotalBalance + "Balance (LCY)";
          IF "Recurring Method" >= "Recurring Method"::"RF Reversing Fixed" THEN BEGIN
            DocBalanceReverse := DocBalanceReverse + "Balance (LCY)";
            DateBalanceReverse := DateBalanceReverse + "Balance (LCY)";
            TotalBalanceReverse := TotalBalanceReverse + "Balance (LCY)";
          END;
          LastDocType := "Document Type";
          LastDocNo := "Document No.";
          LastDate := "Posting Date";
          IF TotalBalance = 0 THEN BEGIN
            CurrentCustomerVendors := 0;
            VATEntryCreated := FALSE;
          END;
          IF GenJnlTemplate."Force Doc. Balance" THEN BEGIN
            VATEntryCreated :=
              VATEntryCreated OR
              (("Account Type" = "Account Type"::"G/L Account") AND ("Account No." <> '') AND
               ("Gen. Posting Type" IN ["Gen. Posting Type"::Purchase,"Gen. Posting Type"::Sale])) OR
              (("Bal. Account Type" = "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '') AND
               ("Bal. Gen. Posting Type" IN ["Bal. Gen. Posting Type"::Purchase,"Bal. Gen. Posting Type"::Sale]));
            IF (("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) AND
                ("Account No." <> '')) OR
               (("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]) AND
                ("Bal. Account No." <> ''))
            THEN
              CurrentCustomerVendors := CurrentCustomerVendors + 1;
            IF (CurrentCustomerVendors > 1) AND VATEntryCreated THEN
              AddError(
                STRSUBSTNO(
                  E024Err,
                  "Document Type","Document No.","Posting Date"));
          END;
        END;

      WITH NextGenJnlLine DO BEGIN
        IF (LastDate <> 0D) AND (LastDocNo <> '') AND
           (("Posting Date" <> LastDate) OR
            ("Document Type" <> LastDocType) OR
            ("Document No." <> LastDocNo) OR
            ("Line No." = LastLineNo))
        THEN BEGIN
          IF GenJnlTemplate."Force Doc. Balance" THEN BEGIN
            CASE TRUE OF
              DocBalance <> 0:
                AddError(
                  STRSUBSTNO(
                    E025Err,
                    SELECTSTR(LastDocType + 1,E063Err),LastDocNo,DocBalance));
              DocBalanceReverse <> 0:
                AddError(
                  STRSUBSTNO(
                    E026Err,
                    SELECTSTR(LastDocType + 1,E063Err),LastDocNo,DocBalanceReverse));
            END;
            DocBalance := 0;
            DocBalanceReverse := 0;
          END;
          IF ("Posting Date" <> LastDate) OR
             ("Document Type" <> LastDocType) OR ("Document No." <> LastDocNo)
          THEN BEGIN
            CurrentCustomerVendors := 0;
            VATEntryCreated := FALSE;
            CustPosting := FALSE;
            VendPosting := FALSE;
            SalesPostingType := FALSE;
            PurchPostingType := FALSE;
          END;
        END;

        IF (LastDate <> 0D) AND (("Posting Date" <> LastDate) OR ("Line No." = LastLineNo)) THEN BEGIN
          CASE TRUE OF
            DateBalance <> 0:
              AddError(
                STRSUBSTNO(
                  E027Err,
                  LastDate,DateBalance));
            DateBalanceReverse <> 0:
              AddError(
                STRSUBSTNO(
                  E028Err,
                  LastDate,DateBalanceReverse));
          END;
          DocBalance := 0;
          DocBalanceReverse := 0;
          DateBalance := 0;
          DateBalanceReverse := 0;
        END;

        IF "Line No." = LastLineNo THEN BEGIN
          CASE TRUE OF
            TotalBalance <> 0:
              AddError(
                STRSUBSTNO(
                  E029Err,
                  TotalBalance));
            TotalBalanceReverse <> 0:
              AddError(
                STRSUBSTNO(
                  E030Err,
                  TotalBalanceReverse));
          END;
          DocBalance := 0;
          DocBalanceReverse := 0;
          DateBalance := 0;
          DateBalanceReverse := 0;
          TotalBalance := 0;
          TotalBalanceReverse := 0;
          LastDate := 0D;
          LastDocType := 0;
          LastDocNo := '';
        END;
      END;
    END;

    LOCAL PROCEDURE AddError@2(Text@1000 : Text[250]);
    BEGIN
      ErrorCounter := ErrorCounter + 1;
      ErrorText[ErrorCounter] := Text;
    END;

    LOCAL PROCEDURE AddConditionalError@18(Condition@1000 : Boolean;Text@1001 : Text[250]);
    BEGIN
      IF Condition THEN
        AddError(Text);
    END;

    LOCAL PROCEDURE ReconcileGLAccNo@8(GLAccNo@1000 : Code[20];ReconcileAmount@1001 : Decimal);
    BEGIN
      IF NOT TempGLAccNetChange.GET(GLAccNo) THEN BEGIN
        GLAcc.GET(GLAccNo);
        GLAcc.CALCFIELDS("Balance at Date");
        TempGLAccNetChange.INIT;
        TempGLAccNetChange."No." := GLAcc."No.";
        TempGLAccNetChange.Name := GLAcc.Name;
        TempGLAccNetChange."Balance after Posting" := GLAcc."Balance at Date";
        TempGLAccNetChange.INSERT;
      END;
      TempGLAccNetChange."Net Change in Jnl." := TempGLAccNetChange."Net Change in Jnl." + ReconcileAmount;
      TempGLAccNetChange."Balance after Posting" := TempGLAccNetChange."Balance after Posting" + ReconcileAmount;
      TempGLAccNetChange.MODIFY;
    END;

    LOCAL PROCEDURE CheckGLAcc@4(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT GLAcc.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              E031Err,
              GLAcc.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := GLAcc.Name;

          IF GLAcc.Blocked THEN
            AddError(
              STRSUBSTNO(
                E032Err,
                GLAcc.FIELDCAPTION(Blocked),FALSE,GLAcc.TABLECAPTION,"Account No."));
          IF GLAcc."Account Type" <> GLAcc."Account Type"::Posting THEN BEGIN
            GLAcc."Account Type" := GLAcc."Account Type"::Posting;
            AddError(
              STRSUBSTNO(
                E032Err,
                GLAcc.FIELDCAPTION("Account Type"),GLAcc."Account Type",GLAcc.TABLECAPTION,"Account No."));
          END;
          IF NOT "System-Created Entry" THEN
            IF "Posting Date" = NORMALDATE("Posting Date") THEN
              IF NOT GLAcc."Direct Posting" THEN
                AddError(
                  STRSUBSTNO(
                    E032Err,
                    GLAcc.FIELDCAPTION("Direct Posting"),TRUE,GLAcc.TABLECAPTION,"Account No."));

          IF "Gen. Posting Type" > 0 THEN BEGIN
            CASE "Gen. Posting Type" OF
              "Gen. Posting Type"::Sale:
                SalesPostingType := TRUE;
              "Gen. Posting Type"::Purchase:
                PurchPostingType := TRUE;
            END;
            TestPostingType;

            IF NOT VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
              AddError(
                STRSUBSTNO(
                  E036Err,
                  VATPostingSetup.TABLECAPTION,"VAT Bus. Posting Group","VAT Prod. Posting Group"))
            ELSE
              IF "VAT Calculation Type" <> VATPostingSetup."VAT Calculation Type" THEN
                AddError(
                  STRSUBSTNO(
                    E037Err,
                    FIELDCAPTION("VAT Calculation Type"),VATPostingSetup."VAT Calculation Type"))
          END;

          IF GLAcc."Reconciliation Account" THEN
            ReconcileGLAccNo("Account No.",ROUND("Amount (LCY)" / (1 + "VAT %" / 100)));
        END;
    END;

    LOCAL PROCEDURE CheckCust@9(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT Cust.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              E031Err,
              Cust.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := Cust.Name;
          IF Cust."Privacy Blocked" THEN
            AddError(Cust.GetPrivacyBlockedGenericErrorText(Cust));
          IF ((Cust.Blocked = Cust.Blocked::All) OR
              ((Cust.Blocked IN [Cust.Blocked::Invoice,Cust.Blocked::Ship]) AND
               ("Document Type" IN ["Document Type"::Invoice,"Document Type"::" "]))
              )
          THEN
            AddError(
              STRSUBSTNO(
                E065Err,
                "Account Type",Cust.Blocked,FIELDCAPTION("Document Type"),"Document Type"));
          IF "Currency Code" <> '' THEN
            IF NOT Currency.GET("Currency Code") THEN
              AddError(
                STRSUBSTNO(
                  E038Err,
                  "Currency Code"));
          IF (Cust."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) THEN
            IF ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
              IF ICPartner.Blocked THEN
                AddError(
                  STRSUBSTNO(
                    '%1 %2',
                    STRSUBSTNO(
                      E067Err,
                      Cust.TABLECAPTION,"Account No.",ICPartner.TABLECAPTION,"IC Partner Code"),
                    STRSUBSTNO(
                      E032Err,
                      ICPartner.FIELDCAPTION(Blocked),FALSE,ICPartner.TABLECAPTION,Cust."IC Partner Code")));
            END ELSE
              AddError(
                STRSUBSTNO(
                  '%1 %2',
                  STRSUBSTNO(
                    E067Err,
                    Cust.TABLECAPTION,"Account No.",ICPartner.TABLECAPTION,Cust."IC Partner Code"),
                  STRSUBSTNO(
                    E031Err,
                    ICPartner.TABLECAPTION,Cust."IC Partner Code")));
          CustPosting := TRUE;
          TestPostingType;

          IF "Recurring Method" = 0 THEN
            IF "Document Type" IN
               ["Document Type"::Invoice,"Document Type"::"Credit Memo",
                "Document Type"::"Finance Charge Memo","Document Type"::Reminder]
            THEN BEGIN
              OldCustLedgEntry.RESET;
              OldCustLedgEntry.SETCURRENTKEY("Document No.","Document Type","Customer No.");
              OldCustLedgEntry.SETRANGE("Document Type","Document Type");
              OldCustLedgEntry.SETRANGE("Document No.","Document No.");
              IF OldCustLedgEntry.FINDFIRST THEN
                AddError(
                  STRSUBSTNO(
                    E039Err,"Document Type","Document No."));

              IF SalesSetup."Ext. Doc. No. Mandatory" OR
                 ("External Document No." <> '')
              THEN BEGIN
                IF "External Document No." = '' THEN
                  AddError(
                    STRSUBSTNO(
                      E041Err,FIELDCAPTION("External Document No.")));

                OldCustLedgEntry.RESET;
                OldCustLedgEntry.SETCURRENTKEY("Document Type","External Document No.","Customer No.");
                OldCustLedgEntry.SETRANGE("Document Type","Document Type");
                OldCustLedgEntry.SETRANGE("Customer No.","Account No.");
                OldCustLedgEntry.SETRANGE("External Document No.","External Document No.");
                IF OldCustLedgEntry.FINDFIRST THEN
                  AddError(
                    STRSUBSTNO(
                      E039Err,
                      "Document Type","External Document No."));
                CheckAgainstPrevLines("Gen. Journal Line");
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE CheckVend@10(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT Vend.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              E031Err,
              Vend.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := Vend.Name;

          IF Vend."Privacy Blocked" THEN
            AddError(Vend.GetPrivacyBlockedGenericErrorText(Vend));

          IF ((Vend.Blocked = Vend.Blocked::All) OR
              ((Vend.Blocked = Vend.Blocked::Payment) AND ("Document Type" = "Document Type"::Payment))
              )
          THEN
            AddError(
              STRSUBSTNO(
                E065Err,
                "Account Type",Vend.Blocked,FIELDCAPTION("Document Type"),"Document Type"));

          IF "Currency Code" <> '' THEN
            IF NOT Currency.GET("Currency Code") THEN
              AddError(
                STRSUBSTNO(
                  E038Err,
                  "Currency Code"));

          IF (Vend."IC Partner Code" <> '') AND (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) THEN
            IF ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
              IF ICPartner.Blocked THEN
                AddError(
                  STRSUBSTNO(
                    '%1 %2',
                    STRSUBSTNO(
                      E067Err,
                      Vend.TABLECAPTION,"Account No.",ICPartner.TABLECAPTION,Vend."IC Partner Code"),
                    STRSUBSTNO(
                      E032Err,
                      ICPartner.FIELDCAPTION(Blocked),FALSE,ICPartner.TABLECAPTION,Vend."IC Partner Code")));
            END ELSE
              AddError(
                STRSUBSTNO(
                  '%1 %2',
                  STRSUBSTNO(
                    E067Err,
                    Vend.TABLECAPTION,"Account No.",ICPartner.TABLECAPTION,"IC Partner Code"),
                  STRSUBSTNO(
                    E031Err,
                    ICPartner.TABLECAPTION,Vend."IC Partner Code")));
          VendPosting := TRUE;
          TestPostingType;

          IF "Recurring Method" = 0 THEN
            IF "Document Type" IN
               ["Document Type"::Invoice,"Document Type"::"Credit Memo",
                "Document Type"::"Finance Charge Memo","Document Type"::Reminder]
            THEN BEGIN
              OldVendLedgEntry.RESET;
              OldVendLedgEntry.SETCURRENTKEY("Document No.","Document Type","Vendor No.");
              OldVendLedgEntry.SETRANGE("Document Type","Document Type");
              OldVendLedgEntry.SETRANGE("Document No.","Document No.");
              IF OldVendLedgEntry.FINDFIRST THEN
                AddError(
                  STRSUBSTNO(
                    E040Err,
                    "Document Type","Document No."));

              IF PurchSetup."Ext. Doc. No. Mandatory" OR
                 ("External Document No." <> '')
              THEN BEGIN
                IF "External Document No." = '' THEN
                  AddError(
                    STRSUBSTNO(
                      E041Err,FIELDCAPTION("External Document No.")));

                OldVendLedgEntry.RESET;
                OldVendLedgEntry.SETCURRENTKEY("External Document No.","Document Type","Vendor No.");
                OldVendLedgEntry.SETRANGE("Document Type","Document Type");
                OldVendLedgEntry.SETRANGE("Vendor No.","Account No.");
                OldVendLedgEntry.SETRANGE("External Document No.","External Document No.");
                IF OldVendLedgEntry.FINDFIRST THEN
                  AddError(
                    STRSUBSTNO(
                      E040Err,
                      "Document Type","External Document No."));
                CheckAgainstPrevLines("Gen. Journal Line");
              END;
            END;
        END;
    END;

    LOCAL PROCEDURE CheckBankAcc@11(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT BankAcc.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              E031Err,
              BankAcc.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := BankAcc.Name;

          IF BankAcc.Blocked THEN
            AddError(
              STRSUBSTNO(
                E032Err,
                BankAcc.FIELDCAPTION(Blocked),FALSE,BankAcc.TABLECAPTION,"Account No."));
          IF ("Currency Code" <> BankAcc."Currency Code") AND (BankAcc."Currency Code" <> '') THEN
            AddError(
              STRSUBSTNO(
                E037Err,
                FIELDCAPTION("Currency Code"),BankAcc."Currency Code"));

          IF "Currency Code" <> '' THEN
            IF NOT Currency.GET("Currency Code") THEN
              AddError(
                STRSUBSTNO(
                  E038Err,
                  "Currency Code"));

          IF "Bank Payment Type" <> 0 THEN
            IF ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") AND (Amount < 0) THEN
              IF BankAcc."Currency Code" <> "Currency Code" THEN
                AddError(
                  STRSUBSTNO(
                    E042Err,
                    FIELDCAPTION("Bank Payment Type"),FIELDCAPTION("Currency Code"),
                    TABLECAPTION,BankAcc.TABLECAPTION));

          IF BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group") THEN
            IF BankAccPostingGr."G/L Bank Account No." <> '' THEN
              ReconcileGLAccNo(
                BankAccPostingGr."G/L Bank Account No.",
                ROUND("Amount (LCY)" / (1 + "VAT %" / 100)));
        END;
    END;

    LOCAL PROCEDURE CheckFixedAsset@23(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT FA.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              E031Err,
              FA.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := FA.Description;
          IF FA.Blocked THEN
            AddError(
              STRSUBSTNO(
                E032Err,
                FA.FIELDCAPTION(Blocked),FALSE,FA.TABLECAPTION,"Account No."));
          IF FA.Inactive THEN
            AddError(
              STRSUBSTNO(
                E032Err,
                FA.FIELDCAPTION(Inactive),FALSE,FA.TABLECAPTION,"Account No."));
          IF FA."Budgeted Asset" THEN
            AddError(
              STRSUBSTNO(
                E043Err,
                FA.TABLECAPTION,"Account No.",FA.FIELDCAPTION("Budgeted Asset"),TRUE));
          IF DeprBook.GET("Depreciation Book Code") THEN
            CheckFAIntegration(GenJnlLine)
          ELSE
            AddError(
              STRSUBSTNO(
                E031Err,
                DeprBook.TABLECAPTION,"Depreciation Book Code"));
          IF NOT FADeprBook.GET(FA."No.","Depreciation Book Code") THEN
            AddError(
              STRSUBSTNO(
                E036Err,
                FADeprBook.TABLECAPTION,FA."No.","Depreciation Book Code"));
        END;
    END;

    PROCEDURE CheckICPartner@26(VAR GenJnlLine@1000 : Record 81;VAR AccName@1001 : Text[50]);
    BEGIN
      WITH GenJnlLine DO
        IF NOT ICPartner.GET("Account No.") THEN
          AddError(
            STRSUBSTNO(
              E031Err,
              ICPartner.TABLECAPTION,"Account No."))
        ELSE BEGIN
          AccName := ICPartner.Name;
          IF ICPartner.Blocked THEN
            AddError(
              STRSUBSTNO(
                E032Err,
                ICPartner.FIELDCAPTION(Blocked),FALSE,ICPartner.TABLECAPTION,"Account No."));
        END;
    END;

    LOCAL PROCEDURE TestFixedAsset@13(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      WITH GenJnlLine DO BEGIN
        CASE TRUE OF
          "Job No." <> '':
            AddError(STRSUBSTNO(E044Err,FIELDCAPTION("Job No.")));
          "FA Posting Type" = "FA Posting Type"::" ":
            AddError(STRSUBSTNO(E045Err,FIELDCAPTION("FA Posting Type")));
          "Depreciation Book Code" = '':
            AddError(STRSUBSTNO(E045Err,FIELDCAPTION("Depreciation Book Code")));
          "Depreciation Book Code" = "Duplicate in Depreciation Book":
            AddError(
              STRSUBSTNO(
                E046Err,FIELDCAPTION("Depreciation Book Code"),FIELDCAPTION("Duplicate in Depreciation Book")));
          "Account Type" = "Bal. Account Type":
            AddError(
              STRSUBSTNO(E047Err,FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"),"Account Type"));
        END;
        IF "Account Type" = "Account Type"::"Fixed Asset" THEN
          IF "FA Posting Type" IN
             ["FA Posting Type"::"Acquisition Cost","FA Posting Type"::Disposal,"FA Posting Type"::Maintenance]
          THEN BEGIN
            IF (("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '')) AND
               ("Gen. Posting Type" = "Gen. Posting Type"::" ")
            THEN
              AddError(STRSUBSTNO(E002Err,FIELDCAPTION("Gen. Posting Type")));
          END ELSE BEGIN
            AddConditionalError(
              "Gen. Posting Type" <> "Gen. Posting Type"::" ",
              STRSUBSTNO(
                E048Err,
                FIELDCAPTION("Gen. Posting Type"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
            AddConditionalError(
              "Gen. Bus. Posting Group" <> '',
              STRSUBSTNO(
                E049Err,
                FIELDCAPTION("Gen. Bus. Posting Group"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
            AddConditionalError(
              "Gen. Prod. Posting Group" <> '',
              STRSUBSTNO(
                E049Err,
                FIELDCAPTION("Gen. Prod. Posting Group"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
          END;
        IF "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" THEN
          IF "FA Posting Type" IN
             ["FA Posting Type"::"Acquisition Cost","FA Posting Type"::Disposal,"FA Posting Type"::Maintenance]
          THEN BEGIN
            IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') THEN
              IF "Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::" " THEN
                AddError(STRSUBSTNO(E002Err,FIELDCAPTION("Bal. Gen. Posting Type")));
          END ELSE BEGIN
            AddConditionalError(
              "Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ",
              STRSUBSTNO(
                E049Err,
                FIELDCAPTION("Bal. Gen. Posting Type"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
            AddConditionalError(
              "Bal. Gen. Bus. Posting Group" <> '',
              STRSUBSTNO(
                E049Err,
                FIELDCAPTION("Bal. Gen. Bus. Posting Group"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
            AddConditionalError(
              "Bal. Gen. Prod. Posting Group" <> '',
              STRSUBSTNO(
                E049Err,
                FIELDCAPTION("Bal. Gen. Prod. Posting Group"),FIELDCAPTION("FA Posting Type"),"FA Posting Type"));
          END;
        TempErrorText := '%1 ' + STRSUBSTNO(E050Err,FIELDCAPTION("FA Posting Type"),"FA Posting Type");
        IF "FA Posting Type" <> "FA Posting Type"::"Acquisition Cost" THEN BEGIN
          AddConditionalError("Depr. Acquisition Cost",STRSUBSTNO(TempErrorText,FIELDCAPTION("Depr. Acquisition Cost")));
          AddConditionalError("Salvage Value" <> 0,STRSUBSTNO(TempErrorText,FIELDCAPTION("Salvage Value")));
          AddConditionalError(
            ("FA Posting Type" <> "FA Posting Type"::Maintenance) AND (Quantity <> 0),
            STRSUBSTNO(TempErrorText,FIELDCAPTION(Quantity)));
          AddConditionalError("Insurance No." <> '',STRSUBSTNO(TempErrorText,FIELDCAPTION("Insurance No.")));
        END;
        IF ("FA Posting Type" = "FA Posting Type"::Maintenance) AND "Depr. until FA Posting Date" THEN
          AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Depr. until FA Posting Date")));
        IF ("FA Posting Type" <> "FA Posting Type"::Maintenance) AND ("Maintenance Code" <> '') THEN
          AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("Maintenance Code")));

        IF ("FA Posting Type" <> "FA Posting Type"::Depreciation) AND
           ("FA Posting Type" <> "FA Posting Type"::"Custom 1") AND
           ("No. of Depreciation Days" <> 0)
        THEN
          AddError(STRSUBSTNO(TempErrorText,FIELDCAPTION("No. of Depreciation Days")));

        IF "FA Posting Type" = "FA Posting Type"::Disposal THEN BEGIN
          AddConditionalError("FA Reclassification Entry",STRSUBSTNO(TempErrorText,FIELDCAPTION("FA Reclassification Entry")));
          AddConditionalError("Budgeted FA No." <> '',STRSUBSTNO(TempErrorText,FIELDCAPTION("Budgeted FA No.")));
        END;

        IF "FA Posting Date" = 0D THEN
          "FA Posting Date" := "Posting Date";
        IF DeprBook.GET("Depreciation Book Code") AND
           DeprBook."Use Same FA+G/L Posting Dates" AND
           ("Posting Date" <> "FA Posting Date")
        THEN
          AddError(STRSUBSTNO(E051Err,FIELDCAPTION("Posting Date"),FIELDCAPTION("FA Posting Date")));
        IF "FA Posting Date" <> 0D THEN BEGIN
          AddConditionalError("FA Posting Date" <> NORMALDATE("FA Posting Date"),STRSUBSTNO(E052Err,FIELDCAPTION("FA Posting Date")));
          AddConditionalError(
            NOT ("FA Posting Date" IN [DMY2DATE(1,1,1)..DMY2DATE(31,12,9998)]),STRSUBSTNO(E053Err,FIELDCAPTION("FA Posting Date")));
          IF (AllowFAPostingFrom = 0D) AND (AllowFAPostingTo = 0D) THEN BEGIN
            IF USERID <> '' THEN
              IF UserSetup.GET(USERID) THEN BEGIN
                AllowFAPostingFrom := UserSetup."Allow FA Posting From";
                AllowFAPostingTo := UserSetup."Allow FA Posting To";
              END;
            IF (AllowFAPostingFrom = 0D) AND (AllowFAPostingTo = 0D) THEN BEGIN
              FASetup.GET;
              AllowFAPostingFrom := FASetup."Allow FA Posting From";
              AllowFAPostingTo := FASetup."Allow FA Posting To";
            END;
            IF AllowFAPostingTo = 0D THEN
              AllowFAPostingTo := DMY2DATE(31,12,9999);
          END;
          AddConditionalError(
            ("FA Posting Date" < AllowFAPostingFrom) OR
            ("FA Posting Date" > AllowFAPostingTo),
            STRSUBSTNO(E053Err,FIELDCAPTION("FA Posting Date")));
        END;
        FASetup.GET;
        IF ("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") AND
           ("Insurance No." <> '') AND ("Depreciation Book Code" <> FASetup."Insurance Depr. Book")
        THEN
          AddError(STRSUBSTNO(E054Err,FIELDCAPTION("Depreciation Book Code"),"Depreciation Book Code"));

        IF "FA Error Entry No." > 0 THEN BEGIN
          TempErrorText := '%1 ' + STRSUBSTNO(E055Err,FIELDCAPTION("FA Error Entry No."));
          AddConditionalError("Depr. until FA Posting Date",STRSUBSTNO(TempErrorText,FIELDCAPTION("Depr. until FA Posting Date")));
          AddConditionalError("Depr. Acquisition Cost",STRSUBSTNO(TempErrorText,FIELDCAPTION("Depr. Acquisition Cost")));
          AddConditionalError(
            "Duplicate in Depreciation Book" <> '',
            STRSUBSTNO(TempErrorText,FIELDCAPTION("Duplicate in Depreciation Book")));
          AddConditionalError("Use Duplication List",STRSUBSTNO(TempErrorText,FIELDCAPTION("Use Duplication List")));
          AddConditionalError("Salvage Value" <> 0,STRSUBSTNO(TempErrorText,FIELDCAPTION("Salvage Value")));
          AddConditionalError("Insurance No." <> '',STRSUBSTNO(TempErrorText,FIELDCAPTION("Insurance No.")));
          AddConditionalError("Budgeted FA No." <> '',STRSUBSTNO(TempErrorText,FIELDCAPTION("Budgeted FA No.")));
          AddConditionalError("Recurring Method" > 0,STRSUBSTNO(TempErrorText,FIELDCAPTION("Recurring Method")));
          AddConditionalError("FA Posting Type" = "FA Posting Type"::Maintenance,STRSUBSTNO(TempErrorText,"FA Posting Type"));
        END;
      END;
    END;

    LOCAL PROCEDURE CheckFAIntegration@12(VAR GenJnlLine@1000 : Record 81);
    VAR
      GLIntegration@1001 : Boolean;
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF "FA Posting Type" = "FA Posting Type"::" " THEN
          EXIT;
        CASE "FA Posting Type" OF
          "FA Posting Type"::"Acquisition Cost":
            GLIntegration := DeprBook."G/L Integration - Acq. Cost";
          "FA Posting Type"::Depreciation:
            GLIntegration := DeprBook."G/L Integration - Depreciation";
          "FA Posting Type"::"Write-Down":
            GLIntegration := DeprBook."G/L Integration - Write-Down";
          "FA Posting Type"::Appreciation:
            GLIntegration := DeprBook."G/L Integration - Appreciation";
          "FA Posting Type"::"Custom 1":
            GLIntegration := DeprBook."G/L Integration - Custom 1";
          "FA Posting Type"::"Custom 2":
            GLIntegration := DeprBook."G/L Integration - Custom 2";
          "FA Posting Type"::Disposal:
            GLIntegration := DeprBook."G/L Integration - Disposal";
          "FA Posting Type"::Maintenance:
            GLIntegration := DeprBook."G/L Integration - Maintenance";
        END;
        IF NOT GLIntegration THEN
          AddError(
            STRSUBSTNO(
              E056Err,
              "FA Posting Type"));

        IF NOT DeprBook."G/L Integration - Depreciation" THEN BEGIN
          IF "Depr. until FA Posting Date" THEN
            AddError(
              STRSUBSTNO(
                E057Err,
                FIELDCAPTION("Depr. until FA Posting Date")));
          IF "Depr. Acquisition Cost" THEN
            AddError(
              STRSUBSTNO(
                E057Err,
                FIELDCAPTION("Depr. Acquisition Cost")));
        END;
      END;
    END;

    LOCAL PROCEDURE TestFixedAssetFields@14(VAR GenJnlLine@1000 : Record 81);
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF "FA Posting Type" <> "FA Posting Type"::" " THEN
          AddError(STRSUBSTNO(E058Err,FIELDCAPTION("FA Posting Type")));
        IF "Depreciation Book Code" <> '' THEN
          AddError(STRSUBSTNO(E058Err,FIELDCAPTION("Depreciation Book Code")));
      END;
    END;

    PROCEDURE TestPostingType@15();
    BEGIN
      CASE TRUE OF
        CustPosting AND PurchPostingType:
          AddError(E059Err);
        VendPosting AND SalesPostingType:
          AddError(E060Err);
      END;
    END;

    LOCAL PROCEDURE WarningIfNegativeAmt@3(GenJnlLine@1000 : Record 81);
    BEGIN
      IF (GenJnlLine.Amount < 0) AND NOT AmountError THEN BEGIN
        AmountError := TRUE;
        AddError(STRSUBSTNO(E007Err,GenJnlLine.FIELDCAPTION(Amount)));
      END;
    END;

    LOCAL PROCEDURE WarningIfPositiveAmt@16(GenJnlLine@1000 : Record 81);
    BEGIN
      IF (GenJnlLine.Amount > 0) AND NOT AmountError THEN BEGIN
        AmountError := TRUE;
        AddError(STRSUBSTNO(E006Err,GenJnlLine.FIELDCAPTION(Amount)));
      END;
    END;

    LOCAL PROCEDURE WarningIfZeroAmt@22(GenJnlLine@1000 : Record 81);
    BEGIN
      IF (GenJnlLine.Amount = 0) AND NOT AmountError THEN BEGIN
        AmountError := TRUE;
        AddError(STRSUBSTNO(E002Err,GenJnlLine.FIELDCAPTION(Amount)));
      END;
    END;

    LOCAL PROCEDURE WarningIfNonZeroAmt@24(GenJnlLine@1000 : Record 81);
    BEGIN
      IF (GenJnlLine.Amount <> 0) AND NOT AmountError THEN BEGIN
        AmountError := TRUE;
        AddError(STRSUBSTNO(E062Err,GenJnlLine.FIELDCAPTION(Amount)));
      END;
    END;

    LOCAL PROCEDURE CheckAgainstPrevLines@20(GenJnlLine@1000 : Record 81);
    VAR
      i@1001 : Integer;
      AccType@1002 : Integer;
      AccNo@1003 : Code[20];
      ErrorFound@1004 : Boolean;
    BEGIN
      IF (GenJnlLine."External Document No." = '') OR
         NOT (GenJnlLine."Account Type" IN
              [GenJnlLine."Account Type"::Customer,GenJnlLine."Account Type"::Vendor]) AND
         NOT (GenJnlLine."Bal. Account Type" IN
              [GenJnlLine."Bal. Account Type"::Customer,GenJnlLine."Bal. Account Type"::Vendor])
      THEN
        EXIT;

      IF GenJnlLine."Account Type" IN [GenJnlLine."Account Type"::Customer,GenJnlLine."Account Type"::Vendor] THEN BEGIN
        AccType := GenJnlLine."Account Type";
        AccNo := GenJnlLine."Account No.";
      END ELSE BEGIN
        AccType := GenJnlLine."Bal. Account Type";
        AccNo := GenJnlLine."Bal. Account No.";
      END;

      TempGenJnlLine.RESET;
      TempGenJnlLine.SETRANGE("External Document No.",GenJnlLine."External Document No.");

      WHILE (i < 2) AND NOT ErrorFound DO BEGIN
        i := i + 1;
        IF i = 1 THEN BEGIN
          TempGenJnlLine.SETRANGE("Account Type",AccType);
          TempGenJnlLine.SETRANGE("Account No.",AccNo);
          TempGenJnlLine.SETRANGE("Bal. Account Type");
          TempGenJnlLine.SETRANGE("Bal. Account No.");
        END ELSE BEGIN
          TempGenJnlLine.SETRANGE("Account Type");
          TempGenJnlLine.SETRANGE("Account No.");
          TempGenJnlLine.SETRANGE("Bal. Account Type",AccType);
          TempGenJnlLine.SETRANGE("Bal. Account No.",AccNo);
        END;
        IF TempGenJnlLine.FINDFIRST THEN BEGIN
          ErrorFound := TRUE;
          AddError(
            STRSUBSTNO(
              E064Err,GenJnlLine.FIELDCAPTION("External Document No."),GenJnlLine."External Document No.",
              TempGenJnlLine."Line No.",GenJnlLine.FIELDCAPTION("Document No."),TempGenJnlLine."Document No."));
        END;
      END;

      TempGenJnlLine.RESET;
      TempGenJnlLine := GenJnlLine;
      TempGenJnlLine.INSERT;
    END;

    PROCEDURE CheckICDocument@17();
    VAR
      GenJnlLine4@1000 : Record 81;
      ICGLAccount@1001 : Record 410;
    BEGIN
      WITH "Gen. Journal Line" DO
        IF GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany THEN BEGIN
          IF ("Posting Date" <> LastDate) OR ("Document Type" <> LastDocType) OR ("Document No." <> LastDocNo) THEN BEGIN
            GenJnlLine4.SETCURRENTKEY("Journal Template Name","Journal Batch Name","Posting Date","Document No.");
            GenJnlLine4.SETRANGE("Journal Template Name","Journal Template Name");
            GenJnlLine4.SETRANGE("Journal Batch Name","Journal Batch Name");
            GenJnlLine4.SETRANGE("Posting Date","Posting Date");
            GenJnlLine4.SETRANGE("Document No.","Document No.");
            GenJnlLine4.SETFILTER("IC Partner Code",'<>%1','');
            IF GenJnlLine4.FINDFIRST THEN
              CurrentICPartner := GenJnlLine4."IC Partner Code"
            ELSE
              CurrentICPartner := '';
          END;
          IF (CurrentICPartner <> '') AND ("IC Direction" = "IC Direction"::Outgoing) THEN
            IF ("Account Type" IN ["Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND
               ("Bal. Account Type" IN ["Bal. Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND
               ("Account No." <> '') AND
               ("Bal. Account No." <> '')
            THEN
              AddError(
                STRSUBSTNO(
                  E066Err,FIELDCAPTION("Account No."),FIELDCAPTION("Bal. Account No.")))
            ELSE BEGIN
              IF (("Account Type" IN ["Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND ("Account No." <> '')) XOR
                 (("Bal. Account Type" IN ["Bal. Account Type"::"G/L Account","Account Type"::"Bank Account"]) AND
                  ("Bal. Account No." <> ''))
              THEN
                IF "IC Partner G/L Acc. No." = '' THEN
                  AddError(
                    STRSUBSTNO(
                      E002Err,FIELDCAPTION("IC Partner G/L Acc. No.")))
                ELSE BEGIN
                  IF ICGLAccount.GET("IC Partner G/L Acc. No.") THEN
                    IF ICGLAccount.Blocked THEN
                      AddError(
                        STRSUBSTNO(
                          E032Err,
                          ICGLAccount.FIELDCAPTION(Blocked),FALSE,FIELDCAPTION("IC Partner G/L Acc. No."),
                          "IC Partner G/L Acc. No."
                          ));
                END
              ELSE
                IF "IC Partner G/L Acc. No." <> '' THEN
                  AddError(
                    STRSUBSTNO(
                      E009Err,FIELDCAPTION("IC Partner G/L Acc. No.")));
            END
          ELSE
            IF "IC Partner G/L Acc. No." <> '' THEN BEGIN
              IF "IC Direction" = "IC Direction"::Incoming THEN
                AddError(
                  STRSUBSTNO(
                    E069Err,FIELDCAPTION("IC Partner G/L Acc. No."),FIELDCAPTION("IC Direction"),FORMAT("IC Direction")));
              IF CurrentICPartner = '' THEN
                AddError(
                  STRSUBSTNO(
                    E070Err,FIELDCAPTION("IC Partner G/L Acc. No.")));
            END;
        END;
    END;

    LOCAL PROCEDURE CalcAppliesToIDTotals@28();
    BEGIN
      IF "Gen. Journal Line"."Applies-to ID" = '' THEN
        EXIT;

      CASE "Gen. Journal Line"."Account Type" OF
        "Gen. Journal Line"."Account Type"::Customer:
          BEGIN
            TotalCustAmount[Sign::Negative] := CalcCustRemainingAmount(FALSE);
            TotalCustAmount[Sign::Positive] := CalcCustRemainingAmount(TRUE);
          END;
        "Gen. Journal Line"."Account Type"::Vendor:
          BEGIN
            TotalVendAmount[Sign::Negative] := CalcVendRemainingAmount(FALSE);
            TotalVendAmount[Sign::Positive] := CalcVendRemainingAmount(TRUE);
          END;
      END;
    END;

    LOCAL PROCEDURE CalcCustRemainingAmount@29(PositiveFilter@3000 : Boolean) TotalAmount : Decimal;
    BEGIN
      WITH OldCustLedgEntry DO BEGIN
        SETRANGE("Customer No.","Gen. Journal Line"."Account No.");
        SETRANGE("Applies-to ID","Gen. Journal Line"."Applies-to ID");
        SETRANGE(Positive,PositiveFilter);
        SETAUTOCALCFIELDS("Remaining Amount");
        IF FINDSET THEN
          REPEAT
            TotalAmount += "Remaining Amount";
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CalcVendRemainingAmount@30(PositiveFilter@3000 : Boolean) TotalAmount : Decimal;
    BEGIN
      WITH OldVendLedgEntry DO BEGIN
        SETRANGE("Vendor No.","Gen. Journal Line"."Account No.");
        SETRANGE("Applies-to ID","Gen. Journal Line"."Applies-to ID");
        SETRANGE(Positive,PositiveFilter);
        SETAUTOCALCFIELDS("Remaining Amount");
        IF FINDSET THEN
          REPEAT
            TotalAmount += "Remaining Amount";
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE InitPmtDisc@31(NewAmtPmtTolerance@3001 : Decimal;NewAmtDue@3000 : Decimal);
    BEGIN
      AmountDiscounted := 0;
      AmountPmtDiscTolerance := 0;
      AmountPmtTolerance := NewAmtPmtTolerance;
      AmountDue := NewAmtDue;
    END;

    LOCAL PROCEDURE CalcPmtDisc@32(Positive@3004 : Boolean;RemPmtDiscPossible@3003 : Decimal;IsPostingDateBeforePmtDate@3002 : Boolean;AcceptedPmtTolerance@3001 : Boolean;TotalAmount@3000 : ARRAY [2] OF Decimal);
    VAR
      OppositeSignAmount@3005 : Decimal;
    BEGIN
      IF RemPmtDiscPossible = 0 THEN
        EXIT;

      IF Positive THEN
        OppositeSignAmount := TotalAmount[Sign::Negative]
      ELSE
        OppositeSignAmount := TotalAmount[Sign::Positive];
      IF (IsPostingDateBeforePmtDate OR AcceptedPmtTolerance) AND
         (ABS(AmountPaid + AmountPmtTolerance - RemPmtDiscPossible) >= ABS(AmountDue - OppositeSignAmount))
      THEN BEGIN
        IF IsPostingDateBeforePmtDate THEN
          AmountDiscounted := -RemPmtDiscPossible
        ELSE
          AmountPmtDiscTolerance := -RemPmtDiscPossible;
      END;
    END;

    LOCAL PROCEDURE CheckAccountType@33(VAR GenJournalLine@3001 : Record 81;AccName1@3000 : Text[30];AccName2@3002 : Text[30]);
    BEGIN
      WITH GenJournalLine DO
        CASE "Account Type" OF
          "Account Type"::"G/L Account":
            CheckGLAcc("Gen. Journal Line",AccName1);
          "Account Type"::Customer:
            CheckCust("Gen. Journal Line",AccName1);
          "Account Type"::Vendor:
            CheckVend("Gen. Journal Line",AccName1);
          "Account Type"::"Bank Account":
            CheckBankAcc("Gen. Journal Line",AccName1);
          "Account Type"::"Fixed Asset":
            CheckFixedAsset("Gen. Journal Line",AccName1);
          "Account Type"::"IC Partner":
            CheckICPartner("Gen. Journal Line",AccName2);
        END;
    END;

    LOCAL PROCEDURE CheckOldCustomer@21();
    BEGIN
      WITH OldCustLedgEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Document No.","Document Type");
        SETRANGE("Document Type","Gen. Journal Line"."Applies-to Doc. Type");
        SETRANGE("Document No.","Gen. Journal Line"."Applies-to Doc. No.");
        SETRANGE("Customer No.","Gen. Journal Line"."Account No.");
        IF FINDFIRST THEN BEGIN
          CALCFIELDS("Remaining Amount");
          "Gen. Journal Line"."Due Date" := "Due Date";
          "Gen. Journal Line".Description := Description;
          AmountDue := -"Remaining Amount";
          AmountPmtTolerance := -"Accepted Payment Tolerance";
          IF ("Remaining Pmt. Disc. Possible" <> 0) AND
             (("Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date") OR "Accepted Pmt. Disc. Tolerance") AND
             (AmountPaid - AmountPmtTolerance - "Remaining Pmt. Disc. Possible" >= AmountDue)
          THEN BEGIN
            IF "Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date" THEN
              AmountDiscounted := -"Remaining Pmt. Disc. Possible"
            ELSE
              AmountPmtDiscTolerance := -"Remaining Pmt. Disc. Possible";
          END;
          AmountPaid := AmountPaid + AmountPmtTolerance + AmountDiscounted + AmountPmtDiscTolerance;
          TotalAmountDiscounted := TotalAmountDiscounted + AmountDiscounted;
          TotalAmountPmtTolerance := TotalAmountPmtTolerance + AmountPmtTolerance;
          TotalAmountPmtDiscTolerance := TotalAmountPmtDiscTolerance + AmountPmtDiscTolerance;
          AmountApplied := AmountApplied - AmountPaid;
        END ELSE
          ShowApplyToOutput := FALSE;
      END;
    END;

    LOCAL PROCEDURE CheckOldVendor@27();
    BEGIN
      WITH OldVendLedgEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Document No.","Document Type");
        SETRANGE("Document Type","Gen. Journal Line"."Applies-to Doc. Type");
        SETRANGE("Document No.","Gen. Journal Line"."Applies-to Doc. No.");
        SETRANGE("Vendor No.","Gen. Journal Line"."Account No.");
        IF FINDFIRST THEN BEGIN
          CALCFIELDS("Remaining Amount");
          "Gen. Journal Line"."Due Date" := "Due Date";
          "Gen. Journal Line".Description := Description;
          AmountDue := -"Remaining Amount";
          AmountPaid := "Gen. Journal Line".Amount;
          AmountPmtTolerance := -"Accepted Payment Tolerance";
          IF ("Remaining Pmt. Disc. Possible" <> 0) AND
             (("Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date") OR "Accepted Pmt. Disc. Tolerance") AND
             (AmountPaid - AmountPmtTolerance - "Remaining Pmt. Disc. Possible" >= AmountDue)
          THEN BEGIN
            IF "Pmt. Discount Date" >= "Gen. Journal Line"."Posting Date" THEN
              AmountDiscounted := -"Remaining Pmt. Disc. Possible"
            ELSE
              AmountPmtDiscTolerance := -"Remaining Pmt. Disc. Possible";
          END;
          AmountPaid := AmountPaid + AmountPmtTolerance + AmountDiscounted + AmountPmtDiscTolerance;
          TotalAmountDiscounted := TotalAmountDiscounted + AmountDiscounted;
          TotalAmountPmtTolerance := TotalAmountPmtTolerance + AmountPmtTolerance;
          TotalAmountPmtDiscTolerance := TotalAmountPmtDiscTolerance + AmountPmtDiscTolerance;
          AmountApplied := AmountApplied - AmountPaid;
        END ELSE
          ShowApplyToOutput := FALSE;
      END;
    END;

    LOCAL PROCEDURE CheckGenJnlLineErrors@49(VAR GenJournalLine@1000 : Record 81);
    VAR
      PaymentTerms@1001 : Record 3;
      DimMgt@1003 : Codeunit 408;
      TableID@1002 : ARRAY [10] OF Integer;
      No@1004 : ARRAY [10] OF Code[20];
    BEGIN
      WITH GenJournalLine DO BEGIN
        IF ("Account No." = '') AND ("Bal. Account No." = '') THEN
          AddError(STRSUBSTNO(E001Err,FIELDCAPTION("Account No."),FIELDCAPTION("Bal. Account No.")))
        ELSE
          IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
             ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
          THEN
            TestFixedAssetFields("Gen. Journal Line");
        CheckICDocument;
        IF "Account No." <> '' THEN
          CheckAccount(GenJournalLine);

        IF "Bal. Account No." <> '' THEN
          CheckBalAccount(GenJournalLine);

        IF ("Account No." <> '') AND
           NOT "System-Created Entry" AND
           ("Gen. Posting Type" = "Gen. Posting Type"::" ") AND
           (Amount = 0) AND
           NOT GenJnlTemplate.Recurring AND
           NOT "Allow Zero-Amount Posting" AND
           ("Account Type" <> "Account Type"::"Fixed Asset")
        THEN
          WarningIfZeroAmt("Gen. Journal Line");

        CheckRecurringLine("Gen. Journal Line");
        CheckAllocations("Gen. Journal Line");

        IF "Posting Date" = 0D THEN
          AddError(STRSUBSTNO(E002Err,FIELDCAPTION("Posting Date")))
        ELSE
          CheckNonZeroPostingDate(GenJournalLine);

        IF "Document Date" <> 0D THEN
          IF ("Document Date" <> NORMALDATE("Document Date")) AND
             (("Account Type" <> "Account Type"::"G/L Account") OR
              ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account"))
          THEN
            AddError(
              STRSUBSTNO(
                E013Err,FIELDCAPTION("Document Date")));

        IF "Document No." = '' THEN BEGIN
          AddError(STRSUBSTNO(E002Err,FIELDCAPTION("Document No.")));
          ERROR(STRSUBSTNO(E002Err,FIELDCAPTION("Document No.")));
        END;
        IF "Gen. Journal Batch"."No. Series" <> '' THEN BEGIN
          IF (LastEntrdDocNo <> '') AND
             ("Document No." <> LastEntrdDocNo) AND
             ("Document No." <> INCSTR(LastEntrdDocNo))
          THEN
            AddError(E016Err);
          LastEntrdDocNo := "Document No.";
        END;

        IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset"]) AND
           ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset"])
        THEN
          AddError(
            STRSUBSTNO(
              E017Err,
              FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type")));

        IF Amount * "Amount (LCY)" < 0 THEN
          AddError(
            STRSUBSTNO(
              E008Err,FIELDCAPTION("Amount (LCY)"),FIELDCAPTION(Amount)));

        IF ("Account Type" = "Account Type"::"G/L Account") AND
           ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")
        THEN
          IF "Applies-to Doc. No." <> '' THEN
            AddError(STRSUBSTNO(E009Err,FIELDCAPTION("Applies-to Doc. No.")));

        IF (("Account Type" = "Account Type"::"G/L Account") AND
            ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
           ("Document Type" <> "Document Type"::Invoice)
        THEN
          IF PaymentTerms.GET("Payment Terms Code") THEN
            IF ("Document Type" = "Document Type"::"Credit Memo") AND
               (NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
            THEN BEGIN
              AddConditionalError("Pmt. Discount Date" <> 0D,STRSUBSTNO(E009Err,FIELDCAPTION("Pmt. Discount Date")));
              AddConditionalError("Payment Discount %" <> 0,STRSUBSTNO(E018Err,FIELDCAPTION("Payment Discount %")));
            END ELSE BEGIN
              AddConditionalError("Pmt. Discount Date" <> 0D,STRSUBSTNO(E009Err,FIELDCAPTION("Pmt. Discount Date")));
              AddConditionalError("Payment Discount %" <> 0,STRSUBSTNO(E018Err,FIELDCAPTION("Payment Discount %")));
            END;

        IF (("Account Type" = "Account Type"::"G/L Account") AND
            ("Bal. Account Type" = "Bal. Account Type"::"G/L Account")) OR
           ("Applies-to Doc. No." <> '')
        THEN
          AddConditionalError("Applies-to ID" <> '',STRSUBSTNO(E009Err,FIELDCAPTION("Applies-to ID")));

        IF ("Account Type" <> "Account Type"::"Bank Account") AND
           ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
        THEN
          AddConditionalError(GenJnlLine2."Bank Payment Type" > 0,STRSUBSTNO(E009Err,FIELDCAPTION("Bank Payment Type")));

        IF ("Account No." <> '') AND ("Bal. Account No." <> '') THEN BEGIN
          PurchPostingType := FALSE;
          SalesPostingType := FALSE;
        END;
        IF "Account No." <> '' THEN
          CheckAccountType("Gen. Journal Line",AccName,AccName);
        IF "Bal. Account No." <> '' THEN BEGIN
          CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line","Gen. Journal Line");
          CheckAccountType("Gen. Journal Line",BalAccName,AccName);
          CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line","Gen. Journal Line");
        END;

        AddConditionalError(NOT DimMgt.CheckDimIDComb("Dimension Set ID"),DimMgt.GetDimCombErr);

        TableID[1] := DimMgt.TypeToTableID1("Account Type");
        No[1] := "Account No.";
        TableID[2] := DimMgt.TypeToTableID1("Bal. Account Type");
        No[2] := "Bal. Account No.";
        TableID[3] := DATABASE::Job;
        No[3] := "Job No.";
        TableID[4] := DATABASE::"Salesperson/Purchaser";
        No[4] := "Salespers./Purch. Code";
        TableID[5] := DATABASE::Campaign;
        No[5] := "Campaign No.";
        AddConditionalError(NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID"),DimMgt.GetDimValuePostingErr);
      END;
    END;

    LOCAL PROCEDURE CheckBalAccount@51(VAR GenJournalLine@1000 : Record 81);
    BEGIN
      WITH GenJournalLine DO
        CASE "Bal. Account Type" OF
          "Bal. Account Type"::"G/L Account":
            BEGIN
              IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                 ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
              THEN BEGIN
                IF "Bal. Gen. Posting Type" = 0 THEN
                  AddError(STRSUBSTNO(E002Err,FIELDCAPTION("Bal. Gen. Posting Type")));
              END;
              IF ("Bal. Gen. Posting Type" <> "Bal. Gen. Posting Type"::" ") AND
                 ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
              THEN BEGIN
                IF "Bal. VAT Amount" + "Bal. VAT Base Amount" <> -Amount THEN
                  AddError(
                    STRSUBSTNO(
                      E011Err,FIELDCAPTION("Bal. VAT Amount"),FIELDCAPTION("Bal. VAT Base Amount"),
                      FIELDCAPTION(Amount)));
                IF "Currency Code" <> '' THEN
                  IF "Bal. VAT Amount (LCY)" + "Bal. VAT Base Amount (LCY)" <> -"Amount (LCY)" THEN
                    AddError(
                      STRSUBSTNO(
                        E011Err,FIELDCAPTION("Bal. VAT Amount (LCY)"),
                        FIELDCAPTION("Bal. VAT Base Amount (LCY)"),FIELDCAPTION("Amount (LCY)")));
              END;
            END;
          "Bal. Account Type"::Customer,"Bal. Account Type"::Vendor:
            BEGIN
              IF "Bal. Gen. Posting Type" <> 0 THEN
                AddError(
                  STRSUBSTNO(
                    E004Err,
                    FIELDCAPTION("Bal. Gen. Posting Type"),FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));

              IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                 ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
              THEN
                AddError(
                  STRSUBSTNO(
                    E005Err,
                    FIELDCAPTION("Bal. Gen. Bus. Posting Group"),FIELDCAPTION("Bal. Gen. Prod. Posting Group"),
                    FIELDCAPTION("Bal. VAT Bus. Posting Group"),FIELDCAPTION("Bal. VAT Prod. Posting Group"),
                    FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));

              IF "Document Type" <> 0 THEN BEGIN
                IF ("Bal. Account Type" = "Bal. Account Type"::Customer) =
                   ("Document Type" IN ["Document Type"::Payment,"Document Type"::"Credit Memo"])
                THEN
                  WarningIfNegativeAmt("Gen. Journal Line")
                ELSE
                  WarningIfPositiveAmt("Gen. Journal Line")
              END;
              IF Amount * "Sales/Purch. (LCY)" > 0 THEN
                AddError(
                  STRSUBSTNO(
                    E012Err,
                    FIELDCAPTION("Sales/Purch. (LCY)"),FIELDCAPTION(Amount)));
              IF "Job No." <> '' THEN
                AddError(STRSUBSTNO(E009Err,FIELDCAPTION("Job No.")));
            END;
          "Bal. Account Type"::"Bank Account":
            BEGIN
              IF "Bal. Gen. Posting Type" <> 0 THEN
                AddError(
                  STRSUBSTNO(
                    E004Err,
                    FIELDCAPTION("Bal. Gen. Posting Type"),FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));

              IF ("Bal. Gen. Bus. Posting Group" <> '') OR ("Bal. Gen. Prod. Posting Group" <> '') OR
                 ("Bal. VAT Bus. Posting Group" <> '') OR ("Bal. VAT Prod. Posting Group" <> '')
              THEN
                AddError(
                  STRSUBSTNO(
                    E005Err,
                    FIELDCAPTION("Bal. Gen. Bus. Posting Group"),FIELDCAPTION("Bal. Gen. Prod. Posting Group"),
                    FIELDCAPTION("Bal. VAT Bus. Posting Group"),FIELDCAPTION("Bal. VAT Prod. Posting Group"),
                    FIELDCAPTION("Bal. Account Type"),"Bal. Account Type"));

              AddConditionalError("Job No." <> '',STRSUBSTNO(E009Err,FIELDCAPTION("Job No.")));
            END;
          "Bal. Account Type"::"Fixed Asset":
            TestFixedAsset("Gen. Journal Line");
        END;
    END;

    LOCAL PROCEDURE CheckAccount@54(VAR GenJournalLine@1000 : Record 81);
    BEGIN
      WITH GenJournalLine DO
        CASE "Account Type" OF
          "Account Type"::"G/L Account":
            BEGIN
              IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                 ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
              THEN
                AddConditionalError("Gen. Posting Type" = 0,STRSUBSTNO(E002Err,FIELDCAPTION("Gen. Posting Type")));

              IF ("Gen. Posting Type" <> "Gen. Posting Type"::" ") AND
                 ("VAT Posting" = "VAT Posting"::"Automatic VAT Entry")
              THEN BEGIN
                AddConditionalError(
                  "VAT Amount" + "VAT Base Amount" <> Amount,
                  STRSUBSTNO(
                    E003Err,FIELDCAPTION("VAT Amount"),FIELDCAPTION("VAT Base Amount"),
                    FIELDCAPTION(Amount)));
                AddConditionalError(("Currency Code" <> '') AND
                  ("VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)"),
                  STRSUBSTNO(
                    E003Err,FIELDCAPTION("VAT Amount (LCY)"),
                    FIELDCAPTION("VAT Base Amount (LCY)"),FIELDCAPTION("Amount (LCY)")));
              END;
            END;
          "Account Type"::Customer,"Account Type"::Vendor:
            BEGIN
              AddConditionalError("Gen. Posting Type" <> 0,
                STRSUBSTNO(
                  E004Err,
                  FIELDCAPTION("Gen. Posting Type"),FIELDCAPTION("Account Type"),"Account Type"));

              IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                 ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
              THEN
                AddError(
                  STRSUBSTNO(
                    E005Err,
                    FIELDCAPTION("Gen. Bus. Posting Group"),FIELDCAPTION("Gen. Prod. Posting Group"),
                    FIELDCAPTION("VAT Bus. Posting Group"),FIELDCAPTION("VAT Prod. Posting Group"),
                    FIELDCAPTION("Account Type"),"Account Type"));

              IF "Document Type" <> 0 THEN BEGIN
                IF "Account Type" = "Account Type"::Customer THEN
                  CASE "Document Type" OF
                    "Document Type"::"Credit Memo":
                      WarningIfPositiveAmt("Gen. Journal Line");
                    "Document Type"::Payment:
                      IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") AND
                         ("Applies-to Doc. No." <> '')
                      THEN
                        WarningIfNegativeAmt("Gen. Journal Line")
                      ELSE
                        WarningIfPositiveAmt("Gen. Journal Line");
                    "Document Type"::Refund:
                      WarningIfNegativeAmt("Gen. Journal Line");
                    ELSE
                      WarningIfNegativeAmt("Gen. Journal Line");
                  END
                ELSE
                  CASE "Document Type" OF
                    "Document Type"::"Credit Memo":
                      WarningIfNegativeAmt("Gen. Journal Line");
                    "Document Type"::Payment:
                      IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::"Credit Memo") AND
                         ("Applies-to Doc. No." <> '')
                      THEN
                        WarningIfPositiveAmt("Gen. Journal Line")
                      ELSE
                        WarningIfNegativeAmt("Gen. Journal Line");
                    "Document Type"::Refund:
                      WarningIfPositiveAmt("Gen. Journal Line");
                    ELSE
                      WarningIfPositiveAmt("Gen. Journal Line");
                  END
              END;

              IF Amount * "Sales/Purch. (LCY)" < 0 THEN
                AddError(
                  STRSUBSTNO(
                    E008Err,
                    FIELDCAPTION("Sales/Purch. (LCY)"),FIELDCAPTION(Amount)));
              IF "Job No." <> '' THEN
                AddError(STRSUBSTNO(E009Err,FIELDCAPTION("Job No.")));
            END;
          "Account Type"::"Bank Account":
            BEGIN
              IF "Gen. Posting Type" <> 0 THEN
                AddError(
                  STRSUBSTNO(
                    E004Err,
                    FIELDCAPTION("Gen. Posting Type"),FIELDCAPTION("Account Type"),"Account Type"));

              IF ("Gen. Bus. Posting Group" <> '') OR ("Gen. Prod. Posting Group" <> '') OR
                 ("VAT Bus. Posting Group" <> '') OR ("VAT Prod. Posting Group" <> '')
              THEN
                AddError(
                  STRSUBSTNO(
                    E005Err,
                    FIELDCAPTION("Gen. Bus. Posting Group"),FIELDCAPTION("Gen. Prod. Posting Group"),
                    FIELDCAPTION("VAT Bus. Posting Group"),FIELDCAPTION("VAT Prod. Posting Group"),
                    FIELDCAPTION("Account Type"),"Account Type"));

              IF "Job No." <> '' THEN
                AddError(STRSUBSTNO(E009Err,FIELDCAPTION("Job No.")));
            END;
          "Account Type"::"Fixed Asset":
            TestFixedAsset("Gen. Journal Line");
        END;
    END;

    LOCAL PROCEDURE CheckNonZeroPostingDate@57(VAR GenJournalLine@1000 : Record 81);
    BEGIN
      WITH GenJournalLine DO BEGIN
        IF "Posting Date" <> NORMALDATE("Posting Date") THEN
          IF ("Account Type" <> "Account Type"::"G/L Account") OR
             ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
          THEN
            AddError(
              STRSUBSTNO(
                E013Err,FIELDCAPTION("Posting Date")));

        IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
          IF USERID <> '' THEN
            IF UserSetup.GET(USERID) THEN BEGIN
              AllowPostingFrom := UserSetup."Allow Posting From";
              AllowPostingTo := UserSetup."Allow Posting To";
            END;
          IF (AllowPostingFrom = 0D) AND (AllowPostingTo = 0D) THEN BEGIN
            AllowPostingFrom := GLSetup."Allow Posting From";
            AllowPostingTo := GLSetup."Allow Posting To";
          END;
          IF AllowPostingTo = 0D THEN
            AllowPostingTo := DMY2DATE(31,12,9999);
        END;
        IF ("Posting Date" < AllowPostingFrom) OR ("Posting Date" > AllowPostingTo) THEN
          AddError(
            STRSUBSTNO(
              E014Err,FORMAT("Posting Date")));

        IF "Gen. Journal Batch"."No. Series" <> '' THEN BEGIN
          IF NoSeries."Date Order" AND ("Posting Date" < LastEntrdDate) THEN
            AddError(E015Err);
          LastEntrdDate := "Posting Date";
        END;
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
      <rd:DataSourceID>81da1a93-6a8c-4b5c-873e-243bdfd86bfe</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="Gen__Journal_Batch_Journal_Template_Name">
          <DataField>Gen__Journal_Batch_Journal_Template_Name</DataField>
        </Field>
        <Field Name="Gen__Journal_Batch_Name">
          <DataField>Gen__Journal_Batch_Name</DataField>
        </Field>
        <Field Name="FORMAT_TODAY_0_4_">
          <DataField>FORMAT_TODAY_0_4_</DataField>
        </Field>
        <Field Name="CompanyInformation_Name">
          <DataField>CompanyInformation_Name</DataField>
        </Field>
        <Field Name="CurrReport_PAGENO">
          <DataField>CurrReport_PAGENO</DataField>
        </Field>
        <Field Name="USERID">
          <DataField>USERID</DataField>
        </Field>
        <Field Name="Gen__Journal_Batch___Journal_Template_Name_">
          <DataField>Gen__Journal_Batch___Journal_Template_Name_</DataField>
        </Field>
        <Field Name="Gen__Journal_Batch__Name">
          <DataField>Gen__Journal_Batch__Name</DataField>
        </Field>
        <Field Name="TIME">
          <DataField>TIME</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__TABLECAPTION__________GenJnlLineFilter">
          <DataField>Gen__Journal_Line__TABLECAPTION__________GenJnlLineFilter</DataField>
        </Field>
        <Field Name="GenJnlLineFilter">
          <DataField>GenJnlLineFilter</DataField>
        </Field>
        <Field Name="USE001Err">
          <DataField>USE001Err</DataField>
        </Field>
        <Field Name="GenJnlTemplate__Force_Doc__Balance_">
          <DataField>GenJnlTemplate__Force_Doc__Balance_</DataField>
        </Field>
        <Field Name="Integer_Number">
          <DataField>Integer_Number</DataField>
        </Field>
        <Field Name="Payment_Journal___Pre_Check_TestCaption">
          <DataField>Payment_Journal___Pre_Check_TestCaption</DataField>
        </Field>
        <Field Name="CurrReport_PAGENOCaption">
          <DataField>CurrReport_PAGENOCaption</DataField>
        </Field>
        <Field Name="Gen__Journal_Batch___Journal_Template_Name_Caption">
          <DataField>Gen__Journal_Batch___Journal_Template_Name_Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Batch__NameCaption">
          <DataField>Gen__Journal_Batch__NameCaption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Posting_Date_Caption">
          <DataField>Gen__Journal_Line__Posting_Date_Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Document_Type_Caption">
          <DataField>Gen__Journal_Line__Document_Type_Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Document_No__Caption">
          <DataField>Gen__Journal_Line__Document_No__Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Account_Type_Caption">
          <DataField>Gen__Journal_Line__Account_Type_Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Account_No__Caption">
          <DataField>Gen__Journal_Line__Account_No__Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_DescriptionCaption">
          <DataField>Gen__Journal_Line_DescriptionCaption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_AmountCaption">
          <DataField>Gen__Journal_Line_AmountCaption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Bal__Account_No__Caption">
          <DataField>Gen__Journal_Line__Bal__Account_No__Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Bal__Account_Type_Caption">
          <DataField>Gen__Journal_Line__Bal__Account_Type_Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Bank_Payment_Type_Caption">
          <DataField>Gen__Journal_Line__Bank_Payment_Type_Caption</DataField>
        </Field>
        <Field Name="DocumentCaption">
          <DataField>DocumentCaption</DataField>
        </Field>
        <Field Name="AccountCaption">
          <DataField>AccountCaption</DataField>
        </Field>
        <Field Name="Bal__AccountCaption">
          <DataField>Bal__AccountCaption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Posting_Date_">
          <DataField>Gen__Journal_Line__Posting_Date_</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Document_Type_">
          <DataField>Gen__Journal_Line__Document_Type_</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Document_No__">
          <DataField>Gen__Journal_Line__Document_No__</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Bank_Payment_Type_">
          <DataField>Gen__Journal_Line__Bank_Payment_Type_</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Account_Type_">
          <DataField>Gen__Journal_Line__Account_Type_</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Account_No__">
          <DataField>Gen__Journal_Line__Account_No__</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_Description">
          <DataField>Gen__Journal_Line_Description</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Bal__Account_Type_">
          <DataField>Gen__Journal_Line__Bal__Account_Type_</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Bal__Account_No__">
          <DataField>Gen__Journal_Line__Bal__Account_No__</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Applies_to_Doc__Type_">
          <DataField>Gen__Journal_Line__Applies_to_Doc__Type_</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Applies_to_Doc__No__">
          <DataField>Gen__Journal_Line__Applies_to_Doc__No__</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Due_Date_">
          <DataField>Gen__Journal_Line__Due_Date_</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_Description_Control3015">
          <DataField>Gen__Journal_Line_Description_Control3015</DataField>
        </Field>
        <Field Name="AmountDue">
          <DataField>AmountDue</DataField>
        </Field>
        <Field Name="AmountDueFormat">
          <DataField>AmountDueFormat</DataField>
        </Field>
        <Field Name="AmountDiscounted">
          <DataField>AmountDiscounted</DataField>
        </Field>
        <Field Name="AmountDiscountedFormat">
          <DataField>AmountDiscountedFormat</DataField>
        </Field>
        <Field Name="AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance">
          <DataField>AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance</DataField>
        </Field>
        <Field Name="AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtToleranceFormat">
          <DataField>AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtToleranceFormat</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Currency_Code_">
          <DataField>Gen__Journal_Line__Currency_Code_</DataField>
        </Field>
        <Field Name="AmountPmtDiscTolerance">
          <DataField>AmountPmtDiscTolerance</DataField>
        </Field>
        <Field Name="AmountPmtDiscToleranceFormat">
          <DataField>AmountPmtDiscToleranceFormat</DataField>
        </Field>
        <Field Name="AmountPmtTolerance">
          <DataField>AmountPmtTolerance</DataField>
        </Field>
        <Field Name="AmountPmtToleranceFormat">
          <DataField>AmountPmtToleranceFormat</DataField>
        </Field>
        <Field Name="ShowApplyToOutput">
          <DataField>ShowApplyToOutput</DataField>
        </Field>
        <Field Name="TotalAmount">
          <DataField>TotalAmount</DataField>
        </Field>
        <Field Name="TotalAmountFormat">
          <DataField>TotalAmountFormat</DataField>
        </Field>
        <Field Name="Amount___TotalAmountDiscounted___TotalAmountPmtDiscTolerance___TotalAmountPmtTolerance___AmountApplied">
          <DataField>Amount___TotalAmountDiscounted___TotalAmountPmtDiscTolerance___TotalAmountPmtTolerance___AmountApplied</DataField>
        </Field>
        <Field Name="Amount___TotalAmountDiscounted___TotalAmountPmtDiscTolerance___TotalAmountPmtTolerance___AmountAppliedFormat">
          <DataField>Amount___TotalAmountDiscounted___TotalAmountPmtDiscTolerance___TotalAmountPmtTolerance___AmountAppliedFormat</DataField>
        </Field>
        <Field Name="AmountApplied">
          <DataField>AmountApplied</DataField>
        </Field>
        <Field Name="AmountAppliedFormat">
          <DataField>AmountAppliedFormat</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_Amount">
          <DataField>Gen__Journal_Line_Amount</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_AmountFormat">
          <DataField>Gen__Journal_Line_AmountFormat</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Currency_Code__Control35">
          <DataField>Gen__Journal_Line__Currency_Code__Control35</DataField>
        </Field>
        <Field Name="STRSUBSTNO_USE003Err__Document_Type___Document_No___">
          <DataField>STRSUBSTNO_USE003Err__Document_Type___Document_No___</DataField>
        </Field>
        <Field Name="TotalAmountDiscounted">
          <DataField>TotalAmountDiscounted</DataField>
        </Field>
        <Field Name="TotalAmountDiscountedFormat">
          <DataField>TotalAmountDiscountedFormat</DataField>
        </Field>
        <Field Name="TotalAmountPmtDiscTolerance">
          <DataField>TotalAmountPmtDiscTolerance</DataField>
        </Field>
        <Field Name="TotalAmountPmtDiscToleranceFormat">
          <DataField>TotalAmountPmtDiscToleranceFormat</DataField>
        </Field>
        <Field Name="TotalAmountPmtTolerance">
          <DataField>TotalAmountPmtTolerance</DataField>
        </Field>
        <Field Name="TotalAmountPmtToleranceFormat">
          <DataField>TotalAmountPmtToleranceFormat</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Amount__LCY__">
          <DataField>Gen__Journal_Line__Amount__LCY__</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Amount__LCY__Format">
          <DataField>Gen__Journal_Line__Amount__LCY__Format</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Balance__LCY__">
          <DataField>Gen__Journal_Line__Balance__LCY__</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Balance__LCY__Format">
          <DataField>Gen__Journal_Line__Balance__LCY__Format</DataField>
        </Field>
        <Field Name="STRSUBSTNO_USE002Err__Journal_Template_Name___Journal_Batch_Name__">
          <DataField>STRSUBSTNO_USE002Err__Journal_Template_Name___Journal_Batch_Name__</DataField>
        </Field>
        <Field Name="AmountLcy">
          <DataField>AmountLcy</DataField>
        </Field>
        <Field Name="AmountLcyFormat">
          <DataField>AmountLcyFormat</DataField>
        </Field>
        <Field Name="AmountBalLcy">
          <DataField>AmountBalLcy</DataField>
        </Field>
        <Field Name="AmountBalLcyFormat">
          <DataField>AmountBalLcyFormat</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_Journal_Template_Name">
          <DataField>Gen__Journal_Line_Journal_Template_Name</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_Journal_Batch_Name">
          <DataField>Gen__Journal_Line_Journal_Batch_Name</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_Line_No_">
          <DataField>Gen__Journal_Line_Line_No_</DataField>
        </Field>
        <Field Name="Gen__Journal_Line_Applies_to_ID">
          <DataField>Gen__Journal_Line_Applies_to_ID</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Applies_to_Doc__Type_Caption">
          <DataField>Gen__Journal_Line__Applies_to_Doc__Type_Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Applies_to_Doc__No__Caption">
          <DataField>Gen__Journal_Line__Applies_to_Doc__No__Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Due_Date_Caption">
          <DataField>Gen__Journal_Line__Due_Date_Caption</DataField>
        </Field>
        <Field Name="Description___Caption">
          <DataField>Description___Caption</DataField>
        </Field>
        <Field Name="AmountDueCaption">
          <DataField>AmountDueCaption</DataField>
        </Field>
        <Field Name="AmountDiscountedCaption">
          <DataField>AmountDiscountedCaption</DataField>
        </Field>
        <Field Name="AmountPmtDiscToleranceCaption">
          <DataField>AmountPmtDiscToleranceCaption</DataField>
        </Field>
        <Field Name="AmountPmtToleranceCaption">
          <DataField>AmountPmtToleranceCaption</DataField>
        </Field>
        <Field Name="Unapplied_AmountsCaption">
          <DataField>Unapplied_AmountsCaption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Amount__LCY__Caption">
          <DataField>Gen__Journal_Line__Amount__LCY__Caption</DataField>
        </Field>
        <Field Name="Gen__Journal_Line__Balance__LCY__Caption">
          <DataField>Gen__Journal_Line__Balance__LCY__Caption</DataField>
        </Field>
        <Field Name="Cust_Vend_Name">
          <DataField>Cust_Vend_Name</DataField>
        </Field>
        <Field Name="Cust__Ledger_Entry__Document_Type_">
          <DataField>Cust__Ledger_Entry__Document_Type_</DataField>
        </Field>
        <Field Name="Cust__Ledger_Entry__Document_No__">
          <DataField>Cust__Ledger_Entry__Document_No__</DataField>
        </Field>
        <Field Name="Cust__Ledger_Entry_Description">
          <DataField>Cust__Ledger_Entry_Description</DataField>
        </Field>
        <Field Name="Cust__Ledger_Entry__Due_Date_">
          <DataField>Cust__Ledger_Entry__Due_Date_</DataField>
        </Field>
        <Field Name="Remaining_Amount_">
          <DataField>Remaining_Amount_</DataField>
        </Field>
        <Field Name="Remaining_Amount_Format">
          <DataField>Remaining_Amount_Format</DataField>
        </Field>
        <Field Name="AmountDiscounted_Control3033">
          <DataField>AmountDiscounted_Control3033</DataField>
        </Field>
        <Field Name="AmountDiscounted_Control3033Format">
          <DataField>AmountDiscounted_Control3033Format</DataField>
        </Field>
        <Field Name="Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_">
          <DataField>Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_</DataField>
        </Field>
        <Field Name="Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_Format">
          <DataField>Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_Format</DataField>
        </Field>
        <Field Name="Cust__Ledger_Entry__Currency_Code_">
          <DataField>Cust__Ledger_Entry__Currency_Code_</DataField>
        </Field>
        <Field Name="AmountPmtTolerance_Control3049">
          <DataField>AmountPmtTolerance_Control3049</DataField>
        </Field>
        <Field Name="AmountPmtTolerance_Control3049Format">
          <DataField>AmountPmtTolerance_Control3049Format</DataField>
        </Field>
        <Field Name="AmountPmtDiscTolerance_Control3050">
          <DataField>AmountPmtDiscTolerance_Control3050</DataField>
        </Field>
        <Field Name="AmountPmtDiscTolerance_Control3050Format">
          <DataField>AmountPmtDiscTolerance_Control3050Format</DataField>
        </Field>
        <Field Name="Cust__Ledger_Entry_Entry_No_">
          <DataField>Cust__Ledger_Entry_Entry_No_</DataField>
        </Field>
        <Field Name="Cust__Ledger_Entry_Customer_No_">
          <DataField>Cust__Ledger_Entry_Customer_No_</DataField>
        </Field>
        <Field Name="Cust__Ledger_Entry_Applies_to_ID">
          <DataField>Cust__Ledger_Entry_Applies_to_ID</DataField>
        </Field>
        <Field Name="Remaining_Amount__Control3035">
          <DataField>Remaining_Amount__Control3035</DataField>
        </Field>
        <Field Name="Remaining_Amount__Control3035Format">
          <DataField>Remaining_Amount__Control3035Format</DataField>
        </Field>
        <Field Name="Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036">
          <DataField>Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036</DataField>
        </Field>
        <Field Name="Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036Format">
          <DataField>Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036Format</DataField>
        </Field>
        <Field Name="AmountDiscounted_Control3037">
          <DataField>AmountDiscounted_Control3037</DataField>
        </Field>
        <Field Name="AmountDiscounted_Control3037Format">
          <DataField>AmountDiscounted_Control3037Format</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry_Description">
          <DataField>Vendor_Ledger_Entry_Description</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Due_Date_">
          <DataField>Vendor_Ledger_Entry__Due_Date_</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Document_No__">
          <DataField>Vendor_Ledger_Entry__Document_No__</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Document_Type_">
          <DataField>Vendor_Ledger_Entry__Document_Type_</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Currency_Code_">
          <DataField>Vendor_Ledger_Entry__Currency_Code_</DataField>
        </Field>
        <Field Name="AmountPmtTolerance_Control3051">
          <DataField>AmountPmtTolerance_Control3051</DataField>
        </Field>
        <Field Name="AmountPmtTolerance_Control3051Format">
          <DataField>AmountPmtTolerance_Control3051Format</DataField>
        </Field>
        <Field Name="AmountPmtDiscTolerance_Control3052">
          <DataField>AmountPmtDiscTolerance_Control3052</DataField>
        </Field>
        <Field Name="AmountPmtDiscTolerance_Control3052Format">
          <DataField>AmountPmtDiscTolerance_Control3052Format</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry_Entry_No_">
          <DataField>Vendor_Ledger_Entry_Entry_No_</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry_Vendor_No_">
          <DataField>Vendor_Ledger_Entry_Vendor_No_</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry_Applies_to_ID">
          <DataField>Vendor_Ledger_Entry_Applies_to_ID</DataField>
        </Field>
        <Field Name="ErrorText_Number_">
          <DataField>ErrorText_Number_</DataField>
        </Field>
        <Field Name="ErrorLoop_Number">
          <DataField>ErrorLoop_Number</DataField>
        </Field>
        <Field Name="ErrorText_Number_Caption">
          <DataField>ErrorText_Number_Caption</DataField>
        </Field>
        <Field Name="GLAccNetChange__No__">
          <DataField>GLAccNetChange__No__</DataField>
        </Field>
        <Field Name="GLAccNetChange_Name">
          <DataField>GLAccNetChange_Name</DataField>
        </Field>
        <Field Name="GLAccNetChange__Net_Change_in_Jnl__">
          <DataField>GLAccNetChange__Net_Change_in_Jnl__</DataField>
        </Field>
        <Field Name="GLAccNetChange__Net_Change_in_Jnl__Format">
          <DataField>GLAccNetChange__Net_Change_in_Jnl__Format</DataField>
        </Field>
        <Field Name="GLAccNetChange__Balance_after_Posting_">
          <DataField>GLAccNetChange__Balance_after_Posting_</DataField>
        </Field>
        <Field Name="GLAccNetChange__Balance_after_Posting_Format">
          <DataField>GLAccNetChange__Balance_after_Posting_Format</DataField>
        </Field>
        <Field Name="ReconcileLoop_Number">
          <DataField>ReconcileLoop_Number</DataField>
        </Field>
        <Field Name="ReconciliationCaption">
          <DataField>ReconciliationCaption</DataField>
        </Field>
        <Field Name="GLAccNetChange__No__Caption">
          <DataField>GLAccNetChange__No__Caption</DataField>
        </Field>
        <Field Name="GLAccNetChange_NameCaption">
          <DataField>GLAccNetChange_NameCaption</DataField>
        </Field>
        <Field Name="GLAccNetChange__Net_Change_in_Jnl__Caption">
          <DataField>GLAccNetChange__Net_Change_in_Jnl__Caption</DataField>
        </Field>
        <Field Name="GLAccNetChange__Balance_after_Posting_Caption">
          <DataField>GLAccNetChange__Balance_after_Posting_Caption</DataField>
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
                  <Width>8.7941in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>4.49635in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="Table_Gen__Journal_Line">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.61024in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.45433in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.74803in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.50197in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.45433in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.61024in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.15748in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.14173in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.15748in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.65118in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.70866in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76772in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.76772in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.70866in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.35433in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.03125in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Report_Header_Info">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>93</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Fields!Payment_Journal___Pre_Check_TestCaption.Value + Chr(177) 
  + Fields!CompanyInformation_Name.Value + Chr(177) 
  + Fields!CurrReport_PAGENOCaption.Value + Chr(177) 
  + Fields!Gen__Journal_Batch___Journal_Template_Name_Caption.Value + Chr(177) 
  + Fields!Gen__Journal_Batch___Journal_Template_Name_.Value + Chr(177)  
  + Fields!Gen__Journal_Batch__NameCaption.Value + Chr(177)  
  + Fields!Gen__Journal_Batch__Name.Value)</Hidden>
                                            </Visibility>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>15</ColSpan>
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
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox249">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=first(Fields!USE001Err.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>92</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>15</ColSpan>
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
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
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
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox12</rd:DefaultName>
                                            <ZIndex>91</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>15</ColSpan>
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
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
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
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox52</rd:DefaultName>
                                            <ZIndex>90</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>4pt</PaddingTop>
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
                                                    <Value>=First(Fields!DocumentCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>89</ZIndex>
                                            <Style>
                                              <BottomBorder>
                                                <Style>Dotted</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.07874in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                          <Textbox Name="textbox45">
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
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox45</rd:DefaultName>
                                            <ZIndex>88</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.35433in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>4pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AccountCaption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AccountCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>87</ZIndex>
                                            <Style>
                                              <BottomBorder>
                                                <Style>Dotted</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox43</rd:DefaultName>
                                            <ZIndex>86</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.23622in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                          <Textbox Name="Bal__AccountCaption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Bal__AccountCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>85</ZIndex>
                                            <Style>
                                              <BottomBorder>
                                                <Style>Dotted</Style>
                                              </BottomBorder>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox42</rd:DefaultName>
                                            <ZIndex>84</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.27559in</PaddingLeft>
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
                                    <Height>0.33307in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox29">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Posting_Date_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>83</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
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
                                                    <Value>=First(Fields!Gen__Journal_Line__Document_Type_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>82</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
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
                                                    <Value>=First(Fields!Gen__Journal_Line__Document_No__Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>81</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Bank_Payment_Type_Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Bank_Payment_Type_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>80</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Account_Type_Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Account_Type_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>79</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Account_No__Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Account_No__Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>78</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line_DescriptionCaption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line_DescriptionCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>77</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Bal__Account_Type_Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Account_Type_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>76</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Bal__Account_No__Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Bal__Account_No__Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>75</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox46</rd:DefaultName>
                                            <ZIndex>74</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line_AmountCaption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line_AmountCaption.Value)</Value>
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
                                            <ZIndex>73</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
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
                                            <rd:DefaultName>textbox44</rd:DefaultName>
                                            <ZIndex>72</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>0.35433in</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
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
                                          <Textbox Name="Gen__Journal_Line__Posting_Date_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Posting_Date_.Value)</Value>
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
                                            <ZIndex>71</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Document_Type_">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Document_Type_.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>70</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
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
                                          <Textbox Name="Gen__Journal_Line__Document_No__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Document_No__.Value)</Value>
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
                                            <ZIndex>69</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
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
                                          <Textbox Name="Gen__Journal_Line__Bank_Payment_Type_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Bank_Payment_Type_.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>68</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
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
                                          <Textbox Name="Gen__Journal_Line__Account_Type_">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Account_Type_.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>67</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
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
                                          <Textbox Name="Gen__Journal_Line__Account_No__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Account_No__.Value)</Value>
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
                                            <ZIndex>66</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Cust_Vend_Name">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Cust_Vend_Name.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>65</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Bal__Account_Type_">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Bal__Account_Type_.Value)</Value>
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
                                            <ZIndex>64</ZIndex>
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
                                          <Textbox Name="Gen__Journal_Line__Bal__Account_No__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Bal__Account_No__.Value)</Value>
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
                                            <ZIndex>63</ZIndex>
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
                                          <Textbox Name="textbox14">
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
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox14</rd:DefaultName>
                                            <ZIndex>62</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.33307in</Height>
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
                                            <ZIndex>61</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Applies_to_Doc__Type_Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Applies_to_Doc__Type_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>60</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.21654in</PaddingLeft>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Applies_to_Doc__No__Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Applies_to_Doc__No__Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>59</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.17717in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Due_Date_Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line__Due_Date_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>58</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line_Description_Control3015Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!Gen__Journal_Line_DescriptionCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>57</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AmountDueCaption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AmountDueCaption.Value)</Value>
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
                                            <ZIndex>56</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>2</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AmountDiscountedCaption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AmountDiscountedCaption.Value)</Value>
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
                                            <ZIndex>55</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>0.17717in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AmountPmtDiscToleranceCaption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AmountPmtDiscToleranceCaption.Value)</Value>
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
                                            <rd:DefaultName>AmountPmtDiscToleranceCaption</rd:DefaultName>
                                            <ZIndex>54</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AmountPmtToleranceFormat">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=First(Fields!AmountPmtToleranceCaption.Value)</Value>
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
                                            <rd:DefaultName>AmountPmtToleranceFormat</rd:DefaultName>
                                            <ZIndex>53</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox40</rd:DefaultName>
                                            <ZIndex>52</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    <Height>0.16654in</Height>
                                    <TablixCells>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox5</rd:DefaultName>
                                            <ZIndex>51</ZIndex>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Applies_to_Doc__Type_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Gen__Journal_Line__Applies_to_Doc__Type_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>50</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.21654in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Gen__Journal_Line__Applies_to_Doc__No__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Gen__Journal_Line__Applies_to_Doc__No__.Value</Value>
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
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.17717in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                          <Textbox Name="Gen__Journal_Line__Due_Date_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Gen__Journal_Line__Due_Date_.Value</Value>
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
                                            <ZIndex>48</ZIndex>
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
                                          <Textbox Name="Gen__Journal_Line_Description_Control3015">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Gen__Journal_Line_Description.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>47</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AmountDue">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountDue.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountDueFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>46</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AmountDiscounted">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountDiscounted.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountDiscountedFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountDiscounted</rd:DefaultName>
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
                                          <Textbox Name="AmountPmtDiscTolerance">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountPmtDiscTolerance.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountPmtDiscToleranceFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountPmtDiscTolerance</rd:DefaultName>
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
                                          <Textbox Name="AmountPmtTolerance">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountPmtTolerance.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountPmtToleranceFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountPmtTolerance</rd:DefaultName>
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
                                          <Textbox Name="AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtToleranceFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountPaid___AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance</rd:DefaultName>
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
                                          <Textbox Name="Gen__Journal_Line__Currency_Code_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Gen__Journal_Line__Currency_Code_.Value</Value>
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
                                            <ZIndex>41</ZIndex>
                                            <Visibility>
                                              <Hidden>=not (Fields!ShowApplyToOutput.Value and (Fields!Gen__Journal_Line__Applies_to_Doc__No__.Value&lt;&gt;Previous(Last(Fields!Gen__Journal_Line__Applies_to_Doc__No__.Value)) or Fields!Gen__Journal_Line__Applies_to_Doc__Type_.Value&lt;&gt;Previous(Last(Fields!Gen__Journal_Line__Applies_to_Doc__Type_.Value))))</Hidden>
                                            </Visibility>
                                            <DataElementOutput>NoOutput</DataElementOutput>
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
                                    <Height>0.16654in</Height>
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
                                                    <Style />
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox18</rd:DefaultName>
                                            <ZIndex>40</ZIndex>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Cust__Ledger_Entry__Document_Type_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Cust__Ledger_Entry__Document_Type_.Value</Value>
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
                                            <ZIndex>39</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.21654in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Cust__Ledger_Entry__Document_No__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Cust__Ledger_Entry__Document_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>38</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.17717in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                          <Textbox Name="Cust__Ledger_Entry__Due_Date_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Cust__Ledger_Entry__Due_Date_.Value</Value>
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
                                            <ZIndex>37</ZIndex>
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
                                          <Textbox Name="Cust__Ledger_Entry_Description">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Cust__Ledger_Entry_Description.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>36</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Remaining_Amount_Cust">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!Remaining_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Remaining_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>35</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AmountDiscounted_Control3033">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountDiscounted_Control3033.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountDiscounted_Control3033Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountDiscounted_Control3033</rd:DefaultName>
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
                                          <Textbox Name="AmountPmtDiscTolerance_Control3050">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountPmtDiscTolerance_Control3050.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountPmtDiscTolerance_Control3050Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountPmtDiscTolerance_Control3050</rd:DefaultName>
                                            <ZIndex>33</ZIndex>
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
                                          <Textbox Name="AmountPmtTolerance_Control3049">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountPmtTolerance_Control3049.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountPmtTolerance_Control3049Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountPmtTolerance_Control3049</rd:DefaultName>
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
                                          <Textbox Name="Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance_</rd:DefaultName>
                                            <ZIndex>31</ZIndex>
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
                                          <Textbox Name="Cust__Ledger_Entry__Currency_Code_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Cust__Ledger_Entry__Currency_Code_.Value</Value>
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
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox13">
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
                                            <rd:DefaultName>textbox13</rd:DefaultName>
                                            <ZIndex>29</ZIndex>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Vendor_Ledger_Entry__Document_Type_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Vendor_Ledger_Entry__Document_Type_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>28</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>0.21654in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Vendor_Ledger_Entry__Document_No__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Vendor_Ledger_Entry__Document_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>27</ZIndex>
                                            <Style>
                                              <PaddingLeft>0.17717in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
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
                                          <Textbox Name="Vendor_Ledger_Entry__Due_Date_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Vendor_Ledger_Entry__Due_Date_.Value</Value>
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
                                          <Textbox Name="Vendor_Ledger_Entry_Description">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Vendor_Ledger_Entry_Description.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>25</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Remaining_Amount__Vendor">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!Remaining_Amount__Control3035.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Remaining_Amount__Control3035Format.Value</Format>
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
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="AmountDiscounted_Control3037">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountDiscounted_Control3037.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountDiscounted_Control3037Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountDiscounted_Control3037</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
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
                                          <Textbox Name="AmountPmtDiscTolerance_Control3052">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountPmtDiscTolerance_Control3052.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountPmtDiscTolerance_Control3052Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountPmtDiscTolerance_Control3052</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
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
                                          <Textbox Name="AmountPmtTolerance_Control3051">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!AmountPmtTolerance_Control3051.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!AmountPmtTolerance_Control3051Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>AmountPmtTolerance_Control3051</rd:DefaultName>
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
                                          <Textbox Name="Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Fields!Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>Amount_to_Apply____AmountDiscounted___AmountPmtDiscTolerance___AmountPmtTolerance__Control3036</rd:DefaultName>
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
                                          <Textbox Name="Vendor_Ledger_Entry__Currency_Code_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Vendor_Ledger_Entry__Currency_Code_.Value</Value>
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
                                            <ZIndex>19</ZIndex>
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
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ErrorText_Number_Caption">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>1</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ErrorText_Number_">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>4pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>14</ColSpan>
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
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox61</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                          <Textbox Name="textbox27">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=first(Fields!Unapplied_AmountsCaption.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
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
                                          <Textbox Name="textbox32">
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
                                            <rd:DefaultName>textbox32</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <VerticalAlign>Middle</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>3</ColSpan>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="Amount___TotalAmountDiscounted___AmountApplied1">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=last(Fields!Amount___TotalAmountDiscounted___TotalAmountPmtDiscTolerance___TotalAmountPmtTolerance___AmountApplied.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Amount___TotalAmountDiscounted___TotalAmountPmtDiscTolerance___TotalAmountPmtTolerance___AmountAppliedFormat.Value</Format>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!Amount___TotalAmountDiscounted___TotalAmountPmtDiscTolerance___TotalAmountPmtTolerance___AmountAppliedFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox51</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2.3622in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox62</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
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
                                          <Textbox Name="STRSUBSTNO_USE003Err__Document_Type___Document_No___">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=first(Fields!STRSUBSTNO_USE003Err__Document_Type___Document_No___.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>12</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="TotalAmountDiscounted">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(Last(Fields!TotalAmountDiscounted.value))</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!TotalAmountDiscountedFormat.Value)</Format>
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
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="TotalAmountPmtDiscTolerance">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(last(Fields!TotalAmountPmtDiscTolerance.Value))</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!Gen__Journal_Line_AmountFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmountPmtDiscTolerance</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="TotalAmountPmtTolerance">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=code.BlankZero(last(Fields!TotalAmountPmtTolerance.Value))</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!Gen__Journal_Line_AmountFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>TotalAmountPmtTolerance</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="Gen__Journal_Line_Amount">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=last(Fields!TotalAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!Gen__Journal_Line_AmountFormat.Value)</Format>
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
                                          <Textbox Name="textbox3">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=last(Fields!Gen__Journal_Line__Currency_Code_.Value)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=First(Fields!Gen__Journal_Line_AmountFormat.Value)</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox3</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    <Height>0.16654in</Height>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox6</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2.97244in</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>15</ColSpan>
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
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox20</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>15</ColSpan>
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
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Rectangle Name="rectangle1">
                                            <ReportItems>
                                              <Textbox Name="textbox1">
                                                <KeepTogether>true</KeepTogether>
                                                <Paragraphs>
                                                  <Paragraph>
                                                    <TextRuns>
                                                      <TextRun>
                                                        <Value>=First(Fields!STRSUBSTNO_USE002Err__Journal_Template_Name___Journal_Batch_Name__.Value)</Value>
                                                        <Style>
                                                          <FontSize>7pt</FontSize>
                                                          <FontWeight>Bold</FontWeight>
                                                        </Style>
                                                      </TextRun>
                                                    </TextRuns>
                                                    <Style />
                                                  </Paragraph>
                                                </Paragraphs>
                                                <rd:DefaultName>textbox1</rd:DefaultName>
                                                <Height>0.16654in</Height>
                                                <Width>3.12992in</Width>
                                                <Style>
                                                  <PaddingRight>2pt</PaddingRight>
                                                  <PaddingTop>2pt</PaddingTop>
                                                  <PaddingBottom>2pt</PaddingBottom>
                                                </Style>
                                              </Textbox>
                                              <Textbox Name="textbox16">
                                                <KeepTogether>true</KeepTogether>
                                                <Paragraphs>
                                                  <Paragraph>
                                                    <TextRuns>
                                                      <TextRun>
                                                        <Value>=First(Fields!Gen__Journal_Line__Amount__LCY__Caption.Value)</Value>
                                                        <Style>
                                                          <FontSize>7pt</FontSize>
                                                          <FontWeight>Bold</FontWeight>
                                                        </Style>
                                                      </TextRun>
                                                    </TextRuns>
                                                    <Style />
                                                  </Paragraph>
                                                </Paragraphs>
                                                <Left>3.13332in</Left>
                                                <Height>0.16654in</Height>
                                                <Width>0.88583in</Width>
                                                <ZIndex>1</ZIndex>
                                                <Style>
                                                  <PaddingLeft>2pt</PaddingLeft>
                                                  <PaddingRight>2pt</PaddingRight>
                                                  <PaddingTop>2pt</PaddingTop>
                                                  <PaddingBottom>2pt</PaddingBottom>
                                                </Style>
                                              </Textbox>
                                              <Textbox Name="textbox22">
                                                <KeepTogether>true</KeepTogether>
                                                <Paragraphs>
                                                  <Paragraph>
                                                    <TextRuns>
                                                      <TextRun>
                                                        <Value>=last(Fields!AmountLcy.Value)</Value>
                                                        <Style>
                                                          <FontSize>7pt</FontSize>
                                                          <FontWeight>Bold</FontWeight>
                                                          <Format>=last(Fields!AmountLcyFormat.Value)</Format>
                                                        </Style>
                                                      </TextRun>
                                                    </TextRuns>
                                                    <Style />
                                                  </Paragraph>
                                                </Paragraphs>
                                                <Left>4.01818in</Left>
                                                <Height>0.16654in</Height>
                                                <Width>0.88583in</Width>
                                                <ZIndex>2</ZIndex>
                                                <Style>
                                                  <PaddingLeft>2pt</PaddingLeft>
                                                  <PaddingRight>2pt</PaddingRight>
                                                  <PaddingTop>2pt</PaddingTop>
                                                  <PaddingBottom>2pt</PaddingBottom>
                                                </Style>
                                              </Textbox>
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
                                                    <Style />
                                                  </Paragraph>
                                                </Paragraphs>
                                                <Left>4.90294in</Left>
                                                <Height>0.16654in</Height>
                                                <Width>0.23622in</Width>
                                                <ZIndex>3</ZIndex>
                                                <Style>
                                                  <PaddingLeft>2pt</PaddingLeft>
                                                  <PaddingRight>2pt</PaddingRight>
                                                  <PaddingTop>2pt</PaddingTop>
                                                  <PaddingBottom>2pt</PaddingBottom>
                                                </Style>
                                              </Textbox>
                                              <Textbox Name="textbox26">
                                                <KeepTogether>true</KeepTogether>
                                                <Paragraphs>
                                                  <Paragraph>
                                                    <TextRuns>
                                                      <TextRun>
                                                        <Value>=last(Fields!Gen__Journal_Line__Balance__LCY__Caption.Value)</Value>
                                                        <Style>
                                                          <FontSize>7pt</FontSize>
                                                          <FontWeight>Bold</FontWeight>
                                                        </Style>
                                                      </TextRun>
                                                    </TextRuns>
                                                    <Style />
                                                  </Paragraph>
                                                </Paragraphs>
                                                <Left>5.14241in</Left>
                                                <Height>0.16654in</Height>
                                                <Width>0.88583in</Width>
                                                <ZIndex>4</ZIndex>
                                                <Style>
                                                  <PaddingLeft>2pt</PaddingLeft>
                                                  <PaddingRight>2pt</PaddingRight>
                                                  <PaddingTop>2pt</PaddingTop>
                                                  <PaddingBottom>2pt</PaddingBottom>
                                                </Style>
                                              </Textbox>
                                              <Textbox Name="textbox28">
                                                <KeepTogether>true</KeepTogether>
                                                <Paragraphs>
                                                  <Paragraph>
                                                    <TextRuns>
                                                      <TextRun>
                                                        <Value>=last(Fields!AmountBalLcy.Value)</Value>
                                                        <Style>
                                                          <FontSize>7pt</FontSize>
                                                          <FontWeight>Bold</FontWeight>
                                                          <Format>=last(Fields!AmountBalLcyFormat.Value)</Format>
                                                        </Style>
                                                      </TextRun>
                                                    </TextRuns>
                                                    <Style />
                                                  </Paragraph>
                                                </Paragraphs>
                                                <Left>6.02727in</Left>
                                                <Height>0.16654in</Height>
                                                <Width>0.70866in</Width>
                                                <ZIndex>5</ZIndex>
                                                <Style>
                                                  <PaddingLeft>2pt</PaddingLeft>
                                                  <PaddingRight>2pt</PaddingRight>
                                                  <PaddingTop>2pt</PaddingTop>
                                                  <PaddingBottom>2pt</PaddingBottom>
                                                </Style>
                                              </Textbox>
                                            </ReportItems>
                                            <DataElementOutput>ContentsOnly</DataElementOutput>
                                            <ZIndex>16</ZIndex>
                                            <Style />
                                          </Rectangle>
                                          <ColSpan>15</ColSpan>
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
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox7">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox7</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>15</ColSpan>
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
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                      <TablixCell />
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox8">
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
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox8</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
                                            <Style>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                            </Style>
                                          </Textbox>
                                          <ColSpan>15</ColSpan>
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
                                    <Visibility>
                                      <Hidden>=Fields!GenJnlTemplate__Force_Doc__Balance_.Value</Hidden>
                                    </Visibility>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <RepeatOnNewPage>true</RepeatOnNewPage>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Visibility>
                                      <Hidden>=Fields!GenJnlTemplate__Force_Doc__Balance_.Value</Hidden>
                                    </Visibility>
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
                                    <Group Name="Table1_Group">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!Gen__Journal_Line__Document_No__.Value</GroupExpression>
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
                                        <Group Name="Table_Gen__Journal_Line_Details_Group">
                                          <DataElementName>Detail</DataElementName>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=not (Fields!ShowApplyToOutput.Value and (Fields!Gen__Journal_Line__Applies_to_Doc__No__.Value&lt;&gt;Previous(Last(Fields!Gen__Journal_Line__Applies_to_Doc__No__.Value)) or Fields!Gen__Journal_Line__Applies_to_Doc__Type_.Value&lt;&gt;Previous(Last(Fields!Gen__Journal_Line__Applies_to_Doc__Type_.Value))))</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>= IIF(Len(Fields!Cust__Ledger_Entry_Customer_No_.Value)&gt;0, false, true)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>= IIF(Len(Fields!Vendor_Ledger_Entry_Vendor_No_.Value) &gt; 0, false, true)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>= IIF(Len(Fields!ErrorText_Number_.Value)&gt; 0, false, true)</Hidden>
                                            </Visibility>
                                          </TablixMember>
                                        </TablixMembers>
                                        <DataElementName>Detail_Collection</DataElementName>
                                        <DataElementOutput>Output</DataElementOutput>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF((last(Fields!TotalAmount.Value)+last(Fields!TotalAmountDiscounted.Value)+last(Fields!TotalAmountPmtDiscTolerance.Value)+last(Fields!TotalAmountPmtTolerance.Value)+last(Fields!AmountApplied.Value))=0 OR (last(Fields!TotalAmount.Value)+last(Fields!TotalAmountDiscounted.Value)+last(Fields!TotalAmountPmtDiscTolerance.Value)+last(Fields!TotalAmountPmtTolerance.Value))=0,TRUE,FALSE)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
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
                                    <Visibility>
                                      <Hidden>= IIF(Len(First(Fields!Gen__Journal_Line__Document_No__.Value)) = 0, true, false)</Hidden>
                                    </Visibility>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>Before</KeepWithGroup>
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
                                  <TablixMember>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=isnothing(Fields!Gen__Journal_Line__Posting_Date_.Value)</FilterExpression>
                                  <Operator>Equal</Operator>
                                  <FilterValues>
                                    <FilterValue>=false</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>0.30197in</Top>
                              <Height>3.19549in</Height>
                              <Width>8.7941in</Width>
                              <Style />
                            </Tablix>
                            <Tablix Name="Table_Reconciliation">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>0.62992in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.77165in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.73819in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>0.73819in</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>4.61614in</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.16654in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="ReconciliationCaption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ReconciliationCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Middle</VerticalAlign>
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
                                    <Height>0.16654in</Height>
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
                                                      <FontSize>7pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox10</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    <Height>0.49961in</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GLAccNetChange__No__Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>= Fields!GLAccNetChange__No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GLAccNetChange_NameCaption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChange_NameCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GLAccNetChange__Net_Change_in_Jnl__Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChange__Net_Change_in_Jnl__Caption.Value</Value>
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
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GLAccNetChange__Balance_after_Posting_Caption">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChange__Balance_after_Posting_Caption.Value</Value>
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
                                            <ZIndex>6</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
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
                                            <rd:DefaultName>textbox34</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingBottom>8pt</PaddingBottom>
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
                                          <Textbox Name="GLAccNetChange__No__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChange__No__.Value</Value>
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
                                            <ZIndex>4</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="GLAccNetChange_Name">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChange_Name.Value</Value>
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
                                            <ZIndex>3</ZIndex>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="GLAccNetChange__Net_Change_in_Jnl__">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChange__Net_Change_in_Jnl__.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!GLAccNetChange__Net_Change_in_Jnl__Format.Value</Format>
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
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                          <Textbox Name="GLAccNetChange__Balance_after_Posting_">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!GLAccNetChange__Balance_after_Posting_.Value</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!GLAccNetChange__Balance_after_Posting_Format.Value</Format>
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
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value />
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Format>=Fields!GLAccNetChange__Balance_after_Posting_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox36</rd:DefaultName>
                                            <Style>
                                              <BackgroundColor>White</BackgroundColor>
                                              <VerticalAlign>Bottom</VerticalAlign>
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
                                    <Group Name="Table_Reconciliation_Details_Group">
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
                                  <FilterExpression>= Len(Fields!GLAccNetChange__No__.Value)</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>= 0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>3.49713in</Top>
                              <Height>0.99923in</Height>
                              <Width>8.49409in</Width>
                              <ZIndex>1</ZIndex>
                              <Style>
                                <BackgroundColor>White</BackgroundColor>
                              </Style>
                            </Tablix>
                            <Textbox Name="textbox247">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=first(Fields!Gen__Journal_Line__TABLECAPTION__________GenJnlLineFilter.Value)</Value>
                                      <Style>
                                        <FontSize>7pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                  <Style />
                                </Paragraph>
                              </Paragraphs>
                              <Height>0.16654in</Height>
                              <Width>8.49409in</Width>
                              <ZIndex>2</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!GenJnlLineFilter.value &lt;&gt; "", false, true)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                              <Style>
                                <BackgroundColor>White</BackgroundColor>
                                <VerticalAlign>Bottom</VerticalAlign>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>2pt</PaddingTop>
                                <PaddingBottom>2pt</PaddingBottom>
                              </Style>
                            </Textbox>
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
                      <GroupExpression>=Fields!Gen__Journal_Batch_Journal_Template_Name.Value</GroupExpression>
                      <GroupExpression>=Fields!Gen__Journal_Batch_Name.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                    <Filters>
                      <Filter>
                        <FilterExpression>=Len(Fields!Gen__Journal_Line__Document_No__.Value)</FilterExpression>
                        <Operator>GreaterThan</Operator>
                        <FilterValues>
                          <FilterValue>=0</FilterValue>
                        </FilterValues>
                      </Filter>
                    </Filters>
                  </Group>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Height>4.49635in</Height>
            <Width>8.7941in</Width>
            <Style>
              <BackgroundColor>White</BackgroundColor>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>4.49635in</Height>
        <Style />
      </Body>
      <Width>9.8622in</Width>
      <Page>
        <PageHeader>
          <Height>0.99921in</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="Gen__Journal_Batch__NameCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(6)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.66614in</Top>
              <Height>0.16654in</Height>
              <Width>1.1811in</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="Gen__Journal_Batch___Journal_Template_Name_Caption1">
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.49961in</Top>
              <Height>0.16654in</Height>
              <Width>1.1811in</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="CurrReport_PAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(3)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.16654in</Top>
              <Left>9.38976in</Left>
              <Height>0.16654in</Height>
              <Width>0.29528in</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="Gen__Journal_Batch__Name1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(7)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.66614in</Top>
              <Left>1.24016in</Left>
              <Height>0.16654in</Height>
              <Width>0.59055in</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="Gen__Journal_Batch___Journal_Template_Name_1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(5)</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.49961in</Top>
              <Left>1.24016in</Left>
              <Height>0.16654in</Height>
              <Width>0.59055in</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInformation_Name1">
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.16654in</Top>
              <Height>0.16654in</Height>
              <Width>2.95276in</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="ExecutionTimeTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Globals!ExecutionTime</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>f</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>7.83465in</Left>
              <Height>0.16654in</Height>
              <Width>2.02755in</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="UserIdTextBox">
              <CanGrow>true</CanGrow>
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
              <Top>0.33307in</Top>
              <Left>7.83465in</Left>
              <Height>0.16654in</Height>
              <Width>2.02755in</Width>
              <ZIndex>7</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
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
                      <Value>= Code.GetGroupPageNumber(Code.IsNewPage(Code.GetData(5),Code.GetData(7)),Globals!PageNumber)</Value>
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
              <Top>0.16654in</Top>
              <Left>9.68504in</Left>
              <Height>0.16654in</Height>
              <Width>0.17716in</Width>
              <ZIndex>8</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
        <PageHeight>21cm</PageHeight>
        <PageWidth>29.7cm</PageWidth>
        <InteractiveHeight>29.7cm</InteractiveHeight>
        <InteractiveWidth>21cm</InteractiveWidth>
        <LeftMargin>0.49213in</LeftMargin>
        <TopMargin>0.3937in</TopMargin>
        <BottomMargin>0.49213in</BottomMargin>
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

public Shared newPage as Object
Shared offset as Integer
Shared currentgroup1 as Object
Shared currentgroup2 as Object
Public Function GetGroupPageNumber(NewPage as Boolean,pagenumber as Integer) as Object 
 If NewPage
    offset = pagenumber - 1
  End If
  Return pagenumber - offset
End Function

Public Function IsNewPage(group1 as Object, group2 as Object) As Boolean
   newPage = FALSE
   If Not (group1 = currentgroup1)
       newPage = TRUE
       currentgroup1 = group1
       currentgroup2 = group2
   ELSE 
       If Not (group2 = currentgroup2)
           newPage = TRUE 
           currentgroup2 = group2
       End If
   End If
   Return newPage
End Function

Shared Data1 as Object
Public Function SetData(NewData as Object)
    if NewData &gt; "" then
        Data1 = NewData
    End if
    Return True
End Function

Public Function GetData(Num as integer) as Object
    Return Cstr(Choose(Num, Split(Cstr(Data1), Chr(177))))
End Function




 </Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Inch</rd:ReportUnitType>
  <rd:ReportID>8e230b3e-7302-493f-9a8f-fbc61b28ba7e</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

