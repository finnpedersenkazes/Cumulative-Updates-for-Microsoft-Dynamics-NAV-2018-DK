OBJECT Report 595 Adjust Exchange Rates
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    Permissions=TableData 21=rimd,
                TableData 25=rimd,
                TableData 86=rimd,
                TableData 254=rimd,
                TableData 379=rimd,
                TableData 380=rimd;
    CaptionML=[DAN=Kursreguler valutabeholdninger;
               ENU=Adjust Exchange Rates];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  IF EndDateReq = 0D THEN
                    EndDate := DMY2DATE(31,12,9999)
                  ELSE
                    EndDate := EndDateReq;
                  IF PostingDocNo = '' THEN
                    ERROR(Text000,GenJnlLine.FIELDCAPTION("Document No."));
                  IF NOT AdjCustVendBank AND AdjGLAcc THEN
                    IF NOT CONFIRM(Text001 + Text004,FALSE) THEN
                      ERROR(Text005);

                  SourceCodeSetup.GET;

                  IF ExchRateAdjReg.FINDLAST THEN
                    ExchRateAdjReg.INIT;

                  GLSetup.GET;

                  IF AdjGLAcc THEN BEGIN
                    GLSetup.TESTFIELD("Additional Reporting Currency");

                    Currency3.GET(GLSetup."Additional Reporting Currency");
                    "G/L Account".GET(Currency3.GetRealizedGLGainsAccount);
                    "G/L Account".TESTFIELD("Exchange Rate Adjustment","G/L Account"."Exchange Rate Adjustment"::"No Adjustment");

                    "G/L Account".GET(Currency3.GetRealizedGLLossesAccount);
                    "G/L Account".TESTFIELD("Exchange Rate Adjustment","G/L Account"."Exchange Rate Adjustment"::"No Adjustment");

                    WITH VATPostingSetup2 DO
                      IF FIND('-') THEN
                        REPEAT
                          IF "VAT Calculation Type" <> "VAT Calculation Type"::"Sales Tax" THEN BEGIN
                            CheckExchRateAdjustment(
                              "Purchase VAT Account",TABLECAPTION,FIELDCAPTION("Purchase VAT Account"));
                            CheckExchRateAdjustment(
                              "Reverse Chrg. VAT Acc.",TABLECAPTION,FIELDCAPTION("Reverse Chrg. VAT Acc."));
                            CheckExchRateAdjustment(
                              "Purch. VAT Unreal. Account",TABLECAPTION,FIELDCAPTION("Purch. VAT Unreal. Account"));
                            CheckExchRateAdjustment(
                              "Reverse Chrg. VAT Unreal. Acc.",TABLECAPTION,FIELDCAPTION("Reverse Chrg. VAT Unreal. Acc."));
                            CheckExchRateAdjustment(
                              "Sales VAT Account",TABLECAPTION,FIELDCAPTION("Sales VAT Account"));
                            CheckExchRateAdjustment(
                              "Sales VAT Unreal. Account",TABLECAPTION,FIELDCAPTION("Sales VAT Unreal. Account"));
                          END;
                        UNTIL NEXT = 0;

                    WITH TaxJurisdiction2 DO
                      IF FIND('-') THEN
                        REPEAT
                          CheckExchRateAdjustment(
                            "Tax Account (Purchases)",TABLECAPTION,FIELDCAPTION("Tax Account (Purchases)"));
                          CheckExchRateAdjustment(
                            "Reverse Charge (Purchases)",TABLECAPTION,FIELDCAPTION("Reverse Charge (Purchases)"));
                          CheckExchRateAdjustment(
                            "Unreal. Tax Acc. (Purchases)",TABLECAPTION,FIELDCAPTION("Unreal. Tax Acc. (Purchases)"));
                          CheckExchRateAdjustment(
                            "Unreal. Rev. Charge (Purch.)",TABLECAPTION,FIELDCAPTION("Unreal. Rev. Charge (Purch.)"));
                          CheckExchRateAdjustment(
                            "Tax Account (Sales)",TABLECAPTION,FIELDCAPTION("Tax Account (Sales)"));
                          CheckExchRateAdjustment(
                            "Unreal. Tax Acc. (Sales)",TABLECAPTION,FIELDCAPTION("Unreal. Tax Acc. (Sales)"));
                        UNTIL NEXT = 0;

                    AddCurrCurrencyFactor :=
                      CurrExchRate2.ExchangeRateAdjmt(PostingDate,GLSetup."Additional Reporting Currency");
                  END;
                END;

    OnPostReport=BEGIN
                   UpdateAnalysisView.UpdateAll(0,TRUE);

                   IF TotalCustomersAdjusted + TotalVendorsAdjusted + TotalBankAccountsAdjusted + TotalGLAccountsAdjusted < 1 THEN
                     MESSAGE(NothingToAdjustMsg)
                   ELSE
                     MESSAGE(RatesAdjustedMsg);
                 END;

  }
  DATASET
  {
    { 4146;    ;DataItem;                    ;
               DataItemTable=Table4;
               DataItemTableView=SORTING(Code);
               OnPreDataItem=BEGIN
                               CheckPostingDate;
                               IF NOT AdjCustVendBank THEN
                                 CurrReport.BREAK;

                               Window.OPEN(
                                 Text006 +
                                 Text007 +
                                 Text008 +
                                 Text009 +
                                 Text010);

                               CustNoTotal := Customer.COUNT;
                               VendNoTotal := Vendor.COUNT;
                               COPYFILTER(Code,"Bank Account"."Currency Code");
                               FILTERGROUP(2);
                               "Bank Account".SETFILTER("Currency Code",'<>%1','');
                               FILTERGROUP(0);
                               BankAccNoTotal := "Bank Account".COUNT;
                               "Bank Account".RESET;
                             END;

               OnAfterGetRecord=BEGIN
                                  "Last Date Adjusted" := PostingDate;
                                  MODIFY;

                                  "Currency Factor" :=
                                    CurrExchRate.ExchangeRateAdjmt(PostingDate,Code);

                                  Currency2 := Currency;
                                  Currency2.INSERT;
                                END;

               OnPostDataItem=BEGIN
                                IF (Code = '') AND AdjCustVendBank THEN
                                  ERROR(Text011);
                              END;

               ReqFilterFields=Code }

    { 4558;1   ;DataItem;                    ;
               DataItemTable=Table270;
               DataItemTableView=SORTING(Bank Acc. Posting Group);
               OnPreDataItem=BEGIN
                               SETRANGE("Date Filter",StartDate,EndDate);
                               TempDimBuf2.DELETEALL;
                             END;

               OnAfterGetRecord=BEGIN
                                  TempEntryNoAmountBuf.DELETEALL;
                                  BankAccNo := BankAccNo + 1;
                                  Window.UPDATE(1,ROUND(BankAccNo / BankAccNoTotal * 10000,1));

                                  TempDimSetEntry.RESET;
                                  TempDimSetEntry.DELETEALL;
                                  TempDimBuf.RESET;
                                  TempDimBuf.DELETEALL;

                                  CALCFIELDS("Balance at Date","Balance at Date (LCY)");
                                  AdjBase := "Balance at Date";
                                  AdjBaseLCY := "Balance at Date (LCY)";
                                  AdjAmount :=
                                    ROUND(
                                      CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                                        PostingDate,Currency.Code,"Balance at Date",Currency."Currency Factor")) -
                                    "Balance at Date (LCY)";

                                  IF AdjAmount <> 0 THEN BEGIN
                                    GenJnlLine.VALIDATE("Posting Date",PostingDate);
                                    GenJnlLine."Document No." := PostingDocNo;
                                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                                    GenJnlLine.VALIDATE("Account No.","No.");
                                    GenJnlLine.Description := PADSTR(STRSUBSTNO(PostingDescription,Currency.Code,AdjBase),MAXSTRLEN(GenJnlLine.Description));
                                    GenJnlLine.VALIDATE(Amount,0);
                                    GenJnlLine."Amount (LCY)" := AdjAmount;
                                    GenJnlLine."Source Currency Code" := Currency.Code;
                                    IF Currency.Code = GLSetup."Additional Reporting Currency" THEN
                                      GenJnlLine."Source Currency Amount" := 0;
                                    GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
                                    GenJnlLine."System-Created Entry" := TRUE;
                                    GetJnlLineDefDim(GenJnlLine,TempDimSetEntry);
                                    CopyDimSetEntryToDimBuf(TempDimSetEntry,TempDimBuf);
                                    PostGenJnlLine(GenJnlLine,TempDimSetEntry);
                                    WITH TempEntryNoAmountBuf DO BEGIN
                                      INIT;
                                      "Business Unit Code" := '';
                                      "Entry No." := "Entry No." + 1;
                                      Amount := AdjAmount;
                                      Amount2 := AdjBase;
                                      INSERT;
                                    END;
                                    TempDimBuf2.INIT;
                                    TempDimBuf2."Table ID" := TempEntryNoAmountBuf."Entry No.";
                                    TempDimBuf2."Entry No." := GetDimCombID(TempDimBuf);
                                    TempDimBuf2.INSERT;
                                    TotalAdjBase := TotalAdjBase + AdjBase;
                                    TotalAdjBaseLCY := TotalAdjBaseLCY + AdjBaseLCY;
                                    TotalAdjAmount := TotalAdjAmount + AdjAmount;
                                    Window.UPDATE(4,TotalAdjAmount);

                                    IF TempEntryNoAmountBuf.Amount <> 0 THEN BEGIN
                                      TempDimSetEntry.RESET;
                                      TempDimSetEntry.DELETEALL;
                                      TempDimBuf.RESET;
                                      TempDimBuf.DELETEALL;
                                      TempDimBuf2.SETRANGE("Table ID",TempEntryNoAmountBuf."Entry No.");
                                      IF TempDimBuf2.FINDFIRST THEN
                                        DimBufMgt.GetDimensions(TempDimBuf2."Entry No.",TempDimBuf);
                                      DimMgt.CopyDimBufToDimSetEntry(TempDimBuf,TempDimSetEntry);
                                      IF TempEntryNoAmountBuf.Amount > 0 THEN
                                        PostAdjmt(
                                          Currency.GetRealizedGainsAccount,-TempEntryNoAmountBuf.Amount,TempEntryNoAmountBuf.Amount2,
                                          "Currency Code",TempDimSetEntry,PostingDate,'')
                                      ELSE
                                        PostAdjmt(
                                          Currency.GetRealizedLossesAccount,-TempEntryNoAmountBuf.Amount,TempEntryNoAmountBuf.Amount2,
                                          "Currency Code",TempDimSetEntry,PostingDate,'');
                                    END;
                                  END;
                                  TempDimBuf2.DELETEALL;
                                END;

               DataItemLink=Currency Code=FIELD(Code) }

    { 3273;2   ;DataItem;BankAccountGroupTotal;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               MaxIteration=1;
               OnAfterGetRecord=VAR
                                  BankAccount@1102601000 : Record 270;
                                  GroupTotal@1102601001 : Boolean;
                                BEGIN
                                  BankAccount.COPY("Bank Account");
                                  IF BankAccount.NEXT = 1 THEN BEGIN
                                    IF BankAccount."Bank Acc. Posting Group" <> "Bank Account"."Bank Acc. Posting Group" THEN
                                      GroupTotal := TRUE;
                                  END ELSE
                                    GroupTotal := TRUE;

                                  IF GroupTotal THEN
                                    IF TotalAdjAmount <> 0 THEN BEGIN
                                      AdjExchRateBufferUpdate(
                                        "Bank Account"."Currency Code","Bank Account"."Bank Acc. Posting Group",
                                        TotalAdjBase,TotalAdjBaseLCY,TotalAdjAmount,0,0,0,PostingDate,'');
                                      InsertExchRateAdjmtReg(3,"Bank Account"."Bank Acc. Posting Group","Bank Account"."Currency Code");
                                      TotalBankAccountsAdjusted += 1;
                                      AdjExchRateBuffer.RESET;
                                      AdjExchRateBuffer.DELETEALL;
                                      TotalAdjBase := 0;
                                      TotalAdjBaseLCY := 0;
                                      TotalAdjAmount := 0;
                                    END;
                                END;
                                 }

    { 6836;    ;DataItem;                    ;
               DataItemTable=Table18;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=BEGIN
                               IF NOT AdjCustVendBank THEN
                                 CurrReport.BREAK;

                               DtldCustLedgEntry.LOCKTABLE;
                               CustLedgerEntry.LOCKTABLE;

                               CustNo := 0;

                               IF DtldCustLedgEntry.FIND('+') THEN
                                 NewEntryNo := DtldCustLedgEntry."Entry No." + 1
                               ELSE
                                 NewEntryNo := 1;

                               CLEAR(DimMgt);
                               TempEntryNoAmountBuf.DELETEALL;
                             END;

               OnAfterGetRecord=BEGIN
                                  CustNo := CustNo + 1;
                                  Window.UPDATE(2,ROUND(CustNo / CustNoTotal * 10000,1));

                                  TempCustLedgerEntry.DELETEALL;

                                  Currency.COPYFILTER(Code,CustLedgerEntry."Currency Code");
                                  CustLedgerEntry.FILTERGROUP(2);
                                  CustLedgerEntry.SETFILTER("Currency Code",'<>%1','');
                                  CustLedgerEntry.FILTERGROUP(0);

                                  DtldCustLedgEntry.RESET;
                                  DtldCustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date","Entry Type");
                                  DtldCustLedgEntry.SETRANGE("Customer No.","No.");
                                  DtldCustLedgEntry.SETRANGE("Posting Date",CALCDATE('<+1D>',EndDate),DMY2DATE(31,12,9999));
                                  IF DtldCustLedgEntry.FIND('-') THEN
                                    REPEAT
                                      CustLedgerEntry."Entry No." := DtldCustLedgEntry."Cust. Ledger Entry No.";
                                      IF CustLedgerEntry.FIND('=') THEN
                                        IF (CustLedgerEntry."Posting Date" >= StartDate) AND
                                           (CustLedgerEntry."Posting Date" <= EndDate)
                                        THEN BEGIN
                                          TempCustLedgerEntry."Entry No." := CustLedgerEntry."Entry No.";
                                          IF TempCustLedgerEntry.INSERT THEN;
                                        END;
                                    UNTIL DtldCustLedgEntry.NEXT = 0;

                                  CustLedgerEntry.SETCURRENTKEY("Customer No.",Open);
                                  CustLedgerEntry.SETRANGE("Customer No.","No.");
                                  CustLedgerEntry.SETRANGE(Open,TRUE);
                                  CustLedgerEntry.SETRANGE("Posting Date",0D,EndDate);
                                  IF CustLedgerEntry.FIND('-') THEN
                                    REPEAT
                                      TempCustLedgerEntry."Entry No." := CustLedgerEntry."Entry No.";
                                      IF TempCustLedgerEntry.INSERT THEN;
                                    UNTIL CustLedgerEntry.NEXT = 0;
                                  CustLedgerEntry.RESET;
                                END;

               OnPostDataItem=BEGIN
                                IF CustNo <> 0 THEN
                                  HandlePostAdjmt(1); // Customer
                              END;
                               }

    { 3687;1   ;DataItem;CustomerLedgerEntryLoop;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF NOT TempCustLedgerEntry.FIND('-') THEN
                                 CurrReport.BREAK;
                               FirstEntry := TRUE;
                             END;

               OnAfterGetRecord=BEGIN
                                  TempDtldCustLedgEntrySums.DELETEALL;

                                  IF FirstEntry THEN BEGIN
                                    TempCustLedgerEntry.FIND('-');
                                    FirstEntry := FALSE
                                  END ELSE
                                    IF TempCustLedgerEntry.NEXT = 0 THEN
                                      CurrReport.BREAK;
                                  CustLedgerEntry.GET(TempCustLedgerEntry."Entry No.");
                                  AdjustCustomerLedgerEntry(CustLedgerEntry,PostingDate);
                                END;
                                 }

    { 6942;2   ;DataItem;                    ;
               DataItemTable=Table379;
               DataItemTableView=SORTING(Cust. Ledger Entry No.,Posting Date);
               OnPreDataItem=BEGIN
                               SETCURRENTKEY("Cust. Ledger Entry No.");
                               SETRANGE("Cust. Ledger Entry No.",CustLedgerEntry."Entry No.");
                               SETFILTER("Posting Date",'%1..',CALCDATE('<+1D>',PostingDate));
                             END;

               OnAfterGetRecord=BEGIN
                                  AdjustCustomerLedgerEntry(CustLedgerEntry,"Posting Date");
                                END;
                                 }

    { 3182;    ;DataItem;                    ;
               DataItemTable=Table23;
               DataItemTableView=SORTING(No.);
               OnPreDataItem=BEGIN
                               IF NOT AdjCustVendBank THEN
                                 CurrReport.BREAK;

                               DtldVendLedgEntry.LOCKTABLE;
                               VendorLedgerEntry.LOCKTABLE;

                               VendNo := 0;
                               IF DtldVendLedgEntry.FIND('+') THEN
                                 NewEntryNo := DtldVendLedgEntry."Entry No." + 1
                               ELSE
                                 NewEntryNo := 1;

                               CLEAR(DimMgt);
                               TempEntryNoAmountBuf.DELETEALL;
                             END;

               OnAfterGetRecord=BEGIN
                                  VendNo := VendNo + 1;
                                  Window.UPDATE(3,ROUND(VendNo / VendNoTotal * 10000,1));

                                  TempVendorLedgerEntry.DELETEALL;

                                  Currency.COPYFILTER(Code,VendorLedgerEntry."Currency Code");
                                  VendorLedgerEntry.FILTERGROUP(2);
                                  VendorLedgerEntry.SETFILTER("Currency Code",'<>%1','');
                                  VendorLedgerEntry.FILTERGROUP(0);

                                  DtldVendLedgEntry.RESET;
                                  DtldVendLedgEntry.SETCURRENTKEY("Vendor No.","Posting Date","Entry Type");
                                  DtldVendLedgEntry.SETRANGE("Vendor No.","No.");
                                  DtldVendLedgEntry.SETRANGE("Posting Date",CALCDATE('<+1D>',EndDate),DMY2DATE(31,12,9999));
                                  IF DtldVendLedgEntry.FIND('-') THEN
                                    REPEAT
                                      VendorLedgerEntry."Entry No." := DtldVendLedgEntry."Vendor Ledger Entry No.";
                                      IF VendorLedgerEntry.FIND('=') THEN
                                        IF (VendorLedgerEntry."Posting Date" >= StartDate) AND
                                           (VendorLedgerEntry."Posting Date" <= EndDate)
                                        THEN BEGIN
                                          TempVendorLedgerEntry."Entry No." := VendorLedgerEntry."Entry No.";
                                          IF TempVendorLedgerEntry.INSERT THEN;
                                        END;
                                    UNTIL DtldVendLedgEntry.NEXT = 0;

                                  VendorLedgerEntry.SETCURRENTKEY("Vendor No.",Open);
                                  VendorLedgerEntry.SETRANGE("Vendor No.","No.");
                                  VendorLedgerEntry.SETRANGE(Open,TRUE);
                                  VendorLedgerEntry.SETRANGE("Posting Date",0D,EndDate);
                                  IF VendorLedgerEntry.FIND('-') THEN
                                    REPEAT
                                      TempVendorLedgerEntry."Entry No." := VendorLedgerEntry."Entry No.";
                                      IF TempVendorLedgerEntry.INSERT THEN;
                                    UNTIL VendorLedgerEntry.NEXT = 0;
                                  VendorLedgerEntry.RESET;
                                END;

               OnPostDataItem=BEGIN
                                IF VendNo <> 0 THEN
                                  HandlePostAdjmt(2); // Vendor
                              END;
                               }

    { 1221;1   ;DataItem;VendorLedgerEntryLoop;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number);
               OnPreDataItem=BEGIN
                               IF NOT TempVendorLedgerEntry.FIND('-') THEN
                                 CurrReport.BREAK;
                               FirstEntry := TRUE;
                             END;

               OnAfterGetRecord=BEGIN
                                  TempDtldVendLedgEntrySums.DELETEALL;

                                  IF FirstEntry THEN BEGIN
                                    TempVendorLedgerEntry.FIND('-');
                                    FirstEntry := FALSE
                                  END ELSE
                                    IF TempVendorLedgerEntry.NEXT = 0 THEN
                                      CurrReport.BREAK;
                                  VendorLedgerEntry.GET(TempVendorLedgerEntry."Entry No.");
                                  AdjustVendorLedgerEntry(VendorLedgerEntry,PostingDate);
                                END;
                                 }

    { 2149;2   ;DataItem;                    ;
               DataItemTable=Table380;
               DataItemTableView=SORTING(Vendor Ledger Entry No.,Posting Date);
               OnPreDataItem=BEGIN
                               SETCURRENTKEY("Vendor Ledger Entry No.");
                               SETRANGE("Vendor Ledger Entry No.",VendorLedgerEntry."Entry No.");
                               SETFILTER("Posting Date",'%1..',CALCDATE('<+1D>',PostingDate));
                             END;

               OnAfterGetRecord=BEGIN
                                  AdjustVendorLedgerEntry(VendorLedgerEntry,"Posting Date");
                                END;
                                 }

    { 1756;    ;DataItem;                    ;
               DataItemTable=Table325;
               DataItemTableView=SORTING(VAT Bus. Posting Group,VAT Prod. Posting Group);
               OnPreDataItem=BEGIN
                               IF NOT AdjGLAcc OR
                                  (GLSetup."VAT Exchange Rate Adjustment" = GLSetup."VAT Exchange Rate Adjustment"::"No Adjustment")
                               THEN
                                 CurrReport.BREAK;

                               Window.OPEN(
                                 Text012 +
                                 Text013);

                               VATEntryNoTotal := VATEntry.COUNT;
                               IF NOT
                                  VATEntry.SETCURRENTKEY(
                                    Type,Closed,"VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date")
                               THEN
                                 VATEntry.SETCURRENTKEY(
                                   Type,Closed,"Tax Jurisdiction Code","Use Tax","Posting Date");
                               VATEntry.SETRANGE(Closed,FALSE);
                               VATEntry.SETRANGE("Posting Date",StartDate,EndDate);
                             END;

               OnAfterGetRecord=BEGIN
                                  VATEntryNo := VATEntryNo + 1;
                                  Window.UPDATE(1,ROUND(VATEntryNo / VATEntryNoTotal * 10000,1));

                                  VATEntry.SETRANGE("VAT Bus. Posting Group","VAT Bus. Posting Group");
                                  VATEntry.SETRANGE("VAT Prod. Posting Group","VAT Prod. Posting Group");

                                  IF "VAT Calculation Type" <> "VAT Calculation Type"::"Sales Tax" THEN BEGIN
                                    AdjustVATEntries(VATEntry.Type::Purchase,FALSE);
                                    IF (VATEntry2.Amount <> 0) OR (VATEntry2."Additional-Currency Amount" <> 0) THEN BEGIN
                                      AdjustVATAccount(
                                        GetPurchAccount(FALSE),
                                        VATEntry2.Amount,VATEntry2."Additional-Currency Amount",
                                        VATEntryTotalBase.Amount,VATEntryTotalBase."Additional-Currency Amount");
                                      IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN
                                        AdjustVATAccount(
                                          GetRevChargeAccount(FALSE),
                                          -VATEntry2.Amount,-VATEntry2."Additional-Currency Amount",
                                          -VATEntryTotalBase.Amount,-VATEntryTotalBase."Additional-Currency Amount");
                                    END;
                                    IF (VATEntry2."Remaining Unrealized Amount" <> 0) OR
                                       (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
                                    THEN BEGIN
                                      TESTFIELD("Unrealized VAT Type");
                                      AdjustVATAccount(
                                        GetPurchAccount(TRUE),
                                        VATEntry2."Remaining Unrealized Amount",
                                        VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                                        VATEntryTotalBase."Remaining Unrealized Amount",
                                        VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                                      IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN
                                        AdjustVATAccount(
                                          GetRevChargeAccount(TRUE),
                                          -VATEntry2."Remaining Unrealized Amount",
                                          -VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                                          -VATEntryTotalBase."Remaining Unrealized Amount",
                                          -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                                    END;

                                    AdjustVATEntries(VATEntry.Type::Sale,FALSE);
                                    IF (VATEntry2.Amount <> 0) OR (VATEntry2."Additional-Currency Amount" <> 0) THEN
                                      AdjustVATAccount(
                                        GetSalesAccount(FALSE),
                                        VATEntry2.Amount,VATEntry2."Additional-Currency Amount",
                                        VATEntryTotalBase.Amount,VATEntryTotalBase."Additional-Currency Amount");
                                    IF (VATEntry2."Remaining Unrealized Amount" <> 0) OR
                                       (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
                                    THEN BEGIN
                                      TESTFIELD("Unrealized VAT Type");
                                      AdjustVATAccount(
                                        GetSalesAccount(TRUE),
                                        VATEntry2."Remaining Unrealized Amount",
                                        VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                                        VATEntryTotalBase."Remaining Unrealized Amount",
                                        VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                                    END;
                                  END ELSE BEGIN
                                    IF TaxJurisdiction.FIND('-') THEN
                                      REPEAT
                                        VATEntry.SETRANGE("Tax Jurisdiction Code",TaxJurisdiction.Code);
                                        AdjustVATEntries(VATEntry.Type::Purchase,FALSE);
                                        AdjustPurchTax(FALSE);
                                        AdjustVATEntries(VATEntry.Type::Purchase,TRUE);
                                        AdjustPurchTax(TRUE);
                                        AdjustVATEntries(VATEntry.Type::Sale,FALSE);
                                        AdjustSalesTax;
                                      UNTIL TaxJurisdiction.NEXT = 0;
                                    VATEntry.SETRANGE("Tax Jurisdiction Code");
                                  END;
                                  CLEAR(VATEntryTotalBase);
                                END;
                                 }

    { 6710;    ;DataItem;                    ;
               DataItemTable=Table15;
               DataItemTableView=SORTING(No.)
                                 WHERE(Exchange Rate Adjustment=FILTER(Adjust Amount..Adjust Additional-Currency Amount));
               OnPreDataItem=BEGIN
                               IF NOT AdjGLAcc THEN
                                 CurrReport.BREAK;

                               Window.OPEN(
                                 Text014 +
                                 Text015);

                               GLAccNoTotal := COUNT;
                               SETRANGE("Date Filter",StartDate,EndDate);
                             END;

               OnAfterGetRecord=BEGIN
                                  GLAccNo := GLAccNo + 1;
                                  Window.UPDATE(1,ROUND(GLAccNo / GLAccNoTotal * 10000,1));
                                  IF "Exchange Rate Adjustment" = "Exchange Rate Adjustment"::"No Adjustment" THEN
                                    CurrReport.SKIP;

                                  TempDimSetEntry.RESET;
                                  TempDimSetEntry.DELETEALL;
                                  CALCFIELDS("Net Change","Additional-Currency Net Change");
                                  CASE "Exchange Rate Adjustment" OF
                                    "Exchange Rate Adjustment"::"Adjust Amount":
                                      PostGLAccAdjmt(
                                        "No.","Exchange Rate Adjustment"::"Adjust Amount",
                                        ROUND(
                                          CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                                            PostingDate,GLSetup."Additional Reporting Currency",
                                            "Additional-Currency Net Change",AddCurrCurrencyFactor) -
                                          "Net Change"),
                                        "Net Change",
                                        "Additional-Currency Net Change");
                                    "Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                                      PostGLAccAdjmt(
                                        "No.","Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
                                        ROUND(
                                          CurrExchRate2.ExchangeAmtLCYToFCY(
                                            PostingDate,GLSetup."Additional Reporting Currency",
                                            "Net Change",AddCurrCurrencyFactor) -
                                          "Additional-Currency Net Change",
                                          Currency3."Amount Rounding Precision"),
                                        "Net Change",
                                        "Additional-Currency Net Change");
                                  END;
                                END;

               OnPostDataItem=BEGIN
                                IF AdjGLAcc THEN BEGIN
                                  GenJnlLine."Document No." := PostingDocNo;
                                  GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                                  GenJnlLine."Posting Date" := PostingDate;
                                  GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";

                                  IF GLAmtTotal <> 0 THEN BEGIN
                                    IF GLAmtTotal < 0 THEN
                                      GenJnlLine."Account No." := Currency3.GetRealizedGLLossesAccount
                                    ELSE
                                      GenJnlLine."Account No." := Currency3.GetRealizedGLGainsAccount;
                                    GenJnlLine.Description :=
                                      STRSUBSTNO(
                                        PostingDescription,
                                        GLSetup."Additional Reporting Currency",
                                        GLAddCurrNetChangeTotal);
                                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
                                    GenJnlLine."Currency Code" := '';
                                    GenJnlLine.Amount := -GLAmtTotal;
                                    GenJnlLine."Amount (LCY)" := -GLAmtTotal;
                                    GetJnlLineDefDim(GenJnlLine,TempDimSetEntry);
                                    PostGenJnlLine(GenJnlLine,TempDimSetEntry);
                                  END;
                                  IF GLAddCurrAmtTotal <> 0 THEN BEGIN
                                    IF GLAddCurrAmtTotal < 0 THEN
                                      GenJnlLine."Account No." := Currency3.GetRealizedGLLossesAccount
                                    ELSE
                                      GenJnlLine."Account No." := Currency3.GetRealizedGLGainsAccount;
                                    GenJnlLine.Description :=
                                      STRSUBSTNO(
                                        PostingDescription,'',
                                        GLNetChangeTotal);
                                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                                    GenJnlLine."Currency Code" := GLSetup."Additional Reporting Currency";
                                    GenJnlLine.Amount := -GLAddCurrAmtTotal;
                                    GenJnlLine."Amount (LCY)" := 0;
                                    GetJnlLineDefDim(GenJnlLine,TempDimSetEntry);
                                    PostGenJnlLine(GenJnlLine,TempDimSetEntry);
                                  END;

                                  WITH ExchRateAdjReg DO BEGIN
                                    "No." := "No." + 1;
                                    "Creation Date" := PostingDate;
                                    "Account Type" := "Account Type"::"G/L Account";
                                    "Posting Group" := '';
                                    "Currency Code" := GLSetup."Additional Reporting Currency";
                                    "Currency Factor" := CurrExchRate2."Adjustment Exch. Rate Amount";
                                    "Adjusted Base" := 0;
                                    "Adjusted Base (LCY)" := GLNetChangeBase;
                                    "Adjusted Amt. (LCY)" := GLAmtTotal;
                                    "Adjusted Base (Add.-Curr.)" := GLAddCurrNetChangeBase;
                                    "Adjusted Amt. (Add.-Curr.)" := GLAddCurrAmtTotal;
                                    INSERT;
                                  END;

                                  TotalGLAccountsAdjusted += 1;
                                END;
                              END;
                               }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
      OnOpenPage=BEGIN
                   IF PostingDescription = '' THEN
                     PostingDescription := Text016;
                   IF NOT (AdjCustVendBank OR AdjGLAcc) THEN
                     AdjCustVendBank := TRUE;
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 21  ;2   ;Group     ;
                  CaptionML=[DAN=Valutakursreguleringsperiode;
                             ENU=Adjustment Period] }

      { 1   ;3   ;Field     ;
                  Name=StartingDate;
                  CaptionML=[DAN=Startdato;
                             ENU=Starting Date];
                  ToolTipML=[DAN=Angiver starten p� den periode, hvor posterne skal reguleres. Dette felt udfyldes normalt ikke, man du kan indtaste en dato.;
                             ENU=Specifies the beginning of the period for which entries are adjusted. This field is usually left blank, but you can enter a date.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=StartDate }

      { 2   ;3   ;Field     ;
                  Name=EndingDate;
                  CaptionML=[DAN=Slutdato;
                             ENU=Ending Date];
                  ToolTipML=[DAN=Angiver den sidste dato for regulering af poster. Denne dato er som regel den samme som bogf�ringsdatoen i feltet Bogf�ringsdato.;
                             ENU=Specifies the last date for which entries are adjusted. This date is usually the same as the posting date in the Posting Date field.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=EndDateReq;
                  OnValidate=BEGIN
                               PostingDate := EndDateReq;
                             END;
                              }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf�ringsbeskrivelse;
                             ENU=Posting Description];
                  ToolTipML=[DAN=Angiver tekst til de finansposter, der oprettes ved k�rslen. Som standard foresl�s Valutakursregulering p� %1 %2, hvor %1 erstattes af valutakoden, og %2 af det valutabel�b, der er reguleret, dvs. at teksten kunne v�re: Kursregulering af DEM 38.000.;
                             ENU=Specifies text for the general ledger entries that are created by the batch job. The default text is Exchange Rate Adjmt. of %1 %2, in which %1 is replaced by the currency code and %2 is replaced by the currency amount that is adjusted. For example, Exchange Rate Adjmt. of DEM 38,000.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PostingDescription }

      { 4   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf�ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver den dato, hvor finansposterne bogf�res. Denne dato er normalt den samme som slutdatoen i feltet Slutdato.;
                             ENU=Specifies the date on which the general ledger entries are posted. This date is usually the same as the ending date in the Ending Date field.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PostingDate;
                  OnValidate=BEGIN
                               CheckPostingDate;
                             END;
                              }

      { 5   ;2   ;Field     ;
                  Name=DocumentNo;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver det dokumentnummer, som skal vises p� de finansposter, der bliver oprettet ved k�rslen.;
                             ENU=Specifies the document number that will appear on the general ledger entries that are created by the batch job.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PostingDocNo }

      { 7   ;2   ;Field     ;
                  CaptionML=[DAN=Reguler debitor, kreditor og bankkonti;
                             ENU=Adjust Customer, Vendor and Bank Accounts];
                  ToolTipML=[DAN=Angiver, om du vil regulere for valutasvingninger i debitor, kreditor og bankkonti.;
                             ENU=Specifies if you want to adjust customer, vendor, and bank accounts for currency fluctuations.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=AdjCustVendBank;
                  MultiLine=Yes }

      { 9   ;2   ;Field     ;
                  Name=AdjGLAcc;
                  CaptionML=[DAN=Reguler finanskonti for ekstra rapp.valuta;
                             ENU=Adjust G/L Accounts for Add.-Reporting Currency];
                  ToolTipML=[DAN=Angiver, om du vil bogf�re i en ekstra rapporteringsvaluta og regulere finanskonti for valutasvingninger mellem den relevante regnskabsvaluta og den ekstra rapporteringsvaluta.;
                             ENU=Specifies if you want to post in an additional reporting currency and adjust general ledger accounts for currency fluctuations between LCY and the additional reporting currency.];
                  ApplicationArea=#Suite;
                  SourceExpr=AdjGLAcc;
                  MultiLine=Yes }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=%1 skal indtastes.;ENU=%1 must be entered.';
      Text001@1001 : TextConst 'DAN="Vil du regulere finansposter for valutakurssvingninger uden at regulere debitor-, kreditor- og bankposter? Dette kan resultere i forkerte kursreguleringer i forbindelse med debitorer, kreditorer og bankkonti.\\ ";ENU="Do you want to adjust general ledger entries for currency fluctuations without adjusting customer, vendor and bank ledger entries? This may result in incorrect currency adjustments to payables, receivables and bank accounts.\\ "';
      Text004@1004 : TextConst 'DAN=Vil du forts�tte?;ENU=Do you wish to continue?';
      Text005@1005 : TextConst 'DAN=Kursreguleringen er afbrudt.;ENU=The adjustment of exchange rates has been canceled.';
      Text006@1006 : TextConst 'DAN=Valutakurser reguleres...\\;ENU=Adjusting exchange rates...\\';
      Text007@1007 : TextConst 'DAN=Bankkonto        @1@@@@@@@@@@@@@\\;ENU=Bank Account    @1@@@@@@@@@@@@@\\';
      Text008@1008 : TextConst 'DAN=Debitor          @2@@@@@@@@@@@@@\;ENU=Customer        @2@@@@@@@@@@@@@\';
      Text009@1009 : TextConst 'DAN=Kreditor         @3@@@@@@@@@@@@@\;ENU=Vendor          @3@@@@@@@@@@@@@\';
      Text010@1010 : TextConst 'DAN=Regulering       #4#############;ENU=Adjustment      #4#############';
      Text011@1011 : TextConst 'DAN=Der er ikke fundet nogen valutaer.;ENU=No currencies have been found.';
      Text012@1012 : TextConst 'DAN=Regulerer momsposter ...\\;ENU=Adjusting VAT Entries...\\';
      Text013@1013 : TextConst 'DAN=Momspost         @1@@@@@@@@@@@@@;ENU=VAT Entry    @1@@@@@@@@@@@@@';
      Text014@1014 : TextConst 'DAN=Regulerer finans...\\;ENU=Adjusting general ledger...\\';
      Text015@1015 : TextConst 'DAN=Finanskonto      @1@@@@@@@@@@@@@;ENU=G/L Account    @1@@@@@@@@@@@@@';
      Text016@1016 : TextConst '@@@="%1 = Currency Code, %2= Adjust Amount";DAN=Kursregul. af %1 %2, val.kursjust.;ENU=Adjmt. of %1 %2, Ex.Rate Adjust.';
      Text017@1017 : TextConst 'DAN="Indholdet i %1 p� %2 %3 skal v�re %4. N�r denne %2 bruges i tabellen %5, bliver valutakursreguleringen defineret i feltet %6 i tabellen %7. %2 %3 bruges i feltet %8 i tabellen %5. ";ENU="%1 on %2 %3 must be %4. When this %2 is used in %5, the exchange rate adjustment is defined in the %6 field in the %7. %2 %3 is used in the %8 field in the %5. "';
      DtldCustLedgEntry@1019 : Record 379;
      TempDtldCustLedgEntry@1003 : TEMPORARY Record 379;
      TempDtldCustLedgEntrySums@1096 : TEMPORARY Record 379;
      DtldVendLedgEntry@1020 : Record 380;
      TempDtldVendLedgEntry@1018 : TEMPORARY Record 380;
      TempDtldVendLedgEntrySums@1098 : TEMPORARY Record 380;
      ExchRateAdjReg@1021 : Record 86;
      CustPostingGr@1022 : Record 92;
      VendPostingGr@1023 : Record 93;
      GenJnlLine@1024 : Record 81;
      SourceCodeSetup@1025 : Record 242;
      AdjExchRateBuffer@1026 : TEMPORARY Record 331;
      AdjExchRateBuffer2@1027 : TEMPORARY Record 331;
      Currency2@1028 : TEMPORARY Record 4;
      Currency3@1029 : Record 4;
      CurrExchRate@1030 : Record 330;
      CurrExchRate2@1031 : Record 330;
      GLSetup@1032 : Record 98;
      VATEntry@1033 : Record 254;
      VATEntry2@1034 : Record 254;
      VATEntryTotalBase@1035 : Record 254;
      TaxJurisdiction@1036 : Record 320;
      VATPostingSetup2@1037 : Record 325;
      TaxJurisdiction2@1038 : Record 320;
      TempDimBuf@1049 : TEMPORARY Record 360;
      TempDimBuf2@1090 : TEMPORARY Record 360;
      TempDimSetEntry@1050 : TEMPORARY Record 480;
      TempEntryNoAmountBuf@1079 : TEMPORARY Record 386;
      CustLedgerEntry@1083 : Record 21;
      TempCustLedgerEntry@1082 : TEMPORARY Record 21;
      VendorLedgerEntry@1081 : Record 25;
      TempVendorLedgerEntry@1085 : TEMPORARY Record 25;
      GenJnlPostLine@1039 : Codeunit 12;
      UpdateAnalysisView@1002 : Codeunit 410;
      DimMgt@1077 : Codeunit 408;
      DimBufMgt@1078 : Codeunit 411;
      Window@1040 : Dialog;
      TotalAdjBase@1087 : Decimal;
      TotalAdjBaseLCY@1086 : Decimal;
      TotalAdjAmount@1041 : Decimal;
      GainsAmount@1042 : Decimal;
      LossesAmount@1043 : Decimal;
      PostingDate@1044 : Date;
      PostingDescription@1045 : Text[50];
      AdjBase@1046 : Decimal;
      AdjBaseLCY@1047 : Decimal;
      AdjAmount@1048 : Decimal;
      CustNo@1051 : Decimal;
      CustNoTotal@1052 : Decimal;
      VendNo@1053 : Decimal;
      VendNoTotal@1054 : Decimal;
      BankAccNo@1055 : Decimal;
      BankAccNoTotal@1056 : Decimal;
      GLAccNo@1057 : Decimal;
      GLAccNoTotal@1058 : Decimal;
      GLAmtTotal@1059 : Decimal;
      GLAddCurrAmtTotal@1060 : Decimal;
      GLNetChangeTotal@1061 : Decimal;
      GLAddCurrNetChangeTotal@1062 : Decimal;
      GLNetChangeBase@1063 : Decimal;
      GLAddCurrNetChangeBase@1064 : Decimal;
      PostingDocNo@1065 : Code[20];
      StartDate@1066 : Date;
      EndDate@1067 : Date;
      EndDateReq@1068 : Date;
      Correction@1069 : Boolean;
      OK@1070 : Boolean;
      AdjCustVendBank@1071 : Boolean;
      AdjGLAcc@1072 : Boolean;
      AddCurrCurrencyFactor@1073 : Decimal;
      VATEntryNoTotal@1074 : Decimal;
      VATEntryNo@1075 : Decimal;
      NewEntryNo@1076 : Integer;
      Text018@1080 : TextConst 'DAN=Denne bogf�ringsdato kan ikke angives, fordi den ikke ligger i reguleringsperioden. Angiv bogf�ringsdatoen igen.;ENU=This posting date cannot be entered because it does not occur within the adjustment period. Reenter the posting date.';
      FirstEntry@1084 : Boolean;
      MaxAdjExchRateBufIndex@1089 : Integer;
      RatesAdjustedMsg@1088 : TextConst 'DAN=�n eller flere valutakurser er blevet justeret.;ENU=One or more currency exchange rates have been adjusted.';
      NothingToAdjustMsg@1091 : TextConst 'DAN=Der er intet at justere.;ENU=There is nothing to adjust.';
      TotalBankAccountsAdjusted@1092 : Integer;
      TotalCustomersAdjusted@1093 : Integer;
      TotalVendorsAdjusted@1094 : Integer;
      TotalGLAccountsAdjusted@1095 : Integer;

    LOCAL PROCEDURE PostAdjmt@1(GLAccNo@1000 : Code[20];PostingAmount@1001 : Decimal;AdjBase2@1002 : Decimal;CurrencyCode2@1003 : Code[10];VAR DimSetEntry@1004 : Record 480;PostingDate2@1005 : Date;ICCode@1006 : Code[20]) TransactionNo : Integer;
    BEGIN
      WITH GenJnlLine DO
        IF PostingAmount <> 0 THEN BEGIN
          INIT;
          VALIDATE("Posting Date",PostingDate2);
          "Document No." := PostingDocNo;
          "Account Type" := "Account Type"::"G/L Account";
          VALIDATE("Account No.",GLAccNo);
          Description := PADSTR(STRSUBSTNO(PostingDescription,CurrencyCode2,AdjBase2),MAXSTRLEN(Description));
          VALIDATE(Amount,PostingAmount);
          "Source Currency Code" := CurrencyCode2;
          "IC Partner Code" := ICCode;
          IF CurrencyCode2 = GLSetup."Additional Reporting Currency" THEN
            "Source Currency Amount" := 0;
          "Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
          "System-Created Entry" := TRUE;
          TransactionNo := PostGenJnlLine(GenJnlLine,DimSetEntry);
        END;
    END;

    LOCAL PROCEDURE InsertExchRateAdjmtReg@2(AdjustAccType@1000 : Integer;PostingGrCode@1001 : Code[20];CurrencyCode@1002 : Code[10]);
    BEGIN
      IF Currency2.Code <> CurrencyCode THEN
        Currency2.GET(CurrencyCode);

      WITH ExchRateAdjReg DO BEGIN
        "No." := "No." + 1;
        "Creation Date" := PostingDate;
        "Account Type" := AdjustAccType;
        "Posting Group" := PostingGrCode;
        "Currency Code" := Currency2.Code;
        "Currency Factor" := Currency2."Currency Factor";
        "Adjusted Base" := AdjExchRateBuffer.AdjBase;
        "Adjusted Base (LCY)" := AdjExchRateBuffer.AdjBaseLCY;
        "Adjusted Amt. (LCY)" := AdjExchRateBuffer.AdjAmount;
        INSERT;
      END;
    END;

    [External]
    PROCEDURE InitializeRequest@3(NewStartDate@1000 : Date;NewEndDate@1001 : Date;NewPostingDescription@1002 : Text[50];NewPostingDate@1003 : Date);
    BEGIN
      StartDate := NewStartDate;
      EndDate := NewEndDate;
      PostingDescription := NewPostingDescription;
      PostingDate := NewPostingDate;
      IF EndDate = 0D THEN
        EndDateReq := DMY2DATE(31,12,9999)
      ELSE
        EndDateReq := EndDate;
    END;

    [External]
    PROCEDURE InitializeRequest2@25(NewStartDate@1000 : Date;NewEndDate@1001 : Date;NewPostingDescription@1002 : Text[50];NewPostingDate@1003 : Date;NewPostingDocNo@1004 : Code[20];NewAdjCustVendBank@1005 : Boolean;NewAdjGLAcc@1006 : Boolean);
    BEGIN
      InitializeRequest(NewStartDate,NewEndDate,NewPostingDescription,NewPostingDate);
      PostingDocNo := NewPostingDocNo;
      AdjCustVendBank := NewAdjCustVendBank;
      AdjGLAcc := NewAdjGLAcc;
    END;

    LOCAL PROCEDURE AdjExchRateBufferUpdate@15(CurrencyCode2@1000 : Code[10];PostingGroup2@1001 : Code[20];AdjBase2@1002 : Decimal;AdjBaseLCY2@1003 : Decimal;AdjAmount2@1004 : Decimal;GainsAmount2@1005 : Decimal;LossesAmount2@1006 : Decimal;DimEntryNo@1007 : Integer;Postingdate2@1008 : Date;ICCode@1009 : Code[20]) : Integer;
    BEGIN
      AdjExchRateBuffer.INIT;
      OK := AdjExchRateBuffer.GET(CurrencyCode2,PostingGroup2,DimEntryNo,Postingdate2,ICCode);

      AdjExchRateBuffer.AdjBase := AdjExchRateBuffer.AdjBase + AdjBase2;
      AdjExchRateBuffer.AdjBaseLCY := AdjExchRateBuffer.AdjBaseLCY + AdjBaseLCY2;
      AdjExchRateBuffer.AdjAmount := AdjExchRateBuffer.AdjAmount + AdjAmount2;
      AdjExchRateBuffer.TotalGainsAmount := AdjExchRateBuffer.TotalGainsAmount + GainsAmount2;
      AdjExchRateBuffer.TotalLossesAmount := AdjExchRateBuffer.TotalLossesAmount + LossesAmount2;

      IF NOT OK THEN BEGIN
        AdjExchRateBuffer."Currency Code" := CurrencyCode2;
        AdjExchRateBuffer."Posting Group" := PostingGroup2;
        AdjExchRateBuffer."Dimension Entry No." := DimEntryNo;
        AdjExchRateBuffer."Posting Date" := Postingdate2;
        AdjExchRateBuffer."IC Partner Code" := ICCode;
        MaxAdjExchRateBufIndex += 1;
        AdjExchRateBuffer.Index := MaxAdjExchRateBufIndex;
        AdjExchRateBuffer.INSERT;
      END ELSE
        AdjExchRateBuffer.MODIFY;

      EXIT(AdjExchRateBuffer.Index);
    END;

    LOCAL PROCEDURE HandlePostAdjmt@7(AdjustAccType@1000 : Integer);
    VAR
      GLEntry@1001 : Record 17;
      TempDtldCVLedgEntryBuf@1002 : TEMPORARY Record 383;
    BEGIN
      IF AdjExchRateBuffer.FIND('-') THEN BEGIN
        // Summarize per currency and dimension combination
        REPEAT
          AdjExchRateBuffer2.INIT;
          OK :=
            AdjExchRateBuffer2.GET(
              AdjExchRateBuffer."Currency Code",
              '',
              AdjExchRateBuffer."Dimension Entry No.",
              AdjExchRateBuffer."Posting Date",
              AdjExchRateBuffer."IC Partner Code");
          AdjExchRateBuffer2.AdjBase := AdjExchRateBuffer2.AdjBase + AdjExchRateBuffer.AdjBase;
          AdjExchRateBuffer2.TotalGainsAmount := AdjExchRateBuffer2.TotalGainsAmount + AdjExchRateBuffer.TotalGainsAmount;
          AdjExchRateBuffer2.TotalLossesAmount := AdjExchRateBuffer2.TotalLossesAmount + AdjExchRateBuffer.TotalLossesAmount;
          IF NOT OK THEN BEGIN
            AdjExchRateBuffer2."Currency Code" := AdjExchRateBuffer."Currency Code";
            AdjExchRateBuffer2."Dimension Entry No." := AdjExchRateBuffer."Dimension Entry No.";
            AdjExchRateBuffer2."Posting Date" := AdjExchRateBuffer."Posting Date";
            AdjExchRateBuffer2."IC Partner Code" := AdjExchRateBuffer."IC Partner Code";
            AdjExchRateBuffer2.INSERT;
          END ELSE
            AdjExchRateBuffer2.MODIFY;
        UNTIL AdjExchRateBuffer.NEXT = 0;

        // Post per posting group and per currency
        IF AdjExchRateBuffer2.FIND('-') THEN
          REPEAT
            WITH AdjExchRateBuffer DO BEGIN
              SETRANGE("Currency Code",AdjExchRateBuffer2."Currency Code");
              SETRANGE("Dimension Entry No.",AdjExchRateBuffer2."Dimension Entry No.");
              SETRANGE("Posting Date",AdjExchRateBuffer2."Posting Date");
              SETRANGE("IC Partner Code",AdjExchRateBuffer2."IC Partner Code");
              TempDimBuf.RESET;
              TempDimBuf.DELETEALL;
              TempDimSetEntry.RESET;
              TempDimSetEntry.DELETEALL;
              FIND('-');
              DimBufMgt.GetDimensions("Dimension Entry No.",TempDimBuf);
              DimMgt.CopyDimBufToDimSetEntry(TempDimBuf,TempDimSetEntry);
              REPEAT
                TempDtldCVLedgEntryBuf.INIT;
                TempDtldCVLedgEntryBuf."Entry No." := Index;
                IF AdjAmount <> 0 THEN
                  CASE AdjustAccType OF
                    1: // Customer
                      BEGIN
                        CustPostingGr.GET("Posting Group");
                        TempDtldCVLedgEntryBuf."Transaction No." :=
                          PostAdjmt(
                            CustPostingGr.GetReceivablesAccount,AdjAmount,AdjBase,"Currency Code",TempDimSetEntry,
                            AdjExchRateBuffer2."Posting Date","IC Partner Code");
                        IF TempDtldCVLedgEntryBuf.INSERT THEN;
                        InsertExchRateAdjmtReg(1,"Posting Group","Currency Code");
                        TotalCustomersAdjusted += 1;
                      END;
                    2: // Vendor
                      BEGIN
                        VendPostingGr.GET("Posting Group");
                        TempDtldCVLedgEntryBuf."Transaction No." :=
                          PostAdjmt(
                            VendPostingGr.GetPayablesAccount,AdjAmount,AdjBase,"Currency Code",TempDimSetEntry,
                            AdjExchRateBuffer2."Posting Date","IC Partner Code");
                        IF TempDtldCVLedgEntryBuf.INSERT THEN;
                        InsertExchRateAdjmtReg(2,"Posting Group","Currency Code");
                        TotalVendorsAdjusted += 1;
                      END;
                  END;
              UNTIL NEXT = 0;
            END;

            WITH AdjExchRateBuffer2 DO BEGIN
              Currency2.GET("Currency Code");
              IF TotalGainsAmount <> 0 THEN
                PostAdjmt(
                  Currency2.GetUnrealizedGainsAccount,-TotalGainsAmount,AdjBase,"Currency Code",TempDimSetEntry,
                  "Posting Date","IC Partner Code");
              IF TotalLossesAmount <> 0 THEN
                PostAdjmt(
                  Currency2.GetUnrealizedLossesAccount,-TotalLossesAmount,AdjBase,"Currency Code",TempDimSetEntry,
                  "Posting Date","IC Partner Code");
            END;
          UNTIL AdjExchRateBuffer2.NEXT = 0;

        GLEntry.FINDLAST;
        CASE AdjustAccType OF
          1: // Customer
            IF TempDtldCustLedgEntry.FIND('-') THEN
              REPEAT
                IF TempDtldCVLedgEntryBuf.GET(TempDtldCustLedgEntry."Transaction No.") THEN
                  TempDtldCustLedgEntry."Transaction No." := TempDtldCVLedgEntryBuf."Transaction No."
                ELSE
                  TempDtldCustLedgEntry."Transaction No." := GLEntry."Transaction No.";
                DtldCustLedgEntry := TempDtldCustLedgEntry;
                DtldCustLedgEntry.INSERT(TRUE);
              UNTIL TempDtldCustLedgEntry.NEXT = 0;
          2: // Vendor
            IF TempDtldVendLedgEntry.FIND('-') THEN
              REPEAT
                IF TempDtldCVLedgEntryBuf.GET(TempDtldVendLedgEntry."Transaction No.") THEN
                  TempDtldVendLedgEntry."Transaction No." := TempDtldCVLedgEntryBuf."Transaction No."
                ELSE
                  TempDtldVendLedgEntry."Transaction No." := GLEntry."Transaction No.";
                DtldVendLedgEntry := TempDtldVendLedgEntry;
                DtldVendLedgEntry.INSERT(TRUE);
              UNTIL TempDtldVendLedgEntry.NEXT = 0;
        END;

        AdjExchRateBuffer.RESET;
        AdjExchRateBuffer.DELETEALL;
        AdjExchRateBuffer2.RESET;
        AdjExchRateBuffer2.DELETEALL;
        TempDtldCustLedgEntry.RESET;
        TempDtldCustLedgEntry.DELETEALL;
        TempDtldVendLedgEntry.RESET;
        TempDtldVendLedgEntry.DELETEALL;
      END;
    END;

    [Internal]
    LOCAL PROCEDURE AdjustVATEntries@12(VATType@1000 : Integer;UseTax@1001 : Boolean);
    BEGIN
      CLEAR(VATEntry2);
      WITH VATEntry DO BEGIN
        SETRANGE(Type,VATType);
        SETRANGE("Use Tax",UseTax);
        IF FIND('-') THEN
          REPEAT
            Accumulate(VATEntry2.Base,Base);
            Accumulate(VATEntry2.Amount,Amount);
            Accumulate(VATEntry2."Unrealized Amount","Unrealized Amount");
            Accumulate(VATEntry2."Unrealized Base","Unrealized Base");
            Accumulate(VATEntry2."Remaining Unrealized Amount","Remaining Unrealized Amount");
            Accumulate(VATEntry2."Remaining Unrealized Base","Remaining Unrealized Base");
            Accumulate(VATEntry2."Additional-Currency Amount","Additional-Currency Amount");
            Accumulate(VATEntry2."Additional-Currency Base","Additional-Currency Base");
            Accumulate(VATEntry2."Add.-Currency Unrealized Amt.","Add.-Currency Unrealized Amt.");
            Accumulate(VATEntry2."Add.-Currency Unrealized Base","Add.-Currency Unrealized Base");
            Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Amount","Add.-Curr. Rem. Unreal. Amount");
            Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Base","Add.-Curr. Rem. Unreal. Base");

            Accumulate(VATEntryTotalBase.Base,Base);
            Accumulate(VATEntryTotalBase.Amount,Amount);
            Accumulate(VATEntryTotalBase."Unrealized Amount","Unrealized Amount");
            Accumulate(VATEntryTotalBase."Unrealized Base","Unrealized Base");
            Accumulate(VATEntryTotalBase."Remaining Unrealized Amount","Remaining Unrealized Amount");
            Accumulate(VATEntryTotalBase."Remaining Unrealized Base","Remaining Unrealized Base");
            Accumulate(VATEntryTotalBase."Additional-Currency Amount","Additional-Currency Amount");
            Accumulate(VATEntryTotalBase."Additional-Currency Base","Additional-Currency Base");
            Accumulate(VATEntryTotalBase."Add.-Currency Unrealized Amt.","Add.-Currency Unrealized Amt.");
            Accumulate(VATEntryTotalBase."Add.-Currency Unrealized Base","Add.-Currency Unrealized Base");
            Accumulate(
              VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount","Add.-Curr. Rem. Unreal. Amount");
            Accumulate(VATEntryTotalBase."Add.-Curr. Rem. Unreal. Base","Add.-Curr. Rem. Unreal. Base");

            AdjustVATAmount(Base,"Additional-Currency Base");
            AdjustVATAmount(Amount,"Additional-Currency Amount");
            AdjustVATAmount("Unrealized Amount","Add.-Currency Unrealized Amt.");
            AdjustVATAmount("Unrealized Base","Add.-Currency Unrealized Base");
            AdjustVATAmount("Remaining Unrealized Amount","Add.-Curr. Rem. Unreal. Amount");
            AdjustVATAmount("Remaining Unrealized Base","Add.-Curr. Rem. Unreal. Base");
            MODIFY;

            Accumulate(VATEntry2.Base,-Base);
            Accumulate(VATEntry2.Amount,-Amount);
            Accumulate(VATEntry2."Unrealized Amount",-"Unrealized Amount");
            Accumulate(VATEntry2."Unrealized Base",-"Unrealized Base");
            Accumulate(VATEntry2."Remaining Unrealized Amount",-"Remaining Unrealized Amount");
            Accumulate(VATEntry2."Remaining Unrealized Base",-"Remaining Unrealized Base");
            Accumulate(VATEntry2."Additional-Currency Amount",-"Additional-Currency Amount");
            Accumulate(VATEntry2."Additional-Currency Base",-"Additional-Currency Base");
            Accumulate(VATEntry2."Add.-Currency Unrealized Amt.",-"Add.-Currency Unrealized Amt.");
            Accumulate(VATEntry2."Add.-Currency Unrealized Base",-"Add.-Currency Unrealized Base");
            Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Amount",-"Add.-Curr. Rem. Unreal. Amount");
            Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Base",-"Add.-Curr. Rem. Unreal. Base");
          UNTIL NEXT = 0;
      END;
    END;

    [Internal]
    LOCAL PROCEDURE AdjustVATAmount@4(VAR AmountLCY@1000 : Decimal;VAR AmountAddCurr@1001 : Decimal);
    BEGIN
      CASE GLSetup."VAT Exchange Rate Adjustment" OF
        GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
          AmountLCY :=
            ROUND(
              CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                PostingDate,GLSetup."Additional Reporting Currency",
                AmountAddCurr,AddCurrCurrencyFactor));
        GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
          AmountAddCurr :=
            ROUND(
              CurrExchRate2.ExchangeAmtLCYToFCY(
                PostingDate,GLSetup."Additional Reporting Currency",
                AmountLCY,AddCurrCurrencyFactor));
      END;
    END;

    LOCAL PROCEDURE AdjustVATAccount@13(AccNo@1000 : Code[20];AmountLCY@1001 : Decimal;AmountAddCurr@1002 : Decimal;BaseLCY@1003 : Decimal;BaseAddCurr@1004 : Decimal);
    BEGIN
      "G/L Account".GET(AccNo);
      "G/L Account".SETRANGE("Date Filter",StartDate,EndDate);
      CASE GLSetup."VAT Exchange Rate Adjustment" OF
        GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
          PostGLAccAdjmt(
            AccNo,GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount",
            -AmountLCY,BaseLCY,BaseAddCurr);
        GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
          PostGLAccAdjmt(
            AccNo,GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
            -AmountAddCurr,BaseLCY,BaseAddCurr);
      END;
    END;

    LOCAL PROCEDURE AdjustPurchTax@5(UseTax@1000 : Boolean);
    BEGIN
      IF (VATEntry2.Amount <> 0) OR (VATEntry2."Additional-Currency Amount" <> 0) THEN BEGIN
        TaxJurisdiction.TESTFIELD("Tax Account (Purchases)");
        AdjustVATAccount(
          TaxJurisdiction."Tax Account (Purchases)",
          VATEntry2.Amount,VATEntry2."Additional-Currency Amount",
          VATEntryTotalBase.Amount,VATEntryTotalBase."Additional-Currency Amount");
        IF UseTax THEN BEGIN
          TaxJurisdiction.TESTFIELD("Reverse Charge (Purchases)");
          AdjustVATAccount(
            TaxJurisdiction."Reverse Charge (Purchases)",
            -VATEntry2.Amount,-VATEntry2."Additional-Currency Amount",
            -VATEntryTotalBase.Amount,-VATEntryTotalBase."Additional-Currency Amount");
        END;
      END;
      IF (VATEntry2."Remaining Unrealized Amount" <> 0) OR
         (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
      THEN BEGIN
        TaxJurisdiction.TESTFIELD("Unrealized VAT Type");
        TaxJurisdiction.TESTFIELD("Unreal. Tax Acc. (Purchases)");
        AdjustVATAccount(
          TaxJurisdiction."Unreal. Tax Acc. (Purchases)",
          VATEntry2."Remaining Unrealized Amount",VATEntry2."Add.-Curr. Rem. Unreal. Amount",
          VATEntryTotalBase."Remaining Unrealized Amount",VATEntry2."Add.-Curr. Rem. Unreal. Amount");

        IF UseTax THEN BEGIN
          TaxJurisdiction.TESTFIELD("Unreal. Rev. Charge (Purch.)");
          AdjustVATAccount(
            TaxJurisdiction."Unreal. Rev. Charge (Purch.)",
            -VATEntry2."Remaining Unrealized Amount",
            -VATEntry2."Add.-Curr. Rem. Unreal. Amount",
            -VATEntryTotalBase."Remaining Unrealized Amount",
            -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
        END;
      END;
    END;

    LOCAL PROCEDURE AdjustSalesTax@10();
    BEGIN
      TaxJurisdiction.TESTFIELD("Tax Account (Sales)");
      AdjustVATAccount(
        TaxJurisdiction."Tax Account (Sales)",
        VATEntry2.Amount,VATEntry2."Additional-Currency Amount",
        VATEntryTotalBase.Amount,VATEntryTotalBase."Additional-Currency Amount");
      IF (VATEntry2."Remaining Unrealized Amount" <> 0) OR
         (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
      THEN BEGIN
        TaxJurisdiction.TESTFIELD("Unrealized VAT Type");
        TaxJurisdiction.TESTFIELD("Unreal. Tax Acc. (Sales)");
        AdjustVATAccount(
          TaxJurisdiction."Unreal. Tax Acc. (Sales)",
          VATEntry2."Remaining Unrealized Amount",
          VATEntry2."Add.-Curr. Rem. Unreal. Amount",
          VATEntryTotalBase."Remaining Unrealized Amount",
          VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
      END;
    END;

    LOCAL PROCEDURE Accumulate@9(VAR TotalAmount@1000 : Decimal;AmountToAdd@1001 : Decimal);
    BEGIN
      TotalAmount := TotalAmount + AmountToAdd;
    END;

    LOCAL PROCEDURE PostGLAccAdjmt@23(GLAccNo@1000 : Code[20];ExchRateAdjmt@1001 : Integer;Amount@1002 : Decimal;NetChange@1003 : Decimal;AddCurrNetChange@1004 : Decimal);
    BEGIN
      GenJnlLine.INIT;
      CASE ExchRateAdjmt OF
        "G/L Account"."Exchange Rate Adjustment"::"Adjust Amount":
          BEGIN
            GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
            GenJnlLine."Currency Code" := '';
            GenJnlLine.Amount := Amount;
            GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
            GLAmtTotal := GLAmtTotal + GenJnlLine.Amount;
            GLAddCurrNetChangeTotal := GLAddCurrNetChangeTotal + AddCurrNetChange;
            GLNetChangeBase := GLNetChangeBase + NetChange;
          END;
        "G/L Account"."Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
          BEGIN
            GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
            GenJnlLine."Currency Code" := GLSetup."Additional Reporting Currency";
            GenJnlLine.Amount := Amount;
            GenJnlLine."Amount (LCY)" := 0;
            GLAddCurrAmtTotal := GLAddCurrAmtTotal + GenJnlLine.Amount;
            GLNetChangeTotal := GLNetChangeTotal + NetChange;
            GLAddCurrNetChangeBase := GLAddCurrNetChangeBase + AddCurrNetChange;
          END;
      END;
      IF GenJnlLine.Amount <> 0 THEN BEGIN
        GenJnlLine."Document No." := PostingDocNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := GLAccNo;
        GenJnlLine."Posting Date" := PostingDate;
        CASE GenJnlLine."Additional-Currency Posting" OF
          GenJnlLine."Additional-Currency Posting"::"Amount Only":
            GenJnlLine.Description :=
              STRSUBSTNO(
                PostingDescription,
                GLSetup."Additional Reporting Currency",
                AddCurrNetChange);
          GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only":
            GenJnlLine.Description :=
              STRSUBSTNO(
                PostingDescription,
                '',
                NetChange);
        END;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        GetJnlLineDefDim(GenJnlLine,TempDimSetEntry);
        PostGenJnlLine(GenJnlLine,TempDimSetEntry);
      END;
    END;

    LOCAL PROCEDURE CheckExchRateAdjustment@6(AccNo@1000 : Code[20];SetupTableName@1001 : Text[100];SetupFieldName@1002 : Text[100]);
    VAR
      GLAcc@1003 : Record 15;
      GLSetup@1004 : Record 98;
    BEGIN
      IF AccNo = '' THEN
        EXIT;
      GLAcc.GET(AccNo);
      IF GLAcc."Exchange Rate Adjustment" <> GLAcc."Exchange Rate Adjustment"::"No Adjustment" THEN BEGIN
        GLAcc."Exchange Rate Adjustment" := GLAcc."Exchange Rate Adjustment"::"No Adjustment";
        ERROR(
          Text017,
          GLAcc.FIELDCAPTION("Exchange Rate Adjustment"),GLAcc.TABLECAPTION,
          GLAcc."No.",GLAcc."Exchange Rate Adjustment",
          SetupTableName,GLSetup.FIELDCAPTION("VAT Exchange Rate Adjustment"),
          GLSetup.TABLECAPTION,SetupFieldName);
      END;
    END;

    LOCAL PROCEDURE HandleCustDebitCredit@17(Amount@1000 : Decimal;AmountLCY@1001 : Decimal;Correction@1002 : Boolean;AdjAmount@1003 : Decimal);
    BEGIN
      IF ((Amount > 0) OR (AmountLCY > 0)) AND (NOT Correction) OR
         ((Amount < 0) OR (AmountLCY < 0)) AND Correction
      THEN BEGIN
        TempDtldCustLedgEntry."Debit Amount (LCY)" := AdjAmount;
        TempDtldCustLedgEntry."Credit Amount (LCY)" := 0;
      END ELSE BEGIN
        TempDtldCustLedgEntry."Debit Amount (LCY)" := 0;
        TempDtldCustLedgEntry."Credit Amount (LCY)" := -AdjAmount;
      END;
    END;

    LOCAL PROCEDURE HandleVendDebitCredit@14(Amount@1000 : Decimal;AmountLCY@1001 : Decimal;Correction@1002 : Boolean;AdjAmount@1003 : Decimal);
    BEGIN
      IF ((Amount > 0) OR (AmountLCY > 0)) AND (NOT Correction) OR
         ((Amount < 0) OR (AmountLCY < 0)) AND Correction
      THEN BEGIN
        TempDtldVendLedgEntry."Debit Amount (LCY)" := AdjAmount;
        TempDtldVendLedgEntry."Credit Amount (LCY)" := 0;
      END ELSE BEGIN
        TempDtldVendLedgEntry."Debit Amount (LCY)" := 0;
        TempDtldVendLedgEntry."Credit Amount (LCY)" := -AdjAmount;
      END;
    END;

    LOCAL PROCEDURE GetJnlLineDefDim@11(VAR GenJnlLine@1000 : Record 81;VAR DimSetEntry@1001 : Record 480);
    VAR
      TableID@1002 : ARRAY [10] OF Integer;
      No@1003 : ARRAY [10] OF Code[20];
    BEGIN
      WITH GenJnlLine DO BEGIN
        CASE "Account Type" OF
          "Account Type"::"G/L Account":
            TableID[1] := DATABASE::"G/L Account";
          "Account Type"::"Bank Account":
            TableID[1] := DATABASE::"Bank Account";
        END;
        No[1] := "Account No.";
        DimMgt.GetDefaultDimID(TableID,No,"Source Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Dimension Set ID",0);
      END;
      DimMgt.GetDimSetEntryDefaultDim(DimSetEntry);
    END;

    LOCAL PROCEDURE CopyDimSetEntryToDimBuf@18(VAR DimSetEntry@1000 : Record 480;VAR DimBuf@1001 : Record 360);
    BEGIN
      IF DimSetEntry.FIND('-') THEN
        REPEAT
          DimBuf."Table ID" := DATABASE::"Dimension Buffer";
          DimBuf."Entry No." := 0;
          DimBuf."Dimension Code" := DimSetEntry."Dimension Code";
          DimBuf."Dimension Value Code" := DimSetEntry."Dimension Value Code";
          DimBuf.INSERT;
        UNTIL DimSetEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE GetDimCombID@21(VAR DimBuf@1000 : Record 360) : Integer;
    VAR
      DimEntryNo@1001 : Integer;
    BEGIN
      DimEntryNo := DimBufMgt.FindDimensions(DimBuf);
      IF DimEntryNo = 0 THEN
        DimEntryNo := DimBufMgt.InsertDimensions(DimBuf);
      EXIT(DimEntryNo);
    END;

    LOCAL PROCEDURE PostGenJnlLine@8(VAR GenJnlLine@1000 : Record 81;VAR DimSetEntry@1001 : Record 480) : Integer;
    BEGIN
      GenJnlLine."Shortcut Dimension 1 Code" := GetGlobalDimVal(GLSetup."Global Dimension 1 Code",DimSetEntry);
      GenJnlLine."Shortcut Dimension 2 Code" := GetGlobalDimVal(GLSetup."Global Dimension 2 Code",DimSetEntry);
      GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
      GenJnlPostLine.RUN(GenJnlLine);
      EXIT(GenJnlPostLine.GetNextTransactionNo);
    END;

    LOCAL PROCEDURE GetGlobalDimVal@16(GlobalDimCode@1000 : Code[20];VAR DimSetEntry@1001 : Record 480) : Code[20];
    VAR
      DimVal@1002 : Code[20];
    BEGIN
      IF GlobalDimCode = '' THEN
        DimVal := ''
      ELSE BEGIN
        DimSetEntry.SETRANGE("Dimension Code",GlobalDimCode);
        IF DimSetEntry.FIND('-') THEN
          DimVal := DimSetEntry."Dimension Value Code"
        ELSE
          DimVal := '';
        DimSetEntry.SETRANGE("Dimension Code");
      END;
      EXIT(DimVal);
    END;

    [External]
    PROCEDURE CheckPostingDate@19();
    BEGIN
      IF PostingDate < StartDate THEN
        ERROR(Text018);
      IF PostingDate > EndDateReq THEN
        ERROR(Text018);
    END;

    [Internal]
    PROCEDURE AdjustCustomerLedgerEntry@20(CusLedgerEntry@1001 : Record 21;PostingDate2@1000 : Date);
    VAR
      DimSetEntry@1005 : Record 480;
      DimEntryNo@1004 : Integer;
      OldAdjAmount@1003 : Decimal;
      Adjust@1002 : Boolean;
      AdjExchRateBufIndex@1006 : Integer;
    BEGIN
      WITH CusLedgerEntry DO BEGIN
        SETRANGE("Date Filter",0D,PostingDate2);
        Currency2.GET("Currency Code");
        GainsAmount := 0;
        LossesAmount := 0;
        OldAdjAmount := 0;
        Adjust := FALSE;

        TempDimSetEntry.RESET;
        TempDimSetEntry.DELETEALL;
        TempDimBuf.RESET;
        TempDimBuf.DELETEALL;
        DimSetEntry.SETRANGE("Dimension Set ID","Dimension Set ID");
        CopyDimSetEntryToDimBuf(DimSetEntry,TempDimBuf);
        DimEntryNo := GetDimCombID(TempDimBuf);

        CALCFIELDS(
          Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)","Original Amt. (LCY)",
          "Debit Amount","Credit Amount","Debit Amount (LCY)","Credit Amount (LCY)");

        // Calculate Old Unrealized Gains and Losses
        SetUnrealizedGainLossFilterCust(DtldCustLedgEntry,"Entry No.");
        DtldCustLedgEntry.CALCSUMS("Amount (LCY)");

        SetUnrealizedGainLossFilterCust(TempDtldCustLedgEntrySums,"Entry No.");
        TempDtldCustLedgEntrySums.CALCSUMS("Amount (LCY)");
        OldAdjAmount := DtldCustLedgEntry."Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
        "Remaining Amt. (LCY)" := "Remaining Amt. (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
        "Debit Amount (LCY)" := "Debit Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
        "Credit Amount (LCY)" := "Credit Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
        TempDtldCustLedgEntrySums.RESET;

        // Modify Currency factor on Customer Ledger Entry
        IF "Adjusted Currency Factor" <> Currency2."Currency Factor" THEN BEGIN
          "Adjusted Currency Factor" := Currency2."Currency Factor";
          MODIFY;
        END;

        // Calculate New Unrealized Gains and Losses
        AdjAmount :=
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
              PostingDate2,Currency2.Code,"Remaining Amount",Currency2."Currency Factor")) -
          "Remaining Amt. (LCY)";

        IF AdjAmount <> 0 THEN BEGIN
          InitDtldCustLedgEntry(CusLedgerEntry,TempDtldCustLedgEntry);
          TempDtldCustLedgEntry."Entry No." := NewEntryNo;
          TempDtldCustLedgEntry."Posting Date" := PostingDate2;
          TempDtldCustLedgEntry."Document No." := PostingDocNo;

          Correction :=
            ("Debit Amount" < 0) OR
            ("Credit Amount" < 0) OR
            ("Debit Amount (LCY)" < 0) OR
            ("Credit Amount (LCY)" < 0);

          IF OldAdjAmount > 0 THEN
            CASE TRUE OF
              (AdjAmount > 0):
                BEGIN
                  TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                  TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                  HandleCustDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldCustLedgEntry."Amount (LCY)");
                  InsertTempDtldCustomerLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  GainsAmount := AdjAmount;
                  Adjust := TRUE;
                END;
              (AdjAmount < 0):
                IF -AdjAmount <= OldAdjAmount THEN BEGIN
                  TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                  TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                  HandleCustDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldCustLedgEntry."Amount (LCY)");
                  InsertTempDtldCustomerLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  LossesAmount := AdjAmount;
                  Adjust := TRUE;
                END ELSE BEGIN
                  AdjAmount := AdjAmount + OldAdjAmount;
                  TempDtldCustLedgEntry."Amount (LCY)" := -OldAdjAmount;
                  TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                  HandleCustDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldCustLedgEntry."Amount (LCY)");
                  InsertTempDtldCustomerLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  AdjExchRateBufIndex :=
                    AdjExchRateBufferUpdate(
                      "Currency Code",Customer."Customer Posting Group",
                      0,0,-OldAdjAmount,-OldAdjAmount,0,DimEntryNo,PostingDate2,Customer."IC Partner Code");
                  TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                  ModifyTempDtldCustomerLedgerEntry;
                  Adjust := FALSE;
                END;
            END;
          IF OldAdjAmount < 0 THEN
            CASE TRUE OF
              (AdjAmount < 0):
                BEGIN
                  TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                  TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                  HandleCustDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldCustLedgEntry."Amount (LCY)");
                  InsertTempDtldCustomerLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  LossesAmount := AdjAmount;
                  Adjust := TRUE;
                END;
              (AdjAmount > 0):
                IF AdjAmount <= -OldAdjAmount THEN BEGIN
                  TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                  TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                  HandleCustDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldCustLedgEntry."Amount (LCY)");
                  InsertTempDtldCustomerLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  GainsAmount := AdjAmount;
                  Adjust := TRUE;
                END ELSE BEGIN
                  AdjAmount := OldAdjAmount + AdjAmount;
                  TempDtldCustLedgEntry."Amount (LCY)" := -OldAdjAmount;
                  TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                  HandleCustDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldCustLedgEntry."Amount (LCY)");
                  InsertTempDtldCustomerLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  AdjExchRateBufIndex :=
                    AdjExchRateBufferUpdate(
                      "Currency Code",Customer."Customer Posting Group",
                      0,0,-OldAdjAmount,0,-OldAdjAmount,DimEntryNo,PostingDate2,Customer."IC Partner Code");
                  TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                  ModifyTempDtldCustomerLedgerEntry;
                  Adjust := FALSE;
                END;
            END;
          IF NOT Adjust THEN BEGIN
            TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
            HandleCustDebitCredit(Amount,"Amount (LCY)",Correction,TempDtldCustLedgEntry."Amount (LCY)");
            TempDtldCustLedgEntry."Entry No." := NewEntryNo;
            IF AdjAmount < 0 THEN BEGIN
              TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
              GainsAmount := 0;
              LossesAmount := AdjAmount;
            END ELSE
              IF AdjAmount > 0 THEN BEGIN
                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                GainsAmount := AdjAmount;
                LossesAmount := 0;
              END;
            InsertTempDtldCustomerLedgerEntry;
            NewEntryNo := NewEntryNo + 1;
          END;

          TotalAdjAmount := TotalAdjAmount + AdjAmount;
          Window.UPDATE(4,TotalAdjAmount);
          AdjExchRateBufIndex :=
            AdjExchRateBufferUpdate(
              "Currency Code",Customer."Customer Posting Group",
              "Remaining Amount","Remaining Amt. (LCY)",TempDtldCustLedgEntry."Amount (LCY)",
              GainsAmount,LossesAmount,DimEntryNo,PostingDate2,Customer."IC Partner Code");
          TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
          ModifyTempDtldCustomerLedgerEntry;
        END;
      END;
    END;

    [Internal]
    PROCEDURE AdjustVendorLedgerEntry@24(VendLedgerEntry@1001 : Record 25;PostingDate2@1000 : Date);
    VAR
      DimSetEntry@1006 : Record 480;
      DimEntryNo@1005 : Integer;
      OldAdjAmount@1004 : Decimal;
      Adjust@1003 : Boolean;
      AdjExchRateBufIndex@1007 : Integer;
    BEGIN
      WITH VendLedgerEntry DO BEGIN
        SETRANGE("Date Filter",0D,PostingDate2);
        Currency2.GET("Currency Code");
        GainsAmount := 0;
        LossesAmount := 0;
        OldAdjAmount := 0;
        Adjust := FALSE;

        TempDimBuf.RESET;
        TempDimBuf.DELETEALL;
        DimSetEntry.SETRANGE("Dimension Set ID","Dimension Set ID");
        CopyDimSetEntryToDimBuf(DimSetEntry,TempDimBuf);
        DimEntryNo := GetDimCombID(TempDimBuf);

        CALCFIELDS(
          Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)","Original Amt. (LCY)",
          "Debit Amount","Credit Amount","Debit Amount (LCY)","Credit Amount (LCY)");

        // Calculate Old Unrealized GainLoss
        SetUnrealizedGainLossFilterVend(DtldVendLedgEntry,"Entry No.");
        DtldVendLedgEntry.CALCSUMS("Amount (LCY)");

        SetUnrealizedGainLossFilterVend(TempDtldVendLedgEntrySums,"Entry No.");
        TempDtldVendLedgEntrySums.CALCSUMS("Amount (LCY)");
        OldAdjAmount := DtldVendLedgEntry."Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
        "Remaining Amt. (LCY)" := "Remaining Amt. (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
        "Debit Amount (LCY)" := "Debit Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
        "Credit Amount (LCY)" := "Credit Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
        TempDtldVendLedgEntrySums.RESET;

        // Modify Currency factor on Vendor Ledger Entry
        IF "Adjusted Currency Factor" <> Currency2."Currency Factor" THEN BEGIN
          "Adjusted Currency Factor" := Currency2."Currency Factor";
          MODIFY;
        END;

        // Calculate New Unrealized Gains and Losses
        AdjAmount :=
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
              PostingDate2,Currency2.Code,"Remaining Amount",Currency2."Currency Factor")) -
          "Remaining Amt. (LCY)";

        IF AdjAmount <> 0 THEN BEGIN
          InitDtldVendLedgEntry(VendLedgerEntry,TempDtldVendLedgEntry);
          TempDtldVendLedgEntry."Entry No." := NewEntryNo;
          TempDtldVendLedgEntry."Posting Date" := PostingDate2;
          TempDtldVendLedgEntry."Document No." := PostingDocNo;

          Correction :=
            ("Debit Amount" < 0) OR
            ("Credit Amount" < 0) OR
            ("Debit Amount (LCY)" < 0) OR
            ("Credit Amount (LCY)" < 0);

          IF OldAdjAmount > 0 THEN
            CASE TRUE OF
              (AdjAmount > 0):
                BEGIN
                  TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                  TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                  HandleVendDebitCredit(Amount,"Amount (LCY)",Correction,TempDtldVendLedgEntry."Amount (LCY)");
                  InsertTempDtldVendorLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  GainsAmount := AdjAmount;
                  Adjust := TRUE;
                END;
              (AdjAmount < 0):
                IF -AdjAmount <= OldAdjAmount THEN BEGIN
                  TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                  TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                  HandleVendDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldVendLedgEntry."Amount (LCY)");
                  InsertTempDtldVendorLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  LossesAmount := AdjAmount;
                  Adjust := TRUE;
                END ELSE BEGIN
                  AdjAmount := AdjAmount + OldAdjAmount;
                  TempDtldVendLedgEntry."Amount (LCY)" := -OldAdjAmount;
                  TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                  HandleVendDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldVendLedgEntry."Amount (LCY)");
                  InsertTempDtldVendorLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  AdjExchRateBufIndex :=
                    AdjExchRateBufferUpdate(
                      "Currency Code",Vendor."Vendor Posting Group",
                      0,0,-OldAdjAmount,-OldAdjAmount,0,DimEntryNo,PostingDate2,Vendor."IC Partner Code");
                  TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                  ModifyTempDtldVendorLedgerEntry;
                  Adjust := FALSE;
                END;
            END;
          IF OldAdjAmount < 0 THEN
            CASE TRUE OF
              (AdjAmount < 0):
                BEGIN
                  TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                  TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                  HandleVendDebitCredit(Amount,"Amount (LCY)",Correction,TempDtldVendLedgEntry."Amount (LCY)");
                  InsertTempDtldVendorLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  LossesAmount := AdjAmount;
                  Adjust := TRUE;
                END;
              (AdjAmount > 0):
                IF AdjAmount <= -OldAdjAmount THEN BEGIN
                  TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                  TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                  HandleVendDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldVendLedgEntry."Amount (LCY)");
                  InsertTempDtldVendorLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  GainsAmount := AdjAmount;
                  Adjust := TRUE;
                END ELSE BEGIN
                  AdjAmount := OldAdjAmount + AdjAmount;
                  TempDtldVendLedgEntry."Amount (LCY)" := -OldAdjAmount;
                  TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                  HandleVendDebitCredit(
                    Amount,"Amount (LCY)",Correction,TempDtldVendLedgEntry."Amount (LCY)");
                  InsertTempDtldVendorLedgerEntry;
                  NewEntryNo := NewEntryNo + 1;
                  AdjExchRateBufIndex :=
                    AdjExchRateBufferUpdate(
                      "Currency Code",Vendor."Vendor Posting Group",
                      0,0,-OldAdjAmount,0,-OldAdjAmount,DimEntryNo,PostingDate2,Vendor."IC Partner Code");
                  TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                  ModifyTempDtldVendorLedgerEntry;
                  Adjust := FALSE;
                END;
            END;

          IF NOT Adjust THEN BEGIN
            TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
            HandleVendDebitCredit(Amount,"Amount (LCY)",Correction,TempDtldVendLedgEntry."Amount (LCY)");
            TempDtldVendLedgEntry."Entry No." := NewEntryNo;
            IF AdjAmount < 0 THEN BEGIN
              TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
              GainsAmount := 0;
              LossesAmount := AdjAmount;
            END ELSE
              IF AdjAmount > 0 THEN BEGIN
                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                GainsAmount := AdjAmount;
                LossesAmount := 0;
              END;
            InsertTempDtldVendorLedgerEntry;
            NewEntryNo := NewEntryNo + 1;
          END;

          TotalAdjAmount := TotalAdjAmount + AdjAmount;
          Window.UPDATE(4,TotalAdjAmount);
          AdjExchRateBufIndex :=
            AdjExchRateBufferUpdate(
              "Currency Code",Vendor."Vendor Posting Group",
              "Remaining Amount","Remaining Amt. (LCY)",
              TempDtldVendLedgEntry."Amount (LCY)",GainsAmount,LossesAmount,DimEntryNo,PostingDate2,Vendor."IC Partner Code");
          TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
          ModifyTempDtldVendorLedgerEntry;
        END;
      END;
    END;

    LOCAL PROCEDURE InitDtldCustLedgEntry@27(CustLedgEntry@1000 : Record 21;VAR DtldCustLedgEntry@1001 : Record 379);
    BEGIN
      WITH CustLedgEntry DO BEGIN
        DtldCustLedgEntry.INIT;
        DtldCustLedgEntry."Cust. Ledger Entry No." := "Entry No.";
        DtldCustLedgEntry.Amount := 0;
        DtldCustLedgEntry."Customer No." := "Customer No.";
        DtldCustLedgEntry."Currency Code" := "Currency Code";
        DtldCustLedgEntry."User ID" := USERID;
        DtldCustLedgEntry."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        DtldCustLedgEntry."Journal Batch Name" := "Journal Batch Name";
        DtldCustLedgEntry."Reason Code" := "Reason Code";
        DtldCustLedgEntry."Initial Entry Due Date" := "Due Date";
        DtldCustLedgEntry."Initial Entry Global Dim. 1" := "Global Dimension 1 Code";
        DtldCustLedgEntry."Initial Entry Global Dim. 2" := "Global Dimension 2 Code";
        DtldCustLedgEntry."Initial Document Type" := "Document Type";
      END;
    END;

    LOCAL PROCEDURE InitDtldVendLedgEntry@28(VendLedgEntry@1001 : Record 25;VAR DtldVendLedgEntry@1000 : Record 380);
    BEGIN
      WITH VendLedgEntry DO BEGIN
        DtldVendLedgEntry.INIT;
        DtldVendLedgEntry."Vendor Ledger Entry No." := "Entry No.";
        DtldVendLedgEntry.Amount := 0;
        DtldVendLedgEntry."Vendor No." := "Vendor No.";
        DtldVendLedgEntry."Currency Code" := "Currency Code";
        DtldVendLedgEntry."User ID" := USERID;
        DtldVendLedgEntry."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
        DtldVendLedgEntry."Journal Batch Name" := "Journal Batch Name";
        DtldVendLedgEntry."Reason Code" := "Reason Code";
        DtldVendLedgEntry."Initial Entry Due Date" := "Due Date";
        DtldVendLedgEntry."Initial Entry Global Dim. 1" := "Global Dimension 1 Code";
        DtldVendLedgEntry."Initial Entry Global Dim. 2" := "Global Dimension 2 Code";
        DtldVendLedgEntry."Initial Document Type" := "Document Type";
      END;
    END;

    LOCAL PROCEDURE SetUnrealizedGainLossFilterCust@22(VAR DtldCustLedgEntry@1000 : Record 379;EntryNo@1001 : Integer);
    BEGIN
      WITH DtldCustLedgEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type");
        SETRANGE("Cust. Ledger Entry No.",EntryNo);
        SETRANGE("Entry Type","Entry Type"::"Unrealized Loss","Entry Type"::"Unrealized Gain");
      END;
    END;

    LOCAL PROCEDURE SetUnrealizedGainLossFilterVend@26(VAR DtldVendLedgEntry@1001 : Record 380;EntryNo@1000 : Integer);
    BEGIN
      WITH DtldVendLedgEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Vendor Ledger Entry No.","Entry Type");
        SETRANGE("Vendor Ledger Entry No.",EntryNo);
        SETRANGE("Entry Type","Entry Type"::"Unrealized Loss","Entry Type"::"Unrealized Gain");
      END;
    END;

    LOCAL PROCEDURE InsertTempDtldCustomerLedgerEntry@30();
    BEGIN
      TempDtldCustLedgEntry.INSERT;
      TempDtldCustLedgEntrySums := TempDtldCustLedgEntry;
      TempDtldCustLedgEntrySums.INSERT;
    END;

    LOCAL PROCEDURE InsertTempDtldVendorLedgerEntry@29();
    BEGIN
      TempDtldVendLedgEntry.INSERT;
      TempDtldVendLedgEntrySums := TempDtldVendLedgEntry;
      TempDtldVendLedgEntrySums.INSERT;
    END;

    LOCAL PROCEDURE ModifyTempDtldCustomerLedgerEntry@33();
    BEGIN
      TempDtldCustLedgEntry.MODIFY;
      TempDtldCustLedgEntrySums := TempDtldCustLedgEntry;
      TempDtldCustLedgEntrySums.MODIFY;
    END;

    LOCAL PROCEDURE ModifyTempDtldVendorLedgerEntry@32();
    BEGIN
      TempDtldVendLedgEntry.MODIFY;
      TempDtldVendLedgEntrySums := TempDtldVendLedgEntry;
      TempDtldVendLedgEntrySums.MODIFY;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

