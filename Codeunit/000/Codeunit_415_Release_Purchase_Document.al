OBJECT Codeunit 415 Release Purchase Document
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    TableNo=38;
    OnRun=BEGIN
            PurchaseHeader.COPY(Rec);
            Code;
            Rec := PurchaseHeader;
          END;

  }
  CODE
  {
    VAR
      Text001@1010 : TextConst 'DAN=Der er ikke noget at frigive for dokumentet af typen %1 med nummer %2.;ENU=There is nothing to release for the document of type %1 with the number %2.';
      PurchSetup@1002 : Record 312;
      InvtSetup@1000 : Record 313;
      PurchaseHeader@1007 : Record 38;
      WhsePurchRelease@1004 : Codeunit 5772;
      Text002@1005 : TextConst 'DAN=Dette dokument kan kun frigives, n†r godkendelsesprocessen er fuldf›rt.;ENU=This document can only be released when the approval process is complete.';
      Text003@1006 : TextConst 'DAN=Godkendelsesprocessen skal annulleres eller fuldf›res, inden dette dokument kan †bnes igen.;ENU=The approval process must be cancelled or completed to reopen this document.';
      Text005@1001 : TextConst 'DAN=Der er ubetalte forudbetalingsfakturaer, der er knyttet til dokumentet af typen %1 med nummer %2.;ENU=There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
      UnpostedPrepaymentAmountsErr@1003 : TextConst '@@@="%1 - Document Type; %2 - Document No.";DAN=Der er ikke-bogf›rte forudbetalingsbel›b p† dokumentet af typen %1 med nummer %2.;ENU=There are unposted prepayment amounts on the document of type %1 with the number %2.';
      PreviewMode@1008 : Boolean;
      SkipCheckReleaseRestrictions@1009 : Boolean;

    LOCAL PROCEDURE Code@11() LinesWereModified : Boolean;
    VAR
      PurchLine@1006 : Record 39;
      PrepaymentMgt@1003 : Codeunit 441;
      NotOnlyDropShipment@1002 : Boolean;
      PostingDate@1001 : Date;
      PrintPostedDocuments@1000 : Boolean;
    BEGIN
      WITH PurchaseHeader DO BEGIN
        IF Status = Status::Released THEN
          EXIT;

        OnBeforeReleasePurchaseDoc(PurchaseHeader,PreviewMode);
        IF NOT (PreviewMode OR SkipCheckReleaseRestrictions) THEN
          CheckPurchaseReleaseRestrictions;

        TESTFIELD("Buy-from Vendor No.");

        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        PurchLine.SETFILTER(Type,'>0');
        PurchLine.SETFILTER(Quantity,'<>0');
        IF NOT PurchLine.FIND('-') THEN
          ERROR(Text001,"Document Type","No.");
        InvtSetup.GET;
        IF InvtSetup."Location Mandatory" THEN BEGIN
          PurchLine.SETRANGE(Type,PurchLine.Type::Item);
          IF PurchLine.FIND('-') THEN
            REPEAT
              IF NOT PurchLine.IsServiceItem THEN
                PurchLine.TESTFIELD("Location Code");
            UNTIL PurchLine.NEXT = 0;
          PurchLine.SETFILTER(Type,'>0');
        END;
        PurchLine.SETRANGE("Drop Shipment",FALSE);
        NotOnlyDropShipment := PurchLine.FIND('-');
        PurchLine.RESET;

        PurchSetup.GET;
        IF PurchSetup."Calc. Inv. Discount" THEN BEGIN
          PostingDate := "Posting Date";
          PrintPostedDocuments := "Print Posted Documents";
          CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",PurchLine);
          LinesWereModified := TRUE;
          GET("Document Type","No.");
          "Print Posted Documents" := PrintPostedDocuments;
          IF PostingDate <> "Posting Date" THEN
            VALIDATE("Posting Date",PostingDate);
        END;

        IF PrepaymentMgt.TestPurchasePrepayment(PurchaseHeader) AND ("Document Type" = "Document Type"::Order) THEN BEGIN
          Status := Status::"Pending Prepayment";
          MODIFY(TRUE);
          EXIT;
        END;
        Status := Status::Released;

        LinesWereModified := LinesWereModified OR CalcAndUpdateVATOnLines(PurchaseHeader,PurchLine);

        MODIFY(TRUE);

        IF NotOnlyDropShipment THEN
          IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
            WhsePurchRelease.Release(PurchaseHeader);

        OnAfterReleasePurchaseDoc(PurchaseHeader,PreviewMode,LinesWereModified);
      END;
    END;

    [External]
    PROCEDURE Reopen@1(VAR PurchHeader@1000 : Record 38);
    BEGIN
      OnBeforeReopenPurchaseDoc(PurchHeader);

      WITH PurchHeader DO BEGIN
        IF Status = Status::Open THEN
          EXIT;
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
          WhsePurchRelease.Reopen(PurchHeader);
        Status := Status::Open;

        MODIFY(TRUE);
      END;

      OnAfterReopenPurchaseDoc(PurchHeader);
    END;

    [External]
    PROCEDURE PerformManualRelease@2(VAR PurchHeader@1002 : Record 38);
    VAR
      PrepaymentMgt@1001 : Codeunit 441;
    BEGIN
      IF PrepaymentMgt.TestPurchasePrepayment(PurchHeader) THEN
        ERROR(UnpostedPrepaymentAmountsErr,PurchHeader."Document Type",PurchHeader."No.");

      PerformManualCheckAndRelease(PurchHeader);
    END;

    [External]
    PROCEDURE PerformManualCheckAndRelease@13(VAR PurchHeader@1002 : Record 38);
    VAR
      PrepaymentMgt@1001 : Codeunit 441;
      ApprovalsMgmt@1000 : Codeunit 1535;
    BEGIN
      WITH PurchHeader DO
        IF ("Document Type" = "Document Type"::Order) AND PrepaymentMgt.TestPurchasePayment(PurchHeader) THEN BEGIN
          IF Status <> Status::"Pending Prepayment" THEN BEGIN
            Status := Status::"Pending Prepayment";
            MODIFY;
            COMMIT;
          END;
          ERROR(STRSUBSTNO(Text005,"Document Type","No."));
        END;

      IF ApprovalsMgmt.IsPurchaseHeaderPendingApproval(PurchHeader) THEN
        ERROR(Text002);

      CODEUNIT.RUN(CODEUNIT::"Release Purchase Document",PurchHeader);
    END;

    [External]
    PROCEDURE PerformManualReopen@3(VAR PurchHeader@1002 : Record 38);
    BEGIN
      IF PurchHeader.Status = PurchHeader.Status::"Pending Approval" THEN
        ERROR(Text003);

      Reopen(PurchHeader);
    END;

    [External]
    PROCEDURE ReleasePurchaseHeader@8(VAR PurchHdr@1000 : Record 38;Preview@1001 : Boolean) LinesWereModified : Boolean;
    BEGIN
      PreviewMode := Preview;
      PurchaseHeader.COPY(PurchHdr);
      LinesWereModified := Code;
      PurchHdr := PurchaseHeader;
    END;

    PROCEDURE CalcAndUpdateVATOnLines@9(VAR PurchaseHeader@1003 : Record 38;VAR PurchLine@1002 : Record 39) LinesWereModified : Boolean;
    VAR
      TempVATAmountLine0@1001 : TEMPORARY Record 290;
      TempVATAmountLine1@1000 : TEMPORARY Record 290;
    BEGIN
      PurchLine.SetPurchHeader(PurchaseHeader);
      PurchLine.CalcVATAmountLines(0,PurchaseHeader,PurchLine,TempVATAmountLine0);
      PurchLine.CalcVATAmountLines(1,PurchaseHeader,PurchLine,TempVATAmountLine1);
      LinesWereModified :=
        PurchLine.UpdateVATOnLines(0,PurchaseHeader,PurchLine,TempVATAmountLine0) OR
        PurchLine.UpdateVATOnLines(1,PurchaseHeader,PurchLine,TempVATAmountLine1);
    END;

    PROCEDURE SetSkipCheckReleaseRestrictions@17();
    BEGIN
      SkipCheckReleaseRestrictions := TRUE;
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeReleasePurchaseDoc@5(VAR PurchaseHeader@1000 : Record 38;PreviewMode@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterReleasePurchaseDoc@4(VAR PurchaseHeader@1000 : Record 38;PreviewMode@1001 : Boolean;LinesWereModified@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeReopenPurchaseDoc@6(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterReopenPurchaseDoc@7(VAR PurchaseHeader@1000 : Record 38);
    BEGIN
    END;

    BEGIN
    END.
  }
}

