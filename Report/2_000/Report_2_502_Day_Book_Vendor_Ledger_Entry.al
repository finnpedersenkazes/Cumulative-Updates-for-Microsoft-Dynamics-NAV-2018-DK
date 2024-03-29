OBJECT Report 2502 Day Book Vendor Ledger Entry
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kreditorpost i momsdagbog;
               ENU=Day Book Vendor Ledger Entry];
    OnPreReport=BEGIN
                  VendLedgFilter := ReqVendLedgEntry.GETFILTERS;
                  GLSetup.GET;
                END;

  }
  DATASET
  {
    { 7249;    ;DataItem;ReqVendLedgEntry    ;
               DataItemTable=Table25;
               DataItemTableView=SORTING(Document Type,Vendor No.,Posting Date,Currency Code);
               OnPreDataItem=BEGIN
                               CurrReport.BREAK;
                             END;

               ReqFilterFields=Document Type,Vendor No.,Posting Date,Currency Code }

    { 9857;    ;DataItem;                    ;
               DataItemTable=Table2000000007;
               DataItemTableView=SORTING(Period Type,Period Start)
                                 WHERE(Period Type=CONST(Date));
               OnPreDataItem=VAR
                               PostingDateStart@1000 : Date;
                               PostingDateEnd@1001 : Date;
                             BEGIN
                               CurrReport.CREATETOTALS("Vendor Ledger Entry"."Amount (LCY)",VATAmount,PmtDiscRcd,VATBase,ActualAmount);
                               ReqVendLedgEntry.COPYFILTER("Posting Date","Period Start");

                               IF ReqVendLedgEntry.GETFILTER("Posting Date") = '' THEN
                                 ERROR(MissingDateRangeFilterErr);

                               PostingDateStart := ReqVendLedgEntry.GETRANGEMIN("Posting Date");
                               PostingDateEnd := CALCDATE('<+1Y>',PostingDateStart);

                               IF ReqVendLedgEntry.GETRANGEMAX("Posting Date") > PostingDateEnd THEN
                                 ERROR(MaxPostingDateErr);
                             END;

               OnAfterGetRecord=BEGIN
                                  AmountLCY2 := 0;
                                  AmountLCY3 := 0;
                                  PmtDiscRcd2 := 0;
                                  PmtDiscRcd3 := 0;
                                END;
                                 }

    { 6   ;1   ;Column  ;USERID              ;
               SourceExpr=USERID }

    { 4   ;1   ;Column  ;CurrReport_PAGENO   ;
               SourceExpr=CurrReport.PAGENO }

    { 2   ;1   ;Column  ;FORMAT_TODAY_0_4_   ;
               SourceExpr=FORMAT(TODAY,0,4) }

    { 3   ;1   ;Column  ;COMPANYNAME         ;
               SourceExpr=COMPANYPROPERTY.DISPLAYNAME }

    { 9   ;1   ;Column  ;All_amounts_are_in___GLSetup__LCY_Code_;
               SourceExpr='All amounts are in ' + GLSetup."LCY Code" }

    { 7   ;1   ;Column  ;Vendor_Ledger_Entry__TABLENAME__________VendLedgFilter;
               SourceExpr="Vendor Ledger Entry".TABLENAME + ': ' + VendLedgFilter }

    { 1040;1   ;Column  ;VendLedgFilter      ;
               SourceExpr=VendLedgFilter }

    { 1041;1   ;Column  ;PrintCLDetails      ;
               SourceExpr=PrintCLDetails }

    { 36  ;1   ;Column  ;Total_for______Vendor_Ledger_Entry__TABLENAME__________VendLedgFilter;
               SourceExpr='Total for ' + "Vendor Ledger Entry".TABLENAME + ': ' + VendLedgFilter }

    { 63  ;1   ;Column  ;Vendor_Ledger_Entry___Amount__LCY__;
               SourceExpr="Vendor Ledger Entry"."Amount (LCY)";
               AutoFormatType=1 }

    { 64  ;1   ;Column  ;PmtDiscRcd          ;
               SourceExpr=PmtDiscRcd;
               AutoFormatType=1 }

    { 65  ;1   ;Column  ;ActualAmount        ;
               SourceExpr=ActualAmount;
               AutoFormatType=1 }

    { 66  ;1   ;Column  ;VATBase             ;
               SourceExpr=VATBase;
               AutoFormatType=1 }

    { 67  ;1   ;Column  ;VATAmount           ;
               SourceExpr=VATAmount;
               AutoFormatType=1 }

    { 1555;1   ;Column  ;PmtDiscRcd4         ;
               SourceExpr=PmtDiscRcd4 }

    { 1556;1   ;Column  ;AmountLCY4          ;
               SourceExpr=AmountLCY4 }

    { 1557;1   ;Column  ;PmtDiscRcd3         ;
               SourceExpr=PmtDiscRcd3 }

    { 1558;1   ;Column  ;AmountLCY3          ;
               SourceExpr=AmountLCY3 }

    { 1559;1   ;Column  ;Date_Period_Type    ;
               SourceExpr="Period Type" }

    { 1560;1   ;Column  ;Date_Period_Start   ;
               SourceExpr="Period Start" }

    { 5   ;1   ;Column  ;CurrReport_PAGENOCaption;
               SourceExpr=CurrReport_PAGENOCaptionLbl }

    { 1   ;1   ;Column  ;Day_Book_Vendor_Ledger_EntryCaption;
               SourceExpr=Day_Book_Vendor_Ledger_EntryCaptionLbl }

    { 52  ;1   ;Column  ;VATAmount_Control23Caption;
               SourceExpr=VATAmount_Control23CaptionLbl }

    { 53  ;1   ;Column  ;PmtDiscRcd_Control32Caption;
               SourceExpr=PmtDiscRcd_Control32CaptionLbl }

    { 55  ;1   ;Column  ;Vendor_Ledger_Entry__Amount__LCY__Caption;
               SourceExpr=Vendor_Ledger_Entry__Amount__LCY__CaptionLbl }

    { 13  ;1   ;Column  ;ActualAmount_Control35Caption;
               SourceExpr=ActualAmount_Control35CaptionLbl }

    { 39  ;1   ;Column  ;VATBase_Control26Caption;
               SourceExpr=VATBase_Control26CaptionLbl }

    { 24  ;1   ;Column  ;VATAmount_Control23Caption_Control24;
               SourceExpr=VATAmount_Control23Caption_Control24Lbl }

    { 33  ;1   ;Column  ;PmtDiscRcd_Control32Caption_Control33;
               SourceExpr=PmtDiscRcd_Control32Caption_Control33Lbl }

    { 27  ;1   ;Column  ;VATBase_Control26Caption_Control27;
               SourceExpr=VATBase_Control26Caption_Control27Lbl }

    { 30  ;1   ;Column  ;Vendor_Ledger_Entry__Amount__LCY__Caption_Control30;
               SourceExpr=Vendor_Ledger_Entry__Amount__LCY__Caption_Control30Lbl }

    { 21  ;1   ;Column  ;Vendor_NameCaption  ;
               SourceExpr=Vendor_NameCaptionLbl }

    { 12  ;1   ;Column  ;Vendor_Ledger_Entry__Vendor_No__Caption;
               SourceExpr=Vendor_Ledger_Entry__Vendor_No__CaptionLbl }

    { 18  ;1   ;Column  ;Vendor_Ledger_Entry__External_Document_No__Caption;
               SourceExpr="Vendor Ledger Entry".FIELDCAPTION("External Document No.") }

    { 15  ;1   ;Column  ;Vendor_Ledger_Entry__Document_No__Caption;
               SourceExpr="Vendor Ledger Entry".FIELDCAPTION("Document No.") }

    { 54  ;1   ;Column  ;ActualAmount_Control35Caption_Control54;
               SourceExpr=ActualAmount_Control35Caption_Control54Lbl }

    { 4114;1   ;DataItem;                    ;
               DataItemTable=Table25;
               DataItemTableView=SORTING(Document Type,Vendor No.,Posting Date,Currency Code);
               OnPreDataItem=BEGIN
                               CurrReport.CREATETOTALS("Amount (LCY)",VATAmount,PmtDiscRcd,VATBase,ActualAmount);
                               COPYFILTERS(ReqVendLedgEntry);
                               SETRANGE("Posting Date",Date."Period Start");
                             END;

               OnAfterGetRecord=BEGIN
                                  SecondStep := TRUE;
                                  IF "Document Type" <> PreviousVendorLedgerEntry."Document Type" THEN BEGIN
                                    AmountLCY2 := 0;
                                    PmtDiscRcd2 := 0;
                                  END;
                                  AmountLCY2 := AmountLCY2 + "Amount (LCY)";
                                  AmountLCY3 := AmountLCY3 + "Amount (LCY)";
                                  AmountLCY4 := AmountLCY4 + "Amount (LCY)";
                                  PmtDiscRcd2 := PmtDiscRcd2 + PmtDiscRcd;
                                  PmtDiscRcd3 := PmtDiscRcd3 + PmtDiscRcd;
                                  PmtDiscRcd4 := PmtDiscRcd4 + PmtDiscRcd;
                                  PreviousVendorLedgerEntry := "Vendor Ledger Entry";

                                  IF "Vendor No." <> Vendor."No." THEN
                                    IF NOT Vendor.GET("Vendor No.") THEN
                                      Vendor.INIT;

                                  VATAmount := 0;
                                  VATBase := 0;
                                  VATEntry.SETCURRENTKEY("Transaction No.");
                                  VATEntry.SETRANGE("Transaction No.","Transaction No.");
                                  IF VATEntry.FIND('-') THEN
                                    REPEAT
                                      VATAmount := VATAmount - VATEntry.Amount;
                                      VATBase := VATBase - VATEntry.Base;
                                    UNTIL VATEntry.NEXT = 0;

                                  PmtDiscRcd := 0;
                                  VendLedgEntry.SETCURRENTKEY("Closed by Entry No.");
                                  VendLedgEntry.SETRANGE("Closed by Entry No.","Entry No.");
                                  IF VendLedgEntry.FIND('-') THEN
                                    REPEAT
                                      PmtDiscRcd := PmtDiscRcd - VendLedgEntry."Pmt. Disc. Rcd.(LCY)"
                                    UNTIL VendLedgEntry.NEXT = 0;

                                  ActualAmount := "Amount (LCY)" - PmtDiscRcd;
                                END;
                                 }

    { 10  ;2   ;Column  ;Vendor_Ledger_Entry__FIELDNAME__Posting_Date__________FORMAT_Date__Period_Start__0_4_;
               SourceExpr=FIELDNAME("Posting Date") + ' ' + FORMAT(Date."Period Start",0,4) }

    { 8   ;2   ;Column  ;FIELDNAME__Document_Type___________FORMAT___Document_Type__;
               SourceExpr=FIELDNAME("Document Type") + ' ' + FORMAT("Document Type") }

    { 14  ;2   ;Column  ;Vendor_Ledger_Entry__Document_No__;
               SourceExpr="Document No." }

    { 17  ;2   ;Column  ;Vendor_Ledger_Entry__External_Document_No__;
               SourceExpr="External Document No." }

    { 23  ;2   ;Column  ;VATAmount_Control23 ;
               SourceExpr=VATAmount;
               AutoFormatType=1 }

    { 29  ;2   ;Column  ;Vendor_Ledger_Entry__Amount__LCY__;
               SourceExpr="Amount (LCY)";
               AutoFormatType=1 }

    { 32  ;2   ;Column  ;PmtDiscRcd_Control32;
               SourceExpr=PmtDiscRcd;
               AutoFormatType=1 }

    { 20  ;2   ;Column  ;Vendor_Name         ;
               SourceExpr=Vendor.Name }

    { 11  ;2   ;Column  ;Vendor_Ledger_Entry__Vendor_No__;
               SourceExpr="Vendor No." }

    { 26  ;2   ;Column  ;VATBase_Control26   ;
               SourceExpr=VATBase;
               AutoFormatType=1 }

    { 35  ;2   ;Column  ;ActualAmount_Control35;
               SourceExpr=ActualAmount;
               AutoFormatType=1 }

    { 1043;2   ;Column  ;VendorLedgerEntry___EntryNo__;
               SourceExpr="Entry No." }

    { 31  ;2   ;Column  ;Total_for___FIELDNAME__Document_Type_________FORMAT__Document_Type__;
               SourceExpr='Total for ' + FIELDNAME("Document Type") + ' ' + FORMAT("Document Type") }

    { 46  ;2   ;Column  ;Vendor_Ledger_Entry__Amount__LCY___Control46;
               SourceExpr="Amount (LCY)";
               AutoFormatType=1 }

    { 47  ;2   ;Column  ;PmtDiscRcd_Control47;
               SourceExpr=PmtDiscRcd;
               AutoFormatType=1 }

    { 48  ;2   ;Column  ;ActualAmount_Control48;
               SourceExpr=ActualAmount;
               AutoFormatType=1 }

    { 49  ;2   ;Column  ;VATBase_Control49   ;
               SourceExpr=VATBase;
               AutoFormatType=1 }

    { 50  ;2   ;Column  ;VATAmount_Control50 ;
               SourceExpr=VATAmount;
               AutoFormatType=1 }

    { 1047;2   ;Column  ;AmountLCY2          ;
               SourceExpr=AmountLCY2 }

    { 1049;2   ;Column  ;PmtDiscRcd2         ;
               SourceExpr=PmtDiscRcd2 }

    { 28  ;2   ;Column  ;Total_for_____FORMAT_Date__Period_Start__0_4_;
               SourceExpr='Total for ' + FORMAT(Date."Period Start",0,4) }

    { 51  ;2   ;Column  ;Vendor_Ledger_Entry__Amount__LCY___Control51;
               SourceExpr="Amount (LCY)";
               AutoFormatType=1 }

    { 58  ;2   ;Column  ;PmtDiscRcd_Control58;
               SourceExpr=PmtDiscRcd;
               AutoFormatType=1 }

    { 59  ;2   ;Column  ;ActualAmount_Control59;
               SourceExpr=ActualAmount;
               AutoFormatType=1 }

    { 61  ;2   ;Column  ;VATBase_Control61   ;
               SourceExpr=VATBase;
               AutoFormatType=1 }

    { 62  ;2   ;Column  ;VATAmount_Control62 ;
               SourceExpr=VATAmount;
               AutoFormatType=1 }

    { 1170000006;2;Column;Vendor_Ledger_Entry_Document_Type;
               SourceExpr="Document Type" }

    { 7069;2   ;DataItem;                    ;
               DataItemTable=Table17;
               DataItemTableView=SORTING(Transaction No.);
               OnPreDataItem=VAR
                               DtldVendLedgEntry@1040 : Record 380;
                               TransactionNoFilter@1041 : Text[250];
                             BEGIN
                               IF NOT PrintGLDetails THEN
                                 CurrReport.BREAK
                                 ;
                               DtldVendLedgEntry.RESET;
                               DtldVendLedgEntry.SETRANGE("Vendor Ledger Entry No.","Vendor Ledger Entry"."Entry No.");
                               DtldVendLedgEntry.SETFILTER("Entry Type",'<>%1',DtldVendLedgEntry."Entry Type"::Application);
                               IF DtldVendLedgEntry.FINDSET THEN BEGIN
                                 TransactionNoFilter := FORMAT(DtldVendLedgEntry."Transaction No.");
                                 WHILE DtldVendLedgEntry.NEXT <> 0 DO
                                   TransactionNoFilter := TransactionNoFilter + '|' + FORMAT(DtldVendLedgEntry."Transaction No.");
                               END;
                               SETFILTER("Transaction No.",TransactionNoFilter);
                             END;

               OnAfterGetRecord=BEGIN
                                  IF "G/L Account No." <> GLAcc."No." THEN
                                    IF NOT GLAcc.GET("G/L Account No.") THEN
                                      GLAcc.INIT;

                                  AmountLCY1 := "Vendor Ledger Entry"."Amount (LCY)";
                                  PmtDiscRcd1 := PmtDiscRcd;
                                  IF SecondStep THEN BEGIN
                                    VatBase1 := 0;
                                    VatAmount1 := 0;
                                    SecondStep := FALSE;
                                  END ELSE BEGIN
                                    VatBase1 := VATBase;
                                    VatAmount1 := VATAmount;
                                  END;
                                END;
                                 }

    { 34  ;3   ;Column  ;G_L_Entry__G_L_Account_No__;
               SourceExpr="G/L Account No." }

    { 37  ;3   ;Column  ;G_L_Entry_Amount    ;
               SourceExpr=Amount;
               AutoFormatType=1 }

    { 40  ;3   ;Column  ;GLAcc_Name          ;
               SourceExpr=GLAcc.Name }

    { 1042;3   ;Column  ;G_L_Entry___Entry_No__;
               SourceExpr="Entry No." }

    { 1045;3   ;Column  ;GetPmtDiscRcd       ;
               SourceExpr=PmtDiscRcd1 }

    { 1046;3   ;Column  ;GetVatBase          ;
               SourceExpr=VatBase1 }

    { 1048;3   ;Column  ;GetVatAmount        ;
               SourceExpr=VatAmount1 }

    { 1044;3   ;Column  ;GetAmountLCY        ;
               SourceExpr=AmountLCY1 }

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
                  Name=PrintVendLedgerDetails;
                  CaptionML=[DAN=Udskriv kreditorpostdetaljer;
                             ENU=Print Vend. Ledger Details];
                  ToolTipML=[DAN=Angiver, om debitorpostdetaljer udskrives;
                             ENU=Specifies if Cust. Ledger Details is printed];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintCLDetails;
                  OnValidate=BEGIN
                               PrintCLDetailsOnAfterValidate;
                             END;
                              }

      { 1   ;2   ;Field     ;
                  Name=PrintGLEntryDetails;
                  CaptionML=[DAN=Udskriv finanspostdetaljer;
                             ENU=Print G/L Entry Details];
                  ToolTipML=[DAN=Angiver, om finanspostdetaljer udskrives;
                             ENU=Specifies if G/L Entry Details are printed];
                  ApplicationArea=#Basic,#Suite;
                  SourceExpr=PrintGLDetails;
                  OnValidate=BEGIN
                               PrintGLDetailsOnAfterValidate;
                             END;
                              }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      GLSetup@1040 : Record 98;
      GLAcc@1041 : Record 15;
      Vendor@1042 : Record 23;
      VendLedgEntry@1043 : Record 25;
      VATEntry@1044 : Record 254;
      PreviousVendorLedgerEntry@1900 : Record 25;
      VendLedgFilter@1045 : Text;
      PmtDiscRcd@1047 : Decimal;
      VATAmount@1048 : Decimal;
      ActualAmount@1049 : Decimal;
      VATBase@1050 : Decimal;
      AmountLCY1@1053 : Decimal;
      PmtDiscRcd1@1054 : Decimal;
      VatAmount1@1055 : Decimal;
      VatBase1@1056 : Decimal;
      PrintGLDetails@1051 : Boolean;
      PrintCLDetails@1052 : Boolean;
      SecondStep@1057 : Boolean;
      AmountLCY2@1058 : Decimal;
      PmtDiscRcd2@1059 : Decimal;
      AmountLCY3@1061 : Decimal;
      AmountLCY4@1062 : Decimal;
      PmtDiscRcd3@1063 : Decimal;
      PmtDiscRcd4@1064 : Decimal;
      CurrReport_PAGENOCaptionLbl@8565 : TextConst 'DAN=Side;ENU=Page';
      Day_Book_Vendor_Ledger_EntryCaptionLbl@1594 : TextConst 'DAN=Kreditorpost i momsdagbog;ENU=Day Book Vendor Ledger Entry';
      VATAmount_Control23CaptionLbl@3354 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      PmtDiscRcd_Control32CaptionLbl@2977 : TextConst 'DAN=Kontantrabat modtaget;ENU=Payment Discount Rcd.';
      Vendor_Ledger_Entry__Amount__LCY__CaptionLbl@1475 : TextConst 'DAN=Posteringsbel�b;ENU=Ledger Entry Amount';
      ActualAmount_Control35CaptionLbl@5042 : TextConst 'DAN=Faktisk bel�b;ENU=Actual Amount';
      VATBase_Control26CaptionLbl@4104 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      VATAmount_Control23Caption_Control24Lbl@7451 : TextConst 'DAN=Momsbel�b;ENU=VAT Amount';
      PmtDiscRcd_Control32Caption_Control33Lbl@3779 : TextConst 'DAN=Kontantrabat modtaget;ENU=Payment Discount Rcd.';
      VATBase_Control26Caption_Control27Lbl@9137 : TextConst 'DAN=Momsgrundlag;ENU=VAT Base';
      Vendor_Ledger_Entry__Amount__LCY__Caption_Control30Lbl@7729 : TextConst 'DAN=Posteringsbel�b;ENU=Ledger Entry Amount';
      Vendor_NameCaptionLbl@8151 : TextConst 'DAN=Navn;ENU=Name';
      Vendor_Ledger_Entry__Vendor_No__CaptionLbl@8279 : TextConst 'DAN=Kontonr.;ENU=Account No.';
      ActualAmount_Control35Caption_Control54Lbl@3527 : TextConst 'DAN=Faktisk bel�b;ENU=Actual Amount';
      MissingDateRangeFilterErr@1002 : TextConst 'DAN=Bogf�ringsdatofilteret skal angives.;ENU=Posting Date filter must be set.';
      MaxPostingDateErr@1000 : TextConst 'DAN=Bogf�ringsdatoperioden m� ikke v�re l�ngere end et �r.;ENU=Posting Date period must not be longer than 1 year.';

    LOCAL PROCEDURE PrintGLDetailsOnAfterValidate@19014577();
    BEGIN
      IF PrintGLDetails THEN
        PrintCLDetails := TRUE;
    END;

    LOCAL PROCEDURE PrintCLDetailsOnAfterValidate@19057318();
    BEGIN
      IF NOT PrintCLDetails THEN
        PrintGLDetails := FALSE;
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
      <rd:DataSourceID>5516365c-e08b-4654-ab0a-992d43d4b758</rd:DataSourceID>
    </DataSource>
  </DataSources>
  <DataSets>
    <DataSet Name="DataSet_Result">
      <Query>
        <DataSourceName>DataSource</DataSourceName>
        <CommandText />
      </Query>
      <Fields>
        <Field Name="USERID">
          <DataField>USERID</DataField>
        </Field>
        <Field Name="CurrReport_PAGENO">
          <DataField>CurrReport_PAGENO</DataField>
        </Field>
        <Field Name="FORMAT_TODAY_0_4_">
          <DataField>FORMAT_TODAY_0_4_</DataField>
        </Field>
        <Field Name="COMPANYNAME">
          <DataField>COMPANYNAME</DataField>
        </Field>
        <Field Name="All_amounts_are_in___GLSetup__LCY_Code_">
          <DataField>All_amounts_are_in___GLSetup__LCY_Code_</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__TABLENAME__________VendLedgFilter">
          <DataField>Vendor_Ledger_Entry__TABLENAME__________VendLedgFilter</DataField>
        </Field>
        <Field Name="VendLedgFilter">
          <DataField>VendLedgFilter</DataField>
        </Field>
        <Field Name="PrintCLDetails">
          <DataField>PrintCLDetails</DataField>
        </Field>
        <Field Name="Total_for______Vendor_Ledger_Entry__TABLENAME__________VendLedgFilter">
          <DataField>Total_for______Vendor_Ledger_Entry__TABLENAME__________VendLedgFilter</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry___Amount__LCY__">
          <DataField>Vendor_Ledger_Entry___Amount__LCY__</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry___Amount__LCY__Format">
          <DataField>Vendor_Ledger_Entry___Amount__LCY__Format</DataField>
        </Field>
        <Field Name="PmtDiscRcd">
          <DataField>PmtDiscRcd</DataField>
        </Field>
        <Field Name="PmtDiscRcdFormat">
          <DataField>PmtDiscRcdFormat</DataField>
        </Field>
        <Field Name="ActualAmount">
          <DataField>ActualAmount</DataField>
        </Field>
        <Field Name="ActualAmountFormat">
          <DataField>ActualAmountFormat</DataField>
        </Field>
        <Field Name="VATBase">
          <DataField>VATBase</DataField>
        </Field>
        <Field Name="VATBaseFormat">
          <DataField>VATBaseFormat</DataField>
        </Field>
        <Field Name="VATAmount">
          <DataField>VATAmount</DataField>
        </Field>
        <Field Name="VATAmountFormat">
          <DataField>VATAmountFormat</DataField>
        </Field>
        <Field Name="PmtDiscRcd4">
          <DataField>PmtDiscRcd4</DataField>
        </Field>
        <Field Name="PmtDiscRcd4Format">
          <DataField>PmtDiscRcd4Format</DataField>
        </Field>
        <Field Name="AmountLCY4">
          <DataField>AmountLCY4</DataField>
        </Field>
        <Field Name="AmountLCY4Format">
          <DataField>AmountLCY4Format</DataField>
        </Field>
        <Field Name="PmtDiscRcd3">
          <DataField>PmtDiscRcd3</DataField>
        </Field>
        <Field Name="PmtDiscRcd3Format">
          <DataField>PmtDiscRcd3Format</DataField>
        </Field>
        <Field Name="AmountLCY3">
          <DataField>AmountLCY3</DataField>
        </Field>
        <Field Name="AmountLCY3Format">
          <DataField>AmountLCY3Format</DataField>
        </Field>
        <Field Name="Date_Period_Type">
          <DataField>Date_Period_Type</DataField>
        </Field>
        <Field Name="Date_Period_Start">
          <DataField>Date_Period_Start</DataField>
        </Field>
        <Field Name="CurrReport_PAGENOCaption">
          <DataField>CurrReport_PAGENOCaption</DataField>
        </Field>
        <Field Name="Day_Book_Vendor_Ledger_EntryCaption">
          <DataField>Day_Book_Vendor_Ledger_EntryCaption</DataField>
        </Field>
        <Field Name="VATAmount_Control23Caption">
          <DataField>VATAmount_Control23Caption</DataField>
        </Field>
        <Field Name="PmtDiscRcd_Control32Caption">
          <DataField>PmtDiscRcd_Control32Caption</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Amount__LCY__Caption">
          <DataField>Vendor_Ledger_Entry__Amount__LCY__Caption</DataField>
        </Field>
        <Field Name="ActualAmount_Control35Caption">
          <DataField>ActualAmount_Control35Caption</DataField>
        </Field>
        <Field Name="VATBase_Control26Caption">
          <DataField>VATBase_Control26Caption</DataField>
        </Field>
        <Field Name="VATAmount_Control23Caption_Control24">
          <DataField>VATAmount_Control23Caption_Control24</DataField>
        </Field>
        <Field Name="PmtDiscRcd_Control32Caption_Control33">
          <DataField>PmtDiscRcd_Control32Caption_Control33</DataField>
        </Field>
        <Field Name="VATBase_Control26Caption_Control27">
          <DataField>VATBase_Control26Caption_Control27</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Amount__LCY__Caption_Control30">
          <DataField>Vendor_Ledger_Entry__Amount__LCY__Caption_Control30</DataField>
        </Field>
        <Field Name="Vendor_NameCaption">
          <DataField>Vendor_NameCaption</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Vendor_No__Caption">
          <DataField>Vendor_Ledger_Entry__Vendor_No__Caption</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__External_Document_No__Caption">
          <DataField>Vendor_Ledger_Entry__External_Document_No__Caption</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Document_No__Caption">
          <DataField>Vendor_Ledger_Entry__Document_No__Caption</DataField>
        </Field>
        <Field Name="ActualAmount_Control35Caption_Control54">
          <DataField>ActualAmount_Control35Caption_Control54</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__FIELDNAME__Posting_Date__________FORMAT_Date__Period_Start__0_4_">
          <DataField>Vendor_Ledger_Entry__FIELDNAME__Posting_Date__________FORMAT_Date__Period_Start__0_4_</DataField>
        </Field>
        <Field Name="FIELDNAME__Document_Type___________FORMAT___Document_Type__">
          <DataField>FIELDNAME__Document_Type___________FORMAT___Document_Type__</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Document_No__">
          <DataField>Vendor_Ledger_Entry__Document_No__</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__External_Document_No__">
          <DataField>Vendor_Ledger_Entry__External_Document_No__</DataField>
        </Field>
        <Field Name="VATAmount_Control23">
          <DataField>VATAmount_Control23</DataField>
        </Field>
        <Field Name="VATAmount_Control23Format">
          <DataField>VATAmount_Control23Format</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Amount__LCY__">
          <DataField>Vendor_Ledger_Entry__Amount__LCY__</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Amount__LCY__Format">
          <DataField>Vendor_Ledger_Entry__Amount__LCY__Format</DataField>
        </Field>
        <Field Name="PmtDiscRcd_Control32">
          <DataField>PmtDiscRcd_Control32</DataField>
        </Field>
        <Field Name="PmtDiscRcd_Control32Format">
          <DataField>PmtDiscRcd_Control32Format</DataField>
        </Field>
        <Field Name="Vendor_Name">
          <DataField>Vendor_Name</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Vendor_No__">
          <DataField>Vendor_Ledger_Entry__Vendor_No__</DataField>
        </Field>
        <Field Name="VATBase_Control26">
          <DataField>VATBase_Control26</DataField>
        </Field>
        <Field Name="VATBase_Control26Format">
          <DataField>VATBase_Control26Format</DataField>
        </Field>
        <Field Name="ActualAmount_Control35">
          <DataField>ActualAmount_Control35</DataField>
        </Field>
        <Field Name="ActualAmount_Control35Format">
          <DataField>ActualAmount_Control35Format</DataField>
        </Field>
        <Field Name="VendorLedgerEntry___EntryNo__">
          <DataField>VendorLedgerEntry___EntryNo__</DataField>
        </Field>
        <Field Name="Total_for___FIELDNAME__Document_Type_________FORMAT__Document_Type__">
          <DataField>Total_for___FIELDNAME__Document_Type_________FORMAT__Document_Type__</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Amount__LCY___Control46">
          <DataField>Vendor_Ledger_Entry__Amount__LCY___Control46</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Amount__LCY___Control46Format">
          <DataField>Vendor_Ledger_Entry__Amount__LCY___Control46Format</DataField>
        </Field>
        <Field Name="PmtDiscRcd_Control47">
          <DataField>PmtDiscRcd_Control47</DataField>
        </Field>
        <Field Name="PmtDiscRcd_Control47Format">
          <DataField>PmtDiscRcd_Control47Format</DataField>
        </Field>
        <Field Name="ActualAmount_Control48">
          <DataField>ActualAmount_Control48</DataField>
        </Field>
        <Field Name="ActualAmount_Control48Format">
          <DataField>ActualAmount_Control48Format</DataField>
        </Field>
        <Field Name="VATBase_Control49">
          <DataField>VATBase_Control49</DataField>
        </Field>
        <Field Name="VATBase_Control49Format">
          <DataField>VATBase_Control49Format</DataField>
        </Field>
        <Field Name="VATAmount_Control50">
          <DataField>VATAmount_Control50</DataField>
        </Field>
        <Field Name="VATAmount_Control50Format">
          <DataField>VATAmount_Control50Format</DataField>
        </Field>
        <Field Name="AmountLCY2">
          <DataField>AmountLCY2</DataField>
        </Field>
        <Field Name="AmountLCY2Format">
          <DataField>AmountLCY2Format</DataField>
        </Field>
        <Field Name="PmtDiscRcd2">
          <DataField>PmtDiscRcd2</DataField>
        </Field>
        <Field Name="PmtDiscRcd2Format">
          <DataField>PmtDiscRcd2Format</DataField>
        </Field>
        <Field Name="Total_for_____FORMAT_Date__Period_Start__0_4_">
          <DataField>Total_for_____FORMAT_Date__Period_Start__0_4_</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Amount__LCY___Control51">
          <DataField>Vendor_Ledger_Entry__Amount__LCY___Control51</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry__Amount__LCY___Control51Format">
          <DataField>Vendor_Ledger_Entry__Amount__LCY___Control51Format</DataField>
        </Field>
        <Field Name="PmtDiscRcd_Control58">
          <DataField>PmtDiscRcd_Control58</DataField>
        </Field>
        <Field Name="PmtDiscRcd_Control58Format">
          <DataField>PmtDiscRcd_Control58Format</DataField>
        </Field>
        <Field Name="ActualAmount_Control59">
          <DataField>ActualAmount_Control59</DataField>
        </Field>
        <Field Name="ActualAmount_Control59Format">
          <DataField>ActualAmount_Control59Format</DataField>
        </Field>
        <Field Name="VATBase_Control61">
          <DataField>VATBase_Control61</DataField>
        </Field>
        <Field Name="VATBase_Control61Format">
          <DataField>VATBase_Control61Format</DataField>
        </Field>
        <Field Name="VATAmount_Control62">
          <DataField>VATAmount_Control62</DataField>
        </Field>
        <Field Name="VATAmount_Control62Format">
          <DataField>VATAmount_Control62Format</DataField>
        </Field>
        <Field Name="Vendor_Ledger_Entry_Document_Type">
          <DataField>Vendor_Ledger_Entry_Document_Type</DataField>
        </Field>
        <Field Name="G_L_Entry__G_L_Account_No__">
          <DataField>G_L_Entry__G_L_Account_No__</DataField>
        </Field>
        <Field Name="G_L_Entry_Amount">
          <DataField>G_L_Entry_Amount</DataField>
        </Field>
        <Field Name="G_L_Entry_AmountFormat">
          <DataField>G_L_Entry_AmountFormat</DataField>
        </Field>
        <Field Name="GLAcc_Name">
          <DataField>GLAcc_Name</DataField>
        </Field>
        <Field Name="G_L_Entry___Entry_No__">
          <DataField>G_L_Entry___Entry_No__</DataField>
        </Field>
        <Field Name="GetPmtDiscRcd">
          <DataField>GetPmtDiscRcd</DataField>
        </Field>
        <Field Name="GetPmtDiscRcdFormat">
          <DataField>GetPmtDiscRcdFormat</DataField>
        </Field>
        <Field Name="GetVatBase">
          <DataField>GetVatBase</DataField>
        </Field>
        <Field Name="GetVatBaseFormat">
          <DataField>GetVatBaseFormat</DataField>
        </Field>
        <Field Name="GetVatAmount">
          <DataField>GetVatAmount</DataField>
        </Field>
        <Field Name="GetVatAmountFormat">
          <DataField>GetVatAmountFormat</DataField>
        </Field>
        <Field Name="GetAmountLCY">
          <DataField>GetAmountLCY</DataField>
        </Field>
        <Field Name="GetAmountLCYFormat">
          <DataField>GetAmountLCYFormat</DataField>
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
          <Tablix Name="table2">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>7.93651cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>7.93651cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.423cm</Height>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox10</rd:DefaultName>
                          <ZIndex>3</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox3">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Ledger_Entry__TABLENAME__________VendLedgFilter.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox3</rd:DefaultName>
                          <ZIndex>4</ZIndex>
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
                  <KeepWithGroup>Before</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
                <TablixMember>
                  <Visibility>
                    <Hidden>=IIF(Fields!VendLedgFilter.Value = "",True,False)</Hidden>
                  </Visibility>
                  <KeepWithGroup>Before</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <Height>0.846cm</Height>
            <Width>15.87302cm</Width>
            <ZIndex>1</ZIndex>
          </Tablix>
          <Tablix Name="Table1">
            <TablixBody>
              <TablixColumns>
                <TablixColumn>
                  <Width>1.575cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.5873cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.65cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>2.85714cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.95cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.95cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.95cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.95cm</Width>
                </TablixColumn>
                <TablixColumn>
                  <Width>1.875cm</Width>
                </TablixColumn>
              </TablixColumns>
              <TablixRows>
                <TablixRow>
                  <Height>0.03125in</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="COMPANYNAME">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!COMPANYNAME.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>102</ZIndex>
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
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="CurrReport_PAGENOCaption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!CurrReport_PAGENOCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>101</ZIndex>
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
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Day_Book_Vendor_Ledger_EntryCaption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Day_Book_Vendor_Ledger_EntryCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>100</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="PrintCLDetails">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!PrintCLDetails.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>99</ZIndex>
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TODAY">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!FORMAT_TODAY_0_4_.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Color>Red</Color>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>98</ZIndex>
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
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="AllAmountText">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!All_amounts_are_in___GLSetup__LCY_Code_.Value</Value>
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
                          <Visibility>
                            <Hidden>true</Hidden>
                          </Visibility>
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
                        <Textbox Name="textbox95">
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
                          <rd:DefaultName>textbox95</rd:DefaultName>
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
                        <Textbox Name="textbox96">
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
                          <rd:DefaultName>textbox96</rd:DefaultName>
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
                        <Textbox Name="textbox97">
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
                          <rd:DefaultName>textbox97</rd:DefaultName>
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
                  <Height>0.75cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox111">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Ledger_Entry__Document_No__Caption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>111</ZIndex>
                          <Visibility>
                            <Hidden>=IIF(Fields!PrintCLDetails.Value,False,True)</Hidden>
                          </Visibility>
                          <DataElementOutput>NoOutput</DataElementOutput>
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
                        <Textbox Name="TextBox112">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Ledger_Entry__External_Document_No__Caption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>110</ZIndex>
                          <Visibility>
                            <Hidden>=IIF(Fields!PrintCLDetails.Value,False,True)</Hidden>
                          </Visibility>
                          <DataElementOutput>NoOutput</DataElementOutput>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="TextBox113">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Ledger_Entry__Vendor_No__Caption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>109</ZIndex>
                          <Visibility>
                            <Hidden>=IIF(Fields!PrintCLDetails.Value,False,True)</Hidden>
                          </Visibility>
                          <DataElementOutput>NoOutput</DataElementOutput>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                                  <Value>=Fields!Vendor_NameCaption.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>108</ZIndex>
                          <Visibility>
                            <Hidden>=IIF(Fields!PrintCLDetails.Value,False,True)</Hidden>
                          </Visibility>
                          <DataElementOutput>NoOutput</DataElementOutput>
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
                        <Textbox Name="Vendor_Ledger_Entry__Amount__LCY__Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!Vendor_Ledger_Entry__Amount__LCY__Caption.Value)</Value>
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
                          <ZIndex>107</ZIndex>
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
                        <Textbox Name="PmtDiscRcd_Control32Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!PmtDiscRcd_Control32Caption.Value)</Value>
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
                          <ZIndex>106</ZIndex>
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
                        <Textbox Name="ActualAmount_Control35Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!ActualAmount_Control35Caption.Value)</Value>
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
                          <ZIndex>105</ZIndex>
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
                        <Textbox Name="VATBase_Control26Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!VATBase_Control26Caption.Value)</Value>
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
                          <ZIndex>104</ZIndex>
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
                        <Textbox Name="VATAmount_Control23Caption">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=First(Fields!VATAmount_Control23Caption.Value)</Value>
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
                          <ZIndex>103</ZIndex>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox1">
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
                          <rd:DefaultName>textbox1</rd:DefaultName>
                          <ZIndex>93</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="FIELDNAME__Document_Type___________FORMAT___Document_Type__">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Ledger_Entry__FIELDNAME__Posting_Date__________FORMAT_Date__Period_Start__0_4_.Value</Value>
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
                          <ZIndex>84</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
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
                        <Textbox Name="TextBox12">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>83</ZIndex>
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
                  </TablixCells>
                </TablixRow>
                <TablixRow>
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox24">
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
                          <rd:DefaultName>textbox24</rd:DefaultName>
                          <ZIndex>77</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>0.075cm</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox33">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!FIELDNAME__Document_Type___________FORMAT___Document_Type__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox33</rd:DefaultName>
                          <ZIndex>68</ZIndex>
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
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox37</rd:DefaultName>
                          <ZIndex>67</ZIndex>
                          <Style>
                            <PaddingLeft>2pt</PaddingLeft>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
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
                              <Style>
                                <TextAlign>Left</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>62</ZIndex>
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
                        <Textbox Name="Vendor_Ledger_Entry__External_Document_No__">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Ledger_Entry__External_Document_No__.Value</Value>
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
                          <ZIndex>61</ZIndex>
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
                        <Textbox Name="Vendor_Ledger_Entry__Vendor_No__">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Ledger_Entry__Vendor_No__.Value</Value>
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
                          <ZIndex>60</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>1pt</PaddingLeft>
                            <PaddingRight>0.075cm</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
                          </Style>
                        </Textbox>
                      </CellContents>
                    </TablixCell>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Vendor_Name">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Name.Value</Value>
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
                        <Textbox Name="Vendor_Ledger_Entry__Amount__LCY__">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Ledger_Entry__Amount__LCY__.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!Vendor_Ledger_Entry__Amount__LCY__Format.Value</Format>
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
                        <Textbox Name="PmtDiscRcd_Control32">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!PmtDiscRcd_Control32.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!PmtDiscRcd_Control32Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="ActualAmount_Control35">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!Vendor_Ledger_Entry__Amount__LCY__.Value - Fields!PmtDiscRcd_Control32.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!ActualAmount_Control35Format.Value</Format>
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
                        <Textbox Name="VATBase_Control26">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VATBase_Control26.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VATBase_Control26Format.Value</Format>
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
                        <Textbox Name="VATAmount_Control23">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!VATAmount_Control23.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VATAmount_Control23Format.Value</Format>
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
                  <Height>0.423cm</Height>
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
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox72</rd:DefaultName>
                          <ZIndex>8</ZIndex>
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
                        <Textbox Name="textbox74">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!G_L_Entry__G_L_Account_No__.Value</Value>
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
                          <rd:DefaultName>textbox74</rd:DefaultName>
                          <ZIndex>6</ZIndex>
                          <Style>
                            <PaddingLeft>1pt</PaddingLeft>
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
                                  <Value>=Fields!GLAcc_Name.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox75</rd:DefaultName>
                          <ZIndex>5</ZIndex>
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
                        <Textbox Name="textbox76">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Fields!G_L_Entry_Amount.Value</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!G_L_Entry_AmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox76</rd:DefaultName>
                          <ZIndex>4</ZIndex>
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox77</rd:DefaultName>
                          <ZIndex>3</ZIndex>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox63">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox63</rd:DefaultName>
                          <ZIndex>17</ZIndex>
                          <Style>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox51">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!Total_for___FIELDNAME__Document_Type_________FORMAT__Document_Type__.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox51</rd:DefaultName>
                          <ZIndex>23</ZIndex>
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
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox81">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!AmountLCY2.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!Vendor_Ledger_Entry__Amount__LCY___Control46Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                              <Style>
                                <TextAlign>Right</TextAlign>
                              </Style>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>22</ZIndex>
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
                        <Textbox Name="textbox89">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!PmtDiscRcd.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!PmtDiscRcd_Control47Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox89</rd:DefaultName>
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
                        <Textbox Name="textbox82">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!AmountLCY2.Value) - Sum(Fields!PmtDiscRcd.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!ActualAmount_Control48Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox82</rd:DefaultName>
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
                        <Textbox Name="textbox83">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VATBase_Control26.Value) - Sum(Fields!GetVatBase.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VATBase_Control49Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox83</rd:DefaultName>
                          <ZIndex>19</ZIndex>
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
                        <Textbox Name="textbox84">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VATAmount_Control23.Value) - Sum(Fields!GetVatAmount.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <Format>=Fields!VATAmount_Control50Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox84</rd:DefaultName>
                          <ZIndex>18</ZIndex>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
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
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox42</rd:DefaultName>
                          <ZIndex>32</ZIndex>
                          <Style>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="textbox34">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value />
                                  <Style />
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox34</rd:DefaultName>
                          <ZIndex>41</ZIndex>
                          <Style>
                            <VerticalAlign>Middle</VerticalAlign>
                            <PaddingLeft>2pt</PaddingLeft>
                            <PaddingRight>2pt</PaddingRight>
                            <PaddingTop>2pt</PaddingTop>
                            <PaddingBottom>2pt</PaddingBottom>
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
                  <Height>0.423cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Total_for___FIELDNAME__Document_Type_________FORMAT__Document_Type__">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!Total_for_____FORMAT_Date__Period_Start__0_4_.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>47</ZIndex>
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
                        <Textbox Name="textbox85">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!AmountLCY3.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!Vendor_Ledger_Entry__Amount__LCY___Control51Format.Value</Format>
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
                        <Textbox Name="textbox13">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!PmtDiscRcd.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!PmtDiscRcd_Control58Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
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
                        <Textbox Name="textbox56">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!AmountLCY3.Value) - Sum(Fields!PmtDiscRcd.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!ActualAmount_Control59Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox56</rd:DefaultName>
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
                        <Textbox Name="textbox57">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VATBase_Control26.Value) - Sum(Fields!GetVatBase.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!VATBase_Control61Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox57</rd:DefaultName>
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
                        <Textbox Name="textbox58">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VATAmount_Control23.Value) - Sum(Fields!GetVatAmount.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!VATAmount_Control62Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox58</rd:DefaultName>
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
                  <Height>1.11027cm</Height>
                  <TablixCells>
                    <TablixCell>
                      <CellContents>
                        <Textbox Name="Total_for______Vendor_Ledger_Entry__TABLENAME__________VendLedgFilter">
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!Total_for______Vendor_Ledger_Entry__TABLENAME__________VendLedgFilter.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>53</ZIndex>
                          <Style>
                            <VerticalAlign>Bottom</VerticalAlign>
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
                        <Textbox Name="textbox19">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!AmountLCY4.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=First(Fields!Vendor_Ledger_Entry__Amount__LCY___Control46Format.Value)</Format>
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
                        <Textbox Name="textbox59">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!PmtDiscRcd.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!PmtDiscRcd_Control32Format.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <ZIndex>51</ZIndex>
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
                        <Textbox Name="textbox86">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Last(Fields!AmountLCY4.Value) - Sum(Fields!PmtDiscRcd.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!PmtDiscRcdFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox86</rd:DefaultName>
                          <ZIndex>50</ZIndex>
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
                        <Textbox Name="textbox87">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VATBase_Control26.Value) - Sum(Fields!GetVatBase.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!VATBaseFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox87</rd:DefaultName>
                          <ZIndex>49</ZIndex>
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
                        <Textbox Name="textbox88">
                          <CanGrow>true</CanGrow>
                          <KeepTogether>true</KeepTogether>
                          <Paragraphs>
                            <Paragraph>
                              <TextRuns>
                                <TextRun>
                                  <Value>=Sum(Fields!VATAmount_Control23.Value) - Sum(Fields!GetVatAmount.Value)</Value>
                                  <Style>
                                    <FontSize>7pt</FontSize>
                                    <FontWeight>Bold</FontWeight>
                                    <Format>=Fields!VATAmountFormat.Value</Format>
                                  </Style>
                                </TextRun>
                              </TextRuns>
                            </Paragraph>
                          </Paragraphs>
                          <rd:DefaultName>textbox88</rd:DefaultName>
                          <ZIndex>48</ZIndex>
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
                  <Group Name="Table1_Group">
                    <GroupExpressions>
                      <GroupExpression>=Fields!Vendor_Ledger_Entry__FIELDNAME__Posting_Date__________FORMAT_Date__Period_Start__0_4_.Value</GroupExpression>
                    </GroupExpressions>
                    <Filters>
                      <Filter>
                        <FilterExpression>=Fields!Vendor_Ledger_Entry__FIELDNAME__Posting_Date__________FORMAT_Date__Period_Start__0_4_.Value</FilterExpression>
                        <Operator>GreaterThan</Operator>
                        <FilterValues>
                          <FilterValue />
                        </FilterValues>
                      </Filter>
                    </Filters>
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
                      <Group Name="Table1_Group2">
                        <GroupExpressions>
                          <GroupExpression>=Fields!Vendor_Ledger_Entry_Document_Type.Value</GroupExpression>
                        </GroupExpressions>
                      </Group>
                      <TablixMembers>
                        <TablixMember>
                          <Visibility>
                            <Hidden>=IIF(Fields!PrintCLDetails.Value,False,True)</Hidden>
                          </Visibility>
                          <KeepWithGroup>After</KeepWithGroup>
                          <KeepTogether>true</KeepTogether>
                        </TablixMember>
                        <TablixMember>
                          <Group Name="Table1_Group3">
                            <GroupExpressions>
                              <GroupExpression>=Fields!VendorLedgerEntry___EntryNo__.Value</GroupExpression>
                            </GroupExpressions>
                            <Filters>
                              <Filter>
                                <FilterExpression>=Fields!VendorLedgerEntry___EntryNo__.Value</FilterExpression>
                                <Operator>GreaterThan</Operator>
                                <FilterValues>
                                  <FilterValue>=0</FilterValue>
                                </FilterValues>
                              </Filter>
                            </Filters>
                          </Group>
                          <TablixMembers>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF(Fields!PrintCLDetails.Value,False,True)</Hidden>
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
                                    <Hidden>=IIF(Fields!G_L_Entry___Entry_No__.Value &gt; 0,False,True)</Hidden>
                                  </Visibility>
                                </TablixMember>
                              </TablixMembers>
                              <DataElementName>Detail_Collection</DataElementName>
                              <DataElementOutput>Output</DataElementOutput>
                              <KeepTogether>true</KeepTogether>
                            </TablixMember>
                            <TablixMember>
                              <Visibility>
                                <Hidden>=IIF(Fields!G_L_Entry___Entry_No__.Value &gt; 0,False,True)</Hidden>
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
                          <Visibility>
                            <Hidden>=IIF(Fields!PrintCLDetails.Value,False,True)</Hidden>
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
                  </TablixMembers>
                </TablixMember>
                <TablixMember>
                  <KeepWithGroup>Before</KeepWithGroup>
                  <KeepTogether>true</KeepTogether>
                </TablixMember>
              </TablixMembers>
            </TablixRowHierarchy>
            <DataSetName>DataSet_Result</DataSetName>
            <Top>0.846cm</Top>
            <Width>17.34444cm</Width>
          </Tablix>
        </ReportItems>
        <Height>7.43863cm</Height>
      </Body>
      <Width>18.15cm</Width>
      <Page>
        <PageHeader>
          <Height>2.5394cm</Height>
          <PrintOnFirstPage>true</PrintOnFirstPage>
          <PrintOnLastPage>true</PrintOnLastPage>
          <ReportItems>
            <Textbox Name="textbox16">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!AllAmountText.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <rd:DefaultName>textbox16</rd:DefaultName>
              <Top>0.83333in</Top>
              <Width>7.5cm</Width>
              <ZIndex>6</ZIndex>
              <Style>
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
                      <Value>=ReportItems!TODAY.Value</Value>
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
              <Left>13.96825cm</Left>
              <Height>0.423cm</Height>
              <ZIndex>3</ZIndex>
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
                      <Value>=ReportItems!COMPANYNAME.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
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
            <Textbox Name="CurrReport_PAGENOCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!CurrReport_PAGENOCaption.Value</Value>
                      <Style>
                        <FontSize>7pt</FontSize>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Top>0.423cm</Top>
              <Left>16.95cm</Left>
              <Height>0.423cm</Height>
              <Width>0.75cm</Width>
              <ZIndex>1</ZIndex>
              <Style>
                <VerticalAlign>Middle</VerticalAlign>
              </Style>
            </Textbox>
            <Textbox Name="Day_Book_Vendor_Ledger_EntryCaption1">
              <KeepTogether>true</KeepTogether>
              <Paragraphs>
                <Paragraph>
                  <TextRuns>
                    <TextRun>
                      <Value>=ReportItems!Day_Book_Vendor_Ledger_EntryCaption.Value</Value>
                      <Style>
                        <FontSize>8pt</FontSize>
                        <FontWeight>Bold</FontWeight>
                      </Style>
                    </TextRun>
                  </TextRuns>
                </Paragraph>
              </Paragraphs>
              <Height>0.423cm</Height>
              <Width>7.5cm</Width>
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
</Code>
  <Language>=User!Language</Language>
  <ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
  <rd:ReportUnitType>Invalid</rd:ReportUnitType>
  <rd:ReportID>85910e09-7694-4900-93d3-61cbe4abc2ce</rd:ReportID>
</Report>
    END_OF_RDLDATA
  }
}

