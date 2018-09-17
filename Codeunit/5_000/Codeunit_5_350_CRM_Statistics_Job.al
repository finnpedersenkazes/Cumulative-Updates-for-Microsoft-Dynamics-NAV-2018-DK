OBJECT Codeunit 5350 CRM Statistics Job
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    TableNo=472;
    OnRun=BEGIN
            UpdateStatisticsAndInvoices(GetLastLogEntryNo);
          END;

  }
  CODE
  {
    VAR
      ConnectionNotEnabledErr@1002 : TextConst '@@@="%1 = CRM product name";DAN=%1-forbindelsen er ikke aktiveret.;ENU=The %1 connection is not enabled.';
      RecordFoundTxt@1001 : TextConst '@@@=%1 is a table name, e.g. Customer, %2 is a number, e.g. Customer 12344 was not found.;DAN=%1 %2 blev ikke fundet.;ENU=%1 %2 was not found.';
      AccountStatisticsUpdatedMsg@1003 : TextConst 'DAN="Opdaterede kontostatistik. ";ENU="Updated account statistics. "';
      InvoiceStatusUpdatedMsg@1000 : TextConst 'DAN=Opdaterede betalingsstatus for salgsfakturaer.;ENU=Updated payment status of sales invoices.';
      CRMProductName@1004 : Codeunit 5344;

    LOCAL PROCEDURE UpdateStatisticsAndInvoices@1(JobLogEntryNo@1011 : Integer);
    VAR
      CRMConnectionSetup@1004 : Record 5330;
      ConnectionName@1006 : Text;
    BEGIN
      CRMConnectionSetup.GET;
      IF NOT CRMConnectionSetup."Is Enabled" THEN
        ERROR(ConnectionNotEnabledErr,CRMProductName.FULL);

      ConnectionName := FORMAT(CREATEGUID);
      CRMConnectionSetup.RegisterConnectionWithName(ConnectionName);
      SETDEFAULTTABLECONNECTION(
        TABLECONNECTIONTYPE::CRM,CRMConnectionSetup.GetDefaultCRMConnection(ConnectionName));

      UpdateAccountStatistics(JobLogEntryNo);

      UpdateInvoices(JobLogEntryNo);

      CRMConnectionSetup.UnregisterConnectionWithName(ConnectionName);
    END;

    LOCAL PROCEDURE UpdateAccountStatistics@13(JobLogEntryNo@1000 : Integer);
    VAR
      IntegrationRecord@1007 : Record 5151;
      CRMIntegrationRecord@1006 : Record 5331;
      IntegrationTableSynch@1005 : Codeunit 5335;
      CustomerRecordID@1004 : RecordID;
      RecRef@1003 : ARRAY [2] OF RecordRef;
      CRMID@1002 : GUID;
      ErrorText@1001 : Text;
      SynchActionType@1008 : 'None,Insert,Modify,ForceModify,IgnoreUnchanged,Fail,Skip,Delete';
    BEGIN
      IntegrationTableSynch.BeginIntegrationSynchJobLoging(
        TABLECONNECTIONTYPE::CRM,CODEUNIT::"CRM Statistics Job",JobLogEntryNo);

      IntegrationRecord.SETRANGE("Table ID",DATABASE::Customer);
      IntegrationRecord.SETRANGE("Deleted On",0DT);
      IF IntegrationRecord.FINDSET THEN
        REPEAT
          CustomerRecordID := IntegrationRecord."Record ID";
          IF CRMIntegrationRecord.FindIDFromRecordID(CustomerRecordID,CRMID) THEN BEGIN
            SynchActionType := UpdateCRMAccountStatisticsForCoupledCustomer(CustomerRecordID,CRMID,RecRef[1],RecRef[2],ErrorText);
            IF SynchActionType = SynchActionType::Fail THEN
              IntegrationTableSynch.LogSynchError(RecRef[1],RecRef[2],ErrorText)
            ELSE
              IntegrationTableSynch.IncrementSynchJobCounters(SynchActionType);
          END;
        UNTIL IntegrationRecord.NEXT = 0;

      IntegrationTableSynch.EndIntegrationSynchJobWithMsg(GetAccStatsUpdateFinalMessage);
    END;

    LOCAL PROCEDURE UpdateInvoices@14(JobLogEntryNo@1000 : Integer);
    VAR
      IntegrationTableSynch@1002 : Codeunit 5335;
      SynchActionType@1001 : 'None,Insert,Modify,ForceModify,IgnoreUnchanged,Fail,Skip,Delete';
      Counter@1003 : Integer;
    BEGIN
      IntegrationTableSynch.BeginIntegrationSynchJobLoging(
        TABLECONNECTIONTYPE::CRM,CODEUNIT::"CRM Statistics Job",JobLogEntryNo);

      Counter := UpdateStatusOfPaidInvoices('');
      IntegrationTableSynch.UpdateSynchJobCounters(SynchActionType::Modify,Counter);

      IntegrationTableSynch.EndIntegrationSynchJobWithMsg(GetInvStatusUpdateFinalMessage);
    END;

    LOCAL PROCEDURE UpdateCRMAccountStatisticsForCoupledCustomer@2(CustomerRecordID@1000 : RecordID;CRMAccountID@1004 : GUID;VAR CustomerRecRef@1002 : RecordRef;VAR CRMAccountRecRef@1003 : RecordRef;VAR ErrorText@1006 : Text) : Integer;
    VAR
      Customer@1001 : Record 18;
      CRMAccount@1005 : Record 5341;
      SynchActionType@1007 : 'None,Insert,Modify,ForceModify,IgnoreUnchanged,Fail,Skip,Delete';
    BEGIN
      Customer.GET(CustomerRecordID);
      CustomerRecRef.GETTABLE(Customer);
      IF NOT CRMAccount.GET(CRMAccountID) THEN BEGIN
        ErrorText := STRSUBSTNO(RecordFoundTxt,CRMAccount.TABLECAPTION,CRMAccountID);
        EXIT(SynchActionType::Fail);
      END;
      CRMAccountRecRef.GETTABLE(CRMAccount);
      EXIT(CreateOrUpdateCRMAccountStatistics(Customer,CRMAccount));
    END;

    [External]
    PROCEDURE CreateOrUpdateCRMAccountStatistics@3(Customer@1001 : Record 18;VAR CRMAccount@1000 : Record 5341) : Integer;
    VAR
      CRMAccountStatistics@1002 : Record 5367;
      xCRMAccountStatistics@1003 : Record 5367;
      LcyCRMTransactioncurrency@1004 : Record 5345;
      CRMSynchHelper@1005 : Codeunit 5342;
      SynchActionType@1006 : 'None,Insert,Modify,ForceModify,IgnoreUnchanged,Fail,Skip,Delete';
    BEGIN
      FindCRMAccountStatistics(CRMAccountStatistics,CRMAccount);
      xCRMAccountStatistics := CRMAccountStatistics;
      Customer.CALCFIELDS("Balance (LCY)","Outstanding Orders (LCY)","Shipped Not Invoiced (LCY)",
        "Outstanding Invoices (LCY)","Outstanding Serv. Orders (LCY)","Serv Shipped Not Invoiced(LCY)",
        "Outstanding Serv.Invoices(LCY)");
      WITH CRMAccountStatistics DO BEGIN
        Name := Customer.Name;
        "Customer No" := Customer."No.";
        "Balance (LCY)" := Customer."Balance (LCY)";
        "Outstanding Orders (LCY)" := Customer."Outstanding Orders (LCY)";
        "Shipped Not Invoiced (LCY)" := Customer."Shipped Not Invoiced (LCY)";
        "Outstanding Invoices (LCY)" := Customer."Outstanding Invoices (LCY)";
        "Outstanding Serv Orders (LCY)" := Customer."Outstanding Serv. Orders (LCY)";
        "Serv Shipped Not Invd (LCY)" := Customer."Serv Shipped Not Invoiced(LCY)";
        "Outstd Serv Invoices (LCY)" := Customer."Outstanding Serv.Invoices(LCY)";
        "Total (LCY)" := Customer.GetTotalAmountLCY;
        "Credit Limit (LCY)" := Customer."Credit Limit (LCY)";
        "Overdue Amounts (LCY)" := Customer.CalcOverdueBalance;
        "Overdue Amounts As Of Date" := WORKDATE;
        "Total Sales (LCY)" := Customer.GetSalesLCY;
        "Invd Prepayment Amount (LCY)" := Customer.GetInvoicedPrepmtAmountLCY;
        TransactionCurrencyId := CRMSynchHelper.FindNAVLocalCurrencyInCRM(LcyCRMTransactioncurrency);
        IF xCRMAccountStatistics."Customer No" = '' THEN BEGIN
          MODIFY;
          EXIT(SynchActionType::Insert);
        END;
        IF IsCRMAccountStatisticsModified(xCRMAccountStatistics,CRMAccountStatistics) THEN BEGIN
          MODIFY;
          EXIT(SynchActionType::Modify);
        END;
        EXIT(SynchActionType::IgnoreUnchanged);
      END;
    END;

    PROCEDURE GetAccStatsUpdateFinalMessage@10() : Text;
    BEGIN
      EXIT(AccountStatisticsUpdatedMsg);
    END;

    PROCEDURE GetInvStatusUpdateFinalMessage@11() : Text;
    BEGIN
      EXIT(InvoiceStatusUpdatedMsg);
    END;

    LOCAL PROCEDURE IsCRMAccountStatisticsModified@9(xCRMAccountStatistics@1001 : Record 5367;CRMAccountStatistics@1000 : Record 5367) : Boolean;
    VAR
      Field@1004 : Record 2000000041;
      TypeHelper@1005 : Codeunit 10;
      RecRef@1002 : ARRAY [2] OF RecordRef;
      FieldRef@1003 : ARRAY [2] OF FieldRef;
    BEGIN
      RecRef[1].GETTABLE(xCRMAccountStatistics);
      RecRef[2].GETTABLE(CRMAccountStatistics);
      IF TypeHelper.FindFields(RecRef[1].NUMBER,Field) THEN
        REPEAT
          FieldRef[1] := RecRef[1].FIELD(Field."No.");
          IF FieldRef[1].NUMBER >= CRMAccountStatistics.FIELDNO(Name) THEN BEGIN // non system CRM fields starts from Name
            FieldRef[2] := RecRef[2].FIELD(Field."No.");
            IF FieldRef[1].VALUE <> FieldRef[2].VALUE THEN
              EXIT(TRUE);
          END;
        UNTIL Field.NEXT = 0;
      RecRef[1].CLOSE;
      RecRef[2].CLOSE;
    END;

    LOCAL PROCEDURE InitCRMAccountStatistics@5(VAR CRMAccountStatistics@1001 : Record 5367);
    BEGIN
      WITH CRMAccountStatistics DO BEGIN
        INIT;
        AccountStatisticsId := CREATEGUID;
        // Set all Money type fields to 1 temporarily, because if they have always been zero they show as '--' in CRM
        "Balance (LCY)" := 1;
        "Total (LCY)" := 1;
        "Credit Limit (LCY)" := 1;
        "Overdue Amounts (LCY)" := 1;
        "Total Sales (LCY)" := 1;
        "Invd Prepayment Amount (LCY)" := 1;
        "Outstanding Orders (LCY)" := 1;
        "Shipped Not Invoiced (LCY)" := 1;
        "Outstanding Invoices (LCY)" := 1;
        "Outstanding Serv Orders (LCY)" := 1;
        "Serv Shipped Not Invd (LCY)" := 1;
        "Outstd Serv Invoices (LCY)" := 1;
        INSERT;
      END;
    END;

    LOCAL PROCEDURE FindCRMAccountStatistics@8(VAR CRMAccountStatistics@1000 : Record 5367;VAR CRMAccount@1001 : Record 5341);
    BEGIN
      IF ISNULLGUID(CRMAccount.AccountStatiticsId) THEN BEGIN
        InitCRMAccountStatistics(CRMAccountStatistics);
        CRMAccount.AccountStatiticsId := CRMAccountStatistics.AccountStatisticsId;
        ModifyCRMAccount(CRMAccount);
      END ELSE
        CRMAccountStatistics.GET(CRMAccount.AccountStatiticsId);
    END;

    LOCAL PROCEDURE ModifyCRMAccount@6(VAR CRMAccount@1000 : Record 5341);
    VAR
      CRMIntegrationRecord@1001 : Record 5331;
    BEGIN
      WITH CRMAccount DO
        IF NOT CRMIntegrationRecord.IsModifiedAfterLastSynchonizedCRMRecord(AccountId,DATABASE::Customer,ModifiedOn) THEN BEGIN
          MODIFY;
          CRMIntegrationRecord.SetLastSynchCRMModifiedOn(AccountId,DATABASE::Customer,ModifiedOn);
        END ELSE
          MODIFY;
    END;

    PROCEDURE UpdateStatusOfPaidInvoices@4(CustomerNo@1002 : Code[20]) UpdatedInvoiceCounter : Integer;
    VAR
      CRMConnectionSetup@1001 : Record 5330;
      DtldCustLedgEntry@1004 : Record 379;
      CurrCLENo@1000 : Integer;
      ForAllCustomers@1003 : Boolean;
    BEGIN
      CRMConnectionSetup.GET;
      DtldCustLedgEntry.SETCURRENTKEY("Cust. Ledger Entry No.","Posting Date");
      DtldCustLedgEntry.SETFILTER("Entry No.",'>%1',CRMConnectionSetup."Last Update Invoice Entry No.");
      ForAllCustomers := CustomerNo = '';
      IF NOT ForAllCustomers THEN
        DtldCustLedgEntry.SETRANGE("Customer No.",CustomerNo);
      IF DtldCustLedgEntry.FINDSET THEN BEGIN
        CurrCLENo := DtldCustLedgEntry."Cust. Ledger Entry No.";
        REPEAT
          IF CurrCLENo <> DtldCustLedgEntry."Cust. Ledger Entry No." THEN BEGIN
            UpdatedInvoiceCounter += UpdateInvoice(CurrCLENo);
            CurrCLENo := DtldCustLedgEntry."Cust. Ledger Entry No.";
          END;
        UNTIL DtldCustLedgEntry.NEXT = 0;
        UpdatedInvoiceCounter += UpdateInvoice(CurrCLENo);
        IF ForAllCustomers THEN
          CRMConnectionSetup.UpdateLastUpdateInvoiceEntryNo;
      END;
    END;

    LOCAL PROCEDURE UpdateInvoice@7(CustLedgEntryNo@1000 : Integer) : Integer;
    VAR
      CRMIntegrationRecord@1005 : Record 5331;
      CRMInvoice@1002 : Record 5355;
      CustLedgerEntry@1001 : Record 21;
      SalesInvHeader@1003 : Record 112;
      CRMSynchHelper@1004 : Codeunit 5342;
    BEGIN
      IF CustLedgerEntry.GET(CustLedgEntryNo) THEN
        IF CustLedgerEntry."Document Type" = CustLedgerEntry."Document Type"::Invoice THEN
          IF SalesInvHeader.GET(CustLedgerEntry."Document No.") THEN
            IF CRMIntegrationRecord.FindByRecordID(SalesInvHeader.RECORDID) THEN
              IF CRMInvoice.GET(CRMIntegrationRecord."CRM ID") THEN
                EXIT(CRMSynchHelper.UpdateCRMInvoiceStatusFromEntry(CRMInvoice,CustLedgerEntry));
    END;

    [EventSubscriber(Table,472,OnFindingIfJobNeedsToBeRun)]
    LOCAL PROCEDURE OnFindingIfJobNeedsToBeRun@65(VAR Sender@1000 : Record 472;VAR Result@1001 : Boolean);
    VAR
      CRMConnectionSetup@1002 : Record 5330;
      DetailedCustLedgEntry@1003 : Record 379;
    BEGIN
      WITH Sender DO
        IF ("Object Type to Run" = "Object Type to Run"::Codeunit) AND ("Object ID to Run" = CODEUNIT::"CRM Statistics Job") THEN
          IF CRMConnectionSetup.GET AND CRMConnectionSetup."Is Enabled" THEN
            Result :=
              DetailedCustLedgEntry.FINDLAST AND
              (CRMConnectionSetup."Last Update Invoice Entry No." < DetailedCustLedgEntry."Entry No.");
    END;

    BEGIN
    END.
  }
}

