OBJECT Report 322 Aged Accounts Payable
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Aldersfordelt g�ld;
               ENU=Aged Accounts Payable];
    OnPreReport=VAR
                  CaptionManagement@1000 : Codeunit 42;
                BEGIN
                  VendorFilter := CaptionManagement.GetRecordFiltersWithCaptions(Vendor);

                  GLSetup.GET;

                  CalcDates;
                  CreateHeadings;

                  TodayFormatted := TypeHelper.GetFormattedCurrentDateTimeInUserTimeZone('f');
                  CompanyDisplayName := COMPANYPROPERTY.DISPLAYNAME;
                END;

  }
  DATASET
  {
    { 3182;    ;DataItem;Vendor              ;
               DataItemTable=Table23;
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               PageGroupNo := 1;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF NewPagePerVendor THEN
                                    PageGroupNo := PageGroupNo + 1;

                                  TempCurrency.RESET;
                                  TempCurrency.DELETEALL;
                                  TempVendorLedgEntry.RESET;
                                  TempVendorLedgEntry.DELETEALL;
                                  CLEAR(GrandTotalVLERemaingAmtLCY);
                                  GrandTotalVLEAmtLCY := 0;
                                END;

               ReqFilterFields=No. }

    { 3   ;1   ;Column  ;TodayFormatted      ;
               SourceExpr=TodayFormatted }

    { 4   ;1   ;Column  ;CompanyName         ;
               SourceExpr=CompanyDisplayName }

    { 132 ;1   ;Column  ;NewPagePerVendor    ;
               SourceExpr=NewPagePerVendor }

    { 108 ;1   ;Column  ;AgesAsOfEndingDate  ;
               SourceExpr=STRSUBSTNO(Text006,FORMAT(EndingDate,0,4)) }

    { 110 ;1   ;Column  ;SelectAgeByDuePostngDocDt;
               SourceExpr=STRSUBSTNO(Text007,SELECTSTR(AgingBy + 1,Text009)) }

    { 128 ;1   ;Column  ;PrintAmountInLCY    ;
               SourceExpr=PrintAmountInLCY }

    { 1   ;1   ;Column  ;CaptionVendorFilter ;
               SourceExpr=TABLECAPTION + ': ' + VendorFilter }

    { 126 ;1   ;Column  ;VendorFilter        ;
               SourceExpr=VendorFilter }

    { 129 ;1   ;Column  ;AgingBy             ;
               SourceExpr=AgingBy }

    { 57  ;1   ;Column  ;SelctAgeByDuePostngDocDt1;
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

    { 130 ;1   ;Column  ;PrintDetails        ;
               SourceExpr=PrintDetails }

    { 42  ;1   ;Column  ;GrandTotalVLE5RemAmtLCY;
               SourceExpr=GrandTotalVLERemaingAmtLCY[5];
               AutoFormatType=1 }

    { 43  ;1   ;Column  ;GrandTotalVLE4RemAmtLCY;
               SourceExpr=GrandTotalVLERemaingAmtLCY[4];
               AutoFormatType=1 }

    { 44  ;1   ;Column  ;GrandTotalVLE3RemAmtLCY;
               SourceExpr=GrandTotalVLERemaingAmtLCY[3];
               AutoFormatType=1 }

    { 45  ;1   ;Column  ;GrandTotalVLE2RemAmtLCY;
               SourceExpr=GrandTotalVLERemaingAmtLCY[2];
               AutoFormatType=1 }

    { 46  ;1   ;Column  ;GrandTotalVLE1RemAmtLCY;
               SourceExpr=GrandTotalVLERemaingAmtLCY[1];
               AutoFormatType=1 }

    { 47  ;1   ;Column  ;GrandTotalVLE1AmtLCY;
               SourceExpr=GrandTotalVLEAmtLCY;
               AutoFormatType=1 }

    { 127 ;1   ;Column  ;PageGroupNo         ;
               SourceExpr=PageGroupNo }

    { 140 ;1   ;Column  ;No_Vendor           ;
               SourceExpr="No." }

    { 2   ;1   ;Column  ;AgedAcctPayableCaption;
               SourceExpr=AgedAcctPayableCaptionLbl }

    { 6   ;1   ;Column  ;CurrReportPageNoCaption;
               SourceExpr=CurrReportPageNoCaptionLbl }

    { 111 ;1   ;Column  ;AllAmtsinLCYCaption ;
               SourceExpr=AllAmtsinLCYCaptionLbl }

    { 54  ;1   ;Column  ;AgedOverdueAmsCaption;
               SourceExpr=AgedOverdueAmsCaptionLbl }

    { 74  ;1   ;Column  ;GrandTotalVLE5RemAmtLCYCaption;
               SourceExpr=GrandTotalVLE5RemAmtLCYCaptionLbl }

    { 75  ;1   ;Column  ;AmountLCYCaption    ;
               SourceExpr=AmountLCYCaptionLbl }

    { 76  ;1   ;Column  ;DueDateCaption      ;
               SourceExpr=DueDateCaptionLbl }

    { 77  ;1   ;Column  ;DocumentNoCaption   ;
               SourceExpr=DocumentNoCaptionLbl }

    { 78  ;1   ;Column  ;PostingDateCaption  ;
               SourceExpr=PostingDateCaptionLbl }

    { 79  ;1   ;Column  ;DocumentTypeCaption ;
               SourceExpr=DocumentTypeCaptionLbl }

    { 10  ;1   ;Column  ;VendorNoCaption     ;
               SourceExpr=FIELDCAPTION("No.") }

    { 16  ;1   ;Column  ;VendorNameCaption   ;
               SourceExpr=FIELDCAPTION(Name) }

    { 41  ;1   ;Column  ;CurrencyCaption     ;
               SourceExpr=CurrencyCaptionLbl }

    { 55  ;1   ;Column  ;TotalLCYCaption     ;
               SourceExpr=TotalLCYCaptionLbl }

    { 4114;1   ;DataItem;                    ;
               DataItemTable=Table25;
               DataItemTableView=SORTING(Vendor No.,Posting Date,Currency Code);
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               SETRANGE("Posting Date",EndingDate + 1,DMY2DATE(31,12,9999));
                             END;

               OnAfterGetRecord=VAR
                                  VendorLedgEntry@1000 : Record 25;
                                BEGIN
                                  VendorLedgEntry.SETCURRENTKEY("Closed by Entry No.");
                                  VendorLedgEntry.SETRANGE("Closed by Entry No.","Entry No.");
                                  VendorLedgEntry.SETRANGE("Posting Date",0D,EndingDate);
                                  IF VendorLedgEntry.FINDSET(FALSE,FALSE) THEN
                                    REPEAT
                                      InsertTemp(VendorLedgEntry);
                                    UNTIL VendorLedgEntry.NEXT = 0;

                                  IF "Closed by Entry No." <> 0 THEN BEGIN
                                    VendorLedgEntry.SETRANGE("Closed by Entry No.","Closed by Entry No.");
                                    IF VendorLedgEntry.FINDSET(FALSE,FALSE) THEN
                                      REPEAT
                                        InsertTemp(VendorLedgEntry);
                                      UNTIL VendorLedgEntry.NEXT = 0;
                                  END;

                                  VendorLedgEntry.RESET;
                                  VendorLedgEntry.SETRANGE("Entry No.","Closed by Entry No.");
                                  VendorLedgEntry.SETRANGE("Posting Date",0D,EndingDate);
                                  IF VendorLedgEntry.FINDSET(FALSE,FALSE) THEN
                                    REPEAT
                                      InsertTemp(VendorLedgEntry);
                                    UNTIL VendorLedgEntry.NEXT = 0;
                                  CurrReport.SKIP;
                                END;

               DataItemLink=Vendor No.=FIELD(No.) }

    { 7673;1   ;DataItem;OpenVendorLedgEntry ;
               DataItemTable=Table25;
               DataItemTableView=SORTING(Vendor No.,Open,Positive,Due Date,Currency Code);
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
                                 SETRANGE("Posting Date",0D,EndingDate);
                                 SETRANGE("Date Filter",0D,EndingDate);
                               END
                             END;

               OnAfterGetRecord=BEGIN
                                  IF AgingBy = AgingBy::"Posting Date" THEN BEGIN
                                    CALCFIELDS("Remaining Amt. (LCY)");
                                    IF "Remaining Amt. (LCY)" = 0 THEN
                                      CurrReport.SKIP;
                                  END;
                                  InsertTemp(OpenVendorLedgEntry);
                                  CurrReport.SKIP;
                                END;

               DataItemLink=Vendor No.=FIELD(No.) }

    { 6523;1   ;DataItem;CurrencyLoop        ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               NumberOfCurrencies := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  CLEAR(TotalVendorLedgEntry);

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

               OnPostDataItem=BEGIN
                                IF NewPagePerVendor AND (NumberOfCurrencies > 0) THEN
                                  CurrReport.NEWPAGE;
                              END;
                               }

    { 4766;2   ;DataItem;TempVendortLedgEntryLoop;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT PrintAmountInLCY THEN
                                 TempVendorLedgEntry.SETRANGE("Currency Code",TempCurrency.Code);
                             END;

               OnAfterGetRecord=VAR
                                  PeriodIndex@1001 : Integer;
                                BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempVendorLedgEntry.FINDSET(FALSE,FALSE) THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF TempVendorLedgEntry.NEXT = 0 THEN
                                      CurrReport.BREAK;

                                  VendorLedgEntryEndingDate := TempVendorLedgEntry;
                                  DetailedVendorLedgerEntry.SETRANGE("Vendor Ledger Entry No.",VendorLedgEntryEndingDate."Entry No.");
                                  IF DetailedVendorLedgerEntry.FINDSET(FALSE,FALSE) THEN
                                    REPEAT
                                      IF (DetailedVendorLedgerEntry."Entry Type" =
                                          DetailedVendorLedgerEntry."Entry Type"::"Initial Entry") AND
                                         (VendorLedgEntryEndingDate."Posting Date" > EndingDate) AND
                                         (AgingBy <> AgingBy::"Posting Date")
                                      THEN BEGIN
                                        IF VendorLedgEntryEndingDate."Document Date" <= EndingDate THEN
                                          DetailedVendorLedgerEntry."Posting Date" :=
                                            VendorLedgEntryEndingDate."Document Date"
                                        ELSE
                                          IF (VendorLedgEntryEndingDate."Due Date" <= EndingDate) AND
                                             (AgingBy = AgingBy::"Due Date")
                                          THEN
                                            DetailedVendorLedgerEntry."Posting Date" :=
                                              VendorLedgEntryEndingDate."Due Date"
                                      END;

                                      IF (DetailedVendorLedgerEntry."Posting Date" <= EndingDate) OR
                                         (TempVendorLedgEntry.Open AND
                                          (AgingBy = AgingBy::"Due Date") AND
                                          (VendorLedgEntryEndingDate."Due Date" > EndingDate) AND
                                          (VendorLedgEntryEndingDate."Posting Date" <= EndingDate))
                                      THEN BEGIN
                                        IF DetailedVendorLedgerEntry."Entry Type" IN
                                           [DetailedVendorLedgerEntry."Entry Type"::"Initial Entry",
                                            DetailedVendorLedgerEntry."Entry Type"::"Unrealized Loss",
                                            DetailedVendorLedgerEntry."Entry Type"::"Unrealized Gain",
                                            DetailedVendorLedgerEntry."Entry Type"::"Realized Loss",
                                            DetailedVendorLedgerEntry."Entry Type"::"Realized Gain",
                                            DetailedVendorLedgerEntry."Entry Type"::"Payment Discount",
                                            DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Excl.)",
                                            DetailedVendorLedgerEntry."Entry Type"::"Payment Discount (VAT Adjustment)",
                                            DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance",
                                            DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance",
                                            DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Excl.)",
                                            DetailedVendorLedgerEntry."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                                            DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                            DetailedVendorLedgerEntry."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]
                                        THEN BEGIN
                                          VendorLedgEntryEndingDate.Amount := VendorLedgEntryEndingDate.Amount + DetailedVendorLedgerEntry.Amount;
                                          VendorLedgEntryEndingDate."Amount (LCY)" :=
                                            VendorLedgEntryEndingDate."Amount (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                        END;
                                        IF DetailedVendorLedgerEntry."Posting Date" <= EndingDate THEN BEGIN
                                          VendorLedgEntryEndingDate."Remaining Amount" :=
                                            VendorLedgEntryEndingDate."Remaining Amount" + DetailedVendorLedgerEntry.Amount;
                                          VendorLedgEntryEndingDate."Remaining Amt. (LCY)" :=
                                            VendorLedgEntryEndingDate."Remaining Amt. (LCY)" + DetailedVendorLedgerEntry."Amount (LCY)";
                                        END;
                                      END;
                                    UNTIL DetailedVendorLedgerEntry.NEXT = 0;

                                  IF VendorLedgEntryEndingDate."Remaining Amount" = 0 THEN
                                    CurrReport.SKIP;

                                  CASE AgingBy OF
                                    AgingBy::"Due Date":
                                      PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Due Date");
                                    AgingBy::"Posting Date":
                                      PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Posting Date");
                                    AgingBy::"Document Date":
                                      BEGIN
                                        IF VendorLedgEntryEndingDate."Document Date" > EndingDate THEN BEGIN
                                          VendorLedgEntryEndingDate."Remaining Amount" := 0;
                                          VendorLedgEntryEndingDate."Remaining Amt. (LCY)" := 0;
                                          VendorLedgEntryEndingDate."Document Date" := VendorLedgEntryEndingDate."Posting Date";
                                        END;
                                        PeriodIndex := GetPeriodIndex(VendorLedgEntryEndingDate."Document Date");
                                      END;
                                  END;
                                  CLEAR(AgedVendorLedgEntry);
                                  AgedVendorLedgEntry[PeriodIndex]."Remaining Amount" := VendorLedgEntryEndingDate."Remaining Amount";
                                  AgedVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" := VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                                  TotalVendorLedgEntry[PeriodIndex]."Remaining Amount" += VendorLedgEntryEndingDate."Remaining Amount";
                                  TotalVendorLedgEntry[PeriodIndex]."Remaining Amt. (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                                  GrandTotalVLERemaingAmtLCY[PeriodIndex] += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                                  TotalVendorLedgEntry[1].Amount += VendorLedgEntryEndingDate."Remaining Amount";
                                  TotalVendorLedgEntry[1]."Amount (LCY)" += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                                  GrandTotalVLEAmtLCY += VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
                                END;

               OnPostDataItem=BEGIN
                                IF NOT PrintAmountInLCY THEN
                                  UpdateCurrencyTotals;
                              END;
                               }

    { 80  ;3   ;Column  ;VendorName          ;
               SourceExpr=Vendor.Name }

    { 81  ;3   ;Column  ;VendorNo            ;
               SourceExpr=Vendor."No." }

    { 58  ;3   ;Column  ;VLEEndingDateRemAmtLCY;
               SourceExpr=VendorLedgEntryEndingDate."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 59  ;3   ;Column  ;AgedVLE1RemAmtLCY   ;
               SourceExpr=AgedVendorLedgEntry[1]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 60  ;3   ;Column  ;AgedVendLedgEnt2RemAmtLCY;
               SourceExpr=AgedVendorLedgEntry[2]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 61  ;3   ;Column  ;AgedVendLedgEnt3RemAmtLCY;
               SourceExpr=AgedVendorLedgEntry[3]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 62  ;3   ;Column  ;AgedVendLedgEnt4RemAmtLCY;
               SourceExpr=AgedVendorLedgEntry[4]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 63  ;3   ;Column  ;AgedVendLedgEnt5RemAmtLCY;
               SourceExpr=AgedVendorLedgEntry[5]."Remaining Amt. (LCY)";
               AutoFormatType=1 }

    { 65  ;3   ;Column  ;VendLedgEntryEndDtAmtLCY;
               SourceExpr=VendorLedgEntryEndingDate."Amount (LCY)";
               AutoFormatType=1 }

    { 66  ;3   ;Column  ;VendLedgEntryEndDtDueDate;
               SourceExpr=FORMAT(VendorLedgEntryEndingDate."Due Date") }

    { 67  ;3   ;Column  ;VendLedgEntryEndDtDocNo;
               SourceExpr=VendorLedgEntryEndingDate."Document No." }

    { 68  ;3   ;Column  ;VendLedgEntyEndgDtDocType;
               SourceExpr=FORMAT(VendorLedgEntryEndingDate."Document Type") }

    { 69  ;3   ;Column  ;VendLedgEntryEndDtPostgDt;
               SourceExpr=FORMAT(VendorLedgEntryEndingDate."Posting Date") }

    { 89  ;3   ;Column  ;AgedVendLedgEnt5RemAmt;
               SourceExpr=AgedVendorLedgEntry[5]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 90  ;3   ;Column  ;AgedVendLedgEnt4RemAmt;
               SourceExpr=AgedVendorLedgEntry[4]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 91  ;3   ;Column  ;AgedVendLedgEnt3RemAmt;
               SourceExpr=AgedVendorLedgEntry[3]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 92  ;3   ;Column  ;AgedVendLedgEnt2RemAmt;
               SourceExpr=AgedVendorLedgEntry[2]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 93  ;3   ;Column  ;AgedVendLedgEnt1RemAmt;
               SourceExpr=AgedVendorLedgEntry[1]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 94  ;3   ;Column  ;VLEEndingDateRemAmt ;
               SourceExpr=VendorLedgEntryEndingDate."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 95  ;3   ;Column  ;VendLedgEntryEndingDtAmt;
               SourceExpr=VendorLedgEntryEndingDate.Amount;
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 82  ;3   ;Column  ;TotalVendorName     ;
               SourceExpr=STRSUBSTNO(Text005,Vendor.Name) }

    { 100 ;3   ;Column  ;CurrCode_TempVenLedgEntryLoop;
               SourceExpr=CurrencyCode;
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 8052;    ;DataItem;CurrencyTotals      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               PageGroupNo := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempCurrency2.FINDSET(FALSE,FALSE) THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF TempCurrency2.NEXT = 0 THEN
                                      CurrReport.BREAK;

                                  CLEAR(AgedVendorLedgEntry);
                                  TempCurrencyAmount.SETRANGE("Currency Code",TempCurrency2.Code);
                                  IF TempCurrencyAmount.FINDSET(FALSE,FALSE) THEN
                                    REPEAT
                                      IF TempCurrencyAmount.Date <> DMY2DATE(31,12,9999) THEN
                                        AgedVendorLedgEntry[GetPeriodIndex(TempCurrencyAmount.Date)]."Remaining Amount" :=
                                          TempCurrencyAmount.Amount
                                      ELSE
                                        AgedVendorLedgEntry[6]."Remaining Amount" := TempCurrencyAmount.Amount;
                                    UNTIL TempCurrencyAmount.NEXT = 0;
                                END;
                                 }

    { 131 ;1   ;Column  ;Number_CurrencyTotals;
               SourceExpr=Number }

    { 133 ;1   ;Column  ;NewPagePerVend_CurrTotal;
               SourceExpr=NewPagePerVendor }

    { 117 ;1   ;Column  ;TempCurrency2Code   ;
               SourceExpr=TempCurrency2.Code;
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 119 ;1   ;Column  ;AgedVendLedgEnt6RemAmtLCY5;
               SourceExpr=AgedVendorLedgEntry[6]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 120 ;1   ;Column  ;AgedVendLedgEnt1RemAmtLCY1;
               SourceExpr=AgedVendorLedgEntry[1]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 121 ;1   ;Column  ;AgedVendLedgEnt2RemAmtLCY2;
               SourceExpr=AgedVendorLedgEntry[2]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 122 ;1   ;Column  ;AgedVendLedgEnt3RemAmtLCY3;
               SourceExpr=AgedVendorLedgEntry[3]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 123 ;1   ;Column  ;AgedVendLedgEnt4RemAmtLCY4;
               SourceExpr=AgedVendorLedgEntry[4]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 124 ;1   ;Column  ;AgedVendLedgEnt5RemAmtLCY5;
               SourceExpr=AgedVendorLedgEntry[5]."Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 125 ;1   ;Column  ;CurrencySpecificationCaption;
               SourceExpr=CurrencySpecificationCaptionLbl }

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
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
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
                  CaptionML=[DAN=Udskriv bel�b i RV;
                             ENU=Print Amounts in LCY];
                  ToolTipML=[DAN=Angiver, om rapporten skal vise aldersfordelingen pr. kreditorpost.;
                             ENU=Specifies if you want the report to specify the aging per vendor ledger entry.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintAmountInLCY }

      { 11  ;2   ;Field     ;
                  CaptionML=[DAN=Udskriv detaljer;
                             ENU=Print Details];
                  ToolTipML=[DAN=Angiver, om rapporten skal vise detaljerede poster, der udg�r den totale saldo for hver kreditor.;
                             ENU=Specifies if you want the report to show the detailed entries that add up the total balance for each vendor.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintDetails }

      { 15  ;2   ;Field     ;
                  CaptionML=[DAN=Overskriftstype;
                             ENU=Heading Type];
                  ToolTipML=[DAN=Angiver, om kolonneoverskriften for de tre perioder indikerer et datointerval eller antallet af dage siden forfaldsdatoen.;
                             ENU=Specifies if the column heading for the three periods will indicate a date interval or the number of days overdue.];
                  OptionCaptionML=[DAN=Tidsinterval,Antal dage;
                                   ENU=Date Interval,Number of Days];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=HeadingType }

      { 13  ;2   ;Field     ;
                  CaptionML=[DAN=Skift side pr. kreditor;
                             ENU=New Page per Vendor];
                  ToolTipML=[DAN=Angiver, om oplysninger om hver enkelt kreditor udskrives p� en ny side, hvis du har valgt to eller flere kreditorer, der skal medtages i rapporten.;
                             ENU=Specifies if each vendor's information is printed on a new page if you have chosen two or more vendors to be included in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=NewPagePerVendor }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      GLSetup@1011 : Record 98;
      TempVendorLedgEntry@1009 : TEMPORARY Record 25;
      VendorLedgEntryEndingDate@1013 : Record 25;
      TotalVendorLedgEntry@1014 : ARRAY [5] OF Record 25;
      AgedVendorLedgEntry@1022 : ARRAY [6] OF Record 25;
      TempCurrency@1010 : TEMPORARY Record 4;
      TempCurrency2@1030 : TEMPORARY Record 4;
      TempCurrencyAmount@1029 : TEMPORARY Record 264;
      DetailedVendorLedgerEntry@1102601000 : Record 380;
      TypeHelper@1035 : Codeunit 10;
      GrandTotalVLERemaingAmtLCY@1018 : ARRAY [5] OF Decimal;
      GrandTotalVLEAmtLCY@1034 : Decimal;
      VendorFilter@1000 : Text;
      PrintAmountInLCY@1012 : Boolean;
      EndingDate@1001 : Date;
      AgingBy@1002 : 'Due Date,Posting Date,Document Date';
      PeriodLength@1003 : DateFormula;
      PrintDetails@1015 : Boolean;
      HeadingType@1019 : 'Date Interval,Number of Days';
      NewPagePerVendor@1027 : Boolean;
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
      Text010@1032 : TextConst 'DAN=Datoformlen %1 er ugyldig. Pr�v at omformulere den ved f.eks. at skrive 1M+LM i stedet for LM+1M.;ENU=The Date Formula %1 cannot be used. Try to restate it, for example, by using 1M+CM instead of CM+1M.';
      PageGroupNo@1033 : Integer;
      EnterDateFormulaErr@1026 : TextConst 'DAN=Angiv en datoformel i feltet Periodel�ngde.;ENU=Enter a date formula in the Period Length field.';
      Text027@1049 : TextConst '@@@=Negating the period length: %1 is the period length;DAN=-%1;ENU=-%1';
      AgedAcctPayableCaptionLbl@4917 : TextConst 'DAN=Aldersfordelt g�ld;ENU=Aged Accounts Payable';
      CurrReportPageNoCaptionLbl@2595 : TextConst 'DAN=Side;ENU=Page';
      AllAmtsinLCYCaptionLbl@4956 : TextConst 'DAN=Alle bel�b i RV;ENU=All Amounts in LCY';
      AgedOverdueAmsCaptionLbl@3975 : TextConst 'DAN=Aldersfordelte forfaldne bel�b;ENU=Aged Overdue Amounts';
      GrandTotalVLE5RemAmtLCYCaptionLbl@4625 : TextConst 'DAN=Saldo;ENU=Balance';
      AmountLCYCaptionLbl@1831 : TextConst 'DAN=Oprindeligt bel�b;ENU=Original Amount';
      DueDateCaptionLbl@3162 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      DocumentNoCaptionLbl@2552 : TextConst 'DAN=Bilagsnr.;ENU=Document No.';
      PostingDateCaptionLbl@4591 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      DocumentTypeCaptionLbl@5905 : TextConst 'DAN=Bilagstype;ENU=Document Type';
      CurrencyCaptionLbl@8050 : TextConst 'DAN=Valutakode;ENU=Currency Code';
      TotalLCYCaptionLbl@5808 : TextConst 'DAN=I alt (RV);ENU=Total (LCY)';
      CurrencySpecificationCaptionLbl@9777 : TextConst 'DAN=Valutaspecifikation;ENU=Currency Specification';
      TodayFormatted@1036 : Text;
      CompanyDisplayName@1037 : Text;

    LOCAL PROCEDURE CalcDates@5();
    VAR
      i@1000 : Integer;
      PeriodLength2@1001 : DateFormula;
    BEGIN
      IF NOT EVALUATE(PeriodLength2,STRSUBSTNO(Text027,PeriodLength)) THEN
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

      i := ARRAYLEN(PeriodEndDate);

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
        HeaderText[i] := STRSUBSTNO('%1\%2',Text001,PeriodStartDate[i - 1])
      ELSE
        HeaderText[i] := STRSUBSTNO('%1\%2 %3',Text003,EndingDate - PeriodStartDate[i - 1] + 1,Text002);
    END;

    LOCAL PROCEDURE InsertTemp@1(VAR VendorLedgEntry@1040000 : Record 25);
    VAR
      Currency@1000 : Record 4;
    BEGIN
      WITH TempVendorLedgEntry DO BEGIN
        IF GET(VendorLedgEntry."Entry No.") THEN
          EXIT;
        TempVendorLedgEntry := VendorLedgEntry;
        INSERT;
        IF PrintAmountInLCY THEN BEGIN
          CLEAR(TempCurrency);
          TempCurrency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
          IF TempCurrency.INSERT THEN;
          EXIT;
        END;
        IF TempCurrency.GET("Currency Code") THEN
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

    LOCAL PROCEDURE UpdateCurrencyTotals@7();
    VAR
      i@1000 : Integer;
    BEGIN
      TempCurrency2.Code := CurrencyCode;
      IF TempCurrency2.INSERT THEN;
      WITH TempCurrencyAmount DO BEGIN
        FOR i := 1 TO ARRAYLEN(TotalVendorLedgEntry) DO BEGIN
          "Currency Code" := CurrencyCode;
          Date := PeriodStartDate[i];
          IF FIND THEN BEGIN
            Amount := Amount + TotalVendorLedgEntry[i]."Remaining Amount";
            MODIFY;
          END ELSE BEGIN
            "Currency Code" := CurrencyCode;
            Date := PeriodStartDate[i];
            Amount := TotalVendorLedgEntry[i]."Remaining Amount";
            INSERT;
          END;
        END;
        "Currency Code" := CurrencyCode;
        Date := DMY2DATE(31,12,9999);
        IF FIND THEN BEGIN
          Amount := Amount + TotalVendorLedgEntry[1].Amount;
          MODIFY;
        END ELSE BEGIN
          "Currency Code" := CurrencyCode;
          Date := DMY2DATE(31,12,9999);
          Amount := TotalVendorLedgEntry[1].Amount;
          INSERT;
        END;
      END;
    END;

    PROCEDURE InitializeRequest@3(NewEndingDate@1004 : Date;NewAgingBy@1003 : Option;NewPeriodLength@1002 : DateFormula;NewPrintAmountInLCY@1006 : Boolean;NewPrintDetails@1001 : Boolean;NewHeadingType@1005 : Option;NewNewPagePerVendor@1000 : Boolean);
    BEGIN
      EndingDate := NewEndingDate;
      AgingBy := NewAgingBy;
      PeriodLength := NewPeriodLength;
      PrintAmountInLCY := NewPrintAmountInLCY;
      PrintDetails := NewPrintDetails;
      HeadingType := NewHeadingType;
      NewPagePerVendor := NewNewPagePerVendor;
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
      <rd:DataSourceID>baa5abde-6f4a-493b-8d8b-dff241d3f62b</rd:DataSourceID>
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
        <Field Name="NewPagePerVendor">
          <DataField>NewPagePerVendor</DataField>
        </Field>
        <Field Name="AgesAsOfEndingDate">
          <DataField>AgesAsOfEndingDate</DataField>
        </Field>
        <Field Name="SelectAgeByDuePostngDocDt">
          <DataField>SelectAgeByDuePostngDocDt</DataField>
        </Field>
        <Field Name="PrintAmountInLCY">
          <DataField>PrintAmountInLCY</DataField>
        </Field>
        <Field Name="CaptionVendorFilter">
          <DataField>CaptionVendorFilter</DataField>
        </Field>
        <Field Name="VendorFilter">
          <DataField>VendorFilter</DataField>
        </Field>
        <Field Name="AgingBy">
          <DataField>AgingBy</DataField>
        </Field>
        <Field Name="SelctAgeByDuePostngDocDt1">
          <DataField>SelctAgeByDuePostngDocDt1</DataField>
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
        <Field Name="GrandTotalVLE5RemAmtLCY">
          <DataField>GrandTotalVLE5RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalVLE5RemAmtLCYFormat">
          <DataField>GrandTotalVLE5RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalVLE4RemAmtLCY">
          <DataField>GrandTotalVLE4RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalVLE4RemAmtLCYFormat">
          <DataField>GrandTotalVLE4RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalVLE3RemAmtLCY">
          <DataField>GrandTotalVLE3RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalVLE3RemAmtLCYFormat">
          <DataField>GrandTotalVLE3RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalVLE2RemAmtLCY">
          <DataField>GrandTotalVLE2RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalVLE2RemAmtLCYFormat">
          <DataField>GrandTotalVLE2RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalVLE1RemAmtLCY">
          <DataField>GrandTotalVLE1RemAmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalVLE1RemAmtLCYFormat">
          <DataField>GrandTotalVLE1RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="GrandTotalVLE1AmtLCY">
          <DataField>GrandTotalVLE1AmtLCY</DataField>
        </Field>
        <Field Name="GrandTotalVLE1AmtLCYFormat">
          <DataField>GrandTotalVLE1AmtLCYFormat</DataField>
        </Field>
        <Field Name="PageGroupNo">
          <DataField>PageGroupNo</DataField>
        </Field>
        <Field Name="No_Vendor">
          <DataField>No_Vendor</DataField>
        </Field>
        <Field Name="AgedAcctPayableCaption">
          <DataField>AgedAcctPayableCaption</DataField>
        </Field>
        <Field Name="CurrReportPageNoCaption">
          <DataField>CurrReportPageNoCaption</DataField>
        </Field>
        <Field Name="AllAmtsinLCYCaption">
          <DataField>AllAmtsinLCYCaption</DataField>
        </Field>
        <Field Name="AgedOverdueAmsCaption">
          <DataField>AgedOverdueAmsCaption</DataField>
        </Field>
        <Field Name="GrandTotalVLE5RemAmtLCYCaption">
          <DataField>GrandTotalVLE5RemAmtLCYCaption</DataField>
        </Field>
        <Field Name="AmountLCYCaption">
          <DataField>AmountLCYCaption</DataField>
        </Field>
        <Field Name="DueDateCaption">
          <DataField>DueDateCaption</DataField>
        </Field>
        <Field Name="DocumentNoCaption">
          <DataField>DocumentNoCaption</DataField>
        </Field>
        <Field Name="PostingDateCaption">
          <DataField>PostingDateCaption</DataField>
        </Field>
        <Field Name="DocumentTypeCaption">
          <DataField>DocumentTypeCaption</DataField>
        </Field>
        <Field Name="VendorNoCaption">
          <DataField>VendorNoCaption</DataField>
        </Field>
        <Field Name="VendorNameCaption">
          <DataField>VendorNameCaption</DataField>
        </Field>
        <Field Name="CurrencyCaption">
          <DataField>CurrencyCaption</DataField>
        </Field>
        <Field Name="TotalLCYCaption">
          <DataField>TotalLCYCaption</DataField>
        </Field>
        <Field Name="VendorName">
          <DataField>VendorName</DataField>
        </Field>
        <Field Name="VendorNo">
          <DataField>VendorNo</DataField>
        </Field>
        <Field Name="VLEEndingDateRemAmtLCY">
          <DataField>VLEEndingDateRemAmtLCY</DataField>
        </Field>
        <Field Name="VLEEndingDateRemAmtLCYFormat">
          <DataField>VLEEndingDateRemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedVLE1RemAmtLCY">
          <DataField>AgedVLE1RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedVLE1RemAmtLCYFormat">
          <DataField>AgedVLE1RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt2RemAmtLCY">
          <DataField>AgedVendLedgEnt2RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt2RemAmtLCYFormat">
          <DataField>AgedVendLedgEnt2RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt3RemAmtLCY">
          <DataField>AgedVendLedgEnt3RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt3RemAmtLCYFormat">
          <DataField>AgedVendLedgEnt3RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt4RemAmtLCY">
          <DataField>AgedVendLedgEnt4RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt4RemAmtLCYFormat">
          <DataField>AgedVendLedgEnt4RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt5RemAmtLCY">
          <DataField>AgedVendLedgEnt5RemAmtLCY</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt5RemAmtLCYFormat">
          <DataField>AgedVendLedgEnt5RemAmtLCYFormat</DataField>
        </Field>
        <Field Name="VendLedgEntryEndDtAmtLCY">
          <DataField>VendLedgEntryEndDtAmtLCY</DataField>
        </Field>
        <Field Name="VendLedgEntryEndDtAmtLCYFormat">
          <DataField>VendLedgEntryEndDtAmtLCYFormat</DataField>
        </Field>
        <Field Name="VendLedgEntryEndDtDueDate">
          <DataField>VendLedgEntryEndDtDueDate</DataField>
        </Field>
        <Field Name="VendLedgEntryEndDtDocNo">
          <DataField>VendLedgEntryEndDtDocNo</DataField>
        </Field>
        <Field Name="VendLedgEntyEndgDtDocType">
          <DataField>VendLedgEntyEndgDtDocType</DataField>
        </Field>
        <Field Name="VendLedgEntryEndDtPostgDt">
          <DataField>VendLedgEntryEndDtPostgDt</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt5RemAmt">
          <DataField>AgedVendLedgEnt5RemAmt</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt5RemAmtFormat">
          <DataField>AgedVendLedgEnt5RemAmtFormat</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt4RemAmt">
          <DataField>AgedVendLedgEnt4RemAmt</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt4RemAmtFormat">
          <DataField>AgedVendLedgEnt4RemAmtFormat</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt3RemAmt">
          <DataField>AgedVendLedgEnt3RemAmt</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt3RemAmtFormat">
          <DataField>AgedVendLedgEnt3RemAmtFormat</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt2RemAmt">
          <DataField>AgedVendLedgEnt2RemAmt</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt2RemAmtFormat">
          <DataField>AgedVendLedgEnt2RemAmtFormat</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt1RemAmt">
          <DataField>AgedVendLedgEnt1RemAmt</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt1RemAmtFormat">
          <DataField>AgedVendLedgEnt1RemAmtFormat</DataField>
        </Field>
        <Field Name="VLEEndingDateRemAmt">
          <DataField>VLEEndingDateRemAmt</DataField>
        </Field>
        <Field Name="VLEEndingDateRemAmtFormat">
          <DataField>VLEEndingDateRemAmtFormat</DataField>
        </Field>
        <Field Name="VendLedgEntryEndingDtAmt">
          <DataField>VendLedgEntryEndingDtAmt</DataField>
        </Field>
        <Field Name="VendLedgEntryEndingDtAmtFormat">
          <DataField>VendLedgEntryEndingDtAmtFormat</DataField>
        </Field>
        <Field Name="TotalVendorName">
          <DataField>TotalVendorName</DataField>
        </Field>
        <Field Name="CurrCode_TempVenLedgEntryLoop">
          <DataField>CurrCode_TempVenLedgEntryLoop</DataField>
        </Field>
        <Field Name="Number_CurrencyTotals">
          <DataField>Number_CurrencyTotals</DataField>
        </Field>
        <Field Name="NewPagePerVend_CurrTotal">
          <DataField>NewPagePerVend_CurrTotal</DataField>
        </Field>
        <Field Name="TempCurrency2Code">
          <DataField>TempCurrency2Code</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt6RemAmtLCY5">
          <DataField>AgedVendLedgEnt6RemAmtLCY5</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt6RemAmtLCY5Format">
          <DataField>AgedVendLedgEnt6RemAmtLCY5Format</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt1RemAmtLCY1">
          <DataField>AgedVendLedgEnt1RemAmtLCY1</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt1RemAmtLCY1Format">
          <DataField>AgedVendLedgEnt1RemAmtLCY1Format</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt2RemAmtLCY2">
          <DataField>AgedVendLedgEnt2RemAmtLCY2</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt2RemAmtLCY2Format">
          <DataField>AgedVendLedgEnt2RemAmtLCY2Format</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt3RemAmtLCY3">
          <DataField>AgedVendLedgEnt3RemAmtLCY3</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt3RemAmtLCY3Format">
          <DataField>AgedVendLedgEnt3RemAmtLCY3Format</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt4RemAmtLCY4">
          <DataField>AgedVendLedgEnt4RemAmtLCY4</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt4RemAmtLCY4Format">
          <DataField>AgedVendLedgEnt4RemAmtLCY4Format</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt5RemAmtLCY5">
          <DataField>AgedVendLedgEnt5RemAmtLCY5</DataField>
        </Field>
        <Field Name="AgedVendLedgEnt5RemAmtLCY5Format">
          <DataField>AgedVendLedgEnt5RemAmtLCY5Format</DataField>
        </Field>
        <Field Name="CurrencySpecificationCaption">
          <DataField>CurrencySpecificationCaption</DataField>
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
          <Tablix Name="table3">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>0.59571in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.19685in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.62992in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.62492in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.23622in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.49994in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.72835in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.72835in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.72835in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.72835in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.72835in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.72835in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox295</rd:DefaultName>
                          <ZIndex>286</ZIndex>
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
                        <Textbox Name="textbox237">
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
                          <ZIndex>285</ZIndex>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>284</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>283</ZIndex>
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
                        <Textbox Name="textbox240">
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
                          <ZIndex>282</ZIndex>
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
                          <ZIndex>281</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                          <ZIndex>280</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                          <ZIndex>279</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox271">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(Fields!AgingBy.Value="Due Date",First(Fields!AgedOverdueAmsCaption.Value),First(Fields!SelctAgeByDuePostngDocDt1.Value))</Value>
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
                          <rd:DefaultName>textbox271</rd:DefaultName>
                          <ZIndex>278</ZIndex>
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
                  <Height>0.16654in</Height>
                  <TablixCells>
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
                          <ZIndex>277</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox288</rd:DefaultName>
                          <ZIndex>276</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox289</rd:DefaultName>
                          <ZIndex>275</ZIndex>
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
                          <ZIndex>274</ZIndex>
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
                          <ZIndex>273</ZIndex>
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
                        <Textbox Name="textbox293">
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
                          <rd:DefaultName>textbox293</rd:DefaultName>
                          <ZIndex>272</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox294">
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
                          <rd:DefaultName>textbox294</rd:DefaultName>
                          <ZIndex>271</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox327</rd:DefaultName>
                          <ZIndex>270</ZIndex>
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
                        <Textbox Name="textbox296">
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
                          <rd:DefaultName>textbox296</rd:DefaultName>
                          <ZIndex>269</ZIndex>
                          <Style>
                            <TopBorder>
                              <Style>=IIF(RowNumber(Nothing)=0,"None","Dotted")</Style>
                            </TopBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox272">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!PostingDateCaption.Value)," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>268</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox284">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!DocumentTypeCaption.Value)," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>267</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox297">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!DocumentNoCaption.Value)," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>266</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Code.CalcLeft(First(Fields!DueDateCaption.Value)," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>265</ZIndex>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>264</ZIndex>
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
                        <Textbox Name="textbox304">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!AmountLCYCaption.Value)," ")</Value>
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
                          <ZIndex>263</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox305">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!GrandTotalVLE5RemAmtLCYCaption.Value)," ")</Value>
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
                          <ZIndex>262</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText1.Value),"\")</Value>
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
                          <ZIndex>261</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox307">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText2.Value),"\")</Value>
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
                          <ZIndex>260</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox308">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText3.Value),"\")</Value>
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
                          <ZIndex>259</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText4.Value),"\")</Value>
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
                          <ZIndex>258</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText5.Value),"\")</Value>
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
                          <ZIndex>257</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                  <Height>0.21654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox314">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!PostingDateCaption.Value)," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>256</ZIndex>
                          <Style>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox315">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!DocumentTypeCaption.Value)," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>255</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox316">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!DocumentNoCaption.Value)," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>254</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox317">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!DueDateCaption.Value)," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>253</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox318">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!AmountLCYCaption.Value)," ")</Value>
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
                          <ZIndex>252</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox319">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!GrandTotalVLE5RemAmtLCYCaption.Value)," ")</Value>
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
                          <ZIndex>251</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
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
                                  <Value>=Code.CalcRight(First(Fields!HeaderText1.Value),"\")</Value>
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
                          <ZIndex>250</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
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
                                  <Value>=Code.CalcRight(First(Fields!HeaderText2.Value),"\")</Value>
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
                          <ZIndex>249</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
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
                                  <Value>=Code.CalcRight(First(Fields!HeaderText3.Value),"\")</Value>
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
                          <ZIndex>248</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
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
                                  <Value>=Code.CalcRight(First(Fields!HeaderText4.Value),"\")</Value>
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
                          <ZIndex>247</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
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
                                  <Value>=Code.CalcRight(First(Fields!HeaderText5.Value),"\")</Value>
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
                          <ZIndex>246</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
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
                        <Textbox Name="textbox330">
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
                          <ZIndex>245</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>244</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox332">
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
                          <ZIndex>243</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>242</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>241</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>240</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
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
                          <ZIndex>239</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>8pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox337">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText1.Value),"\")</Value>
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
                          <ZIndex>238</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText2.Value),"\")</Value>
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
                          <ZIndex>237</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText3.Value),"\")</Value>
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
                          <ZIndex>236</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText4.Value),"\")</Value>
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
                          <ZIndex>235</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText5.Value),"\")</Value>
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
                          <ZIndex>234</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                  <Height>0.21654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox347">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendorNoCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>233</ZIndex>
                          <Style>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox348">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendorNameCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>232</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
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
                        <Textbox Name="textbox349">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!GrandTotalVLE5RemAmtLCYCaption.Value)</Value>
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
                          <ZIndex>231</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox350">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!HeaderText1.Value),"\")</Value>
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
                          <ZIndex>230</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox351">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!HeaderText2.Value),"\")</Value>
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
                          <ZIndex>229</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
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
                                  <Value>=Code.CalcRight(First(Fields!HeaderText3.Value),"\")</Value>
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
                          <ZIndex>228</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox353">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!HeaderText4.Value),"\")</Value>
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
                          <ZIndex>227</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox354">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!HeaderText5.Value),"\")</Value>
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
                          <ZIndex>226</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
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
                        <Textbox Name="textbox391">
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
                          <ZIndex>225</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>224</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox393">
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
                          <ZIndex>223</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox394">
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
                          <ZIndex>222</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>221</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox396">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(Fields!CurrencyCaption.Value," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>220</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                          <ZIndex>219</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox398">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText1.Value),"\")</Value>
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
                          <ZIndex>218</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox399">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText2.Value),"\")</Value>
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
                          <ZIndex>217</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox400">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText3.Value),"\")</Value>
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
                          <ZIndex>216</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox401">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText4.Value),"\")</Value>
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
                          <ZIndex>215</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox402">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcLeft(First(Fields!HeaderText5.Value),"\")</Value>
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
                          <ZIndex>214</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                  <Height>0.21654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox406">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendorNoCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>213</ZIndex>
                          <Style>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox407">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendorNameCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>212</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                        <ColSpan>4</ColSpan>
                        <rd:Selected>true</rd:Selected>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox408">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(Fields!CurrencyCaption.Value," ")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>211</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox409">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!GrandTotalVLE5RemAmtLCYCaption.Value)</Value>
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
                          <ZIndex>210</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox410">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!HeaderText1.Value),"\")</Value>
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
                          <ZIndex>209</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
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
                                  <Value>=Code.CalcRight(First(Fields!HeaderText2.Value),"\")</Value>
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
                          <ZIndex>208</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox412">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!HeaderText3.Value),"\")</Value>
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
                          <ZIndex>207</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox413">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!HeaderText4.Value),"\")</Value>
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
                          <ZIndex>206</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox414">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Code.CalcRight(First(Fields!HeaderText5.Value),"\")</Value>
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
                          <ZIndex>205</ZIndex>
                          <Style>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingBottom>4pt</PaddingBottom>
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
                        <Textbox Name="textbox418">
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
                          <ZIndex>204</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox419">
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
                          <ZIndex>203</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox420">
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
                          <ZIndex>202</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox421">
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
                          <ZIndex>201</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox422">
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
                          <ZIndex>200</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox423">
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
                          <ZIndex>199</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox424">
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
                          <ZIndex>198</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox52</rd:DefaultName>
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
                        <Textbox Name="Textbox51">
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox51</rd:DefaultName>
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
                        <Textbox Name="Textbox72">
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox72</rd:DefaultName>
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
                        <Textbox Name="Textbox80">
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox80</rd:DefaultName>
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
                        <Textbox Name="textbox429">
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
                          <ZIndex>193</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalLCYCaption.Value,"DataSet_Result")</Value>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox11</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox12</rd:DefaultName>
                          <ZIndex>190</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox14</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox15</rd:DefaultName>
                          <ZIndex>187</ZIndex>
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
                                  <Value>=Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!VLEEndingDateRemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>186</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
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
                                  <Value>=Sum(Fields!AgedVLE1RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVLE1RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>185</ZIndex>
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
                        <Textbox Name="textbox68">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVendLedgEnt2RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVendLedgEnt2RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>184</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox69">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVendLedgEnt3RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVendLedgEnt3RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>183</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Sum(Fields!AgedVendLedgEnt4RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVendLedgEnt4RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>182</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
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
                                  <Value>=Sum(Fields!AgedVendLedgEnt5RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVendLedgEnt5RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>181</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox2">
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
                          <rd:DefaultName>textbox2</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox3</rd:DefaultName>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox4">
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
                          <rd:DefaultName>textbox4</rd:DefaultName>
                          <ZIndex>178</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox5</rd:DefaultName>
                          <ZIndex>177</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox6</rd:DefaultName>
                          <ZIndex>176</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox7</rd:DefaultName>
                          <ZIndex>175</ZIndex>
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
                                    <Format>=Fields!VLEEndingDateRemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox8</rd:DefaultName>
                          <ZIndex>174</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox107">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVLE1RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE4RemAmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>173</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox108">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt2RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE3RemAmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>172</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt3RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE2RemAmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>171</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt4RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE1RemAmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>170</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox111">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt5RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE1AmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>169</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox23</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox24</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox25</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox86</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox87</rd:DefaultName>
                          <ZIndex>164</ZIndex>
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
                          <ZIndex>163</ZIndex>
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
                                    <Format>=Fields!VLEEndingDateRemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox89</rd:DefaultName>
                          <ZIndex>162</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox90">
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
                                    <Format>=Fields!AgedVLE1RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox90</rd:DefaultName>
                          <ZIndex>161</ZIndex>
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
                        <Textbox Name="textbox91">
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
                                    <Format>=First(Fields!GrandTotalVLE2RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox91</rd:DefaultName>
                          <ZIndex>160</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox98">
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
                                    <Format>=First(Fields!GrandTotalVLE3RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox98</rd:DefaultName>
                          <ZIndex>159</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalVLE4RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox100</rd:DefaultName>
                          <ZIndex>158</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalVLE5RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox101</rd:DefaultName>
                          <ZIndex>157</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox83">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!No_Vendor.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>156</ZIndex>
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
                        <Textbox Name="textbox84">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendorName.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>155</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox73</rd:DefaultName>
                          <ZIndex>154</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox74</rd:DefaultName>
                          <ZIndex>153</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox75</rd:DefaultName>
                          <ZIndex>152</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox76</rd:DefaultName>
                          <ZIndex>151</ZIndex>
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
                          <ZIndex>150</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox78</rd:DefaultName>
                          <ZIndex>149</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox79</rd:DefaultName>
                          <ZIndex>148</ZIndex>
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
                        <Textbox Name="textbox33">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendLedgEntryEndDtPostgDt.Value</Value>
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
                          <ZIndex>147</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!VendLedgEntyEndgDtDocType.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>146</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!VendLedgEntryEndDtDocNo.Value</Value>
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
                          <ZIndex>145</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!VendLedgEntryEndDtDueDate.Value</Value>
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
                          <ZIndex>144</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox37">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendLedgEntryEndDtAmtLCY.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VendLedgEntryEndDtAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>143</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="textbox38">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VLEEndingDateRemAmtLCY.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VLEEndingDateRemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>142</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox39">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVLE1RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVLE1RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>141</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!AgedVendLedgEnt2RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt2RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>140</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox41">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVendLedgEnt3RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt3RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>139</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!AgedVendLedgEnt4RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt4RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>138</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox43">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVendLedgEnt5RemAmtLCY.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt5RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>137</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox44">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendLedgEntryEndDtPostgDt.Value</Value>
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
                          <ZIndex>136</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!VendLedgEntyEndgDtDocType.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>135</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!VendLedgEntryEndDtDocNo.Value</Value>
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
                          <ZIndex>134</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!VendLedgEntryEndDtDueDate.Value</Value>
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
                          <ZIndex>133</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!VendLedgEntryEndingDtAmt.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VendLedgEntryEndingDtAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>132</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="textbox49">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VLEEndingDateRemAmt.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VLEEndingDateRemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>131</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!AgedVendLedgEnt1RemAmt.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt1RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>130</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!AgedVendLedgEnt2RemAmt.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt2RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>129</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!AgedVendLedgEnt3RemAmt.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt3RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>128</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!AgedVendLedgEnt4RemAmt.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt4RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>127</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!AgedVendLedgEnt5RemAmt.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt5RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>126</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox67">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=IIF(Fields!Number_CurrencyTotals.Value=1,Fields!CurrencySpecificationCaption.Value,"")</Value>
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
                          <ZIndex>8</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="textbox165">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VendLedgEntryEndingDtAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox165</rd:DefaultName>
                          <ZIndex>7</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox187">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TempCurrency2Code.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!VendLedgEntryEndingDtAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox187</rd:DefaultName>
                          <ZIndex>6</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox188">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVendLedgEnt6RemAmtLCY5.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt6RemAmtLCY5Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox188</rd:DefaultName>
                          <ZIndex>5</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!AgedVendLedgEnt1RemAmtLCY1.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt1RemAmtLCY1Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox189</rd:DefaultName>
                          <ZIndex>4</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox197">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVendLedgEnt2RemAmtLCY2.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt2RemAmtLCY2Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox197</rd:DefaultName>
                          <ZIndex>3</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox198">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVendLedgEnt3RemAmtLCY3.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt3RemAmtLCY3Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox198</rd:DefaultName>
                          <ZIndex>2</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox199">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVendLedgEnt4RemAmtLCY4.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt4RemAmtLCY4Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox199</rd:DefaultName>
                          <ZIndex>1</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox200">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVendLedgEnt5RemAmtLCY5.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt5RemAmtLCY5Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox200</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox26">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalVendorName.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
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
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VLEEndingDateRemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!VLEEndingDateRemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox28">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVLE1RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVLE1RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>13</ZIndex>
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
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt2RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVendLedgEnt2RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>12</ZIndex>
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
                        <Textbox Name="textbox30">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt3RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVendLedgEnt3RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>11</ZIndex>
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
                        <Textbox Name="textbox31">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt4RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVendLedgEnt4RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>10</ZIndex>
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
                        <Textbox Name="textbox53">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt5RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVendLedgEnt5RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>9</ZIndex>
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
                        <Textbox Name="textbox54">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalVendorName.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
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
                        <ColSpan>4</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox231">
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
                          <rd:DefaultName>textbox231</rd:DefaultName>
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
                        <Textbox Name="textbox232">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrCode_TempVenLedgEntryLoop.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox63">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!VLEEndingDateRemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!VLEEndingDateRemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox63</rd:DefaultName>
                          <ZIndex>21</ZIndex>
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
                        <Textbox Name="textbox61">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt1RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVendLedgEnt1RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>20</ZIndex>
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
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt2RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVendLedgEnt2RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox64">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt3RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVendLedgEnt3RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>18</ZIndex>
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
                        <Textbox Name="textbox162">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt4RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVendLedgEnt4RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>17</ZIndex>
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
                        <Textbox Name="textbox163">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt5RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVendLedgEnt5RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>16</ZIndex>
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
                        <Textbox Name="textbox164">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!No_Vendor.Value</Value>
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
                          <ZIndex>32</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!VendorName.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>31</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox167">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!VLEEndingDateRemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VLEEndingDateRemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>30</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox168">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVLE1RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVLE1RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>29</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox169">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt2RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt2RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>28</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox170">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt3RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt3RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>27</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox171">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt4RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt4RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>26</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=sum(Fields!AgedVendLedgEnt5RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt5RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>25</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox173">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!No_Vendor.Value</Value>
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
                          <ZIndex>41</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!VendorName.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>40</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="textbox175">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrCode_TempVenLedgEntryLoop.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>39</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=sum(Fields!VLEEndingDateRemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VLEEndingDateRemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>38</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox177">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt1RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt1RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>37</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox178">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt2RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt2RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>36</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=sum(Fields!AgedVendLedgEnt3RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt3RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>35</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox180">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!AgedVendLedgEnt4RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt4RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>34</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=sum(Fields!AgedVendLedgEnt5RemAmt.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt5RemAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>33</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                            <PaddingLeft>2pt</PaddingLeft>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox119</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox120</rd:DefaultName>
                          <ZIndex>50</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox121</rd:DefaultName>
                          <ZIndex>49</ZIndex>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox122</rd:DefaultName>
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
                        <Textbox Name="textbox123">
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
                          <rd:DefaultName>textbox123</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox124</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox125</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox126</rd:DefaultName>
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
                        <Textbox Name="textbox127">
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
                          <rd:DefaultName>textbox127</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox128</rd:DefaultName>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.16654in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox213">
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
                          <rd:DefaultName>textbox213</rd:DefaultName>
                          <ZIndex>65</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox214</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox215</rd:DefaultName>
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
                        <Textbox Name="textbox219">
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
                          <rd:DefaultName>textbox219</rd:DefaultName>
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
                        <Textbox Name="textbox220">
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
                          <rd:DefaultName>textbox220</rd:DefaultName>
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
                        <Textbox Name="textbox221">
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
                          <rd:DefaultName>textbox221</rd:DefaultName>
                          <ZIndex>60</ZIndex>
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
                        <Textbox Name="textbox222">
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
                                    <Format>=Fields!VLEEndingDateRemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox222</rd:DefaultName>
                          <ZIndex>59</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox223</rd:DefaultName>
                          <ZIndex>58</ZIndex>
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
                        <Textbox Name="textbox224">
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
                                    <Format>=First(Fields!GrandTotalVLE2RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox224</rd:DefaultName>
                          <ZIndex>57</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value />
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalVLE3RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox225</rd:DefaultName>
                          <ZIndex>56</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox226">
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
                                    <Format>=First(Fields!GrandTotalVLE4RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox226</rd:DefaultName>
                          <ZIndex>55</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox227">
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
                                    <Format>=First(Fields!GrandTotalVLE5RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox227</rd:DefaultName>
                          <ZIndex>54</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox204">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalLCYCaption.Value)</Value>
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
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox139</rd:DefaultName>
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
                        <Textbox Name="textbox140">
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
                          <rd:DefaultName>textbox140</rd:DefaultName>
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
                        <Textbox Name="textbox141">
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox142">
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
                          <rd:DefaultName>textbox142</rd:DefaultName>
                          <ZIndex>73</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox143</rd:DefaultName>
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
                        <Textbox Name="textbox236">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=sum(Fields!VLEEndingDateRemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!VLEEndingDateRemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>71</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=sum(Fields!AgedVLE1RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!AgedVLE1RemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>70</ZIndex>
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
                        <Textbox Name="textbox245">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVendLedgEnt2RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalVLE2RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>69</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Sum(Fields!AgedVendLedgEnt3RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalVLE3RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>68</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox247">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVendLedgEnt4RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalVLE4RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>67</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox248">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVendLedgEnt5RemAmtLCY.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!GrandTotalVLE5RemAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>66</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox241">
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
                          <rd:DefaultName>textbox241</rd:DefaultName>
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
                        <Textbox Name="textbox205">
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
                          <rd:DefaultName>textbox205</rd:DefaultName>
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
                        <Textbox Name="textbox206">
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
                          <rd:DefaultName>textbox206</rd:DefaultName>
                          <ZIndex>87</ZIndex>
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
                        <Textbox Name="textbox207">
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
                          <rd:DefaultName>textbox207</rd:DefaultName>
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
                        <Textbox Name="textbox208">
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
                          <rd:DefaultName>textbox208</rd:DefaultName>
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
                        <Textbox Name="textbox209">
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
                          <rd:DefaultName>textbox209</rd:DefaultName>
                          <ZIndex>84</ZIndex>
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
                        <Textbox Name="textbox235">
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
                          <rd:DefaultName>textbox235</rd:DefaultName>
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
                        <Textbox Name="textbox250">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVLE1RemAmtLCY.Value),Sum(Fields!VLEEndingDateRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!GrandTotalVLE2RemAmtLCY.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>82</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox251">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt2RemAmtLCY.Value),Sum(Fields!VLEEndingDateRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!GrandTotalVLE2RemAmtLCY.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>81</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox252">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt3RemAmtLCY.Value),Sum(Fields!VLEEndingDateRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!GrandTotalVLE2RemAmtLCY.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>80</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox253">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt4RemAmtLCY.Value),Sum(Fields!VLEEndingDateRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!GrandTotalVLE2RemAmtLCY.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>79</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox254">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt5RemAmtLCY.Value),Sum(Fields!VLEEndingDateRemAmtLCY.Value))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!GrandTotalVLE2RemAmtLCY.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>78</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox103</rd:DefaultName>
                          <ZIndex>101</ZIndex>
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
                        <Textbox Name="textbox133">
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
                          <rd:DefaultName>textbox133</rd:DefaultName>
                          <ZIndex>100</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox134</rd:DefaultName>
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
                        <Textbox Name="textbox147">
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
                          <rd:DefaultName>textbox147</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox148</rd:DefaultName>
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
                        <Textbox Name="textbox149">
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
                          <rd:DefaultName>textbox149</rd:DefaultName>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox150</rd:DefaultName>
                          <ZIndex>95</ZIndex>
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
                        <Textbox Name="textbox151">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox151</rd:DefaultName>
                          <ZIndex>94</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox152</rd:DefaultName>
                          <ZIndex>93</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox194</rd:DefaultName>
                          <ZIndex>92</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox195">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox195</rd:DefaultName>
                          <ZIndex>91</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox196">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox196</rd:DefaultName>
                          <ZIndex>90</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                        <Textbox Name="textbox358">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalLCYCaption.Value,"DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="textbox359">
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
                        <Textbox Name="textbox360">
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
                        <Textbox Name="textbox361">
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
                        <Textbox Name="textbox362">
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox363">
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
                          <ZIndex>108</ZIndex>
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
                        <Textbox Name="textbox364">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!VLEEndingDateRemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>107</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox365">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVLE1RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVLE1RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>106</ZIndex>
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
                        <Textbox Name="textbox366">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVendLedgEnt2RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVendLedgEnt2RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>105</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox367">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVendLedgEnt3RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVendLedgEnt3RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>104</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox9">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVendLedgEnt4RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVendLedgEnt4RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>103</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox10">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!AgedVendLedgEnt5RemAmtLCY.Value, "DataSet_Result")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!AgedVendLedgEnt5RemAmtLCYFormat.Value, "DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>102</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="textbox369">
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
                        <Textbox Name="textbox370">
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="textbox372">
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
                        <Textbox Name="textbox373">
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
                        <Textbox Name="textbox374">
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
                                    <Format>=Fields!VLEEndingDateRemAmtLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>119</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox375">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVLE1RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE4RemAmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>118</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox376">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt2RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE3RemAmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>117</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox377">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt3RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE2RemAmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>116</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox16">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt4RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE1RemAmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>115</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=code.calcPct(Sum(Fields!AgedVendLedgEnt5RemAmtLCY.Value, "DataSet_Result"),Sum(Fields!VLEEndingDateRemAmtLCY.Value, "DataSet_Result"))</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=First(Fields!GrandTotalVLE1AmtLCYFormat.Value,"DataSet_Result")</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>114</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                  <Visibility>
                    <Hidden>=IIF(Fields!PrintDetails.Value,False,True)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF(Fields!PrintDetails.Value,False,True)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF((not First(Fields!PrintDetails.Value))and(First(Fields!PrintAmountInLCY.Value)),False,True)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF((not First(Fields!PrintDetails.Value))and(First(Fields!PrintAmountInLCY.Value)),False,True)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF((not First(Fields!PrintDetails.Value))and(not First(Fields!PrintAmountInLCY.Value)),False,True)</Hidden>
                  </Visibility>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF((not First(Fields!PrintDetails.Value))and(not First(Fields!PrintAmountInLCY.Value)),False,True)</Hidden>
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
                  <Group Name="table3_Group1">
                    <GroupExpressions>
                      <GroupExpression>1</GroupExpression>
                    </GroupExpressions>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <Group Name="table3_Group2">
                        <GroupExpressions>
                          <GroupExpression>=IIF(Fields!NewPagePerVendor.Value,Fields!PageGroupNo.Value,1)</GroupExpression>
                        </GroupExpressions>
                        <PageBreak>
                          <BreakLocation>Between</BreakLocation>
                        </PageBreak>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <Group Name="table3_Group3">
                            <GroupExpressions>
                              <GroupExpression>=Fields!Number_CurrencyTotals.Value</GroupExpression>
                            </GroupExpressions>
                          </Group>
                          <TablixMembers>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF((Fields!Number_CurrencyTotals.Value=1 )and Fields!NewPagePerVend_CurrTotal.Value,False,True)</Hidden>
                              </Visibility>
                              <KeepWithGroup>After</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF((Fields!Number_CurrencyTotals.Value=1 )and Fields!NewPagePerVend_CurrTotal.Value,False,True)</Hidden>
                              </Visibility>
                              <KeepWithGroup>After</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF((Fields!Number_CurrencyTotals.Value=1 )and Fields!NewPagePerVend_CurrTotal.Value,False,True)</Hidden>
                              </Visibility>
                              <KeepWithGroup>After</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Group Name="table3_Group4">
                                <GroupExpressions>
                                  <GroupExpression>=Fields!VendorNo.Value</GroupExpression>
                                  <GroupExpression>=Fields!CurrCode_TempVenLedgEntryLoop.Value</GroupExpression>
                                </GroupExpressions>
                              </Group>
                              <TablixMembers>
                                <TablixMember>
                                  <Visibility>
                                    <Hidden>=IIF((Fields!PrintDetails.Value)and(Fields!VendorName.Value&lt;&gt;""),False,True)</Hidden>
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
                                        <Hidden>=IIF(Fields!PrintAmountInLCY.Value and Fields!PrintDetails.Value,False,True)</Hidden>
                                      </Visibility>
                                    </TablixMember>
                                    <TablixMember>
                                      <Visibility>
                                        <Hidden>=IIF((not Fields!PrintAmountInLCY.Value) and Fields!PrintDetails.Value,False,True)</Hidden>
                                      </Visibility>
                                    </TablixMember>
                                    <TablixMember>
                                      <Visibility>
                                        <Hidden>=IIF(Fields!TempCurrency2Code.Value&lt;&gt;"",False,True)</Hidden>
                                      </Visibility>
                                    </TablixMember>
                                  </TablixMembers>
                                  <DataElementName>Detail_Collection</DataElementName>
                                  <DataElementOutput>Output</DataElementOutput>
                                  <KeepTogether>true</KeepTogether>
                                </TablixMember>
                                <TablixMember>
                                  <Visibility>
                                    <Hidden>=IIF(Fields!PrintAmountInLCY.Value and Fields!PrintDetails.Value,False,True)</Hidden>
                                  </Visibility>
                                  <KeepWithGroup>Before</KeepWithGroup>
                                  <KeepTogether>true</KeepTogether>
                                </TablixMember>
                                <TablixMember>
                                  <Visibility>
                                    <Hidden>=IIF((not Fields!PrintAmountInLCY.Value) and Fields!PrintDetails.Value,False,True)</Hidden>
                                  </Visibility>
                                  <KeepWithGroup>Before</KeepWithGroup>
                                  <KeepTogether>true</KeepTogether>
                                </TablixMember>
                                <TablixMember>
                                  <Visibility>
                                    <Hidden>=IIF((not Fields!PrintDetails.Value)and(Fields!PrintAmountInLCY.Value)and(Fields!VendorName.Value&lt;&gt;""),False,True)</Hidden>
                                  </Visibility>
                                  <KeepWithGroup>Before</KeepWithGroup>
                                  <KeepTogether>true</KeepTogether>
                                </TablixMember>
                                <TablixMember>
                                  <Visibility>
                                    <Hidden>=IIF(((not Fields!PrintDetails.Value)and(not Fields!PrintAmountInLCY.Value))
and(Fields!TempCurrency2Code.Value="")
and(not Fields!VendorNo.Value=""),False,True)</Hidden>
                                  </Visibility>
                                  <KeepWithGroup>Before</KeepWithGroup>
                                  <KeepTogether>true</KeepTogether>
                                </TablixMember>
                                <TablixMember>
                                  <Visibility>
                                    <Hidden>=IIF(Fields!PrintDetails.Value,False,True)</Hidden>
                                  </Visibility>
                                  <KeepWithGroup>Before</KeepWithGroup>
                                  <KeepTogether>true</KeepTogether>
                                </TablixMember>
                              </TablixMembers>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF((Fields!PrintDetails.Value)or(Fields!TempCurrency2Code.Value&lt;&gt;""),True,False)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF((not Fields!NewPagePerVendor.Value)and( Fields!Number_CurrencyTotals.Value&lt;1),False,True)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF((not Fields!NewPagePerVendor.Value)and( Fields!Number_CurrencyTotals.Value&lt;1),False,True)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF(Fields!TempCurrency2Code.Value="",False,True)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                          </TablixMembers>
                        </TablixMember>
                      </TablixMembers>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF((Fields!NewPagePerVendor.Value) and (Fields!PrintAmountInLCY.Value),False,True)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF((Fields!NewPagePerVendor.Value) and (Fields!PrintAmountInLCY.Value),False,True)</Hidden>
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
                <FilterExpression>=Fields!VendLedgEntryEndDtDocNo.Value</FilterExpression>
                <Operator>GreaterThanOrEqual</Operator>
                <FilterValues>
                  <FilterValue>''</FilterValue>
                </FilterValues>
              </Filter>
            </Filters>
            <Top>2.22222cm</Top>
            <Height>4.64658in</Height>
            <Width>18.17029cm</Width>
            <Style />
          </Tablix>
          <Textbox Name="textbox440">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!CaptionVendorFilter.Value)</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Top>1.269cm</Top>
            <Height>0.423cm</Height>
            <Width>18.15cm</Width>
            <ZIndex>1</ZIndex>
            <Visibility>
              <Hidden>=IIF(Fields!VendorFilter.Value="",True,False)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="textbox439">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!AllAmtsinLCYCaption.Value)</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Top>0.846cm</Top>
            <Height>0.423cm</Height>
            <Width>9.20635cm</Width>
            <ZIndex>2</ZIndex>
            <Visibility>
              <Hidden>=IIF(First(Fields!PrintAmountInLCY.Value),False,True)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="textbox438">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!SelectAgeByDuePostngDocDt.Value)</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Top>0.423cm</Top>
            <Height>0.423cm</Height>
            <Width>9.20635cm</Width>
            <ZIndex>3</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="textbox437">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!AgesAsOfEndingDate.Value)</Value>
                    <Style>
                      <FontSize>7pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Height>0.423cm</Height>
            <Width>9.20635cm</Width>
            <ZIndex>4</ZIndex>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Tablix Name="table2">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>2.12474in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.87489in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.70866in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.16654in</Height>
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
                                  <Value>=first(Fields!CurrencySpecificationCaption.Value, "table2")</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>83</ZIndex>
                          <Visibility>
                            <Hidden>=iif(Fields!Number_CurrencyTotals.Value = 1,false,true)</Hidden>
                          </Visibility>
                          <DataElementOutput>NoOutput</DataElementOutput>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!TempCurrency2Code.Value</Value>
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
                          <ZIndex>82</ZIndex>
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
                        <Textbox Name="textbox19">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVendLedgEnt6RemAmtLCY5.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt6RemAmtLCY5Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>81</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                                  <Value>=Fields!AgedVendLedgEnt1RemAmtLCY1.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt1RemAmtLCY1Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>80</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!AgedVendLedgEnt2RemAmtLCY2.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt2RemAmtLCY2Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>79</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox22">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AgedVendLedgEnt3RemAmtLCY3.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt3RemAmtLCY3Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>78</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!AgedVendLedgEnt4RemAmtLCY4.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt4RemAmtLCY4Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>77</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!AgedVendLedgEnt5RemAmtLCY5.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!AgedVendLedgEnt5RemAmtLCY5Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>76</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
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
                <FilterExpression>=String.IsNullOrEmpty(Fields!CurrencySpecificationCaption.Value)</FilterExpression>
                <Operator>Equal</Operator>
                <FilterValues>
                  <FilterValue>=false</FilterValue>
                </FilterValues>
              </Filter>
            </Filters>
            <Top>14.92063cm</Top>
            <Height>0.42301cm</Height>
            <Width>18.41904cm</Width>
            <ZIndex>5</ZIndex>
            <Visibility>
              <Hidden>=iif(Fields!Number_CurrencyTotals.Value = 0,true,false)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <Border>
                <Style>None</Style>
              </Border>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>15.34364cm</Height>
        <Style />
      </Body>
      <Width>18.47024cm</Width>
      <Page>
        <PageHeader>
          <Height>1.692cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="CurrReportPageNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!CurrReportPageNoCaption.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>16.95cm</Left>
              <Height>0.423cm</Height>
              <Width>0.75cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="AgedAccountsPayableCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!AgedAcctPayableCaption.Value</Value>
                      <Style>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyName">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!CompanyName.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
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
            <Textbox Name="ExecutionTimeTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!TodayFormatted.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                        <Format>D</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>12.06349cm</Left>
              <Height>0.423cm</Height>
              <Width>6.08651cm</Width>
              <ZIndex>3</ZIndex>
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

Shared Pct as Decimal
Shared Str as string
Public Function CalcPct(Amount1 as Decimal, Amount2 as Decimal) as String
    if Amount2 &lt;&gt; 0 then
       Pct = Amount1 / Amount2 * 100
    else
       Pct = 0
    end if
   Pct = ROUND(10*Pct)/10
   Str = Pct
   return Str+"%"
End Function

Shared LenL
Public Function CalcLeft(Str1 as String, Str2 as String) as String
  if InStr(Str1,Str2) &gt;0 then
    LenL = Left(Str1,InStr(Str1,Str2)-1)
  else
    LenL = ""
  end if
  return LenL
End Function

Shared LenR
Public Function CalcRight(Str1 as String, Str2 as String) as String
  if InStr(Str1,Str2) &gt;0 then
    LenR = Right(Str1,Len(Str1) - InStr(Str1,Str2))
  else
    LenR = Str1
  end if
  return LenR
End Function</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Cm</rd:ReportUnitType>
  <rd:ReportID>579e7511-4a8c-4b64-b9f0-93fb21beb5da</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

