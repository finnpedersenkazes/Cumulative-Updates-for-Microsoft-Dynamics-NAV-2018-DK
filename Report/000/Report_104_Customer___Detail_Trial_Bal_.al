OBJECT Report 104 Customer - Detail Trial Bal.
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debitor - kontokort;
               ENU=Customer - Detail Trial Bal.];
    OnPreReport=VAR
                  CaptionManagement@1000 : Codeunit 42;
                BEGIN
                  CustFilter := CaptionManagement.GetRecordFiltersWithCaptions(Customer);
                  CustDateFilter := Customer.GETFILTER("Date Filter");
                  WITH "Cust. Ledger Entry" DO
                    IF PrintAmountsInLCY THEN BEGIN
                      AmountCaption := FIELDCAPTION("Amount (LCY)");
                      RemainingAmtCaption := FIELDCAPTION("Remaining Amt. (LCY)");
                    END ELSE BEGIN
                      AmountCaption := FIELDCAPTION(Amount);
                      RemainingAmtCaption := FIELDCAPTION("Remaining Amount");
                    END;
                END;

  }
  DATASET
  {
    { 6836;    ;DataItem;                    ;
               DataItemTable=Table18;
               DataItemTableView=SORTING(No.);
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               PageGroupNo := 1;
                               CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                               CurrReport.CREATETOTALS("Cust. Ledger Entry"."Amount (LCY)",StartBalanceLCY,StartBalAdjLCY,Correction,ApplicationRounding);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF PrintOnlyOnePerPage THEN
                                    PageGroupNo := PageGroupNo + 1;

                                  StartBalanceLCY := 0;
                                  StartBalAdjLCY := 0;
                                  IF CustDateFilter <> '' THEN BEGIN
                                    IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                                      SETRANGE("Date Filter",0D,GETRANGEMIN("Date Filter") - 1);
                                      CALCFIELDS("Net Change (LCY)");
                                      StartBalanceLCY := "Net Change (LCY)";
                                    END;
                                    SETFILTER("Date Filter",CustDateFilter);
                                    CALCFIELDS("Net Change (LCY)");
                                    StartBalAdjLCY := "Net Change (LCY)";
                                    CustLedgEntry.SETCURRENTKEY("Customer No.","Posting Date");
                                    CustLedgEntry.SETRANGE("Customer No.","No.");
                                    CustLedgEntry.SETFILTER("Posting Date",CustDateFilter);
                                    IF CustLedgEntry.FIND('-') THEN
                                      REPEAT
                                        CustLedgEntry.SETFILTER("Date Filter",CustDateFilter);
                                        CustLedgEntry.CALCFIELDS("Amount (LCY)");
                                        StartBalAdjLCY := StartBalAdjLCY - CustLedgEntry."Amount (LCY)";
                                        "Detailed Cust. Ledg. Entry".SETCURRENTKEY("Cust. Ledger Entry No.","Entry Type","Posting Date");
                                        "Detailed Cust. Ledg. Entry".SETRANGE("Cust. Ledger Entry No.",CustLedgEntry."Entry No.");
                                        "Detailed Cust. Ledg. Entry".SETFILTER("Entry Type",'%1|%2',
                                          "Detailed Cust. Ledg. Entry"."Entry Type"::"Correction of Remaining Amount",
                                          "Detailed Cust. Ledg. Entry"."Entry Type"::"Appln. Rounding");
                                        "Detailed Cust. Ledg. Entry".SETFILTER("Posting Date",CustDateFilter);
                                        IF "Detailed Cust. Ledg. Entry".FIND('-') THEN
                                          REPEAT
                                            StartBalAdjLCY := StartBalAdjLCY - "Detailed Cust. Ledg. Entry"."Amount (LCY)";
                                          UNTIL "Detailed Cust. Ledg. Entry".NEXT = 0;
                                        "Detailed Cust. Ledg. Entry".RESET;
                                      UNTIL CustLedgEntry.NEXT = 0;
                                  END;
                                  CurrReport.PRINTONLYIFDETAIL := ExcludeBalanceOnly OR (StartBalanceLCY = 0);
                                  CustBalanceLCY := StartBalanceLCY + StartBalAdjLCY
                                END;

               ReqFilterFields=No.,Search Name,Customer Posting Group,Date Filter }

    { 2   ;1   ;Column  ;TodayFormatted      ;
               SourceExpr=FORMAT(TODAY) }

    { 3   ;1   ;Column  ;PeriodCustDatetFilter;
               SourceExpr=STRSUBSTNO(Text000,CustDateFilter) }

    { 6   ;1   ;Column  ;CompanyName         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 42  ;1   ;Column  ;PrintAmountsInLCY   ;
               SourceExpr=PrintAmountsInLCY }

    { 75  ;1   ;Column  ;ExcludeBalanceOnly  ;
               SourceExpr=ExcludeBalanceOnly }

    { 10  ;1   ;Column  ;CustFilterCaption   ;
               SourceExpr=TABLECAPTION + ': ' + CustFilter }

    { 18  ;1   ;Column  ;CustFilter          ;
               SourceExpr=CustFilter }

    { 53  ;1   ;Column  ;AmountCaption       ;
               SourceExpr=AmountCaption }

    { 54  ;1   ;Column  ;RemainingAmtCaption ;
               SourceExpr=RemainingAmtCaption }

    { 22  ;1   ;Column  ;No_Cust             ;
               SourceExpr="No." }

    { 23  ;1   ;Column  ;Name_Cust           ;
               SourceExpr=Name }

    { 25  ;1   ;Column  ;PhoneNo_Cust        ;
               IncludeCaption=Yes;
               SourceExpr="Phone No." }

    { 77  ;1   ;Column  ;PageGroupNo         ;
               SourceExpr=PageGroupNo }

    { 28  ;1   ;Column  ;StartBalanceLCY     ;
               SourceExpr=StartBalanceLCY;
               AutoFormatType=1 }

    { 27  ;1   ;Column  ;StartBalAdjLCY      ;
               SourceExpr=StartBalAdjLCY;
               AutoFormatType=1 }

    { 40  ;1   ;Column  ;CustBalanceLCY      ;
               SourceExpr=CustBalanceLCY;
               AutoFormatType=1 }

    { 65  ;1   ;Column  ;CustLedgerEntryAmtLCY;
               SourceExpr="Cust. Ledger Entry"."Amount (LCY)" + Correction + ApplicationRounding;
               AutoFormatType=1 }

    { 68  ;1   ;Column  ;StartBalanceLCYAdjLCY;
               SourceExpr=StartBalanceLCY + StartBalAdjLCY;
               AutoFormatType=1 }

    { 70  ;1   ;Column  ;StrtBalLCYCustLedgEntryAmt;
               SourceExpr=StartBalanceLCY + "Cust. Ledger Entry"."Amount (LCY)" + Correction + ApplicationRounding;
               AutoFormatType=1 }

    { 1   ;1   ;Column  ;CustDetailTrialBalCaption;
               SourceExpr=CustDetailTrialBalCaptionLbl }

    { 4   ;1   ;Column  ;PageNoCaption       ;
               SourceExpr=PageNoCaptionLbl }

    { 8   ;1   ;Column  ;AllAmtsLCYCaption   ;
               SourceExpr=AllAmtsLCYCaptionLbl }

    { 9   ;1   ;Column  ;RepInclCustsBalCptn ;
               SourceExpr=RepInclCustsBalCptnLbl }

    { 11  ;1   ;Column  ;PostingDateCaption  ;
               SourceExpr=PostingDateCaptionLbl }

    { 20  ;1   ;Column  ;DueDateCaption      ;
               SourceExpr=DueDateCaptionLbl }

    { 57  ;1   ;Column  ;BalanceLCYCaption   ;
               SourceExpr=BalanceLCYCaptionLbl }

    { 26  ;1   ;Column  ;AdjOpeningBalCaption;
               SourceExpr=AdjOpeningBalCaptionLbl }

    { 50  ;1   ;Column  ;BeforePeriodCaption ;
               SourceExpr=BeforePeriodCaptionLbl }

    { 64  ;1   ;Column  ;TotalCaption        ;
               SourceExpr=TotalCaptionLbl }

    { 66  ;1   ;Column  ;OpeningBalCaption   ;
               SourceExpr=OpeningBalCaptionLbl }

    { 19  ;1   ;Column  ;ExternalDocNoCaption;
               SourceExpr=ExternalDocNoCaptionLbl }

    { 8503;1   ;DataItem;                    ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.,Posting Date);
               OnPreDataItem=BEGIN
                               CustLedgEntryExists := FALSE;
                               CurrReport.CREATETOTALS(CustAmount,"Amount (LCY)");
                             END;

               OnAfterGetRecord=BEGIN
                                  CALCFIELDS(Amount,"Remaining Amount","Amount (LCY)","Remaining Amt. (LCY)");

                                  CustLedgEntryExists := TRUE;
                                  IF PrintAmountsInLCY THEN BEGIN
                                    CustAmount := "Amount (LCY)";
                                    CustRemainAmount := "Remaining Amt. (LCY)";
                                    CustCurrencyCode := '';
                                  END ELSE BEGIN
                                    CustAmount := Amount;
                                    CustRemainAmount := "Remaining Amount";
                                    CustCurrencyCode := "Currency Code";
                                  END;
                                  CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                                  IF ("Document Type" = "Document Type"::Payment) OR ("Document Type" = "Document Type"::Refund) THEN
                                    CustEntryDueDate := 0D
                                  ELSE
                                    CustEntryDueDate := "Due Date";
                                END;

               DataItemLink=Customer No.=FIELD(No.),
                            Posting Date=FIELD(Date Filter),
                            Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                            Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                            Date Filter=FIELD(Date Filter) }

    { 35  ;2   ;Column  ;PostDate_CustLedgEntry;
               SourceExpr=FORMAT("Posting Date") }

    { 36  ;2   ;Column  ;DocType_CustLedgEntry;
               IncludeCaption=Yes;
               SourceExpr="Document Type" }

    { 37  ;2   ;Column  ;DocNo_CustLedgEntry ;
               IncludeCaption=Yes;
               SourceExpr="Document No." }

    { 17  ;2   ;Column  ;ExtDocNo_CustLedgEntry;
               SourceExpr="External Document No." }

    { 38  ;2   ;Column  ;Desc_CustLedgEntry  ;
               IncludeCaption=Yes;
               SourceExpr=Description }

    { 39  ;2   ;Column  ;CustAmount          ;
               SourceExpr=CustAmount;
               AutoFormatType=1;
               AutoFormatExpr=CustCurrencyCode }

    { 41  ;2   ;Column  ;CustRemainAmount    ;
               SourceExpr=CustRemainAmount;
               AutoFormatType=1;
               AutoFormatExpr=CustCurrencyCode }

    { 44  ;2   ;Column  ;CustEntryDueDate    ;
               SourceExpr=FORMAT(CustEntryDueDate) }

    { 45  ;2   ;Column  ;EntryNo_CustLedgEntry;
               IncludeCaption=Yes;
               SourceExpr="Entry No." }

    { 51  ;2   ;Column  ;CustCurrencyCode    ;
               SourceExpr=CustCurrencyCode }

    { 56  ;2   ;Column  ;CustBalanceLCY1     ;
               SourceExpr=CustBalanceLCY;
               AutoFormatType=1 }

    { 6942;2   ;DataItem;                    ;
               DataItemTable=Table379;
               DataItemTableView=SORTING(Cust. Ledger Entry No.,Entry Type,Posting Date)
                                 WHERE(Entry Type=FILTER(Appln. Rounding|Correction of Remaining Amount));
               OnPreDataItem=BEGIN
                               SETFILTER("Posting Date",CustDateFilter);
                               Correction := 0;
                               ApplicationRounding := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  CASE "Entry Type" OF
                                    "Entry Type"::"Appln. Rounding":
                                      ApplicationRounding := ApplicationRounding + "Amount (LCY)";
                                    "Entry Type"::"Correction of Remaining Amount":
                                      Correction := Correction + "Amount (LCY)";
                                  END;
                                  CustBalanceLCY := CustBalanceLCY + "Amount (LCY)";
                                END;

               DataItemLink=Cust. Ledger Entry No.=FIELD(Entry No.) }

    { 58  ;3   ;Column  ;EntryType_DtldCustLedgEntry;
               SourceExpr=FORMAT("Entry Type") }

    { 60  ;3   ;Column  ;Correction          ;
               SourceExpr=Correction;
               AutoFormatType=1 }

    { 61  ;3   ;Column  ;CustBalanceLCY2     ;
               SourceExpr=CustBalanceLCY;
               AutoFormatType=1 }

    { 72  ;3   ;Column  ;ApplicationRounding ;
               SourceExpr=ApplicationRounding;
               AutoFormatType=1 }

    { 5444;1   ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnAfterGetRecord=BEGIN
                                  IF NOT CustLedgEntryExists AND ((StartBalanceLCY = 0) OR ExcludeBalanceOnly) THEN BEGIN
                                    StartBalanceLCY := 0;
                                    CurrReport.SKIP;
                                  END;
                                END;
                                 }

    { 48  ;2   ;Column  ;Name1_Cust          ;
               SourceExpr=Customer.Name }

    { 62  ;2   ;Column  ;CustBalanceLCY4     ;
               SourceExpr=CustBalanceLCY;
               AutoFormatType=1 }

    { 80  ;2   ;Column  ;StartBalanceLCY2    ;
               SourceExpr=StartBalanceLCY }

    { 81  ;2   ;Column  ;StartBalAdjLCY2     ;
               SourceExpr=StartBalAdjLCY }

    { 49  ;2   ;Column  ;CustBalStBalStBalAdjLCY;
               SourceExpr=CustBalanceLCY - StartBalanceLCY - StartBalAdjLCY;
               AutoFormatType=1 }

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
                  Name=ShowAmountsInLCY;
                  CaptionML=[DAN=Vis bel�b i RV;
                             ENU=Show Amounts in LCY];
                  ToolTipML=[DAN=Angiver, om de rapporterede bel�b vises i den lokale valuta.;
                             ENU=Specifies if the reported amounts are shown in the local currency.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintAmountsInLCY }

      { 2   ;2   ;Field     ;
                  Name=NewPageperCustomer;
                  CaptionML=[DAN=Skift side pr. debitor;
                             ENU=New Page per Customer];
                  ToolTipML=[DAN=Angiver, om oplysninger om hver enkelt debitor udskrives p� en ny side, hvis du har valgt to eller flere debitorer, der skal medtages i rapporten.;
                             ENU=Specifies if each customer's information is printed on a new page if you have chosen two or more customers to be included in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintOnlyOnePerPage }

      { 3   ;2   ;Field     ;
                  Name=ExcludeCustHaveaBalanceOnly;
                  CaptionML=[DAN=Udelad debitorer, der kun har saldo;
                             ENU=Exclude Customers That Have a Balance Only];
                  ToolTipML=[DAN=Angiver, hvis du ikke �nsker, at rapporten skal omfatte poster for debitorer, som har en saldo, men som ikke har en bev�gelse i den valgte tidsperiode.;
                             ENU=Specifies if you do not want the report to include entries for customers that have a balance but do not have a net change during the selected time period.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=ExcludeBalanceOnly;
                  MultiLine=Yes }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Periode: %1;ENU=Period: %1';
      CustLedgEntry@1016 : Record 21;
      PrintAmountsInLCY@1001 : Boolean;
      PrintOnlyOnePerPage@1002 : Boolean;
      ExcludeBalanceOnly@1003 : Boolean;
      CustFilter@1004 : Text;
      CustDateFilter@1005 : Text;
      AmountCaption@1006 : Text[80];
      RemainingAmtCaption@1007 : Text[30];
      CustAmount@1008 : Decimal;
      CustRemainAmount@1009 : Decimal;
      CustBalanceLCY@1010 : Decimal;
      CustCurrencyCode@1011 : Code[10];
      CustEntryDueDate@1012 : Date;
      StartBalanceLCY@1013 : Decimal;
      StartBalAdjLCY@1015 : Decimal;
      Correction@1019 : Decimal;
      ApplicationRounding@1017 : Decimal;
      CustLedgEntryExists@1014 : Boolean;
      PageGroupNo@1021 : Integer;
      CustDetailTrialBalCaptionLbl@1475 : TextConst 'DAN=Debitor - kontokort;ENU=Customer - Detail Trial Bal.';
      PageNoCaptionLbl@2773 : TextConst 'DAN=Side;ENU=Page';
      AllAmtsLCYCaptionLbl@7254 : TextConst 'DAN=Alle bel�b er i RV.;ENU=All amounts are in LCY';
      RepInclCustsBalCptnLbl@8795 : TextConst 'DAN=Rapporten indeholder ogs� debitorer, der kun har saldi.;ENU=This report also includes customers that only have balances.';
      PostingDateCaptionLbl@4591 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      DueDateCaptionLbl@3162 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      BalanceLCYCaptionLbl@3724 : TextConst 'DAN=Saldo (RV);ENU=Balance (LCY)';
      AdjOpeningBalCaptionLbl@6168 : TextConst 'DAN=Just. af startsaldo;ENU=Adj. of Opening Balance';
      BeforePeriodCaptionLbl@2604 : TextConst 'DAN=Total (RV) f�r periode;ENU=Total (LCY) Before Period';
      TotalCaptionLbl@1909 : TextConst 'DAN=I alt (RV);ENU=Total (LCY)';
      OpeningBalCaptionLbl@1557 : TextConst 'DAN=Total just. af startsaldo;ENU=Total Adj. of Opening Balance';
      ExternalDocNoCaptionLbl@1018 : TextConst 'DAN=Eksternt bilagsnr.;ENU=External Doc. No.';

    PROCEDURE InitializeRequest@1(ShowAmountInLCY@1002 : Boolean;SetPrintOnlyOnePerPage@1000 : Boolean;SetExcludeBalanceOnly@1001 : Boolean);
    BEGIN
      PrintOnlyOnePerPage := SetPrintOnlyOnePerPage;
      PrintAmountsInLCY := ShowAmountInLCY;
      ExcludeBalanceOnly := SetExcludeBalanceOnly;
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
      <rd:DataSourceID>8da16eac-55ee-44f4-8dd4-0f2195b75a8b</rd:DataSourceID>
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
        <Field Name="PeriodCustDatetFilter">
          <DataField>PeriodCustDatetFilter</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="PrintAmountsInLCY">
          <DataField>PrintAmountsInLCY</DataField>
        </Field>
        <Field Name="ExcludeBalanceOnly">
          <DataField>ExcludeBalanceOnly</DataField>
        </Field>
        <Field Name="CustFilterCaption">
          <DataField>CustFilterCaption</DataField>
        </Field>
        <Field Name="CustFilter">
          <DataField>CustFilter</DataField>
        </Field>
        <Field Name="AmountCaption">
          <DataField>AmountCaption</DataField>
        </Field>
        <Field Name="RemainingAmtCaption">
          <DataField>RemainingAmtCaption</DataField>
        </Field>
        <Field Name="No_Cust">
          <DataField>No_Cust</DataField>
        </Field>
        <Field Name="Name_Cust">
          <DataField>Name_Cust</DataField>
        </Field>
        <Field Name="PhoneNo_Cust">
          <DataField>PhoneNo_Cust</DataField>
        </Field>
        <Field Name="PageGroupNo">
          <DataField>PageGroupNo</DataField>
        </Field>
        <Field Name="StartBalanceLCY">
          <DataField>StartBalanceLCY</DataField>
        </Field>
        <Field Name="StartBalanceLCYFormat">
          <DataField>StartBalanceLCYFormat</DataField>
        </Field>
        <Field Name="StartBalAdjLCY">
          <DataField>StartBalAdjLCY</DataField>
        </Field>
        <Field Name="StartBalAdjLCYFormat">
          <DataField>StartBalAdjLCYFormat</DataField>
        </Field>
        <Field Name="CustBalanceLCY">
          <DataField>CustBalanceLCY</DataField>
        </Field>
        <Field Name="CustBalanceLCYFormat">
          <DataField>CustBalanceLCYFormat</DataField>
        </Field>
        <Field Name="CustLedgerEntryAmtLCY">
          <DataField>CustLedgerEntryAmtLCY</DataField>
        </Field>
        <Field Name="CustLedgerEntryAmtLCYFormat">
          <DataField>CustLedgerEntryAmtLCYFormat</DataField>
        </Field>
        <Field Name="StartBalanceLCYAdjLCY">
          <DataField>StartBalanceLCYAdjLCY</DataField>
        </Field>
        <Field Name="StartBalanceLCYAdjLCYFormat">
          <DataField>StartBalanceLCYAdjLCYFormat</DataField>
        </Field>
        <Field Name="StrtBalLCYCustLedgEntryAmt">
          <DataField>StrtBalLCYCustLedgEntryAmt</DataField>
        </Field>
        <Field Name="StrtBalLCYCustLedgEntryAmtFormat">
          <DataField>StrtBalLCYCustLedgEntryAmtFormat</DataField>
        </Field>
        <Field Name="CustDetailTrialBalCaption">
          <DataField>CustDetailTrialBalCaption</DataField>
        </Field>
        <Field Name="PageNoCaption">
          <DataField>PageNoCaption</DataField>
        </Field>
        <Field Name="AllAmtsLCYCaption">
          <DataField>AllAmtsLCYCaption</DataField>
        </Field>
        <Field Name="RepInclCustsBalCptn">
          <DataField>RepInclCustsBalCptn</DataField>
        </Field>
        <Field Name="PostingDateCaption">
          <DataField>PostingDateCaption</DataField>
        </Field>
        <Field Name="DueDateCaption">
          <DataField>DueDateCaption</DataField>
        </Field>
        <Field Name="BalanceLCYCaption">
          <DataField>BalanceLCYCaption</DataField>
        </Field>
        <Field Name="AdjOpeningBalCaption">
          <DataField>AdjOpeningBalCaption</DataField>
        </Field>
        <Field Name="BeforePeriodCaption">
          <DataField>BeforePeriodCaption</DataField>
        </Field>
        <Field Name="TotalCaption">
          <DataField>TotalCaption</DataField>
        </Field>
        <Field Name="OpeningBalCaption">
          <DataField>OpeningBalCaption</DataField>
        </Field>
        <Field Name="ExternalDocNoCaption">
          <DataField>ExternalDocNoCaption</DataField>
        </Field>
        <Field Name="PostDate_CustLedgEntry">
          <DataField>PostDate_CustLedgEntry</DataField>
        </Field>
        <Field Name="DocType_CustLedgEntry">
          <DataField>DocType_CustLedgEntry</DataField>
        </Field>
        <Field Name="DocNo_CustLedgEntry">
          <DataField>DocNo_CustLedgEntry</DataField>
        </Field>
        <Field Name="ExtDocNo_CustLedgEntry">
          <DataField>ExtDocNo_CustLedgEntry</DataField>
        </Field>
        <Field Name="Desc_CustLedgEntry">
          <DataField>Desc_CustLedgEntry</DataField>
        </Field>
        <Field Name="CustAmount">
          <DataField>CustAmount</DataField>
        </Field>
        <Field Name="CustAmountFormat">
          <DataField>CustAmountFormat</DataField>
        </Field>
        <Field Name="CustRemainAmount">
          <DataField>CustRemainAmount</DataField>
        </Field>
        <Field Name="CustRemainAmountFormat">
          <DataField>CustRemainAmountFormat</DataField>
        </Field>
        <Field Name="CustEntryDueDate">
          <DataField>CustEntryDueDate</DataField>
        </Field>
        <Field Name="EntryNo_CustLedgEntry">
          <DataField>EntryNo_CustLedgEntry</DataField>
        </Field>
        <Field Name="CustCurrencyCode">
          <DataField>CustCurrencyCode</DataField>
        </Field>
        <Field Name="CustBalanceLCY1">
          <DataField>CustBalanceLCY1</DataField>
        </Field>
        <Field Name="CustBalanceLCY1Format">
          <DataField>CustBalanceLCY1Format</DataField>
        </Field>
        <Field Name="EntryType_DtldCustLedgEntry">
          <DataField>EntryType_DtldCustLedgEntry</DataField>
        </Field>
        <Field Name="Correction">
          <DataField>Correction</DataField>
        </Field>
        <Field Name="CorrectionFormat">
          <DataField>CorrectionFormat</DataField>
        </Field>
        <Field Name="CustBalanceLCY2">
          <DataField>CustBalanceLCY2</DataField>
        </Field>
        <Field Name="CustBalanceLCY2Format">
          <DataField>CustBalanceLCY2Format</DataField>
        </Field>
        <Field Name="ApplicationRounding">
          <DataField>ApplicationRounding</DataField>
        </Field>
        <Field Name="ApplicationRoundingFormat">
          <DataField>ApplicationRoundingFormat</DataField>
        </Field>
        <Field Name="Name1_Cust">
          <DataField>Name1_Cust</DataField>
        </Field>
        <Field Name="CustBalanceLCY4">
          <DataField>CustBalanceLCY4</DataField>
        </Field>
        <Field Name="CustBalanceLCY4Format">
          <DataField>CustBalanceLCY4Format</DataField>
        </Field>
        <Field Name="StartBalanceLCY2">
          <DataField>StartBalanceLCY2</DataField>
        </Field>
        <Field Name="StartBalanceLCY2Format">
          <DataField>StartBalanceLCY2Format</DataField>
        </Field>
        <Field Name="StartBalAdjLCY2">
          <DataField>StartBalAdjLCY2</DataField>
        </Field>
        <Field Name="StartBalAdjLCY2Format">
          <DataField>StartBalAdjLCY2Format</DataField>
        </Field>
        <Field Name="CustBalStBalStBalAdjLCY">
          <DataField>CustBalStBalStBalAdjLCY</DataField>
        </Field>
        <Field Name="CustBalStBalStBalAdjLCYFormat">
          <DataField>CustBalStBalStBalAdjLCYFormat</DataField>
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
          <Tablix Name="CustLedgerEntry">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>1.89337cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.84384cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.25456cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.21373cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.06261cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.90916cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.03263cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.99397cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.59964cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.20541cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.35278cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryPostingDtCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDateCaption.Value</Value>
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
                          <ZIndex>171</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDocTypeCaption">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>170</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDocNoCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocNo_CustLedgEntryCaption.Value + "/" + "&lt;br&gt;" + "&lt;i&gt;" + Fields!ExternalDocNoCaption.Value + "&lt;/i&gt;"</Value>
                                  <MarkupType>HTML</MarkupType>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
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
                          <ZIndex>169</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDescCaption">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>168</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox134">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>167</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Fields!AmountCaption.Value</Value>
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
                          <ZIndex>166</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="RemainingAmtCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(Fields!RemainingAmtCaption.Value," " , Chr(10))</Value>
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
                          <ZIndex>165</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustBalanceLCYCtrl56Cptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(Fields!BalanceLCYCaption.Value," ",Chr(10))</Value>
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
                          <ZIndex>164</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustEntryDueDateCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DueDateCaption.Value</Value>
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
                          <ZIndex>162</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryEntryNoCaption">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>161</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="Textbox9">
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox9</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox456">
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
                          <rd:DefaultName>Textbox456</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Middle</VerticalAlign>
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
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox8</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox231">
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
                          <rd:DefaultName>textbox231</rd:DefaultName>
                          <ZIndex>157</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox232</rd:DefaultName>
                          <ZIndex>156</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox233">
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
                          <rd:DefaultName>textbox233</rd:DefaultName>
                          <ZIndex>155</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox234">
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
                          <rd:DefaultName>textbox234</rd:DefaultName>
                          <ZIndex>154</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox235</rd:DefaultName>
                          <ZIndex>153</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox237</rd:DefaultName>
                          <ZIndex>151</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox5</rd:DefaultName>
                          <ZIndex>150</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>Solid</Style>
                            </BottomBorder>
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
                        <Textbox Name="Textbox10">
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
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox10</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <Color>#ff0000</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox14</rd:DefaultName>
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
                        <Textbox Name="Textbox17">
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
                          <rd:DefaultName>Textbox17</rd:DefaultName>
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
                        <Textbox Name="Textbox18">
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox18</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox19</rd:DefaultName>
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
                        <Textbox Name="Textbox22">
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox22</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>Textbox23</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                          <rd:DefaultName>Textbox7</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                          <rd:DefaultName>Textbox25</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox26</rd:DefaultName>
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
                        <Textbox Name="CustNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!No_Cust.Value</Value>
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
                          <ZIndex>149</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                                  <Value>=Fields!Name_Cust.Value</Value>
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
                          <ZIndex>148</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
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
                        <Textbox Name="TextBox1">
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
                          <ZIndex>147</ZIndex>
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
                        <Textbox Name="TextBox11">
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
                          <ZIndex>146</ZIndex>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>145</ZIndex>
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
                        <Textbox Name="TextBox13">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!StartBalanceLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>144</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <rd:Selected>true</rd:Selected>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox15">
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
                          <ZIndex>142</ZIndex>
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
                        <Textbox Name="TextBox16">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>141</ZIndex>
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
                        <Textbox Name="textbox173">
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
                          <rd:DefaultName>textbox173</rd:DefaultName>
                          <ZIndex>140</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Parameters!PhoneNo_CustCaption.Value</Value>
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
                          <ZIndex>139</ZIndex>
                          <Style>
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
                        <Textbox Name="CustPhoneNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PhoneNo_Cust.Value</Value>
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
                          <ZIndex>138</ZIndex>
                          <Style>
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
                        <Textbox Name="TextBox111">
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
                          <ZIndex>137</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox112">
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
                          <ZIndex>136</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox114">
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
                          <ZIndex>134</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox115">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>133</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="textbox119">
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
                          <rd:DefaultName>textbox119</rd:DefaultName>
                          <ZIndex>121</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox120</rd:DefaultName>
                          <ZIndex>120</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="AdjofOpeningBalCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AdjOpeningBalCaption.Value</Value>
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
                          <ZIndex>119</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
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
                        <Textbox Name="textbox123">
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
                          <rd:DefaultName>textbox123</rd:DefaultName>
                          <ZIndex>118</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="StartBalAdjLCY">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!StartBalAdjLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>117</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox125</rd:DefaultName>
                          <ZIndex>116</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="StartBalanceLCYAdjLCY1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!StartBalanceLCYAdjLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!StartBalanceLCYAdjLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>115</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox128</rd:DefaultName>
                          <ZIndex>113</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox129</rd:DefaultName>
                          <ZIndex>112</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="CustLedgEntryPostingDt">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostDate_CustLedgEntry.Value</Value>
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
                          <ZIndex>111</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDocType">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>110</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDocNo">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_CustLedgEntry.Value + IIf(Fields!ExtDocNo_CustLedgEntry.Value &lt;&gt; ""," /","") + "&lt;br&gt;" + "&lt;i&gt;" + Fields!ExtDocNo_CustLedgEntry.Value + "&lt;/i&gt;"</Value>
                                  <MarkupType>HTML</MarkupType>
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
                          <ZIndex>109</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDesc">
                          <CanGrow>true</CanGrow>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>108</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustCurrencyCode">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustCurrencyCode.Value</Value>
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
                          <ZIndex>107</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustAmount.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CustAmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>106</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustRemainAmount">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustRemainAmount.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CustRemainAmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>105</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustBalanceLCY">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustBalanceLCY.Value-Fields!Correction.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CustBalanceLCY1Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>104</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustEntryDueDate">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustEntryDueDate.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>d</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>102</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryEntryNo">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>101</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDocType1">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>99</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDocNo1">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_CustLedgEntry.Value + IIf(Fields!ExtDocNo_CustLedgEntry.Value &lt;&gt; ""," /","") + "&lt;br&gt;" + "&lt;i&gt;" + Fields!ExtDocNo_CustLedgEntry.Value + "&lt;/i&gt;"</Value>
                                  <MarkupType>HTML</MarkupType>
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
                          <ZIndex>98</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
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
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryType_DtldCustLedgEntry.Value</Value>
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
                          <ZIndex>97</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>96</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Correction">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Correction.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CorrectionFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>95</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox64</rd:DefaultName>
                          <ZIndex>94</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustBalanceLCYCtrl61">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustBalanceLCY2.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CustBalanceLCY1Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>93</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox67</rd:DefaultName>
                          <ZIndex>91</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox68</rd:DefaultName>
                          <ZIndex>90</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="textbox58">
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
                          <rd:DefaultName>textbox58</rd:DefaultName>
                          <ZIndex>10</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDocType2">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>9</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustLedgEntryDocNo3">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_CustLedgEntry.Value + IIf(Fields!ExtDocNo_CustLedgEntry.Value &lt;&gt; ""," /","") + "&lt;br&gt;" + "&lt;i&gt;" + Fields!ExtDocNo_CustLedgEntry.Value + "&lt;/i&gt;"</Value>
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
                          <ZIndex>8</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="DtldCustLedgEntry2EntryType">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryType_DtldCustLedgEntry.Value</Value>
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
                          <ZIndex>7</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                          <ZIndex>6</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="ApplicationRounding">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!ApplicationRounding.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!ApplicationRoundingFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>5</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox48</rd:DefaultName>
                          <ZIndex>4</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustBalanceLCYCtrl73">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CustBalanceLCY2.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!CustBalanceLCY1Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>3</ZIndex>
                          <Style>
                            <Border />
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox59">
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
                          <rd:DefaultName>textbox59</rd:DefaultName>
                          <ZIndex>1</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value />
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
                          <rd:DefaultName>textbox60</rd:DefaultName>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.07938cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox61">
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
                          <rd:DefaultName>Textbox61</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox62">
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
                          <rd:DefaultName>Textbox62</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox66">
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
                          <rd:DefaultName>Textbox66</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <PaddingLeft>5pt</PaddingLeft>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox69</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox70</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox71</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox72</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox73</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox74</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="textbox29">
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
                          <rd:DefaultName>textbox29</rd:DefaultName>
                          <ZIndex>20</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustNameCtrl48">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>18</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                          <ZIndex>17</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                          <ZIndex>16</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox2</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustBalanceLCY1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!CustBalanceLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Last(Fields!CustBalanceLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>14</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox54</rd:DefaultName>
                          <ZIndex>12</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox55</rd:DefaultName>
                          <ZIndex>11</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox3</rd:DefaultName>
                          <ZIndex>30</ZIndex>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustNameCtrl481">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>28</ZIndex>
                          <Style>
                            <Border />
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
                        <Textbox Name="textbox78">
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
                          <rd:DefaultName>textbox78</rd:DefaultName>
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
                        <Textbox Name="CustBalStBalStBalAdjLCY">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!CustBalStBalStBalAdjLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Last(Fields!CustBalStBalStBalAdjLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>26</ZIndex>
                          <Style>
                            <Border />
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox80</rd:DefaultName>
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
                        <Textbox Name="CustBalanceLCY2">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!CustBalanceLCY.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Last(Fields!CustBalanceLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>24</ZIndex>
                          <Style>
                            <Border />
                            <PaddingLeft>5pt</PaddingLeft>
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
                          <rd:DefaultName>textbox83</rd:DefaultName>
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
                        <Textbox Name="textbox84">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox84</rd:DefaultName>
                          <ZIndex>21</ZIndex>
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
                        <Textbox Name="textbox146">
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
                          <rd:DefaultName>textbox146</rd:DefaultName>
                          <ZIndex>52</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox147</rd:DefaultName>
                          <ZIndex>51</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox148</rd:DefaultName>
                          <ZIndex>50</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox149</rd:DefaultName>
                          <ZIndex>49</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox150</rd:DefaultName>
                          <ZIndex>48</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox151</rd:DefaultName>
                          <ZIndex>47</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox52</rd:DefaultName>
                          <ZIndex>46</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox65</rd:DefaultName>
                          <ZIndex>45</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox156">
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
                          <rd:DefaultName>textbox156</rd:DefaultName>
                          <ZIndex>43</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox157</rd:DefaultName>
                          <ZIndex>42</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="TotalLCYBeforePeriodCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!BeforePeriodCaption.Value)</Value>
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
                          <ZIndex>60</ZIndex>
                          <Style>
                            <Border />
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
                        <Textbox Name="textbox319">
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
                          <ZIndex>58</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>57</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="StartBalanceLCYCtrl80">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalanceLCY2.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=First(Fields!StartBalanceLCYFormat.Value)</Format>
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
                            <Border />
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
                        <Textbox Name="textbox307">
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
                          <rd:DefaultName>textbox307</rd:DefaultName>
                          <ZIndex>54</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value />
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
                          <rd:DefaultName>textbox308</rd:DefaultName>
                          <ZIndex>53</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="TotalAdjofOpeningBalCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!OpeningBalCaption.Value)</Value>
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
                          <ZIndex>67</ZIndex>
                          <Style>
                            <Border />
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
                        <Textbox Name="StartBalAdjLCY_Ctrl67">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalAdjLCY2.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=First(Fields!StartBalAdjLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>65</ZIndex>
                          <Style>
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
                        <Textbox Name="StartBalanceLCYAdjLCY">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalanceLCY2.Value)+Sum(Fields!StartBalAdjLCY2.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=First(Fields!StartBalanceLCYAdjLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>64</ZIndex>
                          <Style>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox20</rd:DefaultName>
                          <ZIndex>62</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox21</rd:DefaultName>
                          <ZIndex>61</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="TotalLCYCptn">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalCaption.Value)</Value>
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
                          <ZIndex>74</ZIndex>
                          <Style>
                            <Border />
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
                        <Textbox Name="textbox4">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!CustBalanceLCY4.Value)-(Sum(Fields!StartBalanceLCY2.Value)+Sum(Fields!StartBalAdjLCY2.Value))</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!CustLedgerEntryAmtLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>72</ZIndex>
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
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CustBalanceLCYCtrl62">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!CustBalanceLCY4.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!StrtBalLCYCustLedgEntryAmtFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>71</ZIndex>
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
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox291">
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
                          <rd:DefaultName>textbox291</rd:DefaultName>
                          <ZIndex>69</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox292">
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox292</rd:DefaultName>
                          <ZIndex>68</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="TotalLCYBeforePeriodCptn1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!BeforePeriodCaption.Value)</Value>
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
                          <ZIndex>82</ZIndex>
                          <Style>
                            <Border />
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
                        <Textbox Name="textbox331">
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
                          <ZIndex>80</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>79</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="SumStartBalanceLCYCtrl80">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalanceLCY2.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=First(Fields!StartBalanceLCYFormat.Value)</Format>
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
                            <Border />
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
                        <Textbox Name="textbox275">
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
                          <rd:DefaultName>textbox275</rd:DefaultName>
                          <ZIndex>76</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox276</rd:DefaultName>
                          <ZIndex>75</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox28</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox30">
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox30</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox31">
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox31</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox32</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox33</rd:DefaultName>
                          <Style>
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
                        <Textbox Name="Textbox35">
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox35</rd:DefaultName>
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
                        <Textbox Name="Textbox39">
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox39</rd:DefaultName>
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
                        <Textbox Name="Textbox40">
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
                          <rd:DefaultName>Textbox40</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox41">
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox41</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="Textbox42">
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox42</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox43">
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox43</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox44">
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox44</rd:DefaultName>
                          <Style>
                            <Border />
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox47">
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
                          <rd:DefaultName>Textbox47</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox49">
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
                          <rd:DefaultName>Textbox49</rd:DefaultName>
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
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
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
                          <rd:DefaultName>Textbox51</rd:DefaultName>
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
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox53">
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox53</rd:DefaultName>
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
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox56">
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
                          <rd:DefaultName>Textbox56</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox57">
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox57</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="TotalLCYCptn1">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!TotalCaption.Value)</Value>
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
                          <ZIndex>89</ZIndex>
                          <Style>
                            <Border />
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
                        <Textbox Name="CustBalanceLCYStartBalanceLCY">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!CustBalanceLCY4.Value)-Sum(Fields!StartBalanceLCY2.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!StrtBalLCYCustLedgEntryAmtFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>87</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="SumCustBalanceLCYCtrl62">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!CustBalanceLCY4.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!StrtBalLCYCustLedgEntryAmtFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>86</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
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
                        <Textbox Name="textbox27">
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
                          <rd:DefaultName>textbox27</rd:DefaultName>
                          <ZIndex>84</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                          <rd:DefaultName>textbox63</rd:DefaultName>
                          <ZIndex>83</ZIndex>
                          <Style>
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
                </TablixMember>
                <TablixMember>
                  <Group Name="Table1_Group1">
                    <GroupExpressions>
                      <GroupExpression>=1</GroupExpression>
                    </GroupExpressions>
                  </Group>
                  <TablixMembers>
                    <TablixMember>
                      <Group Name="Table1_Group2">
                        <GroupExpressions>
                          <GroupExpression>=Fields!PageGroupNo.Value</GroupExpression>
                        </GroupExpressions>
                        <PageBreak>
                          <BreakLocation>Between</BreakLocation>
                        </PageBreak>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <Group Name="Table1_Group">
                            <GroupExpressions>
                              <GroupExpression>=Fields!No_Cust.Value</GroupExpression>
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
                              <Visibility>
                                <Hidden>=IIF(Fields!StartBalAdjLCY.Value=0,TRUE,FALSE)</Hidden>
                              </Visibility>
                              <KeepWithGroup>After</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Group Name="Table1_Group3">
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
                                        <Hidden>=IsNothing(Fields!EntryNo_CustLedgEntry.Value)</Hidden>
                                      </Visibility>
                                    </TablixMember>
                                    <TablixMember>
                                      <Visibility>
                                        <Hidden>=IIF(Fields!Correction.Value=0,TRUE,FALSE)</Hidden>
                                      </Visibility>
                                    </TablixMember>
                                    <TablixMember>
                                      <Visibility>
                                        <Hidden>=IIF(Fields!ApplicationRounding.Value=0,TRUE,FALSE)</Hidden>
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
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF(Fields!PrintAmountsInLCY.Value=TRUE,TRUE,FALSE)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF(Fields!PrintAmountsInLCY.Value=TRUE,FALSE,TRUE)</Hidden>
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
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Sum(Fields!StartBalAdjLCY.Value)=0,TRUE,FALSE)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Sum(Fields!StartBalAdjLCY.Value)=0,TRUE,FALSE)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Sum(Fields!StartBalAdjLCY.Value)=0,TRUE,FALSE)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Sum(Fields!StartBalAdjLCY.Value)=0,FALSE,TRUE)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <KeepWithGroup>Before</KeepWithGroup>
                    </TablixMember>
                    <TablixMember>
                      <KeepWithGroup>Before</KeepWithGroup>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Sum(Fields!StartBalAdjLCY.Value)=0,FALSE,TRUE)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                  </TablixMembers>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>20pt</Top>
            <Height>6.0766cm</Height>
            <Width>18.00893cm</Width>
            <Style />
          </Tablix>
          <Textbox Name="CustTABLECAPTIONFilter">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!CustFilterCaption.Value)</Value>
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
            <Top>10pt</Top>
            <Height>11pt</Height>
            <Width>18.00893cm</Width>
            <ZIndex>1</ZIndex>
            <Visibility>
              <Hidden>=IIF(Fields!CustFilter.Value="",TRUE,FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
          <Textbox Name="ThisRepInclCustsOnlyBalCptn">
            <KeepTogether>true</KeepTogether>
            <Paragraphs>
              <Paragraph>
                <TextRuns>
                  <TextRun>
                    <Value>=First(Fields!RepInclCustsBalCptn.Value)</Value>
                    <Style>
                      <FontFamily>Segoe UI</FontFamily>
                      <FontSize>8pt</FontSize>
                    </Style>
                  </TextRun>
                </TextRuns>
                <Style />
              </Paragraph>
            </Paragraphs>
            <Height>11pt</Height>
            <Width>18.00893cm</Width>
            <ZIndex>2</ZIndex>
            <Visibility>
              <Hidden>=IIF(Fields!ExcludeBalanceOnly.Value=TRUE,TRUE,FALSE)</Hidden>
            </Visibility>
            <DataElementOutput>NoOutput</DataElementOutput>
            <Style>
              <VerticalAlign>Middle</VerticalAlign>
            </Style>
          </Textbox>
        </ReportItems>
        <Height>2.67014in</Height>
        <Style />
      </Body>
      <Width>7.09013in</Width>
      <Page>
        <PageHeader>
          <Height>0.97222in</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="AllamtsareinLCYCptn">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!AllAmtsLCYCaption.Value</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>40pt</Top>
              <Height>11pt</Height>
              <Width>17.93838cm</Width>
              <Visibility>
                <Hidden>=IIF(Fields!PrintAmountsInLCY.Value=FALSE,TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
              <Style>
                <Border />
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CurrReportPAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!PageNoCaption.Value &amp;"    "&amp;Globals!PageNumber</Value>
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
              <Top>10pt</Top>
              <Left>12.97687cm</Left>
              <Height>11pt</Height>
              <Width>5.02098cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="CustDetailTrialBalCptn1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!CustDetailTrialBalCaption.Value</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>14pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Height>20pt</Height>
              <Width>12.94159cm</Width>
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
                      <Value>=Fields!CompanyName.Value</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>30pt</Top>
              <Height>11pt</Height>
              <Width>17.99785cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Text000CustDtFilter1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=Fields!PeriodCustDatetFilter.Value</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style />
                </Paragraph>
              </Paragraphs>
              <Top>20pt</Top>
              <Height>11pt</Height>
              <Width>12.94159cm</Width>
              <ZIndex>4</ZIndex>
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
                      <Value>=Fields!TodayFormatted.Value</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Format>g</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>12.97687cm</Left>
              <Height>11pt</Height>
              <Width>5.03206cm</Width>
              <ZIndex>5</ZIndex>
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
              <Top>20pt</Top>
              <Left>12.97687cm</Left>
              <Height>11pt</Height>
              <Width>5.03206cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
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
        <BottomMargin>0.41667in</BottomMargin>
        <Style />
      </Page>
    </ReportSection>
  </ReportSections>
  <ReportParameters>
    <ReportParameter Name="PhoneNo_CustCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>PhoneNo_CustCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>PhoneNo_CustCaption</Prompt>
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
          <ParameterName>PhoneNo_CustCaption</ParameterName>
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
  <rd:ReportUnitType>Inch</rd:ReportUnitType>
  <rd:ReportID>ece01aa1-21dc-42ce-80d9-9c65b57a7364</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

