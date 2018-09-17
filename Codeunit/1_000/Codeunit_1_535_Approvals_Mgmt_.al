OBJECT Codeunit 1535 Approvals Mgmt.
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    Permissions=TableData 454=imd,
                TableData 455=imd,
                TableData 456=imd,
                TableData 457=imd,
                TableData 458=imd,
                TableData 1511=imd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      UserIdNotInSetupErr@1015 : TextConst '@@@=User ID NAVUser does not exist in the Approval User Setup window.;DAN=Bruger-id''et %1 findes ikke i vinduet Brugerops�tning af godkendelser.;ENU=User ID %1 does not exist in the Approval User Setup window.';
      ApproverUserIdNotInSetupErr@1005 : TextConst '@@@=You must set up an approver for user ID NAVUser in the Approval User Setup window.;DAN=Du skal oprette godkender af bruger-id %1 i vinduet Brugerops�tning af godkendelser.;ENU=You must set up an approver for user ID %1 in the Approval User Setup window.';
      WFUserGroupNotInSetupErr@1013 : TextConst '@@@=The workflow user group member with user ID NAVUser does not exist in the Approval User Setup window.;DAN=Workflowets brugergruppemedlem med bruger-id''et %1 findes ikke i vinduet Brugerops�tning af godkendelser.;ENU=The workflow user group member with user ID %1 does not exist in the Approval User Setup window.';
      SubstituteNotFoundErr@1007 : TextConst '@@@=There is no substitute for user ID NAVUser in the Approval User Setup window.;DAN=Der er ingen stedfortr�der, direkte godkender eller godkendelsesadministrator for bruger-id''et %1 i vinduet Brugerops�tning af godkendelser.;ENU=There is no substitute, direct approver, or approval administrator for user ID %1 in the Approval User Setup window.';
      NoSuitableApproverFoundErr@1000 : TextConst 'DAN=Der blev ikke fundet en kvalificeret godkender.;ENU=No qualified approver was found.';
      DelegateOnlyOpenRequestsErr@1049 : TextConst 'DAN=Du kan kun uddelegere �bne godkendelsesanmodninger.;ENU=You can only delegate open approval requests.';
      ApproveOnlyOpenRequestsErr@1060 : TextConst 'DAN=Du kan kun godkende �bne godkendelsesanmodninger.;ENU=You can only approve open approval requests.';
      RejectOnlyOpenRequestsErr@1061 : TextConst 'DAN=Du kan kun afvise �bne godkendelsesposter.;ENU=You can only reject open approval entries.';
      ApprovalsDelegatedMsg@1018 : TextConst 'DAN=De valgte godkendelsesanmodninger er blevet uddelegeret.;ENU=The selected approval requests have been delegated.';
      NoReqToApproveErr@1056 : TextConst 'DAN=Der er ingen godkendelsesanmodninger at godkende.;ENU=There is no approval request to approve.';
      NoReqToRejectErr@1057 : TextConst 'DAN=Der er ingen godkendelsesanmodninger at afvise.;ENU=There is no approval request to reject.';
      NoReqToDelegateErr@1059 : TextConst 'DAN=Der er ingen godkendelsesanmodninger at uddelegere.;ENU=There is no approval request to delegate.';
      PendingApprovalMsg@1002 : TextConst 'DAN=En anmodning om godkendelse er blevet sendt.;ENU=An approval request has been sent.';
      NoApprovalsSentMsg@1006 : TextConst 'DAN=Der er ikke sendt nogen godkendelsesanmodninger, enten fordi de allerede er sendt, eller fordi relaterede workflows ikke underst�tter kladdelinjen.;ENU=No approval requests have been sent, either because they are already sent or because related workflows do not support the journal line.';
      PendingApprovalForSelectedLinesMsg@1020 : TextConst 'DAN=Godkendelsesanmodninger er blevet sendt.;ENU=Approval requests have been sent.';
      PendingApprovalForSomeSelectedLinesMsg@1001 : TextConst 'DAN=Godkendelsesanmodninger er blevet sendt.\\Anmodninger for nogle kladdelinjer blev ikke sendt, enten fordi de allerede er blevet sendt, eller fordi relaterede workflows ikke underst�tter kladdelinjen.;ENU=Approval requests have been sent.\\Requests for some journal lines were not sent, either because they are already sent or because related workflows do not support the journal line.';
      PurchaserUserNotFoundErr@1003 : TextConst '@@@=Example: The salesperson/purchaser user ID NAVUser does not exist in the Approval User Setup window for Salesperson/Purchaser code AB.;DAN=S�lgerens/k�berens bruger-id %1 findes ikke i vinduet Brugerops�tning af godkendelser for %2 %3.;ENU=The salesperson/purchaser user ID %1 does not exist in the Approval User Setup window for %2 %3.';
      NoApprovalRequestsFoundErr@1009 : TextConst 'DAN=Der findes ingen godkendelsesanmodninger.;ENU=No approval requests exist.';
      NoWFUserGroupMembersErr@1004 : TextConst 'DAN=Der skal konfigureres en brugergruppe for workflow med mindst �t medlem.;ENU=A workflow user group with at least one member must be set up.';
      DocStatusChangedMsg@1010 : TextConst '@@@=Order 1001 has been automatically approved. The status has been changed to Released.;DAN=%1 %2 er blevet godkendt automatisk. Status er �ndret til %3.;ENU=%1 %2 has been automatically approved. The status has been changed to %3.';
      UnsupportedRecordTypeErr@1011 : TextConst '@@@=Record type Customer is not supported by this workflow response.;DAN=Recordtypen %1 underst�ttes ikke af denne workflowrespons.;ENU=Record type %1 is not supported by this workflow response.';
      SalesPrePostCheckErr@1012 : TextConst '@@@="%1=document type, %2=document no., e.g. Sales Order 321 must be approved...";DAN=Salget %1 %2 skal godkendes og frigives, inden du kan udf�re denne handling.;ENU=Sales %1 %2 must be approved and released before you can perform this action.';
      WorkflowEventHandling@1071 : Codeunit 1520;
      WorkflowManagement@1070 : Codeunit 1501;
      PurchPrePostCheckErr@1022 : TextConst '@@@="%1=document type, %2=document no., e.g. Purchase Order 321 must be approved...";DAN=K�bet %1 %2 skal godkendes og frigives, inden du kan udf�re denne handling.;ENU=Purchase %1 %2 must be approved and released before you can perform this action.';
      NoWorkflowEnabledErr@1101 : TextConst 'DAN=Der er ikke aktiveret et godkendelsesworkflow for denne recordtype.;ENU=No approval workflow for this record type is enabled.';
      ApprovalReqCanceledForSelectedLinesMsg@1019 : TextConst 'DAN=Godkendelsesanmodningen for den valgte record er blevet annulleret.;ENU=The approval request for the selected record has been canceled.';
      PendingJournalBatchApprovalExistsErr@1017 : TextConst '@@@=%1 is the Document No. of the journal line;DAN=Der findes allerede en godkendelsesanmodning.;ENU=An approval request already exists.';
      ApporvalChainIsUnsupportedMsg@1016 : TextConst '@@@=Only Direct Approver is supported as Approver Limit Type option for Gen. Journal Batch DEFAULT, CASH. The approval request will be approved automatically.;DAN=Kun Direkte godkender underst�ttes i indstillingen Godkenders gr�nsetype for %1. Godkendelsesanmodningen godkendes automatisk.;ENU=Only Direct Approver is supported as Approver Limit Type option for %1. The approval request will be approved automatically.';
      RecHasBeenApprovedMsg@1008 : TextConst '@@@="%1 = Record Id";DAN=%1 er blevet godkendt.;ENU=%1 has been approved.';
      NoPermissionToDelegateErr@1014 : TextConst 'DAN=Du har ikke tilladelse til at uddelegere �n eller flere af de valgte godkendelsesanmodninger.;ENU=You do not have permission to delegate one or more of the selected approval requests.';
      NothingToApproveErr@1021 : TextConst 'DAN=Der er intet at godkende.;ENU=There is nothing to approve.';

    [Integration]
    [External]
    PROCEDURE OnSendPurchaseDocForApproval@3(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnSendSalesDocForApproval@10(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnSendIncomingDocForApproval@191(VAR IncomingDocument@1000 : Record 130);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCancelPurchaseApprovalRequest@4(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCancelSalesApprovalRequest@34(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCancelIncomingDocApprovalRequest@100(VAR IncomingDocument@1000 : Record 130);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnSendCustomerForApproval@52(VAR Customer@1000 : Record 18);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnSendVendorForApproval@56(VAR Vendor@1000 : Record 23);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnSendItemForApproval@64(VAR Item@1000 : Record 27);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCancelCustomerApprovalRequest@51(VAR Customer@1000 : Record 18);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCancelVendorApprovalRequest@67(VAR Vendor@1000 : Record 23);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCancelItemApprovalRequest@69(VAR Item@1000 : Record 27);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnSendGeneralJournalBatchForApproval@62(VAR GenJournalBatch@1000 : Record 232);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCancelGeneralJournalBatchApprovalRequest@61(VAR GenJournalBatch@1000 : Record 232);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnSendGeneralJournalLineForApproval@65(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnCancelGeneralJournalLineApprovalRequest@63(VAR GenJournalLine@1000 : Record 81);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnApproveApprovalRequest@68(VAR ApprovalEntry@1000 : Record 454);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnRejectApprovalRequest@76(VAR ApprovalEntry@1000 : Record 454);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnDelegateApprovalRequest@78(VAR ApprovalEntry@1000 : Record 454);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnRenameRecordInApprovalRequest@96(OldRecordId@1000 : RecordID;NewRecordId@1001 : RecordID);
    BEGIN
    END;

    [Integration]
    [External]
    PROCEDURE OnDeleteRecordInApprovalRequest@97(RecordIDToApprove@1000 : RecordID);
    BEGIN
    END;

    [External]
    PROCEDURE ApproveRecordApprovalRequest@48(RecordID@1000 : RecordID);
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry,RecordID) THEN
        ERROR(NoReqToApproveErr);

      ApprovalEntry.SETRECFILTER;
      ApproveApprovalRequests(ApprovalEntry);
    END;

    [External]
    PROCEDURE ApproveGenJournalLineRequest@103(GenJournalLine@1000 : Record 81);
    VAR
      GenJournalBatch@1001 : Record 232;
      ApprovalEntry@1002 : Record 454;
    BEGIN
      GenJournalBatch.GET(GenJournalLine."Journal Template Name",GenJournalLine."Journal Batch Name");
      IF FindOpenApprovalEntryForCurrUser(ApprovalEntry,GenJournalBatch.RECORDID) THEN
        ApproveRecordApprovalRequest(GenJournalBatch.RECORDID);
      CLEAR(ApprovalEntry);
      IF FindOpenApprovalEntryForCurrUser(ApprovalEntry,GenJournalLine.RECORDID) THEN
        ApproveRecordApprovalRequest(GenJournalLine.RECORDID);
    END;

    [External]
    PROCEDURE RejectRecordApprovalRequest@57(RecordID@1000 : RecordID);
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry,RecordID) THEN
        ERROR(NoReqToRejectErr);

      ApprovalEntry.SETRECFILTER;
      RejectApprovalRequests(ApprovalEntry);
    END;

    [External]
    PROCEDURE RejectGenJournalLineRequest@104(GenJournalLine@1002 : Record 81);
    VAR
      GenJournalBatch@1001 : Record 232;
      ApprovalEntry@1000 : Record 454;
    BEGIN
      GenJournalBatch.GET(GenJournalLine."Journal Template Name",GenJournalLine."Journal Batch Name");
      IF FindOpenApprovalEntryForCurrUser(ApprovalEntry,GenJournalBatch.RECORDID) THEN
        RejectRecordApprovalRequest(GenJournalBatch.RECORDID);
      CLEAR(ApprovalEntry);
      IF FindOpenApprovalEntryForCurrUser(ApprovalEntry,GenJournalLine.RECORDID) THEN
        RejectRecordApprovalRequest(GenJournalLine.RECORDID);
    END;

    [External]
    PROCEDURE DelegateRecordApprovalRequest@58(RecordID@1000 : RecordID);
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      IF NOT FindOpenApprovalEntryForCurrUser(ApprovalEntry,RecordID) THEN
        ERROR(NoReqToDelegateErr);

      ApprovalEntry.SETRECFILTER;
      DelegateApprovalRequests(ApprovalEntry);
    END;

    [External]
    PROCEDURE DelegateGenJournalLineRequest@29(GenJournalLine@1000 : Record 81);
    VAR
      GenJournalBatch@1002 : Record 232;
      ApprovalEntry@1001 : Record 454;
    BEGIN
      GenJournalBatch.GET(GenJournalLine."Journal Template Name",GenJournalLine."Journal Batch Name");
      IF FindOpenApprovalEntryForCurrUser(ApprovalEntry,GenJournalBatch.RECORDID) THEN
        DelegateRecordApprovalRequest(GenJournalBatch.RECORDID);
      CLEAR(ApprovalEntry);
      IF FindOpenApprovalEntryForCurrUser(ApprovalEntry,GenJournalLine.RECORDID) THEN
        DelegateRecordApprovalRequest(GenJournalLine.RECORDID);
    END;

    [External]
    PROCEDURE ApproveApprovalRequests@108(VAR ApprovalEntry@1000 : Record 454);
    BEGIN
      IF ApprovalEntry.FINDSET(TRUE) THEN
        REPEAT
          ApproveSelectedApprovalRequest(ApprovalEntry);
        UNTIL ApprovalEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE RejectApprovalRequests@28(VAR ApprovalEntry@1000 : Record 454);
    BEGIN
      IF ApprovalEntry.FINDSET(TRUE) THEN
        REPEAT
          RejectSelectedApprovalRequest(ApprovalEntry);
        UNTIL ApprovalEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE DelegateApprovalRequests@27(VAR ApprovalEntry@1000 : Record 454);
    BEGIN
      IF ApprovalEntry.FINDSET(TRUE) THEN BEGIN
        REPEAT
          DelegateSelectedApprovalRequest(ApprovalEntry,TRUE);
        UNTIL ApprovalEntry.NEXT = 0;
        MESSAGE(ApprovalsDelegatedMsg);
      END;
    END;

    LOCAL PROCEDURE ApproveSelectedApprovalRequest@5(VAR ApprovalEntry@1000 : Record 454);
    BEGIN
      IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
        ERROR(ApproveOnlyOpenRequestsErr);

      IF ApprovalEntry."Approver ID" <> USERID THEN
        CheckUserAsApprovalAdministrator;

      ApprovalEntry.VALIDATE(Status,ApprovalEntry.Status::Approved);
      ApprovalEntry.MODIFY(TRUE);
      OnApproveApprovalRequest(ApprovalEntry);
    END;

    LOCAL PROCEDURE RejectSelectedApprovalRequest@2(VAR ApprovalEntry@1000 : Record 454);
    BEGIN
      IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
        ERROR(RejectOnlyOpenRequestsErr);

      IF ApprovalEntry."Approver ID" <> USERID THEN
        CheckUserAsApprovalAdministrator;

      OnRejectApprovalRequest(ApprovalEntry);
      ApprovalEntry.GET(ApprovalEntry."Entry No.");
      ApprovalEntry.VALIDATE(Status,ApprovalEntry.Status::Rejected);
      ApprovalEntry.MODIFY(TRUE);
    END;

    [External]
    PROCEDURE DelegateSelectedApprovalRequest@1(VAR ApprovalEntry@1000 : Record 454;CheckCurrentUser@1001 : Boolean);
    BEGIN
      IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
        ERROR(DelegateOnlyOpenRequestsErr);

      IF CheckCurrentUser AND (NOT ApprovalEntry.CanCurrentUserEdit) THEN
        ERROR(NoPermissionToDelegateErr);

      SubstituteUserIdForApprovalEntry(ApprovalEntry)
    END;

    LOCAL PROCEDURE SubstituteUserIdForApprovalEntry@86(ApprovalEntry@1000 : Record 454);
    VAR
      UserSetup@1001 : Record 91;
      ApprovalAdminUserSetup@1002 : Record 91;
    BEGIN
      IF NOT UserSetup.GET(ApprovalEntry."Approver ID") THEN
        ERROR(ApproverUserIdNotInSetupErr,ApprovalEntry."Sender ID");

      IF UserSetup.Substitute = '' THEN
        IF UserSetup."Approver ID" = '' THEN BEGIN
          ApprovalAdminUserSetup.SETRANGE("Approval Administrator",TRUE);
          IF ApprovalAdminUserSetup.FINDFIRST THEN
            UserSetup.GET(ApprovalAdminUserSetup."User ID")
          ELSE
            ERROR(SubstituteNotFoundErr,UserSetup."User ID");
        END ELSE
          UserSetup.GET(UserSetup."Approver ID")
      ELSE
        UserSetup.GET(UserSetup.Substitute);

      ApprovalEntry."Approver ID" := UserSetup."User ID";
      ApprovalEntry.MODIFY(TRUE);
      OnDelegateApprovalRequest(ApprovalEntry);
    END;

    [External]
    PROCEDURE FindOpenApprovalEntryForCurrUser@43(VAR ApprovalEntry@1002 : Record 454;RecordID@1000 : RecordID) : Boolean;
    BEGIN
      ApprovalEntry.SETRANGE("Table ID",RecordID.TABLENO);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecordID);
      ApprovalEntry.SETRANGE(Status,ApprovalEntry.Status::Open);
      ApprovalEntry.SETRANGE("Approver ID",USERID);
      ApprovalEntry.SETRANGE("Related to Change",FALSE);

      EXIT(ApprovalEntry.FINDFIRST);
    END;

    [External]
    PROCEDURE FindApprovalEntryForCurrUser@101(VAR ApprovalEntry@1002 : Record 454;RecordID@1000 : RecordID) : Boolean;
    BEGIN
      ApprovalEntry.SETRANGE("Table ID",RecordID.TABLENO);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecordID);
      ApprovalEntry.SETRANGE("Approver ID",USERID);

      EXIT(ApprovalEntry.FINDFIRST);
    END;

    LOCAL PROCEDURE ShowPurchApprovalStatus@9(PurchaseHeader@1000 : Record 38);
    BEGIN
      PurchaseHeader.FIND;

      CASE PurchaseHeader.Status OF
        PurchaseHeader.Status::Released:
          MESSAGE(DocStatusChangedMsg,PurchaseHeader."Document Type",PurchaseHeader."No.",PurchaseHeader.Status);
        PurchaseHeader.Status::"Pending Approval":
          IF HasOpenOrPendingApprovalEntries(PurchaseHeader.RECORDID) THEN
            MESSAGE(PendingApprovalMsg);
        PurchaseHeader.Status::"Pending Prepayment":
          MESSAGE(DocStatusChangedMsg,PurchaseHeader."Document Type",PurchaseHeader."No.",PurchaseHeader.Status);
      END;
    END;

    LOCAL PROCEDURE ShowSalesApprovalStatus@26(SalesHeader@1000 : Record 36);
    BEGIN
      SalesHeader.FIND;

      CASE SalesHeader.Status OF
        SalesHeader.Status::Released:
          MESSAGE(DocStatusChangedMsg,SalesHeader."Document Type",SalesHeader."No.",SalesHeader.Status);
        SalesHeader.Status::"Pending Approval":
          IF HasOpenOrPendingApprovalEntries(SalesHeader.RECORDID) THEN
            MESSAGE(PendingApprovalMsg);
        SalesHeader.Status::"Pending Prepayment":
          MESSAGE(DocStatusChangedMsg,SalesHeader."Document Type",SalesHeader."No.",SalesHeader.Status);
      END;
    END;

    LOCAL PROCEDURE ShowApprovalStatus@107(RecId@1000 : RecordID;WorkflowInstanceId@1001 : GUID);
    BEGIN
      IF HasPendingApprovalEntriesForWorkflow(RecId,WorkflowInstanceId) THEN
        MESSAGE(PendingApprovalMsg)
      ELSE
        MESSAGE(RecHasBeenApprovedMsg,FORMAT(RecId,0,1));
    END;

    [External]
    PROCEDURE ApproveApprovalRequestsForRecord@186(RecRef@1000 : RecordRef;WorkflowStepInstance@1001 : Record 1504);
    VAR
      ApprovalEntry@1002 : Record 454;
    BEGIN
      ApprovalEntry.SETCURRENTKEY("Table ID","Document Type","Document No.","Sequence No.");
      ApprovalEntry.SETRANGE("Table ID",RecRef.NUMBER);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecRef.RECORDID);
      ApprovalEntry.SETFILTER(Status,'%1|%2',ApprovalEntry.Status::Created,ApprovalEntry.Status::Open);
      ApprovalEntry.SETRANGE("Workflow Step Instance ID",WorkflowStepInstance.ID);
      IF ApprovalEntry.FINDSET(TRUE) THEN
        REPEAT
          ApprovalEntry.VALIDATE(Status,ApprovalEntry.Status::Approved);
          ApprovalEntry.MODIFY(TRUE);
          CreateApprovalEntryNotification(ApprovalEntry,WorkflowStepInstance);
        UNTIL ApprovalEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE CancelApprovalRequestsForRecord@8(RecRef@1000 : RecordRef;WorkflowStepInstance@1001 : Record 1504);
    VAR
      ApprovalEntry@1002 : Record 454;
      OldStatus@1003 : Option;
    BEGIN
      ApprovalEntry.SETCURRENTKEY("Table ID","Document Type","Document No.","Sequence No.");
      ApprovalEntry.SETRANGE("Table ID",RecRef.NUMBER);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecRef.RECORDID);
      ApprovalEntry.SETFILTER(Status,'<>%1&<>%2',ApprovalEntry.Status::Rejected,ApprovalEntry.Status::Canceled);
      ApprovalEntry.SETRANGE("Workflow Step Instance ID",WorkflowStepInstance.ID);
      IF ApprovalEntry.FINDSET(TRUE) THEN
        REPEAT
          OldStatus := ApprovalEntry.Status;
          ApprovalEntry.VALIDATE(Status,ApprovalEntry.Status::Canceled);
          ApprovalEntry.MODIFY(TRUE);
          IF OldStatus IN [ApprovalEntry.Status::Open,ApprovalEntry.Status::Approved] THEN
            CreateApprovalEntryNotification(ApprovalEntry,WorkflowStepInstance);
        UNTIL ApprovalEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE RejectApprovalRequestsForRecord@7(RecRef@1000 : RecordRef;WorkflowStepInstance@1001 : Record 1504);
    VAR
      ApprovalEntry@1002 : Record 454;
      OldStatus@1003 : Option;
    BEGIN
      ApprovalEntry.SETCURRENTKEY("Table ID","Document Type","Document No.","Sequence No.");
      ApprovalEntry.SETRANGE("Table ID",RecRef.NUMBER);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecRef.RECORDID);
      ApprovalEntry.SETFILTER(Status,'<>%1&<>%2',ApprovalEntry.Status::Rejected,ApprovalEntry.Status::Canceled);
      ApprovalEntry.SETRANGE("Workflow Step Instance ID",WorkflowStepInstance.ID);
      IF ApprovalEntry.FINDSET(TRUE) THEN BEGIN
        REPEAT
          OldStatus := ApprovalEntry.Status;
          ApprovalEntry.VALIDATE(Status,ApprovalEntry.Status::Rejected);
          ApprovalEntry.MODIFY(TRUE);
          IF (OldStatus IN [ApprovalEntry.Status::Open,ApprovalEntry.Status::Approved]) AND
             (ApprovalEntry."Approver ID" <> USERID)
          THEN
            CreateApprovalEntryNotification(ApprovalEntry,WorkflowStepInstance);
        UNTIL ApprovalEntry.NEXT = 0;
        IF ApprovalEntry."Approver ID" <> ApprovalEntry."Sender ID" THEN BEGIN
          ApprovalEntry."Approver ID" := ApprovalEntry."Sender ID";
          CreateApprovalEntryNotification(ApprovalEntry,WorkflowStepInstance);
        END;
      END;
    END;

    [External]
    PROCEDURE SendApprovalRequestFromRecord@33(RecRef@1004 : RecordRef;WorkflowStepInstance@1002 : Record 1504);
    VAR
      ApprovalEntry@1001 : Record 454;
      ApprovalEntry2@1000 : Record 454;
    BEGIN
      ApprovalEntry.SETCURRENTKEY("Table ID","Record ID to Approve",Status,"Workflow Step Instance ID","Sequence No.");
      ApprovalEntry.SETRANGE("Table ID",RecRef.NUMBER);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecRef.RECORDID);
      ApprovalEntry.SETRANGE(Status,ApprovalEntry.Status::Created);
      ApprovalEntry.SETRANGE("Workflow Step Instance ID",WorkflowStepInstance.ID);

      IF ApprovalEntry.FINDFIRST THEN BEGIN
        ApprovalEntry2.COPYFILTERS(ApprovalEntry);
        ApprovalEntry2.SETRANGE("Sequence No.",ApprovalEntry."Sequence No.");
        IF ApprovalEntry2.FINDSET(TRUE) THEN
          REPEAT
            ApprovalEntry2.VALIDATE(Status,ApprovalEntry2.Status::Open);
            ApprovalEntry2.MODIFY(TRUE);
            CreateApprovalEntryNotification(ApprovalEntry2,WorkflowStepInstance);
          UNTIL ApprovalEntry2.NEXT = 0;
        EXIT;
      END;

      ApprovalEntry.SETRANGE(Status,ApprovalEntry.Status::Approved);
      IF ApprovalEntry.FINDLAST THEN
        OnApproveApprovalRequest(ApprovalEntry)
      ELSE
        ERROR(NoApprovalRequestsFoundErr);
    END;

    [External]
    PROCEDURE SendApprovalRequestFromApprovalEntry@41(ApprovalEntry@1000 : Record 454;WorkflowStepInstance@1002 : Record 1504);
    VAR
      ApprovalEntry2@1001 : Record 454;
      ApprovalEntry3@1003 : Record 454;
    BEGIN
      IF ApprovalEntry.Status = ApprovalEntry.Status::Open THEN BEGIN
        CreateApprovalEntryNotification(ApprovalEntry,WorkflowStepInstance);
        EXIT;
      END;

      ApprovalEntry2.SETCURRENTKEY("Table ID","Document Type","Document No.","Sequence No.");
      ApprovalEntry2.SETRANGE("Record ID to Approve",ApprovalEntry."Record ID to Approve");
      ApprovalEntry2.SETRANGE(Status,ApprovalEntry.Status::Created);

      IF ApprovalEntry2.FINDFIRST THEN BEGIN
        ApprovalEntry3.COPYFILTERS(ApprovalEntry2);
        ApprovalEntry3.SETRANGE("Sequence No.",ApprovalEntry2."Sequence No.");
        IF ApprovalEntry3.FINDSET THEN
          REPEAT
            ApprovalEntry3.VALIDATE(Status,ApprovalEntry3.Status::Open);
            ApprovalEntry3.MODIFY(TRUE);
            CreateApprovalEntryNotification(ApprovalEntry3,WorkflowStepInstance);
          UNTIL ApprovalEntry3.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CreateApprovalRequests@6(RecRef@1000 : RecordRef;WorkflowStepInstance@1001 : Record 1504);
    VAR
      WorkflowStepArgument@1003 : Record 1523;
      ApprovalEntryArgument@1002 : Record 454;
    BEGIN
      PopulateApprovalEntryArgument(RecRef,WorkflowStepInstance,ApprovalEntryArgument);

      IF WorkflowStepArgument.GET(WorkflowStepInstance.Argument) THEN
        CASE WorkflowStepArgument."Approver Type" OF
          WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser":
            CreateApprReqForApprTypeSalespersPurchaser(WorkflowStepArgument,ApprovalEntryArgument);
          WorkflowStepArgument."Approver Type"::Approver:
            CreateApprReqForApprTypeApprover(WorkflowStepArgument,ApprovalEntryArgument);
          WorkflowStepArgument."Approver Type"::"Workflow User Group":
            CreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument,ApprovalEntryArgument);
        END;

      IF WorkflowStepArgument."Show Confirmation Message" THEN
        InformUserOnStatusChange(RecRef,WorkflowStepInstance.ID);
    END;

    [Internal]
    PROCEDURE CreateAndAutomaticallyApproveRequest@44(RecRef@1000 : RecordRef;WorkflowStepInstance@1001 : Record 1504);
    VAR
      ApprovalEntryArgument@1002 : Record 454;
      WorkflowStepArgument@1003 : Record 1523;
    BEGIN
      PopulateApprovalEntryArgument(RecRef,WorkflowStepInstance,ApprovalEntryArgument);
      IF NOT WorkflowStepArgument.GET(WorkflowStepInstance.Argument) THEN
        WorkflowStepArgument.INIT;

      CreateApprovalRequestForUser(WorkflowStepArgument,ApprovalEntryArgument);

      InformUserOnStatusChange(RecRef,WorkflowStepInstance.ID);
    END;

    LOCAL PROCEDURE CreateApprReqForApprTypeSalespersPurchaser@32(WorkflowStepArgument@1001 : Record 1523;ApprovalEntryArgument@1002 : Record 454);
    BEGIN
      ApprovalEntryArgument.TESTFIELD("Salespers./Purch. Code");

      CASE WorkflowStepArgument."Approver Limit Type" OF
        WorkflowStepArgument."Approver Limit Type"::"Approver Chain":
          BEGIN
            CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument,ApprovalEntryArgument);
            CreateApprovalRequestForChainOfApprovers(WorkflowStepArgument,ApprovalEntryArgument);
          END;
        WorkflowStepArgument."Approver Limit Type"::"Direct Approver":
          CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument,ApprovalEntryArgument);
        WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver":
          BEGIN
            CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument,ApprovalEntryArgument);
            CreateApprovalRequestForApproverWithSufficientLimit(WorkflowStepArgument,ApprovalEntryArgument);
          END;
        WorkflowStepArgument."Approver Limit Type"::"Specific Approver":
          BEGIN
            CreateApprovalRequestForSalespersPurchaser(WorkflowStepArgument,ApprovalEntryArgument);
            CreateApprovalRequestForSpecificUser(WorkflowStepArgument,ApprovalEntryArgument);
          END;
      END;
    END;

    LOCAL PROCEDURE CreateApprReqForApprTypeApprover@31(WorkflowStepArgument@1001 : Record 1523;ApprovalEntryArgument@1000 : Record 454);
    BEGIN
      CASE WorkflowStepArgument."Approver Limit Type" OF
        WorkflowStepArgument."Approver Limit Type"::"Approver Chain":
          BEGIN
            CreateApprovalRequestForUser(WorkflowStepArgument,ApprovalEntryArgument);
            CreateApprovalRequestForChainOfApprovers(WorkflowStepArgument,ApprovalEntryArgument);
          END;
        WorkflowStepArgument."Approver Limit Type"::"Direct Approver":
          CreateApprovalRequestForApprover(WorkflowStepArgument,ApprovalEntryArgument);
        WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver":
          BEGIN
            CreateApprovalRequestForUser(WorkflowStepArgument,ApprovalEntryArgument);
            CreateApprovalRequestForApproverWithSufficientLimit(WorkflowStepArgument,ApprovalEntryArgument);
          END;
        WorkflowStepArgument."Approver Limit Type"::"Specific Approver":
          CreateApprovalRequestForSpecificUser(WorkflowStepArgument,ApprovalEntryArgument);
      END;
    END;

    LOCAL PROCEDURE CreateApprReqForApprTypeWorkflowUserGroup@49(WorkflowStepArgument@1001 : Record 1523;ApprovalEntryArgument@1000 : Record 454);
    VAR
      UserSetup@1004 : Record 91;
      WorkflowUserGroupMember@1006 : Record 1541;
      ApproverId@1003 : Code[50];
      SequenceNo@1002 : Integer;
    BEGIN
      SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

      WITH WorkflowUserGroupMember DO BEGIN
        SETCURRENTKEY("Workflow User Group Code","Sequence No.");
        SETRANGE("Workflow User Group Code",WorkflowStepArgument."Workflow User Group Code");

        IF NOT FINDSET THEN
          ERROR(NoWFUserGroupMembersErr);

        REPEAT
          ApproverId := "User Name";
          IF NOT UserSetup.GET(ApproverId) THEN
            ERROR(WFUserGroupNotInSetupErr,ApproverId);
          MakeApprovalEntry(ApprovalEntryArgument,SequenceNo + "Sequence No.",ApproverId,WorkflowStepArgument);
        UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CreateApprovalRequestForChainOfApprovers@18(WorkflowStepArgument@1008 : Record 1523;ApprovalEntryArgument@1000 : Record 454);
    BEGIN
      CreateApprovalRequestForApproverChain(WorkflowStepArgument,ApprovalEntryArgument,FALSE);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForApproverWithSufficientLimit@45(WorkflowStepArgument@1008 : Record 1523;ApprovalEntryArgument@1000 : Record 454);
    BEGIN
      CreateApprovalRequestForApproverChain(WorkflowStepArgument,ApprovalEntryArgument,TRUE);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForApproverChain@46(WorkflowStepArgument@1008 : Record 1523;ApprovalEntryArgument@1000 : Record 454;SufficientApproverOnly@1003 : Boolean);
    VAR
      ApprovalEntry@1001 : Record 454;
      UserSetup@1007 : Record 91;
      ApproverId@1002 : Code[50];
      SequenceNo@1006 : Integer;
    BEGIN
      ApproverId := USERID;

      WITH ApprovalEntry DO BEGIN
        SETCURRENTKEY("Record ID to Approve","Workflow Step Instance ID","Sequence No.");
        SETRANGE("Table ID",ApprovalEntryArgument."Table ID");
        SETRANGE("Record ID to Approve",ApprovalEntryArgument."Record ID to Approve");
        SETRANGE("Workflow Step Instance ID",ApprovalEntryArgument."Workflow Step Instance ID");
        SETRANGE(Status,Status::Created);
        IF FINDLAST THEN
          ApproverId := "Approver ID"
        ELSE
          IF (WorkflowStepArgument."Approver Type" = WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser") AND
             (WorkflowStepArgument."Approver Limit Type" = WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver")
          THEN BEGIN
            FindUserSetupBySalesPurchCode(UserSetup,ApprovalEntryArgument);
            ApproverId := UserSetup."User ID";
          END;
      END;

      IF NOT UserSetup.GET(ApproverId) THEN
        ERROR(ApproverUserIdNotInSetupErr,ApprovalEntry."Sender ID");

      IF NOT IsSufficientApprover(UserSetup,ApprovalEntryArgument) THEN
        REPEAT
          ApproverId := UserSetup."Approver ID";

          IF ApproverId = '' THEN
            ERROR(NoSuitableApproverFoundErr);

          IF NOT UserSetup.GET(ApproverId) THEN
            ERROR(ApproverUserIdNotInSetupErr,UserSetup."User ID");

          // Approval Entry should not be created only when IsSufficientApprover is false and SufficientApproverOnly is true
          IF IsSufficientApprover(UserSetup,ApprovalEntryArgument) OR (NOT SufficientApproverOnly) THEN BEGIN
            SequenceNo := GetLastSequenceNo(ApprovalEntryArgument) + 1;
            MakeApprovalEntry(ApprovalEntryArgument,SequenceNo,ApproverId,WorkflowStepArgument);
          END;

        UNTIL IsSufficientApprover(UserSetup,ApprovalEntryArgument);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForApprover@19(WorkflowStepArgument@1001 : Record 1523;ApprovalEntryArgument@1000 : Record 454);
    VAR
      UserSetup@1006 : Record 91;
      UsrId@1005 : Code[50];
      SequenceNo@1004 : Integer;
    BEGIN
      UsrId := USERID;

      SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

      IF NOT UserSetup.GET(USERID) THEN
        ERROR(UserIdNotInSetupErr,UsrId);

      UsrId := UserSetup."Approver ID";
      IF NOT UserSetup.GET(UsrId) THEN BEGIN
        IF NOT UserSetup."Approval Administrator" THEN
          ERROR(ApproverUserIdNotInSetupErr,UserSetup."User ID");
        UsrId := USERID;
      END;

      SequenceNo += 1;
      MakeApprovalEntry(ApprovalEntryArgument,SequenceNo,UsrId,WorkflowStepArgument);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForSalespersPurchaser@21(WorkflowStepArgument@1006 : Record 1523;ApprovalEntryArgument@1000 : Record 454);
    VAR
      UserSetup@1001 : Record 91;
      SequenceNo@1002 : Integer;
    BEGIN
      SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

      FindUserSetupBySalesPurchCode(UserSetup,ApprovalEntryArgument);

      SequenceNo += 1;

      IF WorkflowStepArgument."Approver Limit Type" = WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver" THEN BEGIN
        IF IsSufficientApprover(UserSetup,ApprovalEntryArgument) THEN
          MakeApprovalEntry(ApprovalEntryArgument,SequenceNo,UserSetup."User ID",WorkflowStepArgument);
      END ELSE
        MakeApprovalEntry(ApprovalEntryArgument,SequenceNo,UserSetup."User ID",WorkflowStepArgument);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForUser@22(WorkflowStepArgument@1001 : Record 1523;ApprovalEntryArgument@1000 : Record 454);
    VAR
      SequenceNo@1002 : Integer;
    BEGIN
      SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

      SequenceNo += 1;
      MakeApprovalEntry(ApprovalEntryArgument,SequenceNo,USERID,WorkflowStepArgument);
    END;

    LOCAL PROCEDURE CreateApprovalRequestForSpecificUser@118(WorkflowStepArgument@1001 : Record 1523;ApprovalEntryArgument@1000 : Record 454);
    VAR
      UserSetup@1006 : Record 91;
      UsrId@1005 : Code[50];
      SequenceNo@1004 : Integer;
    BEGIN
      UsrId := WorkflowStepArgument."Approver User ID";

      SequenceNo := GetLastSequenceNo(ApprovalEntryArgument);

      IF NOT UserSetup.GET(UsrId) THEN
        ERROR(UserIdNotInSetupErr,UsrId);

      SequenceNo += 1;
      MakeApprovalEntry(ApprovalEntryArgument,SequenceNo,UsrId,WorkflowStepArgument);
    END;

    LOCAL PROCEDURE MakeApprovalEntry@23(ApprovalEntryArgument@1007 : Record 454;SequenceNo@1001 : Integer;ApproverId@1003 : Code[50];WorkflowStepArgument@1005 : Record 1523);
    VAR
      ApprovalEntry@1002 : Record 454;
    BEGIN
      WITH ApprovalEntry DO BEGIN
        "Table ID" := ApprovalEntryArgument."Table ID";
        "Document Type" := ApprovalEntryArgument."Document Type";
        "Document No." := ApprovalEntryArgument."Document No.";
        "Salespers./Purch. Code" := ApprovalEntryArgument."Salespers./Purch. Code";
        "Sequence No." := SequenceNo;
        "Sender ID" := USERID;
        Amount := ApprovalEntryArgument.Amount;
        "Amount (LCY)" := ApprovalEntryArgument."Amount (LCY)";
        "Currency Code" := ApprovalEntryArgument."Currency Code";
        "Approver ID" := ApproverId;
        "Workflow Step Instance ID" := ApprovalEntryArgument."Workflow Step Instance ID";
        IF ApproverId = USERID THEN
          Status := Status::Approved
        ELSE
          Status := Status::Created;
        "Date-Time Sent for Approval" := CREATEDATETIME(TODAY,TIME);
        "Last Date-Time Modified" := CREATEDATETIME(TODAY,TIME);
        "Last Modified By User ID" := USERID;
        "Due Date" := CALCDATE(WorkflowStepArgument."Due Date Formula",TODAY);

        CASE WorkflowStepArgument."Delegate After" OF
          WorkflowStepArgument."Delegate After"::Never:
            EVALUATE("Delegation Date Formula",'');
          WorkflowStepArgument."Delegate After"::"1 day":
            EVALUATE("Delegation Date Formula",'<1D>');
          WorkflowStepArgument."Delegate After"::"2 days":
            EVALUATE("Delegation Date Formula",'<2D>');
          WorkflowStepArgument."Delegate After"::"5 days":
            EVALUATE("Delegation Date Formula",'<5D>');
          ELSE
            EVALUATE("Delegation Date Formula",'');
        END;
        "Available Credit Limit (LCY)" := ApprovalEntryArgument."Available Credit Limit (LCY)";
        SetApproverType(WorkflowStepArgument,ApprovalEntry);
        SetLimitType(WorkflowStepArgument,ApprovalEntry);
        "Record ID to Approve" := ApprovalEntryArgument."Record ID to Approve";
        "Approval Code" := ApprovalEntryArgument."Approval Code";
        INSERT(TRUE);
      END;
    END;

    [Internal]
    PROCEDURE CalcPurchaseDocAmount@24(PurchaseHeader@1002 : Record 38;VAR ApprovalAmount@1001 : Decimal;VAR ApprovalAmountLCY@1000 : Decimal);
    VAR
      TempPurchaseLine@1009 : TEMPORARY Record 39;
      TotalPurchaseLine@1008 : Record 39;
      TotalPurchaseLineLCY@1007 : Record 39;
      PurchPost@1006 : Codeunit 90;
      TempAmount@1005 : Decimal;
      VAtText@1004 : Text[30];
    BEGIN
      PurchaseHeader.CalcInvDiscForHeader;
      PurchPost.GetPurchLines(PurchaseHeader,TempPurchaseLine,0);
      CLEAR(PurchPost);
      PurchPost.SumPurchLinesTemp(
        PurchaseHeader,TempPurchaseLine,0,TotalPurchaseLine,TotalPurchaseLineLCY,
        TempAmount,VAtText);
      ApprovalAmount := TotalPurchaseLine.Amount;
      ApprovalAmountLCY := TotalPurchaseLineLCY.Amount;
    END;

    [Internal]
    PROCEDURE CalcSalesDocAmount@82(SalesHeader@1000 : Record 36;VAR ApprovalAmount@1001 : Decimal;VAR ApprovalAmountLCY@1002 : Decimal);
    VAR
      TempSalesLine@1009 : TEMPORARY Record 37;
      TotalSalesLine@1008 : Record 37;
      TotalSalesLineLCY@1007 : Record 37;
      SalesPost@1006 : Codeunit 80;
      TempAmount@1005 : ARRAY [5] OF Decimal;
      VAtText@1004 : Text[30];
    BEGIN
      SalesHeader.CalcInvDiscForHeader;
      SalesPost.GetSalesLines(SalesHeader,TempSalesLine,0);
      CLEAR(SalesPost);
      SalesPost.SumSalesLinesTemp(
        SalesHeader,TempSalesLine,0,TotalSalesLine,TotalSalesLineLCY,
        TempAmount[1],VAtText,TempAmount[2],TempAmount[3],TempAmount[4]);
      ApprovalAmount := TotalSalesLine.Amount;
      ApprovalAmountLCY := TotalSalesLineLCY.Amount;
    END;

    LOCAL PROCEDURE PopulateApprovalEntryArgument@80(RecRef@1000 : RecordRef;WorkflowStepInstance@1009 : Record 1504;VAR ApprovalEntryArgument@1001 : Record 454);
    VAR
      Customer@1006 : Record 18;
      GenJournalBatch@1008 : Record 232;
      GenJournalLine@1007 : Record 81;
      PurchaseHeader@1003 : Record 38;
      SalesHeader@1004 : Record 36;
      IncomingDocument@1010 : Record 130;
      ApprovalAmount@1002 : Decimal;
      ApprovalAmountLCY@1005 : Decimal;
    BEGIN
      ApprovalEntryArgument.INIT;
      ApprovalEntryArgument."Table ID" := RecRef.NUMBER;
      ApprovalEntryArgument."Record ID to Approve" := RecRef.RECORDID;
      ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
      ApprovalEntryArgument."Approval Code" := WorkflowStepInstance."Workflow Code";
      ApprovalEntryArgument."Workflow Step Instance ID" := WorkflowStepInstance.ID;

      CASE RecRef.NUMBER OF
        DATABASE::"Purchase Header":
          BEGIN
            RecRef.SETTABLE(PurchaseHeader);
            CalcPurchaseDocAmount(PurchaseHeader,ApprovalAmount,ApprovalAmountLCY);
            ApprovalEntryArgument."Document Type" := PurchaseHeader."Document Type";
            ApprovalEntryArgument."Document No." := PurchaseHeader."No.";
            ApprovalEntryArgument."Salespers./Purch. Code" := PurchaseHeader."Purchaser Code";
            ApprovalEntryArgument.Amount := ApprovalAmount;
            ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
            ApprovalEntryArgument."Currency Code" := PurchaseHeader."Currency Code";
          END;
        DATABASE::"Sales Header":
          BEGIN
            RecRef.SETTABLE(SalesHeader);
            CalcSalesDocAmount(SalesHeader,ApprovalAmount,ApprovalAmountLCY);
            ApprovalEntryArgument."Document Type" := SalesHeader."Document Type";
            ApprovalEntryArgument."Document No." := SalesHeader."No.";
            ApprovalEntryArgument."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
            ApprovalEntryArgument.Amount := ApprovalAmount;
            ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
            ApprovalEntryArgument."Currency Code" := SalesHeader."Currency Code";
            ApprovalEntryArgument."Available Credit Limit (LCY)" := GetAvailableCreditLimit(SalesHeader);
          END;
        DATABASE::Customer:
          BEGIN
            RecRef.SETTABLE(Customer);
            ApprovalEntryArgument."Salespers./Purch. Code" := Customer."Salesperson Code";
            ApprovalEntryArgument."Currency Code" := Customer."Currency Code";
            ApprovalEntryArgument."Available Credit Limit (LCY)" := Customer.CalcAvailableCredit;
          END;
        DATABASE::"Gen. Journal Batch":
          RecRef.SETTABLE(GenJournalBatch);
        DATABASE::"Gen. Journal Line":
          BEGIN
            RecRef.SETTABLE(GenJournalLine);
            ApprovalEntryArgument."Document Type" := GenJournalLine."Document Type";
            ApprovalEntryArgument."Document No." := GenJournalLine."Document No.";
            ApprovalEntryArgument."Salespers./Purch. Code" := GenJournalLine."Salespers./Purch. Code";
            ApprovalEntryArgument.Amount := GenJournalLine.Amount;
            ApprovalEntryArgument."Amount (LCY)" := GenJournalLine."Amount (LCY)";
            ApprovalEntryArgument."Currency Code" := GenJournalLine."Currency Code";
          END;
        DATABASE::"Incoming Document":
          BEGIN
            RecRef.SETTABLE(IncomingDocument);
            ApprovalEntryArgument."Document No." := FORMAT(IncomingDocument."Entry No.");
          END;
      END;
    END;

    [External]
    PROCEDURE CreateApprovalEntryNotification@50(ApprovalEntry@1000 : Record 454;WorkflowStepInstance@1001 : Record 1504);
    VAR
      WorkflowStepArgument@1002 : Record 1523;
      NotificationEntry@1003 : Record 1511;
      UserSetup@1004 : Record 91;
    BEGIN
      IF NOT WorkflowStepArgument.GET(WorkflowStepInstance.Argument) THEN
        EXIT;

      IF WorkflowStepArgument."Notification User ID" = '' THEN BEGIN
        IF NOT UserSetup.GET(ApprovalEntry."Approver ID") THEN
          EXIT;
        WorkflowStepArgument.VALIDATE("Notification User ID",ApprovalEntry."Approver ID");
      END;

      ApprovalEntry.RESET;
      NotificationEntry.CreateNew(
        NotificationEntry.Type::Approval,WorkflowStepArgument."Notification User ID",
        ApprovalEntry,WorkflowStepArgument."Link Target Page",WorkflowStepArgument."Custom Link");
    END;

    LOCAL PROCEDURE SetApproverType@71(WorkflowStepArgument@1001 : Record 1523;VAR ApprovalEntry@1000 : Record 454);
    BEGIN
      CASE WorkflowStepArgument."Approver Type" OF
        WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser":
          ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::"Sales Pers./Purchaser";
        WorkflowStepArgument."Approver Type"::Approver:
          ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::Approver;
        WorkflowStepArgument."Approver Type"::"Workflow User Group":
          ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::"Workflow User Group";
      END;
    END;

    LOCAL PROCEDURE SetLimitType@81(WorkflowStepArgument@1000 : Record 1523;VAR ApprovalEntry@1001 : Record 454);
    BEGIN
      CASE WorkflowStepArgument."Approver Limit Type" OF
        WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
        WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver":
          ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"Approval Limits";
        WorkflowStepArgument."Approver Limit Type"::"Direct Approver":
          ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
        WorkflowStepArgument."Approver Limit Type"::"Specific Approver":
          ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
      END;

      IF ApprovalEntry."Approval Type" = ApprovalEntry."Approval Type"::"Workflow User Group" THEN
        ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
    END;

    LOCAL PROCEDURE IsSufficientPurchApprover@12(UserSetup@1000 : Record 91;DocumentType@1003 : Option;ApprovalAmountLCY@1002 : Decimal) : Boolean;
    VAR
      PurchaseHeader@1001 : Record 38;
    BEGIN
      IF UserSetup."User ID" = UserSetup."Approver ID" THEN
        EXIT(TRUE);

      CASE DocumentType OF
        PurchaseHeader."Document Type"::Quote:
          IF UserSetup."Unlimited Request Approval" OR
             ((ApprovalAmountLCY <= UserSetup."Request Amount Approval Limit") AND (UserSetup."Request Amount Approval Limit" <> 0))
          THEN
            EXIT(TRUE);
        ELSE
          IF UserSetup."Unlimited Purchase Approval" OR
             ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND (UserSetup."Purchase Amount Approval Limit" <> 0))
          THEN
            EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsSufficientSalesApprover@13(UserSetup@1000 : Record 91;ApprovalAmountLCY@1002 : Decimal) : Boolean;
    BEGIN
      IF UserSetup."User ID" = UserSetup."Approver ID" THEN
        EXIT(TRUE);

      IF UserSetup."Unlimited Sales Approval" OR
         ((ApprovalAmountLCY <= UserSetup."Sales Amount Approval Limit") AND (UserSetup."Sales Amount Approval Limit" <> 0))
      THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsSufficientGenJournalLineApprover@89(UserSetup@1000 : Record 91;ApprovalEntryArgument@1001 : Record 454) : Boolean;
    VAR
      GenJournalLine@1003 : Record 81;
      RecRef@1002 : RecordRef;
    BEGIN
      RecRef.GET(ApprovalEntryArgument."Record ID to Approve");
      RecRef.SETTABLE(GenJournalLine);

      IF GenJournalLine.IsForPurchase THEN
        EXIT(IsSufficientPurchApprover(UserSetup,ApprovalEntryArgument."Document Type",ApprovalEntryArgument."Amount (LCY)"));

      IF GenJournalLine.IsForSales THEN
        EXIT(IsSufficientSalesApprover(UserSetup,ApprovalEntryArgument."Amount (LCY)"));

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE IsSufficientApprover@20(UserSetup@1001 : Record 91;ApprovalEntryArgument@1003 : Record 454) : Boolean;
    BEGIN
      CASE ApprovalEntryArgument."Table ID" OF
        DATABASE::"Purchase Header":
          EXIT(IsSufficientPurchApprover(UserSetup,ApprovalEntryArgument."Document Type",ApprovalEntryArgument."Amount (LCY)"));
        DATABASE::"Sales Header":
          EXIT(IsSufficientSalesApprover(UserSetup,ApprovalEntryArgument."Amount (LCY)"));
        DATABASE::"Gen. Journal Batch":
          MESSAGE(ApporvalChainIsUnsupportedMsg,FORMAT(ApprovalEntryArgument."Record ID to Approve"));
        DATABASE::"Gen. Journal Line":
          EXIT(IsSufficientGenJournalLineApprover(UserSetup,ApprovalEntryArgument));
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE GetAvailableCreditLimit@25(SalesHeader@1000 : Record 36) : Decimal;
    BEGIN
      EXIT(SalesHeader.CheckAvailableCreditLimit);
    END;

    [External]
    PROCEDURE PrePostApprovalCheckSales@38(VAR SalesHeader@1000 : Record 36) : Boolean;
    BEGIN
      IF IsSalesHeaderPendingApproval(SalesHeader) THEN
        ERROR(SalesPrePostCheckErr,SalesHeader."Document Type",SalesHeader."No.");

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE PrePostApprovalCheckPurch@39(VAR PurchaseHeader@1001 : Record 38) : Boolean;
    BEGIN
      IF IsPurchaseHeaderPendingApproval(PurchaseHeader) THEN
        ERROR(PurchPrePostCheckErr,PurchaseHeader."Document Type",PurchaseHeader."No.");

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE IsIncomingDocApprovalsWorkflowEnabled@102(VAR IncomingDocument@1002 : Record 130) : Boolean;
    BEGIN
      EXIT(WorkflowManagement.CanExecuteWorkflow(IncomingDocument,WorkflowEventHandling.RunWorkflowOnSendIncomingDocForApprovalCode));
    END;

    [External]
    PROCEDURE IsPurchaseApprovalsWorkflowEnabled@59(VAR PurchaseHeader@1002 : Record 38) : Boolean;
    BEGIN
      EXIT(WorkflowManagement.CanExecuteWorkflow(PurchaseHeader,WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode));
    END;

    PROCEDURE IsPurchaseHeaderPendingApproval@113(VAR PurchaseHeader@1000 : Record 38) : Boolean;
    BEGIN
      IF PurchaseHeader.Status <> PurchaseHeader.Status::Open THEN
        EXIT(FALSE);

      EXIT(IsPurchaseApprovalsWorkflowEnabled(PurchaseHeader));
    END;

    [Internal]
    PROCEDURE IsSalesApprovalsWorkflowEnabled@17(VAR SalesHeader@1002 : Record 36) : Boolean;
    BEGIN
      EXIT(WorkflowManagement.CanExecuteWorkflow(SalesHeader,WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode));
    END;

    PROCEDURE IsSalesHeaderPendingApproval@119(VAR SalesHeader@1000 : Record 36) : Boolean;
    BEGIN
      IF SalesHeader.Status <> SalesHeader.Status::Open THEN
        EXIT(FALSE);

      EXIT(IsSalesApprovalsWorkflowEnabled(SalesHeader));
    END;

    [Internal]
    PROCEDURE IsOverdueNotificationsWorkflowEnabled@42() : Boolean;
    VAR
      ApprovalEntry@1000 : Record 454;
    BEGIN
      ApprovalEntry.INIT;
      EXIT(WorkflowManagement.WorkflowExists(ApprovalEntry,ApprovalEntry,
          WorkflowEventHandling.RunWorkflowOnSendOverdueNotificationsCode));
    END;

    [Internal]
    PROCEDURE IsGeneralJournalBatchApprovalsWorkflowEnabled@70(VAR GenJournalBatch@1002 : Record 232) : Boolean;
    BEGIN
      EXIT(WorkflowManagement.CanExecuteWorkflow(GenJournalBatch,
          WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode));
    END;

    [Internal]
    PROCEDURE IsGeneralJournalLineApprovalsWorkflowEnabled@72(VAR GenJournalLine@1002 : Record 81) : Boolean;
    BEGIN
      EXIT(WorkflowManagement.CanExecuteWorkflow(GenJournalLine,
          WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode));
    END;

    [External]
    PROCEDURE CheckPurchaseApprovalPossible@77(VAR PurchaseHeader@1002 : Record 38) : Boolean;
    BEGIN
      IF NOT IsPurchaseApprovalsWorkflowEnabled(PurchaseHeader) THEN
        ERROR(NoWorkflowEnabledErr);

      IF NOT PurchaseHeader.PurchLinesExist THEN
        ERROR(NothingToApproveErr);

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE CheckIncomingDocApprovalsWorkflowEnabled@192(VAR IncomingDocument@1002 : Record 130) : Boolean;
    BEGIN
      IF NOT IsIncomingDocApprovalsWorkflowEnabled(IncomingDocument) THEN
        ERROR(NoWorkflowEnabledErr);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CheckSalesApprovalPossible@155(VAR SalesHeader@1002 : Record 36) : Boolean;
    BEGIN
      IF NOT IsSalesApprovalsWorkflowEnabled(SalesHeader) THEN
        ERROR(NoWorkflowEnabledErr);

      IF NOT SalesHeader.SalesLinesExist THEN
        ERROR(NothingToApproveErr);

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE CheckCustomerApprovalsWorkflowEnabled@11(VAR Customer@1002 : Record 18) : Boolean;
    BEGIN
      IF NOT WorkflowManagement.CanExecuteWorkflow(Customer,WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode) THEN BEGIN
        IF WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer,WorkflowEventHandling.RunWorkflowOnCustomerChangedCode) THEN
          EXIT(FALSE);
        ERROR(NoWorkflowEnabledErr);
      END;
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE CheckVendorApprovalsWorkflowEnabled@83(VAR Vendor@1002 : Record 23) : Boolean;
    BEGIN
      IF NOT WorkflowManagement.CanExecuteWorkflow(Vendor,WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode) THEN BEGIN
        IF WorkflowManagement.EnabledWorkflowExist(DATABASE::Vendor,WorkflowEventHandling.RunWorkflowOnVendorChangedCode) THEN
          EXIT(FALSE);
        ERROR(NoWorkflowEnabledErr);
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CheckItemApprovalsWorkflowEnabled@84(VAR Item@1002 : Record 27) : Boolean;
    BEGIN
      IF NOT WorkflowManagement.CanExecuteWorkflow(Item,WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode) THEN BEGIN
        IF WorkflowManagement.EnabledWorkflowExist(DATABASE::Item,WorkflowEventHandling.RunWorkflowOnItemChangedCode) THEN
          EXIT(FALSE);
        ERROR(NoWorkflowEnabledErr);
      END;
      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE CheckGeneralJournalBatchApprovalsWorkflowEnabled@74(VAR GenJournalBatch@1002 : Record 232) : Boolean;
    BEGIN
      IF NOT
         WorkflowManagement.CanExecuteWorkflow(GenJournalBatch,
           WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode)
      THEN
        ERROR(NoWorkflowEnabledErr);

      EXIT(TRUE);
    END;

    [Internal]
    PROCEDURE CheckGeneralJournalLineApprovalsWorkflowEnabled@73(VAR GenJournalLine@1002 : Record 81) : Boolean;
    BEGIN
      IF NOT
         WorkflowManagement.CanExecuteWorkflow(GenJournalLine,
           WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode)
      THEN
        ERROR(NoWorkflowEnabledErr);

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DeleteApprovalEntry@35(Variant@1001 : Variant);
    VAR
      RecRef@1002 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Variant);
      DeleteApprovalEntries(RecRef.RECORDID);
    END;

    [EventSubscriber(Table,81,OnMoveGenJournalLine)]
    [External]
    PROCEDURE PostApprovalEntriesMoveGenJournalLine@91(VAR Sender@1000 : Record 81;ToRecordID@1002 : RecordID);
    BEGIN
      PostApprovalEntries(Sender.RECORDID,ToRecordID,Sender."Document No.");
    END;

    [EventSubscriber(Table,81,OnAfterDeleteEvent)]
    [External]
    PROCEDURE DeleteApprovalEntriesAfterDeleteGenJournalLine@94(VAR Rec@1000 : Record 81;RunTrigger@1001 : Boolean);
    BEGIN
      IF NOT Rec.ISTEMPORARY THEN
        DeleteApprovalEntries(Rec.RECORDID);
    END;

    [EventSubscriber(Table,232,OnMoveGenJournalBatch)]
    [External]
    PROCEDURE PostApprovalEntriesMoveGenJournalBatch@36(VAR Sender@1000 : Record 232;ToRecordID@1001 : RecordID);
    VAR
      RecordRestrictionMgt@1002 : Codeunit 1550;
    BEGIN
      IF PostApprovalEntries(Sender.RECORDID,ToRecordID,'') THEN BEGIN
        RecordRestrictionMgt.AllowRecordUsage(Sender);
        DeleteApprovalEntries(Sender.RECORDID);
      END;
    END;

    [EventSubscriber(Table,232,OnAfterDeleteEvent)]
    [External]
    PROCEDURE DeleteApprovalEntriesAfterDeleteGenJournalBatch@98(VAR Rec@1000 : Record 232;RunTrigger@1001 : Boolean);
    BEGIN
      IF NOT Rec.ISTEMPORARY THEN
        DeleteApprovalEntries(Rec.RECORDID);
    END;

    [EventSubscriber(Table,18,OnAfterDeleteEvent)]
    [External]
    PROCEDURE DeleteApprovalEntriesAfterDeleteCustomer@99(VAR Rec@1000 : Record 18;RunTrigger@1001 : Boolean);
    BEGIN
      IF NOT Rec.ISTEMPORARY THEN
        DeleteApprovalEntries(Rec.RECORDID);
    END;

    [EventSubscriber(Table,23,OnAfterDeleteEvent)]
    [External]
    PROCEDURE DeleteApprovalEntriesAfterDeleteVendor@112(VAR Rec@1000 : Record 23;RunTrigger@1001 : Boolean);
    BEGIN
      IF NOT Rec.ISTEMPORARY THEN
        DeleteApprovalEntries(Rec.RECORDID);
    END;

    [EventSubscriber(Table,27,OnAfterDeleteEvent)]
    [External]
    PROCEDURE DeleteApprovalEntriesAfterDeleteItem@109(VAR Rec@1000 : Record 27;RunTrigger@1001 : Boolean);
    BEGIN
      IF NOT Rec.ISTEMPORARY THEN
        DeleteApprovalEntries(Rec.RECORDID);
    END;

    [External]
    PROCEDURE PostApprovalEntries@105(ApprovedRecordID@1003 : RecordID;PostedRecordID@1001 : RecordID;PostedDocNo@1002 : Code[20]) : Boolean;
    VAR
      ApprovalEntry@1000 : Record 454;
      PostedApprovalEntry@1004 : Record 456;
    BEGIN
      ApprovalEntry.SETAUTOCALCFIELDS("Pending Approvals","Number of Approved Requests","Number of Rejected Requests");
      ApprovalEntry.SETRANGE("Table ID",ApprovedRecordID.TABLENO);
      ApprovalEntry.SETRANGE("Record ID to Approve",ApprovedRecordID);
      IF NOT ApprovalEntry.FINDSET THEN
        EXIT(FALSE);

      REPEAT
        PostedApprovalEntry.INIT;
        PostedApprovalEntry.TRANSFERFIELDS(ApprovalEntry);
        PostedApprovalEntry."Number of Approved Requests" := ApprovalEntry."Number of Approved Requests";
        PostedApprovalEntry."Number of Rejected Requests" := ApprovalEntry."Number of Rejected Requests";
        PostedApprovalEntry."Table ID" := PostedRecordID.TABLENO;
        PostedApprovalEntry."Document No." := PostedDocNo;
        PostedApprovalEntry."Posted Record ID" := PostedRecordID;
        PostedApprovalEntry."Entry No." := 0;
        PostedApprovalEntry.INSERT(TRUE);
      UNTIL ApprovalEntry.NEXT = 0;

      PostApprovalCommentLines(ApprovedRecordID,PostedRecordID,PostedDocNo);
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE PostApprovalCommentLines@90(ApprovedRecordID@1000 : RecordID;PostedRecordID@1003 : RecordID;PostedDocNo@1004 : Code[20]);
    VAR
      ApprovalCommentLine@1001 : Record 455;
      PostedApprovalCommentLine@1002 : Record 457;
    BEGIN
      ApprovalCommentLine.SETRANGE("Table ID",ApprovedRecordID.TABLENO);
      ApprovalCommentLine.SETRANGE("Record ID to Approve",ApprovedRecordID);
      IF ApprovalCommentLine.FINDSET THEN
        REPEAT
          PostedApprovalCommentLine.INIT;
          PostedApprovalCommentLine.TRANSFERFIELDS(ApprovalCommentLine);
          PostedApprovalCommentLine."Entry No." := 0;
          PostedApprovalCommentLine."Table ID" := PostedRecordID.TABLENO;
          PostedApprovalCommentLine."Document No." := PostedDocNo;
          PostedApprovalCommentLine."Posted Record ID" := PostedRecordID;
          PostedApprovalCommentLine.INSERT(TRUE);
        UNTIL ApprovalCommentLine.NEXT = 0;
    END;

    [External]
    PROCEDURE ShowPostedApprovalEntries@60(PostedRecordID@1000 : RecordID);
    VAR
      PostedApprovalEntry@1001 : Record 456;
    BEGIN
      PostedApprovalEntry.FILTERGROUP(2);
      PostedApprovalEntry.SETRANGE("Posted Record ID",PostedRecordID);
      PostedApprovalEntry.FILTERGROUP(0);
      PAGE.RUN(PAGE::"Posted Approval Entries",PostedApprovalEntry);
    END;

    [External]
    PROCEDURE DeletePostedApprovalEntries@40(PostedRecordID@1000 : RecordID);
    VAR
      PostedApprovalEntry@1003 : Record 456;
    BEGIN
      PostedApprovalEntry.SETRANGE("Table ID",PostedRecordID.TABLENO);
      PostedApprovalEntry.SETRANGE("Posted Record ID",PostedRecordID);
      PostedApprovalEntry.DELETEALL;
      DeletePostedApprovalCommentLines(PostedRecordID);
    END;

    LOCAL PROCEDURE DeletePostedApprovalCommentLines@37(PostedRecordID@1000 : RecordID);
    VAR
      PostedApprovalCommentLine@1003 : Record 457;
    BEGIN
      PostedApprovalCommentLine.SETRANGE("Table ID",PostedRecordID.TABLENO);
      PostedApprovalCommentLine.SETRANGE("Posted Record ID",PostedRecordID);
      PostedApprovalCommentLine.DELETEALL;
    END;

    [External]
    PROCEDURE SetStatusToPendingApproval@47(VAR Variant@1000 : Variant);
    VAR
      SalesHeader@1002 : Record 36;
      PurchaseHeader@1003 : Record 38;
      IncomingDocument@1004 : Record 130;
      RecRef@1001 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Variant);

      CASE RecRef.NUMBER OF
        DATABASE::"Purchase Header":
          BEGIN
            RecRef.SETTABLE(PurchaseHeader);
            PurchaseHeader.VALIDATE(Status,PurchaseHeader.Status::"Pending Approval");
            PurchaseHeader.MODIFY(TRUE);
            Variant := PurchaseHeader;
          END;
        DATABASE::"Sales Header":
          BEGIN
            RecRef.SETTABLE(SalesHeader);
            SalesHeader.VALIDATE(Status,SalesHeader.Status::"Pending Approval");
            SalesHeader.MODIFY(TRUE);
            Variant := SalesHeader;
          END;
        DATABASE::"Incoming Document":
          BEGIN
            RecRef.SETTABLE(IncomingDocument);
            IncomingDocument.VALIDATE(Status,IncomingDocument.Status::"Pending Approval");
            IncomingDocument.MODIFY(TRUE);
            Variant := IncomingDocument;
          END;
        ELSE
          ERROR(UnsupportedRecordTypeErr,RecRef.CAPTION);
      END;
    END;

    [External]
    PROCEDURE InformUserOnStatusChange@110(Variant@1001 : Variant;WorkflowInstanceId@1000 : GUID);
    VAR
      RecRef@1004 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Variant);

      CASE RecRef.NUMBER OF
        DATABASE::"Purchase Header":
          ShowPurchApprovalStatus(Variant);
        DATABASE::"Sales Header":
          ShowSalesApprovalStatus(Variant);
        ELSE
          ShowApprovalStatus(RecRef.RECORDID,WorkflowInstanceId);
      END;
    END;

    [External]
    PROCEDURE GetApprovalComment@53(Variant@1000 : Variant);
    VAR
      BlankGUID@1001 : GUID;
    BEGIN
      ShowApprovalComments(Variant,BlankGUID);
    END;

    [External]
    PROCEDURE GetApprovalCommentForWorkflowStepInstanceID@30(Variant@1000 : Variant;WorkflowStepInstanceID@1001 : GUID);
    BEGIN
      ShowApprovalComments(Variant,WorkflowStepInstanceID);
    END;

    LOCAL PROCEDURE ShowApprovalComments@95(Variant@1002 : Variant;WorkflowStepInstanceID@1000 : GUID);
    VAR
      ApprovalCommentLine@1001 : Record 455;
      ApprovalEntry@1004 : Record 454;
      ApprovalComments@1003 : Page 660;
      RecRef@1005 : RecordRef;
    BEGIN
      RecRef.GETTABLE(Variant);

      CASE RecRef.NUMBER OF
        DATABASE::"Approval Entry":
          BEGIN
            ApprovalEntry := Variant;
            RecRef.GET(ApprovalEntry."Record ID to Approve");
            ApprovalCommentLine.SETRANGE("Table ID",RecRef.NUMBER);
            ApprovalCommentLine.SETRANGE("Record ID to Approve",ApprovalEntry."Record ID to Approve");
          END;
        DATABASE::"Purchase Header":
          BEGIN
            ApprovalCommentLine.SETRANGE("Table ID",RecRef.NUMBER);
            ApprovalCommentLine.SETRANGE("Record ID to Approve",RecRef.RECORDID);
            FindOpenApprovalEntryForCurrUser(ApprovalEntry,RecRef.RECORDID);
          END;
        DATABASE::"Sales Header":
          BEGIN
            ApprovalCommentLine.SETRANGE("Table ID",RecRef.NUMBER);
            ApprovalCommentLine.SETRANGE("Record ID to Approve",RecRef.RECORDID);
            FindOpenApprovalEntryForCurrUser(ApprovalEntry,RecRef.RECORDID);
          END;
        ELSE BEGIN
          ApprovalCommentLine.SETRANGE("Table ID",RecRef.NUMBER);
          ApprovalCommentLine.SETRANGE("Record ID to Approve",RecRef.RECORDID);
          FindOpenApprovalEntryForCurrUser(ApprovalEntry,RecRef.RECORDID);
        END;
      END;

      IF ISNULLGUID(WorkflowStepInstanceID) AND (NOT ISNULLGUID(ApprovalEntry."Workflow Step Instance ID")) THEN
        WorkflowStepInstanceID := ApprovalEntry."Workflow Step Instance ID";

      ApprovalComments.SETTABLEVIEW(ApprovalCommentLine);
      ApprovalComments.SetWorkflowStepInstanceID(WorkflowStepInstanceID);
      ApprovalComments.RUN;
    END;

    [External]
    PROCEDURE HasOpenApprovalEntriesForCurrentUser@14(RecordID@1000 : RecordID) : Boolean;
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      EXIT(FindOpenApprovalEntryForCurrUser(ApprovalEntry,RecordID));
    END;

    [External]
    PROCEDURE HasOpenApprovalEntries@154(RecordID@1000 : RecordID) : Boolean;
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      ApprovalEntry.SETRANGE("Table ID",RecordID.TABLENO);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecordID);
      ApprovalEntry.SETRANGE(Status,ApprovalEntry.Status::Open);
      ApprovalEntry.SETRANGE("Related to Change",FALSE);
      EXIT(NOT ApprovalEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE HasOpenOrPendingApprovalEntries@115(RecordID@1000 : RecordID) : Boolean;
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      ApprovalEntry.SETRANGE("Table ID",RecordID.TABLENO);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecordID);
      ApprovalEntry.SETFILTER(Status,'%1|%2',ApprovalEntry.Status::Open,ApprovalEntry.Status::Created);
      ApprovalEntry.SETRANGE("Related to Change",FALSE);
      EXIT(NOT ApprovalEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE HasApprovalEntries@15(RecordID@1001 : RecordID) : Boolean;
    VAR
      ApprovalEntry@1000 : Record 454;
    BEGIN
      ApprovalEntry.SETRANGE("Table ID",RecordID.TABLENO);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecordID);
      ApprovalEntry.SETRANGE("Related to Change",FALSE);
      EXIT(NOT ApprovalEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE HasPendingApprovalEntriesForWorkflow@156(RecId@1000 : RecordID;WorkflowInstanceId@1002 : GUID) : Boolean;
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      ApprovalEntry.SETRANGE("Record ID to Approve",RecId);
      ApprovalEntry.SETFILTER(Status,'%1|%2',ApprovalEntry.Status::Open,ApprovalEntry.Status::Created);
      ApprovalEntry.SETFILTER("Workflow Step Instance ID",WorkflowInstanceId);
      EXIT(NOT ApprovalEntry.ISEMPTY);
    END;

    [External]
    PROCEDURE HasAnyOpenJournalLineApprovalEntries@187(JournalTemplateName@1000 : Code[20];JournalBatchName@1003 : Code[20]) : Boolean;
    VAR
      GenJournalLine@1001 : Record 81;
      ApprovalEntry@1002 : Record 454;
      GenJournalLineRecRef@1008 : RecordRef;
      GenJournalLineRecordID@1006 : RecordID;
    BEGIN
      ApprovalEntry.SETRANGE("Table ID",DATABASE::"Gen. Journal Line");
      ApprovalEntry.SETRANGE(Status,ApprovalEntry.Status::Open);
      ApprovalEntry.SETRANGE("Related to Change",FALSE);
      IF ApprovalEntry.ISEMPTY THEN
        EXIT(FALSE);

      GenJournalLine.SETRANGE("Journal Template Name",JournalTemplateName);
      GenJournalLine.SETRANGE("Journal Batch Name",JournalBatchName);
      IF GenJournalLine.ISEMPTY THEN
        EXIT(FALSE);

      IF GenJournalLine.COUNT < ApprovalEntry.COUNT THEN BEGIN
        GenJournalLine.FINDSET;
        REPEAT
          IF HasOpenApprovalEntries(GenJournalLine.RECORDID) THEN
            EXIT(TRUE);
        UNTIL GenJournalLine.NEXT = 0;
      END ELSE BEGIN
        ApprovalEntry.FINDSET;
        REPEAT
          GenJournalLineRecordID := ApprovalEntry."Record ID to Approve";
          GenJournalLineRecRef := GenJournalLineRecordID.GETRECORD;
          GenJournalLineRecRef.SETTABLE(GenJournalLine);
          IF (GenJournalLine."Journal Template Name" = JournalTemplateName) AND
             (GenJournalLine."Journal Batch Name" = JournalBatchName)
          THEN
            EXIT(TRUE);
        UNTIL ApprovalEntry.NEXT = 0;
      END;

      EXIT(FALSE)
    END;

    [External]
    PROCEDURE TrySendJournalBatchApprovalRequest@54(VAR GenJournalLine@1000 : Record 81);
    VAR
      GenJournalBatch@1001 : Record 232;
    BEGIN
      GetGeneralJournalBatch(GenJournalBatch,GenJournalLine);
      CheckGeneralJournalBatchApprovalsWorkflowEnabled(GenJournalBatch);
      IF HasOpenApprovalEntries(GenJournalBatch.RECORDID) OR
         HasAnyOpenJournalLineApprovalEntries(GenJournalBatch."Journal Template Name",GenJournalBatch.Name)
      THEN
        ERROR(PendingJournalBatchApprovalExistsErr);
      OnSendGeneralJournalBatchForApproval(GenJournalBatch);
    END;

    [External]
    PROCEDURE TrySendJournalLineApprovalRequests@183(VAR GenJournalLine@1000 : Record 81);
    VAR
      LinesSent@1001 : Integer;
    BEGIN
      IF GenJournalLine.COUNT = 1 THEN
        CheckGeneralJournalLineApprovalsWorkflowEnabled(GenJournalLine);

      REPEAT
        IF WorkflowManagement.CanExecuteWorkflow(GenJournalLine,
             WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode) AND
           NOT HasOpenApprovalEntries(GenJournalLine.RECORDID)
        THEN BEGIN
          OnSendGeneralJournalLineForApproval(GenJournalLine);
          LinesSent += 1;
        END;
      UNTIL GenJournalLine.NEXT = 0;

      CASE LinesSent OF
        0:
          MESSAGE(NoApprovalsSentMsg);
        GenJournalLine.COUNT:
          MESSAGE(PendingApprovalForSelectedLinesMsg);
        ELSE
          MESSAGE(PendingApprovalForSomeSelectedLinesMsg);
      END;
    END;

    [External]
    PROCEDURE TryCancelJournalBatchApprovalRequest@189(VAR GenJournalLine@1000 : Record 81);
    VAR
      GenJournalBatch@1001 : Record 232;
      WorkflowWebhookManagement@1002 : Codeunit 1543;
    BEGIN
      GetGeneralJournalBatch(GenJournalBatch,GenJournalLine);
      OnCancelGeneralJournalBatchApprovalRequest(GenJournalBatch);
      WorkflowWebhookManagement.FindAndCancel(GenJournalBatch.RECORDID);
    END;

    [External]
    PROCEDURE TryCancelJournalLineApprovalRequests@88(VAR GenJournalLine@1000 : Record 81);
    VAR
      WorkflowWebhookManagement@1001 : Codeunit 1543;
    BEGIN
      REPEAT
        IF HasOpenApprovalEntries(GenJournalLine.RECORDID) THEN
          OnCancelGeneralJournalLineApprovalRequest(GenJournalLine);
        WorkflowWebhookManagement.FindAndCancel(GenJournalLine.RECORDID);
      UNTIL GenJournalLine.NEXT = 0;
      MESSAGE(ApprovalReqCanceledForSelectedLinesMsg);
    END;

    [External]
    PROCEDURE ShowJournalApprovalEntries@55(VAR GenJournalLine@1000 : Record 81);
    VAR
      ApprovalEntry@1002 : Record 454;
      GenJournalBatch@1001 : Record 232;
    BEGIN
      GetGeneralJournalBatch(GenJournalBatch,GenJournalLine);

      ApprovalEntry.SETFILTER("Table ID",'%1|%2',DATABASE::"Gen. Journal Batch",DATABASE::"Gen. Journal Line");
      ApprovalEntry.SETFILTER("Record ID to Approve",'%1|%2',GenJournalBatch.RECORDID,GenJournalLine.RECORDID);
      ApprovalEntry.SETRANGE("Related to Change",FALSE);
      PAGE.RUN(PAGE::"Approval Entries",ApprovalEntry);
    END;

    LOCAL PROCEDURE GetGeneralJournalBatch@87(VAR GenJournalBatch@1000 : Record 232;VAR GenJournalLine@1001 : Record 81);
    BEGIN
      IF NOT GenJournalBatch.GET(GenJournalLine."Journal Template Name",GenJournalLine."Journal Batch Name") THEN
        GenJournalBatch.GET(GenJournalLine.GETFILTER("Journal Template Name"),GenJournalLine.GETFILTER("Journal Batch Name"));
    END;

    [EventSubscriber(Codeunit,1535,OnRenameRecordInApprovalRequest)]
    [External]
    PROCEDURE RenameApprovalEntries@79(OldRecordId@1000 : RecordID;NewRecordId@1001 : RecordID);
    VAR
      ApprovalEntry@1002 : Record 454;
    BEGIN
      ApprovalEntry.SETRANGE("Record ID to Approve",OldRecordId);
      IF ApprovalEntry.FINDFIRST THEN
        ApprovalEntry.MODIFYALL("Record ID to Approve",NewRecordId,TRUE);
      ChangeApprovalComments(OldRecordId,NewRecordId);
    END;

    LOCAL PROCEDURE ChangeApprovalComments@85(OldRecordId@1000 : RecordID;NewRecordId@1001 : RecordID);
    VAR
      ApprovalCommentLine@1002 : Record 455;
    BEGIN
      ApprovalCommentLine.SETRANGE("Record ID to Approve",OldRecordId);
      ApprovalCommentLine.MODIFYALL("Record ID to Approve",NewRecordId,TRUE);
    END;

    [EventSubscriber(Codeunit,1535,OnDeleteRecordInApprovalRequest)]
    [External]
    PROCEDURE DeleteApprovalEntries@93(RecordIDToApprove@1000 : RecordID);
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      ApprovalEntry.SETRANGE("Table ID",RecordIDToApprove.TABLENO);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecordIDToApprove);
      ApprovalEntry.DELETEALL(TRUE);
      DeleteApprovalCommentLines(RecordIDToApprove);
    END;

    [Internal]
    PROCEDURE DeleteApprovalCommentLines@92(RecordIDToApprove@1000 : RecordID);
    VAR
      ApprovalCommentLine@1001 : Record 455;
    BEGIN
      ApprovalCommentLine.SETRANGE("Table ID",RecordIDToApprove.TABLENO);
      ApprovalCommentLine.SETRANGE("Record ID to Approve",RecordIDToApprove);
      ApprovalCommentLine.DELETEALL(TRUE);
    END;

    [External]
    PROCEDURE CopyApprovalEntryQuoteToOrder@66(FromRecID@1006 : RecordID;ToDocNo@1007 : Code[20];ToRecID@1008 : RecordID);
    VAR
      FromApprovalEntry@1000 : Record 454;
      ToApprovalEntry@1001 : Record 454;
      FromApprovalCommentLine@1002 : Record 455;
      ToApprovalCommentLine@1003 : Record 455;
      LastEntryNo@1004 : Integer;
    BEGIN
      FromApprovalEntry.SETRANGE("Table ID",FromRecID.TABLENO);
      FromApprovalEntry.SETRANGE("Record ID to Approve",FromRecID);
      IF FromApprovalEntry.FINDSET THEN BEGIN
        ToApprovalEntry.FINDLAST;
        LastEntryNo := ToApprovalEntry."Entry No.";
        REPEAT
          ToApprovalEntry := FromApprovalEntry;
          ToApprovalEntry."Entry No." := LastEntryNo + 1;
          ToApprovalEntry."Document Type" := ToApprovalEntry."Document Type"::Order;
          ToApprovalEntry."Document No." := ToDocNo;
          ToApprovalEntry."Record ID to Approve" := ToRecID;
          LastEntryNo += 1;
          ToApprovalEntry.INSERT;
        UNTIL FromApprovalEntry.NEXT = 0;

        FromApprovalCommentLine.SETRANGE("Table ID",FromRecID.TABLENO);
        FromApprovalCommentLine.SETRANGE("Record ID to Approve",FromRecID);
        IF FromApprovalCommentLine.FINDSET THEN BEGIN
          ToApprovalCommentLine.FINDLAST;
          LastEntryNo := ToApprovalCommentLine."Entry No.";
          REPEAT
            ToApprovalCommentLine := FromApprovalCommentLine;
            ToApprovalCommentLine."Entry No." := LastEntryNo + 1;
            ToApprovalCommentLine."Document Type" := ToApprovalCommentLine."Document Type"::Order;
            ToApprovalCommentLine."Document No." := ToDocNo;
            ToApprovalCommentLine."Record ID to Approve" := ToRecID;
            ToApprovalCommentLine.INSERT;
            LastEntryNo += 1;
          UNTIL FromApprovalCommentLine.NEXT = 0;
        END;
      END;
    END;

    LOCAL PROCEDURE GetLastSequenceNo@16(ApprovalEntryArgument@1000 : Record 454) : Integer;
    VAR
      ApprovalEntry@1001 : Record 454;
    BEGIN
      WITH ApprovalEntry DO BEGIN
        SETCURRENTKEY("Record ID to Approve","Workflow Step Instance ID","Sequence No.");
        SETRANGE("Table ID",ApprovalEntryArgument."Table ID");
        SETRANGE("Record ID to Approve",ApprovalEntryArgument."Record ID to Approve");
        SETRANGE("Workflow Step Instance ID",ApprovalEntryArgument."Workflow Step Instance ID");
        IF FINDLAST THEN
          EXIT("Sequence No.");
      END;
      EXIT(0);
    END;

    [External]
    PROCEDURE OpenApprovalEntriesPage@75(RecId@1000 : RecordID);
    VAR
      ApprovalEntry@1002 : Record 454;
    BEGIN
      ApprovalEntry.SETRANGE("Table ID",RecId.TABLENO);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecId);
      ApprovalEntry.SETRANGE("Related to Change",FALSE);
      PAGE.RUNMODAL(PAGE::"Approval Entries",ApprovalEntry);
    END;

    [External]
    PROCEDURE CanCancelApprovalForRecord@106(RecID@1000 : RecordID) : Boolean;
    VAR
      ApprovalEntry@1001 : Record 454;
      UserSetup@1002 : Record 91;
    BEGIN
      IF NOT UserSetup.GET(USERID) THEN
        EXIT(FALSE);

      ApprovalEntry.SETRANGE("Table ID",RecID.TABLENO);
      ApprovalEntry.SETRANGE("Record ID to Approve",RecID);
      ApprovalEntry.SETFILTER(Status,'%1|%2',ApprovalEntry.Status::Created,ApprovalEntry.Status::Open);
      ApprovalEntry.SETRANGE("Related to Change",FALSE);

      IF NOT UserSetup."Approval Administrator" THEN
        ApprovalEntry.SETRANGE("Sender ID",USERID);
      EXIT(ApprovalEntry.FINDFIRST);
    END;

    LOCAL PROCEDURE FindUserSetupBySalesPurchCode@114(VAR UserSetup@1000 : Record 91;ApprovalEntryArgument@1001 : Record 454);
    BEGIN
      IF ApprovalEntryArgument."Salespers./Purch. Code" <> '' THEN BEGIN
        UserSetup.SETCURRENTKEY("Salespers./Purch. Code");
        UserSetup.SETRANGE("Salespers./Purch. Code",ApprovalEntryArgument."Salespers./Purch. Code");
        IF NOT UserSetup.FINDFIRST THEN
          ERROR(
            PurchaserUserNotFoundErr,UserSetup."User ID",UserSetup.FIELDCAPTION("Salespers./Purch. Code"),
            UserSetup."Salespers./Purch. Code");
        EXIT;
      END;
    END;

    LOCAL PROCEDURE CheckUserAsApprovalAdministrator@116();
    VAR
      UserSetup@1000 : Record 91;
    BEGIN
      UserSetup.GET(USERID);
      UserSetup.TESTFIELD("Approval Administrator");
    END;

    BEGIN
    END.
  }
}

