OBJECT Codeunit 96 Purch.-Quote to Order
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    TableNo=38;
    OnRun=VAR
            Vend@1002 : Record 23;
            PurchCommentLine@1006 : Record 43;
            PurchCalcDiscByType@1007 : Codeunit 66;
            ApprovalsMgmt@1000 : Codeunit 1535;
            ArchiveManagement@1001 : Codeunit 5063;
            RecordLinkManagement@1004 : Codeunit 447;
            PurchLineReserve@1005 : Codeunit 99000834;
            ShouldRedistributeInvoiceAmount@1003 : Boolean;
          BEGIN
            TESTFIELD("Document Type","Document Type"::Quote);
            ShouldRedistributeInvoiceAmount := PurchCalcDiscByType.ShouldRedistributeInvoiceDiscountAmount(Rec);

            OnCheckPurchasePostRestrictions;

            Vend.GET("Buy-from Vendor No.");
            Vend.CheckBlockedVendOnDocs(Vend,FALSE);

            ValidatePurchaserOnPurchHeader(Rec,TRUE,FALSE);

            CreatePurchHeader(Rec,Vend."Prepayment %");

            PurchQuoteLine.SETRANGE("Document Type","Document Type");
            PurchQuoteLine.SETRANGE("Document No.","No.");
            IF PurchQuoteLine.FINDSET THEN
              REPEAT
                PurchOrderLine := PurchQuoteLine;
                PurchOrderLine."Document Type" := PurchOrderHeader."Document Type";
                PurchOrderLine."Document No." := PurchOrderHeader."No.";
                PurchLineReserve.TransferPurchLineToPurchLine(
                  PurchQuoteLine,PurchOrderLine,PurchQuoteLine."Outstanding Qty. (Base)");
                PurchOrderLine."Shortcut Dimension 1 Code" := PurchQuoteLine."Shortcut Dimension 1 Code";
                PurchOrderLine."Shortcut Dimension 2 Code" := PurchQuoteLine."Shortcut Dimension 2 Code";
                PurchOrderLine."Dimension Set ID" := PurchQuoteLine."Dimension Set ID";
                IF Vend."Prepayment %" <> 0 THEN
                  PurchOrderLine."Prepayment %" := Vend."Prepayment %";
                PrepmtMgt.SetPurchPrepaymentPct(PurchOrderLine,PurchOrderHeader."Posting Date");
                PurchOrderLine.VALIDATE("Prepayment %");
                PurchOrderLine.DefaultDeferralCode;
                OnBeforeInsertPurchOrderLine(PurchOrderLine,PurchOrderHeader,PurchQuoteLine,Rec);
                PurchOrderLine.INSERT;
                OnAfterInsertPurchOrderLine(PurchQuoteLine,PurchOrderLine);

                PurchLineReserve.VerifyQuantity(PurchOrderLine,PurchQuoteLine);
              UNTIL PurchQuoteLine.NEXT = 0;

            OnAfterInsertAllPurchOrderLines(PurchOrderLine,Rec);

            PurchSetup.GET;
            IF PurchSetup."Archive Quotes and Orders" THEN
              ArchiveManagement.ArchPurchDocumentNoConfirm(Rec);

            IF PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" THEN BEGIN
              PurchOrderHeader."Posting Date" := 0D;
              PurchOrderHeader.MODIFY;
            END;

            PurchCommentLine.CopyComments("Document Type",PurchOrderHeader."Document Type","No.",PurchOrderHeader."No.");
            RecordLinkManagement.CopyLinks(Rec,PurchOrderHeader);

            AssignItemCharges("Document Type","No.",PurchOrderHeader."Document Type",PurchOrderHeader."No.");

            ApprovalsMgmt.CopyApprovalEntryQuoteToOrder(RECORDID,PurchOrderHeader."No.",PurchOrderHeader.RECORDID);
            ApprovalsMgmt.DeleteApprovalEntries(RECORDID);

            OnBeforeDeletePurchQuote(Rec,PurchOrderHeader);

            DELETELINKS;
            DELETE;

            PurchQuoteLine.DELETEALL;

            IF NOT ShouldRedistributeInvoiceAmount THEN
              PurchCalcDiscByType.ResetRecalculateInvoiceDisc(PurchOrderHeader);
          END;

  }
  CODE
  {
    VAR
      PurchQuoteLine@1000 : Record 39;
      PurchOrderHeader@1001 : Record 38;
      PurchOrderLine@1002 : Record 39;
      PurchSetup@1008 : Record 312;
      PrepmtMgt@1007 : Codeunit 441;

    LOCAL PROCEDURE CreatePurchHeader@2(PurchHeader@1000 : Record 38;PrepmtPercent@1001 : Decimal);
    BEGIN
      WITH PurchHeader DO BEGIN
        PurchOrderHeader := PurchHeader;
        PurchOrderHeader."Document Type" := PurchOrderHeader."Document Type"::Order;
        PurchOrderHeader."No. Printed" := 0;
        PurchOrderHeader.Status := PurchOrderHeader.Status::Open;
        PurchOrderHeader."No." := '';
        PurchOrderHeader."Quote No." := "No.";
        PurchOrderHeader.InitRecord;

        PurchOrderLine.LOCKTABLE;
        PurchOrderHeader.INSERT(TRUE);

        PurchOrderHeader."Order Date" := "Order Date";
        IF "Posting Date" <> 0D THEN
          PurchOrderHeader."Posting Date" := "Posting Date";

        PurchOrderHeader.InitFromPurchHeader(PurchHeader);
        PurchOrderHeader."Inbound Whse. Handling Time" := "Inbound Whse. Handling Time";

        PurchOrderHeader."Prepayment %" := PrepmtPercent;
        IF PurchOrderHeader."Posting Date" = 0D THEN
          PurchOrderHeader."Posting Date" := WORKDATE;
        OnBeforeInsertPurchOrderHeader(PurchOrderHeader,PurchHeader);
        PurchOrderHeader.MODIFY;
      END;
    END;

    LOCAL PROCEDURE AssignItemCharges@3(FromDocType@1001 : Option;FromDocNo@1002 : Code[20];ToDocType@1004 : Option;ToDocNo@1003 : Code[20]);
    VAR
      ItemChargeAssgntPurch@1000 : Record 5805;
    BEGIN
      ItemChargeAssgntPurch.RESET;
      ItemChargeAssgntPurch.SETRANGE("Document Type",FromDocType);
      ItemChargeAssgntPurch.SETRANGE("Document No.",FromDocNo);
      WHILE ItemChargeAssgntPurch.FINDFIRST DO BEGIN
        ItemChargeAssgntPurch.DELETE;
        ItemChargeAssgntPurch."Document Type" := PurchOrderHeader."Document Type";
        ItemChargeAssgntPurch."Document No." := PurchOrderHeader."No.";
        IF NOT (ItemChargeAssgntPurch."Applies-to Doc. Type" IN
                [ItemChargeAssgntPurch."Applies-to Doc. Type"::Receipt,
                 ItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Shipment"])
        THEN BEGIN
          ItemChargeAssgntPurch."Applies-to Doc. Type" := ToDocType;
          ItemChargeAssgntPurch."Applies-to Doc. No." := ToDocNo;
        END;
        ItemChargeAssgntPurch.INSERT;
      END;
    END;

    [External]
    PROCEDURE GetPurchOrderHeader@1(VAR PurchHeader@1000 : Record 38);
    BEGIN
      PurchHeader := PurchOrderHeader;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeDeletePurchQuote@5(VAR QuotePurchHeader@1000 : Record 38;VAR OrderPurchHeader@1001 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertPurchOrderHeader@7(VAR PurchOrderHeader@1000 : Record 38;PurchQuoteHeader@1001 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertPurchOrderLine@8(VAR PurchOrderLine@1004 : Record 39;PurchOrderHeader@1003 : Record 38;PurchQuoteLine@1002 : Record 39;PurchQuoteHeader@1001 : Record 38);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertPurchOrderLine@9(VAR PurchaseQuoteLine@1000 : Record 39;VAR PurchaseOrderLine@1001 : Record 39);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertAllPurchOrderLines@4(VAR PurchOrderLine@1001 : Record 39;PurchQuoteHeader@1000 : Record 38);
    BEGIN
    END;

    BEGIN
    END.
  }
}

