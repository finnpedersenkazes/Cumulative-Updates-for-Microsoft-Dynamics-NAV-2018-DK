OBJECT Codeunit 1751 Data Classification Eval. Data
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {

    PROCEDURE CreateEvaluationData@1();
    VAR
      Company@1003 : Record 2000000006;
      Field@1000 : Record 2000000041;
      DataSensitivity@1002 : Record 2000000159;
      DataClassEvalDataCountry@1001 : Codeunit 1752;
    BEGIN
      IF NOT Company.GET(COMPANYNAME) THEN
        EXIT;

      IF NOT Company."Evaluation Company" THEN
        EXIT;

      Field.SETFILTER(DataClassification,STRSUBSTNO('%1|%2|%3',
          Field.DataClassification::CustomerContent,
          Field.DataClassification::EndUserIdentifiableInformation,
          Field.DataClassification::EndUserPseudonymousIdentifiers));
      IF Field.FINDSET THEN
        REPEAT
          DataSensitivity."Company Name" := COMPANYNAME;
          DataSensitivity."Table No" := Field.TableNo;
          DataSensitivity."Field No" := Field."No.";
          DataSensitivity."Data Sensitivity" := DataSensitivity."Data Sensitivity"::Unclassified;
          IF DataSensitivity.INSERT THEN;
        UNTIL Field.NEXT = 0;

      ClassifyTablesPart1;
      ClassifyTablesPart2;
      ClassifyTablesPart3;

      ClassifyTablesToNormalPart1;
      ClassifyTablesToNormalPart2;
      ClassifyTablesToNormalPart3;
      ClassifyTablesToNormalPart4;
      ClassifyTablesToNormalPart5;
      ClassifyTablesToNormalPart6;
      ClassifyTablesToNormalPart7;
      ClassifyTablesToNormalPart8;
      ClassifyTablesToNormalPart9;
      ClassifyTablesToNormalPart10;
      ClassifyTablesToNormalPart11;

      DataClassEvalDataCountry.ClassifyCountrySpecificTables;

      // All EUII and EUPI Fields are set to Personal
      DataSensitivity.SETFILTER("Data Classification",
        STRSUBSTNO('%1|%2',
          DataSensitivity."Data Classification"::EndUserIdentifiableInformation,
          DataSensitivity."Data Classification"::EndUserPseudonymousIdentifiers));
      DataSensitivity.MODIFYALL("Data Sensitivity",DataSensitivity."Data Sensitivity"::Personal);
    END;

    LOCAL PROCEDURE ClassifyTablesPart1@234();
    BEGIN
      ClassifyCreditTransferEntry;
      ClassifyActiveSession;
      ClassifyRegisteredInvtMovementHdr;
      ClassifySEPADirectDebitMandate;
      ClassifyPostedAssemblyHeader;
      ClassifyPostedInvtPickHeader;
      ClassifyPostedInvtPutawayHeader;
      ClassifyPurchInvEntityAggregate;
      ClassifySalesInvoiceEntityAggregate;
      ClassifyWarehouseEntry;
      ClassifyWarehouseJournalLine;
      ClassifyWarehouseEmployee;
      ClassifyContactAltAddress;
      ClassifyCashFlowForecastEntry;
      ClassifyDirectDebitCollection;
      ClassifyActivityLog;
      ClassifyInventoryPeriodEntry;
      ClassifyMyItem;
      ClassifyUserSecurityStatus;
      ClassifyCueSetup;
      ClassifyVATReportArchive;
      ClassifySessionEvent;
      ClassifyUserDefaultStyleSheet;
      ClassifyUserPlan;
      ClassifyUserGroupAccessControl;
      ClassifyUserGroupMember;
      ClassifyAnalysisSelectedDimension;
      ClassifyItemAnalysisViewBudgEntry;
      ClassifyItemAnalysisViewEntry;
      ClassifyTokenCache;
      ClassifyTenantLicenseState;
      ClassifyOutlookSynchUserSetup;
      ClassifyFAJournalSetup;
      ClassifyCustomizedCalendarEntry;
      ClassifyOfficeContactAssociations;
      ClassifyMyVendor;
      ClassifyItemBudgetEntry;
      ClassifyMyCustomer;
      ClassifyAccessControl;
      ClassifyUserProperty;
      ClassifyUser;
      ClassifyConfidentialInformation;
      ClassifyAttendee;
      ClassifyOverdueApprovalEntry;
      ClassifyApplicationAreaSetup;
      ClassifyDateComprRegister;
      ClassifyEmployeeAbsence;
      ClassifyWorkflowStepInstanceArchive;
      ClassifyMyJob;
      ClassifyAlternativeAddress;
      ClassifyWorkflowStepArgument;
      ClassifyPageDataPersonalization;
      ClassifySentNotificationEntry;
      ClassifyICOutboxPurchaseHeader;
      ClassifyUserMetadata;
      ClassifyNotificationEntry;
      ClassifyUserPersonalization;
      ClassifyWorkflowStepInstance;
      ClassifyWorkCenter;
      ClassifyCampaignEntry;
      ClassifySession;
      ClassifyPurchaseLineArchive;
      ClassifyPurchaseHeaderArchive;
      ClassifySalesLineArchive;
      ClassifySalesHeaderArchive;
      ClassifyApprovalCommentLine;
      ClassifyCommunicationMethod;
      ClassifySavedSegmentCriteria;
      ClassifyOpportunityEntry;
      ClassifyOpportunity;
      ClassifyContactProfileAnswer;
      ClassifyTodo;
      ClassifyMarketingSetup;
      ClassifySegmentLine;
      ClassifyLoggedSegment;
      ClassifyServiceInvoiceLine;
      ClassifyServiceInvoiceHeader;
      ClassifyServiceShipmentLine;
      ClassifyServiceShipmentHeader;
      ClassifyJobQueueLogEntry;
      ClassifyJobQueueEntry;
      ClassifyInteractionLogEntry;
      ClassifyPostedApprovalCommentLine;
      ClassifyPostedApprovalEntry;
      ClassifyContact;
      ClassifyApprovalEntry;
      ClassifyContractChangeLog;
      ClassifyServiceContractHeader;
      ClassifyHandledICInboxPurchHeader;
      ClassifyHandledICInboxSalesHeader;
      ClassifyICInboxPurchaseHeader;
      ClassifyICInboxSalesHeader;
      ClassifyHandledICOutboxPurchHdr;
    END;

    LOCAL PROCEDURE ClassifyTablesPart2@235();
    BEGIN
      ClassifyServiceItemLog;
      ClassifyServiceCrMemoHeader;
      ClassifyServiceRegister;
      ClassifyUserPageMetadata;
      ClassifyICPartner;
      ClassifyChangeLogEntry;
      ClassifyInsCoverageLedgerEntry;
      ClassifyLoanerEntry;
      ClassifyServiceDocumentLog;
      ClassifyWarrantyLedgerEntry;
      ClassifyServiceLedgerEntry;
      ClassifyTermsAndConditionsState;
      ClassifyServiceLine;
      ClassifyServiceHeader;
      ClassifyDetailedVendorLedgEntry;
      ClassifyDetailedCustLedgEntry;
      ClassifyPostedPaymentReconLine;
      ClassifyAppliedPaymentEntry;
      ClassifySelectedDimension;
      ClassifyConfigLine;
      ClassifyItemApplicationEntryHistory;
      ClassifyConfigPackageTable;
      ClassifyItemApplicationEntry;
      ClassifyReservationEntry;
      ClassifyCalendarEvent;
      ClassifyCapacityLedgerEntry;
      ClassifyPayableVendorLedgerEntry;
      ClassifyReminderFinChargeEntry;
      ClassifyPositivePayEntryDetail;
      ClassifySalesShipmentLine;
      ClassifyICOutboxSalesHeader;
      ClassifyIssuedFinChargeMemoHeader;
      ClassifyFinanceChargeMemoHeader;
      ClassifyFiledServiceContractHeader;
      ClassifyBinCreationWorksheetLine;
      ClassifyIssuedReminderHeader;
      ClassifyReminderHeader;
      ClassifyDirectDebitCollectionEntry;
      ClassifyValueEntry;
      ClassifyCustomerBankAccount;
      ClassifyCreditTransferRegister;
      ClassifyPhysInventoryLedgerEntry;
      ClassifyBankAccReconciliationLine;
      ClassifyTimeSheetLine;
      ClassifyCheckLedgerEntry;
      ClassifyBankAccountLedgerEntry;
      ClassifyBookingSync;
      ClassifyExchangeSync;
      ClassifyO365SalesDocument;
      ClassifyVATEntry;
      ClassifyWarehouseActivityHeader;
      ClassifyVATRegistrationLog;
      ClassifyRequisitionLine;
      ClassifyServiceCrMemoLine;
      ClassifyJobRegister;
      ClassifyResourceRegister;
      ClassifyReturnReceiptLine;
      ClassifyReturnReceiptHeader;
      ClassifyOrderAddress;
      ClassifyShiptoAddress;
      ClassifyReturnShipmentLine;
      ClassifyReturnShipmentHeader;
      ClassifyResLedgerEntry;
      ClassifyInsuranceRegister;
      ClassifyContractGainLossEntry;
      ClassifyMyTimeSheets;
      ClassifyCustomReportLayout;
      ClassifyCostBudgetRegister;
      ClassifyCostBudgetEntry;
      ClassifyCostAllocationTarget;
      ClassifyCostAllocationSource;
      ClassifyCostRegister;
      ClassifyCostEntry;
      ClassifyCostType;
      ClassifyReversalEntry;
      ClassifyJobLedgerEntry;
      ClassifyTimeSheetLineArchive;
      ClassifyJob;
      ClassifyResCapacityEntry;
      ClassifyResource;
      ClassifyIncomingDocument;
      ClassifyWarehouseRegister;
      ClassifyPurchCrMemoLine;
      ClassifyPurchCrMemoHdr;
      ClassifyPurchInvLine;
      ClassifyPurchInvHeader;
      ClassifyPurchRcptLine;
      ClassifyPurchRcptHeader;
      ClassifySalesCrMemoLine;
      ClassifySalesCrMemoHeader;
      ClassifySalesInvoiceLine;
      ClassifySalesInvoiceHeader;
      ClassifyMaintenanceLedgerEntry;
      ClassifySalesShipmentHeader;
      ClassifyFARegister;
      ClassifyMaintenanceRegistration;
      ClassifyWorkflowStepArgumentArchive;
      ClassifyGLBudgetEntry;
      ClassifyUserSetup;
      ClassifyFALedgerEntry;
    END;

    LOCAL PROCEDURE ClassifyTablesPart3@238();
    BEGIN
      ClassifyHandledICOutboxSalesHeader;
      ClassifyJobPlanningLine;
      ClassifyGenJournalLine;
      ClassifyPrinterSelection;
      ClassifyTimeSheetChartSetup;
      ClassifyUserTimeRegister;
      ClassifyItemRegister;
      ClassifyGLRegister;
      ClassifyPurchaseLine;
      ClassifyPurchaseHeader;
      ClassifySalesLine;
      ClassifySalesHeader;
      ClassifyTimeSheetHeaderArchive;
      ClassifyItemLedgerEntry;
      ClassifyTimeSheetHeader;
      ClassifyItem;
      ClassifyVendorLedgerEntry;
      ClassifyVendor;
      ClassifyCustLedgerEntry;
      ClassifyMyAccount;
      ClassifyCustomer;
      ClassifyGLEntry;
      ClassifySalespersonPurchaser;
      ClassifyManufacturingUserTemplate;
      ClassifyVendorBankAccount;
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart1@232();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Payment Terms");
      SetTableFieldsToNormal(DATABASE::Currency);
      SetTableFieldsToNormal(DATABASE::"Finance Charge Terms");
      SetTableFieldsToNormal(DATABASE::"Customer Price Group");
      SetTableFieldsToNormal(DATABASE::"Standard Text");
      SetTableFieldsToNormal(DATABASE::Language);
      SetTableFieldsToNormal(DATABASE::"Country/Region");
      SetTableFieldsToNormal(DATABASE::"Shipment Method");
      SetTableFieldsToNormal(DATABASE::"Country/Region Translation");
      SetTableFieldsToNormal(DATABASE::Location);
      SetTableFieldsToNormal(DATABASE::"G/L Account");
      SetTableFieldsToNormal(DATABASE::"Cust. Invoice Disc.");
      SetTableFieldsToNormal(DATABASE::"Vendor Invoice Disc.");
      SetTableFieldsToNormal(DATABASE::"Item Translation");
      SetTableFieldsToNormal(DATABASE::"Sales Line");
      SetTableFieldsToNormal(DATABASE::"Purchase Line");
      SetTableFieldsToNormal(DATABASE::"Rounding Method");
      SetTableFieldsToNormal(DATABASE::"Purch. Comment Line");
      SetTableFieldsToNormal(DATABASE::"Sales Comment Line");
      SetTableFieldsToNormal(DATABASE::"Accounting Period");
      SetTableFieldsToNormal(DATABASE::"Batch Processing Parameter");
      SetTableFieldsToNormal(DATABASE::"Batch Processing Parameter Map");
      SetTableFieldsToNormal(DATABASE::"Document Sending Profile");
      SetTableFieldsToNormal(DATABASE::"Electronic Document Format");
      SetTableFieldsToNormal(DATABASE::"Report Selections");
      SetTableFieldsToNormal(DATABASE::"Company Information");
      SetTableFieldsToNormal(DATABASE::"Gen. Journal Template");
      SetTableFieldsToNormal(DATABASE::"Item Journal Template");
      SetTableFieldsToNormal(DATABASE::"Item Journal Line");
      SetTableFieldsToNormal(DATABASE::"Acc. Schedule Name");
      SetTableFieldsToNormal(DATABASE::"Acc. Schedule Line");
      SetTableFieldsToNormal(DATABASE::"Exch. Rate Adjmt. Reg.");
      SetTableFieldsToNormal(DATABASE::"BOM Component");
      SetTableFieldsToNormal(DATABASE::"Customer Posting Group");
      SetTableFieldsToNormal(DATABASE::"Vendor Posting Group");
      SetTableFieldsToNormal(DATABASE::"Inventory Posting Group");
      SetTableFieldsToNormal(DATABASE::"G/L Budget Name");
      SetTableFieldsToNormal(DATABASE::"Comment Line");
      SetTableFieldsToNormal(DATABASE::"General Ledger Setup");
      SetTableFieldsToNormal(DATABASE::"Item Vendor");
      SetTableFieldsToNormal(DATABASE::"Incoming Documents Setup");
      SetTableFieldsToNormal(DATABASE::"Acc. Sched. KPI Web Srv. Setup");
      SetTableFieldsToNormal(DATABASE::"Acc. Sched. KPI Web Srv. Line");
      SetTableFieldsToNormal(DATABASE::"Unlinked Attachment");
      SetTableFieldsToNormal(DATABASE::"ECSL VAT Report Line Relation");
      SetTableFieldsToNormal(DATABASE::"Resource Group");
      SetTableFieldsToNormal(DATABASE::"Standard Sales Code");
      SetTableFieldsToNormal(DATABASE::"Standard Sales Line");
      SetTableFieldsToNormal(DATABASE::"Standard Customer Sales Code");
      SetTableFieldsToNormal(DATABASE::"Standard Purchase Code");
      SetTableFieldsToNormal(DATABASE::"Standard Purchase Line");
      SetTableFieldsToNormal(DATABASE::"Standard Vendor Purchase Code");
      SetTableFieldsToNormal(DATABASE::"G/L Account Where-Used");
      SetTableFieldsToNormal(DATABASE::"Work Type");
      SetTableFieldsToNormal(DATABASE::"Resource Price");
      SetTableFieldsToNormal(DATABASE::"Resource Cost");
      SetTableFieldsToNormal(DATABASE::"Unit of Measure");
      SetTableFieldsToNormal(DATABASE::"Resource Unit of Measure");
      SetTableFieldsToNormal(DATABASE::"Res. Journal Template");
      SetTableFieldsToNormal(DATABASE::"Res. Journal Line");
      SetTableFieldsToNormal(DATABASE::"Job Posting Group");
      SetTableFieldsToNormal(DATABASE::"Job Journal Template");
      SetTableFieldsToNormal(DATABASE::"Job Journal Line");
      SetTableFieldsToNormal(DATABASE::"Business Unit");
      SetTableFieldsToNormal(DATABASE::"Gen. Jnl. Allocation");
      SetTableFieldsToNormal(DATABASE::"Post Code");
      SetTableFieldsToNormal(DATABASE::"Source Code");
      SetTableFieldsToNormal(DATABASE::"Reason Code");
      SetTableFieldsToNormal(DATABASE::"Gen. Journal Batch");
      SetTableFieldsToNormal(DATABASE::"Item Journal Batch");
      SetTableFieldsToNormal(DATABASE::"Res. Journal Batch");
      SetTableFieldsToNormal(DATABASE::"Job Journal Batch");
      SetTableFieldsToNormal(DATABASE::"Source Code Setup");
      SetTableFieldsToNormal(DATABASE::"Req. Wksh. Template");
      SetTableFieldsToNormal(DATABASE::"Requisition Wksh. Name");
      SetTableFieldsToNormal(DATABASE::"Intrastat Setup");
      SetTableFieldsToNormal(DATABASE::"VAT Reg. No. Srv Config");
      SetTableFieldsToNormal(DATABASE::"Gen. Business Posting Group");
      SetTableFieldsToNormal(DATABASE::"Gen. Product Posting Group");
      SetTableFieldsToNormal(DATABASE::"General Posting Setup");
      SetTableFieldsToNormal(DATABASE::"VAT Statement Template");
      SetTableFieldsToNormal(DATABASE::"VAT Statement Line");
      SetTableFieldsToNormal(DATABASE::"VAT Statement Name");
      SetTableFieldsToNormal(DATABASE::"Transaction Type");
      SetTableFieldsToNormal(DATABASE::"Transport Method");
      SetTableFieldsToNormal(DATABASE::"Tariff Number");
      SetTableFieldsToNormal(DATABASE::"Intrastat Jnl. Template");
      SetTableFieldsToNormal(DATABASE::"Intrastat Jnl. Batch");
      SetTableFieldsToNormal(DATABASE::"Intrastat Jnl. Line");
      SetTableFieldsToNormal(DATABASE::"Currency Amount");
      SetTableFieldsToNormal(DATABASE::"Customer Amount");
      SetTableFieldsToNormal(DATABASE::"Vendor Amount");
      SetTableFieldsToNormal(DATABASE::"Item Amount");
      SetTableFieldsToNormal(DATABASE::"G/L Account Net Change");
      SetTableFieldsToNormal(DATABASE::"Bank Account");
      SetTableFieldsToNormal(DATABASE::"Bank Acc. Reconciliation");
      SetTableFieldsToNormal(DATABASE::"Bank Account Statement");
      SetTableFieldsToNormal(DATABASE::"Bank Account Statement Line");
      SetTableFieldsToNormal(DATABASE::"Bank Account Posting Group");
      SetTableFieldsToNormal(DATABASE::"Job Journal Quantity");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart2@244();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Extended Text Header");
      SetTableFieldsToNormal(DATABASE::"Extended Text Line");
      SetTableFieldsToNormal(DATABASE::Area);
      SetTableFieldsToNormal(DATABASE::"Transaction Specification");
      SetTableFieldsToNormal(DATABASE::Territory);
      SetTableFieldsToNormal(DATABASE::"Payment Method");
      SetTableFieldsToNormal(DATABASE::"VAT Amount Line");
      SetTableFieldsToNormal(DATABASE::"Shipping Agent");
      SetTableFieldsToNormal(DATABASE::"Reminder Terms");
      SetTableFieldsToNormal(DATABASE::"Reminder Level");
      SetTableFieldsToNormal(DATABASE::"Reminder Text");
      SetTableFieldsToNormal(DATABASE::"Reminder Line");
      SetTableFieldsToNormal(DATABASE::"Issued Reminder Line");
      SetTableFieldsToNormal(DATABASE::"Reminder Comment Line");
      SetTableFieldsToNormal(DATABASE::"Finance Charge Text");
      SetTableFieldsToNormal(DATABASE::"Finance Charge Memo Line");
      SetTableFieldsToNormal(DATABASE::"Issued Fin. Charge Memo Line");
      SetTableFieldsToNormal(DATABASE::"Fin. Charge Comment Line");
      SetTableFieldsToNormal(DATABASE::"No. Series");
      SetTableFieldsToNormal(DATABASE::"No. Series Line");
      SetTableFieldsToNormal(DATABASE::"No. Series Relationship");
      SetTableFieldsToNormal(DATABASE::"Sales & Receivables Setup");
      SetTableFieldsToNormal(DATABASE::"Purchases & Payables Setup");
      SetTableFieldsToNormal(DATABASE::"Inventory Setup");
      SetTableFieldsToNormal(DATABASE::"Resources Setup");
      SetTableFieldsToNormal(DATABASE::"Jobs Setup");
      SetTableFieldsToNormal(DATABASE::"Tax Area Translation");
      SetTableFieldsToNormal(DATABASE::"Tax Area");
      SetTableFieldsToNormal(DATABASE::"Tax Area Line");
      SetTableFieldsToNormal(DATABASE::"Tax Jurisdiction");
      SetTableFieldsToNormal(DATABASE::"Tax Group");
      SetTableFieldsToNormal(DATABASE::"Tax Detail");
      SetTableFieldsToNormal(DATABASE::"VAT Business Posting Group");
      SetTableFieldsToNormal(DATABASE::"VAT Product Posting Group");
      SetTableFieldsToNormal(DATABASE::"VAT Posting Setup");
      SetTableFieldsToNormal(DATABASE::"Tax Setup");
      SetTableFieldsToNormal(DATABASE::"Tax Jurisdiction Translation");
      SetTableFieldsToNormal(DATABASE::"Currency for Fin. Charge Terms");
      SetTableFieldsToNormal(DATABASE::"Currency for Reminder Level");
      SetTableFieldsToNormal(DATABASE::"Currency Exchange Rate");
      SetTableFieldsToNormal(DATABASE::"Column Layout Name");
      SetTableFieldsToNormal(DATABASE::"Column Layout");
      SetTableFieldsToNormal(DATABASE::"Resource Price Change");
      SetTableFieldsToNormal(DATABASE::"Tracking Specification");
      SetTableFieldsToNormal(DATABASE::"Customer Discount Group");
      SetTableFieldsToNormal(DATABASE::"Item Discount Group");
      SetTableFieldsToNormal(DATABASE::"Acc. Sched. Cell Value");
      SetTableFieldsToNormal(DATABASE::Dimension);
      SetTableFieldsToNormal(DATABASE::"Dimension Value");
      SetTableFieldsToNormal(DATABASE::"Dimension Combination");
      SetTableFieldsToNormal(DATABASE::"Dimension Value Combination");
      SetTableFieldsToNormal(DATABASE::"Default Dimension");
      SetTableFieldsToNormal(DATABASE::"Default Dimension Priority");
      SetTableFieldsToNormal(DATABASE::"Dimension Set ID Filter Line");
      SetTableFieldsToNormal(DATABASE::"ECSL VAT Report Line");
      SetTableFieldsToNormal(DATABASE::"Analysis View");
      SetTableFieldsToNormal(DATABASE::"Analysis View Filter");
      SetTableFieldsToNormal(DATABASE::"G/L Account (Analysis View)");
      SetTableFieldsToNormal(DATABASE::"Object Translation");
      SetTableFieldsToNormal(DATABASE::"Report List Translation");
      SetTableFieldsToNormal(DATABASE::"VAT Registration No. Format");
      SetTableFieldsToNormal(DATABASE::"Dimension Translation");
      SetTableFieldsToNormal(DATABASE::"Availability at Date");
      SetTableFieldsToNormal(DATABASE::"XBRL Taxonomy");
      SetTableFieldsToNormal(DATABASE::"XBRL Taxonomy Line");
      SetTableFieldsToNormal(DATABASE::"XBRL Comment Line");
      SetTableFieldsToNormal(DATABASE::"XBRL G/L Map Line");
      SetTableFieldsToNormal(DATABASE::"XBRL Rollup Line");
      SetTableFieldsToNormal(DATABASE::"XBRL Schema");
      SetTableFieldsToNormal(DATABASE::"XBRL Linkbase");
      SetTableFieldsToNormal(DATABASE::"XBRL Taxonomy Label");
      SetTableFieldsToNormal(DATABASE::"Change Log Setup");
      SetTableFieldsToNormal(DATABASE::"Change Log Setup (Table)");
      SetTableFieldsToNormal(DATABASE::"Change Log Setup (Field)");
      SetTableFieldsToNormal(DATABASE::"XBRL Line Constant");
      SetTableFieldsToNormal(DATABASE::"IC G/L Account");
      SetTableFieldsToNormal(DATABASE::"IC Dimension");
      SetTableFieldsToNormal(DATABASE::"IC Dimension Value");
      SetTableFieldsToNormal(DATABASE::"IC Outbox Transaction");
      SetTableFieldsToNormal(DATABASE::"IC Outbox Jnl. Line");
      SetTableFieldsToNormal(DATABASE::"Handled IC Outbox Trans.");
      SetTableFieldsToNormal(DATABASE::"Handled IC Outbox Jnl. Line");
      SetTableFieldsToNormal(DATABASE::"IC Inbox Transaction");
      SetTableFieldsToNormal(DATABASE::"IC Inbox Jnl. Line");
      SetTableFieldsToNormal(DATABASE::"Handled IC Inbox Trans.");
      SetTableFieldsToNormal(DATABASE::"Handled IC Inbox Jnl. Line");
      SetTableFieldsToNormal(DATABASE::"IC Inbox/Outbox Jnl. Line Dim.");
      SetTableFieldsToNormal(DATABASE::"IC Comment Line");
      SetTableFieldsToNormal(DATABASE::"IC Outbox Sales Line");
      SetTableFieldsToNormal(DATABASE::"IC Outbox Purchase Line");
      SetTableFieldsToNormal(DATABASE::"Handled IC Outbox Sales Line");
      SetTableFieldsToNormal(DATABASE::"Handled IC Outbox Purch. Line");
      SetTableFieldsToNormal(DATABASE::"IC Inbox Sales Line");
      SetTableFieldsToNormal(DATABASE::"IC Inbox Purchase Line");
      SetTableFieldsToNormal(DATABASE::"Handled IC Inbox Sales Line");
      SetTableFieldsToNormal(DATABASE::"Handled IC Inbox Purch. Line");
      SetTableFieldsToNormal(DATABASE::"IC Document Dimension");
      SetTableFieldsToNormal(DATABASE::"Sales Prepayment %");
      SetTableFieldsToNormal(DATABASE::"Purchase Prepayment %");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart3@246();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Payment Term Translation");
      SetTableFieldsToNormal(DATABASE::"Shipment Method Translation");
      SetTableFieldsToNormal(DATABASE::"Payment Method Translation");
      SetTableFieldsToNormal(DATABASE::"Job Queue Category");
      SetTableFieldsToNormal(DATABASE::"Dimension Set Tree Node");
      SetTableFieldsToNormal(DATABASE::"Business Chart Map");
      SetTableFieldsToNormal(DATABASE::"VAT Rate Change Setup");
      SetTableFieldsToNormal(DATABASE::"VAT Rate Change Conversion");
      SetTableFieldsToNormal(DATABASE::"VAT Clause");
      SetTableFieldsToNormal(DATABASE::"VAT Clause Translation");
      SetTableFieldsToNormal(DATABASE::"G/L Account Category");
      SetTableFieldsToNormal(DATABASE::"Error Message");
      SetTableFieldsToNormal(DATABASE::"Standard Address");
      SetTableFieldsToNormal(DATABASE::"VAT Statement Report Line");
      SetTableFieldsToNormal(DATABASE::"VAT Report Setup");
      SetTableFieldsToNormal(DATABASE::"VAT Report Line Relation");
      SetTableFieldsToNormal(DATABASE::"VAT Report Error Log");
      SetTableFieldsToNormal(DATABASE::"VAT Reports Configuration");
      SetTableFieldsToNormal(DATABASE::"Standard General Journal");
      SetTableFieldsToNormal(DATABASE::"Standard General Journal Line");
      SetTableFieldsToNormal(DATABASE::"Standard Item Journal");
      SetTableFieldsToNormal(DATABASE::"Standard Item Journal Line");
      SetTableFieldsToNormal(DATABASE::"Online Bank Acc. Link");
      SetTableFieldsToNormal(DATABASE::"Certificate of Supply");
      SetTableFieldsToNormal(DATABASE::"Online Map Setup");
      SetTableFieldsToNormal(DATABASE::"Online Map Parameter Setup");
      SetTableFieldsToNormal(DATABASE::Geolocation);
      SetTableFieldsToNormal(DATABASE::"Cash Flow Account");
      SetTableFieldsToNormal(DATABASE::"Cash Flow Account Comment");
      SetTableFieldsToNormal(DATABASE::"Cash Flow Setup");
      SetTableFieldsToNormal(DATABASE::"Cash Flow Worksheet Line");
      SetTableFieldsToNormal(DATABASE::"Cash Flow Manual Revenue");
      SetTableFieldsToNormal(DATABASE::"Cash Flow Manual Expense");
      SetTableFieldsToNormal(DATABASE::"Cortana Intelligence");
      SetTableFieldsToNormal(DATABASE::"Cash Flow Report Selection");
      SetTableFieldsToNormal(DATABASE::"Social Listening Search Topic");
      SetTableFieldsToNormal(DATABASE::"Excel Template Storage");
      SetTableFieldsToNormal(DATABASE::"Assembly Line");
      SetTableFieldsToNormal(DATABASE::"Assemble-to-Order Link");
      SetTableFieldsToNormal(DATABASE::"Assembly Setup");
      SetTableFieldsToNormal(DATABASE::"Assembly Comment Line");
      SetTableFieldsToNormal(DATABASE::"Posted Assembly Line");
      SetTableFieldsToNormal(DATABASE::"Posted Assemble-to-Order Link");
      SetTableFieldsToNormal(DATABASE::"Time Sheet Detail");
      SetTableFieldsToNormal(DATABASE::"Time Sheet Comment Line");
      SetTableFieldsToNormal(DATABASE::"Time Sheet Detail Archive");
      SetTableFieldsToNormal(DATABASE::"Time Sheet Cmt. Line Archive");
      SetTableFieldsToNormal(DATABASE::"Document Search Result");
      SetTableFieldsToNormal(DATABASE::"Job Task");
      SetTableFieldsToNormal(DATABASE::"Job Task Dimension");
      SetTableFieldsToNormal(DATABASE::"Job WIP Method");
      SetTableFieldsToNormal(DATABASE::"Job WIP Warning");
      SetTableFieldsToNormal(DATABASE::"Job Resource Price");
      SetTableFieldsToNormal(DATABASE::"Job Item Price");
      SetTableFieldsToNormal(DATABASE::"Job G/L Account Price");
      SetTableFieldsToNormal(DATABASE::"Job Usage Link");
      SetTableFieldsToNormal(DATABASE::"Job WIP Total");
      SetTableFieldsToNormal(DATABASE::"Job Planning Line Invoice");
      SetTableFieldsToNormal(DATABASE::"Job Planning Line - Calendar");
      SetTableFieldsToNormal(DATABASE::"Additional Fee Setup");
      SetTableFieldsToNormal(DATABASE::"Sorting Table");
      SetTableFieldsToNormal(DATABASE::"Reminder Terms Translation");
      SetTableFieldsToNormal(DATABASE::"Line Fee Note on Report Hist.");
      SetTableFieldsToNormal(DATABASE::"Payment Service Setup");
      SetTableFieldsToNormal(DATABASE::"Payment Reporting Argument");
      SetTableFieldsToNormal(DATABASE::"Cost Journal Template");
      SetTableFieldsToNormal(DATABASE::"Cost Journal Line");
      SetTableFieldsToNormal(DATABASE::"Cost Journal Batch");
      SetTableFieldsToNormal(DATABASE::"Cost Accounting Setup");
      SetTableFieldsToNormal(DATABASE::"Cost Budget Name");
      SetTableFieldsToNormal(DATABASE::"Cost Center");
      SetTableFieldsToNormal(DATABASE::"Cost Object");
      SetTableFieldsToNormal(DATABASE::"Bank Export/Import Setup");
      SetTableFieldsToNormal(DATABASE::"Data Exchange Type");
      SetTableFieldsToNormal(DATABASE::"Intermediate Data Import");
      SetTableFieldsToNormal(DATABASE::"Data Exch.");
      SetTableFieldsToNormal(DATABASE::"Data Exch. Field");
      SetTableFieldsToNormal(DATABASE::"Data Exch. Def");
      SetTableFieldsToNormal(DATABASE::"Data Exch. Column Def");
      SetTableFieldsToNormal(DATABASE::"Data Exch. Mapping");
      SetTableFieldsToNormal(DATABASE::"Data Exch. Field Mapping");
      SetTableFieldsToNormal(DATABASE::"Payment Export Data");
      SetTableFieldsToNormal(DATABASE::"Data Exch. Line Def");
      SetTableFieldsToNormal(DATABASE::"Payment Jnl. Export Error Text");
      SetTableFieldsToNormal(DATABASE::"Payment Export Remittance Text");
      SetTableFieldsToNormal(DATABASE::"Transformation Rule");
      SetTableFieldsToNormal(DATABASE::"Positive Pay Header");
      SetTableFieldsToNormal(DATABASE::"Positive Pay Detail");
      SetTableFieldsToNormal(DATABASE::"Positive Pay Footer");
      SetTableFieldsToNormal(DATABASE::"Bank Stmt Multiple Match Line");
      SetTableFieldsToNormal(DATABASE::"Text-to-Account Mapping");
      SetTableFieldsToNormal(DATABASE::"Bank Pmt. Appl. Rule");
      SetTableFieldsToNormal(DATABASE::"Bank Data Conv. Bank");
      SetTableFieldsToNormal(DATABASE::"Service Password");
      SetTableFieldsToNormal(DATABASE::"OCR Service Document Template");
      SetTableFieldsToNormal(DATABASE::"Bank Clearing Standard");
      SetTableFieldsToNormal(DATABASE::"Bank Data Conversion Pmt. Type");
      SetTableFieldsToNormal(DATABASE::"Outstanding Bank Transaction");
      SetTableFieldsToNormal(DATABASE::"Payment Application Proposal");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart4@247();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Posted Payment Recon. Hdr");
      SetTableFieldsToNormal(DATABASE::"Payment Matching Details");
      SetTableFieldsToNormal(DATABASE::"Mini Customer Template");
      SetTableFieldsToNormal(DATABASE::"Item Template");
      SetTableFieldsToNormal(DATABASE::"Dimensions Template");
      SetTableFieldsToNormal(DATABASE::"O365 Device Setup Instructions");
      SetTableFieldsToNormal(DATABASE::"O365 Getting Started Page Data");
      SetTableFieldsToNormal(DATABASE::"Chart Definition");
      SetTableFieldsToNormal(DATABASE::"Last Used Chart");
      SetTableFieldsToNormal(DATABASE::"Trial Balance Setup");
      SetTableFieldsToNormal(DATABASE::"Activities Cue");
      SetTableFieldsToNormal(DATABASE::"Service Connection");
      SetTableFieldsToNormal(DATABASE::"Net Promoter Score Setup");
      SetTableFieldsToNormal(DATABASE::"Product Video Category");
      SetTableFieldsToNormal(DATABASE::Workflow);
      SetTableFieldsToNormal(DATABASE::"Workflow Step");
      SetTableFieldsToNormal(DATABASE::"Workflow - Table Relation");
      SetTableFieldsToNormal(DATABASE::"Workflow Table Relation Value");
      SetTableFieldsToNormal(DATABASE::"Workflow Category");
      SetTableFieldsToNormal(DATABASE::"WF Event/Response Combination");
      SetTableFieldsToNormal(DATABASE::"Dynamic Request Page Entity");
      SetTableFieldsToNormal(DATABASE::"Dynamic Request Page Field");
      SetTableFieldsToNormal(DATABASE::"Notification Context");
      SetTableFieldsToNormal(DATABASE::"Workflow Event");
      SetTableFieldsToNormal(DATABASE::"Workflow Response");
      SetTableFieldsToNormal(DATABASE::"Workflow Event Queue");
      SetTableFieldsToNormal(DATABASE::"Workflow Rule");
      SetTableFieldsToNormal(DATABASE::"Workflow - Record Change");
      SetTableFieldsToNormal(DATABASE::"Workflow Record Change Archive");
      SetTableFieldsToNormal(DATABASE::"Workflow User Group");
      SetTableFieldsToNormal(DATABASE::"Flow Service Configuration");
      SetTableFieldsToNormal(DATABASE::"Flow User Environment Config");
      SetTableFieldsToNormal(DATABASE::"Restricted Record");
      SetTableFieldsToNormal(DATABASE::"Office Add-in Context");
      SetTableFieldsToNormal(DATABASE::"Office Add-in Setup");
      SetTableFieldsToNormal(DATABASE::"Office Invoice");
      SetTableFieldsToNormal(DATABASE::"Office Add-in");
      SetTableFieldsToNormal(DATABASE::"Office Admin. Credentials");
      SetTableFieldsToNormal(DATABASE::"Office Job Journal");
      SetTableFieldsToNormal(DATABASE::"Office Document Selection");
      SetTableFieldsToNormal(DATABASE::"Office Suggested Line Item");
      SetTableFieldsToNormal(DATABASE::"Invoiced Booking Item");
      SetTableFieldsToNormal(DATABASE::"Curr. Exch. Rate Update Setup");
      SetTableFieldsToNormal(DATABASE::"Import G/L Transaction");
      SetTableFieldsToNormal(DATABASE::"Deferral Template");
      SetTableFieldsToNormal(DATABASE::"Deferral Header");
      SetTableFieldsToNormal(DATABASE::"Deferral Line");
      SetTableFieldsToNormal(DATABASE::"Posted Deferral Header");
      SetTableFieldsToNormal(DATABASE::"Posted Deferral Line");
      SetTableFieldsToNormal(DATABASE::"Data Migration Error");
      SetTableFieldsToNormal(DATABASE::"Data Migration Parameters");
      SetTableFieldsToNormal(DATABASE::"Data Migration Status");
      SetTableFieldsToNormal(DATABASE::"Data Migrator Registration");
      SetTableFieldsToNormal(DATABASE::"Data Migration Entity");
      SetTableFieldsToNormal(DATABASE::"Assisted Company Setup Status");
      SetTableFieldsToNormal(DATABASE::"Assisted Setup");
      SetTableFieldsToNormal(DATABASE::"Encrypted Key/Value");
      SetTableFieldsToNormal(DATABASE::"Data Migration Setup");
      SetTableFieldsToNormal(DATABASE::"Assisted Setup Log");
      SetTableFieldsToNormal(DATABASE::"Aggregated Assisted Setup");
      SetTableFieldsToNormal(DATABASE::"Assisted Setup Icons");
      SetTableFieldsToNormal(DATABASE::"Business Unit Setup");
      SetTableFieldsToNormal(DATABASE::"Business Unit Information");
      SetTableFieldsToNormal(DATABASE::"Consolidation Account");
      SetTableFieldsToNormal(DATABASE::"Business Setup");
      SetTableFieldsToNormal(DATABASE::"Business Setup Icon");
      SetTableFieldsToNormal(DATABASE::"VAT Setup Posting Groups");
      SetTableFieldsToNormal(DATABASE::"VAT Assisted Setup Templates");
      SetTableFieldsToNormal(DATABASE::"VAT Assisted Setup Bus. Grp.");
      SetTableFieldsToNormal(DATABASE::"Cancelled Document");
      SetTableFieldsToNormal(DATABASE::"Time Series Forecast");
      SetTableFieldsToNormal(DATABASE::"Azure Machine Learning Usage");
      SetTableFieldsToNormal(DATABASE::"Image Analysis Setup");
      SetTableFieldsToNormal(DATABASE::"Sales Document Icon");
      SetTableFieldsToNormal(DATABASE::"O365 Customer");
      SetTableFieldsToNormal(DATABASE::"O365 Sales Initial Setup");
      SetTableFieldsToNormal(DATABASE::"O365 Field Excel Mapping");
      SetTableFieldsToNormal(DATABASE::"O365 Cust. Invoice Discount");
      SetTableFieldsToNormal(DATABASE::"O365 HTML Template");
      SetTableFieldsToNormal(DATABASE::"O365 Coupon Claim");
      SetTableFieldsToNormal(DATABASE::"O365 Coupon Claim Doc. Link");
      SetTableFieldsToNormal(DATABASE::"O365 Posted Coupon Claim");
      SetTableFieldsToNormal(DATABASE::"O365 Email Setup");
      SetTableFieldsToNormal(DATABASE::"O365 Payment Service Logo");
      SetTableFieldsToNormal(DATABASE::"O365 Brand Color");
      SetTableFieldsToNormal(DATABASE::"O365 Social Network");
      SetTableFieldsToNormal(DATABASE::"O365 Settings Menu");
      SetTableFieldsToNormal(DATABASE::"O365 Country/Region");
      SetTableFieldsToNormal(DATABASE::"O365 Payment Terms");
      SetTableFieldsToNormal(DATABASE::"O365 Payment Method");
      SetTableFieldsToNormal(DATABASE::"O365 Document Sent History");
      SetTableFieldsToNormal(DATABASE::"O365 C2Graph Event Settings");
      SetTableFieldsToNormal(DATABASE::"O365 Sales Event");
      SetTableFieldsToNormal(DATABASE::"O365 Sales Graph");
      SetTableFieldsToNormal(DATABASE::"O365 Sales Invoice Document");
      SetTableFieldsToNormal(DATABASE::"Native - Export Invoices");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart5@248();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Native - Payment");
      SetTableFieldsToNormal(DATABASE::"Native - API Tax Setup");
      SetTableFieldsToNormal(DATABASE::"Contact Alt. Addr. Date Range");
      SetTableFieldsToNormal(DATABASE::"Business Relation");
      SetTableFieldsToNormal(DATABASE::"Contact Business Relation");
      SetTableFieldsToNormal(DATABASE::"Mailing Group");
      SetTableFieldsToNormal(DATABASE::"Contact Mailing Group");
      SetTableFieldsToNormal(DATABASE::"Industry Group");
      SetTableFieldsToNormal(DATABASE::"Contact Industry Group");
      SetTableFieldsToNormal(DATABASE::"Web Source");
      SetTableFieldsToNormal(DATABASE::"Contact Web Source");
      SetTableFieldsToNormal(DATABASE::"Rlshp. Mgt. Comment Line");
      SetTableFieldsToNormal(DATABASE::Attachment);
      SetTableFieldsToNormal(DATABASE::"Interaction Group");
      SetTableFieldsToNormal(DATABASE::"Interaction Template");
      SetTableFieldsToNormal(DATABASE::"Job Responsibility");
      SetTableFieldsToNormal(DATABASE::"Contact Job Responsibility");
      SetTableFieldsToNormal(DATABASE::Salutation);
      SetTableFieldsToNormal(DATABASE::"Salutation Formula");
      SetTableFieldsToNormal(DATABASE::"Organizational Level");
      SetTableFieldsToNormal(DATABASE::Campaign);
      SetTableFieldsToNormal(DATABASE::"Campaign Status");
      SetTableFieldsToNormal(DATABASE::"Delivery Sorter");
      SetTableFieldsToNormal(DATABASE::"Segment Header");
      SetTableFieldsToNormal(DATABASE::"Segment History");
      SetTableFieldsToNormal(DATABASE::Activity);
      SetTableFieldsToNormal(DATABASE::"Activity Step");
      SetTableFieldsToNormal(DATABASE::Team);
      SetTableFieldsToNormal(DATABASE::"Team Salesperson");
      SetTableFieldsToNormal(DATABASE::"Contact Duplicate");
      SetTableFieldsToNormal(DATABASE::"Cont. Duplicate Search String");
      SetTableFieldsToNormal(DATABASE::"Profile Questionnaire Header");
      SetTableFieldsToNormal(DATABASE::"Profile Questionnaire Line");
      SetTableFieldsToNormal(DATABASE::"Sales Cycle");
      SetTableFieldsToNormal(DATABASE::"Sales Cycle Stage");
      SetTableFieldsToNormal(DATABASE::"Close Opportunity Code");
      SetTableFieldsToNormal(DATABASE::"Duplicate Search String Setup");
      SetTableFieldsToNormal(DATABASE::"Segment Wizard Filter");
      SetTableFieldsToNormal(DATABASE::"Segment Criteria Line");
      SetTableFieldsToNormal(DATABASE::"Saved Segment Criteria Line");
      SetTableFieldsToNormal(DATABASE::"Contact Value");
      SetTableFieldsToNormal(DATABASE::"RM Matrix Management");
      SetTableFieldsToNormal(DATABASE::"Interaction Tmpl. Language");
      SetTableFieldsToNormal(DATABASE::"Segment Interaction Language");
      SetTableFieldsToNormal(DATABASE::"Customer Template");
      SetTableFieldsToNormal(DATABASE::Rating);
      SetTableFieldsToNormal(DATABASE::"Interaction Template Setup");
      SetTableFieldsToNormal(DATABASE::"Current Salesperson");
      SetTableFieldsToNormal(DATABASE::"Purch. Comment Line Archive");
      SetTableFieldsToNormal(DATABASE::"Sales Comment Line Archive");
      SetTableFieldsToNormal(DATABASE::"Deferral Header Archive");
      SetTableFieldsToNormal(DATABASE::"Deferral Line Archive");
      SetTableFieldsToNormal(DATABASE::"Integration Record");
      SetTableFieldsToNormal(DATABASE::"Integration Record Archive");
      SetTableFieldsToNormal(DATABASE::"Alternative Address");
      SetTableFieldsToNormal(DATABASE::Qualification);
      SetTableFieldsToNormal(DATABASE::Relative);
      SetTableFieldsToNormal(DATABASE::"Human Resource Comment Line");
      SetTableFieldsToNormal(DATABASE::Union);
      SetTableFieldsToNormal(DATABASE::"Cause of Inactivity");
      SetTableFieldsToNormal(DATABASE::"Employment Contract");
      SetTableFieldsToNormal(DATABASE::"Employee Statistics Group");
      SetTableFieldsToNormal(DATABASE::"Misc. Article");
      SetTableFieldsToNormal(DATABASE::"Misc. Article Information");
      SetTableFieldsToNormal(DATABASE::Confidential);
      SetTableFieldsToNormal(DATABASE::"Grounds for Termination");
      SetTableFieldsToNormal(DATABASE::"Human Resources Setup");
      SetTableFieldsToNormal(DATABASE::"HR Confidential Comment Line");
      SetTableFieldsToNormal(DATABASE::"Human Resource Unit of Measure");
      SetTableFieldsToNormal(DATABASE::"Outlook Synch. Entity");
      SetTableFieldsToNormal(DATABASE::"Outlook Synch. Entity Element");
      SetTableFieldsToNormal(DATABASE::"Outlook Synch. Filter");
      SetTableFieldsToNormal(DATABASE::"Outlook Synch. Field");
      SetTableFieldsToNormal(DATABASE::"Outlook Synch. Lookup Name");
      SetTableFieldsToNormal(DATABASE::"Outlook Synch. Option Correl.");
      SetTableFieldsToNormal(DATABASE::"Outlook Synch. Dependency");
      SetTableFieldsToNormal(DATABASE::"Exchange Folder");
      SetTableFieldsToNormal(DATABASE::"Exchange Service Setup");
      SetTableFieldsToNormal(DATABASE::"CRM Redirect");
      SetTableFieldsToNormal(DATABASE::"CRM Integration Record");
      SetTableFieldsToNormal(DATABASE::"CRM Option Mapping");
      SetTableFieldsToNormal(DATABASE::"Integration Table Mapping");
      SetTableFieldsToNormal(DATABASE::"Integration Field Mapping");
      SetTableFieldsToNormal(DATABASE::"Temp Integration Field Mapping");
      SetTableFieldsToNormal(DATABASE::"Integration Synch. Job");
      SetTableFieldsToNormal(DATABASE::"Integration Synch. Job Errors");
      SetTableFieldsToNormal(DATABASE::"CRM Systemuser");
      SetTableFieldsToNormal(DATABASE::"CRM Account");
      SetTableFieldsToNormal(DATABASE::"CRM Contact");
      SetTableFieldsToNormal(DATABASE::"CRM Opportunity");
      SetTableFieldsToNormal(DATABASE::"CRM Post");
      SetTableFieldsToNormal(DATABASE::"CRM Transactioncurrency");
      SetTableFieldsToNormal(DATABASE::"CRM Pricelevel");
      SetTableFieldsToNormal(DATABASE::"CRM Productpricelevel");
      SetTableFieldsToNormal(DATABASE::"CRM Product");
      SetTableFieldsToNormal(DATABASE::"CRM Incident");
      SetTableFieldsToNormal(DATABASE::"CRM Incidentresolution");
      SetTableFieldsToNormal(DATABASE::"CRM Quote");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart6@249();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"CRM Quotedetail");
      SetTableFieldsToNormal(DATABASE::"CRM Salesorder");
      SetTableFieldsToNormal(DATABASE::"CRM Salesorderdetail");
      SetTableFieldsToNormal(DATABASE::"CRM Invoice");
      SetTableFieldsToNormal(DATABASE::"CRM Invoicedetail");
      SetTableFieldsToNormal(DATABASE::"CRM Contract");
      SetTableFieldsToNormal(DATABASE::"CRM Team");
      SetTableFieldsToNormal(DATABASE::"CRM Customeraddress");
      SetTableFieldsToNormal(DATABASE::"CRM Uom");
      SetTableFieldsToNormal(DATABASE::"CRM Uomschedule");
      SetTableFieldsToNormal(DATABASE::"CRM Organization");
      SetTableFieldsToNormal(DATABASE::"CRM Businessunit");
      SetTableFieldsToNormal(DATABASE::"CRM Discount");
      SetTableFieldsToNormal(DATABASE::"CRM Discounttype");
      SetTableFieldsToNormal(DATABASE::"CRM Account Statistics");
      SetTableFieldsToNormal(DATABASE::"CRM NAV Connection");
      SetTableFieldsToNormal(DATABASE::"CRM Synch. Job Status Cue");
      SetTableFieldsToNormal(DATABASE::"CRM Full Synch. Review Line");
      SetTableFieldsToNormal(DATABASE::"Ext Txt ID Integration Record");
      SetTableFieldsToNormal(DATABASE::"Item Variant");
      SetTableFieldsToNormal(DATABASE::"Unit of Measure Translation");
      SetTableFieldsToNormal(DATABASE::"Item Unit of Measure");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Line");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Component");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Routing Line");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Capacity Need");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Routing Tool");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Routing Personnel");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Rtng Qlty Meas.");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Comment Line");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Rtng Comment Line");
      SetTableFieldsToNormal(DATABASE::"Prod. Order Comp. Cmt Line");
      SetTableFieldsToNormal(DATABASE::"Planning Error Log");
      SetTableFieldsToNormal(DATABASE::"Graph Contact");
      SetTableFieldsToNormal(DATABASE::"Graph Integration Record");
      SetTableFieldsToNormal(DATABASE::"Graph Integration Rec. Archive");
      SetTableFieldsToNormal(DATABASE::"Graph Subscription");
      SetTableFieldsToNormal(DATABASE::"Graph Business Profile");
      SetTableFieldsToNormal(DATABASE::"API Entities Setup");
      SetTableFieldsToNormal(DATABASE::"Sales Invoice Line Aggregate");
      SetTableFieldsToNormal(DATABASE::"Purch. Inv. Line Aggregate");
      SetTableFieldsToNormal(DATABASE::"Journal Lines Entity Setup");
      SetTableFieldsToNormal(DATABASE::"Account Entity Setup");
      SetTableFieldsToNormal(DATABASE::"Aged Report Entity");
      SetTableFieldsToNormal(DATABASE::"Acc. Schedule Line Entity");
      SetTableFieldsToNormal(DATABASE::"Unplanned Demand");
      SetTableFieldsToNormal(DATABASE::"Inventory Page Data");
      SetTableFieldsToNormal(DATABASE::"Timeline Event");
      SetTableFieldsToNormal(DATABASE::"Timeline Event Change");
      SetTableFieldsToNormal(DATABASE::"Fixed Asset");
      SetTableFieldsToNormal(DATABASE::"FA Setup");
      SetTableFieldsToNormal(DATABASE::"FA Posting Type Setup");
      SetTableFieldsToNormal(DATABASE::"FA Posting Group");
      SetTableFieldsToNormal(DATABASE::"FA Class");
      SetTableFieldsToNormal(DATABASE::"FA Subclass");
      SetTableFieldsToNormal(DATABASE::"FA Location");
      SetTableFieldsToNormal(DATABASE::"Depreciation Book");
      SetTableFieldsToNormal(DATABASE::"FA Depreciation Book");
      SetTableFieldsToNormal(DATABASE::"FA Allocation");
      SetTableFieldsToNormal(DATABASE::"FA Journal Template");
      SetTableFieldsToNormal(DATABASE::"FA Journal Batch");
      SetTableFieldsToNormal(DATABASE::"FA Journal Line");
      SetTableFieldsToNormal(DATABASE::"FA Reclass. Journal Template");
      SetTableFieldsToNormal(DATABASE::"FA Reclass. Journal Batch");
      SetTableFieldsToNormal(DATABASE::"FA Reclass. Journal Line");
      SetTableFieldsToNormal(DATABASE::Maintenance);
      SetTableFieldsToNormal(DATABASE::Insurance);
      SetTableFieldsToNormal(DATABASE::"Insurance Type");
      SetTableFieldsToNormal(DATABASE::"Insurance Journal Template");
      SetTableFieldsToNormal(DATABASE::"Insurance Journal Batch");
      SetTableFieldsToNormal(DATABASE::"Insurance Journal Line");
      SetTableFieldsToNormal(DATABASE::"Main Asset Component");
      SetTableFieldsToNormal(DATABASE::"Depreciation Table Header");
      SetTableFieldsToNormal(DATABASE::"Depreciation Table Line");
      SetTableFieldsToNormal(DATABASE::"FA Posting Type");
      SetTableFieldsToNormal(DATABASE::"FA Date Type");
      SetTableFieldsToNormal(DATABASE::"FA Matrix Posting Type");
      SetTableFieldsToNormal(DATABASE::"Total Value Insured");
      SetTableFieldsToNormal(DATABASE::"Stockkeeping Unit");
      SetTableFieldsToNormal(DATABASE::"Stockkeeping Unit Comment Line");
      SetTableFieldsToNormal(DATABASE::"Responsibility Center");
      SetTableFieldsToNormal(DATABASE::"Item Substitution");
      SetTableFieldsToNormal(DATABASE::"Substitution Condition");
      SetTableFieldsToNormal(DATABASE::"Item Cross Reference");
      SetTableFieldsToNormal(DATABASE::"Nonstock Item");
      SetTableFieldsToNormal(DATABASE::"Nonstock Item Setup");
      SetTableFieldsToNormal(DATABASE::Manufacturer);
      SetTableFieldsToNormal(DATABASE::Purchasing);
      SetTableFieldsToNormal(DATABASE::"Item Category");
      SetTableFieldsToNormal(DATABASE::"Product Group");
      SetTableFieldsToNormal(DATABASE::"Transfer Line");
      SetTableFieldsToNormal(DATABASE::"Transfer Route");
      SetTableFieldsToNormal(DATABASE::"Transfer Shipment Header");
      SetTableFieldsToNormal(DATABASE::"Transfer Shipment Line");
      SetTableFieldsToNormal(DATABASE::"Transfer Receipt Header");
      SetTableFieldsToNormal(DATABASE::"Transfer Receipt Line");
      SetTableFieldsToNormal(DATABASE::"Inventory Comment Line");
      SetTableFieldsToNormal(DATABASE::"Warehouse Request");
      SetTableFieldsToNormal(DATABASE::"Warehouse Activity Line");
      SetTableFieldsToNormal(DATABASE::"Whse. Cross-Dock Opportunity");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart7@250();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Warehouse Setup");
      SetTableFieldsToNormal(DATABASE::"Warehouse Comment Line");
      SetTableFieldsToNormal(DATABASE::"Warehouse Source Filter");
      SetTableFieldsToNormal(DATABASE::"Registered Whse. Activity Line");
      SetTableFieldsToNormal(DATABASE::"Shipping Agent Services");
      SetTableFieldsToNormal(DATABASE::"Item Charge");
      SetTableFieldsToNormal(DATABASE::"Item Charge Assignment (Purch)");
      SetTableFieldsToNormal(DATABASE::"Item Charge Assignment (Sales)");
      SetTableFieldsToNormal(DATABASE::"Inventory Posting Setup");
      SetTableFieldsToNormal(DATABASE::"Inventory Period");
      SetTableFieldsToNormal(DATABASE::"G/L - Item Ledger Relation");
      SetTableFieldsToNormal(DATABASE::"Availability Calc. Overview");
      SetTableFieldsToNormal(DATABASE::"Standard Cost Worksheet Name");
      SetTableFieldsToNormal(DATABASE::"Standard Cost Worksheet");
      SetTableFieldsToNormal(DATABASE::"Inventory Report Header");
      SetTableFieldsToNormal(DATABASE::"Average Cost Calc. Overview");
      SetTableFieldsToNormal(DATABASE::"Memoized Result");
      SetTableFieldsToNormal(DATABASE::"Item Availability by Date");
      SetTableFieldsToNormal(DATABASE::"BOM Warning Log");
      SetTableFieldsToNormal(DATABASE::"Service Item Line");
      SetTableFieldsToNormal(DATABASE::"Service Order Type");
      SetTableFieldsToNormal(DATABASE::"Service Item Group");
      SetTableFieldsToNormal(DATABASE::"Service Cost");
      SetTableFieldsToNormal(DATABASE::"Service Comment Line");
      SetTableFieldsToNormal(DATABASE::"Service Hour");
      SetTableFieldsToNormal(DATABASE::"Service Mgt. Setup");
      SetTableFieldsToNormal(DATABASE::Loaner);
      SetTableFieldsToNormal(DATABASE::"Fault Area");
      SetTableFieldsToNormal(DATABASE::"Symptom Code");
      SetTableFieldsToNormal(DATABASE::"Fault Reason Code");
      SetTableFieldsToNormal(DATABASE::"Fault Code");
      SetTableFieldsToNormal(DATABASE::"Resolution Code");
      SetTableFieldsToNormal(DATABASE::"Fault/Resol. Cod. Relationship");
      SetTableFieldsToNormal(DATABASE::"Fault Area/Symptom Code");
      SetTableFieldsToNormal(DATABASE::"Repair Status");
      SetTableFieldsToNormal(DATABASE::"Service Status Priority Setup");
      SetTableFieldsToNormal(DATABASE::"Service Shelf");
      SetTableFieldsToNormal(DATABASE::"Service Email Queue");
      SetTableFieldsToNormal(DATABASE::"Service Document Register");
      SetTableFieldsToNormal(DATABASE::"Service Item");
      SetTableFieldsToNormal(DATABASE::"Service Item Component");
      SetTableFieldsToNormal(DATABASE::"Troubleshooting Header");
      SetTableFieldsToNormal(DATABASE::"Troubleshooting Line");
      SetTableFieldsToNormal(DATABASE::"Troubleshooting Setup");
      SetTableFieldsToNormal(DATABASE::"Service Order Allocation");
      SetTableFieldsToNormal(DATABASE::"Resource Location");
      SetTableFieldsToNormal(DATABASE::"Work-Hour Template");
      SetTableFieldsToNormal(DATABASE::"Skill Code");
      SetTableFieldsToNormal(DATABASE::"Resource Skill");
      SetTableFieldsToNormal(DATABASE::"Service Zone");
      SetTableFieldsToNormal(DATABASE::"Resource Service Zone");
      SetTableFieldsToNormal(DATABASE::"Service Contract Line");
      SetTableFieldsToNormal(DATABASE::"Contract Group");
      SetTableFieldsToNormal(DATABASE::"Service Contract Template");
      SetTableFieldsToNormal(DATABASE::"Filed Contract Line");
      SetTableFieldsToNormal(DATABASE::"Contract/Service Discount");
      SetTableFieldsToNormal(DATABASE::"Service Contract Account Group");
      SetTableFieldsToNormal(DATABASE::"Service Shipment Item Line");
      SetTableFieldsToNormal(DATABASE::"Standard Service Code");
      SetTableFieldsToNormal(DATABASE::"Standard Service Line");
      SetTableFieldsToNormal(DATABASE::"Standard Service Item Gr. Code");
      SetTableFieldsToNormal(DATABASE::"Service Price Group");
      SetTableFieldsToNormal(DATABASE::"Serv. Price Group Setup");
      SetTableFieldsToNormal(DATABASE::"Service Price Adjustment Group");
      SetTableFieldsToNormal(DATABASE::"Serv. Price Adjustment Detail");
      SetTableFieldsToNormal(DATABASE::"Service Line Price Adjmt.");
      SetTableFieldsToNormal(DATABASE::"Azure AD App Setup");
      SetTableFieldsToNormal(DATABASE::"Azure AD Mgt. Setup");
      SetTableFieldsToNormal(DATABASE::"Item Tracking Code");
      SetTableFieldsToNormal(DATABASE::"Serial No. Information");
      SetTableFieldsToNormal(DATABASE::"Lot No. Information");
      SetTableFieldsToNormal(DATABASE::"Item Tracking Comment");
      SetTableFieldsToNormal(DATABASE::"Whse. Item Tracking Line");
      SetTableFieldsToNormal(DATABASE::"Return Reason");
      SetTableFieldsToNormal(DATABASE::"Returns-Related Document");
      SetTableFieldsToNormal(DATABASE::"Exchange Contact");
      SetTableFieldsToNormal(DATABASE::"Booking Service");
      SetTableFieldsToNormal(DATABASE::"Booking Mailbox");
      SetTableFieldsToNormal(DATABASE::"Booking Staff");
      SetTableFieldsToNormal(DATABASE::"Booking Service Mapping");
      SetTableFieldsToNormal(DATABASE::"Booking Item");
      SetTableFieldsToNormal(DATABASE::"Tenant Web Service OData");
      SetTableFieldsToNormal(DATABASE::"Tenant Web Service Columns");
      SetTableFieldsToNormal(DATABASE::"Tenant Web Service Filter");
      SetTableFieldsToNormal(DATABASE::"Booking Mgr. Setup");
      SetTableFieldsToNormal(DATABASE::"Sales Price");
      SetTableFieldsToNormal(DATABASE::"Sales Line Discount");
      SetTableFieldsToNormal(DATABASE::"Purchase Price");
      SetTableFieldsToNormal(DATABASE::"Purchase Line Discount");
      SetTableFieldsToNormal(DATABASE::"Sales Price Worksheet");
      SetTableFieldsToNormal(DATABASE::"Campaign Target Group");
      SetTableFieldsToNormal(DATABASE::"Analysis Field Value");
      SetTableFieldsToNormal(DATABASE::"Analysis Report Name");
      SetTableFieldsToNormal(DATABASE::"Analysis Line Template");
      SetTableFieldsToNormal(DATABASE::"Analysis Type");
      SetTableFieldsToNormal(DATABASE::"Analysis Line");
      SetTableFieldsToNormal(DATABASE::"Analysis Column Template");
      SetTableFieldsToNormal(DATABASE::"Analysis Column");
      SetTableFieldsToNormal(DATABASE::"Item Budget Name");
      SetTableFieldsToNormal(DATABASE::"Item Analysis View");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart8@251();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Item Analysis View Filter");
      SetTableFieldsToNormal(DATABASE::Zone);
      SetTableFieldsToNormal(DATABASE::"Bin Content");
      SetTableFieldsToNormal(DATABASE::"Bin Type");
      SetTableFieldsToNormal(DATABASE::"Warehouse Class");
      SetTableFieldsToNormal(DATABASE::"Special Equipment");
      SetTableFieldsToNormal(DATABASE::"Put-away Template Header");
      SetTableFieldsToNormal(DATABASE::"Put-away Template Line");
      SetTableFieldsToNormal(DATABASE::"Warehouse Journal Template");
      SetTableFieldsToNormal(DATABASE::"Warehouse Receipt Line");
      SetTableFieldsToNormal(DATABASE::"Posted Whse. Receipt Line");
      SetTableFieldsToNormal(DATABASE::"Warehouse Shipment Line");
      SetTableFieldsToNormal(DATABASE::"Posted Whse. Shipment Line");
      SetTableFieldsToNormal(DATABASE::"Whse. Put-away Request");
      SetTableFieldsToNormal(DATABASE::"Whse. Pick Request");
      SetTableFieldsToNormal(DATABASE::"Whse. Worksheet Line");
      SetTableFieldsToNormal(DATABASE::"Whse. Worksheet Name");
      SetTableFieldsToNormal(DATABASE::"Whse. Worksheet Template");
      SetTableFieldsToNormal(DATABASE::"Whse. Internal Put-away Line");
      SetTableFieldsToNormal(DATABASE::"Whse. Internal Pick Line");
      SetTableFieldsToNormal(DATABASE::"Bin Template");
      SetTableFieldsToNormal(DATABASE::"Bin Creation Wksh. Template");
      SetTableFieldsToNormal(DATABASE::"Bin Creation Wksh. Name");
      SetTableFieldsToNormal(DATABASE::"Posted Invt. Put-away Line");
      SetTableFieldsToNormal(DATABASE::"Posted Invt. Pick Line");
      SetTableFieldsToNormal(DATABASE::"Registered Invt. Movement Line");
      SetTableFieldsToNormal(DATABASE::"Internal Movement Line");
      SetTableFieldsToNormal(DATABASE::Bin);
      SetTableFieldsToNormal(DATABASE::"Phys. Invt. Item Selection");
      SetTableFieldsToNormal(DATABASE::"Phys. Invt. Counting Period");
      SetTableFieldsToNormal(DATABASE::"Item Attribute");
      SetTableFieldsToNormal(DATABASE::"Item Attribute Value");
      SetTableFieldsToNormal(DATABASE::"Item Attribute Translation");
      SetTableFieldsToNormal(DATABASE::"Item Attr. Value Translation");
      SetTableFieldsToNormal(DATABASE::"Item Attribute Value Selection");
      SetTableFieldsToNormal(DATABASE::"Item Attribute Value Mapping");
      SetTableFieldsToNormal(DATABASE::"Base Calendar");
      SetTableFieldsToNormal(DATABASE::"Base Calendar Change");
      SetTableFieldsToNormal(DATABASE::"Customized Calendar Change");
      SetTableFieldsToNormal(DATABASE::"Where Used Base Calendar");
      SetTableFieldsToNormal(DATABASE::"Miniform Header");
      SetTableFieldsToNormal(DATABASE::"Miniform Line");
      SetTableFieldsToNormal(DATABASE::"Miniform Function Group");
      SetTableFieldsToNormal(DATABASE::"Miniform Function");
      SetTableFieldsToNormal(DATABASE::"Item Identifier");
      SetTableFieldsToNormal(DATABASE::"MS-Event Emitter Event Codes");
      SetTableFieldsToNormal(DATABASE::"MS-QBO Customer");
      SetTableFieldsToNormal(DATABASE::"MS-QBO Item");
      SetTableFieldsToNormal(DATABASE::"MS-QBO Invoice");
      SetTableFieldsToNormal(DATABASE::"MS-QBO Modified Field List");
      SetTableFieldsToNormal(DATABASE::"MS-QBO Setup");
      SetTableFieldsToNormal(DATABASE::"MS-QBO Synchronization Error");
      SetTableFieldsToNormal(DATABASE::"MS-QBO Start Sync. Service");
      SetTableFieldsToNormal(DATABASE::"MS-QBO Failed Syncs");
      SetTableFieldsToNormal(DATABASE::"MS- PayPal Standard Account");
      SetTableFieldsToNormal(DATABASE::"MS- PayPal Standard Template");
      SetTableFieldsToNormal(DATABASE::"MS- PayPal Transaction");
      SetTableFieldsToNormal(DATABASE::"MS-QBD Setup");
      SetTableFieldsToNormal(DATABASE::"Dimensions Field Map");
      SetTableFieldsToNormal(DATABASE::"Record Set Definition");
      SetTableFieldsToNormal(DATABASE::"Record Set Tree");
      SetTableFieldsToNormal(DATABASE::"Config. Questionnaire");
      SetTableFieldsToNormal(DATABASE::"Config. Question Area");
      SetTableFieldsToNormal(DATABASE::"Config. Question");
      SetTableFieldsToNormal(DATABASE::"Config. Package Record");
      SetTableFieldsToNormal(DATABASE::"Config. Package Data");
      SetTableFieldsToNormal(DATABASE::"Config. Package Field");
      SetTableFieldsToNormal(DATABASE::"Config. Package Error");
      SetTableFieldsToNormal(DATABASE::"Config. Template Header");
      SetTableFieldsToNormal(DATABASE::"Config. Template Line");
      SetTableFieldsToNormal(DATABASE::"Config. Tmpl. Selection Rules");
      SetTableFieldsToNormal(DATABASE::"Config. Selection");
      SetTableFieldsToNormal(DATABASE::"Config. Package");
      SetTableFieldsToNormal(DATABASE::"Config. Related Field");
      SetTableFieldsToNormal(DATABASE::"Config. Related Table");
      SetTableFieldsToNormal(DATABASE::"Config. Package Filter");
      SetTableFieldsToNormal(DATABASE::"Config. Setup");
      SetTableFieldsToNormal(DATABASE::"Config. Field Mapping");
      SetTableFieldsToNormal(DATABASE::"Config. Table Processing Rule");
      SetTableFieldsToNormal(DATABASE::"Config. Record For Processing");
      SetTableFieldsToNormal(DATABASE::"User Group");
      SetTableFieldsToNormal(DATABASE::"User Group Permission Set");
      SetTableFieldsToNormal(DATABASE::"Plan Permission Set");
      SetTableFieldsToNormal(DATABASE::"User Group Plan");
      SetTableFieldsToNormal(DATABASE::"Team Member Cue");
      SetTableFieldsToNormal(DATABASE::"Warehouse Basic Cue");
      SetTableFieldsToNormal(DATABASE::"Warehouse WMS Cue");
      SetTableFieldsToNormal(DATABASE::"Service Cue");
      SetTableFieldsToNormal(DATABASE::"Sales Cue");
      SetTableFieldsToNormal(DATABASE::"Finance Cue");
      SetTableFieldsToNormal(DATABASE::"Purchase Cue");
      SetTableFieldsToNormal(DATABASE::"Manufacturing Cue");
      SetTableFieldsToNormal(DATABASE::"Job Cue");
      SetTableFieldsToNormal(DATABASE::"Warehouse Worker WMS Cue");
      SetTableFieldsToNormal(DATABASE::"Administration Cue");
      SetTableFieldsToNormal(DATABASE::"SB Owner Cue");
      SetTableFieldsToNormal(DATABASE::"RapidStart Services Cue");
      SetTableFieldsToNormal(DATABASE::"User Security Status");
      SetTableFieldsToNormal(DATABASE::"Relationship Mgmt. Cue");
      SetTableFieldsToNormal(DATABASE::"O365 Sales Cue");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart9@260();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Accounting Services Cue");
      SetTableFieldsToNormal(DATABASE::"Autocomplete Address");
      SetTableFieldsToNormal(DATABASE::"Postcode Service Config");
      SetTableFieldsToNormal(DATABASE::TempStack);
      SetTableFieldsToNormal(DATABASE::"Profile Resource Import/Export");
      SetTableFieldsToNormal(DATABASE::"Generic Chart Setup");
      SetTableFieldsToNormal(DATABASE::"Generic Chart Filter");
      SetTableFieldsToNormal(DATABASE::"Generic Chart Y-Axis");
      SetTableFieldsToNormal(DATABASE::"Generic Chart Query Column");
      SetTableFieldsToNormal(DATABASE::"Terms And Conditions");
      SetTableFieldsToNormal(DATABASE::"Media Repository");
      SetTableFieldsToNormal(DATABASE::"Email Item");
      SetTableFieldsToNormal(DATABASE::"Email Parameter");
      SetTableFieldsToNormal(DATABASE::"XML Schema");
      SetTableFieldsToNormal(DATABASE::"XML Schema Element");
      SetTableFieldsToNormal(DATABASE::"XML Schema Restriction");
      SetTableFieldsToNormal(DATABASE::"Referenced XML Schema");
      SetTableFieldsToNormal(DATABASE::"Report Layout Selection");
      SetTableFieldsToNormal(DATABASE::"Report Layout Update Log");
      SetTableFieldsToNormal(DATABASE::"Custom Report Selection");
      SetTableFieldsToNormal(DATABASE::"Table Filter");
      SetTableFieldsToNormal(DATABASE::"Web Service Aggregate");
      SetTableFieldsToNormal(DATABASE::"CAL Test Suite");
      SetTableFieldsToNormal(DATABASE::"CAL Test Line");
      SetTableFieldsToNormal(DATABASE::"CAL Test Codeunit");
      SetTableFieldsToNormal(DATABASE::"CAL Test Enabled Codeunit");
      SetTableFieldsToNormal(DATABASE::"CAL Test Method");
      SetTableFieldsToNormal(DATABASE::"CAL Test Result");
      SetTableFieldsToNormal(DATABASE::"CAL Test Coverage Map");
      SetTableFieldsToNormal(DATABASE::"Semi-Manual Test Wizard");
      SetTableFieldsToNormal(DATABASE::"Semi-Manual Execution Log");
      SetTableFieldsToNormal(DATABASE::"Work Shift");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart10@261();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Shop Calendar");
      SetTableFieldsToNormal(DATABASE::"Shop Calendar Working Days");
      SetTableFieldsToNormal(DATABASE::"Shop Calendar Holiday");
      SetTableFieldsToNormal(DATABASE::"Work Center Group");
      SetTableFieldsToNormal(DATABASE::"Machine Center");
      SetTableFieldsToNormal(DATABASE::Stop);
      SetTableFieldsToNormal(DATABASE::Scrap);
      SetTableFieldsToNormal(DATABASE::"Routing Header");
      SetTableFieldsToNormal(DATABASE::"Routing Line");
      SetTableFieldsToNormal(DATABASE::"Manufacturing Setup");
      SetTableFieldsToNormal(DATABASE::"Manufacturing Comment Line");
      SetTableFieldsToNormal(DATABASE::"Production BOM Header");
      SetTableFieldsToNormal(DATABASE::"Production BOM Line");
      SetTableFieldsToNormal(DATABASE::Family);
      SetTableFieldsToNormal(DATABASE::"Family Line");
      SetTableFieldsToNormal(DATABASE::"Routing Comment Line");
      SetTableFieldsToNormal(DATABASE::"Production BOM Comment Line");
      SetTableFieldsToNormal(DATABASE::"Routing Link");
      SetTableFieldsToNormal(DATABASE::"Standard Task");
      SetTableFieldsToNormal(DATABASE::"Production BOM Version");
      SetTableFieldsToNormal(DATABASE::"Capacity Unit of Measure");
      SetTableFieldsToNormal(DATABASE::"Standard Task Tool");
      SetTableFieldsToNormal(DATABASE::"Standard Task Personnel");
      SetTableFieldsToNormal(DATABASE::"Standard Task Description");
      SetTableFieldsToNormal(DATABASE::"Standard Task Quality Measure");
      SetTableFieldsToNormal(DATABASE::"Quality Measure");
      SetTableFieldsToNormal(DATABASE::"Routing Version");
      SetTableFieldsToNormal(DATABASE::"Production Matrix BOM Line");
      SetTableFieldsToNormal(DATABASE::"Where-Used Line");
      SetTableFieldsToNormal(DATABASE::"Sales Planning Line");
      SetTableFieldsToNormal(DATABASE::"Routing Tool");
      SetTableFieldsToNormal(DATABASE::"Routing Personnel");
      SetTableFieldsToNormal(DATABASE::"Routing Quality Measure");
      SetTableFieldsToNormal(DATABASE::"Planning Component");
      SetTableFieldsToNormal(DATABASE::"Planning Routing Line");
      SetTableFieldsToNormal(DATABASE::"Item Availability Line");
      SetTableFieldsToNormal(DATABASE::"Registered Absence");
      SetTableFieldsToNormal(DATABASE::"Planning Assignment");
      SetTableFieldsToNormal(DATABASE::"Production Forecast Name");
      SetTableFieldsToNormal(DATABASE::"Inventory Profile");
      SetTableFieldsToNormal(DATABASE::"Untracked Planning Element");
      SetTableFieldsToNormal(DATABASE::"Capacity Constrained Resource");
      SetTableFieldsToNormal(DATABASE::"Order Promising Setup");
      SetTableFieldsToNormal(DATABASE::"Order Promising Line");
      SetTableFieldsToNormal(DATABASE::"Incoming Document Attachment");
      SetTableFieldsToNormal(DATABASE::"Inc. Doc. Attachment Overview");
      SetTableFieldsToNormal(DATABASE::"License Agreement");
      SetTableFieldsToNormal(DATABASE::"G/L Entry - VAT Entry Link");
      SetTableFieldsToNormal(DATABASE::"Document Entry");
      SetTableFieldsToNormal(DATABASE::"Entry/Exit Point");
      SetTableFieldsToNormal(DATABASE::"Entry Summary");
      SetTableFieldsToNormal(DATABASE::"Analysis View Entry");
      SetTableFieldsToNormal(DATABASE::"Analysis View Budget Entry");
      SetTableFieldsToNormal(DATABASE::"SMTP Mail Setup");
      SetTableFieldsToNormal(DATABASE::"Workflow Webhook Entry");
      SetTableFieldsToNormal(DATABASE::"Workflow Webhook Notification");
      SetTableFieldsToNormal(DATABASE::"Workflow Webhook Subscription");
      SetTableFieldsToNormal(DATABASE::"Report Inbox");
      SetTableFieldsToNormal(DATABASE::"Dimension Set Entry");
      SetTableFieldsToNormal(DATABASE::"Change Global Dim. Log Entry");
      SetTableFieldsToNormal(DATABASE::"Business Chart User Setup");
      SetTableFieldsToNormal(DATABASE::"VAT Rate Change Log Entry");
      SetTableFieldsToNormal(DATABASE::"VAT Report Line");
      SetTableFieldsToNormal(DATABASE::"Trailing Sales Orders Setup");
      SetTableFieldsToNormal(DATABASE::"Account Schedules Chart Setup");
      SetTableFieldsToNormal(DATABASE::"Acc. Sched. Chart Setup Line");
      SetTableFieldsToNormal(DATABASE::"Analysis Report Chart Setup");
      SetTableFieldsToNormal(DATABASE::"Analysis Report Chart Line");
      SetTableFieldsToNormal(DATABASE::"Cash Flow Forecast");
      SetTableFieldsToNormal(DATABASE::"Cash Flow Chart Setup");
      SetTableFieldsToNormal(DATABASE::"Social Listening Setup");
      SetTableFieldsToNormal(DATABASE::"Assembly Header");
      SetTableFieldsToNormal(DATABASE::"Time Sheet Posting Entry");
      SetTableFieldsToNormal(DATABASE::"Payment Registration Setup");
      SetTableFieldsToNormal(DATABASE::"Job WIP Entry");
      SetTableFieldsToNormal(DATABASE::"Job WIP G/L Entry");
      SetTableFieldsToNormal(DATABASE::"Job Entry No.");
      SetTableFieldsToNormal(DATABASE::"User Task");
      SetTableFieldsToNormal(DATABASE::"Credit Trans Re-export History");
      SetTableFieldsToNormal(DATABASE::"Positive Pay Entry");
      SetTableFieldsToNormal(DATABASE::"Bank Data Conv. Service Setup");
      SetTableFieldsToNormal(DATABASE::"OCR Service Setup");
      SetTableFieldsToNormal(DATABASE::"Doc. Exch. Service Setup");
      SetTableFieldsToNormal(DATABASE::"Mini Vendor Template");
      SetTableFieldsToNormal(DATABASE::"User Preference");
      SetTableFieldsToNormal(DATABASE::"O365 Getting Started");
      SetTableFieldsToNormal(DATABASE::"User Tours");
      SetTableFieldsToNormal(DATABASE::"Sales by Cust. Grp.Chart Setup");
      SetTableFieldsToNormal(DATABASE::"Role Center Notifications");
      SetTableFieldsToNormal(DATABASE::"Net Promoter Score");
      SetTableFieldsToNormal(DATABASE::"Notification Setup");
      SetTableFieldsToNormal(DATABASE::"Notification Schedule");
      SetTableFieldsToNormal(DATABASE::"My Notifications");
      SetTableFieldsToNormal(DATABASE::"Workflow User Group Member");
      SetTableFieldsToNormal(DATABASE::"Exchange Object");
      SetTableFieldsToNormal(DATABASE::"Payroll Setup");
      SetTableFieldsToNormal(DATABASE::"Approval Workflow Wizard");
      SetTableFieldsToNormal(DATABASE::"O365 Item Basket Entry");
      SetTableFieldsToNormal(DATABASE::"Calendar Event User Config.");
    END;

    LOCAL PROCEDURE ClassifyTablesToNormalPart11@271();
    BEGIN
      SetTableFieldsToNormal(DATABASE::"Inter. Log Entry Comment Line");
      SetTableFieldsToNormal(DATABASE::"To-do Interaction Language");
      SetTableFieldsToNormal(DATABASE::"Outlook Synch. Link");
      SetTableFieldsToNormal(DATABASE::"Outlook Synch. Setup Detail");
      SetTableFieldsToNormal(DATABASE::"CRM Connection Setup");
      SetTableFieldsToNormal(DATABASE::"Production Order");
      SetTableFieldsToNormal(DATABASE::"Transfer Header");
      SetTableFieldsToNormal(DATABASE::"Registered Whse. Activity Hdr.");
      SetTableFieldsToNormal(DATABASE::"Avg. Cost Adjmt. Entry Point");
      SetTableFieldsToNormal(DATABASE::"Post Value Entry to G/L");
      SetTableFieldsToNormal(DATABASE::"Inventory Report Entry");
      SetTableFieldsToNormal(DATABASE::"Inventory Adjmt. Entry (Order)");
      SetTableFieldsToNormal(DATABASE::"Power BI Report Configuration");
      SetTableFieldsToNormal(DATABASE::"Power BI User Configuration");
      SetTableFieldsToNormal(DATABASE::"Item Entry Relation");
      SetTableFieldsToNormal(DATABASE::"Value Entry Relation");
      SetTableFieldsToNormal(DATABASE::"Whse. Item Entry Relation");
      SetTableFieldsToNormal(DATABASE::"Warehouse Journal Batch");
      SetTableFieldsToNormal(DATABASE::"Warehouse Receipt Header");
      SetTableFieldsToNormal(DATABASE::"Posted Whse. Receipt Header");
      SetTableFieldsToNormal(DATABASE::"Warehouse Shipment Header");
      SetTableFieldsToNormal(DATABASE::"Posted Whse. Shipment Header");
      SetTableFieldsToNormal(DATABASE::"Whse. Internal Put-away Header");
      SetTableFieldsToNormal(DATABASE::"Whse. Internal Pick Header");
      SetTableFieldsToNormal(DATABASE::"Internal Movement Header");
      SetTableFieldsToNormal(DATABASE::"ADCS User");
      SetTableFieldsToNormal(DATABASE::Plan);
      SetTableFieldsToNormal(DATABASE::"User Login");
      SetTableFieldsToNormal(DATABASE::"Calendar Entry");
      SetTableFieldsToNormal(DATABASE::"Calendar Absence Entry");
      SetTableFieldsToNormal(DATABASE::"Production Matrix  BOM Entry");
      SetTableFieldsToNormal(DATABASE::"Order Tracking Entry");
      SetTableFieldsToNormal(DATABASE::"Action Message Entry");
      SetTableFieldsToNormal(DATABASE::"Production Forecast Entry");
      SetTableFieldsToNormal(DATABASE::"Record Link");
      SetTableFieldsToNormal(DATABASE::"Document Service");
      SetTableFieldsToNormal(DATABASE::"Data Privacy Entities");
      SetTableFieldsToNormal(DATABASE::"Data Class. Notif. Setup");
    END;

    PROCEDURE SetTableFieldsToNormal@231(TableNo@1001 : Integer);
    VAR
      DataClassificationMgt@1000 : Codeunit 1750;
    BEGIN
      DataClassificationMgt.SetTableFieldsToNormal(TableNo);
    END;

    LOCAL PROCEDURE SetFieldToPersonal@2(TableNo@1000 : Integer;FieldNo@1001 : Integer);
    VAR
      DataClassificationMgt@1002 : Codeunit 1750;
    BEGIN
      DataClassificationMgt.SetFieldToPersonal(TableNo,FieldNo);
    END;

    LOCAL PROCEDURE SetFieldToSensitive@3(TableNo@1000 : Integer;FieldNo@1001 : Integer);
    VAR
      DataClassificationMgt@1002 : Codeunit 1750;
    BEGIN
      DataClassificationMgt.SetFieldToSensitive(TableNo,FieldNo);
    END;

    LOCAL PROCEDURE SetFieldToCompanyConfidential@4(TableNo@1000 : Integer;FieldNo@1001 : Integer);
    VAR
      DataClassificationMgt@1002 : Codeunit 1750;
    BEGIN
      DataClassificationMgt.SetFieldToCompanyConfidential(TableNo,FieldNo);
    END;

    LOCAL PROCEDURE ClassifyCreditTransferEntry@5();
    VAR
      DummyCreditTransferEntry@1000 : Record 1206;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Credit Transfer Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Message to Recipient"));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Recipient Bank Acc. No."));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Transaction ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Transfer Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Transfer Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Applies-to Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCreditTransferEntry.FIELDNO("Credit Transfer Register No."));
    END;

    LOCAL PROCEDURE ClassifyActiveSession@6();
    VAR
      DummyActiveSession@1000 : Record 2000000110;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Active Session";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyActiveSession.FIELDNO("Session Unique ID"));
      SetFieldToPersonal(TableNo,DummyActiveSession.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyActiveSession.FIELDNO("Session ID"));
      SetFieldToPersonal(TableNo,DummyActiveSession.FIELDNO("User SID"));
    END;

    LOCAL PROCEDURE ClassifyRegisteredInvtMovementHdr@7();
    VAR
      DummyRegisteredInvtMovementHdr@1000 : Record 7344;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Registered Invt. Movement Hdr.";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyRegisteredInvtMovementHdr.FIELDNO("Assigned User ID"));
    END;

    LOCAL PROCEDURE ClassifySEPADirectDebitMandate@8();
    VAR
      DummySEPADirectDebitMandate@1000 : Record 1230;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"SEPA Direct Debit Mandate";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO(Closed));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO("Debit Counter"));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO("Expected Number of Debits"));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO(Blocked));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO("Type of Payment"));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO("Date of Signature"));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO("Valid To"));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO("Valid From"));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO("Customer Bank Account Code"));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO("Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummySEPADirectDebitMandate.FIELDNO(ID));
    END;

    LOCAL PROCEDURE ClassifyPostedAssemblyHeader@9();
    VAR
      DummyPostedAssemblyHeader@1000 : Record 910;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Posted Assembly Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPostedAssemblyHeader.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyPostedInvtPickHeader@10();
    VAR
      DummyPostedInvtPickHeader@1000 : Record 7342;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Posted Invt. Pick Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPostedInvtPickHeader.FIELDNO("Assigned User ID"));
    END;

    LOCAL PROCEDURE ClassifyPostedInvtPutawayHeader@11();
    VAR
      DummyPostedInvtPutAwayHeader@1000 : Record 7340;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Posted Invt. Put-away Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPostedInvtPutAwayHeader.FIELDNO("Assigned User ID"));
    END;

    LOCAL PROCEDURE ClassifyPurchInvEntityAggregate@12();
    VAR
      DummyPurchInvEntityAggregate@1000 : Record 5477;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purch. Inv. Entity Aggregate";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchInvEntityAggregate.FIELDNO("Buy-from Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchInvEntityAggregate.FIELDNO("Buy-from Contact"));
      SetFieldToPersonal(TableNo,DummyPurchInvEntityAggregate.FIELDNO("Buy-from City"));
      SetFieldToPersonal(TableNo,DummyPurchInvEntityAggregate.FIELDNO("Buy-from Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchInvEntityAggregate.FIELDNO("Buy-from Address"));
      SetFieldToPersonal(TableNo,DummyPurchInvEntityAggregate.FIELDNO("Buy-from Vendor Name"));
      SetFieldToPersonal(TableNo,DummyPurchInvEntityAggregate.FIELDNO("Buy-from County"));
    END;

    LOCAL PROCEDURE ClassifySalesInvoiceEntityAggregate@13();
    VAR
      DummySalesInvoiceEntityAggregate@1000 : Record 5475;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Invoice Entity Aggregate";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("Sell-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("Sell-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("Sell-to City"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("Sell-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("Sell-to Address"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("Sell-to Customer Name"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("Contact Graph Id"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceEntityAggregate.FIELDNO("Sell-to County"));
    END;

    LOCAL PROCEDURE ClassifyWarehouseEntry@14();
    VAR
      DummyWarehouseEntry@1000 : Record 7312;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Warehouse Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO(Dedicated));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Phys Invt Counting Period Type"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Phys Invt Counting Period Code"));
      SetFieldToPersonal(TableNo,DummyWarehouseEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Serial No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Qty. per Unit of Measure"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Variant Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Reference No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Reference Document"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Warranty Date"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Whse. Document Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Whse. Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Whse. Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Journal Template Name"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO(Weight));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO(Cubage));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Lot No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Expiration Date"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Bin Type Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Source Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Source Document"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Source Subline No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Source Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Source Subtype"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Qty. (Base)"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Bin Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Zone Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Registering Date"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyWarehouseEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyWarehouseJournalLine@15();
    VAR
      DummyWarehouseJournalLine@1000 : Record 7311;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Warehouse Journal Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyWarehouseJournalLine.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyWarehouseEmployee@16();
    VAR
      DummyWarehouseEmployee@1000 : Record 7301;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Warehouse Employee";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyWarehouseEmployee.FIELDNO("ADCS User"));
      SetFieldToPersonal(TableNo,DummyWarehouseEmployee.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyContactAltAddress@17();
    VAR
      DummyContactAltAddress@1000 : Record 5051;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Contact Alt. Address";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Search E-Mail"));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Telex Answer Back"));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Home Page"));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO(Pager));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Mobile Phone No."));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Extension No."));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Telex No."));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Country/Region Code"));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Company Name 2"));
      SetFieldToPersonal(TableNo,DummyContactAltAddress.FIELDNO("Company Name"));
    END;

    LOCAL PROCEDURE ClassifyCashFlowForecastEntry@18();
    VAR
      DummyCashFlowForecastEntry@1000 : Record 847;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cash Flow Forecast Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("G/L Budget Name"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO(Positive));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Recurring Method"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Associated Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Associated Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Payment Discount"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO(Overdue));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Cash Flow Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Cash Flow Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Cash Flow Forecast No."));
      SetFieldToPersonal(TableNo,DummyCashFlowForecastEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCashFlowForecastEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyDirectDebitCollection@19();
    VAR
      DummyDirectDebitCollection@1000 : Record 1207;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Direct Debit Collection";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyDirectDebitCollection.FIELDNO("Created by User"));
    END;

    LOCAL PROCEDURE ClassifyActivityLog@20();
    VAR
      DummyActivityLog@1000 : Record 710;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Activity Log";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyActivityLog.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyInventoryPeriodEntry@21();
    VAR
      DummyInventoryPeriodEntry@1000 : Record 5815;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Inventory Period Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyInventoryPeriodEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyInventoryPeriodEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyInventoryPeriodEntry.FIELDNO("Closing Item Register No."));
      SetFieldToCompanyConfidential(TableNo,DummyInventoryPeriodEntry.FIELDNO("Creation Time"));
      SetFieldToCompanyConfidential(TableNo,DummyInventoryPeriodEntry.FIELDNO("Creation Date"));
      SetFieldToPersonal(TableNo,DummyInventoryPeriodEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyInventoryPeriodEntry.FIELDNO("Ending Date"));
      SetFieldToCompanyConfidential(TableNo,DummyInventoryPeriodEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyMyItem@22();
    VAR
      DummyMyItem@1000 : Record 9152;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"My Item";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyMyItem.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyUserSecurityStatus@23();
    VAR
      DummyUserSecurityStatus@1000 : Record 9062;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Security Status";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserSecurityStatus.FIELDNO("User Security ID"));
    END;

    LOCAL PROCEDURE ClassifyCueSetup@24();
    VAR
      DummyCueSetup@1000 : Record 9701;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cue Setup";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCueSetup.FIELDNO("User Name"));
    END;

    LOCAL PROCEDURE ClassifyVATReportArchive@25();
    VAR
      DummyVATReportArchive@1000 : Record 747;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"VAT Report Archive";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyVATReportArchive.FIELDNO("Submitted By"));
    END;

    LOCAL PROCEDURE ClassifySessionEvent@26();
    VAR
      DummySessionEvent@1000 : Record 2000000111;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Session Event";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySessionEvent.FIELDNO("Session Unique ID"));
      SetFieldToPersonal(TableNo,DummySessionEvent.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummySessionEvent.FIELDNO("Session ID"));
      SetFieldToPersonal(TableNo,DummySessionEvent.FIELDNO("User SID"));
    END;

    LOCAL PROCEDURE ClassifyUserDefaultStyleSheet@28();
    VAR
      DummyUserDefaultStyleSheet@1000 : Record 2000000067;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Default Style Sheet";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserDefaultStyleSheet.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyUserPlan@29();
    VAR
      DummyUserPlan@1000 : Record 9005;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Plan";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserPlan.FIELDNO("User Security ID"));
    END;

    LOCAL PROCEDURE ClassifyUserGroupAccessControl@30();
    VAR
      DummyUserGroupAccessControl@1000 : Record 9002;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Group Access Control";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserGroupAccessControl.FIELDNO("User Security ID"));
    END;

    LOCAL PROCEDURE ClassifyUserGroupMember@31();
    VAR
      DummyUserGroupMember@1000 : Record 9001;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Group Member";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserGroupMember.FIELDNO("User Security ID"));
      SetFieldToPersonal(TableNo,DummyUserGroupMember.FIELDNO("User Group Code"));
    END;

    LOCAL PROCEDURE ClassifyAnalysisSelectedDimension@32();
    VAR
      DummyAnalysisSelectedDimension@1000 : Record 7159;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Analysis Selected Dimension";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyAnalysisSelectedDimension.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyItemAnalysisViewBudgEntry@33();
    VAR
      DummyItemAnalysisViewBudgEntry@1000 : Record 7156;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Item Analysis View Budg. Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Cost Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Sales Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Dimension 3 Value Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Dimension 2 Value Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Dimension 1 Value Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Budget Name"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Analysis View Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewBudgEntry.FIELDNO("Analysis Area"));
    END;

    LOCAL PROCEDURE ClassifyItemAnalysisViewEntry@34();
    VAR
      DummyItemAnalysisViewEntry@1000 : Record 7154;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Item Analysis View Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Cost Amount (Expected)"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Sales Amount (Expected)"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Cost Amount (Non-Invtbl.)"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Cost Amount (Actual)"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Sales Amount (Actual)"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Invoiced Quantity"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Item Ledger Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Dimension 3 Value Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Dimension 2 Value Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Dimension 1 Value Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Analysis View Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemAnalysisViewEntry.FIELDNO("Analysis Area"));
    END;

    LOCAL PROCEDURE ClassifyTokenCache@35();
    VAR
      DummyTokenCache@1000 : Record 2000000197;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Token Cache";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyTokenCache.FIELDNO("Tenant ID"));
      SetFieldToPersonal(TableNo,DummyTokenCache.FIELDNO("User Unique ID"));
      SetFieldToPersonal(TableNo,DummyTokenCache.FIELDNO("User Security ID"));
    END;

    LOCAL PROCEDURE ClassifyTenantLicenseState@36();
    VAR
      DummyTenantLicenseState@1000 : Record 2000000189;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Tenant License State";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyTenantLicenseState.FIELDNO("User Security ID"));
    END;

    LOCAL PROCEDURE ClassifyOutlookSynchUserSetup@37();
    VAR
      DummyOutlookSynchUserSetup@1000 : Record 5305;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Outlook Synch. User Setup";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyOutlookSynchUserSetup.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyFAJournalSetup@38();
    VAR
      DummyFAJournalSetup@1000 : Record 5605;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"FA Journal Setup";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyFAJournalSetup.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyCustomizedCalendarEntry@39();
    VAR
      DummyCustomizedCalendarEntry@1000 : Record 7603;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Customized Calendar Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyCustomizedCalendarEntry.FIELDNO(Nonworking));
      SetFieldToCompanyConfidential(TableNo,DummyCustomizedCalendarEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyCustomizedCalendarEntry.FIELDNO(Date));
      SetFieldToCompanyConfidential(TableNo,DummyCustomizedCalendarEntry.FIELDNO("Base Calendar Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustomizedCalendarEntry.FIELDNO("Additional Source Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustomizedCalendarEntry.FIELDNO("Source Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustomizedCalendarEntry.FIELDNO("Source Type"));
    END;

    LOCAL PROCEDURE ClassifyOfficeContactAssociations@40();
    VAR
      DummyOfficeContactAssociations@1000 : Record 1625;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Office Contact Associations";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyOfficeContactAssociations.FIELDNO("Contact Name"));
    END;

    LOCAL PROCEDURE ClassifyMyVendor@41();
    VAR
      DummyMyVendor@1000 : Record 9151;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"My Vendor";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyMyVendor.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyMyVendor.FIELDNO(Name));
      SetFieldToPersonal(TableNo,DummyMyVendor.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyItemBudgetEntry@42();
    VAR
      DummyItemBudgetEntry@1000 : Record 7134;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Item Budget Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Budget Dimension 3 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Budget Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Budget Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Location Code"));
      SetFieldToPersonal(TableNo,DummyItemBudgetEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Sales Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Cost Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO(Date));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Budget Name"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Analysis Area"));
      SetFieldToCompanyConfidential(TableNo,DummyItemBudgetEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyMyCustomer@43();
    VAR
      DummyMyCustomer@1000 : Record 9150;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"My Customer";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyMyCustomer.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyMyCustomer.FIELDNO(Name));
      SetFieldToPersonal(TableNo,DummyMyCustomer.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyAccessControl@44();
    VAR
      DummyAccessControl@1000 : Record 2000000053;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Access Control";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyAccessControl.FIELDNO("User Security ID"));
    END;

    LOCAL PROCEDURE ClassifyUserProperty@45();
    VAR
      DummyUserProperty@1000 : Record 2000000121;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Property";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserProperty.FIELDNO(Password));
      SetFieldToPersonal(TableNo,DummyUserProperty.FIELDNO("User Security ID"));
    END;

    LOCAL PROCEDURE ClassifyUser@46();
    VAR
      DummyUser@1000 : Record 2000000120;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::User;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUser.FIELDNO("Exchange Identifier"));
      SetFieldToPersonal(TableNo,DummyUser.FIELDNO("Contact Email"));
      SetFieldToPersonal(TableNo,DummyUser.FIELDNO("Authentication Email"));
      SetFieldToPersonal(TableNo,DummyUser.FIELDNO("Windows Security ID"));
      SetFieldToPersonal(TableNo,DummyUser.FIELDNO("Full Name"));
      SetFieldToPersonal(TableNo,DummyUser.FIELDNO("User Name"));
      SetFieldToPersonal(TableNo,DummyUser.FIELDNO("User Security ID"));
    END;

    LOCAL PROCEDURE ClassifyConfidentialInformation@50();
    VAR
      DummyConfidentialInformation@1000 : Record 5216;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Confidential Information";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyConfidentialInformation.FIELDNO(Description));
    END;

    LOCAL PROCEDURE ClassifyAttendee@51();
    VAR
      DummyAttendee@1000 : Record 5199;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Attendee;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyAttendee.FIELDNO("Attendee Name"));
    END;

    LOCAL PROCEDURE ClassifyOverdueApprovalEntry@52();
    VAR
      DummyOverdueApprovalEntry@1000 : Record 458;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Overdue Approval Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Limit Type"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Approval Type"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Approval Code"));
      SetFieldToPersonal(TableNo,DummyOverdueApprovalEntry.FIELDNO("Approver ID"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Due Date"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Sequence No."));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Sent to Name"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("E-Mail"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Sent Date"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Sent Time"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Sent to ID"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyOverdueApprovalEntry.FIELDNO("Table ID"));
    END;

    LOCAL PROCEDURE ClassifyApplicationAreaSetup@53();
    VAR
      DummyApplicationAreaSetup@1000 : Record 9178;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Application Area Setup";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyApplicationAreaSetup.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyDateComprRegister@54();
    VAR
      DummyDateComprRegister@1000 : Record 87;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Date Compr. Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyDateComprRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyEmployeeAbsence@55();
    VAR
      DummyEmployeeAbsence@1000 : Record 5207;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Employee Absence";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO("Qty. per Unit of Measure"));
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO("Quantity (Base)"));
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO("Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO("Cause of Absence Code"));
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO("To Date"));
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO("From Date"));
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyEmployeeAbsence.FIELDNO("Employee No."));
    END;

    LOCAL PROCEDURE ClassifyWorkflowStepInstanceArchive@56();
    VAR
      DummyWorkflowStepInstanceArchive@1000 : Record 1530;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Workflow Step Instance Archive";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyWorkflowStepInstanceArchive.FIELDNO("Last Modified By User ID"));
      SetFieldToPersonal(TableNo,DummyWorkflowStepInstanceArchive.FIELDNO("Created By User ID"));
    END;

    LOCAL PROCEDURE ClassifyMyJob@58();
    VAR
      DummyMyJob@1000 : Record 9154;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"My Job";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyMyJob.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyAlternativeAddress@60();
    VAR
      DummyAlternativeAddress@1000 : Record 5201;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Alternative Address";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyAlternativeAddress.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyWorkflowStepArgument@62();
    VAR
      DummyWorkflowStepArgument@1000 : Record 1523;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Workflow Step Argument";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyWorkflowStepArgument.FIELDNO("Response User ID"));
      SetFieldToPersonal(TableNo,DummyWorkflowStepArgument.FIELDNO("Approver User ID"));
      SetFieldToPersonal(TableNo,DummyWorkflowStepArgument.FIELDNO("Notification User ID"));
    END;

    LOCAL PROCEDURE ClassifyPageDataPersonalization@63();
    VAR
      DummyPageDataPersonalization@1000 : Record 2000000080;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Page Data Personalization";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPageDataPersonalization.FIELDNO("User SID"));
    END;

    LOCAL PROCEDURE ClassifySentNotificationEntry@64();
    VAR
      DummySentNotificationEntry@1000 : Record 1514;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sent Notification Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummySentNotificationEntry.FIELDNO("Aggregated with Entry"));
      SetFieldToCompanyConfidential(TableNo,DummySentNotificationEntry.FIELDNO("Notification Method"));
      SetFieldToCompanyConfidential(TableNo,DummySentNotificationEntry.FIELDNO("Notification Content"));
      SetFieldToCompanyConfidential(TableNo,DummySentNotificationEntry.FIELDNO("Sent Date-Time"));
      SetFieldToPersonal(TableNo,DummySentNotificationEntry.FIELDNO("Created By"));
      SetFieldToCompanyConfidential(TableNo,DummySentNotificationEntry.FIELDNO("Created Date-Time"));
      SetFieldToCompanyConfidential(TableNo,DummySentNotificationEntry.FIELDNO("Custom Link"));
      SetFieldToCompanyConfidential(TableNo,DummySentNotificationEntry.FIELDNO("Link Target Page"));
      SetFieldToPersonal(TableNo,DummySentNotificationEntry.FIELDNO("Recipient User ID"));
      SetFieldToCompanyConfidential(TableNo,DummySentNotificationEntry.FIELDNO(Type));
      SetFieldToCompanyConfidential(TableNo,DummySentNotificationEntry.FIELDNO(ID));
    END;

    LOCAL PROCEDURE ClassifyICOutboxPurchaseHeader@65();
    VAR
      DummyICOutboxPurchaseHeader@1000 : Record 428;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"IC Outbox Purchase Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyICOutboxPurchaseHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyICOutboxPurchaseHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyICOutboxPurchaseHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyICOutboxPurchaseHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyICOutboxPurchaseHeader.FIELDNO("Ship-to Name"));
    END;

    LOCAL PROCEDURE ClassifyUserMetadata@66();
    VAR
      DummyUserMetadata@1000 : Record 2000000075;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Metadata";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserMetadata.FIELDNO("User SID"));
    END;

    LOCAL PROCEDURE ClassifyNotificationEntry@67();
    VAR
      DummyNotificationEntry@1000 : Record 1511;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Notification Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyNotificationEntry.FIELDNO("Created By"));
      SetFieldToCompanyConfidential(TableNo,DummyNotificationEntry.FIELDNO("Created Date-Time"));
      SetFieldToCompanyConfidential(TableNo,DummyNotificationEntry.FIELDNO("Error Message"));
      SetFieldToCompanyConfidential(TableNo,DummyNotificationEntry.FIELDNO("Custom Link"));
      SetFieldToCompanyConfidential(TableNo,DummyNotificationEntry.FIELDNO("Link Target Page"));
      SetFieldToPersonal(TableNo,DummyNotificationEntry.FIELDNO("Recipient User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyNotificationEntry.FIELDNO(Type));
      SetFieldToCompanyConfidential(TableNo,DummyNotificationEntry.FIELDNO(ID));
    END;

    LOCAL PROCEDURE ClassifyUserPersonalization@68();
    VAR
      DummyUserPersonalization@1000 : Record 2000000073;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Personalization";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserPersonalization.FIELDNO("User SID"));
    END;

    LOCAL PROCEDURE ClassifyWorkflowStepInstance@69();
    VAR
      DummyWorkflowStepInstance@1000 : Record 1504;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Workflow Step Instance";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyWorkflowStepInstance.FIELDNO("Last Modified By User ID"));
      SetFieldToPersonal(TableNo,DummyWorkflowStepInstance.FIELDNO("Created By User ID"));
    END;

    LOCAL PROCEDURE ClassifyWorkCenter@70();
    VAR
      DummyWorkCenter@1000 : Record 99000754;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Work Center";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyWorkCenter.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyWorkCenter.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyWorkCenter.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyWorkCenter.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyWorkCenter.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyWorkCenter.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyWorkCenter.FIELDNO("Search Name"));
      SetFieldToPersonal(TableNo,DummyWorkCenter.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyCampaignEntry@71();
    VAR
      DummyCampaignEntry@1000 : Record 5072;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Campaign Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyCampaignEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCampaignEntry.FIELDNO("Register No."));
      SetFieldToCompanyConfidential(TableNo,DummyCampaignEntry.FIELDNO("Salesperson Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCampaignEntry.FIELDNO(Canceled));
      SetFieldToCompanyConfidential(TableNo,DummyCampaignEntry.FIELDNO("Segment No."));
      SetFieldToPersonal(TableNo,DummyCampaignEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCampaignEntry.FIELDNO(Date));
      SetFieldToCompanyConfidential(TableNo,DummyCampaignEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyCampaignEntry.FIELDNO("Campaign No."));
      SetFieldToCompanyConfidential(TableNo,DummyCampaignEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifySession@72();
    VAR
      DummySession@1000 : Record 2000000009;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Session;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySession.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummySession.FIELDNO("Connection ID"));
    END;

    LOCAL PROCEDURE ClassifyPurchaseLineArchive@73();
    VAR
      DummyPurchaseLineArchive@1000 : Record 5110;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purchase Line Archive";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchaseLineArchive.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyPurchaseHeaderArchive@74();
    VAR
      DummyPurchaseHeaderArchive@1000 : Record 5109;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purchase Header Archive";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Assigned User ID"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Archived By"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Buy-from County"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Buy-from Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Pay-to County"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Pay-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Buy-from Contact"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Buy-from City"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Buy-from Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Buy-from Address"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Buy-from Vendor Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Buy-from Vendor Name"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Pay-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Pay-to City"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Pay-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Pay-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Pay-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeaderArchive.FIELDNO("Pay-to Name"));
    END;

    LOCAL PROCEDURE ClassifySalesLineArchive@75();
    VAR
      DummySalesLineArchive@1000 : Record 5108;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Line Archive";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesLineArchive.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifySalesHeaderArchive@76();
    VAR
      DummySalesHeaderArchive@1000 : Record 5107;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Header Archive";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Assigned User ID"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Archived By"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Sell-to County"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Sell-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Sell-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Sell-to City"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Sell-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Sell-to Address"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Sell-to Customer Name 2"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Sell-to Customer Name"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesHeaderArchive.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifyApprovalCommentLine@77();
    VAR
      DummyApprovalCommentLine@1000 : Record 455;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Approval Comment Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyApprovalCommentLine.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyCommunicationMethod@78();
    VAR
      DummyCommunicationMethod@1000 : Record 5100;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Communication Method";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCommunicationMethod.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyCommunicationMethod.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifySavedSegmentCriteria@79();
    VAR
      DummySavedSegmentCriteria@1000 : Record 5098;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Saved Segment Criteria";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySavedSegmentCriteria.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyOpportunityEntry@80();
    VAR
      DummyOpportunityEntry@1000 : Record 5093;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Opportunity Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Sales Cycle Stage Description"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Action Type"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Cancel Old To Do"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Wizard Step"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Estimated Close Date"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Previous Sales Cycle Stage"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Close Opportunity Code"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Probability %"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Chances of Success %"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Completed %"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Calcd. Current Value (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Estimated Value (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Action Taken"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Days Open"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Date Closed"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO(Active));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Date of Change"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Campaign No."));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Salesperson Code"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Contact Company No."));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Contact No."));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Sales Cycle Stage"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Sales Cycle Code"));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Opportunity No."));
      SetFieldToCompanyConfidential(TableNo,DummyOpportunityEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyOpportunity@81();
    VAR
      DummyOpportunity@1000 : Record 5092;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Opportunity;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyOpportunity.FIELDNO("Wizard Contact Name"));
    END;

    LOCAL PROCEDURE ClassifyContactProfileAnswer@82();
    VAR
      DummyContactProfileAnswer@1000 : Record 5089;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Contact Profile Answer";
      SetTableFieldsToNormal(TableNo);
      SetFieldToSensitive(TableNo,DummyContactProfileAnswer.FIELDNO("Profile Questionnaire Value"));
    END;

    LOCAL PROCEDURE ClassifyTodo@83();
    VAR
      DummyToDo@1000 : Record 5080;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"To-do";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyToDo.FIELDNO("Wizard Contact Name"));
      SetFieldToPersonal(TableNo,DummyToDo.FIELDNO("Completed By"));
    END;

    LOCAL PROCEDURE ClassifyMarketingSetup@84();
    VAR
      DummyMarketingSetup@1000 : Record 5079;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Marketing Setup";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyMarketingSetup.FIELDNO("Exchange Account User Name"));
    END;

    LOCAL PROCEDURE ClassifySegmentLine@85();
    VAR
      DummySegmentLine@1000 : Record 5077;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Segment Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySegmentLine.FIELDNO("Wizard Contact Name"));
    END;

    LOCAL PROCEDURE ClassifyLoggedSegment@86();
    VAR
      DummyLoggedSegment@1000 : Record 5075;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Logged Segment";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyLoggedSegment.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyServiceInvoiceLine@87();
    VAR
      DummyServiceInvoiceLine@1000 : Record 5993;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Invoice Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceInvoiceLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyServiceInvoiceHeader@88();
    VAR
      DummyServiceInvoiceHeader@1000 : Record 5992;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Invoice Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to Fax No."));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to E-Mail"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to Phone 2"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Contact Name"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO(Name));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Phone No. 2"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to Phone"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceInvoiceHeader.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifyServiceShipmentLine@89();
    VAR
      DummyServiceShipmentLine@1000 : Record 5991;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Shipment Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceShipmentLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyServiceShipmentHeader@90();
    VAR
      DummyServiceShipmentHeader@1000 : Record 5990;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Shipment Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to Fax No."));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to E-Mail"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to Phone 2"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Contact Name"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO(Name));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Phone No. 2"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to Phone"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceShipmentHeader.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifyJobQueueLogEntry@91();
    VAR
      DummyJobQueueLogEntry@1000 : Record 474;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Job Queue Log Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("Job Queue Category Code"));
      SetFieldToPersonal(TableNo,DummyJobQueueLogEntry.FIELDNO("Processed by User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("Error Message 4"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("Error Message 3"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("Error Message 2"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("Error Message"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO(Status));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("Object ID to Run"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("Object Type to Run"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("End Date/Time"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("Start Date/Time"));
      SetFieldToPersonal(TableNo,DummyJobQueueLogEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO(ID));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueLogEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyJobQueueEntry@92();
    VAR
      DummyJobQueueEntry@1000 : Record 472;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Job Queue Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("On Hold Due to Inactivity"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Manual Recurrence"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("System Task ID"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Rerun Delay (sec.)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Report Request Page Options"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Printer Name"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("User Language ID"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Notify On Success"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Timeout (sec.)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("User Session Started"));
      SetFieldToPersonal(TableNo,DummyJobQueueEntry.FIELDNO("User Service Instance ID"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Error Message 4"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Error Message 3"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Error Message 2"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Error Message"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Job Queue Category Code"));
      SetFieldToPersonal(TableNo,DummyJobQueueEntry.FIELDNO("User Session ID"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Run in User Session"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Reference Starting Time"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Ending Time"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Starting Time"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Run on Sundays"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Run on Saturdays"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Run on Fridays"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Run on Thursdays"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Run on Wednesdays"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Run on Tuesdays"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Run on Mondays"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("No. of Minutes between Runs"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Recurring Job"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Parameter String"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO(Priority));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO(Status));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("No. of Attempts to Run"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Maximum No. of Attempts to Run"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Report Output Type"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Object ID to Run"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Object Type to Run"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Earliest Start Date/Time"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Expiration Date/Time"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO("Last Ready State"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO(XML));
      SetFieldToPersonal(TableNo,DummyJobQueueEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyJobQueueEntry.FIELDNO(ID));
    END;

    LOCAL PROCEDURE ClassifyInteractionLogEntry@93();
    VAR
      DummyInteractionLogEntry@1000 : Record 5065;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Interaction Log Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO(Postponed));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Opportunity No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO(Subject));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("E-Mail Logged"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Interaction Language Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Send Word Docs. as Attmt."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Contact Via"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Doc. No. Occurrence"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Version No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Logged Segment Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Contact Alt. Address Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Correspondence Type"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO(Canceled));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Delivery Status"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Salesperson Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("To-do No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Attempt Failed"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Time of Interaction"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO(Evaluation));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Segment No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Campaign Target"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Campaign Response"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Campaign Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Campaign No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Interaction Template Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Interaction Group Code"));
      SetFieldToPersonal(TableNo,DummyInteractionLogEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Duration (Min.)"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Cost (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Attachment No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Initiated By"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Information Flow"));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO(Date));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Contact Company No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Contact No."));
      SetFieldToCompanyConfidential(TableNo,DummyInteractionLogEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyPostedApprovalCommentLine@94();
    VAR
      DummyPostedApprovalCommentLine@1000 : Record 457;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Posted Approval Comment Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPostedApprovalCommentLine.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyPostedApprovalEntry@95();
    VAR
      DummyPostedApprovalEntry@1000 : Record 456;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Posted Approval Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Iteration No."));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Number of Rejected Requests"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Number of Approved Requests"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Delegation Date Formula"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Available Credit Limit (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Limit Type"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Approval Type"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Due Date"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Last Modified By ID"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Last Date-Time Modified"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Date-Time Sent for Approval"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO(Status));
      SetFieldToPersonal(TableNo,DummyPostedApprovalEntry.FIELDNO("Approver ID"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Salespers./Purch. Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Sender ID"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Approval Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Sequence No."));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyPostedApprovalEntry.FIELDNO("Table ID"));
    END;

    LOCAL PROCEDURE ClassifyContact@96();
    VAR
      DummyContact@1000 : Record 5050;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Contact;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("E-Mail 2"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Search E-Mail"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO(Image));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO(Pager));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Mobile Phone No."));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Extension No."));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO(Surname));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Middle Name"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("First Name"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Home Page"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Post Code"));
      SetFieldToSensitive(TableNo,DummyContact.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Telex Answer Back"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Telex No."));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO("Search Name"));
      SetFieldToPersonal(TableNo,DummyContact.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyApprovalEntry@97();
    VAR
      DummyApprovalEntry@1000 : Record 454;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Approval Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Workflow Step Instance ID"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Delegation Date Formula"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Available Credit Limit (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Limit Type"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Approval Type"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Due Date"));
      SetFieldToPersonal(TableNo,DummyApprovalEntry.FIELDNO("Last Modified By User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Last Date-Time Modified"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Date-Time Sent for Approval"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO(Status));
      SetFieldToPersonal(TableNo,DummyApprovalEntry.FIELDNO("Approver ID"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Salespers./Purch. Code"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Sender ID"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Approval Code"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Sequence No."));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyApprovalEntry.FIELDNO("Table ID"));
    END;

    LOCAL PROCEDURE ClassifyContractChangeLog@98();
    VAR
      DummyContractChangeLog@1000 : Record 5967;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Contract Change Log";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyContractChangeLog.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyServiceContractHeader@99();
    VAR
      DummyServiceContractHeader@1000 : Record 5965;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Contract Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceContractHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummyServiceContractHeader.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyServiceContractHeader.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyServiceContractHeader.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyServiceContractHeader.FIELDNO("Contact Name"));
    END;

    LOCAL PROCEDURE ClassifyHandledICInboxPurchHeader@100();
    VAR
      DummyHandledICInboxPurchHeader@1000 : Record 440;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Handled IC Inbox Purch. Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyHandledICInboxPurchHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyHandledICInboxPurchHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyHandledICInboxPurchHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyHandledICInboxPurchHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyHandledICInboxPurchHeader.FIELDNO("Ship-to Name"));
    END;

    LOCAL PROCEDURE ClassifyHandledICInboxSalesHeader@101();
    VAR
      DummyHandledICInboxSalesHeader@1000 : Record 438;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Handled IC Inbox Sales Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyHandledICInboxSalesHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyHandledICInboxSalesHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyHandledICInboxSalesHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyHandledICInboxSalesHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyHandledICInboxSalesHeader.FIELDNO("Ship-to Name"));
    END;

    LOCAL PROCEDURE ClassifyICInboxPurchaseHeader@102();
    VAR
      DummyICInboxPurchaseHeader@1000 : Record 436;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"IC Inbox Purchase Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyICInboxPurchaseHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyICInboxPurchaseHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyICInboxPurchaseHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyICInboxPurchaseHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyICInboxPurchaseHeader.FIELDNO("Ship-to Name"));
    END;

    LOCAL PROCEDURE ClassifyICInboxSalesHeader@103();
    VAR
      DummyICInboxSalesHeader@1000 : Record 434;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"IC Inbox Sales Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyICInboxSalesHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyICInboxSalesHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyICInboxSalesHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyICInboxSalesHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyICInboxSalesHeader.FIELDNO("Ship-to Name"));
    END;

    LOCAL PROCEDURE ClassifyHandledICOutboxPurchHdr@104();
    VAR
      DummyHandledICOutboxPurchHdr@1000 : Record 432;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Handled IC Outbox Purch. Hdr";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyHandledICOutboxPurchHdr.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyHandledICOutboxPurchHdr.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyHandledICOutboxPurchHdr.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyHandledICOutboxPurchHdr.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyHandledICOutboxPurchHdr.FIELDNO("Ship-to Name"));
    END;

    LOCAL PROCEDURE ClassifyHandledICOutboxSalesHeader@105();
    VAR
      DummyHandledICOutboxSalesHeader@1000 : Record 430;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Handled IC Outbox Sales Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyHandledICOutboxSalesHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyHandledICOutboxSalesHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyHandledICOutboxSalesHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyHandledICOutboxSalesHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyHandledICOutboxSalesHeader.FIELDNO("Ship-to Name"));
    END;

    LOCAL PROCEDURE ClassifyServiceItemLog@106();
    VAR
      DummyServiceItemLog@1000 : Record 5942;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Item Log";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceItemLog.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyServiceCrMemoHeader@107();
    VAR
      DummyServiceCrMemoHeader@1000 : Record 5994;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Cr.Memo Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to Fax No."));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to E-Mail"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to Phone 2"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Contact Name"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO(Name));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Phone No. 2"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to Phone"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceCrMemoHeader.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifyServiceRegister@108();
    VAR
      DummyServiceRegister@1000 : Record 5934;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyUserPageMetadata@109();
    VAR
      DummyUserPageMetadata@1000 : Record 2000000188;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Page Metadata";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserPageMetadata.FIELDNO("User SID"));
    END;

    LOCAL PROCEDURE ClassifyICPartner@110();
    VAR
      DummyICPartner@1000 : Record 413;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"IC Partner";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyICPartner.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyChangeLogEntry@111();
    VAR
      DummyChangeLogEntry@1000 : Record 405;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Change Log Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Primary Key Field 3 Value"));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Primary Key Field 3 No."));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Primary Key Field 2 Value"));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Primary Key Field 2 No."));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Primary Key Field 1 Value"));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Primary Key Field 1 No."));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Primary Key"));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("New Value"));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Old Value"));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Type of Change"));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Field No."));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Table No."));
      SetFieldToPersonal(TableNo,DummyChangeLogEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO(Time));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Date and Time"));
      SetFieldToCompanyConfidential(TableNo,DummyChangeLogEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyInsCoverageLedgerEntry@112();
    VAR
      DummyInsCoverageLedgerEntry@1000 : Record 5629;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Ins. Coverage Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Index Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("FA Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("FA Subclass Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("FA Class Code"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("FA Description"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("FA No."));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Disposed FA"));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Insurance No."));
      SetFieldToCompanyConfidential(TableNo,DummyInsCoverageLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyLoanerEntry@113();
    VAR
      DummyLoanerEntry@1000 : Record 5914;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Loaner Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO(Lent));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Time Received"));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Date Received"));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Time Lent"));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Date Lent"));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Service Item Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Service Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Service Item Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Loaner No."));
      SetFieldToCompanyConfidential(TableNo,DummyLoanerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyServiceDocumentLog@114();
    VAR
      DummyServiceDocumentLog@1000 : Record 5912;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Document Log";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceDocumentLog.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyWarrantyLedgerEntry@115();
    VAR
      DummyWarrantyLedgerEntry@1000 : Record 5908;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Warranty Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Service Order Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Variant Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Vendor Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Vendor No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO(Open));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Work Type Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO(Type));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Resolution Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Symptom Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Fault Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Fault Area Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Fault Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Service Contract No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Service Order No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Service Item Group (Serviced)"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Serial No. (Serviced)"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Item No. (Serviced)"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Service Item No. (Serviced)"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Variant Code (Serviced)"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Bill-to Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Ship-to Code"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyWarrantyLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyServiceLedgerEntry@116();
    VAR
      DummyServiceLedgerEntry@1000 : Record 5907;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Job Posted"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Job Line Type"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Job Task No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Applies-to Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Apply Until Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO(Prepaid));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Service Price Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Serv. Price Adjmt. Gr. Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO(Open));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Variant Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Responsibility Center"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Bin Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Work Type Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Job No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Service Order No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Service Order Type"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Fault Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Bill-to Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Contract Disc. Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Discount %"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Unit Price"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Charged Qty."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Unit Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Discount Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Cost Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO(Type));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Contract Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Variant Code (Serviced)"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Service Item No. (Serviced)"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Contract Invoice Period"));
      SetFieldToPersonal(TableNo,DummyServiceLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Serial No. (Serviced)"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Item No. (Serviced)"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Ship-to Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Moved from Prepaid Acc."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Document Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Serv. Contract Acc. Gr. Code"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Service Contract No."));
      SetFieldToCompanyConfidential(TableNo,DummyServiceLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyTermsAndConditionsState@117();
    VAR
      DummyTermsAndConditionsState@1000 : Record 9191;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Terms And Conditions State";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyTermsAndConditionsState.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyServiceLine@118();
    VAR
      DummyServiceLine@1000 : Record 5902;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyServiceHeader@119();
    VAR
      DummyServiceHeader@1000 : Record 5900;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Assigned User ID"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to Phone 2"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to Phone"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to E-Mail"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to Fax No."));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Phone No. 2"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Contact Name"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO(Name));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummyServiceHeader.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifyDetailedVendorLedgEntry@120();
    VAR
      DummyDetailedVendorLedgEntry@1000 : Record 380;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Detailed Vendor Ledg. Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Ledger Entry Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Application No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Tax Jurisdiction Code"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Max. Payment Tolerance"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Remaining Pmt. Disc. Possible"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Unapplied by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO(Unapplied));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Applied Vend. Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Initial Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("VAT Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("VAT Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Use Tax"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Initial Entry Global Dim. 2"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Initial Entry Global Dim. 1"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Initial Entry Due Date"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Credit Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Debit Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Vendor No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Vendor Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedVendorLedgEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyDetailedCustLedgEntry@121();
    VAR
      DummyDetailedCustLedgEntry@1000 : Record 379;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Detailed Cust. Ledg. Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Ledger Entry Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Application No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Tax Jurisdiction Code"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Max. Payment Tolerance"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Remaining Pmt. Disc. Possible"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Unapplied by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO(Unapplied));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Applied Cust. Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Initial Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("VAT Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("VAT Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Use Tax"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Initial Entry Global Dim. 2"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Initial Entry Global Dim. 1"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Initial Entry Due Date"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Credit Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Debit Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyDetailedCustLedgEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Cust. Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyDetailedCustLedgEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyPostedPaymentReconLine@122();
    VAR
      DummyPostedPaymentReconLine@1000 : Record 1296;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Posted Payment Recon. Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPostedPaymentReconLine.FIELDNO("Related-Party Name"));
    END;

    LOCAL PROCEDURE ClassifyAppliedPaymentEntry@123();
    VAR
      DummyAppliedPaymentEntry@1000 : Record 1294;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Applied Payment Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Due Date"));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO(Quality));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Applied Pmt. Discount"));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Applied Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Applies-to Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Statement Type"));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Match Confidence"));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Statement Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Statement No."));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("Bank Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyAppliedPaymentEntry.FIELDNO("External Document No."));
    END;

    LOCAL PROCEDURE ClassifySelectedDimension@124();
    VAR
      DummySelectedDimension@1000 : Record 369;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Selected Dimension";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySelectedDimension.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyConfigLine@125();
    VAR
      DummyConfigLine@1000 : Record 8622;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Config. Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyConfigLine.FIELDNO("Responsible ID"));
    END;

    LOCAL PROCEDURE ClassifyItemApplicationEntryHistory@126();
    VAR
      DummyItemApplicationEntryHistory@1000 : Record 343;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Item Application Entry History";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Output Completely Invd. Date"));
      SetFieldToPersonal(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Deleted By User"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Deleted Date"));
      SetFieldToPersonal(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Last Modified By User"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Last Modified Date"));
      SetFieldToPersonal(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Created By User"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Creation Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Transferred-from Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Primary Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Outbound Item Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Inbound Item Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Item Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntryHistory.FIELDNO("Cost Application"));
    END;

    LOCAL PROCEDURE ClassifyConfigPackageTable@127();
    VAR
      DummyConfigPackageTable@1000 : Record 8613;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Config. Package Table";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyConfigPackageTable.FIELDNO("Created by User ID"));
      SetFieldToPersonal(TableNo,DummyConfigPackageTable.FIELDNO("Imported by User ID"));
    END;

    LOCAL PROCEDURE ClassifyItemApplicationEntry@128();
    VAR
      DummyItemApplicationEntry@1000 : Record 339;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Item Application Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Outbound Entry is Updated"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Output Completely Invd. Date"));
      SetFieldToPersonal(TableNo,DummyItemApplicationEntry.FIELDNO("Last Modified By User"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Last Modified Date"));
      SetFieldToPersonal(TableNo,DummyItemApplicationEntry.FIELDNO("Created By User"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Creation Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Transferred-from Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Outbound Item Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Inbound Item Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Item Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemApplicationEntry.FIELDNO("Cost Application"));
    END;

    LOCAL PROCEDURE ClassifyReservationEntry@129();
    VAR
      DummyReservationEntry@1000 : Record 337;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Reservation Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("New Expiration Date"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("New Lot No."));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("New Serial No."));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Item Tracking"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO(Correction));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Variant Code"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Lot No."));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Quantity Invoiced (Base)"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Qty. to Invoice (Base)"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Qty. to Handle (Base)"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Expiration Date"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Warranty Date"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Appl.-to Item Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Planning Flexibility"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Suppressed Action Msg."));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO(Binding));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Qty. per Unit of Measure"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO(Positive));
      SetFieldToPersonal(TableNo,DummyReservationEntry.FIELDNO("Changed By"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Appl.-from Item Entry"));
      SetFieldToPersonal(TableNo,DummyReservationEntry.FIELDNO("Created By"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Serial No."));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Shipment Date"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Expected Receipt Date"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Item Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Source Ref. No."));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Source Prod. Order Line"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Source Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Source ID"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Source Subtype"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Transferred from Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Creation Date"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Disallow Cancellation"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Reservation Status"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Quantity (Base)"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyReservationEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyCalendarEvent@130();
    VAR
      DummyCalendarEvent@1000 : Record 2160;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Calendar Event";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCalendarEvent.FIELDNO(User));
    END;

    LOCAL PROCEDURE ClassifyCapacityLedgerEntry@131();
    VAR
      DummyCapacityLedgerEntry@1000 : Record 5832;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Capacity Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Order No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO(Subcontracting));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Work Shift Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Work Center Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Scrap Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Stop Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Qty. per Unit of Measure"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Variant Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Order Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Routing Reference No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Routing No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Ending Time"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Starting Time"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Completely Invoiced"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Last Output Line"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Qty. per Cap. Unit of Measure"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Cap. Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Order Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Concurrent Capacity"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Scrap Quantity"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Output Quantity"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Invoiced Quantity"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Stop Time"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Run Time"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Setup Time"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Work Center No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Operation No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO(Type));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("No."));
      SetFieldToCompanyConfidential(TableNo,DummyCapacityLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyPayableVendorLedgerEntry@132();
    VAR
      DummyPayableVendorLedgerEntry@1000 : Record 317;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Payable Vendor Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyPayableVendorLedgerEntry.FIELDNO(Future));
      SetFieldToCompanyConfidential(TableNo,DummyPayableVendorLedgerEntry.FIELDNO(Positive));
      SetFieldToCompanyConfidential(TableNo,DummyPayableVendorLedgerEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPayableVendorLedgerEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyPayableVendorLedgerEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyPayableVendorLedgerEntry.FIELDNO("Vendor Ledg. Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyPayableVendorLedgerEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyPayableVendorLedgerEntry.FIELDNO("Vendor No."));
      SetFieldToCompanyConfidential(TableNo,DummyPayableVendorLedgerEntry.FIELDNO(Priority));
    END;

    LOCAL PROCEDURE ClassifyReminderFinChargeEntry@133();
    VAR
      DummyReminderFinChargeEntry@1000 : Record 300;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Reminder/Fin. Charge Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Due Date"));
      SetFieldToPersonal(TableNo,DummyReminderFinChargeEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Remaining Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Customer Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Interest Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Interest Posted"));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Reminder Level"));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("No."));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO(Type));
      SetFieldToCompanyConfidential(TableNo,DummyReminderFinChargeEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyPositivePayEntryDetail@134();
    VAR
      DummyPositivePayEntryDetail@1000 : Record 1232;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Positive Pay Entry Detail";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO("Update Date"));
      SetFieldToPersonal(TableNo,DummyPositivePayEntryDetail.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO(Payee));
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO("Check No."));
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO("No."));
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO("Upload Date-Time"));
      SetFieldToCompanyConfidential(TableNo,DummyPositivePayEntryDetail.FIELDNO("Bank Account No."));
    END;

    LOCAL PROCEDURE ClassifySalesShipmentLine@135();
    VAR
      DummySalesShipmentLine@1000 : Record 111;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Shipment Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesShipmentLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyICOutboxSalesHeader@136();
    VAR
      DummyICOutboxSalesHeader@1000 : Record 426;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"IC Outbox Sales Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyICOutboxSalesHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyICOutboxSalesHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyICOutboxSalesHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyICOutboxSalesHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyICOutboxSalesHeader.FIELDNO("Ship-to Name"));
    END;

    LOCAL PROCEDURE ClassifyIssuedFinChargeMemoHeader@137();
    VAR
      DummyIssuedFinChargeMemoHeader@1000 : Record 304;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Issued Fin. Charge Memo Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyIssuedFinChargeMemoHeader.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyFinanceChargeMemoHeader@138();
    VAR
      DummyFinanceChargeMemoHeader@1000 : Record 302;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Finance Charge Memo Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO("Assigned User ID"));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyFinanceChargeMemoHeader.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyFiledServiceContractHeader@139();
    VAR
      DummyFiledServiceContractHeader@1000 : Record 5970;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Filed Service Contract Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Filed By"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Bill-to Name"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Contact Name"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyFiledServiceContractHeader.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyBinCreationWorksheetLine@140();
    VAR
      DummyBinCreationWorksheetLine@1000 : Record 7338;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Bin Creation Worksheet Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyBinCreationWorksheetLine.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyIssuedReminderHeader@141();
    VAR
      DummyIssuedReminderHeader@1000 : Record 297;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Issued Reminder Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyIssuedReminderHeader.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyReminderHeader@142();
    VAR
      DummyReminderHeader@1000 : Record 295;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Reminder Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO("Assigned User ID"));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyReminderHeader.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyDirectDebitCollectionEntry@143();
    VAR
      DummyDirectDebitCollectionEntry@1000 : Record 1208;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Direct Debit Collection Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Mandate ID"));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO(Status));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Sequence Type"));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Transaction ID"));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Transfer Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Transfer Date"));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Applies-to Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyDirectDebitCollectionEntry.FIELDNO("Direct Debit Collection No."));
    END;

    LOCAL PROCEDURE ClassifyValueEntry@144();
    VAR
      DummyValueEntry@1000 : Record 5802;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Value Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Exp. Cost Posted to G/L (ACY)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Expected Cost Posted to G/L"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost Amount (Non-Invtbl.)(ACY)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost Amount (Expected) (ACY)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost Amount (Non-Invtbl.)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost Amount (Expected)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Sales Amount (Expected)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Purchase Amount (Expected)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Purchase Amount (Actual)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO(Type));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Capacity Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO(Adjustment));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Variance Type"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Valuation Date"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO(Inventoriable));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Partial Revaluation"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Return Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Valued By Average Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Item Charge No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Expected Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Order Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Order No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Order Type"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Job Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Variant Code"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Document Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Job No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost per Unit (ACY)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost Posted to G/L (ACY)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost Amount (Actual) (ACY)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Drop Shipment"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost Posted to G/L"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost Amount (Actual)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Applies-to Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyValueEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Discount Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Salespers./Purch. Code"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Average Cost Exception"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Sales Amount (Actual)"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Job Task No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Cost per Unit"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Invoiced Quantity"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Item Ledger Entry Quantity"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Valued Quantity"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Item Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Source Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Inventory Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Item Ledger Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyValueEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyCustomerBankAccount@145();
    VAR
      DummyCustomerBankAccount@1000 : Record 287;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Customer Bank Account";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO(IBAN));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Home Page"));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Telex Answer Back"));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Country/Region Code"));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Transit No."));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Bank Account No."));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Bank Branch No."));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Telex No."));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyCustomerBankAccount.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyCreditTransferRegister@146();
    VAR
      DummyCreditTransferRegister@1000 : Record 1205;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Credit Transfer Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCreditTransferRegister.FIELDNO("Created by User"));
    END;

    LOCAL PROCEDURE ClassifyPhysInventoryLedgerEntry@147();
    VAR
      DummyPhysInventoryLedgerEntry@1000 : Record 281;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Phys. Inventory Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Phys Invt Counting Period Type"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Phys Invt Counting Period Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Variant Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Last Item Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Qty. (Phys. Inventory)"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Qty. (Calculated)"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Salespers./Purch. Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Unit Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Unit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Inventory Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyPhysInventoryLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyBankAccReconciliationLine@148();
    VAR
      DummyBankAccReconciliationLine@1000 : Record 274;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Bank Acc. Reconciliation Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyBankAccReconciliationLine.FIELDNO("Related-Party City"));
      SetFieldToPersonal(TableNo,DummyBankAccReconciliationLine.FIELDNO("Related-Party Address"));
      SetFieldToPersonal(TableNo,DummyBankAccReconciliationLine.FIELDNO("Related-Party Bank Acc. No."));
      SetFieldToPersonal(TableNo,DummyBankAccReconciliationLine.FIELDNO("Related-Party Name"));
    END;

    LOCAL PROCEDURE ClassifyTimeSheetLine@149();
    VAR
      DummyTimeSheetLine@1000 : Record 951;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Time Sheet Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyTimeSheetLine.FIELDNO("Approved By"));
      SetFieldToPersonal(TableNo,DummyTimeSheetLine.FIELDNO("Approver ID"));
    END;

    LOCAL PROCEDURE ClassifyCheckLedgerEntry@150();
    VAR
      DummyCheckLedgerEntry@1000 : Record 272;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Check Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Positive Pay Exported"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Data Exch. Voided Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Data Exch. Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("External Document No."));
      SetFieldToPersonal(TableNo,DummyCheckLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Statement Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Statement No."));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Statement Status"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO(Open));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Bal. Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Bal. Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Original Entry Status"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Entry Status"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Bank Payment Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Check Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Check No."));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Check Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Bank Account Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Bank Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyCheckLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyBankAccountLedgerEntry@151();
    VAR
      DummyBankAccountLedgerEntry@1000 : Record 271;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Bank Account Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Reversed Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Reversed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO(Reversed));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Credit Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Debit Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Statement Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Statement No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Statement Status"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Bal. Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Bal. Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Closed at Date"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Closed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO(Positive));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO(Open));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyBankAccountLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Our Contact Code"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Bank Acc. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Remaining Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Bank Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyBankAccountLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyBookingSync@152();
    VAR
      DummyBookingSync@1000 : Record 6702;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Booking Sync";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyBookingSync.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyExchangeSync@153();
    VAR
      DummyExchangeSync@1000 : Record 6700;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Exchange Sync";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyExchangeSync.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyO365SalesDocument@154();
    VAR
      DummyO365SalesDocument@1000 : Record 2103;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"O365 Sales Document";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyO365SalesDocument.FIELDNO("Sell-to Contact"));
      SetFieldToPersonal(TableNo,DummyO365SalesDocument.FIELDNO("Sell-to Customer Name"));
    END;

    LOCAL PROCEDURE ClassifyVATEntry@155();
    VAR
      DummyVATEntry@1000 : Record 254;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"VAT Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("EU Service"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Reversed Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Reversed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO(Reversed));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("VAT Registration No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Ship-to/Order Address Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Add.-Curr. VAT Difference"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("VAT Difference"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Add.-Curr. Rem. Unreal. Base"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Add.-Curr. Rem. Unreal. Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("VAT Base Discount %"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Add.-Currency Unrealized Base"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Add.-Currency Unrealized Amt."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Additional-Currency Base"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Additional-Currency Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("VAT Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("VAT Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Unrealized VAT Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Sales Tax Connection No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Tax on Tax"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Tax Type"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Tax Group Used"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Tax Jurisdiction Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Use Tax"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Tax Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Tax Liable"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Tax Area Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Remaining Unrealized Base"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Remaining Unrealized Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Unrealized Base"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Unrealized Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Internal Ref. No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Country/Region Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO(Closed));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Closed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyVATEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("EU 3-Party Trade"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Bill-to/Pay-to No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("VAT Calculation Type"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO(Base));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO(Type));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyVATEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyWarehouseActivityHeader@156();
    VAR
      DummyWarehouseActivityHeader@1000 : Record 5766;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Warehouse Activity Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyWarehouseActivityHeader.FIELDNO("Assigned User ID"));
    END;

    LOCAL PROCEDURE ClassifyVATRegistrationLog@157();
    VAR
      DummyVATRegistrationLog@1000 : Record 249;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"VAT Registration Log";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("Verified City"));
      SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("Verified Postcode"));
      SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("Verified Street"));
      SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("Verified Address"));
      SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("Verified Name"));
      SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("Country/Region Code"));
      SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("VAT Registration No."));
    END;

    LOCAL PROCEDURE ClassifyRequisitionLine@158();
    VAR
      DummyRequisitionLine@1000 : Record 246;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Requisition Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyRequisitionLine.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyServiceCrMemoLine@159();
    VAR
      DummyServiceCrMemoLine@1000 : Record 5995;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Service Cr.Memo Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyServiceCrMemoLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyJobRegister@160();
    VAR
      DummyJobRegister@1000 : Record 241;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Job Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyJobRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyResourceRegister@161();
    VAR
      DummyResourceRegister@1000 : Record 240;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Resource Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyResourceRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyReturnReceiptLine@162();
    VAR
      DummyReturnReceiptLine@1000 : Record 6661;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Return Receipt Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyReturnReceiptLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyReturnReceiptHeader@163();
    VAR
      DummyReturnReceiptHeader@1000 : Record 6660;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Return Receipt Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Sell-to County"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Sell-to Post Code"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Sell-to Contact"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Sell-to City"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Sell-to Address 2"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Sell-to Address"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Sell-to Customer Name 2"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Sell-to Customer Name"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummyReturnReceiptHeader.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifyOrderAddress@164();
    VAR
      DummyOrderAddress@1000 : Record 224;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Order Address";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO("Home Page"));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO("Telex Answer Back"));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO("Telex No."));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyOrderAddress.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyShiptoAddress@165();
    VAR
      DummyShipToAddress@1000 : Record 222;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Ship-to Address";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("Home Page"));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("Telex Answer Back"));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("Telex No."));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyShipToAddress.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyReturnShipmentLine@166();
    VAR
      DummyReturnShipmentLine@1000 : Record 6651;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Return Shipment Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyReturnShipmentLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyReturnShipmentHeader@167();
    VAR
      DummyReturnShipmentHeader@1000 : Record 6650;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Return Shipment Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Buy-from County"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Buy-from Post Code"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Pay-to County"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Pay-to Post Code"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Buy-from Contact"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Buy-from City"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Buy-from Address 2"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Buy-from Address"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Buy-from Vendor Name 2"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Buy-from Vendor Name"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Pay-to Contact"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Pay-to City"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Pay-to Address 2"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Pay-to Address"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Pay-to Name 2"));
      SetFieldToPersonal(TableNo,DummyReturnShipmentHeader.FIELDNO("Pay-to Name"));
    END;

    LOCAL PROCEDURE ClassifyResLedgerEntry@168();
    VAR
      DummyResLedgerEntry@1000 : Record 203;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Res. Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Order Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Order Type"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Order No."));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Quantity (Base)"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Qty. per Unit of Measure"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO(Chargeable));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyResLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Total Price"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Unit Price"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Total Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Unit Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Direct Unit Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Job No."));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Work Type Code"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Resource Group No."));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Resource No."));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyResLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyInsuranceRegister@169();
    VAR
      DummyInsuranceRegister@1000 : Record 5636;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Insurance Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyInsuranceRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyContractGainLossEntry@170();
    VAR
      DummyContractGainLossEntry@1000 : Record 5969;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Contract Gain/Loss Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO(Amount));
      SetFieldToPersonal(TableNo,DummyContractGainLossEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO("Ship-to Code"));
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO("Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO("Responsibility Center"));
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO("Type of Change"));
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO("Change Date"));
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO("Contract Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO("Contract No."));
      SetFieldToCompanyConfidential(TableNo,DummyContractGainLossEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyMyTimeSheets@171();
    VAR
      DummyMyTimeSheets@1000 : Record 9155;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"My Time Sheets";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyMyTimeSheets.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyCustomReportLayout@172();
    VAR
      DummyCustomReportLayout@1000 : Record 9650;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Custom Report Layout";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCustomReportLayout.FIELDNO("Last Modified by User"));
    END;

    LOCAL PROCEDURE ClassifyCostBudgetRegister@173();
    VAR
      DummyCostBudgetRegister@1000 : Record 1111;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cost Budget Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCostBudgetRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyCostBudgetEntry@174();
    VAR
      DummyCostBudgetEntry@1000 : Record 1109;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cost Budget Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Last Date Modified"));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Allocated with Journal No."));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO(Allocated));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("System-Created Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Source Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Allocation ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Allocation Description"));
      SetFieldToPersonal(TableNo,DummyCostBudgetEntry.FIELDNO("Last Modified By User"));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Cost Object Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Cost Center Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO(Date));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Cost Type No."));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Budget Name"));
      SetFieldToCompanyConfidential(TableNo,DummyCostBudgetEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyCostAllocationTarget@175();
    VAR
      DummyCostAllocationTarget@1000 : Record 1107;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cost Allocation Target";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCostAllocationTarget.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyCostAllocationSource@176();
    VAR
      DummyCostAllocationSource@1000 : Record 1106;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cost Allocation Source";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCostAllocationSource.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyCostRegister@177();
    VAR
      DummyCostRegister@1000 : Record 1105;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cost Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCostRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyCostEntry@178();
    VAR
      DummyCostEntry@1000 : Record 1104;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cost Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Allocated with Journal No."));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO(Allocated));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("System-Created Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Source Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("G/L Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("G/L Account"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Additional-Currency Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Cost Object Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Cost Center Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Allocation ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Allocation Description"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Add.-Currency Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Cost Type No."));
      SetFieldToPersonal(TableNo,DummyCostEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Add.-Currency Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyCostEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyCostType@179();
    VAR
      DummyCostType@1000 : Record 1103;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cost Type";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCostType.FIELDNO("Modified By"));
    END;

    LOCAL PROCEDURE ClassifyReversalEntry@180();
    VAR
      DummyReversalEntry@1000 : Record 179;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Reversal Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Reversal Type"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("FA Posting Type"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("FA Posting Category"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Bal. Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Bal. Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Account Name"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("VAT Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Credit Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Debit Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Source Code"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("G/L Register No."));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyReversalEntry.FIELDNO("Line No."));
    END;

    LOCAL PROCEDURE ClassifyJobLedgerEntry@181();
    VAR
      DummyJobLedgerEntry@1000 : Record 169;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Job Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Total Price"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Posted Service Shipment No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Service Order No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Line Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Qty. per Unit of Measure"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Line Type"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Variant Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Transaction Specification"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Ledger Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Description 2"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Quantity (Base)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Bin Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Add.-Currency Line Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Add.-Currency Total Price"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Additional-Currency Total Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO(Area));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Unit Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Entry/Exit Point"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Country/Region Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Transport Method"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Transaction Type"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Job Task No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Original Unit Cost (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Amt. Posted to G/L"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Amt. to Post to G/L"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Ledger Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("DateTime Adjusted"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO(Adjusted));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Original Total Cost (ACY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Original Total Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Original Unit Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Original Total Cost (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyJobLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Line Discount %"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Lot No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Serial No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Customer Price Group"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Work Type Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Job Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Currency Factor"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Line Discount Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Line Discount Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Line Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Unit Price"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Total Cost"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Resource Group No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Total Price (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Unit Price (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Total Cost (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Unit Cost (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Direct Unit Cost (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO(Type));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Job No."));
      SetFieldToCompanyConfidential(TableNo,DummyJobLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyTimeSheetLineArchive@182();
    VAR
      DummyTimeSheetLineArchive@1000 : Record 955;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Time Sheet Line Archive";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyTimeSheetLineArchive.FIELDNO("Approved By"));
      SetFieldToPersonal(TableNo,DummyTimeSheetLineArchive.FIELDNO("Approver ID"));
    END;

    LOCAL PROCEDURE ClassifyJob@183();
    VAR
      DummyJob@1000 : Record 167;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Job;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyJob.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummyJob.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummyJob.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummyJob.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummyJob.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummyJob.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummyJob.FIELDNO("Bill-to Name"));
      SetFieldToPersonal(TableNo,DummyJob.FIELDNO("Bill-to Contact"));
    END;

    LOCAL PROCEDURE ClassifyResCapacityEntry@184();
    VAR
      DummyResCapacityEntry@1000 : Record 160;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Res. Capacity Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyResCapacityEntry.FIELDNO(Capacity));
      SetFieldToCompanyConfidential(TableNo,DummyResCapacityEntry.FIELDNO(Date));
      SetFieldToCompanyConfidential(TableNo,DummyResCapacityEntry.FIELDNO("Resource Group No."));
      SetFieldToCompanyConfidential(TableNo,DummyResCapacityEntry.FIELDNO("Resource No."));
      SetFieldToCompanyConfidential(TableNo,DummyResCapacityEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyResource@185();
    VAR
      DummyResource@1000 : Record 156;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Resource;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO(Image));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO("Time Sheet Approver User ID"));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO("Time Sheet Owner User ID"));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO(Picture));
      SetFieldToSensitive(TableNo,DummyResource.FIELDNO("Employment Date"));
      SetFieldToSensitive(TableNo,DummyResource.FIELDNO(Education));
      SetFieldToSensitive(TableNo,DummyResource.FIELDNO("Social Security No."));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO("Search Name"));
      SetFieldToPersonal(TableNo,DummyResource.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyIncomingDocument@186();
    VAR
      DummyIncomingDocument@1000 : Record 130;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Incoming Document";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyIncomingDocument.FIELDNO("Vendor Phone No."));
      SetFieldToPersonal(TableNo,DummyIncomingDocument.FIELDNO("Vendor Bank Account No."));
      SetFieldToPersonal(TableNo,DummyIncomingDocument.FIELDNO("Vendor Bank Branch No."));
      SetFieldToPersonal(TableNo,DummyIncomingDocument.FIELDNO("Vendor IBAN"));
      SetFieldToPersonal(TableNo,DummyIncomingDocument.FIELDNO("Vendor VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyIncomingDocument.FIELDNO("Vendor Name"));
      SetFieldToPersonal(TableNo,DummyIncomingDocument.FIELDNO("Last Modified By User ID"));
      SetFieldToPersonal(TableNo,DummyIncomingDocument.FIELDNO("Released By User ID"));
      SetFieldToPersonal(TableNo,DummyIncomingDocument.FIELDNO("Created By User ID"));
    END;

    LOCAL PROCEDURE ClassifyWarehouseRegister@187();
    VAR
      DummyWarehouseRegister@1000 : Record 7313;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Warehouse Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyWarehouseRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyPurchCrMemoLine@188();
    VAR
      DummyPurchCrMemoLine@1000 : Record 125;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purch. Cr. Memo Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchCrMemoLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyPurchCrMemoHdr@189();
    VAR
      DummyPurchCrMemoHdr@1000 : Record 124;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purch. Cr. Memo Hdr.";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Buy-from County"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Buy-from Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Pay-to County"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Pay-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Buy-from Contact"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Buy-from City"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Buy-from Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Buy-from Address"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Buy-from Vendor Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Buy-from Vendor Name"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Pay-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Pay-to City"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Pay-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Pay-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Pay-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchCrMemoHdr.FIELDNO("Pay-to Name"));
    END;

    LOCAL PROCEDURE ClassifyPurchInvLine@190();
    VAR
      DummyPurchInvLine@1000 : Record 123;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purch. Inv. Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchInvLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyPurchInvHeader@191();
    VAR
      DummyPurchInvHeader@1000 : Record 122;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purch. Inv. Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Creditor No."));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Buy-from County"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Buy-from Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Pay-to County"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Pay-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Buy-from Contact"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Buy-from City"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Buy-from Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Buy-from Address"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Buy-from Vendor Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Buy-from Vendor Name"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Pay-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Pay-to City"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Pay-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Pay-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Pay-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchInvHeader.FIELDNO("Pay-to Name"));
    END;

    LOCAL PROCEDURE ClassifyPurchRcptLine@192();
    VAR
      DummyPurchRcptLine@1000 : Record 121;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purch. Rcpt. Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchRcptLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyPurchRcptHeader@193();
    VAR
      DummyPurchRcptHeader@1000 : Record 120;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purch. Rcpt. Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Buy-from County"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Buy-from Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Pay-to County"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Pay-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Buy-from Contact"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Buy-from City"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Buy-from Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Buy-from Address"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Buy-from Vendor Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Buy-from Vendor Name"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Pay-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Pay-to City"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Pay-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Pay-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Pay-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchRcptHeader.FIELDNO("Pay-to Name"));
    END;

    LOCAL PROCEDURE ClassifySalesCrMemoLine@194();
    VAR
      DummySalesCrMemoLine@1000 : Record 115;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Cr.Memo Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesCrMemoLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifySalesCrMemoHeader@195();
    VAR
      DummySalesCrMemoHeader@1000 : Record 114;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Cr.Memo Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Sell-to County"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Sell-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Sell-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Sell-to City"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Sell-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Sell-to Address"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Sell-to Customer Name 2"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Sell-to Customer Name"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesCrMemoHeader.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifySalesInvoiceLine@196();
    VAR
      DummySalesInvoiceLine@1000 : Record 113;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Invoice Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesInvoiceLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifySalesInvoiceHeader@197();
    VAR
      DummySalesInvoiceHeader@1000 : Record 112;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Invoice Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Sell-to County"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Sell-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Sell-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Sell-to City"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Sell-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Sell-to Address"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Sell-to Customer Name 2"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Sell-to Customer Name"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesInvoiceHeader.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifyMaintenanceLedgerEntry@198();
    VAR
      DummyMaintenanceLedgerEntry@1000 : Record 5625;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Maintenance Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Reversed Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Reversed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO(Reversed));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("VAT Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("VAT Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Use Tax"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Tax Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Tax Liable"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Tax Area Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Automatic Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Index Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO(Correction));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Maintenance Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("FA Exchange Rate"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Depreciation Book Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("FA Class Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Gen. Posting Type"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("VAT Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Bal. Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Bal. Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Source Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Journal Batch Name"));
      SetFieldToPersonal(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("FA Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("FA Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("FA Subclass Code"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("FA No./Budgeted FA No."));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("FA Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("FA No."));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("G/L Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyMaintenanceLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifySalesShipmentHeader@199();
    VAR
      DummySalesShipmentHeader@1000 : Record 110;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Shipment Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("User ID"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Sell-to County"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Sell-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Sell-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Sell-to City"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Sell-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Sell-to Address"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Sell-to Customer Name 2"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Sell-to Customer Name"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesShipmentHeader.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifyFARegister@200();
    VAR
      DummyFARegister@1000 : Record 5617;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"FA Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyFARegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyMaintenanceRegistration@201();
    VAR
      DummyMaintenanceRegistration@1000 : Record 5616;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Maintenance Registration";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyMaintenanceRegistration.FIELDNO("Service Agent Mobile Phone"));
      SetFieldToPersonal(TableNo,DummyMaintenanceRegistration.FIELDNO("Service Agent Phone No."));
      SetFieldToPersonal(TableNo,DummyMaintenanceRegistration.FIELDNO("Service Agent Name"));
    END;

    LOCAL PROCEDURE ClassifyWorkflowStepArgumentArchive@202();
    VAR
      DummyWorkflowStepArgumentArchive@1000 : Record 1531;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Workflow Step Argument Archive";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyWorkflowStepArgumentArchive.FIELDNO("Response User ID"));
      SetFieldToPersonal(TableNo,DummyWorkflowStepArgumentArchive.FIELDNO("Approver User ID"));
      SetFieldToPersonal(TableNo,DummyWorkflowStepArgumentArchive.FIELDNO("Notification User ID"));
    END;

    LOCAL PROCEDURE ClassifyGLBudgetEntry@203();
    VAR
      DummyGLBudgetEntry@1000 : Record 96;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"G/L Budget Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Last Date Modified"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Budget Dimension 4 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Budget Dimension 3 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Budget Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Budget Dimension 1 Code"));
      SetFieldToPersonal(TableNo,DummyGLBudgetEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Business Unit Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO(Date));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("G/L Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Budget Name"));
      SetFieldToCompanyConfidential(TableNo,DummyGLBudgetEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyUserSetup@204();
    VAR
      DummyUserSetup@1000 : Record 91;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Setup";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserSetup.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyUserSetup.FIELDNO(Substitute));
      SetFieldToPersonal(TableNo,DummyUserSetup.FIELDNO("Approver ID"));
      SetFieldToPersonal(TableNo,DummyUserSetup.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyFALedgerEntry@205();
    VAR
      DummyFALedgerEntry@1000 : Record 5601;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"FA Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Reversed Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Reversed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO(Reversed));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("VAT Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("VAT Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Use Tax"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Tax Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Tax Liable"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Tax Area Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Property Class (Custom 1)"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Depr. % this year (Custom 1)"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Accum. Depr. % (Custom 1)"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Depr. Ending Date (Custom 1)"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Depr. Starting Date (Custom 1)"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Automatic Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Use FA Ledger Check"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Depreciation Ending Date"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Canceled from FA No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Index Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO(Correction));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Result on Disposal"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA Exchange Rate"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA Class Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Gen. Posting Type"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("VAT Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Bal. Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Bal. Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Source Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Depreciation Table Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Declining-Balance %"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Fixed Depr. Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("No. of Depreciation Years"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Straight-Line %"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Depreciation Starting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Depreciation Method"));
      SetFieldToPersonal(TableNo,DummyFALedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA Subclass Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA No./Budgeted FA No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("No. of Depreciation Days"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Disposal Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Disposal Calculation Method"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Part of Depreciable Basis"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Part of Book Value"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Reclassification Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA Posting Type"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA Posting Category"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Depreciation Book Code"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("FA No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("G/L Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyFALedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyJobPlanningLine@206();
    VAR
      DummyJobPlanningLine@1000 : Record 1003;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Job Planning Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyJobPlanningLine.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyGenJournalLine@207();
    VAR
      DummyGenJournalLine@1000 : Record 81;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Gen. Journal Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyGenJournalLine.FIELDNO("VAT Registration No."));
    END;

    LOCAL PROCEDURE ClassifyPrinterSelection@208();
    VAR
      DummyPrinterSelection@1000 : Record 78;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Printer Selection";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPrinterSelection.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyTimeSheetChartSetup@209();
    VAR
      DummyTimeSheetChartSetup@1000 : Record 959;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Time Sheet Chart Setup";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyTimeSheetChartSetup.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyUserTimeRegister@210();
    VAR
      DummyUserTimeRegister@1000 : Record 51;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"User Time Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyUserTimeRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyItemRegister@211();
    VAR
      DummyItemRegister@1000 : Record 46;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Item Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyItemRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyGLRegister@212();
    VAR
      DummyGLRegister@1000 : Record 45;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"G/L Register";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyGLRegister.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyPurchaseLine@213();
    VAR
      DummyPurchaseLine@1000 : Record 39;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purchase Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchaseLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifyPurchaseHeader@214();
    VAR
      DummyPurchaseHeader@1000 : Record 38;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Purchase Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Assigned User ID"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Creditor No."));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Buy-from County"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Buy-from Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Pay-to County"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Pay-to Post Code"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Buy-from Contact"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Buy-from City"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Buy-from Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Buy-from Address"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Buy-from Vendor Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Buy-from Vendor Name"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Pay-to Contact"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Pay-to City"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Pay-to Address 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Pay-to Address"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Pay-to Name 2"));
      SetFieldToPersonal(TableNo,DummyPurchaseHeader.FIELDNO("Pay-to Name"));
    END;

    LOCAL PROCEDURE ClassifySalesLine@215();
    VAR
      DummySalesLine@1000 : Record 37;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Line";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesLine.FIELDNO("Tax Area Code"));
    END;

    LOCAL PROCEDURE ClassifySalesHeader@216();
    VAR
      DummySalesHeader@1000 : Record 36;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Sales Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Assigned User ID"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Ship-to County"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Ship-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Sell-to County"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Sell-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Bill-to County"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Bill-to Post Code"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Sell-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Sell-to City"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Sell-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Sell-to Address"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Sell-to Customer Name 2"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Sell-to Customer Name"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Ship-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Ship-to City"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Ship-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Ship-to Address"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Ship-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Ship-to Name"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Bill-to Contact"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Bill-to City"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Bill-to Address 2"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Bill-to Address"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Bill-to Name 2"));
      SetFieldToPersonal(TableNo,DummySalesHeader.FIELDNO("Bill-to Name"));
    END;

    LOCAL PROCEDURE ClassifyTimeSheetHeaderArchive@217();
    VAR
      DummyTimeSheetHeaderArchive@1000 : Record 954;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Time Sheet Header Archive";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyTimeSheetHeaderArchive.FIELDNO("Approver User ID"));
      SetFieldToPersonal(TableNo,DummyTimeSheetHeaderArchive.FIELDNO("Owner User ID"));
    END;

    LOCAL PROCEDURE ClassifyItemLedgerEntry@218();
    VAR
      DummyItemLedgerEntry@1000 : Record 32;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Item Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Serial No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Product Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Purchasing Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO(Nonstock));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Item Category Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Out-of-Stock Substitution"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Originally Ordered Var. Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Originally Ordered No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Cross-Reference No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Order Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Order Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Unit of Measure Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Prod. Order Comp. Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Assemble to Order"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Return Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Shipped Qty. Not Returned"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO(Correction));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Applied Entry to Adjust"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Last Invoice Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Completely Invoiced"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Qty. per Unit of Measure"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Variant Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Document Line No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Order No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Transaction Specification"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO(Area));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Entry/Exit Point"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Country/Region Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Transport Method"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Transaction Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Drop Shipment"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Derived from Blanket Order"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO(Positive));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO(Open));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Applies-to Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Expiration Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Job Purchase"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Job Task No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Job No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Invoiced Quantity"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Remaining Quantity"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Warranty Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Item Tracking"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Location Code"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Item No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyItemLedgerEntry.FIELDNO("Lot No."));
    END;

    LOCAL PROCEDURE ClassifyTimeSheetHeader@219();
    VAR
      DummyTimeSheetHeader@1000 : Record 950;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Time Sheet Header";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyTimeSheetHeader.FIELDNO("Approver User ID"));
      SetFieldToPersonal(TableNo,DummyTimeSheetHeader.FIELDNO("Owner User ID"));
    END;

    LOCAL PROCEDURE ClassifyItem@220();
    VAR
      DummyItem@1000 : Record 27;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Item;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyItem.FIELDNO("Application Wksh. User ID"));
    END;

    LOCAL PROCEDURE ClassifyVendorLedgerEntry@221();
    VAR
      DummyVendorLedgerEntry@1000 : Record 25;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Vendor Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Applies-to Ext. Doc. No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Payment Method Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Payment Reference"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Creditor No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Exported to Payment File"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Message to Recipient"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Recipient Bank Account"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO(Prepayment));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Reversed Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Reversed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO(Reversed));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Applying Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("IC Partner Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Amount to Apply"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Pmt. Tolerance (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Accepted Pmt. Disc. Tolerance"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Accepted Payment Tolerance"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Max. Payment Tolerance"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Pmt. Disc. Tolerance Date"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Remaining Pmt. Disc. Possible"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Original Currency Factor"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Adjusted Currency Factor"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Closed by Currency Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Closed by Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Closed by Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Bal. Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Bal. Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Applies-to ID"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Closed by Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Closed at Date"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Closed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO(Positive));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Pmt. Disc. Rcd.(LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Original Pmt. Disc. Possible"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Pmt. Discount Date"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Due Date"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO(Open));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Applies-to Doc. No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Applies-to Doc. Type"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("On Hold"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyVendorLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Purchaser Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Vendor Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Buy-from Vendor No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Inv. Discount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Purchase (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Vendor No."));
      SetFieldToCompanyConfidential(TableNo,DummyVendorLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyVendor@222();
    VAR
      DummyVendor@1000 : Record 23;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Vendor;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Creditor No."));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO(Image));
      SetFieldToCompanyConfidential(TableNo,DummyVendor.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Home Page"));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO(GLN));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO(Picture));
      SetFieldToSensitive(TableNo,DummyVendor.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Telex Answer Back"));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Telex No."));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO("Search Name"));
      SetFieldToPersonal(TableNo,DummyVendor.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyCustLedgerEntry@223();
    VAR
      DummyCustLedgerEntry@1000 : Record 21;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Cust. Ledger Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Applies-to Ext. Doc. No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Payment Method Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Direct Debit Mandate ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Exported to Payment File"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Message to Recipient"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Recipient Bank Account"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO(Prepayment));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Reversed Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Reversed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO(Reversed));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Applying Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("IC Partner Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Amount to Apply"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Pmt. Tolerance (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Accepted Pmt. Disc. Tolerance"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Accepted Payment Tolerance"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Last Issued Reminder Level"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Max. Payment Tolerance"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Pmt. Disc. Tolerance Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Remaining Pmt. Disc. Possible"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Original Currency Factor"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Adjusted Currency Factor"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Closed by Currency Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Closed by Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Closing Interest Calculated"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Calculate Interest"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Closed by Amount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Bal. Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Bal. Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Applies-to ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Closed by Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Closed at Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Closed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO(Positive));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Pmt. Disc. Given (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Original Pmt. Disc. Possible"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Pmt. Discount Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Due Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO(Open));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Applies-to Doc. No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Applies-to Doc. Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("On Hold"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyCustLedgerEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Salesperson Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Customer Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Sell-to Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Inv. Discount (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Profit (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Sales (LCY)"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Currency Code"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Customer No."));
      SetFieldToCompanyConfidential(TableNo,DummyCustLedgerEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifyMyAccount@224();
    VAR
      DummyMyAccount@1000 : Record 9153;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"My Account";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyMyAccount.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyCustomer@225();
    VAR
      DummyCustomer@1000 : Record 18;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::Customer;
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO(Image));
      SetFieldToCompanyConfidential(TableNo,DummyCustomer.FIELDNO("Tax Area Code"));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("Home Page"));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO(GLN));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO(Picture));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("VAT Registration No."));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("Telex Answer Back"));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("Telex No."));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO("Search Name"));
      SetFieldToPersonal(TableNo,DummyCustomer.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyGLEntry@226();
    VAR
      DummyGLEntry@1000 : Record 17;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"G/L Entry";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Last Modified DateTime"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("FA Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("FA Entry Type"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Account Id"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Reversed Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Reversed by Entry No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO(Reversed));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("IC Partner Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Close Income Statement Dim. ID"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Add.-Currency Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Add.-Currency Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Additional-Currency Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("VAT Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("VAT Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Use Tax"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Tax Group Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Tax Liable"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Tax Area Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("No. Series"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Source No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Source Type"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("External Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Document Date"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Credit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Debit Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Transaction No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Bal. Account Type"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Gen. Prod. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Gen. Bus. Posting Group"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Gen. Posting Type"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Reason Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Journal Batch Name"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Business Unit Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("VAT Amount"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO(Quantity));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Job No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Prod. Order No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Dimension Set ID"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Prior-Year Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("System-Created Entry"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Source Code"));
      SetFieldToPersonal(TableNo,DummyGLEntry.FIELDNO("User ID"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Global Dimension 2 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Global Dimension 1 Code"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO(Amount));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Bal. Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO(Description));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Document No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Document Type"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Posting Date"));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("G/L Account No."));
      SetFieldToCompanyConfidential(TableNo,DummyGLEntry.FIELDNO("Entry No."));
    END;

    LOCAL PROCEDURE ClassifySalespersonPurchaser@227();
    VAR
      DummySalespersonPurchaser@1000 : Record 13;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Salesperson/Purchaser";
      SetTableFieldsToNormal(TableNo);
      SetFieldToCompanyConfidential(TableNo,DummySalespersonPurchaser.FIELDNO("Job Title"));
      SetFieldToPersonal(TableNo,DummySalespersonPurchaser.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummySalespersonPurchaser.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummySalespersonPurchaser.FIELDNO(Image));
      SetFieldToPersonal(TableNo,DummySalespersonPurchaser.FIELDNO("E-Mail 2"));
      SetFieldToPersonal(TableNo,DummySalespersonPurchaser.FIELDNO("Search E-Mail"));
      SetFieldToPersonal(TableNo,DummySalespersonPurchaser.FIELDNO(Name));
    END;

    LOCAL PROCEDURE ClassifyManufacturingUserTemplate@228();
    VAR
      DummyManufacturingUserTemplate@1000 : Record 5525;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Manufacturing User Template";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyManufacturingUserTemplate.FIELDNO("User ID"));
    END;

    LOCAL PROCEDURE ClassifyVendorBankAccount@229();
    VAR
      DummyVendorBankAccount@1000 : Record 288;
      TableNo@1002 : Integer;
    BEGIN
      TableNo := DATABASE::"Vendor Bank Account";
      SetTableFieldsToNormal(TableNo);
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO(IBAN));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Home Page"));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("E-Mail"));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Language Code"));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Telex Answer Back"));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Fax No."));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO(County));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Country/Region Code"));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Transit No."));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Bank Account No."));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Bank Branch No."));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Telex No."));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Phone No."));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO(Contact));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Post Code"));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO(City));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Address 2"));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO(Address));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO("Name 2"));
      SetFieldToPersonal(TableNo,DummyVendorBankAccount.FIELDNO(Name));
    END;

    BEGIN
    END.
  }
}

