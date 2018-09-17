OBJECT Report 1316 Standard Statement
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Standardkontoudtog;
               ENU=Standard Statement];
    OnInitReport=BEGIN
                   GLSetup.GET;
                   SalesSetup.GET;

                   CASE SalesSetup."Logo Position on Documents" OF
                     SalesSetup."Logo Position on Documents"::"No Logo":
                       ;
                     SalesSetup."Logo Position on Documents"::Left:
                       BEGIN
                         CompanyInfo1.GET;
                         CompanyInfo1.CALCFIELDS(Picture);
                       END;
                     SalesSetup."Logo Position on Documents"::Center:
                       BEGIN
                         CompanyInfo2.GET;
                         CompanyInfo2.CALCFIELDS(Picture);
                       END;
                     SalesSetup."Logo Position on Documents"::Right:
                       BEGIN
                         CompanyInfo3.GET;
                         CompanyInfo3.CALCFIELDS(Picture);
                       END;
                   END;

                   LogInteractionEnable := TRUE;
                 END;

    OnPreReport=BEGIN
                  InitRequestPageDataInternal;
                END;

    DefaultLayout=Word;
  }
  DATASET
  {
    { 6836;    ;DataItem;                    ;
               DataItemTable=Table18;
               DataItemTableView=SORTING(No.);
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               VerifyDates;
                               AgingBandEndingDate := EndDate;
                               CalcAgingBandDates;

                               CompanyInfo.GET;
                               FormatAddr.Company(CompanyAddr,CompanyInfo);
                               CompanyInfo.CALCFIELDS(Picture);

                               TempCurrency2.Code := '';
                               TempCurrency2.INSERT;
                               COPYFILTER("Currency Filter",Currency.Code);
                               IF Currency.FIND('-') THEN
                                 REPEAT
                                   TempCurrency2 := Currency;
                                   TempCurrency2.INSERT;
                                 UNTIL Currency.NEXT = 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  TempAgingBandBuf.DELETEALL;
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                                  PrintLine := FALSE;
                                  Cust2 := Customer;
                                  COPYFILTER("Currency Filter",TempCurrency2.Code);
                                  IF PrintAllHavingBal THEN BEGIN
                                    IF TempCurrency2.FIND('-') THEN
                                      REPEAT
                                        Cust2.SETRANGE("Date Filter",0D,EndDate);
                                        Cust2.SETRANGE("Currency Filter",TempCurrency2.Code);
                                        Cust2.CALCFIELDS("Net Change");
                                        PrintLine := Cust2."Net Change" <> 0;
                                      UNTIL (TempCurrency2.NEXT = 0) OR PrintLine;
                                  END;
                                  IF (NOT PrintLine) AND PrintAllHavingEntry THEN BEGIN
                                    CustLedgerEntry.RESET;
                                    CustLedgerEntry.SETCURRENTKEY("Customer No.","Posting Date");
                                    CustLedgerEntry.SETRANGE("Customer No.","No.");
                                    CustLedgerEntry.SETRANGE("Posting Date",StartDate,EndDate);
                                    COPYFILTER("Currency Filter",CustLedgerEntry."Currency Code");
                                    PrintLine := NOT CustLedgerEntry.ISEMPTY;
                                  END;
                                  IF NOT PrintLine THEN
                                    CurrReport.SKIP;

                                  FormatAddr.Customer(CustAddr,Customer);
                                  CurrReport.PAGENO := 1;

                                  IF NOT IsReportInPreviewMode THEN BEGIN
                                    LOCKTABLE;
                                    FIND;
                                    "Last Statement No." := "Last Statement No." + 1;
                                    MODIFY;
                                    COMMIT;
                                  END ELSE
                                    "Last Statement No." := "Last Statement No." + 1;

                                  IF LogInteraction THEN
                                    IF NOT IsReportInPreviewMode THEN
                                      SegManagement.LogDocument(
                                        7,FORMAT("Last Statement No."),0,0,DATABASE::Customer,"No.","Salesperson Code",'',
                                        StatementLbl + FORMAT("Last Statement No."),'');
                                  IsFirstLoop := FALSE;
                                END;

               ReqFilterFields=No.,Search Name,Print Statements,Currency Filter }

    { 108 ;1   ;Column  ;No_Cust             ;
               SourceExpr="No." }

    { 5444;1   ;DataItem;Integer             ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               PrintOnlyIfDetail=Yes }

    { 63  ;2   ;Column  ;CompanyPicture      ;
               SourceExpr=CompanyInfo.Picture }

    { 52  ;2   ;Column  ;CompanyInfo1Picture ;
               SourceExpr=CompanyInfo1.Picture }

    { 61  ;2   ;Column  ;CompanyInfo2Picture ;
               SourceExpr=CompanyInfo2.Picture }

    { 103 ;2   ;Column  ;CompanyInfo3Picture ;
               SourceExpr=CompanyInfo3.Picture }

    { 4   ;2   ;Column  ;CustAddr1           ;
               SourceExpr=CustAddr[1] }

    { 5   ;2   ;Column  ;CompanyAddr1        ;
               SourceExpr=CompanyAddr[1] }

    { 6   ;2   ;Column  ;CustAddr2           ;
               SourceExpr=CustAddr[2] }

    { 7   ;2   ;Column  ;CompanyAddr2        ;
               SourceExpr=CompanyAddr[2] }

    { 8   ;2   ;Column  ;CustAddr3           ;
               SourceExpr=CustAddr[3] }

    { 9   ;2   ;Column  ;CompanyAddr3        ;
               SourceExpr=CompanyAddr[3] }

    { 10  ;2   ;Column  ;CustAddr4           ;
               SourceExpr=CustAddr[4] }

    { 11  ;2   ;Column  ;CompanyAddr4        ;
               SourceExpr=CompanyAddr[4] }

    { 12  ;2   ;Column  ;CustAddr5           ;
               SourceExpr=CustAddr[5] }

    { 105 ;2   ;Column  ;CompanyAddr5        ;
               SourceExpr=CompanyAddr[5] }

    { 14  ;2   ;Column  ;PhoneNo_CompanyInfo ;
               SourceExpr=CompanyInfo."Phone No." }

    { 15  ;2   ;Column  ;CustAddr6           ;
               SourceExpr=CustAddr[6] }

    { 119 ;2   ;Column  ;CompanyAddr6        ;
               SourceExpr=CompanyAddr[6] }

    { 75  ;2   ;Column  ;CompanyInfoEmail    ;
               SourceExpr=CompanyInfo."E-Mail" }

    { 17  ;2   ;Column  ;CompanyInfoHomePage ;
               SourceExpr=CompanyInfo."Home Page" }

    { 19  ;2   ;Column  ;VATRegNo_CompanyInfo;
               SourceExpr=CompanyInfo."VAT Registration No." }

    { 21  ;2   ;Column  ;GiroNo_CompanyInfo  ;
               SourceExpr=CompanyInfo."Giro No." }

    { 23  ;2   ;Column  ;BankName_CompanyInfo;
               SourceExpr=CompanyInfo."Bank Name" }

    { 25  ;2   ;Column  ;BankAccNo_CompanyInfo;
               SourceExpr=CompanyInfo."Bank Account No." }

    { 27  ;2   ;Column  ;No1_Cust            ;
               SourceExpr=Customer."No." }

    { 28  ;2   ;Column  ;TodayFormatted      ;
               SourceExpr=FORMAT(TODAY) }

    { 30  ;2   ;Column  ;StartDate           ;
               SourceExpr=FORMAT(StartDate) }

    { 32  ;2   ;Column  ;EndDate             ;
               SourceExpr=FORMAT(EndDate) }

    { 34  ;2   ;Column  ;LastStatmntNo_Cust  ;
               DecimalPlaces=0:0;
               SourceExpr=FORMAT(Customer."Last Statement No.") }

    { 3   ;2   ;Column  ;CustAddr7           ;
               SourceExpr=CustAddr[7] }

    { 67  ;2   ;Column  ;CustAddr8           ;
               SourceExpr=CustAddr[8] }

    { 68  ;2   ;Column  ;CompanyAddr7        ;
               SourceExpr=CompanyAddr[7] }

    { 69  ;2   ;Column  ;CompanyAddr8        ;
               SourceExpr=CompanyAddr[8] }

    { 1   ;2   ;Column  ;StatementCaption    ;
               SourceExpr=StatementCaptionLbl }

    { 13  ;2   ;Column  ;PhoneNo_CompanyInfoCaption;
               SourceExpr=PhoneNo_CompanyInfoCaptionLbl }

    { 18  ;2   ;Column  ;VATRegNo_CompanyInfoCaption;
               SourceExpr=VATRegNo_CompanyInfoCaptionLbl }

    { 20  ;2   ;Column  ;GiroNo_CompanyInfoCaption;
               SourceExpr=GiroNo_CompanyInfoCaptionLbl }

    { 22  ;2   ;Column  ;BankName_CompanyInfoCaption;
               SourceExpr=BankName_CompanyInfoCaptionLbl }

    { 24  ;2   ;Column  ;BankAccNo_CompanyInfoCaption;
               SourceExpr=BankAccNo_CompanyInfoCaptionLbl }

    { 26  ;2   ;Column  ;No1_CustCaption     ;
               SourceExpr=No1_CustCaptionLbl }

    { 29  ;2   ;Column  ;StartDateCaption    ;
               SourceExpr=StartDateCaptionLbl }

    { 31  ;2   ;Column  ;EndDateCaption      ;
               SourceExpr=EndDateCaptionLbl }

    { 33  ;2   ;Column  ;LastStatmntNo_CustCaption;
               SourceExpr=LastStatmntNo_CustCaptionLbl }

    { 35  ;2   ;Column  ;PostDate_DtldCustLedgEntriesCaption;
               SourceExpr=PostDate_DtldCustLedgEntriesCaptionLbl }

    { 36  ;2   ;Column  ;DocNo_DtldCustLedgEntriesCaption;
               SourceExpr=DtldCustLedgEntries.FIELDCAPTION("Document No.") }

    { 37  ;2   ;Column  ;Desc_CustLedgEntry2Caption;
               SourceExpr=CustLedgEntry2.FIELDCAPTION(Description) }

    { 38  ;2   ;Column  ;DueDate_CustLedgEntry2Caption;
               SourceExpr=DueDate_CustLedgEntry2CaptionLbl }

    { 39  ;2   ;Column  ;RemainAmtCustLedgEntry2Caption;
               SourceExpr=CustLedgEntry2.FIELDCAPTION("Remaining Amount") }

    { 40  ;2   ;Column  ;CustBalanceCaption  ;
               SourceExpr=CustBalanceCaptionLbl }

    { 72  ;2   ;Column  ;OriginalAmt_CustLedgEntry2Caption;
               SourceExpr=CustLedgEntry2.FIELDCAPTION("Original Amount") }

    { 64  ;2   ;Column  ;CompanyInfoHomepageCaption;
               SourceExpr=CompanyInfoHomepageCaptionLbl }

    { 65  ;2   ;Column  ;CompanyInfoEmailCaption;
               SourceExpr=CompanyInfoEmailCaptionLbl }

    { 66  ;2   ;Column  ;DocDateCaption      ;
               SourceExpr=DocDateCaptionLbl }

    { 42  ;2   ;Column  ;CurrReportPageNoCaption;
               SourceExpr=CurrReportPageNoCaptionLbl }

    { 171 ;2   ;Column  ;CompanyLegalOffice  ;
               SourceExpr=CompanyInfo.GetLegalOffice }

    { 172 ;2   ;Column  ;CompanyLegalOffice_Lbl;
               SourceExpr=CompanyInfo.GetLegalOfficeLbl }

    { 6523;2   ;DataItem;CurrencyLoop        ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               Customer.COPYFILTER("Currency Filter",TempCurrency2.Code);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    TempCurrency2.FINDFIRST;

                                  REPEAT
                                    IF NOT IsFirstLoop THEN
                                      IsFirstLoop := TRUE
                                    ELSE
                                      IF TempCurrency2.NEXT = 0 THEN
                                        CurrReport.BREAK;
                                    CustLedgerEntry.SETCURRENTKEY("Customer No.","Posting Date","Currency Code");
                                    CustLedgerEntry.SETRANGE("Customer No.",Customer."No.");
                                    CustLedgerEntry.SETRANGE("Posting Date",0D,EndDate);
                                    CustLedgerEntry.SETRANGE("Currency Code",TempCurrency2.Code);
                                    EntriesExists := NOT CustLedgerEntry.ISEMPTY;
                                  UNTIL EntriesExists;
                                  Cust2 := Customer;
                                  Cust2.SETRANGE("Date Filter",0D,StartDate - 1);
                                  Cust2.SETRANGE("Currency Filter",TempCurrency2.Code);
                                  Cust2.CALCFIELDS("Net Change");
                                  StartBalance := Cust2."Net Change";
                                  CustBalance := Cust2."Net Change";
                                  CustBalance2 := 0;
                                END;
                                 }

    { 115 ;3   ;Column  ;Total_Caption2      ;
               SourceExpr=Total_CaptionLbl }

    { 4414;3   ;DataItem;CustLedgEntryHdr    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 41  ;4   ;Column  ;Currency2Code_CustLedgEntryHdr;
               SourceExpr=STRSUBSTNO(EntriesLbl,CurrencyCode3) }

    { 77  ;4   ;Column  ;StartBalance        ;
               SourceExpr=StartBalance;
               AutoFormatType=1;
               AutoFormatExpr=TempCurrency2.Code }

    { 93  ;4   ;Column  ;CurrencyCode3       ;
               SourceExpr=CurrencyCode3 }

    { 94  ;4   ;Column  ;CustBalance_CustLedgEntryHdr;
               SourceExpr=CustBalance }

    { 95  ;4   ;Column  ;PrintLine           ;
               SourceExpr=PrintLine }

    { 96  ;4   ;Column  ;DtldCustLedgEntryType;
               SourceExpr=FORMAT(DtldCustLedgEntries."Entry Type",0,2) }

    { 97  ;4   ;Column  ;EntriesExists       ;
               SourceExpr=EntriesExists }

    { 102 ;4   ;Column  ;IsNewCustCurrencyGroup;
               SourceExpr=IsNewCustCurrencyGroup }

    { 9366;4   ;DataItem;DtldCustLedgEntries ;
               DataItemTable=Table379;
               DataItemTableView=SORTING(Customer No.,Posting Date,Entry Type,Currency Code);
               OnPreDataItem=BEGIN
                               SETRANGE("Customer No.",Customer."No.");
                               SETRANGE("Posting Date",StartDate,EndDate);
                               SETRANGE("Currency Code",TempCurrency2.Code);

                               IF TempCurrency2.Code = '' THEN BEGIN
                                 GLSetup.TESTFIELD("LCY Code");
                                 CurrencyCode3 := GLSetup."LCY Code"
                               END ELSE
                                 CurrencyCode3 := TempCurrency2.Code;

                               IsFirstPrintLine := TRUE;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF SkipReversedUnapplied(DtldCustLedgEntries) OR (Amount = 0) THEN
                                    CurrReport.SKIP;
                                  RemainingAmount := 0;
                                  PrintLine := TRUE;
                                  CASE "Entry Type" OF
                                    "Entry Type"::"Initial Entry":
                                      BEGIN
                                        CustLedgerEntry.GET("Cust. Ledger Entry No.");
                                        Description := CustLedgerEntry.Description;
                                        DueDate := CustLedgerEntry."Due Date";
                                        CustLedgerEntry.SETRANGE("Date Filter",0D,EndDate);
                                        CustLedgerEntry.CALCFIELDS("Remaining Amount");
                                        RemainingAmount := CustLedgerEntry."Remaining Amount";
                                        CustLedgerEntry.SETRANGE("Date Filter");
                                      END;
                                    "Entry Type"::Application:
                                      BEGIN
                                        DetailedCustLedgEntry2.SETCURRENTKEY("Customer No.","Posting Date","Entry Type");
                                        DetailedCustLedgEntry2.SETRANGE("Customer No.","Customer No.");
                                        DetailedCustLedgEntry2.SETRANGE("Posting Date","Posting Date");
                                        DetailedCustLedgEntry2.SETRANGE("Entry Type","Entry Type"::Application);
                                        DetailedCustLedgEntry2.SETRANGE("Transaction No.","Transaction No.");
                                        DetailedCustLedgEntry2.SETFILTER("Currency Code",'<>%1',"Currency Code");
                                        IF NOT DetailedCustLedgEntry2.ISEMPTY THEN BEGIN
                                          Description := MulticurrencyAppLbl;
                                          DueDate := 0D;
                                        END ELSE
                                          CurrReport.SKIP;
                                      END;
                                    "Entry Type"::"Payment Discount",
                                    "Entry Type"::"Payment Discount (VAT Excl.)",
                                    "Entry Type"::"Payment Discount (VAT Adjustment)",
                                    "Entry Type"::"Payment Discount Tolerance",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                                      BEGIN
                                        Description := PaymentDiscountLbl;
                                        DueDate := 0D;
                                      END;
                                    "Entry Type"::"Payment Tolerance",
                                    "Entry Type"::"Payment Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Tolerance (VAT Adjustment)":
                                      BEGIN
                                        Description := WriteoffsLbl;
                                        DueDate := 0D;
                                      END;
                                    "Entry Type"::"Appln. Rounding",
                                    "Entry Type"::"Correction of Remaining Amount":
                                      BEGIN
                                        Description := RoundingLbl;
                                        DueDate := 0D;
                                      END;
                                  END;

                                  CustBalance := CustBalance + Amount;
                                  IsNewCustCurrencyGroup := IsFirstPrintLine;
                                  IsFirstPrintLine := FALSE;
                                END;
                                 }

    { 44  ;5   ;Column  ;PostDate_DtldCustLedgEntries;
               SourceExpr=FORMAT("Posting Date") }

    { 45  ;5   ;Column  ;DocNo_DtldCustLedgEntries;
               SourceExpr="Document No." }

    { 46  ;5   ;Column  ;Description         ;
               SourceExpr=Description }

    { 47  ;5   ;Column  ;DueDate_DtldCustLedgEntries;
               SourceExpr=FORMAT(DueDate) }

    { 78  ;5   ;Column  ;CurrCode_DtldCustLedgEntries;
               SourceExpr="Currency Code" }

    { 54  ;5   ;Column  ;Amt_DtldCustLedgEntries;
               SourceExpr=Amount;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 48  ;5   ;Column  ;RemainAmt_DtldCustLedgEntries;
               SourceExpr=RemainingAmount;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 49  ;5   ;Column  ;CustBalance         ;
               SourceExpr=CustBalance;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 1102601000;5;Column;Currency2Code      ;
               SourceExpr=TempCurrency2.Code }

    { 7720;3   ;DataItem;CustLedgEntryFooter ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 51  ;4   ;Column  ;CurrencyCode3_CustLedgEntryFooter;
               SourceExpr=CurrencyCode3 }

    { 2   ;4   ;Column  ;Total_Caption       ;
               SourceExpr=Total_CaptionLbl }

    { 71  ;4   ;Column  ;CustBalance_CustLedgEntryHdrFooter;
               SourceExpr=CustBalance;
               AutoFormatType=1;
               AutoFormatExpr=TempCurrency2.Code }

    { 98  ;4   ;Column  ;EntriesExistsl_CustLedgEntryFooterCaption;
               SourceExpr=EntriesExists }

    { 107 ;3   ;DataItem;OverdueVisible      ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF NOT PrintEntriesDue THEN
                                 CurrReport.BREAK;
                             END;
                              }

    { 16  ;4   ;Column  ;Total_Caption3      ;
               SourceExpr=Total_CaptionLbl }

    { 114 ;4   ;Column  ;PostDate_DtldCustLedgEntriesCaption2;
               SourceExpr=PostDate_DtldCustLedgEntriesCaptionLbl }

    { 113 ;4   ;Column  ;DocNo_DtldCustLedgEntriesCaption2;
               SourceExpr=DtldCustLedgEntries.FIELDCAPTION("Document No.") }

    { 112 ;4   ;Column  ;Desc_CustLedgEntry2Caption2;
               SourceExpr=CustLedgEntry2.FIELDCAPTION(Description) }

    { 111 ;4   ;Column  ;DueDate_CustLedgEntry2Caption2;
               SourceExpr=DueDate_CustLedgEntry2CaptionLbl }

    { 110 ;4   ;Column  ;RemainAmtCustLedgEntry2Caption2;
               SourceExpr=CustLedgEntry2.FIELDCAPTION("Remaining Amount") }

    { 109 ;4   ;Column  ;OriginalAmt_CustLedgEntry2Caption2;
               SourceExpr=CustLedgEntry2.FIELDCAPTION("Original Amount") }

    { 9065;4   ;DataItem;CustLedgEntry2      ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.,Open,Positive,Due Date);
               OnPreDataItem=BEGIN
                               CurrReport.CREATETOTALS("Remaining Amount");
                               IF NOT IncludeAgingBand THEN
                                 SETRANGE("Due Date",0D,EndDate - 1);
                               SETRANGE("Currency Code",TempCurrency2.Code);
                               IF (NOT PrintEntriesDue) AND (NOT IncludeAgingBand) THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=VAR
                                  CustLedgEntry@1000 : Record 21;
                                BEGIN
                                  IF IncludeAgingBand THEN
                                    IF ("Posting Date" > EndDate) AND ("Due Date" >= EndDate) THEN
                                      CurrReport.SKIP;
                                  CustLedgEntry := CustLedgEntry2;
                                  CustLedgEntry.SETRANGE("Date Filter",0D,EndDate);
                                  CustLedgEntry.CALCFIELDS("Remaining Amount");
                                  "Remaining Amount" := CustLedgEntry."Remaining Amount";
                                  IF CustLedgEntry."Remaining Amount" = 0 THEN
                                    CurrReport.SKIP;

                                  IF "Due Date" >= EndDate THEN
                                    CurrReport.SKIP;

                                  CustBalance2 := CustBalance2 + CustLedgEntry."Remaining Amount";
                                END;

               DataItemLinkReference=Customer;
               DataItemLink=Customer No.=FIELD(No.) }

    { 76  ;5   ;Column  ;OverDueEntries      ;
               SourceExpr=STRSUBSTNO(OverdueEntriesLbl,TempCurrency2.Code) }

    { 56  ;5   ;Column  ;RemainAmt_CustLedgEntry2;
               SourceExpr="Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 57  ;5   ;Column  ;PostDate_CustLedgEntry2;
               SourceExpr=FORMAT("Posting Date") }

    { 58  ;5   ;Column  ;DocNo_CustLedgEntry2;
               SourceExpr="Document No." }

    { 59  ;5   ;Column  ;Desc_CustLedgEntry2 ;
               SourceExpr=Description }

    { 60  ;5   ;Column  ;DueDate_CustLedgEntry2;
               SourceExpr=FORMAT("Due Date") }

    { 70  ;5   ;Column  ;OriginalAmt_CustLedgEntry2;
               SourceExpr="Original Amount";
               AutoFormatExpr="Currency Code" }

    { 74  ;5   ;Column  ;CurrCode_CustLedgEntry2;
               SourceExpr="Currency Code" }

    { 99  ;5   ;Column  ;PrintEntriesDue     ;
               SourceExpr=PrintEntriesDue }

    { 100 ;5   ;Column  ;Currency2Code_CustLedgEntry2;
               SourceExpr=TempCurrency2.Code }

    { 73  ;5   ;Column  ;CurrencyCode3_CustLedgEntry2;
               SourceExpr=CurrencyCode3 }

    { 8460;5   ;Column  ;CustNo_CustLedgEntry2;
               SourceExpr="Customer No." }

    { 117 ;4   ;DataItem;OverdueEntryFooder  ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 118 ;5   ;Column  ;OverdueBalance      ;
               SourceExpr=CustBalance2 }

    { 106 ;2   ;DataItem;AgingBandVisible    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnPreDataItem=BEGIN
                               IF NOT IncludeAgingBand THEN
                                 CurrReport.BREAK
                             END;
                              }

    { 116 ;3   ;DataItem;AgingCustLedgEntry  ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.,Open,Positive,Due Date);
               OnPreDataItem=BEGIN
                               Customer.COPYFILTER("Currency Filter","Currency Code");
                               SETCURRENTKEY("Customer No.","Posting Date","Currency Code");
                               SETRANGE("Customer No.",Customer."No.");
                               SETRANGE("Posting Date",0D,EndDate);
                             END;

               OnAfterGetRecord=VAR
                                  CustLedgEntry@1000 : Record 21;
                                BEGIN
                                  IF ("Posting Date" > EndDate) AND ("Due Date" >= EndDate) THEN
                                    CurrReport.SKIP;
                                  IF DateChoice = DateChoice::"Due Date" THEN
                                    IF "Due Date" >= EndDate THEN
                                      CurrReport.SKIP;
                                  CustLedgEntry := AgingCustLedgEntry;
                                  CustLedgEntry.SETRANGE("Date Filter",0D,EndDate);
                                  CustLedgEntry.CALCFIELDS("Remaining Amount");
                                  "Remaining Amount" := CustLedgEntry."Remaining Amount";
                                  IF CustLedgEntry."Remaining Amount" = 0 THEN
                                    CurrReport.SKIP;

                                  IF "Posting Date" <= EndDate THEN
                                    UpdateBuffer("Currency Code",GetDate("Posting Date","Due Date"),"Remaining Amount");
                                END;

               DataItemLinkReference=Customer;
               DataItemLink=Customer No.=FIELD(No.) }

    { 1154;3   ;DataItem;AgingBandLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    IF NOT TempAgingBandBuf.FIND('-') THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF TempAgingBandBuf.NEXT = 0 THEN
                                      CurrReport.BREAK;
                                  AgingBandCurrencyCode := TempAgingBandBuf."Currency Code";
                                  IF AgingBandCurrencyCode = '' THEN
                                    AgingBandCurrencyCode := GLSetup."LCY Code";
                                END;
                                 }

    { 81  ;4   ;Column  ;AgingDate1          ;
               SourceExpr=FORMAT(AgingDate[1] + 1) }

    { 82  ;4   ;Column  ;AgingDate2          ;
               SourceExpr=FORMAT(AgingDate[2]) }

    { 83  ;4   ;Column  ;AgingDate21         ;
               SourceExpr=FORMAT(AgingDate[2] + 1) }

    { 84  ;4   ;Column  ;AgingDate3          ;
               SourceExpr=FORMAT(AgingDate[3]) }

    { 89  ;4   ;Column  ;AgingDate31         ;
               SourceExpr=FORMAT(AgingDate[3] + 1) }

    { 90  ;4   ;Column  ;AgingDate4          ;
               SourceExpr=FORMAT(AgingDate[4]) }

    { 53  ;4   ;Column  ;AgingBandEndingDate ;
               SourceExpr=STRSUBSTNO(AgedSummaryLbl,AgingBandEndingDate,PeriodLength,SELECTSTR(DateChoice + 1,DuePostingDateLbl)) }

    { 91  ;4   ;Column  ;AgingDate41         ;
               SourceExpr=FORMAT(AgingDate[4] + 1) }

    { 92  ;4   ;Column  ;AgingDate5          ;
               SourceExpr=FORMAT(AgingDate[5]) }

    { 79  ;4   ;Column  ;AgingBandBufCol1Amt ;
               SourceExpr=TempAgingBandBuf."Column 1 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=TempAgingBandBuf."Currency Code" }

    { 85  ;4   ;Column  ;AgingBandBufCol2Amt ;
               SourceExpr=TempAgingBandBuf."Column 2 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=TempAgingBandBuf."Currency Code" }

    { 86  ;4   ;Column  ;AgingBandBufCol3Amt ;
               SourceExpr=TempAgingBandBuf."Column 3 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=TempAgingBandBuf."Currency Code" }

    { 87  ;4   ;Column  ;AgingBandBufCol4Amt ;
               SourceExpr=TempAgingBandBuf."Column 4 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=TempAgingBandBuf."Currency Code" }

    { 88  ;4   ;Column  ;AgingBandBufCol5Amt ;
               SourceExpr=TempAgingBandBuf."Column 5 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=TempAgingBandBuf."Currency Code" }

    { 80  ;4   ;Column  ;AgingBandCurrencyCode;
               SourceExpr=AgingBandCurrencyCode }

    { 62  ;4   ;Column  ;beforeCaption       ;
               SourceExpr=beforeCaptionLbl }

    { 43  ;4   ;Column  ;AgingDateHeader1    ;
               SourceExpr=AgingDateHeader1 }

    { 50  ;4   ;Column  ;AgingDateHeader2    ;
               SourceExpr=AgingDateHeader2 }

    { 55  ;4   ;Column  ;AgingDateHeader3    ;
               SourceExpr=AgingDateHeader3 }

    { 101 ;4   ;Column  ;AgingDateHeader4    ;
               SourceExpr=AgingDateHeader4 }

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
      OnOpenPage=BEGIN
                   InitRequestPageDataInternal;
                 END;

    }
    CONTROLS
    {
      { 8   ;0   ;Container ;
                  ContainerType=ContentArea }

      { 5   ;1   ;Group     ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 9   ;2   ;Field     ;
                  Name=Start Date;
                  CaptionML=[DAN=Startdato;
                             ENU=Start Date];
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k›rslen behandler oplysninger fra.;
                             ENU=Specifies the date from which the report or batch job processes information.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=StartDate }

      { 11  ;2   ;Field     ;
                  Name=End Date;
                  CaptionML=[DAN=Slutdato;
                             ENU=End Date];
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k›rslen behandler oplysninger frem til.;
                             ENU=Specifies the date to which the report or batch job processes information.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=EndDate }

      { 1   ;2   ;Field     ;
                  Name=ShowOverdueEntries;
                  CaptionML=[DAN=Vis forfaldne poster;
                             ENU=Show Overdue Entries];
                  ToolTipML=[DAN=Angiver, om forfaldne poster skal vises separat for hver valuta.;
                             ENU=Specifies if you want overdue entries to be shown separately for each currency.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintEntriesDue }

      { 13  ;2   ;Group     ;
                  Name=Include;
                  CaptionML=[DAN=Inkluder;
                             ENU=Include];
                  GroupType=Group }

      { 2   ;3   ;Field     ;
                  Name=IncludeAllCustomerswithLE;
                  CaptionML=[DAN=Medtag alle debitorer, der har poster;
                             ENU=Include All Customers with Ledger Entries];
                  ToolTipML=[DAN=Angiver, om alle debitorer med finansposter i slutningen af den valgte periode skal med i rapporten.;
                             ENU=Specifies if you want entries displayed for customers that have ledger entries at the end of the selected period.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintAllHavingEntry;
                  MultiLine=Yes;
                  OnValidate=BEGIN
                               IF NOT PrintAllHavingEntry THEN
                                 PrintAllHavingBal := TRUE;
                             END;
                              }

      { 3   ;3   ;Field     ;
                  Name=IncludeAllCustomerswithBalance;
                  CaptionML=[DAN=Medtag ogs† debitorer, der kun har saldo;
                             ENU=Include All Customers with a Balance];
                  ToolTipML=[DAN=Angiver, om alle debitorer med en saldo i slutningen af den valgte periode skal med i rapporten.;
                             ENU=Specifies if you want entries displayed for customers that have a balance at the end of the selected period.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintAllHavingBal;
                  MultiLine=Yes;
                  OnValidate=BEGIN
                               IF NOT PrintAllHavingBal THEN
                                 PrintAllHavingEntry := TRUE;
                             END;
                              }

      { 10  ;3   ;Field     ;
                  Name=IncludeReversedEntries;
                  CaptionML=[DAN=Medtag tilbagef›rte poster;
                             ENU=Include Reversed Entries];
                  ToolTipML=[DAN=Angiver, om du vil medtage tilbagef›rte poster i rapporten.;
                             ENU=Specifies if you want to include reversed entries in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintReversedEntries }

      { 14  ;3   ;Field     ;
                  Name=IncludeUnappliedEntries;
                  CaptionML=[DAN=Medtag ikke-udlignede poster;
                             ENU=Include Unapplied Entries];
                  ToolTipML=[DAN=Angiver, om du vil medtage annullerede poster i rapporten.;
                             ENU=Specifies if you want to include unapplied entries in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintUnappliedEntries }

      { 15  ;2   ;Group     ;
                  CaptionML=[DAN=Aldersfordelingsinterval;
                             ENU=Aging Band];
                  GroupType=Group }

      { 12  ;3   ;Field     ;
                  Name=IncludeAgingBand;
                  CaptionML=[DAN=Medtag aldersford.intv.;
                             ENU=Include Aging Band];
                  ToolTipML=[DAN=Angiver, om der skal medtages et aldersfordelingsinterval i rapporten. Hvis du markerer dette afkrydsningsfelt, skal du ogs† udfylde felterne Aldersfordelingsinterval og Aldersford.intv. efter.;
                             ENU=Specifies if you want an aging band to be included in the document. If you place a check mark here, you must also fill in the Aging Band Period Length and Aging Band by fields.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=IncludeAgingBand }

      { 7   ;3   ;Field     ;
                  Name=AgingBandPeriodLengt;
                  CaptionML=[DAN=Aldersfordelingsinterval;
                             ENU=Aging Band Period Length];
                  ToolTipML=[DAN=Angiver l‘ngden p† hver af de fire perioder i aldersfordelingsintervallet. Angiv f.eks. "1M" for ‚n m†ned. Den seneste periode slutter p† den sidste dag i den periode, der er angivet i feltet Datofilter.;
                             ENU=Specifies the length of each of the four periods in the aging band, for example, enter "1M" for one month. The most recent period will end on the last day of the period in the Date Filter field.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PeriodLength }

      { 6   ;3   ;Field     ;
                  Name=AgingBandby;
                  CaptionML=[DAN=Aldersford.intv. efter;
                             ENU=Aging Band by];
                  ToolTipML=[DAN=Angiver, om aldersfordelingsintervallet skal beregnes ud fra forfaldsdatoen eller fra bogf›ringsdatoen.;
                             ENU=Specifies if the aging band will be calculated from the due date or from the posting date.];
                  OptionCaptionML=[DAN=Forfaldsdato,Bogf›ringsdato;
                                   ENU=Due Date,Posting Date];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DateChoice }

      { 4   ;2   ;Field     ;
                  Name=LogInteraction;
                  CaptionML=[DAN=Logf›r interaktion;
                             ENU=Log Interaction];
                  ToolTipML=[DAN=Angiver, om programmet skal logf›re denne interaktion.;
                             ENU=Specifies if you want the program to log this interaction.];
                  ApplicationArea=#Advanced;
                  SourceExpr=LogInteraction;
                  Enabled=LogInteractionEnable }

      { 17  ;1   ;Group     ;
                  Name=Output Options;
                  CaptionML=[DAN=Rapportindstillinger;
                             ENU=Output Options];
                  GroupType=Group }

      { 16  ;2   ;Field     ;
                  Name=ReportOutput;
                  CaptionML=[DAN=Rapportresultat;
                             ENU=Report Output];
                  ToolTipML=[DAN=Angiver udl‘sningen af den planlagte rapport s†som PDF eller Word.;
                             ENU=Specifies the output of the scheduled report, such as PDF or Word.];
                  OptionCaptionML=[@@@=Each item is a verb/action - to print, to preview, to export to Word, export to PDF, send email, export to XML for RDLC layouts only;
                                   DAN=Udskriv,Vis eksempel,Word,PDF,Email,XML - kun RDLC-layout;
                                   ENU=Print,Preview,Word,PDF,Email,XML - RDLC layouts only];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=SupportedOutputMethod;
                  OnValidate=VAR
                               CustomLayoutReporting@1000 : Codeunit 8800;
                             BEGIN
                               ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);

                               CASE SupportedOutputMethod OF
                                 SupportedOutputMethod::Print:
                                   ChosenOutputMethod := CustomLayoutReporting.GetPrintOption;
                                 SupportedOutputMethod::Preview:
                                   ChosenOutputMethod := CustomLayoutReporting.GetPreviewOption;
                                 SupportedOutputMethod::Word:
                                   ChosenOutputMethod := CustomLayoutReporting.GetWordOption;
                                 SupportedOutputMethod::PDF:
                                   ChosenOutputMethod := CustomLayoutReporting.GetPDFOption;
                                 SupportedOutputMethod::Email:
                                   ChosenOutputMethod := CustomLayoutReporting.GetEmailOption;
                                 SupportedOutputMethod::XML:
                                   ChosenOutputMethod := CustomLayoutReporting.GetXMLOption;
                               END;
                             END;
                              }

      { 18  ;2   ;Field     ;
                  Name=ChosenOutput;
                  ApplicationArea=#Advanced;
                  SourceExpr=ChosenOutputMethod;
                  Visible=False }

      { 20  ;2   ;Group     ;
                  Name=EmailOptions;
                  CaptionML=[DAN=Mail-indstillinger;
                             ENU=Email Options];
                  Visible=ShowPrintRemaining;
                  GroupType=Group }

      { 21  ;3   ;Field     ;
                  Name=PrintMissingAddresses;
                  CaptionML=[DAN=Udskriv resterende kontoudtog;
                             ENU=Print remaining statements];
                  ToolTipML=[DAN=Angiver, at endnu ubetalte bel›b inkluderes.;
                             ENU=Specifies that amounts remaining to be paid will be included.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintRemaining }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      EntriesLbl@1001 : TextConst '@@@="%1 = Currency code";DAN=Poster %1;ENU=Entries %1';
      OverdueEntriesLbl@1002 : TextConst '@@@="%1=Currency code";DAN=Forfaldne poster %1;ENU=Overdue Entries %1';
      StatementLbl@1003 : TextConst 'DAN="Kontoudtog ";ENU="Statement "';
      GLSetup@1004 : Record 98;
      SalesSetup@1052 : Record 311;
      CompanyInfo@1005 : Record 79;
      CompanyInfo1@1049 : Record 79;
      CompanyInfo2@1050 : Record 79;
      CompanyInfo3@1051 : Record 79;
      Cust2@1006 : Record 18;
      Currency@1007 : Record 4;
      TempCurrency2@1008 : TEMPORARY Record 4;
      Language@1009 : Record 8;
      CustLedgerEntry@1033 : Record 21;
      DetailedCustLedgEntry2@1034 : Record 379;
      TempAgingBandBuf@1037 : TEMPORARY Record 47;
      FormatAddr@1021 : Codeunit 365;
      SegManagement@1020 : Codeunit 5051;
      PrintAllHavingEntry@1010 : Boolean;
      PrintAllHavingBal@1011 : Boolean;
      PrintEntriesDue@1012 : Boolean;
      PrintUnappliedEntries@1047 : Boolean;
      PrintReversedEntries@1048 : Boolean;
      PrintLine@1013 : Boolean;
      LogInteraction@1023 : Boolean;
      EntriesExists@1024 : Boolean;
      StartDate@1014 : Date;
      EndDate@1015 : Date;
      DueDate@1030 : Date;
      CustAddr@1016 : ARRAY [8] OF Text[50];
      CompanyAddr@1017 : ARRAY [8] OF Text[50];
      Description@1026 : Text[50];
      StartBalance@1018 : Decimal;
      CustBalance@1019 : Decimal;
      RemainingAmount@1031 : Decimal;
      CurrencyCode3@1022 : Code[10];
      MulticurrencyAppLbl@1027 : TextConst 'DAN=Multivaluta;ENU=Multicurrency Application';
      PaymentDiscountLbl@1028 : TextConst 'DAN=Kontantrabat;ENU=Payment Discount';
      RoundingLbl@1029 : TextConst 'DAN=Afrunding;ENU=Rounding';
      PeriodLength@1032 : DateFormula;
      PeriodLength2@1046 : DateFormula;
      DateChoice@1035 : 'Due Date,Posting Date';
      AgingDate@1036 : ARRAY [5] OF Date;
      AgingBandPeriodErr@1038 : TextConst 'DAN=Du skal angive l‘ngden af aldersfordelingsintervallet.;ENU=You must specify the Aging Band Period Length.';
      AgingBandEndingDate@1040 : Date;
      AgingBandEndErr@1044 : TextConst 'DAN=Du skal angive en slutdato for aldersfordelingsintervallet.;ENU=You must specify Aging Band Ending Date.';
      AgedSummaryLbl@1041 : TextConst '@@@="%1=Report aging band end date, %2=Aging band period, %3=Type of deadline (''due date'', ''posting date'') as given in DuePostingDateLbl";DAN=Aldersfordelt oversigt efter %1 (%2 efter %3);ENU=Aged Summary by %1 (%2 by %3)';
      IncludeAgingBand@1043 : Boolean;
      PeriodLengthErr@1039 : TextConst 'DAN=Periodel‘ngden er ugyldig.;ENU=Period Length is out of range.';
      AgingBandCurrencyCode@1042 : Code[20];
      DuePostingDateLbl@1025 : TextConst 'DAN=Forfaldsdato,Bogf›ringsdato;ENU=Due Date,Posting Date';
      WriteoffsLbl@1045 : TextConst 'DAN=Udligningsafskrivninger;ENU=Application Writeoffs';
      LogInteractionEnable@19003940 : Boolean INDATASET;
      PeriodSeparatorLbl@1070 : TextConst '@@@=Negating the period length: %1 is the period length;DAN=-%1;ENU=-%1';
      StatementCaptionLbl@1978 : TextConst 'DAN=Kontoudtog;ENU=Statement';
      PhoneNo_CompanyInfoCaptionLbl@2240 : TextConst 'DAN=Telefon;ENU=Phone No.';
      VATRegNo_CompanyInfoCaptionLbl@4406 : TextConst 'DAN=SE/CVR-nr.;ENU=VAT Registration No.';
      GiroNo_CompanyInfoCaptionLbl@6756 : TextConst 'DAN=Gironr.;ENU=Giro No.';
      BankName_CompanyInfoCaptionLbl@4354 : TextConst 'DAN=Bank;ENU=Bank';
      BankAccNo_CompanyInfoCaptionLbl@6132 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      No1_CustCaptionLbl@9474 : TextConst 'DAN=Debitornr.;ENU=Customer No.';
      StartDateCaptionLbl@9565 : TextConst 'DAN=Startdato;ENU=Starting Date';
      EndDateCaptionLbl@4843 : TextConst 'DAN=Slutdato;ENU=Ending Date';
      LastStatmntNo_CustCaptionLbl@8647 : TextConst 'DAN=Kontoudtogsnr.;ENU=Statement No.';
      PostDate_DtldCustLedgEntriesCaptionLbl@1432 : TextConst 'DAN=Bogf›ringsdato;ENU=Posting Date';
      DueDate_CustLedgEntry2CaptionLbl@1175 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      CustBalanceCaptionLbl@2935 : TextConst 'DAN=Saldo;ENU=Balance';
      beforeCaptionLbl@1964 : TextConst 'DAN=..f›r;ENU=..before';
      isInitialized@1090 : Boolean;
      CompanyInfoHomepageCaptionLbl@3493 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      CompanyInfoEmailCaptionLbl@1765 : TextConst 'DAN=Mail;ENU=Email';
      DocDateCaptionLbl@6175 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      Total_CaptionLbl@1000 : TextConst 'DAN=Total;ENU=Total';
      BlankStartDateErr@1053 : TextConst 'DAN=Startdato skal indeholde en v‘rdi.;ENU=Start Date must have a value.';
      BlankEndDateErr@1054 : TextConst 'DAN=Slutdato skal indeholde en v‘rdi.;ENU=End Date must have a value.';
      StartDateLaterTheEndDateErr@1055 : TextConst 'DAN=Startdatoen skal ligge f›r slutdatoen.;ENU=Start date must be earlier than End date.';
      IsFirstLoop@1056 : Boolean;
      CurrReportPageNoCaptionLbl@1057 : TextConst 'DAN=Side;ENU=Page';
      IsFirstPrintLine@1058 : Boolean;
      IsNewCustCurrencyGroup@1059 : Boolean;
      AgingDateHeader1@1061 : Text;
      AgingDateHeader2@1060 : Text;
      AgingDateHeader3@1062 : Text;
      AgingDateHeader4@1063 : Text;
      SupportedOutputMethod@1071 : 'Print,Preview,Word,PDF,Email,XML';
      ChosenOutputMethod@1069 : Integer;
      PrintRemaining@1065 : Boolean;
      ShowPrintRemaining@1067 : Boolean INDATASET;
      CustBalance2@1066 : Decimal;
      GreetingLbl@1074 : TextConst 'DAN=Hej;ENU=Hello';
      ClosingLbl@1073 : TextConst 'DAN=Med venlig hilsen;ENU=Sincerely';
      BodyLbl@1064 : TextConst 'DAN=Tak for din interesse i vores varer. Din opg›relse er vedh‘ftet denne meddelelse.;ENU=Thank you for your business. Your statement is attached to this message.';

    LOCAL PROCEDURE GetDate@3(PostingDate@1000 : Date;DueDate@1001 : Date) : Date;
    BEGIN
      IF DateChoice = DateChoice::"Posting Date" THEN
        EXIT(PostingDate);

      EXIT(DueDate);
    END;

    LOCAL PROCEDURE CalcAgingBandDates@1();
    BEGIN
      IF NOT IncludeAgingBand THEN
        EXIT;
      IF AgingBandEndingDate = 0D THEN
        ERROR(AgingBandEndErr);
      IF FORMAT(PeriodLength) = '' THEN
        ERROR(AgingBandPeriodErr);
      EVALUATE(PeriodLength2,STRSUBSTNO(PeriodSeparatorLbl,PeriodLength));
      AgingDate[5] := AgingBandEndingDate;
      AgingDate[4] := CALCDATE(PeriodLength2,AgingDate[5]);
      AgingDate[3] := CALCDATE(PeriodLength2,AgingDate[4]);
      AgingDate[2] := CALCDATE(PeriodLength2,AgingDate[3]);
      AgingDate[1] := CALCDATE(PeriodLength2,AgingDate[2]);
      IF AgingDate[2] <= AgingDate[1] THEN
        ERROR(PeriodLengthErr);

      AgingDateHeader1 := FORMAT(AgingDate[1]) + ' - ' + FORMAT(AgingDate[2]);
      AgingDateHeader2 := FORMAT(AgingDate[2] + 1) + ' - ' + FORMAT(AgingDate[3]);
      AgingDateHeader3 := FORMAT(AgingDate[3] + 1) + ' - ' + FORMAT(AgingDate[4]);
      AgingDateHeader4 := FORMAT(AgingDate[4] + 1);
    END;

    LOCAL PROCEDURE UpdateBuffer@2(CurrencyCode@1000 : Code[10];Date@1001 : Date;Amount@1002 : Decimal);
    VAR
      I@1003 : Integer;
      GoOn@1004 : Boolean;
    BEGIN
      TempAgingBandBuf.INIT;
      TempAgingBandBuf."Currency Code" := CurrencyCode;
      IF NOT TempAgingBandBuf.FIND THEN
        TempAgingBandBuf.INSERT;
      I := 1;
      GoOn := TRUE;
      WHILE (I <= 5) AND GoOn DO BEGIN
        IF Date <= AgingDate[I] THEN
          IF I = 1 THEN BEGIN
            TempAgingBandBuf."Column 1 Amt." := TempAgingBandBuf."Column 1 Amt." + Amount;
            GoOn := FALSE;
          END;
        IF Date <= AgingDate[I] THEN
          IF I = 2 THEN BEGIN
            TempAgingBandBuf."Column 2 Amt." := TempAgingBandBuf."Column 2 Amt." + Amount;
            GoOn := FALSE;
          END;
        IF Date <= AgingDate[I] THEN
          IF I = 3 THEN BEGIN
            TempAgingBandBuf."Column 3 Amt." := TempAgingBandBuf."Column 3 Amt." + Amount;
            GoOn := FALSE;
          END;
        IF Date <= AgingDate[I] THEN
          IF I = 4 THEN BEGIN
            TempAgingBandBuf."Column 4 Amt." := TempAgingBandBuf."Column 4 Amt." + Amount;
            GoOn := FALSE;
          END;
        IF Date <= AgingDate[I] THEN
          IF I = 5 THEN BEGIN
            TempAgingBandBuf."Column 5 Amt." := TempAgingBandBuf."Column 5 Amt." + Amount;
            GoOn := FALSE;
          END;
        I := I + 1;
      END;
      TempAgingBandBuf.MODIFY;
    END;

    PROCEDURE SkipReversedUnapplied@4(VAR DetailedCustLedgEntry@1000 : Record 379) : Boolean;
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      IF PrintReversedEntries AND PrintUnappliedEntries THEN
        EXIT(FALSE);
      IF NOT PrintUnappliedEntries THEN
        IF DetailedCustLedgEntry.Unapplied THEN
          EXIT(TRUE);
      IF NOT PrintReversedEntries THEN BEGIN
        CustLedgEntry.GET(DetailedCustLedgEntry."Cust. Ledger Entry No.");
        IF CustLedgEntry.Reversed THEN
          EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    PROCEDURE InitializeRequest@5(NewPrintEntriesDue@1000 : Boolean;NewPrintAllHavingEntry@1001 : Boolean;NewPrintAllHavingBal@1002 : Boolean;NewPrintReversedEntries@1003 : Boolean;NewPrintUnappliedEntries@1004 : Boolean;NewIncludeAgingBand@1005 : Boolean;NewPeriodLength@1006 : Text[30];NewDateChoice@1007 : 'Due Date,Posting Date';NewLogInteraction@1008 : Boolean;NewStartDate@1009 : Date;NewEndDate@1010 : Date);
    BEGIN
      InitRequestPageDataInternal;

      PrintEntriesDue := NewPrintEntriesDue;
      PrintAllHavingEntry := NewPrintAllHavingEntry;
      PrintAllHavingBal := NewPrintAllHavingBal;
      PrintReversedEntries := NewPrintReversedEntries;
      PrintUnappliedEntries := NewPrintUnappliedEntries;
      IncludeAgingBand := NewIncludeAgingBand;
      EVALUATE(PeriodLength,NewPeriodLength);
      DateChoice := NewDateChoice;
      LogInteraction := NewLogInteraction;
      StartDate := NewStartDate;
      EndDate := NewEndDate;
    END;

    LOCAL PROCEDURE IsReportInPreviewMode@6() : Boolean;
    VAR
      MailManagement@1000 : Codeunit 9520;
    BEGIN
      EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    END;

    PROCEDURE InitRequestPageDataInternal@1091();
    BEGIN
      IF isInitialized THEN
        EXIT;

      isInitialized := TRUE;

      IF (NOT PrintAllHavingEntry) AND (NOT PrintAllHavingBal) THEN
        PrintAllHavingBal := TRUE;

      LogInteraction := SegManagement.FindInteractTmplCode(7) <> '';
      LogInteractionEnable := LogInteraction;

      IF FORMAT(PeriodLength) = '' THEN
        EVALUATE(PeriodLength,'<1M+CM>');

      ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);
    END;

    LOCAL PROCEDURE VerifyDates@7();
    BEGIN
      IF StartDate = 0D THEN
        ERROR(BlankStartDateErr);
      IF EndDate = 0D THEN
        ERROR(BlankEndDateErr);
      IF StartDate > EndDate THEN
        ERROR(StartDateLaterTheEndDateErr);
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
      <rd:DataSourceID>b94148f2-a346-43d2-9f01-9142603a0f2d</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="No_Cust">
          <DataField>No_Cust</DataField>
        </Field>
        <Field Name="CompanyInfo1Picture">
          <DataField>CompanyInfo1Picture</DataField>
        </Field>
        <Field Name="CompanyInfo2Picture">
          <DataField>CompanyInfo2Picture</DataField>
        </Field>
        <Field Name="CompanyInfo3Picture">
          <DataField>CompanyInfo3Picture</DataField>
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
        <Field Name="PhoneNo_CompanyInfo">
          <DataField>PhoneNo_CompanyInfo</DataField>
        </Field>
        <Field Name="CustAddr6">
          <DataField>CustAddr6</DataField>
        </Field>
        <Field Name="CompanyInfoEmail">
          <DataField>CompanyInfoEmail</DataField>
        </Field>
        <Field Name="CompanyInfoHomePage">
          <DataField>CompanyInfoHomePage</DataField>
        </Field>
        <Field Name="VATRegNo_CompanyInfo">
          <DataField>VATRegNo_CompanyInfo</DataField>
        </Field>
        <Field Name="GiroNo_CompanyInfo">
          <DataField>GiroNo_CompanyInfo</DataField>
        </Field>
        <Field Name="BankName_CompanyInfo">
          <DataField>BankName_CompanyInfo</DataField>
        </Field>
        <Field Name="BankAccNo_CompanyInfo">
          <DataField>BankAccNo_CompanyInfo</DataField>
        </Field>
        <Field Name="No1_Cust">
          <DataField>No1_Cust</DataField>
        </Field>
        <Field Name="TodayFormatted">
          <DataField>TodayFormatted</DataField>
        </Field>
        <Field Name="StartDate">
          <DataField>StartDate</DataField>
        </Field>
        <Field Name="EndDate">
          <DataField>EndDate</DataField>
        </Field>
        <Field Name="LastStatmntNo_Cust">
          <DataField>LastStatmntNo_Cust</DataField>
        </Field>
        <Field Name="CustAddr7">
          <DataField>CustAddr7</DataField>
        </Field>
        <Field Name="CustAddr8">
          <DataField>CustAddr8</DataField>
        </Field>
        <Field Name="CompanyAddr7">
          <DataField>CompanyAddr7</DataField>
        </Field>
        <Field Name="CompanyAddr8">
          <DataField>CompanyAddr8</DataField>
        </Field>
        <Field Name="StatementCaption">
          <DataField>StatementCaption</DataField>
        </Field>
        <Field Name="PhoneNo_CompanyInfoCaption">
          <DataField>PhoneNo_CompanyInfoCaption</DataField>
        </Field>
        <Field Name="VATRegNo_CompanyInfoCaption">
          <DataField>VATRegNo_CompanyInfoCaption</DataField>
        </Field>
        <Field Name="GiroNo_CompanyInfoCaption">
          <DataField>GiroNo_CompanyInfoCaption</DataField>
        </Field>
        <Field Name="BankName_CompanyInfoCaption">
          <DataField>BankName_CompanyInfoCaption</DataField>
        </Field>
        <Field Name="BankAccNo_CompanyInfoCaption">
          <DataField>BankAccNo_CompanyInfoCaption</DataField>
        </Field>
        <Field Name="No1_CustCaption">
          <DataField>No1_CustCaption</DataField>
        </Field>
        <Field Name="StartDateCaption">
          <DataField>StartDateCaption</DataField>
        </Field>
        <Field Name="EndDateCaption">
          <DataField>EndDateCaption</DataField>
        </Field>
        <Field Name="LastStatmntNo_CustCaption">
          <DataField>LastStatmntNo_CustCaption</DataField>
        </Field>
        <Field Name="PostDate_DtldCustLedgEntriesCaption">
          <DataField>PostDate_DtldCustLedgEntriesCaption</DataField>
        </Field>
        <Field Name="DocNo_DtldCustLedgEntriesCaption">
          <DataField>DocNo_DtldCustLedgEntriesCaption</DataField>
        </Field>
        <Field Name="Desc_CustLedgEntry2Caption">
          <DataField>Desc_CustLedgEntry2Caption</DataField>
        </Field>
        <Field Name="DueDate_CustLedgEntry2Caption">
          <DataField>DueDate_CustLedgEntry2Caption</DataField>
        </Field>
        <Field Name="RemainAmtCustLedgEntry2Caption">
          <DataField>RemainAmtCustLedgEntry2Caption</DataField>
        </Field>
        <Field Name="CustBalanceCaption">
          <DataField>CustBalanceCaption</DataField>
        </Field>
        <Field Name="OriginalAmt_CustLedgEntry2Caption">
          <DataField>OriginalAmt_CustLedgEntry2Caption</DataField>
        </Field>
        <Field Name="CompanyInfoHomepageCaption">
          <DataField>CompanyInfoHomepageCaption</DataField>
        </Field>
        <Field Name="CompanyInfoEmailCaption">
          <DataField>CompanyInfoEmailCaption</DataField>
        </Field>
        <Field Name="DocDateCaption">
          <DataField>DocDateCaption</DataField>
        </Field>
        <Field Name="CurrReportPageNoCaption">
          <DataField>CurrReportPageNoCaption</DataField>
        </Field>
        <Field Name="Currency2Code_CustLedgEntryHdr">
          <DataField>Currency2Code_CustLedgEntryHdr</DataField>
        </Field>
        <Field Name="StartBalance">
          <DataField>StartBalance</DataField>
        </Field>
        <Field Name="StartBalanceFormat">
          <DataField>StartBalanceFormat</DataField>
        </Field>
        <Field Name="CurrencyCode3">
          <DataField>CurrencyCode3</DataField>
        </Field>
        <Field Name="CustBalance_CustLedgEntryHdr">
          <DataField>CustBalance_CustLedgEntryHdr</DataField>
        </Field>
        <Field Name="CustBalance_CustLedgEntryHdrFormat">
          <DataField>CustBalance_CustLedgEntryHdrFormat</DataField>
        </Field>
        <Field Name="PrintLine">
          <DataField>PrintLine</DataField>
        </Field>
        <Field Name="DtldCustLedgEntryType">
          <DataField>DtldCustLedgEntryType</DataField>
        </Field>
        <Field Name="EntriesExists">
          <DataField>EntriesExists</DataField>
        </Field>
        <Field Name="IsNewCustCurrencyGroup">
          <DataField>IsNewCustCurrencyGroup</DataField>
        </Field>
        <Field Name="PostDate_DtldCustLedgEntries">
          <DataField>PostDate_DtldCustLedgEntries</DataField>
        </Field>
        <Field Name="DocNo_DtldCustLedgEntries">
          <DataField>DocNo_DtldCustLedgEntries</DataField>
        </Field>
        <Field Name="Description">
          <DataField>Description</DataField>
        </Field>
        <Field Name="DueDate_DtldCustLedgEntries">
          <DataField>DueDate_DtldCustLedgEntries</DataField>
        </Field>
        <Field Name="CurrCode_DtldCustLedgEntries">
          <DataField>CurrCode_DtldCustLedgEntries</DataField>
        </Field>
        <Field Name="Amt_DtldCustLedgEntries">
          <DataField>Amt_DtldCustLedgEntries</DataField>
        </Field>
        <Field Name="Amt_DtldCustLedgEntriesFormat">
          <DataField>Amt_DtldCustLedgEntriesFormat</DataField>
        </Field>
        <Field Name="RemainAmt_DtldCustLedgEntries">
          <DataField>RemainAmt_DtldCustLedgEntries</DataField>
        </Field>
        <Field Name="RemainAmt_DtldCustLedgEntriesFormat">
          <DataField>RemainAmt_DtldCustLedgEntriesFormat</DataField>
        </Field>
        <Field Name="CustBalance">
          <DataField>CustBalance</DataField>
        </Field>
        <Field Name="CustBalanceFormat">
          <DataField>CustBalanceFormat</DataField>
        </Field>
        <Field Name="Currency2Code">
          <DataField>Currency2Code</DataField>
        </Field>
        <Field Name="Total_Caption3">
          <DataField>Total_Caption3</DataField>
        </Field>
        <Field Name="CurrencyCode3_CustLedgEntryFooter">
          <DataField>CurrencyCode3_CustLedgEntryFooter</DataField>
        </Field>
        <Field Name="Total_Caption">
          <DataField>Total_Caption</DataField>
        </Field>
        <Field Name="CustBalance_CustLedgEntryHdrFooter">
          <DataField>CustBalance_CustLedgEntryHdrFooter</DataField>
        </Field>
        <Field Name="CustBalance_CustLedgEntryHdrFooterFormat">
          <DataField>CustBalance_CustLedgEntryHdrFooterFormat</DataField>
        </Field>
        <Field Name="EntriesExistsl_CustLedgEntryFooterCaption">
          <DataField>EntriesExistsl_CustLedgEntryFooterCaption</DataField>
        </Field>
        <Field Name="OverDueEntries">
          <DataField>OverDueEntries</DataField>
        </Field>
        <Field Name="RemainAmt_CustLedgEntry2">
          <DataField>RemainAmt_CustLedgEntry2</DataField>
        </Field>
        <Field Name="RemainAmt_CustLedgEntry2Format">
          <DataField>RemainAmt_CustLedgEntry2Format</DataField>
        </Field>
        <Field Name="PostDate_CustLedgEntry2">
          <DataField>PostDate_CustLedgEntry2</DataField>
        </Field>
        <Field Name="DocNo_CustLedgEntry2">
          <DataField>DocNo_CustLedgEntry2</DataField>
        </Field>
        <Field Name="Desc_CustLedgEntry2">
          <DataField>Desc_CustLedgEntry2</DataField>
        </Field>
        <Field Name="DueDate_CustLedgEntry2">
          <DataField>DueDate_CustLedgEntry2</DataField>
        </Field>
        <Field Name="OriginalAmt_CustLedgEntry2">
          <DataField>OriginalAmt_CustLedgEntry2</DataField>
        </Field>
        <Field Name="OriginalAmt_CustLedgEntry2Format">
          <DataField>OriginalAmt_CustLedgEntry2Format</DataField>
        </Field>
        <Field Name="CurrCode_CustLedgEntry2">
          <DataField>CurrCode_CustLedgEntry2</DataField>
        </Field>
        <Field Name="PrintEntriesDue">
          <DataField>PrintEntriesDue</DataField>
        </Field>
        <Field Name="Currency2Code_CustLedgEntry2">
          <DataField>Currency2Code_CustLedgEntry2</DataField>
        </Field>
        <Field Name="CurrencyCode3_CustLedgEntry2">
          <DataField>CurrencyCode3_CustLedgEntry2</DataField>
        </Field>
        <Field Name="CustNo_CustLedgEntry2">
          <DataField>CustNo_CustLedgEntry2</DataField>
        </Field>
        <Field Name="AgingDate1">
          <DataField>AgingDate1</DataField>
        </Field>
        <Field Name="AgingDate2">
          <DataField>AgingDate2</DataField>
        </Field>
        <Field Name="AgingDate21">
          <DataField>AgingDate21</DataField>
        </Field>
        <Field Name="AgingDate3">
          <DataField>AgingDate3</DataField>
        </Field>
        <Field Name="AgingDate31">
          <DataField>AgingDate31</DataField>
        </Field>
        <Field Name="AgingDate4">
          <DataField>AgingDate4</DataField>
        </Field>
        <Field Name="AgingBandEndingDate">
          <DataField>AgingBandEndingDate</DataField>
        </Field>
        <Field Name="AgingDate41">
          <DataField>AgingDate41</DataField>
        </Field>
        <Field Name="AgingDate5">
          <DataField>AgingDate5</DataField>
        </Field>
        <Field Name="AgingBandBufCol1Amt">
          <DataField>AgingBandBufCol1Amt</DataField>
        </Field>
        <Field Name="AgingBandBufCol1AmtFormat">
          <DataField>AgingBandBufCol1AmtFormat</DataField>
        </Field>
        <Field Name="AgingBandBufCol2Amt">
          <DataField>AgingBandBufCol2Amt</DataField>
        </Field>
        <Field Name="AgingBandBufCol2AmtFormat">
          <DataField>AgingBandBufCol2AmtFormat</DataField>
        </Field>
        <Field Name="AgingBandBufCol3Amt">
          <DataField>AgingBandBufCol3Amt</DataField>
        </Field>
        <Field Name="AgingBandBufCol3AmtFormat">
          <DataField>AgingBandBufCol3AmtFormat</DataField>
        </Field>
        <Field Name="AgingBandBufCol4Amt">
          <DataField>AgingBandBufCol4Amt</DataField>
        </Field>
        <Field Name="AgingBandBufCol4AmtFormat">
          <DataField>AgingBandBufCol4AmtFormat</DataField>
        </Field>
        <Field Name="AgingBandBufCol5Amt">
          <DataField>AgingBandBufCol5Amt</DataField>
        </Field>
        <Field Name="AgingBandBufCol5AmtFormat">
          <DataField>AgingBandBufCol5AmtFormat</DataField>
        </Field>
        <Field Name="AgingBandCurrencyCode">
          <DataField>AgingBandCurrencyCode</DataField>
        </Field>
        <Field Name="beforeCaption">
          <DataField>beforeCaption</DataField>
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
                  <Width>17.93863cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>5.86059cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Rectangle Name="list1_Contents">
                          <ReportItems>
                            <Tablix Name="table3">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>4.25331cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.73421cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.73418cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.73421cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.73421cm</Width>
                                  </TablixColumn>
                                  <TablixColumn>
                                    <Width>2.73421cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>0.35278cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox127">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AgingBandEndingDate.Value</Value>
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
                                            <rd:DefaultName>textbox127</rd:DefaultName>
                                            <ZIndex>27</ZIndex>
                                            <Style>
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
                                          <Textbox Name="textbox131">
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
                                            <rd:DefaultName>textbox131</rd:DefaultName>
                                            <ZIndex>26</ZIndex>
                                            <Style>
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
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox153</rd:DefaultName>
                                            <ZIndex>25</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
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
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox159</rd:DefaultName>
                                            <ZIndex>24</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
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
                                          <Textbox Name="textbox139">
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
                                            <rd:DefaultName>textbox139</rd:DefaultName>
                                            <ZIndex>23</ZIndex>
                                            <Style>
                                              <PaddingRight>5pt</PaddingRight>
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
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox140</rd:DefaultName>
                                            <ZIndex>22</ZIndex>
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
                                            <rd:DefaultName>textbox141</rd:DefaultName>
                                            <ZIndex>21</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox148</rd:DefaultName>
                                            <ZIndex>20</ZIndex>
                                            <Style>
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
                                                      <FontSize>7pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style />
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox154</rd:DefaultName>
                                            <ZIndex>19</ZIndex>
                                            <Style>
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
                                            <rd:DefaultName>textbox160</rd:DefaultName>
                                            <ZIndex>18</ZIndex>
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
                                          <Textbox Name="textbox142">
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
                                            <rd:DefaultName>textbox142</rd:DefaultName>
                                            <ZIndex>17</ZIndex>
                                            <Style>
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
                                                    <Value>=Fields!AgingDate41.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox143</rd:DefaultName>
                                            <ZIndex>16</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
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
                                                    <Value>=Fields!AgingDate31.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox144</rd:DefaultName>
                                            <ZIndex>15</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
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
                                                    <Value>=Fields!AgingDate21.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox149</rd:DefaultName>
                                            <ZIndex>14</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox155">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AgingDate1.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox155</rd:DefaultName>
                                            <ZIndex>13</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox161">
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
                                            <rd:DefaultName>textbox161</rd:DefaultName>
                                            <ZIndex>12</ZIndex>
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
                                          <Textbox Name="textbox145">
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
                                            <rd:DefaultName>textbox145</rd:DefaultName>
                                            <ZIndex>11</ZIndex>
                                            <Style>
                                              <PaddingRight>5pt</PaddingRight>
                                            </Style>
                                          </Textbox>
                                        </CellContents>
                                      </TablixCell>
                                      <TablixCell>
                                        <CellContents>
                                          <Textbox Name="textbox146">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AgingDate5.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox146</rd:DefaultName>
                                            <ZIndex>10</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
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
                                                    <Value>=Fields!AgingDate4.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox147</rd:DefaultName>
                                            <ZIndex>9</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
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
                                                    <Value>=Fields!AgingDate3.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox150</rd:DefaultName>
                                            <ZIndex>8</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
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
                                                    <Value>=Fields!AgingDate2.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox156</rd:DefaultName>
                                            <ZIndex>7</ZIndex>
                                            <Style>
                                              <PaddingLeft>5pt</PaddingLeft>
                                              <PaddingRight>5pt</PaddingRight>
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
                                                    <Value>=Fields!beforeCaption.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <FontWeight>Bold</FontWeight>
                                                      <Format>d</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox162</rd:DefaultName>
                                            <ZIndex>6</ZIndex>
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
                                          <Textbox Name="textbox133">
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AgingBandCurrencyCode.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Center</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox133</rd:DefaultName>
                                            <ZIndex>5</ZIndex>
                                            <Style>
                                              <PaddingRight>5pt</PaddingRight>
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
                                                    <Value>=Fields!AgingBandBufCol5Amt.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!AgingBandBufCol5AmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox134</rd:DefaultName>
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
                                          <Textbox Name="textbox135">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AgingBandBufCol4Amt.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!AgingBandBufCol4AmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox135</rd:DefaultName>
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
                                          <Textbox Name="textbox151">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AgingBandBufCol3Amt.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!AgingBandBufCol3AmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox151</rd:DefaultName>
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
                                          <Textbox Name="textbox157">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AgingBandBufCol2Amt.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!AgingBandBufCol2AmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox157</rd:DefaultName>
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
                                          <Textbox Name="textbox163">
                                            <CanGrow>true</CanGrow>
                                            <KeepTogether>true</KeepTogether>
                                            <Paragraphs>
                                              <Paragraph>
                                                <TextRuns>
                                                  <TextRun>
                                                    <Value>=Fields!AgingBandBufCol1Amt.Value</Value>
                                                    <Style>
                                                      <FontFamily>Segoe UI</FontFamily>
                                                      <FontSize>8pt</FontSize>
                                                      <Format>=Fields!AgingBandBufCol1AmtFormat.Value</Format>
                                                    </Style>
                                                  </TextRun>
                                                </TextRuns>
                                                <Style>
                                                  <TextAlign>Right</TextAlign>
                                                </Style>
                                              </Paragraph>
                                            </Paragraphs>
                                            <rd:DefaultName>textbox163</rd:DefaultName>
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
                                    <Group Name="table3_Details_Group">
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
                                  <FilterExpression>=Fields!AgingBandCurrencyCode.Value</FilterExpression>
                                  <Operator>GreaterThan</Operator>
                                  <FilterValues>
                                    <FilterValue>=""</FilterValue>
                                  </FilterValues>
                                </Filter>
                              </Filters>
                              <Top>4.02645cm</Top>
                              <Height>1.83413cm</Height>
                              <Width>17.92433cm</Width>
                              <Style />
                            </Tablix>
                            <Tablix Name="table5">
                              <TablixBody>
                                <TablixColumns>
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
                                            <ZIndex>13</ZIndex>
                                            <Visibility>
                                              <Hidden>=Code.SetData(Cstr(Fields!CustAddr1.Value) + Chr(177) + 
Cstr(Fields!CustAddr2.Value) + Chr(177) + 
Cstr(Fields!CustAddr3.Value) + Chr(177) + 
Cstr(Fields!CustAddr4.Value) + Chr(177) + 
Cstr(Fields!CustAddr5.Value) + Chr(177) + 
Cstr(Fields!CustAddr6.Value) + Chr(177) + 
Cstr(Fields!CustAddr7.Value) + Chr(177) + 
Cstr(Fields!CustAddr8.Value) + Chr(177) + 
Chr(177) + 
Cstr(Fields!No1_Cust.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr1.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr2.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr3.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr4.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr7.Value) + Chr(177) + 
Cstr(Fields!CompanyAddr8.Value) + Chr(177) + 
Chr(177) + 
Chr(177) + 
Chr(177) + 
Chr(177) + 
Chr(177) + 
Chr(177) + 
Cstr(Fields!PhoneNo_CompanyInfo.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoHomePage.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoEmail.Value) + Chr(177) + 
Cstr(Fields!VATRegNo_CompanyInfo.Value) + Chr(177) + 
Cstr(Fields!GiroNo_CompanyInfo.Value) + Chr(177) + 
Cstr(Fields!BankName_CompanyInfo.Value) + Chr(177) + 
Cstr(Fields!BankAccNo_CompanyInfo.Value) + Chr(177) + 
Cstr(Fields!TodayFormatted.Value) + Chr(177) + 
Cstr(Fields!StartDate.Value) + Chr(177) + 
Cstr(Fields!EndDate.Value) + Chr(177) + 
Cstr(Fields!LastStatmntNo_Cust.Value) + Chr(177) + 
Cstr(Fields!LastStatmntNo_CustCaption.Value) + Chr(177) + 
Cstr(Fields!EndDateCaption.Value) + Chr(177) + 
Cstr(Fields!StartDateCaption.Value) + Chr(177) + 
Cstr(Fields!No1_CustCaption.Value) + Chr(177) + 
Cstr(Fields!BankAccNo_CompanyInfoCaption.Value) + Chr(177) + 
Cstr(Fields!BankName_CompanyInfoCaption.Value) + Chr(177) + 
Cstr(Fields!GiroNo_CompanyInfoCaption.Value) + Chr(177) + 
Cstr(Fields!VATRegNo_CompanyInfoCaption.Value) + Chr(177) + 
Cstr(Fields!PhoneNo_CompanyInfoCaption.Value) + Chr(177) + 
Cstr(Fields!StatementCaption.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoHomepageCaption.Value) + Chr(177) + 
Cstr(Fields!CompanyInfoEmailCaption.Value) + Chr(177) + 
Cstr(Fields!DocDateCaption.Value) + Chr(177) + 
Cstr(Fields!PostDate_DtldCustLedgEntriesCaption.Value) + Chr(177) + 
Cstr(Fields!DocNo_DtldCustLedgEntriesCaption.Value) + Chr(177) + 
Cstr(Fields!Desc_CustLedgEntry2Caption.Value) + Chr(177) + 
Cstr(Fields!DueDate_CustLedgEntry2Caption.Value) + Chr(177) + 
Cstr(Fields!OriginalAmt_CustLedgEntry2Caption.Value) + Chr(177) + 
Cstr(Fields!RemainAmtCustLedgEntry2Caption.Value) + Chr(177) + 
Cstr(Fields!CustBalanceCaption.Value)
, 1)</Hidden>
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
                                                    <Value>=iif(Code.IsNewPage(Fields!No_Cust.Value),TRUE,FALSE)</Value>
                                                    <Style>
                                                      <FontSize>7pt</FontSize>
                                                      <Color>#ff0000</Color>
                                                    </Style>
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
                                              <PaddingLeft>2pt</PaddingLeft>
                                              <PaddingRight>2pt</PaddingRight>
                                              <PaddingTop>2pt</PaddingTop>
                                              <PaddingBottom>2pt</PaddingBottom>
                                            </Style>
                                          </Textbox>
                                          <rd:Selected>true</rd:Selected>
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
                              <Height>0.1cm</Height>
                              <Width>0.4cm</Width>
                              <ZIndex>1</ZIndex>
                              <Style />
                            </Tablix>
                            <Tablix Name="list2">
                              <TablixBody>
                                <TablixColumns>
                                  <TablixColumn>
                                    <Width>17.93863cm</Width>
                                  </TablixColumn>
                                </TablixColumns>
                                <TablixRows>
                                  <TablixRow>
                                    <Height>3.22057cm</Height>
                                    <TablixCells>
                                      <TablixCell>
                                        <CellContents>
                                          <Rectangle Name="list2_Contents">
                                            <ReportItems>
                                              <Tablix Name="Table1">
                                                <TablixBody>
                                                  <TablixColumns>
                                                    <TablixColumn>
                                                      <Width>2.04cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>1.98768cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>4.20624cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>1.98768cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>1.7749cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>1.90023cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>2.4052cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>1.6367cm</Width>
                                                    </TablixColumn>
                                                  </TablixColumns>
                                                  <TablixRows>
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
                                                                      <Value>=Fields!Currency2Code_CustLedgEntryHdr.Value</Value>
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
                                                              <rd:DefaultName>textbox4</rd:DefaultName>
                                                              <ZIndex>30</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="textbox31">
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
                                                              <rd:DefaultName>textbox31</rd:DefaultName>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox11</rd:DefaultName>
                                                              <Style>
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
                                                              <rd:DefaultName>textbox12</rd:DefaultName>
                                                              <ZIndex>27</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <FontWeight>Bold</FontWeight>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox13</rd:DefaultName>
                                                              <ZIndex>26</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <FontWeight>Bold</FontWeight>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox14</rd:DefaultName>
                                                              <ZIndex>25</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
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
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <FontWeight>Bold</FontWeight>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox17</rd:DefaultName>
                                                              <ZIndex>24</ZIndex>
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
                                                                  <Style>
                                                                    <TextAlign>Left</TextAlign>
                                                                  </Style>
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox7</rd:DefaultName>
                                                              <ZIndex>23</ZIndex>
                                                              <Style>
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
                                                              <rd:DefaultName>textbox39</rd:DefaultName>
                                                              <ZIndex>22</ZIndex>
                                                              <Style>
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
                                                                      <Style>
                                                                        <FontSize>7pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox40</rd:DefaultName>
                                                              <ZIndex>21</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox41</rd:DefaultName>
                                                              <ZIndex>20</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox42</rd:DefaultName>
                                                              <ZIndex>19</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Style>
                                                                        <FontSize>7pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox43</rd:DefaultName>
                                                              <ZIndex>18</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox44</rd:DefaultName>
                                                              <ZIndex>17</ZIndex>
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
                                                                      <Value>=Fields!StartBalance.Value</Value>
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <Format>=Fields!StartBalanceFormat.Value</Format>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style>
                                                                    <TextAlign>Right</TextAlign>
                                                                  </Style>
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox45</rd:DefaultName>
                                                              <ZIndex>16</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                            <Textbox Name="textbox81">
                                                              <CanGrow>true</CanGrow>
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!PostDate_DtldCustLedgEntries.Value</Value>
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
                                                              <rd:DefaultName>textbox81</rd:DefaultName>
                                                              <ZIndex>7</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Value>=Fields!DocNo_DtldCustLedgEntries.Value</Value>
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
                                                              <rd:DefaultName>textbox83</rd:DefaultName>
                                                              <ZIndex>6</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
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
                                                                      <Value>=Fields!Description.Value</Value>
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
                                                              <rd:DefaultName>textbox84</rd:DefaultName>
                                                              <ZIndex>5</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="textbox85">
                                                              <CanGrow>true</CanGrow>
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!DueDate_DtldCustLedgEntries.Value</Value>
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
                                                              <rd:DefaultName>textbox85</rd:DefaultName>
                                                              <ZIndex>4</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Value>=Fields!CurrCode_DtldCustLedgEntries.Value</Value>
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
                                                              <rd:DefaultName>textbox108</rd:DefaultName>
                                                              <ZIndex>3</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                                      <Value>=Fields!Amt_DtldCustLedgEntries.Value</Value>
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <Format>=Fields!Amt_DtldCustLedgEntriesFormat.Value</Format>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style>
                                                                    <TextAlign>Right</TextAlign>
                                                                  </Style>
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox86</rd:DefaultName>
                                                              <ZIndex>2</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Value>=Fields!RemainAmt_DtldCustLedgEntries.Value</Value>
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <Format>=Fields!RemainAmt_DtldCustLedgEntriesFormat.Value</Format>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style>
                                                                    <TextAlign>Right</TextAlign>
                                                                  </Style>
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox87</rd:DefaultName>
                                                              <ZIndex>1</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Value>=Fields!CustBalance.Value</Value>
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <Format>=Fields!CustBalanceFormat.Value</Format>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style>
                                                                    <TextAlign>Right</TextAlign>
                                                                  </Style>
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox88</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                                  <Style>
                                                                    <TextAlign>Right</TextAlign>
                                                                  </Style>
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>Textbox68</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox69">
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
                                                              <rd:DefaultName>Textbox69</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox70">
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
                                                              <rd:DefaultName>Textbox70</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox71">
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
                                                              <rd:DefaultName>Textbox71</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                              <rd:DefaultName>Textbox72</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox73">
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
                                                              <rd:DefaultName>Textbox73</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox74">
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
                                                              <rd:DefaultName>Textbox74</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox75">
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
                                                              <rd:DefaultName>Textbox75</rd:DefaultName>
                                                              <Style>
                                                                <Border>
                                                                  <Style>None</Style>
                                                                </Border>
                                                                <BottomBorder>
                                                                  <Style>Solid</Style>
                                                                </BottomBorder>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                            <Textbox Name="Textbox76">
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
                                                              <rd:DefaultName>Textbox76</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox77">
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
                                                              <rd:DefaultName>Textbox77</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox78">
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
                                                              <rd:DefaultName>Textbox78</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox79">
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
                                                              <rd:DefaultName>Textbox79</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                              <rd:DefaultName>Textbox80</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox82">
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
                                                              <rd:DefaultName>Textbox82</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox89">
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
                                                              <rd:DefaultName>Textbox89</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox90">
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
                                                              <rd:DefaultName>Textbox90</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                            <Textbox Name="textbox18">
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
                                                              <rd:DefaultName>textbox18</rd:DefaultName>
                                                              <ZIndex>15</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
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
                                                              <rd:DefaultName>textbox19</rd:DefaultName>
                                                              <ZIndex>14</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                              <rd:DefaultName>textbox20</rd:DefaultName>
                                                              <ZIndex>13</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
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
                                                              <rd:DefaultName>textbox25</rd:DefaultName>
                                                              <ZIndex>12</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                              <rd:DefaultName>textbox26</rd:DefaultName>
                                                              <ZIndex>11</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                              <rd:DefaultName>textbox28</rd:DefaultName>
                                                              <ZIndex>10</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Value>=LAST(Fields!Total_Caption3.Value) &amp; " " &amp;LAST(Fields!CurrencyCode3.Value)</Value>
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
                                                              <rd:DefaultName>textbox29</rd:DefaultName>
                                                              <ZIndex>9</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                                      <Value>=LAST(Fields!CustBalance_CustLedgEntryHdr.Value)</Value>
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <FontWeight>Bold</FontWeight>
                                                                        <Format>=LAST(Fields!CustBalance_CustLedgEntryHdrFormat.Value)</Format>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style>
                                                                    <TextAlign>Right</TextAlign>
                                                                  </Style>
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox30</rd:DefaultName>
                                                              <ZIndex>8</ZIndex>
                                                              <Style>
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
                                                      <Group Name="Table1_CurrencyGroup">
                                                        <GroupExpressions>
                                                          <GroupExpression>=Fields!CurrencyCode3.Value</GroupExpression>
                                                        </GroupExpressions>
                                                      </Group>
                                                      <TablixMembers>
                                                        <TablixMember>
                                                          <Group Name="Table1_Details_Group">
                                                            <DataElementName>Detail</DataElementName>
                                                          </Group>
                                                          <TablixMembers>
                                                            <TablixMember>
                                                              <Visibility>
                                                                <Hidden>=IIF((Fields!DocNo_DtldCustLedgEntries.Value="") OR (Fields!PrintLine.Value=FALSE AND Fields!DtldCustLedgEntryType.Value="2") OR NOT Fields!IsNewCustCurrencyGroup.Value,TRUE,FALSE)</Hidden>
                                                              </Visibility>
                                                              <KeepWithGroup>After</KeepWithGroup>
                                                              <RepeatOnNewPage>true</RepeatOnNewPage>
                                                              <KeepTogether>true</KeepTogether>
                                                            </TablixMember>
                                                            <TablixMember>
                                                              <Visibility>
                                                                <Hidden>=IIF((Fields!DocNo_DtldCustLedgEntries.Value="") OR (Fields!PrintLine.Value=FALSE AND Fields!DtldCustLedgEntryType.Value="2") OR NOT Fields!IsNewCustCurrencyGroup.Value,TRUE,FALSE)</Hidden>
                                                              </Visibility>
                                                              <KeepWithGroup>After</KeepWithGroup>
                                                              <RepeatOnNewPage>true</RepeatOnNewPage>
                                                              <KeepTogether>true</KeepTogether>
                                                            </TablixMember>
                                                            <TablixMember>
                                                              <Visibility>
                                                                <Hidden>=IIF(Fields!DocNo_DtldCustLedgEntries.Value="",TRUE,FALSE) OR IIF(Fields!PrintLine.Value=FALSE AND Fields!DtldCustLedgEntryType.Value="2",TRUE,FALSE)</Hidden>
                                                              </Visibility>
                                                            </TablixMember>
                                                          </TablixMembers>
                                                          <DataElementName>Detail_Collection</DataElementName>
                                                          <DataElementOutput>Output</DataElementOutput>
                                                          <KeepTogether>true</KeepTogether>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF((Fields!EntriesExists.Value OR Fields!StartBalance.Value&gt;0),FALSE,TRUE)</Hidden>
                                                          </Visibility>
                                                          <KeepWithGroup>Before</KeepWithGroup>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF((Fields!EntriesExists.Value OR Fields!StartBalance.Value&gt;0),FALSE,TRUE)</Hidden>
                                                          </Visibility>
                                                          <KeepWithGroup>Before</KeepWithGroup>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF((Fields!EntriesExists.Value OR Fields!StartBalance.Value&gt;0),FALSE,TRUE)</Hidden>
                                                          </Visibility>
                                                          <KeepWithGroup>Before</KeepWithGroup>
                                                          <KeepTogether>true</KeepTogether>
                                                        </TablixMember>
                                                      </TablixMembers>
                                                    </TablixMember>
                                                  </TablixMembers>
                                                </TablixRowHierarchy>
                                                <Height>1.76388cm</Height>
                                                <Width>17.93863cm</Width>
                                                <Style />
                                              </Tablix>
                                              <Tablix Name="table2">
                                                <TablixBody>
                                                  <TablixColumns>
                                                    <TablixColumn>
                                                      <Width>2.04cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>1.98768cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>4.20624cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>1.98768cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>1.7749cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>1.97078cm</Width>
                                                    </TablixColumn>
                                                    <TablixColumn>
                                                      <Width>2.33464cm</Width>
                                                    </TablixColumn>
                                                  </TablixColumns>
                                                  <TablixRows>
                                                    <TablixRow>
                                                      <Height>0.35278cm</Height>
                                                      <TablixCells>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="textbox49">
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!OverDueEntries.Value</Value>
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
                                                              <ZIndex>19</ZIndex>
                                                              <Style>
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
                                                            <Textbox Name="textbox8">
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
                                                              <rd:DefaultName>textbox8</rd:DefaultName>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                              <rd:DefaultName>textbox9</rd:DefaultName>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox32</rd:DefaultName>
                                                              <ZIndex>16</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
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
                                                              <rd:DefaultName>textbox33</rd:DefaultName>
                                                              <ZIndex>15</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox34</rd:DefaultName>
                                                              <ZIndex>14</ZIndex>
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
                                                            <Textbox Name="textbox113">
                                                              <CanGrow>true</CanGrow>
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!PostDate_CustLedgEntry2.Value</Value>
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
                                                              <rd:DefaultName>textbox113</rd:DefaultName>
                                                              <ZIndex>6</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                                      <Value>=Fields!DocNo_CustLedgEntry2.Value</Value>
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
                                                              <rd:DefaultName>textbox114</rd:DefaultName>
                                                              <ZIndex>5</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Value>=Fields!Desc_CustLedgEntry2.Value</Value>
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
                                                              <rd:DefaultName>textbox115</rd:DefaultName>
                                                              <ZIndex>4</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="textbox120">
                                                              <CanGrow>true</CanGrow>
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!DueDate_CustLedgEntry2.Value</Value>
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
                                                              <rd:DefaultName>textbox120</rd:DefaultName>
                                                              <ZIndex>3</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="textbox123">
                                                              <CanGrow>true</CanGrow>
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!CurrCode_CustLedgEntry2.Value</Value>
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
                                                              <rd:DefaultName>textbox123</rd:DefaultName>
                                                              <ZIndex>2</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="textbox126">
                                                              <CanGrow>true</CanGrow>
                                                              <KeepTogether>true</KeepTogether>
                                                              <Paragraphs>
                                                                <Paragraph>
                                                                  <TextRuns>
                                                                    <TextRun>
                                                                      <Value>=Fields!OriginalAmt_CustLedgEntry2.Value</Value>
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <Format>=Fields!OriginalAmt_CustLedgEntry2Format.Value</Format>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style>
                                                                    <TextAlign>Right</TextAlign>
                                                                  </Style>
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox126</rd:DefaultName>
                                                              <ZIndex>1</ZIndex>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Value>=Fields!RemainAmt_CustLedgEntry2.Value</Value>
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <Format>=Fields!RemainAmt_CustLedgEntry2Format.Value</Format>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style>
                                                                    <TextAlign>Right</TextAlign>
                                                                  </Style>
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox129</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                            <Textbox Name="Textbox91">
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
                                                              <rd:DefaultName>Textbox91</rd:DefaultName>
                                                              <Style>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox92">
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
                                                              <rd:DefaultName>Textbox92</rd:DefaultName>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox93">
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
                                                              <rd:DefaultName>Textbox93</rd:DefaultName>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox94">
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
                                                              <rd:DefaultName>Textbox94</rd:DefaultName>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox95">
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
                                                              <rd:DefaultName>Textbox95</rd:DefaultName>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox96">
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
                                                              <rd:DefaultName>Textbox96</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox97">
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
                                                              <rd:DefaultName>Textbox97</rd:DefaultName>
                                                              <Style>
                                                                <Border>
                                                                  <Style>None</Style>
                                                                </Border>
                                                                <BottomBorder>
                                                                  <Style>Solid</Style>
                                                                </BottomBorder>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                            <Textbox Name="Textbox98">
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
                                                              <rd:DefaultName>Textbox98</rd:DefaultName>
                                                              <Style>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox99">
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
                                                              <rd:DefaultName>Textbox99</rd:DefaultName>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox100">
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
                                                              <rd:DefaultName>Textbox100</rd:DefaultName>
                                                              <Style>
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
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>Textbox101</rd:DefaultName>
                                                              <Style>
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
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>Textbox102</rd:DefaultName>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
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
                                                                <VerticalAlign>Middle</VerticalAlign>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
                                                              </Style>
                                                            </Textbox>
                                                          </CellContents>
                                                        </TablixCell>
                                                        <TablixCell>
                                                          <CellContents>
                                                            <Textbox Name="Textbox104">
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
                                                              <rd:DefaultName>Textbox104</rd:DefaultName>
                                                              <Style>
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                            <Textbox Name="textbox35">
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
                                                              <rd:DefaultName>textbox35</rd:DefaultName>
                                                              <ZIndex>13</ZIndex>
                                                              <Style>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox36</rd:DefaultName>
                                                              <ZIndex>12</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
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
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox37</rd:DefaultName>
                                                              <ZIndex>11</ZIndex>
                                                              <Style>
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
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                      </Style>
                                                                    </TextRun>
                                                                  </TextRuns>
                                                                  <Style />
                                                                </Paragraph>
                                                              </Paragraphs>
                                                              <rd:DefaultName>textbox38</rd:DefaultName>
                                                              <ZIndex>10</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                              <ZIndex>9</ZIndex>
                                                              <Style>
                                                                <PaddingLeft>5pt</PaddingLeft>
                                                                <PaddingRight>5pt</PaddingRight>
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
                                                                      <Value>=(Fields!Total_Caption.Value) &amp;Fields!CurrencyCode3_CustLedgEntry2.Value</Value>
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
                                                                <VerticalAlign>Middle</VerticalAlign>
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
                                                                      <Value>=SUM(Fields!RemainAmt_CustLedgEntry2.Value)</Value>
                                                                      <Style>
                                                                        <FontFamily>Segoe UI</FontFamily>
                                                                        <FontSize>8pt</FontSize>
                                                                        <FontWeight>Bold</FontWeight>
                                                                        <Format>=Fields!RemainAmt_CustLedgEntry2Format.Value</Format>
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
                                                  </TablixMembers>
                                                </TablixColumnHierarchy>
                                                <TablixRowHierarchy>
                                                  <TablixMembers>
                                                    <TablixMember>
                                                      <Group Name="table2_Group1">
                                                        <GroupExpressions>
                                                          <GroupExpression>=Fields!CurrCode_CustLedgEntry2.Value</GroupExpression>
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
                                                            <TablixMember />
                                                          </TablixMembers>
                                                          <DataElementName>Detail_Collection</DataElementName>
                                                          <DataElementOutput>Output</DataElementOutput>
                                                          <KeepTogether>true</KeepTogether>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!CustNo_CustLedgEntry2.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                          <KeepWithGroup>Before</KeepWithGroup>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!CustNo_CustLedgEntry2.Value="",TRUE,FALSE)</Hidden>
                                                          </Visibility>
                                                          <KeepWithGroup>Before</KeepWithGroup>
                                                        </TablixMember>
                                                        <TablixMember>
                                                          <Visibility>
                                                            <Hidden>=IIF(Fields!CustNo_CustLedgEntry2.Value="",TRUE,FALSE)</Hidden>
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
                                                    <FilterExpression>=Fields!CustNo_CustLedgEntry2.Value</FilterExpression>
                                                    <Operator>GreaterThan</Operator>
                                                    <FilterValues>
                                                      <FilterValue>=""</FilterValue>
                                                    </FilterValues>
                                                  </Filter>
                                                </Filters>
                                                <Top>1.80947cm</Top>
                                                <Height>1.4111cm</Height>
                                                <Width>16.30192cm</Width>
                                                <ZIndex>1</ZIndex>
                                                <Visibility>
                                                  <Hidden>=IIF(Fields!CustNo_CustLedgEntry2.Value="",TRUE,FALSE) OR IIF(Fields!PrintEntriesDue.Value=FALSE,TRUE,FALSE)</Hidden>
                                                </Visibility>
                                                <DataElementOutput>NoOutput</DataElementOutput>
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
                                    <Group Name="list2_Details_Group">
                                      <GroupExpressions>
                                        <GroupExpression>=Fields!Currency2Code.Value</GroupExpression>
                                        <GroupExpression>=Fields!Currency2Code_CustLedgEntry2.Value</GroupExpression>
                                      </GroupExpressions>
                                    </Group>
                                    <DataElementOutput>Output</DataElementOutput>
                                    <KeepTogether>true</KeepTogether>
                                  </TablixMember>
                                </TablixMembers>
                              </TablixRowHierarchy>
                              <DataSetName>DataSet_Result</DataSetName>
                              <Top>0.03171cm</Top>
                              <Height>3.22057cm</Height>
                              <Width>17.93863cm</Width>
                              <ZIndex>2</ZIndex>
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
                      <GroupExpression>=Fields!No_Cust.Value</GroupExpression>
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
            <PageBreak>
              <BreakLocation>End</BreakLocation>
            </PageBreak>
            <Height>5.86059cm</Height>
            <Width>17.93863cm</Width>
            <Style />
          </Tablix>
        </ReportItems>
        <Height>2.30732in</Height>
        <Style />
      </Body>
      <Width>18cm</Width>
      <Page>
        <PageHeader>
          <Height>4.18764in</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="LastStatmntNo_CustCaption11">
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>190.50554pt</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>3.13051cm</Width>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="EndDateCaption11">
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.93812cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>3.13051cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="StartDateCaption11">
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.54687cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>3.13051cm</Width>
              <ZIndex>2</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_9_11">
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>179.0555pt</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>3.13051cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BankAccNo_CompanyInfoCaption11">
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>3.28834in</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>3.02467cm</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BankName_CompanyInfoCaption11">
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
              <Top>7.95433cm</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>3.02467cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="GiroNo_CompanyInfoCaption11">
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.5525cm</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>3.02467cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VATRegNo_CompanyInfoCaption11">
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>7.14537cm</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>3.02467cm</Width>
              <ZIndex>7</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PhoneNo_CompanyInfoCaption11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(42,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>5.9025cm</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>3.02467cm</Width>
              <ZIndex>8</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="StatementCaption11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(43,1)</Value>
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
              <Top>1.77271cm</Top>
              <Height>20pt</Height>
              <Width>17.93147cm</Width>
              <ZIndex>9</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr811">
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
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>5.4795cm</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>6.19252cm</Width>
              <ZIndex>10</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr711">
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
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>5.0565cm</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>6.19252cm</Width>
              <ZIndex>11</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr811">
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
              <Top>5.47354cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>11.70697cm</Width>
              <ZIndex>12</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr711">
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
              <Top>5.05054cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>11.70697cm</Width>
              <ZIndex>13</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="LastStatmntNo_Cust11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(33,1)</Value>
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
              <Top>190.50554pt</Top>
              <Left>3.20113cm</Left>
              <Height>11pt</Height>
              <Width>8.5059cm</Width>
              <ZIndex>14</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="EndDate11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(32,1)</Value>
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
              <Top>7.93812cm</Top>
              <Left>3.20113cm</Left>
              <Height>11pt</Height>
              <Width>8.5059cm</Width>
              <ZIndex>15</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="StartDate11">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(31,1)</Value>
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
              <Top>7.54687cm</Top>
              <Left>3.20113cm</Left>
              <Height>11pt</Height>
              <Width>8.5059cm</Width>
              <ZIndex>16</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr_10_11">
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
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>179.0555pt</Top>
              <Left>3.20113cm</Left>
              <Height>11pt</Height>
              <Width>8.5059cm</Width>
              <ZIndex>17</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BankAccNo_CompanyInfo11">
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
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>3.28834in</Top>
              <Left>14.75645cm</Left>
              <Height>11pt</Height>
              <Width>3.16787cm</Width>
              <ZIndex>18</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="BankName_CompanyInfo11">
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
              <Top>7.95433cm</Top>
              <Left>14.75645cm</Left>
              <Height>11pt</Height>
              <Width>3.16787cm</Width>
              <ZIndex>19</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="GiroNo_CompanyInfo11">
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
              <Top>7.5525cm</Top>
              <Left>14.75645cm</Left>
              <Height>11pt</Height>
              <Width>3.16787cm</Width>
              <ZIndex>20</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="VATRegNo_CompanyInfo11">
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
              <Top>7.14537cm</Top>
              <Left>14.75645cm</Left>
              <Height>11pt</Height>
              <Width>3.16787cm</Width>
              <ZIndex>21</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr611">
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
              <Top>4.62754cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>11.70697cm</Width>
              <ZIndex>22</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PhoneNo_CompanyInfo11">
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
              <Top>5.9025cm</Top>
              <Left>14.75645cm</Left>
              <Height>11pt</Height>
              <Width>3.16787cm</Width>
              <ZIndex>23</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr511">
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
              <Top>4.20454cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>11.70697cm</Width>
              <ZIndex>24</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr411">
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
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>4.6335cm</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>6.19252cm</Width>
              <ZIndex>25</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr411">
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
              <Top>3.78154cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>11.70697cm</Width>
              <ZIndex>26</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr311">
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
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>4.2105cm</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>6.19252cm</Width>
              <ZIndex>27</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr311">
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
              <Top>3.35854cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>11.70697cm</Width>
              <ZIndex>28</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr211">
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
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>3.7875cm</Top>
              <Left>11.7318cm</Left>
              <Height>11pt</Height>
              <Width>6.19252cm</Width>
              <ZIndex>29</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr211">
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
              <Top>2.93554cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>11.70697cm</Width>
              <ZIndex>30</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyAddr111">
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
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>3.35854cm</Top>
              <Left>11.7461cm</Left>
              <Height>11pt</Height>
              <Width>6.18537cm</Width>
              <ZIndex>31</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustAddr111">
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
              <Top>2.53455cm</Top>
              <Left>0.00007cm</Left>
              <Height>11pt</Height>
              <Width>11.70697cm</Width>
              <ZIndex>32</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="TodayFormatted1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(30,1)</Value>
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
              <Top>7.14537cm</Top>
              <Left>3.20113cm</Left>
              <Height>11pt</Height>
              <Width>8.5059cm</Width>
              <ZIndex>33</ZIndex>
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
                      <Value>=Code.GetGroupPageNumber(ReportItems!NewPage.Value, Globals!PageNumber)</Value>
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
              <Top>2.53455cm</Top>
              <Left>17.50681cm</Left>
              <Height>11pt</Height>
              <Width>0.42466cm</Width>
              <ZIndex>34</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingLeft>1pt</PaddingLeft>
              </Style>
            </Textbox>
            <Textbox Name="CurrReportPageNoCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!CurrReportPageNoCaption.Value</Value>
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
              <Top>2.53455cm</Top>
              <Left>11.7461cm</Left>
              <Height>11pt</Height>
              <Width>5.76071cm</Width>
              <ZIndex>35</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoHomePageCaption">
              <CanGrow>true</CanGrow>
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
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>179.0555pt</Top>
              <Left>332.55518pt</Left>
              <Height>11pt</Height>
              <Width>1.19081in</Width>
              <ZIndex>36</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoEmailCaption">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(45,1)</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>190.50554pt</Top>
              <Left>4.61733in</Left>
              <Height>11pt</Height>
              <Width>3.02843cm</Width>
              <ZIndex>37</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoHomePageValue">
              <CanGrow>true</CanGrow>
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
              <Top>179.0555pt</Top>
              <Left>14.75645cm</Left>
              <Height>11pt</Height>
              <Width>1.24719in</Width>
              <ZIndex>38</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Textbox Name="CompanyInfoEmailValue">
              <CanGrow>true</CanGrow>
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
              <Top>190.50554pt</Top>
              <Left>14.75645cm</Left>
              <Height>11pt</Height>
              <Width>1.24719in</Width>
              <ZIndex>39</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Textbox>
            <Image Name="Imageleft">
              <Source>Database</Source>
              <Value>=Convert.ToBase64String(Fields!CompanyInfo1Picture.Value)</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>40</ZIndex>
              <Visibility>
                <Hidden>=IIF(IsNothing(Fields!CompanyInfo1Picture.Value)=TRUE,TRUE,FALSE)</Hidden>
              </Visibility>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Image>
            <Image Name="ImageCenter">
              <Source>Database</Source>
              <Value>=Convert.ToBase64String(Fields!CompanyInfo2Picture.Value)</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Left>6cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>41</ZIndex>
              <Visibility>
                <Hidden>=IIF(ISNOTHING(Fields!CompanyInfo2Picture.Value) =  TRUE, TRUE, FALSE)</Hidden>
              </Visibility>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Image>
            <Image Name="ImageRight">
              <Source>Database</Source>
              <Value>=Convert.ToBase64String(Fields!CompanyInfo3Picture.Value)</Value>
              <MIMEType>image/bmp</MIMEType>
              <Sizing>FitProportional</Sizing>
              <Left>12cm</Left>
              <Height>14mm</Height>
              <Width>60mm</Width>
              <ZIndex>42</ZIndex>
              <Visibility>
                <Hidden>=IIF(ISNOTHING(Fields!CompanyInfo3Picture.Value) =  TRUE, TRUE, FALSE)</Hidden>
              </Visibility>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
              </Style>
            </Image>
            <Textbox Name="DocumentDateCaption">
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
              <Top>7.15881cm</Top>
              <Height>11pt</Height>
              <Width>3.13051cm</Width>
              <ZIndex>43</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox63">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(47,1)</Value>
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
              <Top>9.30244cm</Top>
              <Left>0.00714cm</Left>
              <Height>27.80009pt</Height>
              <Width>2.04cm</Width>
              <ZIndex>44</ZIndex>
              <Style>
                <VerticalAlign>Bottom</VerticalAlign>
                <PaddingRight>5pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="textbox64">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(48,1)</Value>
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
              <Top>9.30244cm</Top>
              <Left>2.04cm</Left>
              <Height>27.80002pt</Height>
              <Width>1.98767cm</Width>
              <ZIndex>45</ZIndex>
              <Style>
                <VerticalAlign>Bottom</VerticalAlign>
                <PaddingLeft>5pt</PaddingLeft>
                <PaddingRight>5pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="textbox65">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Code.GetData(49,1)</Value>
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
              <Top>9.30244cm</Top>
              <Left>4.02767cm</Left>
              <Height>27.80009pt</Height>
              <Width>4.20623cm</Width>
              <ZIndex>46</ZIndex>
              <Style>
                <VerticalAlign>Bottom</VerticalAlign>
                <PaddingLeft>5pt</PaddingLeft>
                <PaddingRight>5pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="textbox66">
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
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Top>9.30244cm</Top>
              <Left>8.2339cm</Left>
              <Height>27.80009pt</Height>
              <Width>1.9877cm</Width>
              <ZIndex>47</ZIndex>
              <Style>
                <VerticalAlign>Bottom</VerticalAlign>
                <PaddingLeft>5pt</PaddingLeft>
                <PaddingRight>5pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="textbox67">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= Replace(Code.GetData(51,1)," ",chr(10))</Value>
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
              <Top>9.30244cm</Top>
              <Left>12.01069cm</Left>
              <Height>27.80009pt</Height>
              <Width>1.81547cm</Width>
              <ZIndex>48</ZIndex>
              <Style>
                <VerticalAlign>Bottom</VerticalAlign>
                <PaddingLeft>5pt</PaddingLeft>
                <PaddingRight>5pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="textbox68">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= Replace(Code.GetData(52,1)," ",chr(10))</Value>
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
              <Top>9.30244cm</Top>
              <Left>13.89671cm</Left>
              <Height>27.80009pt</Height>
              <Width>2.40522cm</Width>
              <ZIndex>49</ZIndex>
              <Style>
                <VerticalAlign>Bottom</VerticalAlign>
                <PaddingLeft>5pt</PaddingLeft>
                <PaddingRight>5pt</PaddingRight>
              </Style>
            </Textbox>
            <Textbox Name="textbox69">
              <CanGrow>true</CanGrow>
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>= Code.GetData(53,1)</Value>
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
              <Top>9.30244cm</Top>
              <Left>16.30193cm</Left>
              <Height>27.80009pt</Height>
              <Width>1.63668cm</Width>
              <ZIndex>50</ZIndex>
              <Style>
                <VerticalAlign>Bottom</VerticalAlign>
                <PaddingLeft>5pt</PaddingLeft>
              </Style>
            </Textbox>
            <Textbox Name="Textbox320">
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
                    <TextAlign>Center</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <rd:DefaultName>Textbox320</rd:DefaultName>
              <Top>4.04597in</Top>
              <Left>0.00281in</Left>
              <Height>5pt</Height>
              <Width>7.05683in</Width>
              <ZIndex>51</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <BottomBorder>
                  <Style>Solid</Style>
                </BottomBorder>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="Textbox321">
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
                    <TextAlign>Center</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <rd:DefaultName>Textbox320</rd:DefaultName>
              <Top>4.11819in</Top>
              <Height>5pt</Height>
              <Width>7.05683in</Width>
              <ZIndex>52</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <BottomBorder>
                  <Style>None</Style>
                </BottomBorder>
                <VerticalAlign>Middle</VerticalAlign>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
            <Textbox Name="Textbox293">
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
              <rd:DefaultName>Textbox293</rd:DefaultName>
              <Top>3.28834in</Top>
              <Height>10pt</Height>
              <Width>4.61056in</Width>
              <ZIndex>53</ZIndex>
              <Style>
                <Border>
                  <Style>None</Style>
                </Border>
                <PaddingLeft>2pt</PaddingLeft>
                <PaddingRight>2pt</PaddingRight>
                <PaddingTop>2pt</PaddingTop>
                <PaddingBottom>2pt</PaddingBottom>
              </Style>
            </Textbox>
          </ReportItems>
          <Style />
        </PageHeader>
        <PageHeight>11.69in</PageHeight>
        <PageWidth>8.27in</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>0.69444in</LeftMargin>
        <RightMargin>0.41667in</RightMargin>
        <TopMargin>0.41667in</TopMargin>
        <BottomMargin>0.58333in</BottomMargin>
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
  If Group = 1 and NewData &lt;&gt; "" Then
      Data1 = NewData
  End If

  If Group = 2 and NewData &lt;&gt; "" Then
      Data2 = NewData
  End If

  If Group = 3 and NewData &lt;&gt; "" Then
      Data3 = NewData
  End If

  If Group = 4 and NewData &lt;&gt; "" Then
      Data4 = NewData
  End If
  Return True
End Function

    Shared offset as Integer
    Shared newPage as Object
    Shared currentgroup1 as Object

    Public Function GetGroupPageNumber(NewPage as Boolean, pagenumber as Integer) as Object
    If NewPage
    offset = pagenumber - 1
    End If
    Return pagenumber - offset
    End Function

    Public Function IsNewPage(group1 as Object) As Boolean
    newPage = FALSE
    If Not (group1 = currentgroup1)
    newPage = TRUE
    currentgroup1 = group1
    End If
    Return newPage
    End Function
  </Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Inch</rd:ReportUnitType>
  <rd:ReportID>0cf80e7c-8d6e-450a-8c70-f965a950f850</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
  WORDLAYOUT
  {
    UEsDBBQABgAIAAAAIQCUCR0sxgEAAKsKAAATAAgCW0NvbnRlbnRfVHlwZXNdLnhtbCCiBAIooAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzJZPT+MwEMXvSHyHyFfUuHBYoVVTDrtwBCRA4mrsSQ==
    aq3/yTMF+u3XTtosYgupthvgEinxvPd+ySTOzM6erSkeIaL2rmLH5ZQV4KRX2jUVu7u9mJyyAkk4JYx3ULEVIDubHx7MblcBsEhqhxVbEIXvnKNcgBVY+gAurdQ+WkHpNDY8CA==
    +Us0wE+m029cekfgaELZg81nP6EWS0PF+XO63JEE17DiR1eXoyqmbdbn63yrIoLBVxIRgtFSUFrnj0694pqsmcqkbGtwoQMepYI3EvLK2wFr3VV6mFErKK5FpEthUxV/8lFx5Q==
    5dImZfm+zRZOX9daQq/PbiF6CYipS9aU/YoV2m34t3HIJZK399ZwTWCvow94vDdOb5r9IJKG/hnuyHDy0QxtP5BWBvD/d6PzHY4HoiQYA2DtPIjwBA83o1G8MB8Eqb0n52mMbg==
    9NaDEODUSAwb50GEBQgFcf9P8i+CzniHPqQ88WBgjD6srQchGuMRRVx9xIa5ydod6pN3jT8cn7999CxfZh/pib7Ei0xpGILuuP8n3dq8F5kq259pGq7iP9z2ZhbK6knY6S/aJw==
    Juu97w/ymKVAbcnm7ag5/w0AAP//AwBQSwMEFAAGAAgAAAAhAB6RGrfvAAAATgIAAAsACAJfcmVscy8ucmVscyCiBAIooAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAArJLBasMwDEDvg/2D0b1R2g==
    wRijTi9j0NsY2QcIW0lME9vYatf+/TzY2AJd6WFHy9LTk9B6c5xGdeCUXfAallUNir0J1vlew1v7vHgAlYW8pTF41nDiDJvm9mb9yiNJKcqDi1kVis8aBpH4iJjNwBPlKkT25Q==
    pwtpIinP1GMks6OecVXX95h+M6CZMdXWakhbeweqPUW+hh26zhl+CmY/sZczLZCPwt6yXcRU6pO4Mo1qKfUsGmwwLyWckWKsChrwvNHqeqO/p8WJhSwJoQmJL/t8ZlwSWv7nig==
    5hk/Nu8hWbRf4W8bnF1B8wEAAP//AwBQSwMEFAAGAAgAAAAhALFxJT5eAQAA8AYAABwACAF3b3JkL19yZWxzL2RvY3VtZW50LnhtbC5yZWxzIKIEASigAAEAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAvJVPT4QwEMXvJn4H0rsUUNc/WdiLMdmrronXLh2gkbaknVX59jYiLKtr46HxOG/aeb+80rJcvQ==
    yzZ6BWOFVjlJ44REoErNhapz8rS5P7smkUWmOGu1gpz0YMmqOD1ZPkDL0G2yjehs5KYom5MGsbul1JYNSGZj3YFynUobydCVpqYdK19YDTRLkgU18xmkOJgZrXlOzJo7/03fwQ==
    X2brqhIl3OlyJ0HhEQsqpPN2A5mpAXMigQs2iGncqZrQ4wznIRks9q0LcYIY6tjN+c3+KqQ9KK40zgFGxYeQZiEZ0O2dHcNnOYipDyIoQ7mzqOWzc5s44nivUoEgM28k/03jzQ==
    ZhGSptIav30kk+SNJGgmdautZaYf1+xhxg7lXy0f1GVIpjfYPgKiex1n2cxEbzpJ2DNSuGHbdnaPJslHcRH0LfuRxaj4EG5CIjTAOJg9wFBPd4Ue/KeKDwAAAP//AwBQSwMEFA==
    AAYACAAMQEZLwSxBTUYcAABB9gEAEQAAAHdvcmQvZG9jdW1lbnQueG1s7V3rktpKkn6Vjt4f82cZ6n7pOO0NcTt2hM8Zh+09MxsbGw41qLtZAyKEuu2eiXmy/bGPtK+wVbohgQ==
    BAIJEFCOcINKUiFVVX5fVlZm1v/9z//+8m8/p5ObV8dbjN3Z/S38M7i9cWZDdzSePd3fvviPLXF7s/Dt2cieuDPn/vbNWdz+27tfftyN3OHL1Jn5N6qC2eLOvr999v35Xbu9GA==
    PjtTe/Fnd+7M1LlH15vavjr0ntojz/6hKp5O2ggA1p7a49ltdP98PNyjBnWX/+I5cSU2JGuVTMdDz124j/6fh+607T4+jodOXI2qBILMY/yYrz9Gbg0/XG8U3q6/zT136CwWqg==
    yq49e7UXcXXDnzs/D2kPn23Pd34u64A7V0Lbsi3WK0J7VKTeEMH1qvDOVbG2fqq1inbvMV2Reqq1muh+NeW8HNuvJrReE9+vJrxek9ivprXhNC0lZ1Pb+/4yb6mK57Y/fhhPxg==
    /lsgcomojWff93gidVdSwxSPdq6Bt6fuyJngUVyLq1DKm91F97eS+/Wj34X3Rx/xHV6Z9w9v6UUYF4KN50xUW7izxfN4nkj4dN/a1MnnuJLXTS/xOp0s0akswBXBUy9symWFew==
    gO7mGiEo0SO6iuSOMo+Q/c08AvmxX9OkGheWBJC4ArRWAVs4u1VBoyrai7fpUkR/zJ+q9fKvnvsyX9Y2rlbbh6XM/pjt9oLRaEmP4EW1h/nybM+VKE+Hdx+eZq5nP0zUE6m+vw==
    Ud13E/TAjZaSW62iPLijN/25GPnRxydPf/Gij4E78xc3P+7sxXCs2uiL8+Q6N//+4VYVPVuzxUrRcJE+br/7pZ3UZE/Gtq7o1Z7c3/7L7/br3U27+7Lw3anjBZf+uPPtp+wFXw==
    AqXKG31TX3wnwAWIIYsuH4/iqyHBDFPIojOQ3o1s3+6MZ1pFUxfNPedx/PM3ez5Xx+oRw3aeLcD9n7QYLsVv9Daz1dGiNbNfFZbNXc9ftAueov0n/cY/FfY/39+2VWV36pn/qg==
    OuJzcN/fppNPilT+E/5XcG75qqqRfddzPqiqPvTub//R59CiXUlasodwi9BupyW6wmpJznoIdEiHcvTP5MXUQzkKYVUnO0MNtFEjJ/2mvvRno09e2ETqqKs6UD3yUfp42SMtSA==
    OYNSSBx11sQdfo9PDsNH+qiKnFF0fj6xh86zOxk5XqQ569aL7+g5j/bLxP+0vOgbBAIKJign8UOsVPGkBbyhzQMlgRhjKSq/vch/+5yRogfcLs0xVz+vpjyjz/e3AAwgJoDcRg==
    RZ90UR8g3Idx0efoIVMXB5WEvzP/4r9NnPh9fne/zO1hQIjh29tPTsdz7O8dR/GZExbW3Prt6Fn0Z4A1D5PoI/wd9SXzjF81av7qjePxqc7/VZ1TRAz07/hvc4Wp9ovvLs93lA==
    7KtJYnDkzuOKZmpKGDyZO3G9+BbV1n+PalqopnCC76GcOI/+nrc+uL6CmD1v9sZPz/v+8Fh1w8h5X+nuP/a6u73W8A+Tj/ab++InfaSA30l14kfXTXAIECuo8nHsLfzPrurbYA==
    OE/s6Gh5sutOXqaz1Pm4ILhk5r7vKIpIjv4Ij2DqEZNBpodUiE7jkaokHFJQyLg1ditvZ+r0vVgYP3laDjlAjPNEQnUR5XjQYXHR1+AyDSWC3R4QAnX3JdDHkqLuYqWwnLbQ/g==
    oDDqSX2qyUJPMXLXnmt8q6pEIEl1OwBZCpOtQR90BAEW4ANCSd+SA2INCOr1Oe92B0Wk1Fi9JD6O2jY+zDaxKq2kv9ypOba/Cwf5w/BvJD7Dv6bHfyzho592IgzRlfMdBSEgtA==
    LlZF/TxCiy5OEdqJBKO9ZFTPdR/7npe0wmLuTBSFqa6NET23DU4q1f677HgKuiy8oPid1OBIhCnq5HgAJSOlnUBX5RFTMDiyRY0eHJmGOjdM/+qO7LdBYNXwl7y9L6a3EBBczQ==
    QoCWfoPq8WG2kQ2qN0RwzxbVs+OpdlTXZ71rVHATCKhJxW1BICmWjDBs4HB5uNrMBhANIFYDxNURZRRdo+iuYPtHe+HrYTKd+b+73/TpyqsgiGmDO8DIgPvycL2dDbw3RH7PFg==
    3tfHlNF5a9R5Pb9Gsy7EgEsBJDYqb1blzbSywUSDiZVV3syIMiqvUXmLoL0qpgvOAeGMGqNuHqQbLG+IsJ4/lhu1ti7sU41Uo1LbkpJhoib71CDg8jDbxtcKg50uw4CeGwyeGA==
    8bJDx+iuRnfNx++qwI04AlQAzgxur+H2tQJ24wT1bPXWaCAdSmvVH4nbePSROPaqlrsJ3bcHnjv9qoaiHknBQAp8q9dKXx3Pt2bDZ+3lrEdu0DCu9/e4bGp7Tzp0K6z9b1/mzg==
    8P42qCou+w+lCAoY+6uW8FDPOD+rf/q6pfNzcLjB+Tk5X8b5Oe2fvNn5GQNIUhcXOTP3O4BCnJGyroBdlgheOEGIysIaoh/23jtp73YU2Q3ay0uOwUUibwyLfbioqyNOZ2+f4g==
    wO6Kcwku1CBilMZzicWzq6MVP02G70cRbp4bo2RbqDKxRCH0NXBLONjL6nvZAb6FRlIjv1TUzYnG+JJk6pW0mftJ4/x+YhdF76qv87vxbDKeOTej8cL/GuCY/tZJvn1Mvn0OMQ==
    bw7JnR1g9geFe8TifdJlNDrhjMa+LmYWoRYXQVDU/E6hvc4KoTMfQM6xxEoqh2+pg3Z42eOjM/T74cWT4Nf84K8X/H1IYmjmgeLo3YzVLymIVEKnBlc0+G9wfM3w99dfPXv+PA==
    Hg48dYV+c1tB8bJEB+QtKueqmLndZ3v25FiKZof+Mgxm8wNU/dlUVUoFsG9evPWI3vK5Mt79or5psa8l80ZY2+xV9Yh+Z32gmiLqL5DfX/FF4S22foKwe3KaNynyPPfHs2OPFg==
    Satnq2mvPcfDZDwfjCcT/RP6+41350wfHPVcajSLoFXVYP248KNvYbv+AwkLAIk6rS4F3RYBvN+yJOEtDvqcAKKQCHb/qe9WIvCy0APLnvTm4xpSkIS6S/hywRPFn8EztsO30A==
    D7vwhp9VA+kL1YHvOf7wWX99VG8bn2inzrSzzaGPFlqne/jxmzuKNSldwc9Hb6o/1TPe/Aye5S1+orCJNop1e1nBXOlWvzru9EZ/UQ2uHir4AftVvUt0bXyNLp+5+tHC35nMsg==
    Je2wqB0/dvRV/Q/OpSQjfRyKZQh4ARwmOBjqzpUsugdV2A5Gr5miM6bXdhTnepaarTUaebCyXgvVjJRIAlm5ZULawZ0el/0BppBwiEXHotaAcYv0MJRUXoixJd3ER7e4zHeEiA==
    i1N5c9//pHLpv0uPiIzpJIH/ItwfHgX+IQGr8H+2qIaqoxpkhDOJMDGolotqqCl25PLKiEHDRqIhykfD0yrDVIhVNDzu+CvUkKUAcADOaPydLYvgqizCdO4hDkU595Hr4xB8dA==
    DimNF82BR7wKj/meD2fyZto2FScXUmN14Xivzu27m5W1xLOFDFIVMlqQEAYpVn8MaOSCBjGgsR00SBnQWFW1sovv2xLTkT7FPNclaj0xXUOsdCYb3cVmo2tivjnMQJn8cTl4kg==
    Fbdw0oIZs9SMdNNMhIEdvBz7Xd6DICPS2aK0SEdnzmXScaZmeVVQi00eckClQJiWC8ZEHUSsDmW4owZdRw46mFPI+1wMulYXF+U+PT8dIm7eBtrjc/i12AK1a+LXk1sAmmmBig==
    h8NBjfFbkPw8Aaq6eZ1LCJGQspyD9pUBVHNM66UVCgNszQO2w9rVLxLYKlt8WxBJQTGl0CBbDrId3+BrkO0CkW3NJH5MZDvqiCo2spllwKMwQmWDPuREMokIBoYQ1gmhicb8FA==
    VjcA60pZ8s/mtfKX//71zNf/oq6iVbGihQkjEiNgsCIHK6jBii1YQa8AK2426n5GyTNKXnng/vTszhydWjRcOP8we3RryhzEKBeQI1QuJuJKgLy4uY+/IlM+80Jj8PBdcfutqA==
    T1tTMWzhhca88iV6i+X0YuU5JuKEEMbKZSS/XrQxMLMnzNSBLyW9zQoVJyYAQ4OM4pQtSitO0ZlzUZxif5WVVrAEHyAr0wqQ0V4PlmyF6OJjt8K+7ncfdS4I7YJHWtZwqAZP4g==
    CJP44Ukh6boC/uNcNyTFJLYZZMtpYi3MljOUW04oyivmHOfXnlBItpwkIbzZcihR6pWK3NhyBmveJEv2WS+eZEXjbTh7zIwDCJb/duun/NxJ7mj0R6qjnFdnlj5Wp9+vnE4fxw==
    vz5Y+6H4zMfVH4yecP2O6MTKDe1MmNGZaTPuIkhh+63nT0b67Edn9NSf+d7YWdS2nRZFEBGIRbl9vK9Fv9ne8idebV2Va0VIBXK9LSdaPv6egVynbEch2Je3HUkIOxvxtKlLzg==
    D0l/VzQm7ZwekVHa7Z1ef94umLvq0yUy354XbfTcoZphHJAzKKcCMWhWUla2Gd/Y6k3xzgn13/JQuVX1rBkqjcJ6+inzHvQQDZMT08M2ITTc4CyG39Jt84Zqm0kwTAUHSBhaSA==
    00JhgzeGEALDhyEEQwg7+Kw2BO4LhWtnJ9azA/IXJ5gHHQTLESAEIAhEuQRd1wLlm5q8MWiOUK4RX1udFa7Okj4zKG9Q/kxQfpPcXTzQ/8UbP41n9sSa+odS3DnEHHEAjYtDCg==
    7be2e2MQP1hybK7+/t/D+Ey084vBe4P3m/B+q+RdPOZ/dvROAer9DwP4lAut4QuTwSSF95vbvDFgT8LEpQbsDdhfBNhvFruLR3pd0LEn9mxY177KkCBEMeCyXI7LK0H39XZuDA==
    ogcegAbRDaJfzSrtujDWvi6bhCsejA4e4heMR8PD8p33c84qTRme58yGbx9dd16ZLAAkVBv7ox1YIT1DZE83RwVAV++untuxffWmX5yhHpa7wPtZDbR0WDwFjEIJyy31RETyaQ==
    edE3CAQUTNAiXSGnXXX37ESd293hwQDhroiLQnd4OuBSwo3u8CFjwT3cZivyFjwZb6Xc4Y1LcbFLMZEkZ6a9vpBGdtfXsmM10NesAcYkKWpEmHr9uLNUXM5tkrakmHZmnvp+tA==
    PIu67mhlkUqdrszQkEgogMSyFD6DwcDqyf5A9lGXdAdWZ9AbsB4HAyl7PWJdznRu2SPpW9Itv3ptfv+cOu9JTiRCBA+HFeZ9tPZN7bhqqdkapboOAjXIYjD1iaYWVSUPA8QYwg==
    pJzgbVKMyBVKXbonmmJqUZQu6qB0ygAagG2UXmyCSQn4ZkpvbTK5XKfquq/lI+qzEMrSg9OYHuoC3xy3+8pLlZwjRBSOwouwT2wDzdwWNCaNXU0ahCMGCAPlVkAaa9LYEuF/Vg==
    vXMYeNkYIV/dTYIxIgg3bnE1wlmZAHsTWd8gM5iJrD98ZP0AMNlv3Hx/k4hefRzl7lRVGJpamacY5wQRzMrthGx4aheeKuy1ptg0jh3Ozwas06P7x/Wk/ESOa7UwjiKbOemkmA==
    uyFy31DN7lTjLIbeuB5vQsiRlBgCEwl6AHJZ9lNj6OTMkgEYOjkFnZycLJaCcwUe4jvDfxQve4C5BlLze0allGaucQA6KO63xtDDhWQXMLRhZiGbUg2YeUgdRKQDeA9AQhBTIQ==
    ESOGhA5AQgV91hgCaniyA0M0hmjKEE2BmBmS2ZlkkgDig1AN5ARSTrDZcbx+qtnYc40hnIYnXDCEYwinDOFsFDZDOzvTTiqGuSrJCCoIRwiY/Szr55hUNzWGURqe8MEwimGUMg==
    jJISrUPFUBSfzSedMk7Vgvf7NC6K9qamGHcGJk58zQnUe+/oAKS4ETCVCVaZCPKtrrOKOnLW0tcXS+geBJAZxeFG5wwzsbwqTQDhxaUJ4MTYtxIlWsCiSApcx0pUjzBpoW2Nqw==
    dIEBzmXXXcPzy6VTukq4qdH5uRL1HjCw5kgzmK+ub0++RbmV4vCV/R2MBUNUIo7L5Qu91kjobKOfLq/A/YE269tz9Prvsg2z6rCTr8ll3iZKjtKIt7lRg/FuoSBdsY4apwvHew==
    dW7f3axowOcPIZm59sB1/dQFOgEE/pZzRWWk4VISpYzTct6mEjHOBphxji0CsNXhDDChSojsdTHtXjDY5DT+6uWFvXTqlCc5KpccUD7oNkPC321twDIQtqLFXiogJCaAtYQwNQ==
    IYLAkFMGqTC6x75wsK2PztUwWm7qVmwYRX0MaL+qYdRM0k4ySTu2fbQCm2yTv2ZYT/VND5OMmBUsNZA+xZzVsdRQU+/kW5CS91EfUWc8TDKP83G88L/aDxOHtKzhULVGnDBEXQ==
    GGGSFDLX4Vld8dF+c1/85JxiDWeUOuu63xOgINYKQGxLip1v/py5aYGfuX8kcNCO+y950V+98Si2h6lKblLB/O318iCINKc8iAbKKYc8v1yK/HJQUB7X084880kzmwzdievFhQ==
    9ovvHm3d+S+vjjd6cf4YL8ZqTFbWnKCaSiGJoIzOXUjupNVWqqC4nHN6pLqG6XLAEESgxDL+gWYnTQo0O8BFT2aX8gZ9CDty41LeFW5VkFqwu4hBWxVbN+aNqs1srtgWK3lSJA==
    auaupQG9TIKoo9jYU8KRGbaD4F+gEz6rVurqc/e3D/bw+5PnvsxGMDNW29kKTd6psovnNeSdyvLDFmNApwOZ5Oecd2rFyip6jPTwqbd6KSPGq+bUy/YuXWGiwrwnddGQhBJiyQ==
    kCGh3Uloa+c0xnS6YxaoXgfjbi+Dlh3MES7rU7orWhod/HQglWKIE5PBVnG6biZwFsP8/Y5rmIpIjqFk6o9hgd1ZoLhjGoP/O6ZtysH/g2rLBv8N/odpmwoE6bqRP8o6chjwRw==
    gAnAkRAG+/fA/o1d0xj4D9bRDPwb+G80/G+UpatmgL9446fxzJ7o+OzDsAAEGFFCASsXZWxYIM0C27unMUwQeGAckQm6DIMK6cANE1wjE2yXp6tmgyRXx4GsQZRBRBhF1bf8vg==
    PirY0jdN4QGEaKnY463hsWamYPjhdMmKaiKHvRyiT+wrdXDWqb6oQISQWNAoK8S5O5hWwu0dXElTI+mhtKvQWQ3F1BiRAmIuCaw+66zHq/TyG//0fudcYMoBj0MHzhwWTut3fg==
    +eM1NXIQoAhiKWFTNu7dq/VrcVK/wtjCpjipH326n1Vyg7O9F6emDMYtRDlTWCyN3Xf3yX62Z9LXLjvoWE7oD8sBWxqJjH95oX95UWDnqoGEbzGQRJl29jaQ9HqQddk5+50fPw==
    Ert+DPffZYU6Y2GoMST7uqmtuicLRFwwAi85ojWfe44138gzMZ/VkE1PRJHAAEkOqueOaUhI61n1RN16cRJKVC+oQIAIRJRKk92wLgW5oKdOvDZm9N+0/rtrfGUWmXbXc6GFLQ==
    dvzUMBXWwHL1/MajbirkMit9V+1RsUIlYSBSvTxCOcWIihpsl4ZG0tGXjeKQvQMujw2fZhOPRnDISVEzDrg0PFDIA+sBSdWXPxETEmFecstAQwQliGC9mxrDAzsGXhoeMDzQiA==
    wEtDAykayA1MqsoEhEiKmCTGy7o2Hsjtp8ZQwY5BmIYKDBU0JQjTsEHK/6YwOKm6Lw6QGDCBgJkb1OaMU9hbjeGFHUMyDS8YXmhSSKbhhiU3LHdRr9tqRIDgDBFEDTPUxAxFfQ==
    1RReqCtE0/CF4YsThmhWZYs9YzOzflPZMGUTZbHTrt4IJwgTd69xnCl0nEGCl3Ic3wbbsE+tfjayPjuKw42nCYT5u3pHF5eG7fyNp0+MYxmAKGRKKsoxJdnS5B0Ku4Jva/KBxQ==
    Bv3O4ZrcgFCd4+6hVi+vaISc/gl/XM9Owyszrsxu0bFP7t4TKwygkBDBeNyZaVX5aVW2J067oXkf4x4bNEMwsxua41WNN19fzbwNokSghmx3fKUws2LY2bDncw3GHQqoQJhTEw==
    g1uXcWdTf50WqVLmlFMLycatzNdm6gXT78vaxXw172p42I+2zVbCFBdFW/ZWl32MASCcmw3M98m7utY9K2eiXmqKSXdXF5A+BF2e3bQsZ0JabLq1LCw6lU23ZuppdjDfFhq/lA==
    tRXF8HS7le9WnLe3ec4ySfHe5tHFpWWtpn7Lt5id2xKr9aQaRot6TUnGIGZYb2+Nokc8w0wA601SgcCaGuFfIXpf6Iz1CNbgPnu44P3GtNteQrgsCFTj5KgfCJH2EqzBrYEqQQ==
    lYAat4YiuV8rT6vFOX1ydF03Q5l9wiyMSqqnAOPT5DY6F5Vsd10sZ0Dsp5BVV6oSnUp9RI/3MMn076/eePTVVmOctKzhUN0cx0arC7ek4VJXfLTf3Bc/OafE2hmlzrru92QaQw==
    rJXpy7bk4PkL0TM3PR2ZuX8kk5V2rEMmL6rfTX/Va5Cqkmj+B3hMV9lynoSFZ8sFAPnlMr+coYLro3ramWc7abqYzKbp9ovvnpN+2cICUMgINOplk9XLY47D9OSDM0wE5rLBqg==
    adY/KmLimx39o65y94VV/yiClwRg/KO2JxYKOLCMDXR9YAb65EpGzQr65Bm7PIUaw4ZWvLypp9ZlCazM3JAAxgArm0S83+0K1JOU94AkXWR1ulYfd7pw0FEqQL9bANBnrw5snw==
    dYbdcdrZZg461DfbNGR3ejBsyIQ6HOv5ruuXEOFUFn5pZfRlFGMOGCqnGhvw3QC+1GCvwd7rwF5aHnq3Ks4CbHbBuEzkxpUVZ0ghFVxAaaC7MnRjozcb7L4S7MZGb3ZIVfClAA==
    A0ikKLdMbrB3k83CQK+B3uuAXlKn2iyvUW1GldVmpERPIoxAudgeA90boBsZtdlg95VgNzJqs1M5urslmKRYcGLW+qrbLAz2Guy9DuxdC9mvoDdvy/9/mchd3doMICUYUIJKIQ==
    N+UdKfoMUNoDxOogIZiCbU76UvQGA3rdyG20ZoPcV4LcRml2atjwFDCMCJPllGYDvZssFgZ6DfReB/QWZHbdqDRfFAI/OI9KyKOsX5UtF1BCLDAXJT3lBpIM+hwBimmHINzrDA==
    GOhY0BICSKvfQdeIwpkOaUwKmG3+RwbArwvAmx9TnJGj/aKJ68/vfdKYwRPQS2WtXjBOICDx1kIXELKaC/6VQP6c41j3j1cVlEDKuAClNI0zDle9wnRmqaDUsxqdtSasSWe5rA==
    rpjr0Y4AKxndbcwjG7LWpDvmoAp6arw/LMdoVh9LX7tJlTfh3Jn5TG44t4KO8cj5zfa+n2x2cw6KffyaYbZPNcTRANSdGbgiEKdSCqWltfZpwIUZg5Kjzsujkh1qTf2qzCMBog==
    TDBseKcy7yw7pTFmoW35HE5nFrpCrbkB7HFqo0+OrOQb+K8W00kNmA6xIAJRQM1aa02gTpoE6s219RtQN6AeyIoB9UyT4BpAnQKCGUHMQHo9kI4bBelb4uAMpBtIPyGkYwPpqw==
    kI5qgPQWhZBiCIztpSZMR03C9G0xGgbTDaafENORwfRVTIc1YDqBSGBAQLmcKgbTt2I6bBKmG9OLwfQGYzrcB9P3cpXUN+Xsbdfpki7vZ4d8X43sXt6QlwLAaGV6XiuZrPbTtg==
    sIHdXESdoQKQ4pfWrmi6VLEA7VjB2z07tgLuz86jo1e6nSWAhG1xe+MpArm/9T6M4pmAPh93+1A9w3j24r4sYkp5+vL3CI+gBAHAPGt9U2CRXPGbHayau3O9CAgCGQ2y0et7cA==
    4Frx4PoKspenJ85j6mz4yPe3HIhAal3XTx0+vfjBYSyHQ3eiuyvazzu4qB2xnd4VRtc+njmfxv5QPShmiRNZ2JbB1wd39BZ8Ufe8aBZ69/9QSwMEFAAGAAgADEBGS8WWCsOYBA==
    AABdEQAAEAAAAHdvcmQvaGVhZGVyMS54bWzVVttu4zYQ/RVBfdj2waEky5ZsrLPwLbt+6NZIumiBoljQEm1pI5EqSd+26Jf1oZ/UX+hQEiXbSlLb6UtjIOJtzsycuZB///nX2w==
    d7s0MTaEi5jRgWnfWKZBaMDCmK4G5louW75pCIlpiBNGycDcE2G+u3277UchN0CWiv42CwZmJGXWR0gEEUmxuEnjgDPBlvImYCliy2UcELRlPESOZVv5KOMsIEKAojGmGyzMEg==
    LtidhxZyvAVhBeiiIMJckl2NYV8M0kE95DeBnCuAwEPHbkK1L4bqImVVA8i9CgisaiB1rkN6wrnudUhOE8m7DqndRPKvQ2qkU9pMcJYRCptLxlMsYcpXKMX8cZ21ADjDMl7ESQ==
    LPeAaXU1DI7p4xUWgVSFkLbDixE8lLKQJO1QozCobE77pXyrklem9wv58qMl+Dn+FyITFqxTQmXuOeIkAS4YFVGcVRWeXosGm5EG2bzkxCZNzKo72WeWy3PtaVJQWQOeY37Jfw==
    mhSWv4xoW2dEREFUEueYcKxTW5JCFtaKr6LmgFz7zAaiAZwGQFeQyyA6JQQS+7Qu0W22el2U33O2zmq0+HVos7pmt/QyB8tsOcxg8TpjHiKcQSmnQX+2oozjRQIWQewNCJ+RRw==
    wFBVYqprXYSy/My5GsShse1vcDIwHcvv+J7d7cGLAKmtkAVzaJM/LL4czN7jJCF8r4XmeEWMj+t0AS8M49sfWWawpaEWvzsG+UTj39ZELaFjYHRgCwymNCzGvPgELGFcK/Pu1A==
    z4SpBJbIWO0NzAUOHlcQXBra1RYwEhIlUFohMhwAURqoa5mlKbkadKwaxmNGJXQlNctACF5P4f3AtKyh7905Q7NcmudLE8cdTvXS/YQs8TqRB4dzkAI5e5D7hGgrPhAwkpcWZg==
    ozA/smBSslQfUdFNiAIPCmcnPfW7gILisPg6MN18AETAqq3912q/BFolGBCVNpUxWBSzxVickFZ6lf+TKpk1fMaJIHxDzFtD/amzspB8KgVLNfwOSBdgBhZBDOX5QFaMGJ9myg==
    7GhIxclSIA7nqJEs9p079RpM4SCAuDZY8i2dKF+1fLtbLY3FySKqjMZJjKvdbz7iTd9A47WAEBKOZpBEK/g+SCyJuuXGOFOXZQks8epY8iF/h/PwcyUArx5b21FXast2O45nWQ==
    HVfvZQnwHrEE8umg6PT5Mifn9aHPtuXbftfveG6VCScQWOJRTMOiaiCgy3j3Pc4ymAPxReOiwhq8UfdafZ+Fe4phJloUb+BxkDEuBXrGL/RGhWEHj6loYCIA6wMLP0Fnu8/lfg==
    ThPlxC/2r/meZlXPS3L19JRjWM/zXTJOZrAzmwzM36eePeyMe26rN3HaLbczHrX8sT9s9bzuxLFG7qjjOX/o6JCdLKlpNKgyMY77BGdsOeUq/+Q+g5wSGUkSMItLXU66R8z5QQ==
    4/i/V4C8PaX+pNyfJgZ4NGt6Kx5R1R5O2aqb6X/GVu2q4z7hquOeuvpCjzv4O/H/eUf+He85KAVkDe2ePzoT6FwbFTCUwl17eiXwBbou4OMIQjWrFxLnhQv7yttZX3WV4gguzQ==
    fwBQSwMEFAAGAAgADEBGS3lTco5OAgAA+gkAABEAAAB3b3JkL2VuZG5vdGVzLnhtbM2WS3LiMBCGr+LSHmSbR4gLSKWGylR2qeQEiiyDKtajJBnD2WYxR5orTNv4wYwZypjNbA==
    sPXoT3+3utv8+vFz+XQQqbdnxnIlVygY+8hjkqqYy+0KZS4ZLZBnHZExSZVkK3RkFj2tl3nEZCyVY9YDgLRRrukK7ZzTEcaW7pggdiw4NcqqxI2pElglCacM58rEOPQDv3zTRg==
    UWYtnPaNyD2xqMLRQz9abEgOxgVwiumOGMcOLSO4GTLDj3jRBYUDQOBhGHRRk5tRc1yo6oCmg0CgqkOaDSNdcG4+jBR2SQ/DSJMuaTGM1Ekn0U1wpZmExUQZQRwMzRYLYr4yPQ==
    ArAmjn/ylLsjMP15jSFcfg1QBFYNQUzimwkPWKiYpZO4pigobyOjyn7U2BfSo5N99agtTB//TyYbRTPBpCs9x4alEAsl7Y7rpsLFUBos7mrI/poTe5GipjsFPcvlX+1pcwplCw==
    7CO/ir9IT8qvEwO/x40UiMaij4Q/z6yVCMjC9uBBoTkLbtCzgdSAsAOYW3YbYlYhsD2KtkRzvb3vlr8blemWxu+jvbY1m8vbHKyy5TyD7X1iPnZEQykLGr1upTLkMwVFcPceXA==
    n1fegFdUCTr7tnt55I4atlmmiSFOGQRTHJrPKCj3aRjCP4f4fYV8/3HhBy8+qqbeiqnnxcNL+FxPvW9YQrLUnW0uIW+meFhNKMiEvSRxDHpNiUp5Ebhw2gzes0I3yZxCHl4vcQ==
    Y3+C1EKrNXPaUf5WTl3yjyrpuMzKJvXxt6/+/+nqRc3X3G7f7fo3UEsDBBQABgAIAAxARkuCOaAYTgIAAAAKAAASAAAAd29yZC9mb290bm90ZXMueG1szZZLktowEIav4tIeZA==
    m+e4gKmpUJOa3RRzAo0sg2qsR0kyhrNlkSPlCmkb25CYUMZsssFIVn/6/5a64dePn4vng0i9PTOWK7lEwdBHHpNUxVxulyhzyWCOPOuIjEmqJFuiI7PoebXIo0QpJ5Vj1gOCtA==
    Ua7pEu2c0xHGlu6YIHYoODXKqsQNqRJYJQmnDOfKxDj0A7/8po2izFrY7huRe2JRhaOHbrTYkByCC+AY0x0xjh3OjOBuyAQ/4XkbFPYAgcMwaKNGd6OmuFDVAo17gUBVizTpRw==
    umJu2o8UtkmzfqRRmzTvR2pdJ9G+4EozCS8TZQRxMDRbLIj5yvQAwJo4/slT7o7A9Kc1hnD51UMRRDUEMYrvJsywUDFLR3FNUVDfRkZV/KCJL6RHp/jqUUeYLv5PIWtFM8GkKw==
    nWPDUsiFknbHdVPhoi8NXu5qyP6Wib1IUdOdgo7l8q/2tD6l8gzsIr/Kv0hPym8TA7/DiRSIJqKLhD/3rJUIuIXnjXul5iK5QccGUgPCFmBq2X2ISYXA9ijOJZrr7WOn/N2oTA==
    n2n8MdrbuWZzeZ/B6rZc3mD7mJiPHdFQyoJGb1upDPlMQRGcvQfH55Un4BVVgi5/3L08ckcN6yzTxBCnDIIpDt1nEJQLNQzhv0O8WSLff5r7wauPqqn3YuplPnsNX+qpzZolJA==
    S93F4hLyboqH1YSCTlhLEseg2ZSolBeZC8fNYJMVwknmFPLwaoGb+BOkFlq9M6cV5Wft6qpDqqTjMiv71Mffbv3/0+xVzTeNXwzs6jdQSwMECgAAAAAAAAAhAFQBBrnyAwAA8g==
    AwAAFQAAAHdvcmQvbWVkaWEvaW1hZ2UxLnBuZ4lQTkcNChoKAAAADUlIRFIAAADIAAAAyAgCAAAAIjo5yQAAAAFzUkdCAK7OHOkAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAOXSQ==
    REFUeF7t0rEVgkAAREG4BgjpvzvJsAA9DSiBHzFbwAb/zTrnPN7fxRS4r8C+jfV1fu479KTAVWAooUBRAKyiqs8FLAiSAmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTg==
    wWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUAA==
    K8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFg==
    A0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSQ==
    VqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSA==
    CoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOg==
    BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxUBSAKwkq1OwGEgKgJVkdQoWA0kBsJKsTsFiICkAVpLVKVgMJAXASrI6BYuBpABYSVanYDGQFAAryeoULAaSAmAlWZ2CxUBSAA==
    rCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWktUpWAwkBcBKsjoFi4GkAFhJVqdgMZAUACvJ6hQsBpICYCVZnYLFQFIArCSrU7AYSAqAlWR1ChYDSQGwkqxOwWIgKQBWktUpWA==
    DCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJVmdgsVAUgCsJKtTsBhICoCVZHUKFgNJAbCSrE7BYiApAFaS1SlYDCQFwEqyOgWLgaQAWElWp2AxkBQAK8nqFCwGkgJgJQ==
    WZ2CxUBSYOwbW0nZJ5/+Uf0Ahm8Ksdfm760AAAAASUVORK5CYIJQSwMEFAAGAAgAAAAhAKpSJd8jBgAAixoAABUAAAB3b3JkL3RoZW1lL3RoZW1lMS54bWzsWU2LGzcYvhf6Hw==
    xNwdf834Y4k32GM7abObhOwmJUd5Rp5RrBkZSd5dEwIlORYKpWnpoYHeeihtAwn0kv6abVPaFPIXqtF4bMmWWdpsYClZw1ofz/vq0ftKjzSey1dOEgKOEOOYph2neqniAJQGNA==
    xGnUce4cDkstB3AB0xASmqKOM0fcubL74QeX4Y6IUYKAtE/5Duw4sRDTnXKZB7IZ8kt0ilLZN6YsgUJWWVQOGTyWfhNSrlUqjXICceqAFCbS7c3xGAcIHGYund3C+YDIf6ngWQ==
    Q0DYQeYaGRYKG06q2Refc58wcARJx5HjhPT4EJ0IBxDIhezoOBX155R3L5eXRkRssdXshupvYbcwCCc1Zcei0dLQdT230V36VwAiNnGD5qAxaCz9KQAMAjnTnIuO9XrtXt9bYA==
    NVBetPjuN/v1qoHX/Nc38F0v+xh4BcqL7gZ+OPRXMdRAedGzxKRZ810Dr0B5sbGBb1a6fbdp4BUoJjidbKArXqPuF7NdQsaUXLPC2547bNYW8BWqrK2u3D4V29ZaAu9TNpQAlQ==
    XChwCsR8isYwkDgfEjxiGOzhKJYLbwpTymVzpVYZVuryf/ZxVUlFBO4gqFnnTQHfaMr4AB4wPBUd52Pp1dEgb17++Oblc3D66MXpo19OHz8+ffSzxeoaTCPd6vX3X/z99FPw1w==
    8+9eP/nKjuc6/vefPvvt1y/tQKEDX3397I8Xz1598/mfPzyxwLsMjnT4IU4QBzfQMbhNEzkxywBoxP6dxWEMsW7RTSMOU5jZWNADERvoG3NIoAXXQ2YE7zIpEzbg1dl9g/BBzA==
    ZgJbgNfjxADuU0p6lFnndD0bS4/CLI3sg7OZjrsN4ZFtbH8tv4PZVK53bHPpx8igeYvIlMMIpUiArI9OELKY3cPYiOs+DhjldCzAPQx6EFtDcohHxmpaGV3DiczL3EZQ5tuIzQ==
    /l3Qo8Tmvo+OTKTcFZDYXCJihPEqnAmYWBnDhOjIPShiG8mDOQuMgHMhMx0hQsEgRJzbbG6yuUH3upQXe9r3yTwxkUzgiQ25BynVkX068WOYTK2ccRrr2I/4RC5RCG5RYSVBzQ==
    HZLVZR5gujXddzEy0n323r4jldW+QLKeGbNtCUTN/TgnY4iU8/Kanic4PVPc12Tde7eyLoX01bdP7bp7IQW9y7B1R63L+Dbcunj7lIX44mt3H87SW0huFwv0vXS/l+7/vXRv2w==
    z+cv2CuNVpf44qqu3CRb7+1jTMiBmBO0x5W6czm9cCgbVUUZLR8TprEsLoYzcBGDqgwYFZ9gER/EcCqHqaoRIr5wHXEwpVyeD6rZ6jvrILNkn4Z5a7VaPJlKAyhW7fJ8KdrlaQ==
    JPLWRnP1CLZ0r2qRelQuCGS2/4aENphJom4h0SwazyChZnYuLNoWFq3M/VYW6muRFbn/AMx+1PDcnJFcb5CgMMtTbl9k99wzvS2Y5rRrlum1M67nk2mDhLbcTBLaMoxhiNabzw==
    OdftVUoNelkoNmk0W+8i15mIrGkDSc0aOJZ7ru5JNwGcdpyxvBnKYjKV/nimm5BEaccJxCLQ/0VZpoyLPuRxDlNd+fwTLBADBCdyretpIOmKW7XWzOZ4Qcm1KxcvcupLTzIajw==
    USC2tKyqsi93Yu19S3BWoTNJ+iAOj8GIzNhtKAPlNatZAEPMxTKaIWba4l5FcU2uFlvR+MVstUUhmcZwcaLoYp7DVXlJR5uHYro+K7O+mMwoypL01qfu2UZZhyaaWw6Q7NS06w==
    x7s75DVWK903WOXSva517ULrtp0Sb38gaNRWgxnUMsYWaqtWk9o5Xgi04ZZLc9sZcd6nwfqqzQ6I4l6pahuvJujovlz5fXldnRHBFVV0Ip8R/OJH5VwJVGuhLicCzBjuOA8qXg==
    1/Vrnl+qtLxBya27lVLL69ZLXc+rVwdetdLv1R7KoIg4qXr52EP5PEPmizcvqn3j7UtSXLMvBTQpU3UPLitj9falWtv+9gVgGZkHjdqwXW/3GqV2vTssuf1eq9T2G71Sv+E3+w==
    w77vtdrDhw44UmC3W/fdxqBValR9v+Q2Khn9VrvUdGu1rtvstgZu9+Ei1nLmxXcRXsVr9x8AAAD//wMAUEsDBBQABgAIAAAAIQCknYjqfAkAAAYmAAARAAAAd29yZC9zZXR0aQ==
    bmdzLnhtbLRabW/bOBL+fsD9h8CfL434ThlNFyRF3nbR3h4u3R+g2HIi1LIMSW6aXdx/v5FlNU36eNG9xX6yzIczHD6cGQ4pvf7hc7O9+FR1fd3urhfsVba4qHardl3v7q4Xvw==
    fEiXdnHRD+VuXW7bXXW9eKz6xQ9v/v631w/LvhoG6tZfkIpdv2xW14v7Ydgvr6761X3VlP2rdl/tCNy0XVMO9Le7u2rK7uNhf7lqm3051Lf1th4er3iW6cVJTXu9OHS75UnFZQ==
    U6+6tm83wyiybDebelWdfmaJ7nvGnUSKdnVoqt1wHPGqq7ZkQ7vr7+t9P2tr/l9tBN7PSj793iQ+Ndu53wPLvmO6D223/iLxPeaNAvuuXVV9TwvUbGcD693TwPIbRV/GfkVjnw==
    pnhUReIsOz59bbn6Ywr4Nwp0X/0xFeqk4qp/bKrPs6J++z2UTNC7+rYru8nhTnw0q+Xbu13blbdbMod4uaCpXRytW7whL/+1bZuLh+W+6la01BQiWba4GgEiuN3cDOVQEdzvqw==
    7fYYM6ttVZLah+VdVzbk7XPLUWZdbcrDdvhQ3t4M7Z46fSrJesNPKlf3ZVeuhqq72Zcr0hba3dC127nfuv1XOwSKnI4WdpLYtO2wa4fq393X/0igXl8vLtnzTqfm42BXL2Wr3Q==
    +ps/L/Q8b53VPBOc4np8OvRViu/Kx/YwTHM7IjdTziAVu7Ihvp/lgfftuhqZO3T19zvGKHBkh6kTiXCglnJcV6+rD+M63wyP2yoRuTf1r5XbrX869ENNGo/Z4E9Y8HsGVLtx5A==
    n8kzPzzuq1SVw4GW8S8a7OgpaVvv39dd13Zvd2vy3b9ssHqzqToaoKZYeE/uXXftw5HnH6tyTVvLnxz36mu3oo1q3c8P/yEPnrtmmbMmcTdZOqJPSJaJQgaIcKPMKfpeIELooA==
    MaKUPDnbC0QJxk5cvUQkDwVENM/PjGO1YhIiOWM2YoSLxCHiWG49RqQrMAdRMyYgkrgIFiGM6SDzM0jSBiKSMw0tYFoVBWSUWcUMZIeQmKAfMJdZC9lhjmcK2+aE03gcJ/MMyw==
    BCWxV7FC6YiRyKw4gygXoe+waKzGXCfjBfRRzmTEHsJ5FnO42pwLH+EqcMFiAdnho8dDfyPEchiNXGuWw5lyw1wOo4TnzONV4E5Fg7X5LAswfggJEXMQuSjOICJTUJsguxNcUw==
    kQmPI1hkxuA4FUxZD+cjuMgdZEdw43I8jhLCJ4homUnIqDDMFljGGCHxTK1MZ9jJlXMwh4igY4QRLBKFN/RekZjNISKJawEZpXnqdAYxDud4ydUZH5WKVhVaTYgvIKNSMxegVw==
    SS20xdqcSgwyKr2WCssEkbC/ySKLEXNQcKnwTKMSBvqbTLzAMSeTdhL6jmIsOmgBZXgloDbFjZEYEYx76AeUkAqOLZAiJrjatNHLDPKmpNYe5kSlM46jXmnuGPQDZUTykFGViw==
    FLEFPitwbCtvioS1BS0FRgpZeKwtcYVzoqb1mcvuF4jIcgN3Ji0Ew3lHKxXwXqI1z3D9pi3VT1hbzqyF2UXnOnLoO9qxzGOrHdMFnqknEWy1FxIzqkPGJUYK7hKeaWH8mfkkmg==
    EtaWtMdWG9prDfREk0npYTQars7Ej+GasjlEqCCOkB0jdO4xIkUW8DhGZNivjaWiC/JmcplHzEFOGy22wGd5xNo85STMTuAC17CmoMIKrhwhOc47plBKQRmbSZYg15Zn1sHsbw==
    OQseRrCl0M6h1VSMKo+1SX0m6i2lZbwHW6rfcMVlyXnwLmMtFQ/YNss5jiybGx2w1U5lOPfawCOD/maDLnC2tIWWuBq08dxZ00bKfXimURc4TnM6GxmM0MkMW0CIx+fgnEltzg==
    yFBGwONIbjCjuVIO16M5RSPeAXNrZIIxl+ec4doy9+rLDdkLJEhn8XyCDriuIiRZbHXBGcMzjYLjSjWnlcOemCchE6wPKOQNzvGOCY1rZTqeMhxzjtN2ihFBXGNEaSOhbc6yIg==
    h9nFWdqyYGw7S1XaGZlzNzIulzFAP3BOnMnKzlExiLUFzXBsO6phHWa0kI7h+URucb52SQgJEc+k0nBf8EwH7FWeM4VXwQvDBeTAS8FwTqSNKVjIASExYERTSYxtM3SUwRYYxQ==
    8c2Ctzzh/OZzyuTYAict3s28o3MwHocozbE2b1yGrQ6cnZlPkMFAD/GBqlhsQeIyYQuSUfh0GMajPdQWqHopIAdkdORw/wlcGrwKQdBJAs4nUCbPofcGKrAVzJbBsoDv7IIV3g==
    wywWLLkVjIXgWIH9LTgu8Xku+PEKASKBFbgWC7Ry+C6NEIUryBCF0NiCpBm+DwnJ8AQZLaiK5VCGisEk4PoUXJw5NxaSMXwXUEhabrgKhdS5g/mtsFo5uNqFo/oWslN4Zs9Y7Q==
    hcA320VgFp8Bi0AbIOatYGdu3YvIQ3YGMWQ2QuJ4aQbZiRkX+EYzsiwYyDWFohewQiHXKTRGpHYCrkJUdGjDMpqf8fhIgZVBruN4Tw7XlMr7xGCUxJxOwhhxIhjMjs8UfiMQAw==
    89gPaPPR+oyMKRj0+FioKDFvaXybghF9pu6lA7LB5/rEhMQ7BpVvnEMLklCaw1hIMkuYN0ohDt+/JTpo4R0jWSXxfWKyJuIzbXI64du8RGf37AwiGb67TZGOEpi3KDK8a44Ifg==
    w5ESy/GNWSJKpzvvqwnq37xuluMHFeNb5elpfF170UwSoWxuu7q8eD9+cnE19rjtPvp6N+O31abtqq+Rm8PtDF5eTkDflNtt6srVDByNbpbrut8X1eb4vH1fdndPek89Oti6rg==
    Nj990TV+K1B1/+zaw35CH7pyP72GnbswOZHeLOvd8K5u5vb+cHszS+3K7vEr6LBb//ypO/L0RM/DcrivmuPr7Hfl8bXssW+1u/zlZiJ7te1uxleu1ftyv5/e3N7esevFtr67Hw==
    2PiydaB/67L7ePxze8dPGD9ifMKOf8rVODPqfXp4auNz21f9xNwmntrk3Caf2tTcpp7a9Nymx7b7x33Vbevdx+vFl8exfdNut+1Dtf7xCf+maSKhvy/3VTF9f0Hu1U4Npw8y+g==
    i0/L6vNArK3rYXHR7+t1U34eP/aYyq9T7+3xc4ZnfUds7Lx/rmFdDuX8+vqZ8NHFX9gyfheyqskdbx6b26fPPV5Nhm/rfrip9mVXDm03Y/84Ykwt1+3q7Xr8ZGVq/y1n3Edr8w==
    S+0zdildyC+9lPZyPNoarnmhmf3vKdLmD7je/A8AAP//AwBQSwMEFAAGAAgAAAAhAOg8bnZ8BQAAJRMAABoAAAB3b3JkL2dsb3NzYXJ5L3NldHRpbmdzLnhtbLRY227bRhB9Lw==
    0H8Q9Fxb3DspxAl42yaB3RSR8wEUubIJk1xiSVlxv75DUrRcZxw4DfJkas7OZc9cyPGbd1/ranFvXFfa5mJJzr3lwjS5Lcrm5mL55Vqf+ctF12dNkVW2MRfLB9Mt3739/bc3hw==
    dWf6Ho51CzDRdOs6v1je9n27Xq26/NbUWXduW9MAuLOuznr46W5Wdebu9u1Zbus268ttWZX9w4p6nlwezdiL5d4166OJs7rMne3srh9U1na3K3Nz/DNruNf4nVQSm+9r0/Sjxw==
    lTMVxGCb7rZsu9la/X+tAXg7G7n/3iXu62o+dyDeK657sK541HhNeINC62xuug4SVFdzgGVzcsy/MfTo+xx8H684mgJ14o1PTyMXP2aAfmNAdubHTIijiVX3UJuvs6Gueg0lEw==
    dFluXeamgjvyUefrDzeNddm2gnCAlwVcbTFGt3wLVX5fmsMC/mTgphkMVsvVIC/MLttX/XW23fS2nU8o6k1wfpu5LO+N27RZDkmIbdM7W83nCvuX7WNoAgc5OmqMLTE87Tuj0w==
    y+zB7vsnyGZqN7DQZDWE+p8WurIF9AOouvL1nA4KYzREPA3huSML48GVhbkeKNr0D5XRcJlN+Y8Jm+LjvutLsDg20k9E8L0ATDN4/gRJvX5ojTZZvwfafpGzMTO6Ktur0jnrPg==
    NAV0+C9zVu52xoGDMuvNFZRT6exh5Pm9yQqYyj/pd/W0rGDGF9388Nnafj7qeVqKlLAp0gE9IZ7HQkVRhNCUKBSJqWLHPniGaC+NNYYQKtIUjYAw4kcJjjBOcR0hgxTXkTJKIg==
    FEk8P+IoolkcoDelgibw6sIQKWUYvIAEiY8iSgX+sRWfIaFUIXofGvMwwP0kKtBo5mjKE3msy+eIBB4whBEvTFB2GOXCw3WY5yUob4wRQmIUCZTCs81ikfpo5liquAoxBMojwA==
    /XBfBgHKDiCaojflMRcKjYDHMmVo5ngiUryquOY0ROtAeEoqHCEiVeh9hBARSVFEMqXQ2CT3JEPrQAoSMLRPpVSxRPMjlReqFxASRGifyoASgVYvvEh9jVpTnKQaZUcJHjBcxw==
    Fy9MJOVLplF2VACOUHZUSEWARxB5iqAVohIKajjCPQ/X0VCjKG8+zN4ErXifc56gmfO58iK0G30hSYL7ETCR0Jv6MaUSrbcAprJGZ2LAhcTndSA8xnFrvhfjXRLESlGU0SCFwg==
    QqsqSKVWKAeBZipAGQ0TmUi0dkKtIoF2Y8RglKI5jQSNQjQ/kWAxRydF5Esf5y0KSfACkgxvNBRJPd9HOYgJTwK0F2LqBR4aW8wIfCCgCFcpQW8axyIRqB8IOsZrJ5EyFeh9Eg==
    xf0QzVziMxjYKBJCfnAkpgyPOoF6Y2iNJqlS+DdSCtMNn/4p9TQedcopISgHqS90ivKWxjCv0Up8+ctOS/XCe0GnQCoam9ZQ9Whda02YRntOa86nPl1NEHyD1uthW/7bzU/DQg==
    sagnjTirt67MFlfDPr0aTmzdXVQ2M741sNeZp8hmv53Bs7MJ6GBPqzRsYDMwNnC9LsquTcxufK6uMndzsns84VApbHsfH23l8MFu3J/O7tsJPbisnRaF+Qjh/KhZNv1lWc/ybg==
    v93MWg1sok+gfVN8uncjTyd6DusePvjHhesyGxeH8axpzr5sJrLzym2GpcBcZW077RbbG3KxrMqb254M60APv4rM3Y0/tjf0iNERoxM2/sjy4WZw+vhwktFZ9uQcm2XsJOOzjA==
    n2RilomTTM4yOchuYatzVdncwZozPw7yna0qezDF+xP+jWgioTB5CRnfPNTb0459PmFV2cHe1cI63ls3Y3+MGBHjnt5fQ6HcAXefzS7KOlNMtTr/f+vtvwAAAP//AwBQSwMEFA==
    AAYACAAAACEACi3KdLwFAACrIAAAGgAAAHdvcmQvZ2xvc3NhcnkvZG9jdW1lbnQueG1s3JpLj9s2EMfvBfodBJ/LNSm+F9kNKFFMc1s06aGnQitrbSN6QZLXMYp+945syY94Nw==
    sJ0WaXxZS+TMX0POj0MS2DdvP+eZ95zWzbws7kbkBo+8tEjKybyY3o1+/+iQGnlNGxeTOCuL9G60SpvR2/uff3qzvJ1mZdPE9cqWySJPi9YDqaK5XVbJ3WjWttXteNwkszSPmw==
    m3ye1GVTPrU3SZmPy6eneZKOl2U9GfuY4PVTVZdJ2jTw3TAunuNm1Msln09Tm9TxEpw7QTZOZnHdpp93GuRsET7WY3Us5F8gBCP0ybEUPVtKjLuojoTYRUIQ1ZESv0zphcGJyw==
    lPxjJXmZEj1WUpcpHeGUHwNeVmkBnU9lncctvNbTcR7XnxYVAuEqbueP82zerkATi0EmnhefLogIvLYKOZ2crSDHeTlJMzoZVMq70aIubnt/tPXvQr/d+Pc/g0d9yvg3LkNxWA==
    j3xcpxnMRVk0s3m1XeH5pWrQORtEnr82iOc8G+yWFTlxubxWnuxmKneCp4Tfz3+ebSL/uiLBJ2Skk9h6nBLC4TeHSHKgcPfhi6Zmb3LJiQVkEPCPBESTnifBe4lxs8p3S3RZTQ==
    vy3L7+pyUe3U5t+m9n63ZpfdLnqGVk/LPsHNtwXzYRZXsJTz5Pb9tCjr+DGDiCD3HqTPW2fA61bJ6B72+EmZPEDta/ae9x4f6u6liHPwuH2Os7uRTZ/iRdY+ZHGSzspsktZ/Eg==
    rIgSiks2GnfmSdym07Jefen6Li3SOs42RtM4y9J6NfRVO72uf3yo0q6qdB1h9zC4PD4+ZMmvk8F+a/OYzuLneVkfvAxOSVm0UF56nwPT6WI+Gcz+EoL6gskA+coKxEJmUCBwiA==
    JJGYhszJAMu/e5WDuepfgnKyjrwCRTh6TX67G0GiGRaUjIamfiq7Hid4ROg6IV2o6+6HuuvxBaZGbno2X6g/tKtsOwt7ifiYfh4G1pu292E2Tz55s7ROvbaEg1+b1h5sdO3Neg==
    yja267/V/lA20e/e/w041PXA4RyxnHOCfKF8xCIZIaVDjKwLpRXKOuKzHwGOaI1DXKy8fuReO4tbb1UuvGXcvZVenVZp3P7izYskW3R3Bq9sgaatQ/dbl1lz4/0BXklceHHWlA==
    YN6kdSc3bwYTL4aCW0y8titHXl0uG7DyoG51RA4f8qquFnnlkxdvDP8bTv3AZybgggYMs0C7gEpOZCSVC01IrwlVK10kuBFIuJAiJiRFgcQShSwgitgoIkafjSrVUgb2JVRhnQ==
    a6WGnoe9prXIRro6YPSUXHR57/n+gaujcREOFMMGS8c4i4x2zDjm20jKMHTXtHtyZx0NLBImZIgxY5ExEkql4lZyCtsB88+mzlhhBX6JOhrySAUH1PVNr1J3Si6ugzrtCykcFQ==
    UlLDIO5ACiwUtDBtQ8rD66FOWZ+GymoUKAe1LmAaKRfBEY5YJiMWSGXDs6nzJZQv/iJ1kWTSHFK3aXqVulNysUfdjwFYFIbKt5pLizULfROEJqJBSKCSKxyFV7SZUkMcY5ojbA==
    lUXMKIe0CR3cEZSEnDJqxPmXgtDHGrOXAJOakWh7IlwD1je9CtgpubiOssZloFUkMOcWw/kBUiBgmJJFGs7fjl8TdZw5uGhgBFUiRAwrhiCvAkGuhYXSpqji35e6U3JxHdQ5zQ==
    XCR9zCkPmE9t4AQODDFKYW2iwL+izRRSZ0kk4eJgCBzcMGyrVCtklWaQb2sEVd+XulNycR3UYeeM1ZHTkR+y0JkATtfCSuy0tha2oeuhThBlaOQscr4yiIWBQyqCw5yvIoIF8A==
    AxfE849wQmi7vZTuUyeEhBp6QF3f9Cp1p+TiOqjjAdzgJAyVcsIkoSow3DghDbOUaK6vhzrmtCMy0oi5IEDMduc6gQkiSnKMlYiEOv9cJy3DeHsp3aeOcKGjQ+r6plepOyUX/w==
    d+p2z8365cv/Lrj/BwAA//8DAFBLAwQUAAYACAAAACEAg9C15eYAAACtAgAAJQAAAHdvcmQvZ2xvc3NhcnkvX3JlbHMvZG9jdW1lbnQueG1sLnJlbHOskk1LxDAQhu+C/yHM3Q==
    pruKiGy6FxH2qvUHZNPpB6aTkBk/+u8NwmoXl8VDj/MO87xPIJvt5+jVOyYeAhlYFSUoJBeagToDL/Xj1R0oFkuN9YHQwIQM2+ryYvOE3ko+4n6IrDKF2EAvEu+1ZtfjaLkIEQ==
    KW/akEYreUydjta92g71uixvdZozoDpiql1jIO2aa1D1FPE/7NC2g8OH4N5GJDlRoT9w/4wi+XGcsTZ1KAZmYZGJoE+LrJcU4T8Wh+ScwmpRBZk8zgW+53P1N0vWt4GktnuPvw==
    Bj/RQUIffbLqCwAA//8DAFBLAwQUAAYACAAAACEAdD85esIAAAAoAQAAHgAIAWN1c3RvbVhtbC9fcmVscy9pdGVtMS54bWwucmVscyCiBAEooAABAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIzPsYrDMAwG4P3g3sFob5zcUMoRp0spdDtKDroaR0lMY8tYamnfvuamK3ToKIn/+1G7vYVFXTGzp2igqQ==
    alAYHQ0+TgZ++/1qA4rFxsEuFNHAHRm23edHe8TFSgnx7BOrokQ2MIukb63ZzRgsV5QwlstIOVgpY550su5sJ9Rfdb3W+b8B3ZOpDoOBfBgaUP094Ts2jaN3uCN3CRjlRYV2Fw==
    FgqnsPxkKo2qt3lCMeAFw9+qqYoJumv103/dAwAA//8DAFBLAwQUAAYACAAMQEZLaioc3+EBAABOBAAAEAAIAWRvY1Byb3BzL2FwcC54bWwgogQBKKAAAQAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACdVMtu2zAQ/BWB91i2GxiFYTMokkMPbRPAbnLeUiuJKEUS5NqI+2s99JP6C+VDVugavdSn3dnhcA==
    lrvW75+/Nnevg6qO6Lw0essWszmrUAvTSN1t2YHam/es8gS6AWU0btkJPbvjG7DrJ2csOpLoq6Ch/fpIW9YT2XVde9HjAH4WGDoUW+MGoJC6rjZtKwU+GHEYUFO9nM9XdWNEVA==
    88/7kw36ox7Y/9XDV0LdYHNjJ48sed7jYBUQ8i9RQc0aQ8OmLguJZQjUXg7I57k45alv6NCPlRxH9MW4xvPl7SrhOYv4fQ8OBIUHHo8UQKx/sFZJARSen3+WwhlvWqoeU1NVlA==
    SYdKVjwV2t2hODhJp1G2RCLjk9STyxxn7w46B7b3/N3YwATE+k6AwvvwaLwF5TFR3rDI+IgQd+MJZGzgSOsjCjKu+gYe4/S27AhOgqawNvJHSJcs0zKaYmU9Ob6XpMINU57Ckg==
    Vsbyli8SIQSXxHrywJPdS4NxevEe/9iGVukflpOBs+EFK0xe+Stu+ks4ztYMFvQpl6ckT+C7/2r35iHu2NvbXuKX+/Iiqd9ZEHi9OUUpTS0UsAkbUE5twtLUQptOxcuCiO6wKQ==
    mNe1cS+f81eBL1azefidF/EM5/2Z/mD8D1BLAwQUAAYACAAAACEAdwEKFMQAAAAyAQAAEwAoAGN1c3RvbVhtbC9pdGVtMi54bWwgoiQAKKAgAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAACsj8FqwzAQRH9F7L2Wm0MIxnYwhB5LwG1Pucjy2hZIu0baFOfvK9omX5DjMMObmfq4Ba++MSbH1MBrUYJCsjw6mhv4/Hh7OYBKYmg0ngkbIIZjWw9Vzw==
    12gxqR49WsGxl5vP9sWsJrlNFhydZCRPk7PI5B1hsSUP6jf4bkIOd+cO1Ne9ew8qb6FUDQ0sImuldbILBpMKXpGyN3EMRrKMs/4Dn9heA5LoXVnu9eAG73iOZl1u/7CnoNpaPw==
    Drc/AAAA//8DAFBLAwQUAAYACAAAACEAv9wII+EAAABVAQAAGAAoAGN1c3RvbVhtbC9pdGVtUHJvcHMyLnhtbCCiJAAooCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAJyQwWrDMAyG74O+g9HdtVNnW1bilHRpoNexwq6u4ySG2A62MzbG3n0OO3XHncQnIX0/Kg8fZkLvygftLIdsSwEpK12n7cDh8triAlCIwnZiclZxsA4O1eau7MK+E1GE6A==
    vDpHZVBq6FTPDYcv9tiyIs8pZjWrcZ4d73HNnhk+PbW74kRpkeXNN6CktulM4DDGOO8JCXJURoStm5VNw955I2JCPxDX91qqxsnFKBvJjtIHIpekN29mgmrN87v9ovpwi2u0xQ==
    6/9arvo6aTd4MY+fQKqS/FGtfPOK6gcAAP//AwBQSwMEFAAGAAgAAAAhAFyWJyLCAAAAKAEAAB4ACAFjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbHMgogQBKKAAAQAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMz8GKwjAQBuD7gu8Q5m5TPYgsTb0sgjeRLngN6bQN22RCZhR9e4OnFTx4nBn+7w==
    Z5rdLczqipk9RQOrqgaF0VHv42jgt9svt6BYbOztTBEN3JFh1y6+mhPOVkqIJ59YFSWygUkkfWvNbsJguaKEsVwGysFKGfOok3V/dkS9ruuNzv8NaF9MdegN5EO/AtXdE35i0w==
    MHiHP+QuAaO8qdDuwkLhHOZjptKoOptHFANeMDxX66qYoNtGv/zXPgAAAP//AwBQSwMEFAAGAAgAAAAhAJy9ysz8AAAATgEAABgAKABjdXN0b21YbWwvaXRlbVByb3BzMS54bQ==
    bCCiJAAooCAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABckE1rwzAMhu+D/Yfgu+skzTdxSpNs0Os+YLdhbKc1xFawnbIx9t/nbKfuJL0S0vNK7eFDz9FVWqfAUA==
    lOxiFEnDQShzpuj15RFXKHKeGcFmMJIiA+jQ3d+1wjWCeeY8WHnyUkehoEI8jRR9PZTJMR/qDNdjusdZPvS4GqojrstiTOM+6/My/UZRQJuwxlF08X5pCHH8IjVzO1ikCc0JrA==
    Zj5IeyYwTYrLEfiqpfEkjeOC8DXg9ZueUbf5+Zt+kpO7lZu11SqKVmsarbgFB5PH4tOwoBw27EqsXMB6R55/T7XiPSThmg2V7JOCINK15B9j0zc/6H4AAAD//wMAUEsDBBQABg==
    AAgADEBGS18WiB+9BwAAzkgAABMAKABjdXN0b21YbWwvaXRlbTEueG1sIKIkACigIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAK1cbW8bNwzW5wH7D8G+d511dg==
    EgyZi76kL0CRFl3R7Vvg1k4WLHEC292aP9+Nony5k0RKpO4QNI1PDx8+1OkkUrL93/cT88R8Mzfm2hyYf8zKbMzWXJlbsza/mZ/MxPxsfoH/D6Blbb7A9SW0rs0ltn41O3NhHg==
    AeoQXj0xc/Oj+cGcmDOzAK4/AL0B/AewvcO/d+ZP9PQe2t2rg73nNfj0fBv4+1e4dgW+NmCzhX8XgHwEPPfQtti3beHKGr08BlzHv4XXv8P/C2hdopelOd9f2QHuBuPYAWpiGg==
    1P0Y/HrdB/BzYp6Dii0gbhG76bX59jNoOX9AzaPXJ8AXI0L7N+h/BT2YsnvEM1T/t3kKcX55YHN67rDlHjku4MpcgXXKNMxDdD2H13cQpR9HGpWhpU5z7JWP4AzH0UrQryVkXw==
    YZm1XhHXozo7jdpyb4Z2T+FJW8KIngCWa3H+eSupB8t6sBkPVuGhYT00GQ+NwsOU9TDNeJgqPMxYD7OMh5nCwyHr4TDj4VDh4Yj1cJTxcKTwcMx6OM54OBZ4aJ+jCax2bsXa4Q==
    6rYC5GOFtR1k3QyyPoVrC7C/TvooRaR9RbHoPcezkA4vUaWd51qG1/sMweUybi3ntMU4XlPKqNVyt7eU9VreqqyT81ZS/RaznwX0/Tvgu8ARmvYfjUpVcWx1Ks7h+mdixOfRUg==
    VR17SZ30uXXtmyDDbkfPGbGG6/A+Kp0HWqPLg8P8IL7W+oqRZT5L8FmSj8sAQlRD8DUkH7feh6gpwTcl+bjVPUTNCL4Zycet5SHqkOA7JPm4lTtEHRF8RyQft06HqGOC75jk4w==
    VmWPeoZP4wKrWGqGLKP6PvNsqYoXgNoCtqsL3QyxhOfoFOvBDTzzNuGpsXIq67xRqm+B5cW+dk7V8a1eRc6a8+YrvBeAvAbFnP4rjJBWVM/QqR6igorsKyDbntCOgVpbH0295w==
    NA6HXj6wzaPXzl+MKHHEPnOtKX9Z8Stoc/tI+b0OCcp5l7HVqYhj0dtIFZZ77S0g3Chp981ucJTE+1oSlNMkY6tTEceit5EqLPfaGVZ78d7gJOqNFFVmin3n2ykvZfXvcD67xA==
    3V23tj2FXtgpZ4zhHE77GErS+N6bv7BtVXh6ZTinU8pYqyWOqcZKrlPSg7fY/91qUrc+jsPjIxtHURrrBzwrWOAY9ONPM/qGWLu4hnlPo/Hz2qbXU3Pi2snD2UmIlPDFGkoI2g==
    lzSS/kkO7ZlHdJ5zLKnnj+YWT5TuzUusg2+QYYf3Y55tdR7z1qm3T3DfP+I4uCzMLlKkUyFnrVcU92SdnUatbA9igzsprl5zuzO38HNHYLt7vcO15zxit/t7zbW295q3pj3yzw==
    92usbWk7OjqL/bQs5Pst7xDr/g5RnXd5VC1rQ2ju2ihFfcu8v7Syl/ZgjSW/nzCs50pr4D2M0HsYlSusLqVYX03KmXl94Vp8ar7BX45tu6//6La2+uMseX9voP0MLP7tZcPhCA==
    eYU101ecETRop0nHzqt8j3GtsVevMFubE9d81pMied5ulQ3H2JxtCdfm2Kp+3Pm7xjN4ljbbl7Lp8C42rYe83vZud7OelLfWsj/H6b3Kokln89xKkV8HJD7TOZCbV/lZs+Sn3Q==
    FXV9Qe2yhtf7+6ixRcmPdgexZueybq+yrD3cL5Trr7GjdijHiaO2MqyvTofUo6Vo0npQzlxvS1eiw2OSZBI5jv4MoMuPcnn2S6wJ3F2rzUtzWVvIPpwjn+fKlYyfD6eRDmUZkg==
    J0uj5TPLa3FvUmcZ43Lmc+B6pXy/8LVsrg7OV8E1T3X5ProdbP/+5SWuKJ+wX67w/RalvFV/WmorT2dt9fkst3dQm3NQ8QzlGOP8tBRn7XmmHXSWaslcZay7N/zEw45y+mJHOg==
    f8lHO86uvR3tJMGOeJaQj3zIvr4deK5gB58s5GPj5/smu1Y0hdVCtmtHqddX7nk2HZ6u0sfQq9tptUS+KbWs39/VRyPLXqlopJb1ObMsGmcbvmeA1y/D9nMiCbNs/6PEIsPJ8w==
    GM1+SUmZDBnnIcPUydd8XYahzShKSmvW7bqsoTZLKEfgM3jfK/FeQK7VK8pZa/eL8nHo8HR+MaSnujOAME4f+7zQHp4i0Az6Hal8PFoLbveprtfy1WUpO+/XlXFNuszUpBxHvA==
    b51r7Y9s2joXc7321LpUUVPrK3/S7k56/Oxxuf9M4lJUs/ft+DtKf2KC85t/PwBn9Qy8X2AGcW0m+/E5F+L8OZSMsVaTFWqyYk12sKZGqKkRa2oGa5oKNU3FmqaDNc2EmmZiTQ==
    sypNXL5M6eKwtDaeWaPvFH/7a9071mQ4WhfNKNHUoieBgu5q6K+P1rBbkt0y7PmVjcLT6i2r36ojaEgPDcOfr/8pPB1Bw0bQqCOYkh6mDD/1ua48Ox3BlI1gqo5gRnqYMfzUJw==
    yXLsr+HfYp9d0LGECNprzFKrgH5iQkRZgfZJ6tvSIz5ElBVon4S+LT1iQ0RZQX4kfwaMez+mm9PjEx++zXnNWXK5qSaLo/G5bNO/s2ttuG9qOcGc07+Dd2M+wu9v5NrqvuHDrQ==
    a/c9THzFfytHjKLexXqNNaSPokPS1302TltQn1Byfb/Cfg+xXIv/tBFnFfdlvrf61Vn4vTv+syyybxOam/8BUEsDBBQABgAIAAAAIQCHONIr1wEAAEcGAAAbAAAAd29yZC9nbA==
    b3NzYXJ5L2ZvbnRUYWJsZS54bWzck11v2yAUhu8n7T8g7htjx046q061tolUadpFP34AIdhG48PikLj59wPspNKySM1FdzFbRvAeeDi8+NzcvimJdtyCMLrC6YRgxDUzG6GbCg==
    v76srq4xAkf1hkqjeYX3HPDt4uuXm76sjXaA/HoNpWIVbp3ryiQB1nJFYWI6rn2wNlZR54e2SRS1v7bdFTOqo06shRRun2SEzPCIsR+hmLoWjD8YtlVcu7g+sVx6otHQig4OtA==
    /iO03thNZw3jAP7MSg48RYU+YtL8BKQEswZM7Sb+MGNGEeWXpyT2lHwHFJcBshPADPhliGJEJLBX/A0jxcrHRhtL19KT/JGQzwpFMF6Ml4n6UlPlw/dUirUVMdBRbYCnPrajsg==
    wiQjK1L4Nrw5mYYWJ2Eia6kFHiDDRDLINVVC7g8q9AJgCHTCsfag76gVIbUhBKLxgS2sSYWXhJDs+2qFByX12QUln9+NShb2is+3UZkeFRIUFjlxmA4cFjnHOX7PZHDgxIkXoQ==
    OKCfvEdPRlF9xpGMzLwThfcjODO9yBEbuRc7svzTkfl18U8ceeaN4ej18YwVd9GCfPy8GZ/7c+R/s2KZzw/Kp1oxlgn6IZrWnS2WUCL/abGMHVj8BgAA//8DAFBLAwQUAAYACA==
    AAAAIQCOLns08Q8AAG2oAAAPAAAAd29yZC9zdHlsZXMueG1s7J1bc9s2FoDfd2b/A0dPuw+O77dM3Y6v68wmqRs57TNEQhYbitCSVBzn1y9upEAdgsIBYTfTcfsQi+T5cDkXHA==
    gCD50y/f5ln0lRZlyvKz0e6bnVFE85glaf5wNvp8f7N1MorKiuQJyVhOz0ZPtBz98vM///HT49uyespoGXFAXr6dx2ejWVUt3m5vl/GMzkn5hi1ozk9OWTEnFf9ZPGzPSfFluQ==
    2IrZfEGqdJJmafW0vbezczTSmMKFwqbTNKZXLF7OaV5J+e2CZpzI8nKWLsqa9uhCe2RFsihYTMuSN3qeKd6cpHmD2T0AoHkaF6xk0+oNb4yukURx8d0d+dc8WwEOcYA9ADgqKQ==
    DnGoEdvl05x+G0Xz+O27h5wVZJJxEm9SxGsVSfDoZ67NhMVXdEqWWVWKn8VdoX/qX/KfG5ZXZfT4lpRxmt7zWnDUPOXU2/O8TEf8DCVldV6mxDx5rY+J8zNxYadkXFbG4Ys0SQ==
    R9ui0PI7P/mVZGejvb36yKWoROtYRvKH+hjNtz6PzcoYhyacezYixdb4XAhu67apf40WL9Z/yYIXJE5lOWRaUW6ru0c7ApqlwjX2Dk/rH5+WopPJsmK6EAlQ/zbYbdDp3IS5QQ==
    j5Vf8bN0+p7FX2gyrviJs5Esix/8/O6uSFnBfedsdCrL5AfHdJ7epklCc+PCfJYm9I8ZzT+XNFkd/+1G2r8+ELNlzv/ePz6UhpCVyfW3mC6EN/GzORE6+SgEMnH1Ml0VLsX/Vw==
    w3a1JrrkZ5SIkBLtriNk9VGIPSFRGq3tZi7X2i6vQhW0/1IFHbxUQYcvVdDRSxV0/FIFnbxUQRLznAWleUK/KUeExQDqJo7FG9Eci7OhORZfQnMsroLmWDwBzbEYOppjsWM0xw==
    YqYITsVimxUaxr5vsfZ+7uYxwo+7eUjw424eAfy4mwO+H3dzfPfjbg7nftzN0duPuzlY47kq1YrecTfLq8FeNmWsyllFo4p+G04jOWfJeVYYnhj0aBGkkQEwKrLpgXgwLSby9w==
    ZguRTuo/nldiRhexaTRNH5YFn54PrTjNv9KMT5QjkiScFxBY0GpZWHrEx6YLOqUFzWMa0rDDQcVMMMqX80kA21yQh2AsmieBu68mBgkKjUHz+fNMOEkawKjnJC7Y8KoxEiw+vA==
    T8vhfSUg0cUyy2gg1scwJiZZw+cGEjN8aiAxw2cGEjN8YmDoLFQXaVqgntK0QB2maYH6TdlnqH7TtED9pmmB+k3ThvfbfVplMsSbWceu+9rdZcbEyvjgeozTh5zwBGD4cKPXTA==
    oztSkIeCLGaRWJjuxpptxpZzwZKn6D7EmNaQQuX10kQueavTfDm8Q1u0UM7V8AK5V8ML5GANb7iLfeBpskjQbsPMZ8bLSdXptJLk5LRjki1VQjvc20g13MJWDnCTFmUwN+jGBg==
    sOCPIp0V6gwR+Va1HF6xFWu4W61HpaDV08gAtcxY/CVMGL59WtCCT8u+DCbdsCxjjzQJRxxXBVO2Zrr8nlSJk8tfzxczUqZyrtRCuA/19T316ANZDG7QXUbSPIzerrfmJM2icA==
    GcTt/Yf30T1biGmm6JgwwAtWVWwejKlXAv/1B538O0wFz/kkOH8K1NrzQMtDEnaZBhhkFIklgUg8zUzzNMgYKnn/pU8TRookDO2uoGobS0UDEcdkvlBJRwDf4nHxkcefANmQ5A==
    /U6KVKwLhXKq+yAwY9mwXE7+pPHwUPeRRUFWhn5dVnL9Uaa6Ujocbnia0MINTxGkNvnwIOw3QGNbuOGNbeFCNfYyI2WZWm+hevNCNbfmhW7v8Mmf5rGMFdNlFq4Da2CwHqyBwQ==
    upBly3lehmyx5AVssOSFbm9Ak5G8AEtykvefIk2CKUPCQmlCwkKpQcJC6UDCgipg+A4dAzZ8m44BG75XR8ECpQAGLJSdBR3+A93lMWCh7EzCQtmZhIWyMwkLZWf7VxGdTnkSHA==
    bogxkKFszkCGG2jyis4XrCDFUyDkdUYfSIAFUkW7K9hUPN/AcrWJOwBSrFFnAZNthQul5D/oJFjVBCtkvQKsiJIsYyzQ2tpqwJGS7b1rm8TkkxyDq3CXkZjOWJbQwtImuyyfLw==
    j9VjGevVl9VwWvZ8nz7Mqmg8a1b7TczRzkbJesLeEttcYFefH9XPs3SJfaBJupzXFYUPUxztuwtLi24JH2wWXmUSLclDR0lY5tFmyVWW3JI8dpSEZZ44Sko/bUn2+cMVKb50Gg==
    wnGf/TRzPIvxHfdZUSPcWWyfITWSXSZ43GdFLVeJzuNY3C2A2nHzGbu8m/PY5TFeZKdg3MlOcfYrO6LPwT7Rr6kY2TFBU5bX7J4AcV8m0U6R87clU+v2rRtO7g91veOJU17SqA==
    k7PvfuOqFWXs/egcbuwI57hjRzgHIDvCKRJZxVEhyU5xjk12hHOQsiPQ0QqOCLhoBeVx0QrK+0QrSPGJVgOyADvCOR2wI9COChFoRx2QKdgRKEcF4l6OCiloR4UItKNCBNpRYQ==
    AoZzVCiPc1Qo7+OokOLjqJCCdlSIQDsqRKAdFSLQjgoRaEf1zO2t4l6OCiloR4UItKNCBNpRZb44wFGhPM5RobyPo0KKj6NCCtpRIQLtqBCBdlSIQDsqRKAdFSJQjgrEvRwVUg==
    0I4KEWhHhQi0o6pHDf0dFcrjHBXK+zgqpPg4KqSgHRUi0I4KEWhHhQi0o0IE2lEhAuWoQNzLUSEF7agQgXZUiEA7qrxZOMBRoTzOUaG8j6NCio+jQgraUSEC7agQgXZUiEA7Kg==
    RKAdFSJQjgrEvRwVUtCOChFoR4WIPvvUtyht2+x38aue1h377reudKU+mY9ym6h9d1RdKzvL/VmEC8a+RJ0PHu7L+YYbJJ1kKZNL1Jbb6iZXbolA3fj89bL/CR+TPvClS/pZCA==
    ec8UwA9cJcGaykGfyZuSYJJ30GfppiTIOg/6oq8pCYbBg76gK/2y3pTChyMg3BdmDOFdi3hftDbEYRf3xWhDEPZwX2Q2BGEH98VjQ/AwEsF5XfrQsZ+Omv2lgNBnjgbh2E7oMw==
    S6irOhxDx3BVmp3gqj07wVWNdgJKn1YMXrF2FFrDdpSfqqGbYVXt76h2AlbVkOClaoDxVzVEeasaovxUDQMjVtWQgFW1f3C2E7xUDTD+qoYob1VDlJ+q4VCGVTUkYFUNCVhVDw==
    HJCtGH9VQ5S3qiHKT9UwucOqGhKwqoYErKohwUvVAOOvaojyVjVE+akazJLRqoYErKohAatqSPBSNcD4qxqivFUNUX2qlqsoLVWjNGyI45IwQxA3IBuCuOBsCHrMlgxpz9mSQQ==
    8JwtQV3VOsfNlkyl2Qmu2rMTXNVoJ6D0acXgFWtHoTVsR/mpGjdb6lK1v6PaCVhV42ZLVlXjZku9qsbNlnpVjZst2VWNmy11qRo3W+pStX9wthO8VI2bLfWqGjdb6lU1brZkVw==
    NW621KVq3GypS9W42VKXqgcOyFaMv6pxs6VeVeNmS3ZV42ZLXarGzZa6VI2bLXWpGjdbsqoaN1vqVTVuttSratxsya5q3GypS9W42VKXqnGzpS5V42ZLVlXjZku9qsbNlnpVjQ==
    my194CJpgFdAjeekqKJw74u7JeWsIsNfTvg5L2jJsq80idBN3X5sfbNKlCG/Csevr3hDxWvLjWeMEvXaVg2UF75Lmm9LCWFRo0h/xUsflhXX91hViVIQFhXPeFmxfuGUpSj94g==
    2ObJJ/na2PWCLW+XlRVZWU19te7aVX+p61q91VvvSlhpT52lFff2kTJ0WwVPteduqiGvzyRT3znjf7zLEw541N/4UjVNvhGF4ucvaZZ9IOpqtrBfmtFppc7u7sj3DKydn6hX5g==
    WeULGVutgO12ZdRP/a01S3+rl+jrm/5WkxQBpKO75Q6UoT3taMNNbYzHo+XT0evVAo9Pq54lvLRfhZ+bVt02fVxDijIVRiEv2dk5Pzm+2TvXWlJ2E4tAW19xsiP+10qqP7JnaQ==
    dytMNO3Wb9Ndb67+aEhXI82YIYJsfVyRLnnvbmpyh1vYm60/C8g9WIY+/m99nRhnlBYXrBQ5gOqJ1jXStJtLTvfVFj9hwpoHPjdofmzwoPlh/digi5HFy5L7nwzf605gdNq6Cg==
    1Klo1aHOxga1skkjtu7HWtON+kjMelP0t2Mw1qRIr9aEsiaj09ZVoE4NtSat3xeypo+sfuvEemuMF1KAOjZSfcajM4pVzuNgNM+k3CY3aWcj4l4EaLfKtuWpLiWaaYyl4fX7Rg==
    nre17TznghU8BimHk3mMLFV870A3/Dv3N/kHL5M2X0zl49yK3GQ5XrJNBuQlXedHXsJpznua3g4T/91PXKVqTfe7ZG7QGuV2Q2lZB11ZkbGJ0dMk682ObZO8PDraO9QbKMObpA==
    DJ+f2OMFyZNx+r1pkI4L9RV8Vtt5xaonV9feFU0nTsV78jld9pfO2yaqdy5LJV4naytpCysjwVCyWrxJoaoVCDXhPbz7Oy1U0i37VSkh1mqfNWYRZ5SoQdAwdP5zmmZidNoT/w==
    i9/yK9c38uCExF8eCrbkZbTOiM3yVMjU+pSlOdf3lhXff7z6YvxazLKUW2+pNRv1aWrTvbsXKH3dvHPk+aHdXF4xZPQ6uT4/v7po9CgXyXiddXfXh+9T8W3wOnvCj3M+pfiMiA==
    PuV4jJ0+xXiNsviCrANqZ6DYNAysTeZv5H/r1THjgRFYuwJPFQ+x1YOD471LebKrNzxN0wHqY4kOWA/Dc6Cu2VmeynAnw7HR984jwFqJagQwCkSNS46ZAsZyErash43gfrQqEg==
    1cq/exJzdXq9dyNvf3eYhHlU9ee+HDv/mvwlaFUHpS67simbUhc9pr+mLi7B8PTycu96pcaWU68y06Gpi08pPgOGTzkeI4hPMV6pC76gv3PqcnhxenFl7Q1P03SA+liiA9bD8A==
    HKiBU5e1Es3g3yyR/Pipi58fvaYu3fnA9fX5jdz40WES5tEfIHUJWVVM6iLW7jekLl1PVgROXW5ODg/2n229/zV1eU1dnqMg5F2Q1xzpNUcKkiMB+3vNnZz68zVVslrAa6q0OQ==
    VWpWefZdVnmM5+WUcvGpkt7AvbbKs3N8cqWHob9fqvQ6KjhFsR83KXgdc/rGHET/rGkC3ozH9pHrELaxk1pGPTT1CN5Mx9F1YyvNMPPDNXLTuG9tyQ8f2Tzzs03ZxbPPVZ5pAA==
    cVkkRXVUTsWDE1izaSYe7WYGqM6ja3U6S3YJRqj6lM7dE36ocIg5uLY49+1ztMVfMdvWnLy1Lbtn33mz5XpL7ZAXpO7t2tFWpC5R1r3+LIC+Smuna1O3KmG1tbtnB/f13sm1Tg==
    6XXm/Wdcn24qsd2c1MNUIXa+l/w6UsZpejYa0wdGo8/vRINn5zw8tA/FpfFbllV+rwvZ1aWX3y8F0DhWj4r2rnfd8t/e7d7T8QN3/q/pxrqj3qaDgC01TGCzodnb3fGcQI/F9Q==
    t+6vtp76r/Ln/wMAAP//AwBQSwMEFAAGAAgAAAAhADqX79SoAQAA+AYAABQAAAB3b3JkL3dlYlNldHRpbmdzLnhtbOyVy07DMBBF90j8Q+Q9TVqSkkS0SAiBkHiJ195xnNbC9g==
    RLbbEL6eaZLSQlmQFSxYeTzjezKja8XHJ69KekturAA9IcNBQDyuGeRCzybk6fH8ICaedVTnVILmE1JzS06m+3vHVVrx7IE7hyethxRtU8UmZO5cmfq+ZXOuqB1AyTUWCzCKOg==
    3JqZr6h5WZQHDFRJnciEFK72R0EwJh3G/IQCRSEYPwO2UFy7Ru8bLpEI2s5Fade06ie0CkxeGmDcWpxHyZanqNAfmGG4A1KCGbBQuAEO03XUoFA+DJpIyQ0g6gcY7QDGlvdDRA==
    HcK3teKvxFMsvZxpMDSTSMKRPOzKa8BkipbmYmm71atSkeONCMLDwyg5ipLmQAZ5fdYUl1RilfirLDp6xQu3zgYf2Xsxm3+TfoRyN3kKzoH6ksdGTnOzitxGo/EmEtzYt9W5VQ==
    UFLGu5iBBLxAdOGgRcitzvops08d9dOa7cn7SP3N0G34xQ/0IgniJBn/+/En/IjjKIzD4Sj89+O3/GjX5seFL0B9q5+vr5qPUCmhuru5aGVb79X0HQAA//8DAFBLAwQUAAYACA==
    AAAAIQCHONIr1wEAAEcGAAASAAAAd29yZC9mb250VGFibGUueG1s3JNdb9sgFIbvJ+0/IO4bY8dOOqtOtbaJVGnaRT9+ACHYRuPD4pC4+fcD7KTSskjNRXcxW0bwHng4vPjc3A==
    vimJdtyCMLrC6YRgxDUzG6GbCr++rK6uMQJH9YZKo3mF9xzw7eLrl5u+rI12gPx6DaViFW6d68okAdZyRWFiOq59sDZWUeeHtkkUtb+23RUzqqNOrIUUbp9khMzwiLEfoZi6Fg==
    jD8YtlVcu7g+sVx6otHQig4OtP4jtN7YTWcN4wD+zEoOPEWFPmLS/ASkBLMGTO0m/jBjRhHll6ck9pR8BxSXAbITwAz4ZYhiRCSwV/wNI8XKx0YbS9fSk/yRkM8KRTBejJeJ+g==
    UlPlw/dUirUVMdBRbYCnPrajssIkIytS+Da8OZmGFidhImupBR4gw0QyyDVVQu4PKvQCYAh0wrH2oO+oFSG1IQSi8YEtrEmFl4SQ7PtqhQcl9dkFJZ/fjUoW9orPt1GZHhUSFA==
    FjlxmA4cFjnHOX7PZHDgxIkXoTign7xHT0ZRfcaRjMy8E4X3IzgzvcgRG7kXO7L805H5dfFPHHnmjeHo9fGMFXfRgnz8vBmf+3Pkf7Nimc8PyqdaMZYJ+iGa1p0tllAi/2mxjA==
    HVj8BgAA//8DAFBLAwQUAAYACAAAACEAxFQFbXckAABHDAEAGAAAAHdvcmQvZ2xvc3Nhcnkvc3R5bGVzLnhtbMR9WXMjN7rl+0Tc/6CopzsP7sK+OK77BtaxY9rdvl329DNLYg==
    uTimRA1FeZlfPwdJqooqJAUlmfBELyWROie/xLcjAeR//Ofvt+urX5fbh9Xm7ps39C/kzdXy7npzs7r7+Zs3P/2YvzJvrh52i7ubxXpzt/zmzR/Lhzf/+dd/+2//8dvXD7s/1g==
    y4crENw9fH17/c2bj7vd/ddv3z5cf1zeLh7+srlf3uHLD5vt7WKHX7c/v71dbH95vP/qenN7v9it3q/Wq90fbxkh6s2BZvsals2HD6vrZdxcP94u73YD/u12uQbj5u7h4+r+4Q==
    ie2317D9ttne3G8318uHB9z07XrPd7tY3X2ioaIiul1dbzcPmw+7v+BmDhINVIBTMvx0u/5MIKcRsIpAPSynUcgDxduHP26Xv7+5ur3++ruf7zbbxfs1mHBLV5DqaiB+81do8w==
    ZnMdlx8Wj+vdQ/l1+8P28Ovht+GfvLnbPVz99vXi4Xq1+hFSgOp2BdZv3d3D6g2+WS4edu5htTj+Mh0+K99/LH84irx+2B197Fc3qzdvy0Uf/i++/HWx/uYNY0+fhCLEs8/Wiw==
    u5+fPlveffXTu2Nhjj56D95v3iy2X71zBfj2cG/7f4/u+P7L34YL3y+uV8N1Fh92S9gqVaSQrlfFNZi0T7/887EM8uJxtzlcZCDY//uJ9m016DBhGPS7vV/h2+WHv22uf1nevA==
    2+GLb94M18KHP333w3a12cJ3vnljh2viw3fL29W3q5ub5d3RH959XN0s//VxeffTw/Lm8+f/lQf7P3xwvXm8w89cy8EQ1g836ffr5X3xJnx7tyg6+XsBrMtfP64+X3yA/58nMg==
    etDEGP7jclFCyhX9kmIQfxIFK4iHo7sd53z84t6Hv5p0If5nXUj8WReSf9aF1J91If1nXcj8WRcaaHpeaHV3s/x974j1ZSrWFs8Jb5zMc8LZJvOc8KXJPCdcZTLPCU+YzHPC0A==
    J/OcsOPJPCfMdALPbnN9ygqPjJ2fsPaXeds54jzedko4j7edAc7jbQf883jb8f083nY4P4+3Hb3P420H6+m8+1Lr6ju42d3uYi/7sNns7ja75dVu+fvlbIs7cA191jx8Jekttw==
    s9zkDDT7yHZIxBezXS+G39sWMjjp+fl8Vzq6q82Hqw+rnx+3aM8vFXx59+tyjUb5anFzA74ZCbfL3eP2xIicY9Pb5Yfldnl3vZzTsOcjLZ3g1d3j7fsZbPN+8fNsXMu7m5mH7w==
    iXGWoPDJoNE/fyxOsprBqG8X19vN5aJtFrPFh7+tHi4fq0Jy5R/X6+VMXH+fx8QGrst7g4Hm8tZgoLm8MxhoLm8MjnQ21xAd2GYaqQPbTAN2YJtp3Pb2Ode4HdhmGrcD20zjdg==
    YLt83H5c7dZDiD+uOujr5+7CelNmxi+W493q57sFCoDL081hzvTqh8V28fN2cf/xqkxMj9Me3/PU6/jNzR9XP86R0z4xzVXXDyYScNeru8fLB/QZ21zO9YlvJvf6xDeTg33iuw==
    3MW+R5lcCrRv5+ln3j2+34067cD0Kqd9t1g/7gvay71tsbvcwj47QF5tH2Zzg3HaGSz476WcLeqcI/J9lvJywT5zXe5WX0alWcU7UM4g5Xpz/cs8YfjbP+6XW7Rlv1zMlDfr9Q==
    5rflzXyM73bbzd7Wjl2eDSp5lcun2/uPi4fV0Cs9o3h9qn96pn71/eL+4hv6Yb1Y3c2jt/TV7WK1vpqvgvj2x+//dvXj5r60mWVg5iH0m91uczsb52Em8N//tXz/3+cR0KEJvg==
    +2Omu3UzTQ8NZGE1Q5LZM21uZmJCmbm6W82SQwe+/7n84/1msb2Zh+2H7XK/jGW3nInx3eL2fl90zOBbiIu/If7MUA0NfP9rsV2VeaG5nOrHWciOpg0fHt//7+X15aHu75urWQ==
    Zob+8bgb5h+HUndAz0d3eZnwjO7yEmHQJtJDsd8ZbvYZ3eU3+4xurpsN68XDw+rkI9Sz+ea63Se+ue/38ubvwLdZb7YfHtfzDeAT4Wwj+EQ42xBu1o+3dw9z3vHAN+MND3xz3w==
    74wmM/DNMCU38P2P7epmNmUMZHNpYiCbSw0D2Vw6GMhmVcDlK3SOyC5fpnNEdvlanT3ZTCXAEdlcdjZr+p/pKc8R2Vx2NpDNZWcD2Vx2NpDNZWc8Xi0/fEARPF+KOaKcy+aOKA==
    50s0d7vl7f1mu9j+MRNlWi9/XswwQbpn+2G7+VD2N2zu9ou4Z6Asc9TrGYvtPd1cSv7X8v1sohWuOeWaYUZ0sV5vNjPNrX1OOAPy+dq1FmzYyXGxCD+sF9fLj5v1zXJ74p5OYw==
    0S+/22/L+FL8QYxXTXv+bfXzx93Vu4+fZvuPaRRpIp8a9mew9gXHxlw97WcZg32/vFk93j4JWm+mUPz14MGin4FFG/y5kniGlK9E1tdUbeTnKvkZUr8SWV/TvBI5+Okz5Ev+EA==
    F9tfRg1Bv2Q/n3q8E8anX7KiT+DRy75kSJ+QYyaoX7KiZ65y5a6vy9OCWjuv85nT+Nc5z2n8FC86zTLFnU6zvNqvTlO85GD/XP66Kpl9StAcrvdp9UQV94ci+lWR878eN/t5+w==
    Zw+cXr+p6zsUTncPy6tRHv76B1fPoszpcXx1uDlN8eq4c5ri1QHoNMWrItFJ+KSQdJrl1bHpNMWrg9RpisnRqs4I06JVjZ8WrWr8OdGqZjknWl1QBZymeHU5cJpisqPWFJMd9Q==
    gkrhNMUkR63gZzlqzTLZUWuKyY5aU0x21LoAm+aoNX6ao9b4cxy1ZjnHUWuWyY5aU0x21JpisqPWFJMdtaaY7Khn1vYn4Wc5as0y2VFrismOWlNMdtShXrzAUWv8NEet8ec4ag==
    zXKOo9Yskx21ppjsqDXFZEetKSY7ak0x2VFrikmOWsHPctSaZbKj1hSTHbWmmOyo+62G5ztqjZ/mqDX+HEetWc5x1JplsqPWFJMdtaaY7Kg1xWRHrSkmO2pNMclRK/hZjlqzTA==
    dtSaYrKj1hSTHXV4WHiBo9b4aY5a489x1JrlHEetWSY7ak0x2VFrismOWlNMdtSaYrKj1hSTHLWCn+WoNctkR60pJjtqTfGSfR4eUZ5aZk+nz3qeXLH/+kdXB6H+ebyV+5iKvw==
    nupJqtNcr9+L4DebX65GNx7yod94Hcnq/Xq1GaaoTzxWP+YdlkRMevD5j/DyDp9j9gsPXTrshRiemVbk4rXIak5FvGTyx8iqyRMvWfoxsqo6xUvR9xhZpUHxUtAd/PJpUQrSUQ==
    BX4pzByB6Qn4S9H6CF4P8Usx+ghYj/BLkfkIWA/wS/H4CCivSnD+Ei1fOU7q0/rSiuElczxi0KcZXjLLWldP4bh2jNcq7TTDa7V3muG1ajzNMEmfJ2mmK/Y01WQNn6Y6T9W1mw==
    TVX1+Y56mmGqqmuGs1Rd0Zyv6prqbFXXVOepug6MU1VdM0xV9fnB+TTDWaquaM5XdU11tqprqvNUXaeyqaquGaaqumaYquoLE/JJmvNVXVOdreqa6jxV18XdVFXXDFNVXTNMVQ==
    dc1wlqormvNVXVOdreqa6jxVV13yZFXXDFNVXTNMVXXNcJaqK5rzVV1Tna3qmuolVQ+zKM9UPUnDR/BpRdgRcFpCPgJOC85HwDO6pSP0md3SEcOZ3VKtqyedT+uWjpV2muG12g==
    O83wWjWeZpikz5M00xV7mmqyhk9Tnafqad3SmKrPd9TTDFNVPa1bOqnqad3Si6qe1i29qOpp3dJpVU/rlsZUPa1bGlP1+cH5NMNZqp7WLb2o6mnd0ouqntYtnVb1tG5pTNXTug==
    pTFVT+uWxlR9YUI+SXO+qqd1Sy+qelq3dFrV07qlMVVP65bGVD2tWxpT9bRu6aSqp3VLL6p6Wrf0oqqndUunVT2tWxpT9bRuaUzV07qlMVVP65ZOqnpat/Siqqd1Sy+qelq39A==
    PSCrGY6Aene72O6u5jsv7tvFw8fd4vLDCX+62y4fNutflzdXk2/17W/P3llVrjG8FQ5/v8ONlmPLj/YY3eyPbT0QDn/43c2nd0sVcJHo6vAWr8PHg+CHZ6z7Kw7A+lLXH3Gt6w==
    w4FTJy51ODj2086n4djYLy984nTZQZDPVvP014eh/Txe+797Nlovyr0rVvqCzIMVvzhGe0M/JaA9eG5LQsjzfr1/zxl++O7uBgS/Hd7xtZf05vfFngrfh+V6/f1i/9eb+9N/ug==
    Xn7Y7b+lZDhn4Ivv3++PzDuJ3w6x9STB2+fC7H89vGvtxHjvD9E/PPQ/aZIlgIwM97AC5dKRfqUNf5LmaHv0sDv6S7Gq7dP7kV3gav8ofn5s1c9Nf9qNbB9WxSiGPyGESmVTPA==
    aGlvN9cl0D79hSHlPwclPb1k78R9PwsT148PMIkhonypFyKojM5Y66gWSRPrvSHECUq0owwZ4cuhaQJGbowppdwwAjMI7KhnVEgSqBE8EKMIN1JnT6QxOvha4Bags8CZcyJSSg==
    hHMqmBU25shYtDnbbKXSlcBNQGeBTRBWU06ItlxE6WyWKsmcnedQuyCVwE1Ab4FpzNpzp0RMIjNujSDBau4Zly56VwvcAnQWWHmihFLcsKgFVdkpRaBqqbxMkvNYCdwEdBY4cA==
    ZqyxRFIJXUfuFegZsUwLQzSpna4J6C0w3F0na5wIVjidXUjwe4Qn56LKStQCtwC9bThKkjUBIUTwhDpNEmEmhADvp5nXNtwCdBbYJbg44qfxMQjjiGeeBJe9ETIitKZK4Cag9w==
    CGttMrHOlGxASfKGp6ypFDabFFwdh5uAzgInzbKK3oeYuGAme4vh0olRBp+Puo7DTUDvETZCS+Y0E/gpJ25hkZRzJlTmyvKRONwCdBZYhOiZds4gPgli8EPgmeRActYq6VAJ3A==
    BHQWmGvNpVcqS4yZstRqy/APxKKEO2sqgZuA3ibBdUzK2+SFEDBFZ0PJBMGw5KTJrDaJFqCzwDLD7hDwqTEEVonIpHRADMBHnCuWK4GbgN71sPaeZ1XqLIbii+GXrE3wTlmpEQ==
    tep6uAXonZoT1wGVrROMCJK5d2gnFKWG5+AprZ2uCegsMEssaOYyC1yh0JXGBWUyjx4DaVHxVgI3Ab2dTqF3MFzyhCiViLQO4T9Zkg23OanahpuA3iNMaSYi0AR/F0QZw0BvRA==
    MNJnSLJ/i/qzEW4BOguMAJp9yMyrbATzxgaRc7IZAtiQc13ANwG9RzgHm6lk1FAuQpJGCo+aJqOyxYVYXfw0Ab1tWLKsOdGRcASqFH3SmQrOgjOURFObRBPQW+Bg4d0oCpSygg==
    O22ViiqgT7PRcfSbI11zA9C7lkBtSGnE1QgXaMw8sgB1jCHcOmpsnTiagN42jFFC+NQi+CAEl4j/TEgamRTZKz1iwy1A7ygRlODemyw4/iuQcVMQDGMISzVG14mjCege1lC6RA==
    NMJRO6FidD65JL1DWylclLUNNwGdBUaihTEqCQf3givYIzPIuj4yboLy9bxEE9BZ4JhkFIaQYBJMkSC65pQpikctkQxY7XRNQO8ooYfJsiRp9kLDnaQUZaIMRbkzMtTVWhPQuw==
    vAyoERNGLdAoWKQ+46ro3QPjUqVct0hNQO8Rpt4TK4SiiFSMMx8RaJUXLEuDDrOOEk1A7xHOhmhqo6EouYRPVkUhvVRUIeeGka65Ceg9wlwQJ7hJKWoBRaN7z8Jzic7duLF5iQ==
    JqC3wNZla0NEJywEg98gRFnulY8UTYWsi58moHfxEwV1aM0oTVpwqxzGiTDk3kwJ2ok6DjcBnQW2jksamI4cJmljMkZxbanOAWWjzrYSuAnoLLBESs00elQuiFcJLUSwKGEoMg==
    QuLcqHpeogXonely5CIzlk0iwiZphZVGoySTKMG4rGd+moDOAhOTFS0KpYwKY5XXmgX0Pz5hKAUZeRLaAnSv1iSc2xCJywobmEUX7CXGLKtMXaxNognobcMyEZapjypL9MPGEg==
    miz8P2uWtIx119wE9DYJhirWaRTjtDQR1qPNUYYTq5XSydQCNwG9Rzh6Kq1M0iW0Dyi+GLeJG7Q9TjrOaxtuAnoLzHWZgYQ+M/KAQTHOnYnWxcR0SHZE4Bags8A6JZFL5M+RCA==
    zkvnq5iSklEoO+W6RWoCekcJlXmCc1tFhCBGGK8dS6Gs4EB8JfVTpCags8DCGBOTZbJMM1BineOB5iyQu5S0qa7WmoARgbUUdv/YfIbih0QZIk3KlWcWRnsdHPfwdmNjxo918Q==
    0wJ0FpiHKJTnjkVtBBTtE0Xq9Tlpjo5y5KFME9BZYC/hOwioSQUUX4iozJAsI1IvkchddT3cBPQ2CSm1kUSYmJ0oWTYokxx6H+056vG6RWoCOguMXMVwRZKJjyLl6JGzBPeayA==
    ou1UR4kmoLPAMWfFvCuzOEE4ExyzyANZRUeTybpOzU1AZ4FRZ5nS+nJKyjMWDddPKsLbDVr56OoRbgI6C5xl4oT4TFkyglnveXCUBDRCNqA1ridSmoDOArMcgpdUEbTBgvHsnQ==
    oz7w8j+ex6Zbm4DeYU1bqw3T3CG+RpmcJyrZoBP1MlldFz9NQG+BFXVMGo9UKwVz0irLUNkg2aLZJCOTgU1A7yjhfSYiCZ1UFkYa5wKymI0GHVu0Iw/Hm4DecThEgzLR+IgEqw==
    NYJssiZQ1LvlaUAYicMtQGeBVZlE10mrEJlQsE9qQuYROpeB+TSylLEF6C2wsLicQ9ryCfWtwGVlCt4T6oXhoi5+moARgXOmfD8nNEPiIM6lTJK3kaIeIJ5S64ImDtUXSaaeWw==
    awI6C+ySjyHkIMpDY0fhUsnrSJTJ0eg4Mj/cBHQWWDOlgxbeWSNEdtbBPKXEZ0ElZLC6gG8COguM0UK/bm1gIYhUMi21KM3LagivCK9NogkYETiUiDdUynPMSxjDKVWcRS8cag==
    R2eSRdpFQkBnyesRbgJGBEYi1GxwxxkENmjIRNAUtbiwCumLGSWD9iQYLWndcTQBnQVmngnnpeK+hCibPcdVYZYGDWXguq7WmoARgY3U1gzfzCCw4ZEFEazhCSbJHSkLFHVMUg==
    ooEY6emagN4CcyklJzR79JRMRycINXDqiM+zZHW11gR0FthQC7ZAE1VQtUPrgwyWLTPGxrIEtG5CW4DOAludIle8JFVc30qvNGqvlGKKQVFbC9wEdBY4JFbK2WAiyltio4/cOg==
    iqoGDbBxqn6K1AR0Flhlbkh2yFgsC9TgTio2JFxcncdQO10T0FlgGVJgNKQkLfItKpusOfKCkPjH0zgyP9wCdBbYU42xQtznKgpFyzSJs9QRSxTCKqmb0Cags8BcuJQCidRQIg==
    XEYqoJkTVVb2OCH9yPKDFqCzwC4n4o0gjugspEjO5iIGi0mjAMu1wE3AiMAcNf6+Ur5cYGoNS9qbKIIQlFGjDMowr7M1KQcy8pyuBRgROCqV5FxTVUl56hIyQTaCUoe+XZZexw==
    JSTf6EY6jhZgzCQCY2rop2eohxUaB5Mdp9KJfd6yQpdK3Fozti2iCRgRGKWS1jPVw7imlTLJ0kMKbYSP2ufSVMgUY6K1DTcBnQUuJbhJHIGVamHQWpKItBskKgOnhahtuAnoLA==
    cCrPBMtSDfRmyK/MWqW0Tw4xqsSp+ilSE9BbYF+2xOUQZS4TvagSHGImwQeROGVGBG4BegusqJfUE0qsFVFReJQwXgqPwJqJr+fWmoDeTsfRi1mJwEOVYI47JNhIg2QBfU80dQ==
    tdYE9Ha6lCPSllYeHhNR21okL6UcT3AkObIXqQnoLHD2RpLgFWU+CprRnTmXI1MxS5cJrefWmoD/zwLX9WUbMSJyomhRDzH6fn+ww8P94rq8veW3rxcfdsvtN/ujOtaru2VZtw==
    /umXfz4WoRePu83hhgf4DDde1qkgVSunUM8pa5DCJdeZMhZRbNQpvgl48bZnmKNzZV4exTIVTHCUy+hEVIQ/ltl5pUfm6FqAEYHRPcp98p+hESjbvlw2ZdWg8N5br03ZX6V8tg==
    AmVo3Qi0AJ0FDkagDbXcy7LHx5aDPbSFCAExmsWRVbJNQGeBmRY8uuRQYTARjXSek2gpzyZ7xUZWtjQBIwLzpFEYziMwTUaahD4EI1SWUcCHmLeaaRpoeaJQNwItQGeBTeQW2Q==
    TzsiuAgsO6lpWW9FLUpPOfL4rAnoLHC5TNk7rjV3gnDntSLK4BNhY+Aj6y6agN4jnHkiPOcU9LDTx3CFMUO84pJYI0ZGuAUYEVgYZe1M88wKLbRyaEs9eNF0GhMST5aw5EhZtg==
    OzKD1AB0FjgymkSWsSweFZRzbyXNNjLmk89qbKFICzAW1gQ97BSZIdNJVabhbQiJCZeM0+XYDOlIzpaHkfOCmoDOAsNXytW5KI2od6WDRt4K6FMtXF/WcbgJ6CywKkW8jBgtCw==
    k5TchMAViUr67PBRLXAT0Flgwog0qAwwSLgeAqpLEUGA5kSQzUYmZJqA3gJT68ojMBZ4hI8ntHghO2+y1tY6UzcCTUBngaMRMQSfRUhRcEpgnppbmpiJOfFcz280Ab1tGB2dKA==
    KTbpJFzZEpakNxReb7wmdGzdRQPQWWATMC4xEuUTMi0aAySsLJF/aUo0i7rTagI6C2xJpI7aRMuUW/LG5GRdLJWtocGPLIlsAjoLHKywnticJBKYdxyyRJHK7pTECZd14mgCeg==
    j3AIMREbUgpKsLK+nCFjCc2YCiLrupZoAjoL7Mp5KVkqT9EEqyA9mkx0mCwTptPY+rcmoHdqZugfUNUSdGkCdYKLlJNsSIrw+zCy2KkJ6G3DAQNms0plI6ukZdOl5Rpdmo+shA==
    gdqGW4DOAlNcNJgy04B6xgqDiyftnc9EBqNV/eihCeidmjPlSpYJBa1FZNKLcrRORB9kQ1kLVKfmFqB3ao4BYTV7UwYsGnTD+9NGLTo3mVI9kdIE9E7NPnMEJAjBjAi+rIiOtg==
    LLxCF2TcyGk2TUDvEebozQXLStmyVyl5xKZyfENZPchYqueZm4DeApc1FKJsmBFMoGz0nmSSlSGKSD12umMT0NvptBIocb3CdYVDe+Zj9DqXbTScxVQ/emgCOgvsrdaIR0qUVQ==
    upQwQw1lER+iTlCR1VGiCegssKAuJKQAqBi1TMgoucoyaPQ/zug4YsNNQO/UjKCambdoIjloPS5MfZA5OImxG9kM2wR0Flh7ipTKqS7HTgjPDOoBGlyMigVpXT0/3AT0NokceA==
    QMlY5puERzpINClK0UA4JAJbj3AT0Fngchyf8ULJoKigOVpBjdUUtVeUmqu6zW8CegucHXEKEYkjrTqL/tdIE4zLhlFlUl0PNwGdBUYW0FSwyIhESQD/QXAqC6JlhIXSkadITQ==
    QO8RtlJGagx8ngvBUOViCEttK7ItHVA9wi1AZ4HLCTRewBI1Qr9F165EJIS5ZBm0HmqnawI6Cywl3EV6laXkKLhy2XYZUtCocNG1jS12agF6l5cwSG40VaocD8+so0QYhFV07Q==
    aN91LXAT0FvgqKMsO/ZRxwhmreMhkRgU6kdb5BiZbm0AOgscDC1ngHsSYhJECVQyvhzAnqOEI8WRiZQWoHdYM/DwzGGZZcWHRscTCYc0XEGoPHKkahPQW2BBPCpGl+FLQupoAw==
    j4arsgcslJngWuAWoHvigGs7nssGKhGdtiUIcGYVIb6s1R1JHA1A72pNcEGQqDKDaZZNKFlwJxMKxfLIM9UzP01A78SRkP+9sJkmIRLyVlJoL1kgNnshxhJHC9A7NTPtE7GSwQ==
    lURZI5+RBQLNJQETxkY2sLQAnQXORnFpdMgaYXU4EoGU09jQshmdo6tbpCagd2p2ECBnJAOUt2XhCIccaHeg6BTsyPxwE9BZ4KRSzE7n4JkQuezDjOgnpJHSEJroyIn9LUBngQ==
    vUZgUqLsI6dCyuI+mZIyp4Mk5kcOrW0COgtMVBY06kysz0Iy4ygGjTKRSuMWc53pmoDeTpestUqUo+LKg4qy+gH5IAYjRcpyZLdCE9C7WkNREJQzzAYi4PqeoF9PRjsOXaOeqQ==
    q7UWoHeUYLg0Dw6jpYRHN2FRJITMPU9o3cfOvGoBeicOW85BIFJJnoXjaIJRfFHUC54a7/PIVs0WoLPAPOlyZJEJXhphcvTlPT4pKq4jatyR1xU1Ab2dzqocaEBjSfVwToZhng==
    cOYkjeWM+JFVvS1A7+LHlbPgtQmZSOFidA69mVSJoJRJ1I6cdt4C9B7haJ1HaYAGXYusMgpxFSlKG4NmzYxEiSagd2q2JKaAyB/Lzh/ufGkoYoqIA554OnJSdAvQW2D0Yk5Q6w==
    WWaClfUazmK8eJl1Kuc71AK3AJ0FphLj48orqJgSkfKyfsNwxjF8yLQjR1s3Ab2LH04Y6vASm9DxeNRgFjEAtQJKBW1z3eY3Ab0Th9aIUElrnqMwKbmMroFRH8uJ9tGP7EBvAQ==
    upeX5Vwzq40KuH4mzgqZKQ8ix2TVyIR2E9Db6bKNpftl3kYRk7eCKWdLKovO5JEjpJqA3tWaShzRiTlRjheQZaM2Kf/JmfCAMayrtRagd5SAozBfzsyVpY8MLjgrqXRa5fKyyw==
    kSjRAnQWmKTEUvSSmnIWeNYu80yiEYrKQN1IE9oEdBY4uAy+xFRZFMWptZKrQJFxSVmFPfJumiag9wgb4hFQLaUIryY5eJJHXZ6CGYJVXfw0Ab3j8LBcx3ItFUETHA3MM8lYng==
    wtEyY13H4Ragt8BERERTjE5ZA4o6wQjHGDGUIXzlsbNWWoDOAgvFmdTUEzQLiK7Z2qRtSJkmx+FfI0/zW4DOAmOwpLGeICgRQfGzpsmjuqWIUE6GsX0cDUBngTUPSKwGHSUaCA==
    y+BQ0qaydhkRyyCT1fPDLUBngdH9kqwIDRYDlrS3IShjaBZleZoemwxsAXqn5hC41lYFkrxQ2TlmJLIBmmLEghTqR7dNQG+TYKjCTTCcyygIzyZposKwfBUl+ZhJtAC9o0RmmQ==
    o0JUlCVBrDc2MgyfjNzSIM3I6ztbgN4mIVIoByfzsqEchbm3tJyKIFAhUJpZXcA3AZ0Fttw7oZVlVmihpUZLyYRPxkcdiBrpOJqA7okjBKuJRMerRTm7U2aGHxw6dgOXGkscDQ==
    QO/UjMIlMlIOUo7CkXLSVt6/8sJKm0cOh2kCOgvsuSc2MRG0N6KcXC7K8hKaNVJvYCPnBTUBnQV2yAOccJXKCcqMZpMRmxCyyu+ow0YW7bcAnQXOIrkUM82oYkQ5ZTuiJNC8nA==
    m5psIHUB3wT0ThypvHMcVWISQlgPHwrwdqbLnh2tRrrmJqCzwLScRsMTQYCS5byiss0sOOO49l5kN9KEtgC9nY6qWJ4OWs2NQMaCq2uvpMgyOeZG1q01AZ0Fhm+rstLTWZeFdQ==
    1CvKBVJYeUhEzEjx0wT0znTJR0XKYWwZTS9CVNQ+or7VxMbIRt7C1gT0NgkUWiRKFVk5cBRBNpHo0a1nxSwqm5F3IrQAIwJnFMpznbVCUL8gPzFd3s3hvDIpxmxMjJFyFAgjjw==
    bluAzgInhpog22Q59yKZ5NFeJqWZzsNm+1rgJmBEYMq52K+On8GGs83eMybKfnto2peNnSoHxaOTyo681KwF6CxwOagzluWIKaA0cMEoRx2RRBGD1mfk/UpNQGeB0TkyHyiV0g==
    chGDN8zkmLR1mjrnR5rQJqCzwI5GUvYL8PIgCHWjj6gamaEcA2ZMrgv4JqCzwD4arjllOecoAgKTkFygetQ+wKHGHsq0AJ0FJpYTYVAv0mQFDdoYxCpmS58prHR1Ad8E9I4Szg==
    Rc+jFVkrETxzJhpNTUZHbAiKxjpKtACdBeYQgKACy6gEMFTW2mzY8OAwIXCNPM1vAjoLnB0vj7XLKy6sSJF4jJ/QLmodUYiNrEhpAno7nWJJm1A2ZDDBifVM+uQl0SSy8k7R2g==
    6VqAzgIb6T1FKUO4g4aVGw5fRy1myrHP0tYz8E3AiMAxME6HCYDLBQ6m7DZE2xDg9ERza4lHCeZoWREcXS1wE9BZYHiP05FZFARa4P+9E1wb1LpJMitHDg9vAsZMIvNghwg9Qw==
    LUGNk9YxifZGJMLQQkSXWESIzZyPPONoAsbKy0zIfofHDFNVhrEkucyJ0aJhj2hFEqrFqMtJVHWmawJGBLaGoE+dyYaHTQ3od5P0RcNOIcgGRsqxHLDLkTdrtwAjAmvkxDQEvA==
    GQR2OaBvoCRgwJJC+KeKySRV1lyid68FbgE6C4xO18dQNs9GIyTTPtsQhbVwIXQSud5i2QR0FjiFgMxqpY5IXIE5X14zgno3e24IavTa6VqAzgJLXY4lVqQsuS9llzEKF4f/Ww==
    U55r1gI3AZ0Fzii74OMEfu+RPqPPCqGVOmOIdcmPHKnaAvS24ZxdtAltcHlZR3a+zDBEXR7JxihcPcJNwIjASumgZjrtvBxlgF5S5AC12vJ+p4ihQ3XrlZdspONoAsYyHdrp/Q==
    u61msOFcTogIaIR5WUqJoqC8IscJi2yr1chp501AZ4HRO6aAnr1U4DA07Sg6zJiIK6fNuJF3IjQBvUcYlVbUsEkuqdCUG++ky0o7EXkpF+sRbgFeKfDTTw9//X8AAAD//wMAUA==
    SwMEFAAGAAgAAAAhALE/uGIiAQAATgIAAB0AAAB3b3JkL2dsb3NzYXJ5L3dlYlNldHRpbmdzLnhtbJTSzUoDMRAA4LvgO4Tc22yLLbJ0WxCpCP6B1nuazrbBJBMyqdv16R3Xqg==
    SC/tLZPJfMwkmcx23ol3SGQxVHLQL6SAYHBlw7qSi5d571IKyjqstMMAlWyB5Gx6fjZpygaWz5AznyTBSqDSm0puco6lUmQ24DX1MULgZI3J68xhWiuv09s29gz6qLNdWmdzqw==
    hkUxlnsmHaNgXVsD12i2HkLu6lUCxyIG2thIP1pzjNZgWsWEBoh4Hu++Pa9t+GUGFweQtyYhYZ37PMy+o47i8kHRrbz7A0anAcMDYExwGjHaE4paDzspvClv1wGTXjqWeCTBXQ==
    iQ6WU35SjNl6+wFzTFcJG4Kkvrb5XtvH8Hp/10XaOWyeHm44UP9+wfQTAAD//wMAUEsDBBQABgAIAAxARksykpgSNQEAADwCAAARAAgBZG9jUHJvcHMvY29yZS54bWwgogQBKA==
    oAABAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAClUktOwzAQvUrkfWI7qVoUOakEiBWVkEACsTP2tDVN7MieNu3ZWHAkrg==
    QBLSIBA7dp55H8178sfbu1ge6yo6gA/G2YLwhJEIrHLa2E1B9riOL8iyFMp5uPOuAY8GQtRpbMi1KsgWsckpbfa+SpzfUK0oVFCDxUB5wimZuAi+Dn8KBmRiHoOZWG3bJm028A==
    UsY4fVrd3qst1DI2NqC0CkbVpAgDHJLuVNsha+driWFwaKTayQ30TnNaA0otUdI+WdxM0UgptMrD/uUVFEZ0mJQHic730w5OrfM6jIiGoLxpsOuu31Qy4Kqrbm1AX576jYeD6Q==
    my25oNNbjGV8GYOOusg5nhooyBl5zK6uH25ImTK+iDmL2fyBZzljeTpLUpbN0sXsWdBfPt/G9XjEv53PRqWgP79A+QlQSwECLQAUAAYACAAAACEAlAkdLMYBAACrCgAAEwAAAA==
    AAAAAAAAAAAAAAAAAABbQ29udGVudF9UeXBlc10ueG1sUEsBAi0AFAAGAAgAAAAhAB6RGrfvAAAATgIAAAsAAAAAAAAAAAAAAAAA/wMAAF9yZWxzLy5yZWxzUEsBAi0AFAAGAA==
    CAAAACEAsXElPl4BAADwBgAAHAAAAAAAAAAAAAAAAAAfBwAAd29yZC9fcmVscy9kb2N1bWVudC54bWwucmVsc1BLAQItABQABgAIAAxARkvBLEFNRhwAAEH2AQARAAAAAAAAAA==
    AAAAAAAAvwkAAHdvcmQvZG9jdW1lbnQueG1sUEsBAi0AFAAGAAgADEBGS8WWCsOYBAAAXREAABAAAAAAAAAAAAAAAAAANCYAAHdvcmQvaGVhZGVyMS54bWxQSwECLQAUAAYACA==
    AAxARkt5U3KOTgIAAPoJAAARAAAAAAAAAAAAAAAAAPoqAAB3b3JkL2VuZG5vdGVzLnhtbFBLAQItABQABgAIAAxARkuCOaAYTgIAAAAKAAASAAAAAAAAAAAAAAAAAHctAAB3bw==
    cmQvZm9vdG5vdGVzLnhtbFBLAQItAAoAAAAAAAAAIQBUAQa58gMAAPIDAAAVAAAAAAAAAAAAAAAAAPUvAAB3b3JkL21lZGlhL2ltYWdlMS5wbmdQSwECLQAUAAYACAAAACEAqg==
    UiXfIwYAAIsaAAAVAAAAAAAAAAAAAAAAABo0AAB3b3JkL3RoZW1lL3RoZW1lMS54bWxQSwECLQAUAAYACAAAACEApJ2I6nwJAAAGJgAAEQAAAAAAAAAAAAAAAABwOgAAd29yZA==
    L3NldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQDoPG52fAUAACUTAAAaAAAAAAAAAAAAAAAAABtEAAB3b3JkL2dsb3NzYXJ5L3NldHRpbmdzLnhtbFBLAQItABQABgAIAAAAIQ==
    AAotynS8BQAAqyAAABoAAAAAAAAAAAAAAAAAz0kAAHdvcmQvZ2xvc3NhcnkvZG9jdW1lbnQueG1sUEsBAi0AFAAGAAgAAAAhAIPQteXmAAAArQIAACUAAAAAAAAAAAAAAAAAww==
    TwAAd29yZC9nbG9zc2FyeS9fcmVscy9kb2N1bWVudC54bWwucmVsc1BLAQItABQABgAIAAAAIQB0Pzl6wgAAACgBAAAeAAAAAAAAAAAAAAAAAOxQAABjdXN0b21YbWwvX3JlbA==
    cy9pdGVtMS54bWwucmVsc1BLAQItABQABgAIAAxARktqKhzf4QEAAE4EAAAQAAAAAAAAAAAAAAAAAPJSAABkb2NQcm9wcy9hcHAueG1sUEsBAi0AFAAGAAgAAAAhAHcBChTEAA==
    AAAyAQAAEwAAAAAAAAAAAAAAAAAJVgAAY3VzdG9tWG1sL2l0ZW0yLnhtbFBLAQItABQABgAIAAAAIQC/3Agj4QAAAFUBAAAYAAAAAAAAAAAAAAAAACZXAABjdXN0b21YbWwvaQ==
    dGVtUHJvcHMyLnhtbFBLAQItABQABgAIAAAAIQBcliciwgAAACgBAAAeAAAAAAAAAAAAAAAAAGVYAABjdXN0b21YbWwvX3JlbHMvaXRlbTIueG1sLnJlbHNQSwECLQAUAAYACA==
    AAAAIQCcvcrM/AAAAE4BAAAYAAAAAAAAAAAAAAAAAGtaAABjdXN0b21YbWwvaXRlbVByb3BzMS54bWxQSwECLQAUAAYACAAMQEZLXxaIH70HAADOSAAAEwAAAAAAAAAAAAAAAA==
    AMVbAABjdXN0b21YbWwvaXRlbTEueG1sUEsBAi0AFAAGAAgAAAAhAIc40ivXAQAARwYAABsAAAAAAAAAAAAAAAAA22MAAHdvcmQvZ2xvc3NhcnkvZm9udFRhYmxlLnhtbFBLAQ==
    Ai0AFAAGAAgAAAAhAI4uezTxDwAAbagAAA8AAAAAAAAAAAAAAAAA62UAAHdvcmQvc3R5bGVzLnhtbFBLAQItABQABgAIAAAAIQA6l+/UqAEAAPgGAAAUAAAAAAAAAAAAAAAAAA==
    CXYAAHdvcmQvd2ViU2V0dGluZ3MueG1sUEsBAi0AFAAGAAgAAAAhAIc40ivXAQAARwYAABIAAAAAAAAAAAAAAAAA43cAAHdvcmQvZm9udFRhYmxlLnhtbFBLAQItABQABgAIAA==
    AAAhAMRUBW13JAAARwwBABgAAAAAAAAAAAAAAAAA6nkAAHdvcmQvZ2xvc3Nhcnkvc3R5bGVzLnhtbFBLAQItABQABgAIAAAAIQCxP7hiIgEAAE4CAAAdAAAAAAAAAAAAAAAAAA==
    l54AAHdvcmQvZ2xvc3Nhcnkvd2ViU2V0dGluZ3MueG1sUEsBAi0AFAAGAAgADEBGSzKSmBI1AQAAPAIAABEAAAAAAAAAAAAAAAAA9J8AAGRvY1Byb3BzL2NvcmUueG1sUEsFBg==
    AAAAABsAGwAkBwAAYKIAAAAA
    END_OF_WORDLAYOUT
  }
}

