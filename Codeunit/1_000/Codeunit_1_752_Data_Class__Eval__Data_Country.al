OBJECT Codeunit 1752 Data Class. Eval. Data Country
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    PROCEDURE ClassifyCountrySpecificTables@3();
    VAR
      DataClassificationEvalData@1000 : Codeunit 1751;
    BEGIN
      ClassifyEmployee;
      ClassifyPayableEmployeeLedgerEntry;
      ClassifyDetailedEmployeeLedgerEntry;
      ClassifyEmployeeLedgerEntry;
      ClassifyEmployeeRelative;
      ClassifyEmployeeQualification;
      ClassifyVATReportHeader;
      DataClassificationEvalData.SetTableFieldsToNormal(DATABASE::"Employee Posting Group");
      DataClassificationEvalData.SetTableFieldsToNormal(DATABASE::"Cause of Absence");
    END;

    LOCAL PROCEDURE ClassifyPayableEmployeeLedgerEntry@47();
    VAR
      DummyPayableEmployeeLedgerEntry@1000 : Record 5224;
      DataClassificationMgt@1001 : Codeunit 1750;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Payable Employee Ledger Entry";
      DataClassificationMgt.SetTableFieldsToNormal(TableNo);
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyPayableEmployeeLedgerEntry.FIELDNO(Positive));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyPayableEmployeeLedgerEntry.FIELDNO("Currency Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyPayableEmployeeLedgerEntry.FIELDNO(Amount));
      DataClassificationMgt.SetFieldToCompanyConfidential(
        TableNo,DummyPayableEmployeeLedgerEntry.FIELDNO("Employee Ledg. Entry No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyPayableEmployeeLedgerEntry.FIELDNO("Entry No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyPayableEmployeeLedgerEntry.FIELDNO("Employee No."));
    END;

    LOCAL PROCEDURE ClassifyDetailedEmployeeLedgerEntry@48();
    VAR
      DummyDetailedEmployeeLedgerEntry@1000 : Record 5223;
      DataClassificationMgt@1001 : Codeunit 1750;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Detailed Employee Ledger Entry";
      DataClassificationMgt.SetTableFieldsToNormal(TableNo);
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Ledger Entry Amount"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Application No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(
        TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Unapplied by Entry No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO(Unapplied));
      DataClassificationMgt.SetFieldToCompanyConfidential(
        TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Applied Empl. Ledger Entry No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(
        TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Initial Document Type"));
      DataClassificationMgt.SetFieldToCompanyConfidential(
        TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Initial Entry Global Dim. 2"));
      DataClassificationMgt.SetFieldToCompanyConfidential(
        TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Initial Entry Global Dim. 1"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Credit Amount (LCY)"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Debit Amount (LCY)"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Credit Amount"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Debit Amount"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Reason Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Journal Batch Name"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Transaction No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Source Code"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("User ID"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Currency Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Employee No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Amount (LCY)"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO(Amount));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Document No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Document Type"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Posting Date"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Entry Type"));
      DataClassificationMgt.SetFieldToCompanyConfidential(
        TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Employee Ledger Entry No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyDetailedEmployeeLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyEmployeeLedgerEntry@49();
    VAR
      DummyEmployeeLedgerEntry@1000 : Record 5222;
      DataClassificationMgt@1001 : Codeunit 1750;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Employee Ledger Entry";
      DataClassificationMgt.SetTableFieldsToNormal(TableNo);
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Applying Entry"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Amount to Apply"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Payment Method Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Payment Reference"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Creditor No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("No. Series"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Message to Recipient"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Closed by Amount (LCY)"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Transaction No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Bal. Account No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Bal. Account Type"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Reason Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Journal Batch Name"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Applies-to ID"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Closed by Amount"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Closed at Date"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Closed by Entry No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO(Positive));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO(Open));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Applies-to Doc. No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Applies-to Doc. Type"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Source Code"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployeeLedgerEntry.FIELDNO("User ID"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Salespers./Purch. Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Employee Posting Group"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Dimension Set ID"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Currency Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Exported to Payment File"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO(Description));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Document No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Document Type"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Posting Date"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Employee No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyEmployeeRelative@57();
    VAR
      DummyEmployeeRelative@1000 : Record 5205;
      DataClassificationMgt@1001 : Codeunit 1750;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Employee Relative";
      DataClassificationMgt.SetTableFieldsToNormal(TableNo);
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeRelative.FIELDNO("Relative's Employee No."));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployeeRelative.FIELDNO("Phone No."));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployeeRelative.FIELDNO("Birth Date"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployeeRelative.FIELDNO("Last Name"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployeeRelative.FIELDNO("Middle Name"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployeeRelative.FIELDNO("First Name"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeRelative.FIELDNO("Relative Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeRelative.FIELDNO("Line No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeRelative.FIELDNO("Employee No."));
    END;

    LOCAL PROCEDURE ClassifyEmployeeQualification@59();
    VAR
      DummyEmployeeQualification@1000 : Record 5203;
      DataClassificationMgt@1001 : Codeunit 1750;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Employee Qualification";
      DataClassificationMgt.SetTableFieldsToNormal(TableNo);
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO("Expiration Date"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO("Employee Status"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO("Course Grade"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO(Cost));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO("Institution/Company"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO(Description));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO(Type));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO("To Date"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO("From Date"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO("Qualification Code"));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO("Line No."));
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,DummyEmployeeQualification.FIELDNO("Employee No."));
    END;

    LOCAL PROCEDURE ClassifyEmployee@61();
    VAR
      DummyEmployee@1000 : Record 5200;
      DataClassificationMgt@1001 : Codeunit 1750;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Employee;
      DataClassificationMgt.SetTableFieldsToNormal(TableNo);
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO(Image));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO(IBAN));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Bank Account No."));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Bank Branch No."));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Company E-Mail"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Fax No."));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO(Pager));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO(Extension));
      DataClassificationMgt.SetFieldToSensitive(TableNo,DummyEmployee.FIELDNO("Termination Date"));
      DataClassificationMgt.SetFieldToSensitive(TableNo,DummyEmployee.FIELDNO("Inactive Date"));
      DataClassificationMgt.SetFieldToSensitive(TableNo,DummyEmployee.FIELDNO(Status));
      DataClassificationMgt.SetFieldToSensitive(TableNo,DummyEmployee.FIELDNO("Employment Date"));
      DataClassificationMgt.SetFieldToSensitive(TableNo,DummyEmployee.FIELDNO(Gender));
      DataClassificationMgt.SetFieldToSensitive(TableNo,DummyEmployee.FIELDNO("Union Membership No."));
      DataClassificationMgt.SetFieldToSensitive(TableNo,DummyEmployee.FIELDNO("Union Code"));
      DataClassificationMgt.SetFieldToSensitive(TableNo,DummyEmployee.FIELDNO("Social Security No."));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Birth Date"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO(Picture));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("E-Mail"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Mobile Phone No."));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Phone No."));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO(County));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Post Code"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO(City));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Address 2"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO(Address));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Search Name"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Last Name"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("Middle Name"));
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyEmployee.FIELDNO("First Name"));
    END;

    LOCAL PROCEDURE ClassifyVATReportHeader@27();
    VAR
      DummyVATReportHeader@1000 : Record 740;
      DataClassificationMgt@1001 : Codeunit 1750;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"VAT Report Header";
      DataClassificationMgt.SetTableFieldsToNormal(TableNo);
      DataClassificationMgt.SetFieldToPersonal(TableNo,DummyVATReportHeader.FIELDNO("Submitted By"));
    END;

    BEGIN
    END.
  }
}

