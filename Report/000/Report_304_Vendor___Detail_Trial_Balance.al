OBJECT Report 304 Vendor - Detail Trial Balance
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditor - kontokort;
               ENU=Vendor - Detail Trial Balance];
    OnPreReport=VAR
                  CaptionManagement@1000 : Codeunit 42;
                BEGIN
                  VendFilter := CaptionManagement.GetRecordFiltersWithCaptions(Vendor);
                  VendDateFilter := Vendor.GETFILTER("Date Filter");

                  WITH "Vendor Ledger Entry" DO
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
    { 3182;    ;DataItem;                    ;
               DataItemTable=Table23;
               DataItemTableView=SORTING(No.);
               PrintOnlyIfDetail=Yes;
               OnPreDataItem=BEGIN
                               PageGroupNo := 1;
                               SumCorrections := 0;

                               CurrReport.NEWPAGEPERRECORD := PrintOnlyOnePerPage;
                               CurrReport.CREATETOTALS("Vendor Ledger Entry"."Amount (LCY)",StartBalanceLCY,StartBalAdjLCY,Correction,ApplicationRounding);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF PrintOnlyOnePerPage THEN
                                    PageGroupNo := PageGroupNo + 1;

                                  StartBalanceLCY := 0;
                                  StartBalAdjLCY := 0;
                                  IF VendDateFilter <> '' THEN BEGIN
                                    IF GETRANGEMIN("Date Filter") <> 0D THEN BEGIN
                                      SETRANGE("Date Filter",0D,GETRANGEMIN("Date Filter") - 1);
                                      CALCFIELDS("Net Change (LCY)");
                                      StartBalanceLCY := -"Net Change (LCY)";
                                    END;
                                    SETFILTER("Date Filter",VendDateFilter);
                                    CALCFIELDS("Net Change (LCY)");
                                    StartBalAdjLCY := -"Net Change (LCY)";
                                    VendorLedgerEntry.SETCURRENTKEY("Vendor No.","Posting Date");
                                    VendorLedgerEntry.SETRANGE("Vendor No.","No.");
                                    VendorLedgerEntry.SETFILTER("Posting Date",VendDateFilter);
                                    IF VendorLedgerEntry.FIND('-') THEN
                                      REPEAT
                                        VendorLedgerEntry.SETFILTER("Date Filter",VendDateFilter);
                                        VendorLedgerEntry.CALCFIELDS("Amount (LCY)");
                                        StartBalAdjLCY := StartBalAdjLCY - VendorLedgerEntry."Amount (LCY)";
                                        "Detailed Vendor Ledg. Entry".SETCURRENTKEY("Vendor Ledger Entry No.","Entry Type","Posting Date");
                                        "Detailed Vendor Ledg. Entry".SETRANGE("Vendor Ledger Entry No.",VendorLedgerEntry."Entry No.");
                                        "Detailed Vendor Ledg. Entry".SETFILTER("Entry Type",'%1|%2',
                                          "Detailed Vendor Ledg. Entry"."Entry Type"::"Correction of Remaining Amount",
                                          "Detailed Vendor Ledg. Entry"."Entry Type"::"Appln. Rounding");
                                        "Detailed Vendor Ledg. Entry".SETFILTER("Posting Date",VendDateFilter);
                                        IF "Detailed Vendor Ledg. Entry".FIND('-') THEN
                                          REPEAT
                                            StartBalAdjLCY := StartBalAdjLCY - "Detailed Vendor Ledg. Entry"."Amount (LCY)";
                                          UNTIL "Detailed Vendor Ledg. Entry".NEXT = 0;
                                        "Detailed Vendor Ledg. Entry".RESET;
                                      UNTIL VendorLedgerEntry.NEXT = 0;
                                  END;
                                  CurrReport.PRINTONLYIFDETAIL := ExcludeBalanceOnly OR (StartBalanceLCY = 0);
                                  VendBalanceLCY := StartBalanceLCY + StartBalAdjLCY;
                                END;

               ReqFilterFields=No.,Search Name,Vendor Posting Group,Date Filter }

    { 3   ;1   ;Column  ;VendDatetFilterPeriod;
               SourceExpr=STRSUBSTNO(Text000,VendDateFilter) }

    { 6   ;1   ;Column  ;CompanyName         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 10  ;1   ;Column  ;VendorTblCapVendFltr;
               SourceExpr=TABLECAPTION + ': ' + VendFilter }

    { 18  ;1   ;Column  ;VendFilter          ;
               SourceExpr=VendFilter }

    { 42  ;1   ;Column  ;PageGroupNo         ;
               SourceExpr=PageGroupNo }

    { 74  ;1   ;Column  ;PrintAmountsInLCY   ;
               SourceExpr=PrintAmountsInLCY }

    { 75  ;1   ;Column  ;ExcludeBalanceOnly  ;
               SourceExpr=ExcludeBalanceOnly }

    { 76  ;1   ;Column  ;PrintOnlyOnePerPage ;
               SourceExpr=PrintOnlyOnePerPage }

    { 15  ;1   ;Column  ;AmountCaption       ;
               SourceExpr=AmountCaption;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 52  ;1   ;Column  ;RemainingAmtCaption ;
               SourceExpr=RemainingAmtCaption;
               AutoFormatType=1;
               AutoFormatExpr="Currency Code" }

    { 22  ;1   ;Column  ;No_Vendor           ;
               SourceExpr="No." }

    { 23  ;1   ;Column  ;Name_Vendor         ;
               SourceExpr=Name }

    { 25  ;1   ;Column  ;PhoneNo_Vendor      ;
               IncludeCaption=Yes;
               SourceExpr="Phone No." }

    { 28  ;1   ;Column  ;StartBalanceLCY     ;
               SourceExpr=StartBalanceLCY;
               AutoFormatType=1 }

    { 34  ;1   ;Column  ;StartBalAdjLCY      ;
               SourceExpr=StartBalAdjLCY;
               AutoFormatType=1 }

    { 47  ;1   ;Column  ;VendBalanceLCY      ;
               SourceExpr=VendBalanceLCY;
               AutoFormatType=1 }

    { 68  ;1   ;Column  ;StrtBalLCYStartBalAdjLCY;
               SourceExpr=StartBalanceLCY + StartBalAdjLCY;
               AutoFormatType=1 }

    { 1   ;1   ;Column  ;VendDetailTrialBalCap;
               SourceExpr=VendDetailTrialBalCapLbl }

    { 4   ;1   ;Column  ;PageCaption         ;
               SourceExpr=PageCaptionLbl }

    { 8   ;1   ;Column  ;AllamountsareinLCYCaption;
               SourceExpr=AllamountsareinLCYCaptionLbl }

    { 9   ;1   ;Column  ;ReportIncludesvendorshavebalanceCaption;
               SourceExpr=ReportIncludesvendorshavebalanceCaptionLbl }

    { 11  ;1   ;Column  ;PostingDateCaption  ;
               SourceExpr=PostingDateCaptionLbl }

    { 16  ;1   ;Column  ;BalanceLCYCaption   ;
               SourceExpr=BalanceLCYCaptionLbl }

    { 20  ;1   ;Column  ;DueDateCaption      ;
               SourceExpr=DueDateCaptionLbl }

    { 17  ;1   ;Column  ;AdjofOpeningBalanceCaption;
               SourceExpr=AdjofOpeningBalanceCaptionLbl }

    { 63  ;1   ;Column  ;TotalLCYCaption     ;
               SourceExpr=TotalLCYCaptionLbl }

    { 64  ;1   ;Column  ;TotalAdjofOpenBalCaption;
               SourceExpr=TotalAdjofOpenBalCaptionLbl }

    { 70  ;1   ;Column  ;TotalLCYBeforePeriodCaption;
               SourceExpr=TotalLCYBeforePeriodCaptionLbl }

    { 5   ;1   ;Column  ;ExternalDocNoCaption;
               SourceExpr=ExternalDocNoCaptionLbl }

    { 4114;1   ;DataItem;                    ;
               DataItemTable=Table25;
               DataItemTableView=SORTING(Vendor No.,Posting Date);
               OnPreDataItem=BEGIN
                               VendLedgEntryExists := FALSE;
                               CurrReport.CREATETOTALS(VendAmount,"Amount (LCY)");
                             END;

               OnAfterGetRecord=BEGIN
                                  CALCFIELDS(Amount,"Remaining Amount","Amount (LCY)","Remaining Amt. (LCY)");

                                  VendLedgEntryExists := TRUE;
                                  IF PrintAmountsInLCY THEN BEGIN
                                    VendAmount := "Amount (LCY)";
                                    VendRemainAmount := "Remaining Amt. (LCY)";
                                    VendCurrencyCode := '';
                                  END ELSE BEGIN
                                    VendAmount := Amount;
                                    VendRemainAmount := "Remaining Amount";
                                    VendCurrencyCode := "Currency Code";
                                  END;
                                  VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                                  IF ("Document Type" = "Document Type"::Payment) OR ("Document Type" = "Document Type"::Refund) THEN
                                    VendEntryDueDate := 0D
                                  ELSE
                                    VendEntryDueDate := "Due Date";
                                END;

               DataItemLink=Vendor No.=FIELD(No.),
                            Posting Date=FIELD(Date Filter),
                            Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                            Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                            Date Filter=FIELD(Date Filter) }

    { 35  ;2   ;Column  ;PostingDate_VendLedgEntry;
               SourceExpr=FORMAT("Posting Date") }

    { 36  ;2   ;Column  ;DocType_VendLedgEntry;
               IncludeCaption=Yes;
               SourceExpr="Document Type" }

    { 37  ;2   ;Column  ;DocNo_VendLedgerEntry;
               IncludeCaption=Yes;
               SourceExpr="Document No." }

    { 2   ;2   ;Column  ;ExtDocNo_VendLedgerEntry;
               SourceExpr="External Document No." }

    { 38  ;2   ;Column  ;Desc_VendLedgerEntry;
               IncludeCaption=Yes;
               SourceExpr=Description }

    { 39  ;2   ;Column  ;VendAmount          ;
               SourceExpr=VendAmount;
               AutoFormatType=1;
               AutoFormatExpr=VendCurrencyCode }

    { 40  ;2   ;Column  ;VendBalLCY2         ;
               SourceExpr=VendBalanceLCY;
               AutoFormatType=1 }

    { 41  ;2   ;Column  ;VendRemainAmount    ;
               SourceExpr=VendRemainAmount;
               AutoFormatType=1;
               AutoFormatExpr=VendCurrencyCode }

    { 44  ;2   ;Column  ;VendEntryDueDate    ;
               SourceExpr=FORMAT(VendEntryDueDate) }

    { 45  ;2   ;Column  ;EntryNo_VendorLedgerEntry;
               IncludeCaption=Yes;
               SourceExpr="Entry No." }

    { 54  ;2   ;Column  ;VendCurrencyCode    ;
               SourceExpr=VendCurrencyCode }

    { 2149;2   ;DataItem;                    ;
               DataItemTable=Table380;
               DataItemTableView=SORTING(Vendor Ledger Entry No.,Entry Type,Posting Date)
                                 WHERE(Entry Type=CONST(Correction of Remaining Amount));
               OnPreDataItem=BEGIN
                               SETFILTER("Posting Date",VendDateFilter);
                               Correction := 0;
                             END;

               OnAfterGetRecord=BEGIN
                                  Correction := Correction + "Amount (LCY)";
                                  VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                                END;

               OnPostDataItem=BEGIN
                                SumCorrections := SumCorrections + Correction;
                              END;

               DataItemLink=Vendor Ledger Entry No.=FIELD(Entry No.) }

    { 58  ;3   ;Column  ;EntryTyp_DetVendLedgEntry;
               SourceExpr="Entry Type" }

    { 59  ;3   ;Column  ;Correction          ;
               SourceExpr=Correction;
               AutoFormatType=1 }

    { 4103;2   ;DataItem;Detailed Vendor Ledg. Entry2;
               DataItemTable=Table380;
               DataItemTableView=SORTING(Vendor Ledger Entry No.,Entry Type,Posting Date)
                                 WHERE(Entry Type=CONST(Appln. Rounding));
               OnPreDataItem=BEGIN
                               SETFILTER("Posting Date",VendDateFilter);
                             END;

               OnAfterGetRecord=BEGIN
                                  ApplicationRounding := ApplicationRounding + "Amount (LCY)";
                                  VendBalanceLCY := VendBalanceLCY + "Amount (LCY)";
                                END;

               DataItemLink=Vendor Ledger Entry No.=FIELD(Entry No.) }

    { 55  ;3   ;Column  ;Entry_DetVendLedgEntry2;
               SourceExpr="Entry Type" }

    { 56  ;3   ;Column  ;VendBalanceLCY3     ;
               SourceExpr=VendBalanceLCY;
               AutoFormatType=1 }

    { 71  ;3   ;Column  ;ApplicationRounding ;
               SourceExpr=ApplicationRounding;
               AutoFormatType=1 }

    { 5444;1   ;DataItem;                    ;
               DataItemTable=Table2000000026;
               DataItemTableView=SORTING(Number)
                                 WHERE(Number=CONST(1));
               OnAfterGetRecord=BEGIN
                                  IF NOT VendLedgEntryExists AND ((StartBalanceLCY = 0) OR ExcludeBalanceOnly) THEN BEGIN
                                    StartBalanceLCY := 0;
                                    CurrReport.SKIP;
                                  END;
                                END;
                                 }

    { 62  ;2   ;Column  ;VendBalanceLCY4     ;
               SourceExpr=VendBalanceLCY;
               AutoFormatType=1 }

    { 78  ;2   ;Column  ;StartBalAdjLCY1     ;
               SourceExpr=StartBalAdjLCY }

    { 79  ;2   ;Column  ;StartBalanceLCY1    ;
               SourceExpr=StartBalanceLCY }

    { 49  ;2   ;Column  ;VendBalStrtBalStrtBalAdj;
               SourceExpr=VendBalanceLCY - StartBalanceLCY;
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
                  CaptionML=[DAN=Skift side pr. kreditor;
                             ENU=New Page per Vendor];
                  ToolTipML=[DAN=Angiver, om oplysninger om hver enkelt kreditor udskrives p� en ny side, hvis du har valgt to eller flere kreditorer, der skal medtages i rapporten.;
                             ENU=Specifies if each vendor's information is printed on a new page if you have chosen two or more vendors to be included in the report.];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintOnlyOnePerPage }

      { 3   ;2   ;Field     ;
                  CaptionML=[DAN=Udelad kreditorer, der kun har saldo;
                             ENU=Exclude Vendors That Have A Balance Only];
                  ToolTipML=[DAN=Angiver, hvis du ikke �nsker, at rapporten skal omfatte poster for kreditorer, som har en saldo, men som ikke har en bev�gelse i den valgte tidsperiode.;
                             ENU=Specifies if you do not want the report to include entries for vendors that have a balance but do not have a net change during the selected time period.];
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
      VendorLedgerEntry@1015 : Record 25;
      VendFilter@1001 : Text;
      VendDateFilter@1002 : Text;
      VendAmount@1003 : Decimal;
      VendRemainAmount@1004 : Decimal;
      VendBalanceLCY@1005 : Decimal;
      VendEntryDueDate@1006 : Date;
      StartBalanceLCY@1007 : Decimal;
      StartBalAdjLCY@1016 : Decimal;
      Correction@1017 : Decimal;
      ApplicationRounding@1018 : Decimal;
      ExcludeBalanceOnly@1008 : Boolean;
      PrintAmountsInLCY@1009 : Boolean;
      PrintOnlyOnePerPage@1010 : Boolean;
      VendLedgEntryExists@1011 : Boolean;
      AmountCaption@1012 : Text[30];
      RemainingAmtCaption@1013 : Text[30];
      VendCurrencyCode@1014 : Code[10];
      PageGroupNo@1019 : Integer;
      SumCorrections@1020 : Decimal;
      VendDetailTrialBalCapLbl@3278 : TextConst 'DAN=Kreditor - kontokort;ENU=Vendor - Detail Trial Balance';
      PageCaptionLbl@6215 : TextConst 'DAN=Side;ENU=Page';
      AllamountsareinLCYCaptionLbl@3692 : TextConst 'DAN=Alle bel�b er i RV.;ENU=All amounts are in LCY.';
      ReportIncludesvendorshavebalanceCaptionLbl@1632 : TextConst 'DAN=Rapporten indeholder ogs� kreditorer, der kun har saldi.;ENU=This report also includes vendors that only have balances.';
      PostingDateCaptionLbl@4591 : TextConst 'DAN=Bogf�ringsdato;ENU=Posting Date';
      BalanceLCYCaptionLbl@3724 : TextConst 'DAN=Saldo (RV);ENU=Balance (LCY)';
      DueDateCaptionLbl@3162 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      AdjofOpeningBalanceCaptionLbl@4089 : TextConst 'DAN=Just. af startsaldo;ENU=Adj. of Opening Balance';
      TotalLCYCaptionLbl@5808 : TextConst 'DAN=I alt (RV);ENU=Total (LCY)';
      TotalAdjofOpenBalCaptionLbl@6111 : TextConst 'DAN=Total just. af startsaldo;ENU=Total Adj. of Opening Balance';
      TotalLCYBeforePeriodCaptionLbl@6275 : TextConst 'DAN=Total (RV) f�r periode;ENU=Total (LCY) Before Period';
      ExternalDocNoCaptionLbl@1021 : TextConst 'DAN=Eksternt bilagsnr.;ENU=External Doc. No.';

    PROCEDURE InitializeRequest@1(NewPrintAmountsInLCY@1000 : Boolean;NewPrintOnlyOnePerPage@1001 : Boolean;NewExcludeBalanceOnly@1002 : Boolean);
    BEGIN
      PrintAmountsInLCY := NewPrintAmountsInLCY;
      PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
      ExcludeBalanceOnly := NewExcludeBalanceOnly;
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
      <rd:DataSourceID>87c53af1-fc5f-41ac-b1d0-82930778f46c</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="VendDatetFilterPeriod">
          <DataField>VendDatetFilterPeriod</DataField>
        </Field>
        <Field Name="CompanyName">
          <DataField>CompanyName</DataField>
        </Field>
        <Field Name="VendorTblCapVendFltr">
          <DataField>VendorTblCapVendFltr</DataField>
        </Field>
        <Field Name="VendFilter">
          <DataField>VendFilter</DataField>
        </Field>
        <Field Name="PageGroupNo">
          <DataField>PageGroupNo</DataField>
        </Field>
        <Field Name="PrintAmountsInLCY">
          <DataField>PrintAmountsInLCY</DataField>
        </Field>
        <Field Name="ExcludeBalanceOnly">
          <DataField>ExcludeBalanceOnly</DataField>
        </Field>
        <Field Name="PrintOnlyOnePerPage">
          <DataField>PrintOnlyOnePerPage</DataField>
        </Field>
        <Field Name="AmountCaption">
          <DataField>AmountCaption</DataField>
        </Field>
        <Field Name="RemainingAmtCaption">
          <DataField>RemainingAmtCaption</DataField>
        </Field>
        <Field Name="No_Vendor">
          <DataField>No_Vendor</DataField>
        </Field>
        <Field Name="Name_Vendor">
          <DataField>Name_Vendor</DataField>
        </Field>
        <Field Name="PhoneNo_Vendor">
          <DataField>PhoneNo_Vendor</DataField>
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
        <Field Name="VendBalanceLCY">
          <DataField>VendBalanceLCY</DataField>
        </Field>
        <Field Name="VendBalanceLCYFormat">
          <DataField>VendBalanceLCYFormat</DataField>
        </Field>
        <Field Name="StrtBalLCYStartBalAdjLCY">
          <DataField>StrtBalLCYStartBalAdjLCY</DataField>
        </Field>
        <Field Name="StrtBalLCYStartBalAdjLCYFormat">
          <DataField>StrtBalLCYStartBalAdjLCYFormat</DataField>
        </Field>
        <Field Name="VendDetailTrialBalCap">
          <DataField>VendDetailTrialBalCap</DataField>
        </Field>
        <Field Name="PageCaption">
          <DataField>PageCaption</DataField>
        </Field>
        <Field Name="AllamountsareinLCYCaption">
          <DataField>AllamountsareinLCYCaption</DataField>
        </Field>
        <Field Name="ReportIncludesvendorshavebalanceCaption">
          <DataField>ReportIncludesvendorshavebalanceCaption</DataField>
        </Field>
        <Field Name="PostingDateCaption">
          <DataField>PostingDateCaption</DataField>
        </Field>
        <Field Name="BalanceLCYCaption">
          <DataField>BalanceLCYCaption</DataField>
        </Field>
        <Field Name="DueDateCaption">
          <DataField>DueDateCaption</DataField>
        </Field>
        <Field Name="AdjofOpeningBalanceCaption">
          <DataField>AdjofOpeningBalanceCaption</DataField>
        </Field>
        <Field Name="TotalLCYCaption">
          <DataField>TotalLCYCaption</DataField>
        </Field>
        <Field Name="TotalAdjofOpenBalCaption">
          <DataField>TotalAdjofOpenBalCaption</DataField>
        </Field>
        <Field Name="TotalLCYBeforePeriodCaption">
          <DataField>TotalLCYBeforePeriodCaption</DataField>
        </Field>
        <Field Name="ExternalDocNoCaption">
          <DataField>ExternalDocNoCaption</DataField>
        </Field>
        <Field Name="PostingDate_VendLedgEntry">
          <DataField>PostingDate_VendLedgEntry</DataField>
        </Field>
        <Field Name="DocType_VendLedgEntry">
          <DataField>DocType_VendLedgEntry</DataField>
        </Field>
        <Field Name="DocNo_VendLedgerEntry">
          <DataField>DocNo_VendLedgerEntry</DataField>
        </Field>
        <Field Name="ExtDocNo_VendLedgerEntry">
          <DataField>ExtDocNo_VendLedgerEntry</DataField>
        </Field>
        <Field Name="Desc_VendLedgerEntry">
          <DataField>Desc_VendLedgerEntry</DataField>
        </Field>
        <Field Name="VendAmount">
          <DataField>VendAmount</DataField>
        </Field>
        <Field Name="VendAmountFormat">
          <DataField>VendAmountFormat</DataField>
        </Field>
        <Field Name="VendBalLCY2">
          <DataField>VendBalLCY2</DataField>
        </Field>
        <Field Name="VendBalLCY2Format">
          <DataField>VendBalLCY2Format</DataField>
        </Field>
        <Field Name="VendRemainAmount">
          <DataField>VendRemainAmount</DataField>
        </Field>
        <Field Name="VendRemainAmountFormat">
          <DataField>VendRemainAmountFormat</DataField>
        </Field>
        <Field Name="VendEntryDueDate">
          <DataField>VendEntryDueDate</DataField>
        </Field>
        <Field Name="EntryNo_VendorLedgerEntry">
          <DataField>EntryNo_VendorLedgerEntry</DataField>
        </Field>
        <Field Name="VendCurrencyCode">
          <DataField>VendCurrencyCode</DataField>
        </Field>
        <Field Name="EntryTyp_DetVendLedgEntry">
          <DataField>EntryTyp_DetVendLedgEntry</DataField>
        </Field>
        <Field Name="Correction">
          <DataField>Correction</DataField>
        </Field>
        <Field Name="CorrectionFormat">
          <DataField>CorrectionFormat</DataField>
        </Field>
        <Field Name="Entry_DetVendLedgEntry2">
          <DataField>Entry_DetVendLedgEntry2</DataField>
        </Field>
        <Field Name="VendBalanceLCY3">
          <DataField>VendBalanceLCY3</DataField>
        </Field>
        <Field Name="VendBalanceLCY3Format">
          <DataField>VendBalanceLCY3Format</DataField>
        </Field>
        <Field Name="ApplicationRounding">
          <DataField>ApplicationRounding</DataField>
        </Field>
        <Field Name="ApplicationRoundingFormat">
          <DataField>ApplicationRoundingFormat</DataField>
        </Field>
        <Field Name="VendBalanceLCY4">
          <DataField>VendBalanceLCY4</DataField>
        </Field>
        <Field Name="VendBalanceLCY4Format">
          <DataField>VendBalanceLCY4Format</DataField>
        </Field>
        <Field Name="StartBalAdjLCY1">
          <DataField>StartBalAdjLCY1</DataField>
        </Field>
        <Field Name="StartBalAdjLCY1Format">
          <DataField>StartBalAdjLCY1Format</DataField>
        </Field>
        <Field Name="StartBalanceLCY1">
          <DataField>StartBalanceLCY1</DataField>
        </Field>
        <Field Name="StartBalanceLCY1Format">
          <DataField>StartBalanceLCY1Format</DataField>
        </Field>
        <Field Name="VendBalStrtBalStrtBalAdj">
          <DataField>VendBalStrtBalStrtBalAdj</DataField>
        </Field>
        <Field Name="VendBalStrtBalStrtBalAdjFormat">
          <DataField>VendBalStrtBalStrtBalAdjFormat</DataField>
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
          <Tablix Name="tblVendor">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>0.60991in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.72592in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.87229in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.76435in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.4185in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.92726in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.92726in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.929in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.6215in</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>0.36063in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VendLedEntryPostDateCap">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!PostingDateCaption.Value)</Value>
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
                          <ZIndex>207</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="VendLedEntryDocTypeCap">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocType_VendLedgEntryCaption.Value</Value>
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
                          <ZIndex>206</ZIndex>
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
                        <Textbox Name="DocNo_VendLedgerEntryCap">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!DocNo_VendLedgerEntryCaption.Value + "/" + "&lt;br&gt;" + "&lt;i&gt;" + Fields!ExternalDocNoCaption.Value + "&lt;/i&gt;"</Value>
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
                          <ZIndex>205</ZIndex>
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
                        <Textbox Name="Desc_VendLedgerEntryCap">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!Desc_VendLedgerEntryCaption.Value</Value>
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
                          <ZIndex>204</ZIndex>
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
                        <Textbox Name="TextBox136">
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
                          <ZIndex>203</ZIndex>
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
                                  <Value>=First(Fields!AmountCaption.Value)</Value>
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
                          <ZIndex>202</ZIndex>
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
                                  <Value>=Replace(First(Fields!RemainingAmtCaption.Value)," ",chr(10))</Value>
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
                          <ZIndex>201</ZIndex>
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
                        <Textbox Name="BalanceLCYCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Replace(First(Fields!BalanceLCYCaption.Value)," ",chr(10))</Value>
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
                          <ZIndex>200</ZIndex>
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
                        <Textbox Name="DueDateCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!DueDateCaption.Value)</Value>
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
                          <ZIndex>198</ZIndex>
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
                        <Textbox Name="VendLedrEntryEntryNoCap">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!EntryNo_VendorLedgerEntryCaption.Value</Value>
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
                          <ZIndex>197</ZIndex>
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
                  <Height>0.06944in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox149">
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox149</rd:DefaultName>
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
                        <ColSpan>10</ColSpan>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox13</rd:DefaultName>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>10</ColSpan>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox42">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!No_Vendor.Value</Value>
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
                          <rd:DefaultName>textbox42</rd:DefaultName>
                          <ZIndex>185</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                                  <Value>=Fields!Name_Vendor.Value</Value>
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
                          <rd:DefaultName>textbox43</rd:DefaultName>
                          <ZIndex>184</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox72">
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
                          <rd:DefaultName>textbox72</rd:DefaultName>
                          <ZIndex>176</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox73">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Parameters!PhoneNo_VendorCaption.Value</Value>
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
                          <rd:DefaultName>textbox73</rd:DefaultName>
                          <ZIndex>175</ZIndex>
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
                        <Textbox Name="textbox75">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PhoneNo_Vendor.value</Value>
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
                          <rd:DefaultName>textbox75</rd:DefaultName>
                          <ZIndex>174</ZIndex>
                          <Style>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                        <Textbox Name="textbox87">
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
                          <rd:DefaultName>textbox87</rd:DefaultName>
                          <ZIndex>166</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                        <Textbox Name="textbox94">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!StartBalanceLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!StartBalanceLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox94</rd:DefaultName>
                          <ZIndex>159</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox96</rd:DefaultName>
                          <ZIndex>157</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox102</rd:DefaultName>
                          <ZIndex>155</ZIndex>
                          <Style>
                            <BackgroundColor>#efefef</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox104">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!AdjofOpeningBalanceCaption.Value</Value>
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
                          <rd:DefaultName>textbox104</rd:DefaultName>
                          <ZIndex>153</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="textbox106">
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
                          <rd:DefaultName>textbox106</rd:DefaultName>
                          <ZIndex>152</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Fields!StartBalAdjLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!StartBalAdjLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox107</rd:DefaultName>
                          <ZIndex>151</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                          <rd:DefaultName>textbox108</rd:DefaultName>
                          <ZIndex>150</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Fields!StrtBalLCYStartBalAdjLCY.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!StrtBalLCYStartBalAdjLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox109</rd:DefaultName>
                          <ZIndex>149</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox111">
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
                          <rd:DefaultName>textbox111</rd:DefaultName>
                          <ZIndex>147</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox16">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PostingDate_VendLedgEntry.Value</Value>
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
                          <rd:DefaultName>textbox16</rd:DefaultName>
                          <ZIndex>145</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                                  <Value>=Fields!DocType_VendLedgEntry.Value</Value>
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
                          <rd:DefaultName>textbox17</rd:DefaultName>
                          <ZIndex>144</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox18">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!DocNo_VendLedgerEntry.Value + IIf(Fields!ExtDocNo_VendLedgerEntry.Value &lt;&gt; ""," /","") + "&lt;br&gt;" + "&lt;i&gt;" + Fields!ExtDocNo_VendLedgerEntry.Value + "&lt;/i&gt;"</Value>
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
                          <rd:DefaultName>textbox18</rd:DefaultName>
                          <ZIndex>143</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Fields!Desc_VendLedgerEntry.Value</Value>
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
                          <rd:DefaultName>textbox19</rd:DefaultName>
                          <ZIndex>142</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                                  <Value>=Fields!VendCurrencyCode.Value</Value>
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
                          <rd:DefaultName>textbox20</rd:DefaultName>
                          <ZIndex>141</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendAmount.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!VendAmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox21</rd:DefaultName>
                          <ZIndex>140</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Fields!VendRemainAmount.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!VendRemainAmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox22</rd:DefaultName>
                          <ZIndex>139</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox23">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendBalanceLCY.Value-Fields!Correction.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!VendBalanceLCYFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox23</rd:DefaultName>
                          <ZIndex>138</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox25">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VendEntryDueDate.Value</Value>
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
                          <rd:DefaultName>textbox25</rd:DefaultName>
                          <ZIndex>136</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                                  <Value>=Fields!EntryNo_VendorLedgerEntry.Value</Value>
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
                          <rd:DefaultName>textbox26</rd:DefaultName>
                          <ZIndex>135</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                        <Textbox Name="textbox44">
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
                          <rd:DefaultName>textbox44</rd:DefaultName>
                          <ZIndex>134</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Fields!DocType_VendLedgEntry.Value</Value>
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
                          <ZIndex>133</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                                  <Value>=Fields!DocNo_VendLedgerEntry.Value + IIf(Fields!ExtDocNo_VendLedgerEntry.Value &lt;&gt; ""," /","") + "&lt;br&gt;" + "&lt;i&gt;" + Fields!ExtDocNo_VendLedgerEntry.Value + "&lt;/i&gt;"</Value>
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
                          <ZIndex>132</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox105">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!EntryTyp_DetVendLedgEntry.Value</Value>
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
                          <rd:DefaultName>textbox105</rd:DefaultName>
                          <ZIndex>131</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                          <rd:DefaultName>textbox117</rd:DefaultName>
                          <ZIndex>130</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox118">
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox118</rd:DefaultName>
                          <ZIndex>129</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox119</rd:DefaultName>
                          <ZIndex>128</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                                  <Value>=Fields!VendBalLCY2.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!VendBalLCY2Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox120</rd:DefaultName>
                          <ZIndex>127</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox122</rd:DefaultName>
                          <ZIndex>125</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox128</rd:DefaultName>
                          <ZIndex>10</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                                  <Value>=Fields!DocType_VendLedgEntry.Value</Value>
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
                          <rd:DefaultName>textbox129</rd:DefaultName>
                          <ZIndex>9</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=Fields!DocNo_VendLedgerEntry.Value + IIf(Fields!ExtDocNo_VendLedgerEntry.Value &lt;&gt; ""," /","") + "&lt;br&gt;" + "&lt;i&gt;" + Fields!ExtDocNo_VendLedgerEntry.Value + "&lt;/i&gt;"</Value>
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
                          <ZIndex>8</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox130">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Entry_DetVendLedgEntry2.Value</Value>
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
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox132">
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
                          <rd:DefaultName>textbox132</rd:DefaultName>
                          <ZIndex>6</ZIndex>
                          <Style>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox133">
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox133</rd:DefaultName>
                          <ZIndex>5</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox134</rd:DefaultName>
                          <ZIndex>4</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
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
                                  <Value>=Fields!VendBalanceLCY3.Value</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!VendBalanceLCY3Format.Value</Format>
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
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox138">
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
                          <rd:DefaultName>textbox138</rd:DefaultName>
                          <ZIndex>1</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <BackgroundColor>#f0f0f0</BackgroundColor>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox6</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox2">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=LAST(Fields!Name_Vendor.Value)</Value>
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
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="Textbox3">
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
                          <rd:DefaultName>Textbox3</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
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
                        <Textbox Name="textbox256">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=LAST(Fields!VendBalanceLCY4.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>N</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox256</rd:DefaultName>
                          <ZIndex>14</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
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
                        <Textbox Name="textbox258">
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
                          <rd:DefaultName>textbox258</rd:DefaultName>
                          <ZIndex>12</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <BottomBorder>
                              <Style>None</Style>
                            </BottomBorder>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox15">
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
                          <rd:DefaultName>Textbox15</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox24">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=LAST(Fields!Name_Vendor.Value)</Value>
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
                          <rd:DefaultName>Textbox24</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
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
                        <Textbox Name="Textbox46">
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
                          <rd:DefaultName>Textbox46</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
                              <Style>Solid</Style>
                            </TopBorder>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingRight>5pt</PaddingRight>
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
                                  <Value>=LAST(Fields!VendBalStrtBalStrtBalAdj.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=LAST(Fields!VendBalStrtBalStrtBalAdjFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox41</rd:DefaultName>
                          <ZIndex>26</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
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
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox151</rd:DefaultName>
                          <ZIndex>25</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
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
                        <Textbox Name="textbox190">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=LAST(Fields!VendBalanceLCY4.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=LAST(Fields!VendBalanceLCY4Format.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox190</rd:DefaultName>
                          <ZIndex>24</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
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
                        <Textbox Name="textbox204">
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
                          <rd:DefaultName>textbox204</rd:DefaultName>
                          <ZIndex>22</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Color>#cccccc</Color>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
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
                          <rd:DefaultName>textbox39</rd:DefaultName>
                          <ZIndex>41</ZIndex>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>10</ColSpan>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox54">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalLCYBeforePeriodCaption.Value</Value>
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
                          <ZIndex>50</ZIndex>
                          <Style>
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
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
                        <Textbox Name="textbox69">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalanceLCY1.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Last(Fields!StartBalanceLCY1Format.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>45</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>43</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox85">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalAdjofOpenBalCaption.Value</Value>
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
                          <ZIndex>58</ZIndex>
                          <Style>
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
                        <Textbox Name="Textbox7">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=SUM(Fields!StartBalAdjLCY1.Value)</Value>
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
                          <rd:DefaultName>Textbox7</rd:DefaultName>
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
                        <Textbox Name="textbox99">
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
                          <ZIndex>55</ZIndex>
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
                        <Textbox Name="textbox100">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalAdjLCY1.Value)+Sum(Fields!StartBalanceLCY1.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Last(Fields!StartBalanceLCY1Format.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>54</ZIndex>
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
                        <Textbox Name="textbox113">
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
                          <ZIndex>52</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox124">
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
                          <rd:DefaultName>Textbox124</rd:DefaultName>
                          <Style>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox28</rd:DefaultName>
                          <Style>
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
                                    <FontWeight>Bold</FontWeight>
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
                                    <FontWeight>Bold</FontWeight>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox32</rd:DefaultName>
                          <Style>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox33</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox36">
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
                          <rd:DefaultName>Textbox36</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
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
                        <Textbox Name="Textbox155">
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
                          <rd:DefaultName>Textbox155</rd:DefaultName>
                          <Style>
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
                        <Textbox Name="Textbox48">
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
                          <rd:DefaultName>Textbox48</rd:DefaultName>
                          <Style>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
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
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox50">
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
                          <rd:DefaultName>Textbox50</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>Textbox51</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>Textbox52</rd:DefaultName>
                          <Style>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox56</rd:DefaultName>
                          <Style>
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
                        <Textbox Name="textbox115">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalLCYCaption.Value</Value>
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
                          <ZIndex>66</ZIndex>
                          <Style>
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
                        <Textbox Name="Textbox9">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VendBalStrtBalStrtBalAdj.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=LAST(Fields!VendBalStrtBalStrtBalAdjFormat.Value)</Format>
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>63</ZIndex>
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
                        <Textbox Name="textbox126">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VendBalanceLCY4.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Last(Fields!StartBalanceLCY1Format.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>62</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
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
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>2</ColSpan>
                      </CellContents>
                    </TablixCell>
                    <TablixCell />
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox142">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalLCYBeforePeriodCaption.Value</Value>
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
                          <ZIndex>74</ZIndex>
                          <Style>
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
                        <Textbox Name="Textbox137">
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
                          <rd:DefaultName>Textbox137</rd:DefaultName>
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
                        <Textbox Name="Textbox139">
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
                          <rd:DefaultName>Textbox139</rd:DefaultName>
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
                        <Textbox Name="textbox154">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalanceLCY1.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Last(Fields!StartBalanceLCY1Format.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>70</ZIndex>
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
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>68</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
                  <TablixCells>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox95</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                        <ColSpan>10</ColSpan>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
                  <TablixCells>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox80</rd:DefaultName>
                          <Style>
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
                        <Textbox Name="Textbox60">
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
                          <rd:DefaultName>Textbox60</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox61</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox62</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox63">
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
                          <rd:DefaultName>Textbox63</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox64">
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
                          <rd:DefaultName>Textbox64</rd:DefaultName>
                          <Style>
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
                        <Textbox Name="textbox158">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalLCYCaption.Value</Value>
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
                          <ZIndex>82</ZIndex>
                          <Style>
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
                        <Textbox Name="Textbox11">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VendBalStrtBalStrtBalAdj.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=LAST(Fields!VendBalStrtBalStrtBalAdjFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox11</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
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
                        <Textbox Name="textbox162">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VendBalanceLCY4.Value)-Sum(Fields!StartBalAdjLCY1.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!VendBalanceLCYFormat.Value)</Format>
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
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox164">
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
                          <ZIndex>76</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
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
                                  <Value>=Fields!TotalLCYBeforePeriodCaption.Value</Value>
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
                          <rd:DefaultName>textbox1</rd:DefaultName>
                          <ZIndex>91</ZIndex>
                          <Style>
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
                        <Textbox Name="Textbox67">
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
                          <rd:DefaultName>Textbox67</rd:DefaultName>
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
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox68</rd:DefaultName>
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
                        <Textbox Name="textbox8">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalanceLCY1.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Last(Fields!StartBalanceLCY1Format.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox8</rd:DefaultName>
                          <ZIndex>86</ZIndex>
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
                        <Textbox Name="textbox10">
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
                          <rd:DefaultName>textbox10</rd:DefaultName>
                          <ZIndex>84</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox147">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalAdjofOpenBalCaption.Value</Value>
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
                          <rd:DefaultName>textbox147</rd:DefaultName>
                          <ZIndex>99</ZIndex>
                          <Style>
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
                        <Textbox Name="Textbox12">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=SUM(Fields!StartBalAdjLCY1.Value)</Value>
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
                          <rd:DefaultName>Textbox12</rd:DefaultName>
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
                        <Textbox Name="textbox194">
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
                          <rd:DefaultName>textbox194</rd:DefaultName>
                          <ZIndex>96</ZIndex>
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
                        <Textbox Name="textbox195">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalAdjLCY1.Value)+Sum(Fields!StartBalanceLCY1.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Last(Fields!StartBalanceLCY1Format.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox195</rd:DefaultName>
                          <ZIndex>95</ZIndex>
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
                        <Textbox Name="textbox197">
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
                          <rd:DefaultName>textbox197</rd:DefaultName>
                          <ZIndex>93</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox65">
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
                          <rd:DefaultName>Textbox65</rd:DefaultName>
                          <Style>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox71</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox76</rd:DefaultName>
                          <Style>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox77</rd:DefaultName>
                          <Style>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox78</rd:DefaultName>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox79</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox81">
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
                          <rd:DefaultName>Textbox81</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox53</rd:DefaultName>
                          <Style>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox89</rd:DefaultName>
                          <Style>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox90</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox92</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
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
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox93</rd:DefaultName>
                          <Style>
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
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox97</rd:DefaultName>
                          <Style>
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
                        <Textbox Name="textbox203">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalLCYCaption.Value</Value>
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
                          <rd:DefaultName>textbox203</rd:DefaultName>
                          <ZIndex>107</ZIndex>
                          <Style>
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
                        <Textbox Name="Textbox29">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VendBalStrtBalStrtBalAdj.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=LAST(Fields!VendBalStrtBalStrtBalAdjFormat.Value)</Format>
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
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
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
                          <rd:DefaultName>textbox209</rd:DefaultName>
                          <ZIndex>104</ZIndex>
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
                        <Textbox Name="textbox131">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VendBalanceLCY4.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Last(Fields!StartBalanceLCY1Format.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>103</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox212">
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
                          <rd:DefaultName>textbox212</rd:DefaultName>
                          <ZIndex>101</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox218">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalLCYBeforePeriodCaption.Value</Value>
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
                          <rd:DefaultName>textbox218</rd:DefaultName>
                          <ZIndex>115</ZIndex>
                          <Style>
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
                        <Textbox Name="Textbox88">
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
                          <rd:DefaultName>Textbox88</rd:DefaultName>
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox98</rd:DefaultName>
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
                        <Textbox Name="textbox225">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!StartBalanceLCY1.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <Format>=Fields!StartBalanceLCY1Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox225</rd:DefaultName>
                          <ZIndex>111</ZIndex>
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
                        <Textbox Name="textbox227">
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
                          <rd:DefaultName>textbox227</rd:DefaultName>
                          <ZIndex>109</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.06944in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox34">
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
                          <rd:DefaultName>Textbox34</rd:DefaultName>
                          <Style>
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
                        <Textbox Name="Textbox110">
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
                          <rd:DefaultName>Textbox110</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox112">
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
                          <rd:DefaultName>Textbox112</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox114">
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
                          <rd:DefaultName>Textbox114</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox121">
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
                          <rd:DefaultName>Textbox121</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox123">
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
                          <rd:DefaultName>Textbox123</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox127">
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
                          <rd:DefaultName>Textbox127</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox5</rd:DefaultName>
                          <Style>
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
                        <Textbox Name="Textbox145">
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
                          <rd:DefaultName>Textbox145</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox146">
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
                          <rd:DefaultName>Textbox146</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox148">
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
                          <rd:DefaultName>Textbox148</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox150">
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
                          <rd:DefaultName>Textbox150</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <TopBorder>
                              <Style>Solid</Style>
                            </TopBorder>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox153">
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
                          <rd:DefaultName>Textbox153</rd:DefaultName>
                          <Style>
                            <PaddingRight>5pt</PaddingRight>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Textbox157">
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
                          <rd:DefaultName>Textbox157</rd:DefaultName>
                          <Style>
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
                        <Textbox Name="textbox233">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!TotalLCYCaption.Value</Value>
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
                          <rd:DefaultName>textbox233</rd:DefaultName>
                          <ZIndex>123</ZIndex>
                          <Style>
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
                        <Textbox Name="Textbox14">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VendBalStrtBalStrtBalAdj.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=LAST(Fields!VendBalStrtBalStrtBalAdjFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox14</rd:DefaultName>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox239</rd:DefaultName>
                          <ZIndex>120</ZIndex>
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
                        <Textbox Name="textbox240">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VendBalanceLCY4.Value)-Sum(Fields!StartBalAdjLCY1.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!VendBalanceLCYFormat.Value)</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox240</rd:DefaultName>
                          <ZIndex>119</ZIndex>
                          <Style>
                            <Border>
                              <Style>None</Style>
                            </Border>
                            <VerticalAlign>Top</VerticalAlign>
                            <PaddingLeft>5pt</PaddingLeft>
                            <PaddingRight>5pt</PaddingRight>
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
                          <rd:DefaultName>textbox242</rd:DefaultName>
                          <ZIndex>117</ZIndex>
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
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>After</KeepWithGroup>
                  <RepeatOnNewPage>true</RepeatOnNewPage>
                  <KeepTogether>true</KeepTogether>
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
                          <GroupExpression>=IIF(Fields!PrintOnlyOnePerPage.Value,Fields!PageGroupNo.Value,1)</GroupExpression>
                        </GroupExpressions>
                        <PageBreak>
                          <BreakLocation>Between</BreakLocation>
                        </PageBreak>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <Group Name="Table1_Group">
                            <GroupExpressions>
                              <GroupExpression>=Fields!No_Vendor.Value</GroupExpression>
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
                              <Visibility>
                                <Hidden>=IIF(Fields!StartBalAdjLCY.Value=0,TRUE,FALSE)</Hidden>
                              </Visibility>
                              <KeepWithGroup>After</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Group Name="Table1_Group3">
                                <GroupExpressions>
                                  <GroupExpression>=Fields!EntryNo_VendorLedgerEntry.Value</GroupExpression>
                                </GroupExpressions>
                              </Group>
                              <TablixMembers>
                                <TablixMember>
                                  <Visibility>
                                    <Hidden>=IIF(Fields!DocNo_VendLedgerEntry.Value="",TRUE,FALSE)</Hidden>
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
                                        <Hidden>=IIF(Fields!EntryTyp_DetVendLedgEntry.Value="",TRUE,FALSE)</Hidden>
                                      </Visibility>
                                    </TablixMember>
                                    <TablixMember>
                                      <Visibility>
                                        <Hidden>=IIF(Fields!Entry_DetVendLedgEntry2.Value="",TRUE,FALSE)</Hidden>
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
                              <Visibility>
                                <Hidden>=IIF(NOT Fields!PrintAmountsInLCY.Value,FALSE,TRUE)</Hidden>
                              </Visibility>
                              <KeepWithGroup>Before</KeepWithGroup>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF(Fields!PrintAmountsInLCY.Value,FALSE,TRUE)</Hidden>
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
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(not Fields!PrintOnlyOnePerPage.Value and not (SUM(Fields!StartBalAdjLCY1.Value)=0),FALSE,True)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(not Fields!PrintOnlyOnePerPage.Value and not (SUM(Fields!StartBalAdjLCY1.Value)=0),FALSE,True)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(not Fields!PrintOnlyOnePerPage.Value and not (SUM(Fields!StartBalAdjLCY1.Value)=0),FALSE,True)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(not Fields!PrintOnlyOnePerPage.Value and not (SUM(Fields!StartBalAdjLCY1.Value)=0),FALSE,True)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(not Fields!PrintOnlyOnePerPage.Value and not (SUM(Fields!StartBalAdjLCY1.Value)=0),FALSE,True)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(not Fields!PrintOnlyOnePerPage.Value and SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,TRUE)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(not Fields!PrintOnlyOnePerPage.Value and SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,TRUE)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(not Fields!PrintOnlyOnePerPage.Value and SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,TRUE)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                        </TablixMember>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(not Fields!PrintOnlyOnePerPage.Value and SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,TRUE)</Hidden>
                          </Visibility>
                          <KeepWithGroup>Before</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                      </TablixMembers>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Fields!PrintOnlyOnePerPage.Value and not SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,True)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Fields!PrintOnlyOnePerPage.Value and not SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,True)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Fields!PrintOnlyOnePerPage.Value and not SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,True)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Fields!PrintOnlyOnePerPage.Value and not SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,True)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Fields!PrintOnlyOnePerPage.Value and not SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,True)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Fields!PrintOnlyOnePerPage.Value and SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,TRUE)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Fields!PrintOnlyOnePerPage.Value and SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,TRUE)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Fields!PrintOnlyOnePerPage.Value and SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,TRUE)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                    </TablixMember>
                    <TablixMember>
                      <Visibility>
                        <Hidden>=IIF(Fields!PrintOnlyOnePerPage.Value and SUM(Fields!StartBalAdjLCY1.Value)=0,FALSE,TRUE)</Hidden>
                      </Visibility>
                      <KeepWithGroup>Before</KeepWithGroup>
                      <KeepTogether>true</KeepTogether>
                    </TablixMember>
                  </TablixMembers>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>30pt</Top>
            <Height>9.17217cm</Height>
            <Width>18.17782cm</Width>
            <Style />
          </Tablix>
          <Tablix Name="ReportFilters">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>7.15662in</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.13889in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="ReportIncludesvendorshavebalanceCaption">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!ReportIncludesvendorshavebalanceCaption.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
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
                              <Style />
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>Textbox35</rd:DefaultName>
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
                        <Textbox Name="VendorTblCapVendFltr">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!VendorTblCapVendFltr.Value)</Value>
                                  <Style>
                                    <FontFamily>Segoe UI</FontFamily>
                                    <FontSize>8pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style />
                            </Paragraph>
                          </Paragraphs>
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
              </TablixMembers>
            </TablixColumnHierarchy>
            <TablixRowHierarchy>
              <TablixMembers>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF(Fields!ExcludeBalanceOnly.Value=TRUE,TRUE,FALSE)</Hidden>
                  </Visibility>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF(Fields!VendFilter.value="",TRUE,FALSE)</Hidden>
                  </Visibility>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF(((Fields!ExcludeBalanceOnly.Value=TRUE) OR (Fields!VendFilter.value="")),TRUE,FALSE)</Hidden>
                  </Visibility>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <Height>0.41667in</Height>
            <Width>7.15662in</Width>
            <ZIndex>1</ZIndex>
            <Style>
              <Border>
                <Style>None</Style>
              </Border>
            </Style>
          </Tablix>
        </ReportItems>
        <Height>10.23051cm</Height>
        <Style />
      </Body>
      <Width>18.17782cm</Width>
      <Page>
        <PageHeader>
          <Height>2.46944cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="VendDetailTrialBalCap1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!VendDetailTrialBalCap.Value, "DataSet_Result")</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>14pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Left</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Height>20pt</Height>
              <Width>7.5cm</Width>
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
                      <Value>=First(Fields!CompanyName.Value, "DataSet_Result")</Value>
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
              <Top>30pt</Top>
              <Height>11pt</Height>
              <Width>7.5cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="SubStrNoxt000VendDtFltr1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!VendDatetFilterPeriod.Value, "DataSet_Result")</Value>
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
              <Top>20pt</Top>
              <Height>11pt</Height>
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
                      <Value>=Globals!ExecutionTime</Value>
                      <Style>
                        <FontFamily>Segoe UI</FontFamily>
                        <FontSize>8pt</FontSize>
                        <Format>D</Format>
                      </Style>
                    </TextRun>
                  </TextRuns>
                  <Style>
                    <TextAlign>Right</TextAlign>
                  </Style>
                </Paragraph>
              </Paragraphs>
              <Left>13.57787cm</Left>
              <Height>11pt</Height>
              <Width>4.44513cm</Width>
              <ZIndex>3</ZIndex>
              <Style>
                <Border />
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
              <Top>0.8128cm</Top>
              <Left>13.57787cm</Left>
              <Height>11pt</Height>
              <Width>4.44513cm</Width>
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
                      <Value>=First(Fields!PageCaption.Value, "DataSet_Result") &amp; " " &amp; Globals!PageNumber</Value>
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
              <Top>0.4064cm</Top>
              <Left>13.57787cm</Left>
              <Height>11pt</Height>
              <Width>4.44513cm</Width>
              <ZIndex>5</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="textbox152">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=First(Fields!AllamountsareinLCYCaption.Value, "DataSet_Result")</Value>
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
              <Top>40pt</Top>
              <Height>11pt</Height>
              <Width>7.5cm</Width>
              <ZIndex>6</ZIndex>
              <Visibility>
                <Hidden>=IIF(Fields!PrintAmountsInLCY.Value="FALSE",TRUE,FALSE)</Hidden>
              </Visibility>
              <DataElementOutput>NoOutput</DataElementOutput>
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
        <LeftMargin>1.76388cm</LeftMargin>
        <RightMargin>1.05834cm</RightMargin>
        <TopMargin>1.05834cm</TopMargin>
        <BottomMargin>1.48166cm</BottomMargin>
        <ColumnSpacing>1.27cm</ColumnSpacing>
        <Style />
      </Page>
    </ReportSection>
  </ReportSections>
  <ReportParameters>
    <ReportParameter Name="PhoneNo_VendorCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>PhoneNo_VendorCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>PhoneNo_VendorCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="DocType_VendLedgEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>DocType_VendLedgEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>DocType_VendLedgEntryCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="DocNo_VendLedgerEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>DocNo_VendLedgerEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>DocNo_VendLedgerEntryCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="Desc_VendLedgerEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>Desc_VendLedgerEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>Desc_VendLedgerEntryCaption</Prompt>
    </ReportParameter>
    <ReportParameter Name="EntryNo_VendorLedgerEntryCaption">
      <DataType>String</DataType>
      <DefaultValue>
        <Values>
          <Value>EntryNo_VendorLedgerEntryCaption</Value>
        </Values>
      </DefaultValue>
      <Prompt>EntryNo_VendorLedgerEntryCaption</Prompt>
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
          <ParameterName>PhoneNo_VendorCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>1</RowIndex>
          <ParameterName>DocType_VendLedgEntryCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>2</RowIndex>
          <ParameterName>DocNo_VendLedgerEntryCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>3</RowIndex>
          <ParameterName>Desc_VendLedgerEntryCaption</ParameterName>
        </CellDefinition>
        <CellDefinition>
          <ColumnIndex>0</ColumnIndex>
          <RowIndex>4</RowIndex>
          <ParameterName>EntryNo_VendorLedgerEntryCaption</ParameterName>
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
  <rd:ReportID>d39b4e5f-097d-4c38-9c75-1c16b28f2dac</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

