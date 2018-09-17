OBJECT Codeunit 1261 Imp. SEPA CAMT Bank Rec. Lines
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    TableNo=274;
    OnRun=VAR
            DataExch@1002 : Record 1220;
            ProcessDataExch@1001 : Codeunit 1201;
            RecRef@1000 : RecordRef;
          BEGIN
            DataExch.GET("Data Exch. Entry No.");
            RecRef.GETTABLE(Rec);
            PreProcess(Rec);
            ProcessDataExch.ProcessAllLinesColumnMapping(DataExch,RecRef);
            PostProcess(Rec)
          END;

  }
  CODE
  {
    VAR
      StatementIDTxt@1000 : TextConst '@@@={Locked};DAN=/Document/BkToCstmrStmt/Stmt/Id;ENU=/Document/BkToCstmrStmt/Stmt/Id';
      IBANTxt@1001 : TextConst '@@@={Locked};DAN=/Document/BkToCstmrStmt/Stmt/Acct/Id/IBAN;ENU=/Document/BkToCstmrStmt/Stmt/Acct/Id/IBAN';
      BankIDTxt@1007 : TextConst '@@@={Locked};DAN=/Document/BkToCstmrStmt/Stmt/Acct/Id/Othr/Id;ENU=/Document/BkToCstmrStmt/Stmt/Acct/Id/Othr/Id';
      CurrencyTxt@1002 : TextConst '@@@={Locked};DAN=/Document/BkToCstmrStmt/Stmt/Bal/Amt[@Ccy];ENU=/Document/BkToCstmrStmt/Stmt/Bal/Amt[@Ccy]';
      BalTypeTxt@1006 : TextConst '@@@={Locked};DAN=/Document/BkToCstmrStmt/Stmt/Bal/Tp/CdOrPrtry/Cd;ENU=/Document/BkToCstmrStmt/Stmt/Bal/Tp/CdOrPrtry/Cd';
      ClosingBalTxt@1005 : TextConst '@@@={Locked};DAN=/Document/BkToCstmrStmt/Stmt/Bal/Amt;ENU=/Document/BkToCstmrStmt/Stmt/Bal/Amt';
      StatementDateTxt@1004 : TextConst '@@@={Locked};DAN=/Document/BkToCstmrStmt/Stmt/CreDtTm;ENU=/Document/BkToCstmrStmt/Stmt/CreDtTm';
      CrdDbtIndTxt@1003 : TextConst '@@@={Locked};DAN=/Document/BkToCstmrStmt/Stmt/Bal/CdtDbtInd;ENU=/Document/BkToCstmrStmt/Stmt/Bal/CdtDbtInd';

    LOCAL PROCEDURE PreProcess@1(BankAccReconciliationLine@1000 : Record 274);
    VAR
      DataExch@1001 : Record 1220;
      PrePostProcessXMLImport@1002 : Codeunit 1262;
    BEGIN
      DataExch.GET(BankAccReconciliationLine."Data Exch. Entry No.");
      PrePostProcessXMLImport.PreProcessFile(DataExch,StatementIDTxt);
      PrePostProcessXMLImport.PreProcessBankAccount(
        DataExch,BankAccReconciliationLine."Bank Account No.",IBANTxt,BankIDTxt,CurrencyTxt);
    END;

    LOCAL PROCEDURE PostProcess@2(BankAccReconciliationLine@1000 : Record 274);
    VAR
      DataExch@1001 : Record 1220;
      BankAccReconciliation@1002 : Record 273;
      PrePostProcessXMLImport@1004 : Codeunit 1262;
      RecRef@1003 : RecordRef;
    BEGIN
      DataExch.GET(BankAccReconciliationLine."Data Exch. Entry No.");
      BankAccReconciliation.GET(
        BankAccReconciliationLine."Statement Type",
        BankAccReconciliationLine."Bank Account No.",
        BankAccReconciliationLine."Statement No.");

      RecRef.GETTABLE(BankAccReconciliation);
      PrePostProcessXMLImport.PostProcessStatementEndingBalance(DataExch,RecRef,
        BankAccReconciliation.FIELDNO("Statement Ending Balance"),'CLBD',BalTypeTxt,ClosingBalTxt,CrdDbtIndTxt,4);
      PrePostProcessXMLImport.PostProcessStatementDate(DataExch,RecRef,BankAccReconciliation.FIELDNO("Statement Date"),
        StatementDateTxt);
    END;

    BEGIN
    END.
  }
}

