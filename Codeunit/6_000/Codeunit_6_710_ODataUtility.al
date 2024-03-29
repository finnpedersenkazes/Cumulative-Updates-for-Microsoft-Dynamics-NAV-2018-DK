OBJECT Codeunit 6710 ODataUtility
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 6710=rimd,
                TableData 6711=rimd,
                TableData 6712=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ODataWizardTxt@1000 : TextConst 'DAN=Konfigurer rapporteringsdata;ENU=Set Up Reporting Data';
      TypeHelper@1064 : Codeunit 10;
      WorksheetWriter@1014 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorksheetWriter";
      WorkbookWriter@1003 : DotNet "'Microsoft.Dynamics.Nav.OpenXml, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.OpenXml.Spreadsheet.WorkbookWriter";
      ODataProtocolVersion@1001 : 'V3,V4';
      BalanceSheetHeadingTxt@1005 : TextConst 'DAN=Balance;ENU=Balance Sheet';
      BalanceSheetNameTxt@1012 : TextConst '@@@={Locked};DAN=BalanceSheet;ENU=BalanceSheet';
      CompanyTxt@1006 : TextConst 'DAN=Virksomhed;ENU=Company';
      CurrencyTxt@1007 : TextConst 'DAN=Valuta;ENU=Currency';
      PrintedTxt@1008 : TextConst 'DAN=Udskrevet;ENU=Printed';
      AsOfDateTxt@1009 : TextConst 'DAN=Pr. dato;ENU=As of Date';
      DesciptionTxt@1010 : TextConst 'DAN=Beskrivelse;ENU=Description';
      BalanceTxt@1011 : TextConst 'DAN=Saldo;ENU=Balance';
      PrintDollarLinesTxt@1013 : TextConst 'DAN=Udskriv 0 v�rdilinjer;ENU=Print 0 Value Lines';
      SummaryTrialBalanceHeadingTxt@1016 : TextConst 'DAN=R�balanceoversigt;ENU=Summary Trial Balance';
      SummaryTrialBalanceNameTxt@1017 : TextConst '@@@={Locked};DAN=SummaryTrialBalance;ENU=SummaryTrialBalance';
      FromDateTxt@1018 : TextConst 'DAN=Fra dato;ENU=From Date';
      ToDateTxt@1019 : TextConst 'DAN=Til dato;ENU=To Date';
      NoTxt@1020 : TextConst 'DAN=Nr.;ENU=No.';
      NameTxt@1021 : TextConst 'DAN=Navn;ENU=Name';
      TotalDebitActivitiesTxt@1022 : TextConst 'DAN=Samlede debetaktiviteter;ENU=Total Debit Activities';
      TotalCreditActivitiesTxt@1023 : TextConst 'DAN=Samlede kreditaktiviteter;ENU=Total Credit Activities';
      EndingBalanceTxt@1024 : TextConst 'DAN=Slutsaldo;ENU=Ending Balance';
      BeginningBalanceTxt@1025 : TextConst 'DAN=Startsaldo;ENU=Beginning Balance';
      IncomeStatementHeadingTxt@1026 : TextConst 'DAN=Resultatopg�relse;ENU=Income Statement';
      IncomeStatementNameTxt@1027 : TextConst '@@@={Locked};DAN=IncomeStatement;ENU=IncomeStatement';
      AccountNameTxt@1028 : TextConst 'DAN=Kontonavn;ENU=Account Name';
      NetChangeTxt@1029 : TextConst 'DAN=Bev�gelse;ENU=Net Change';
      StatementOfRetainedEarningsHeadingTxt@1030 : TextConst 'DAN=Opg�relse af overf�rt resultat;ENU=Statement of Retained Earnings';
      StatementOfRetainedEarningsNameTxt@1031 : TextConst '@@@={Locked};DAN=StatementOfRetainedEarnings;ENU=StatementOfRetainedEarnings';
      StartingDateTxt@1015 : TextConst 'DAN=Startdato;ENU=Starting Date';
      EndingDateTxt@1032 : TextConst 'DAN=Slutdato;ENU=Ending Date';
      AgedAccountsPayableHeadingTxt@1033 : TextConst 'DAN=Aldersfordelt g�ld;ENU=Aged Accounts Payable';
      AgedAccountsPayableNameTxt@1034 : TextConst '@@@={Locked};DAN=AgedAccountsPayable;ENU=AgedAccountsPayable';
      AgedAccountsReceivableHeaderTxt@1035 : TextConst 'DAN=Aldersfordelte tilgodehavender;ENU=Aged Accounts Receivable';
      AgedAccountsReceivableNameTxt@1036 : TextConst '@@@={Locked};DAN=AgedAccountsReceivable;ENU=AgedAccountsReceivable';
      BalanceDueTxt@1037 : TextConst 'DAN=Forf. bel�b;ENU=Balance Due';
      CurrentTxt@1038 : TextConst 'DAN=L�bende;ENU=Current';
      UpTo30DaysTxt@1039 : TextConst 'DAN=Op til 30 dage;ENU=Up to 30 Days';
      Days31To60Txt@1040 : TextConst 'DAN=31-60 dage;ENU=31-60 Days';
      Over60DaysTxt@1041 : TextConst 'DAN=Over 60 dage;ENU=Over 60 Days';
      AgedByTxt@1042 : TextConst 'DAN=Aldersfordelt efter;ENU=Aged By';
      AgedAsOfDateTxt@1043 : TextConst 'DAN=Aldersfordelt pr. dato;ENU=Aged as of Date';
      DueDateTxt@1044 : TextConst 'DAN=Forfaldsdato;ENU=Due Date';
      CashFlowHeadingTxt@1045 : TextConst 'DAN=Pengestr�msopg�relse;ENU=Cash Flow Statement';
      CashFlowNameTxt@1046 : TextConst '@@@={Locked};DAN=CashFlow;ENU=CashFlow';
      PeriodStartTxt@1047 : TextConst 'DAN=Periodestart;ENU=Period Start';
      PeriodEndTxt@1048 : TextConst 'DAN=Periodeslut;ENU=Period End';
      DescriptionStaticTxt@1004 : TextConst '@@@={Locked};DAN=Description;ENU=Description';
      BalanceStaticTxt@1049 : TextConst '@@@={Locked};DAN=Balance;ENU=Balance';
      NoStaticTxt@1050 : TextConst '@@@={Locked};DAN=No.;ENU=No.';
      NameStaticTxt@1051 : TextConst '@@@={Locked};DAN=Name;ENU=Name';
      BeginningBalanceStaticTxt@1052 : TextConst '@@@={Locked};DAN=Beginning Balance;ENU=Beginning Balance';
      TotalDebitStaticTxt@1053 : TextConst '@@@={Locked};DAN=Total Debit Activities;ENU=Total Debit Activities';
      TotalCreditStaticTxt@1054 : TextConst '@@@={Locked};DAN=Total Credit Activities;ENU=Total Credit Activities';
      EndingBalanceStaticTxt@1055 : TextConst '@@@={Locked};DAN=Ending Balance;ENU=Ending Balance';
      AccountNameStaticTxt@1056 : TextConst '@@@={Locked};DAN=Account Name;ENU=Account Name';
      NetChangeStaticTxt@1057 : TextConst '@@@={Locked};DAN=Net Change;ENU=Net Change';
      BalanceDueStaticTxt@1058 : TextConst 'DAN=Forf. bel�b;ENU=Balance Due';
      CurrentStaticTxt@1059 : TextConst '@@@={Locked};DAN=Current;ENU=Current';
      UpTo30StaticTxt@1060 : TextConst '@@@={Locked};DAN=Up to 30 Days;ENU=Up to 30 Days';
      Days31To60StaticTxt@1061 : TextConst '@@@={Locked};DAN=31-60 Days;ENU=31-60 Days';
      Over60StaticTxt@1062 : TextConst '@@@={Locked};DAN=Over 60 Days;ENU=Over 60 Days';

    [TryFunction]
    [External]
    PROCEDURE GenerateSelectText@19(ServiceNameParam@1001 : Text;ObjectTypeParam@1004 : ',,,,,Codeunit,,,Page,Query';VAR SelectTextParam@1000 : Text);
    VAR
      TenantWebServiceColumns@1003 : Record 6711;
      TenantWebService@1002 : Record 2000000168;
      FirstColumn@1006 : Boolean;
    BEGIN
      IF TenantWebService.GET(ObjectTypeParam,ServiceNameParam) THEN BEGIN
        FirstColumn := TRUE;
        TenantWebServiceColumns.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);

        IF TenantWebServiceColumns.FIND('-') THEN BEGIN
          SelectTextParam := '$select=';
          REPEAT
            IF NOT FirstColumn THEN
              SelectTextParam += ','
            ELSE
              FirstColumn := FALSE;

            SelectTextParam += TenantWebServiceColumns."Field Name";
          UNTIL TenantWebServiceColumns.NEXT = 0;
        END;
      END;
    END;

    [TryFunction]
    [Internal]
    PROCEDURE GenerateODataV3FilterText@33(ServiceNameParam@1000 : Text;ObjectTypeParam@1003 : ',,,,,Codeunit,,,Page,Query';VAR FilterTextParam@1001 : Text);
    BEGIN
      ODataProtocolVersion := ODataProtocolVersion::V3;
      FilterTextParam := GenerateFilterText(ServiceNameParam,ObjectTypeParam,CLIENTTYPE::OData);
      IF FilterTextParam <> '' THEN
        FilterTextParam := STRSUBSTNO('$filter=%1',FilterTextParam);
    END;

    [TryFunction]
    [Internal]
    PROCEDURE GenerateODataV4FilterText@26(ServiceNameParam@1000 : Text;ObjectTypeParam@1003 : ',,,,,Codeunit,,,Page,Query';VAR FilterTextParam@1001 : Text);
    BEGIN
      ODataProtocolVersion := ODataProtocolVersion::V4;
      FilterTextParam := GenerateFilterText(ServiceNameParam,ObjectTypeParam,CLIENTTYPE::ODataV4);
      IF FilterTextParam <> '' THEN
        FilterTextParam := STRSUBSTNO('$filter=%1',FilterTextParam);
    END;

    LOCAL PROCEDURE GenerateFilterText@21(ServiceNameParam@1000 : Text;ObjectTypeParam@1003 : ',,,,,Codeunit,,,Page,Query';ClientType@1004 : ClientType) : Text;
    VAR
      TenantWebService@1009 : Record 2000000168;
      TableItemFilterTextDictionary@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";
      FilterText@1005 : Text;
    BEGIN
      IF TenantWebService.GET(ObjectTypeParam,ServiceNameParam) THEN BEGIN
        TableItemFilterTextDictionary := TableItemFilterTextDictionary.Dictionary;
        GetNAVFilters(TenantWebService,TableItemFilterTextDictionary);
        FilterText := CombineFiltersFromTables(TenantWebService,TableItemFilterTextDictionary,ClientType);
      END;

      EXIT(FilterText);
    END;

    [External]
    PROCEDURE GenerateODataV3Url@35(ServiceRootUrlParam@1010 : Text;ServiceNameParam@1000 : Text;ObjectTypeParam@1003 : ',,,,,,,,Page,Query') : Text;
    BEGIN
      EXIT(GenerateUrl(ServiceRootUrlParam,ServiceNameParam,ObjectTypeParam,ODataProtocolVersion::V3));
    END;

    [External]
    PROCEDURE GenerateODataV4Url@14(ServiceRootUrlParam@1010 : Text;ServiceNameParam@1000 : Text;ObjectTypeParam@1003 : ',,,,,,,,Page,Query') : Text;
    BEGIN
      EXIT(GenerateUrl(ServiceRootUrlParam,ServiceNameParam,ObjectTypeParam,ODataProtocolVersion::V4));
    END;

    LOCAL PROCEDURE GenerateUrl@8(ServiceRootUrlParam@1010 : Text;ServiceNameParam@1000 : Text;ObjectTypeParam@1003 : ',,,,,,,,Page,Query';ODataProtocolVersionParam@1004 : 'V3,V4') : Text;
    VAR
      TenantWebService@1001 : Record 2000000168;
      TenantWebServiceOData@1002 : Record 6710;
      ODataUrl@1012 : Text;
      SelectText@1011 : Text;
      FilterText@1009 : Text;
    BEGIN
      IF TenantWebService.GET(ObjectTypeParam,ServiceNameParam) THEN BEGIN
        TenantWebServiceOData.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);

        IF TenantWebServiceOData.FINDFIRST THEN BEGIN
          SelectText := TenantWebServiceOData.GetOdataSelectClause;
          IF ODataProtocolVersionParam = ODataProtocolVersionParam::V3 THEN
            FilterText := TenantWebServiceOData.GetOdataFilterClause
          ELSE
            FilterText := TenantWebServiceOData.GetOdataV4FilterClause;
        END;
      END;

      ODataUrl := BuildUrl(ServiceRootUrlParam,SelectText,FilterText);
      EXIT(ODataUrl);
    END;

    LOCAL PROCEDURE BuildUrl@27(ServiceRootUrlParam@1000 : Text;SelectTextParam@1004 : Text;FilterTextParam@1001 : Text) : Text;
    VAR
      ODataUrl@1003 : Text;
      preSelectTextConjunction@1002 : Text;
    BEGIN
      IF STRPOS(ServiceRootUrlParam,'?tenant=') > 0 THEN
        preSelectTextConjunction := '&'
      ELSE
        preSelectTextConjunction := '?';

      IF (STRLEN(SelectTextParam) > 0) AND (STRLEN(FilterTextParam) > 0) THEN
        ODataUrl := ServiceRootUrlParam + preSelectTextConjunction + SelectTextParam + '&' + FilterTextParam
      ELSE
        IF STRLEN(SelectTextParam) > 0 THEN
          ODataUrl := ServiceRootUrlParam + preSelectTextConjunction + SelectTextParam
        ELSE
          // FilterText is based on SelectText, so it doesn't make sense to have only the FilterText.
          ODataUrl := ServiceRootUrlParam;

      EXIT(ODataUrl);
    END;

    LOCAL PROCEDURE CombineFiltersFromTables@41(VAR TenantWebService@1001 : Record 2000000168;TableItemFilterTextDictionaryParam@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";ODataClientType@1023 : ClientType) : Text;
    VAR
      KeyValuePair@1013 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.KeyValuePair`2";
      ODataFilterGenerator@1005 : DotNet "'Microsoft.Dynamics.Nav.Ncl, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Runtime.ODataFilterGenerator";
      Filter@1021 : Text;
      Conjunction@1022 : Text;
      DataItemFilterText@1002 : Text;
      FilterTextForSelectedColumns@1000 : Text;
    BEGIN
      FOREACH KeyValuePair IN TableItemFilterTextDictionaryParam DO BEGIN
        FilterTextForSelectedColumns := RemoveUnselectedColumnsFromFilter(TenantWebService,KeyValuePair.Key,KeyValuePair.Value);
        CASE TenantWebService."Object Type" OF
          TenantWebService."Object Type"::Page:
            CASE ODataClientType OF
              CLIENTTYPE::OData:
                DataItemFilterText := ODataFilterGenerator.CreateODataV3Filter(KeyValuePair.Key,FilterTextForSelectedColumns,0);
              CLIENTTYPE::ODataV4:
                DataItemFilterText := ODataFilterGenerator.CreateODataV4Filter(KeyValuePair.Key,FilterTextForSelectedColumns,0);
            END;
          TenantWebService."Object Type"::Query:
            CASE ODataClientType OF
              CLIENTTYPE::OData:
                DataItemFilterText := ODataFilterGenerator.CreateODataV3Filter(KeyValuePair.Key,FilterTextForSelectedColumns,
                    TenantWebService."Object ID");
              CLIENTTYPE::ODataV4:
                DataItemFilterText := ODataFilterGenerator.CreateODataV4Filter(KeyValuePair.Key,FilterTextForSelectedColumns,
                    TenantWebService."Object ID");
            END;
        END;
        Filter := STRSUBSTNO('%1%2%3',Filter,Conjunction,DataItemFilterText);
        Conjunction := ' and ';
      END;
      EXIT(Filter);
    END;

    LOCAL PROCEDURE RemoveUnselectedColumnsFromFilter@2(VAR TenantWebService@1000 : Record 2000000168;DataItemNumber@1001 : Integer;DataItemView@1002 : Text) : Text;
    VAR
      TenantWebServiceColumns@1008 : Record 6711;
      BaseRecRef@1003 : RecordRef;
      UpdatedRecRef@1004 : RecordRef;
      BaseFieldRef@1005 : FieldRef;
      UpdatedFieldRef@1006 : FieldRef;
    BEGIN
      // Removes filters that aren't in the selected columns for the given service.
      BaseRecRef.OPEN(DataItemNumber);
      BaseRecRef.SETVIEW(DataItemView);
      UpdatedRecRef.OPEN(DataItemNumber);

      TenantWebServiceColumns.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
      TenantWebServiceColumns.SETRANGE("Data Item",DataItemNumber);
      IF TenantWebServiceColumns.FINDSET THEN
        REPEAT
          BaseFieldRef := BaseRecRef.FIELD(TenantWebServiceColumns."Field Number");
          UpdatedFieldRef := UpdatedRecRef.FIELD(TenantWebServiceColumns."Field Number");
          UpdatedFieldRef.SETFILTER(BaseFieldRef.GETFILTER);
        UNTIL TenantWebServiceColumns.NEXT = 0;

      EXIT(UpdatedRecRef.GETVIEW);
    END;

    [TryFunction]
    LOCAL PROCEDURE FindColumnsFromNAVFilters@3(VAR TenantWebService@1006 : Record 2000000168;TableItemFilterTextDictionaryParam@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";VAR ColumnListParam@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.List`1");
    VAR
      TenantWebServiceColumns@1007 : Record 6711;
      FieldTable@1009 : Record 2000000041;
      Regex@1002 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
      LocalFilterSegments@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
      TempString1@1008 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      TempString2@1011 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      KeyValuePair@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.KeyValuePair`2";
      LocalFilterText@1026 : Text;
      I@1025 : Integer;
      Column@1024 : Text;
      IndexOfKeyStart@1016 : Integer;
      IndexOfValueEnd@1015 : Integer;
    BEGIN
      // SORTING(No.) WHERE(No=FILTER(01121212..01454545|31669966),Balance Due=FILTER(>0))

      FOREACH KeyValuePair IN TableItemFilterTextDictionaryParam DO BEGIN
        LocalFilterText := DELSTR(KeyValuePair.Value,1,STRPOS(KeyValuePair.Value,'WHERE') + 5);  // becomes No=FILTER(01121212..01454545|31669966),Balance Due=FILTER(>0))
        LocalFilterText := DELSTR(LocalFilterText,STRLEN(LocalFilterText),1); // remove ), becomes No=FILTER(01121212..01454545|31669966),Balance Due=FILTER(>0)
        LocalFilterSegments := Regex.Split(LocalFilterText,'=FILTER'); // No   (01121212..01454545|31669966),Balance Due   (>0)

        // Break all the filters into key value pairs.
        FOR I := 0 TO LocalFilterSegments.Length - 2 DO BEGIN
          TempString1 := LocalFilterSegments.GetValue(I);
          TempString2 := LocalFilterSegments.GetValue(I + 1);
          IndexOfKeyStart := TempString1.LastIndexOf(',');
          IndexOfValueEnd := TempString2.LastIndexOf(',');

          // Start index of the key is either at the beginning or right after the comma.
          IF IndexOfKeyStart > 0 THEN
            IndexOfKeyStart := IndexOfKeyStart + 1
          ELSE
            IndexOfKeyStart := 0;

          // End index of the value is either right before the comma or at the end.  Make sure we don't confuse commas in last filter value.
          IF (IndexOfValueEnd < 0) OR (I = LocalFilterSegments.Length - 2) THEN
            IndexOfValueEnd := TempString2.Length;

          Column := TempString1.Substring(IndexOfKeyStart,TempString1.Length - IndexOfKeyStart);

          // Add to the list if the field is in the dataset.
          FieldTable.SETRANGE(TableNo,KeyValuePair.Key);
          FieldTable.SETFILTER(ObsoleteState,'<>%1',FieldTable.ObsoleteState::Removed);
          FieldTable.SETRANGE("Field Caption",Column);
          IF FieldTable.FINDFIRST THEN BEGIN
            TenantWebServiceColumns.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
            TenantWebServiceColumns.SETRANGE("Data Item",KeyValuePair.Key);
            TenantWebServiceColumns.SETRANGE("Field Number",FieldTable."No.");
            IF TenantWebServiceColumns.FINDFIRST THEN
              ColumnListParam.Add(Column);
          END;
        END;
      END;
    END;

    LOCAL PROCEDURE GetNAVFilters@12(VAR TenantWebService@1000 : Record 2000000168;VAR TableItemFilterTextDictionaryParam@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2");
    VAR
      TenantWebServiceFilter@1001 : Record 6712;
      FilterText@1008 : Text;
    BEGIN
      TenantWebServiceFilter.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
      IF TenantWebServiceFilter.FIND('-') THEN BEGIN
        REPEAT
          FilterText := TenantWebServiceFilter.GetFilter;
          IF STRLEN(FilterText) > 0 THEN
            TableItemFilterTextDictionaryParam.Add(TenantWebServiceFilter."Data Item",FilterText);
        UNTIL TenantWebServiceFilter.NEXT = 0;
      END;
    END;

    [EventSubscriber(Table,2000000168,OnAfterDeleteEvent)]
    LOCAL PROCEDURE DeleteODataOnDeleteTenantWebService@6(VAR Rec@1000 : Record 2000000168;RunTrigger@1001 : Boolean);
    VAR
      TenantWebServiceColumns@1003 : Record 6711;
      TenantWebServiceFilter@1002 : Record 6712;
      TenantWebServiceOData@1004 : Record 6710;
    BEGIN
      // Delete the data from the OData concrete tables when a Tenant Web Service record is deleted.
      TenantWebServiceFilter.SETRANGE(TenantWebServiceID,Rec.RECORDID);
      TenantWebServiceColumns.SETRANGE(TenantWebServiceID,Rec.RECORDID);
      TenantWebServiceOData.SETRANGE(TenantWebServiceID,Rec.RECORDID);
      TenantWebServiceFilter.DELETEALL;
      TenantWebServiceColumns.DELETEALL;
      TenantWebServiceOData.DELETEALL;
    END;

    [External]
    PROCEDURE ConvertNavFieldNameToOdataName@10(NavFieldName@1000 : Text) : Text;
    VAR
      i@1001 : Integer;
    BEGIN
      i := STRPOS(NavFieldName,'%');
      IF i > 0 THEN
        NavFieldName := INSSTR(NavFieldName,'Percent',i);
      NavFieldName := DELCHR(NavFieldName,'=','(.)<>%');
      NavFieldName := CONVERTSTR(NavFieldName,' ,:;?&"/-','_________');
      EXIT(NavFieldName);
    END;

    [Internal]
    PROCEDURE GetColumnsFromFilter@4(VAR TenantWebService@1004 : Record 2000000168;FilterText@1000 : Text;VAR ColumnList@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.List`1");
    VAR
      TableItemFilterTextDictionary@1002 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";
    BEGIN
      TableItemFilterTextDictionary := TableItemFilterTextDictionary.Dictionary;
      TableItemFilterTextDictionary.Add(1,FilterText);
      FindColumnsFromNAVFilters(TenantWebService,TableItemFilterTextDictionary,ColumnList);
    END;

    [EventSubscriber(Codeunit,2,OnCompanyInitialize)]
    [External]
    PROCEDURE CreateAssistedSetup@9();
    VAR
      AssistedSetup@1000 : Record 1803;
      NewOrderNumber@1001 : Integer;
    BEGIN
      IF AssistedSetup.GET(PAGE::"OData Setup Wizard") THEN
        EXIT;

      AssistedSetup.LOCKTABLE;
      AssistedSetup.SETCURRENTKEY(Order,Visible);
      IF AssistedSetup.FINDLAST THEN
        NewOrderNumber := AssistedSetup.Order + 1
      ELSE
        NewOrderNumber := 1;

      CLEAR(AssistedSetup);
      AssistedSetup.INIT;
      AssistedSetup.VALIDATE("Page ID",PAGE::"OData Setup Wizard");
      AssistedSetup.VALIDATE(Name,ODataWizardTxt);
      AssistedSetup.VALIDATE(Order,NewOrderNumber);
      AssistedSetup.VALIDATE(Status,AssistedSetup.Status::"Not Completed");
      AssistedSetup.VALIDATE(Visible,TRUE);
      AssistedSetup.INSERT(TRUE);
    END;

    LOCAL PROCEDURE CreateWorksheetWebService@1(PageCaption@1000 : Text[240];PageId@1001 : Text);
    VAR
      TenantWebService@1002 : Record 2000000168;
      ObjectId@1003 : Integer;
    BEGIN
      IF NOT TenantWebService.GET(TenantWebService."Object Type"::Page,PageCaption) THEN BEGIN
        TenantWebService.INIT;
        TenantWebService."Object Type" := TenantWebService."Object Type"::Page;
        EVALUATE(ObjectId,COPYSTR(PageId,5));
        TenantWebService."Object ID" := ObjectId;
        TenantWebService."Service Name" := PageCaption;
        TenantWebService.Published := TRUE;
        TenantWebService.INSERT(TRUE);
      END;
    END;

    PROCEDURE EditJournalWorksheetInExcel@15(PageCaption@1000 : Text[240];PageId@1001 : Text;JournalBatchName@1002 : Text;JournalTemplateName@1003 : Text);
    VAR
      ApplicationManagement@1005 : Codeunit 1;
      Filter@1004 : Text;
    BEGIN
      CreateWorksheetWebService(PageCaption,PageId);

      Filter := STRSUBSTNO('Journal_Batch_Name eq ''%1'' and Journal_Template_Name eq ''%2''',JournalBatchName,JournalTemplateName);
      ApplicationManagement.OnEditInExcel(PageCaption,Filter);
    END;

    PROCEDURE EditWorksheetInExcel@36(PageCaption@1000 : Text[240];PageId@1001 : Text;Filter@1002 : Text);
    VAR
      ApplicationManagement@1003 : Codeunit 1;
    BEGIN
      CreateWorksheetWebService(PageCaption,PageId);
      ApplicationManagement.OnEditInExcel(PageCaption,Filter);
    END;

    [Internal]
    PROCEDURE GenerateExcelWorkBook@37(ObjectTypeParm@1000 : ',,,,,Codeunit,,,Page,Query';ServiceNameParm@1001 : Text;ShowDialogParm@1003 : Boolean);
    VAR
      TenantWebService@1002 : Record 2000000168;
      TenantWebServiceColumns@1005 : Record 6711;
    BEGIN
      IF NOT TenantWebService.GET(ObjectTypeParm,ServiceNameParm) THEN
        EXIT;

      TenantWebServiceColumns.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
      TenantWebServiceColumns.FINDFIRST;

      GenerateExcelWorkBookWithColumns(ObjectTypeParm,ServiceNameParm,ShowDialogParm,TenantWebServiceColumns)
    END;

    [Internal]
    PROCEDURE GenerateExcelWorkBookWithColumns@24(ObjectTypeParm@1000 : ',,,,,Codeunit,,,Page,Query';ServiceNameParm@1001 : Text;ShowDialogParm@1003 : Boolean;VAR TenantWebServiceColumns@1006 : Record 6711);
    VAR
      TenantWebService@1002 : Record 2000000168;
      TempBlob@1018 : TEMPORARY Record 99008535;
      FileManagement@1004 : Codeunit 419;
      DataEntityExportInfo@1017 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.Excel.Export.DataEntityExportInfo";
      DataEntityExportGenerator@1012 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.Excel.Export.DataEntityExportGenerator";
      NvOutStream@1008 : OutStream;
      FileName@1007 : Text;
    BEGIN
      IF NOT TenantWebService.GET(ObjectTypeParm,ServiceNameParm) THEN
        EXIT;

      DataEntityExportInfo := DataEntityExportInfo.DataEntityExportInfo;
      CreateDataEntityExportInfo(TenantWebService,DataEntityExportInfo,TenantWebServiceColumns);

      DataEntityExportGenerator := DataEntityExportGenerator.DataEntityExportGenerator;
      TempBlob.Blob.CREATEOUTSTREAM(NvOutStream);
      DataEntityExportGenerator.GenerateWorkbook(DataEntityExportInfo,NvOutStream);
      FileName := TenantWebService."Service Name" + '.xlsx';
      FileManagement.BLOBExport(TempBlob,FileName,ShowDialogParm);
    END;

    [Internal]
    PROCEDURE GenerateExcelTemplateWorkBook@39(ObjectTypeParm@1002 : ',,,,,Codeunit,,,Page,Query';ServiceNameParm@1001 : Text[50];ShowDialogParm@1000 : Boolean;StatementType@1012 : 'BalanceSheet,SummaryTrialBalance,CashFlowStatement,StatementOfRetainedEarnings,AgedAccountsReceivable,AgedAccountsPayable,IncomeStatement');
    VAR
      WebService@1009 : Record 2000000076;
      TempBlob@1008 : TEMPORARY Record 99008535;
      MediaResources@1017 : Record 2000000182;
      FileManagement@1007 : Codeunit 419;
      OfficeAppInfo@1014 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.OfficeAppInfo";
      WorkbookSettingsManager@1022 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.Excel.WorkbookSettingsManager";
      SettingsObject@1025 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.DynamicsExtensionSettings";
      NvOutStream@1011 : OutStream;
      NvInStream@1010 : InStream;
      HostName@1006 : Text;
      FileName@1005 : Text;
      TempFileName@1004 : Text[60];
    BEGIN
      IF NOT WebService.GET(ObjectTypeParm,ServiceNameParm) THEN
        EXIT;

      OfficeAppInfo := OfficeAppInfo.OfficeAppInfo;
      OfficeAppInfo.Id := 'WA104379629';
      OfficeAppInfo.Store := 'en-US';
      OfficeAppInfo.StoreType := 'OMEX';
      OfficeAppInfo.Version := '1.3.0.0';

      HostName := GETURL(CLIENTTYPE::Web);
      IF STRPOS(HostName,'?') <> 0 THEN
        HostName := COPYSTR(HostName,1,STRPOS(HostName,'?') - 1);

      TempFileName := ServiceNameParm + '.xltm';
      IF NOT MediaResources.GET(TempFileName) THEN
        EXIT;

      MediaResources.CALCFIELDS(Blob);
      MediaResources.Blob.CREATEINSTREAM(NvInStream);

      TempBlob.Blob.CREATEOUTSTREAM(NvOutStream);
      COPYSTREAM(NvOutStream,NvInStream);

      // Collect data for template translations to match company generated for
      WorkbookWriter := WorkbookWriter.Open(NvOutStream);
      WorksheetWriter := WorkbookWriter.FirstWorksheet;

      CASE StatementType OF
        StatementType::BalanceSheet:
          AddBalanceSheetCellValues;
        StatementType::SummaryTrialBalance:
          AddSummaryTrialBalancetCellValues;
        StatementType::AgedAccountsPayable:
          AddAgedAccountsPayableCellValues;
        StatementType::AgedAccountsReceivable:
          AddAgedAccountsReceivableCellValues;
        StatementType::CashFlowStatement:
          AddCashFlowStatementCellValues;
        StatementType::IncomeStatement:
          AddIncomeStatementCellValues;
        StatementType::StatementOfRetainedEarnings:
          AddStatementOfRetainedEarningsCellValues;
      END;

      WorkbookSettingsManager := WorkbookSettingsManager.WorkbookSettingsManager(WorkbookWriter.Document);

      SettingsObject := SettingsObject.DynamicsExtensionSettings;
      WorkbookSettingsManager.SettingsObject.Headers.Clear;
      WorkbookSettingsManager.SettingsObject.Headers.Add('Company',WebService.CURRENTCOMPANY);
      WorkbookSettingsManager.SetAppInfo(OfficeAppInfo);
      WorkbookSettingsManager.SetHostName(HostName);
      WorkbookSettingsManager.SetLanguage(TypeHelper.LanguageIDToCultureName(WINDOWSLANGUAGE));
      WorkbookWriter.Close;

      FileName := WebService."Service Name" + '.xltm';
      FileManagement.BLOBExport(TempBlob,FileName,ShowDialogParm);
    END;

    [TryFunction]
    LOCAL PROCEDURE GetConjunctionString@48(VAR localFilterSegments@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";VAR ConjunctionStringParam@1001 : Text;VAR IndexParam@1002 : Integer);
    BEGIN
      ConjunctionStringParam := localFilterSegments.GetValue(IndexParam);
      IndexParam += 1;
    END;

    [TryFunction]
    LOCAL PROCEDURE GetNextFieldString@23(VAR localFilterSegments@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";VAR NextFieldStringParam@1001 : Text;VAR IndexParam@1002 : Integer);
    BEGIN
      NextFieldStringParam := localFilterSegments.GetValue(IndexParam);
      IndexParam += 1;
    END;

    LOCAL PROCEDURE TrimFilterClause@22(VAR FilterClauseParam@1000 : Text);
    BEGIN
      IF STRPOS(FilterClauseParam,'filter=') <> 0 THEN
        FilterClauseParam := DELSTR(FilterClauseParam,1,STRPOS(FilterClauseParam,'filter=') + 6);

      // becomes  ((No ge '01121212' and No le '01445544') or No eq '10000') and ((Name eq 'bob') and Name eq 'frank')
      FilterClauseParam := DELCHR(FilterClauseParam,'<','(');
      FilterClauseParam := DELCHR(FilterClauseParam,'>',')');
      // becomes  (No ge '01121212' and No le '01445544') or No eq '10000') and ((Name eq 'bob') and Name eq 'frank'
    END;

    LOCAL PROCEDURE GetEndPointAndCreateWorkbook@20(ServiceName@1001 : Text[240];ODataFilter@1000 : Text);
    VAR
      TenantWebService@1002 : Record 2000000168;
      TenantWebServiceOData@1004 : Record 6710;
      TenantWebServiceColumns@1016 : Record 6711;
      TempTenantWebServiceColumns@1014 : TEMPORARY Record 6711;
      ColumnDictionary@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";
      SourceTableText@1006 : Text;
      SavedSelectText@1003 : Text;
      DefaultSelectText@1008 : Text;
      OldFilter@1010 : Text;
      TableNo@1013 : Integer;
      UseTempColumns@1017 : Boolean;
    BEGIN
      ColumnDictionary := ColumnDictionary.Dictionary;

      IF NOT TenantWebService.GET(TenantWebService."Object Type"::Page,ServiceName) THEN
        EXIT;

      TenantWebServiceOData.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);

      // Get the default $select text
      InitSelectedColumns(TenantWebService,ColumnDictionary,SourceTableText);
      EVALUATE(TableNo,SourceTableText);
      DefaultSelectText := GetDefaultSelectText(ColumnDictionary);
      SavedSelectText := TenantWebServiceOData.GetOdataSelectClause;

      // If we don't have an endpoint - we need a new endpoint
      IF NOT TenantWebServiceOData.FINDFIRST THEN BEGIN
        CreateEndPoint(TenantWebService,ColumnDictionary,DefaultSelectText,TenantWebServiceColumns);
        TenantWebServiceOData.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
        TenantWebServiceOData.FINDFIRST;
      END ELSE BEGIN
        // If we have a select text mismatch - set the select text for this operation and use a temp column record
        IF SavedSelectText <> DefaultSelectText THEN BEGIN
          InsertSelectedColumns(TenantWebService,ColumnDictionary,TempTenantWebServiceColumns,TableNo);
          TempTenantWebServiceColumns.MODIFY(TRUE);
          TempTenantWebServiceColumns.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
          TempTenantWebServiceColumns.FINDFIRST;
          TenantWebServiceOData.SetOdataSelectClause(DefaultSelectText);
          UseTempColumns := TRUE;
        END;
        // Save the filter to restore later
        OldFilter := TenantWebServiceOData.GetOdataFilterClause;
      END;

      // This record should now exist after creating the endpoint.
      TenantWebServiceColumns.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
      TenantWebServiceColumns.FINDFIRST;

      TenantWebServiceOData.SetOdataV4FilterClause(ODataFilter);
      TenantWebServiceOData.MODIFY(TRUE);

      IF UseTempColumns THEN
        GenerateExcelWorkBookWithColumns(TenantWebService."Object Type",ServiceName,TRUE,TempTenantWebServiceColumns)
      ELSE
        GenerateExcelWorkBookWithColumns(TenantWebService."Object Type",ServiceName,TRUE,TenantWebServiceColumns);

      // Restore the filters and columns.
      TenantWebServiceOData.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
      TenantWebServiceOData.FINDFIRST;
      TenantWebServiceOData.SetOdataV4FilterClause(OldFilter);
      TenantWebServiceOData.SetOdataSelectClause(SavedSelectText);
      TenantWebServiceOData.MODIFY(TRUE);
    END;

    [Internal]
    PROCEDURE CreateDataEntityExportInfo@18(VAR TenantWebService@1013 : Record 2000000168;VAR DataEntityExportInfoParam@1002 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.Excel.Export.DataEntityExportInfo";VAR TenantWebServiceColumns@1024 : Record 6711);
    VAR
      TenantWebServiceOData@1014 : Record 6710;
      ConnectionInfo@1010 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.Excel.Export.ConnectionInfo";
      OfficeAppInfo@1009 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.OfficeAppInfo";
      DataEntityInfo@1008 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.DataEntityInfo";
      BindingInfo@1007 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.BindingInfo";
      FieldInfo@1005 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FieldInfo";
      FieldFilterCollectionNode@1003 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterCollectionNode";
      FieldFilterCollectionNode2@1001 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterCollectionNode";
      EntityFilterCollectionNode@1000 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterCollectionNode";
      FilterClause@1029 : Text;
      HostName@1022 : Text;
      ServiceName@1033 : Text;
      FieldFilterCounter@1012 : Integer;
      Inserted@1034 : Boolean;
    BEGIN
      OfficeAppInfo := OfficeAppInfo.OfficeAppInfo;
      OfficeAppInfo.Id := 'WA104379629';
      OfficeAppInfo.Store := 'en-US'; // todo US store only?
      OfficeAppInfo.StoreType := 'OMEX';
      OfficeAppInfo.Version := '1.3.0.0';

      DataEntityExportInfoParam := DataEntityExportInfoParam.DataEntityExportInfo;
      DataEntityExportInfoParam.AppReference := OfficeAppInfo;

      ConnectionInfo := ConnectionInfo.ConnectionInfo;
      HostName := GETURL(CLIENTTYPE::Web);
      IF STRPOS(HostName,'?') <> 0 THEN
        HostName := COPYSTR(HostName,1,STRPOS(HostName,'?') - 1);
      ConnectionInfo.HostName := HostName;

      DataEntityExportInfoParam.Connection := ConnectionInfo;
      DataEntityExportInfoParam.Language := TypeHelper.LanguageIDToCultureName(WINDOWSLANGUAGE); // todo get language
      DataEntityExportInfoParam.EnableDesign := TRUE;
      DataEntityExportInfoParam.RefreshOnOpen := TRUE;
      DataEntityExportInfoParam.Headers.Add('Company',TenantWebService.CURRENTCOMPANY);
      DataEntityInfo := DataEntityInfo.DataEntityInfo;
      ServiceName := ExternalizeName(TenantWebService."Service Name");
      DataEntityInfo.Name := ServiceName;
      DataEntityInfo.PublicName := ServiceName;
      DataEntityExportInfoParam.Entities.Add(DataEntityInfo);

      BindingInfo := BindingInfo.BindingInfo;
      BindingInfo.EntityName := DataEntityInfo.Name;

      DataEntityExportInfoParam.Bindings.Add(BindingInfo);

      TenantWebServiceOData.INIT;
      TenantWebServiceOData.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
      TenantWebServiceOData.FINDFIRST;

      TenantWebServiceColumns.INIT;
      TenantWebServiceColumns.SETRANGE(TenantWebServiceID,TenantWebService.RECORDID);
      FilterClause := TenantWebServiceOData.GetOdataV4FilterClause;

      EntityFilterCollectionNode := EntityFilterCollectionNode.FilterCollectionNode;  // One filter collection node for entire entity
      IF TenantWebServiceColumns.FINDSET THEN BEGIN
        REPEAT
          FieldInfo := FieldInfo.FieldInfo;
          FieldInfo.Name := TenantWebServiceColumns."Field Name";
          FieldInfo.Label := TenantWebServiceColumns."Field Name";
          BindingInfo.Fields.Add(FieldInfo);

          Inserted := InsertDataIntoFilterCollectionNode(TenantWebServiceColumns."Field Name",GetFieldType(TenantWebServiceColumns),
              FilterClause,EntityFilterCollectionNode,FieldFilterCollectionNode,FieldFilterCollectionNode2);

          IF Inserted THEN
            FieldFilterCounter += 1;

          IF FieldFilterCounter > 1 THEN
            EntityFilterCollectionNode.Operator('and');  // All fields are anded together

        UNTIL TenantWebServiceColumns.NEXT = 0;
        AddFieldNodeToEntityNode(FieldFilterCollectionNode,FieldFilterCollectionNode2,EntityFilterCollectionNode);
      END;

      DataEntityInfo.Filter(EntityFilterCollectionNode);
    END;

    LOCAL PROCEDURE InsertDataIntoFilterCollectionNode@49(FieldName@1001 : Text;FieldType@1007 : Text;FilterClause@1016 : Text;VAR EntityFilterCollectionNode@1000 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterCollectionNode";VAR FieldFilterCollectionNode@1018 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterCollectionNode";VAR FieldFilterCollectionNode2@1017 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterCollectionNode") : Boolean;
    VAR
      FilterBinaryNode@1019 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterBinaryNode";
      FilterLeftOperand@1015 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterLeftOperand";
      ValueString@1014 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      Regex@1013 : DotNet "'System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
      FilterSegments@1012 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";
      ConjunctionString@1011 : Text;
      OldConjunctionString@1010 : Text;
      NextFieldString@1009 : Text;
      Index@1008 : Integer;
      NumberOfCharsTrimmed@1004 : Integer;
      TrimPos@1003 : Integer;
      FilterCreated@1025 : Boolean;
    BEGIN
      // New column, if the previous row had data, add it entity filter collection
      AddFieldNodeToEntityNode(FieldFilterCollectionNode,FieldFilterCollectionNode2,EntityFilterCollectionNode);

      TrimPos := 0;
      Index := 1;
      OldConjunctionString := '';
      // $filter=((No ge '01121212' and No le '01445544') or No eq '10000') and ((Name eq 'bo b') and Name eq 'fra nk')
      IF FilterClause <> '' THEN BEGIN
        TrimFilterClause(FilterClause);

        IF Regex.IsMatch(FilterClause,STRSUBSTNO('\b%1\b',FieldName)) THEN BEGIN
          FilterClause := COPYSTR(FilterClause,STRPOS(FilterClause,FieldName + ' '));

          WHILE FilterClause <> '' DO BEGIN
            FilterCreated := TRUE;
            FilterBinaryNode := FilterBinaryNode.FilterBinaryNode;
            FilterLeftOperand := FilterLeftOperand.FilterLeftOperand;

            FilterLeftOperand.Field(FieldName);
            FilterLeftOperand.Type(FieldType);

            FilterBinaryNode.Left := FilterLeftOperand;
            FilterSegments := Regex.Split(FilterClause,' ');

            FilterBinaryNode.Operator(FilterSegments.GetValue(1));
            ValueString := FilterSegments.GetValue(2);
            Index := 3;

            NumberOfCharsTrimmed := ConcatValueStringPortions(ValueString,FilterSegments,Index);

            FilterBinaryNode.Right(ValueString);

            TrimPos := STRPOS(FilterClause,ValueString) + STRLEN(ValueString) + NumberOfCharsTrimmed;

            IF NOT GetConjunctionString(FilterSegments,ConjunctionString,Index) THEN
              ConjunctionString := '';

            IF NOT GetNextFieldString(FilterSegments,NextFieldString,Index) THEN
              NextFieldString := '';

            TrimPos := TrimPos + STRLEN(ConjunctionString) + STRLEN(NextFieldString);

            IF (NextFieldString = '') OR (NextFieldString = FieldName) THEN BEGIN
              IF (OldConjunctionString <> '') AND (OldConjunctionString <> ConjunctionString) THEN BEGIN
                IF ISNULL(FieldFilterCollectionNode2) THEN BEGIN
                  FieldFilterCollectionNode2 := FieldFilterCollectionNode2.FilterCollectionNode;
                  FieldFilterCollectionNode2.Operator(ConjunctionString);
                END;

                FieldFilterCollectionNode.Collection.Add(FilterBinaryNode);
                IF OldConjunctionString <> '' THEN
                  FieldFilterCollectionNode.Operator(OldConjunctionString);

                FieldFilterCollectionNode2.Collection.Add(FieldFilterCollectionNode);

                CLEAR(FieldFilterCollectionNode);
              END ELSE BEGIN
                IF ISNULL(FieldFilterCollectionNode) THEN
                  FieldFilterCollectionNode := FieldFilterCollectionNode.FilterCollectionNode;

                FieldFilterCollectionNode.Collection.Add(FilterBinaryNode);
                FieldFilterCollectionNode.Operator(OldConjunctionString)
              END
            END ELSE BEGIN
              IF ISNULL(FieldFilterCollectionNode2) THEN
                FieldFilterCollectionNode2 := FieldFilterCollectionNode2.FilterCollectionNode;

              IF ISNULL(FieldFilterCollectionNode) THEN
                FieldFilterCollectionNode := FieldFilterCollectionNode.FilterCollectionNode;

              FieldFilterCollectionNode.Collection.Add(FilterBinaryNode);
              FieldFilterCollectionNode.Operator(OldConjunctionString);

              FieldFilterCollectionNode2.Collection.Add(FieldFilterCollectionNode);

              CLEAR(FieldFilterCollectionNode);

              FilterClause := ''; // the FilterClause is exhausted for this field
            END;

            OldConjunctionString := ConjunctionString;

            FilterClause := COPYSTR(FilterClause,TrimPos); // remove that portion that has been processed.
          END;
        END;
      END;
      EXIT(FilterCreated);
    END;

    LOCAL PROCEDURE ConcatValueStringPortions@17(VAR ValueStringParam@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";VAR FilterSegmentsParam@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Array";VAR IndexParm@1007 : Integer) : Integer;
    VAR
      ValueStringPortion@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      LastPosition@1001 : Integer;
      FirstPosition@1002 : Integer;
      SingleTick@1006 : Char;
      StrLenAfterTrim@1008 : Integer;
      StrLenBeforeTrim@1004 : Integer;
    BEGIN
      SingleTick := 39;

      FirstPosition := ValueStringParam.IndexOf(SingleTick);
      LastPosition := ValueStringParam.LastIndexOf(SingleTick);

      // The valueString might have been spit earlier if it had an embedded ' ', stick it back together
      IF (FirstPosition = 0) AND (FirstPosition = LastPosition) THEN BEGIN
        REPEAT
          ValueStringPortion := FilterSegmentsParam.GetValue(IndexParm);
          ValueStringParam := ValueStringParam.Concat(ValueStringParam,' ');
          ValueStringParam := ValueStringParam.Concat(ValueStringParam,ValueStringPortion);
          ValueStringPortion := FilterSegmentsParam.GetValue(IndexParm);
          IndexParm += 1 ;
        UNTIL ValueStringPortion.LastIndexOf(SingleTick) > 0;
      END;

      // Now that the string has been put back together if needed, remove leading and trailing SingleTick
      // as the excel addin will apply them.
      FirstPosition := ValueStringParam.IndexOf(SingleTick);

      StrLenBeforeTrim := STRLEN(ValueStringParam);
      IF FirstPosition = 0 THEN BEGIN
        ValueStringParam := DELSTR(ValueStringParam,1,1);
        LastPosition := ValueStringParam.LastIndexOf(SingleTick);
        IF LastPosition > 0 THEN BEGIN
          ValueStringParam := DELCHR(ValueStringParam,'>',')'); // Remove any trailing ')'
          ValueStringParam := DELSTR(ValueStringParam,ValueStringParam.Length,1);
        END;
      END;

      StrLenAfterTrim := STRLEN(ValueStringParam);
      EXIT(StrLenBeforeTrim - StrLenAfterTrim);
    END;

    LOCAL PROCEDURE GetFieldType@13(VAR TenantWebServiceColumnsParam@1001 : Record 6711) : Text;
    VAR
      FieldTable@1000 : Record 2000000041;
    BEGIN
      FieldTable.SETRANGE(TableNo,TenantWebServiceColumnsParam."Data Item");
      FieldTable.SETRANGE("No.",TenantWebServiceColumnsParam."Field Number");
      IF FieldTable.FINDFIRST THEN
        CASE FieldTable.Type OF
          FieldTable.Type::Text,FieldTable.Type::Code,FieldTable.Type::OemCode,FieldTable.Type::OemText,FieldTable.Type::Option:
            EXIT('Edm.String');
          FieldTable.Type::BigInteger,FieldTable.Type::Integer:
            EXIT('Edm.Int32');
          FieldTable.Type::Decimal:
            EXIT('Edm.Decimal');
          FieldTable.Type::Date,FieldTable.Type::DateTime,FieldTable.Type::Time:
            EXIT('Edm.DateTimeOffset');
          FieldTable.Type::Boolean:
            EXIT('Edm.Boolean');
        END;
    END;

    LOCAL PROCEDURE AddFieldNodeToEntityNode@11(VAR FieldFilterCollectionNodeParam@1002 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterCollectionNode";VAR FieldFilterCollectionNode2Param@1001 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterCollectionNode";VAR EntityFilterCollectionNodeParam@1000 : DotNet "'Microsoft.Dynamics.Platform.Integration.Office, Version=7.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Platform.Integration.Office.FilterCollectionNode");
    BEGIN
      IF NOT ISNULL(FieldFilterCollectionNode2Param) THEN BEGIN
        EntityFilterCollectionNodeParam.Collection.Add(FieldFilterCollectionNode2Param);
        CLEAR(FieldFilterCollectionNode2Param);
      END;

      IF NOT ISNULL(FieldFilterCollectionNodeParam) THEN BEGIN
        EntityFilterCollectionNodeParam.Collection.Add(FieldFilterCollectionNodeParam);
        CLEAR(FieldFilterCollectionNodeParam);
      END;
    END;

    LOCAL PROCEDURE InitSelectedColumns@30(VAR TenantWebService@1000 : Record 2000000168;ColumnDictionary@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";VAR SourceTableText@1004 : Text);
    BEGIN
      InitColumnsForPage(TenantWebService,ColumnDictionary,SourceTableText);
    END;

    LOCAL PROCEDURE InitColumnsForPage@31(VAR TenantWebService@1010 : Record 2000000168;ColumnDictionary@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";VAR SourceTableTextParam@1017 : Text);
    VAR
      FieldsTable@1014 : Record 2000000041;
      PageControlField@1019 : Record 2000000192;
      ODataUtility@1018 : Codeunit 6710;
      FieldNameText@1015 : Text;
    BEGIN
      PageControlField.SETRANGE(PageNo,TenantWebService."Object ID");
      IF PageControlField.FINDSET THEN
        REPEAT
          SourceTableTextParam := FORMAT(PageControlField.TableNo);

          IF FieldsTable.GET(PageControlField.TableNo,PageControlField.FieldNo) THEN BEGIN
            IF ColumnDictionary.ContainsKey(FieldsTable."No.") THEN
              EXIT;

            // Convert to OData compatible name.
            FieldNameText := ODataUtility.ConvertNavFieldNameToOdataName(PageControlField.ControlName);
            ColumnDictionary.Add(FieldsTable."No.",FieldNameText);
          END;
        UNTIL PageControlField.NEXT = 0;

      EnsureKeysInSelect(SourceTableTextParam,ColumnDictionary);
    END;

    LOCAL PROCEDURE EnsureKeysInSelect@5(SourceTableTextParam@1000 : Text;ColumnDictionary@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2");
    VAR
      RecRef@1002 : RecordRef;
      VarKeyRef@1003 : KeyRef;
      VarFieldRef@1004 : FieldRef;
      KeysText@1005 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.String";
      SourceTableId@1006 : Integer;
      i@1007 : Integer;
    BEGIN
      EVALUATE(SourceTableId,SourceTableTextParam);

      RecRef.OPEN(SourceTableId);
      VarKeyRef := RecRef.KEYINDEX(1);
      FOR i := 1 TO VarKeyRef.FIELDCOUNT DO BEGIN
        VarFieldRef := VarKeyRef.FIELDINDEX(i);
        KeysText := ConvertNavFieldNameToOdataName(VarFieldRef.NAME);

        IF NOT ColumnDictionary.ContainsKey(VarFieldRef.NUMBER) THEN
          ColumnDictionary.Add(VarFieldRef.NUMBER,KeysText);
      END;
    END;

    LOCAL PROCEDURE InsertSelectedColumns@32(VAR TenantWebService@1000 : Record 2000000168;VAR ColumnDictionary@1001 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";VAR TargetTenantWebServiceColumns@1002 : Record 6711;TableNo@1007 : Integer);
    VAR
      keyValuePair@1006 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.KeyValuePair`2";
      EntryId@1003 : Integer;
    BEGIN
      FOREACH keyValuePair IN ColumnDictionary DO BEGIN
        CLEAR(TargetTenantWebServiceColumns);

        TargetTenantWebServiceColumns.INIT;
        TargetTenantWebServiceColumns.VALIDATE(TenantWebServiceID,TenantWebService.RECORDID);
        TargetTenantWebServiceColumns.VALIDATE("Data Item",TableNo);
        TargetTenantWebServiceColumns.VALIDATE(Include,TRUE);
        TargetTenantWebServiceColumns.VALIDATE("Field Number",keyValuePair.Key);
        TargetTenantWebServiceColumns.VALIDATE("Field Name",COPYSTR(keyValuePair.Value,1));
        IF TargetTenantWebServiceColumns.ISTEMPORARY THEN BEGIN
          EntryId := EntryId + 1;
          TargetTenantWebServiceColumns."Entry ID" := EntryId;
        END;
        TargetTenantWebServiceColumns.INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE InsertODataRecord@25(VAR TenantWebService@1000 : Record 2000000168;SelectText@1003 : Text);
    VAR
      TenantWebServiceOData@1001 : Record 6710;
    BEGIN
      TenantWebServiceOData.INIT;
      TenantWebServiceOData.VALIDATE(TenantWebServiceID,TenantWebService.RECORDID);
      TenantWebServiceOData.SetOdataSelectClause(SelectText);
      TenantWebServiceOData.INSERT(TRUE);
    END;

    LOCAL PROCEDURE GetDefaultSelectText@44(VAR ColumnDictionary@1000 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2") : Text;
    VAR
      keyValuePair@1003 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.KeyValuePair`2";
      FirstColumn@1002 : Boolean;
      SelectTextParam@1001 : Text;
    BEGIN
      FirstColumn := TRUE;
      SelectTextParam := '$select=';
      FOREACH keyValuePair IN ColumnDictionary DO BEGIN
        IF NOT FirstColumn THEN
          SelectTextParam += ','
        ELSE
          FirstColumn := FALSE;

        SelectTextParam += COPYSTR(keyValuePair.Value,1);
      END;

      EXIT(SelectTextParam);
    END;

    LOCAL PROCEDURE CreateEndPoint@28(VAR TenantWebService@1002 : Record 2000000168;VAR ColumnDictionary@1004 : DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.Dictionary`2";SelectQueryParam@1000 : Text;VAR TenantWebServiceColumns@1003 : Record 6711);
    VAR
      SourceTableText@1005 : Text;
      TableNo@1006 : Integer;
    BEGIN
      InitSelectedColumns(TenantWebService,ColumnDictionary,SourceTableText);
      EVALUATE(TableNo,SourceTableText);
      InsertSelectedColumns(TenantWebService,ColumnDictionary,TenantWebServiceColumns,TableNo);
      InsertODataRecord(TenantWebService,SelectQueryParam);
    END;

    [EventSubscriber(Codeunit,1,OnEditInExcel)]
    LOCAL PROCEDURE EditInExcel@34(ServiceName@1000 : Text[240];ODataFilter@1001 : Text);
    BEGIN
      IF STRPOS(ODataFilter,'$filter=') = 0 THEN
        ODataFilter := STRSUBSTNO('%1%2','$filter=',ODataFilter);

      GetEndPointAndCreateWorkbook(ServiceName,ODataFilter);
    END;

    LOCAL PROCEDURE ExternalizeName@45(Name@1000 : Text) : Text;
    BEGIN
      // Service names are externalized by replacing some special characters with '_'
      // We should do the same here
      Name := CONVERTSTR(Name,' ','_');
      Name := CONVERTSTR(Name,'\','_');
      Name := CONVERTSTR(Name,'/','_');
      Name := CONVERTSTR(Name,'''','_');
      Name := CONVERTSTR(Name,'"','_');
      Name := CONVERTSTR(Name,'.','_');
      Name := CONVERTSTR(Name,'(','_');
      Name := CONVERTSTR(Name,')','_');
      Name := CONVERTSTR(Name,'-','_');
      Name := CONVERTSTR(Name,':','_');

      Name := RemoveDoubleUnderscore(Name);

      EXIT(Name);
    END;

    LOCAL PROCEDURE RemoveDoubleUnderscore@29(Input@1000 : Text) : Text;
    VAR
      UnderscorePos@1001 : Integer;
    BEGIN
      WHILE STRPOS(Input,'__') <> 0 DO BEGIN
        UnderscorePos := STRPOS(Input,'__');
        Input := DELSTR(Input,UnderscorePos,2);
        Input := INSSTR(Input,'_',UnderscorePos);
      END;
      EXIT(Input);
    END;

    [External]
    PROCEDURE CreateTenantWebServiceColumnForPage@1004(TenantWebServiceRecordId@1002 : RecordID;FieldNumber@1000 : Integer;DataItem@1003 : Integer);
    VAR
      TenantWebServiceColumns@1001 : Record 6711;
      FieldTable@1004 : Record 2000000041;
      ODataUtility@1005 : Codeunit 6710;
      FieldNameConverted@1006 : Text;
    BEGIN
      TenantWebServiceColumns.INIT;
      TenantWebServiceColumns."Entry ID" := 0;
      TenantWebServiceColumns."Data Item" := DataItem;
      TenantWebServiceColumns."Field Number" := FieldNumber;
      TenantWebServiceColumns.TenantWebServiceID := TenantWebServiceRecordId;
      TenantWebServiceColumns.Include := TRUE;

      IF FieldTable.GET(DataItem,FieldNumber) THEN
        FieldNameConverted := ODataUtility.ConvertNavFieldNameToOdataName(FieldTable.FieldName);

      TenantWebServiceColumns."Field Name" := COPYSTR(FieldNameConverted,1,250);
      TenantWebServiceColumns.INSERT;
    END;

    [External]
    PROCEDURE CreateTenantWebServiceColumnForQuery@16(TenantWebServiceRecordId@1002 : RecordID;FieldNumber@1001 : Integer;DataItem@1000 : Integer;MetaData@1007 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.QueryMetadataReader");
    VAR
      TenantWebServiceColumns@1006 : Record 6711;
      queryField@1004 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.QueryFields";
      FieldNameConverted@1003 : Text;
      i@1009 : Integer;
    BEGIN
      TenantWebServiceColumns.INIT;
      TenantWebServiceColumns."Entry ID" := 0;
      TenantWebServiceColumns."Data Item" := DataItem;
      TenantWebServiceColumns."Field Number" := FieldNumber;
      TenantWebServiceColumns.TenantWebServiceID := TenantWebServiceRecordId;
      TenantWebServiceColumns.Include := TRUE;

      FOR i := 0 TO MetaData.Fields.Count - 1 DO BEGIN
        queryField := MetaData.Fields.Item(i);
        IF (queryField.FieldNo = FieldNumber) AND (queryField.TableNo = DataItem) THEN
          FieldNameConverted := queryField.FieldName;
      END;

      TenantWebServiceColumns."Field Name" := COPYSTR(FieldNameConverted,1,250);
      TenantWebServiceColumns.INSERT;
    END;

    LOCAL PROCEDURE AddBalanceSheetCellValues@55();
    BEGIN
      WorksheetWriter.Name(BalanceSheetNameTxt);

      WorksheetWriter.UpdateCellValueText(2,'B',BalanceSheetHeadingTxt);

      WorksheetWriter.SetCellValueText(4,'B',CompanyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(5,'B',CurrencyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(7,'B',PrintedTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(8,'B',AsOfDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(10,'B',PrintDollarLinesTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.UpdateCellValueText(11,'B',DesciptionTxt);
      WorksheetWriter.UpdateTableColumnHeader('BalanceSheetTable',DescriptionStaticTxt,DesciptionTxt);
      WorksheetWriter.UpdateCellValueText(11,'C',BalanceTxt);
      WorksheetWriter.UpdateTableColumnHeader('BalanceSheetTable',BalanceStaticTxt,BalanceTxt);
    END;

    LOCAL PROCEDURE AddSummaryTrialBalancetCellValues@59();
    BEGIN
      WorksheetWriter.Name(SummaryTrialBalanceNameTxt);

      WorksheetWriter.UpdateCellValueText(2,'B',SummaryTrialBalanceHeadingTxt);
      WorksheetWriter.SetCellValueText(2,'F',CompanyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(4,'B',PrintedTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(4,'F',FromDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(5,'F',ToDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(6,'B',PrintDollarLinesTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.UpdateCellValueText(7,'B',NoTxt);
      WorksheetWriter.UpdateTableColumnHeader('SummaryTrialBalanceTable',NoStaticTxt,NoTxt);
      WorksheetWriter.UpdateCellValueText(7,'C',NameTxt);
      WorksheetWriter.UpdateTableColumnHeader('SummaryTrialBalanceTable',NameStaticTxt,NameTxt);
      WorksheetWriter.UpdateCellValueText(7,'D',BeginningBalanceTxt);
      WorksheetWriter.UpdateTableColumnHeader('SummaryTrialBalanceTable',BeginningBalanceStaticTxt,BeginningBalanceTxt);
      WorksheetWriter.UpdateCellValueText(7,'E',TotalDebitActivitiesTxt);
      WorksheetWriter.UpdateTableColumnHeader('SummaryTrialBalanceTable',TotalDebitStaticTxt,TotalDebitActivitiesTxt);
      WorksheetWriter.UpdateCellValueText(7,'F',TotalCreditActivitiesTxt);
      WorksheetWriter.UpdateTableColumnHeader('SummaryTrialBalanceTable',TotalCreditStaticTxt,TotalCreditActivitiesTxt);
      WorksheetWriter.UpdateCellValueText(7,'G',EndingBalanceTxt);
      WorksheetWriter.UpdateTableColumnHeader('SummaryTrialBalanceTable',EndingBalanceStaticTxt,EndingBalanceTxt);
    END;

    LOCAL PROCEDURE AddIncomeStatementCellValues@60();
    BEGIN
      WorksheetWriter.Name(IncomeStatementNameTxt);

      WorksheetWriter.UpdateCellValueText(2,'B',IncomeStatementHeadingTxt);

      WorksheetWriter.SetCellValueText(5,'B',CompanyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(6,'B',CurrencyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(7,'B',PrintedTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(9,'B',FromDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(10,'B',ToDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(12,'B',PrintDollarLinesTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.UpdateCellValueText(13,'B',AccountNameTxt);
      WorksheetWriter.UpdateTableColumnHeader('IncomeStatementTable',AccountNameStaticTxt,AccountNameTxt);
      WorksheetWriter.UpdateCellValueText(13,'C',NetChangeTxt);
      WorksheetWriter.UpdateTableColumnHeader('IncomeStatementTable',NetChangeStaticTxt,NetChangeTxt);
    END;

    LOCAL PROCEDURE AddStatementOfRetainedEarningsCellValues@61();
    BEGIN
      WorksheetWriter.Name(StatementOfRetainedEarningsNameTxt);

      WorksheetWriter.UpdateCellValueText(2,'B',StatementOfRetainedEarningsHeadingTxt);

      WorksheetWriter.SetCellValueText(5,'B',CompanyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(6,'B',CurrencyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(7,'B',PrintedTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(9,'B',StartingDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(10,'B',EndingDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(12,'B',PrintDollarLinesTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.UpdateCellValueText(13,'B',DesciptionTxt);
      WorksheetWriter.UpdateTableColumnHeader('StatementofRetainedEarningsTable',DescriptionStaticTxt,DesciptionTxt);
      WorksheetWriter.UpdateCellValueText(13,'C',NetChangeTxt);
      WorksheetWriter.UpdateTableColumnHeader('StatementofRetainedEarningsTable',NetChangeStaticTxt,NetChangeTxt);
    END;

    LOCAL PROCEDURE AddAgedAccountsPayableCellValues@62();
    BEGIN
      WorksheetWriter.Name(AgedAccountsPayableNameTxt);

      WorksheetWriter.UpdateCellValueText(2,'C',AgedAccountsPayableHeadingTxt);

      WorksheetWriter.SetCellValueText(2,'G',CompanyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(4,'C',AgedAsOfDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(4,'G',CurrencyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(5,'C',AgedByTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(5,'D',DueDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(5,'G',PrintedTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(6,'H',PrintDollarLinesTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.UpdateCellValueText(7,'C',NoTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsPayableTable',NoStaticTxt,NoTxt);
      WorksheetWriter.UpdateCellValueText(7,'D',NameTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsPayableTable',NameStaticTxt,NameTxt);
      WorksheetWriter.UpdateCellValueText(7,'E',BalanceDueTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsPayableTable',BalanceDueStaticTxt,BalanceDueTxt);
      WorksheetWriter.UpdateCellValueText(7,'F',CurrentTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsPayableTable',CurrentStaticTxt,CurrentTxt);
      WorksheetWriter.UpdateCellValueText(7,'G',UpTo30DaysTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsPayableTable',UpTo30StaticTxt,UpTo30DaysTxt);
      WorksheetWriter.UpdateCellValueText(7,'H',Days31To60Txt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsPayableTable',Days31To60StaticTxt,Days31To60Txt);
      WorksheetWriter.UpdateCellValueText(7,'I',Over60DaysTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsPayableTable',Over60StaticTxt,Over60DaysTxt);
    END;

    LOCAL PROCEDURE AddAgedAccountsReceivableCellValues@63();
    BEGIN
      WorksheetWriter.Name(AgedAccountsReceivableNameTxt);

      WorksheetWriter.UpdateCellValueText(2,'C',AgedAccountsReceivableHeaderTxt);

      WorksheetWriter.SetCellValueText(2,'G',CompanyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(4,'C',AgedAsOfDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(4,'G',CurrencyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(5,'C',AgedByTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(5,'D',DueDateTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(5,'G',PrintedTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(6,'H',PrintDollarLinesTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.UpdateCellValueText(7,'C',NoTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsReceivableTable',NoStaticTxt,NoTxt);
      WorksheetWriter.UpdateCellValueText(7,'D',NameTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsReceivableTable',NameStaticTxt,NameTxt);
      WorksheetWriter.UpdateCellValueText(7,'E',BalanceDueTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsReceivableTable',BalanceDueStaticTxt,BalanceDueTxt);
      WorksheetWriter.UpdateCellValueText(7,'F',CurrentTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsReceivableTable',CurrentStaticTxt,CurrentTxt);
      WorksheetWriter.UpdateCellValueText(7,'G',UpTo30DaysTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsReceivableTable',UpTo30StaticTxt,UpTo30DaysTxt);
      WorksheetWriter.UpdateCellValueText(7,'H',Days31To60Txt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsReceivableTable',Days31To60StaticTxt,Days31To60Txt);
      WorksheetWriter.UpdateCellValueText(7,'I',Over60DaysTxt);
      WorksheetWriter.UpdateTableColumnHeader('AgedAccountsReceivableTable',Over60StaticTxt,Over60DaysTxt);
    END;

    LOCAL PROCEDURE AddCashFlowStatementCellValues@64();
    BEGIN
      WorksheetWriter.Name(CashFlowNameTxt);

      WorksheetWriter.UpdateCellValueText(2,'B',CashFlowHeadingTxt);

      WorksheetWriter.SetCellValueText(5,'B',CompanyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(6,'B',CurrencyTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(7,'B',PrintedTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(9,'B',PeriodStartTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(10,'B',PeriodEndTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.SetCellValueText(12,'B',PrintDollarLinesTxt,WorksheetWriter.DefaultCellDecorator);
      WorksheetWriter.UpdateCellValueText(13,'B',DesciptionTxt);
      WorksheetWriter.UpdateTableColumnHeader('CashFlowTable',DescriptionStaticTxt,DesciptionTxt);
      WorksheetWriter.UpdateCellValueText(13,'C',NetChangeTxt);
      WorksheetWriter.UpdateTableColumnHeader('CashFlowTable',NetChangeStaticTxt,NetChangeTxt);
    END;

    [External]
    PROCEDURE GetTenantWebServiceMetadata@7(TenantWebService@1005 : Record 2000000168;VAR TenantWebServiceMetadata@1000 : DotNet "'Microsoft.Dynamics.Nav.Client.BusinessChart.Model, Version=11.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Client.BusinessChart.QueryMetadataReader");
    VAR
      ObjectMetadata@1003 : Record 2000000071;
      inStream@1002 : InStream;
    BEGIN
      IF NOT ObjectMetadata.GET(TenantWebService."Object Type",TenantWebService."Object ID") THEN
        EXIT;
      IF NOT ObjectMetadata.Metadata.HASVALUE THEN
        EXIT;

      ObjectMetadata.CALCFIELDS(Metadata);
      ObjectMetadata.Metadata.CREATEINSTREAM(inStream,TEXTENCODING::Windows);
      TenantWebServiceMetadata := TenantWebServiceMetadata.FromStream(inStream);
    END;

    BEGIN
    END.
  }
}

