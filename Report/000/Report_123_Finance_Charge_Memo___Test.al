OBJECT Report 123 Finance Charge Memo - Test
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Rentenota - kontrol;
               ENU=Finance Charge Memo - Test];
    OnInitReport=BEGIN
                   GLSetup.GET;
                 END;

    OnPreReport=BEGIN
                  FinChrgMemoHeaderFilter := "Finance Charge Memo Header".GETFILTERS;
                END;

  }
  DATASET
  {
    { 8733;    ;DataItem;                    ;
               DataItemTable=Table302;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Rentenota;
                                   ENU=Finance Charge Memo];
               OnAfterGetRecord=BEGIN
                                  CALCFIELDS("Remaining Amount");
                                  IF "Customer No." = '' THEN
                                    AddError(STRSUBSTNO(Text000,FIELDCAPTION("Customer No.")))
                                  ELSE BEGIN
                                    IF Cust.GET("Customer No.") THEN BEGIN
                                      IF Cust."Privacy Blocked" THEN
                                        AddError(Cust.GetPrivacyBlockedGenericErrorText(Cust));
                                      IF Cust.Blocked = Cust.Blocked::All THEN
                                        AddError(
                                          STRSUBSTNO(
                                            Text010,
                                            Cust.FIELDCAPTION(Blocked),Cust.Blocked,Cust.TABLECAPTION,"Customer No."));
                                      IF Cust."Currency Code" <> "Currency Code" THEN
                                        IF Cust."Currency Code" <> '' THEN
                                          AddError(
                                            STRSUBSTNO(
                                              Text002,
                                              FIELDCAPTION("Currency Code"),Cust."Currency Code"))
                                        ELSE
                                          AddError(
                                            STRSUBSTNO(
                                              Text002,
                                              FIELDCAPTION("Currency Code"),GLSetup."LCY Code"));
                                    END ELSE
                                      AddError(
                                        STRSUBSTNO(
                                          Text003,
                                          Cust.TABLECAPTION,"Customer No."));
                                  END;

                                  GLSetup.GET;

                                  IF "Posting Date" = 0D THEN
                                    AddError(STRSUBSTNO(Text000,FIELDCAPTION("Posting Date")))
                                  ELSE BEGIN
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
                                          Text004,FIELDCAPTION("Posting Date")));
                                  END;
                                  IF "Document Date" = 0D THEN
                                    AddError(STRSUBSTNO(Text000,FIELDCAPTION("Document Date")));
                                  IF "Due Date" = 0D THEN
                                    AddError(STRSUBSTNO(Text000,FIELDCAPTION("Due Date")));
                                  IF "Customer Posting Group" = '' THEN
                                    AddError(STRSUBSTNO(Text000,FIELDCAPTION("Customer Posting Group")));
                                  IF "Currency Code" = '' THEN BEGIN
                                    GLSetup.TESTFIELD("LCY Code");
                                    TotalText := STRSUBSTNO(Text005,GLSetup."LCY Code");
                                    TotalInclVATText := STRSUBSTNO(Text006,GLSetup."LCY Code");
                                  END ELSE BEGIN
                                    TotalText := STRSUBSTNO(Text005,"Currency Code");
                                    TotalInclVATText := STRSUBSTNO(Text006,"Currency Code");
                                  END;
                                  FormatAddr.FinanceChargeMemo(CustAddr,"Finance Charge Memo Header");
                                  IF "Your Reference" = '' THEN
                                    ReferenceText := ''
                                  ELSE
                                    ReferenceText := FIELDCAPTION("Your Reference");
                                  IF "VAT Registration No." = '' THEN
                                    VATNoText := ''
                                  ELSE
                                    VATNoText := FIELDCAPTION("VAT Registration No.");
                                  IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimCombErr);

                                  TableID[1] := DATABASE::Customer;
                                  No[1] := "Customer No.";
                                  IF NOT DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") THEN
                                    AddError(DimMgt.GetDimValuePostingErr);
                                END;

               ReqFilterFields=No. }

    { 8098;1   ;DataItem;PageCounter         ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 2   ;2   ;Column  ;TODAY               ;
               SourceExpr=TODAY }

    { 3   ;2   ;Column  ;COMPANYNAME         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 108 ;2   ;Column  ;PageCaption         ;
               SourceExpr=STRSUBSTNO(Text007,' ') }

    { 109 ;2   ;Column  ;Fin_Charge_Memo_Header___No__;
               SourceExpr="Finance Charge Memo Header"."No." }

    { 7   ;2   ;Column  ;STRSUBSTNO_Text008_FinChrgMemoHeaderFilter_;
               SourceExpr=STRSUBSTNO(Text008,FinChrgMemoHeaderFilter) }

    { 91  ;2   ;Column  ;FinChrgMemoHeaderFilter;
               SourceExpr=FinChrgMemoHeaderFilter }

    { 33  ;2   ;Column  ;STRSUBSTNO___1__2___Finance_Charge_Memo_Header___No___Cust_Name_;
               SourceExpr=STRSUBSTNO('%1 %2',"Finance Charge Memo Header"."No.",Cust.Name) }

    { 14  ;2   ;Column  ;CustAddr_8_         ;
               SourceExpr=CustAddr[8] }

    { 15  ;2   ;Column  ;CustAddr_7_         ;
               SourceExpr=CustAddr[7] }

    { 18  ;2   ;Column  ;CustAddr_6_         ;
               SourceExpr=CustAddr[6] }

    { 19  ;2   ;Column  ;CustAddr_5_         ;
               SourceExpr=CustAddr[5] }

    { 21  ;2   ;Column  ;CustAddr_4_         ;
               SourceExpr=CustAddr[4] }

    { 22  ;2   ;Column  ;CustAddr_3_         ;
               SourceExpr=CustAddr[3] }

    { 23  ;2   ;Column  ;CustAddr_2_         ;
               SourceExpr=CustAddr[2] }

    { 24  ;2   ;Column  ;CustAddr_1_         ;
               SourceExpr=CustAddr[1] }

    { 67  ;2   ;Column  ;Finance_Charge_Memo_Header___Customer_No__;
               SourceExpr="Finance Charge Memo Header"."Customer No." }

    { 53  ;2   ;Column  ;Finance_Charge_Memo_Header___Document_Date_;
               SourceExpr=FORMAT("Finance Charge Memo Header"."Document Date") }

    { 57  ;2   ;Column  ;Finance_Charge_Memo_Header___Posting_Date_;
               SourceExpr=FORMAT("Finance Charge Memo Header"."Posting Date") }

    { 37  ;2   ;Column  ;Finance_Charge_Memo_Header___VAT_Registration_No__;
               SourceExpr="Finance Charge Memo Header"."VAT Registration No." }

    { 41  ;2   ;Column  ;Finance_Charge_Memo_Header___Your_Reference_;
               SourceExpr="Finance Charge Memo Header"."Your Reference" }

    { 81  ;2   ;Column  ;Finance_Charge_Memo_Header___Due_Date_;
               SourceExpr=FORMAT("Finance Charge Memo Header"."Due Date") }

    { 8   ;2   ;Column  ;Finance_Charge_Memo_Header___Post_Additional_Fee_;
               SourceExpr=FORMAT("Finance Charge Memo Header"."Post Additional Fee") }

    { 83  ;2   ;Column  ;Finance_Charge_Memo_Header___Post_Interest_;
               SourceExpr=FORMAT("Finance Charge Memo Header"."Post Interest") }

    { 85  ;2   ;Column  ;Finance_Charge_Memo_Header___Fin__Charge_Terms_Code_;
               SourceExpr="Finance Charge Memo Header"."Fin. Charge Terms Code" }

    { 42  ;2   ;Column  ;ReferenceText       ;
               SourceExpr=ReferenceText }

    { 40  ;2   ;Column  ;VATNoText           ;
               SourceExpr=VATNoText }

    { 1   ;2   ;Column  ;Finance_Charge_Memo___TestCaption;
               SourceExpr=Finance_Charge_Memo___TestCaptionLbl }

    { 74  ;2   ;Column  ;Finance_Charge_Memo_Header___Customer_No__Caption;
               SourceExpr="Finance Charge Memo Header".FIELDCAPTION("Customer No.") }

    { 71  ;2   ;Column  ;Finance_Charge_Memo_Header___Document_Date_Caption;
               SourceExpr=Finance_Charge_Memo_Header___Document_Date_CaptionLbl }

    { 75  ;2   ;Column  ;Finance_Charge_Memo_Header___Posting_Date_Caption;
               SourceExpr=Finance_Charge_Memo_Header___Posting_Date_CaptionLbl }

    { 82  ;2   ;Column  ;Finance_Charge_Memo_Header___Due_Date_Caption;
               SourceExpr=Finance_Charge_Memo_Header___Due_Date_CaptionLbl }

    { 32  ;2   ;Column  ;Finance_Charge_Memo_Header___Post_Additional_Fee_Caption;
               SourceExpr=CAPTIONCLASSTRANSLATE("Finance Charge Memo Header".FIELDCAPTION("Post Additional Fee")) }

    { 84  ;2   ;Column  ;Finance_Charge_Memo_Header___Post_Interest_Caption;
               SourceExpr=CAPTIONCLASSTRANSLATE("Finance Charge Memo Header".FIELDCAPTION("Post Interest")) }

    { 86  ;2   ;Column  ;Finance_Charge_Memo_Header___Fin__Charge_Terms_Code_Caption;
               SourceExpr="Finance Charge Memo Header".FIELDCAPTION("Fin. Charge Terms Code") }

    { 9775;2   ;DataItem;DimensionLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowDim THEN
                                 CurrReport.BREAK;
                               DimSetEntry.SETRANGE("Dimension Set ID","Finance Charge Memo Header"."Dimension Set ID");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry.FINDSET THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF NOT Continue THEN
                                      CurrReport.BREAK;

                                  CLEAR(DimText);
                                  REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                      DimText := STRSUBSTNO('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
                                    ELSE
                                      DimText :=
                                        STRSUBSTNO(
                                          '%1; %2 - %3',DimText,DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                      DimText := OldDimText;
                                      EXIT;
                                    END;
                                  UNTIL DimSetEntry.NEXT = 0;
                                END;
                                 }

    { 174 ;3   ;Column  ;DimText             ;
               SourceExpr=DimText }

    { 95  ;3   ;Column  ;DimensionLoop_Number;
               SourceExpr=Number }

    { 186 ;3   ;Column  ;Header_DimensionsCaption;
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

    { 69  ;3   ;Column  ;ErrorText_Number_   ;
               SourceExpr=ErrorText[Number] }

    { 68  ;3   ;Column  ;ErrorText_Number_Caption;
               SourceExpr=ErrorText_Number_CaptionLbl }

    { 9507;2   ;DataItem;BeginningText       ;
               DataItemTable=Table303;
               DataItemTableView=SORTING(Finance Charge Memo No.,Line No.);
               OnPreDataItem=BEGIN
                               IF FIND('-') THEN BEGIN
                                 StartLineNo := 0;
                                 REPEAT
                                   Continue := Type = Type::" ";
                                   IF Continue AND (Description <> '') THEN
                                     StartLineNo := "Line No.";
                                 UNTIL (NEXT = 0) OR NOT Continue;
                               END;
                               SETRANGE("Line No.",0,StartLineNo);
                             END;

               DataItemLinkReference=Finance Charge Memo Header;
               DataItemLink=Finance Charge Memo No.=FIELD(No.) }

    { 16  ;3   ;Column  ;BeginningText_Description;
               SourceExpr=Description }

    { 110 ;3   ;Column  ;StartLineNo         ;
               SourceExpr=StartLineNo }

    { 9546;2   ;DataItem;                    ;
               DataItemTable=Table303;
               DataItemTableView=SORTING(Finance Charge Memo No.,Line No.);
               OnPreDataItem=BEGIN
                               IF FIND('+') THEN BEGIN
                                 EndLineNo := "Line No." + 1;
                                 REPEAT
                                   Continue := Type = Type::" ";
                                   IF Continue AND (Description <> '') THEN
                                     EndLineNo := "Line No.";
                                 UNTIL (NEXT(-1) = 0) OR NOT Continue;
                               END;
                               SETRANGE("Line No.",StartLineNo + 1,EndLineNo - 1);
                               VATAmountLine.DELETEALL;
                               CurrReport.CREATETOTALS(Amount,"VAT Amount");

                               TotalAmount := 0;
                               TotalVatAmount := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  VATAmountLine.INIT;
                                  VATAmountLine."VAT Identifier" := "VAT Identifier";
                                  VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                  VATAmountLine."Tax Group Code" := "Tax Group Code";
                                  VATAmountLine."VAT %" := "VAT %";
                                  VATAmountLine."VAT Base" := Amount;
                                  VATAmountLine."VAT Amount" := "VAT Amount";
                                  VATAmountLine."Amount Including VAT" := Amount + "VAT Amount";
                                  VATAmountLine.InsertLine;

                                  CASE Type OF
                                    Type::"Customer Ledger Entry":
                                      BEGIN
                                        IF Amount < 0 THEN
                                          AddError(
                                            STRSUBSTNO(
                                              Text009,
                                              FIELDCAPTION(Amount)));
                                      END;
                                  END;

                                  TotalAmount += Amount;
                                  TotalVatAmount += "VAT Amount";
                                END;

               DataItemLinkReference=Finance Charge Memo Header;
               DataItemLink=Finance Charge Memo No.=FIELD(No.) }

    { 104 ;3   ;Column  ;ShowFinChMemoLine1  ;
               SourceExpr=("Line No." > StartLineNo) AND (Type = Type::"Customer Ledger Entry") }

    { 105 ;3   ;Column  ;ShowFinChMemoLine2  ;
               SourceExpr=("Line No." > StartLineNo) AND (Type <> Type::"Customer Ledger Entry") }

    { 106 ;3   ;Column  ;TotalVatAmount      ;
               SourceExpr=TotalVatAmount }

    { 107 ;3   ;Column  ;TotalAmount         ;
               SourceExpr=TotalAmount }

    { 10  ;3   ;Column  ;Finance_Charge_Memo_Line__Document_No__;
               SourceExpr="Document No." }

    { 12  ;3   ;Column  ;Finance_Charge_Memo_Line_Description;
               SourceExpr=Description }

    { 26  ;3   ;Column  ;Finance_Charge_Memo_Line__Original_Amount_;
               SourceExpr="Original Amount" }

    { 28  ;3   ;Column  ;Finance_Charge_Memo_Line__Remaining_Amount_;
               SourceExpr="Remaining Amount" }

    { 31  ;3   ;Column  ;Finance_Charge_Memo_Line__Document_Date_;
               SourceExpr=FORMAT("Document Date") }

    { 9   ;3   ;Column  ;Finance_Charge_Memo_Line_Amount;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 38  ;3   ;Column  ;Finance_Charge_Memo_Line__Due_Date_;
               SourceExpr=FORMAT("Due Date") }

    { 17  ;3   ;Column  ;Finance_Charge_Memo_Line__Document_Type_;
               SourceExpr="Document Type" }

    { 61  ;3   ;Column  ;Finance_Charge_Memo_Line_Amount_Control61;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 111 ;3   ;Column  ;FinChMemo_Line___Line_No__;
               SourceExpr="Line No." }

    { 29  ;3   ;Column  ;Finance_Charge_Memo_Line_Amount_Control29;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 43  ;3   ;Column  ;TotalText           ;
               SourceExpr=TotalText }

    { 44  ;3   ;Column  ;Finance_Charge_Memo_Line__VAT_Amount_;
               SourceExpr="VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 46  ;3   ;Column  ;TotalInclVATText    ;
               SourceExpr=TotalInclVATText }

    { 47  ;3   ;Column  ;Amount____VAT_Amount_;
               SourceExpr=Amount + "VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr=GetCurrencyCode }

    { 25  ;3   ;Column  ;Finance_Charge_Memo_Line_DescriptionCaption;
               SourceExpr=FIELDCAPTION(Description) }

    { 27  ;3   ;Column  ;Finance_Charge_Memo_Line__Original_Amount_Caption;
               SourceExpr=FIELDCAPTION("Original Amount") }

    { 30  ;3   ;Column  ;Finance_Charge_Memo_Line__Remaining_Amount_Caption;
               SourceExpr=FIELDCAPTION("Remaining Amount") }

    { 11  ;3   ;Column  ;Finance_Charge_Memo_Line__Document_No__Caption;
               SourceExpr=FIELDCAPTION("Document No.") }

    { 35  ;3   ;Column  ;Finance_Charge_Memo_Line__Document_Date_Caption;
               SourceExpr=Finance_Charge_Memo_Line__Document_Date_CaptionLbl }

    { 4   ;3   ;Column  ;Finance_Charge_Memo_Line_AmountCaption;
               SourceExpr=FIELDCAPTION(Amount) }

    { 34  ;3   ;Column  ;Finance_Charge_Memo_Line__Due_Date_Caption;
               SourceExpr=Finance_Charge_Memo_Line__Due_Date_CaptionLbl }

    { 36  ;3   ;Column  ;Finance_Charge_Memo_Line__Document_Type_Caption;
               SourceExpr=FIELDCAPTION("Document Type") }

    { 48  ;3   ;Column  ;Finance_Charge_Memo_Line__VAT_Amount_Caption;
               SourceExpr=FIELDCAPTION("VAT Amount") }

    { 2217;3   ;DataItem;LineErrorCounter    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               SETRANGE(Number,1,ErrorCounter);
                             END;

               OnPostDataItem=BEGIN
                                ErrorCounter := 0;
                              END;
                               }

    { 97  ;4   ;Column  ;ErrorText_Number__Control97;
               SourceExpr=ErrorText[Number] }

    { 96  ;4   ;Column  ;ErrorText_Number__Control97Caption;
               SourceExpr=ErrorText_Number__Control97CaptionLbl }

    { 8620;2   ;DataItem;ReminderLine2       ;
               DataItemTable=Table303;
               DataItemTableView=SORTING(Finance Charge Memo No.,Line No.);
               OnPreDataItem=BEGIN
                               SETFILTER("Line No.",'>=%1',EndLineNo);
                             END;

               DataItemLinkReference=Finance Charge Memo Header;
               DataItemLink=Finance Charge Memo No.=FIELD(No.) }

    { 13  ;3   ;Column  ;ReminderLine2_Description;
               SourceExpr=Description }

    { 112 ;3   ;Column  ;ReminderLine2__Line_No__;
               SourceExpr="Line No." }

    { 6558;2   ;DataItem;VATCounter          ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF TotalVatAmount = 0 THEN
                                 CurrReport.BREAK;
                               SETRANGE(Number,1,VATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(VATAmountLine."VAT Base",VATAmountLine."VAT Amount",VATAmountLine."Amount Including VAT");
                             END;

               OnAfterGetRecord=BEGIN
                                  VATAmountLine.GetLine(Number);
                                END;
                                 }

    { 62  ;3   ;Column  ;VATAmountLine__VAT_Amount_;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Finance Charge Memo Line".GetCurrencyCode }

    { 59  ;3   ;Column  ;VATAmountLine__VAT_Base_;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Finance Charge Memo Line".GetCurrencyCode }

    { 76  ;3   ;Column  ;VATAmountLine__Amount_Including_VAT_;
               SourceExpr=VATAmountLine."Amount Including VAT";
               AutoFormatType=1;
               AutoFormatExpr="Finance Charge Memo Line".GetCurrencyCode }

    { 55  ;3   ;Column  ;VATAmountLine__VAT_Amount__Control55;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Finance Charge Memo Line".GetCurrencyCode }

    { 56  ;3   ;Column  ;VATAmountLine__VAT_Base__Control56;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Finance Charge Memo Line".GetCurrencyCode }

    { 58  ;3   ;Column  ;VATAmountLine__VAT___;
               SourceExpr=VATAmountLine."VAT %" }

    { 73  ;3   ;Column  ;VATAmountLine__Amount_Including_VAT__Control73;
               SourceExpr=VATAmountLine."Amount Including VAT";
               AutoFormatType=1;
               AutoFormatExpr="Finance Charge Memo Line".GetCurrencyCode }

    { 45  ;3   ;Column  ;VATAmountLine__VAT_Amount__Control45;
               SourceExpr=VATAmountLine."VAT Amount";
               AutoFormatType=1;
               AutoFormatExpr="Finance Charge Memo Line".GetCurrencyCode }

    { 49  ;3   ;Column  ;VATAmountLine__VAT_Base__Control49;
               SourceExpr=VATAmountLine."VAT Base";
               AutoFormatType=1;
               AutoFormatExpr="Finance Charge Memo Line".GetCurrencyCode }

    { 80  ;3   ;Column  ;VATAmountLine__Amount_Including_VAT__Control80;
               SourceExpr=VATAmountLine."Amount Including VAT";
               AutoFormatType=1;
               AutoFormatExpr="Finance Charge Memo Line".GetCurrencyCode }

    { 64  ;3   ;Column  ;VATAmountLine__VAT_Amount__Control55Caption;
               SourceExpr=VATAmountLine__VAT_Amount__Control55CaptionLbl }

    { 65  ;3   ;Column  ;VATAmountLine__VAT_Base__Control56Caption;
               SourceExpr=VATAmountLine__VAT_Base__Control56CaptionLbl }

    { 70  ;3   ;Column  ;VAT_Amount_SpecificationCaption;
               SourceExpr=VAT_Amount_SpecificationCaptionLbl }

    { 66  ;3   ;Column  ;VATAmountLine__VAT___Caption;
               SourceExpr=VATAmountLine__VAT___CaptionLbl }

    { 79  ;3   ;Column  ;VATAmountLine__Amount_Including_VAT__Control73Caption;
               SourceExpr=VATAmountLine__Amount_Including_VAT__Control73CaptionLbl }

    { 50  ;3   ;Column  ;VATAmountLine__VAT_Base__Control49Caption;
               SourceExpr=VATAmountLine__VAT_Base__Control49CaptionLbl }

    { 2038;2   ;DataItem;VATCounterLCY       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF (NOT GLSetup."Print VAT specification in LCY") OR
                                  ("Finance Charge Memo Header"."Currency Code" = '') OR
                                  (VATAmountLine.GetTotalVATAmount = 0)
                               THEN
                                 CurrReport.BREAK;

                               SETRANGE(Number,1,VATAmountLine.COUNT);
                               CurrReport.CREATETOTALS(VALVATBaseLCY,VALVATAmountLCY);

                               IF GLSetup."LCY Code" = '' THEN
                                 VALSpecLCYHeader := Text011 + Text012
                               ELSE
                                 VALSpecLCYHeader := Text011 + FORMAT(GLSetup."LCY Code");

                               CurrExchRate.FindCurrency("Finance Charge Memo Header"."Posting Date","Finance Charge Memo Header"."Currency Code",1);
                               VALExchRate := STRSUBSTNO(Text013,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
                               CurrFactor := CurrExchRate.ExchangeRate("Finance Charge Memo Header"."Posting Date",
                                   "Finance Charge Memo Header"."Currency Code");
                             END;

               OnAfterGetRecord=BEGIN
                                  VATAmountLine.GetLine(Number);

                                  VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                        "Finance Charge Memo Header"."Posting Date","Finance Charge Memo Header"."Currency Code",
                                        VATAmountLine."VAT Base",CurrFactor));
                                  VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                        "Finance Charge Memo Header"."Posting Date","Finance Charge Memo Header"."Currency Code",
                                        VATAmountLine."VAT Amount",CurrFactor));
                                END;
                                 }

    { 39  ;3   ;Column  ;VALExchRate         ;
               SourceExpr=VALExchRate }

    { 87  ;3   ;Column  ;VALSpecLCYHeader    ;
               SourceExpr=VALSpecLCYHeader }

    { 89  ;3   ;Column  ;VALVATAmountLCY     ;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 90  ;3   ;Column  ;VALVATBaseLCY       ;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 92  ;3   ;Column  ;VALVATAmountLCY_Control92;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 93  ;3   ;Column  ;VALVATBaseLCY_Control93;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 94  ;3   ;Column  ;VATAmountLine__VAT____Control94;
               DecimalPlaces=0:5;
               SourceExpr=VATAmountLine."VAT %" }

    { 101 ;3   ;Column  ;VALVATAmountLCY_Control101;
               SourceExpr=VALVATAmountLCY;
               AutoFormatType=1 }

    { 102 ;3   ;Column  ;VALVATBaseLCY_Control102;
               SourceExpr=VALVATBaseLCY;
               AutoFormatType=1 }

    { 63  ;3   ;Column  ;VALVATAmountLCY_Control92Caption;
               SourceExpr=VALVATAmountLCY_Control92CaptionLbl }

    { 72  ;3   ;Column  ;VALVATBaseLCY_Control93Caption;
               SourceExpr=VALVATBaseLCY_Control93CaptionLbl }

    { 77  ;3   ;Column  ;VATAmountLine__VAT____Control94Caption;
               SourceExpr=VATAmountLine__VAT____Control94CaptionLbl }

    { 103 ;3   ;Column  ;VALVATBaseLCY_Control102Caption;
               SourceExpr=VALVATBaseLCY_Control102CaptionLbl }

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
      Text000@1000 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be specified.';
      Text002@1002 : TextConst 'DAN=%1 skal v�re %2.;ENU=%1 must be %2.';
      Text003@1003 : TextConst 'DAN=%1 %2 findes ikke.;ENU=%1 %2 does not exist.';
      Text004@1004 : TextConst 'DAN=%1 er ikke inden for den tilladte bogf�ringsperiode.;ENU=%1 is not within your allowed range of posting dates.';
      Text005@1005 : TextConst 'DAN=I alt %1;ENU=Total %1';
      Text006@1006 : TextConst 'DAN=I alt %1 inkl. moms;ENU=Total %1 Incl. VAT';
      Text007@1007 : TextConst 'DAN=Side %1;ENU=Page %1';
      Text008@1008 : TextConst 'DAN=Rentenota: %1;ENU=Finance Charge Memo: %1';
      Text009@1009 : TextConst 'DAN=%1 skal v�re positivtal eller 0.;ENU=%1 must be positive or 0.';
      GLSetup@1010 : Record 98;
      UserSetup@1011 : Record 91;
      Cust@1012 : Record 18;
      VATAmountLine@1013 : TEMPORARY Record 290;
      DimSetEntry@1014 : Record 480;
      CurrExchRate@1040 : Record 330;
      DimMgt@1015 : Codeunit 408;
      FormatAddr@1032 : Codeunit 365;
      CustAddr@1016 : ARRAY [8] OF Text[50];
      FinChrgMemoHeaderFilter@1017 : Text;
      AllowPostingFrom@1018 : Date;
      AllowPostingTo@1019 : Date;
      StartLineNo@1020 : Integer;
      EndLineNo@1021 : Integer;
      Continue@1022 : Boolean;
      VATNoText@1023 : Text[80];
      ReferenceText@1024 : Text[80];
      TotalText@1025 : Text[50];
      TotalInclVATText@1026 : Text[50];
      ErrorCounter@1027 : Integer;
      ErrorText@1028 : ARRAY [99] OF Text[250];
      DimText@1029 : Text[120];
      OldDimText@1030 : Text[75];
      ShowDim@1031 : Boolean;
      TableID@1033 : ARRAY [10] OF Integer;
      No@1034 : ARRAY [10] OF Code[20];
      Text010@1035 : TextConst 'DAN=%1 m� ikke v�re %2 for %3 %4.;ENU=%1 must not be %2 for %3 %4.';
      VALVATBaseLCY@1039 : Decimal;
      VALVATAmountLCY@1038 : Decimal;
      VALSpecLCYHeader@1037 : Text[80];
      VALExchRate@1036 : Text[50];
      Text011@1043 : TextConst 'DAN="Momsbel�bsspecifikation i ";ENU="VAT Amount Specification in "';
      Text012@1042 : TextConst 'DAN=Lokal valuta;ENU=Local Currency';
      Text013@1041 : TextConst 'DAN=Valutakurs: %1/%2;ENU=Exchange rate: %1/%2';
      CurrFactor@1044 : Decimal;
      TotalAmount@1001 : Decimal;
      TotalVatAmount@1045 : Decimal;
      Finance_Charge_Memo___TestCaptionLbl@8241 : TextConst 'DAN=Rentenota - kontrol;ENU=Finance Charge Memo - Test';
      Finance_Charge_Memo_Header___Document_Date_CaptionLbl@3484 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      Finance_Charge_Memo_Header___Posting_Date_CaptionLbl@7918 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      Finance_Charge_Memo_Header___Due_Date_CaptionLbl@3054 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      Header_DimensionsCaptionLbl@4011 : TextConst 'DAN=Dimensioner - hoved;ENU=Header Dimensions';
      ErrorText_Number_CaptionLbl@5070 : TextConst 'DAN=Advarsel!;ENU=Warning!';
      Finance_Charge_Memo_Line__Document_Date_CaptionLbl@6938 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      Finance_Charge_Memo_Line__Due_Date_CaptionLbl@9433 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      ErrorText_Number__Control97CaptionLbl@5440 : TextConst 'DAN=Advarsel!;ENU=Warning!';
      VATAmountLine__VAT_Amount__Control55CaptionLbl@4668 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VATAmountLine__VAT_Base__Control56CaptionLbl@9164 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VAT_Amount_SpecificationCaptionLbl@5688 : TextConst 'DAN=Momsbel�bspecifikation;ENU=VAT Amount Specification';
      VATAmountLine__VAT___CaptionLbl@6736 : TextConst 'DAN=Momspct.;ENU=VAT %';
      VATAmountLine__Amount_Including_VAT__Control73CaptionLbl@6724 : TextConst 'DAN=Bel�b inkl. moms;ENU=Amount Including VAT';
      VATAmountLine__VAT_Base__Control49CaptionLbl@5249 : TextConst 'DAN=I alt;ENU=Total';
      VALVATAmountLCY_Control92CaptionLbl@5300 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      VALVATBaseLCY_Control93CaptionLbl@1683 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATAmountLine__VAT____Control94CaptionLbl@4839 : TextConst 'DAN=Momspct.;ENU=VAT %';
      VALVATBaseLCY_Control102CaptionLbl@3138 : TextConst 'DAN=I alt;ENU=Total';

    LOCAL PROCEDURE AddError@1(Text@1000 : Text[250]);
    BEGIN
      ErrorCounter := ErrorCounter + 1;
      ErrorText[ErrorCounter] := Text;
    END;

    PROCEDURE InitializeRequest@2(NewShowDim@1000 : Boolean);
    BEGIN
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
      <rd:DataSourceID>2a4733d5-e33c-4a22-b712-6ff4cb4c049e</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="TODAY">
          <DataField>TODAY</DataField>
        </Field>
        <Field Name="COMPANYNAME">
          <DataField>COMPANYNAME</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="Fin_Charge_Memo_Header___No__">
          <DataField>Fin_Charge_Memo_Header___No__</DataField>
        </Field>
        <Field Name="STRSUBSTNO_Text008_FinChrgMemoHeaderFilter_">
          <DataField>STRSUBSTNO_Text008_FinChrgMemoHeaderFilter_</DataField>
        </Field>
        <Field Name="FinChrgMemoHeaderFilter">
          <DataField>FinChrgMemoHeaderFilter</DataField>
        </Field>
        <Field Name="STRSUBSTNO___1__2___Finance_Charge_Memo_Header___No___Cust_Name_">
          <DataField>STRSUBSTNO___1__2___Finance_Charge_Memo_Header___No___Cust_Name_</DataField>
        </Field>
        <Field Name="CustAddr_8_">
          <DataField>CustAddr_8_</DataField>
        </Field>
        <Field Name="CustAddr_7_">
          <DataField>CustAddr_7_</DataField>
        </Field>
        <Field Name="CustAddr_6_">
          <DataField>CustAddr_6_</DataField>
        </Field>
        <Field Name="CustAddr_5_">
          <DataField>CustAddr_5_</DataField>
        </Field>
        <Field Name="CustAddr_4_">
          <DataField>CustAddr_4_</DataField>
        </Field>
        <Field Name="CustAddr_3_">
          <DataField>CustAddr_3_</DataField>
        </Field>
        <Field Name="CustAddr_2_">
          <DataField>CustAddr_2_</DataField>
        </Field>
        <Field Name="CustAddr_1_">
          <DataField>CustAddr_1_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Customer_No__">
          <DataField>Finance_Charge_Memo_Header___Customer_No__</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Document_Date_">
          <DataField>Finance_Charge_Memo_Header___Document_Date_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Posting_Date_">
          <DataField>Finance_Charge_Memo_Header___Posting_Date_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___VAT_Registration_No__">
          <DataField>Finance_Charge_Memo_Header___VAT_Registration_No__</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Your_Reference_">
          <DataField>Finance_Charge_Memo_Header___Your_Reference_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Due_Date_">
          <DataField>Finance_Charge_Memo_Header___Due_Date_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Post_Additional_Fee_">
          <DataField>Finance_Charge_Memo_Header___Post_Additional_Fee_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Post_Interest_">
          <DataField>Finance_Charge_Memo_Header___Post_Interest_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Fin__Charge_Terms_Code_">
          <DataField>Finance_Charge_Memo_Header___Fin__Charge_Terms_Code_</DataField>
        </Field>
        <Field Name="ReferenceText">
          <DataField>ReferenceText</DataField>
        </Field>
        <Field Name="VATNoText">
          <DataField>VATNoText</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo___TestCaption">
          <DataField>Finance_Charge_Memo___TestCaption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Customer_No__Caption">
          <DataField>Finance_Charge_Memo_Header___Customer_No__Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Document_Date_Caption">
          <DataField>Finance_Charge_Memo_Header___Document_Date_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Posting_Date_Caption">
          <DataField>Finance_Charge_Memo_Header___Posting_Date_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Due_Date_Caption">
          <DataField>Finance_Charge_Memo_Header___Due_Date_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Post_Additional_Fee_Caption">
          <DataField>Finance_Charge_Memo_Header___Post_Additional_Fee_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Post_Interest_Caption">
          <DataField>Finance_Charge_Memo_Header___Post_Interest_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Header___Fin__Charge_Terms_Code_Caption">
          <DataField>Finance_Charge_Memo_Header___Fin__Charge_Terms_Code_Caption</DataField>
        </Field>
        <Field Name="DimText">
          <DataField>DimText</DataField>
        </Field>
        <Field Name="DimensionLoop_Number">
          <DataField>DimensionLoop_Number</DataField>
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
        <Field Name="BeginningText_Description">
          <DataField>BeginningText_Description</DataField>
        </Field>
        <Field Name="StartLineNo">
          <DataField>StartLineNo</DataField>
        </Field>
        <Field Name="ShowFinChMemoLine1">
          <DataField>ShowFinChMemoLine1</DataField>
        </Field>
        <Field Name="ShowFinChMemoLine2">
          <DataField>ShowFinChMemoLine2</DataField>
        </Field>
        <Field Name="TotalVatAmount">
          <DataField>TotalVatAmount</DataField>
        </Field>
        <Field Name="TotalVatAmountFormat">
          <DataField>TotalVatAmountFormat</DataField>
        </Field>
        <Field Name="TotalAmount">
          <DataField>TotalAmount</DataField>
        </Field>
        <Field Name="TotalAmountFormat">
          <DataField>TotalAmountFormat</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Document_No__">
          <DataField>Finance_Charge_Memo_Line__Document_No__</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line_Description">
          <DataField>Finance_Charge_Memo_Line_Description</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Original_Amount_">
          <DataField>Finance_Charge_Memo_Line__Original_Amount_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Original_Amount_Format">
          <DataField>Finance_Charge_Memo_Line__Original_Amount_Format</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Remaining_Amount_">
          <DataField>Finance_Charge_Memo_Line__Remaining_Amount_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Remaining_Amount_Format">
          <DataField>Finance_Charge_Memo_Line__Remaining_Amount_Format</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Document_Date_">
          <DataField>Finance_Charge_Memo_Line__Document_Date_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line_Amount">
          <DataField>Finance_Charge_Memo_Line_Amount</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line_AmountFormat">
          <DataField>Finance_Charge_Memo_Line_AmountFormat</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Due_Date_">
          <DataField>Finance_Charge_Memo_Line__Due_Date_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Document_Type_">
          <DataField>Finance_Charge_Memo_Line__Document_Type_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line_Amount_Control61">
          <DataField>Finance_Charge_Memo_Line_Amount_Control61</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line_Amount_Control61Format">
          <DataField>Finance_Charge_Memo_Line_Amount_Control61Format</DataField>
        </Field>
        <Field Name="FinChMemo_Line___Line_No__">
          <DataField>FinChMemo_Line___Line_No__</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line_Amount_Control29">
          <DataField>Finance_Charge_Memo_Line_Amount_Control29</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line_Amount_Control29Format">
          <DataField>Finance_Charge_Memo_Line_Amount_Control29Format</DataField>
        </Field>
        <Field Name="TotalText">
          <DataField>TotalText</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__VAT_Amount_">
          <DataField>Finance_Charge_Memo_Line__VAT_Amount_</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__VAT_Amount_Format">
          <DataField>Finance_Charge_Memo_Line__VAT_Amount_Format</DataField>
        </Field>
        <Field Name="TotalInclVATText">
          <DataField>TotalInclVATText</DataField>
        </Field>
        <Field Name="Amount____VAT_Amount_">
          <DataField>Amount____VAT_Amount_</DataField>
        </Field>
        <Field Name="Amount____VAT_Amount_Format">
          <DataField>Amount____VAT_Amount_Format</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line_DescriptionCaption">
          <DataField>Finance_Charge_Memo_Line_DescriptionCaption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Original_Amount_Caption">
          <DataField>Finance_Charge_Memo_Line__Original_Amount_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Remaining_Amount_Caption">
          <DataField>Finance_Charge_Memo_Line__Remaining_Amount_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Document_No__Caption">
          <DataField>Finance_Charge_Memo_Line__Document_No__Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Document_Date_Caption">
          <DataField>Finance_Charge_Memo_Line__Document_Date_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line_AmountCaption">
          <DataField>Finance_Charge_Memo_Line_AmountCaption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Due_Date_Caption">
          <DataField>Finance_Charge_Memo_Line__Due_Date_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__Document_Type_Caption">
          <DataField>Finance_Charge_Memo_Line__Document_Type_Caption</DataField>
        </Field>
        <Field Name="Finance_Charge_Memo_Line__VAT_Amount_Caption">
          <DataField>Finance_Charge_Memo_Line__VAT_Amount_Caption</DataField>
        </Field>
        <Field Name="ErrorText_Number__Control97">
          <DataField>ErrorText_Number__Control97</DataField>
        </Field>
        <Field Name="ErrorText_Number__Control97Caption">
          <DataField>ErrorText_Number__Control97Caption</DataField>
        </Field>
        <Field Name="ReminderLine2_Description">
          <DataField>ReminderLine2_Description</DataField>
        </Field>
        <Field Name="ReminderLine2__Line_No__">
          <DataField>ReminderLine2__Line_No__</DataField>
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
        <Field Name="VATAmountLine__Amount_Including_VAT_">
          <DataField>VATAmountLine__Amount_Including_VAT_</DataField>
        </Field>
        <Field Name="VATAmountLine__Amount_Including_VAT_Format">
          <DataField>VATAmountLine__Amount_Including_VAT_Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control55">
          <DataField>VATAmountLine__VAT_Amount__Control55</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control55Format">
          <DataField>VATAmountLine__VAT_Amount__Control55Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control56">
          <DataField>VATAmountLine__VAT_Base__Control56</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control56Format">
          <DataField>VATAmountLine__VAT_Base__Control56Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT___">
          <DataField>VATAmountLine__VAT___</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT___Format">
          <DataField>VATAmountLine__VAT___Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Amount_Including_VAT__Control73">
          <DataField>VATAmountLine__Amount_Including_VAT__Control73</DataField>
        </Field>
        <Field Name="VATAmountLine__Amount_Including_VAT__Control73Format">
          <DataField>VATAmountLine__Amount_Including_VAT__Control73Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control45">
          <DataField>VATAmountLine__VAT_Amount__Control45</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control45Format">
          <DataField>VATAmountLine__VAT_Amount__Control45Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control49">
          <DataField>VATAmountLine__VAT_Base__Control49</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control49Format">
          <DataField>VATAmountLine__VAT_Base__Control49Format</DataField>
        </Field>
        <Field Name="VATAmountLine__Amount_Including_VAT__Control80">
          <DataField>VATAmountLine__Amount_Including_VAT__Control80</DataField>
        </Field>
        <Field Name="VATAmountLine__Amount_Including_VAT__Control80Format">
          <DataField>VATAmountLine__Amount_Including_VAT__Control80Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Amount__Control55Caption">
          <DataField>VATAmountLine__VAT_Amount__Control55Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control56Caption">
          <DataField>VATAmountLine__VAT_Base__Control56Caption</DataField>
        </Field>
        <Field Name="VAT_Amount_SpecificationCaption">
          <DataField>VAT_Amount_SpecificationCaption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT___Caption">
          <DataField>VATAmountLine__VAT___Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__Amount_Including_VAT__Control73Caption">
          <DataField>VATAmountLine__Amount_Including_VAT__Control73Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT_Base__Control49Caption">
          <DataField>VATAmountLine__VAT_Base__Control49Caption</DataField>
        </Field>
        <Field Name="VALExchRate">
          <DataField>VALExchRate</DataField>
        </Field>
        <Field Name="VALSpecLCYHeader">
          <DataField>VALSpecLCYHeader</DataField>
        </Field>
        <Field Name="VALVATAmountLCY">
          <DataField>VALVATAmountLCY</DataField>
        </Field>
        <Field Name="VALVATAmountLCYFormat">
          <DataField>VALVATAmountLCYFormat</DataField>
        </Field>
        <Field Name="VALVATBaseLCY">
          <DataField>VALVATBaseLCY</DataField>
        </Field>
        <Field Name="VALVATBaseLCYFormat">
          <DataField>VALVATBaseLCYFormat</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control92">
          <DataField>VALVATAmountLCY_Control92</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control92Format">
          <DataField>VALVATAmountLCY_Control92Format</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control93">
          <DataField>VALVATBaseLCY_Control93</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control93Format">
          <DataField>VALVATBaseLCY_Control93Format</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT____Control94">
          <DataField>VATAmountLine__VAT____Control94</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT____Control94Format">
          <DataField>VATAmountLine__VAT____Control94Format</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control101">
          <DataField>VALVATAmountLCY_Control101</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control101Format">
          <DataField>VALVATAmountLCY_Control101Format</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control102">
          <DataField>VALVATBaseLCY_Control102</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control102Format">
          <DataField>VALVATBaseLCY_Control102Format</DataField>
        </Field>
        <Field Name="VALVATAmountLCY_Control92Caption">
          <DataField>VALVATAmountLCY_Control92Caption</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control93Caption">
          <DataField>VALVATBaseLCY_Control93Caption</DataField>
        </Field>
        <Field Name="VATAmountLine__VAT____Control94Caption">
          <DataField>VATAmountLine__VAT____Control94Caption</DataField>
        </Field>
        <Field Name="VALVATBaseLCY_Control102Caption">
          <DataField>VALVATBaseLCY_Control102Caption</DataField>
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
                  <Width>18.17302cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>21.92869cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="table9">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2.3cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.7cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.7cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.26984cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox119</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox111">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALSpecLCYHeader.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox111</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox103">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALExchRate.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox103</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox90</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox84">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT____Control94Caption.Value</Value>
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
                                            <rd:DefaultName>textbox84</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
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
                                          <Textbox Name="textbox87">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATBaseLCY_Control93Caption.Value</Value>
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
                                            <rd:DefaultName>textbox87</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
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
                                          <Textbox Name="textbox88">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATAmountLCY_Control92Caption.Value</Value>
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
                                            <rd:DefaultName>textbox88</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox89</rd:DefaultName>
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
                                    <Height>0.423cm</Height>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox43</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox55">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT____Control94.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT____Control94Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox55</rd:DefaultName>
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
                                          <Textbox Name="textbox57">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATBaseLCY.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VALVATBaseLCY_Control93Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox57</rd:DefaultName>
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
                                          <Textbox Name="textbox58">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATAmountLCY.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VALVATAmountLCY_Control92Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox58</rd:DefaultName>
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
                                          <Textbox Name="textbox74">
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
                                            <rd:DefaultName>textbox74</rd:DefaultName>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox130</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox126">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATBaseLCY_Control102Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox126</rd:DefaultName>
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
                                          <Textbox Name="textbox127">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATBaseLCY.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VALVATBaseLCY_Control102Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox127</rd:DefaultName>
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
                                          <Textbox Name="textbox128">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VALVATAmountLCY.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VALVATAmountLCY_Control101Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox128</rd:DefaultName>
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
                                          <Textbox Name="textbox129">
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
                                            <rd:DefaultName>textbox129</rd:DefaultName>
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
                                    <Group Name="table9_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=1</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="table9_Details_Group">
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
                                  <FilterExpression>=Fields!VALVATAmountLCY_Control92Caption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>18.12169cm</Top>
                              <Width>8.96984cm</Width>
                              <ZIndex>34</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!VALVATAmountLCY_Control92Caption.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="table8">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2.3cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.7cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.7cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.7cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox73">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VAT_Amount_SpecificationCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox73</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
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
                                          <Textbox Name="textbox76">
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
                                            <rd:DefaultName>textbox76</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox68</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.846cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox64">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT___Caption.Value</Value>
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
                                            <rd:DefaultName>textbox64</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
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
                                          <Textbox Name="textbox65">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Base__Control56Caption.Value</Value>
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
                                            <rd:DefaultName>textbox65</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
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
                                          <Textbox Name="textbox66">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Amount__Control55Caption.Value</Value>
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
                                            <rd:DefaultName>textbox66</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
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
                                          <Textbox Name="textbox67">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__Amount_Including_VAT__Control73Caption.Value</Value>
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
                                            <rd:DefaultName>textbox67</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox38</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox46">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox46</rd:DefaultName>
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
                                          <Textbox Name="textbox61">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Base_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Base__Control56Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox61</rd:DefaultName>
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
                                          <Textbox Name="textbox48">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Amount_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__VAT_Amount__Control55Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox48</rd:DefaultName>
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
                                          <Textbox Name="textbox51">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__Amount_Including_VAT_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!VATAmountLine__Amount_Including_VAT__Control73Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox51</rd:DefaultName>
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
                                    <Height>0.423cm</Height>
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
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox83</rd:DefaultName>
                                            <ZIndex>4</ZIndex>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox77">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!VATAmountLine__VAT_Base__Control49Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox77</rd:DefaultName>
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
                                          <Textbox Name="textbox79">
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
                                                      <Format>=Fields!VATAmountLine__VAT_Base__Control49Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox79</rd:DefaultName>
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
                                          <Textbox Name="textbox80">
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
                                                      <Format>=Fields!VATAmountLine__VAT_Amount__Control45Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox80</rd:DefaultName>
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
                                          <Textbox Name="textbox81">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Sum(Fields!VATAmountLine__Amount_Including_VAT_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!VATAmountLine__Amount_Including_VAT__Control80Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox81</rd:DefaultName>
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
                                    <Group Name="table8_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=1</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="table8_Details_Group">
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
                                  <FilterExpression>=Fields!VAT_Amount_SpecificationCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>14.68254cm</Top>
                              <Height>3.384cm</Height>
                              <Width>10.4cm</Width>
                              <ZIndex>33</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!VAT_Amount_SpecificationCaption.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="table7">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>18.09524cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox49">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ReminderLine2_Description.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox49</rd:DefaultName>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox54</rd:DefaultName>
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
                                  <TablixMember>
                                    <KeepWithGroup>Before</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!ReminderLine2__Line_No__.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>13.35978cm</Top>
                              <Height>1.269cm</Height>
                              <Width>18.09524cm</Width>
                              <ZIndex>32</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!ReminderLine2__Line_No__.Value &gt; 0,False,True)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="table6">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2.1cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.8cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.3cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>1.8cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.7cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.7cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.7cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
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
                                            <rd:DefaultName>textbox62</rd:DefaultName>
                                            <ZIndex>36</ZIndex>
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
                                    <Height>0.846cm</Height>
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
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Document_Date_Caption.Value</Value>
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
                                            <rd:DefaultName>textbox1</rd:DefaultName>
                                            <ZIndex>35</ZIndex>
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
                                          <Textbox Name="textbox59">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Document_Type_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox59</rd:DefaultName>
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
                                          <Textbox Name="textbox56">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Document_No__Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox56</rd:DefaultName>
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
                                          <Textbox Name="textbox53">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Due_Date_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox53</rd:DefaultName>
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
                                          <Textbox Name="textbox50">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line_DescriptionCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox50</rd:DefaultName>
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
                                          <Textbox Name="textbox47">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Original_Amount_Caption.Value</Value>
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
                                            <rd:DefaultName>textbox47</rd:DefaultName>
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
                                          <Textbox Name="textbox3">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Remaining_Amount_Caption.Value</Value>
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
                                            <rd:DefaultName>textbox3</rd:DefaultName>
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
                                          <Textbox Name="textbox8">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line_AmountCaption.Value</Value>
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
                                            <rd:DefaultName>textbox8</rd:DefaultName>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox94">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Document_Date_.Value</Value>
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
                                            <rd:DefaultName>textbox94</rd:DefaultName>
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
                                          <Textbox Name="textbox95">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Document_Type_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox95</rd:DefaultName>
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
                                          <Textbox Name="textbox96">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Document_No__.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox96</rd:DefaultName>
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
                                          <Textbox Name="textbox97">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line__Due_Date_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox97</rd:DefaultName>
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
                                          <Textbox Name="textbox98">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line_Description.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox98</rd:DefaultName>
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
                                          <Textbox Name="textbox99">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Finance_Charge_Memo_Line__Original_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Finance_Charge_Memo_Line__Original_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox99</rd:DefaultName>
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
                                          <Textbox Name="textbox100">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Finance_Charge_Memo_Line__Remaining_Amount_.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Finance_Charge_Memo_Line__Remaining_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox100</rd:DefaultName>
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
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox101">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Finance_Charge_Memo_Line_Amount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Finance_Charge_Memo_Line_AmountFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox101</rd:DefaultName>
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
                                    <Height>0.423cm</Height>
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
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox78</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
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
                                          <Textbox Name="textbox82">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Finance_Charge_Memo_Line_Description.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox82</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
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
                                          <Textbox Name="textbox85">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Fields!Finance_Charge_Memo_Line_Amount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Finance_Charge_Memo_Line_Amount_Control61Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox85</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox28">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorText_Number__Control97Caption.Value</Value>
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
                                          <Textbox Name="textbox60">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorText_Number__Control97.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox60</rd:DefaultName>
                                            <Style>
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>1pt</PaddingTop>
                                              <PaddingBottom>1pt</PaddingBottom>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox86">
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
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox86</rd:DefaultName>
                                            <ZIndex>2</ZIndex>
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
                                    <Height>0.423cm</Height>
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
                                            <rd:DefaultName>textbox44</rd:DefaultName>
                                            <ZIndex>3</ZIndex>
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
                                    <Height>0.423cm</Height>
                                    <TablixCells>
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
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox118</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
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
                                          <Textbox Name="textbox122">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox122</rd:DefaultName>
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
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox124</rd:DefaultName>
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
                                          <Textbox Name="textbox125">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Code.BlankZero(Last(Fields!TotalAmount.Value))</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!Finance_Charge_Memo_Line_Amount_Control29Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox125</rd:DefaultName>
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
                                    <Height>0.423cm</Height>
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
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox110</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
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
                                          <Textbox Name="textbox114">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!Finance_Charge_Memo_Line__VAT_Amount_Caption.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox114</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
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
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox116</rd:DefaultName>
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
                                          <Textbox Name="textbox117">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalVatAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <Format>=Fields!Finance_Charge_Memo_Line__VAT_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox117</rd:DefaultName>
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
                                    <Height>0.423cm</Height>
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
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox102</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
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
                                          <Textbox Name="textbox106">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalInclVATText.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox106</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
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
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox108</rd:DefaultName>
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
                                          <Textbox Name="textbox109">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Last(Fields!TotalAmount.Value) + Last(Fields!TotalVatAmount.Value)</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>=Fields!Amount____VAT_Amount_Format.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox109</rd:DefaultName>
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
                                    <Height>0.423cm</Height>
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
                                                <Style>
                                                  <TextAlign>Left</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox70</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
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
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <KeepWithGroup>After</KeepWithGroup>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                  <TablixMember>
                                    <Group Name="table6_Group1">
                                      <GroupExpressions>
                                        <GroupExpression>=1</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <TablixMembers>
                                      <TablixMember>
                                        <Group Name="table6_Group2">
                                          <GroupExpressions>
                                            <GroupExpression>=Fields!FinChMemo_Line___Line_No__.Value</GroupExpression>
                                          </GroupExpressions>
                                        </Group>
                                        <TablixMembers>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!ShowFinChMemoLine1.Value,False,True)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!ShowFinChMemoLine2.Value,False,True)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>After</KeepWithGroup>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Group Name="table6_Details_Group">
                                              <DataElementName>Detail</DataElementName>
                                            </Group>
                                            <TablixMembers>
                                              <TablixMember>
                                                <Visibility>
                                                  <Hidden>=IIF(Fields!ErrorText_Number__Control97Caption.Value = "",True,False)</Hidden>
                                                </Visibility>
                                              </TablixMember>
                                            </TablixMembers>
                                            <DataElementName>Detail_Collection</DataElementName>
                                            <DataElementOutput>Output</DataElementOutput>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                          <TablixMember>
                                            <Visibility>
                                              <Hidden>=IIF(Last(Fields!ErrorText_Number__Control97Caption.Value) = "",True,False)</Hidden>
                                            </Visibility>
                                            <KeepWithGroup>Before</KeepWithGroup>
                                            <KeepTogether>true</KeepTogether>
                                          </TablixMember>
                                        </TablixMembers>
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
                                        <Visibility>
                                          <Hidden>=IIF(Last(Fields!TotalVatAmount.Value) = 0,True,False)</Hidden>
                                        </Visibility>
                                        <KeepWithGroup>Before</KeepWithGroup>
                                        <KeepTogether>true</KeepTogether>
                                      </TablixMember>
                                      <TablixMember>
                                        <Visibility>
                                          <Hidden>=IIF(Last(Fields!TotalVatAmount.Value) = 0,True,False)</Hidden>
                                        </Visibility>
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
                                  <FilterExpression>=Fields!Finance_Charge_Memo_Line_DescriptionCaption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>8.22751cm</Top>
                              <Height>5.076cm</Height>
                              <Width>18.1cm</Width>
                              <ZIndex>31</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!Finance_Charge_Memo_Line_DescriptionCaption.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="table5">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>18.09524cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.42328cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox42">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!BeginningText_Description.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox42</rd:DefaultName>
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
                                    </TablixMembers>
                                    <DataElementName>Detail_Collection</DataElementName>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!StartLineNo.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>7.77777cm</Top>
                              <Height>0.42328cm</Height>
                              <Width>18.09524cm</Width>
                              <ZIndex>30</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!StartLineNo.Value = 0,True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="table4">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>2.3cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>15.87302cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox10">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorText_Number_Caption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox10</rd:DefaultName>
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
                                          <Textbox Name="textbox30">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!ErrorText_Number_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox30</rd:DefaultName>
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox36</rd:DefaultName>
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
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!ErrorText_Number_Caption.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>6.48148cm</Top>
                              <Height>1.269cm</Height>
                              <ZIndex>29</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!ErrorText_Number_Caption.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Textbox Name="textbox34">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Post_Additional_Fee_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>3.83598cm</Top>
                              <Left>13.96825cm</Left>
                              <Height>0.423cm</Height>
                              <ZIndex>28</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox35">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Post_Interest_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>3.41297cm</Top>
                              <Left>13.96825cm</Left>
                              <Height>0.423cm</Height>
                              <ZIndex>27</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox37">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Fin__Charge_Terms_Code_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.56698cm</Top>
                              <Left>13.96825cm</Left>
                              <Height>0.423cm</Height>
                              <ZIndex>26</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox39">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Due_Date_.Value</Value>
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
                              <Top>1.72098cm</Top>
                              <Left>13.96825cm</Left>
                              <Height>0.423cm</Height>
                              <ZIndex>25</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox40">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Document_Date_.Value</Value>
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
                              <Top>1.29798cm</Top>
                              <Left>13.96825cm</Left>
                              <Height>0.423cm</Height>
                              <ZIndex>24</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox41">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Posting_Date_.Value</Value>
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
                              <Top>0.87497cm</Top>
                              <Left>13.96825cm</Left>
                              <Height>0.423cm</Height>
                              <ZIndex>23</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox26">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Post_Additional_Fee_Caption.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>3.83598cm</Top>
                              <Left>10.15873cm</Left>
                              <Height>0.423cm</Height>
                              <Width>3.57cm</Width>
                              <ZIndex>22</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox27">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Post_Interest_Caption.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>3.41297cm</Top>
                              <Left>10.15873cm</Left>
                              <Height>0.423cm</Height>
                              <Width>3.57cm</Width>
                              <ZIndex>21</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox29">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Fin__Charge_Terms_Code_Caption.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.56698cm</Top>
                              <Left>10.15873cm</Left>
                              <Height>0.423cm</Height>
                              <Width>3.57cm</Width>
                              <ZIndex>20</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox31">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Due_Date_Caption.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>1.72098cm</Top>
                              <Left>10.15873cm</Left>
                              <Height>0.423cm</Height>
                              <Width>3.57cm</Width>
                              <ZIndex>19</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox32">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Document_Date_Caption.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>1.29798cm</Top>
                              <Left>10.15873cm</Left>
                              <Height>0.423cm</Height>
                              <Width>3.57cm</Width>
                              <ZIndex>18</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox33">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Posting_Date_Caption.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>0.87497cm</Top>
                              <Left>10.15873cm</Left>
                              <Height>0.423cm</Height>
                              <Width>3.57cm</Width>
                              <ZIndex>17</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox23">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Your_Reference_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>5.55555cm</Top>
                              <Left>3.36cm</Left>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>16</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox24">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___VAT_Registration_No__.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>5.13255cm</Top>
                              <Left>3.36cm</Left>
                              <Height>0.423cm</Height>
                              <Width>4.2cm</Width>
                              <ZIndex>15</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox25">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Customer_No__.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>4.70955cm</Top>
                              <Left>3.36cm</Left>
                              <Height>0.423cm</Height>
                              <Width>4.2cm</Width>
                              <ZIndex>14</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox20">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!ReferenceText.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>5.55555cm</Top>
                              <Height>0.423cm</Height>
                              <Width>3.15cm</Width>
                              <ZIndex>13</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox21">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!VATNoText.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>5.13255cm</Top>
                              <Height>0.423cm</Height>
                              <Width>3.15cm</Width>
                              <ZIndex>12</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox22">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!Finance_Charge_Memo_Header___Customer_No__Caption.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>4.70955cm</Top>
                              <Height>0.423cm</Height>
                              <Width>3.15cm</Width>
                              <ZIndex>11</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox19">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr_8_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>3.8337cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>10</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox18">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr_7_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>3.4107cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>9</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox17">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr_6_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.9877cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>8</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox16">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr_5_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.5647cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>7</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox14">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr_4_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>2.1417cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>6</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox13">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr_3_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>1.7187cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>5</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox12">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr_2_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <Top>1.2957cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>4</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Textbox Name="textbox11">
                              <KeepTogether>true</KeepTogether>
                              <Paragraphs>
                                <Paragraph>
                                  <TextRuns>
                                    <TextRun>
                                      <Value>=Fields!CustAddr_1_.Value</Value>
                                      <Style>
                                        <FontSize>9pt</FontSize>
                                      </Style>
                                    </TextRun>
                                  </TextRuns>
                                </Paragraph>
                              </Paragraphs>
                              <rd:DefaultName>textbox11</rd:DefaultName>
                              <Top>0.8727cm</Top>
                              <Height>0.423cm</Height>
                              <Width>6.3cm</Width>
                              <ZIndex>3</ZIndex>
                              <Style>
                                <PaddingLeft>2pt</PaddingLeft>
                                <PaddingRight>2pt</PaddingRight>
                                <PaddingTop>1pt</PaddingTop>
                                <PaddingBottom>1pt</PaddingBottom>
                              </Style>
                            </Textbox>
                            <Tablix Name="table3">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>10.47619cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox15">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!STRSUBSTNO___1__2___Finance_Charge_Memo_Header___No___Cust_Name_.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox15</rd:DefaultName>
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
                                    </TablixCells>
                                  </TablixRow>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
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
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox6</rd:DefaultName>
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
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <Filters>
                                <Filter>
                                  <FilterExpression>=Fields!STRSUBSTNO___1__2___Finance_Charge_Memo_Header___No___Cust_Name_.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue />
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Height>0.846cm</Height>
                              <Width>10.47619cm</Width>
                              <ZIndex>2</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!STRSUBSTNO___1__2___Finance_Charge_Memo_Header___No___Cust_Name_.Value = "",True,False)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Tablix Name="table1">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>3.1746cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>14.92063cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.423cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox5">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!Header_DimensionsCaption.Value</Value>
                                                    <Style>
                                                      <FontSize>9pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox5</rd:DefaultName>
                                            <ZIndex>1</ZIndex>
                                            <Visibility>
                                              <Hidden>=IIF(Fields!DimensionLoop_Number.Value = 1,False,True)</Hidden>
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
                                          <Textbox Name="textbox7">
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
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox7</rd:DefaultName>
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
                                    <Group Name="table1_Details_Group">
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
                                  <FilterExpression>=Fields!DimensionLoop_Number.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=0</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>6.00529cm</Top>
                              <Height>0.423cm</Height>
                              <Width>18.09523cm</Width>
                              <ZIndex>1</ZIndex>
                              <Visibility>
                                <Hidden>=IIF(Fields!DimensionLoop_Number.Value &gt; 0,False,True)</Hidden>
                              </Visibility>
                              <DataElementOutput>NoOutput</DataElementOutput>
                            </Tablix>
                            <Textbox Name="HeaderData">
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
                              <Top>0.18518cm</Top>
                              <Left>11.42857cm</Left>
                              <Height>0.31746cm</Height>
                              <Width>1.26984cm</Width>
                              <Visibility>
                                <Hidden>=Code.SetData(Fields!Finance_Charge_Memo___TestCaption.Value + Chr(177) +
Fields!COMPANYNAME.Value + Chr(177) +
Format(Fields!TODAY.Value,"D") + Chr(177) +
Fields!PageCaption.Value)</Hidden>
                              </Visibility>
                              <Style />
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
                      <GroupExpression>=Fields!Fin_Charge_Memo_Header___No__.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <Visibility>
                    <Hidden>=IIF(Fields!Fin_Charge_Memo_Header___No__.Value = "",True,False)</Hidden>
                  </Visibility>
                  <DataElementOutput>Output</DataElementOutput>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <Filters>
              <Filter>
                <FilterExpression>=Fields!Fin_Charge_Memo_Header___No__.Value</FilterExpression>
                <Operator>GreaterThan</Operator>
                <FilterValues>
                  <FilterValue />
                </FilterValues>
              </Filter>
            </Filters>
            <Top>1.2963cm</Top>
            <ZIndex>1</ZIndex>
            <DataElementOutput>NoOutput</DataElementOutput>
          </Tablix>
          <Tablix Name="table2">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>18.09524cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox9">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!STRSUBSTNO_Text008_FinChrgMemoHeaderFilter_.Value</Value>
                                  <Style>
                                    <FontSize>9pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox9</rd:DefaultName>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.846cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox2">
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
                          <rd:DefaultName>textbox2</rd:DefaultName>
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
              </TablixMembers>
            </TablixRowHierarchy>
            <Filters>
              <Filter>
                <FilterExpression>=Fields!FinChrgMemoHeaderFilter.Value</FilterExpression>
                <Operator>GreaterThan</Operator>
                <FilterValues>
                  <FilterValue />
                </FilterValues>
              </Filter>
            </Filters>
            <Height>1.269cm</Height>
            <Width>18.09524cm</Width>
            <Visibility>
              <Hidden>=IIF(Fields!FinChrgMemoHeaderFilter.Value = "",True,False)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
          </Tablix>
        </ReportItems>
        <Height>23.22499cm</Height>
      </Body>
      <Width>18.17302cm</Width>
      <Page>
        <PageHeader>
          <Height>1.5873cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="PageNumberTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(4) &amp; Globals!PageNumber</Value>
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
              <Top>0.50237cm</Top>
              <Left>13.86cm</Left>
              <Height>0.423cm</Height>
              <Width>4.2cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
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
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.92537cm</Top>
              <Left>13.86243cm</Left>
              <Height>0.423cm</Height>
              <Width>4.2cm</Width>
              <ZIndex>3</ZIndex>
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
                        <FontSize>9pt</FontSize>
                        <Format>g</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.07937cm</Top>
              <Left>11.76cm</Left>
              <Height>0.423cm</Height>
              <Width>6.3cm</Width>
              <ZIndex>2</ZIndex>
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
                        <FontSize>9pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.50237cm</Top>
              <Height>0.423cm</Height>
              <Width>10.5cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Finance_Charge_Memo___TestCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(1)</Value>
                      <Style>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.07937cm</Top>
              <Height>0.423cm</Height>
              <Width>10.5cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
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

Shared Data1 as Object

Public Function GetData(Num as Integer) as Object
   Return Cstr(Choose(Num, Split(Cstr(Data1),Chr(177))))
End Function

Public Function SetData(NewData as Object)
  If NewData &gt; "" Then
      Data1 = NewData
  End If
  Return True
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Invalid</rd:ReportUnitType>
  <rd:ReportID>5acd8ac0-3e86-49bd-b4b1-4dfe8cc7dbd5</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

