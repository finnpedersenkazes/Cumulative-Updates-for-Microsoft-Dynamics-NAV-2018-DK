OBJECT Report 116 Statement
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kontoudtog;
               ENU=Statement];
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

                               Currency2.Code := '';
                               Currency2.INSERT;
                               COPYFILTER("Currency Filter",Currency.Code);
                               IF Currency.FIND('-') THEN
                                 REPEAT
                                   Currency2 := Currency;
                                   Currency2.INSERT;
                                 UNTIL Currency.NEXT = 0;
                             END;

               OnAfterGetRecord=VAR
                                  CustLedgerEntry@1000 : Record 21;
                                BEGIN
                                  AgingBandBuf.DELETEALL;
                                  CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                                  PrintLine := FALSE;
                                  Cust2 := Customer;
                                  COPYFILTER("Currency Filter",Currency2.Code);
                                  IF PrintAllHavingBal THEN BEGIN
                                    IF Currency2.FIND('-') THEN
                                      REPEAT
                                        Cust2.SETRANGE("Date Filter",0D,EndDate);
                                        Cust2.SETRANGE("Currency Filter",Currency2.Code);
                                        Cust2.CALCFIELDS("Net Change");
                                        PrintLine := Cust2."Net Change" <> 0;
                                      UNTIL (Currency2.NEXT = 0) OR PrintLine;
                                  END;
                                  IF (NOT PrintLine) AND PrintAllHavingEntry THEN BEGIN
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
                                        Text003 + FORMAT("Last Statement No."),'');
                                  IsFirstLoop := FALSE;
                                END;

               ReqFilterFields=No.,Search Name,Print Statements,Currency Filter }

    { 108 ;1   ;Column  ;No_Cust             ;
               SourceExpr="No." }

    { 5444;1   ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               PrintOnlyIfDetail=Yes }

    { 63  ;2   ;Column  ;CompanyInfo1Picture ;
               SourceExpr=CompanyInfo1.Picture }

    { 61  ;2   ;Column  ;CompanyInfo2Picture ;
               SourceExpr=CompanyInfo2.Picture }

    { 52  ;2   ;Column  ;CompanyInfo3Picture ;
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

    { 14  ;2   ;Column  ;PhoneNo_CompanyInfo ;
               SourceExpr=CompanyInfo."Phone No." }

    { 15  ;2   ;Column  ;CustAddr6           ;
               SourceExpr=CustAddr[6] }

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

    { 16  ;2   ;Column  ;Total_Caption2      ;
               SourceExpr=Total_CaptionLbl }

    { 42  ;2   ;Column  ;CurrReportPageNoCaption;
               SourceExpr=CurrReportPageNoCaptionLbl }

    { 6523;2   ;DataItem;CurrencyLoop        ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               Customer.COPYFILTER("Currency Filter",Currency2.Code);
                             END;

               OnAfterGetRecord=VAR
                                  CustLedgerEntry@1000 : Record 21;
                                BEGIN
                                  IF Number = 1 THEN
                                    Currency2.FINDFIRST;

                                  REPEAT
                                    IF NOT IsFirstLoop THEN
                                      IsFirstLoop := TRUE
                                    ELSE
                                      IF Currency2.NEXT = 0 THEN
                                        CurrReport.BREAK;
                                    CustLedgerEntry.SETRANGE("Customer No.",Customer."No.");
                                    CustLedgerEntry.SETRANGE("Posting Date",0D,EndDate);
                                    CustLedgerEntry.SETRANGE("Currency Code",Currency2.Code);
                                    EntriesExists := NOT CustLedgerEntry.ISEMPTY;
                                  UNTIL EntriesExists;
                                  Cust2 := Customer;
                                  Cust2.SETRANGE("Date Filter",0D,StartDate - 1);
                                  Cust2.SETRANGE("Currency Filter",Currency2.Code);
                                  Cust2.CALCFIELDS("Net Change");
                                  StartBalance := Cust2."Net Change";
                                  CustBalance := Cust2."Net Change";
                                END;
                                 }

    { 4414;3   ;DataItem;CustLedgEntryHdr    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1)) }

    { 41  ;4   ;Column  ;Currency2Code_CustLedgEntryHdr;
               SourceExpr=STRSUBSTNO(Text001,CurrencyCode3) }

    { 77  ;4   ;Column  ;StartBalance        ;
               SourceExpr=StartBalance;
               AutoFormatType=1;
               AutoFormatExpr=Currency2.Code }

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
                               SETRANGE("Currency Code",Currency2.Code);

                               IF Currency2.Code = '' THEN BEGIN
                                 GLSetup.TESTFIELD("LCY Code");
                                 CurrencyCode3 := GLSetup."LCY Code"
                               END ELSE
                                 CurrencyCode3 := Currency2.Code;

                               IsFirstPrintLine := TRUE;
                             END;

               OnAfterGetRecord=VAR
                                  CustLedgerEntry@1000 : Record 21;
                                BEGIN
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
                                      END;
                                    "Entry Type"::Application:
                                      BEGIN
                                        DtldCustLedgEntries2.SETCURRENTKEY("Customer No.","Posting Date","Entry Type");
                                        DtldCustLedgEntries2.SETRANGE("Customer No.","Customer No.");
                                        DtldCustLedgEntries2.SETRANGE("Posting Date","Posting Date");
                                        DtldCustLedgEntries2.SETRANGE("Entry Type","Entry Type"::Application);
                                        DtldCustLedgEntries2.SETRANGE("Transaction No.","Transaction No.");
                                        DtldCustLedgEntries2.SETFILTER("Currency Code",'<>%1',"Currency Code");
                                        IF NOT DtldCustLedgEntries2.ISEMPTY THEN BEGIN
                                          Description := Text005;
                                          DueDate := 0D;
                                        END ELSE
                                          PrintLine := FALSE;
                                      END;
                                    "Entry Type"::"Payment Discount",
                                    "Entry Type"::"Payment Discount (VAT Excl.)",
                                    "Entry Type"::"Payment Discount (VAT Adjustment)",
                                    "Entry Type"::"Payment Discount Tolerance",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                                      BEGIN
                                        Description := Text006;
                                        DueDate := 0D;
                                      END;
                                    "Entry Type"::"Payment Tolerance",
                                    "Entry Type"::"Payment Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Tolerance (VAT Adjustment)":
                                      BEGIN
                                        Description := Text014;
                                        DueDate := 0D;
                                      END;
                                    "Entry Type"::"Appln. Rounding",
                                    "Entry Type"::"Correction of Remaining Amount":
                                      BEGIN
                                        Description := Text007;
                                        DueDate := 0D;
                                      END;
                                  END;

                                  IF PrintLine THEN BEGIN
                                    CustBalance := CustBalance + Amount;
                                    IsNewCustCurrencyGroup := IsFirstPrintLine;
                                    IsFirstPrintLine := FALSE;
                                    ClearCompanyPicture;
                                  END;
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
               SourceExpr=Currency2.Code }

    { 7720;3   ;DataItem;CustLedgEntryFooter ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnAfterGetRecord=BEGIN
                                  ClearCompanyPicture;
                                END;
                                 }

    { 51  ;4   ;Column  ;CurrencyCode3_CustLedgEntryFooter;
               SourceExpr=CurrencyCode3 }

    { 2   ;4   ;Column  ;Total_Caption       ;
               SourceExpr=Total_CaptionLbl }

    { 71  ;4   ;Column  ;CustBalance_CustLedgEntryHdrFooter;
               SourceExpr=CustBalance;
               AutoFormatType=1;
               AutoFormatExpr=Currency2.Code }

    { 98  ;4   ;Column  ;EntriesExistsl_CustLedgEntryFooterCaption;
               SourceExpr=EntriesExists }

    { 9065;3   ;DataItem;CustLedgEntry2      ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.,Open,Positive,Due Date);
               OnPreDataItem=BEGIN
                               CurrReport.CREATETOTALS("Remaining Amount");
                               IF NOT IncludeAgingBand THEN
                                 SETRANGE("Due Date",0D,EndDate - 1);
                               SETRANGE("Currency Code",Currency2.Code);
                               IF (NOT PrintEntriesDue) AND (NOT IncludeAgingBand) THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=VAR
                                  CustLedgEntry@1000 : Record 21;
                                BEGIN
                                  IF IncludeAgingBand THEN BEGIN
                                    IF ("Posting Date" > EndDate) AND ("Due Date" >= EndDate) THEN
                                      CurrReport.SKIP;
                                    IF DateChoice = DateChoice::"Due Date" THEN
                                      IF "Due Date" >= EndDate THEN
                                        CurrReport.SKIP;
                                  END;
                                  CustLedgEntry := CustLedgEntry2;
                                  CustLedgEntry.SETRANGE("Date Filter",0D,EndDate);
                                  CustLedgEntry.CALCFIELDS("Remaining Amount");
                                  "Remaining Amount" := CustLedgEntry."Remaining Amount";
                                  IF CustLedgEntry."Remaining Amount" = 0 THEN
                                    CurrReport.SKIP;

                                  IF IncludeAgingBand AND ("Posting Date" <= EndDate) THEN
                                    UpdateBuffer(Currency2.Code,GetDate("Posting Date","Due Date"),"Remaining Amount");
                                  IF "Due Date" >= EndDate THEN
                                    CurrReport.SKIP;

                                  ClearCompanyPicture;
                                END;

               DataItemLinkReference=Customer;
               DataItemLink=Customer No.=FIELD(No.) }

    { 76  ;4   ;Column  ;OverDueEntries      ;
               SourceExpr=STRSUBSTNO(Text002,Currency2.Code) }

    { 56  ;4   ;Column  ;RemainAmt_CustLedgEntry2;
               SourceExpr="Remaining Amount";
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 57  ;4   ;Column  ;PostDate_CustLedgEntry2;
               SourceExpr=FORMAT("Posting Date") }

    { 58  ;4   ;Column  ;DocNo_CustLedgEntry2;
               SourceExpr="Document No." }

    { 59  ;4   ;Column  ;Desc_CustLedgEntry2 ;
               SourceExpr=Description }

    { 60  ;4   ;Column  ;DueDate_CustLedgEntry2;
               SourceExpr=FORMAT("Due Date") }

    { 70  ;4   ;Column  ;OriginalAmt_CustLedgEntry2;
               SourceExpr="Original Amount";
               AutoFormatExpr="Currency Code" }

    { 74  ;4   ;Column  ;CurrCode_CustLedgEntry2;
               SourceExpr="Currency Code" }

    { 99  ;4   ;Column  ;PrintEntriesDue     ;
               SourceExpr=PrintEntriesDue }

    { 100 ;4   ;Column  ;Currency2Code_CustLedgEntry2;
               SourceExpr=Currency2.Code }

    { 73  ;4   ;Column  ;CurrencyCode3_CustLedgEntry2;
               SourceExpr=CurrencyCode3 }

    { 8460;4   ;Column  ;CustNo_CustLedgEntry2;
               SourceExpr="Customer No." }

    { 1154;2   ;DataItem;AgingBandLoop       ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT IncludeAgingBand THEN
                                 CurrReport.BREAK;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN BEGIN
                                    ClearCompanyPicture;
                                    IF NOT AgingBandBuf.FIND('-') THEN
                                      CurrReport.BREAK;
                                  END ELSE
                                    IF AgingBandBuf.NEXT = 0 THEN
                                      CurrReport.BREAK;
                                  AgingBandCurrencyCode := AgingBandBuf."Currency Code";
                                  IF AgingBandCurrencyCode = '' THEN
                                    AgingBandCurrencyCode := GLSetup."LCY Code";
                                END;
                                 }

    { 81  ;3   ;Column  ;AgingDate1          ;
               SourceExpr=FORMAT(AgingDate[1] + 1) }

    { 82  ;3   ;Column  ;AgingDate2          ;
               SourceExpr=FORMAT(AgingDate[2]) }

    { 83  ;3   ;Column  ;AgingDate21         ;
               SourceExpr=FORMAT(AgingDate[2] + 1) }

    { 84  ;3   ;Column  ;AgingDate3          ;
               SourceExpr=FORMAT(AgingDate[3]) }

    { 89  ;3   ;Column  ;AgingDate31         ;
               SourceExpr=FORMAT(AgingDate[3] + 1) }

    { 90  ;3   ;Column  ;AgingDate4          ;
               SourceExpr=FORMAT(AgingDate[4]) }

    { 53  ;3   ;Column  ;AgingBandEndingDate ;
               SourceExpr=STRSUBSTNO(Text011,AgingBandEndingDate,PeriodLength,SELECTSTR(DateChoice + 1,Text013)) }

    { 91  ;3   ;Column  ;AgingDate41         ;
               SourceExpr=FORMAT(AgingDate[4] + 1) }

    { 92  ;3   ;Column  ;AgingDate5          ;
               SourceExpr=FORMAT(AgingDate[5]) }

    { 79  ;3   ;Column  ;AgingBandBufCol1Amt ;
               SourceExpr=AgingBandBuf."Column 1 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=AgingBandBuf."Currency Code" }

    { 85  ;3   ;Column  ;AgingBandBufCol2Amt ;
               SourceExpr=AgingBandBuf."Column 2 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=AgingBandBuf."Currency Code" }

    { 86  ;3   ;Column  ;AgingBandBufCol3Amt ;
               SourceExpr=AgingBandBuf."Column 3 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=AgingBandBuf."Currency Code" }

    { 87  ;3   ;Column  ;AgingBandBufCol4Amt ;
               SourceExpr=AgingBandBuf."Column 4 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=AgingBandBuf."Currency Code" }

    { 88  ;3   ;Column  ;AgingBandBufCol5Amt ;
               SourceExpr=AgingBandBuf."Column 5 Amt.";
               AutoFormatType=1;
               AutoFormatExpr=AgingBandBuf."Currency Code" }

    { 80  ;3   ;Column  ;AgingBandCurrencyCode;
               SourceExpr=AgingBandCurrencyCode }

    { 62  ;3   ;Column  ;beforeCaption       ;
               SourceExpr=beforeCaptionLbl }

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
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k�rslen behandler oplysninger fra.;
                             ENU=Specifies the date from which the report or batch job processes information.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=StartDate }

      { 11  ;2   ;Field     ;
                  Name=End Date;
                  CaptionML=[DAN=Slutdato;
                             ENU=End Date];
                  ToolTipML=[DAN=Angiver den dato, som rapporten eller k�rslen behandler oplysninger frem til.;
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
                  CaptionML=[DAN=Medtag ogs� debitorer, der kun har saldo;
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
                  CaptionML=[DAN=Medtag tilbagef�rte poster;
                             ENU=Include Reversed Entries];
                  ToolTipML=[DAN=Angiver, om du vil medtage tilbagef�rte poster i rapporten.;
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
                  ToolTipML=[DAN=Angiver, om der skal medtages et aldersfordelingsinterval i rapporten. Hvis du markerer dette afkrydsningsfelt, skal du ogs� udfylde felterne Aldersfordelingsinterval og Aldersford.intv. efter.;
                             ENU=Specifies if you want an aging band to be included in the document. If you place a check mark here, you must also fill in the Aging Band Period Length and Aging Band by fields.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=IncludeAgingBand }

      { 7   ;3   ;Field     ;
                  Name=AgingBandPeriodLengt;
                  CaptionML=[DAN=Aldersfordelingsinterval;
                             ENU=Aging Band Period Length];
                  ToolTipML=[DAN=Angiver l�ngden p� hver af de fire perioder i aldersfordelingsintervallet. Angiv f.eks. "1M" for �n m�ned. Den seneste periode slutter p� den sidste dag i den periode, der er angivet i feltet Datofilter.;
                             ENU=Specifies the length of each of the four periods in the aging band, for example, enter "1M" for one month. The most recent period will end on the last day of the period in the Date Filter field.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PeriodLength }

      { 6   ;3   ;Field     ;
                  Name=AgingBandby;
                  CaptionML=[DAN=Aldersford.intv. efter;
                             ENU=Aging Band by];
                  ToolTipML=[DAN=Angiver, om aldersfordelingsintervallet skal beregnes ud fra forfaldsdatoen eller fra bogf�ringsdatoen.;
                             ENU=Specifies if the aging band will be calculated from the due date or from the posting date.];
                  OptionCaptionML=[DAN=Forfaldsdato,Bogf�ringsdato;
                                   ENU=Due Date,Posting Date];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=DateChoice }

      { 4   ;2   ;Field     ;
                  Name=LogInteraction;
                  CaptionML=[DAN=Logf�r interaktion;
                             ENU=Log Interaction];
                  ToolTipML=[DAN=Angiver, at interaktioner med kontakten er logf�rt.;
                             ENU=Specifies that interactions with the contact are logged.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=LogInteraction;
                  Enabled=LogInteractionEnable }

      { 19  ;1   ;Group     ;
                  Name=Output Options;
                  CaptionML=[DAN=Rapportindstillinger;
                             ENU=Output Options];
                  GroupType=Group }

      { 18  ;2   ;Field     ;
                  Name=ReportOutput;
                  CaptionML=[DAN=Rapportresultat;
                             ENU=Report Output];
                  ToolTipML=[DAN=Angiver udl�sningen af den planlagte rapport s�som PDF eller Word.;
                             ENU=Specifies the output of the scheduled report, such as PDF or Word.];
                  OptionCaptionML=[DAN=Udskriv,Vis eksempel,PDF,Email,Excel,XML;
                                   ENU=Print,Preview,PDF,Email,Excel,XML];
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
                                 SupportedOutputMethod::PDF:
                                   ChosenOutputMethod := CustomLayoutReporting.GetPDFOption;
                                 SupportedOutputMethod::Email:
                                   ChosenOutputMethod := CustomLayoutReporting.GetEmailOption;
                                 SupportedOutputMethod::Excel:
                                   ChosenOutputMethod := CustomLayoutReporting.GetExcelOption;
                                 SupportedOutputMethod::XML:
                                   ChosenOutputMethod := CustomLayoutReporting.GetXMLOption;
                               END;
                             END;
                              }

      { 20  ;2   ;Field     ;
                  Name=ChosenOutput;
                  CaptionML=[DAN=Valgt output;
                             ENU=Chosen Output];
                  ToolTipML=[DAN=Angiver, hvordan rapporten skal eksporteres, f.eks. til udskrivning eller Excel.;
                             ENU=Specifies how to output the report, such as Print or Excel.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ChosenOutputMethod;
                  Visible=False }

      { 17  ;2   ;Group     ;
                  Name=EmailOptions;
                  CaptionML=[DAN=Mail-indstillinger;
                             ENU=Email Options];
                  Visible=ShowPrintRemaining;
                  GroupType=Group }

      { 16  ;3   ;Field     ;
                  Name=PrintMissingAddresses;
                  CaptionML=[DAN=Udskriv resterende kontoudtog;
                             ENU=Print remaining statements];
                  ToolTipML=[DAN=Angiver, om du vil udskrive de resterende kontoudtog.;
                             ENU=Specifies if you want to print remaining statements.];
                  ApplicationArea=#Advanced;
                  SourceExpr=PrintRemaining }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Poster %1;ENU=Entries %1';
      Text002@1002 : TextConst 'DAN=Forfaldne poster %1;ENU=Overdue Entries %1';
      Text003@1003 : TextConst 'DAN="Kontoudtog ";ENU="Statement "';
      GLSetup@1004 : Record 98;
      SalesSetup@1052 : Record 311;
      CompanyInfo@1005 : Record 79;
      CompanyInfo1@1051 : Record 79;
      CompanyInfo2@1050 : Record 79;
      CompanyInfo3@1049 : Record 79;
      Cust2@1006 : Record 18;
      Currency@1007 : Record 4;
      Currency2@1008 : TEMPORARY Record 4;
      Language@1009 : Record 8;
      DtldCustLedgEntries2@1034 : Record 379;
      AgingBandBuf@1037 : TEMPORARY Record 47;
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
      Text005@1027 : TextConst 'DAN=Multivaluta;ENU=Multicurrency Application';
      Text006@1028 : TextConst 'DAN=Kontantrabat;ENU=Payment Discount';
      Text007@1029 : TextConst 'DAN=Afrunding;ENU=Rounding';
      PeriodLength@1032 : DateFormula;
      PeriodLength2@1046 : DateFormula;
      DateChoice@1035 : 'Due Date,Posting Date';
      AgingDate@1036 : ARRAY [5] OF Date;
      Text008@1038 : TextConst 'DAN=Du skal angive l�ngden af aldersfordelingsintervallet.;ENU=You must specify the Aging Band Period Length.';
      AgingBandEndingDate@1040 : Date;
      Text010@1044 : TextConst 'DAN=Du skal angive en slutdato for aldersfordelingsintervallet.;ENU=You must specify Aging Band Ending Date.';
      Text011@1041 : TextConst 'DAN=Aldersfordelt oversigt efter %1 (%2 efter %3);ENU=Aged Summary by %1 (%2 by %3)';
      IncludeAgingBand@1043 : Boolean;
      Text012@1039 : TextConst 'DAN=Periodel�ngden er ugyldig.;ENU=Period Length is out of range.';
      AgingBandCurrencyCode@1042 : Code[20];
      Text013@1025 : TextConst 'DAN=Forfaldsdato,Bogf�ringsdato;ENU=Due Date,Posting Date';
      Text014@1045 : TextConst 'DAN=Udligningsafskrivninger;ENU=Application Writeoffs';
      LogInteractionEnable@19003940 : Boolean INDATASET;
      Text036@1070 : TextConst '@@@=Negating the period length: %1 is the period length;DAN=-%1;ENU=-%1';
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
      PostDate_DtldCustLedgEntriesCaptionLbl@1432 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      DueDate_CustLedgEntry2CaptionLbl@1175 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      CustBalanceCaptionLbl@2935 : TextConst 'DAN=Saldo;ENU=Balance';
      beforeCaptionLbl@1964 : TextConst 'DAN=..f�r;ENU=..before';
      isInitialized@1090 : Boolean;
      CompanyInfoHomepageCaptionLbl@3493 : TextConst 'DAN=Hjemmeside;ENU=Home Page';
      CompanyInfoEmailCaptionLbl@1765 : TextConst 'DAN=Mail;ENU=Email';
      DocDateCaptionLbl@6175 : TextConst 'DAN=Bilagsdato;ENU=Document Date';
      Total_CaptionLbl@1000 : TextConst 'DAN=I alt;ENU=Total';
      BlankStartDateErr@1053 : TextConst 'DAN=Startdato skal indeholde en v�rdi.;ENU=Start Date must have a value.';
      BlankEndDateErr@1054 : TextConst 'DAN=Slutdato skal indeholde en v�rdi.;ENU=End Date must have a value.';
      StartDateLaterTheEndDateErr@1055 : TextConst 'DAN=Startdatoen skal ligge f�r slutdatoen.;ENU=Start date must be earlier than End date.';
      IsFirstLoop@1056 : Boolean;
      CurrReportPageNoCaptionLbl@1057 : TextConst 'DAN=Side;ENU=Page';
      IsFirstPrintLine@1058 : Boolean;
      IsNewCustCurrencyGroup@1059 : Boolean;
      SupportedOutputMethod@1060 : 'Print,Preview,PDF,Email,Excel,XML';
      ChosenOutputMethod@1064 : Integer;
      PrintRemaining@1062 : Boolean;
      ShowPrintRemaining@1061 : Boolean INDATASET;
      FirstCustomerPrinted@1033 : Boolean;

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
        ERROR(Text010);
      IF FORMAT(PeriodLength) = '' THEN
        ERROR(Text008);
      EVALUATE(PeriodLength2,STRSUBSTNO(Text036,PeriodLength));
      AgingDate[5] := AgingBandEndingDate;
      AgingDate[4] := CALCDATE(PeriodLength2,AgingDate[5]);
      AgingDate[3] := CALCDATE(PeriodLength2,AgingDate[4]);
      AgingDate[2] := CALCDATE(PeriodLength2,AgingDate[3]);
      AgingDate[1] := CALCDATE(PeriodLength2,AgingDate[2]);
      IF AgingDate[2] <= AgingDate[1] THEN
        ERROR(Text012);
    END;

    LOCAL PROCEDURE UpdateBuffer@2(CurrencyCode@1000 : Code[10];Date@1001 : Date;Amount@1002 : Decimal);
    VAR
      I@1003 : Integer;
      GoOn@1004 : Boolean;
    BEGIN
      AgingBandBuf.INIT;
      AgingBandBuf."Currency Code" := CurrencyCode;
      IF NOT AgingBandBuf.FIND THEN
        AgingBandBuf.INSERT;
      I := 1;
      GoOn := TRUE;
      WHILE (I <= 5) AND GoOn DO BEGIN
        IF Date <= AgingDate[I] THEN
          IF I = 1 THEN BEGIN
            AgingBandBuf."Column 1 Amt." := AgingBandBuf."Column 1 Amt." + Amount;
            GoOn := FALSE;
          END;
        IF Date <= AgingDate[I] THEN
          IF I = 2 THEN BEGIN
            AgingBandBuf."Column 2 Amt." := AgingBandBuf."Column 2 Amt." + Amount;
            GoOn := FALSE;
          END;
        IF Date <= AgingDate[I] THEN
          IF I = 3 THEN BEGIN
            AgingBandBuf."Column 3 Amt." := AgingBandBuf."Column 3 Amt." + Amount;
            GoOn := FALSE;
          END;
        IF Date <= AgingDate[I] THEN
          IF I = 4 THEN BEGIN
            AgingBandBuf."Column 4 Amt." := AgingBandBuf."Column 4 Amt." + Amount;
            GoOn := FALSE;
          END;
        IF Date <= AgingDate[I] THEN
          IF I = 5 THEN BEGIN
            AgingBandBuf."Column 5 Amt." := AgingBandBuf."Column 5 Amt." + Amount;
            GoOn := FALSE;
          END;
        I := I + 1;
      END;
      AgingBandBuf.MODIFY;
    END;

    PROCEDURE SkipReversedUnapplied@4(VAR DtldCustLedgEntries@1000 : Record 379) : Boolean;
    VAR
      CustLedgEntry@1001 : Record 21;
    BEGIN
      IF PrintReversedEntries AND PrintUnappliedEntries THEN
        EXIT(FALSE);
      IF NOT PrintUnappliedEntries THEN
        IF DtldCustLedgEntries.Unapplied THEN
          EXIT(TRUE);
      IF NOT PrintReversedEntries THEN BEGIN
        CustLedgEntry.GET(DtldCustLedgEntries."Cust. Ledger Entry No.");
        IF CustLedgEntry.Reversed THEN
          EXIT(TRUE);
      END;
      EXIT(FALSE);
    END;

    PROCEDURE InitializeRequest@5(NewPrintEntriesDue@1000 : Boolean;NewPrintAllHavingEntry@1001 : Boolean;NewPrintAllHavingBal@1002 : Boolean;NewPrintReversedEntries@1003 : Boolean;NewPrintUnappliedEntries@1004 : Boolean;NewIncludeAgingBand@1005 : Boolean;NewPeriodLength@1006 : Text[30];NewDateChoice@1007 : Option;NewLogInteraction@1008 : Boolean;NewStartDate@1009 : Date;NewEndDate@1010 : Date);
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

    LOCAL PROCEDURE IsReportInPreviewMode@8() : Boolean;
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

    LOCAL PROCEDURE ClearCompanyPicture@15();
    BEGIN
      IF FirstCustomerPrinted THEN BEGIN
        CLEAR(CompanyInfo.Picture);
        CLEAR(CompanyInfo1.Picture);
        CLEAR(CompanyInfo2.Picture);
        CLEAR(CompanyInfo3.Picture);
      END;
      FirstCustomerPrinted := TRUE;
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
        <Field Name="Total_Caption2">
          <DataField>Total_Caption2</DataField>
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
                                                                      <Value>=LAST(Fields!Total_Caption2.Value) &amp; " " &amp;LAST(Fields!CurrencyCode3.Value)</Value>
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
}

