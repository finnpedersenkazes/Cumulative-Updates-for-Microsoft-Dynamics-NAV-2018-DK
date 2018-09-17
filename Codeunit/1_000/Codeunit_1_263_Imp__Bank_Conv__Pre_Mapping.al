OBJECT Codeunit 1263 Imp. Bank Conv.-Pre-Mapping
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
            DataExch@1001 : Record 1220;
            PrePostProcessXMLImport@1000 : Codeunit 1262;
          BEGIN
            DataExch.GET("Data Exch. Entry No.");
            PrePostProcessXMLImport.PreProcessFile(DataExch,StmtNoPathFilterTxt);
            PrePostProcessXMLImport.PreProcessBankAccount(DataExch,"Bank Account No.",StmtBankAccNoPathFilterTxt,'',CurrCodePathFilterTxt);
          END;

  }
  CODE
  {
    VAR
      StmtBankAccNoPathFilterTxt@1000 : TextConst '@@@={Locked};DAN=/reportExportResponse/return/finsta/ownbankaccountidentification/bankaccount;ENU=/reportExportResponse/return/finsta/ownbankaccountidentification/bankaccount';
      CurrCodePathFilterTxt@1001 : TextConst '@@@={Locked};DAN="=''/reportExportResponse/return/finsta/statementdetails/amountdetails/currency''|=''/reportExportResponse/return/finsta/transactions/posting/currency''";ENU="=''/reportExportResponse/return/finsta/statementdetails/amountdetails/currency''|=''/reportExportResponse/return/finsta/transactions/posting/currency''"';
      StmtNoPathFilterTxt@1007 : TextConst '@@@={Locked};DAN=/reportExportResponse/return/finsta/statementdetails/statementno;ENU=/reportExportResponse/return/finsta/statementdetails/statementno';

    BEGIN
    END.
  }
}

