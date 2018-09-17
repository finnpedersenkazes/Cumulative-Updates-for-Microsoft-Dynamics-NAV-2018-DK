OBJECT Codeunit 414 Release Sales Document
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    TableNo=36;
    OnRun=BEGIN
            SalesHeader.COPY(Rec);
            Code;
            Rec := SalesHeader;
          END;

  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Der er ikke noget at frigive for dokumentet af typen %1 med nummer %2.;ENU=There is nothing to release for the document of type %1 with the number %2.';
      SalesSetup@1002 : Record 311;
      InvtSetup@1000 : Record 313;
      SalesHeader@1008 : Record 36;
      WhseSalesRelease@1004 : Codeunit 5771;
      Text002@1005 : TextConst 'DAN=Dette dokument kan kun frigives, n†r godkendelsesprocessen er fuldf›rt.;ENU=This document can only be released when the approval process is complete.';
      Text003@1003 : TextConst 'DAN=Godkendelsesprocessen skal annulleres eller fuldf›res, inden dette dokument kan †bnes igen.;ENU=The approval process must be cancelled or completed to reopen this document.';
      Text005@1006 : TextConst 'DAN=Der er ubetalte forudbetalingsfakturaer, der er knyttet til dokumentet af typen %1 med nummer %2.;ENU=There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
      UnpostedPrepaymentAmountsErr@1007 : TextConst '@@@="%1 - Document Type; %2 - Document No.";DAN=Der er ikke-bogf›rte forudbetalingsbel›b p† dokumentet af typen %1 med nummer %2.;ENU=There are unposted prepayment amounts on the document of type %1 with the number %2.';
      PreviewMode@1009 : Boolean;

    LOCAL PROCEDURE Code@10() LinesWereModified : Boolean;
    VAR
      SalesLine@1006 : Record 37;
      PrepaymentMgt@1003 : Codeunit 441;
      NotOnlyDropShipment@1002 : Boolean;
      PostingDate@1001 : Date;
      PrintPostedDocuments@1000 : Boolean;
    BEGIN
      WITH SalesHeader DO BEGIN
        IF Status = Status::Released THEN
          EXIT;

        OnBeforeReleaseSalesDoc(SalesHeader,PreviewMode);
        IF NOT PreviewMode THEN
          CheckSalesReleaseRestrictions;

        IF "Document Type" = "Document Type"::Quote THEN
          IF CheckCustomerCreated(TRUE) THEN
            GET("Document Type"::Quote,"No.")
          ELSE
            EXIT;

        TESTFIELD("Sell-to Customer No.");

        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.SETFILTER(Type,'>0');
        SalesLine.SETFILTER(Quantity,'<>0');
        IF NOT SalesLine.FIND('-') THEN
          ERROR(Text001,"Document Type","No.");
        InvtSetup.GET;
        IF InvtSetup."Location Mandatory" THEN BEGIN
          SalesLine.SETRANGE(Type,SalesLine.Type::Item);
          IF SalesLine.FINDSET THEN
            REPEAT
              IF NOT SalesLine.IsServiceItem THEN
                SalesLine.TESTFIELD("Location Code");
            UNTIL SalesLine.NEXT = 0;
          SalesLine.SETFILTER(Type,'>0');
        END;
        SalesLine.SETRANGE("Drop Shipment",FALSE);
        NotOnlyDropShipment := SalesLine.FINDFIRST;
        SalesLine.RESET;

        SalesSetup.GET;
        IF SalesSetup."Calc. Inv. Discount" THEN BEGIN
          PostingDate := "Posting Date";
          PrintPostedDocuments := "Print Posted Documents";
          CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",SalesLine);
          LinesWereModified := TRUE;
          GET("Document Type","No.");
          "Print Posted Documents" := PrintPostedDocuments;
          IF PostingDate <> "Posting Date" THEN
            VALIDATE("Posting Date",PostingDate);
        END;

        IF PrepaymentMgt.TestSalesPrepayment(SalesHeader) AND ("Document Type" = "Document Type"::Order) THEN BEGIN
          Status := Status::"Pending Prepayment";
          MODIFY(TRUE);
          EXIT;
        END;
        Status := Status::Released;

        LinesWereModified := LinesWereModified OR CalcAndUpdateVATOnLines(SalesHeader,SalesLine);

        ReleaseATOs(SalesHeader);
        OnAfterReleaseATOs(SalesHeader,SalesLine);

        MODIFY(TRUE);

        IF NotOnlyDropShipment THEN
          IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
            WhseSalesRelease.Release(SalesHeader);

        OnAfterReleaseSalesDoc(SalesHeader,PreviewMode,LinesWereModified);
      END;
    END;

    [External]
    PROCEDURE Reopen@1(VAR SalesHeader@1000 : Record 36);
    BEGIN
      OnBeforeReopenSalesDoc(SalesHeader);

      WITH SalesHeader DO BEGIN
        IF Status = Status::Open THEN
          EXIT;
        Status := Status::Open;

        IF "Document Type" <> "Document Type"::Order THEN
          ReopenATOs(SalesHeader);

        MODIFY(TRUE);
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"] THEN
          WhseSalesRelease.Reopen(SalesHeader);
      END;

      OnAfterReopenSalesDoc(SalesHeader);
    END;

    [External]
    PROCEDURE PerformManualRelease@2(VAR SalesHeader@1002 : Record 36);
    VAR
      PrepaymentMgt@1001 : Codeunit 441;
    BEGIN
      IF PrepaymentMgt.TestSalesPrepayment(SalesHeader) THEN
        ERROR(UnpostedPrepaymentAmountsErr,SalesHeader."Document Type",SalesHeader."No.");

      PerformManualCheckAndRelease(SalesHeader);
    END;

    PROCEDURE PerformManualCheckAndRelease@13(VAR SalesHeader@1002 : Record 36);
    VAR
      PrepaymentMgt@1001 : Codeunit 441;
      ApprovalsMgmt@1000 : Codeunit 1535;
    BEGIN
      WITH SalesHeader DO
        IF ("Document Type" = "Document Type"::Order) AND PrepaymentMgt.TestSalesPayment(SalesHeader) THEN BEGIN
          IF Status <> Status::"Pending Prepayment" THEN BEGIN
            Status := Status::"Pending Prepayment";
            MODIFY;
            COMMIT;
          END;
          ERROR(STRSUBSTNO(Text005,"Document Type","No."));
        END;

      IF ApprovalsMgmt.IsSalesHeaderPendingApproval(SalesHeader) THEN
        ERROR(Text002);

      CODEUNIT.RUN(CODEUNIT::"Release Sales Document",SalesHeader);
    END;

    [External]
    PROCEDURE PerformManualReopen@3(VAR SalesHeader@1002 : Record 36);
    BEGIN
      IF SalesHeader.Status = SalesHeader.Status::"Pending Approval" THEN
        ERROR(Text003);

      Reopen(SalesHeader);
    END;

    LOCAL PROCEDURE ReleaseATOs@5(SalesHeader@1000 : Record 36);
    VAR
      SalesLine@1001 : Record 37;
      AsmHeader@1002 : Record 900;
    BEGIN
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      IF SalesLine.FINDSET THEN
        REPEAT
          IF SalesLine.AsmToOrderExists(AsmHeader) THEN
            CODEUNIT.RUN(CODEUNIT::"Release Assembly Document",AsmHeader);
        UNTIL SalesLine.NEXT = 0;
    END;

    LOCAL PROCEDURE ReopenATOs@6(SalesHeader@1000 : Record 36);
    VAR
      SalesLine@1001 : Record 37;
      AsmHeader@1002 : Record 900;
      ReleaseAssemblyDocument@1003 : Codeunit 903;
    BEGIN
      SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
      SalesLine.SETRANGE("Document No.",SalesHeader."No.");
      IF SalesLine.FINDSET THEN
        REPEAT
          IF SalesLine.AsmToOrderExists(AsmHeader) THEN
            ReleaseAssemblyDocument.Reopen(AsmHeader);
        UNTIL SalesLine.NEXT = 0;
    END;

    [External]
    PROCEDURE ReleaseSalesHeader@11(VAR SalesHdr@1000 : Record 36;Preview@1001 : Boolean) LinesWereModified : Boolean;
    BEGIN
      PreviewMode := Preview;
      SalesHeader.COPY(SalesHdr);
      LinesWereModified := Code;
      SalesHdr := SalesHeader;
    END;

    PROCEDURE CalcAndUpdateVATOnLines@14(VAR SalesHeader@1003 : Record 36;VAR SalesLine@1002 : Record 37) LinesWereModified : Boolean;
    VAR
      TempVATAmountLine0@1001 : TEMPORARY Record 290;
      TempVATAmountLine1@1000 : TEMPORARY Record 290;
    BEGIN
      SalesLine.SetSalesHeader(SalesHeader);
      SalesLine.CalcVATAmountLines(0,SalesHeader,SalesLine,TempVATAmountLine0);
      SalesLine.CalcVATAmountLines(1,SalesHeader,SalesLine,TempVATAmountLine1);
      LinesWereModified :=
        SalesLine.UpdateVATOnLines(0,SalesHeader,SalesLine,TempVATAmountLine0) OR
        SalesLine.UpdateVATOnLines(1,SalesHeader,SalesLine,TempVATAmountLine1);
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeReleaseSalesDoc@7(VAR SalesHeader@1000 : Record 36;PreviewMode@1001 : Boolean);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterReleaseSalesDoc@4(VAR SalesHeader@1000 : Record 36;PreviewMode@1001 : Boolean;LinesWereModified@1002 : Boolean);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnBeforeReopenSalesDoc@8(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterReopenSalesDoc@9(VAR SalesHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    [External]
    LOCAL PROCEDURE OnAfterReleaseATOs@12(VAR SalesHeader@1000 : Record 36;VAR SalesLine@1001 : Record 37);
    BEGIN
    END;

    BEGIN
    END.
  }
}

