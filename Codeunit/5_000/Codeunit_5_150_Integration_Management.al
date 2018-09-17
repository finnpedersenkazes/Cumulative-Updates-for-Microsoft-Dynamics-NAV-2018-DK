OBJECT Codeunit 5150 Integration Management
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Permissions=TableData 112=rm,
                TableData 113=rm,
                TableData 5079=r;
    SingleInstance=Yes;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      IntegrationIsActivated@1003 : Boolean;
      PageServiceNameTok@1004 : TextConst 'DAN=Integration %1;ENU=Integration %1';
      IntegrationServicesEnabledMsg@1006 : TextConst '@@@=%1 - product name;DAN=Integrationsservicer er aktiveret.\Servicen %1 skal genstartes.;ENU=Integration services have been enabled.\The %1 service should be restarted.';
      IntegrationServicesDisabledMsg@1005 : TextConst '@@@=%1 - product name;DAN=Integrationsservicer er deaktiveret.\Servicen %1 skal genstartes.;ENU=Integration services have been disabled.\The %1 service should be restarted.';
      HideMessages@1000 : Boolean;

    [External]
    PROCEDURE GetDatabaseTableTriggerSetup@1(TableID@1000 : Integer;VAR Insert@1001 : Boolean;VAR Modify@1002 : Boolean;VAR Delete@1003 : Boolean;VAR Rename@1004 : Boolean);
    BEGIN
      IF COMPANYNAME = '' THEN
        EXIT;

      IF NOT GetIntegrationActivated THEN
        EXIT;

      IF IsIntegrationRecord(TableID) OR IsIntegrationRecordChild(TableID) THEN BEGIN
        Insert := TRUE;
        Modify := TRUE;
        Delete := TRUE;
        Rename := TRUE;
      END;
    END;

    [External]
    PROCEDURE OnDatabaseInsert@2(RecRef@1000 : RecordRef);
    VAR
      TimeStamp@1001 : DateTime;
    BEGIN
      IF NOT GetIntegrationActivated THEN
        EXIT;

      TimeStamp := CURRENTDATETIME;
      UpdateParentIntegrationRecord(RecRef,TimeStamp);
      InsertUpdateIntegrationRecord(RecRef,TimeStamp);
    END;

    [External]
    PROCEDURE OnDatabaseModify@3(RecRef@1000 : RecordRef);
    VAR
      TimeStamp@1001 : DateTime;
    BEGIN
      IF NOT GetIntegrationActivated THEN
        EXIT;

      TimeStamp := CURRENTDATETIME;
      UpdateParentIntegrationRecord(RecRef,TimeStamp);
      InsertUpdateIntegrationRecord(RecRef,TimeStamp);
    END;

    [External]
    PROCEDURE OnDatabaseDelete@4(RecRef@1000 : RecordRef);
    VAR
      SalesHeader@1002 : Record 36;
      IntegrationRecord@1001 : Record 5151;
      IntegrationRecordArchive@1005 : Record 5152;
      SkipDeletion@1004 : Boolean;
      TimeStamp@1003 : DateTime;
    BEGIN
      IF NOT GetIntegrationActivated THEN
        EXIT;

      TimeStamp := CURRENTDATETIME;
      UpdateParentIntegrationRecord(RecRef,TimeStamp);
      IF IsIntegrationRecord(RecRef.NUMBER) THEN BEGIN
        IntegrationRecord.SETRANGE("Record ID",RecRef.RECORDID);
        IF IntegrationRecord.FINDFIRST THEN BEGIN
          // Handle exceptions where "Deleted On" should not be set.
          IF RecRef.NUMBER = DATABASE::"Sales Header" THEN BEGIN
            RecRef.SETTABLE(SalesHeader);
            SkipDeletion := SalesHeader.Invoice;
          END;

          // Archive
          IntegrationRecordArchive.TRANSFERFIELDS(IntegrationRecord);
          IF IntegrationRecordArchive.INSERT THEN;

          IF NOT SkipDeletion THEN
            IntegrationRecord."Deleted On" := TimeStamp;

          CLEAR(IntegrationRecord."Record ID");
          IntegrationRecord."Modified On" := TimeStamp;
          IntegrationRecord.MODIFY;
        END;
      END;
    END;

    [External]
    PROCEDURE OnDatabaseRename@5(RecRef@1000 : RecordRef;XRecRef@1001 : RecordRef);
    VAR
      IntegrationRecord@1003 : Record 5151;
      TimeStamp@1002 : DateTime;
    BEGIN
      IF NOT GetIntegrationActivated THEN
        EXIT;

      TimeStamp := CURRENTDATETIME;
      UpdateParentIntegrationRecord(RecRef,TimeStamp);
      IF IsIntegrationRecord(RecRef.NUMBER) THEN BEGIN
        IntegrationRecord.SETRANGE("Record ID",XRecRef.RECORDID);
        IF IntegrationRecord.FINDFIRST THEN BEGIN
          IntegrationRecord."Record ID" := RecRef.RECORDID;
          IntegrationRecord.MODIFY;
        END;
      END;
      InsertUpdateIntegrationRecord(RecRef,TimeStamp);
    END;

    LOCAL PROCEDURE UpdateParentIntegrationRecord@17(RecRef@1000 : RecordRef;TimeStamp@1008 : DateTime);
    VAR
      Currency@1012 : Record 4;
      SalesHeader@1001 : Record 36;
      SalesLine@1007 : Record 37;
      SalesInvoiceHeader@1002 : Record 112;
      SalesInvoiceLine@1009 : Record 113;
      SalesCrMemoHeader@1020 : Record 114;
      SalesCrMemoLine@1019 : Record 115;
      Customer@1003 : Record 18;
      ShipToAddress@1010 : Record 222;
      CurrencyExchangeRate@1011 : Record 330;
      SalesPrice@1004 : Record 7002;
      CustomerPriceGroup@1005 : Record 6;
      ContactProfileAnswer@1016 : Record 5089;
      ContactAltAddress@1014 : Record 5051;
      RlshpMgtCommentLine@1013 : Record 5061;
      Contact@1015 : Record 5050;
      Vendor@1018 : Record 23;
      VendorBankAccount@1017 : Record 288;
      PurchaseHeader@1022 : Record 38;
      PurchaseLine@1021 : Record 39;
      ParentRecRef@1006 : RecordRef;
    BEGIN
      // Handle cases where entities change should update the parent record
      // Function must not fail even if the parent record cannot be found
      CASE RecRef.NUMBER OF
        DATABASE::"Sales Line":
          BEGIN
            RecRef.SETTABLE(SalesLine);
            IF SalesHeader.GET(SalesLine."Document Type",SalesLine."Document No.") THEN BEGIN
              ParentRecRef.GETTABLE(SalesHeader);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Sales Invoice Line":
          BEGIN
            RecRef.SETTABLE(SalesInvoiceLine);
            IF SalesInvoiceHeader.GET(SalesInvoiceLine."Document No.") THEN BEGIN
              ParentRecRef.GETTABLE(SalesInvoiceHeader);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Sales Cr.Memo Line":
          BEGIN
            RecRef.SETTABLE(SalesCrMemoLine);
            IF SalesCrMemoHeader.GET(SalesCrMemoLine."Document No.") THEN BEGIN
              ParentRecRef.GETTABLE(SalesCrMemoHeader);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Sales Price":
          BEGIN
            RecRef.SETTABLE(SalesPrice);
            IF SalesPrice."Sales Type" <> SalesPrice."Sales Type"::"Customer Price Group" THEN
              EXIT;

            IF CustomerPriceGroup.GET(SalesPrice."Sales Code") THEN BEGIN
              ParentRecRef.GETTABLE(CustomerPriceGroup);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Ship-to Address":
          BEGIN
            RecRef.SETTABLE(ShipToAddress);
            IF Customer.GET(ShipToAddress."Customer No.") THEN BEGIN
              ParentRecRef.GETTABLE(Customer);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Currency Exchange Rate":
          BEGIN
            RecRef.SETTABLE(CurrencyExchangeRate);
            IF Currency.GET(CurrencyExchangeRate."Currency Code") THEN BEGIN
              ParentRecRef.GETTABLE(Currency);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Contact Alt. Address":
          BEGIN
            RecRef.SETTABLE(ContactAltAddress);
            IF Contact.GET(ContactAltAddress."Contact No.") THEN BEGIN
              ParentRecRef.GETTABLE(Contact);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Contact Profile Answer":
          BEGIN
            RecRef.SETTABLE(ContactProfileAnswer);
            IF Contact.GET(ContactProfileAnswer."Contact No.") THEN BEGIN
              ParentRecRef.GETTABLE(Contact);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Rlshp. Mgt. Comment Line":
          BEGIN
            RecRef.SETTABLE(RlshpMgtCommentLine);
            IF RlshpMgtCommentLine."Table Name" = RlshpMgtCommentLine."Table Name"::Contact THEN
              IF Contact.GET(RlshpMgtCommentLine."No.") THEN BEGIN
                ParentRecRef.GETTABLE(Contact);
                InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
              END;
          END;
        DATABASE::"Vendor Bank Account":
          BEGIN
            RecRef.SETTABLE(VendorBankAccount);
            IF Vendor.GET(VendorBankAccount."Vendor No.") THEN BEGIN
              ParentRecRef.GETTABLE(Vendor);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
        DATABASE::"Purchase Line":
          BEGIN
            RecRef.SETTABLE(PurchaseLine);
            IF PurchaseHeader.GET(PurchaseLine."Document Type",PurchaseLine."Document No.") THEN BEGIN
              ParentRecRef.GETTABLE(PurchaseHeader);
              InsertUpdateIntegrationRecord(ParentRecRef,TimeStamp);
            END;
          END;
      END;
    END;

    [External]
    PROCEDURE SetupIntegrationTables@8();
    VAR
      TempNameValueBuffer@1000 : TEMPORARY Record 823;
      TableId@1001 : Integer;
    BEGIN
      CreateIntegrationPageList(TempNameValueBuffer);
      TempNameValueBuffer.FINDFIRST;
      REPEAT
        EVALUATE(TableId,TempNameValueBuffer.Value);
        InitializeIntegrationRecords(TableId);
      UNTIL TempNameValueBuffer.NEXT = 0;
    END;

    [External]
    PROCEDURE CreateIntegrationPageList@23(VAR TempNameValueBuffer@1000 : TEMPORARY Record 823);
    VAR
      NextId@1001 : Integer;
    BEGIN
      WITH TempNameValueBuffer DO BEGIN
        DELETEALL;
        NextId := 1;

        AddToIntegrationPageList(PAGE::"Resource List",DATABASE::Resource,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Payment Terms",DATABASE::"Payment Terms",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Shipment Methods",DATABASE::"Shipment Method",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Shipping Agents",DATABASE::"Shipping Agent",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::Currencies,DATABASE::Currency,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Salespersons/Purchasers",DATABASE::"Salesperson/Purchaser",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Customer Card",DATABASE::Customer,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Vendor Card",DATABASE::Vendor,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Company Information",DATABASE::"Company Information",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Item Card",DATABASE::Item,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"G/L Account Card",DATABASE::"G/L Account",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Sales Order",DATABASE::"Sales Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Sales Invoice",DATABASE::"Sales Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Sales Credit Memo",DATABASE::"Sales Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"General Journal Batches",DATABASE::"Gen. Journal Batch",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"General Journal",DATABASE::"Gen. Journal Line",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(
          PAGE::"VAT Business Posting Groups",DATABASE::"VAT Business Posting Group",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"VAT Product Posting Groups",DATABASE::"VAT Product Posting Group",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"VAT Clauses",DATABASE::"VAT Clause",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Tax Groups",DATABASE::"Tax Group",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Tax Area List",DATABASE::"Tax Area",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Posted Sales Invoice",DATABASE::"Sales Invoice Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Posted Sales Credit Memos",DATABASE::"Sales Cr.Memo Header",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Units of Measure",DATABASE::"Unit of Measure",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Ship-to Address",DATABASE::"Ship-to Address",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Contact Card",DATABASE::Contact,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Countries/Regions",DATABASE::"Country/Region",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Shipment Methods",DATABASE::"Shipment Method",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Opportunity List",DATABASE::Opportunity,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Units of Measure Entity",DATABASE::"Unit of Measure",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::Dimensions,DATABASE::Dimension,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Item Categories Entity",DATABASE::"Item Category",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Currencies Entity",DATABASE::Currency,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Country/Regions Entity",DATABASE::"Country/Region",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Payment Methods Entity",DATABASE::"Payment Method",TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Employee Entity",DATABASE::Employee,TempNameValueBuffer,NextId);
        AddToIntegrationPageList(PAGE::"Unlinked Attachments",DATABASE::"Unlinked Attachment",TempNameValueBuffer,NextId);
      END;
    END;

    [External]
    PROCEDURE IsIntegrationServicesEnabled@24() : Boolean;
    VAR
      WebService@1000 : Record 2000000076;
    BEGIN
      EXIT(WebService.GET(WebService."Object Type"::Codeunit,'Integration Service'));
    END;

    [External]
    PROCEDURE IsIntegrationActivated@21() : Boolean;
    BEGIN
      EXIT(IntegrationIsActivated);
    END;

    [Internal]
    PROCEDURE EnableIntegrationServices@25();
    BEGIN
      IF IsIntegrationServicesEnabled THEN
        EXIT;

      SetupIntegrationService;
      SetupIntegrationServices;
      IF NOT HideMessages THEN
        MESSAGE(IntegrationServicesEnabledMsg,PRODUCTNAME.FULL);
    END;

    [External]
    PROCEDURE DisableIntegrationServices@26();
    BEGIN
      IF NOT IsIntegrationServicesEnabled THEN
        EXIT;

      DeleteIntegrationService;
      DeleteIntegrationServices;

      MESSAGE(IntegrationServicesDisabledMsg,PRODUCTNAME.FULL);
    END;

    [External]
    PROCEDURE SetConnectorIsEnabledForSession@27(IsEnabled@1000 : Boolean);
    BEGIN
      IntegrationIsActivated := IsEnabled;
    END;

    [External]
    PROCEDURE IsIntegrationRecord@6(TableID@1000 : Integer) : Boolean;
    VAR
      isIntegrationRecord@1001 : Boolean;
    BEGIN
      OnIsIntegrationRecord(TableID,isIntegrationRecord);
      IF isIntegrationRecord THEN
        EXIT(TRUE);
      EXIT(TableID IN
        [DATABASE::Resource,
         DATABASE::"Shipping Agent",
         DATABASE::"Salesperson/Purchaser",
         DATABASE::Customer,
         DATABASE::Vendor,
         DATABASE::Dimension,
         DATABASE::"Dimension Value",
         DATABASE::"Company Information",
         DATABASE::Item,
         DATABASE::"G/L Account",
         DATABASE::"Sales Header",
         DATABASE::"Sales Invoice Header",
         DATABASE::"Gen. Journal Batch",
         DATABASE::"Sales Cr.Memo Header",
         DATABASE::"Gen. Journal Line",
         DATABASE::"VAT Business Posting Group",
         DATABASE::"VAT Product Posting Group",
         DATABASE::"VAT Clause",
         DATABASE::"Tax Group",
         DATABASE::"Tax Area",
         DATABASE::"Unit of Measure",
         DATABASE::"Ship-to Address",
         DATABASE::Contact,
         DATABASE::"Country/Region",
         DATABASE::"Customer Price Group",
         DATABASE::"Sales Price",
         DATABASE::"Payment Terms",
         DATABASE::"Shipment Method",
         DATABASE::Opportunity,
         DATABASE::"Item Category",
         DATABASE::"Country/Region",
         DATABASE::"Payment Method",
         DATABASE::Currency,
         DATABASE::Employee,
         DATABASE::"Incoming Document Attachment",
         DATABASE::"Unlinked Attachment",
         DATABASE::"Purchase Header",
         DATABASE::"Purch. Inv. Header",
         DATABASE::"G/L Entry"]);
    END;

    [Integration]
    [External]
    PROCEDURE OnIsIntegrationRecord@29(TableID@1000 : Integer;VAR isIntegrationRecord@1001 : Boolean);
    BEGIN
    END;

    [External]
    PROCEDURE IsIntegrationRecordChild@18(TableID@1000 : Integer) : Boolean;
    VAR
      isIntegrationRecordChild@1001 : Boolean;
    BEGIN
      OnIsIntegrationRecordChild(TableID,isIntegrationRecordChild);
      IF isIntegrationRecordChild THEN
        EXIT(TRUE);

      EXIT(TableID IN
        [DATABASE::"Sales Line",
         DATABASE::"Currency Exchange Rate",
         DATABASE::"Sales Invoice Line",
         DATABASE::"Sales Cr.Memo Line",
         DATABASE::"Contact Alt. Address",
         DATABASE::"Contact Profile Answer",
         DATABASE::"Dimension Value",
         DATABASE::"Rlshp. Mgt. Comment Line",
         DATABASE::"Vendor Bank Account"]);
    END;

    [Integration]
    [External]
    PROCEDURE OnIsIntegrationRecordChild@30(TableID@1000 : Integer;VAR isIntegrationRecordChild@1001 : Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE GetIntegrationActivated@20() : Boolean;
    VAR
      GraphSyncRunner@1000 : Codeunit 5452;
      IsSyncEnabled@1001 : Boolean;
    BEGIN
      IF IsIntegrationDisabled THEN
        EXIT(FALSE);
      IF NOT IntegrationIsActivated THEN BEGIN
        OnGetIntegrationActivated(IsSyncEnabled);
        IF IsSyncEnabled THEN
          IntegrationIsActivated := TRUE
        ELSE
          IntegrationIsActivated := IsCRMConnectionEnabled OR GraphSyncRunner.IsGraphSyncEnabled;
      END;

      EXIT(IntegrationIsActivated);
    END;

    [Integration]
    [External]
    PROCEDURE OnGetIntegrationActivated@11(VAR IsSyncEnabled@1000 : Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE IsIntegrationDisabled@37() : Boolean;
    VAR
      IsSyncDisabled@1000 : Boolean;
    BEGIN
      OnGetIntegrationDisabled(IsSyncDisabled);
      IF IsSyncDisabled THEN BEGIN
        IntegrationIsActivated := FALSE;
        EXIT(TRUE);
      END;
    END;

    [Integration]
    [External]
    PROCEDURE OnGetIntegrationDisabled@35(VAR IsSyncDisabled@1000 : Boolean);
    BEGIN
    END;

    LOCAL PROCEDURE IsCRMConnectionEnabled@15() : Boolean;
    VAR
      CRMConnectionSetup@1000 : Record 5330;
    BEGIN
      IF NOT CRMConnectionSetup.GET THEN
        EXIT(FALSE);

      EXIT(CRMConnectionSetup."Is Enabled");
    END;

    LOCAL PROCEDURE SetupIntegrationService@12();
    VAR
      WebService@1000 : Record 2000000076;
      WebServiceManagement@1001 : Codeunit 9750;
    BEGIN
      WebServiceManagement.CreateWebService(
        WebService."Object Type"::Codeunit,CODEUNIT::"Integration Service",'Integration Service',TRUE);
    END;

    LOCAL PROCEDURE DeleteIntegrationService@14();
    VAR
      WebService@1000 : Record 2000000076;
    BEGIN
      IF WebService.GET(WebService."Object Type"::Codeunit,'Integration Service') THEN
        WebService.DELETE;
    END;

    LOCAL PROCEDURE SetupIntegrationServices@28();
    VAR
      TempNameValueBuffer@1000 : TEMPORARY Record 823;
      WebService@1003 : Record 2000000076;
      Objects@1002 : Record 2000000038;
      WebServiceManagement@1004 : Codeunit 9750;
      PageId@1001 : Integer;
    BEGIN
      CreateIntegrationPageList(TempNameValueBuffer);
      TempNameValueBuffer.FINDFIRST;

      REPEAT
        EVALUATE(PageId,TempNameValueBuffer.Name);

        Objects.SETRANGE("Object Type",Objects."Object Type"::Page);
        Objects.SETRANGE("Object ID",PageId);
        IF Objects.FINDFIRST THEN
          WebServiceManagement.CreateWebService(WebService."Object Type"::Page,Objects."Object ID",
            STRSUBSTNO(PageServiceNameTok,Objects."Object Name"),TRUE);
      UNTIL TempNameValueBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE DeleteIntegrationServices@38();
    VAR
      TempNameValueBuffer@1003 : TEMPORARY Record 823;
      WebService@1002 : Record 2000000076;
      Objects@1001 : Record 2000000038;
      PageId@1000 : Integer;
    BEGIN
      CreateIntegrationPageList(TempNameValueBuffer);
      TempNameValueBuffer.FINDFIRST;

      WebService.SETRANGE("Object Type",WebService."Object Type"::Page);
      REPEAT
        EVALUATE(PageId,TempNameValueBuffer.Name);
        WebService.SETRANGE("Object ID",PageId);

        Objects.SETRANGE("Object Type",WebService."Object Type"::Page);
        Objects.SETRANGE("Object ID",PageId);
        IF Objects.FINDFIRST THEN BEGIN
          WebService.SETRANGE("Service Name",STRSUBSTNO(PageServiceNameTok,Objects."Object Name"));
          IF WebService.FINDFIRST THEN
            WebService.DELETE;
        END;
      UNTIL TempNameValueBuffer.NEXT = 0;
    END;

    LOCAL PROCEDURE InitializeIntegrationRecords@9(TableID@1000 : Integer);
    VAR
      RecRef@1002 : RecordRef;
    BEGIN
      WITH RecRef DO BEGIN
        OPEN(TableID,FALSE);
        IF FINDSET(FALSE) THEN
          REPEAT
            InsertUpdateIntegrationRecord(RecRef,CURRENTDATETIME);
          UNTIL NEXT = 0;
        CLOSE;
      END;
    END;

    [External]
    PROCEDURE InsertUpdateIntegrationRecord@16(RecRef@1000 : RecordRef;IntegrationLastModified@1001 : DateTime) IntegrationID : GUID;
    VAR
      IntegrationRecord@1002 : Record 5151;
      Handled@1003 : Boolean;
    BEGIN
      IF IsIntegrationRecord(RecRef.NUMBER) THEN
        WITH IntegrationRecord DO BEGIN
          SETRANGE("Record ID",RecRef.RECORDID);
          IF FINDFIRST THEN BEGIN
            "Modified On" := IntegrationLastModified;
            OnUpdateReferencedIdField(RecRef,"Integration ID",Handled);
            MODIFY;
          END ELSE BEGIN
            RESET;
            INIT;
            OnGetPredefinedIdValue("Integration ID",RecRef,Handled);
            IF NOT Handled THEN
              "Integration ID" := CREATEGUID;
            "Record ID" := RecRef.RECORDID;
            "Table ID" := RecRef.NUMBER;
            "Modified On" := IntegrationLastModified;
            INSERT;
            IF NOT Handled THEN
              OnUpdateReferencedIdField(RecRef,"Integration ID",Handled);
          END;
          IntegrationID := "Integration ID";
          ReactivateJobForTable(RecRef.NUMBER);
        END;
    END;

    LOCAL PROCEDURE ReactivateJobForTable@7(TableNo@1000 : Integer);
    VAR
      JobQueueEntry@1001 : Record 472;
    BEGIN
      JobQueueEntry.FilterInactiveOnHoldEntries;
      IF JobQueueEntry.ISEMPTY THEN
        EXIT;
      JobQueueEntry.FINDSET;
      REPEAT
        IF IsJobActsOnTable(JobQueueEntry,TableNo) THEN
          JobQueueEntry.Restart;
      UNTIL JobQueueEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE IsJobActsOnTable@32(JobQueueEntry@1001 : Record 472;TableNo@1000 : Integer) : Boolean;
    VAR
      IntegrationTableMapping@1004 : Record 5335;
      RecRef@1002 : RecordRef;
    BEGIN
      IF RecRef.GET(JobQueueEntry."Record ID to Process") AND
         (RecRef.NUMBER = DATABASE::"Integration Table Mapping")
      THEN BEGIN
        RecRef.SETTABLE(IntegrationTableMapping);
        EXIT(IntegrationTableMapping."Table ID" = TableNo);
      END;
    END;

    LOCAL PROCEDURE AddToIntegrationPageList@22(PageId@1002 : Integer;TableId@1003 : Integer;VAR TempNameValueBuffer@1000 : TEMPORARY Record 823;VAR NextId@1001 : Integer);
    BEGIN
      WITH TempNameValueBuffer DO BEGIN
        INIT;
        ID := NextId;
        NextId := NextId + 1;
        Name := FORMAT(PageId);
        Value := FORMAT(TableId);
        INSERT;
      END;
    END;

    [External]
    PROCEDURE SetHideMessages@10(HideMessagesNew@1000 : Boolean);
    BEGIN
      HideMessages := HideMessagesNew;
    END;

    [External]
    PROCEDURE GetIdWithoutBrackets@31(Id@1000 : GUID) : Text;
    BEGIN
      EXIT(COPYSTR(FORMAT(Id),2,STRLEN(FORMAT(Id)) - 2));
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnUpdateReferencedIdField@13(VAR RecRef@1000 : RecordRef;NewId@1001 : GUID;VAR Handled@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnGetPredefinedIdValue@19(VAR Id@1000 : GUID;VAR RecRef@1002 : RecordRef;VAR Handled@1001 : Boolean);
    BEGIN
    END;

    BEGIN
    END.
  }
}

