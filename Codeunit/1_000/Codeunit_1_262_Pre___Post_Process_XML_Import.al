OBJECT Codeunit 1262 Pre & Post Process XML Import
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019,NAVDK11.00.00.23019;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      DiffCurrQst@1001 : TextConst '@@@="%1 %2 = Currency Code EUR; %3 %4 = LCY Code DKK.";DAN=Det bankkontoudtog, du er ved at importere, indeholder transaktioner i %1 %2. Dette er i konflikt med %3 %4.\\Vil du forts�tte?;ENU=The bank statement that you are importing contains transactions in %1 %2. This conflicts with the %3 %4.\\Do you want to continue?';
      MissingStmtDateInDataMsg@1012 : TextConst 'DAN=Kontoudtogsdatoen blev ikke fundet i de data, der skal indl�ses.;ENU=The statement date was not found in the data to be imported.';
      MissingCrdDbtIndInDataMsg@1013 : TextConst 'DAN=Kredit-/debetindikatoren blev ikke fundet i de data, der skal indl�ses.;ENU=The credit/debit indicator was not found in the data to be imported.';
      MissingBalTypeInDataMsg@1014 : TextConst 'DAN=Balancetypen blev ikke fundet i de data, der skal indl�ses.;ENU=The balance type was not found in the data to be imported.';
      MissingClosingBalInDataMsg@1015 : TextConst 'DAN=Ultimosaldoen blev ikke fundet i de data, der skal indl�ses.;ENU=The closing balance was not found in the data to be imported.';
      MissingBankAccNoQst@1022 : TextConst 'DAN=Bankkontoen %1 har ikke et bankkontonummer.\\Vil du forts�tte?;ENU=Bank account %1 does not have a bank account number.\\Do you want to continue?';
      BankAccCurrErr@1020 : TextConst '@@@="%1 %2 = Currency Code EUR; %3 = Bank Account No.";DAN=Det bankkontoudtog, du er ved at importere, indeholder transaktioner i andre valutaer end %1 %2 p� bankkonto %3.;ENU=The bank statement that you are importing contains transactions in currencies other than the %1 %2 of bank account %3.';
      MultipleStmtErr@1019 : TextConst 'DAN=Den fil, du pr�ver at indl�se, indeholder flere bankkontoudtog.;ENU=The file that you are trying to import contains more than one bank statement.';
      MissingBankAccNoInDataErr@1018 : TextConst 'DAN=Bankkontonummeret blev ikke fundet i de data, der skal indl�ses.;ENU=The bank account number was not found in the data to be imported.';
      BankAccMismatchQst@1017 : TextConst '@@@="%1=Value; %2 = Bank account no.";DAN=Bankkontoen %1 har ikke det bankkontonummer %2, som er angivet i bankkontoudtogsfilen.\\Vil du forts�tte?;ENU=Bank account %1 does not have the bank account number %2, as specified in the bank statement file.\\Do you want to continue?';

    [Internal]
    PROCEDURE PostProcessStatementDate@3(DataExch@1002 : Record 1220;VAR RecRef@1000 : RecordRef;FieldNo@1001 : Integer;StmtDatePathFilter@1004 : Text);
    VAR
      DataExchFieldDetails@1007 : Query 1232;
    BEGIN
      SetValueFromDataExchField(DataExchFieldDetails,DataExch,StmtDatePathFilter,MissingStmtDateInDataMsg,RecRef,FieldNo);
    END;

    [Internal]
    PROCEDURE PostProcessStatementEndingBalance@11(DataExch@1004 : Record 1220;VAR RecRef@1000 : RecordRef;FieldNo@1001 : Integer;BalTypeDescriptor@1009 : Text;BalTypePathFilter@1007 : Text;BalAmtPathFilter@1010 : Text;CrdDbtIndPathFilter@1011 : Text;ParentNodeOffset@1012 : Integer);
    VAR
      DataExchFieldDetails@1008 : Query 1232;
      GroupNodeID@1002 : Text;
    BEGIN
      DataExchFieldDetails.SETRANGE(FieldValue,BalTypeDescriptor);
      IF NOT HasDataExchFieldValue(DataExchFieldDetails,DataExch."Entry No.",BalTypePathFilter) THEN BEGIN
        MESSAGE(MissingBalTypeInDataMsg);
        EXIT;
      END;

      GroupNodeID := GetSubTreeRoot(DataExchFieldDetails.Node_ID,ParentNodeOffset);
      CLEAR(DataExchFieldDetails);
      DataExchFieldDetails.SETFILTER(Node_ID,'%1',GroupNodeID + '*');
      IF NOT SetValueFromDataExchField(DataExchFieldDetails,DataExch,BalAmtPathFilter,MissingClosingBalInDataMsg,RecRef,FieldNo) THEN
        EXIT;

      IF CrdDbtIndPathFilter = '' THEN
        EXIT;

      SetValueFromDataExchField(DataExchFieldDetails,DataExch,CrdDbtIndPathFilter,MissingCrdDbtIndInDataMsg,RecRef,FieldNo);
    END;

    [External]
    PROCEDURE PreProcessBankAccount@5(DataExch@1005 : Record 1220;BankAccNo@1004 : Code[20];IBANPathFilter@1006 : Text;BankAccIDPathFilter@1000 : Text;CurrCodePathFilter@1007 : Text);
    VAR
      BankAccount@1001 : Record 270;
    BEGIN
      BankAccount.GET(BankAccNo);
      CheckBankAccNo(DataExch,BankAccount,IBANPathFilter,BankAccIDPathFilter);
      CheckBankAccCurrency(DataExch,BankAccount,CurrCodePathFilter);
    END;

    [External]
    PROCEDURE PreProcessGLAccount@1(DataExch@1005 : Record 1220;VAR GenJournalLineTemplate@1004 : Record 81;CurrencyCodePathFilter@1001 : Text);
    VAR
      GLSetup@1000 : Record 98;
      DataExchFieldDetails@1007 : Query 1232;
      StatementCurrencyCode@1006 : Code[10];
    BEGIN
      GLSetup.GET;

      DataExchFieldDetails.SETFILTER(FieldValue,'<>%1&<>%2','',GLSetup."LCY Code");
      IF HasDataExchFieldValue(DataExchFieldDetails,DataExch."Entry No.",CurrencyCodePathFilter) THEN
        IF NOT CONFIRM(STRSUBSTNO(DiffCurrQst,GenJournalLineTemplate.FIELDCAPTION("Currency Code"),
               DataExchFieldDetails.FieldValue,GLSetup.FIELDCAPTION("LCY Code"),GLSetup."LCY Code"))
        THEN
          ERROR('');

      DataExchFieldDetails.SETRANGE(FieldValue);
      IF HasDataExchFieldValue(DataExchFieldDetails,DataExch."Entry No.",CurrencyCodePathFilter) THEN BEGIN
        StatementCurrencyCode := FORMAT(DataExchFieldDetails.FieldValue,-MAXSTRLEN(GenJournalLineTemplate."Currency Code"));
        GenJournalLineTemplate.VALIDATE("Currency Code",GLSetup.GetCurrencyCode(StatementCurrencyCode));
      END;
    END;

    [External]
    PROCEDURE PreProcessFile@6(DataExch@1000 : Record 1220;StatementIdPathFilter@1001 : Text);
    BEGIN
      CheckMultipleStatements(DataExch,StatementIdPathFilter);
    END;

    LOCAL PROCEDURE GetSubTreeRoot@13(Node@1002 : Text;Distance@1001 : Integer) : Text;
    BEGIN
      EXIT(COPYSTR(Node,1,STRLEN(Node) - Distance * 4));
    END;

    LOCAL PROCEDURE CheckBankAccNo@4(DataExch@1003 : Record 1220;BankAccount@1000 : Record 270;IBANPathFilter@1001 : Text;BankAccIDPathFilter@1004 : Text);
    VAR
      DataExchFieldDetails@1002 : Query 1232;
      FileHasIBAN@1005 : Boolean;
      FileHasBankAccID@1006 : Boolean;
    BEGIN
      IF BankAccount.GetBankAccountNo = '' THEN BEGIN
        IF NOT CONFIRM(STRSUBSTNO(MissingBankAccNoQst,BankAccount."No.")) THEN
          ERROR('');
        EXIT;
      END;

      FileHasIBAN := HasDataExchFieldValue(DataExchFieldDetails,DataExch."Entry No.",IBANPathFilter);
      IF NOT FileHasIBAN AND (BankAccIDPathFilter <> '') THEN
        FileHasBankAccID := HasDataExchFieldValue(DataExchFieldDetails,DataExch."Entry No.",BankAccIDPathFilter);

      IF NOT FileHasIBAN AND NOT FileHasBankAccID THEN
        ERROR(MissingBankAccNoInDataErr);

      IF (DELCHR(DataExchFieldDetails.FieldValue,'=','- ') <> DELCHR(BankAccount."Bank Account No.",'=','- ')) AND
         (DELCHR(DataExchFieldDetails.FieldValue,'=','- ') <> DELCHR(BankAccount."Bank Branch No." + BankAccount."Bank Account No.",'=','- ')) AND
         (DELCHR(DataExchFieldDetails.FieldValue,'=','- ') <> DELCHR(BankAccount.IBAN,'=','- '))
      THEN
        IF NOT CONFIRM(STRSUBSTNO(BankAccMismatchQst,BankAccount."No.",DataExchFieldDetails.FieldValue)) THEN
          ERROR('');
    END;

    LOCAL PROCEDURE CheckBankAccCurrency@9(DataExch@1004 : Record 1220;BankAccount@1000 : Record 270;CurrCodePathFilter@1001 : Text);
    VAR
      GeneralLedgerSetup@1003 : Record 98;
      DataExchFieldDetails@1002 : Query 1232;
    BEGIN
      GeneralLedgerSetup.GET;

      DataExchFieldDetails.SETFILTER(FieldValue,'<>%1&<>%2','',GeneralLedgerSetup.GetCurrencyCode(BankAccount."Currency Code"));
      IF HasDataExchFieldValue(DataExchFieldDetails,DataExch."Entry No.",CurrCodePathFilter) THEN
        ERROR(BankAccCurrErr,BankAccount.FIELDCAPTION("Currency Code"),
          GeneralLedgerSetup.GetCurrencyCode(BankAccount."Currency Code"),BankAccount."No.");
    END;

    LOCAL PROCEDURE CheckMultipleStatements@2(DataExch@1003 : Record 1220;StatementIdPathFilter@1000 : Text);
    VAR
      DataExchFieldDetails@1001 : Query 1232;
      StmtCount@1002 : Integer;
    BEGIN
      IF HasDataExchFieldValue(DataExchFieldDetails,DataExch."Entry No.",StatementIdPathFilter) THEN BEGIN
        StmtCount := 1;
        WHILE DataExchFieldDetails.READ DO
          StmtCount += 1;
      END;

      IF StmtCount > 1 THEN
        ERROR(MultipleStmtErr);
    END;

    [External]
    PROCEDURE HasDataExchFieldValue@7(VAR DataExchFieldDetails@1003 : Query 1232;DataExchEntryNo@1001 : Integer;PathFilter@1002 : Text) : Boolean;
    BEGIN
      DataExchFieldDetails.SETRANGE(Data_Exch_No,DataExchEntryNo);
      DataExchFieldDetails.SETFILTER(Path,PathFilter);
      DataExchFieldDetails.OPEN;
      EXIT(DataExchFieldDetails.READ);
    END;

    LOCAL PROCEDURE SetValueFromDataExchField@8(VAR DataExchFieldDetails@1000 : Query 1232;DataExch@1001 : Record 1220;PathFilter@1005 : Text;NotFoundMessage@1006 : Text;RecRef@1003 : RecordRef;FieldNo@1004 : Integer) : Boolean;
    VAR
      DataExchField@1002 : Record 1221;
      TempFieldIdsToNegate@1009 : TEMPORARY Record 2000000026;
      DummyDataExchFieldMapping@1008 : Record 1225;
      ProcessDataExch@1007 : Codeunit 1201;
    BEGIN
      IF NOT HasDataExchFieldValue(DataExchFieldDetails,DataExch."Entry No.",PathFilter) THEN BEGIN
        MESSAGE(NotFoundMessage);
        EXIT(FALSE);
      END;

      DataExchField.GET(
        DataExchFieldDetails.Data_Exch_No,
        DataExchFieldDetails.Line_No,
        DataExchFieldDetails.Column_No,
        DataExchFieldDetails.Node_ID);

      DummyDataExchFieldMapping."Data Exch. Def Code" := DataExch."Data Exch. Def Code";
      DummyDataExchFieldMapping."Data Exch. Line Def Code" := DataExch."Data Exch. Line Def Code";
      DummyDataExchFieldMapping."Column No." := DataExchFieldDetails.Column_No;
      DummyDataExchFieldMapping."Field ID" := FieldNo;
      DummyDataExchFieldMapping."Table ID" := RecRef.NUMBER;

      ProcessDataExch.SetField(RecRef,DummyDataExchFieldMapping,DataExchField,TempFieldIdsToNegate);
      ProcessDataExch.NegateAmounts(RecRef,TempFieldIdsToNegate);

      RecRef.MODIFY(TRUE);
      EXIT(TRUE);
    END;

    BEGIN
    END.
  }
}

