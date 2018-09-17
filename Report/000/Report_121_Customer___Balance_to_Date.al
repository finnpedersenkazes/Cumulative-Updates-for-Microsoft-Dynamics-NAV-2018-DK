OBJECT Report 121 Customer - Balance to Date
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitor - saldo til dato;
               ENU=Customer - Balance to Date];
    OnPreReport=VAR
                  CaptionManagement@1000 : Codeunit 42;
                BEGIN
                  CustFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);
                END;

  }
  DATASET
  {
    { 6836;    ;DataItem;                    ;
               DataItemTable=Table18;
               DataItemTableView=SORTING(No.);
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               CurrReport.NEWPAGEPERRECORD := PrintOnePrPage;
                             END;

               OnAfterGetRecord=BEGIN
                                  IF MaxDate = 0D THEN
                                    ERROR(BlankMaxDateErr);

                                  SETRANGE("Date Filter",0D,MaxDate);
                                  CALCFIELDS("Net Change (LCY)","Net Change");

                                  IF (PrintAmountInLCY AND ("Net Change (LCY)" = 0) OR
                                      (NOT PrintAmountInLCY) AND ("Net Change" = 0)) AND
                                     (NOT ShowEntriesWithZeroBalance)
                                  THEN
                                    CurrReport.SKIP;
                                END;

               ReqFilterFields=No.,Date Filter,Blocked }

    { 2   ;1   ;Column  ;TodayFormatted      ;
               SourceExpr=FORMAT(TODAY,0,4) }

    { 3   ;1   ;Column  ;TxtCustGeTranmaxDtFilter;
               SourceExpr=STRSUBSTNO(Text000,FORMAT(GETRANGEMAX("Date Filter"))) }

    { 6   ;1   ;Column  ;CompanyName         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 16  ;1   ;Column  ;PrintOnePrPage      ;
               SourceExpr=PrintOnePrPage }

    { 14  ;1   ;Column  ;CustFilter          ;
               SourceExpr=CustFilter }

    { 17  ;1   ;Column  ;PrintAmountInLCY    ;
               SourceExpr=PrintAmountInLCY }

    { 10  ;1   ;Column  ;CustTableCaptCustFilter;
               SourceExpr=TABLECAPTION + ': ' + CustFilter }

    { 22  ;1   ;Column  ;No_Customer         ;
               SourceExpr="No." }

    { 23  ;1   ;Column  ;Name_Customer       ;
               SourceExpr=Name }

    { 25  ;1   ;Column  ;PhoneNo_Customer    ;
               IncludeCaption=Yes;
               SourceExpr="Phone No." }

    { 1   ;1   ;Column  ;CustBalancetoDateCaption;
               SourceExpr=CustBalancetoDateCaptionLbl }

    { 4   ;1   ;Column  ;CurrReportPageNoCaption;
               SourceExpr=CurrReportPageNoCaptionLbl }

    { 8   ;1   ;Column  ;AllamtsareinLCYCaption;
               SourceExpr=AllamtsareinLCYCaptionLbl }

    { 29  ;1   ;Column  ;CustLedgEntryPostingDtCaption;
               SourceExpr=CustLedgEntryPostingDtCaptionLbl }

    { 45  ;1   ;Column  ;OriginalAmtCaption  ;
               SourceExpr=OriginalAmtCaptionLbl }

    { 5082;1   ;DataItem;CustLedgEntry3      ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Entry No.);
               OnPreDataItem=VAR
                               TempCustLedgerEntry@1000 : TEMPORARY Record 21;
                               ClosedEntryIncluded@1001 : Boolean;
                             BEGIN
                               RESET;
                               FilterCustLedgerEntry(CustLedgEntry3);
                               IF FINDSET THEN
                                 REPEAT
                                   IF NOT Open THEN
                                     ClosedEntryIncluded := CheckCustEntryIncluded("Entry No.");
                                   IF Open OR ClosedEntryIncluded THEN BEGIN
                                     MARK(TRUE);
                                     TempCustLedgerEntry := CustLedgEntry3;
                                     TempCustLedgerEntry.INSERT;
                                   END;
                                 UNTIL NEXT = 0;

                               SETCURRENTKEY("Entry No.");
                               MARKEDONLY(TRUE);

                               AddCustomerDimensionFilter(CustLedgEntry3);

                               CalcCustomerTotalAmount(TempCustLedgerEntry);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF PrintAmountInLCY THEN BEGIN
                                    CALCFIELDS("Original Amt. (LCY)","Remaining Amt. (LCY)");
                                    OriginalAmt := "Original Amt. (LCY)";
                                    RemainingAmt := "Remaining Amt. (LCY)";
                                    CurrencyCode := '';
                                  END ELSE BEGIN
                                    CALCFIELDS("Original Amount","Remaining Amount");
                                    OriginalAmt := "Original Amount";
                                    RemainingAmt := "Remaining Amount";
                                    CurrencyCode := "Currency Code";
                                  END;
                                END;
                                 }

    { 28  ;2   ;Column  ;PostingDt_CustLedgEntry;
               IncludeCaption=No;
               SourceExpr=FORMAT("Posting Date") }

    { 32  ;2   ;Column  ;DocType_CustLedgEntry;
               IncludeCaption=Yes;
               SourceExpr="Document Type" }

    { 34  ;2   ;Column  ;DocNo_CustLedgEntry ;
               IncludeCaption=Yes;
               SourceExpr="Document No." }

    { 36  ;2   ;Column  ;Desc_CustLedgEntry  ;
               IncludeCaption=Yes;
               SourceExpr=Description }

    { 44  ;2   ;Column  ;OriginalAmt         ;
               SourceExpr=OriginalAmt;
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 54  ;2   ;Column  ;EntryNo_CustLedgEntry;
               IncludeCaption=Yes;
               SourceExpr="Entry No." }

    { 15  ;2   ;Column  ;CurrencyCode        ;
               SourceExpr=CurrencyCode }

    { 6942;2   ;DataItem;                    ;
               DataItemTable=Table379;
               DataItemTableView=SORTING(Cust. Ledger Entry No.,Posting Date)
                                 WHERE(Entry Type=FILTER(<>Initial Entry));
               OnPreDataItem=BEGIN
                               DtldCustLedgEntryNum := 0;
                               CustLedgEntry3.COPYFILTER("Posting Date","Posting Date");
                             END;

               OnAfterGetRecord=BEGIN
                                  IF NOT PrintUnappliedEntries THEN
                                    IF Unapplied THEN
                                      CurrReport.SKIP;

                                  IF PrintAmountInLCY THEN BEGIN
                                    Amt := "Amount (LCY)";
                                    CurrencyCode := '';
                                  END ELSE BEGIN
                                    Amt := Amount;
                                    CurrencyCode := "Currency Code";
                                  END;
                                  IF Amt = 0 THEN
                                    CurrReport.SKIP;

                                  DtldCustLedgEntryNum := DtldCustLedgEntryNum + 1;
                                END;

               DataItemLink=Cust. Ledger Entry No.=FIELD(Entry No.),
                            Posting Date=FIELD(Date Filter) }

    { 42  ;3   ;Column  ;EntType_DtldCustLedgEnt;
               SourceExpr="Entry Type" }

    { 46  ;3   ;Column  ;postDt_DtldCustLedgEntry;
               SourceExpr=FORMAT("Posting Date") }

    { 48  ;3   ;Column  ;DocType_DtldCustLedgEntry;
               SourceExpr="Document Type" }

    { 50  ;3   ;Column  ;DocNo_DtldCustLedgEntry;
               SourceExpr="Document No." }

    { 52  ;3   ;Column  ;Amt                 ;
               SourceExpr=Amt;
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 56  ;3   ;Column  ;CurrencyCodeDtldCustLedgEntry;
               SourceExpr=CurrencyCode }

    { 21  ;3   ;Column  ;EntNo_DtldCustLedgEntry;
               SourceExpr=DtldCustLedgEntryNum }

    { 11  ;3   ;Column  ;RemainingAmt        ;
               SourceExpr=RemainingAmt;
               AutoFormatType=1;
               AutoFormatExpr=CurrencyCode }

    { 4152;1   ;DataItem;Integer2            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               IF NOT ShowEntriesWithZeroBalance THEN
                                 CurrencyTotalBuffer.SETFILTER("Total Amount",'<>0');
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    OK := CurrencyTotalBuffer.FIND('-')
                                  ELSE
                                    OK := CurrencyTotalBuffer.NEXT <> 0;
                                  IF NOT OK THEN
                                    CurrReport.BREAK;

                                  CurrencyTotalBuffer2.UpdateTotal(
                                    CurrencyTotalBuffer."Currency Code",
                                    CurrencyTotalBuffer."Total Amount",
                                    0,
                                    Counter1);
                                END;

               OnPostDataItem=BEGIN
                                CurrencyTotalBuffer.DELETEALL;
                              END;
                               }

    { 9   ;2   ;Column  ;CustName            ;
               SourceExpr=Customer.Name }

    { 98  ;2   ;Column  ;TtlAmtCurrencyTtlBuff;
               SourceExpr=CurrencyTotalBuffer."Total Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyTotalBuffer."Currency Code" }

    { 18  ;2   ;Column  ;CurryCode_CurrencyTtBuff;
               SourceExpr=CurrencyTotalBuffer."Currency Code" }

    { 7913;    ;DataItem;Integer3            ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=FILTER(1..));
               OnPreDataItem=BEGIN
                               CurrencyTotalBuffer2.SETFILTER("Total Amount",'<>0');
                             END;

               OnAfterGetRecord=BEGIN
                                  IF Number = 1 THEN
                                    OK := CurrencyTotalBuffer2.FIND('-')
                                  ELSE
                                    OK := CurrencyTotalBuffer2.NEXT <> 0;
                                  IF NOT OK THEN
                                    CurrReport.BREAK;
                                END;

               OnPostDataItem=BEGIN
                                CurrencyTotalBuffer2.DELETEALL;
                              END;
                               }

    { 12  ;1   ;Column  ;CurryCode_CurrencyTtBuff2;
               SourceExpr=CurrencyTotalBuffer2."Currency Code" }

    { 19  ;1   ;Column  ;TtlAmtCurrencyTtlBuff2;
               SourceExpr=CurrencyTotalBuffer2."Total Amount";
               AutoFormatType=1;
               AutoFormatExpr=CurrencyTotalBuffer2."Currency Code" }

    { 20  ;1   ;Column  ;TotalCaption        ;
               SourceExpr=TotalCaptionLbl }

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

      { 3   ;2   ;Field     ;
                  Name=Ending Date;
                  CaptionML=[DAN=Slutdato;
                             ENU=Ending Date];
                  ToolTipML=[DAN=Angiver den sidste dato, hvortil der vises oplysninger i rapporten. Ved manglende udfyldning viser rapporten oplysninger indtil dags dato.;
                             ENU=Specifies the last date until which information in the report is shown. If left blank, the report shows information until the present time.];
                  ApplicationArea=#Suite;
                  SourceExpr=MaxDate }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Vis bel�b i RV;
                             ENU=Show Amounts in LCY];
                  ToolTipML=[DAN=Angiver, om bel�bene i rapporten vises i RV. Hvis du lader feltet st� tomt, vises bel�bene i udenlandske valutaer.;
                             ENU=Specifies if amounts in the report are displayed in LCY. If you leave the check box blank, amounts are shown in foreign currencies.];
                  ApplicationArea=#Suite;
                  SourceExpr=PrintAmountInLCY }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Skift side pr. debitor;
                             ENU=New Page per Customer];
                  ToolTipML=[DAN=Angiver, om hver enkelt debitor udskrives p� en separat side, hvis du har valgt to eller flere debitorer, der skal medtages i rapporten.;
                             ENU=Specifies if each customer balance is printed on a separate page, in case two or more customers are included in the report.];
                  ApplicationArea=#Suite;
                  SourceExpr=PrintOnePrPage }

      { 4   ;2   ;Field     ;
                  CaptionML=[DAN=Medtag ikke-udlignede poster;
                             ENU=Include Unapplied Entries];
                  ToolTipML=[DAN=Angiver, om annullerede poster medtages i rapporten.;
                             ENU=Specifies if unapplied entries are included in the report.];
                  ApplicationArea=#Suite;
                  SourceExpr=PrintUnappliedEntries }

      { 5   ;2   ;Field     ;
                  Name=ShowEntriesWithZeroBalance;
                  CaptionML=[DAN=Vis poster, hvor saldoen er nul;
                             ENU=Show Entries with Zero Balance];
                  ToolTipML=[DAN=Angiver, om rapporten skal medtage poster med en saldo p� nul. Som standard medtager posten kun poster med en positiv eller negativ saldo.;
                             ENU=Specifies if the report must include entries with a balance of 0. By default, the report only includes entries with a positive or negative balance.];
                  ApplicationArea=#Suite;
                  SourceExpr=ShowEntriesWithZeroBalance }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Saldo d. %1;ENU=Balance on %1';
      CurrencyTotalBuffer@1001 : TEMPORARY Record 332;
      CurrencyTotalBuffer2@1002 : TEMPORARY Record 332;
      PrintAmountInLCY@1005 : Boolean;
      PrintOnePrPage@1006 : Boolean;
      CustFilter@1007 : Text;
      MaxDate@1009 : Date;
      OriginalAmt@1010 : Decimal;
      Amt@1011 : Decimal;
      RemainingAmt@1012 : Decimal;
      Counter1@1013 : Integer;
      DtldCustLedgEntryNum@1003 : Integer;
      OK@1014 : Boolean;
      CurrencyCode@1015 : Code[10];
      PrintUnappliedEntries@1004 : Boolean;
      ShowEntriesWithZeroBalance@1008 : Boolean;
      CustBalancetoDateCaptionLbl@9242 : TextConst 'DAN=Debitor - saldo til dato;ENU=Customer - Balance to Date';
      CurrReportPageNoCaptionLbl@2595 : TextConst 'DAN=Side;ENU=Page';
      AllamtsareinLCYCaptionLbl@6201 : TextConst 'DAN=Alle bel�b er i RV.;ENU=All amounts are in LCY.';
      CustLedgEntryPostingDtCaptionLbl@5330 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      OriginalAmtCaptionLbl@8860 : TextConst 'DAN=Bel�b;ENU=Amount';
      TotalCaptionLbl@1909 : TextConst 'DAN=I alt;ENU=Total';
      BlankMaxDateErr@1017 : TextConst 'DAN=Slutdato skal indeholde en v�rdi.;ENU=Ending Date must have a value.';

    PROCEDURE InitializeRequest@1(NewPrintAmountInLCY@1000 : Boolean;NewPrintOnePrPage@1001 : Boolean;NewPrintUnappliedEntries@1002 : Boolean;NewEndingDate@1003 : Date);
    BEGIN
      PrintAmountInLCY := NewPrintAmountInLCY;
      PrintOnePrPage := NewPrintOnePrPage;
      PrintUnappliedEntries := NewPrintUnappliedEntries;
      MaxDate := NewEndingDate;
    END;

    LOCAL PROCEDURE FilterCustLedgerEntry@5(VAR CustLedgerEntry@1000 : Record 21);
    BEGIN
      WITH CustLedgerEntry DO BEGIN
        SETCURRENTKEY("Customer No.","Posting Date");
        SETRANGE("Customer No.",Customer."No.");
        SETRANGE("Posting Date",0D,MaxDate);
      END;
    END;

    LOCAL PROCEDURE AddCustomerDimensionFilter@3(VAR CustLedgerEntry@1000 : Record 21);
    BEGIN
      WITH CustLedgerEntry DO BEGIN
        IF Customer.GETFILTER("Global Dimension 1 Filter") <> '' THEN
          SETFILTER("Global Dimension 1 Code",Customer.GETFILTER("Global Dimension 1 Filter"));
        IF Customer.GETFILTER("Global Dimension 2 Filter") <> '' THEN
          SETFILTER("Global Dimension 2 Code",Customer.GETFILTER("Global Dimension 2 Filter"));
        IF Customer.GETFILTER("Currency Filter") <> '' THEN
          SETFILTER("Currency Code",Customer.GETFILTER("Currency Filter"));
      END;
    END;

    LOCAL PROCEDURE CalcCustomerTotalAmount@8(VAR TempCustLedgerEntry@1000 : TEMPORARY Record 21);
    BEGIN
      WITH TempCustLedgerEntry DO BEGIN
        SETCURRENTKEY("Entry No.");
        SETRANGE("Date Filter",0D,MaxDate);
        AddCustomerDimensionFilter(TempCustLedgerEntry);
        IF FINDSET THEN
          REPEAT
            IF PrintAmountInLCY THEN BEGIN
              CALCFIELDS("Remaining Amt. (LCY)");
              RemainingAmt := "Remaining Amt. (LCY)";
              CurrencyCode := '';
            END ELSE BEGIN
              CALCFIELDS("Remaining Amount");
              RemainingAmt := "Remaining Amount";
              CurrencyCode := "Currency Code";
            END;
            IF RemainingAmt <> 0 THEN
              CurrencyTotalBuffer.UpdateTotal(
                CurrencyCode,
                RemainingAmt,
                0,
                Counter1);
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CheckCustEntryIncluded@6(EntryNo@1000 : Integer) : Boolean;
    VAR
      CustLedgerEntry@1001 : Record 21;
    BEGIN
      IF CustLedgerEntry.GET(EntryNo) AND (CustLedgerEntry."Posting Date" <= MaxDate) THEN BEGIN
        CustLedgerEntry.SETRANGE("Date Filter",0D,MaxDate);
        CustLedgerEntry.CALCFIELDS("Remaining Amount");
        IF CustLedgerEntry."Remaining Amount" <> 0 THEN
          EXIT(TRUE);
        IF PrintUnappliedEntries THEN
          EXIT(CheckUnappliedEntryExists(EntryNo));
      END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckUnappliedEntryExists@7(EntryNo@1001 : Integer) : Boolean;
    VAR
      DetailedCustLedgEntry@1000 : Record 379;
    BEGIN
      WITH DetailedCustLedgEntry DO BEGIN
        SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type","Posting Date");
        SETRANGE("Cust. Ledger Entry No.",EntryNo);
        SETRANGE("Entry Type","Entry Type"::Application);
        SETFILTER("Posting Date",'>%1',MaxDate);
        SETRANGE(Unapplied,TRUE);
        EXIT(NOT ISEMPTY);
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
      <rd:DataSourceID>c51bac03-1cc8-4cff-b436-d1f9d01aa92c</rd:DataSourceID>
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
        <Field Name="TxtCustGeTranmaxDtFilter">
          <DataField>TxtCustGeTranmaxDtFilter</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="PrintOnePrPage">
          <DataField>PrintOnePrPage</DataField>
        </Field>
        <Field Name="CustFilter">
          <DataField>CustFilter</DataField>
        </Field>
        <Field Name="PrintAmountInLCY">
          <DataField>PrintAmountInLCY</DataField>
        </Field>
        <Field Name="CustTableCaptCustFilter">
          <DataField>CustTableCaptCustFilter</DataField>
        </Field>
        <Field Name="No_Customer">
          <DataField>No_Customer</DataField>
        </Field>
        <Field Name="Name_Customer">
          <DataField>Name_Customer</DataField>
        </Field>
        <Field Name="PhoneNo_Customer">
          <DataField>PhoneNo_Customer</DataField>
        </Field>
        <Field Name="CustBalancetoDateCaption">
          <DataField>CustBalancetoDateCaption</DataField>
        </Field>
        <Field Name="CurrReportPageNoCaption">
          <DataField>CurrReportPageNoCaption</DataField>
        </Field>
        <Field Name="AllamtsareinLCYCaption">
          <DataField>AllamtsareinLCYCaption</DataField>
        </Field>
        <Field Name="CustLedgEntryPostingDtCaption">
          <DataField>CustLedgEntryPostingDtCaption</DataField>
        </Field>
        <Field Name="OriginalAmtCaption">
          <DataField>OriginalAmtCaption</DataField>
        </Field>
        <Field Name="PostingDt_CustLedgEntry">
          <DataField>PostingDt_CustLedgEntry</DataField>
        </Field>
        <Field Name="DocType_CustLedgEntry">
          <DataField>DocType_CustLedgEntry</DataField>
        </Field>
        <Field Name="DocNo_CustLedgEntry">
          <DataField>DocNo_CustLedgEntry</DataField>
        </Field>
        <Field Name="Desc_CustLedgEntry">
          <DataField>Desc_CustLedgEntry</DataField>
        </Field>
        <Field Name="OriginalAmt">
          <DataField>OriginalAmt</DataField>
        </Field>
        <Field Name="OriginalAmtFormat">
          <DataField>OriginalAmtFormat</DataField>
        </Field>
        <Field Name="EntryNo_CustLedgEntry">
          <DataField>EntryNo_CustLedgEntry</DataField>
        </Field>
        <Field Name="CurrencyCode">
          <DataField>CurrencyCode</DataField>
        </Field>
        <Field Name="DateFilter_CustLedgEntry">
          <DataField>DateFilter_CustLedgEntry</DataField>
        </Field>
        <Field Name="EntType_DtldCustLedgEnt">
          <DataField>EntType_DtldCustLedgEnt</DataField>
        </Field>
        <Field Name="postDt_DtldCustLedgEntry">
          <DataField>postDt_DtldCustLedgEntry</DataField>
        </Field>
        <Field Name="DocType_DtldCustLedgEntry">
          <DataField>DocType_DtldCustLedgEntry</DataField>
        </Field>
        <Field Name="DocNo_DtldCustLedgEntry">
          <DataField>DocNo_DtldCustLedgEntry</DataField>
        </Field>
        <Field Name="Amt">
          <DataField>Amt</DataField>
        </Field>
        <Field Name="AmtFormat">
          <DataField>AmtFormat</DataField>
        </Field>
        <Field Name="CurrencyCodeDtldCustLedgEntry">
          <DataField>CurrencyCodeDtldCustLedgEntry</DataField>
        </Field>
        <Field Name="EntNo_DtldCustLedgEntry">
          <DataField>EntNo_DtldCustLedgEntry</DataField>
        </Field>
        <Field Name="RemainingAmt">
          <DataField>RemainingAmt</DataField>
        </Field>
        <Field Name="RemainingAmtFormat">
          <DataField>RemainingAmtFormat</DataField>
        </Field>
        <Field Name="CustName">
          <DataField>CustName</DataField>
        </Field>
        <Field Name="TtlAmtCurrencyTtlBuff">
          <DataField>TtlAmtCurrencyTtlBuff</DataField>
        </Field>
        <Field Name="TtlAmtCurrencyTtlBuffFormat">
          <DataField>TtlAmtCurrencyTtlBuffFormat</DataField>
        </Field>
        <Field Name="CurryCode_CurrencyTtBuff">
          <DataField>CurryCode_CurrencyTtBuff</DataField>
        </Field>
        <Field Name="CurryCode_CurrencyTtBuff2">
          <DataField>CurryCode_CurrencyTtBuff2</DataField>
        </Field>
        <Field Name="TtlAmtCurrencyTtlBuff2">
          <DataField>TtlAmtCurrencyTtlBuff2</DataField>
        </Field>
        <Field Name="TtlAmtCurrencyTtlBuff2Format">
          <DataField>TtlAmtCurrencyTtlBuff2Format</DataField>
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
          <Tablix Name="CustLedgEntry1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>0.74965in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.98425in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.86614in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.08661in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.55118in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.25861in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.68036in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntry3PostDateCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!CustLedgEntryPostingDtCaption.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <PaddingRight>0.0625in</PaddingRight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>246</ZIndex>
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
                        <Textbox Name="CustLedgEntry3DocTypeCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocType_CustLedgEntryCaption.Value</Value>
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
                          <ZIndex>245</ZIndex>
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
                        <Textbox Name="CustLedgEntry3DocNoCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocNo_CustLedgEntryCaption.Value</Value>
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
                          <ZIndex>244</ZIndex>
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
                        <Textbox Name="CustLedgEntry3DescCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!Desc_CustLedgEntryCaption.Value</Value>
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
                          <ZIndex>243</ZIndex>
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
                        <Textbox Name="TextBox110">
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
                          <ZIndex>242</ZIndex>
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
                        <Textbox Name="OriginalAmtCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!OriginalAmtCaption.Value)</Value>
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
                          <ZIndex>241</ZIndex>
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
                        <Textbox Name="CustLedgEntry3EntryNoCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!EntryNo_CustLedgEntryCaption.Value</Value>
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
                          <ZIndex>240</ZIndex>
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
                  <Height>0.0625in</Height>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox2</rd:DefaultName>
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
                  <Height>0.0625in</Height>
                  <TablixCells>
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
                          <rd:DefaultName>textbox16</rd:DefaultName>
                          <ZIndex>228</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                                  <Value>=Fields!No_Customer.Value</Value>
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
                          <ZIndex>210</ZIndex>
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
                        <Textbox Name="CustName">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Name_Customer.Value</Value>
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
                          <ZIndex>209</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="TextBox12">
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
                          <ZIndex>208</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
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
                          <rd:DefaultName>textbox15</rd:DefaultName>
                          <ZIndex>194</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustPhoneNoCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!PhoneNo_CustomerCaption.Value</Value>
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
                          <ZIndex>193</ZIndex>
                          <Style>
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
                        <Textbox Name="CustPhoneNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PhoneNo_Customer.Value</Value>
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
                          <ZIndex>192</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox17">
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
                          <ZIndex>191</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntry3PostingDt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDt_CustLedgEntry.Value</Value>
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
                          <ZIndex>159</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3DocType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocType_CustLedgEntry.Value</Value>
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
                          <ZIndex>158</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3DocNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_CustLedgEntry.Value</Value>
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
                          <ZIndex>157</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3Desc">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Desc_CustLedgEntry.Value</Value>
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
                          <ZIndex>156</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CurrencyCode">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrencyCode.Value</Value>
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
                          <ZIndex>155</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="OriginalAmt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!OriginalAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!OriginalAmtFormat.Value</Format>
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
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3EntryNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryNo_CustLedgEntry.Value</Value>
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
                          <ZIndex>153</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3PostDate">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDt_CustLedgEntry.Value</Value>
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
                          <ZIndex>123</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3DocType1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocType_CustLedgEntry.Value</Value>
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
                          <ZIndex>122</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3DocNo1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_CustLedgEntry.Value</Value>
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
                          <ZIndex>121</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3Desc1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Desc_CustLedgEntry.Value</Value>
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
                          <ZIndex>120</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CurrencyCode1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrencyCode.Value</Value>
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
                          <ZIndex>119</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="OriginalAmt1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!OriginalAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!OriginalAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>118</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3EntryNo1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryNo_CustLedgEntry.Value</Value>
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
                          <ZIndex>117</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedgEntryPostDate">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!postDt_DtldCustLedgEntry.Value</Value>
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
                          <ZIndex>105</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedgEntryDocType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocType_DtldCustLedgEntry.Value</Value>
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
                          <ZIndex>104</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedgEntryDocuNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_DtldCustLedgEntry.Value</Value>
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
                          <ZIndex>103</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedgEntryEntryType">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntType_DtldCustLedgEnt.Value</Value>
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
                          <ZIndex>102</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedEntryCurrencyCode">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrencyCodeDtldCustLedgEntry.Value</Value>
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
                          <ZIndex>101</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="Amt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Amt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AmtFormat.Value</Format>
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
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="textbox122">
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
                          <rd:DefaultName>textbox122</rd:DefaultName>
                          <ZIndex>99</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="textbox72">
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
                          <rd:DefaultName>textbox72</rd:DefaultName>
                          <ZIndex>87</ZIndex>
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
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustName3">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustName.Value</Value>
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
                          <ZIndex>86</ZIndex>
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
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="CurrencyTtlBuffCurryCode1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurryCode_CurrencyTtBuff.Value</Value>
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
                          <ZIndex>85</ZIndex>
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
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CurrencyTtlBuffTtlAmt1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TtlAmtCurrencyTtlBuff.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TtlAmtCurrencyTtlBuffFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>84</ZIndex>
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
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox6</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>="#CCCCCC"</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
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
                        <Textbox Name="textbox202">
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
                          <rd:DefaultName>textbox202</rd:DefaultName>
                          <ZIndex>71</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TotalCaption1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
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
                          <ZIndex>17</ZIndex>
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
                        <Textbox Name="textbox140">
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
                          <ZIndex>16</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>3</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox143">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurryCode_CurrencyTtBuff2.Value</Value>
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
                        <Textbox Name="CurrencyTtlBuff2TtlAmt1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TtlAmtCurrencyTtlBuff2.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TtlAmtCurrencyTtlBuff2Format.Value</Format>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox5</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
                  <TablixCells>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox9</rd:DefaultName>
                          <Style>
                            <PaddingRight>0.0625in</PaddingRight>
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
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox19">
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
                          <rd:DefaultName>Textbox19</rd:DefaultName>
                          <Style>
                            <Border />
                            <PaddingRight>0.0625in</PaddingRight>
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
                        <Textbox Name="textbox102">
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
                          <rd:DefaultName>textbox102</rd:DefaultName>
                          <ZIndex>35</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <PaddingRight>0.0625in</PaddingRight>
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
                        <Textbox Name="CurrencyCodeCtrl5">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrencyCodeDtldCustLedgEntry.Value</Value>
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
                          <ZIndex>31</ZIndex>
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
                        <Textbox Name="RemainingAmt1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!RemainingAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!RemainingAmtFormat.Value</Format>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox11</rd:DefaultName>
                          <Style>
                            <Border />
                            <PaddingRight>0.0625in</PaddingRight>
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
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Group Name="Table1_Group">
                    <GroupExpressions>
                      <GroupExpression>=Fields!No_Customer.Value</GroupExpression>
                    </GroupExpressions>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=iif(Fields!No_Customer.Value="",true,false)</Hidden>
                      </Visibility>
                      <KeepWithGroup>After</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=iif(Fields!No_Customer.Value="",true,false)</Hidden>
                      </Visibility>
                      <KeepWithGroup>After</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Group Name="Table1_Group2">
                        <GroupExpressions>
                          <GroupExpression>=Fields!EntryNo_CustLedgEntry.Value</GroupExpression>
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
                                <Hidden>=iif(Fields!DocNo_CustLedgEntry.Value="",true,false) or
 iif(Fields!DocNo_DtldCustLedgEntry.Value&lt;&gt;"",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!EntNo_DtldCustLedgEntry.Value=1,false,true) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!DocNo_DtldCustLedgEntry.Value="",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!CustName.Value="",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!CustName.Value="",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!No_Customer.Value&lt;&gt;"",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                          </TablixMembers>
                          <DataElementName>Detail_Collection</DataElementName>
                          <DataElementOutput>Output</DataElementOutput>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!DocNo_DtldCustLedgEntry.Value="",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!DocNo_DtldCustLedgEntry.Value="",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                      </TablixMembers>
                    </TablixMember>
                  </TablixMembers>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Height>4.02168cm</Height>
            <Width>18.22907cm</Width>
            <Visibility>
              <Hidden>=iif(Fields!PrintOnePrPage.Value=true,true,false)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
            </Style>
          </Tablix>
          <Tablix Name="CustLedgEntry2">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>0.74965in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.98425in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.86614in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.08661in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.55118in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.25861in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.68036in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntry3PostDateCapt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!CustLedgEntryPostingDtCaption.Value)</Value>
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
                          <ZIndex>246</ZIndex>
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
                        <Textbox Name="CustLedgEntry3DocTypeCaption2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocType_CustLedgEntryCaption.Value</Value>
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
                          <ZIndex>245</ZIndex>
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
                        <Textbox Name="CustLedgEntry3DocNoCaption2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocNo_CustLedgEntryCaption.Value</Value>
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
                          <ZIndex>244</ZIndex>
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
                        <Textbox Name="CustLedgEntry3DescCaption2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!Desc_CustLedgEntryCaption.Value</Value>
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
                          <ZIndex>243</ZIndex>
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
                        <Textbox Name="textbox435">
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
                          <ZIndex>242</ZIndex>
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
                        <Textbox Name="OriginalAmtCaption2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!OriginalAmtCaption.Value)</Value>
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
                          <ZIndex>241</ZIndex>
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
                        <Textbox Name="CustLedgEntry3EntryNoCaption2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!EntryNo_CustLedgEntryCaption.Value</Value>
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
                          <ZIndex>240</ZIndex>
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
                  <Height>0.06944in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox20">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox20</rd:DefaultName>
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
                      </CellContents>
                    </TablixCell>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox22</rd:DefaultName>
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
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox23">
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
                          <rd:DefaultName>Textbox23</rd:DefaultName>
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
                      </CellContents>
                    </TablixCell>
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
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox26">
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
                          <rd:DefaultName>Textbox26</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox28</rd:DefaultName>
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
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox29">
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
                          <rd:DefaultName>Textbox29</rd:DefaultName>
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
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox449">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>228</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
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
                          <ZIndex>227</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox451">
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
                          <ZIndex>226</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox452">
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
                          <ZIndex>225</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox453">
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
                          <ZIndex>224</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox454">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>223</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox455">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>222</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>0.0625in</PaddingRight>
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
                                  <Value>=Fields!No_Customer.Value</Value>
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
                          <ZIndex>210</ZIndex>
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
                        <Textbox Name="CustName2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Name_Customer.Value</Value>
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
                          <ZIndex>209</ZIndex>
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
                        <Textbox Name="textbox222">
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
                          <ZIndex>208</ZIndex>
                          <Style>
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
                        <Textbox Name="textbox223">
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
                          <ZIndex>207</ZIndex>
                          <Style>
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
                        <Textbox Name="textbox224">
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
                          <ZIndex>206</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="textbox236">
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
                          <ZIndex>194</ZIndex>
                          <Style>
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
                        <Textbox Name="CustPhoneNoCaption2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!PhoneNo_CustomerCaption.Value</Value>
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
                          <ZIndex>193</ZIndex>
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
                        <Textbox Name="CustPhoneNo2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PhoneNo_Customer.Value</Value>
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
                          <ZIndex>192</ZIndex>
                          <Style>
                            <Border />
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox239">
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
                          <ZIndex>191</ZIndex>
                          <Style>
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
                        <Textbox Name="textbox240">
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
                          <ZIndex>190</ZIndex>
                          <Style>
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
                        <Textbox Name="textbox241">
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
                          <ZIndex>189</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="CustLedgEntry3PostDate2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDt_CustLedgEntry.Value</Value>
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
                          <ZIndex>159</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3DocType2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocType_CustLedgEntry.Value</Value>
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
                          <ZIndex>158</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="textbox309">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_CustLedgEntry.Value</Value>
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
                          <ZIndex>157</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3Desc2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Desc_CustLedgEntry.Value</Value>
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
                          <ZIndex>156</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CurrencyCode2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrencyCode.Value</Value>
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
                          <ZIndex>155</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="OriginalAmt2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!OriginalAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!OriginalAmtFormat.Value</Format>
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
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3EntryNo2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryNo_CustLedgEntry.Value</Value>
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
                          <ZIndex>153</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3PostingDate">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDt_CustLedgEntry.Value</Value>
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
                          <ZIndex>123</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3DocType3">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocType_CustLedgEntry.Value</Value>
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
                          <ZIndex>122</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3DocNo2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_CustLedgEntry.Value</Value>
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
                          <ZIndex>121</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3Desc3">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Desc_CustLedgEntry.Value</Value>
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
                          <ZIndex>120</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedEntryCurrencyCode">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrencyCode.Value</Value>
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
                          <ZIndex>119</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedEntryOriginalAmt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!OriginalAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!OriginalAmtFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>118</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="CustLedgEntry3EntryNo3">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryNo_CustLedgEntry.Value</Value>
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
                          <ZIndex>117</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedgEntryPostDate2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!postDt_DtldCustLedgEntry.Value</Value>
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
                          <ZIndex>105</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedgEntryDocType2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocType_DtldCustLedgEntry.Value</Value>
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
                          <ZIndex>104</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedgEntryDocuNo2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_DtldCustLedgEntry.Value</Value>
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
                          <ZIndex>103</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedgEntryEntryType2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntType_DtldCustLedgEnt.Value</Value>
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
                          <ZIndex>102</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedEntryCurrencyCode2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrencyCodeDtldCustLedgEntry.Value</Value>
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
                          <ZIndex>101</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="DtldCustLedEntryAmt2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Amt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!AmtFormat.Value</Format>
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
                            <Border />
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="textbox367">
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
                          <ZIndex>99</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="textbox379">
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
                          <ZIndex>87</ZIndex>
                          <Style>
                            <Border>
                              <Color>="#CCCCCC"</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
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
                        <Textbox Name="CustNameCtrl9">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustName.Value</Value>
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
                          <ZIndex>86</ZIndex>
                          <Style>
                            <Border>
                              <Color>="#CCCCCC"</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="CurrencyTtlBuffCurryCode">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurryCode_CurrencyTtBuff.Value</Value>
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
                          <ZIndex>85</ZIndex>
                          <Style>
                            <Border>
                              <Color>="#CCCCCC"</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
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
                        <Textbox Name="CurrencyTtlBuffTtlAmt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TtlAmtCurrencyTtlBuff.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TtlAmtCurrencyTtlBuffFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <FontFamily>Segoe UI</FontFamily>
                                <FontSize>8pt</FontSize>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>84</ZIndex>
                          <Style>
                            <Border>
                              <Color>="#CCCCCC"</Color>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox8</rd:DefaultName>
                          <Style>
                            <Border>
                              <Color>="#CCCCCC"</Color>
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
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox395">
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
                          <ZIndex>71</ZIndex>
                          <Style>
                            <FontFamily>Segoe UI</FontFamily>
                            <FontSize>8pt</FontSize>
                            <VerticalAlign>Middle</VerticalAlign>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
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
                                  <Value>=Fields!TotalCaption.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
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
                          <ZIndex>17</ZIndex>
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
                        <Textbox Name="textbox414">
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
                          <ZIndex>16</ZIndex>
                          <Style>
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
                        <Textbox Name="CurrencyTtlBuff2CurryCode">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurryCode_CurrencyTtBuff2.Value</Value>
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
                        <Textbox Name="CurrencyTtlBuff2TtlAmt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TtlAmtCurrencyTtlBuff2.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!TtlAmtCurrencyTtlBuff2Format.Value</Format>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox4</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="textbox271">
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
                          <ZIndex>35</ZIndex>
                          <Style>
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
                        <Textbox Name="CurrencyCodeCtrl56">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrencyCodeDtldCustLedgEntry.Value</Value>
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
                          <ZIndex>31</ZIndex>
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
                        <Textbox Name="RemainingAmt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!RemainingAmt.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!RemainingAmtFormat.Value</Format>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox10</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Group Name="table2_Group1">
                    <GroupExpressions>
                      <GroupExpression>=Fields!No_Customer.Value</GroupExpression>
                    </GroupExpressions>
                    <PageBreak>
                      <BreakLocation>Between</BreakLocation>
                    </PageBreak>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=iif(Fields!No_Customer.Value="",true,false)</Hidden>
                      </Visibility>
                      <KeepWithGroup>After</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=iif(Fields!No_Customer.Value="",true,false)</Hidden>
                      </Visibility>
                      <KeepWithGroup>After</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Group Name="table2_Group2">
                        <GroupExpressions>
                          <GroupExpression>=Fields!EntryNo_CustLedgEntry.Value</GroupExpression>
                        </GroupExpressions>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <Group Name="table2_Details_Group">
                            <DataElementName>Detail</DataElementName>
                          </Group>
                          <TablixMembers>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!DocNo_CustLedgEntry.Value="",true,false) or
 iif(Fields!DocNo_DtldCustLedgEntry.Value&lt;&gt;"",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!EntNo_DtldCustLedgEntry.Value=1,false,true) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!DocNo_DtldCustLedgEntry.Value="",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!CustName.Value="",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!CustName.Value="",true,false) or
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=iif(Fields!No_Customer.Value&lt;&gt;"",true,false)</Hidden>
                              </Visibility>
                            </TablixMember>
                          </TablixMembers>
                          <DataElementName>Detail_Collection</DataElementName>
                          <DataElementOutput>Output</DataElementOutput>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=iif(Fields!DocNo_DtldCustLedgEntry.Value="",true,false) OR
 iif(Fields!No_Customer.Value="",true,false)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                      </TablixMembers>
                    </TablixMember>
                  </TablixMembers>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>4.33565cm</Top>
            <Height>3.88056cm</Height>
            <Width>18.22907cm</Width>
            <ZIndex>1</ZIndex>
            <Visibility>
              <Hidden>=iif(Fields!PrintOnePrPage.Value=false,true,false)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <FontFamily>Segoe UI</FontFamily>
              <FontSize>8pt</FontSize>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>8.21621cm</Height>
        <Style>
          <FontFamily>Segoe UI</FontFamily>
          <FontSize>8pt</FontSize>
        </Style>
      </Body>
      <Width>18.22907cm</Width>
      <Page>
        <PageHeader>
          <Height>2.90195cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="ExecutionTimeTextBox">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!TodayFormatted.Value, "DataSet_Result")</Value>
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
              <Left>14.11111cm</Left>
              <Height>11pt</Height>
              <Width>4.11796cm</Width>
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
              <Top>0.70556cm</Top>
              <Left>14.11111cm</Left>
              <Height>11pt</Height>
              <Width>4.11796cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustTABLECAPTIONCustFilter">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CustTableCaptCustFilter.Value,"DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <TextDecoration>None</TextDecoration>
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
              <Top>2.50472cm</Top>
              <Height>11pt</Height>
              <Width>18.22907cm</Width>
              <ZIndex>2</ZIndex>
              <Visibility>
                <Hidden>=iif(Fields!CustFilter.Value="",true,false) or
 iif(Globals!PageNumber&lt;&gt;1,true,false)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <Border />
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="AllamtsareinLCYCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!AllamtsareinLCYCaption.Value,"DataSet_Result")</Value>
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
              <Top>1.76389cm</Top>
              <Height>11pt</Height>
              <Width>400pt</Width>
              <ZIndex>3</ZIndex>
              <Visibility>
                <Hidden>=iif(Fields!PrintAmountInLCY.Value=false,true,false)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <Border />
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustBalancetoDateCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CustBalancetoDateCaption.Value,"DataSet_Result")</Value>
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
              <Width>400pt</Width>
              <ZIndex>4</ZIndex>
              <Style>
                <Border />
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustGETRANGEMAXDtFilter">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!TxtCustGeTranmaxDtFilter.Value,"DataSet_Result")</Value>
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
              <Top>2.11667cm</Top>
              <Height>11pt</Height>
              <Width>400pt</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <Border />
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="COMPANYNAME">
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
              <Top>0.70556cm</Top>
              <Height>11pt</Height>
              <Width>400pt</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <Border />
                <FontFamily>Segoe UI</FontFamily>
                <FontSize>8pt</FontSize>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="PAGENOCaption">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!CurrReportPageNoCaption.Value,"DataSet_Result") &amp;" " &amp; Globals!PageNumber</Value>
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
              <Top>0.35278cm</Top>
              <Left>14.11111cm</Left>
              <Height>11pt</Height>
              <Width>4.11796cm</Width>
              <ZIndex>7</ZIndex>
              <Style>
                <Border />
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
        <PageHeight>29.7cm</PageHeight>
        <PageWidth>21cm</PageWidth>
        <InteractiveHeight>11in</InteractiveHeight>
        <InteractiveWidth>8.5in</InteractiveWidth>
        <LeftMargin>1.05834cm</LeftMargin>
        <RightMargin>1.48166cm</RightMargin>
        <TopMargin>1.05834cm</TopMargin>
        <BottomMargin>1.05834cm</BottomMargin>
        <ColumnSpacing>1.27cm</ColumnSpacing>
        <Style>
          <FontFamily>Segoe UI</FontFamily>
          <FontSize>8pt</FontSize>
        </Style>
      </Page>
    </ReportSection>
  </ReportSections>
  <ReportParameters>
    <ReportParameter Name="PhoneNo_CustomerCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>PhoneNo_CustomerCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>PhoneNo_CustomerCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="DocType_CustLedgEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>DocType_CustLedgEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>DocType_CustLedgEntryCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="DocNo_CustLedgEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>DocNo_CustLedgEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>DocNo_CustLedgEntryCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Desc_CustLedgEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Desc_CustLedgEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Desc_CustLedgEntryCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="EntryNo_CustLedgEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>EntryNo_CustLedgEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>EntryNo_CustLedgEntryCaption</Prompt>
    </ReportParameter>
  </ReportParameters>
  <ReportParametersLayout>
    <GridLayoutDefinition>
      <NumberOfColumns>1</NumberOfColumns>
      <NumberOfRows>5</NumberOfRows>
      <CellDefinitions>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>0</RowIndex>
          <ParameterName>PhoneNo_CustomerCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>1</RowIndex>
          <ParameterName>DocType_CustLedgEntryCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>2</RowIndex>
          <ParameterName>DocNo_CustLedgEntryCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>3</RowIndex>
          <ParameterName>Desc_CustLedgEntryCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>4</RowIndex>
          <ParameterName>EntryNo_CustLedgEntryCaption</ParameterName>
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
  <rd:ReportID>6c52bc02-b3b7-444d-b28c-75f4e2a17b33</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

