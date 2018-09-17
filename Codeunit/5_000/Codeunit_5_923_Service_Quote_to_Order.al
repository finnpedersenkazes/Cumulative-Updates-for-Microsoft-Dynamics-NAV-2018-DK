OBJECT Codeunit 5923 Service-Quote to Order
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    TableNo=5900;
    Permissions=TableData 5914=m,
                TableData 5950=rimd;
    OnRun=VAR
            ServQuoteLine@1001 : Record 5902;
            Customer@1005 : Record 18;
            CustCheckCreditLimit@1000 : Codeunit 312;
            ItemCheckAvail@1002 : Codeunit 311;
            DocType@1003 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
          BEGIN
            OnBeforeRun(Rec);

            NewServHeader := Rec;

            ServMgtSetup.GET;

            NewServHeader."Document Type" := "Document Type"::Order;
            Customer.GET("Customer No.");
            Customer.CheckBlockedCustOnDocs(Customer,DocType::Quote,FALSE,FALSE);
            IF "Customer No." <> "Bill-to Customer No." THEN BEGIN
              Customer.GET("Bill-to Customer No.");
              Customer.CheckBlockedCustOnDocs(Customer,DocType::Quote,FALSE,FALSE);
            END;

            ValidateSalesPersonOnServiceHeader(Rec,TRUE,FALSE);

            CustCheckCreditLimit.ServiceHeaderCheck(NewServHeader);

            ServQuoteLine.SETRANGE("Document Type","Document Type");
            ServQuoteLine.SETRANGE("Document No.","No.");
            ServQuoteLine.SETRANGE(Type,ServQuoteLine.Type::Item);
            ServQuoteLine.SETFILTER("No.",'<>%1','');
            IF ServQuoteLine.FIND('-') THEN
              REPEAT
                ServLine := ServQuoteLine;
                ServLine.VALIDATE("Reserved Qty. (Base)",0);
                ServLine."Line No." := 0;
                IF GUIALLOWED THEN
                  IF ItemCheckAvail.ServiceInvLineCheck(ServLine) THEN
                    ItemCheckAvail.RaiseUpdateInterruptedError;
              UNTIL ServQuoteLine.NEXT = 0;

            MakeOrder(Rec);

            DELETE(TRUE);
          END;

  }
  CODE
  {
    VAR
      ServMgtSetup@1006 : Record 5911;
      RepairStatus@1004 : Record 5927;
      ServItemLine@1001 : Record 5901;
      ServItemLine2@1008 : Record 5901;
      ServLine@1000 : Record 5902;
      ServLine2@1009 : Record 5902;
      ServOrderAlloc@1005 : Record 5950;
      NewServHeader@1010 : Record 5900;
      LoanerEntry@1019 : Record 5914;
      ServCommentLine@1020 : Record 5906;
      ServCommentLine2@1021 : Record 5906;
      NoSeriesMgt@1007 : Codeunit 396;
      ServLogMgt@1011 : Codeunit 5906;
      ReserveServiceLine@1012 : Codeunit 99000842;

    LOCAL PROCEDURE TestNoSeries@21();
    BEGIN
      ServMgtSetup.TESTFIELD("Service Order Nos.");
    END;

    LOCAL PROCEDURE GetNoSeriesCode@20() : Code[20];
    BEGIN
      EXIT(ServMgtSetup."Service Order Nos.");
    END;

    [External]
    PROCEDURE ReturnOrderNo@1() : Code[20];
    BEGIN
      EXIT(NewServHeader."No.");
    END;

    LOCAL PROCEDURE InsertServHeader@4(VAR ServiceHeaderOrder@1001 : Record 5900;ServiceHeaderQuote@1000 : Record 5900);
    BEGIN
      ServiceHeaderOrder.INSERT(TRUE);
      ServiceHeaderOrder."Document Date" := ServiceHeaderQuote."Document Date";
      ServiceHeaderOrder."Location Code" := ServiceHeaderQuote."Location Code";
      ServiceHeaderOrder.MODIFY;

      OnAfterInsertServHeader(ServiceHeaderOrder,ServiceHeaderQuote);
    END;

    LOCAL PROCEDURE MakeOrder@3(ServiceHeader@1000 : Record 5900);
    VAR
      ApprovalsMgmt@1002 : Codeunit 1535;
      RecordLinkManagement@1001 : Codeunit 447;
    BEGIN
      WITH NewServHeader DO BEGIN
        "No." := '';
        "No. Printed" := 0;
        VALIDATE(Status,Status::Pending);
        "Order Date" := WORKDATE;
        "Order Time" := TIME;
        "Actual Response Time (Hours)" := 0;
        "Service Time (Hours)" := 0;
        "Starting Date" := 0D;
        "Starting Time" := 0T;
        "Finishing Date" := 0D;
        "Finishing Time" := 0T;

        TestNoSeries;
        NoSeriesMgt.InitSeries(GetNoSeriesCode,'',0D,"No.","No. Series");

        "Quote No." := ServiceHeader."No.";
        RecordLinkManagement.CopyLinks(ServiceHeader,NewServHeader);
        InsertServHeader(NewServHeader,ServiceHeader);

        ServCommentLine.RESET;
        ServCommentLine.SETRANGE("Table Name",ServCommentLine."Table Name"::"Service Header");
        ServCommentLine.SETRANGE("Table Subtype",ServiceHeader."Document Type");
        ServCommentLine.SETRANGE("No.",ServiceHeader."No.");
        ServCommentLine.SETRANGE("Table Line No.",0);
        IF ServCommentLine.FIND('-') THEN
          REPEAT
            ServCommentLine2 := ServCommentLine;
            ServCommentLine2."Table Subtype" := "Document Type";
            ServCommentLine2."No." := "No.";
            ServCommentLine2.INSERT;
          UNTIL ServCommentLine.NEXT = 0;

        ServOrderAlloc.RESET;
        ServOrderAlloc.SETCURRENTKEY("Document Type","Document No.",Status);
        ServOrderAlloc.SETRANGE("Document Type",ServiceHeader."Document Type");
        ServOrderAlloc.SETRANGE("Document No.",ServiceHeader."No.");
        ServOrderAlloc.SETRANGE(Status,ServOrderAlloc.Status::Active);
        WHILE ServOrderAlloc.FINDFIRST DO BEGIN
          ServOrderAlloc."Document Type" := "Document Type";
          ServOrderAlloc."Document No." := "No.";
          ServOrderAlloc."Service Started" := TRUE;
          ServOrderAlloc.Status := ServOrderAlloc.Status::"Reallocation Needed";
          ServOrderAlloc.MODIFY;
        END;

        ServItemLine.RESET;
        ServItemLine.SETRANGE("Document Type",ServiceHeader."Document Type");
        ServItemLine.SETRANGE("Document No.",ServiceHeader."No.");
        IF ServItemLine.FIND('-') THEN
          REPEAT
            ServItemLine2 := ServItemLine;
            ServItemLine2."Document Type" := "Document Type";
            ServItemLine2."Document No." := "No.";
            ServItemLine2."Starting Date" := 0D;
            ServItemLine2."Starting Time" := 0T;
            ServItemLine2."Actual Response Time (Hours)" := 0;
            ServItemLine2."Finishing Date" := 0D;
            ServItemLine2."Finishing Time" := 0T;
            RepairStatus.RESET;
            RepairStatus.SETRANGE(Initial,TRUE);
            IF RepairStatus.FINDFIRST THEN
              ServItemLine2."Repair Status Code" := RepairStatus.Code;
            ServItemLine2.INSERT(TRUE);
            OnAfterInsertServiceLine(ServItemLine2,ServItemLine);
          UNTIL ServItemLine.NEXT = 0;

        UpdateResponseDateTime;

        LoanerEntry.RESET;
        LoanerEntry.SETCURRENTKEY("Document Type","Document No.");
        LoanerEntry.SETRANGE("Document Type",ServiceHeader."Document Type" + 1);
        LoanerEntry.SETRANGE("Document No.",ServiceHeader."No.");
        WHILE LoanerEntry.FINDFIRST DO BEGIN
          LoanerEntry."Document Type" := "Document Type" + 1;
          LoanerEntry."Document No." := "No.";
          LoanerEntry.MODIFY;
        END;

        ServCommentLine.RESET;
        ServCommentLine.SETRANGE("Table Name",ServCommentLine."Table Name"::"Service Header");
        ServCommentLine.SETRANGE("Table Subtype",ServiceHeader."Document Type");
        ServCommentLine.SETRANGE("No.",ServiceHeader."No.");
        ServCommentLine.SETFILTER("Table Line No.",'>%1',0);
        IF ServCommentLine.FIND('-') THEN
          REPEAT
            ServCommentLine2 := ServCommentLine;
            ServCommentLine2."Table Subtype" := "Document Type";
            ServCommentLine2."No." := "No.";
            ServCommentLine2.INSERT;
          UNTIL ServCommentLine.NEXT = 0;

        ServLine.RESET;
        ServLine.SETRANGE("Document Type",ServiceHeader."Document Type");
        ServLine.SETRANGE("Document No.",ServiceHeader."No.");
        IF ServLine.FIND('-') THEN
          REPEAT
            ServLine2 := ServLine;
            ServLine2."Document Type" := "Document Type";
            ServLine2."Document No." := "No.";
            ServLine2."Posting Date" := "Posting Date";
            ServLine2.INSERT;
            ReserveServiceLine.TransServLineToServLine(ServLine,ServLine2,ServLine.Quantity);
          UNTIL ServLine.NEXT = 0;

        ServLogMgt.ServOrderQuoteChanged(NewServHeader,ServiceHeader);
        ApprovalsMgmt.CopyApprovalEntryQuoteToOrder(ServiceHeader.RECORDID,"No.",RECORDID);
        ApprovalsMgmt.DeleteApprovalEntries(ServiceHeader.RECORDID);
        ServLine.DELETEALL(TRUE);
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeRun@2(VAR ServiceHeader@1000 : Record 5900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertServHeader@5(VAR ServiceHeaderOrder@1000 : Record 5900;ServiceHeaderQuote@1001 : Record 5900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertServiceLine@7(VAR ServiceItemLine2@1000 : Record 5901;ServiceItemLine@1001 : Record 5901);
    BEGIN
    END;

    BEGIN
    END.
  }
}

