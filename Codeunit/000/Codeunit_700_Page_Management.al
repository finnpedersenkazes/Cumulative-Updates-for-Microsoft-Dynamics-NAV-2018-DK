OBJECT Codeunit 700 Page Management
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      DataTypeManagement@1001 : Codeunit 701;

    [External]
    PROCEDURE PageRun@7(RecRelatedVariant@1000 : Variant) : Boolean;
    VAR
      RecordRef@1002 : RecordRef;
      RecordRefVariant@1003 : Variant;
      PageID@1004 : Integer;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT(FALSE);

      IF NOT DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) THEN
        EXIT(FALSE);

      PageID := GetPageID(RecordRef);

      IF PageID <> 0 THEN BEGIN
        RecordRefVariant := RecordRef;
        PAGE.RUN(PageID,RecordRefVariant);
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE PageRunModal@10(RecRelatedVariant@1000 : Variant) : Boolean;
    VAR
      RecordRef@1002 : RecordRef;
      RecordRefVariant@1003 : Variant;
      PageID@1004 : Integer;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT(FALSE);

      IF NOT DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) THEN
        EXIT(FALSE);

      PageID := GetPageID(RecordRef);

      IF PageID <> 0 THEN BEGIN
        RecordRefVariant := RecordRef;
        PAGE.RUNMODAL(PageID,RecordRefVariant);
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE PageRunModalWithFieldFocus@1(RecRelatedVariant@1000 : Variant;FieldNumber@1001 : Integer) : Boolean;
    VAR
      RecordRef@1002 : RecordRef;
      RecordRefVariant@1003 : Variant;
      PageID@1004 : Integer;
    BEGIN
      IF NOT GUIALLOWED THEN
        EXIT(FALSE);

      IF NOT DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) THEN
        EXIT(FALSE);

      PageID := GetPageID(RecordRef);

      IF PageID <> 0 THEN BEGIN
        RecordRefVariant := RecordRef;
        PAGE.RUNMODAL(PageID,RecordRefVariant,FieldNumber);
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    [Internal]
    PROCEDURE GetPageID@4(RecRelatedVariant@1001 : Variant) : Integer;
    VAR
      RecordRef@1004 : RecordRef;
      EmptyRecRef@1002 : RecordRef;
      PageID@1003 : Integer;
    BEGIN
      IF NOT DataTypeManagement.GetRecordRef(RecRelatedVariant,RecordRef) THEN
        EXIT;

      EmptyRecRef.OPEN(RecordRef.NUMBER);
      PageID := GetConditionalCardPageID(RecordRef);
      // Choose default card only if record exists
      IF RecordRef.RECORDID <> EmptyRecRef.RECORDID THEN
        IF PageID = 0 THEN
          PageID := GetDefaultCardPageID(RecordRef.NUMBER);

      IF PageID = 0 THEN
        PageID := GetDefaultLookupPageID(RecordRef.NUMBER);

      EXIT(PageID);
    END;

    [External]
    PROCEDURE GetDefaultCardPageID@2(TableID@1000 : Integer) : Integer;
    VAR
      PageMetadata@1002 : Record 2000000138;
      LookupPageID@1003 : Integer;
    BEGIN
      IF TableID = 0 THEN
        EXIT(0);

      LookupPageID := GetDefaultLookupPageID(TableID);
      IF LookupPageID <> 0 THEN BEGIN
        PageMetadata.GET(LookupPageID);
        IF PageMetadata.CardPageID <> 0 THEN
          EXIT(PageMetadata.CardPageID);
      END;
      EXIT(0);
    END;

    [External]
    PROCEDURE GetDefaultLookupPageID@8(TableID@1000 : Integer) : Integer;
    VAR
      TableMetadata@1001 : Record 2000000136;
    BEGIN
      IF TableID = 0 THEN
        EXIT(0);

      TableMetadata.GET(TableID);
      EXIT(TableMetadata.LookupPageID);
    END;

    [External]
    PROCEDURE GetConditionalCardPageID@3(RecordRef@1001 : RecordRef) : Integer;
    BEGIN
      CASE RecordRef.NUMBER OF
        DATABASE::"Company Information":
          EXIT(PAGE::"Company Information");
        DATABASE::"Sales Header":
          EXIT(GetSalesHeaderPageID(RecordRef));
        DATABASE::"Purchase Header":
          EXIT(GetPurchaseHeaderPageID(RecordRef));
        DATABASE::"Service Header":
          EXIT(GetServiceHeaderPageID(RecordRef));
        DATABASE::"Gen. Journal Batch":
          EXIT(GetGenJournalBatchPageID(RecordRef));
        DATABASE::"Gen. Journal Line":
          EXIT(GetGenJournalLinePageID(RecordRef));
        DATABASE::"Sales Header Archive":
          EXIT(GetSalesHeaderArchivePageID(RecordRef));
        DATABASE::"Purchase Header Archive":
          EXIT(GetPurchaseHeaderArchivePageID(RecordRef));
        DATABASE::"Res. Journal Line":
          EXIT(PAGE::"Resource Journal");
        DATABASE::"Job Journal Line":
          EXIT(PAGE::"Job Journal");
        DATABASE::"Item Analysis View":
          EXIT(GetAnalysisViewPageID(RecordRef));
        DATABASE::"Purchases & Payables Setup":
          EXIT(PAGE::"Purchases & Payables Setup");
        DATABASE::"Approval Entry":
          EXIT(GetApprovalEntryPageID(RecordRef));
        DATABASE::"Doc. Exch. Service Setup":
          EXIT(PAGE::"Doc. Exch. Service Setup");
        DATABASE::"Incoming Documents Setup":
          EXIT(PAGE::"Incoming Documents Setup");
        DATABASE::"Text-to-Account Mapping":
          EXIT(PAGE::"Text-to-Account Mapping Wksh.");
        DATABASE::"Cash Flow Setup":
          EXIT(PAGE::"Cash Flow Setup");
        DATABASE::"Production Order":
          EXIT(GetProductionOrderPageID(RecordRef));
      END;
      EXIT(0);
    END;

    LOCAL PROCEDURE GetSalesHeaderPageID@15(RecordRef@1000 : RecordRef) : Integer;
    VAR
      SalesHeader@1001 : Record 36;
    BEGIN
      RecordRef.SETTABLE(SalesHeader);
      CASE SalesHeader."Document Type" OF
        SalesHeader."Document Type"::Quote:
          EXIT(PAGE::"Sales Quote");
        SalesHeader."Document Type"::Order:
          EXIT(PAGE::"Sales Order");
        SalesHeader."Document Type"::Invoice:
          EXIT(PAGE::"Sales Invoice");
        SalesHeader."Document Type"::"Credit Memo":
          EXIT(PAGE::"Sales Credit Memo");
        SalesHeader."Document Type"::"Blanket Order":
          EXIT(PAGE::"Blanket Sales Order");
        SalesHeader."Document Type"::"Return Order":
          EXIT(PAGE::"Sales Return Order");
      END;
    END;

    LOCAL PROCEDURE GetPurchaseHeaderPageID@17(RecordRef@1000 : RecordRef) : Integer;
    VAR
      PurchaseHeader@1001 : Record 38;
    BEGIN
      RecordRef.SETTABLE(PurchaseHeader);
      CASE PurchaseHeader."Document Type" OF
        PurchaseHeader."Document Type"::Quote:
          EXIT(PAGE::"Purchase Quote");
        PurchaseHeader."Document Type"::Order:
          EXIT(PAGE::"Purchase Order");
        PurchaseHeader."Document Type"::Invoice:
          EXIT(PAGE::"Purchase Invoice");
        PurchaseHeader."Document Type"::"Credit Memo":
          EXIT(PAGE::"Purchase Credit Memo");
        PurchaseHeader."Document Type"::"Blanket Order":
          EXIT(PAGE::"Blanket Purchase Order");
        PurchaseHeader."Document Type"::"Return Order":
          EXIT(PAGE::"Purchase Return Order");
      END;
    END;

    LOCAL PROCEDURE GetServiceHeaderPageID@21(RecordRef@1000 : RecordRef) : Integer;
    VAR
      ServiceHeader@1001 : Record 5900;
    BEGIN
      RecordRef.SETTABLE(ServiceHeader);
      CASE ServiceHeader."Document Type" OF
        ServiceHeader."Document Type"::Quote:
          EXIT(PAGE::"Service Quote");
        ServiceHeader."Document Type"::Order:
          EXIT(PAGE::"Service Order");
        ServiceHeader."Document Type"::Invoice:
          EXIT(PAGE::"Service Invoice");
        ServiceHeader."Document Type"::"Credit Memo":
          EXIT(PAGE::"Service Credit Memo");
      END;
    END;

    LOCAL PROCEDURE GetGenJournalBatchPageID@13(RecordRef@1000 : RecordRef) : Integer;
    VAR
      GenJournalBatch@1001 : Record 232;
      GenJournalLine@1003 : Record 81;
    BEGIN
      RecordRef.SETTABLE(GenJournalBatch);

      GenJournalLine.SETRANGE("Journal Template Name",GenJournalBatch."Journal Template Name");
      GenJournalLine.SETRANGE("Journal Batch Name",GenJournalBatch.Name);
      IF NOT GenJournalLine.FINDFIRST THEN
        EXIT(PAGE::"General Journal");

      RecordRef.GETTABLE(GenJournalLine);
      EXIT(GetGenJournalLinePageID(RecordRef));
    END;

    LOCAL PROCEDURE GetGenJournalLinePageID@20(RecordRef@1000 : RecordRef) : Integer;
    VAR
      GenJournalLine@1003 : Record 81;
      GenJournalTemplate@1002 : Record 80;
    BEGIN
      RecordRef.SETTABLE(GenJournalLine);
      GenJournalTemplate.GET(GenJournalLine."Journal Template Name");
      IF GenJournalTemplate.Recurring THEN
        EXIT(PAGE::"Recurring General Journal");
      CASE GenJournalTemplate.Type OF
        GenJournalTemplate.Type::General:
          EXIT(PAGE::"General Journal");
        GenJournalTemplate.Type::Sales:
          EXIT(PAGE::"Sales Journal");
        GenJournalTemplate.Type::Purchases:
          EXIT(PAGE::"Purchase Journal");
        GenJournalTemplate.Type::"Cash Receipts":
          EXIT(PAGE::"Cash Receipt Journal");
        GenJournalTemplate.Type::Payments:
          EXIT(PAGE::"Payment Journal");
        GenJournalTemplate.Type::Assets:
          EXIT(PAGE::"Fixed Asset G/L Journal");
        GenJournalTemplate.Type::Intercompany:
          EXIT(PAGE::"IC General Journal");
        GenJournalTemplate.Type::Jobs:
          EXIT(PAGE::"Job G/L Journal");
      END;
    END;

    LOCAL PROCEDURE GetSalesHeaderArchivePageID@19(RecordRef@1000 : RecordRef) : Integer;
    VAR
      SalesHeaderArchive@1003 : Record 5107;
    BEGIN
      RecordRef.SETTABLE(SalesHeaderArchive);
      CASE SalesHeaderArchive."Document Type" OF
        SalesHeaderArchive."Document Type"::Quote:
          EXIT(PAGE::"Sales Quote Archive");
        SalesHeaderArchive."Document Type"::Order:
          EXIT(PAGE::"Sales Order Archive");
        SalesHeaderArchive."Document Type"::"Return Order":
          EXIT(PAGE::"Sales Return Order Archive");
      END;
    END;

    LOCAL PROCEDURE GetPurchaseHeaderArchivePageID@18(RecordRef@1000 : RecordRef) : Integer;
    VAR
      PurchaseHeaderArchive@1002 : Record 5109;
    BEGIN
      RecordRef.SETTABLE(PurchaseHeaderArchive);
      CASE PurchaseHeaderArchive."Document Type" OF
        PurchaseHeaderArchive."Document Type"::Quote:
          EXIT(PAGE::"Purchase Quote Archive");
        PurchaseHeaderArchive."Document Type"::Order:
          EXIT(PAGE::"Purchase Order Archive");
        PurchaseHeaderArchive."Document Type"::"Return Order":
          EXIT(PAGE::"Purchase Return Order Archive");
      END;
    END;

    LOCAL PROCEDURE GetAnalysisViewPageID@12(RecordRef@1000 : RecordRef) : Integer;
    VAR
      ItemAnalysisView@1002 : Record 7152;
    BEGIN
      RecordRef.SETTABLE(ItemAnalysisView);
      CASE ItemAnalysisView."Analysis Area" OF
        ItemAnalysisView."Analysis Area"::Sales:
          EXIT(PAGE::"Sales Analysis View Card");
        ItemAnalysisView."Analysis Area"::Purchase:
          EXIT(PAGE::"Purchase Analysis View Card");
        ItemAnalysisView."Analysis Area"::Inventory:
          EXIT(PAGE::"Invt. Analysis View Card");
      END;
    END;

    LOCAL PROCEDURE GetApprovalEntryPageID@9(RecordRef@1000 : RecordRef) : Integer;
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      RecordRef.SETTABLE(ApprovalEntry);
      CASE ApprovalEntry.Status OF
        ApprovalEntry.Status::Open:
          EXIT(PAGE::"Requests to Approve");
        ELSE
          EXIT(PAGE::"Approval Entries");
      END;
    END;

    LOCAL PROCEDURE GetProductionOrderPageID@22(RecordRef@1001 : RecordRef) : Integer;
    VAR
      ProductionOrder@1000 : Record 5405;
    BEGIN
      RecordRef.SETTABLE(ProductionOrder);
      CASE ProductionOrder.Status OF
        ProductionOrder.Status::Simulated:
          EXIT(PAGE::"Simulated Production Order");
        ProductionOrder.Status::Planned:
          EXIT(PAGE::"Planned Production Order");
        ProductionOrder.Status::"Firm Planned":
          EXIT(PAGE::"Firm Planned Prod. Order");
        ProductionOrder.Status::Released:
          EXIT(PAGE::"Released Production Order");
        ProductionOrder.Status::Finished:
          EXIT(PAGE::"Finished Production Order");
      END;
    END;

    [Internal]
    PROCEDURE GetRTCUrl@6(VAR RecRef@1000 : RecordRef;PageID@1001 : Integer) : Text;
    BEGIN
      IF NOT RecRef.HASFILTER THEN
        RecRef.SETRECFILTER;

      IF NOT VerifyPageID(RecRef.NUMBER,PageID) THEN
        PageID := GetPageID(RecRef);

      EXIT(GETURL(CLIENTTYPE::Windows,COMPANYNAME,OBJECTTYPE::Page,PageID,RecRef,FALSE));
    END;

    [External]
    PROCEDURE GetWebUrl@5(VAR RecRef@1000 : RecordRef;PageID@1001 : Integer) : Text;
    BEGIN
      IF NOT RecRef.HASFILTER THEN
        RecRef.SETRECFILTER;

      IF NOT VerifyPageID(RecRef.NUMBER,PageID) THEN
        PageID := GetPageID(RecRef);

      EXIT(GETURL(CLIENTTYPE::Web,COMPANYNAME,OBJECTTYPE::Page,PageID,RecRef,FALSE));
    END;

    LOCAL PROCEDURE VerifyPageID@11(TableID@1000 : Integer;PageID@1001 : Integer) : Boolean;
    VAR
      PageMetadata@1002 : Record 2000000138;
    BEGIN
      EXIT(PageMetadata.GET(PageID) AND (PageMetadata.SourceTable = TableID));
    END;

    [Internal]
    PROCEDURE GetPageCaption@16(PageID@1000 : Integer) : Text;
    VAR
      PageMetadata@1002 : Record 2000000138;
    BEGIN
      IF NOT PageMetadata.GET(PageID) THEN
        EXIT('');

      EXIT(PageMetadata.Caption);
    END;

    BEGIN
    END.
  }
}

