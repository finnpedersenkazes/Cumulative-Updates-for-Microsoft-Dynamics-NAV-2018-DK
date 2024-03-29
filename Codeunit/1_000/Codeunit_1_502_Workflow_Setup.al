OBJECT Codeunit 1502 Workflow Setup
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      MsTemplateTok@1065 : TextConst '@@@={Locked};DAN=MS-;ENU=MS-';
      MsWizardWorkflowTok@1066 : TextConst '@@@={Locked};DAN=WZ-;ENU=WZ-';
      PurchInvWorkflowCodeTxt@1002 : TextConst '@@@={Locked};DAN=PIW;ENU=PIW';
      PurchInvWorkflowDescriptionTxt@1001 : TextConst 'DAN=K�bsfakturaworkflow;ENU=Purchase Invoice Workflow';
      IncDocOCRWorkflowCodeTxt@1090 : TextConst '@@@={Locked};DAN=INCDOC-OCR;ENU=INCDOC-OCR';
      IncDocOCRWorkflowDescriptionTxt@1091 : TextConst 'DAN=Indg�ende OCR-bilagsworkflow;ENU=Incoming Document OCR Workflow';
      IncDocToGenJnlLineOCRWorkflowCodeTxt@1050 : TextConst '@@@={Locked};DAN=INCDOC-JNL-OCR;ENU=INCDOC-JNL-OCR';
      IncDocToGenJnlLineOCRWorkflowDescriptionTxt@1049 : TextConst 'DAN=Indg�ende bilag til finanskladdelinjes OCR-workflow;ENU=Incoming Document to General Journal Line OCR Workflow';
      IncDocExchWorkflowCodeTxt@1092 : TextConst '@@@={Locked};DAN=INCDOC-DOCEXCH;ENU=INCDOC-DOCEXCH';
      IncDocExchWorkflowDescriptionTxt@1093 : TextConst 'DAN=Workflow for indg�ende dokumentudveksling;ENU=Incoming Document Exchange Workflow';
      IncDocWorkflowCodeTxt@1004 : TextConst '@@@={Locked};DAN=INCDOC;ENU=INCDOC';
      IncDocWorkflowDescTxt@1005 : TextConst 'DAN=Indg�ende bilagsworkflow;ENU=Incoming Document Workflow';
      IncomingDocumentApprWorkflowCodeTxt@1080 : TextConst '@@@={Locked};DAN=INCDOCAPW;ENU=INCDOCAPW';
      PurchInvoiceApprWorkflowCodeTxt@1006 : TextConst '@@@={Locked};DAN=PIAPW;ENU=PIAPW';
      PurchReturnOrderApprWorkflowCodeTxt@1012 : TextConst '@@@={Locked};DAN=PROAPW;ENU=PROAPW';
      PurchQuoteApprWorkflowCodeTxt@1016 : TextConst '@@@={Locked};DAN=PQAPW;ENU=PQAPW';
      PurchOrderApprWorkflowCodeTxt@1018 : TextConst '@@@={Locked};DAN=POAPW;ENU=POAPW';
      PurchCreditMemoApprWorkflowCodeTxt@1019 : TextConst '@@@={Locked};DAN=PCMAPW;ENU=PCMAPW';
      PurchBlanketOrderApprWorkflowCodeTxt@1020 : TextConst '@@@={Locked};DAN=BPOAPW;ENU=BPOAPW';
      IncomingDocumentApprWorkflowDescTxt@1081 : TextConst 'DAN=Godkendelsesworkflow for indg�ende bilag;ENU=Incoming Document Approval Workflow';
      PurchInvoiceApprWorkflowDescTxt@1007 : TextConst 'DAN=Godkendelsesworkflow for k�bsfaktura;ENU=Purchase Invoice Approval Workflow';
      PurchReturnOrderApprWorkflowDescTxt@1014 : TextConst 'DAN=Godkendelsesworkflow for returvareordre;ENU=Purchase Return Order Approval Workflow';
      PurchQuoteApprWorkflowDescTxt@1023 : TextConst 'DAN=Godkendelsesworkflow for k�bsrekvisition;ENU=Purchase Quote Approval Workflow';
      PurchOrderApprWorkflowDescTxt@1022 : TextConst 'DAN=Godkendelsesworkflow for k�bsordre;ENU=Purchase Order Approval Workflow';
      PurchCreditMemoApprWorkflowDescTxt@1025 : TextConst 'DAN=Godkendelsesworkflow for k�bskreditnota;ENU=Purchase Credit Memo Approval Workflow';
      PurchBlanketOrderApprWorkflowDescTxt@1024 : TextConst 'DAN=Godkendelsesworkflow for rammek�bsordre;ENU=Blanket Purchase Order Approval Workflow';
      PendingApprovalsCondnTxt@1017 : TextConst '@@@={Locked};DAN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Approval Entry"">%1</DataItem></DataItems></ReportParameters>";ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Approval Entry"">%1</DataItem></DataItems></ReportParameters>"';
      PurchHeaderTypeCondnTxt@1011 : TextConst '@@@={Locked};DAN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Purchase Header"">%1</DataItem><DataItem name=""Purchase Line"">%2</DataItem></DataItems></ReportParameters>";ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Purchase Header"">%1</DataItem><DataItem name=""Purchase Line"">%2</DataItem></DataItems></ReportParameters>"';
      SalesHeaderTypeCondnTxt@1035 : TextConst '@@@={Locked};DAN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Sales Header"">%1</DataItem><DataItem name=""Sales Line"">%2</DataItem></DataItems></ReportParameters>";ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Sales Header"">%1</DataItem><DataItem name=""Sales Line"">%2</DataItem></DataItems></ReportParameters>"';
      IncomingDocumentTypeCondnTxt@1083 : TextConst '@@@={Locked};DAN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Incoming Document"">%1</DataItem><DataItem name=""Incoming Document Attachment"">%2</DataItem></DataItems></ReportParameters>";ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Incoming Document"">%1</DataItem><DataItem name=""Incoming Document Attachment"">%2</DataItem></DataItems></ReportParameters>"';
      CustomerTypeCondnTxt@1149 : TextConst '@@@={Locked};DAN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Customer"">%1</DataItem></DataItems></ReportParameters>";ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Customer"">%1</DataItem></DataItems></ReportParameters>"';
      VendorTypeCondnTxt@1100 : TextConst '@@@={Locked};DAN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Vendor"">%1</DataItem></DataItems></ReportParameters>";ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Vendor"">%1</DataItem></DataItems></ReportParameters>"';
      ItemTypeCondnTxt@1101 : TextConst '@@@={Locked};DAN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Item"">%1</DataItem></DataItems></ReportParameters>";ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Item"">%1</DataItem></DataItems></ReportParameters>"';
      GeneralJournalBatchTypeCondnTxt@1059 : TextConst '@@@={Locked};DAN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Gen. Journal Batch"">%1</DataItem></DataItems></ReportParameters>";ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Gen. Journal Batch"">%1</DataItem></DataItems></ReportParameters>"';
      GeneralJournalLineTypeCondnTxt@1063 : TextConst '@@@={Locked};DAN="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Gen. Journal Line"">%1</DataItem></DataItems></ReportParameters>";ENU="<?xml version=""1.0"" encoding=""utf-8"" standalone=""yes""?><ReportParameters><DataItems><DataItem name=""Gen. Journal Line"">%1</DataItem></DataItems></ReportParameters>"';
      InvalidEventCondErr@1026 : TextConst 'DAN=Der er ikke angivet nogen h�ndelsesbetingelser.;ENU=No event conditions are specified.';
      OverdueWorkflowCodeTxt@1000 : TextConst '@@@={Locked};DAN=OVERDUE;ENU=OVERDUE';
      OverdueWorkflowDescTxt@1003 : TextConst 'DAN=Workflow for forfaldne godkendelsesanmodninger;ENU=Overdue Approval Requests Workflow';
      WorkflowEventHandling@1052 : Codeunit 1520;
      WorkflowResponseHandling@1051 : Codeunit 1521;
      WorkflowRequestPageHandling@1060 : Codeunit 1522;
      BlankDateFormula@1009 : DateFormula;
      SalesInvoiceApprWorkflowCodeTxt@1034 : TextConst '@@@={Locked};DAN=SIAPW;ENU=SIAPW';
      SalesReturnOrderApprWorkflowCodeTxt@1033 : TextConst '@@@={Locked};DAN=SROAPW;ENU=SROAPW';
      SalesQuoteApprWorkflowCodeTxt@1032 : TextConst '@@@={Locked};DAN=SQAPW;ENU=SQAPW';
      SalesOrderApprWorkflowCodeTxt@1031 : TextConst '@@@={Locked};DAN=SOAPW;ENU=SOAPW';
      SalesCreditMemoApprWorkflowCodeTxt@1030 : TextConst '@@@={Locked};DAN=SCMAPW;ENU=SCMAPW';
      SalesBlanketOrderApprWorkflowCodeTxt@1029 : TextConst '@@@={Locked};DAN=BSOAPW;ENU=BSOAPW';
      SalesInvoiceCreditLimitApprWorkflowCodeTxt@1036 : TextConst '@@@={Locked};DAN=SICLAPW;ENU=SICLAPW';
      SalesOrderCreditLimitApprWorkflowCodeTxt@1037 : TextConst '@@@={Locked};DAN=SOCLAPW;ENU=SOCLAPW';
      SalesRetOrderCrLimitApprWorkflowCodeTxt@1043 : TextConst '@@@={Locked};DAN=SROCLAPW;ENU=SROCLAPW';
      SalesQuoteCrLimitApprWorkflowCodeTxt@1042 : TextConst '@@@={Locked};DAN=SQCLAPW;ENU=SQCLAPW';
      SalesCrMemoCrLimitApprWorkflowCodeTxt@1041 : TextConst '@@@={Locked};DAN=SCMCLAPW;ENU=SCMCLAPW';
      SalesBlanketOrderCrLimitApprWorkflowCodeTxt@1040 : TextConst '@@@={Locked};DAN=BSOCLAPW;ENU=BSOCLAPW';
      SalesInvoiceApprWorkflowDescTxt@1028 : TextConst 'DAN=Godkendelsesworkflow for salgsfaktura;ENU=Sales Invoice Approval Workflow';
      SalesReturnOrderApprWorkflowDescTxt@1027 : TextConst 'DAN=Godkendelsesworkflow for salgsreturvareordre;ENU=Sales Return Order Approval Workflow';
      SalesQuoteApprWorkflowDescTxt@1021 : TextConst 'DAN=Godkendelsesworkflow for salgstilbud;ENU=Sales Quote Approval Workflow';
      SalesOrderApprWorkflowDescTxt@1015 : TextConst 'DAN=Godkendelsesworkflow for salgsordre;ENU=Sales Order Approval Workflow';
      SalesCreditMemoApprWorkflowDescTxt@1013 : TextConst 'DAN=Godkendelsesworkflow for salgskreditnota;ENU=Sales Credit Memo Approval Workflow';
      SalesBlanketOrderApprWorkflowDescTxt@1010 : TextConst 'DAN=Godkendelsesworkflow for rammesalgsordre;ENU=Blanket Sales Order Approval Workflow';
      SalesInvoiceCreditLimitApprWorkflowDescTxt@1038 : TextConst 'DAN=Godkendelsesworkflow for kreditmaksimum for salgsfakturaer;ENU=Sales Invoice Credit Limit Approval Workflow';
      SalesOrderCreditLimitApprWorkflowDescTxt@1039 : TextConst 'DAN=Godkendelsesworkflow for kreditmaksimum for salgsordrer;ENU=Sales Order Credit Limit Approval Workflow';
      SalesRetOrderCrLimitApprWorkflowDescTxt@1047 : TextConst 'DAN=Godkendelsesworkflow for kreditmaksimum for salgsreturvareordrer;ENU=Sales Return Order Credit Limit Approval Workflow';
      SalesQuoteCrLimitApprWorkflowDescTxt@1046 : TextConst 'DAN=Godkendelsesworkflow for kreditmaksimum for salgstilbud;ENU=Sales Quote Credit Limit Approval Workflow';
      SalesCrMemoCrLimitApprWorkflowDescTxt@1045 : TextConst 'DAN=Godkendelsesworkflow for kreditmaksimum for salgskreditnota;ENU=Sales Credit Memo Credit Limit Approval Workflow';
      SalesBlanketOrderCrLimitApprWorkflowDescTxt@1044 : TextConst 'DAN=Godkendelsesworkflow for kreditmaksimum for rammesalgsordre;ENU=Blanket Sales Order Credit Limit Approval Workflow';
      CustomerApprWorkflowCodeTxt@1148 : TextConst '@@@={Locked};DAN=CUSTAPW;ENU=CUSTAPW';
      CustomerApprWorkflowDescTxt@1108 : TextConst 'DAN=Godkendelsesworkflow for debitor;ENU=Customer Approval Workflow';
      CustomerCredLmtChangeApprWorkflowCodeTxt@1070 : TextConst '@@@={Locked};DAN=CCLCAPW;ENU=CCLCAPW';
      CustomerCredLmtChangeApprWorkflowDescTxt@1069 : TextConst 'DAN=Godkendelsesworkflow for �ndring af kreditmaksimum;ENU=Customer Credit Limit Change Approval Workflow';
      VendorApprWorkflowCodeTxt@1095 : TextConst '@@@={Locked};DAN=VENDAPW;ENU=VENDAPW';
      VendorApprWorkflowDescTxt@1094 : TextConst 'DAN=Godkendelsesworkflow for kreditor;ENU=Vendor Approval Workflow';
      ItemApprWorkflowCodeTxt@1099 : TextConst '@@@={Locked};DAN=ITEMAPW;ENU=ITEMAPW';
      ItemApprWorkflowDescTxt@1098 : TextConst 'DAN=Godkendelsesworkflow for vare;ENU=Item Approval Workflow';
      ItemUnitPriceChangeApprWorkflowCodeTxt@1097 : TextConst '@@@={Locked};DAN=IUPCAPW;ENU=IUPCAPW';
      ItemUnitPriceChangeApprWorkflowDescTxt@1096 : TextConst 'DAN=Godkendelsesworkflow for �ndret vareenhedspris;ENU=Item Unit Price Change Approval Workflow';
      GeneralJournalBatchApprWorkflowCodeTxt@1054 : TextConst '@@@={Locked};DAN=GJBAPW;ENU=GJBAPW';
      GeneralJournalBatchApprWorkflowDescTxt@1053 : TextConst 'DAN=Godkendelsesworkflow for finanskladdenavn;ENU=General Journal Batch Approval Workflow';
      GeneralJournalLineApprWorkflowCodeTxt@1062 : TextConst '@@@={Locked};DAN=GJLAPW;ENU=GJLAPW';
      GeneralJournalLineApprWorkflowDescTxt@1061 : TextConst 'DAN=Godkendelsesworkflow for finanskladdelinje;ENU=General Journal Line Approval Workflow';
      GeneralJournalBatchIsNotBalancedMsg@1055 : TextConst '@@@=General Journal Batch refers to the name of a record.;DAN=Den valgte finanskladdek�rsel er ikke afstemt og kan ikke sendes til godkendelse.;ENU=The selected general journal batch is not balanced and cannot be sent for approval.';
      ApprovalRequestCanceledMsg@1165 : TextConst 'DAN=Godkendelsesanmodningen for recorden er blevet annulleret.;ENU=The approval request for the record has been canceled.';
      SendToOCRWorkflowCodeTxt@1067 : TextConst '@@@={Locked};DAN=INCDOC-OCR;ENU=INCDOC-OCR';
      CustCredLmtChangeSentForAppTxt@1072 : TextConst 'DAN=�ndring af kreditmaksimum for debitor sendt til godkendelse.;ENU=The customer credit limit change was sent for approval.';
      ItemUnitPriceChangeSentForAppTxt@1103 : TextConst 'DAN=�ndring af vareenhedspris blev sendt til godkendelse.;ENU=The item unit price change was sent for approval.';
      IntegrationCategoryTxt@1071 : TextConst '@@@={Locked};DAN=INT;ENU=INT';
      SalesMktCategoryTxt@1073 : TextConst '@@@={Locked};DAN=SALES;ENU=SALES';
      PurchPayCategoryTxt@1074 : TextConst '@@@={Locked};DAN=PURCH;ENU=PURCH';
      PurchDocCategoryTxt@1075 : TextConst '@@@={Locked};DAN=PURCHDOC;ENU=PURCHDOC';
      SalesDocCategoryTxt@1076 : TextConst '@@@={Locked};DAN=SALESDOC;ENU=SALESDOC';
      AdminCategoryTxt@1077 : TextConst '@@@={Locked};DAN=ADMIN;ENU=ADMIN';
      FinCategoryTxt@1087 : TextConst '@@@={Locked};DAN=FIN;ENU=FIN';
      IntegrationCategoryDescTxt@1086 : TextConst 'DAN=Integration;ENU=Integration';
      SalesMktCategoryDescTxt@1085 : TextConst 'DAN=Salg og marketing;ENU=Sales and Marketing';
      PurchPayCategoryDescTxt@1084 : TextConst 'DAN=K�b og g�ld;ENU=Purchases and Payables';
      PurchDocCategoryDescTxt@1082 : TextConst 'DAN=K�bsdokumenter;ENU=Purchase Documents';
      SalesDocCategoryDescTxt@1079 : TextConst 'DAN=Salgsdokumenter;ENU=Sales Documents';
      AdminCategoryDescTxt@1078 : TextConst 'DAN=Administration;ENU=Administration';
      FinCategoryDescTxt@1088 : TextConst 'DAN=Finans;ENU=Finance';
      CustomTemplateToken@1008 : Code[3];

    [External]
    PROCEDURE InitWorkflow@23();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      WorkflowEventHandling.CreateEventsLibrary;
      WorkflowRequestPageHandling.CreateEntitiesAndFields;
      WorkflowRequestPageHandling.AssignEntitiesToWorkflowEvents;
      WorkflowResponseHandling.CreateResponsesLibrary;
      InsertWorkflowCategories;
      InsertJobQueueData;

      Workflow.SETRANGE(Template,TRUE);
      IF Workflow.ISEMPTY THEN
        InsertWorkflowTemplates;
    END;

    LOCAL PROCEDURE InsertWorkflowTemplates@24();
    BEGIN
      InsertApprovalsTableRelations;

      InsertIncomingDocumentWorkflowTemplate;
      InsertIncomingDocumentApprovalWorkflowTemplate;
      InsertIncomingDocumentOCRWorkflowTemplate;
      InsertIncomingDocumentToGenJnlLineOCRWorkflowTemplate;
      InsertIncomingDocumentDocExchWorkflowTemplate;

      InsertPurchaseInvoiceWorkflowTemplate;

      InsertPurchaseBlanketOrderApprovalWorkflowTemplate;
      InsertPurchaseCreditMemoApprovalWorkflowTemplate;
      InsertPurchaseInvoiceApprovalWorkflowTemplate;
      InsertPurchaseOrderApprovalWorkflowTemplate;
      InsertPurchaseQuoteApprovalWorkflowTemplate;
      InsertPurchaseReturnOrderApprovalWorkflowTemplate;

      InsertSalesBlanketOrderApprovalWorkflowTemplate;
      InsertSalesCreditMemoApprovalWorkflowTemplate;
      InsertSalesInvoiceApprovalWorkflowTemplate;
      InsertSalesOrderApprovalWorkflowTemplate;
      InsertSalesQuoteApprovalWorkflowTemplate;
      InsertSalesReturnOrderApprovalWorkflowTemplate;

      InsertSalesInvoiceCreditLimitApprovalWorkflowTemplate;
      InsertSalesOrderCreditLimitApprovalWorkflowTemplate;

      InsertOverdueApprovalsWorkflowTemplate;

      InsertCustomerApprovalWorkflowTemplate;
      InsertCustomerCreditLimitChangeApprovalWorkflowTemplate;

      InsertVendorApprovalWorkflowTemplate;

      InsertItemApprovalWorkflowTemplate;
      InsertItemUnitPriceChangeApprovalWorkflowTemplate;

      InsertGeneralJournalBatchApprovalWorkflowTemplate;
      InsertGeneralJournalLineApprovalWorkflowTemplate;

      OnInsertWorkflowTemplates;
    END;

    [External]
    PROCEDURE InsertWorkflowCategories@126();
    BEGIN
      InsertWorkflowCategory(IntegrationCategoryTxt,IntegrationCategoryDescTxt);
      InsertWorkflowCategory(SalesMktCategoryTxt,SalesMktCategoryDescTxt);
      InsertWorkflowCategory(PurchPayCategoryTxt,PurchPayCategoryDescTxt);
      InsertWorkflowCategory(PurchDocCategoryTxt,PurchDocCategoryDescTxt);
      InsertWorkflowCategory(SalesDocCategoryTxt,SalesDocCategoryDescTxt);
      InsertWorkflowCategory(AdminCategoryTxt,AdminCategoryDescTxt);
      InsertWorkflowCategory(FinCategoryTxt,FinCategoryDescTxt);

      OnAddWorkflowCategoriesToLibrary;
    END;

    [Integration(TRUE)]
    LOCAL PROCEDURE OnInsertWorkflowTemplates@62();
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAddWorkflowCategoriesToLibrary@134();
    BEGIN
    END;

    LOCAL PROCEDURE InsertWorkflow@80(VAR Workflow@1003 : Record 1501;WorkflowCode@1001 : Code[20];WorkflowDescription@1002 : Text[100];CategoryCode@1000 : Code[20]);
    BEGIN
      Workflow.INIT;
      Workflow.Code := WorkflowCode;
      Workflow.Description := WorkflowDescription;
      Workflow.Category := CategoryCode;
      Workflow.Enabled := FALSE;
      Workflow.INSERT;
    END;

    LOCAL PROCEDURE InsertWorkflowTemplate@52(VAR Workflow@1003 : Record 1501;WorkflowCode@1001 : Code[17];WorkflowDescription@1002 : Text[100];CategoryCode@1000 : Code[20]);
    BEGIN
      Workflow.INIT;
      Workflow.Code := GetWorkflowTemplateCode(WorkflowCode);
      Workflow.Description := WorkflowDescription;
      Workflow.Category := CategoryCode;
      Workflow.Enabled := FALSE;
      IF Workflow.INSERT THEN;
    END;

    [External]
    PROCEDURE InsertApprovalsTableRelations@50();
    VAR
      IncomingDocument@1003 : Record 130;
      ApprovalEntry@1000 : Record 454;
      DummyGenJournalLine@1001 : Record 81;
    BEGIN
      InsertTableRelation(DATABASE::"Purchase Header",0,
        DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));

      InsertTableRelation(DATABASE::"Sales Header",0,
        DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));

      InsertTableRelation(DATABASE::Customer,0,
        DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
      InsertTableRelation(DATABASE::Vendor,0,
        DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
      InsertTableRelation(DATABASE::Item,0,
        DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
      InsertTableRelation(DATABASE::"Gen. Journal Line",0,
        DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
      InsertTableRelation(DATABASE::"Gen. Journal Batch",0,
        DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));

      InsertTableRelation(
        DATABASE::"Incoming Document",IncomingDocument.FIELDNO("Entry No."),
        DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Document No."));
      InsertTableRelation(
        DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Document No."),
        DATABASE::"Incoming Document",IncomingDocument.FIELDNO("Entry No."));

      InsertTableRelation(
        DATABASE::"Incoming Document",IncomingDocument.FIELDNO("Entry No."),DATABASE::"Gen. Journal Line",
        DummyGenJournalLine.FIELDNO("Incoming Document Entry No."));
    END;

    LOCAL PROCEDURE InsertIncomingDocumentWorkflowTemplate@65();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,IncDocWorkflowCodeTxt,IncDocWorkflowDescTxt,IntegrationCategoryTxt);
      InsertIncomingDocumentWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertIncomingDocumentWorkflowDetails@77(VAR Workflow@1000 : Record 1501);
    VAR
      IncomingDocument@1005 : Record 130;
      PurchaseHeader@1004 : Record 38;
      OnIncomingDocumentCreatedEventID@1001 : Integer;
    BEGIN
      InsertTableRelation(DATABASE::"Incoming Document",IncomingDocument.FIELDNO("Entry No."),
        DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Incoming Document Entry No."));
      InsertTableRelation(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Incoming Document Entry No."),
        DATABASE::"Incoming Document",IncomingDocument.FIELDNO("Entry No."));

      OnIncomingDocumentCreatedEventID :=
        InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterInsertIncomingDocumentCode);
      InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,OnIncomingDocumentCreatedEventID);
    END;

    LOCAL PROCEDURE InsertIncomingDocumentOCRWorkflowTemplate@133();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(
        Workflow,IncDocOCRWorkflowCodeTxt,IncDocOCRWorkflowDescriptionTxt,IntegrationCategoryTxt);
      InsertIncomingDocumentOCRWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertIncomingDocumentOCRWorkflowDetails@138(VAR Workflow@1003 : Record 1501);
    VAR
      IncomingDocument@1000 : Record 130;
      OCRSuccessEventID@1015 : Integer;
      CreateDocResponseID@1004 : Integer;
      NotifyResponseID@1016 : Integer;
      DocSuccessEventID@1007 : Integer;
      DocErrorEventID@1006 : Integer;
    BEGIN
      OCRSuccessEventID :=
        InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReceiveFromOCRIncomingDocCode);
      InsertEventArgument(
        OCRSuccessEventID,BuildIncomingDocumentOCRTypeConditions(IncomingDocument."OCR Status"::Success));
      CreateDocResponseID :=
        InsertResponseStep(Workflow,WorkflowResponseHandling.GetCreateDocFromIncomingDocCode,OCRSuccessEventID);

      DocSuccessEventID :=
        InsertEventStep(
          Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateDocFromIncomingDocSuccessCode,CreateDocResponseID);
      InsertEventArgument(DocSuccessEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Created));
      InsertResponseStep(Workflow,WorkflowResponseHandling.DoNothingCode,DocSuccessEventID);

      DocErrorEventID :=
        InsertEventStep(
          Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateDocFromIncomingDocFailCode,CreateDocResponseID);
      InsertEventArgument(DocErrorEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Failed));
      NotifyResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,DocErrorEventID);

      InsertNotificationArgument(NotifyResponseID,'',PAGE::"Incoming Document",'');
    END;

    LOCAL PROCEDURE InsertIncomingDocumentToGenJnlLineOCRWorkflowTemplate@35();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(
        Workflow,IncDocToGenJnlLineOCRWorkflowCodeTxt,IncDocToGenJnlLineOCRWorkflowDescriptionTxt,IntegrationCategoryTxt);
      InsertIncomingDocumentToGenJnlLineOCRWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertIncomingDocumentToGenJnlLineOCRWorkflowDetails@21(VAR Workflow@1003 : Record 1501);
    VAR
      IncomingDocument@1000 : Record 130;
      OCRSuccessForGenJnlLineEventID@1010 : Integer;
      CreateDocForGenJnlLineResponseID@1011 : Integer;
      GenJnlLineSuccessEventID@1001 : Integer;
      GenJnlLineFailEventID@1002 : Integer;
      CreateGenJnlLineFailResponseID@1008 : Integer;
    BEGIN
      OCRSuccessForGenJnlLineEventID :=
        InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReceiveFromOCRIncomingDocCode);
      InsertEventArgument(
        OCRSuccessForGenJnlLineEventID,BuildIncomingDocumentOCRTypeConditions(IncomingDocument."OCR Status"::Success));
      CreateDocForGenJnlLineResponseID :=
        InsertResponseStep(Workflow,WorkflowResponseHandling.GetCreateJournalFromIncomingDocCode,OCRSuccessForGenJnlLineEventID);

      GenJnlLineSuccessEventID :=
        InsertEventStep(
          Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocSuccessCode,
          CreateDocForGenJnlLineResponseID);
      InsertResponseStep(Workflow,WorkflowResponseHandling.DoNothingCode,GenJnlLineSuccessEventID);

      GenJnlLineFailEventID :=
        InsertEventStep(
          Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateGenJnlLineFromIncomingDocFailCode,CreateDocForGenJnlLineResponseID);
      CreateGenJnlLineFailResponseID :=
        InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,GenJnlLineFailEventID);

      InsertNotificationArgument(CreateGenJnlLineFailResponseID,'',PAGE::"Incoming Document",'');
    END;

    LOCAL PROCEDURE InsertIncomingDocumentDocExchWorkflowTemplate@129();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,IncDocExchWorkflowCodeTxt,IncDocExchWorkflowDescriptionTxt,IntegrationCategoryTxt);
      InsertIncomingDocumentDocExchWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertIncomingDocumentDocExchWorkflowDetails@127(VAR Workflow@1003 : Record 1501);
    VAR
      IncomingDocument@1000 : Record 130;
      IncDocCreatedEventID@1008 : Integer;
      DocReleasedEventID@1013 : Integer;
      DocSuccessEventID@1015 : Integer;
      DocErrorEventID@1005 : Integer;
      ReleaseDocResponseID@1010 : Integer;
      CreateDocResponseID@1004 : Integer;
      NotifyResponseID@1016 : Integer;
    BEGIN
      IncDocCreatedEventID :=
        InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReceiveFromDocExchIncomingDocCode);
      InsertEventArgument(IncDocCreatedEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::New));
      ReleaseDocResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ReleaseDocumentCode,IncDocCreatedEventID);

      DocReleasedEventID :=
        InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReleaseIncomingDocCode,ReleaseDocResponseID);
      InsertEventArgument(DocReleasedEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Released));
      CreateDocResponseID :=
        InsertResponseStep(Workflow,WorkflowResponseHandling.GetCreateDocFromIncomingDocCode,DocReleasedEventID);

      DocSuccessEventID :=
        InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateDocFromIncomingDocSuccessCode,CreateDocResponseID);
      InsertEventArgument(DocSuccessEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Created));
      InsertResponseStep(Workflow,WorkflowResponseHandling.DoNothingCode,DocSuccessEventID);

      DocErrorEventID :=
        InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterCreateDocFromIncomingDocFailCode,CreateDocResponseID);
      InsertEventArgument(DocErrorEventID,BuildIncomingDocumentTypeConditions(IncomingDocument.Status::Failed));
      NotifyResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,DocErrorEventID);

      InsertNotificationArgument(NotifyResponseID,'',PAGE::"Incoming Document",'');
    END;

    LOCAL PROCEDURE InsertPurchaseInvoiceWorkflowTemplate@79();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,PurchInvWorkflowCodeTxt,PurchInvWorkflowDescriptionTxt,PurchDocCategoryTxt);
      InsertPurchaseInvoiceWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertPurchaseInvoiceWorkflowDetails@85(VAR Workflow@1003 : Record 1501);
    VAR
      PurchaseHeader@1000 : Record 38;
      PurchInvHeader@1001 : Record 122;
      GenJournalLine@1002 : Record 81;
      DocReleasedEventID@1008 : Integer;
      PostedEventID@1013 : Integer;
      JournalLineCreatedEventID@1015 : Integer;
      PostDocAsyncResponseID@1010 : Integer;
      CreatePmtLineResponseID@1014 : Integer;
      NotifyResponseID@1016 : Integer;
    BEGIN
      InsertTableRelation(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("No."),
        DATABASE::"Purch. Inv. Header",PurchInvHeader.FIELDNO("Pre-Assigned No."));
      InsertTableRelation(DATABASE::"Purch. Inv. Header",PurchaseHeader.FIELDNO("No."),
        DATABASE::"Gen. Journal Line",GenJournalLine.FIELDNO("Applies-to Doc. No."));

      DocReleasedEventID := InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterReleasePurchaseDocCode);
      InsertEventArgument(DocReleasedEventID,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::Invoice,PurchaseHeader.Status::Released));

      PostDocAsyncResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.PostDocumentAsyncCode,DocReleasedEventID);

      PostedEventID :=
        InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterPostPurchaseDocCode,PostDocAsyncResponseID);
      CreatePmtLineResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreatePmtLineForPostedPurchaseDocAsyncCode,
          PostedEventID);
      InsertPmtLineCreationArgument(CreatePmtLineResponseID,'','');

      JournalLineCreatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnAfterInsertGeneralJournalLineCode,
          CreatePmtLineResponseID);

      GenJournalLine.SETRANGE("Document Type",GenJournalLine."Document Type"::Payment);
      InsertEventArgument(JournalLineCreatedEventID,BuildGeneralJournalLineTypeConditions(GenJournalLine));

      NotifyResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateNotificationEntryCode,JournalLineCreatedEventID);
      InsertNotificationArgument(NotifyResponseID,'',PAGE::"Payment Journal",'');
    END;

    [Internal]
    PROCEDURE InsertIncomingDocumentApprovalWorkflowTemplate@110();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,IncomingDocumentApprWorkflowCodeTxt,IncomingDocumentApprWorkflowDescTxt,IntegrationCategoryTxt);
      InsertIncomingDocumentApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertIncomingDocumentApprovalWorkflowDetails@108(VAR Workflow@1001 : Record 1501);
    VAR
      IncomingDocument@1000 : Record 130;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Workflow User Group",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(
        Workflow,
        BuildIncomingDocumentTypeConditions(IncomingDocument.Status::New),
        WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode,
        BuildIncomingDocumentTypeConditions(IncomingDocument.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelIncomingDocApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertPurchaseInvoiceApprovalWorkflowTemplate@81();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,PurchInvoiceApprWorkflowCodeTxt,PurchInvoiceApprWorkflowDescTxt,PurchDocCategoryTxt);
      InsertPurchaseInvoiceApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertPurchaseInvoiceApprovalWorkflowDetails@91(VAR Workflow@1001 : Record 1501);
    VAR
      PurchaseHeader@1000 : Record 38;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::Invoice,PurchaseHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::Invoice,PurchaseHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertPurchaseBlanketOrderApprovalWorkflowTemplate@83();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,PurchBlanketOrderApprWorkflowCodeTxt,PurchBlanketOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
      InsertPurchaseBlanketOrderApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertPurchaseBlanketOrderApprovalWorkflowDetails@102(VAR Workflow@1001 : Record 1501);
    VAR
      PurchaseHeader@1000 : Record 38;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Workflow User Group",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::"Blanket Order",PurchaseHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::"Blanket Order",PurchaseHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertPurchaseCreditMemoApprovalWorkflowTemplate@86();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,PurchCreditMemoApprWorkflowCodeTxt,PurchCreditMemoApprWorkflowDescTxt,PurchDocCategoryTxt);
      InsertPurchaseCreditMemoApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertPurchaseCreditMemoApprovalWorkflowDetails@106(VAR Workflow@1001 : Record 1501);
    VAR
      PurchaseHeader@1000 : Record 38;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::"Credit Memo",PurchaseHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::"Credit Memo",PurchaseHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertPurchaseOrderApprovalWorkflowTemplate@88();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,PurchOrderApprWorkflowCodeTxt,PurchOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
      InsertPurchaseOrderApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertPurchaseOrderApprovalWorkflowDetails@112(VAR Workflow@1001 : Record 1501);
    VAR
      PurchaseHeader@1000 : Record 38;
      PurchaseLine@1002 : Record 39;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      InsertTableRelation(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("Document Type"),
        DATABASE::"Purchase Line",PurchaseLine.FIELDNO("Document Type"));
      InsertTableRelation(DATABASE::"Purchase Header",PurchaseHeader.FIELDNO("No."),
        DATABASE::"Purchase Line",PurchaseLine.FIELDNO("Document No."));

      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::Approver,WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::Order,PurchaseHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::Order,PurchaseHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertPurchaseQuoteApprovalWorkflowTemplate@90();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,PurchQuoteApprWorkflowCodeTxt,PurchQuoteApprWorkflowDescTxt,PurchDocCategoryTxt);
      InsertPurchaseQuoteApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertPurchaseQuoteApprovalWorkflowDetails@117(VAR Workflow@1001 : Record 1501);
    VAR
      PurchaseHeader@1000 : Record 38;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::Approver,WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::Quote,PurchaseHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::Quote,PurchaseHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertPurchaseReturnOrderApprovalWorkflowTemplate@92();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,PurchReturnOrderApprWorkflowCodeTxt,PurchReturnOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
      InsertPurchaseReturnOrderApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertPurchaseReturnOrderApprovalWorkflowDetails@119(VAR Workflow@1001 : Record 1501);
    VAR
      PurchaseHeader@1000 : Record 38;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::"Return Order",PurchaseHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
        BuildPurchHeaderTypeConditions(PurchaseHeader."Document Type"::"Return Order",PurchaseHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertSalesInvoiceApprovalWorkflowTemplate@94();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,SalesInvoiceApprWorkflowCodeTxt,SalesInvoiceApprWorkflowDescTxt,SalesDocCategoryTxt);
      InsertSalesInvoiceApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertSalesInvoiceApprovalWorkflowDetails@82(VAR Workflow@1001 : Record 1501);
    VAR
      SalesHeader@1000 : Record 36;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Invoice,SalesHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Invoice,SalesHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertSalesBlanketOrderApprovalWorkflowTemplate@96();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,SalesBlanketOrderApprWorkflowCodeTxt,SalesBlanketOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
      InsertSalesBlanketOrderApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertSalesBlanketOrderApprovalWorkflowDetails@87(VAR Workflow@1001 : Record 1501);
    VAR
      SalesHeader@1000 : Record 36;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Workflow User Group",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::"Blanket Order",SalesHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::"Blanket Order",SalesHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertSalesCreditMemoApprovalWorkflowTemplate@98();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,SalesCreditMemoApprWorkflowCodeTxt,SalesCreditMemoApprWorkflowDescTxt,SalesDocCategoryTxt);
      InsertSalesCreditMemoApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertSalesCreditMemoApprovalWorkflowDetails@95(VAR Workflow@1001 : Record 1501);
    VAR
      SalesHeader@1000 : Record 36;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::"Credit Memo",SalesHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::"Credit Memo",SalesHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertSalesOrderApprovalWorkflowTemplate@100();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,SalesOrderApprWorkflowCodeTxt,SalesOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
      InsertSalesOrderApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertSalesOrderApprovalWorkflowDetails@99(VAR Workflow@1001 : Record 1501);
    VAR
      SalesHeader@1000 : Record 36;
      SalesLine@1002 : Record 37;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      InsertTableRelation(DATABASE::"Sales Header",SalesHeader.FIELDNO("Document Type"),
        DATABASE::"Sales Line",SalesLine.FIELDNO("Document Type"));
      InsertTableRelation(DATABASE::"Sales Header",SalesHeader.FIELDNO("No."),
        DATABASE::"Sales Line",SalesLine.FIELDNO("Document No."));

      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",
        WorkflowStepArgument."Approver Limit Type"::"Approver Chain",0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Order,SalesHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Order,SalesHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertSalesQuoteApprovalWorkflowTemplate@103();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,SalesQuoteApprWorkflowCodeTxt,SalesQuoteApprWorkflowDescTxt,SalesDocCategoryTxt);
      InsertSalesQuoteApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertSalesQuoteApprovalWorkflowDetails@104(VAR Workflow@1001 : Record 1501);
    VAR
      SalesHeader@1000 : Record 36;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Quote,SalesHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Quote,SalesHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertSalesReturnOrderApprovalWorkflowTemplate@105();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,SalesReturnOrderApprWorkflowCodeTxt,SalesReturnOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
      InsertSalesReturnOrderApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertSalesReturnOrderApprovalWorkflowDetails@113(VAR Workflow@1001 : Record 1501);
    VAR
      SalesHeader@1000 : Record 36;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::"Return Order",SalesHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::"Return Order",SalesHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertSalesInvoiceCreditLimitApprovalWorkflowTemplate@107();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,SalesInvoiceCreditLimitApprWorkflowCodeTxt,
        SalesInvoiceCreditLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
      InsertSalesInvoiceCreditLimitApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertSalesInvoiceCreditLimitApprovalWorkflowDetails@116(VAR Workflow@1002 : Record 1501);
    VAR
      SalesHeader@1000 : Record 36;
      WorkflowStepArgument@1001 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertSalesDocWithCreditLimitApprovalWorkflowSteps(Workflow,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Invoice,SalesHeader.Status::Open),
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Invoice,SalesHeader.Status::"Pending Approval"),
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertSalesOrderCreditLimitApprovalWorkflowTemplate@109();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,SalesOrderCreditLimitApprWorkflowCodeTxt,
        SalesOrderCreditLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
      InsertSalesOrderCreditLimitApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertSalesOrderCreditLimitApprovalWorkflowDetails@120(VAR Workflow@1000 : Record 1501);
    VAR
      SalesHeader@1002 : Record 36;
      WorkflowStepArgument@1001 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser",
        WorkflowStepArgument."Approver Limit Type"::"Approver Chain",0,'',BlankDateFormula,TRUE);

      InsertSalesDocWithCreditLimitApprovalWorkflowSteps(Workflow,
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Order,SalesHeader.Status::Open),
        BuildSalesHeaderTypeConditions(SalesHeader."Document Type"::Order,SalesHeader.Status::"Pending Approval"),
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertSalesDocWithCreditLimitApprovalWorkflowSteps@54(Workflow@1000 : Record 1501;DocSentForApprovalConditionString@1001 : Text;DocCanceledConditionString@1023 : Text;WorkflowStepArgument@1020 : Record 1523;ShowConfirmationMessage@1026 : Boolean);
    VAR
      SentForApprovalEventID@1004 : Integer;
      CheckCustomerCreditLimitResponseID@1006 : Integer;
      CustomerCreditLimitExceededEventID@1007 : Integer;
      CustomerCreditLimitNotExceededEventID@1008 : Integer;
      SetStatusToPendingApprovalResponseID@1002 : Integer;
      CreateApprovalRequestResponseID@1019 : Integer;
      SendApprovalRequestResponseID@1018 : Integer;
      OnAllRequestsApprovedEventID@1017 : Integer;
      OnRequestApprovedEventID@1016 : Integer;
      SendApprovalRequestResponseID2@1015 : Integer;
      OnRequestRejectedEventID@1014 : Integer;
      RejectAllApprovalsResponseID@1013 : Integer;
      OnRequestCanceledEventID@1012 : Integer;
      CancelAllApprovalsResponseID@1011 : Integer;
      OnRequestDelegatedEventID@1010 : Integer;
      SentApprovalRequestResponseID3@1009 : Integer;
      SetStatusToPendingApprovalResponseID2@1025 : Integer;
      CreateAndApproveApprovalRequestResponseID@1021 : Integer;
      OpenDocumentResponseID@1003 : Integer;
      ShowMessageResponseID@1005 : Integer;
      RestrictRecordUsageResponseID@1022 : Integer;
      AllowRecordUsageResponseID@1024 : Integer;
    BEGIN
      SentForApprovalEventID := InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode);
      InsertEventArgument(SentForApprovalEventID,DocSentForApprovalConditionString);

      CheckCustomerCreditLimitResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CheckCustomerCreditLimitCode,
          SentForApprovalEventID);

      CustomerCreditLimitExceededEventID := InsertEventStep(Workflow,
          WorkflowEventHandling.RunWorkflowOnCustomerCreditLimitExceededCode,CheckCustomerCreditLimitResponseID);

      RestrictRecordUsageResponseID :=
        InsertResponseStep(Workflow,WorkflowResponseHandling.RestrictRecordUsageCode,CustomerCreditLimitExceededEventID);

      SetStatusToPendingApprovalResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.SetStatusToPendingApprovalCode,
          RestrictRecordUsageResponseID);
      CreateApprovalRequestResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateApprovalRequestsCode,
          SetStatusToPendingApprovalResponseID);
      InsertApprovalArgument(CreateApprovalRequestResponseID,
        WorkflowStepArgument."Approver Type",WorkflowStepArgument."Approver Limit Type",
        WorkflowStepArgument."Workflow User Group Code",WorkflowStepArgument."Approver User ID",
        WorkflowStepArgument."Due Date Formula",ShowConfirmationMessage);
      SendApprovalRequestResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          CreateApprovalRequestResponseID);

      InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');

      OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
      AllowRecordUsageResponseID :=
        InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,OnAllRequestsApprovedEventID);
      InsertResponseStep(Workflow,WorkflowResponseHandling.ReleaseDocumentCode,AllowRecordUsageResponseID);

      OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
      SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestApprovedEventID);

      SetNextStep(Workflow,SendApprovalRequestResponseID2,SendApprovalRequestResponseID);

      OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
          SendApprovalRequestResponseID);
      RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
          OnRequestRejectedEventID);
      InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
      InsertResponseStep(Workflow,WorkflowResponseHandling.OpenDocumentCode,RejectAllApprovalsResponseID);

      OnRequestCanceledEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnRequestCanceledEventID,DocCanceledConditionString);
      CancelAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CancelAllApprovalRequestsCode,
          OnRequestCanceledEventID);
      InsertNotificationArgument(CancelAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
      AllowRecordUsageResponseID :=
        InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,CancelAllApprovalsResponseID);
      OpenDocumentResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.OpenDocumentCode,AllowRecordUsageResponseID);
      ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,OpenDocumentResponseID);
      InsertMessageArgument(ShowMessageResponseID,ApprovalRequestCanceledMsg);

      OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
          SendApprovalRequestResponseID);
      SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestDelegatedEventID);

      SetNextStep(Workflow,SentApprovalRequestResponseID3,SendApprovalRequestResponseID);

      CustomerCreditLimitNotExceededEventID := InsertEventStep(Workflow,
          WorkflowEventHandling.RunWorkflowOnCustomerCreditLimitNotExceededCode,CheckCustomerCreditLimitResponseID);

      SetStatusToPendingApprovalResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SetStatusToPendingApprovalCode,
          CustomerCreditLimitNotExceededEventID);

      CreateAndApproveApprovalRequestResponseID := InsertResponseStep(Workflow,
          WorkflowResponseHandling.CreateAndApproveApprovalRequestAutomaticallyCode,SetStatusToPendingApprovalResponseID2);
      InsertResponseStep(Workflow,WorkflowResponseHandling.ReleaseDocumentCode,
        CreateAndApproveApprovalRequestResponseID);
    END;

    LOCAL PROCEDURE InsertOverdueApprovalsWorkflowTemplate@111();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,OverdueWorkflowCodeTxt,OverdueWorkflowDescTxt,AdminCategoryTxt);
      InsertOverdueApprovalsWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    [External]
    PROCEDURE InsertOverdueApprovalsWorkflow@18() : Code[20];
    VAR
      Workflow@1002 : Record 1501;
    BEGIN
      InsertWorkflow(Workflow,GetWorkflowCode(OverdueWorkflowCodeTxt),OverdueWorkflowDescTxt,AdminCategoryTxt);
      InsertOverdueApprovalsWorkflowDetails(Workflow);
      EXIT(Workflow.Code);
    END;

    LOCAL PROCEDURE InsertOverdueApprovalsWorkflowDetails@122(VAR Workflow@1002 : Record 1501);
    VAR
      OnSendOverdueNotificationsEventID@1003 : Integer;
    BEGIN
      OnSendOverdueNotificationsEventID :=
        InsertEntryPointEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnSendOverdueNotificationsCode);
      InsertResponseStep(Workflow,WorkflowResponseHandling.CreateOverdueNotificationCode,OnSendOverdueNotificationsEventID);
    END;

    LOCAL PROCEDURE InsertCustomerApprovalWorkflowTemplate@115();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,CustomerApprWorkflowCodeTxt,CustomerApprWorkflowDescTxt,SalesMktCategoryTxt);
      InsertCustomerApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    [Internal]
    PROCEDURE InsertCustomerApprovalWorkflow@78();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflow(Workflow,GetWorkflowCode(CustomerApprWorkflowCodeTxt),CustomerApprWorkflowDescTxt,SalesMktCategoryTxt);
      InsertCustomerApprovalWorkflowDetails(Workflow);
    END;

    LOCAL PROCEDURE InsertCustomerApprovalWorkflowDetails@125(VAR Workflow@1000 : Record 1501);
    VAR
      WorkflowStepArgument@1004 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::Approver,WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertRecApprovalWorkflowSteps(Workflow,BuildCustomerTypeConditions,
        WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode,
        WorkflowResponseHandling.CreateApprovalRequestsCode,
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
        WorkflowEventHandling.RunWorkflowOnCancelCustomerApprovalRequestCode,
        WorkflowStepArgument,
        TRUE,TRUE);
    END;

    LOCAL PROCEDURE InsertVendorApprovalWorkflowTemplate@143();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,VendorApprWorkflowCodeTxt,VendorApprWorkflowDescTxt,PurchPayCategoryTxt);
      InsertVendorApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    [Internal]
    PROCEDURE InsertVendorApprovalWorkflow@142();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflow(Workflow,GetWorkflowCode(VendorApprWorkflowCodeTxt),VendorApprWorkflowDescTxt,PurchPayCategoryTxt);
      InsertVendorApprovalWorkflowDetails(Workflow);
    END;

    LOCAL PROCEDURE InsertVendorApprovalWorkflowDetails@141(VAR Workflow@1000 : Record 1501);
    VAR
      WorkflowStepArgument@1004 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::Approver,WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertRecApprovalWorkflowSteps(Workflow,BuildVendorTypeConditions,
        WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode,
        WorkflowResponseHandling.CreateApprovalRequestsCode,
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
        WorkflowEventHandling.RunWorkflowOnCancelVendorApprovalRequestCode,
        WorkflowStepArgument,
        TRUE,TRUE);
    END;

    LOCAL PROCEDURE InsertItemApprovalWorkflowTemplate@147();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,ItemApprWorkflowCodeTxt,ItemApprWorkflowDescTxt,SalesMktCategoryTxt);
      InsertItemApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    [Internal]
    PROCEDURE InsertItemApprovalWorkflow@145();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflow(Workflow,GetWorkflowCode(ItemApprWorkflowCodeTxt),ItemApprWorkflowDescTxt,SalesMktCategoryTxt);
      InsertItemApprovalWorkflowDetails(Workflow);
    END;

    LOCAL PROCEDURE InsertItemApprovalWorkflowDetails@144(VAR Workflow@1000 : Record 1501);
    VAR
      WorkflowStepArgument@1004 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::Approver,WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertRecApprovalWorkflowSteps(Workflow,BuildItemTypeConditions,
        WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode,
        WorkflowResponseHandling.CreateApprovalRequestsCode,
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
        WorkflowEventHandling.RunWorkflowOnCancelItemApprovalRequestCode,
        WorkflowStepArgument,
        TRUE,TRUE);
    END;

    LOCAL PROCEDURE InsertCustomerCreditLimitChangeApprovalWorkflowTemplate@121();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,CustomerCredLmtChangeApprWorkflowCodeTxt,
        CustomerCredLmtChangeApprWorkflowDescTxt,SalesMktCategoryTxt);
      InsertCustomerCreditLimitChangeApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertCustomerCreditLimitChangeApprovalWorkflowDetails@114(VAR Workflow@1000 : Record 1501);
    VAR
      Customer@1001 : Record 18;
      WorkflowRule@1002 : Record 1524;
      WorkflowStepArgument@1004 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Workflow User Group",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,FALSE);

      InsertRecChangedApprovalWorkflowSteps(Workflow,WorkflowRule.Operator::Increased,
        WorkflowEventHandling.RunWorkflowOnCustomerChangedCode,
        WorkflowResponseHandling.CreateApprovalRequestsCode,
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
        WorkflowStepArgument,DATABASE::Customer,Customer.FIELDNO("Credit Limit (LCY)"),
        CustCredLmtChangeSentForAppTxt);
    END;

    LOCAL PROCEDURE InsertItemUnitPriceChangeApprovalWorkflowTemplate@153();
    VAR
      Workflow@1000 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,ItemUnitPriceChangeApprWorkflowCodeTxt,
        ItemUnitPriceChangeApprWorkflowDescTxt,SalesMktCategoryTxt);
      InsertItemUnitPriceChangeApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertItemUnitPriceChangeApprovalWorkflowDetails@152(VAR Workflow@1000 : Record 1501);
    VAR
      Item@1001 : Record 27;
      WorkflowRule@1002 : Record 1524;
      WorkflowStepArgument@1004 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::"Workflow User Group",WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,FALSE);

      InsertRecChangedApprovalWorkflowSteps(Workflow,WorkflowRule.Operator::Increased,
        WorkflowEventHandling.RunWorkflowOnItemChangedCode,
        WorkflowResponseHandling.CreateApprovalRequestsCode,
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
        WorkflowStepArgument,DATABASE::Item,Item.FIELDNO("Unit Price"),
        ItemUnitPriceChangeSentForAppTxt);
    END;

    LOCAL PROCEDURE InsertGeneralJournalBatchApprovalWorkflowTemplate@2();
    VAR
      Workflow@1002 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,GeneralJournalBatchApprWorkflowCodeTxt,
        GeneralJournalBatchApprWorkflowDescTxt,FinCategoryTxt);
      InsertGeneralJournalBatchApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertGeneralJournalBatchApprovalWorkflowDetails@15(VAR Workflow@1000 : Record 1501);
    VAR
      WorkflowStepArgument@1004 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::Approver,WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,TRUE);

      InsertGenJnlBatchApprovalWorkflowSteps(Workflow,BuildGeneralJournalBatchTypeConditions,
        WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode,
        WorkflowResponseHandling.CreateApprovalRequestsCode,
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
        WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertGeneralJournalLineApprovalWorkflowTemplate@32();
    VAR
      Workflow@1002 : Record 1501;
    BEGIN
      InsertWorkflowTemplate(Workflow,GeneralJournalLineApprWorkflowCodeTxt,
        GeneralJournalLineApprWorkflowDescTxt,FinCategoryTxt);
      InsertGeneralJournalLineApprovalWorkflowDetails(Workflow);
      MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertGeneralJournalLineApprovalWorkflowDetails@31(VAR Workflow@1000 : Record 1501);
    VAR
      WorkflowStepArgument@1004 : Record 1523;
      GenJournalLine@1001 : Record 81;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,
        WorkflowStepArgument."Approver Type"::Approver,WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
        0,'',BlankDateFormula,FALSE);

      GenJournalLine.INIT;
      InsertRecApprovalWorkflowSteps(Workflow,BuildGeneralJournalLineTypeConditions(GenJournalLine),
        WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode,
        WorkflowResponseHandling.CreateApprovalRequestsCode,
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
        WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode,
        WorkflowStepArgument,
        FALSE,FALSE);
    END;

    [External]
    PROCEDURE IncomingDocumentWorkflowCode@3() : Code[17];
    BEGIN
      EXIT(IncDocWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE IncomingDocumentApprovalWorkflowCode@184() : Code[17];
    BEGIN
      EXIT(IncomingDocumentApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE IncomingDocumentOCRWorkflowCode@146() : Code[17];
    BEGIN
      EXIT(IncDocOCRWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE IncomingDocumentToGenJnlLineOCRWorkflowCode@10() : Code[17];
    BEGIN
      EXIT(IncDocToGenJnlLineOCRWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE PurchaseInvoiceWorkflowCode@9() : Code[17];
    BEGIN
      EXIT(PurchInvWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE PurchaseInvoiceApprovalWorkflowCode@11() : Code[17];
    BEGIN
      EXIT(PurchInvoiceApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE PurchaseBlanketOrderApprovalWorkflowCode@38() : Code[17];
    BEGIN
      EXIT(PurchBlanketOrderApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE PurchaseCreditMemoApprovalWorkflowCode@39() : Code[17];
    BEGIN
      EXIT(PurchCreditMemoApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE PurchaseQuoteApprovalWorkflowCode@40() : Code[17];
    BEGIN
      EXIT(PurchQuoteApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE PurchaseOrderApprovalWorkflowCode@45() : Code[17];
    BEGIN
      EXIT(PurchOrderApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE PurchaseReturnOrderApprovalWorkflowCode@46() : Code[17];
    BEGIN
      EXIT(PurchReturnOrderApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE SalesInvoiceApprovalWorkflowCode@48() : Code[17];
    BEGIN
      EXIT(SalesInvoiceApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE SalesBlanketOrderApprovalWorkflowCode@47() : Code[17];
    BEGIN
      EXIT(SalesBlanketOrderApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE SalesCreditMemoApprovalWorkflowCode@29() : Code[17];
    BEGIN
      EXIT(SalesCreditMemoApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE SalesQuoteApprovalWorkflowCode@28() : Code[17];
    BEGIN
      EXIT(SalesQuoteApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE SalesOrderApprovalWorkflowCode@27() : Code[17];
    BEGIN
      EXIT(SalesOrderApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE SalesReturnOrderApprovalWorkflowCode@26() : Code[17];
    BEGIN
      EXIT(SalesReturnOrderApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE OverdueNotificationsWorkflowCode@20() : Code[17];
    BEGIN
      EXIT(OverdueWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE SalesInvoiceCreditLimitApprovalWorkflowCode@25() : Code[17];
    BEGIN
      EXIT(SalesInvoiceCreditLimitApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE SalesOrderCreditLimitApprovalWorkflowCode@49() : Code[17];
    BEGIN
      EXIT(SalesOrderCreditLimitApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE CustomerWorkflowCode@75() : Code[17];
    BEGIN
      EXIT(CustomerApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE CustomerCreditLimitChangeApprovalWorkflowCode@132() : Code[17];
    BEGIN
      EXIT(CustomerCredLmtChangeApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE VendorWorkflowCode@136() : Code[17];
    BEGIN
      EXIT(VendorApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE ItemWorkflowCode@139() : Code[17];
    BEGIN
      EXIT(ItemApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE ItemUnitPriceChangeApprovalWorkflowCode@137() : Code[17];
    BEGIN
      EXIT(ItemUnitPriceChangeApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE GeneralJournalBatchApprovalWorkflowCode@4() : Code[17];
    BEGIN
      EXIT(GeneralJournalBatchApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE GeneralJournalLineApprovalWorkflowCode@6() : Code[17];
    BEGIN
      EXIT(GeneralJournalLineApprWorkflowCodeTxt);
    END;

    [External]
    PROCEDURE SendToOCRWorkflowCode@180() : Code[17];
    BEGIN
      EXIT(SendToOCRWorkflowCodeTxt);
    END;

    [Internal]
    PROCEDURE InsertDocApprovalWorkflowSteps@7(Workflow@1003 : Record 1501;DocSendForApprovalConditionString@1006 : Text;DocSendForApprovalEventCode@1001 : Code[128];DocCanceledConditionString@1009 : Text;DocCanceledEventCode@1004 : Code[128];WorkflowStepArgument@1000 : Record 1523;ShowConfirmationMessage@1019 : Boolean);
    VAR
      SentForApprovalEventID@1010 : Integer;
      SetStatusToPendingApprovalResponseID@1002 : Integer;
      CreateApprovalRequestResponseID@1012 : Integer;
      SendApprovalRequestResponseID@1013 : Integer;
      OnAllRequestsApprovedEventID@1014 : Integer;
      OnRequestApprovedEventID@1016 : Integer;
      SendApprovalRequestResponseID2@1017 : Integer;
      OnRequestRejectedEventID@1018 : Integer;
      RejectAllApprovalsResponseID@1020 : Integer;
      OnRequestCanceledEventID@1022 : Integer;
      CancelAllApprovalsResponseID@1023 : Integer;
      OnRequestDelegatedEventID@1025 : Integer;
      SentApprovalRequestResponseID3@1026 : Integer;
      RestrictRecordUsageResponseID@1005 : Integer;
      AllowRecordUsageResponseID@1008 : Integer;
      OpenDocumentResponceID@1011 : Integer;
      ShowMessageResponseID@1015 : Integer;
    BEGIN
      SentForApprovalEventID := InsertEntryPointEventStep(Workflow,DocSendForApprovalEventCode);
      InsertEventArgument(SentForApprovalEventID,DocSendForApprovalConditionString);

      RestrictRecordUsageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RestrictRecordUsageCode,
          SentForApprovalEventID);
      SetStatusToPendingApprovalResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.SetStatusToPendingApprovalCode,
          RestrictRecordUsageResponseID);
      CreateApprovalRequestResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CreateApprovalRequestsCode,
          SetStatusToPendingApprovalResponseID);
      InsertApprovalArgument(CreateApprovalRequestResponseID,
        WorkflowStepArgument."Approver Type",WorkflowStepArgument."Approver Limit Type",
        WorkflowStepArgument."Workflow User Group Code",WorkflowStepArgument."Approver User ID",
        WorkflowStepArgument."Due Date Formula",ShowConfirmationMessage);
      SendApprovalRequestResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          CreateApprovalRequestResponseID);
      InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');

      OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
      AllowRecordUsageResponseID :=
        InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,OnAllRequestsApprovedEventID);
      InsertResponseStep(Workflow,WorkflowResponseHandling.ReleaseDocumentCode,AllowRecordUsageResponseID);

      OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
      SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestApprovedEventID);

      SetNextStep(Workflow,SendApprovalRequestResponseID2,SendApprovalRequestResponseID);

      OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
          SendApprovalRequestResponseID);
      RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
          OnRequestRejectedEventID);
      InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
      InsertResponseStep(Workflow,WorkflowResponseHandling.OpenDocumentCode,RejectAllApprovalsResponseID);

      OnRequestCanceledEventID := InsertEventStep(Workflow,DocCanceledEventCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnRequestCanceledEventID,DocCanceledConditionString);
      CancelAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CancelAllApprovalRequestsCode,
          OnRequestCanceledEventID);
      InsertNotificationArgument(CancelAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
      AllowRecordUsageResponseID :=
        InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,CancelAllApprovalsResponseID);
      OpenDocumentResponceID := InsertResponseStep(Workflow,WorkflowResponseHandling.OpenDocumentCode,AllowRecordUsageResponseID);
      ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,OpenDocumentResponceID);
      InsertMessageArgument(ShowMessageResponseID,ApprovalRequestCanceledMsg);

      OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
          SendApprovalRequestResponseID);
      SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestDelegatedEventID);

      SetNextStep(Workflow,SentApprovalRequestResponseID3,SendApprovalRequestResponseID);
    END;

    [Internal]
    PROCEDURE InsertRecApprovalWorkflowSteps@76(Workflow@1003 : Record 1501;ConditionString@1006 : Text;RecSendForApprovalEventCode@1001 : Code[128];RecCreateApprovalRequestsCode@1005 : Code[128];RecSendApprovalRequestForApprovalCode@1007 : Code[128];RecCanceledEventCode@1004 : Code[128];WorkflowStepArgument@1000 : Record 1523;ShowConfirmationMessage@1009 : Boolean;RemoveRestrictionOnCancel@1019 : Boolean);
    VAR
      SentForApprovalEventID@1010 : Integer;
      CreateApprovalRequestResponseID@1012 : Integer;
      SendApprovalRequestResponseID@1013 : Integer;
      OnAllRequestsApprovedEventID@1014 : Integer;
      OnRequestApprovedEventID@1016 : Integer;
      SendApprovalRequestResponseID2@1017 : Integer;
      OnRequestRejectedEventID@1018 : Integer;
      RejectAllApprovalsResponseID@1020 : Integer;
      OnRequestCanceledEventID@1022 : Integer;
      CancelAllApprovalsResponseID@1023 : Integer;
      OnRequestDelegatedEventID@1025 : Integer;
      SentApprovalRequestResponseID3@1026 : Integer;
      RestrictUsageResponseID@1008 : Integer;
      AllowRecordUsageResponseID@1011 : Integer;
      ShowMessageResponseID@1015 : Integer;
      TempResponseResponseID@1021 : Integer;
    BEGIN
      SentForApprovalEventID := InsertEntryPointEventStep(Workflow,RecSendForApprovalEventCode);
      InsertEventArgument(SentForApprovalEventID,ConditionString);

      RestrictUsageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RestrictRecordUsageCode,
          SentForApprovalEventID);
      CreateApprovalRequestResponseID := InsertResponseStep(Workflow,RecCreateApprovalRequestsCode,
          RestrictUsageResponseID);
      InsertApprovalArgument(CreateApprovalRequestResponseID,
        WorkflowStepArgument."Approver Type",WorkflowStepArgument."Approver Limit Type",
        WorkflowStepArgument."Workflow User Group Code",WorkflowStepArgument."Approver User ID",
        WorkflowStepArgument."Due Date Formula",ShowConfirmationMessage);
      SendApprovalRequestResponseID := InsertResponseStep(Workflow,RecSendApprovalRequestForApprovalCode,
          CreateApprovalRequestResponseID);
      InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');

      OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
      InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,OnAllRequestsApprovedEventID);

      OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
      SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestApprovedEventID);

      SetNextStep(Workflow,SendApprovalRequestResponseID2,SendApprovalRequestResponseID);

      OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
          SendApprovalRequestResponseID);
      RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
          OnRequestRejectedEventID);
      InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');

      OnRequestCanceledEventID := InsertEventStep(Workflow,RecCanceledEventCode,SendApprovalRequestResponseID);
      CancelAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CancelAllApprovalRequestsCode,
          OnRequestCanceledEventID);
      InsertNotificationArgument(CancelAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');

      TempResponseResponseID := CancelAllApprovalsResponseID;
      IF RemoveRestrictionOnCancel THEN BEGIN
        AllowRecordUsageResponseID :=
          InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,CancelAllApprovalsResponseID);
        TempResponseResponseID := AllowRecordUsageResponseID;
      END;
      IF ShowConfirmationMessage THEN BEGIN
        ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,TempResponseResponseID);
        InsertMessageArgument(ShowMessageResponseID,ApprovalRequestCanceledMsg);
      END;

      OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
          SendApprovalRequestResponseID);
      SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestDelegatedEventID);

      SetNextStep(Workflow,SentApprovalRequestResponseID3,SendApprovalRequestResponseID);
    END;

    [Internal]
    PROCEDURE InsertRecChangedApprovalWorkflowSteps@135(Workflow@1003 : Record 1501;RuleOperator@1006 : Option;RecChangedEventCode@1001 : Code[128];RecCreateApprovalRequestsCode@1005 : Code[128];RecSendApprovalRequestForApprovalCode@1007 : Code[128];VAR WorkflowStepArgument@1000 : Record 1523;TableNo@1024 : Integer;FieldNo@1027 : Integer;RecordChangeApprovalMsg@1019 : Text);
    VAR
      CustomerChangedEventID@1010 : Integer;
      RevertFieldResponseID@1002 : Integer;
      CreateApprovalRequestResponseID@1012 : Integer;
      SendApprovalRequestResponseID@1013 : Integer;
      OnAllRequestsApprovedEventID@1014 : Integer;
      OnRequestApprovedEventID@1016 : Integer;
      SendApprovalRequestResponseID2@1017 : Integer;
      OnRequestRejectedEventID@1018 : Integer;
      RejectAllApprovalsResponseID@1020 : Integer;
      DiscardNewValuesResponseID@1008 : Integer;
      OnRequestDelegatedEventID@1025 : Integer;
      SentApprovalRequestResponseID3@1026 : Integer;
      ShowMessageResponseID@1015 : Integer;
      ApplyNewValuesResponseID@1011 : Integer;
    BEGIN
      CustomerChangedEventID := InsertEntryPointEventStep(Workflow,RecChangedEventCode);
      InsertEventRule(CustomerChangedEventID,FieldNo,RuleOperator);

      RevertFieldResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RevertValueForFieldCode,
          CustomerChangedEventID);
      InsertChangeRecValueArgument(RevertFieldResponseID,TableNo,FieldNo);
      CreateApprovalRequestResponseID := InsertResponseStep(Workflow,RecCreateApprovalRequestsCode,
          RevertFieldResponseID);
      InsertApprovalArgument(CreateApprovalRequestResponseID,WorkflowStepArgument."Approver Type",
        WorkflowStepArgument."Approver Limit Type",WorkflowStepArgument."Workflow User Group Code",
        WorkflowStepArgument."Approver User ID",WorkflowStepArgument."Due Date Formula",FALSE);
      SendApprovalRequestResponseID := InsertResponseStep(Workflow,RecSendApprovalRequestForApprovalCode,
          CreateApprovalRequestResponseID);
      InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');
      ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,
          SendApprovalRequestResponseID);
      InsertMessageArgument(ShowMessageResponseID,COPYSTR(RecordChangeApprovalMsg,1,250));

      OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          ShowMessageResponseID);
      InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
      ApplyNewValuesResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ApplyNewValuesCode,
          OnAllRequestsApprovedEventID);
      InsertChangeRecValueArgument(ApplyNewValuesResponseID,TableNo,FieldNo);

      OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          ShowMessageResponseID);
      InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
      SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestApprovedEventID);

      SetNextStep(Workflow,SendApprovalRequestResponseID2,ShowMessageResponseID);

      OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
          ShowMessageResponseID);
      DiscardNewValuesResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.DiscardNewValuesCode,
          OnRequestRejectedEventID);
      RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
          DiscardNewValuesResponseID);
      InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');

      OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
          ShowMessageResponseID);
      SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestDelegatedEventID);

      SetNextStep(Workflow,SentApprovalRequestResponseID3,ShowMessageResponseID);
    END;

    [Internal]
    PROCEDURE InsertGenJnlBatchApprovalWorkflowSteps@8(Workflow@1003 : Record 1501;ConditionString@1006 : Text;RecSendForApprovalEventCode@1001 : Code[128];RecCreateApprovalRequestsCode@1005 : Code[128];RecSendApprovalRequestForApprovalCode@1007 : Code[128];RecCanceledEventCode@1004 : Code[128];WorkflowStepArgument@1000 : Record 1523;ShowConfirmationMessage@1024 : Boolean);
    VAR
      SentForApprovalEventID@1010 : Integer;
      CheckBatchBalanceResponseID@1008 : Integer;
      OnBatchIsBalancedEventID@1009 : Integer;
      OnBatchIsNotBalancedEventID@1011 : Integer;
      CreateApprovalRequestResponseID@1012 : Integer;
      SendApprovalRequestResponseID@1013 : Integer;
      OnAllRequestsApprovedEventID@1014 : Integer;
      OnRequestApprovedEventID@1016 : Integer;
      SendApprovalRequestResponseID2@1017 : Integer;
      OnRequestRejectedEventID@1018 : Integer;
      RejectAllApprovalsResponseID@1020 : Integer;
      OnRequestCanceledEventID@1022 : Integer;
      CancelAllApprovalsResponseID@1023 : Integer;
      OnRequestDelegatedEventID@1025 : Integer;
      SentApprovalRequestResponseID3@1026 : Integer;
      ShowMessageResponseID@1015 : Integer;
      RestrictUsageResponseID@1019 : Integer;
    BEGIN
      SentForApprovalEventID := InsertEntryPointEventStep(Workflow,RecSendForApprovalEventCode);
      InsertEventArgument(SentForApprovalEventID,ConditionString);

      CheckBatchBalanceResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CheckGeneralJournalBatchBalanceCode,
          SentForApprovalEventID);

      OnBatchIsBalancedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnGeneralJournalBatchBalancedCode,
          CheckBatchBalanceResponseID);

      RestrictUsageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RestrictRecordUsageCode,
          OnBatchIsBalancedEventID);
      CreateApprovalRequestResponseID := InsertResponseStep(Workflow,RecCreateApprovalRequestsCode,
          RestrictUsageResponseID);
      InsertApprovalArgument(CreateApprovalRequestResponseID,
        WorkflowStepArgument."Approver Type",WorkflowStepArgument."Approver Limit Type",
        WorkflowStepArgument."Workflow User Group Code",WorkflowStepArgument."Approver User ID",
        WorkflowStepArgument."Due Date Formula",ShowConfirmationMessage);
      SendApprovalRequestResponseID := InsertResponseStep(Workflow,RecSendApprovalRequestForApprovalCode,
          CreateApprovalRequestResponseID);
      InsertNotificationArgument(SendApprovalRequestResponseID,'',0,'');

      OnAllRequestsApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnAllRequestsApprovedEventID,BuildNoPendingApprovalsConditions);
      InsertResponseStep(Workflow,WorkflowResponseHandling.AllowRecordUsageCode,OnAllRequestsApprovedEventID);

      OnRequestApprovedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode,
          SendApprovalRequestResponseID);
      InsertEventArgument(OnRequestApprovedEventID,BuildPendingApprovalsConditions);
      SendApprovalRequestResponseID2 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestApprovedEventID);

      SetNextStep(Workflow,SendApprovalRequestResponseID2,SendApprovalRequestResponseID);

      OnRequestRejectedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode,
          SendApprovalRequestResponseID);
      RejectAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.RejectAllApprovalRequestsCode,
          OnRequestRejectedEventID);
      InsertNotificationArgument(RejectAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');

      OnRequestCanceledEventID := InsertEventStep(Workflow,RecCanceledEventCode,SendApprovalRequestResponseID);
      CancelAllApprovalsResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.CancelAllApprovalRequestsCode,
          OnRequestCanceledEventID);
      InsertNotificationArgument(CancelAllApprovalsResponseID,'',WorkflowStepArgument."Link Target Page",'');
      ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,CancelAllApprovalsResponseID);
      InsertMessageArgument(ShowMessageResponseID,ApprovalRequestCanceledMsg);

      OnRequestDelegatedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode,
          SendApprovalRequestResponseID);
      SentApprovalRequestResponseID3 := InsertResponseStep(Workflow,WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          OnRequestDelegatedEventID);

      SetNextStep(Workflow,SentApprovalRequestResponseID3,SendApprovalRequestResponseID);

      OnBatchIsNotBalancedEventID := InsertEventStep(Workflow,WorkflowEventHandling.RunWorkflowOnGeneralJournalBatchNotBalancedCode,
          CheckBatchBalanceResponseID);

      ShowMessageResponseID := InsertResponseStep(Workflow,WorkflowResponseHandling.ShowMessageCode,OnBatchIsNotBalancedEventID);
      InsertMessageArgument(ShowMessageResponseID,GeneralJournalBatchIsNotBalancedMsg);
    END;

    [Internal]
    PROCEDURE InsertGenJnlLineApprovalWorkflow@140(VAR Workflow@1001 : Record 1501;EventConditions@1002 : Text;ApproverType@1004 : Option;LimitType@1005 : Option;WorkflowUserGroupCode@1006 : Code[20];SpecificApprover@1008 : Code[50];DueDateFormula@1003 : DateFormula);
    VAR
      WorkflowStepArgument@1007 : Record 1523;
    BEGIN
      PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
        WorkflowUserGroupCode,DueDateFormula,TRUE);
      WorkflowStepArgument."Approver User ID" := SpecificApprover;

      InsertRecApprovalWorkflowSteps(Workflow,EventConditions,
        WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode,
        WorkflowResponseHandling.CreateApprovalRequestsCode,
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
        WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode,
        WorkflowStepArgument,
        FALSE,FALSE);
    END;

    [Internal]
    PROCEDURE InsertPurchaseDocumentApprovalWorkflow@69(VAR Workflow@1001 : Record 1501;DocumentType@1002 : Option;ApproverType@1004 : Option;LimitType@1005 : Option;WorkflowUserGroupCode@1006 : Code[20];DueDateFormula@1003 : DateFormula);
    VAR
      PurchaseHeader@1000 : Record 38;
      WorkflowStepArgument@1007 : Record 1523;
    BEGIN
      CASE DocumentType OF
        PurchaseHeader."Document Type"::Order:
          InsertWorkflow(Workflow,GetWorkflowCode(PurchOrderApprWorkflowCodeTxt),PurchOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
        PurchaseHeader."Document Type"::Invoice:
          InsertWorkflow(
            Workflow,GetWorkflowCode(PurchInvoiceApprWorkflowCodeTxt),PurchInvoiceApprWorkflowDescTxt,PurchDocCategoryTxt);
        PurchaseHeader."Document Type"::"Return Order":
          InsertWorkflow(Workflow,GetWorkflowCode(PurchReturnOrderApprWorkflowCodeTxt),
            PurchReturnOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
        PurchaseHeader."Document Type"::"Credit Memo":
          InsertWorkflow(Workflow,GetWorkflowCode(PurchCreditMemoApprWorkflowCodeTxt),
            PurchCreditMemoApprWorkflowDescTxt,PurchDocCategoryTxt);
        PurchaseHeader."Document Type"::Quote:
          InsertWorkflow(Workflow,GetWorkflowCode(PurchQuoteApprWorkflowCodeTxt),PurchQuoteApprWorkflowDescTxt,PurchDocCategoryTxt);
        PurchaseHeader."Document Type"::"Blanket Order":
          InsertWorkflow(Workflow,GetWorkflowCode(PurchBlanketOrderApprWorkflowCodeTxt),
            PurchBlanketOrderApprWorkflowDescTxt,PurchDocCategoryTxt);
      END;

      PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
        WorkflowUserGroupCode,DueDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,BuildPurchHeaderTypeConditions(DocumentType,PurchaseHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
        BuildPurchHeaderTypeConditions(DocumentType,PurchaseHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    [Internal]
    PROCEDURE InsertSalesDocumentApprovalWorkflow@57(VAR Workflow@1001 : Record 1501;DocumentType@1002 : Option;ApproverType@1004 : Option;LimitType@1005 : Option;WorkflowUserGroupCode@1006 : Code[20];DueDateFormula@1003 : DateFormula);
    VAR
      SalesHeader@1000 : Record 36;
      WorkflowStepArgument@1007 : Record 1523;
    BEGIN
      CASE DocumentType OF
        SalesHeader."Document Type"::Order:
          InsertWorkflow(Workflow,GetWorkflowCode(SalesOrderApprWorkflowCodeTxt),SalesOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::Invoice:
          InsertWorkflow(Workflow,GetWorkflowCode(SalesInvoiceApprWorkflowCodeTxt),
            SalesInvoiceApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::"Return Order":
          InsertWorkflow(Workflow,GetWorkflowCode(SalesReturnOrderApprWorkflowCodeTxt),
            SalesReturnOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::"Credit Memo":
          InsertWorkflow(Workflow,GetWorkflowCode(SalesCreditMemoApprWorkflowCodeTxt),
            SalesCreditMemoApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::Quote:
          InsertWorkflow(Workflow,GetWorkflowCode(SalesQuoteApprWorkflowCodeTxt),SalesQuoteApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::"Blanket Order":
          InsertWorkflow(Workflow,GetWorkflowCode(SalesBlanketOrderApprWorkflowCodeTxt),
            SalesBlanketOrderApprWorkflowDescTxt,SalesDocCategoryTxt);
      END;

      PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
        WorkflowUserGroupCode,DueDateFormula,TRUE);

      InsertDocApprovalWorkflowSteps(Workflow,BuildSalesHeaderTypeConditions(DocumentType,SalesHeader.Status::Open),
        WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
        BuildSalesHeaderTypeConditions(DocumentType,SalesHeader.Status::"Pending Approval"),
        WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
        WorkflowStepArgument,TRUE);
    END;

    [Internal]
    PROCEDURE InsertSalesDocumentCreditLimitApprovalWorkflow@53(VAR Workflow@1001 : Record 1501;DocumentType@1002 : Option;ApproverType@1004 : Option;LimitType@1005 : Option;WorkflowUserGroupCode@1006 : Code[20];DueDateFormula@1003 : DateFormula);
    VAR
      SalesHeader@1000 : Record 36;
      WorkflowStepArgument@1007 : Record 1523;
    BEGIN
      CASE DocumentType OF
        SalesHeader."Document Type"::Order:
          InsertWorkflow(Workflow,GetWorkflowCode(SalesOrderCreditLimitApprWorkflowCodeTxt),
            SalesOrderCreditLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::Invoice:
          InsertWorkflow(Workflow,GetWorkflowCode(SalesInvoiceCreditLimitApprWorkflowCodeTxt),
            SalesInvoiceCreditLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::"Return Order":
          InsertWorkflow(Workflow,GetWorkflowCode(SalesRetOrderCrLimitApprWorkflowCodeTxt),
            SalesRetOrderCrLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::"Credit Memo":
          InsertWorkflow(Workflow,GetWorkflowCode(SalesCrMemoCrLimitApprWorkflowCodeTxt),
            SalesCrMemoCrLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::Quote:
          InsertWorkflow(Workflow,GetWorkflowCode(SalesQuoteCrLimitApprWorkflowCodeTxt),
            SalesQuoteCrLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
        SalesHeader."Document Type"::"Blanket Order":
          InsertWorkflow(Workflow,GetWorkflowCode(SalesBlanketOrderCrLimitApprWorkflowCodeTxt),
            SalesBlanketOrderCrLimitApprWorkflowDescTxt,SalesDocCategoryTxt);
      END;

      PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
        WorkflowUserGroupCode,DueDateFormula,TRUE);

      InsertSalesDocWithCreditLimitApprovalWorkflowSteps(Workflow,
        BuildSalesHeaderTypeConditions(DocumentType,SalesHeader.Status::Open),
        BuildSalesHeaderTypeConditions(DocumentType,SalesHeader.Status::"Pending Approval"),WorkflowStepArgument,TRUE);
    END;

    LOCAL PROCEDURE InsertEntryPointEventStep@51(Workflow@1000 : Record 1501;FunctionName@1001 : Code[128]) : Integer;
    VAR
      WorkflowStep@1003 : Record 1502;
    BEGIN
      InsertStep(WorkflowStep,Workflow.Code,WorkflowStep.Type::"Event",FunctionName);
      WorkflowStep.VALIDATE("Entry Point",TRUE);
      WorkflowStep.MODIFY(TRUE);
      EXIT(WorkflowStep.ID);
    END;

    LOCAL PROCEDURE InsertEventStep@12(Workflow@1000 : Record 1501;FunctionName@1001 : Code[128];PreviousStepID@1002 : Integer) : Integer;
    VAR
      WorkflowStep@1003 : Record 1502;
    BEGIN
      InsertStep(WorkflowStep,Workflow.Code,WorkflowStep.Type::"Event",FunctionName);
      WorkflowStep."Sequence No." := GetSequenceNumber(Workflow,PreviousStepID);
      WorkflowStep.VALIDATE("Previous Workflow Step ID",PreviousStepID);
      WorkflowStep.MODIFY(TRUE);
      EXIT(WorkflowStep.ID);
    END;

    LOCAL PROCEDURE InsertResponseStep@13(Workflow@1001 : Record 1501;FunctionName@1000 : Code[128];PreviousStepID@1002 : Integer) : Integer;
    VAR
      WorkflowStep@1003 : Record 1502;
    BEGIN
      InsertStep(WorkflowStep,Workflow.Code,WorkflowStep.Type::Response,FunctionName);
      WorkflowStep."Sequence No." := GetSequenceNumber(Workflow,PreviousStepID);
      WorkflowStep.VALIDATE("Previous Workflow Step ID",PreviousStepID);
      WorkflowStep.MODIFY(TRUE);
      EXIT(WorkflowStep.ID);
    END;

    LOCAL PROCEDURE InsertStep@30(VAR WorkflowStep@1000 : Record 1502;WorkflowCode@1001 : Code[20];StepType@1003 : Option;FunctionName@1002 : Code[128]);
    BEGIN
      WITH WorkflowStep DO BEGIN
        VALIDATE("Workflow Code",WorkflowCode);
        VALIDATE(Type,StepType);
        VALIDATE("Function Name",FunctionName);
        INSERT(TRUE);
      END;
    END;

    LOCAL PROCEDURE MarkWorkflowAsTemplate@74(VAR Workflow@1000 : Record 1501);
    BEGIN
      Workflow.VALIDATE(Template,TRUE);
      Workflow.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE GetSequenceNumber@22(Workflow@1001 : Record 1501;PreviousStepID@1002 : Integer) : Integer;
    VAR
      WorkflowStep@1000 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Workflow.Code);
      WorkflowStep.SETRANGE("Previous Workflow Step ID",PreviousStepID);
      IF WorkflowStep.FINDLAST THEN
        EXIT(WorkflowStep."Sequence No." + 1);
    END;

    LOCAL PROCEDURE SetNextStep@34(Workflow@1003 : Record 1501;WorkflowStepID@1001 : Integer;NextStepID@1000 : Integer);
    VAR
      WorkflowStep@1002 : Record 1502;
    BEGIN
      WorkflowStep.GET(Workflow.Code,WorkflowStepID);
      WorkflowStep.VALIDATE("Next Workflow Step ID",NextStepID);
      WorkflowStep.MODIFY(TRUE);
    END;

    [External]
    PROCEDURE InsertTableRelation@1(TableId@1000 : Integer;FieldId@1001 : Integer;RelatedTableId@1002 : Integer;RelatedFieldId@1003 : Integer);
    VAR
      WorkflowTableRelation@1004 : Record 1505;
    BEGIN
      WorkflowTableRelation.INIT;
      WorkflowTableRelation."Table ID" := TableId;
      WorkflowTableRelation."Field ID" := FieldId;
      WorkflowTableRelation."Related Table ID" := RelatedTableId;
      WorkflowTableRelation."Related Field ID" := RelatedFieldId;
      IF WorkflowTableRelation.INSERT THEN;
    END;

    LOCAL PROCEDURE InsertWorkflowCategory@118(Code@1000 : Code[20];Description@1001 : Text[100]);
    VAR
      WorkflowCategory@1002 : Record 1508;
    BEGIN
      WorkflowCategory.INIT;
      WorkflowCategory.Code := Code;
      WorkflowCategory.Description := Description;
      IF WorkflowCategory.INSERT THEN;
    END;

    LOCAL PROCEDURE InsertEventArgument@41(WorkflowStepID@1000 : Integer;EventConditions@1008 : Text);
    VAR
      WorkflowStep@1001 : Record 1502;
      WorkflowStepArgument@1002 : Record 1523;
    BEGIN
      IF EventConditions = '' THEN
        ERROR(InvalidEventCondErr);

      WorkflowStepArgument.Type := WorkflowStepArgument.Type::"Event";
      WorkflowStepArgument.INSERT(TRUE);
      WorkflowStepArgument.SetEventFilters(EventConditions);

      WorkflowStep.SETRANGE(ID,WorkflowStepID);
      WorkflowStep.FINDFIRST;
      WorkflowStep.Argument := WorkflowStepArgument.ID;
      WorkflowStep.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE InsertEventRule@124(WorkflowStepID@1000 : Integer;FieldNo@1003 : Integer;Operator@1008 : Option);
    VAR
      WorkflowStep@1004 : Record 1502;
      WorkflowRule@1002 : Record 1524;
      WorkflowEvent@1001 : Record 1520;
    BEGIN
      WorkflowStep.SETRANGE(ID,WorkflowStepID);
      WorkflowStep.FINDFIRST;

      WorkflowRule.INIT;
      WorkflowRule."Workflow Code" := WorkflowStep."Workflow Code";
      WorkflowRule."Workflow Step ID" := WorkflowStep.ID;
      WorkflowRule.Operator := Operator;

      IF WorkflowEvent.GET(WorkflowStep."Function Name") THEN
        WorkflowRule."Table ID" := WorkflowEvent."Table ID";
      WorkflowRule."Field No." := FieldNo;
      WorkflowRule.INSERT(TRUE);
    END;

    LOCAL PROCEDURE InsertNotificationArgument@42(WorkflowStepID@1000 : Integer;NotifUserID@1004 : Code[50];LinkTargetPage@1007 : Integer;CustomLink@1003 : Text[250]);
    VAR
      WorkflowStepArgument@1001 : Record 1523;
    BEGIN
      InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

      WorkflowStepArgument."Notification User ID" := NotifUserID;
      WorkflowStepArgument."Link Target Page" := LinkTargetPage;
      WorkflowStepArgument."Custom Link" := CustomLink;
      WorkflowStepArgument.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE InsertPmtLineCreationArgument@43(WorkflowStepID@1004 : Integer;GenJnlTemplateName@1002 : Code[10];GenJnlBatchName@1003 : Code[10]);
    VAR
      WorkflowStepArgument@1000 : Record 1523;
    BEGIN
      InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

      WorkflowStepArgument."General Journal Template Name" := GenJnlTemplateName;
      WorkflowStepArgument."General Journal Batch Name" := GenJnlBatchName;
      WorkflowStepArgument.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE InsertApprovalArgument@44(WorkflowStepID@1000 : Integer;ApproverType@1009 : Option;ApproverLimitType@1010 : Option;WorkflowUserGroupCode@1002 : Code[20];ApproverId@1005 : Code[50];DueDateFormula@1003 : DateFormula;ShowConfirmationMessage@1004 : Boolean);
    VAR
      WorkflowStepArgument@1001 : Record 1523;
    BEGIN
      InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

      WorkflowStepArgument."Approver Type" := ApproverType;
      WorkflowStepArgument."Approver Limit Type" := ApproverLimitType;
      WorkflowStepArgument."Workflow User Group Code" := WorkflowUserGroupCode;
      WorkflowStepArgument."Approver User ID" := ApproverId;
      WorkflowStepArgument."Due Date Formula" := DueDateFormula;
      WorkflowStepArgument."Show Confirmation Message" := ShowConfirmationMessage;
      WorkflowStepArgument.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE InsertMessageArgument@14(WorkflowStepID@1000 : Integer;Message@1002 : Text[250]);
    VAR
      WorkflowStepArgument@1001 : Record 1523;
    BEGIN
      InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

      WorkflowStepArgument.Message := Message;
      WorkflowStepArgument.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE InsertChangeRecValueArgument@130(WorkflowStepID@1000 : Integer;TableNo@1002 : Integer;FieldNo@1003 : Integer);
    VAR
      WorkflowStepArgument@1001 : Record 1523;
    BEGIN
      InsertStepArgument(WorkflowStepArgument,WorkflowStepID);

      WorkflowStepArgument."Table No." := TableNo;
      WorkflowStepArgument."Field No." := FieldNo;
      WorkflowStepArgument.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE InsertStepArgument@19(VAR WorkflowStepArgument@1003 : Record 1523;WorkflowStepID@1000 : Integer);
    VAR
      WorkflowStep@1002 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE(ID,WorkflowStepID);
      WorkflowStep.FINDFIRST;

      IF WorkflowStepArgument.GET(WorkflowStep.Argument) THEN
        EXIT;

      WorkflowStepArgument.Type := WorkflowStepArgument.Type::Response;
      WorkflowStepArgument.VALIDATE("Response Function Name",WorkflowStep."Function Name");
      WorkflowStepArgument.INSERT(TRUE);

      WorkflowStep.Argument := WorkflowStepArgument.ID;
      WorkflowStep.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE GetWorkflowCode@55(WorkflowCode@1000 : Text) : Code[20];
    VAR
      Workflow@1001 : Record 1501;
    BEGIN
      EXIT(COPYSTR(FORMAT(Workflow.COUNT + 1) + '-' + WorkflowCode,1,MAXSTRLEN(Workflow.Code)));
    END;

    [External]
    PROCEDURE GetWorkflowTemplateCode@84(WorkflowCode@1000 : Code[17]) : Code[20];
    BEGIN
      EXIT(GetWorkflowTemplateToken + WorkflowCode);
    END;

    [External]
    PROCEDURE GetWorkflowTemplateToken@89() : Code[3];
    BEGIN
      IF CustomTemplateToken <> '' THEN
        EXIT(CustomTemplateToken);

      EXIT(MsTemplateTok);
    END;

    [External]
    PROCEDURE GetWorkflowWizardCode@101(WorkflowCode@1000 : Code[17]) : Code[20];
    BEGIN
      EXIT(MsWizardWorkflowTok + WorkflowCode);
    END;

    [External]
    PROCEDURE GetWorkflowWizardToken@123() : Code[3];
    BEGIN
      EXIT(MsWizardWorkflowTok);
    END;

    [External]
    PROCEDURE SetTemplateForWorkflowStep@70(Workflow@1000 : Record 1501;FunctionName@1005 : Code[128]);
    VAR
      WorkflowStepArgument@1001 : Record 1523;
      WorkflowStep@1002 : Record 1502;
    BEGIN
      WorkflowStep.SETRANGE("Workflow Code",Workflow.Code);
      WorkflowStep.SETRANGE("Function Name",FunctionName);
      IF WorkflowStep.FINDSET THEN
        REPEAT
          IF NOT WorkflowStepArgument.GET(WorkflowStep.Argument) THEN
            InsertNotificationArgument(WorkflowStep.ID,'',0,'');
        UNTIL WorkflowStep.NEXT = 0;
    END;

    PROCEDURE SetCustomTemplateToken@36(NewCustomTemplateToken@1000 : Code[3]);
    BEGIN
      CustomTemplateToken := NewCustomTemplateToken;
    END;

    LOCAL PROCEDURE PopulateWorkflowStepArgument@5(VAR WorkflowStepArgument@1005 : Record 1523;ApproverType@1004 : Option;ApproverLimitType@1003 : Option;ApprovalEntriesPage@1002 : Integer;WorkflowUserGroupCode@1001 : Code[20];DueDateFormula@1000 : DateFormula;ShowConfirmationMessage@1006 : Boolean);
    BEGIN
      WorkflowStepArgument.INIT;
      WorkflowStepArgument.Type := WorkflowStepArgument.Type::Response;
      WorkflowStepArgument."Approver Type" := ApproverType;
      WorkflowStepArgument."Approver Limit Type" := ApproverLimitType;
      WorkflowStepArgument."Workflow User Group Code" := WorkflowUserGroupCode;
      WorkflowStepArgument."Due Date Formula" := DueDateFormula;
      WorkflowStepArgument."Link Target Page" := ApprovalEntriesPage;
      WorkflowStepArgument."Show Confirmation Message" := ShowConfirmationMessage;
    END;

    LOCAL PROCEDURE BuildNoPendingApprovalsConditions@56() : Text;
    VAR
      ApprovalEntry@1000 : Record 454;
    BEGIN
      ApprovalEntry.SETRANGE("Pending Approvals",0);
      EXIT(STRSUBSTNO(PendingApprovalsCondnTxt,Encode(ApprovalEntry.GETVIEW(FALSE))));
    END;

    LOCAL PROCEDURE BuildPendingApprovalsConditions@61() : Text;
    VAR
      ApprovalEntry@1000 : Record 454;
    BEGIN
      ApprovalEntry.SETFILTER("Pending Approvals",'>%1',0);
      EXIT(STRSUBSTNO(PendingApprovalsCondnTxt,Encode(ApprovalEntry.GETVIEW(FALSE))));
    END;

    [Internal]
    PROCEDURE BuildIncomingDocumentTypeConditions@182(Status@1002 : Option) : Text;
    VAR
      IncomingDocument@1000 : Record 130;
      IncomingDocumentAttachment@1001 : Record 133;
    BEGIN
      IncomingDocument.SETRANGE(Status,Status);
      EXIT(
        STRSUBSTNO(
          IncomingDocumentTypeCondnTxt,Encode(IncomingDocument.GETVIEW(FALSE)),Encode(IncomingDocumentAttachment.GETVIEW(FALSE))));
    END;

    [Internal]
    PROCEDURE BuildIncomingDocumentOCRTypeConditions@128(OCRStatus@1003 : Option) : Text;
    VAR
      IncomingDocument@1000 : Record 130;
      IncomingDocumentAttachment@1001 : Record 133;
    BEGIN
      IncomingDocument.SETRANGE("OCR Status",OCRStatus);
      EXIT(
        STRSUBSTNO(
          IncomingDocumentTypeCondnTxt,Encode(IncomingDocument.GETVIEW(FALSE)),Encode(IncomingDocumentAttachment.GETVIEW(FALSE))));
    END;

    [Internal]
    PROCEDURE BuildPurchHeaderTypeConditions@64(DocumentType@1002 : Option;Status@1003 : Option) : Text;
    VAR
      PurchaseHeader@1000 : Record 38;
      PurchaseLine@1001 : Record 39;
    BEGIN
      PurchaseHeader.SETRANGE("Document Type",DocumentType);
      PurchaseHeader.SETRANGE(Status,Status);
      EXIT(STRSUBSTNO(PurchHeaderTypeCondnTxt,Encode(PurchaseHeader.GETVIEW(FALSE)),Encode(PurchaseLine.GETVIEW(FALSE))));
    END;

    [Internal]
    PROCEDURE BuildSalesHeaderTypeConditions@67(DocumentType@1002 : Option;Status@1003 : Option) : Text;
    VAR
      SalesHeader@1000 : Record 36;
      SalesLine@1001 : Record 37;
    BEGIN
      SalesHeader.SETRANGE("Document Type",DocumentType);
      SalesHeader.SETRANGE(Status,Status);
      EXIT(STRSUBSTNO(SalesHeaderTypeCondnTxt,Encode(SalesHeader.GETVIEW(FALSE)),Encode(SalesLine.GETVIEW(FALSE))));
    END;

    [Internal]
    PROCEDURE BuildCustomerTypeConditions@160() : Text;
    VAR
      Customer@1000 : Record 18;
    BEGIN
      EXIT(STRSUBSTNO(CustomerTypeCondnTxt,Encode(Customer.GETVIEW(FALSE))));
    END;

    [Internal]
    PROCEDURE BuildVendorTypeConditions@148() : Text;
    VAR
      Vendor@1000 : Record 23;
    BEGIN
      EXIT(STRSUBSTNO(VendorTypeCondnTxt,Encode(Vendor.GETVIEW(FALSE))));
    END;

    [Internal]
    PROCEDURE BuildItemTypeConditions@149() : Text;
    VAR
      Item@1000 : Record 27;
    BEGIN
      EXIT(STRSUBSTNO(ItemTypeCondnTxt,Encode(Item.GETVIEW(FALSE))));
    END;

    LOCAL PROCEDURE BuildGeneralJournalBatchTypeConditions@16() : Text;
    VAR
      GenJournalBatch@1000 : Record 232;
    BEGIN
      EXIT(BuildGeneralJournalBatchTypeConditionsFromRec(GenJournalBatch));
    END;

    [Internal]
    PROCEDURE BuildGeneralJournalBatchTypeConditionsFromRec@131(VAR GenJournalBatch@1001 : Record 232) : Text;
    BEGIN
      EXIT(STRSUBSTNO(GeneralJournalBatchTypeCondnTxt,Encode(GenJournalBatch.GETVIEW(FALSE))));
    END;

    [Internal]
    PROCEDURE BuildGeneralJournalLineTypeConditions@33(VAR GenJournalLine@1000 : Record 81) : Text;
    BEGIN
      EXIT(STRSUBSTNO(GeneralJournalLineTypeCondnTxt,Encode(GenJournalLine.GETVIEW(FALSE))));
    END;

    LOCAL PROCEDURE InsertJobQueueData@63();
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      CreateJobQueueEntry(JobQueueEntry."Object Type to Run"::Report,REPORT::"Delegate Approval Requests",CURRENTDATETIME,1440);
    END;

    [External]
    PROCEDURE CreateJobQueueEntry@17(ObjectTypeToRun@1001 : Option;ObjectIdToRun@1002 : Integer;NotBefore@1004 : DateTime;NoOfMinutesBetweenRuns@1003 : Integer);
    VAR
      JobQueueEntry@1000 : Record 472;
    BEGIN
      WITH JobQueueEntry DO BEGIN
        SETRANGE("Object Type to Run",ObjectTypeToRun);
        SETRANGE("Object ID to Run",ObjectIdToRun);
        SETRANGE("Recurring Job",TRUE);
        IF NOT ISEMPTY THEN
          EXIT;

        InitRecurringJob(NoOfMinutesBetweenRuns);
        "Earliest Start Date/Time" := NotBefore;
        "Object Type to Run" := ObjectTypeToRun;
        "Object ID to Run" := ObjectIdToRun;
        "Report Output Type" := "Report Output Type"::"None (Processing only)";
        "Maximum No. of Attempts to Run" := 3;
        CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue",JobQueueEntry);
      END;
    END;

    LOCAL PROCEDURE Encode@93(Text@1001 : Text) : Text;
    VAR
      XMLDOMManagement@1000 : Codeunit 6224;
    BEGIN
      EXIT(XMLDOMManagement.XMLEscape(Text));
    END;

    PROCEDURE GetGeneralJournalBatchIsNotBalancedMsg@37() Message : Text[250];
    BEGIN
      Message := GeneralJournalBatchIsNotBalancedMsg;
    END;

    BEGIN
    END.
  }
}

