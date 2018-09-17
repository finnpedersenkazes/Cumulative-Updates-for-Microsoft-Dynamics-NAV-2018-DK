OBJECT Codeunit 5341 CRM Int. Table. Subscriber
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    SingleInstance=Yes;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      CannotFindSyncedProductErr@1011 : TextConst '@@@="%1=product identifier";DAN=Der blev ikke fundet et synkroniseret produkt for %1.;ENU=Cannot find a synchronized product for %1.';
      CannotSynchOnlyLinesErr@1012 : TextConst 'DAN=Fakturalinjerne kan ikke synkroniseres separat.;ENU=Cannot synchronize invoice lines separately.';
      CannotSynchProductErr@1010 : TextConst '@@@="%1=product identification";DAN=Produktet %1 kan ikke synkroniseres.;ENU=Cannot synchronize the product %1.';
      RecordNotFoundErr@1001 : TextConst '@@@="%1 = The lookup value when searching for the source record, %2 = Source table caption";DAN=%1 blev ikke fundet i tabellen %2.;ENU=Cannot find %1 in table %2.';
      ContactsMustBeRelatedToCompanyErr@1004 : TextConst '@@@="%1 = Contact No.";DAN=Kontakten %1 skal have en kontaktvirksomhed, der har et forretningsforhold en debitor.;ENU=The contact %1 must have a contact company that has a business relation to a customer.';
      ContactMissingCompanyErr@1008 : TextConst 'DAN=Kontakten kan ikke oprettes, da firmaet ikke findes.;ENU=The contact cannot be created because the company does not exist.';
      CRMSynchHelper@1009 : Codeunit 5342;
      CRMUnitGroupExistsAndIsInactiveErr@1005 : TextConst '@@@="%1=table caption: Unit Group,%2=The name of the indicated Unit Group";DAN=%1 %2 findes allerede i %3, men kan ikke synkroniseres, da den er inaktiv.;ENU=The %1 %2 already exists in %3, but it cannot be synchronized, because it is inactive.';
      CRMUnitGroupContainsMoreThanOneUoMErr@1006 : TextConst '@@@="%1=table caption: Unit Group,%2=The name of the indicated Unit Group,%3=table caption: Unit., %4 = CRM product name";DAN=%4 %1 %2 indeholder mere end �n %3. Denne ops�tning kan ikke anvendes til synkronisering.;ENU=The %4 %1 %2 contains more than one %3. This setup cannot be used for synchronization.';
      CustomerHasChangedErr@1000 : TextConst '@@@="%1=CRM sales order number, %2 = CRM product name";DAN=Fakturaen kunne ikke oprettes i %2. Debitoren fra den oprindelige %2-salgsordre %1 blev �ndret eller er ikke l�ngere sammenk�det.;ENU=Cannot create the invoice in %2. The customer from the original %2 sales order %1 was changed or is no longer coupled.';
      NoCoupledSalesInvoiceHeaderErr@1007 : TextConst '@@@="%1 = CRM product name";DAN=Kan ikke finde det sammenk�dede %1-fakturahoved.;ENU=Cannot find the coupled %1 invoice header.';
      RecordMustBeCoupledErr@1016 : TextConst '@@@="%1 =field caption, %2 = field value, %3 - product name ";DAN=%1 %2 skal v�re sammenk�det med en record i %3.;ENU=%1 %2 must be coupled to a record in %3.';
      MappingMustBeSetForGUIDFieldErr@1017 : TextConst '@@@=%1 and %2 are table IDs, %3 and %4 are field captions.;DAN=Tabellen %1 skal knyttes til tabellen %2 for at overf�re en v�rdi mellem felterne %3 og %4.;ENU=Table %1 must be mapped to table %2 to transfer value between fields %3  and %4.';
      CRMProductName@1002 : Codeunit 5344;

    [External]
    PROCEDURE ClearCache@5();
    BEGIN
      CRMSynchHelper.ClearCache;
    END;

    [EventSubscriber(Codeunit,449,OnAfterRun)]
    LOCAL PROCEDURE OnAfterJobQueueEntryRun@63(VAR JobQueueEntry@1000 : Record 472);
    VAR
      IntegrationSynchJob@1003 : Record 5338;
      IntegrationTableMapping@1001 : Record 5335;
      CRMCustomerContactLink@1002 : Codeunit 5351;
    BEGIN
      IF IsJobQueueEntryCRMIntegrationJob(JobQueueEntry,IntegrationTableMapping) THEN BEGIN
        JobQueueEntry."On Hold Due to Inactivity" :=
          IntegrationSynchJob.HaveJobsBeenIdle(JobQueueEntry.GetLastLogEntryNo);

        IF IntegrationTableMapping."Table ID" IN [DATABASE::Customer,DATABASE::Contact] THEN
          CRMCustomerContactLink.EnqueueJobQueueEntry(CODEUNIT::"CRM Customer-Contact Link",IntegrationTableMapping);
      END;
    END;

    [EventSubscriber(Table,472,OnFindingIfJobNeedsToBeRun)]
    LOCAL PROCEDURE OnFindingIfJobNeedsToBeRun@40(VAR Sender@1000 : Record 472;VAR Result@1001 : Boolean);
    VAR
      CRMConnectionSetup@1005 : Record 5330;
      IntegrationTableMapping@1002 : Record 5335;
      CRMIntegrationManagement@1004 : Codeunit 5330;
      RecRef@1003 : RecordRef;
      ConnectionID@1006 : GUID;
    BEGIN
      IF IsJobQueueEntryCRMIntegrationJob(Sender,IntegrationTableMapping) AND
         CRMIntegrationManagement.IsCRMTable(IntegrationTableMapping."Integration Table ID")
      THEN BEGIN
        CRMConnectionSetup.GET;
        IF CRMConnectionSetup."Is Enabled" THEN BEGIN
          ConnectionID := FORMAT(CREATEGUID);
          CRMConnectionSetup.RegisterConnectionWithName(ConnectionID);
          RecRef.OPEN(IntegrationTableMapping."Integration Table ID");
          IntegrationTableMapping.SetIntRecordRefFilter(RecRef);
          Result := NOT RecRef.ISEMPTY;
          RecRef.CLOSE;
          CRMConnectionSetup.UnregisterConnectionWithName(ConnectionID);
        END;
      END;
    END;

    [EventSubscriber(Page,674,OnShowDetails)]
    LOCAL PROCEDURE OnShowDetailedLog@65(JobQueueLogEntry@1000 : Record 474);
    VAR
      IntegrationSynchJob@1001 : Record 5338;
    BEGIN
      IF (JobQueueLogEntry."Object Type to Run" = JobQueueLogEntry."Object Type to Run"::Codeunit) AND
         (JobQueueLogEntry."Object ID to Run" IN [CODEUNIT::"Integration Synch. Job Runner",CODEUNIT::"CRM Statistics Job"])
      THEN BEGIN
        IntegrationSynchJob.SETRANGE("Job Queue Log Entry No.",JobQueueLogEntry."Entry No.");
        PAGE.RUNMODAL(PAGE::"Integration Synch. Job List",IntegrationSynchJob);
      END;
    END;

    LOCAL PROCEDURE IsJobQueueEntryCRMIntegrationJob@64(JobQueueEntry@1000 : Record 472;VAR IntegrationTableMapping@1001 : Record 5335) : Boolean;
    VAR
      RecRef@1002 : RecordRef;
    BEGIN
      CLEAR(IntegrationTableMapping);
      IF JobQueueEntry."Object Type to Run" <> JobQueueEntry."Object Type to Run"::Codeunit THEN
        EXIT(FALSE);
      CASE JobQueueEntry."Object ID to Run" OF
        CODEUNIT::"CRM Statistics Job":
          EXIT(TRUE);
        CODEUNIT::"Integration Synch. Job Runner":
          BEGIN
            RecRef.GET(JobQueueEntry."Record ID to Process");
            IF RecRef.NUMBER = DATABASE::"Integration Table Mapping" THEN BEGIN
              RecRef.SETTABLE(IntegrationTableMapping);
              EXIT(IntegrationTableMapping."Synch. Codeunit ID" = CODEUNIT::"CRM Integration Table Synch.");
            END;
          END;
      END;
    END;

    [EventSubscriber(Table,472,OnAfterDeleteEvent)]
    LOCAL PROCEDURE OnCleanupAfterJobExecution@61(VAR Rec@1000 : Record 472;RunTrigger@1001 : Boolean);
    VAR
      IntegrationTableMapping@1004 : Record 5335;
      RecordID@1002 : RecordID;
      RecRef@1003 : RecordRef;
    BEGIN
      RecordID := Rec."Record ID to Process";
      IF RecordID.TABLENO = DATABASE::"Integration Table Mapping" THEN BEGIN
        RecRef := RecordID.GETRECORD;
        RecRef.SETTABLE(IntegrationTableMapping);
        IF IntegrationTableMapping.GET(IntegrationTableMapping.Name) THEN
          IF IntegrationTableMapping."Delete After Synchronization" THEN
            IntegrationTableMapping.DELETE(TRUE);
      END;
    END;

    [EventSubscriber(Codeunit,5345,OnBeforeTransferRecordFields)]
    [Internal]
    PROCEDURE OnBeforeTransferRecordFields@54(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'Sales Invoice Header-CRM Invoice':
          CheckItemOrResourceIsNotBlocked(SourceRecordRef);
      END;
    END;

    [EventSubscriber(Codeunit,5336,OnTransferFieldData)]
    [Internal]
    PROCEDURE OnTransferFieldData@22(SourceFieldRef@1000 : FieldRef;DestinationFieldRef@1001 : FieldRef;VAR NewValue@1002 : Variant;VAR IsValueFound@1003 : Boolean;VAR NeedsConversion@1004 : Boolean);
    VAR
      IntegrationTableMapping@1006 : Record 5335;
      OptionValue@1005 : Integer;
    BEGIN
      IF ConvertTableToOption(SourceFieldRef,OptionValue) THEN BEGIN
        NewValue := OptionValue;
        IsValueFound := TRUE;
        NeedsConversion := TRUE;
      END ELSE
        IF AreFieldsRelatedToMappedTables(SourceFieldRef,DestinationFieldRef,IntegrationTableMapping) THEN BEGIN
          IsValueFound := FindNewValueForCoupledRecordPK(IntegrationTableMapping,SourceFieldRef,DestinationFieldRef,NewValue);
          NeedsConversion := FALSE;
        END;
    END;

    [EventSubscriber(Codeunit,5345,OnAfterTransferRecordFields)]
    [Internal]
    PROCEDURE OnAfterTransferRecordFields@35(SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1001 : RecordRef;VAR AdditionalFieldsWereModified@1000 : Boolean;DestinationIsInserted@1003 : Boolean);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'CRM Account-Customer':
          AdditionalFieldsWereModified :=
            UpdateCustomerBlocked(SourceRecordRef,DestinationRecordRef) OR
            UpdateCustomerSalespersonCode(SourceRecordRef,DestinationRecordRef);
        'CRM Contact-Contact':
          AdditionalFieldsWereModified :=
            UpdateContactSalespersonCode(SourceRecordRef,DestinationRecordRef);
        'Customer-CRM Account':
          AdditionalFieldsWereModified :=
            UpdateCRMAccountOwnerID(SourceRecordRef,DestinationRecordRef);
        'Sales Invoice Header-CRM Invoice':
          AdditionalFieldsWereModified :=
            UpdateCRMInvoiceOwnerID(SourceRecordRef,DestinationRecordRef);
        'Sales Price-CRM Productpricelevel':
          AdditionalFieldsWereModified :=
            UpdateCRMProductPricelevelAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef);
        'Contact-CRM Contact':
          AdditionalFieldsWereModified :=
            UpdateCRMContactOwnerID(SourceRecordRef,DestinationRecordRef);
        'Currency-CRM Transactioncurrency':
          AdditionalFieldsWereModified :=
            UpdateCRMTransactionCurrencyAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef);
        'Item-CRM Product',
        'Resource-CRM Product':
          AdditionalFieldsWereModified :=
            UpdateCRMProductAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef,DestinationIsInserted);
        'CRM Product-Item':
          AdditionalFieldsWereModified :=
            UpdateItemAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef);
        'CRM Product-Resource':
          AdditionalFieldsWereModified :=
            UpdateResourceAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef);
        'Unit of Measure-CRM Uomschedule':
          AdditionalFieldsWereModified :=
            UpdateCRMUoMScheduleAfterTransferRecordFields(SourceRecordRef,DestinationRecordRef);
        ELSE
          AdditionalFieldsWereModified := FALSE;
      END;
    END;

    [EventSubscriber(Codeunit,5345,OnBeforeInsertRecord)]
    [Internal]
    PROCEDURE OnBeforeInsertRecord@42(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1000 : RecordRef);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'CRM Contact-Contact':
          UpdateContactParentCompany(SourceRecordRef,DestinationRecordRef);
        'Contact-CRM Contact':
          UpdateCRMContactParentCustomerId(SourceRecordRef,DestinationRecordRef);
        'Currency-CRM Transactioncurrency':
          UpdateCRMTransactionCurrencyBeforeInsertRecord(DestinationRecordRef);
        'Customer Price Group-CRM Pricelevel':
          UpdateCRMPricelevelBeforeInsertRecord(SourceRecordRef,DestinationRecordRef);
        'Item-CRM Product',
        'Resource-CRM Product':
          UpdateCRMProductBeforeInsertRecord(DestinationRecordRef);
        'Sales Invoice Header-CRM Invoice':
          UpdateCRMInvoiceBeforeInsertRecord(SourceRecordRef,DestinationRecordRef);
        'Sales Invoice Line-CRM Invoicedetail':
          UpdateCRMInvoiceDetailsBeforeInsertRecord(SourceRecordRef,DestinationRecordRef);
      END;

      IF DestinationRecordRef.NUMBER = DATABASE::"Salesperson/Purchaser" THEN
        UpdateSalesPersOnBeforeInsertRecord(DestinationRecordRef);
    END;

    [EventSubscriber(Codeunit,5345,OnAfterInsertRecord)]
    [Internal]
    PROCEDURE OnAfterInsertRecord@45(SourceRecordRef@1001 : RecordRef;DestinationRecordRef@1000 : RecordRef);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'Customer Price Group-CRM Pricelevel':
          ResetCRMProductpricelevelFromCRMPricelevel(SourceRecordRef);
        'Item-CRM Product',
        'Resource-CRM Product':
          UpdateCRMProductAfterInsertRecord(DestinationRecordRef);
        'Sales Invoice Header-CRM Invoice':
          UpdateCRMInvoiceAfterInsertRecord(SourceRecordRef,DestinationRecordRef);
        'Sales Invoice Line-CRM Invoicedetail':
          UpdateCRMInvoiceDetailsAfterInsertRecord(SourceRecordRef,DestinationRecordRef);
      END;
    END;

    [EventSubscriber(Codeunit,5345,OnBeforeModifyRecord)]
    [Internal]
    PROCEDURE OnBeforeModifyRecord@49(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'Customer Price Group-CRM Pricelevel':
          UpdateCRMPricelevelBeforeModifyRecord(SourceRecordRef,DestinationRecordRef);
      END;
    END;

    [EventSubscriber(Codeunit,5345,OnAfterModifyRecord)]
    [Internal]
    PROCEDURE OnAfterModifyRecord@51(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'Customer Price Group-CRM Pricelevel':
          ResetCRMProductpricelevelFromCRMPricelevel(SourceRecordRef);
      END;

      IF DestinationRecordRef.NUMBER = DATABASE::Customer THEN
        CRMSynchHelper.UpdateContactOnModifyCustomer(DestinationRecordRef);
    END;

    [EventSubscriber(Codeunit,5345,OnAfterUnchangedRecordHandled)]
    PROCEDURE OnAfterUnchangedRecordHandled@62(IntegrationTableMapping@1000 : Record 5335;SourceRecordRef@1001 : RecordRef;DestinationRecordRef@1002 : RecordRef);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'Customer Price Group-CRM Pricelevel':
          ResetCRMProductpricelevelFromCRMPricelevel(SourceRecordRef);
      END;
    END;

    [EventSubscriber(Codeunit,5340,OnQueryPostFilterIgnoreRecord)]
    [External]
    PROCEDURE OnQueryPostFilterIgnoreRecord@36(SourceRecordRef@1001 : RecordRef;VAR IgnoreRecord@1002 : Boolean);
    BEGIN
      IF IgnoreRecord THEN
        EXIT;

      CASE SourceRecordRef.NUMBER OF
        DATABASE::Contact:
          IgnoreRecord := HandleContactQueryPostFilterIgnoreRecord(SourceRecordRef);
        DATABASE::"Sales Invoice Line":
          ERROR(CannotSynchOnlyLinesErr);
      END;
    END;

    [EventSubscriber(Codeunit,5345,OnFindUncoupledDestinationRecord)]
    [External]
    PROCEDURE OnFindUncoupledDestinationRecord@46(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef;VAR DestinationIsDeleted@1003 : Boolean;VAR DestinationFound@1004 : Boolean);
    BEGIN
      CASE GetSourceDestCode(SourceRecordRef,DestinationRecordRef) OF
        'Unit of Measure-CRM Uomschedule':
          DestinationFound := CRMUoMScheduleFindUncoupledDestinationRecord(SourceRecordRef,DestinationRecordRef);
        'Currency-CRM Transactioncurrency':
          DestinationFound := CRMTransactionCurrencyFindUncoupledDestinationRecord(SourceRecordRef,DestinationRecordRef);
      END;

      IF SourceRecordRef.NUMBER = DATABASE::"Sales Price" THEN
        DestinationFound := CRMPriceListLineFindUncoupledDestinationRecord(SourceRecordRef,DestinationRecordRef);
    END;

    LOCAL PROCEDURE GetSourceDestCode@38(SourceRecordRef@1001 : RecordRef;DestinationRecordRef@1000 : RecordRef) : Text;
    BEGIN
      IF (SourceRecordRef.NUMBER <> 0) AND (DestinationRecordRef.NUMBER <> 0) THEN
        EXIT(STRSUBSTNO('%1-%2',SourceRecordRef.NAME,DestinationRecordRef.NAME));
      EXIT('');
    END;

    LOCAL PROCEDURE UpdateCustomerBlocked@34(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1000 : RecordRef) : Boolean;
    VAR
      Customer@1007 : Record 18;
      CRMAccount@1006 : Record 5341;
      DestinationFieldRef@1004 : FieldRef;
      SourceFieldRef@1005 : FieldRef;
      OptionValue@1003 : Integer;
    BEGIN
      // Blocked - we're only handling from Active > Inactive meaning Blocked::"" > Blocked::"All"
      SourceFieldRef := SourceRecordRef.FIELD(CRMAccount.FIELDNO(StatusCode));
      OptionValue := SourceFieldRef.VALUE;
      IF OptionValue = CRMAccount.StatusCode::Inactive THEN BEGIN
        DestinationFieldRef := DestinationRecordRef.FIELD(Customer.FIELDNO(Blocked));
        OptionValue := DestinationFieldRef.VALUE;
        IF OptionValue = Customer.Blocked::" " THEN BEGIN
          DestinationFieldRef.VALUE := Customer.Blocked::All;
          EXIT(TRUE);
        END;
      END;
    END;

    LOCAL PROCEDURE UpdateCustomerSalespersonCode@20(SourceRecordRef@1003 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef) : Boolean;
    VAR
      Customer@1007 : Record 18;
      CRMAccount@1006 : Record 5341;
    BEGIN
      EXIT(
        CRMSynchHelper.UpdateSalesPersonCodeIfChanged(
          SourceRecordRef,DestinationRecordRef,
          CRMAccount.FIELDNO(OwnerId),CRMAccount.FIELDNO(OwnerIdType),CRMAccount.OwnerIdType::systemuser,
          Customer.FIELDNO("Salesperson Code")))
    END;

    LOCAL PROCEDURE UpdateContactSalespersonCode@10(SourceRecordRef@1003 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef) : Boolean;
    VAR
      CRMContact@1006 : Record 5342;
      Contact@1004 : Record 5050;
    BEGIN
      EXIT(
        CRMSynchHelper.UpdateSalesPersonCodeIfChanged(
          SourceRecordRef,DestinationRecordRef,
          CRMContact.FIELDNO(OwnerId),CRMContact.FIELDNO(OwnerIdType),CRMContact.OwnerIdType::systemuser,
          Contact.FIELDNO("Salesperson Code")))
    END;

    LOCAL PROCEDURE UpdateContactParentCompany@12(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1003 : RecordRef);
    VAR
      CRMContact@1008 : Record 5342;
      SourceFieldRef@1000 : FieldRef;
      ParentCustomerId@1002 : GUID;
    BEGIN
      // When inserting we also want to set the company contact id
      // We only allow creation of new contacts if the company has already been created
      SourceFieldRef := SourceRecordRef.FIELD(CRMContact.FIELDNO(ParentCustomerId));
      ParentCustomerId := SourceFieldRef.VALUE;
      IF NOT CRMSynchHelper.SetContactParentCompany(ParentCustomerId,DestinationRecordRef) THEN
        ERROR(ContactMissingCompanyErr);
    END;

    LOCAL PROCEDURE HandleContactQueryPostFilterIgnoreRecord@2(SourceRecordRef@1001 : RecordRef) IgnoreRecord : Boolean;
    VAR
      ContactBusinessRelation@1003 : Record 5054;
    BEGIN
      IF NOT FindContactRelatedCustomer(SourceRecordRef,ContactBusinessRelation) THEN
        IgnoreRecord := TRUE;
    END;

    LOCAL PROCEDURE UpdateSalesPersOnBeforeInsertRecord@15(VAR DestinationRecordRef@1001 : RecordRef);
    VAR
      SalespersonPurchaser@1004 : Record 13;
      DestinationFieldRef@1007 : FieldRef;
      NewCodePattern@1006 : Text;
      NewCodeId@1005 : Integer;
    BEGIN
      // We need to create a new code for this SP.
      // To do so we just do a SP A
      NewCodePattern := 'SP NO. %1';
      NewCodeId := 1;
      WHILE SalespersonPurchaser.GET(STRSUBSTNO(NewCodePattern,NewCodeId)) DO
        NewCodeId := NewCodeId + 1;

      DestinationFieldRef := DestinationRecordRef.FIELD(SalespersonPurchaser.FIELDNO(Code));
      DestinationFieldRef.VALUE := STRSUBSTNO(NewCodePattern,NewCodeId);
    END;

    LOCAL PROCEDURE UpdateCRMAccountOwnerID@17(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef) : Boolean;
    VAR
      CRMAccount@1006 : Record 5341;
      Customer@1009 : Record 18;
    BEGIN
      EXIT(
        CRMSynchHelper.UpdateOwnerIfChanged(
          SourceRecordRef,DestinationRecordRef,Customer.FIELDNO("Salesperson Code"),CRMAccount.FIELDNO(OwnerId),
          CRMAccount.FIELDNO(OwnerIdType),CRMAccount.OwnerIdType::systemuser))
    END;

    LOCAL PROCEDURE UpdateCRMContactOwnerID@19(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef) : Boolean;
    VAR
      CRMContact@1004 : Record 5342;
      Contact@1005 : Record 5050;
    BEGIN
      EXIT(
        CRMSynchHelper.UpdateOwnerIfChanged(
          SourceRecordRef,DestinationRecordRef,Contact.FIELDNO("Salesperson Code"),CRMContact.FIELDNO(OwnerId),
          CRMContact.FIELDNO(OwnerIdType),CRMContact.OwnerIdType::systemuser))
    END;

    LOCAL PROCEDURE UpdateCRMInvoiceOwnerID@240(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef) : Boolean;
    VAR
      CRMInvoice@1004 : Record 5355;
      SalesInvoiceHeader@1005 : Record 112;
    BEGIN
      EXIT(
        CRMSynchHelper.UpdateOwnerIfChanged(
          SourceRecordRef,DestinationRecordRef,SalesInvoiceHeader.FIELDNO("Salesperson Code"),CRMInvoice.FIELDNO(OwnerId),
          CRMInvoice.FIELDNO(OwnerIdType),CRMInvoice.OwnerIdType::systemuser))
    END;

    LOCAL PROCEDURE UpdateCRMContactParentCustomerId@14(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef);
    VAR
      CRMContact@1012 : Record 5342;
      ParentCustomerIdFieldRef@1011 : FieldRef;
    BEGIN
      // Tranfer the parent company id to the ParentCustomerId
      ParentCustomerIdFieldRef := DestinationRecordRef.FIELD(CRMContact.FIELDNO(ParentCustomerId));
      ParentCustomerIdFieldRef.VALUE := FindParentCRMAccountForContact(SourceRecordRef);
    END;

    LOCAL PROCEDURE UpdateCRMInvoiceAfterInsertRecord@4(SourceRecordRef@1002 : RecordRef;DestinationRecordRef@1003 : RecordRef);
    VAR
      CRMInvoice@1000 : Record 5355;
      SalesInvoiceHeader@1005 : Record 112;
      SalesInvoiceLine@1016 : Record 113;
      CRMIntegrationTableSynch@1017 : Codeunit 5340;
      SourceLinesRecordRef@1018 : RecordRef;
    BEGIN
      SourceRecordRef.SETTABLE(SalesInvoiceHeader);
      DestinationRecordRef.SETTABLE(CRMInvoice);

      SalesInvoiceLine.SETRANGE("Document No.",SalesInvoiceHeader."No.");
      IF NOT SalesInvoiceLine.ISEMPTY THEN BEGIN
        SourceLinesRecordRef.GETTABLE(SalesInvoiceLine);
        CRMIntegrationTableSynch.SynchRecordsToIntegrationTable(SourceLinesRecordRef,FALSE,FALSE);

        SalesInvoiceLine.CALCSUMS("Line Discount Amount");
        CRMInvoice.TotalLineItemDiscountAmount := SalesInvoiceLine."Line Discount Amount";
      END;

      CRMInvoice.FreightAmount := 0;
      CRMInvoice.DiscountPercentage := 0;
      CRMInvoice.TotalTax := CRMInvoice.TotalAmount - CRMInvoice.TotalAmountLessFreight;
      CRMInvoice.TotalDiscountAmount := CRMInvoice.DiscountAmount + CRMInvoice.TotalLineItemDiscountAmount;
      CRMInvoice.MODIFY;
      CRMSynchHelper.UpdateCRMInvoiceStatus(CRMInvoice,SalesInvoiceHeader);

      CRMSynchHelper.SetSalesInvoiceHeaderCoupledToCRM(SalesInvoiceHeader);
    END;

    LOCAL PROCEDURE UpdateCRMInvoiceBeforeInsertRecord@60(SourceRecordRef@1002 : RecordRef;DestinationRecordRef@1003 : RecordRef);
    VAR
      CRMAccount@1015 : Record 5341;
      CRMIntegrationRecord@1011 : Record 5331;
      CRMInvoice@1000 : Record 5355;
      CRMPricelevel@1013 : Record 5346;
      CRMSalesorder@1007 : Record 5353;
      Customer@1010 : Record 18;
      SalesInvoiceHeader@1005 : Record 112;
      ShipmentMethod@1008 : Record 10;
      CRMSalesOrderToSalesOrder@1006 : Codeunit 5343;
      TypeHelper@1009 : Codeunit 10;
      DestinationFieldRef@1004 : FieldRef;
      AccountId@1012 : GUID;
    BEGIN
      SourceRecordRef.SETTABLE(SalesInvoiceHeader);

      // Shipment Method Code -> go to table Shipment Method, and from there extract the description and add it to
      IF ShipmentMethod.GET(SalesInvoiceHeader."Shipment Method Code") THEN BEGIN
        DestinationFieldRef := DestinationRecordRef.FIELD(CRMInvoice.FIELDNO(Description));
        TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef,ShipmentMethod.Description,TEXTENCODING::UTF16);
      END;

      DestinationRecordRef.SETTABLE(CRMInvoice);
      IF CRMSalesOrderToSalesOrder.GetCRMSalesOrder(CRMSalesorder,SalesInvoiceHeader."Your Reference") THEN BEGIN
        CRMInvoice.OpportunityId := CRMSalesorder.OpportunityId;
        CRMInvoice.SalesOrderId := CRMSalesorder.SalesOrderId;
        CRMInvoice.PriceLevelId := CRMSalesorder.PriceLevelId;
        CRMInvoice.Name := CRMSalesorder.Name;

        IF NOT CRMSalesOrderToSalesOrder.GetCoupledCustomer(CRMSalesorder,Customer) THEN BEGIN
          IF NOT CRMSalesOrderToSalesOrder.GetCRMAccountOfCRMSalesOrder(CRMSalesorder,CRMAccount) THEN
            ERROR(CustomerHasChangedErr,CRMSalesorder.OrderNumber,CRMProductName.SHORT);
          IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::"CRM Account",CRMAccount.AccountId) THEN
            ERROR(CustomerHasChangedErr,CRMSalesorder.OrderNumber,CRMProductName.SHORT);
        END;
        IF Customer."No." <> SalesInvoiceHeader."Sell-to Customer No." THEN
          ERROR(CustomerHasChangedErr,CRMSalesorder.OrderNumber,CRMProductName.SHORT);
        CRMInvoice.CustomerId := CRMSalesorder.CustomerId;
        CRMInvoice.CustomerIdType := CRMSalesorder.CustomerIdType;
      END ELSE BEGIN
        CRMInvoice.Name := SalesInvoiceHeader."No.";
        Customer.GET(SalesInvoiceHeader."Sell-to Customer No.");

        IF NOT CRMIntegrationRecord.FindIDFromRecordID(Customer.RECORDID,AccountId) THEN
          IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::Customer,Customer.RECORDID) THEN
            ERROR(CustomerHasChangedErr,CRMSalesorder.OrderNumber,CRMProductName.SHORT);
        CRMInvoice.CustomerId := AccountId;
        CRMInvoice.CustomerIdType := CRMInvoice.CustomerIdType::account;
        IF NOT CRMSynchHelper.FindCRMPriceListByCurrencyCode(CRMPricelevel,SalesInvoiceHeader."Currency Code") THEN
          CRMSynchHelper.CreateCRMPricelevelInCurrency(
            CRMPricelevel,SalesInvoiceHeader."Currency Code",SalesInvoiceHeader."Currency Factor");
        CRMInvoice.PriceLevelId := CRMPricelevel.PriceLevelId;
      END;
      DestinationRecordRef.GETTABLE(CRMInvoice);
    END;

    LOCAL PROCEDURE UpdateCRMInvoiceDetailsAfterInsertRecord@58(SourceRecordRef@1001 : RecordRef;DestinationRecordRef@1000 : RecordRef);
    VAR
      CRMInvoicedetail@1003 : Record 5356;
      SalesInvoiceLine@1002 : Record 113;
    BEGIN
      SourceRecordRef.SETTABLE(SalesInvoiceLine);
      DestinationRecordRef.SETTABLE(CRMInvoicedetail);

      CRMInvoicedetail.VolumeDiscountAmount := 0;
      CRMInvoicedetail.ManualDiscountAmount := SalesInvoiceLine."Line Discount Amount";
      CRMInvoicedetail.Tax := SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine.Amount;
      CRMInvoicedetail.BaseAmount :=
        SalesInvoiceLine.Amount + SalesInvoiceLine."Inv. Discount Amount" + SalesInvoiceLine."Line Discount Amount";
      CRMInvoicedetail.ExtendedAmount :=
        SalesInvoiceLine."Amount Including VAT" + SalesInvoiceLine."Inv. Discount Amount";
      CRMInvoicedetail.MODIFY;

      DestinationRecordRef.GETTABLE(CRMInvoicedetail);
    END;

    LOCAL PROCEDURE UpdateCRMInvoiceDetailsBeforeInsertRecord@21(SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1003 : RecordRef);
    VAR
      CRMInvoicedetail@1000 : Record 5356;
      SalesInvoiceHeader@1005 : Record 112;
      SalesInvoiceLine@1006 : Record 113;
      CRMIntegrationRecord@1007 : Record 5331;
      CRMSalesInvoiceHeaderId@1004 : GUID;
    BEGIN
      SourceRecordRef.SETTABLE(SalesInvoiceLine);
      DestinationRecordRef.SETTABLE(CRMInvoicedetail);

      // Get the NAV and CRM invoice headers
      SalesInvoiceHeader.GET(SalesInvoiceLine."Document No.");
      IF NOT CRMIntegrationRecord.FindIDFromRecordID(SalesInvoiceHeader.RECORDID,CRMSalesInvoiceHeaderId) THEN
        ERROR(NoCoupledSalesInvoiceHeaderErr,CRMProductName.SHORT);

      // Initialize the CRM invoice lines
      InitializeCRMInvoiceLineFromCRMHeader(CRMInvoicedetail,CRMSalesInvoiceHeaderId);
      InitializeCRMInvoiceLineFromSalesInvoiceHeader(CRMInvoicedetail,SalesInvoiceHeader);
      InitializeCRMInvoiceLineFromSalesInvoiceLine(CRMInvoicedetail,SalesInvoiceLine);
      InitializeCRMInvoiceLineWithProductDetails(CRMInvoicedetail,SalesInvoiceLine);

      CRMSynchHelper.CreateCRMProductpriceIfAbsent(CRMInvoicedetail);

      DestinationRecordRef.GETTABLE(CRMInvoicedetail);
    END;

    LOCAL PROCEDURE UpdateCRMPricelevelBeforeInsertRecord@25(SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1003 : RecordRef);
    VAR
      CRMPricelevel@1013 : Record 5346;
      CRMTransactioncurrency@1000 : Record 5345;
      CustomerPriceGroup@1005 : Record 6;
      TypeHelper@1006 : Codeunit 10;
      DestinationFieldRef@1004 : FieldRef;
    BEGIN
      SourceRecordRef.SETTABLE(CustomerPriceGroup);
      CheckCustPriceGroupForSync(CRMTransactioncurrency,CustomerPriceGroup);

      DestinationFieldRef := DestinationRecordRef.FIELD(CRMPricelevel.FIELDNO(TransactionCurrencyId));
      CRMSynchHelper.UpdateCRMCurrencyIdIfChanged(CRMTransactioncurrency.ISOCurrencyCode,DestinationFieldRef);

      DestinationFieldRef := DestinationRecordRef.FIELD(CRMPricelevel.FIELDNO(Description));
      TypeHelper.WriteTextToBlobIfChanged(DestinationFieldRef,CustomerPriceGroup.Description,TEXTENCODING::UTF16);
    END;

    LOCAL PROCEDURE UpdateCRMPricelevelBeforeModifyRecord@32(SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1003 : RecordRef);
    VAR
      CRMPricelevel@1013 : Record 5346;
      CRMTransactioncurrency@1007 : Record 5345;
      CustomerPriceGroup@1005 : Record 6;
    BEGIN
      SourceRecordRef.SETTABLE(CustomerPriceGroup);
      CheckCustPriceGroupForSync(CRMTransactioncurrency,CustomerPriceGroup);

      DestinationRecordRef.SETTABLE(CRMPricelevel);
      CRMPricelevel.TESTFIELD(TransactionCurrencyId,CRMTransactioncurrency.TransactionCurrencyId);
    END;

    LOCAL PROCEDURE ResetCRMProductpricelevelFromCRMPricelevel@39(SourceRecordRef@1002 : RecordRef);
    VAR
      CustomerPriceGroup@1005 : Record 6;
      SalesPrice@1016 : Record 7002;
      CRMIntegrationTableSynch@1017 : Codeunit 5340;
      SalesPriceRecordRef@1006 : RecordRef;
    BEGIN
      SourceRecordRef.SETTABLE(CustomerPriceGroup);

      SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::"Customer Price Group");
      SalesPrice.SETRANGE("Sales Code",CustomerPriceGroup.Code);
      IF NOT SalesPrice.ISEMPTY THEN BEGIN
        SalesPriceRecordRef.GETTABLE(SalesPrice);
        CRMIntegrationTableSynch.SynchRecordsToIntegrationTable(SalesPriceRecordRef,FALSE,FALSE);
      END;
    END;

    LOCAL PROCEDURE UpdateCRMProductPricelevelAfterTransferRecordFields@23(SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1003 : RecordRef) UoMHasBeenChanged : Boolean;
    VAR
      CRMProductpricelevel@1000 : Record 5347;
      SalesPrice@1006 : Record 7002;
      CRMUom@1001 : Record 5361;
    BEGIN
      DestinationRecordRef.SETTABLE(CRMProductpricelevel);
      SourceRecordRef.SETTABLE(SalesPrice);
      FindCRMUoMIdForSalesPrice(SalesPrice,CRMUom);
      IF CRMProductpricelevel.UoMId <> CRMUom.UoMId THEN BEGIN
        CRMProductpricelevel.UoMId := CRMUom.UoMId;
        CRMProductpricelevel.UoMScheduleId := CRMUom.UoMScheduleId;
        UoMHasBeenChanged := TRUE;
      END;
      DestinationRecordRef.GETTABLE(CRMProductpricelevel);
    END;

    LOCAL PROCEDURE UpdateCRMProductAfterTransferRecordFields@13(SourceRecordRef@1003 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef;DestinationIsInserted@1014 : Boolean) AdditionalFieldsWereModified : Boolean;
    VAR
      Item@1007 : Record 27;
      Resource@1008 : Record 156;
      CRMProduct@1001 : Record 5348;
      GeneralLedgerSetup@1006 : Record 98;
      TypeHelper@1009 : Codeunit 10;
      DescriptionItemFieldRef@1012 : FieldRef;
      DescriptionProductFieldRef@1011 : FieldRef;
      DestinationFieldRef@1005 : FieldRef;
      UnitOfMeasureCodeFieldRef@1004 : FieldRef;
      UnitOfMeasureCode@1000 : Code[10];
      ProductTypeCode@1013 : Option;
      Blocked@1010 : Boolean;
    BEGIN
      // Update CRM UoM ID, UoMSchedule Id. The CRM UoM Name and UoMScheduleName will be cascade-updated from their IDs by CRM
      IF SourceRecordRef.NUMBER = DATABASE::Item THEN BEGIN
        Blocked := SourceRecordRef.FIELD(Item.FIELDNO(Blocked)).VALUE;
        UnitOfMeasureCodeFieldRef := SourceRecordRef.FIELD(Item.FIELDNO("Base Unit of Measure"));
        ProductTypeCode := CRMProduct.ProductTypeCode::SalesInventory;
        // Update Description
        DescriptionItemFieldRef := SourceRecordRef.FIELD(Item.FIELDNO("Description 2"));
        DescriptionProductFieldRef := DestinationRecordRef.FIELD(CRMProduct.FIELDNO(Description));
        IF TypeHelper.WriteTextToBlobIfChanged(DescriptionProductFieldRef,FORMAT(DescriptionItemFieldRef.VALUE),TEXTENCODING::UTF16) THEN
          AdditionalFieldsWereModified := TRUE;
      END;

      IF SourceRecordRef.NUMBER = DATABASE::Resource THEN BEGIN
        Blocked := SourceRecordRef.FIELD(Resource.FIELDNO(Blocked)).VALUE;
        UnitOfMeasureCodeFieldRef := SourceRecordRef.FIELD(Resource.FIELDNO("Base Unit of Measure"));
        ProductTypeCode := CRMProduct.ProductTypeCode::Services;
      END;

      UnitOfMeasureCodeFieldRef.TESTFIELD;
      UnitOfMeasureCode := FORMAT(UnitOfMeasureCodeFieldRef.VALUE);

      // Update CRM Currency Id (if changed)
      GeneralLedgerSetup.GET;
      DestinationFieldRef := DestinationRecordRef.FIELD(CRMProduct.FIELDNO(TransactionCurrencyId));
      IF CRMSynchHelper.UpdateCRMCurrencyIdIfChanged(FORMAT(GeneralLedgerSetup."LCY Code"),DestinationFieldRef) THEN
        AdditionalFieldsWereModified := TRUE;

      DestinationRecordRef.SETTABLE(CRMProduct);
      IF CRMSynchHelper.UpdateCRMProductUoMFieldsIfChanged(CRMProduct,UnitOfMeasureCode) THEN
        AdditionalFieldsWereModified := TRUE;

      // If the CRMProduct price is negative, update it to zero (CRM doesn't allow negative prices)
      IF CRMSynchHelper.UpdateCRMProductPriceIfNegative(CRMProduct) THEN
        AdditionalFieldsWereModified := TRUE;

      // If the CRM Quantity On Hand is negative, update it to zero
      IF CRMSynchHelper.UpdateCRMProductQuantityOnHandIfNegative(CRMProduct) THEN
        AdditionalFieldsWereModified := TRUE;

      // Create or update the default price list
      IF CRMSynchHelper.UpdateCRMPriceListItem(CRMProduct) THEN
        AdditionalFieldsWereModified := TRUE;

      // Update the Vendor Name
      IF CRMSynchHelper.UpdateCRMProductVendorNameIfChanged(CRMProduct) THEN
        AdditionalFieldsWereModified := TRUE;

      // Set the ProductTypeCode, to later know if this product came from an item or from a resource
      IF CRMSynchHelper.UpdateCRMProductTypeCodeIfChanged(CRMProduct,ProductTypeCode) THEN
        AdditionalFieldsWereModified := TRUE;

      IF DestinationIsInserted THEN
        IF CRMSynchHelper.UpdateCRMProductStateCodeIfChanged(CRMProduct,Blocked) THEN
          AdditionalFieldsWereModified := TRUE;

      IF AdditionalFieldsWereModified THEN
        DestinationRecordRef.GETTABLE(CRMProduct);
    END;

    LOCAL PROCEDURE UpdateCRMProductAfterInsertRecord@11(VAR DestinationRecordRef@1003 : RecordRef);
    VAR
      CRMProduct@1000 : Record 5348;
    BEGIN
      DestinationRecordRef.SETTABLE(CRMProduct);
      CRMSynchHelper.UpdateCRMPriceListItem(CRMProduct);
      CRMSynchHelper.SetCRMProductStateToActive(CRMProduct);
      CRMProduct.MODIFY;
      DestinationRecordRef.GETTABLE(CRMProduct);
    END;

    LOCAL PROCEDURE UpdateCRMProductBeforeInsertRecord@8(VAR DestinationRecordRef@1001 : RecordRef);
    VAR
      CRMProduct@1004 : Record 5348;
    BEGIN
      DestinationRecordRef.SETTABLE(CRMProduct);
      CRMSynchHelper.SetCRMDecimalsSupportedValue(CRMProduct);
      DestinationRecordRef.GETTABLE(CRMProduct);
    END;

    LOCAL PROCEDURE UpdateItemAfterTransferRecordFields@53(SourceRecordRef@1003 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef) AdditionalFieldsWereModified : Boolean;
    VAR
      Item@1007 : Record 27;
      CRMProduct@1001 : Record 5348;
      Blocked@1000 : Boolean;
    BEGIN
      SourceRecordRef.SETTABLE(CRMProduct);
      DestinationRecordRef.SETTABLE(Item);

      Blocked := CRMProduct.StateCode <> CRMProduct.StateCode::Active;
      IF CRMSynchHelper.UpdateItemBlockedIfChanged(Item,Blocked) THEN BEGIN
        DestinationRecordRef.GETTABLE(Item);
        AdditionalFieldsWereModified := TRUE;
      END;
    END;

    LOCAL PROCEDURE UpdateResourceAfterTransferRecordFields@55(SourceRecordRef@1003 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef) AdditionalFieldsWereModified : Boolean;
    VAR
      Resource@1008 : Record 156;
      CRMProduct@1001 : Record 5348;
      Blocked@1000 : Boolean;
    BEGIN
      SourceRecordRef.SETTABLE(CRMProduct);
      DestinationRecordRef.SETTABLE(Resource);

      Blocked := CRMProduct.StateCode <> CRMProduct.StateCode::Active;
      IF CRMSynchHelper.UpdateResourceBlockedIfChanged(Resource,Blocked) THEN BEGIN
        DestinationRecordRef.GETTABLE(Resource);
        AdditionalFieldsWereModified := TRUE;
      END;
    END;

    LOCAL PROCEDURE UpdateCRMTransactionCurrencyBeforeInsertRecord@7(VAR DestinationRecordRef@1003 : RecordRef);
    VAR
      CRMTransactioncurrency@1000 : Record 5345;
      DestinationCurrencyPrecisionFieldRef@1009 : FieldRef;
    BEGIN
      // Fill in the target currency precision, taken from CRM precision defaults
      DestinationCurrencyPrecisionFieldRef := DestinationRecordRef.FIELD(CRMTransactioncurrency.FIELDNO(CurrencyPrecision));
      DestinationCurrencyPrecisionFieldRef.VALUE := CRMSynchHelper.GetCRMCurrencyDefaultPrecision;
    END;

    LOCAL PROCEDURE UpdateCRMTransactionCurrencyAfterTransferRecordFields@9(SourceRecordRef@1003 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef) AdditionalFieldsWereModified : Boolean;
    VAR
      CRMTransactioncurrency@1001 : Record 5345;
      Currency@1004 : Record 4;
      CurrencyCodeFieldRef@1000 : FieldRef;
      DestinationExchangeRateFieldRef@1005 : FieldRef;
    BEGIN
      // Fill-in the target currency Exchange Rate
      CurrencyCodeFieldRef := SourceRecordRef.FIELD(Currency.FIELDNO(Code));
      DestinationExchangeRateFieldRef := DestinationRecordRef.FIELD(CRMTransactioncurrency.FIELDNO(ExchangeRate));
      IF CRMSynchHelper.UpdateFieldRefValueIfChanged(
           DestinationExchangeRateFieldRef,
           FORMAT(CRMSynchHelper.GetCRMLCYToFCYExchangeRate(FORMAT(CurrencyCodeFieldRef.VALUE))))
      THEN
        AdditionalFieldsWereModified := TRUE;
    END;

    LOCAL PROCEDURE CRMTransactionCurrencyFindUncoupledDestinationRecord@6(SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1003 : RecordRef) DestinationFound : Boolean;
    VAR
      Currency@1006 : Record 4;
      CRMTransactioncurrency@1000 : Record 5345;
      CurrencyCodeFieldRef@1005 : FieldRef;
    BEGIN
      // Attempt to match currencies between NAV and CRM, on NAVCurrency.Code = CRMCurrency.ISOCode
      CurrencyCodeFieldRef := SourceRecordRef.FIELD(Currency.FIELDNO(Code));

      // Find destination record
      CRMTransactioncurrency.SETRANGE(ISOCurrencyCode,FORMAT(CurrencyCodeFieldRef.VALUE));
      // A match between the selected NAV currency and a CRM currency was found
      IF CRMTransactioncurrency.FINDFIRST THEN
        DestinationFound := DestinationRecordRef.GET(CRMTransactioncurrency.RECORDID);
    END;

    LOCAL PROCEDURE CRMPriceListLineFindUncoupledDestinationRecord@41(SourceRecordRef@1001 : RecordRef;VAR DestinationRecordRef@1000 : RecordRef) DestinationFound : Boolean;
    VAR
      CRMIntegrationRecord@1006 : Record 5331;
      CRMProductpricelevel@1002 : Record 5347;
      CRMUom@1007 : Record 5361;
      CustomerPriceGroup@1004 : Record 6;
      Item@1009 : Record 27;
      SalesPrice@1003 : Record 7002;
    BEGIN
      // Look for a line with the same combination of ProductId,UoMId
      SourceRecordRef.SETTABLE(SalesPrice);
      CustomerPriceGroup.GET(SalesPrice."Sales Code");
      IF CRMIntegrationRecord.FindByRecordID(CustomerPriceGroup.RECORDID) THEN BEGIN
        CRMProductpricelevel.SETRANGE(PriceLevelId,CRMIntegrationRecord."CRM ID");
        FindCRMUoMIdForSalesPrice(SalesPrice,CRMUom);
        CRMProductpricelevel.SETRANGE(UoMId,CRMUom.UoMId);
        Item.GET(SalesPrice."Item No.");
        CRMIntegrationRecord.FindByRecordID(Item.RECORDID);
        CRMProductpricelevel.SETRANGE(ProductId,CRMIntegrationRecord."CRM ID");
        DestinationFound := CRMProductpricelevel.FINDFIRST;
        DestinationRecordRef.GETTABLE(CRMProductpricelevel);
      END;
    END;

    LOCAL PROCEDURE UpdateCRMUoMScheduleAfterTransferRecordFields@3(SourceRecordRef@1003 : RecordRef;VAR DestinationRecordRef@1002 : RecordRef) AdditionalFieldsWereModified : Boolean;
    VAR
      CRMUomschedule@1001 : Record 5362;
      DestinationFieldRef@1005 : FieldRef;
      UnitNameWasUpdated@1009 : Boolean;
      CRMUomScheduleName@1004 : Text[200];
      CRMUomScheduleStateCode@1000 : Option;
      UnitGroupName@1008 : Text[200];
      UnitOfMeasureName@1007 : Text[100];
      CRMID@1011 : GUID;
    BEGIN
      // Prefix with NAV
      UnitOfMeasureName := CRMSynchHelper.GetUnitOfMeasureName(SourceRecordRef);
      UnitGroupName := CRMSynchHelper.GetUnitGroupName(UnitOfMeasureName); // prefix with "NAV "
      DestinationFieldRef := DestinationRecordRef.FIELD(CRMUomschedule.FIELDNO(Name));
      CRMUomScheduleName := FORMAT(DestinationFieldRef.VALUE);
      IF CRMUomScheduleName <> UnitGroupName THEN BEGIN
        DestinationFieldRef.VALUE := UnitGroupName;
        AdditionalFieldsWereModified := TRUE;
      END;

      // Get the State Code
      DestinationFieldRef := DestinationRecordRef.FIELD(CRMUomschedule.FIELDNO(StateCode));
      CRMUomScheduleStateCode := DestinationFieldRef.VALUE;

      DestinationFieldRef := DestinationRecordRef.FIELD(CRMUomschedule.FIELDNO(UoMScheduleId));
      CRMID := DestinationFieldRef.VALUE;
      IF NOT ValidateCRMUoMSchedule(CRMUomScheduleName,CRMUomScheduleStateCode,CRMID,UnitOfMeasureName,UnitNameWasUpdated) THEN
        EXIT;

      IF UnitNameWasUpdated THEN
        AdditionalFieldsWereModified := TRUE;
    END;

    LOCAL PROCEDURE CRMUoMScheduleFindUncoupledDestinationRecord@1(SourceRecordRef@1002 : RecordRef;VAR DestinationRecordRef@1003 : RecordRef) DestinationFound : Boolean;
    VAR
      CRMUomschedule@1004 : Record 5362;
      UnitFieldWasUpdated@1007 : Boolean;
    BEGIN
      // A match between the selected NAV Unit of Measure and a CRM <Unit Group, Unit> tuple was found
      IF FindValidCRMUoMSchedule(CRMUomschedule,SourceRecordRef,UnitFieldWasUpdated) THEN
        DestinationFound := DestinationRecordRef.GET(CRMUomschedule.RECORDID);
    END;

    LOCAL PROCEDURE FindValidCRMUoMSchedule@16(VAR CRMUomschedule@1001 : Record 5362;SourceRecordRef@1006 : RecordRef;VAR UnitNameWasUpdated@1000 : Boolean) : Boolean;
    VAR
      UnitGroupName@1004 : Text[200];
      UnitOfMeasureName@1003 : Text[100];
    BEGIN
      UnitOfMeasureName := CRMSynchHelper.GetUnitOfMeasureName(SourceRecordRef);
      UnitGroupName := CRMSynchHelper.GetUnitGroupName(UnitOfMeasureName); // prefix with "NAV "

      // If the CRM Unit Group does not exist, exit
      CRMUomschedule.SETRANGE(Name,UnitGroupName);
      IF NOT CRMUomschedule.FINDFIRST THEN
        EXIT(FALSE);

      ValidateCRMUoMSchedule(
        CRMUomschedule.Name,CRMUomschedule.StateCode,CRMUomschedule.UoMScheduleId,UnitOfMeasureName,UnitNameWasUpdated);

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE ValidateCRMUoMSchedule@26(CRMUomScheduleName@1007 : Text[200];CRMUomScheduleStateCode@1001 : Option;CRMUomScheduleId@1006 : GUID;UnitOfMeasureName@1003 : Text[100];VAR UnitNameWasUpdated@1000 : Boolean) : Boolean;
    VAR
      CRMUom@1002 : Record 5361;
      CRMUomschedule@1005 : Record 5362;
    BEGIN
      // If the CRM Unit Group is not active throw and error
      IF CRMUomScheduleStateCode = CRMUomschedule.StateCode::Inactive THEN
        ERROR(CRMUnitGroupExistsAndIsInactiveErr,CRMUomschedule.TABLECAPTION,CRMUomScheduleName,CRMProductName.SHORT);

      // If the CRM Unit Group contains > 1 Units, fail
      CRMUom.SETRANGE(UoMScheduleId,CRMUomScheduleId);
      IF CRMUom.COUNT > 1 THEN
        ERROR(
          CRMUnitGroupContainsMoreThanOneUoMErr,CRMUomschedule.TABLECAPTION,CRMUomScheduleName,CRMUom.TABLECAPTION,
          CRMProductName.SHORT);

      // If the CRM Unit Group contains zero Units, then exit (no match found)
      IF NOT CRMUom.FINDFIRST THEN
        EXIT(FALSE);

      // Verify the CRM Unit name is correct, else update it
      IF CRMUom.Name <> UnitOfMeasureName THEN BEGIN
        CRMUom.Name := UnitOfMeasureName;
        CRMUom.MODIFY;
        UnitNameWasUpdated := TRUE;
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE FindContactRelatedCustomer@18(SourceRecordRef@1000 : RecordRef;VAR ContactBusinessRelation@1005 : Record 5054) : Boolean;
    VAR
      Contact@1001 : Record 5050;
      MarketingSetup@1002 : Record 5079;
      CompanyNoFieldRef@1004 : FieldRef;
    BEGIN
      // Tranfer the parent company id to the ParentCustomerId
      CompanyNoFieldRef := SourceRecordRef.FIELD(Contact.FIELDNO("Company No."));
      IF NOT Contact.GET(CompanyNoFieldRef.VALUE) THEN
        EXIT(FALSE);

      MarketingSetup.GET;
      ContactBusinessRelation.SETFILTER("Business Relation Code",MarketingSetup."Bus. Rel. Code for Customers");
      ContactBusinessRelation.SETRANGE("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
      ContactBusinessRelation.SETFILTER("Contact No.",Contact."No.");
      EXIT(ContactBusinessRelation.FINDFIRST);
    END;

    LOCAL PROCEDURE FindParentCRMAccountForContact@27(SourceRecordRef@1000 : RecordRef) AccountId : GUID;
    VAR
      ContactBusinessRelation@1006 : Record 5054;
      Contact@1005 : Record 5050;
      Customer@1004 : Record 18;
      CRMIntegrationRecord@1002 : Record 5331;
    BEGIN
      IF NOT FindContactRelatedCustomer(SourceRecordRef,ContactBusinessRelation) THEN
        ERROR(ContactsMustBeRelatedToCompanyErr,SourceRecordRef.FIELD(Contact.FIELDNO("No.")).VALUE);

      IF NOT Customer.GET(ContactBusinessRelation."No.") THEN
        ERROR(RecordNotFoundErr,Customer.TABLECAPTION,ContactBusinessRelation."No.");

      CRMIntegrationRecord.FindIDFromRecordID(Customer.RECORDID,AccountId);
    END;

    LOCAL PROCEDURE InitializeCRMInvoiceLineFromCRMHeader@33(VAR CRMInvoicedetail@1001 : Record 5356;CRMInvoiceId@1000 : GUID);
    VAR
      CRMInvoice@1002 : Record 5355;
    BEGIN
      CRMInvoice.GET(CRMInvoiceId);
      CRMInvoicedetail.ActualDeliveryOn := CRMInvoice.DateDelivered;
      CRMInvoicedetail.TransactionCurrencyId := CRMInvoice.TransactionCurrencyId;
      CRMInvoicedetail.ExchangeRate := CRMInvoice.ExchangeRate;
      CRMInvoicedetail.InvoiceId := CRMInvoice.InvoiceId;
      CRMInvoicedetail.ShipTo_City := CRMInvoice.ShipTo_City;
      CRMInvoicedetail.ShipTo_Country := CRMInvoice.ShipTo_Country;
      CRMInvoicedetail.ShipTo_Line1 := CRMInvoice.ShipTo_Line1;
      CRMInvoicedetail.ShipTo_Line2 := CRMInvoice.ShipTo_Line2;
      CRMInvoicedetail.ShipTo_Line3 := CRMInvoice.ShipTo_Line3;
      CRMInvoicedetail.ShipTo_Name := CRMInvoice.ShipTo_Name;
      CRMInvoicedetail.ShipTo_PostalCode := CRMInvoice.ShipTo_PostalCode;
      CRMInvoicedetail.ShipTo_StateOrProvince := CRMInvoice.ShipTo_StateOrProvince;
      CRMInvoicedetail.ShipTo_Fax := CRMInvoice.ShipTo_Fax;
      CRMInvoicedetail.ShipTo_Telephone := CRMInvoice.ShipTo_Telephone;
    END;

    LOCAL PROCEDURE InitializeCRMInvoiceLineFromSalesInvoiceHeader@66(VAR CRMInvoicedetail@1001 : Record 5356;SalesInvoiceHeader@1000 : Record 112);
    BEGIN
      CRMInvoicedetail.TransactionCurrencyId := CRMSynchHelper.GetCRMTransactioncurrency(SalesInvoiceHeader."Currency Code");
      IF SalesInvoiceHeader."Currency Factor" = 0 THEN
        CRMInvoicedetail.ExchangeRate := 1
      ELSE
        CRMInvoicedetail.ExchangeRate := ROUND(1 / SalesInvoiceHeader."Currency Factor");
    END;

    LOCAL PROCEDURE InitializeCRMInvoiceLineFromSalesInvoiceLine@24(VAR CRMInvoicedetail@1001 : Record 5356;SalesInvoiceLine@1000 : Record 113);
    BEGIN
      CRMInvoicedetail.LineItemNumber := SalesInvoiceLine."Line No.";
      CRMInvoicedetail.Tax := SalesInvoiceLine."Amount Including VAT" - SalesInvoiceLine.Amount;
    END;

    LOCAL PROCEDURE InitializeCRMInvoiceLineWithProductDetails@28(VAR CRMInvoicedetail@1001 : Record 5356;SalesInvoiceLine@1000 : Record 113);
    VAR
      CRMProduct@1004 : Record 5348;
      CRMProductId@1003 : GUID;
    BEGIN
      CRMProductId := FindCRMProductId(SalesInvoiceLine);
      IF ISNULLGUID(CRMProductId) THEN BEGIN
        // This will be created as a CRM write-in product
        CRMInvoicedetail.IsProductOverridden := TRUE;
        CRMInvoicedetail.ProductDescription :=
          STRSUBSTNO('%1 %2.',FORMAT(SalesInvoiceLine."No."),FORMAT(SalesInvoiceLine.Description));
      END ELSE BEGIN
        // There is a coupled product or resource in CRM, transfer data from there
        CRMProduct.GET(CRMProductId);
        CRMInvoicedetail.ProductId := CRMProduct.ProductId;
        CRMInvoicedetail.UoMId := CRMProduct.DefaultUoMId;
      END;
    END;

    LOCAL PROCEDURE AreFieldsRelatedToMappedTables@37(SourceFieldRef@1001 : FieldRef;DestinationFieldRef@1000 : FieldRef;VAR IntegrationTableMapping@1007 : Record 5335) : Boolean;
    VAR
      SourceTableID@1002 : Integer;
      DestinationTableID@1003 : Integer;
      Direction@1004 : Integer;
    BEGIN
      IF (SourceFieldRef.RELATION <> 0) AND (DestinationFieldRef.RELATION <> 0) THEN BEGIN
        SourceTableID := SourceFieldRef.RELATION;
        DestinationTableID := DestinationFieldRef.RELATION;
        IF FORMAT(DestinationFieldRef.TYPE) = 'GUID' THEN BEGIN
          IntegrationTableMapping.SETRANGE("Table ID",SourceTableID);
          IntegrationTableMapping.SETRANGE("Integration Table ID",DestinationTableID);
          Direction := IntegrationTableMapping.Direction::ToIntegrationTable;
        END ELSE BEGIN
          IntegrationTableMapping.SETRANGE("Table ID",DestinationTableID);
          IntegrationTableMapping.SETRANGE("Integration Table ID",SourceTableID);
          Direction := IntegrationTableMapping.Direction::FromIntegrationTable;
        END;
        IntegrationTableMapping.SETRANGE("Delete After Synchronization",FALSE);
        IF IntegrationTableMapping.FINDFIRST THEN BEGIN
          IntegrationTableMapping.Direction := Direction;
          EXIT(TRUE);
        END;
        ERROR(
          MappingMustBeSetForGUIDFieldErr,
          SourceFieldRef.RELATION,DestinationFieldRef.RELATION,SourceFieldRef.NAME,DestinationFieldRef.NAME);
      END;
    END;

    LOCAL PROCEDURE IsTableMappedToCRMOption@48(TableID@1000 : Integer) : Boolean;
    VAR
      CRMOptionMapping@1001 : Record 5334;
    BEGIN
      CRMOptionMapping.SETRANGE("Table ID",TableID);
      EXIT(NOT CRMOptionMapping.ISEMPTY);
    END;

    LOCAL PROCEDURE FindCRMProductId@29(SalesInvoiceLine@1000 : Record 113) CRMID : GUID;
    VAR
      CRMIntegrationRecord@1003 : Record 5331;
      Resource@1002 : Record 156;
    BEGIN
      CLEAR(CRMID);
      CASE SalesInvoiceLine.Type OF
        SalesInvoiceLine.Type::Item:
          CRMID := FindCRMProductIdForItem(SalesInvoiceLine."No.");
        SalesInvoiceLine.Type::Resource:
          BEGIN
            Resource.GET(SalesInvoiceLine."No.");
            IF NOT CRMIntegrationRecord.FindIDFromRecordID(Resource.RECORDID,CRMID) THEN BEGIN
              IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::Resource,Resource.RECORDID) THEN
                ERROR(CannotSynchProductErr,Resource."No.");
              IF NOT CRMIntegrationRecord.FindIDFromRecordID(Resource.RECORDID,CRMID) THEN
                ERROR(CannotFindSyncedProductErr);
            END;
          END;
      END;
    END;

    LOCAL PROCEDURE FindCRMProductIdForItem@44(ItemNo@1001 : Code[20]) CRMID : GUID;
    VAR
      Item@1000 : Record 27;
      CRMIntegrationRecord@1002 : Record 5331;
    BEGIN
      Item.GET(ItemNo);
      IF NOT CRMIntegrationRecord.FindIDFromRecordID(Item.RECORDID,CRMID) THEN BEGIN
        IF NOT CRMSynchHelper.SynchRecordIfMappingExists(DATABASE::Item,Item.RECORDID) THEN
          ERROR(CannotSynchProductErr,Item."No.");
        IF NOT CRMIntegrationRecord.FindIDFromRecordID(Item.RECORDID,CRMID) THEN
          ERROR(CannotFindSyncedProductErr);
      END;
    END;

    LOCAL PROCEDURE FindCRMUoMIdForSalesPrice@30(SalesPrice@1000 : Record 7002;VAR CRMUom@1001 : Record 5361);
    VAR
      Item@1002 : Record 27;
      CRMUomschedule@1005 : Record 5362;
      UoMCode@1003 : Code[10];
    BEGIN
      IF SalesPrice."Unit of Measure Code" = '' THEN BEGIN
        Item.GET(SalesPrice."Item No.");
        UoMCode := Item."Base Unit of Measure";
      END ELSE
        UoMCode := SalesPrice."Unit of Measure Code";
      CRMSynchHelper.GetValidCRMUnitOfMeasureRecords(CRMUom,CRMUomschedule,UoMCode);
    END;

    LOCAL PROCEDURE CheckSalesPricesForSync@31(CustomerPriceGroupCode@1000 : Code[10];ExpectedCurrencyCode@1004 : Code[10]);
    VAR
      SalesPrice@1001 : Record 7002;
      CRMUom@1002 : Record 5361;
    BEGIN
      SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::"Customer Price Group");
      SalesPrice.SETRANGE("Sales Code",CustomerPriceGroupCode);
      IF SalesPrice.FINDSET THEN
        REPEAT
          SalesPrice.TESTFIELD("Currency Code",ExpectedCurrencyCode);
          FindCRMProductIdForItem(SalesPrice."Item No.");
          FindCRMUoMIdForSalesPrice(SalesPrice,CRMUom);
        UNTIL SalesPrice.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckCustPriceGroupForSync@43(VAR CRMTransactioncurrency@1000 : Record 5345;CustomerPriceGroup@1001 : Record 6);
    VAR
      SalesPrice@1003 : Record 7002;
    BEGIN
      SalesPrice.SETRANGE("Sales Type",SalesPrice."Sales Type"::"Customer Price Group");
      SalesPrice.SETRANGE("Sales Code",CustomerPriceGroup.Code);
      IF SalesPrice.FINDFIRST THEN BEGIN
        CRMTransactioncurrency.GET(CRMSynchHelper.GetCRMTransactioncurrency(SalesPrice."Currency Code"));
        CheckSalesPricesForSync(CustomerPriceGroup.Code,SalesPrice."Currency Code");
      END ELSE
        CRMSynchHelper.FindNAVLocalCurrencyInCRM(CRMTransactioncurrency);
    END;

    LOCAL PROCEDURE CheckItemOrResourceIsNotBlocked@57(SourceRecordRef@1000 : RecordRef);
    VAR
      SalesInvHeader@1001 : Record 112;
      SalesInvLine@1002 : Record 113;
      Item@1003 : Record 27;
      Resource@1004 : Record 156;
    BEGIN
      SourceRecordRef.SETTABLE(SalesInvHeader);
      SalesInvLine.SETRANGE("Document No.",SalesInvHeader."No.");
      SalesInvLine.SETFILTER(Type,'%1|%2',SalesInvLine.Type::Item,SalesInvLine.Type::Resource);
      IF SalesInvLine.FINDSET THEN
        REPEAT
          IF SalesInvLine.Type = SalesInvLine.Type::Item THEN BEGIN
            Item.GET(SalesInvLine."No.");
            Item.TESTFIELD(Blocked,FALSE);
          END ELSE BEGIN
            Resource.GET(SalesInvLine."No.");
            Resource.TESTFIELD(Blocked,FALSE);
          END;
        UNTIL SalesInvLine.NEXT = 0;
    END;

    LOCAL PROCEDURE ConvertTableToOption@47(SourceFieldRef@1000 : FieldRef;VAR OptionValue@1001 : Integer) TableIsMapped : Boolean;
    VAR
      CRMOptionMapping@1003 : Record 5334;
      RecordRef@1002 : RecordRef;
      RecID@1006 : RecordID;
    BEGIN
      TableIsMapped := FALSE;
      OptionValue := 0;
      IF IsTableMappedToCRMOption(SourceFieldRef.RELATION) THEN BEGIN
        TableIsMapped := TRUE;
        IF FindRecordIDByPK(SourceFieldRef.RELATION,SourceFieldRef.VALUE,RecID) THEN BEGIN
          CRMOptionMapping.SETRANGE("Record ID",RecID);
          IF CRMOptionMapping.FINDFIRST THEN
            OptionValue := CRMOptionMapping."Option Value";
        END;
        RecordRef.CLOSE;
      END;
      EXIT(TableIsMapped);
    END;

    LOCAL PROCEDURE FindNewValueForCoupledRecordPK@56(IntegrationTableMapping@1000 : Record 5335;SourceFieldRef@1002 : FieldRef;DestinationFieldRef@1001 : FieldRef;VAR NewValue@1004 : Variant) IsValueFound : Boolean;
    VAR
      CRMIntegrationRecord@1003 : Record 5331;
      RecID@1007 : RecordID;
      CRMID@1008 : GUID;
    BEGIN
      IF FindNewValueForSpecialMapping(SourceFieldRef,NewValue) THEN
        EXIT(TRUE);
      CASE IntegrationTableMapping.Direction OF
        IntegrationTableMapping.Direction::ToIntegrationTable:
          IF FORMAT(SourceFieldRef.VALUE) = '' THEN BEGIN
            NewValue := CRMID; // Blank GUID
            IsValueFound := TRUE;
          END ELSE BEGIN
            IF FindRecordIDByPK(SourceFieldRef.RELATION,SourceFieldRef.VALUE,RecID) THEN
              IF CRMIntegrationRecord.FindIDFromRecordID(RecID,NewValue) THEN
                EXIT(TRUE);
            IF IsClearValueOnFailedSync(SourceFieldRef,DestinationFieldRef) THEN BEGIN
              NewValue := CRMID;
              EXIT(TRUE);
            END;
            ERROR(RecordMustBeCoupledErr,SourceFieldRef.NAME,SourceFieldRef.VALUE,CRMProductName.SHORT);
          END;
        IntegrationTableMapping.Direction::FromIntegrationTable:
          BEGIN
            CRMID := SourceFieldRef.VALUE;
            IF ISNULLGUID(CRMID) THEN BEGIN
              NewValue := '';
              IsValueFound := TRUE;
            END ELSE BEGIN
              IF CRMIntegrationRecord.FindRecordIDFromID(CRMID,DestinationFieldRef.RELATION,RecID) THEN
                IF FindPKByRecordID(RecID,NewValue) THEN
                  EXIT(TRUE);
              IF IsClearValueOnFailedSync(DestinationFieldRef,SourceFieldRef) THEN BEGIN
                NewValue := '';
                EXIT(TRUE);
              END;
              ERROR(RecordMustBeCoupledErr,SourceFieldRef.NAME,CRMID,PRODUCTNAME.SHORT);
            END;
          END;
      END;
    END;

    LOCAL PROCEDURE FindNewValueForSpecialMapping@59(SourceFieldRef@1002 : FieldRef;VAR NewValue@1000 : Variant) IsValueFound : Boolean;
    VAR
      CRMTransactioncurrency@1005 : Record 5345;
      CRMID@1004 : GUID;
    BEGIN
      CASE SourceFieldRef.RELATION OF
        DATABASE::Currency: // special handling of Local currency
          IF FORMAT(SourceFieldRef.VALUE) = '' THEN BEGIN
            CRMSynchHelper.FindNAVLocalCurrencyInCRM(CRMTransactioncurrency);
            NewValue := CRMTransactioncurrency.TransactionCurrencyId;
            IsValueFound := TRUE;
          END;
        DATABASE::"CRM Transactioncurrency": // special handling of Local currency
          BEGIN
            CRMID := SourceFieldRef.VALUE;
            IF CRMSynchHelper.GetNavCurrencyCode(CRMID) = '' THEN BEGIN
              NewValue := '';
              IsValueFound := TRUE;
            END;
          END;
      END;
    END;

    LOCAL PROCEDURE FindPKByRecordID@52(RecID@1000 : RecordID;VAR PrimaryKey@1001 : Variant) Found : Boolean;
    VAR
      RecordRef@1004 : RecordRef;
      KeyRef@1003 : KeyRef;
      FieldRef@1002 : FieldRef;
    BEGIN
      Found := RecordRef.GET(RecID);
      KeyRef := RecordRef.KEYINDEX(1);
      FieldRef := KeyRef.FIELDINDEX(1);
      PrimaryKey := FieldRef.VALUE;
    END;

    LOCAL PROCEDURE FindRecordIDByPK@50(TableID@1000 : Integer;PrimaryKey@1001 : Variant;VAR RecID@1002 : RecordID) Found : Boolean;
    VAR
      RecordRef@1005 : RecordRef;
      KeyRef@1004 : KeyRef;
      FieldRef@1003 : FieldRef;
    BEGIN
      RecordRef.OPEN(TableID);
      KeyRef := RecordRef.KEYINDEX(1);
      FieldRef := KeyRef.FIELDINDEX(1);
      FieldRef.SETRANGE(PrimaryKey);
      Found := RecordRef.FINDFIRST;
      RecID := RecordRef.RECORDID;
      RecordRef.CLOSE;
    END;

    LOCAL PROCEDURE FindSourceIntegrationTableMapping@68(VAR IntegrationTableMapping@1005 : Record 5335;SourceFieldRef@1002 : FieldRef;DestinationFieldRef@1000 : FieldRef) : Boolean;
    VAR
      SourceRecRef@1006 : RecordRef;
      DestinationRecRef@1007 : RecordRef;
    BEGIN
      SourceRecRef := SourceFieldRef.RECORD;
      DestinationRecRef := DestinationFieldRef.RECORD;
      IntegrationTableMapping.SETRANGE("Table ID",SourceRecRef.NUMBER);
      IntegrationTableMapping.SETRANGE("Integration Table ID",DestinationRecRef.NUMBER);
      EXIT(IntegrationTableMapping.FINDFIRST);
    END;

    LOCAL PROCEDURE IsClearValueOnFailedSync@67(SourceFieldRef@1002 : FieldRef;DestinationFieldRef@1000 : FieldRef) : Boolean;
    VAR
      IntegrationTableMapping@1005 : Record 5335;
      IntegrationFieldMapping@1001 : Record 5336;
    BEGIN
      IF FindSourceIntegrationTableMapping(IntegrationTableMapping,SourceFieldRef,DestinationFieldRef) THEN
        WITH IntegrationFieldMapping DO BEGIN
          SETRANGE("Integration Table Mapping Name",IntegrationTableMapping.Name);
          SETRANGE("Field No.",SourceFieldRef.NUMBER);
          SETRANGE("Integration Table Field No.",DestinationFieldRef.NUMBER);
          FINDFIRST;
          EXIT("Clear Value on Failed Sync");
        END;
      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

