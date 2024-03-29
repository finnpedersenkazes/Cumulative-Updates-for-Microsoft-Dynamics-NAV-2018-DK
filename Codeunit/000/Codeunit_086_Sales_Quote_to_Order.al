OBJECT Codeunit 86 Sales-Quote to Order
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
    OnRun=VAR
            Cust@1008 : Record 18;
            SalesCommentLine@1005 : Record 44;
            ApprovalsMgmt@1002 : Codeunit 1535;
            ArchiveManagement@1001 : Codeunit 5063;
            SalesCalcDiscountByType@1003 : Codeunit 56;
            RecordLinkManagement@1000 : Codeunit 447;
            ShouldRedistributeInvoiceAmount@1004 : Boolean;
          BEGIN
            TESTFIELD("Document Type","Document Type"::Quote);
            ShouldRedistributeInvoiceAmount := SalesCalcDiscountByType.ShouldRedistributeInvoiceDiscountAmount(Rec);

            OnCheckSalesPostRestrictions;

            Cust.GET("Sell-to Customer No.");
            Cust.CheckBlockedCustOnDocs(Cust,"Document Type"::Order,TRUE,FALSE);
            IF "Sell-to Customer No." <> "Bill-to Customer No." THEN BEGIN
              Cust.GET("Bill-to Customer No.");
              Cust.CheckBlockedCustOnDocs(Cust,"Document Type"::Order,TRUE,FALSE);
            END;
            CALCFIELDS("Amount Including VAT","Work Description");

            ValidateSalesPersonOnSalesHeader(Rec,TRUE,FALSE);

            CheckInProgressOpportunities(Rec);

            CreateSalesHeader(Rec,Cust."Prepayment %");

            TransferQuoteToSalesOrderLines(SalesQuoteLine,Rec,SalesOrderLine,SalesOrderHeader,Cust);
            OnAfterInsertAllSalesOrderLines(SalesOrderLine,Rec);

            SalesSetup.GET;
            IF SalesSetup."Archive Quotes and Orders" THEN
              ArchiveManagement.ArchSalesDocumentNoConfirm(Rec);

            IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" THEN BEGIN
              SalesOrderHeader."Posting Date" := 0D;
              SalesOrderHeader.MODIFY;
            END;

            SalesCommentLine.CopyComments("Document Type",SalesOrderHeader."Document Type","No.",SalesOrderHeader."No.");
            RecordLinkManagement.CopyLinks(Rec,SalesOrderHeader);

            AssignItemCharges("Document Type","No.",SalesOrderHeader."Document Type",SalesOrderHeader."No.");

            MoveWonLostOpportunites(Rec,SalesOrderHeader);

            ApprovalsMgmt.CopyApprovalEntryQuoteToOrder(RECORDID,SalesOrderHeader."No.",SalesOrderHeader.RECORDID);
            ApprovalsMgmt.DeleteApprovalEntries(RECORDID);

            OnBeforeDeleteSalesQuote(Rec,SalesOrderHeader);

            DELETELINKS;
            DELETE;

            SalesQuoteLine.DELETEALL;

            IF NOT ShouldRedistributeInvoiceAmount THEN
              SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(SalesOrderHeader);

            OnAfterOnRun(Rec,SalesOrderHeader);
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst '@@@=An open Opportunity is linked to this Quote. The Opportunity has to be closed before the Quote can be converted to an Order. Do you want to close the Opportunity now and continue the conversion?;DAN=Der er knyttet et �bent %1 til dette %2. %1 skal lukkes, inden %2 kan konverteres til en %3. Vil du lukke %1 nu og forts�tte konverteringen?;ENU=An open %1 is linked to this %2. The %1 has to be closed before the %2 can be converted to an %3. Do you want to close the %1 now and continue the conversion?';
      Text001@1001 : TextConst '@@@=An open Opportunity is still linked to this Quote. The conversion to an Order was aborted.;DAN=Der er stadig knyttet et �bent %1 til dette %2. Konverteringen til en %3 blev afbrudt.;ENU=An open %1 is still linked to this %2. The conversion to an %3 was aborted.';
      SalesQuoteLine@1004 : Record 37;
      SalesOrderHeader@1006 : Record 36;
      SalesOrderLine@1007 : Record 37;
      SalesSetup@1002 : Record 311;

    LOCAL PROCEDURE CreateSalesHeader@6(SalesHeader@1000 : Record 36;PrepmtPercent@1001 : Decimal);
    BEGIN
      WITH SalesHeader DO BEGIN
        SalesOrderHeader := SalesHeader;
        SalesOrderHeader."Document Type" := SalesOrderHeader."Document Type"::Order;

        SalesOrderHeader."No. Printed" := 0;
        SalesOrderHeader.Status := SalesOrderHeader.Status::Open;
        SalesOrderHeader."No." := '';
        SalesOrderHeader."Quote No." := "No.";
        SalesOrderLine.LOCKTABLE;
        SalesOrderHeader.INSERT(TRUE);

        SalesOrderHeader."Order Date" := "Order Date";
        IF "Posting Date" <> 0D THEN
          SalesOrderHeader."Posting Date" := "Posting Date";

        SalesOrderHeader.InitFromSalesHeader(SalesHeader);
        SalesOrderHeader."Outbound Whse. Handling Time" := "Outbound Whse. Handling Time";
        SalesOrderHeader.Reserve := Reserve;

        SalesOrderHeader."Prepayment %" := PrepmtPercent;
        IF SalesOrderHeader."Posting Date" = 0D THEN
          SalesOrderHeader."Posting Date" := WORKDATE;
        OnBeforeInsertSalesOrderHeader(SalesOrderHeader,SalesHeader);
        SalesOrderHeader.MODIFY;
      END;
    END;

    LOCAL PROCEDURE AssignItemCharges@15(FromDocType@1000 : Option;FromDocNo@1001 : Code[20];ToDocType@1003 : Option;ToDocNo@1002 : Code[20]);
    VAR
      ItemChargeAssgntSales@1004 : Record 5809;
    BEGIN
      ItemChargeAssgntSales.RESET;
      ItemChargeAssgntSales.SETRANGE("Document Type",FromDocType);
      ItemChargeAssgntSales.SETRANGE("Document No.",FromDocNo);
      WHILE ItemChargeAssgntSales.FINDFIRST DO BEGIN
        ItemChargeAssgntSales.DELETE;
        ItemChargeAssgntSales."Document Type" := SalesOrderHeader."Document Type";
        ItemChargeAssgntSales."Document No." := SalesOrderHeader."No.";
        IF NOT (ItemChargeAssgntSales."Applies-to Doc. Type" IN
                [ItemChargeAssgntSales."Applies-to Doc. Type"::Shipment,
                 ItemChargeAssgntSales."Applies-to Doc. Type"::"Return Receipt"])
        THEN BEGIN
          ItemChargeAssgntSales."Applies-to Doc. Type" := ToDocType;
          ItemChargeAssgntSales."Applies-to Doc. No." := ToDocNo;
        END;
        ItemChargeAssgntSales.INSERT;
      END;
    END;

    [External]
    PROCEDURE GetSalesOrderHeader@1(VAR SalesHeader2@1000 : Record 36);
    BEGIN
      SalesHeader2 := SalesOrderHeader;
    END;

    [External]
    PROCEDURE SetHideValidationDialog@14(NewHideValidationDialog@1000 : Boolean);
    BEGIN
      IF NewHideValidationDialog THEN
        EXIT;
    END;

    LOCAL PROCEDURE CheckInProgressOpportunities@2(VAR SalesHeader@1000 : Record 36);
    VAR
      Opp@1001 : Record 5092;
      TempOpportunityEntry@1002 : TEMPORARY Record 5093;
    BEGIN
      Opp.RESET;
      Opp.SETCURRENTKEY("Sales Document Type","Sales Document No.");
      Opp.SETRANGE("Sales Document Type",Opp."Sales Document Type"::Quote);
      Opp.SETRANGE("Sales Document No.",SalesHeader."No.");
      Opp.SETRANGE(Status,Opp.Status::"In Progress");
      IF Opp.FINDFIRST THEN BEGIN
        IF NOT CONFIRM(Text000,TRUE,Opp.TABLECAPTION,Opp."Sales Document Type"::Quote,Opp."Sales Document Type"::Order) THEN
          ERROR('');
        TempOpportunityEntry.DELETEALL;
        TempOpportunityEntry.INIT;
        TempOpportunityEntry.VALIDATE("Opportunity No.",Opp."No.");
        TempOpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
        TempOpportunityEntry."Contact No." := Opp."Contact No.";
        TempOpportunityEntry."Contact Company No." := Opp."Contact Company No.";
        TempOpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
        TempOpportunityEntry."Campaign No." := Opp."Campaign No.";
        TempOpportunityEntry."Action Taken" := TempOpportunityEntry."Action Taken"::Won;
        TempOpportunityEntry."Calcd. Current Value (LCY)" := TempOpportunityEntry.GetSalesDocValue(SalesHeader);
        TempOpportunityEntry."Cancel Old To Do" := TRUE;
        TempOpportunityEntry."Wizard Step" := 1;
        TempOpportunityEntry.INSERT;
        TempOpportunityEntry.SETRANGE("Action Taken",TempOpportunityEntry."Action Taken"::Won);
        PAGE.RUNMODAL(PAGE::"Close Opportunity",TempOpportunityEntry);
        Opp.RESET;
        Opp.SETCURRENTKEY("Sales Document Type","Sales Document No.");
        Opp.SETRANGE("Sales Document Type",Opp."Sales Document Type"::Quote);
        Opp.SETRANGE("Sales Document No.",SalesHeader."No.");
        Opp.SETRANGE(Status,Opp.Status::"In Progress");
        IF Opp.FINDFIRST THEN
          ERROR(Text001,Opp.TABLECAPTION,Opp."Sales Document Type"::Quote,Opp."Sales Document Type"::Order);
        COMMIT;
        SalesHeader.GET(SalesHeader."Document Type",SalesHeader."No.");
      END;
    END;

    LOCAL PROCEDURE MoveWonLostOpportunites@3(VAR SalesQuoteHeader@1000 : Record 36;VAR SalesOrderHeader@1001 : Record 36);
    VAR
      Opp@1002 : Record 5092;
      OpportunityEntry@1003 : Record 5093;
    BEGIN
      Opp.RESET;
      Opp.SETCURRENTKEY("Sales Document Type","Sales Document No.");
      Opp.SETRANGE("Sales Document Type",Opp."Sales Document Type"::Quote);
      Opp.SETRANGE("Sales Document No.",SalesQuoteHeader."No.");
      IF Opp.FINDFIRST THEN
        IF Opp.Status = Opp.Status::Won THEN BEGIN
          Opp."Sales Document Type" := Opp."Sales Document Type"::Order;
          Opp."Sales Document No." := SalesOrderHeader."No.";
          Opp.MODIFY;
          OpportunityEntry.RESET;
          OpportunityEntry.SETCURRENTKEY(Active,"Opportunity No.");
          OpportunityEntry.SETRANGE(Active,TRUE);
          OpportunityEntry.SETRANGE("Opportunity No.",Opp."No.");
          IF OpportunityEntry.FINDFIRST THEN BEGIN
            OpportunityEntry."Calcd. Current Value (LCY)" := OpportunityEntry.GetSalesDocValue(SalesOrderHeader);
            OpportunityEntry.MODIFY;
          END;
        END ELSE
          IF Opp.Status = Opp.Status::Lost THEN BEGIN
            Opp."Sales Document Type" := Opp."Sales Document Type"::" ";
            Opp."Sales Document No." := '';
            Opp.MODIFY;
          END;
    END;

    LOCAL PROCEDURE TransferQuoteToSalesOrderLines@5(VAR QuoteSalesLine@1000 : Record 37;VAR QuoteSalesHeader@1001 : Record 36;VAR OrderSalesLine@1004 : Record 37;VAR OrderSalesHeader@1005 : Record 36;Customer@1002 : Record 18);
    VAR
      ATOLink@1003 : Record 904;
      Resource@1008 : Record 156;
      PrepmtMgt@1007 : Codeunit 441;
      SalesLineReserve@1006 : Codeunit 99000832;
    BEGIN
      QuoteSalesLine.RESET;
      QuoteSalesLine.SETRANGE("Document Type",QuoteSalesHeader."Document Type");
      QuoteSalesLine.SETRANGE("Document No.",QuoteSalesHeader."No.");
      IF QuoteSalesLine.FINDSET THEN
        REPEAT
          IF QuoteSalesLine.Type = QuoteSalesLine.Type::Resource THEN
            IF QuoteSalesLine."No." <> '' THEN
              IF Resource.GET(QuoteSalesLine."No.") THEN BEGIN
                Resource.CheckResourcePrivacyBlocked(FALSE);
                Resource.TESTFIELD(Blocked,FALSE);
              END;
          OrderSalesLine := QuoteSalesLine;
          OrderSalesLine."Document Type" := OrderSalesHeader."Document Type";
          OrderSalesLine."Document No." := OrderSalesHeader."No.";
          OrderSalesLine."Shortcut Dimension 1 Code" := QuoteSalesLine."Shortcut Dimension 1 Code";
          OrderSalesLine."Shortcut Dimension 2 Code" := QuoteSalesLine."Shortcut Dimension 2 Code";
          OrderSalesLine."Dimension Set ID" := QuoteSalesLine."Dimension Set ID";
          IF Customer."Prepayment %" <> 0 THEN
            OrderSalesLine."Prepayment %" := Customer."Prepayment %";
          PrepmtMgt.SetSalesPrepaymentPct(OrderSalesLine,OrderSalesHeader."Posting Date");
          OrderSalesLine.VALIDATE("Prepayment %");
          IF OrderSalesLine."No." <> '' THEN
            OrderSalesLine.DefaultDeferralCode;
          OnBeforeInsertSalesOrderLine(OrderSalesLine,OrderSalesHeader,QuoteSalesLine,QuoteSalesHeader);
          OrderSalesLine.INSERT;
          OnAfterInsertSalesOrderLine(OrderSalesLine,OrderSalesHeader,QuoteSalesLine,QuoteSalesHeader);
          ATOLink.MakeAsmOrderLinkedToSalesOrderLine(QuoteSalesLine,OrderSalesLine);
          SalesLineReserve.TransferSaleLineToSalesLine(
            QuoteSalesLine,OrderSalesLine,QuoteSalesLine."Outstanding Qty. (Base)");
          SalesLineReserve.VerifyQuantity(OrderSalesLine,QuoteSalesLine);

          IF OrderSalesLine.Reserve = OrderSalesLine.Reserve::Always THEN
            OrderSalesLine.AutoReserve;

        UNTIL QuoteSalesLine.NEXT = 0;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeDeleteSalesQuote@4(VAR QuoteSalesHeader@1000 : Record 36;VAR OrderSalesHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertSalesOrderHeader@7(VAR SalesOrderHeader@1000 : Record 36;SalesQuoteHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertSalesOrderLine@9(VAR SalesOrderLine@1002 : Record 37;SalesOrderHeader@1001 : Record 36;SalesQuoteLine@1003 : Record 37;SalesQuoteHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertAllSalesOrderLines@11(VAR SalesOrderLine@1001 : Record 37;SalesQuoteHeader@1000 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterOnRun@10(VAR SalesHeader@1000 : Record 36;VAR SalesOrderHeader@1001 : Record 36);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertSalesOrderLine@8(VAR SalesOrderLine@1002 : Record 37;SalesOrderHeader@1001 : Record 36;SalesQuoteLine@1003 : Record 37;SalesQuoteHeader@1000 : Record 36);
    BEGIN
    END;

    BEGIN
    END.
  }
}

