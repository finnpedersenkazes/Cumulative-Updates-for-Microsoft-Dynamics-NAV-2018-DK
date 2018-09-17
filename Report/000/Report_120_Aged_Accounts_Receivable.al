OBJECT Report 120 Aged Accounts Receivable
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Aldersfordelte tilgodehavender;
               ENU=Aged Accounts Receivable];
    OnPreReport=VAR
                  CaptionManagement@1000 : Codeunit 42;
                BEGIN
                  CustFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);

                  GLSetup.GET;

                  CalcDates;
                  CreateHeadings;

                  PageGroupNo := 1;
                  NextPageGroupNo := 1;
                  CustFilterCheck := (CustFilter <> 'No.');

                  TodayFormatted := TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone('f');
                  CompanyDisplayName := COMPANYPROPERTY.DISPLAYNAME;
                END;

  }
  DATASET
  {
    { 6836;    ;DataItem;Customer            ;
               DataItemTable=Table18;
               OnAfterGetRecord=BEGIN
                                  IF NewPagePercustomer THEN
                                    PageGroupNo += 1;
                                  TempCurrency.RESET;
                                  TempCurrency.DELETEALL;
                                  TempCustLedgEntry.RESET;
                                  TempCustLedgEntry.DELETEALL;
                                END;

               ReqFilterFields=No. }

    { 3   ;1   ;Column  ;TodayFormatted      ;
               SourceExpr=TodayFormatted }

    { 4   ;1   ;Column  ;CompanyName         ;
               SourceExpr=CompanyDisplayName }

    { 108 ;1   ;Column  ;FormatEndingDate    ;
               SourceExpr=STRSUBSTNO(Text006,FORMAT(EndingDate,0,4)) }

    { 110 ;1   ;Column  ;PostingDate         ;
               SourceExpr=STRSUBSTNO(Text007,SELECTSTR(AgingBy + 1,Text009)) }

    { 128 ;1   ;Column  ;PrintAmountInLCY    ;
               SourceExpr=PrintAmountInLCY }

    { 1   ;1   ;Column  ;TableCaptnCustFilter;
               SourceExpr=TABLECAPTION + ': ' + CustFilter }

    { 129 ;1   ;Column  ;CustFilter          ;
               SourceExpr=CustFilter }

    { 130 ;1   ;Column  ;AgingByDueDate      ;
               SourceExpr=AgingBy = AgingBy::"Due Date" }

    { 57  ;1   ;Column  ;AgedbyDocumnetDate  ;
               SourceExpr=STRSUBSTNO(Text004,SELECTSTR(AgingBy + 1,Text009)) }

    { 64  ;1   ;Column  ;HeaderText5         ;
               SourceExpr=HeaderText[5] }

    { 70  ;1   ;Column  ;HeaderText4         ;
               SourceExpr=HeaderText[4] }

    { 71  ;1   ;Column  ;HeaderText3         ;
               SourceExpr=HeaderText[3] }

    { 72  ;1   ;Column  ;HeaderText2         ;
               SourceExpr=HeaderText[2] }

    { 73  ;1   ;Column  ;HeaderText1         ;
               SourceExpr=HeaderText[1] }

    { 131 ;1   ;Column  ;PrintDetails        ;
               SourceExpr=PrintDetails }

    { 42  ;1   ;Column  ;GrandTotalCLE5RemAmt;
               SourceExpr=GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 43  ;1   ;Column  ;GrandTotalCLE4RemAmt;
               SourceExpr=GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 44  ;1   ;Column  ;GrandTotalCLE3RemAmt;
               SourceExpr=GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 45  ;1   ;Column  ;GrandTotalCLE2RemAmt;
               SourceExpr=GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 46  ;1   ;Column  ;GrandTotalCLE1RemAmt;
               SourceExpr=GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 47  ;1   ;Column  ;GrandTotalCLEAmtLCY ;
               SourceExpr=GrandTotalCustLedgEntry[1]."Amount (LCY)";
               AutoFormatType=1 }

    { 48  ;1   ;Column  ;GrandTotalCLE1CustRemAmtLCY;
               SourceExpr=Pct(GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)") }

    { 49  ;1   ;Column  ;GrandTotalCLE2CustRemAmtLCY;
               SourceExpr=Pct(GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)") }

    { 50  ;1   ;Column  ;GrandTotalCLE3CustRemAmtLCY;
               SourceExpr=Pct(GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)") }

    { 51  ;1   ;Column  ;GrandTotalCLE4CustRemAmtLCY;
               SourceExpr=Pct(GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)") }

    { 52  ;1   ;Column  ;GrandTotalCLE5CustRemAmtLCY;
               SourceExpr=Pct(GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)") }

    { 2   ;1   ;Column  ;AgedAccReceivableCptn;
               SourceExpr=AgedAccReceivableCptnLbl }

    { 6   ;1   ;Column  ;CurrReportPageNoCptn;
               SourceExpr=CurrReportPageNoCptnLbl }

    { 111 ;1   ;Column  ;AllAmtinLCYCptn     ;
               SourceExpr=AllAmtinLCYCptnLbl }

    { 54  ;1   ;Column  ;AgedOverdueAmtCptn  ;
               SourceExpr=AgedOverdueAmtCptnLbl }

    { 75  ;1   ;Column  ;CLEEndDateAmtLCYCptn;
               SourceExpr=CLEEndDateAmtLCYCptnLbl }

    { 76  ;1   ;Column  ;CLEEndDateDueDateCptn;
               SourceExpr=CLEEndDateDueDateCptnLbl }

    { 77  ;1   ;Column  ;CLEEndDateDocNoCptn ;
               SourceExpr=CLEEndDateDocNoCptnLbl }

    { 78  ;1   ;Column  ;CLEEndDatePstngDateCptn;
               SourceExpr=CLEEndDatePstngDateCptnLbl }

    { 79  ;1   ;Column  ;CLEEndDateDocTypeCptn;
               SourceExpr=CLEEndDateDocTypeCptnLbl }

    { 41  ;1   ;Column  ;OriginalAmtCptn     ;
               SourceExpr=OriginalAmtCptnLbl }

    { 55  ;1   ;Column  ;TotalLCYCptn        ;
               SourceExpr=TotalLCYCptnLbl }

    { 5   ;1   ;Column  ;NewPagePercustomer  ;
               SourceExpr=NewPagePercustomer }

    { 7   ;1   ;Column  ;PageGroupNo         ;
               SourceExpr=PageGroupNo }

    { 8503;1   ;DataItem;                    ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.,Posting Date,Currency Code);
               OnPreDataItem=BEGIN
                               SETRANGE("Posting Date",EndingDate + 1,DMY2DATE(31,12,9999));
                             END;

               OnAfterGetRecord=VAR
                                  CustLedgEntry@1000 : Record 21;
                                BEGIN
                                  CustLedgEntry.SETCURRENTKEY("Closed by Entry No.");
                                  CustLedgEntry.SETRANGE("Closed by Entry No.","Entry No.");
                                  CustLedgEntry.SETRANGE("Posting Date",0D,EndingDate);
                                  IF CustLedgEntry.FINDSET(FALSE,FALSE) THEN
                                    REPEAT
                                      InsertTemp(CustLedgEntry);
                                    UNTIL CustLedgEntry.NEXT = 0;

                                  IF "Closed by Entry No." <> 0 THEN BEGIN
                                    CustLedgEntry.SETRANGE("Closed by Entry No.","Closed by Entry No.");
                                    IF CustLedgEntry.FINDSET(FALSE,FALSE) THEN
                                      REPEAT
                                        InsertTemp(CustLedgEntry);
                                      UNTIL CustLedgEntry.NEXT = 0;
                                  END;

                                  CustLedgEntry.RESET;
                                  CustLedgEntry.SETRANGE("Entry No.","Closed by Entry No.");
                                  CustLedgEntry.SETRANGE("Posting Date",0D,EndingDate);
                                  IF CustLedgEntry.FINDSET(FALSE,FALSE) THEN
                                    REPEAT
                                      InsertTemp(CustLedgEntry);
                                    UNTIL CustLedgEntry.NEXT = 0;
                                  CurrReport.SKIP;
                                END;

               DataItemLink=Customer No.=FIELD(No.) }

    { 1473;1   ;DataItem;OpenCustLedgEntry   ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.,Open,Positive,Due Date,Currency Code);
               OnPreDataItem=BEGIN
                               IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
                                 SETRANGE("Posting Date",0D,EndingDate);
                                 SETRANGE("Date Filter",0D,EndingDate);
                               END;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
                                    CALCFIELDS("Remaining Amt. (LCY)");
                                    IF "Remaining Amt. (LCY)" = 0 THEN
                                      CurrReport.SKIP;
                                  END;

                                  InsertTemp(OpenCustLedgEntry);
                                  CurrReport.SKIP;
                                END;

               DataItemLink=Customer No.=FIELD(No.) }

    { 6523;1   ;DataItem;CurrencyLoop        ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               NumberOfCurrencies := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  CLEAR(TotalCustLedgEntry);

                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempCurrency.FINDSET(FALSE,FALSE) THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF TempCurrency.NEXT = 0 THEN
                                      CurrReport.BREAK;

                                  IF TempCurrency.Code <> '' THEN
                                    CurrencyCode := TempCurrency.Code
                                  ELSE
                                    CurrencyCode := GLSetup."LCY Code";

                                  NumberOfCurrencies := NumberOfCurrencies + 1;
                                END;
                                 }

    { 7725;2   ;DataItem;TempCustLedgEntryLoop;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT PrintAmountInLCY THEN BEGIN
                                 IF (TempCurrency.Code = '') OR (TempCurrency.Code = GLSetup."LCY Code") THEN
                                   TempCustLedgEntry.SETFILTER("Currency Code",'%1|%2',GLSetup."LCY Code",'')
                                 ELSE
                                   TempCustLedgEntry.SETRANGE("Currency Code",TempCurrency.Code);
                               END;

                               PageGroupNo := NextPageGroupNo;
                               IF NewPagePercustomer AND (NumberOfCurrencies > 0) THEN
                                 NextPageGroupNo := PageGroupNo + 1;
                             END;

               OnAfterGetRecord=VAR
                                  PeriodIndex@1001 : Integer;
                                BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempCustLedgEntry.FINDSET(FALSE,FALSE) THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF TempCustLedgEntry.NEXT = 0 THEN
                                      CurrReport.BREAK;

                                  CustLedgEntryEndingDate := TempCustLedgEntry;
                                  DetailedCustomerLedgerEntry.SETRANGE("Cust. Ledger Entry No.",CustLedgEntryEndingDate."Entry No.");
                                  IF DetailedCustomerLedgerEntry.FINDSET(FALSE,FALSE) THEN
                                    REPEAT
                                      IF (DetailedCustomerLedgerEntry."Entry Type" =
                                          DetailedCustomerLedgerEntry."Entry Type"::"Initial Entry") AND
                                         (CustLedgEntryEndingDate."Posting Date" > EndingDate) AND
                                         (AgingBy <> AgingBy::"Posting Date")
                                      THEN BEGIN
                                        IF CustLedgEntryEndingDate."Document Date" <= EndingDate THEN
                                          DetailedCustomerLedgerEntry."Posting Date" :=
                                            CustLedgEntryEndingDate."Document Date"
                                        ELSE
                                          IF (CustLedgEntryEndingDate."Due Date" <= EndingDate) AND
                                             (AgingBy = AgingBy::"Due Date")
                                          THEN
                                            DetailedCustomerLedgerEntry."Posting Date" :=
                                              CustLedgEntryEndingDate."Due Date"
                                      END;

                                      IF (DetailedCustomerLedgerEntry."Posting Date" <= EndingDate) OR
                                         (TempCustLedgEntry.Open AND
                                          (AgingBy = AgingBy::"Due Date") AND
                                          (CustLedgEntryEndingDate."Due Date" > EndingDate) AND
                                          (CustLedgEntryEndingDate."Posting Date" <= EndingDate))
                                      THEN BEGIN
                                        IF DetailedCustomerLedgerEntry."Entry Type" IN
                                           [DetailedCustomerLedgerEntry."Entry Type"::"Initial Entry",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Unrealized Loss",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Unrealized Gain",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Realized Loss",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Realized Gain",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Tolerance",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                            DetailedCustomerLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                                        THEN BEGIN
                                          CustLedgEntryEndingDate.Amount := CustLedgEntryEndingDate.Amount + DetailedCustomerLedgerEntry.Amount;
                                          CustLedgEntryEndingDate."Amount (LCY)" :=
                                            CustLedgEntryEndingDate."Amount (LCY)" + DetailedCustomerLedgerEntry."Amount (LCY)";
                                        END;
                                        IF DetailedCustomerLedgerEntry."Posting Date" <= EndingDate THEN BEGIN
                                          CustLedgEntryEndingDate."Remaining Amount" :=
                                            CustLedgEntryEndingDate."Remaining Amount" + DetailedCustomerLedgerEntry.Amount;
                                          CustLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                            CustLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedCustomerLedgerEntry."Amount (LCY)";
                                        END;
                                      END;
                                    UNTIL DetailedCustomerLedgerEntry.NEXT = 0;

                                  IF CustLedgEntryEndingDate."Remaining Amount" = 0 THEN
                                    CurrReport.SKIP;

                                  CASE AgingBy OF
                                    AgingBy::"Due Date":
                                      PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Due Date");
                                    AgingBy::"Posting Date":
                                      PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Posting Date");
                                    AgingBy::"Document Date":
                                      BEGIN
                                        IF CustLedgEntryEndingDate."Document Date" > EndingDate THEN BEGIN
                                          CustLedgEntryEndingDate."Remaining Amount" := 0;
                                          CustLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                          CustLedgEntryEndingDate."Document Date" := CustLedgEntryEndingDate."Posting Date";
                                        END;
                                        PeriodIndex := GetPeriodIndex(CustLedgEntryEndingDate."Document Date");
                                      END;
                                  END;
                                  CLEAR(AgedCustLedgEntry);
                                  AgedCustLedgEntry[PeriodIndex]."Remaining Amount" := CustLedgEntryEndingDate."Remaining Amount";
                                  AgedCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                                  TotalCustLedgEntry[PeriodIndex]."Remaining Amount" += CustLedgEntryEndingDate."Remaining Amount";
                                  TotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                                  GrandTotalCustLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                                  TotalCustLedgEntry[1].Amount += CustLedgEntryEndingDate."Remaining Amount";
                                  TotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                                  GrandTotalCustLedgEntry[1]."Amount (LCY)" += CustLedgEntryEndingDate."Remaining Amt. (LCY)";
                                END;

               OnPostDataItem=BEGIN
                                IF NOT PrintAmountInLCY THEN
                                  UpdateCurrencyTotals;
                              END;
                               }

    { 80  ;3   ;Column  ;Name1_Cust          ;
               IncludeCaption=Yes;
               SourceExpr=Customer.Name }

    { 81  ;3   ;Column  ;No_Cust             ;
               IncludeCaption=Yes;
               SourceExpr=Customer."No." }

    { 58  ;3   ;Column  ;CLEEndDateRemAmtLCY ;
               SourceExpr=CustLedgEntryEndingDate."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 59  ;3   ;Column  ;AgedCLE1RemAmtLCY   ;
               SourceExpr=AgedCustLedgEntry[1]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 60  ;3   ;Column  ;AgedCLE2RemAmtLCY   ;
               SourceExpr=AgedCustLedgEntry[2]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 61  ;3   ;Column  ;AgedCLE3RemAmtLCY   ;
               SourceExpr=AgedCustLedgEntry[3]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 62  ;3   ;Column  ;AgedCLE4RemAmtLCY   ;
               SourceExpr=AgedCustLedgEntry[4]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 63  ;3   ;Column  ;AgedCLE5RemAmtLCY   ;
               SourceExpr=AgedCustLedgEntry[5]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 65  ;3   ;Column  ;CLEEndDateAmtLCY    ;
               SourceExpr=CustLedgEntryEndingDate."Amount (LCY)";
               AutoFormatType=1 }

    { 66  ;3   ;Column  ;CLEEndDueDate       ;
               SourceExpr=FORMAT(CustLedgEntryEndingDate."Due Date") }

    { 67  ;3   ;Column  ;CLEEndDateDocNo     ;
               SourceExpr=CustLedgEntryEndingDate."Document No." }

    { 68  ;3   ;Column  ;CLEDocType          ;
               SourceExpr=FORMAT(CustLedgEntryEndingDate."Document Type") }

    { 69  ;3   ;Column  ;CLEPostingDate      ;
               SourceExpr=FORMAT(CustLedgEntryEndingDate."Posting Date") }

    { 89  ;3   ;Column  ;AgedCLE5TempRemAmt  ;
               SourceExpr=AgedCustLedgEntry[5]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 90  ;3   ;Column  ;AgedCLE4TempRemAmt  ;
               SourceExpr=AgedCustLedgEntry[4]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 91  ;3   ;Column  ;AgedCLE3TempRemAmt  ;
               SourceExpr=AgedCustLedgEntry[3]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 92  ;3   ;Column  ;AgedCLE2TempRemAmt  ;
               SourceExpr=AgedCustLedgEntry[2]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 93  ;3   ;Column  ;AgedCLE1TempRemAmt  ;
               SourceExpr=AgedCustLedgEntry[1]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 94  ;3   ;Column  ;RemAmt_CLEEndDate   ;
               SourceExpr=CustLedgEntryEndingDate."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 95  ;3   ;Column  ;CLEEndDate          ;
               SourceExpr=CustLedgEntryEndingDate.Amount;
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 82  ;3   ;Column  ;Name_Cust           ;
               SourceExpr=STRSUBSTNO(Text005,Customer.Name) }

    { 83  ;3   ;Column  ;TotalCLE1AmtLCY     ;
               SourceExpr=TotalCustLedgEntry[1]."Amount (LCY)";
               AutoFormatType=1 }

    { 84  ;3   ;Column  ;TotalCLE1RemAmtLCY  ;
               SourceExpr=TotalCustLedgEntry[1]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 85  ;3   ;Column  ;TotalCLE2RemAmtLCY  ;
               SourceExpr=TotalCustLedgEntry[2]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 86  ;3   ;Column  ;TotalCLE3RemAmtLCY  ;
               SourceExpr=TotalCustLedgEntry[3]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 87  ;3   ;Column  ;TotalCLE4RemAmtLCY  ;
               SourceExpr=TotalCustLedgEntry[4]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 88  ;3   ;Column  ;TotalCLE5RemAmtLCY  ;
               SourceExpr=TotalCustLedgEntry[5]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 100 ;3   ;Column  ;CurrrencyCode       ;
               SourceExpr=CurrencyCode;
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 102 ;3   ;Column  ;TotalCLE5RemAmt     ;
               SourceExpr=TotalCustLedgEntry[5]."Remaining Amount";
               AutoFormatType=1 }

    { 103 ;3   ;Column  ;TotalCLE4RemAmt     ;
               SourceExpr=TotalCustLedgEntry[4]."Remaining Amount";
               AutoFormatType=1 }

    { 104 ;3   ;Column  ;TotalCLE3RemAmt     ;
               SourceExpr=TotalCustLedgEntry[3]."Remaining Amount";
               AutoFormatType=1 }

    { 105 ;3   ;Column  ;TotalCLE2RemAmt     ;
               SourceExpr=TotalCustLedgEntry[2]."Remaining Amount";
               AutoFormatType=1 }

    { 106 ;3   ;Column  ;TotalCLE1RemAmt     ;
               SourceExpr=TotalCustLedgEntry[1]."Remaining Amount";
               AutoFormatType=1 }

    { 107 ;3   ;Column  ;TotalCLE1Amt        ;
               SourceExpr=TotalCustLedgEntry[1].Amount;
               AutoFormatType=1 }

    { 1010;3   ;Column  ;TotalCheck          ;
               SourceExpr=CustFilterCheck }

    { 1011;3   ;Column  ;GrandTotalCLE1AmtLCY;
               SourceExpr=GrandTotalCustLedgEntry[1]."Amount (LCY)";
               AutoFormatType=1 }

    { 1021;3   ;Column  ;GrandTotalCLE5PctRemAmtLCY;
               SourceExpr=Pct(GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)") }

    { 1019;3   ;Column  ;GrandTotalCLE3PctRemAmtLCY;
               SourceExpr=Pct(GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)") }

    { 1018;3   ;Column  ;GrandTotalCLE2PctRemAmtLCY;
               SourceExpr=Pct(GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)") }

    { 1017;3   ;Column  ;GrandTotalCLE1PctRemAmtLCY;
               SourceExpr=Pct(GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)",GrandTotalCustLedgEntry[1]."Amount (LCY)") }

    { 1016;3   ;Column  ;GrandTotalCLE5RemAmtLCY;
               SourceExpr=GrandTotalCustLedgEntry[5]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 1015;3   ;Column  ;GrandTotalCLE4RemAmtLCY;
               SourceExpr=GrandTotalCustLedgEntry[4]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 1014;3   ;Column  ;GrandTotalCLE3RemAmtLCY;
               SourceExpr=GrandTotalCustLedgEntry[3]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 1013;3   ;Column  ;GrandTotalCLE2RemAmtLCY;
               SourceExpr=GrandTotalCustLedgEntry[2]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 1012;3   ;Column  ;GrandTotalCLE1RemAmtLCY;
               SourceExpr=GrandTotalCustLedgEntry[1]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 8052;    ;DataItem;CurrencyTotals      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempCurrency2.FINDSET(FALSE,FALSE) THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF TempCurrency2.NEXT = 0 THEN
                                      CurrReport.BREAK;

                                  CLEAR(AgedCustLedgEntry);
                                  TempCurrencyAmount.SETRANGE("Currency Code",TempCurrency2.Code);
                                  IF TempCurrencyAmount.FINDSET(FALSE,FALSE) THEN
                                    REPEAT
                                      IF TempCurrencyAmount.Date <> DMY2DATE(31,12,9999) THEN
                                        AgedCustLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                                          TempCurrencyAmount.Amount
                                      ELSE
                                        AgedCustLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
                                    UNTIL TempCurrencyAmount.NEXT = 0;
                                END;
                                 }

    { 132 ;1   ;Column  ;CurrNo              ;
               SourceExpr=Number = 1 }

    { 117 ;1   ;Column  ;TempCurrCode        ;
               SourceExpr=TempCurrency2.Code;
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 119 ;1   ;Column  ;AgedCLE6RemAmt      ;
               SourceExpr=AgedCustLedgEntry[6]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 120 ;1   ;Column  ;AgedCLE1RemAmt      ;
               SourceExpr=AgedCustLedgEntry[1]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 121 ;1   ;Column  ;AgedCLE2RemAmt      ;
               SourceExpr=AgedCustLedgEntry[2]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 122 ;1   ;Column  ;AgedCLE3RemAmt      ;
               SourceExpr=AgedCustLedgEntry[3]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 123 ;1   ;Column  ;AgedCLE4RemAmt      ;
               SourceExpr=AgedCustLedgEntry[4]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 124 ;1   ;Column  ;AgedCLE5RemAmt      ;
               SourceExpr=AgedCustLedgEntry[5]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 125 ;1   ;Column  ;CurrSpecificationCptn;
               SourceExpr=CurrSpecificationCptnLbl }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   IF EndingDate = 0D THEN
                     EndingDate := WORKDATE;
                   IF FORMAT(PeriodLength) = '' THEN
                     EVALUATE(PeriodLength,'<1M>');
                 END;

    }
    CONTROLS
    {
      { 4   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 2   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  Name=AgedAsOf;
                  CaptionML=[DAN=Aldersfordelt pr.;
                             ENU=Aged As Of];
                  ToolTipML=[DAN=Angiver den dato, som aldersfordelingen skal beregnes for.;
                             ENU=Specifies the date that you want the aging calculated for.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=EndingDate }

      { 3   ;2   ;Field     ;
                  Name=Agingby;
                  CaptionML=[DAN=Aldersfordelt efter;
                             ENU=Aging by];
                  ToolTipML=[DAN=Angiver, om aldersfordelingen skal beregnes ud fra forfaldsdatoen, bogf�ringsdatoen eller dokumentdatoen.;
                             ENU=Specifies if the aging will be calculated from the due date, the posting date, or the document date.];
                  OptionCaptionML=[DAN=Forfaldsdato,Bogf�ringsdato,Bilagsdato;
                                   ENU=Due Date,Posting Date,Document Date];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=AgingBy }

      { 7   ;2   ;Field     ;
                  Name=PeriodLength;
                  CaptionML=[DAN=Periodel�ngde;
                             ENU=Period Length];
                  ToolTipML=[DAN=Angiver den periode, der vises data for i rapporten. Angiv f.eks. "1M" for �n m�ned, "30D" for 30 dage, "3K" for tre kvartaler eller "5�" for fem �r.;
                             ENU=Specifies the period for which data is shown in the report. For example, enter "1M" for one month, "30D" for thirty days, "3Q" for three quarters, or "5Y" for five years.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PeriodLength }

      { 9   ;2   ;Field     ;
                  Name=AmountsinLCY;
                  CaptionML=[DAN=Udskriv bel�b i RV;
                             ENU=Print Amounts in LCY];
                  ToolTipML=[DAN=Angiver, om rapporten skal vise aldersfordelingen pr. debitorpost.;
                             ENU=Specifies if you want the report to specify the aging per customer ledger entry.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintAmountInLCY }

      { 11  ;2   ;Field     ;
                  Name=PrintDetails;
                  CaptionML=[DAN=Udskriv detaljer;
                             ENU=Print Details];
                  ToolTipML=[DAN=Angiver, om rapporten skal vise detaljerede poster, der udg�r den totale saldo for hver debitor.;
                             ENU=Specifies if you want the report to show the detailed entries that add up the total balance for each customer.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintDetails }

      { 15  ;2   ;Field     ;
                  Name=HeadingType;
                  CaptionML=[DAN=Overskriftstype;
                             ENU=Heading Type];
                  ToolTipML=[DAN=Angiver, om kolonneoverskriften for de tre perioder indikerer et datointerval eller antallet af dage siden forfaldsdatoen.;
                             ENU=Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.];
                  OptionCaptionML=[DAN=Tidsinterval,Antal dage;
                                   ENU=Date Interval,Number of Days];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=HeadingType }

      { 13  ;2   ;Field     ;
                  Name=perCustomer;
                  CaptionML=[DAN=Skift side pr. debitor;
                             ENU=New Page per Customer];
                  ToolTipML=[DAN=Angiver, om oplysninger om hver enkelt debitor udskrives p� en ny side, hvis du har valgt to eller flere debitorer, der skal medtages i rapporten.;
                             ENU=Specifies if each customer's information is printed on a new page if you have chosen two or more customers to be included in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=NewPagePercustomer }

    }
  }
  LABELS
  {
    { 74  ;BalanceCaption      ;CaptionML=[DAN=Saldo;
                                           ENU=Balance] }
  }
  CODE
  {
    VAR
      GLSetup@1011 : Record 98;
      TempCustLedgEntry@1009 : TEMPORARY Record 21;
      CustLedgEntryEndingDate@1013 : Record 21;
      TotalCustLedgEntry@1014 : ARRAY [5] OF Record 21;
      GrandTotalCustLedgEntry@1018 : ARRAY [5] OF Record 21;
      AgedCustLedgEntry@1022 : ARRAY [6] OF Record 21;
      TempCurrency@1010 : TEMPORARY Record 4;
      TempCurrency2@1030 : TEMPORARY Record 4;
      TempCurrencyAmount@1029 : TEMPORARY Record 264;
      DetailedCustomerLedgerEntry@1102601000 : Record 379;
      TypeHelper@1033 : Codeunit 10;
      CustFilter@1000 : Text;
      PrintAmountInLCY@1012 : Boolean;
      EndingDate@1001 : Date;
      AgingBy@1002 : 'Due Date,Posting Date,Document Date';
      PeriodLength@1003 : DateFormula;
      PrintDetails@1015 : Boolean;
      HeadingType@1019 : 'Date Interval,Number of Days';
      NewPagePercustomer@1027 : Boolean;
      PeriodStartDate@1004 : ARRAY [5] OF Date;
      PeriodEndDate@1005 : ARRAY [5] OF Date;
      HeaderText@1006 : ARRAY [5] OF Text[30];
      Text000@1007 : TextConst 'DAN=Ikke forfalden;ENU=Not Due';
      Text001@1008 : TextConst 'DAN=F�r;ENU=Before';
      CurrencyCode@1016 : Code[10];
      Text002@1020 : TextConst 'DAN=dage;ENU=days';
      Text003@1021 : TextConst 'DAN=Mere end;ENU=More than';
      Text004@1017 : TextConst 'DAN=Aldersfordelt efter %1;ENU=Aged by %1';
      Text005@1023 : TextConst 'DAN=I alt for %1;ENU=Total for %1';
      Text006@1024 : TextConst 'DAN=Aldersfordelt pr. %1;ENU=Aged as of %1';
      Text007@1025 : TextConst 'DAN=Aldersfordelt efter %1;ENU=Aged by %1';
      NumberOfCurrencies@1028 : Integer;
      Text009@1031 : TextConst 'DAN=Forfaldsdato,Bogf�ringsdato,Bilagsdato;ENU=Due Date,Posting Date,Document Date';
      Text010@1032 : TextConst 'DAN=Datoformlen %1 er ugyldig. Pr�v at omformulere den. Skriv f.eks. 1M+LM i stedet for LM+1M.;ENU=The Date Formula %1 cannot be used. Try to restate it. E.g. 1M+CM instead of CM+1M.';
      PageGroupNo@1035 : Integer;
      NextPageGroupNo@1036 : Integer;
      CustFilterCheck@1037 : Boolean;
      Text032@1059 : TextConst '@@@=Negating the period length: %1 is the period length;DAN=-%1;ENU=-%1';
      AgedAccReceivableCptnLbl@5173 : TextConst 'DAN=Aldersfordelte tilgodehavender;ENU=Aged Accounts Receivable';
      CurrReportPageNoCptnLbl@6074 : TextConst 'DAN=Side;ENU=Page';
      AllAmtinLCYCptnLbl@8265 : TextConst 'DAN=Alle bel�b i RV;ENU=All Amounts in LCY';
      AgedOverdueAmtCptnLbl@2837 : TextConst 'DAN=Aldersfordelte forfaldne bel�b;ENU=Aged Overdue Amounts';
      CLEEndDateAmtLCYCptnLbl@3633 : TextConst 'DAN=Oprindeligt bel�b;ENU="Original Amount "';
      CLEEndDateDueDateCptnLbl@1514 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      CLEEndDateDocNoCptnLbl@1511 : TextConst 'DAN=Bilagsnr.;ENU=Document No.';
      CLEEndDatePstngDateCptnLbl@4115 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      CLEEndDateDocTypeCptnLbl@7645 : TextConst 'DAN=Bilagstype;ENU=Document Type';
      OriginalAmtCptnLbl@4991 : TextConst 'DAN=Valutakode;ENU=Currency Code';
      TotalLCYCptnLbl@4055 : TextConst 'DAN=I alt (RV);ENU=Total (LCY)';
      CurrSpecificationCptnLbl@3382 : TextConst 'DAN=Valutaspecifikation;ENU=Currency Specification';
      EnterDateFormulaErr@1026 : TextConst 'DAN=Angiv en datoformel i feltet Periodel�ngde.;ENU=Enter a date formula in the Period Length field.';
      TodayFormatted@1034 : Text;
      CompanyDisplayName@1038 : Text;

    LOCAL PROCEDURE CalcDates@5();
    VAR
      i@1000 : Integer;
      PeriodLength2@1001 : DateFormula;
    BEGIN
      IF NOT EVALUATE(PeriodLength2,STRSUBSTNO(Text032,PeriodLength)) THEN
        ERROR(EnterDateFormulaErr);
      IF AgingBy = AgingBy::"Due Date" THEN BEGIN
        PeriodEndDate[1] := DMY2DATE(31,12,9999);
        PeriodStartDate[1] := EndingDate + 1;
      END ELSE BEGIN
        PeriodEndDate[1] := EndingDate;
        PeriodStartDate[1] := CALCDATE(PeriodLength2,EndingDate + 1);
      END;
      FOR i := 2 TO ARRAYLEN(PeriodEndDate) DO BEGIN
        PeriodEndDate[i] := PeriodStartDate[i - 1] - 1;
        PeriodStartDate[i] := CALCDATE(PeriodLength2,PeriodEndDate[i] + 1);
      END;
      PeriodStartDate[i] := 0D;

      FOR i := 1 TO ARRAYLEN(PeriodEndDate) DO
        IF PeriodEndDate[i] < PeriodStartDate[i] THEN
          ERROR(Text010,PeriodLength);
    END;

    LOCAL PROCEDURE CreateHeadings@10();
    VAR
      i@1000 : Integer;
    BEGIN
      IF AgingBy = AgingBy::"Due Date" THEN BEGIN
        HeaderText[1] := Text000;
        i := 2;
      END ELSE
        i := 1;
      WHILE i < ARRAYLEN(PeriodEndDate) DO BEGIN
        IF HeadingType = HeadingType::"Date Interval" THEN
          HeaderText[i] := STRSUBSTNO('%1\..%2',PeriodStartDate[i],PeriodEndDate[i])
        ELSE
          HeaderText[i] :=
            STRSUBSTNO('%1 - %2 %3',EndingDate - PeriodEndDate[i] + 1,EndingDate - PeriodStartDate[i] + 1,Text002);
        i := i + 1;
      END;
      IF HeadingType = HeadingType::"Date Interval" THEN
        HeaderText[i] := STRSUBSTNO('%1 %2',Text001,PeriodStartDate[i - 1])
      ELSE
        HeaderText[i] := STRSUBSTNO('%1 \%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 1,Text002);
    END;

    LOCAL PROCEDURE InsertTemp@1(VAR CustLedgEntry@1040000 : Record 21);
    VAR
      Currency@1000 : Record 4;
    BEGIN
      WITH TempCustLedgEntry DO BEGIN
        IF GET(CustLedgEntry."Entry No.") THEN
          EXIT;
        TempCustLedgEntry := CustLedgEntry;
        INSERT;
        IF PrintAmountInLCY THEN BEGIN
          CLEAR(TempCurrency);
          TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
          IF TempCurrency.INSERT THEN;
          EXIT;
        END;
        IF TempCurrency.GET("Currency Code") THEN
          EXIT;
        IF TempCurrency.GET('') AND ("Currency Code" = GLSetup."LCY Code") THEN
          EXIT;
        IF TempCurrency.GET(GLSetup."LCY Code") AND ("Currency Code" = '') THEN
          EXIT;
        IF "Currency Code" <> '' THEN
          Currency.GET("Currency Code")
        ELSE BEGIN
          CLEAR(Currency);
          Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        END;
        TempCurrency := Currency;
        TempCurrency.INSERT;
      END;
    END;

    LOCAL PROCEDURE GetPeriodIndex@8(Date@1040000 : Date) : Integer;
    VAR
      i@1000 : Integer;
    BEGIN
      FOR i := 1 TO ARRAYLEN(PeriodEndDate) DO
        IF Date IN [PeriodStartDate[i]..PeriodEndDate[i]] THEN
          EXIT(i);
    END;

    LOCAL PROCEDURE Pct@2(a@1000 : Decimal;b@1001 : Decimal) : Text[30];
    BEGIN
      IF b <> 0 THEN
        EXIT(FORMAT(ROUND(100 * a / b,0.1),0,'<Sign><Integer><Decimals,2>') + '%');
    END;

    LOCAL PROCEDURE UpdateCurrencyTotals@7();
    VAR
      i@1000 : Integer;
    BEGIN
      TempCurrency2.Code := CurrencyCode;
      IF TempCurrency2.INSERT THEN;
      WITH TempCurrencyAmount DO BEGIN
        FOR i := 1 TO ARRAYLEN(TotalCustLedgEntry) DO BEGIN
          "Currency Code" := CurrencyCode;
          Date := PeriodStartDate[i];
          IF FIND THEN BEGIN
            Amount := Amount + TotalCustLedgEntry[i]."Remaining Amount";
            MODIFY;
          END ELSE BEGIN
            "Currency Code" := CurrencyCode;
            Date := PeriodStartDate[i];
            Amount := TotalCustLedgEntry[i]."Remaining Amount";
            INSERT;
          END;
        END;
        "Currency Code" := CurrencyCode;
        Date := DMY2DATE(31,12,9999);
        IF FIND THEN BEGIN
          Amount := Amount + TotalCustLedgEntry[1].Amount;
          MODIFY;
        END ELSE BEGIN
          "Currency Code" := CurrencyCode;
          Date := DMY2DATE(31,12,9999);
          Amount := TotalCustLedgEntry[1].Amount;
          INSERT;
        END;
      END;
    END;

    PROCEDURE InitializeRequest@11(NewEndingDate@1000 : Date;NewAgingBy@1001 : Option;NewPeriodLength@1002 : DateFormula;NewPrintAmountInLCY@1003 : Boolean;NewPrintDetails@1004 : Boolean;NewHeadingType@1005 : Option;NewPagePercust@1006 : Boolean);
    BEGIN
      EndingDate := NewEndingDate;
      AgingBy := NewAgingBy;
      PeriodLength := NewPeriodLength;
      PrintAmountInLCY := NewPrintAmountInLCY;
      PrintDetails := NewPrintDetails;
      HeadingType := NewHeadingType;
      NewPagePercustomer := NewPagePercust;
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
      <rd:DataSourceID>e69e08e8-6612-4ee3-bb5e-5a8848f0aff9</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="TodayFormatted">
          <DataField>TodayFormatted</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="NewPagePercustomer">
          <DataField>NewPagePercustomer</DataField>
        </Field>
        <Field Name="PageGroupNo">
          <DataField>PageGroupNo</DataField>
        </Field>
        <Field Name="FormatEndingDate">
          <DataField>FormatEndingDate</DataField>
        </Field>
        <Field Name="PostingDate">
          <DataField>PostingDate</DataField>
        </Field>
        <Field Name="PrintAmountInLCY">
          <DataField>PrintAmountInLCY</DataField>
        </Field>
        <Field Name="TableCaptnCustFilter">
          <DataField>TableCaptnCustFilter</DataField>
        </Field>
        <Field Name="CustFilter">
          <DataField>CustFilter</DataField>
        </Field>
        <Field Name="AgingByDueDate">
          <DataField>AgingByDueDate</DataField>
        </Field>
        <Field Name="AgedbyDocumnetDate">
          <DataField>AgedbyDocumnetDate</DataField>
        </Field>
        <Field Name="HeaderText5">
          <DataField>HeaderText5</DataField>
        </Field>
        <Field Name="HeaderText4">
          <DataField>HeaderText4</DataField>
        </Field>
        <Field Name="HeaderText3">
          <DataField>HeaderText3</DataField>
        </Field>
        <Field Name="HeaderText2">
          <DataField>HeaderText2</DataField>
        </Field>
        <Field Name="HeaderText1">
          <DataField>HeaderText1</DataField>
        </Field>
        <Field Name="PrintDetails">
          <DataField>PrintDetails</DataField>
        </Field>
        <Field Name="GrandTotalCLE5RemAmt">
          <DataField>GrandTotalCLE5RemAmt</DataField>
        </Field>
        <Field Name="GrandTotalCLE5RemAmtFormat">
          <DataField>GrandTotalCLE5RemAmtFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE4RemAmt">
          <DataField>GrandTotalCLE4RemAmt</DataField>
        </Field>
        <Field Name="GrandTotalCLE4RemAmtFormat">
          <DataField>GrandTotalCLE4RemAmtFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE3RemAmt">
          <DataField>GrandTotalCLE3RemAmt</DataField>
        </Field>
        <Field Name="GrandTotalCLE3RemAmtFormat">
          <DataField>GrandTotalCLE3RemAmtFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE2RemAmt">
          <DataField>GrandTotalCLE2RemAmt</DataField>
        </Field>
        <Field Name="GrandTotalCLE2RemAmtFormat">
          <DataField>GrandTotalCLE2RemAmtFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE1RemAmt">
          <DataField>GrandTotalCLE1RemAmt</DataField>
        </Field>
        <Field Name="GrandTotalCLE1RemAmtFormat">
          <DataField>GrandTotalCLE1RemAmtFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLEAmtLCY">
          <DataField>GrandTotalCLEAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLEAmtLCYFormat">
          <DataField>GrandTotalCLEAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE1CustRemAmtLCY">
          <DataField>GrandTotalCLE1CustRemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE2CustRemAmtLCY">
          <DataField>GrandTotalCLE2CustRemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE3CustRemAmtLCY">
          <DataField>GrandTotalCLE3CustRemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE4CustRemAmtLCY">
          <DataField>GrandTotalCLE4CustRemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE5CustRemAmtLCY">
          <DataField>GrandTotalCLE5CustRemAmtLCY</DataField>
        </Field>
        <Field Name="No1_Cust">
          <DataField>No1_Cust</DataField>
        </Field>
        <Field Name="AgedAccReceivableCptn">
          <DataField>AgedAccReceivableCptn</DataField>
        </Field>
        <Field Name="CurrReportPageNoCptn">
          <DataField>CurrReportPageNoCptn</DataField>
        </Field>
        <Field Name="AllAmtinLCYCptn">
          <DataField>AllAmtinLCYCptn</DataField>
        </Field>
        <Field Name="AgedOverdueAmtCptn">
          <DataField>AgedOverdueAmtCptn</DataField>
        </Field>
        <Field Name="CLEEndDateAmtLCYCptn">
          <DataField>CLEEndDateAmtLCYCptn</DataField>
        </Field>
        <Field Name="CLEEndDateDueDateCptn">
          <DataField>CLEEndDateDueDateCptn</DataField>
        </Field>
        <Field Name="CLEEndDateDocNoCptn">
          <DataField>CLEEndDateDocNoCptn</DataField>
        </Field>
        <Field Name="CLEEndDatePstngDateCptn">
          <DataField>CLEEndDatePstngDateCptn</DataField>
        </Field>
        <Field Name="CLEEndDateDocTypeCptn">
          <DataField>CLEEndDateDocTypeCptn</DataField>
        </Field>
        <Field Name="OriginalAmtCptn">
          <DataField>OriginalAmtCptn</DataField>
        </Field>
        <Field Name="TotalLCYCptn">
          <DataField>TotalLCYCptn</DataField>
        </Field>
        <Field Name="Name1_Cust">
          <DataField>Name1_Cust</DataField>
        </Field>
        <Field Name="No_Cust">
          <DataField>No_Cust</DataField>
        </Field>
        <Field Name="CLEEndDateRemAmtLCY">
          <DataField>CLEEndDateRemAmtLCY</DataField>
        </Field>
        <Field Name="CLEEndDateRemAmtLCYFormat">
          <DataField>CLEEndDateRemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedCLE1RemAmtLCY">
          <DataField>AgedCLE1RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedCLE1RemAmtLCYFormat">
          <DataField>AgedCLE1RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedCLE2RemAmtLCY">
          <DataField>AgedCLE2RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedCLE2RemAmtLCYFormat">
          <DataField>AgedCLE2RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedCLE3RemAmtLCY">
          <DataField>AgedCLE3RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedCLE3RemAmtLCYFormat">
          <DataField>AgedCLE3RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedCLE4RemAmtLCY">
          <DataField>AgedCLE4RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedCLE4RemAmtLCYFormat">
          <DataField>AgedCLE4RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedCLE5RemAmtLCY">
          <DataField>AgedCLE5RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedCLE5RemAmtLCYFormat">
          <DataField>AgedCLE5RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="CLEEndDateAmtLCY">
          <DataField>CLEEndDateAmtLCY</DataField>
        </Field>
        <Field Name="CLEEndDateAmtLCYFormat">
          <DataField>CLEEndDateAmtLCYFormat</DataField>
        </Field>
        <Field Name="CLEEndDueDate">
          <DataField>CLEEndDueDate</DataField>
        </Field>
        <Field Name="CLEEndDateDocNo">
          <DataField>CLEEndDateDocNo</DataField>
        </Field>
        <Field Name="CLEDocType">
          <DataField>CLEDocType</DataField>
        </Field>
        <Field Name="CLEPostingDate">
          <DataField>CLEPostingDate</DataField>
        </Field>
        <Field Name="AgedCLE5TempRemAmt">
          <DataField>AgedCLE5TempRemAmt</DataField>
        </Field>
        <Field Name="AgedCLE5TempRemAmtFormat">
          <DataField>AgedCLE5TempRemAmtFormat</DataField>
        </Field>
        <Field Name="AgedCLE4TempRemAmt">
          <DataField>AgedCLE4TempRemAmt</DataField>
        </Field>
        <Field Name="AgedCLE4TempRemAmtFormat">
          <DataField>AgedCLE4TempRemAmtFormat</DataField>
        </Field>
        <Field Name="AgedCLE3TempRemAmt">
          <DataField>AgedCLE3TempRemAmt</DataField>
        </Field>
        <Field Name="AgedCLE3TempRemAmtFormat">
          <DataField>AgedCLE3TempRemAmtFormat</DataField>
        </Field>
        <Field Name="AgedCLE2TempRemAmt">
          <DataField>AgedCLE2TempRemAmt</DataField>
        </Field>
        <Field Name="AgedCLE2TempRemAmtFormat">
          <DataField>AgedCLE2TempRemAmtFormat</DataField>
        </Field>
        <Field Name="AgedCLE1TempRemAmt">
          <DataField>AgedCLE1TempRemAmt</DataField>
        </Field>
        <Field Name="AgedCLE1TempRemAmtFormat">
          <DataField>AgedCLE1TempRemAmtFormat</DataField>
        </Field>
        <Field Name="RemAmt_CLEEndDate">
          <DataField>RemAmt_CLEEndDate</DataField>
        </Field>
        <Field Name="RemAmt_CLEEndDateFormat">
          <DataField>RemAmt_CLEEndDateFormat</DataField>
        </Field>
        <Field Name="CLEEndDate">
          <DataField>CLEEndDate</DataField>
        </Field>
        <Field Name="CLEEndDateFormat">
          <DataField>CLEEndDateFormat</DataField>
        </Field>
        <Field Name="Name_Cust">
          <DataField>Name_Cust</DataField>
        </Field>
        <Field Name="TotalCLE1AmtLCY">
          <DataField>TotalCLE1AmtLCY</DataField>
        </Field>
        <Field Name="TotalCLE1AmtLCYFormat">
          <DataField>TotalCLE1AmtLCYFormat</DataField>
        </Field>
        <Field Name="TotalCLE1RemAmtLCY">
          <DataField>TotalCLE1RemAmtLCY</DataField>
        </Field>
        <Field Name="TotalCLE1RemAmtLCYFormat">
          <DataField>TotalCLE1RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="TotalCLE2RemAmtLCY">
          <DataField>TotalCLE2RemAmtLCY</DataField>
        </Field>
        <Field Name="TotalCLE2RemAmtLCYFormat">
          <DataField>TotalCLE2RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="TotalCLE3RemAmtLCY">
          <DataField>TotalCLE3RemAmtLCY</DataField>
        </Field>
        <Field Name="TotalCLE3RemAmtLCYFormat">
          <DataField>TotalCLE3RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="TotalCLE4RemAmtLCY">
          <DataField>TotalCLE4RemAmtLCY</DataField>
        </Field>
        <Field Name="TotalCLE4RemAmtLCYFormat">
          <DataField>TotalCLE4RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="TotalCLE5RemAmtLCY">
          <DataField>TotalCLE5RemAmtLCY</DataField>
        </Field>
        <Field Name="TotalCLE5RemAmtLCYFormat">
          <DataField>TotalCLE5RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="CurrrencyCode">
          <DataField>CurrrencyCode</DataField>
        </Field>
        <Field Name="TotalCLE5RemAmt">
          <DataField>TotalCLE5RemAmt</DataField>
        </Field>
        <Field Name="TotalCLE5RemAmtFormat">
          <DataField>TotalCLE5RemAmtFormat</DataField>
        </Field>
        <Field Name="TotalCLE4RemAmt">
          <DataField>TotalCLE4RemAmt</DataField>
        </Field>
        <Field Name="TotalCLE4RemAmtFormat">
          <DataField>TotalCLE4RemAmtFormat</DataField>
        </Field>
        <Field Name="TotalCLE3RemAmt">
          <DataField>TotalCLE3RemAmt</DataField>
        </Field>
        <Field Name="TotalCLE3RemAmtFormat">
          <DataField>TotalCLE3RemAmtFormat</DataField>
        </Field>
        <Field Name="TotalCLE2RemAmt">
          <DataField>TotalCLE2RemAmt</DataField>
        </Field>
        <Field Name="TotalCLE2RemAmtFormat">
          <DataField>TotalCLE2RemAmtFormat</DataField>
        </Field>
        <Field Name="TotalCLE1RemAmt">
          <DataField>TotalCLE1RemAmt</DataField>
        </Field>
        <Field Name="TotalCLE1RemAmtFormat">
          <DataField>TotalCLE1RemAmtFormat</DataField>
        </Field>
        <Field Name="TotalCLE1Amt">
          <DataField>TotalCLE1Amt</DataField>
        </Field>
        <Field Name="TotalCLE1AmtFormat">
          <DataField>TotalCLE1AmtFormat</DataField>
        </Field>
        <Field Name="TotalCheck">
          <DataField>TotalCheck</DataField>
        </Field>
        <Field Name="GrandTotalCLE1AmtLCY">
          <DataField>GrandTotalCLE1AmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE1AmtLCYFormat">
          <DataField>GrandTotalCLE1AmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE5PctRemAmtLCY">
          <DataField>GrandTotalCLE5PctRemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE4PctRemAmtLCY">
          <DataField>GrandTotalCLE4PctRemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE3PctRemAmtLCY">
          <DataField>GrandTotalCLE3PctRemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE2PctRemAmtLCY">
          <DataField>GrandTotalCLE2PctRemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE1PctRemAmtLCY">
          <DataField>GrandTotalCLE1PctRemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE5RemAmtLCY">
          <DataField>GrandTotalCLE5RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE5RemAmtLCYFormat">
          <DataField>GrandTotalCLE5RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE4RemAmtLCY">
          <DataField>GrandTotalCLE4RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE4RemAmtLCYFormat">
          <DataField>GrandTotalCLE4RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE3RemAmtLCY">
          <DataField>GrandTotalCLE3RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE3RemAmtLCYFormat">
          <DataField>GrandTotalCLE3RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE2RemAmtLCY">
          <DataField>GrandTotalCLE2RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE2RemAmtLCYFormat">
          <DataField>GrandTotalCLE2RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalCLE1RemAmtLCY">
          <DataField>GrandTotalCLE1RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalCLE1RemAmtLCYFormat">
          <DataField>GrandTotalCLE1RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="CurrNo">
          <DataField>CurrNo</DataField>
        </Field>
        <Field Name="TempCurrCode">
          <DataField>TempCurrCode</DataField>
        </Field>
        <Field Name="AgedCLE6RemAmt">
          <DataField>AgedCLE6RemAmt</DataField>
        </Field>
        <Field Name="AgedCLE6RemAmtFormat">
          <DataField>AgedCLE6RemAmtFormat</DataField>
        </Field>
        <Field Name="AgedCLE1RemAmt">
          <DataField>AgedCLE1RemAmt</DataField>
        </Field>
        <Field Name="AgedCLE1RemAmtFormat">
          <DataField>AgedCLE1RemAmtFormat</DataField>
        </Field>
        <Field Name="AgedCLE2RemAmt">
          <DataField>AgedCLE2RemAmt</DataField>
        </Field>
        <Field Name="AgedCLE2RemAmtFormat">
          <DataField>AgedCLE2RemAmtFormat</DataField>
        </Field>
        <Field Name="AgedCLE3RemAmt">
          <DataField>AgedCLE3RemAmt</DataField>
        </Field>
        <Field Name="AgedCLE3RemAmtFormat">
          <DataField>AgedCLE3RemAmtFormat</DataField>
        </Field>
        <Field Name="AgedCLE4RemAmt">
          <DataField>AgedCLE4RemAmt</DataField>
        </Field>
        <Field Name="AgedCLE4RemAmtFormat">
          <DataField>AgedCLE4RemAmtFormat</DataField>
        </Field>
        <Field Name="AgedCLE5RemAmt">
          <DataField>AgedCLE5RemAmt</DataField>
        </Field>
        <Field Name="AgedCLE5RemAmtFormat">
          <DataField>AgedCLE5RemAmtFormat</DataField>
        </Field>
        <Field Name="CurrSpecificationCptn">
          <DataField>CurrSpecificationCptn</DataField>
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
          <Tablix Name="AgedAccountRecTable">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>0.781in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.92974in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.94974in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.88881in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.8275in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.9614in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.96141in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.97141in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.91947in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.92989in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.79446in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.13889in</Height>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <PaddingRight>0.0625in</PaddingRight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox3</rd:DefaultName>
                          <ZIndex>204</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
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
                        <Textbox Name="AgedOverdueAmtsCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedOverdueAmtCptn.Value</Value>
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
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>196</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                  <Height>0.06944in</Height>
                  <TablixCells>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox25</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox32</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Dotted</Style>
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
                  <Height>0.13889in</Height>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox55</rd:DefaultName>
                          <ZIndex>195</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
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
                        <Textbox Name="Text004AgingByText009">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedbyDocumnetDate.Value</Value>
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
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>188</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
                  <TablixCells>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox14</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Center</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox22</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Dotted</Style>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox7</rd:DefaultName>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>11</ColSpan>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13799in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryEDtPstngDtCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDatePstngDateCptn.Value</Value>
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
                          <ZIndex>175</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryEDtDocTypeCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDateDocTypeCptn.Value</Value>
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>174</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryEndDtDocNoCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDateDocNoCptn.Value</Value>
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>173</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryEndDtDueDtCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDateDueDateCptn.Value</Value>
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>172</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryEDtAmtLCYCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!CLEEndDateAmtLCYCptn.Value)</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>171</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl58Cptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!BalanceCaption.Value</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>170</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText1.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>169</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText2.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>168</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText3">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText3.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>167</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText4">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText4.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>166</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText5">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(Fields!HeaderText5.Value, " " , Chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>165</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="CustNoCtrl9Cptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!No_CustCaption.Value</Value>
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
                          <ZIndex>164</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustName1Ctrl15Cptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!Name1_CustCaption.Value</Value>
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>163</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl17Cptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!BalanceCaption.Value</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>162</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText11">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText1.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>161</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText21">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText2.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>160</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText31">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText3.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>159</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText41">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText4.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>158</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText51">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(Fields!HeaderText5.Value , " " ,Chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>157</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="CustNoCtrl31Cptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!No_CustCaption.Value</Value>
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
                          <ZIndex>156</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustName1Ctrl30Cptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!Name1_CustCaption.Value</Value>
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>155</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                        <rd:Selected>true</rd:Selected>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl32Cptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!OriginalAmtCptn.Value</Value>
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>154</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl24Cptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!BalanceCaption.Value</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>153</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText12">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText1.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>152</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText22">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText2.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>151</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText32">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText3.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>150</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText42">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!HeaderText4.Value),"\",chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>149</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="HeaderText52">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(Fields!HeaderText5.Value , " ", Chr(10))</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>148</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.0625in</Height>
                  <TablixCells>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox33</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>11</ColSpan>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.0616in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox68">
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
                          <rd:DefaultName>Textbox68</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>11</ColSpan>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!No_Cust.Value)</Value>
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
                          <ZIndex>123</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustName1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!Name1_Cust.Value)</Value>
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
                          <ZIndex>122</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
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
                        <Textbox Name="textbox151">
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox151</rd:DefaultName>
                          <ZIndex>121</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox152</rd:DefaultName>
                          <ZIndex>120</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox153</rd:DefaultName>
                          <ZIndex>119</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox154</rd:DefaultName>
                          <ZIndex>118</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <PaddingLeft>5pt</PaddingLeft>
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
                        <Textbox Name="CustLedgEntryEndDtPostingDt">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEPostingDate.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>d</Format>
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
                          <ZIndex>117</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryEndDtDocType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEDocType.Value</Value>
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
                          <ZIndex>116</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
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
                        <Textbox Name="CustLedgEntryEndDtDocNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDateDocNo.Value</Value>
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
                          <ZIndex>115</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
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
                        <Textbox Name="CustLedgEntryEndDtDueDt">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDueDate.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>d</Format>
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
                          <ZIndex>114</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
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
                        <Textbox Name="CustLedgEntryEndDtAmtLCY">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDateAmtLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CLEEndDateAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>113</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
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
                        <Textbox Name="OriginalAmountCtrl58">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDateRemAmtLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CLEEndDateRemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>112</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
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
                        <Textbox Name="OriginalAmountCtrl59">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE1RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE1RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>111</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
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
                        <Textbox Name="OriginalAmountCtrl60">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE2RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE2RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>110</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
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
                        <Textbox Name="OriginalAmountCtrl61">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE3RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE3RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>109</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
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
                        <Textbox Name="OriginalAmountCtrl62">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE4RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE4RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>108</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
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
                        <Textbox Name="OriginalAmountCtrl63">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE5RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE5RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>107</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BackgroundColor>="#EFEFEF"</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="CustLedgEntryEndDtPostingDtCtrl99">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEPostingDate.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>d</Format>
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
                          <ZIndex>106</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryEndDtDocTypeCtrl98">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEDocType.Value</Value>
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
                          <ZIndex>105</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="CustLedgEntryEndDtDocNoCtrl97">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDateDocNo.Value</Value>
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
                          <ZIndex>104</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="CustLedgEntryEndDtDueDtCtrl96">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDueDate.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>d</Format>
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
                          <ZIndex>103</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="CustLedgEntryEndingDateAmt">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CLEEndDate.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CLEEndDateFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>102</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="OriginalAmountCtrl94">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!RemAmt_CLEEndDate.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!RemAmt_CLEEndDateFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>101</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="OriginalAmountCtrl93">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE1TempRemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE1TempRemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>100</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="OriginalAmountCtrl92">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE2TempRemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE2TempRemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>99</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="OriginalAmountCtrl91">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE3TempRemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE3TempRemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>98</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="OriginalAmountCtrl90">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE4TempRemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE4TempRemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>97</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="OriginalAmountCtrl89">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE5TempRemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE5TempRemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>96</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13799in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustNo1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!No_Cust.Value)</Value>
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
                          <ZIndex>19</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustName11">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!Name1_Cust.Value)</Value>
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
                          <ZIndex>18</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="OriginalAmountCtrl100">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!CurrrencyCode.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>17</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl107">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE1Amt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE1AmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>16</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl106">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE1RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE1RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>15</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl105">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE2RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE2RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>14</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl104">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE3RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE3RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>13</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl103">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE4RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE4RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>12</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl102">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE5RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE5RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>11</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="CustNo2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!No_Cust.Value)</Value>
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
                          <ZIndex>27</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=last(Fields!Name1_Cust.Value)</Value>
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
                          <ZIndex>26</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="OriginalAmountCtrl83">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE1AmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE1AmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>25</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl84">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE1RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE1RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>24</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl85">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE2RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE2RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>23</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl86">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE3RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE3RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>22</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl87">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE4RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE4RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>21</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl88">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE5RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!TotalCLE5RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>20</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="CustName2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!Name_Cust.Value)</Value>
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>35</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox188">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=last(Fields!CurrrencyCode.Value)</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>34</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox189">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=last(Fields!TotalCLE1Amt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE1AmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>33</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl1061">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE1RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE1RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>32</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl1051">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE2RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE2RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>31</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl1041">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE3RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE3RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>30</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl1031">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE4RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE4RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>29</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl1021">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE5RemAmt.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE5RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>28</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="CustName3">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!Name_Cust.Value)</Value>
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>42</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="textbox224">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=last(Fields!TotalCLE1AmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE1AmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>41</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl184">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE1RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE1RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>40</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl851">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE2RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE2RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>39</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl861">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE3RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE3RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>38</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl871">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE4RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE4RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>37</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="OriginalAmountCtrl881">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!TotalCLE5RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TotalCLE5RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>36</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13799in</Height>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox1</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>11</ColSpan>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
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
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>11</ColSpan>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
                  <TablixCells>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox13</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox18</rd:DefaultName>
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
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TotalLCYCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalLCYCptn.Value</Value>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>63</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="OriginalAmtCtrl47Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE1AmtLCY.Value),last(Fields!GrandTotalCLEAmtLCY.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalCLEAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>60</ZIndex>
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
                        <Textbox Name="OriginalAmtCtrl46Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE1RemAmtLCY.Value),last(Fields!GrandTotalCLE1RemAmt.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalCLE1RemAmtFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>59</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl45Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE2RemAmtLCY.Value),last(Fields!GrandTotalCLE2RemAmt.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalCLE2RemAmtFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>58</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl44Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE3RemAmtLCY.Value),last(Fields!GrandTotalCLE3RemAmt.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalCLE3RemAmtFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>57</ZIndex>
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
                        <Textbox Name="OriginalAmountCtrl43Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE4RemAmtLCY.Value),last(Fields!GrandTotalCLE4RemAmt.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalCLE4RemAmtFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>56</ZIndex>
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
                        <Textbox Name="OriginalAmountFormat">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE5RemAmtLCY.Value),last(Fields!GrandTotalCLE5RemAmt.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalCLE5RemAmtFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>55</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                        <Textbox Name="textbox383">
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
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox383</rd:DefaultName>
                          <ZIndex>75</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
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
                        <Textbox Name="GTCustLedgEntryRAmtLCYAmtLCY1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE1PctRemAmtLCY.Value),last(Fields!GrandTotalCLE1CustRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>68</ZIndex>
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
                        <Textbox Name="GTCustLedgEntry2RAmtLCY1AmtLCY1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE2PctRemAmtLCY.Value),last(Fields!GrandTotalCLE2CustRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>67</ZIndex>
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
                        <Textbox Name="CustLedgEntry3RAmtLCY1AmtLCY1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE3PctRemAmtLCY.Value),last(Fields!GrandTotalCLE3CustRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>66</ZIndex>
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
                        <Textbox Name="CustLedgEntry4RAmtLCY1AmtLCY1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE4CustRemAmtLCY.Value),last(Fields!GrandTotalCLE4CustRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>65</ZIndex>
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
                        <Textbox Name="CustLedgEntry5RAmtLCY1AmtLCY1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(last(Fields!TotalCheck.Value),last(Fields!GrandTotalCLE5PctRemAmtLCY.Value),last(Fields!GrandTotalCLE5CustRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>64</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
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
                <TablixMember />
                <TablixMember />
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <Visibility>
                    <Hidden>=iif(Fields!AgingByDueDate.Value,false,true)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=iif(Fields!AgingByDueDate.Value,false,true)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=iif(Fields!AgingByDueDate.Value,true,false)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=iif(Fields!AgingByDueDate.Value,true,false)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=iif(Fields!PrintDetails.Value,false,true)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=iif(Fields!PrintAmountInLCY.Value,false,true) or iif(Fields!PrintDetails.Value, true,false)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=iif(Fields!PrintAmountInLCY.Value,true,false) or iif(Fields!PrintDetails.Value,true,false)</Hidden>
                  </Visibility>
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
                  <Group Name="Table1_Group4">
                    <GroupExpressions>
                      <GroupExpression>=Fields!CompanyName.Value</GroupExpression>
                    </GroupExpressions>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <Group Name="Table1_Group3">
                        <GroupExpressions>
                          <GroupExpression>=IIF(Fields!NewPagePercustomer.Value,Fields!PageGroupNo.Value,1)</GroupExpression>
                        </GroupExpressions>
                        <PageBreak>
                          <BreakLocation>Between</BreakLocation>
                        </PageBreak>
                        <Filters>
                          <Filter>
                            <FilterExpression>=String.IsNullOrEmpty(Fields!No_Cust.Value)</FilterExpression>
                            <Operator>Equal</Operator>
                            <FilterValues>
                              <FilterValue>=false</FilterValue>
                            </FilterValues>
                          </Filter>
                        </Filters>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <Group Name="Table1_Group2">
                            <GroupExpressions>
                              <GroupExpression>=Fields!No_Cust.Value</GroupExpression>
                              <GroupExpression>=Fields!CurrrencyCode.Value</GroupExpression>
                            </GroupExpressions>
                            <Filters>
                              <Filter>
                                <FilterExpression>=String.IsNullOrEmpty(Fields!No_Cust.Value)</FilterExpression>
                                <Operator>Equal</Operator>
                                <FilterValues>
                                  <FilterValue>=false</FilterValue>
                                </FilterValues>
                              </Filter>
                            </Filters>
                          </Group>
                          <TablixMembers>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!PrintDetails.Value,false,true)</Hidden>
                              </Visibility>
                              <KeepWithGroup>After</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Group Name="Table1_Details_Group">
                                <DataElementName>Detail</DataElementName>
                              </Group>
                              <TablixMembers>
                                <TablixMember>
                                  <Visibility>
                                    <Hidden>=iif(Fields!PrintAmountInLCY.Value,false,true) or iif(Fields!PrintDetails.Value,false,true)</Hidden>
                                  </Visibility>
                                </TablixMember>
                                <TablixMember>
                                  <Visibility>
                                    <Hidden>=iif(Fields!PrintAmountInLCY.Value,true,false) or iif(Fields!PrintDetails.Value,false,true)</Hidden>
                                  </Visibility>
                                </TablixMember>
                              </TablixMembers>
                              <DataElementName>Detail_Collection</DataElementName>
                              <DataElementOutput>Output</DataElementOutput>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!PrintAmountInLCY.Value,true,false) or iif(Fields!PrintDetails.Value,true,false)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <RepeatOnNewPage>true</RepeatOnNewPage>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!PrintAmountInLCY.Value,false,true) or iif(Fields!PrintDetails.Value,true,false)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <RepeatOnNewPage>true</RepeatOnNewPage>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!PrintAmountInLCY.Value,true,false) or iif(Fields!PrintDetails.Value,false,true)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <RepeatOnNewPage>true</RepeatOnNewPage>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!PrintAmountInLCY.Value,false,true) or iif(Fields!PrintDetails.Value,false,true)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <RepeatOnNewPage>true</RepeatOnNewPage>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!PrintAmountInLCY.Value,false,true) or iif(Fields!PrintDetails.Value,false,true)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <RepeatOnNewPage>true</RepeatOnNewPage>
                            </TablixMember>
                          </TablixMembers>
                        </TablixMember>
                      </TablixMembers>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=iif(Fields!PrintAmountInLCY.Value,false,true) and iif(Fields!PrintDetails.Value,true,false)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                    </TablixMember>
                    <TablixMember>
                      <KeepWithGroup>Before</KeepWithGroup>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=iif(First(Fields!TotalLCYCptn.Value)="",true,false)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=iif(First(Fields!TotalLCYCptn.Value)="",true,false)</Hidden>
                      </Visibility>
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
                <FilterExpression>=Fields!CLEEndDateDocNo.Value</FilterExpression>
                <Operator>GreaterThanOrEqual</Operator>
                <FilterValues>
                  <FilterValue>''</FilterValue>
                </FilterValues>
              </Filter>
            </Filters>
            <Top>1.51694cm</Top>
            <Height>6.48195cm</Height>
            <Width>25.18367cm</Width>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
            </Style>
          </Tablix>
          <Textbox Name="TABLECptnCustFilter">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!TableCaptnCustFilter.Value</Value>
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
            <Top>1.09361cm</Top>
            <Height>11pt</Height>
            <Width>25.18376cm</Width>
            <ZIndex>1</ZIndex>
            <Visibility>
              <Hidden>=iif(Fields!CustFilter.Value="",true,false)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="AllAmtsinLCYCptn">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!AllAmtinLCYCptn.Value</Value>
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
            <Top>0.74084cm</Top>
            <Height>11pt</Height>
            <Width>713.87048pt</Width>
            <ZIndex>2</ZIndex>
            <Visibility>
              <Hidden>=iif(Fields!PrintAmountInLCY.Value,false,true)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="AgingByText009">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!PostingDate.Value</Value>
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
            <Top>0.35278cm</Top>
            <Height>11pt</Height>
            <Width>713.87048pt</Width>
            <ZIndex>3</ZIndex>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="FORMATEndingDate">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=Fields!FormatEndingDate.Value</Value>
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
            <Height>11pt</Height>
            <Width>713.87048pt</Width>
            <ZIndex>4</ZIndex>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Tablix Name="OriginalTable">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>1.8577in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.66094in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.04637in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.06604in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.10442in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.04733in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.06604in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.06604in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.27778in</Height>
                  <TablixCells>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox4</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox5</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox6</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox8</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox9</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox10</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                            <VerticalAlign>Middle</VerticalAlign>
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
                            <VerticalAlign>Middle</VerticalAlign>
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
                        <Textbox Name="Number1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=first(Fields!CurrSpecificationCptn.Value, "OriginalTable")</Value>
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
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>83</ZIndex>
                          <Visibility>
                            <Hidden>=iif(Fields!CurrNo.Value,false,true)</Hidden>
                          </Visibility>
                          <DataElementOutput>NoOutput</DataElementOutput>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl117">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TempCurrCode.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>82</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl119Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE6RemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE6RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>81</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl120Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE1RemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE1RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>80</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl121Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE2RemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE2RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>79</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl122Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE3RemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE3RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>78</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl123Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE4RemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE4RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>77</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="OriginalAmountCtrl124Format">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedCLE5RemAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AgedCLE5RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>76</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
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
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <KeepWithGroup>After</KeepWithGroup>
                </TablixMember>
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
            <DataSetName>DataSet_Result</DataSetName>
            <Filters>
              <Filter>
                <FilterExpression>=String.IsNullOrEmpty(Fields!CurrSpecificationCptn.Value)</FilterExpression>
                <Operator>Equal</Operator>
                <FilterValues>
                  <FilterValue>=false</FilterValue>
                </FilterValues>
              </Filter>
            </Filters>
            <Top>8.08777cm</Top>
            <Height>1.05834cm</Height>
            <Width>25.1838cm</Width>
            <ZIndex>5</ZIndex>
            <Visibility>
              <Hidden>=iif(Fields!CurrNo.Value,false,true)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>9.14611cm</Height>
        <Style>
          <FontFamily>Segoe UI</FontFamily>
          <FontSize>8pt</FontSize>
        </Style>
      </Body>
      <Width>25.1838cm</Width>
      <Page>
        <PageHeader>
          <Height>1.85075cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="CurrReportPAGENOCptn1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CurrReportPageNoCptn.Value,"DataSet_Result") &amp; " " &amp; Globals!PageNumber</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.41981cm</Top>
              <Left>20.77861cm</Left>
              <Height>11pt</Height>
              <Width>4.40515cm</Width>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="AgedAcctsReceivableCptn1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!AgedAccReceivableCptn.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>14pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Height>20pt</Height>
              <Width>484.95402pt</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="COMPANYNAME1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CompanyName.Value,"DataSet_Result")</Value>
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
              <Top>0.7405cm</Top>
              <Height>11pt</Height>
              <Width>589pt</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="ExecutionTimeTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!TodayFormatted.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Format>D</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>17.1081cm</Left>
              <Height>11pt</Height>
              <Width>8.07566cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
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
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <FontFamily>Segoe UI</FontFamily>
                    <FontSize>8pt</FontSize>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>0.77225cm</Top>
              <Left>20.77861cm</Left>
              <Height>11pt</Height>
              <Width>4.40515cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
          </ReportItems>
          <Style>
            <FontFamily>Segoe UI</FontFamily>
            <FontSize>8pt</FontSize>
          </Style>
        </PageHeader>
        <PageHeight>21cm</PageHeight>
        <PageWidth>29.7cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.05834cm</LeftMargin>
        <RightMargin>1.05834cm</RightMargin>
        <TopMargin>1.05834cm</TopMargin>
        <BottomMargin>1.48166cm</BottomMargin>
        <ColumnSpacing>1.27cm</ColumnSpacing>
        <Style>
          <FontFamily>Segoe UI</FontFamily>
          <FontSize>8pt</FontSize>
        </Style>
      </Page>
    </ReportSection>
  </ReportSections>
  <ReportParameters>
    <ReportParameter Name="Name1_CustCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Name1_CustCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Name1_CustCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="No_CustCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>No_CustCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>No_CustCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="BalanceCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>BalanceCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>BalanceCaption</Prompt>
    </ReportParameter>
  </ReportParameters>
  <ReportParametersLayout>
    <GridLayoutDefinition>
      <NumberOfColumns>1</NumberOfColumns>
      <NumberOfRows>3</NumberOfRows>
      <CellDefinitions>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>0</RowIndex>
          <ParameterName>Name1_CustCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>1</RowIndex>
          <ParameterName>No_CustCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>2</RowIndex>
          <ParameterName>BalanceCaption</ParameterName>
        </CellDefinition>
      </CellDefinitions>
    </GridLayoutDefinition>
  </ReportParametersLayout>
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
  <rd:ReportID>c70db985-a5f0-429a-a660-a31b7edb01ff</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

