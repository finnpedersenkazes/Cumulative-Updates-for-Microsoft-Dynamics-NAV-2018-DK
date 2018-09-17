OBJECT Codeunit 1510 Notification Management
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 458=i,
                TableData 1511=rimd,
                TableData 1514=rim;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      OverdueEntriesMsg@1047 : TextConst 'DAN=Der er oprettet forfaldne godkendelsesposter.;ENU=Overdue approval entries have been created.';
      SalesTxt@1008 : TextConst 'DAN=Salg;ENU=Sales';
      PurchaseTxt@1007 : TextConst 'DAN=K�b;ENU=Purchase';
      ServiceTxt@1006 : TextConst 'DAN=Service;ENU=Service';
      SalesInvoiceTxt@1005 : TextConst 'DAN=Salgsfaktura;ENU=Sales Invoice';
      PurchaseInvoiceTxt@1004 : TextConst 'DAN=K�bsfaktura;ENU=Purchase Invoice';
      ServiceInvoiceTxt@1003 : TextConst 'DAN=Servicefaktura;ENU=Service Invoice';
      SalesCreditMemoTxt@1002 : TextConst 'DAN=Salgskreditnota;ENU=Sales Credit Memo';
      PurchaseCreditMemoTxt@1001 : TextConst 'DAN=K�bskreditnota;ENU=Purchase Credit Memo';
      ServiceCreditMemoTxt@1000 : TextConst 'DAN=Servicekreditnota;ENU=Service Credit Memo';
      ActionNewRecordTxt@1015 : TextConst '@@@=E.g. Sales Invoice 10000 has been created.;DAN=er blevet oprettet.;ENU=has been created.';
      ActionApproveTxt@1014 : TextConst '@@@=E.g. Sales Invoice 10000 requires your approval.;DAN=kr�ver din godkendelse.;ENU=requires your approval.';
      ActionApprovedTxt@1013 : TextConst '@@@=E.g. Sales Invoice 10000 has been approved.;DAN=er blevet godkendt.;ENU=has been approved.';
      ActionApprovalCreatedTxt@1012 : TextConst '@@@=E.g. Sales Invoice 10000 approval request has been created.;DAN=anmodning om godkendelse er oprettet.;ENU=approval request has been created.';
      ActionApprovalCanceledTxt@1011 : TextConst '@@@=E.g. Sales Invoice 10000 approval request has been canceled.;DAN=anmodning om godkendelse er annulleret.;ENU=approval request has been canceled.';
      ActionApprovalRejectedTxt@1010 : TextConst '@@@=E.g. Sales Invoice 10000 approval request has been rejected.;DAN=godkendelse er blevet afvist.;ENU=approval has been rejected.';
      ActionOverdueTxt@1009 : TextConst '@@@=E.g. Sales Invoice 10000 has a pending approval.;DAN=har en udest�ende godkendelse.;ENU=has a pending approval.';

    [External]
    PROCEDURE CreateOverdueNotifications@14(WorkflowStepArgument@1002 : Record 1523);
    VAR
      UserSetup@1006 : Record 91;
      ApprovalEntry@1000 : Record 454;
      OverdueApprovalEntry@1001 : Record 458;
      NotificationEntry@1003 : Record 1511;
    BEGIN
      IF UserSetup.FINDSET THEN
        REPEAT
          ApprovalEntry.RESET;
          ApprovalEntry.SETRANGE("Approver ID",UserSetup."User ID");
          ApprovalEntry.SETRANGE(Status,ApprovalEntry.Status::Open);
          ApprovalEntry.SETFILTER("Due Date",'<=%1',TODAY);
          IF ApprovalEntry.FINDSET THEN
            REPEAT
              InsertOverdueEntry(ApprovalEntry,OverdueApprovalEntry);
              NotificationEntry.CreateNew(NotificationEntry.Type::Overdue,
                UserSetup."User ID",OverdueApprovalEntry,WorkflowStepArgument."Link Target Page",
                WorkflowStepArgument."Custom Link");
            UNTIL ApprovalEntry.NEXT = 0;
        UNTIL UserSetup.NEXT = 0;

      MESSAGE(OverdueEntriesMsg);
    END;

    LOCAL PROCEDURE InsertOverdueEntry@13(ApprovalEntry@1000 : Record 454;VAR OverdueApprovalEntry@1001 : Record 458);
    VAR
      User@1002 : Record 2000000120;
      UserSetup@1003 : Record 91;
    BEGIN
      WITH OverdueApprovalEntry DO BEGIN
        INIT;
        "Approver ID" := ApprovalEntry."Approver ID";
        User.SETRANGE("User Name",ApprovalEntry."Approver ID");
        IF User.FINDFIRST THEN BEGIN
          "Sent to Name" := COPYSTR(User."Full Name",1,MAXSTRLEN("Sent to Name"));
          UserSetup.GET(User."User Name");
        END;

        "Table ID" := ApprovalEntry."Table ID";
        "Document Type" := ApprovalEntry."Document Type";
        "Document No." := ApprovalEntry."Document No.";
        "Sent to ID" := ApprovalEntry."Approver ID";
        "Sent Date" := TODAY;
        "Sent Time" := TIME;
        "E-Mail" := UserSetup."E-Mail";
        "Sequence No." := ApprovalEntry."Sequence No.";
        "Due Date" := ApprovalEntry."Due Date";
        "Approval Code" := ApprovalEntry."Approval Code";
        "Approval Type" := ApprovalEntry."Approval Type";
        "Limit Type" := ApprovalEntry."Limit Type";
        "Record ID to Approve" := ApprovalEntry."Record ID to Approve";
        INSERT;
      END;
    END;

    [External]
    PROCEDURE CreateDefaultNotificationSetup@1(NotificationType@1000 : Option);
    VAR
      NotificationSetup@1001 : Record 1512;
    BEGIN
      IF DefaultNotificationEntryExists(NotificationType) THEN
        EXIT;

      NotificationSetup.INIT;
      NotificationSetup.VALIDATE("Notification Type",NotificationType);
      NotificationSetup.VALIDATE("Notification Method",NotificationSetup."Notification Method"::Email);
      NotificationSetup.INSERT(TRUE);
    END;

    LOCAL PROCEDURE DefaultNotificationEntryExists@4(NotificationType@1000 : Option) : Boolean;
    VAR
      NotificationSetup@1001 : Record 1512;
    BEGIN
      NotificationSetup.SETRANGE("User ID",'');
      NotificationSetup.SETRANGE("Notification Type",NotificationType);
      EXIT(NOT NotificationSetup.ISEMPTY)
    END;

    [External]
    PROCEDURE MoveNotificationEntryToSentNotificationEntries@11(VAR NotificationEntry@1000 : Record 1511;NotificationBody@1001 : Text;AggregatedNotifications@1002 : Boolean;NotificationMethod@1005 : Option);
    VAR
      SentNotificationEntry@1003 : Record 1514;
      InitialSentNotificationEntry@1006 : Record 1514;
    BEGIN
      IF AggregatedNotifications THEN BEGIN
        IF NotificationEntry.FINDSET THEN BEGIN
          InitialSentNotificationEntry.NewRecord(NotificationEntry,NotificationBody,NotificationMethod);
          WHILE NotificationEntry.NEXT <> 0 DO BEGIN
            SentNotificationEntry.NewRecord(NotificationEntry,NotificationBody,NotificationMethod);
            SentNotificationEntry.VALIDATE("Aggregated with Entry",InitialSentNotificationEntry.ID);
            SentNotificationEntry.MODIFY(TRUE);
          END;
        END;
        NotificationEntry.DELETEALL(TRUE);
      END ELSE BEGIN
        SentNotificationEntry.NewRecord(NotificationEntry,NotificationBody,NotificationMethod);
        NotificationEntry.DELETE(TRUE);
      END;
    END;

    [External]
    PROCEDURE GetDocumentTypeAndNumber@3(VAR RecRef@1000 : RecordRef;VAR DocumentType@1001 : Text;VAR DocumentNo@1002 : Text);
    VAR
      FieldRef@1003 : FieldRef;
    BEGIN
      CASE RecRef.NUMBER OF
        DATABASE::"Incoming Document":
          BEGIN
            DocumentType := RecRef.CAPTION;
            FieldRef := RecRef.FIELD(2);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Sales Header":
          BEGIN
            FieldRef := RecRef.FIELD(1);
            DocumentType := SalesTxt + ' ' + FORMAT(FieldRef.VALUE);
            FieldRef := RecRef.FIELD(3);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Purchase Header":
          BEGIN
            FieldRef := RecRef.FIELD(1);
            DocumentType := PurchaseTxt + ' ' + FORMAT(FieldRef.VALUE);
            FieldRef := RecRef.FIELD(3);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Service Header":
          BEGIN
            FieldRef := RecRef.FIELD(1);
            DocumentType := ServiceTxt + ' ' + FORMAT(FieldRef.VALUE);
            FieldRef := RecRef.FIELD(3);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Sales Invoice Header":
          BEGIN
            DocumentType := SalesInvoiceTxt;
            FieldRef := RecRef.FIELD(3);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Purch. Inv. Header":
          BEGIN
            DocumentType := PurchaseInvoiceTxt;
            FieldRef := RecRef.FIELD(3);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Service Invoice Header":
          BEGIN
            DocumentType := ServiceInvoiceTxt;
            FieldRef := RecRef.FIELD(3);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Sales Cr.Memo Header":
          BEGIN
            DocumentType := SalesCreditMemoTxt;
            FieldRef := RecRef.FIELD(3);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Purch. Cr. Memo Hdr.":
          BEGIN
            DocumentType := PurchaseCreditMemoTxt;
            FieldRef := RecRef.FIELD(3);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Service Cr.Memo Header":
          BEGIN
            DocumentType := ServiceCreditMemoTxt;
            FieldRef := RecRef.FIELD(3);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Gen. Journal Line":
          BEGIN
            DocumentType := RecRef.CAPTION;
            FieldRef := RecRef.FIELD(1);
            DocumentNo := FORMAT(FieldRef.VALUE);
            FieldRef := RecRef.FIELD(51);
            DocumentNo += ',' + FORMAT(FieldRef.VALUE);
            FieldRef := RecRef.FIELD(2);
            DocumentNo += ',' + FORMAT(FieldRef.VALUE);
          END;
        DATABASE::"Gen. Journal Batch":
          BEGIN
            DocumentType := RecRef.CAPTION;
            FieldRef := RecRef.FIELD(1);
            DocumentNo := FORMAT(FieldRef.VALUE);
            FieldRef := RecRef.FIELD(2);
            DocumentNo += ',' + FORMAT(FieldRef.VALUE);
          END;
        DATABASE::Customer,
        DATABASE::Vendor,
        DATABASE::Item:
          BEGIN
            DocumentType := RecRef.CAPTION;
            FieldRef := RecRef.FIELD(1);
            DocumentNo := FORMAT(FieldRef.VALUE);
          END;
        ELSE BEGIN
          DocumentType := RecRef.CAPTION;
          FieldRef := RecRef.FIELD(3);
          DocumentNo := FORMAT(FieldRef.VALUE);
        END;
      END;
    END;

    [External]
    PROCEDURE GetActionTextFor@7(VAR NotificationEntry@1000 : Record 1511) : Text;
    VAR
      ApprovalEntry@1001 : Record 454;
      DataTypeManagement@1002 : Codeunit 701;
      RecRef@1003 : RecordRef;
    BEGIN
      CASE NotificationEntry.Type OF
        NotificationEntry.Type::"New Record":
          EXIT(ActionNewRecordTxt);
        NotificationEntry.Type::Approval:
          BEGIN
            DataTypeManagement.GetRecordRef(NotificationEntry."Triggered By Record",RecRef);
            RecRef.SETTABLE(ApprovalEntry);
            CASE ApprovalEntry.Status OF
              ApprovalEntry.Status::Open:
                EXIT(ActionApproveTxt);
              ApprovalEntry.Status::Canceled:
                EXIT(ActionApprovalCanceledTxt);
              ApprovalEntry.Status::Rejected:
                EXIT(ActionApprovalRejectedTxt);
              ApprovalEntry.Status::Created:
                EXIT(ActionApprovalCreatedTxt);
              ApprovalEntry.Status::Approved:
                EXIT(ActionApprovedTxt);
            END;
          END;
        NotificationEntry.Type::Overdue:
          EXIT(ActionOverdueTxt);
      END;
    END;

    BEGIN
    END.
  }
}

