OBJECT Codeunit 427 ICInboxOutboxMgt
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    Permissions=TableData 98=rm;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      GLSetup@1000 : Record 98;
      CompanyInfo@1008 : Record 79;
      DimMgt@1002 : Codeunit 408;
      GLSetupFound@1001 : Boolean;
      CompanyInfoFound@1009 : Boolean;
      Text000@1003 : TextConst 'DAN=Vil du genoprette transaktionen?;ENU=Do you want to re-create the transaction?';
      Text001@1004 : TextConst 'DAN=%1 %2 findes ikke som %3 i %1 %4.;ENU=%1 %2 does not exist as a %3 in %1 %4.';
      Text002@1005 : TextConst 'DAN=Du kan ikke sende IC-dokumentet, fordi %1 %2 har %3 %4.;ENU=You cannot send IC document because %1 %2 has %3 %4.';
      Text004@1006 : TextConst 'DAN=Transaktionen %1 for %2 %3 findes allerede i %4-tabellen.;ENU=Transaction %1 for %2 %3 already exists in the %4 table.';
      Text005@1007 : TextConst 'DAN=%1 skal v�re %2 eller %3 for at kunne genoprettes.;ENU=%1 must be %2 or %3 in order to be re-created.';
      NoItemForCommonItemErr@1010 : TextConst '@@@="%1 = Common Item No value";DAN=Der er ingen vare med relation til det f�lles varenr. %1;ENU=There is no Item related to Common Item No. %1';

    [External]
    PROCEDURE CreateOutboxJnlTransaction@1(TempGenJnlLine@1000 : TEMPORARY Record 81;Rejection@1002 : Boolean) : Integer;
    VAR
      ICPartner@1001 : Record 413;
      OutboxJnlTransaction@1003 : Record 414;
      ICTransactionNo@1004 : Integer;
    BEGIN
      ICPartner.GET(TempGenJnlLine."IC Partner Code");
      IF ICPartner."Inbox Type" = ICPartner."Inbox Type"::"No IC Transfer" THEN
        EXIT(0);

      GLSetup.LOCKTABLE;
      GetGLSetup;
      IF GLSetup."Last IC Transaction No." < 0 THEN
        GLSetup."Last IC Transaction No." := 0;
      ICTransactionNo := GLSetup."Last IC Transaction No." + 1;
      GLSetup."Last IC Transaction No." := ICTransactionNo;
      GLSetup.MODIFY;

      WITH TempGenJnlLine DO BEGIN
        OutboxJnlTransaction.INIT;
        OutboxJnlTransaction."Transaction No." := ICTransactionNo;
        OutboxJnlTransaction."IC Partner Code" := "IC Partner Code";
        OutboxJnlTransaction."Source Type" := OutboxJnlTransaction."Source Type"::"Journal Line";
        OutboxJnlTransaction."Document Type" := "Document Type";
        OutboxJnlTransaction."Document No." := "Document No.";
        OutboxJnlTransaction."Posting Date" := "Posting Date";
        OutboxJnlTransaction."Document Date" := "Document Date";
        OutboxJnlTransaction."IC Partner G/L Acc. No." := "IC Partner G/L Acc. No.";
        OutboxJnlTransaction."Source Line No." := "Source Line No.";
        IF Rejection THEN
          OutboxJnlTransaction."Transaction Source" := OutboxJnlTransaction."Transaction Source"::"Rejected by Current Company"
        ELSE
          OutboxJnlTransaction."Transaction Source" := OutboxJnlTransaction."Transaction Source"::"Created by Current Company";
        OutboxJnlTransaction.INSERT;
      END;
      EXIT(ICTransactionNo);
    END;

    [External]
    PROCEDURE SendSalesDoc@11(VAR SalesHeader@1000 : Record 36;Post@1003 : Boolean);
    VAR
      ICPartner@1002 : Record 413;
    BEGIN
      SalesHeader.TESTFIELD("Send IC Document");
      IF SalesHeader."Sell-to IC Partner Code" <> '' THEN
        ICPartner.GET(SalesHeader."Sell-to IC Partner Code")
      ELSE
        ICPartner.GET(SalesHeader."Bill-to IC Partner Code");
      IF ICPartner."Inbox Type" = ICPartner."Inbox Type"::"No IC Transfer" THEN
        IF Post THEN
          EXIT
        ELSE
          ERROR(Text002,ICPartner.TABLECAPTION,ICPartner.Code,ICPartner.FIELDCAPTION("Inbox Type"),ICPartner."Inbox Type");
      ICPartner.TESTFIELD(Blocked,FALSE);
      IF NOT Post THEN
        CODEUNIT.RUN(CODEUNIT::"Release Sales Document",SalesHeader);
      IF SalesHeader."Sell-to IC Partner Code" <> '' THEN
        CreateOutboxSalesDocTrans(SalesHeader,FALSE,Post);
    END;

    [External]
    PROCEDURE SendPurchDoc@16(VAR PurchHeader@1002 : Record 38;Post@1003 : Boolean);
    VAR
      ICPartner@1004 : Record 413;
    BEGIN
      PurchHeader.TESTFIELD("Send IC Document");
      ICPartner.GET(PurchHeader."Buy-from IC Partner Code");
      IF ICPartner."Inbox Type" = ICPartner."Inbox Type"::"No IC Transfer" THEN
        IF Post THEN
          EXIT
        ELSE
          ERROR(Text002,ICPartner.TABLECAPTION,ICPartner.Code,ICPartner.FIELDCAPTION("Inbox Type"),ICPartner."Inbox Type");
      ICPartner.TESTFIELD(Blocked,FALSE);
      IF NOT Post THEN
        CODEUNIT.RUN(CODEUNIT::"Release Purchase Document",PurchHeader);
      CreateOutboxPurchDocTrans(PurchHeader,FALSE,Post);
    END;

    [External]
    PROCEDURE CreateOutboxSalesDocTrans@9(SalesHeader@1007 : Record 36;Rejection@1008 : Boolean;Post@1005 : Boolean);
    VAR
      OutboxTransaction@1006 : Record 414;
      Customer@1003 : Record 18;
      SalesLine@1002 : Record 37;
      ICOutBoxSalesHeader@1001 : Record 426;
      ICOutBoxSalesLine@1000 : Record 427;
      TransactionNo@1004 : Integer;
      LinesCreated@1011 : Boolean;
    BEGIN
      GLSetup.LOCKTABLE;
      GetGLSetup;
      TransactionNo := GLSetup."Last IC Transaction No." + 1;
      GLSetup."Last IC Transaction No." := TransactionNo;
      GLSetup.MODIFY;
      Customer.GET(SalesHeader."Sell-to Customer No.");
      WITH SalesHeader DO BEGIN
        OutboxTransaction.INIT;
        OutboxTransaction."Transaction No." := TransactionNo;
        OutboxTransaction."IC Partner Code" := Customer."IC Partner Code";
        OutboxTransaction."Source Type" := OutboxTransaction."Source Type"::"Sales Document";
        CASE "Document Type" OF
          "Document Type"::Order:
            OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::Order;
          "Document Type"::Invoice:
            OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::Invoice;
          "Document Type"::"Credit Memo":
            OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::"Credit Memo";
          "Document Type"::"Return Order":
            OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::"Return Order";
        END;
        OutboxTransaction."Document No." := "No.";
        OutboxTransaction."Posting Date" := "Posting Date";
        OutboxTransaction."Document Date" := "Document Date";
        IF Rejection THEN
          OutboxTransaction."Transaction Source" := OutboxTransaction."Transaction Source"::"Rejected by Current Company"
        ELSE
          OutboxTransaction."Transaction Source" := OutboxTransaction."Transaction Source"::"Created by Current Company";
        OutboxTransaction.INSERT;
      END;
      ICOutBoxSalesHeader.TRANSFERFIELDS(SalesHeader);
      IF OutboxTransaction."Document Type" = OutboxTransaction."Document Type"::Order THEN
        ICOutBoxSalesHeader."Order No." := SalesHeader."No.";
      ICOutBoxSalesHeader."IC Partner Code" := OutboxTransaction."IC Partner Code";
      ICOutBoxSalesHeader."IC Transaction No." := OutboxTransaction."Transaction No.";
      ICOutBoxSalesHeader."Transaction Source" := OutboxTransaction."Transaction Source";
      AssignCurrencyCodeInOutBoxDoc(ICOutBoxSalesHeader."Currency Code",OutboxTransaction."IC Partner Code");
      DimMgt.CopyDocDimtoICDocDim(DATABASE::"IC Outbox Sales Header",ICOutBoxSalesHeader."IC Transaction No.",
        ICOutBoxSalesHeader."IC Partner Code",ICOutBoxSalesHeader."Transaction Source",0,SalesHeader."Dimension Set ID");

      WITH ICOutBoxSalesLine DO BEGIN
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type",SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.",SalesHeader."No.");
        IF SalesLine.FIND('-') THEN
          REPEAT
            INIT;
            TRANSFERFIELDS(SalesLine);
            CASE SalesLine."Document Type" OF
              SalesLine."Document Type"::Order:
                "Document Type" := "Document Type"::Order;
              SalesLine."Document Type"::Invoice:
                "Document Type" := "Document Type"::Invoice;
              SalesLine."Document Type"::"Credit Memo":
                "Document Type" := "Document Type"::"Credit Memo";
              SalesLine."Document Type"::"Return Order":
                "Document Type" := "Document Type"::"Return Order";
            END;
            "IC Transaction No." := OutboxTransaction."Transaction No.";
            "IC Partner Code" := OutboxTransaction."IC Partner Code";
            "Transaction Source" := OutboxTransaction."Transaction Source";
            "Currency Code" := ICOutBoxSalesHeader."Currency Code";
            IF SalesLine.Type = SalesLine.Type::" " THEN
              "IC Partner Reference" := '';
            DimMgt.CopyDocDimtoICDocDim(DATABASE::"IC Outbox Sales Line","IC Transaction No.","IC Partner Code","Transaction Source",
              "Line No.",SalesLine."Dimension Set ID");
            UpdateICOutboxSalesLineReceiptShipment(ICOutBoxSalesLine,ICOutBoxSalesHeader);
            IF INSERT(TRUE) THEN
              LinesCreated := TRUE;
          UNTIL SalesLine.NEXT = 0;
      END;

      IF LinesCreated THEN BEGIN
        ICOutBoxSalesHeader.INSERT;
        IF NOT Post THEN BEGIN
          SalesHeader."IC Status" := SalesHeader."IC Status"::Pending;
          SalesHeader.MODIFY;
        END;
      END;
      ICOutboxTransactionCreated(OutboxTransaction);
    END;

    [External]
    PROCEDURE CreateOutboxSalesInvTrans@33(SalesInvHdr@1007 : Record 112);
    VAR
      OutboxTransaction@1006 : Record 414;
      Customer@1003 : Record 18;
      ICPartner@1008 : Record 413;
      SalesInvLine@1002 : Record 113;
      ICOutBoxSalesHeader@1001 : Record 426;
      ICOutBoxSalesLine@1000 : Record 427;
      ICDocDim@1005 : Record 442;
      ItemCrossReference@1010 : Record 5717;
      Item@1014 : Record 27;
      TransactionNo@1004 : Integer;
      RoundingLineNo@1009 : Integer;
    BEGIN
      Customer.GET(SalesInvHdr."Bill-to Customer No.");
      ICPartner.GET(Customer."IC Partner Code");
      IF ICPartner."Inbox Type" = ICPartner."Inbox Type"::"No IC Transfer" THEN
        EXIT;

      GLSetup.LOCKTABLE;
      GetGLSetup;
      TransactionNo := GLSetup."Last IC Transaction No." + 1;
      GLSetup."Last IC Transaction No." := TransactionNo;
      GLSetup.MODIFY;
      WITH SalesInvHdr DO BEGIN
        OutboxTransaction.INIT;
        OutboxTransaction."Transaction No." := TransactionNo;
        OutboxTransaction."IC Partner Code" := Customer."IC Partner Code";
        OutboxTransaction."Source Type" := OutboxTransaction."Source Type"::"Sales Document";
        OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::Invoice;
        OutboxTransaction."Document No." := "No.";
        OutboxTransaction."Posting Date" := "Posting Date";
        OutboxTransaction."Document Date" := "Document Date";
        OutboxTransaction."Transaction Source" := OutboxTransaction."Transaction Source"::"Created by Current Company";
        OutboxTransaction.INSERT;
      END;
      ICOutBoxSalesHeader.TRANSFERFIELDS(SalesInvHdr);
      ICOutBoxSalesHeader."Document Type" := ICOutBoxSalesHeader."Document Type"::Invoice;
      ICOutBoxSalesHeader."IC Partner Code" := OutboxTransaction."IC Partner Code";
      ICOutBoxSalesHeader."IC Transaction No." := OutboxTransaction."Transaction No.";
      ICOutBoxSalesHeader."Transaction Source" := OutboxTransaction."Transaction Source";
      AssignCurrencyCodeInOutBoxDoc(ICOutBoxSalesHeader."Currency Code",OutboxTransaction."IC Partner Code");
      ICOutBoxSalesHeader.INSERT;

      ICDocDim.INIT;
      ICDocDim."Transaction No." := OutboxTransaction."Transaction No.";
      ICDocDim."IC Partner Code" := OutboxTransaction."IC Partner Code";
      ICDocDim."Transaction Source" := OutboxTransaction."Transaction Source";

      CreateICDocDimFromPostedDocDim(ICDocDim,SalesInvHdr."Dimension Set ID",DATABASE::"IC Outbox Sales Header");

      RoundingLineNo := FindRoundingSalesInvLine(SalesInvHdr."No.");
      WITH ICOutBoxSalesLine DO BEGIN
        SalesInvLine.RESET;
        SalesInvLine.SETRANGE("Document No.",SalesInvHdr."No.");
        IF RoundingLineNo <> 0 THEN
          SalesInvLine.SETRANGE("Line No.",0,RoundingLineNo - 1);
        IF SalesInvLine.FINDSET THEN
          REPEAT
            IF (SalesInvLine.Type = SalesInvLine.Type::" ") OR (SalesInvLine."No." <> '') THEN BEGIN
              INIT;
              TRANSFERFIELDS(SalesInvLine);
              "Document Type" := "Document Type"::Invoice;
              "IC Transaction No." := OutboxTransaction."Transaction No.";
              "IC Partner Code" := OutboxTransaction."IC Partner Code";
              "Transaction Source" := OutboxTransaction."Transaction Source";
              "Currency Code" := ICOutBoxSalesHeader."Currency Code";
              IF SalesInvLine.Type = SalesInvLine.Type::" " THEN
                "IC Partner Reference" := '';
              IF (SalesInvLine."Bill-to Customer No." <> SalesInvLine."Sell-to Customer No.") AND
                 (SalesInvLine.Type = SalesInvLine.Type::Item)
              THEN
                CASE ICPartner."Outbound Sales Item No. Type" OF
                  ICPartner."Outbound Sales Item No. Type"::"Internal No.":
                    BEGIN
                      "IC Partner Ref. Type" := "IC Partner Ref. Type"::Item;
                      "IC Partner Reference" := SalesInvLine."No.";
                    END;
                  ICPartner."Outbound Sales Item No. Type"::"Cross Reference":
                    BEGIN
                      VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Cross reference");
                      ItemCrossReference.SETRANGE("Cross-Reference Type",
                        ItemCrossReference."Cross-Reference Type"::Customer);
                      ItemCrossReference.SETRANGE("Cross-Reference Type No.",SalesInvLine."Bill-to Customer No.");
                      ItemCrossReference.SETRANGE("Item No.",SalesInvLine."No.");
                      IF ItemCrossReference.FINDFIRST THEN
                        "IC Partner Reference" := ItemCrossReference."Cross-Reference No.";
                    END;
                  ICPartner."Outbound Sales Item No. Type"::"Common Item No.":
                    BEGIN
                      Item.GET(SalesInvLine."No.");
                      "IC Partner Reference" := Item."Common Item No.";
                    END;
                END;
              UpdateICOutboxSalesLineReceiptShipment(ICOutBoxSalesLine,ICOutBoxSalesHeader);
              INSERT(TRUE);
              ICDocDim."Line No." := SalesInvLine."Line No.";
              CreateICDocDimFromPostedDocDim(ICDocDim,SalesInvLine."Dimension Set ID",DATABASE::"IC Outbox Sales Line");
            END;
          UNTIL SalesInvLine.NEXT = 0;
      END;

      ICOutboxTransactionCreated(OutboxTransaction);
    END;

    [External]
    PROCEDURE CreateOutboxSalesCrMemoTrans@35(SalesCrMemoHdr@1007 : Record 114);
    VAR
      OutboxTransaction@1006 : Record 414;
      Customer@1003 : Record 18;
      ICPartner@1008 : Record 413;
      SalesCrMemoLine@1002 : Record 115;
      ICOutBoxSalesHeader@1001 : Record 426;
      ICOutBoxSalesLine@1000 : Record 427;
      ICDocDim@1005 : Record 442;
      TransactionNo@1004 : Integer;
      RoundingLineNo@1009 : Integer;
    BEGIN
      Customer.GET(SalesCrMemoHdr."Bill-to Customer No.");
      ICPartner.GET(Customer."IC Partner Code");
      IF ICPartner."Inbox Type" = ICPartner."Inbox Type"::"No IC Transfer" THEN
        EXIT;

      GLSetup.LOCKTABLE;
      GetGLSetup;
      TransactionNo := GLSetup."Last IC Transaction No." + 1;
      GLSetup."Last IC Transaction No." := TransactionNo;
      GLSetup.MODIFY;
      WITH SalesCrMemoHdr DO BEGIN
        OutboxTransaction.INIT;
        OutboxTransaction."Transaction No." := TransactionNo;
        OutboxTransaction."IC Partner Code" := Customer."IC Partner Code";
        OutboxTransaction."Source Type" := OutboxTransaction."Source Type"::"Sales Document";
        OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::"Credit Memo";
        OutboxTransaction."Document No." := "No.";
        OutboxTransaction."Posting Date" := "Posting Date";
        OutboxTransaction."Document Date" := "Document Date";
        OutboxTransaction."Transaction Source" := OutboxTransaction."Transaction Source"::"Created by Current Company";
        OutboxTransaction.INSERT;
      END;
      ICOutBoxSalesHeader.TRANSFERFIELDS(SalesCrMemoHdr);
      ICOutBoxSalesHeader."Document Type" := ICOutBoxSalesHeader."Document Type"::"Credit Memo";
      ICOutBoxSalesHeader."IC Partner Code" := OutboxTransaction."IC Partner Code";
      ICOutBoxSalesHeader."IC Transaction No." := OutboxTransaction."Transaction No.";
      ICOutBoxSalesHeader."Transaction Source" := OutboxTransaction."Transaction Source";
      AssignCurrencyCodeInOutBoxDoc(ICOutBoxSalesHeader."Currency Code",OutboxTransaction."IC Partner Code");
      ICOutBoxSalesHeader.INSERT;

      ICDocDim.INIT;
      ICDocDim."Transaction No." := OutboxTransaction."Transaction No.";
      ICDocDim."IC Partner Code" := OutboxTransaction."IC Partner Code";
      ICDocDim."Transaction Source" := OutboxTransaction."Transaction Source";

      CreateICDocDimFromPostedDocDim(ICDocDim,SalesCrMemoHdr."Dimension Set ID",DATABASE::"IC Outbox Sales Header");

      RoundingLineNo := FindRoundingSalesCrMemoLine(SalesCrMemoHdr."No.");
      WITH ICOutBoxSalesLine DO BEGIN
        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETRANGE("Document No.",SalesCrMemoHdr."No.");
        IF RoundingLineNo <> 0 THEN
          SalesCrMemoLine.SETRANGE("Line No.",0,RoundingLineNo - 1);
        IF SalesCrMemoLine.FINDSET THEN
          REPEAT
            IF (SalesCrMemoLine.Type = SalesCrMemoLine.Type::" ") OR (SalesCrMemoLine."No." <> '') THEN BEGIN
              INIT;
              TRANSFERFIELDS(SalesCrMemoLine);
              "Document Type" := "Document Type"::"Credit Memo";
              "IC Transaction No." := OutboxTransaction."Transaction No.";
              "IC Partner Code" := OutboxTransaction."IC Partner Code";
              "Transaction Source" := OutboxTransaction."Transaction Source";
              "Currency Code" := ICOutBoxSalesHeader."Currency Code";
              IF SalesCrMemoLine.Type = SalesCrMemoLine.Type::" " THEN
                "IC Partner Reference" := '';
              UpdateICOutboxSalesLineReceiptShipment(ICOutBoxSalesLine,ICOutBoxSalesHeader);
              INSERT(TRUE);
              ICDocDim."Line No." := SalesCrMemoLine."Line No.";
              CreateICDocDimFromPostedDocDim(ICDocDim,SalesCrMemoLine."Dimension Set ID",DATABASE::"IC Outbox Sales Line");
            END;
          UNTIL SalesCrMemoLine.NEXT = 0;
      END;
      ICOutboxTransactionCreated(OutboxTransaction);
    END;

    [External]
    PROCEDURE CreateOutboxPurchDocTrans@10(PurchHeader@1007 : Record 38;Rejection@1008 : Boolean;Post@1012 : Boolean);
    VAR
      OutboxTransaction@1010 : Record 414;
      Vendor@1006 : Record 23;
      PurchLine@1005 : Record 39;
      ICOutBoxPurchHeader@1004 : Record 428;
      ICOutBoxPurchLine@1003 : Record 429;
      TransactionNo@1000 : Integer;
      LinesCreated@1011 : Boolean;
    BEGIN
      GLSetup.LOCKTABLE;
      GetGLSetup;
      TransactionNo := GLSetup."Last IC Transaction No." + 1;
      GLSetup."Last IC Transaction No." := TransactionNo;
      GLSetup.MODIFY;
      Vendor.GET(PurchHeader."Buy-from Vendor No.");
      Vendor.CheckBlockedVendOnDocs(Vendor,FALSE);
      WITH PurchHeader DO BEGIN
        OutboxTransaction.INIT;
        OutboxTransaction."Transaction No." := TransactionNo;
        OutboxTransaction."IC Partner Code" := Vendor."IC Partner Code";
        OutboxTransaction."Source Type" := OutboxTransaction."Source Type"::"Purchase Document";
        CASE "Document Type" OF
          "Document Type"::Order:
            OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::Order;
          "Document Type"::Invoice:
            OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::Invoice;
          "Document Type"::"Credit Memo":
            OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::"Credit Memo";
          "Document Type"::"Return Order":
            OutboxTransaction."Document Type" := OutboxTransaction."Document Type"::"Return Order";
        END;
        OutboxTransaction."Document No." := "No.";
        OutboxTransaction."Posting Date" := "Posting Date";
        OutboxTransaction."Document Date" := "Document Date";
        IF Rejection THEN
          OutboxTransaction."Transaction Source" := OutboxTransaction."Transaction Source"::"Rejected by Current Company"
        ELSE
          OutboxTransaction."Transaction Source" := OutboxTransaction."Transaction Source"::"Created by Current Company";
        OutboxTransaction.INSERT;
      END;
      ICOutBoxPurchHeader.TRANSFERFIELDS(PurchHeader);
      ICOutBoxPurchHeader."IC Transaction No." := OutboxTransaction."Transaction No.";
      ICOutBoxPurchHeader."IC Partner Code" := OutboxTransaction."IC Partner Code";
      ICOutBoxPurchHeader."Transaction Source" := OutboxTransaction."Transaction Source";

      GetCompanyInfo;
      AssignCurrencyCodeInOutBoxDoc(ICOutBoxPurchHeader."Currency Code",OutboxTransaction."IC Partner Code");
      DimMgt.CopyDocDimtoICDocDim(DATABASE::"IC Outbox Purchase Header",ICOutBoxPurchHeader."IC Transaction No.",
        ICOutBoxPurchHeader."IC Partner Code",ICOutBoxPurchHeader."Transaction Source",0,PurchHeader."Dimension Set ID");
      WITH ICOutBoxPurchLine DO BEGIN
        PurchLine.RESET;
        PurchLine.SETRANGE("Document Type",PurchHeader."Document Type");
        PurchLine.SETRANGE("Document No.",PurchHeader."No.");
        IF PurchLine.FIND('-') THEN
          REPEAT
            INIT;
            TRANSFERFIELDS(PurchLine);
            CASE PurchLine."Document Type" OF
              PurchLine."Document Type"::Order:
                "Document Type" := "Document Type"::Order;
              PurchLine."Document Type"::Invoice:
                "Document Type" := "Document Type"::Invoice;
              PurchLine."Document Type"::"Credit Memo":
                "Document Type" := "Document Type"::"Credit Memo";
              PurchLine."Document Type"::"Return Order":
                "Document Type" := "Document Type"::"Return Order";
            END;
            "IC Partner Code" := OutboxTransaction."IC Partner Code";
            "IC Transaction No." := OutboxTransaction."Transaction No.";
            "Transaction Source" := OutboxTransaction."Transaction Source";
            "Currency Code" := ICOutBoxPurchHeader."Currency Code";
            DimMgt.CopyDocDimtoICDocDim(
              DATABASE::"IC Outbox Purchase Line","IC Transaction No.","IC Partner Code","Transaction Source",
              "Line No.",PurchLine."Dimension Set ID");
            IF PurchLine.Type = PurchLine.Type::" " THEN
              "IC Partner Reference" := '';
            IF INSERT(TRUE) THEN
              LinesCreated := TRUE;
          UNTIL PurchLine.NEXT = 0;
      END;

      IF LinesCreated THEN BEGIN
        ICOutBoxPurchHeader.INSERT;
        IF NOT Post THEN BEGIN
          PurchHeader."IC Status" := PurchHeader."IC Status"::Pending;
          PurchHeader.MODIFY;
        END;
      END;
      ICOutboxTransactionCreated(OutboxTransaction);
    END;

    [External]
    PROCEDURE CreateOutboxJnlLine@2(TransactionNo@1000 : Integer;TransactionSource@1006 : 'Rejected by Current Company, Created by Current Company';TempGenJnlLine@1001 : TEMPORARY Record 81);
    VAR
      OutboxJnlLine@1003 : Record 415;
      ICOutboxTransaction@1002 : Record 414;
      DimMgt@1004 : Codeunit 408;
    BEGIN
      GetGLSetup;
      WITH TempGenJnlLine DO BEGIN
        IF (("Bal. Account Type" IN
             ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"IC Partner"]) AND
            ("Bal. Account No." <> '')) OR
           (("Account Type" = "Account Type"::"G/L Account") AND ("IC Partner G/L Acc. No." <> '')) OR
           (("Account Type" = "Account Type"::"Bank Account") AND ("IC Partner G/L Acc. No." <> ''))
        THEN
          CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",TempGenJnlLine);
        IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"]) AND
           ("Account No." <> '')
        THEN BEGIN
          OutboxJnlLine.INIT;
          OutboxJnlLine."Transaction No." := TransactionNo;
          OutboxJnlLine."IC Partner Code" := "IC Partner Code";
          OutboxJnlLine."Line No." := 0;
          OutboxJnlLine."Transaction Source" := TransactionSource;
          CASE "Account Type" OF
            "Account Type"::Customer:
              OutboxJnlLine."Account Type" := OutboxJnlLine."Account Type"::Customer;
            "Account Type"::Vendor:
              OutboxJnlLine."Account Type" := OutboxJnlLine."Account Type"::Vendor;
            "Account Type"::"IC Partner":
              OutboxJnlLine."Account Type" := OutboxJnlLine."Account Type"::"IC Partner";
          END;
          OutboxJnlLine."Account No." := "Account No.";
          OutboxJnlLine.Amount := Amount;
          OutboxJnlLine."VAT Amount" := "VAT Amount";
          OutboxJnlLine.Description := Description;
          OutboxJnlLine."Currency Code" := "Currency Code";
          OutboxJnlLine."Due Date" := "Due Date";
          OutboxJnlLine."Payment Discount %" := "Payment Discount %";
          OutboxJnlLine."Payment Discount Date" := "Pmt. Discount Date";
          OutboxJnlLine.Quantity := Quantity;
          OutboxJnlLine."Document No." := "Document No.";
          DimMgt.CopyJnlLineDimToICJnlDim(
            DATABASE::"IC Outbox Jnl. Line",TransactionNo,"IC Partner Code",
            OutboxJnlLine."Transaction Source",OutboxJnlLine."Line No.","Dimension Set ID");
          OutboxJnlLine.INSERT;
        END;
        IF "IC Partner G/L Acc. No." <> '' THEN BEGIN
          OutboxJnlLine.INIT;
          OutboxJnlLine."Transaction No." := TransactionNo;
          OutboxJnlLine."IC Partner Code" := "IC Partner Code";
          OutboxJnlLine."Line No." := "Line No.";
          OutboxJnlLine."Transaction Source" := TransactionSource;
          OutboxJnlLine."Account Type" := OutboxJnlLine."Account Type"::"G/L Account";
          OutboxJnlLine."Account No." := "IC Partner G/L Acc. No.";
          OutboxJnlLine.Amount := -Amount;
          OutboxJnlLine."VAT Amount" := "Bal. VAT Amount";
          OutboxJnlLine.Description := Description;
          OutboxJnlLine."Currency Code" := "Currency Code";
          OutboxJnlLine.Quantity := Quantity;
          OutboxJnlLine."Document No." := "Document No.";
          DimMgt.CopyJnlLineDimToICJnlDim(
            DATABASE::"IC Outbox Jnl. Line",TransactionNo,"IC Partner Code",
            OutboxJnlLine."Transaction Source","Line No.","Dimension Set ID");
          OutboxJnlLine.INSERT;
        END;
        ICOutboxTransaction.GET(TransactionNo,"IC Partner Code",TransactionSource,"Document Type");
        ICOutboxTransactionCreated(ICOutboxTransaction);
      END
    END;

    [External]
    PROCEDURE TranslateICGLAccount@6(ICAccNo@1000 : Code[30]) : Code[20];
    VAR
      ICGLAcc@1002 : Record 410;
    BEGIN
      ICGLAcc.GET(ICAccNo);
      EXIT(ICGLAcc."Map-to G/L Acc. No.");
    END;

    [External]
    PROCEDURE TranslateICPartnerToVendor@14(ICPartnerCode@1000 : Code[20]) : Code[20];
    VAR
      ICPartner@1001 : Record 413;
    BEGIN
      ICPartner.GET(ICPartnerCode);
      EXIT(ICPartner."Vendor No.");
    END;

    [External]
    PROCEDURE TranslateICPartnerToCustomer@15(ICPartnerCode@1000 : Code[20]) : Code[20];
    VAR
      ICPartner@1001 : Record 413;
    BEGIN
      ICPartner.GET(ICPartnerCode);
      EXIT(ICPartner."Customer No.");
    END;

    [External]
    PROCEDURE CreateJournalLines@5(InboxTransaction@1000 : Record 418;InboxJnlLine@1002 : Record 419;VAR TempGenJnlLine@1004 : TEMPORARY Record 81;GenJnlTemplate@1009 : Record 80);
    VAR
      GenJnlLine2@1001 : Record 81;
      InOutBoxJnlLineDim@1005 : Record 423;
      TempInOutBoxJnlLineDim@1006 : TEMPORARY Record 423;
      HandledInboxJnlLine@1003 : Record 421;
      DimMgt@1007 : Codeunit 408;
    BEGIN
      GetGLSetup;
      WITH GenJnlLine2 DO
        IF InboxTransaction."Transaction Source" = InboxTransaction."Transaction Source"::"Created by Partner" THEN BEGIN
          INIT;
          "Journal Template Name" := TempGenJnlLine."Journal Template Name";
          "Journal Batch Name" := TempGenJnlLine."Journal Batch Name";
          IF TempGenJnlLine."Posting Date" <> 0D THEN
            "Posting Date" := TempGenJnlLine."Posting Date"
          ELSE
            "Posting Date" := InboxTransaction."Posting Date";
          "Document Type" := InboxTransaction."Document Type";
          "Document No." := TempGenJnlLine."Document No.";
          "Source Code" := GenJnlTemplate."Source Code";
          "Line No." := TempGenJnlLine."Line No." + 10000;
          CASE InboxJnlLine."Account Type" OF
            InboxJnlLine."Account Type"::"G/L Account":
              BEGIN
                "Account Type" := "Account Type"::"G/L Account";
                VALIDATE("Account No.",TranslateICGLAccount(InboxJnlLine."Account No."));
              END;
            InboxJnlLine."Account Type"::Customer:
              BEGIN
                "Account Type" := "Account Type"::Customer;
                VALIDATE("Account No.",TranslateICPartnerToCustomer(InboxJnlLine."IC Partner Code"));
              END;
            InboxJnlLine."Account Type"::Vendor:
              BEGIN
                "Account Type" := "Account Type"::Vendor;
                VALIDATE("Account No.",TranslateICPartnerToVendor(InboxJnlLine."IC Partner Code"));
              END;
            InboxJnlLine."Account Type"::"IC Partner":
              BEGIN
                "Account Type" := "Account Type"::"IC Partner";
                VALIDATE("Account No.",InboxJnlLine."IC Partner Code");
              END;
          END;
          IF InboxJnlLine.Description <> '' THEN
            Description := InboxJnlLine.Description;
          IF InboxJnlLine."Currency Code" = GLSetup."LCY Code" THEN
            InboxJnlLine."Currency Code" := '';
          VALIDATE("Currency Code",InboxJnlLine."Currency Code");
          VALIDATE(Amount,InboxJnlLine.Amount);
          IF ("VAT Amount" <> InboxJnlLine."VAT Amount") AND
             ("VAT Amount" <> 0) AND (InboxJnlLine."VAT Amount" <> 0)
          THEN
            VALIDATE("VAT Amount",InboxJnlLine."VAT Amount");
          "Due Date" := InboxJnlLine."Due Date";
          VALIDATE("Payment Discount %",InboxJnlLine."Payment Discount %");
          VALIDATE("Pmt. Discount Date",InboxJnlLine."Payment Discount Date");
          Quantity := InboxJnlLine.Quantity;
          "IC Direction" := TempGenJnlLine."IC Direction"::Incoming;
          "IC Partner Transaction No." := InboxJnlLine."Transaction No.";
          "External Document No." := InboxJnlLine."Document No.";
          INSERT;
          InOutBoxJnlLineDim.SETRANGE("Table ID",DATABASE::"IC Inbox Jnl. Line");
          InOutBoxJnlLineDim.SETRANGE("Transaction No.",InboxTransaction."Transaction No.");
          InOutBoxJnlLineDim.SETRANGE("Line No.",InboxJnlLine."Line No.");
          InOutBoxJnlLineDim.SETRANGE("IC Partner Code",InboxTransaction."IC Partner Code");
          TempInOutBoxJnlLineDim.DELETEALL;
          DimMgt.CopyICJnlDimToICJnlDim(InOutBoxJnlLineDim,TempInOutBoxJnlLineDim);
          "Dimension Set ID" := DimMgt.CreateDimSetIDFromICJnlLineDim(TempInOutBoxJnlLineDim);
          DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code",
            "Shortcut Dimension 2 Code");
          MODIFY;
          HandledInboxJnlLine.TRANSFERFIELDS(InboxJnlLine);
          HandledInboxJnlLine.INSERT;
          TempGenJnlLine."Line No." := "Line No.";
        END;
    END;

    [External]
    PROCEDURE CreateSalesDocument@13(ICInboxSalesHeader@1000 : Record 434;ReplacePostingDate@1011 : Boolean;PostingDate@1010 : Date);
    VAR
      ICInboxSalesLine@1001 : Record 435;
      SalesHeader@1002 : Record 36;
      ICDocDim@1004 : Record 442;
      ICDocDim2@1009 : Record 442;
      HandledICInboxSalesHeader@1007 : Record 438;
      HandledICInboxSalesLine@1008 : Record 439;
      DimensionSetIDArr@1003 : ARRAY [10] OF Integer;
    BEGIN
      WITH ICInboxSalesHeader DO BEGIN
        SalesHeader.INIT;
        SalesHeader."No." := '';
        SalesHeader."Document Type" := "Document Type";
        SalesHeader.INSERT(TRUE);
        SalesHeader.VALIDATE("IC Direction",SalesHeader."IC Direction"::Incoming);
        SalesHeader.VALIDATE("Sell-to Customer No.","Sell-to Customer No.");
        IF SalesHeader."Bill-to Customer No." <> "Bill-to Customer No." THEN
          SalesHeader.VALIDATE("Bill-to Customer No.","Bill-to Customer No.");
        SalesHeader."External Document No." := "No.";
        SalesHeader."Ship-to Name" := "Ship-to Name";
        SalesHeader."Ship-to Address" := "Ship-to Address";
        SalesHeader."Ship-to Address 2" := "Ship-to Address 2";
        SalesHeader."Ship-to City" := "Ship-to City";
        SalesHeader."Ship-to Post Code" := "Ship-to Post Code";
        IF ReplacePostingDate THEN
          SalesHeader.VALIDATE("Posting Date",PostingDate)
        ELSE
          SalesHeader.VALIDATE("Posting Date","Posting Date");
        GetCurrency("Currency Code");
        SalesHeader.VALIDATE("Currency Code","Currency Code");
        SalesHeader.VALIDATE("Document Date","Document Date");
        SalesHeader.VALIDATE("Prices Including VAT","Prices Including VAT");
        SalesHeader.MODIFY;
        SalesHeader.VALIDATE("Due Date","Due Date");
        SalesHeader.VALIDATE("Payment Discount %","Payment Discount %");
        SalesHeader.VALIDATE("Pmt. Discount Date","Pmt. Discount Date");
        SalesHeader.VALIDATE("Requested Delivery Date","Requested Delivery Date");
        SalesHeader.VALIDATE("Promised Delivery Date","Promised Delivery Date");
        SalesHeader."Shortcut Dimension 1 Code" := '';
        SalesHeader."Shortcut Dimension 2 Code" := '';

        DimMgt.SetICDocDimFilters(
          ICDocDim,DATABASE::"IC Inbox Sales Header","IC Transaction No.",
          "IC Partner Code","Transaction Source",0);
        DimensionSetIDArr[1] := SalesHeader."Dimension Set ID";
        DimensionSetIDArr[2] := DimMgt.CreateDimSetIDFromICDocDim(ICDocDim);
        SalesHeader."Dimension Set ID" :=
          DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr,
            SalesHeader."Shortcut Dimension 1 Code",SalesHeader."Shortcut Dimension 2 Code");
        DimMgt.UpdateGlobalDimFromDimSetID(SalesHeader."Dimension Set ID",SalesHeader."Shortcut Dimension 1 Code",
          SalesHeader."Shortcut Dimension 2 Code");
        SalesHeader.MODIFY;

        HandledICInboxSalesHeader.TRANSFERFIELDS(ICInboxSalesHeader);
        HandledICInboxSalesHeader.INSERT;
        IF ICDocDim.FIND('-') THEN
          DimMgt.MoveICDocDimtoICDocDim(ICDocDim,ICDocDim2,DATABASE::"Handled IC Inbox Sales Header","Transaction Source");
      END;

      WITH ICInboxSalesLine DO  BEGIN
        SETRANGE("IC Transaction No.",ICInboxSalesHeader."IC Transaction No.");
        SETRANGE("IC Partner Code",ICInboxSalesHeader."IC Partner Code");
        SETRANGE("Transaction Source",ICInboxSalesHeader."Transaction Source");
        IF FIND('-') THEN
          REPEAT
            CreateSalesLines(SalesHeader,ICInboxSalesLine);
            HandledICInboxSalesLine.TRANSFERFIELDS(ICInboxSalesLine);
            HandledICInboxSalesLine.INSERT;
            DimMgt.SetICDocDimFilters(
              ICDocDim,DATABASE::"IC Inbox Sales Line","IC Transaction No.","IC Partner Code","Transaction Source","Line No.");
            IF ICDocDim.FIND('-') THEN
              DimMgt.MoveICDocDimtoICDocDim(ICDocDim,ICDocDim2,DATABASE::"Handled IC Inbox Sales Line","Transaction Source");
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CreateSalesLines@19(SalesHeader@1001 : Record 36;ICInboxSalesLine@1000 : Record 435);
    VAR
      SalesLine@1002 : Record 37;
      ICDocDim@1004 : Record 442;
      ItemCrossReference@1006 : Record 5717;
      Currency@1007 : Record 4;
      Precision@1008 : Decimal;
      Precision2@1009 : Decimal;
      DimensionSetIDArr@1003 : ARRAY [10] OF Integer;
    BEGIN
      WITH ICInboxSalesLine DO BEGIN
        SalesLine.INIT;
        SalesLine.TRANSFERFIELDS(ICInboxSalesLine);
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := "Line No.";
        SalesLine.INSERT(TRUE);
        CASE "IC Partner Ref. Type" OF
          "IC Partner Ref. Type"::"Common Item No.":
            BEGIN
              SalesLine.Type := SalesLine.Type::Item;
              SalesLine."No." := GetItemFromCommonItem("IC Partner Reference");
              IF SalesLine."No." <> '' THEN
                SalesLine.VALIDATE("No.",SalesLine."No.")
              ELSE
                SalesLine."No." := "IC Partner Reference";
            END;
          "IC Partner Ref. Type"::"Cross reference":
            BEGIN
              SalesLine.VALIDATE(Type,SalesLine.Type::Item);
              SalesLine.VALIDATE("Cross-Reference No.","IC Partner Reference");
            END;
          "IC Partner Ref. Type"::Item,"IC Partner Ref. Type"::"Vendor Item No.":
            BEGIN
              SalesLine.VALIDATE(Type,SalesLine.Type::Item);
              SalesLine."No." :=
                GetItemFromRef(
                  "IC Partner Reference",ItemCrossReference."Cross-Reference Type"::Customer,SalesHeader."Sell-to Customer No.");
              IF SalesLine."No." <> '' THEN
                SalesLine.VALIDATE("No.",SalesLine."No.")
              ELSE
                SalesLine."No." := "IC Partner Reference";
            END;
          "IC Partner Ref. Type"::"G/L Account":
            BEGIN
              SalesLine.VALIDATE(Type,SalesLine.Type::"G/L Account");
              SalesLine.VALIDATE("No.",TranslateICGLAccount("IC Partner Reference"));
            END;
          "IC Partner Ref. Type"::"Charge (Item)":
            BEGIN
              SalesLine.Type := SalesLine.Type::"Charge (Item)";
              SalesLine.VALIDATE("No.","IC Partner Reference");
            END;
        END;
        SalesLine."Currency Code" := SalesHeader."Currency Code";
        SalesLine.Description := Description;
        IF (SalesLine.Type <> SalesLine.Type::" ") AND (Quantity <> 0) THEN BEGIN
          IF Currency.GET(SalesHeader."Currency Code") THEN BEGIN
            Precision := Currency."Unit-Amount Rounding Precision";
            Precision2 := Currency."Amount Rounding Precision";
          END ELSE BEGIN
            GLSetup.GET;
            IF GLSetup."Unit-Amount Rounding Precision" <> 0 THEN
              Precision := GLSetup."Unit-Amount Rounding Precision"
            ELSE
              Precision := 0.01;
            IF GLSetup."Amount Rounding Precision" <> 0 THEN
              Precision2 := GLSetup."Amount Rounding Precision"
            ELSE
              Precision2 := 0.01;
          END;
          SalesLine.VALIDATE(Quantity,Quantity);
          SalesLine.VALIDATE("Unit of Measure Code","Unit of Measure Code");
          IF SalesHeader."Prices Including VAT" THEN
            SalesLine.VALIDATE("Unit Price",ROUND("Amount Including VAT" / Quantity,Precision))
          ELSE
            SalesLine.VALIDATE("Unit Price",
              ROUND((("Amount Including VAT" / (1 + (SalesLine."VAT %" / 100))) + "Line Discount Amount") / Quantity,Precision));
          SalesLine.VALIDATE("Line Discount Amount","Line Discount Amount");
          SalesLine."Amount Including VAT" := "Amount Including VAT";
          SalesLine."VAT Base Amount" := ROUND("Amount Including VAT" / (1 + (SalesLine."VAT %" / 100)),Precision2);
          IF SalesHeader."Prices Including VAT" THEN
            SalesLine."Line Amount" := "Amount Including VAT"
          ELSE
            SalesLine."Line Amount" := ROUND("Amount Including VAT" / (1 + (SalesLine."VAT %" / 100)),Precision2);
          SalesLine."Line Discount %" := "Line Discount %";
          SalesLine.VALIDATE("Requested Delivery Date","Requested Delivery Date");
          SalesLine.VALIDATE("Promised Delivery Date","Promised Delivery Date");
          UpdateSalesLineICPartnerReference(SalesLine,SalesHeader,ICInboxSalesLine);
        END;
        SalesLine."Shortcut Dimension 1 Code" := '';
        SalesLine."Shortcut Dimension 2 Code" := '';

        DimMgt.SetICDocDimFilters(
          ICDocDim,DATABASE::"IC Inbox Sales Line","IC Transaction No.","IC Partner Code","Transaction Source","Line No.");
        DimensionSetIDArr[1] := SalesLine."Dimension Set ID";
        DimensionSetIDArr[2] := DimMgt.CreateDimSetIDFromICDocDim(ICDocDim);

        SalesLine."Dimension Set ID" :=
          DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr,
            SalesLine."Shortcut Dimension 1 Code",SalesLine."Shortcut Dimension 2 Code");
        DimMgt.UpdateGlobalDimFromDimSetID(SalesLine."Dimension Set ID",SalesLine."Shortcut Dimension 1 Code",
          SalesLine."Shortcut Dimension 2 Code");
        SalesLine.MODIFY;
      END;
    END;

    [External]
    PROCEDURE CreatePurchDocument@22(ICInboxPurchHeader@1000 : Record 436;ReplacePostingDate@1011 : Boolean;PostingDate@1010 : Date);
    VAR
      ICInboxPurchLine@1005 : Record 437;
      PurchHeader@1004 : Record 38;
      ICDocDim@1002 : Record 442;
      ICDocDim2@1009 : Record 442;
      HandledICInboxPurchHeader@1008 : Record 440;
      HandledICInboxPurchLine@1007 : Record 441;
      DimensionSetIDArr@1001 : ARRAY [10] OF Integer;
    BEGIN
      WITH ICInboxPurchHeader DO BEGIN
        PurchHeader.INIT;
        PurchHeader."No." := '';
        PurchHeader."Document Type" := "Document Type";
        PurchHeader.INSERT(TRUE);
        PurchHeader.VALIDATE("IC Direction",PurchHeader."IC Direction"::Incoming);
        PurchHeader.VALIDATE("Buy-from Vendor No.","Buy-from Vendor No.");
        IF "Pay-to Vendor No." <> PurchHeader."Pay-to Vendor No." THEN
          PurchHeader.VALIDATE("Pay-to Vendor No.","Pay-to Vendor No.");
        CASE "Document Type" OF
          "Document Type"::Order,"Document Type"::"Return Order":
            PurchHeader."Vendor Order No." := "No.";
          "Document Type"::Invoice:
            PurchHeader."Vendor Invoice No." := "No.";
          "Document Type"::"Credit Memo":
            PurchHeader."Vendor Cr. Memo No." := "No.";
        END;
        PurchHeader."Your Reference" := "Your Reference";
        PurchHeader."Ship-to Name" := "Ship-to Name";
        PurchHeader."Ship-to Address" := "Ship-to Address";
        PurchHeader."Ship-to Address 2" := "Ship-to Address 2";
        PurchHeader."Ship-to City" := "Ship-to City";
        PurchHeader."Ship-to Post Code" := "Ship-to Post Code";
        PurchHeader."Vendor Order No." := "Vendor Order No.";
        IF ReplacePostingDate THEN
          PurchHeader.VALIDATE("Posting Date",PostingDate)
        ELSE
          PurchHeader.VALIDATE("Posting Date","Posting Date");
        GetCurrency("Currency Code");
        PurchHeader.VALIDATE("Currency Code","Currency Code");
        PurchHeader.VALIDATE("Document Date","Document Date");
        PurchHeader.VALIDATE("Requested Receipt Date","Requested Receipt Date");
        PurchHeader.VALIDATE("Promised Receipt Date","Promised Receipt Date");
        PurchHeader.VALIDATE("Prices Including VAT","Prices Including VAT");
        PurchHeader.VALIDATE("Due Date","Due Date");
        PurchHeader.VALIDATE("Payment Discount %","Payment Discount %");
        PurchHeader.VALIDATE("Pmt. Discount Date","Pmt. Discount Date");
        PurchHeader."Shortcut Dimension 1 Code" := '';
        PurchHeader."Shortcut Dimension 2 Code" := '';
        PurchHeader.MODIFY;

        DimMgt.SetICDocDimFilters(
          ICDocDim,DATABASE::"IC Inbox Purchase Header","IC Transaction No.","IC Partner Code","Transaction Source",0);
        GLSetup.GET;

        DimensionSetIDArr[1] := PurchHeader."Dimension Set ID";
        DimensionSetIDArr[2] := DimMgt.CreateDimSetIDFromICDocDim(ICDocDim);
        PurchHeader."Dimension Set ID" :=
          DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr,
            PurchHeader."Shortcut Dimension 1 Code",PurchHeader."Shortcut Dimension 2 Code");
        DimMgt.UpdateGlobalDimFromDimSetID(PurchHeader."Dimension Set ID",PurchHeader."Shortcut Dimension 1 Code",
          PurchHeader."Shortcut Dimension 2 Code");
        PurchHeader.MODIFY;

        HandledICInboxPurchHeader.TRANSFERFIELDS(ICInboxPurchHeader);
        HandledICInboxPurchHeader.INSERT;
        IF ICDocDim.FIND('-') THEN
          DimMgt.MoveICDocDimtoICDocDim(ICDocDim,ICDocDim2,DATABASE::"Handled IC Inbox Purch. Header","Transaction Source");
      END;

      WITH ICInboxPurchLine DO  BEGIN
        SETRANGE("IC Transaction No.",ICInboxPurchHeader."IC Transaction No.");
        SETRANGE("IC Partner Code",ICInboxPurchHeader."IC Partner Code");
        SETRANGE("Transaction Source",ICInboxPurchHeader."Transaction Source");
        IF FIND('-') THEN
          REPEAT
            CreatePurchLines(PurchHeader,ICInboxPurchLine);
            HandledICInboxPurchLine.TRANSFERFIELDS(ICInboxPurchLine);
            HandledICInboxPurchLine.INSERT;
            DimMgt.SetICDocDimFilters(
              ICDocDim,DATABASE::"IC Inbox Purchase Line","IC Transaction No.","IC Partner Code","Transaction Source","Line No.");
            IF ICDocDim.FIND('-') THEN
              DimMgt.MoveICDocDimtoICDocDim(ICDocDim,ICDocDim2,DATABASE::"Handled IC Inbox Purch. Line","Transaction Source");
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE CreatePurchLines@21(PurchHeader@1001 : Record 38;ICInboxPurchLine@1000 : Record 437);
    VAR
      PurchLine@1004 : Record 39;
      ICDocDim@1003 : Record 442;
      ItemCrossReference@1010 : Record 5717;
      Currency@1012 : Record 4;
      Precision@1011 : Decimal;
      Precision2@1013 : Decimal;
      DimensionSetIDArr@1002 : ARRAY [10] OF Integer;
    BEGIN
      WITH ICInboxPurchLine DO BEGIN
        PurchLine.INIT;
        PurchLine.TRANSFERFIELDS(ICInboxPurchLine);
        PurchLine."Document Type" := PurchHeader."Document Type";
        PurchLine."Document No." := PurchHeader."No.";
        PurchLine."Line No." := "Line No.";
        PurchLine."Receipt No." := '';
        PurchLine."Return Shipment No." := '';
        CASE "IC Partner Ref. Type" OF
          "IC Partner Ref. Type"::"Common Item No.":
            BEGIN
              PurchLine.Type := PurchLine.Type::Item;
              PurchLine."No." := GetItemFromCommonItem("IC Partner Reference");
              IF PurchLine."No." <> '' THEN
                PurchLine.VALIDATE("No.",PurchLine."No.")
              ELSE
                PurchLine."No." := "IC Partner Reference";
            END;
          "IC Partner Ref. Type"::Item:
            BEGIN
              PurchLine.VALIDATE(Type,PurchLine.Type::Item);
              PurchLine."No." :=
                GetItemFromRef(
                  "IC Partner Reference",ItemCrossReference."Cross-Reference Type"::Vendor,PurchHeader."Buy-from Vendor No.");
              IF PurchLine."No." <> '' THEN
                PurchLine.VALIDATE("No.",PurchLine."No.")
              ELSE
                PurchLine."No." := "IC Partner Reference";
            END;
          "IC Partner Ref. Type"::"G/L Account":
            BEGIN
              PurchLine.VALIDATE(Type,PurchLine.Type::"G/L Account");
              PurchLine.VALIDATE("No.",TranslateICGLAccount("IC Partner Reference"));
            END;
          "IC Partner Ref. Type"::"Charge (Item)":
            BEGIN
              PurchLine.Type := PurchLine.Type::"Charge (Item)";
              PurchLine.VALIDATE("No.","IC Partner Reference");
            END;
          "IC Partner Ref. Type"::"Cross reference":
            BEGIN
              PurchLine.VALIDATE(Type,PurchLine.Type::Item);
              PurchLine.VALIDATE("Cross-Reference No.","IC Partner Reference");
            END;
        END;
        PurchLine."Currency Code" := PurchHeader."Currency Code";
        PurchLine.Description := Description;
        IF (PurchLine.Type <> PurchLine.Type::" ") AND (Quantity <> 0) THEN BEGIN
          IF Currency.GET(PurchHeader."Currency Code") THEN BEGIN
            Precision := Currency."Unit-Amount Rounding Precision";
            Precision2 := Currency."Amount Rounding Precision"
          END ELSE BEGIN
            GLSetup.GET;
            IF GLSetup."Unit-Amount Rounding Precision" <> 0 THEN
              Precision := GLSetup."Unit-Amount Rounding Precision"
            ELSE
              Precision := 0.01;
            IF GLSetup."Amount Rounding Precision" <> 0 THEN
              Precision2 := GLSetup."Amount Rounding Precision"
            ELSE
              Precision2 := 0.01;
          END;
          PurchLine.VALIDATE(Quantity,Quantity);
          PurchLine.VALIDATE("Unit of Measure Code","Unit of Measure Code");
          IF PurchHeader."Prices Including VAT" THEN
            PurchLine.VALIDATE("Direct Unit Cost",ROUND("Amount Including VAT" / Quantity,Precision))
          ELSE
            PurchLine.VALIDATE("Direct Unit Cost","Direct Unit Cost");
          PurchLine.VALIDATE("Line Discount Amount","Line Discount Amount");
          PurchLine."Amount Including VAT" := "Amount Including VAT";
          PurchLine."VAT Base Amount" := ROUND("Amount Including VAT" / (1 + (PurchLine."VAT %" / 100)),Precision2);
          IF PurchHeader."Prices Including VAT" THEN
            PurchLine."Line Amount" := "Amount Including VAT"
          ELSE
            PurchLine."Line Amount" := ROUND("Amount Including VAT" / (1 + (PurchLine."VAT %" / 100)),Precision2);
          PurchLine.VALIDATE("Requested Receipt Date","Requested Receipt Date");
          PurchLine.VALIDATE("Promised Receipt Date","Promised Receipt Date");
          PurchLine."Line Discount %" := "Line Discount %";
          PurchLine."Receipt No." := "Receipt No.";
          PurchLine."Receipt Line No." := "Receipt Line No.";
          PurchLine."Return Shipment No." := "Return Shipment No.";
          PurchLine."Return Shipment Line No." := "Return Shipment Line No.";
          UpdatePurchLineICPartnerReference(PurchLine,PurchHeader,ICInboxPurchLine);
          UpdatePurchLineReceiptShipment(PurchLine);
        END;
        PurchLine."Shortcut Dimension 1 Code" := '';
        PurchLine."Shortcut Dimension 2 Code" := '';
        PurchLine.INSERT(TRUE);

        DimMgt.SetICDocDimFilters(
          ICDocDim,DATABASE::"IC Inbox Purchase Line","IC Transaction No.","IC Partner Code","Transaction Source","Line No.");
        DimensionSetIDArr[1] := PurchLine."Dimension Set ID";
        DimensionSetIDArr[2] := DimMgt.CreateDimSetIDFromICDocDim(ICDocDim);
        PurchLine."Dimension Set ID" :=
          DimMgt.GetCombinedDimensionSetID(DimensionSetIDArr,
            PurchLine."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 2 Code");
        DimMgt.UpdateGlobalDimFromDimSetID(PurchLine."Dimension Set ID",PurchLine."Shortcut Dimension 1 Code",
          PurchLine."Shortcut Dimension 2 Code");
        PurchLine.MODIFY;
      END;
    END;

    [External]
    PROCEDURE CreateHandledInbox@4(InboxTransaction@1000 : Record 418);
    VAR
      HandledInboxTransaction@1001 : Record 420;
    BEGIN
      HandledInboxTransaction.INIT;
      HandledInboxTransaction."Transaction No." := InboxTransaction."Transaction No.";
      HandledInboxTransaction."IC Partner Code" := InboxTransaction."IC Partner Code";
      HandledInboxTransaction."Source Type" := InboxTransaction."Source Type";
      HandledInboxTransaction."Document Type" := InboxTransaction."Document Type";
      HandledInboxTransaction."Document No." := InboxTransaction."Document No.";
      HandledInboxTransaction."Posting Date" := InboxTransaction."Posting Date";
      HandledInboxTransaction."Transaction Source" := InboxTransaction."Transaction Source";
      HandledInboxTransaction."Document Date" := InboxTransaction."Document Date";

      CASE InboxTransaction."Line Action" OF
        InboxTransaction."Line Action"::"Return to IC Partner":
          HandledInboxTransaction."Transaction Source" := HandledInboxTransaction."Transaction Source"::"Returned by Partner";
        InboxTransaction."Line Action"::Accept:
          IF InboxTransaction."Transaction Source" = InboxTransaction."Transaction Source"::"Created by Partner" THEN
            HandledInboxTransaction."Transaction Source" := HandledInboxTransaction."Transaction Source"::"Created by Partner"
          ELSE
            HandledInboxTransaction."Transaction Source" := HandledInboxTransaction."Transaction Source"::"Returned by Partner";
      END;
      HandledInboxTransaction.INSERT;
    END;

    [External]
    PROCEDURE RecreateInboxTransaction@7(VAR HandledInboxTransaction@1000 : Record 420);
    VAR
      HandledInboxTransaction2@1004 : Record 420;
      HandledInboxJnlLine@1002 : Record 421;
      InboxTransaction@1001 : Record 418;
      InboxJnlLine@1003 : Record 419;
      ICCommentLine@1005 : Record 424;
      HandledInboxSalesHdr@1006 : Record 438;
      InboxSalesHdr@1007 : Record 434;
      HandledInboxSalesLine@1008 : Record 439;
      InboxSalesLine@1009 : Record 435;
      ICDocDim@1010 : Record 442;
      ICDocDim2@1011 : Record 442;
      HandledInboxPurchHdr@1015 : Record 440;
      InboxPurchHdr@1014 : Record 436;
      HandledInboxPurchLine@1013 : Record 441;
      InboxPurchLine@1012 : Record 437;
      ICIOMgt@1016 : Codeunit 427;
    BEGIN
      WITH HandledInboxTransaction DO
        IF NOT (Status IN [Status::Accepted,Status::Cancelled]) THEN
          ERROR(Text005,FIELDCAPTION(Status),Status::Accepted,Status::Cancelled);

      IF CONFIRM(Text000,TRUE) THEN BEGIN
        HandledInboxTransaction2 := HandledInboxTransaction;
        HandledInboxTransaction2.LOCKTABLE;
        InboxTransaction.LOCKTABLE;
        InboxTransaction.INIT;
        InboxTransaction."Transaction No." := HandledInboxTransaction2."Transaction No.";
        InboxTransaction."IC Partner Code" := HandledInboxTransaction2."IC Partner Code";
        InboxTransaction."Source Type" := HandledInboxTransaction2."Source Type";
        InboxTransaction."Document Type" := HandledInboxTransaction2."Document Type";
        InboxTransaction."Document No." := HandledInboxTransaction2."Document No.";
        InboxTransaction."Posting Date" := HandledInboxTransaction2."Posting Date";
        InboxTransaction."Transaction Source" := InboxTransaction."Transaction Source"::"Created by Partner";
        InboxTransaction."Transaction Source" := HandledInboxTransaction2."Transaction Source";
        InboxTransaction."Document Date" := HandledInboxTransaction2."Document Date";
        InboxTransaction."IC Partner G/L Acc. No." := HandledInboxTransaction2."IC Partner G/L Acc. No.";
        InboxTransaction."Source Line No." := HandledInboxTransaction2."Source Line No.";
        InboxTransaction.INSERT;
        CASE InboxTransaction."Source Type" OF
          InboxTransaction."Source Type"::Journal:
            BEGIN
              HandledInboxJnlLine.LOCKTABLE;
              InboxJnlLine.LOCKTABLE;
              HandledInboxJnlLine.SETRANGE("Transaction No.",HandledInboxTransaction2."Transaction No.");
              HandledInboxJnlLine.SETRANGE("IC Partner Code",HandledInboxTransaction2."IC Partner Code");
              IF HandledInboxJnlLine.FIND('-') THEN
                REPEAT
                  InboxJnlLine.INIT;
                  InboxJnlLine.TRANSFERFIELDS(HandledInboxJnlLine);
                  InboxJnlLine.INSERT;
                  ICIOMgt.MoveICJnlDimToHandled(DATABASE::"Handled IC Inbox Jnl. Line",DATABASE::"IC Inbox Jnl. Line",
                    HandledInboxTransaction."Transaction No.",HandledInboxTransaction."IC Partner Code",
                    FALSE,0);
                UNTIL HandledInboxJnlLine.NEXT = 0;
              HandleICComments(ICCommentLine."Table Name"::"Handled IC Inbox Transaction",
                ICCommentLine."Table Name"::"IC Inbox Transaction",HandledInboxTransaction2."Transaction No.",
                HandledInboxTransaction2."IC Partner Code",HandledInboxTransaction2."Transaction Source");
              HandledInboxTransaction.DELETE(TRUE);
              COMMIT;
            END;
          InboxTransaction."Source Type"::"Sales Document":
            BEGIN
              IF HandledInboxSalesHdr.GET(HandledInboxTransaction2."Transaction No.",
                   HandledInboxTransaction2."IC Partner Code",HandledInboxTransaction2."Transaction Source")
              THEN BEGIN
                InboxSalesHdr.TRANSFERFIELDS(HandledInboxSalesHdr);
                InboxSalesHdr.INSERT;
                ICDocDim.RESET;
                DimMgt.SetICDocDimFilters(
                  ICDocDim,DATABASE::"Handled IC Inbox Sales Header",HandledInboxTransaction2."Transaction No.",
                  HandledInboxTransaction2."IC Partner Code",HandledInboxTransaction2."Transaction Source",0);
                IF ICDocDim.FIND('-') THEN
                  DimMgt.MoveICDocDimtoICDocDim(
                    ICDocDim,ICDocDim2,DATABASE::"IC Inbox Sales Header",InboxSalesHdr."Transaction Source");
                HandledInboxSalesLine.SETRANGE("IC Transaction No.",HandledInboxTransaction2."Transaction No.");
                HandledInboxSalesLine.SETRANGE("IC Partner Code",HandledInboxTransaction2."IC Partner Code");
                HandledInboxSalesLine.SETRANGE("Transaction Source",HandledInboxTransaction2."Transaction Source");
                IF HandledInboxSalesLine.FIND('-') THEN
                  REPEAT
                    InboxSalesLine.TRANSFERFIELDS(HandledInboxSalesLine);
                    InboxSalesLine.INSERT;
                    ICDocDim.RESET;
                    DimMgt.SetICDocDimFilters(
                      ICDocDim,DATABASE::"Handled IC Inbox Sales Line",HandledInboxTransaction2."Transaction No.",
                      HandledInboxTransaction2."IC Partner Code",HandledInboxTransaction2."Transaction Source",
                      HandledInboxSalesLine."Line No.");
                    IF ICDocDim.FIND('-') THEN
                      DimMgt.MoveICDocDimtoICDocDim(
                        ICDocDim,ICDocDim2,DATABASE::"IC Inbox Sales Line",InboxSalesLine."Transaction Source");
                    HandledInboxSalesLine.DELETE(TRUE);
                  UNTIL HandledInboxSalesLine.NEXT = 0;
              END;
              HandleICComments(ICCommentLine."Table Name"::"Handled IC Inbox Transaction",
                ICCommentLine."Table Name"::"IC Inbox Transaction",HandledInboxTransaction2."Transaction No.",
                HandledInboxTransaction2."IC Partner Code",HandledInboxTransaction2."Transaction Source");
              HandledInboxSalesHdr.DELETE(TRUE);
              HandledInboxTransaction.DELETE(TRUE);
              COMMIT;
            END;
          InboxTransaction."Source Type"::"Purchase Document":
            BEGIN
              IF HandledInboxPurchHdr.GET(HandledInboxTransaction2."Transaction No.",
                   HandledInboxTransaction2."IC Partner Code",HandledInboxTransaction2."Transaction Source")
              THEN BEGIN
                InboxPurchHdr.TRANSFERFIELDS(HandledInboxPurchHdr);
                InboxPurchHdr.INSERT;
                ICDocDim.RESET;
                DimMgt.SetICDocDimFilters(
                  ICDocDim,DATABASE::"Handled IC Inbox Purch. Header",HandledInboxTransaction2."Transaction No.",
                  HandledInboxTransaction2."IC Partner Code",HandledInboxTransaction2."Transaction Source",0);
                IF ICDocDim.FIND('-') THEN
                  DimMgt.MoveICDocDimtoICDocDim(
                    ICDocDim,ICDocDim2,DATABASE::"IC Inbox Purchase Header",InboxPurchHdr."Transaction Source");
                HandledInboxPurchLine.SETRANGE("IC Transaction No.",HandledInboxTransaction2."Transaction No.");
                HandledInboxPurchLine.SETRANGE("IC Partner Code",HandledInboxTransaction2."IC Partner Code");
                HandledInboxPurchLine.SETRANGE("Transaction Source",HandledInboxTransaction2."Transaction Source");
                IF HandledInboxPurchLine.FIND('-') THEN
                  REPEAT
                    InboxPurchLine.TRANSFERFIELDS(HandledInboxPurchLine);
                    InboxPurchLine.INSERT;
                    ICDocDim.RESET;
                    DimMgt.SetICDocDimFilters(
                      ICDocDim,DATABASE::"Handled IC Inbox Purch. Line",HandledInboxTransaction2."Transaction No.",
                      HandledInboxTransaction2."IC Partner Code",HandledInboxTransaction2."Transaction Source",
                      HandledInboxPurchLine."Line No.");
                    IF ICDocDim.FIND('-') THEN
                      DimMgt.MoveICDocDimtoICDocDim(
                        ICDocDim,ICDocDim2,DATABASE::"IC Inbox Purchase Line",InboxPurchLine."Transaction Source");
                    HandledInboxPurchLine.DELETE(TRUE);
                  UNTIL HandledInboxPurchLine.NEXT = 0;
              END;
              HandleICComments(ICCommentLine."Table Name"::"Handled IC Inbox Transaction",
                ICCommentLine."Table Name"::"IC Inbox Transaction",HandledInboxTransaction2."Transaction No.",
                HandledInboxTransaction2."IC Partner Code",HandledInboxTransaction2."Transaction Source");
              HandledInboxPurchHdr.DELETE(TRUE);
              HandledInboxTransaction.DELETE(TRUE);
            END;
        END;
      END
    END;

    [External]
    PROCEDURE RecreateOutboxTransaction@38(VAR HandledOutboxTransaction@1000 : Record 416);
    VAR
      HandledOutboxTransaction2@1004 : Record 416;
      HandledOutboxJnlLine@1002 : Record 417;
      OutboxTransaction@1001 : Record 414;
      OutboxJnlLine@1003 : Record 415;
      ICCommentLine@1005 : Record 424;
      HandledOutboxSalesHdr@1006 : Record 430;
      OutboxSalesHdr@1007 : Record 426;
      HandledOutboxSalesLine@1008 : Record 431;
      OutboxSalesLine@1009 : Record 427;
      ICDocDim@1010 : Record 442;
      ICDocDim2@1011 : Record 442;
      HandledOutboxPurchHdr@1015 : Record 432;
      OutboxPurchHdr@1014 : Record 428;
      HandledOutboxPurchLine@1013 : Record 433;
      OutboxPurchLine@1012 : Record 429;
      ICIOMgt@1016 : Codeunit 427;
    BEGIN
      WITH HandledOutboxTransaction DO
        IF NOT (Status IN [Status::"Sent to IC Partner",Status::Cancelled]) THEN
          ERROR(Text005,FIELDCAPTION(Status),Status::"Sent to IC Partner",Status::Cancelled);

      IF CONFIRM(Text000,TRUE) THEN BEGIN
        HandledOutboxTransaction2 := HandledOutboxTransaction;
        HandledOutboxTransaction2.LOCKTABLE;
        OutboxTransaction.LOCKTABLE;
        OutboxTransaction.INIT;
        OutboxTransaction."Transaction No." := HandledOutboxTransaction2."Transaction No.";
        OutboxTransaction."IC Partner Code" := HandledOutboxTransaction2."IC Partner Code";
        OutboxTransaction."Source Type" := HandledOutboxTransaction2."Source Type";
        OutboxTransaction."Document Type" := HandledOutboxTransaction2."Document Type";
        OutboxTransaction."Document No." := HandledOutboxTransaction2."Document No.";
        OutboxTransaction."Posting Date" := HandledOutboxTransaction2."Posting Date";
        OutboxTransaction."Transaction Source" := OutboxTransaction."Transaction Source"::"Created by Current Company";
        OutboxTransaction."Transaction Source" := HandledOutboxTransaction2."Transaction Source";
        OutboxTransaction."Document Date" := HandledOutboxTransaction2."Document Date";
        OutboxTransaction."IC Partner G/L Acc. No." := HandledOutboxTransaction2."IC Partner G/L Acc. No.";
        OutboxTransaction."Source Line No." := HandledOutboxTransaction2."Source Line No.";
        OutboxTransaction.INSERT;
        CASE OutboxTransaction."Source Type" OF
          OutboxTransaction."Source Type"::"Journal Line":
            BEGIN
              HandledOutboxJnlLine.LOCKTABLE;
              OutboxJnlLine.LOCKTABLE;
              HandledOutboxJnlLine.SETRANGE("Transaction No.",HandledOutboxTransaction2."Transaction No.");
              HandledOutboxJnlLine.SETRANGE("IC Partner Code",HandledOutboxTransaction2."IC Partner Code");
              IF HandledOutboxJnlLine.FIND('-') THEN
                REPEAT
                  OutboxJnlLine.INIT;
                  OutboxJnlLine.TRANSFERFIELDS(HandledOutboxJnlLine);
                  OutboxJnlLine.INSERT;
                  ICIOMgt.MoveICJnlDimToHandled(DATABASE::"Handled IC Outbox Jnl. Line",DATABASE::"IC Outbox Jnl. Line",
                    HandledOutboxTransaction."Transaction No.",HandledOutboxTransaction."IC Partner Code",
                    FALSE,0);
                UNTIL HandledOutboxJnlLine.NEXT = 0;
              HandleICComments(ICCommentLine."Table Name"::"Handled IC Outbox Transaction",
                ICCommentLine."Table Name"::"IC Outbox Transaction",HandledOutboxTransaction2."Transaction No.",
                HandledOutboxTransaction2."IC Partner Code",HandledOutboxTransaction2."Transaction Source");
              HandledOutboxTransaction.DELETE(TRUE);
              COMMIT;
            END;
          OutboxTransaction."Source Type"::"Sales Document":
            BEGIN
              IF HandledOutboxSalesHdr.GET(HandledOutboxTransaction2."Transaction No.",
                   HandledOutboxTransaction2."IC Partner Code",HandledOutboxTransaction2."Transaction Source")
              THEN BEGIN
                OutboxSalesHdr.TRANSFERFIELDS(HandledOutboxSalesHdr);
                OutboxSalesHdr.INSERT;
                ICDocDim.RESET;
                DimMgt.SetICDocDimFilters(
                  ICDocDim,DATABASE::"Handled IC Outbox Sales Header",HandledOutboxTransaction2."Transaction No.",
                  HandledOutboxTransaction2."IC Partner Code",HandledOutboxTransaction2."Transaction Source",0);
                IF ICDocDim.FIND('-') THEN
                  DimMgt.MoveICDocDimtoICDocDim(
                    ICDocDim,ICDocDim2,DATABASE::"IC Outbox Sales Header",OutboxSalesHdr."Transaction Source");
                HandledOutboxSalesLine.SETRANGE("IC Transaction No.",HandledOutboxTransaction2."Transaction No.");
                HandledOutboxSalesLine.SETRANGE("IC Partner Code",HandledOutboxTransaction2."IC Partner Code");
                HandledOutboxSalesLine.SETRANGE("Transaction Source",HandledOutboxTransaction2."Transaction Source");
                IF HandledOutboxSalesLine.FIND('-') THEN
                  REPEAT
                    OutboxSalesLine.TRANSFERFIELDS(HandledOutboxSalesLine);
                    OutboxSalesLine.INSERT;
                    ICDocDim.RESET;
                    DimMgt.SetICDocDimFilters(
                      ICDocDim,DATABASE::"Handled IC Outbox Sales Line",HandledOutboxTransaction2."Transaction No.",
                      HandledOutboxTransaction2."IC Partner Code",HandledOutboxTransaction2."Transaction Source",
                      HandledOutboxSalesLine."Line No.");
                    IF ICDocDim.FIND('-') THEN
                      DimMgt.MoveICDocDimtoICDocDim(
                        ICDocDim,ICDocDim2,DATABASE::"IC Outbox Sales Line",OutboxSalesLine."Transaction Source");
                    HandledOutboxSalesLine.DELETE(TRUE);
                  UNTIL HandledOutboxSalesLine.NEXT = 0;
              END;
              HandleICComments(ICCommentLine."Table Name"::"Handled IC Outbox Transaction",
                ICCommentLine."Table Name"::"IC Outbox Transaction",HandledOutboxTransaction2."Transaction No.",
                HandledOutboxTransaction2."IC Partner Code",HandledOutboxTransaction2."Transaction Source");
              HandledOutboxSalesHdr.DELETE(TRUE);
              HandledOutboxTransaction.DELETE(TRUE);
            END;
          OutboxTransaction."Source Type"::"Purchase Document":
            BEGIN
              IF HandledOutboxPurchHdr.GET(HandledOutboxTransaction2."Transaction No.",
                   HandledOutboxTransaction2."IC Partner Code",HandledOutboxTransaction2."Transaction Source")
              THEN BEGIN
                OutboxPurchHdr.TRANSFERFIELDS(HandledOutboxPurchHdr);
                OutboxPurchHdr.INSERT;
                ICDocDim.RESET;
                DimMgt.SetICDocDimFilters(
                  ICDocDim,DATABASE::"Handled IC Outbox Purch. Hdr",HandledOutboxTransaction2."Transaction No.",
                  HandledOutboxTransaction2."IC Partner Code",HandledOutboxTransaction2."Transaction Source",0);
                IF ICDocDim.FIND('-') THEN
                  DimMgt.MoveICDocDimtoICDocDim(
                    ICDocDim,ICDocDim2,DATABASE::"IC Outbox Purchase Header",OutboxPurchHdr."Transaction Source");
                HandledOutboxPurchLine.SETRANGE("IC Transaction No.",HandledOutboxTransaction2."Transaction No.");
                HandledOutboxPurchLine.SETRANGE("IC Partner Code",HandledOutboxTransaction2."IC Partner Code");
                HandledOutboxPurchLine.SETRANGE("Transaction Source",HandledOutboxTransaction2."Transaction Source");
                IF HandledOutboxPurchLine.FIND('-') THEN
                  REPEAT
                    OutboxPurchLine.TRANSFERFIELDS(HandledOutboxPurchLine);
                    OutboxPurchLine.INSERT;
                    ICDocDim.RESET;
                    DimMgt.SetICDocDimFilters(
                      ICDocDim,DATABASE::"Handled IC Outbox Purch. Line",HandledOutboxTransaction2."Transaction No.",
                      HandledOutboxTransaction2."IC Partner Code",HandledOutboxTransaction2."Transaction Source",
                      HandledOutboxPurchLine."Line No.");
                    IF ICDocDim.FIND('-') THEN
                      DimMgt.MoveICDocDimtoICDocDim(
                        ICDocDim,ICDocDim2,DATABASE::"IC Outbox Purchase Line",OutboxPurchLine."Transaction Source");
                    HandledOutboxPurchLine.DELETE(TRUE);
                  UNTIL HandledOutboxPurchLine.NEXT = 0;
              END;
              HandleICComments(ICCommentLine."Table Name"::"Handled IC Outbox Transaction",
                ICCommentLine."Table Name"::"IC Outbox Transaction",HandledOutboxTransaction2."Transaction No.",
                HandledOutboxTransaction2."IC Partner Code",HandledOutboxTransaction2."Transaction Source");
              HandledOutboxPurchHdr.DELETE(TRUE);
              HandledOutboxTransaction.DELETE(TRUE);
            END;
        END;
      END
    END;

    [External]
    PROCEDURE ForwardToOutBox@3(InboxTransaction@1000 : Record 418);
    VAR
      OutboxTransaction@1001 : Record 414;
      OutboxJnlLine@1019 : Record 415;
      InboxJnlLine@1020 : Record 419;
      OutboxSalesHdr@1003 : Record 426;
      OutboxSalesLine@1004 : Record 427;
      InboxSalesHdr@1005 : Record 434;
      InboxSalesLine@1006 : Record 435;
      OutboxPurchHdr@1010 : Record 428;
      OutboxPurchLine@1009 : Record 429;
      InboxPurchHdr@1008 : Record 436;
      InboxPurchLine@1007 : Record 437;
      ICCommentLine@1002 : Record 424;
      ICCommentLine2@1023 : Record 424;
      ICDocDim@1011 : Record 442;
      ICDocDim2@1012 : Record 442;
      HndlInboxJnlLine@1018 : Record 421;
      HndlInboxSalesHdr@1016 : Record 438;
      HndlInboxSalesLine@1015 : Record 439;
      HndlInboxPurchHdr@1014 : Record 440;
      HndlInboxPurchLine@1013 : Record 441;
      ICJnlLineDim@1017 : Record 423;
      ICJnlLineDim2@1021 : Record 423;
    BEGIN
      WITH InboxTransaction DO BEGIN
        OutboxTransaction.INIT;
        OutboxTransaction."Transaction No." := "Transaction No.";
        OutboxTransaction."IC Partner Code" := "IC Partner Code";
        OutboxTransaction."Source Type" := "Source Type";
        OutboxTransaction."Document Type" := "Document Type";
        OutboxTransaction."Document No." := "Document No.";
        OutboxTransaction."Posting Date" := "Posting Date";
        OutboxTransaction."Transaction Source" := OutboxTransaction."Transaction Source"::"Rejected by Current Company";
        OutboxTransaction."Document Date" := "Document Date";
        OutboxTransaction.INSERT;
        CASE "Source Type" OF
          "Source Type"::Journal:
            BEGIN
              InboxJnlLine.SETRANGE("Transaction No.","Transaction No.");
              InboxJnlLine.SETRANGE("IC Partner Code","IC Partner Code");
              InboxJnlLine.SETRANGE("Transaction Source","Transaction Source");
              IF InboxJnlLine.FIND('-') THEN
                REPEAT
                  OutboxJnlLine.TRANSFERFIELDS(InboxJnlLine);
                  OutboxJnlLine."Transaction Source" := OutboxTransaction."Transaction Source";
                  OutboxJnlLine.INSERT;
                  HndlInboxJnlLine.TRANSFERFIELDS(InboxJnlLine);
                  HndlInboxJnlLine.INSERT;

                  ICJnlLineDim.SETRANGE("Table ID",DATABASE::"IC Inbox Jnl. Line");
                  ICJnlLineDim.SETRANGE("Transaction No.",InboxJnlLine."Transaction No.");
                  ICJnlLineDim.SETRANGE("IC Partner Code",InboxJnlLine."IC Partner Code");
                  ICJnlLineDim.SETRANGE("Line No.",InboxJnlLine."Line No.");
                  IF ICJnlLineDim.FIND('-') THEN
                    REPEAT
                      ICJnlLineDim2 := ICJnlLineDim;
                      ICJnlLineDim2."Table ID" := DATABASE::"IC Outbox Jnl. Line";
                      ICJnlLineDim2."Transaction Source" := OutboxJnlLine."Transaction Source";
                      ICJnlLineDim2.INSERT;
                    UNTIL ICJnlLineDim.NEXT = 0;

                UNTIL InboxJnlLine.NEXT = 0;
            END;
          "Source Type"::"Sales Document":
            BEGIN
              IF InboxSalesHdr.GET("Transaction No.","IC Partner Code","Transaction Source") THEN BEGIN
                OutboxSalesHdr.TRANSFERFIELDS(InboxSalesHdr);
                OutboxSalesHdr."Transaction Source" := OutboxTransaction."Transaction Source";
                OutboxSalesHdr.INSERT;
                ICDocDim.RESET;
                DimMgt.SetICDocDimFilters(
                  ICDocDim,DATABASE::"IC Inbox Sales Header","Transaction No.","IC Partner Code","Transaction Source",0);
                IF ICDocDim.FIND('-') THEN
                  DimMgt.CopyICDocDimtoICDocDim(
                    ICDocDim,ICDocDim2,DATABASE::"IC Outbox Sales Header",OutboxSalesHdr."Transaction Source");
                HndlInboxSalesHdr.TRANSFERFIELDS(InboxSalesHdr);
                HndlInboxSalesHdr.INSERT;
                IF ICDocDim.FIND('-') THEN
                  DimMgt.MoveICDocDimtoICDocDim(
                    ICDocDim,ICDocDim2,DATABASE::"Handled IC Inbox Sales Header",InboxSalesHdr."Transaction Source");
                InboxSalesLine.SETRANGE("IC Transaction No.","Transaction No.");
                InboxSalesLine.SETRANGE("IC Partner Code","IC Partner Code");
                InboxSalesLine.SETRANGE("Transaction Source","Transaction Source");
                IF InboxSalesLine.FIND('-') THEN
                  REPEAT
                    OutboxSalesLine.TRANSFERFIELDS(InboxSalesLine);
                    OutboxSalesLine."Transaction Source" := OutboxTransaction."Transaction Source";
                    OutboxSalesLine.INSERT;
                    ICDocDim.RESET;
                    DimMgt.SetICDocDimFilters(
                      ICDocDim,DATABASE::"IC Inbox Sales Line","Transaction No.","IC Partner Code","Transaction Source",
                      OutboxSalesLine."Line No.");
                    IF ICDocDim.FIND('-') THEN
                      DimMgt.CopyICDocDimtoICDocDim(
                        ICDocDim,ICDocDim2,DATABASE::"IC Outbox Sales Line",OutboxSalesLine."Transaction Source");
                    HndlInboxSalesLine.TRANSFERFIELDS(InboxSalesLine);
                    HndlInboxSalesLine.INSERT;
                    IF ICDocDim.FIND('-') THEN
                      DimMgt.MoveICDocDimtoICDocDim(
                        ICDocDim,ICDocDim2,DATABASE::"Handled IC Inbox Sales Line",InboxSalesLine."Transaction Source");
                  UNTIL InboxSalesLine.NEXT = 0;
              END;
            END;
          "Source Type"::"Purchase Document":
            BEGIN
              IF InboxPurchHdr.GET("Transaction No.","IC Partner Code","Transaction Source") THEN BEGIN
                OutboxPurchHdr.TRANSFERFIELDS(InboxPurchHdr);
                OutboxPurchHdr."Transaction Source" := OutboxTransaction."Transaction Source";
                OutboxPurchHdr.INSERT;
                ICDocDim.RESET;
                DimMgt.SetICDocDimFilters(
                  ICDocDim,DATABASE::"IC Inbox Purchase Header","Transaction No.","IC Partner Code","Transaction Source",0);
                IF ICDocDim.FIND('-') THEN
                  DimMgt.CopyICDocDimtoICDocDim(
                    ICDocDim,ICDocDim2,DATABASE::"IC Outbox Purchase Header",OutboxPurchHdr."Transaction Source");
                HndlInboxPurchHdr.TRANSFERFIELDS(InboxPurchHdr);
                HndlInboxPurchHdr.INSERT;
                IF ICDocDim.FIND('-') THEN
                  DimMgt.MoveICDocDimtoICDocDim(
                    ICDocDim,ICDocDim2,DATABASE::"Handled IC Inbox Purch. Header",InboxPurchHdr."Transaction Source");
                InboxPurchLine.SETRANGE("IC Transaction No.","Transaction No.");
                InboxPurchLine.SETRANGE("IC Partner Code","IC Partner Code");
                InboxPurchLine.SETRANGE("Transaction Source","Transaction Source");
                IF InboxPurchLine.FIND('-') THEN
                  REPEAT
                    OutboxPurchLine.TRANSFERFIELDS(InboxPurchLine);
                    OutboxPurchLine."Transaction Source" := OutboxTransaction."Transaction Source";
                    OutboxPurchLine.INSERT;
                    ICDocDim.RESET;
                    DimMgt.SetICDocDimFilters(
                      ICDocDim,DATABASE::"IC Inbox Purchase Line","Transaction No.","IC Partner Code","Transaction Source",
                      OutboxPurchLine."Line No.");
                    IF ICDocDim.FIND('-') THEN
                      DimMgt.CopyICDocDimtoICDocDim(
                        ICDocDim,ICDocDim2,DATABASE::"IC Outbox Purchase Line",OutboxPurchLine."Transaction Source");
                    HndlInboxPurchLine.TRANSFERFIELDS(InboxPurchLine);
                    HndlInboxPurchLine.INSERT;
                    IF ICDocDim.FIND('-') THEN
                      DimMgt.MoveICDocDimtoICDocDim(
                        ICDocDim,ICDocDim2,DATABASE::"Handled IC Inbox Purch. Line",InboxPurchLine."Transaction Source");
                  UNTIL InboxPurchLine.NEXT = 0;
              END;
            END;
        END;
        ICCommentLine.SETRANGE("Table Name",ICCommentLine."Table Name"::"Handled IC Inbox Transaction");
        ICCommentLine.SETRANGE("Transaction No.","Transaction No.");
        ICCommentLine.SETRANGE("IC Partner Code","IC Partner Code");
        IF ICCommentLine.FIND('-') THEN
          REPEAT
            ICCommentLine2 := ICCommentLine;
            ICCommentLine2."Table Name" := ICCommentLine."Table Name"::"IC Outbox Transaction";
            ICCommentLine2."Transaction Source" := ICCommentLine."Transaction Source"::Rejected;
            ICCommentLine2.INSERT;
          UNTIL ICCommentLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE GetCompanyInfo@39();
    BEGIN
      IF NOT CompanyInfoFound THEN
        CompanyInfo.GET;
      CompanyInfoFound := TRUE;
    END;

    [External]
    PROCEDURE GetGLSetup@18();
    BEGIN
      IF NOT GLSetupFound THEN
        GLSetup.GET;
      GLSetupFound := TRUE;
    END;

    [External]
    PROCEDURE GetCurrency@17(VAR CurrencyCode@1000 : Code[20]);
    BEGIN
      GetGLSetup;
      IF CurrencyCode = GLSetup."LCY Code" THEN
        CurrencyCode := '';
    END;

    [External]
    PROCEDURE GetItemFromCommonItem@20(CommonItemNo@1000 : Code[20]) : Code[20];
    VAR
      Item@1001 : Record 27;
    BEGIN
      Item.SETCURRENTKEY("Common Item No.");
      Item.SETRANGE("Common Item No.",CommonItemNo);
      IF NOT Item.FINDFIRST THEN
        ERROR(STRSUBSTNO(NoItemForCommonItemErr,CommonItemNo));
      EXIT(Item."No.");
    END;

    [External]
    PROCEDURE GetItemFromRef@23(Code@1000 : Code[20];CrossRefType@1004 : Option;CrossRefTypeNo@1005 : Code[20]) : Code[20];
    VAR
      Item@1001 : Record 27;
      CrossRef@1002 : Record 5717;
      ItemVendor@1003 : Record 99;
    BEGIN
      IF Item.GET(Code) THEN
        EXIT(Item."No.");
      CrossRef.SETCURRENTKEY("Cross-Reference No.","Cross-Reference Type","Cross-Reference Type No.");
      CrossRef.SETRANGE("Cross-Reference Type",CrossRefType);
      CrossRef.SETRANGE("Cross-Reference Type No.",CrossRefTypeNo);
      CrossRef.SETRANGE("Cross-Reference No.",Code);
      IF CrossRef.FINDFIRST THEN
        EXIT(CrossRef."Item No.");

      IF CrossRefType = CrossRef."Cross-Reference Type"::Vendor THEN BEGIN
        ItemVendor.SETCURRENTKEY("Vendor No.","Vendor Item No.");
        ItemVendor.SETRANGE("Vendor No.",CrossRefTypeNo);
        ItemVendor.SETRANGE("Vendor Item No.",Code);
        IF ItemVendor.FINDFIRST THEN
          EXIT(ItemVendor."Item No.")
      END;
      EXIT('');
    END;

    LOCAL PROCEDURE GetCustInvRndgAccNo@49(CustomerNo@1002 : Code[20]) : Code[20];
    VAR
      Customer@1001 : Record 18;
      CustomerPostingGroup@1000 : Record 92;
    BEGIN
      Customer.GET(CustomerNo);
      CustomerPostingGroup.GET(Customer."Customer Posting Group");
      EXIT(CustomerPostingGroup."Invoice Rounding Account");
    END;

    [External]
    PROCEDURE HandleICComments@24(TableName@1003 : Option;NewTableName@1002 : Option;TransactionNo@1001 : Integer;ICPartner@1000 : Code[20];TransactionSource@1006 : Option);
    VAR
      ICCommentLine@1005 : Record 424;
      TempICCommentLine@1004 : TEMPORARY Record 424;
    BEGIN
      ICCommentLine.SETRANGE("Table Name",TableName);
      ICCommentLine.SETRANGE("Transaction No.",TransactionNo);
      ICCommentLine.SETRANGE("IC Partner Code",ICPartner);
      IF ICCommentLine.FIND('-') THEN BEGIN
        REPEAT
          TempICCommentLine := ICCommentLine;
          ICCommentLine.DELETE;
          TempICCommentLine."Table Name" := NewTableName;
          TempICCommentLine."Transaction Source" := TransactionSource;
          TempICCommentLine.INSERT;
        UNTIL ICCommentLine.NEXT = 0;
        IF TempICCommentLine.FIND('-') THEN
          REPEAT
            ICCommentLine := TempICCommentLine;
            ICCommentLine.INSERT;
          UNTIL TempICCommentLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE OutboxTransToInbox@32(VAR ICOutboxTrans@1000 : Record 414;VAR ICInboxTrans@1001 : Record 418;FromICPartnerCode@1002 : Code[20]);
    VAR
      PartnerICInboxTransaction@1005 : Record 418;
      PartnerHandledICInboxTrans@1003 : Record 420;
      ICPartner@1004 : Record 413;
    BEGIN
      ICInboxTrans."Transaction No." := ICOutboxTrans."Transaction No.";
      ICInboxTrans."IC Partner Code" := FromICPartnerCode;
      ICInboxTrans."Transaction Source" := ICOutboxTrans."Transaction Source";
      ICInboxTrans."Document Type" := ICOutboxTrans."Document Type";
      CASE ICOutboxTrans."Source Type" OF
        ICOutboxTrans."Source Type"::"Journal Line":
          ICInboxTrans."Source Type" := ICInboxTrans."Source Type"::Journal;
        ICOutboxTrans."Source Type"::"Sales Document":
          ICInboxTrans."Source Type" := ICInboxTrans."Source Type"::"Purchase Document";
        ICOutboxTrans."Source Type"::"Purchase Document":
          ICInboxTrans."Source Type" := ICInboxTrans."Source Type"::"Sales Document";
      END;
      ICInboxTrans."Document No." := ICOutboxTrans."Document No.";
      ICInboxTrans."Original Document No." := ICOutboxTrans."Document No.";
      ICInboxTrans."Posting Date" := ICOutboxTrans."Posting Date";
      ICInboxTrans."Document Date" := ICOutboxTrans."Document Date";
      ICInboxTrans."Line Action" := ICInboxTrans."Line Action"::"No Action";
      ICInboxTrans."IC Partner G/L Acc. No." := ICOutboxTrans."IC Partner G/L Acc. No.";
      ICInboxTrans."Source Line No." := ICOutboxTrans."Source Line No.";

      GetCompanyInfo;
      IF CompanyInfo."IC Partner Code" = ICInboxTrans."IC Partner Code" THEN
        ICPartner.GET(ICOutboxTrans."IC Partner Code")
      ELSE
        ICPartner.GET(ICInboxTrans."IC Partner Code");

      IF ICPartner."Inbox Type" = ICPartner."Inbox Type"::Database THEN
        PartnerICInboxTransaction.CHANGECOMPANY(ICPartner."Inbox Details");
      IF PartnerICInboxTransaction.GET(
           ICInboxTrans."Transaction No.",ICInboxTrans."IC Partner Code",
           ICInboxTrans."Transaction Source",ICInboxTrans."Document Type")
      THEN
        ERROR(
          Text004,ICInboxTrans."Transaction No.",ICInboxTrans.FIELDCAPTION("IC Partner Code"),
          ICInboxTrans."IC Partner Code",PartnerICInboxTransaction.TABLECAPTION);

      IF ICPartner."Inbox Type" = ICPartner."Inbox Type"::Database THEN
        PartnerHandledICInboxTrans.CHANGECOMPANY(ICPartner."Inbox Details");
      IF PartnerHandledICInboxTrans.GET(
           ICInboxTrans."Transaction No.",ICInboxTrans."IC Partner Code",
           ICInboxTrans."Transaction Source",ICInboxTrans."Document Type")
      THEN
        ERROR(
          Text004,ICInboxTrans."Transaction No.",ICInboxTrans.FIELDCAPTION("IC Partner Code"),
          ICInboxTrans."IC Partner Code",PartnerHandledICInboxTrans.TABLECAPTION);

      ICInboxTrans.INSERT;
    END;

    [External]
    PROCEDURE OutboxJnlLineToInbox@31(VAR ICInboxTrans@1002 : Record 418;VAR ICOutboxJnlLine@1000 : Record 415;VAR ICInboxJnlLine@1001 : Record 419);
    VAR
      LocalICPartner@1004 : Record 413;
      PartnerICPartner@1003 : Record 413;
    BEGIN
      GetGLSetup;
      GetCompanyInfo;
      ICInboxJnlLine."Transaction No." := ICInboxTrans."Transaction No.";
      ICInboxJnlLine."IC Partner Code" := ICInboxTrans."IC Partner Code";
      ICInboxJnlLine."Transaction Source" := ICInboxTrans."Transaction Source";
      ICInboxJnlLine."Line No." := ICOutboxJnlLine."Line No.";

      IF ICOutboxJnlLine."IC Partner Code" = CompanyInfo."IC Partner Code" THEN
        LocalICPartner.GET(ICInboxTrans."IC Partner Code")
      ELSE
        LocalICPartner.GET(ICOutboxJnlLine."IC Partner Code");

      IF ICOutboxJnlLine."IC Partner Code" = CompanyInfo."IC Partner Code" THEN
        PartnerICPartner.GET(ICInboxTrans."IC Partner Code")
      ELSE BEGIN
        LocalICPartner.TESTFIELD("Inbox Type",LocalICPartner."Inbox Type"::Database);
        PartnerICPartner.CHANGECOMPANY(LocalICPartner."Inbox Details");
        PartnerICPartner.GET(ICInboxJnlLine."IC Partner Code");
      END;

      CASE ICOutboxJnlLine."Account Type" OF
        ICOutboxJnlLine."Account Type"::"G/L Account":
          BEGIN
            ICInboxJnlLine."Account Type" := ICInboxJnlLine."Account Type"::"G/L Account";
            ICInboxJnlLine."Account No." := ICOutboxJnlLine."Account No.";
          END;
        ICOutboxJnlLine."Account Type"::Vendor:
          BEGIN
            ICInboxJnlLine."Account Type" := ICInboxJnlLine."Account Type"::Customer;
            PartnerICPartner.TESTFIELD("Customer No.");
            ICInboxJnlLine."Account No." := PartnerICPartner."Customer No.";
          END;
        ICOutboxJnlLine."Account Type"::Customer:
          BEGIN
            ICInboxJnlLine."Account Type" := ICInboxJnlLine."Account Type"::Vendor;
            PartnerICPartner.TESTFIELD("Vendor No.");
            ICInboxJnlLine."Account No." := PartnerICPartner."Vendor No.";
          END;
        ICOutboxJnlLine."Account Type"::"IC Partner":
          BEGIN
            ICInboxJnlLine."Account Type" := ICInboxJnlLine."Account Type"::"IC Partner";
            ICInboxJnlLine."Account No." := ICInboxJnlLine."IC Partner Code";
          END;
      END;
      ICInboxJnlLine.Amount := -ICOutboxJnlLine.Amount;
      ICInboxJnlLine.Description := ICOutboxJnlLine.Description;
      ICInboxJnlLine."VAT Amount" := -ICOutboxJnlLine."VAT Amount";
      IF ICOutboxJnlLine."Currency Code" = GLSetup."LCY Code" THEN
        ICInboxJnlLine."Currency Code" := ''
      ELSE
        ICInboxJnlLine."Currency Code" := ICOutboxJnlLine."Currency Code";
      ICInboxJnlLine."Due Date" := ICOutboxJnlLine."Due Date";
      ICInboxJnlLine."Payment Discount %" := ICOutboxJnlLine."Payment Discount %";
      ICInboxJnlLine."Payment Discount Date" := ICOutboxJnlLine."Payment Discount Date";
      ICInboxJnlLine.Quantity := -ICOutboxJnlLine.Quantity;
      ICInboxJnlLine."Document No." := ICOutboxJnlLine."Document No.";
      ICInboxJnlLine.INSERT;
    END;

    [External]
    PROCEDURE OutboxSalesHdrToInbox@30(VAR ICInboxTrans@1002 : Record 418;VAR ICOutboxSalesHdr@1000 : Record 426;VAR ICInboxPurchHdr@1001 : Record 436);
    VAR
      ICPartner@1003 : Record 413;
      Vendor@1004 : Record 23;
    BEGIN
      GetCompanyInfo;
      IF ICOutboxSalesHdr."IC Partner Code" = CompanyInfo."IC Partner Code" THEN
        ICPartner.GET(ICInboxTrans."IC Partner Code")
      ELSE BEGIN
        ICPartner.GET(ICOutboxSalesHdr."IC Partner Code");
        ICPartner.TESTFIELD("Inbox Type",ICPartner."Inbox Type"::Database);
        ICPartner.TESTFIELD("Inbox Details");
        ICPartner.CHANGECOMPANY(ICPartner."Inbox Details");
        ICPartner.GET(ICInboxTrans."IC Partner Code");
      END;
      IF ICPartner."Vendor No." = '' THEN
        ERROR(Text001,ICPartner.TABLECAPTION,ICPartner.Code,Vendor.TABLECAPTION,ICOutboxSalesHdr."IC Partner Code");
      ICInboxPurchHdr."IC Transaction No." := ICInboxTrans."Transaction No.";
      ICInboxPurchHdr."IC Partner Code" := ICInboxTrans."IC Partner Code";
      ICInboxPurchHdr."Transaction Source" := ICInboxTrans."Transaction Source";
      ICInboxPurchHdr."Document Type" := ICOutboxSalesHdr."Document Type";
      ICInboxPurchHdr."No." := ICOutboxSalesHdr."No.";
      ICInboxPurchHdr."Ship-to Name" := ICOutboxSalesHdr."Ship-to Name";
      ICInboxPurchHdr."Ship-to Address" := ICOutboxSalesHdr."Ship-to Address";
      ICInboxPurchHdr."Ship-to Address 2" := ICOutboxSalesHdr."Ship-to Address 2";
      ICInboxPurchHdr."Ship-to City" := ICOutboxSalesHdr."Ship-to City";
      ICInboxPurchHdr."Ship-to Post Code" := ICOutboxSalesHdr."Ship-to Post Code";
      ICInboxPurchHdr."Posting Date" := ICOutboxSalesHdr."Posting Date";
      ICInboxPurchHdr."Due Date" := ICOutboxSalesHdr."Due Date";
      ICInboxPurchHdr."Payment Discount %" := ICOutboxSalesHdr."Payment Discount %";
      ICInboxPurchHdr."Pmt. Discount Date" := ICOutboxSalesHdr."Pmt. Discount Date";
      ICInboxPurchHdr."Currency Code" := ICOutboxSalesHdr."Currency Code";
      ICInboxPurchHdr."Document Date" := ICOutboxSalesHdr."Document Date";
      ICInboxPurchHdr."Buy-from Vendor No." := ICPartner."Vendor No.";
      ICInboxPurchHdr."Pay-to Vendor No." := ICPartner."Vendor No.";
      ICInboxPurchHdr."Vendor Invoice No." := ICOutboxSalesHdr."No.";
      ICInboxPurchHdr."Vendor Order No." := ICOutboxSalesHdr."Order No.";
      ICInboxPurchHdr."Vendor Cr. Memo No." := ICOutboxSalesHdr."No.";
      ICInboxPurchHdr."Your Reference" := ICOutboxSalesHdr."External Document No.";
      ICInboxPurchHdr."Sell-to Customer No." := ICOutboxSalesHdr."Sell-to Customer No.";
      ICInboxPurchHdr."Expected Receipt Date" := ICOutboxSalesHdr."Requested Delivery Date";
      ICInboxPurchHdr."Requested Receipt Date" := ICOutboxSalesHdr."Requested Delivery Date";
      ICInboxPurchHdr."Promised Receipt Date" := ICOutboxSalesHdr."Promised Delivery Date";
      ICInboxPurchHdr."Prices Including VAT" := ICOutboxSalesHdr."Prices Including VAT";
      ICInboxPurchHdr.INSERT;
    END;

    [External]
    PROCEDURE OutboxSalesLineToInbox@29(VAR ICInboxTrans@1002 : Record 418;VAR ICOutboxSalesLine@1000 : Record 427;VAR ICInboxPurchLine@1001 : Record 437);
    BEGIN
      ICInboxPurchLine."IC Transaction No." := ICInboxTrans."Transaction No.";
      ICInboxPurchLine."IC Partner Code" := ICInboxTrans."IC Partner Code";
      ICInboxPurchLine."Transaction Source" := ICInboxTrans."Transaction Source";
      ICInboxPurchLine."Line No." := ICOutboxSalesLine."Line No.";
      ICInboxPurchLine."Document Type" := ICOutboxSalesLine."Document Type";
      ICInboxPurchLine."Document No." := ICOutboxSalesLine."Document No.";
      ICInboxPurchLine."IC Partner Ref. Type" := ICOutboxSalesLine."IC Partner Ref. Type";
      ICInboxPurchLine."IC Partner Reference" := ICOutboxSalesLine."IC Partner Reference";
      ICInboxPurchLine.Description := ICOutboxSalesLine.Description;
      ICInboxPurchLine.Quantity := ICOutboxSalesLine.Quantity;
      ICInboxPurchLine."Direct Unit Cost" := ICOutboxSalesLine."Unit Price";
      ICInboxPurchLine."Line Discount Amount" := ICOutboxSalesLine."Line Discount Amount";
      ICInboxPurchLine."Amount Including VAT" := ICOutboxSalesLine."Amount Including VAT";
      ICInboxPurchLine."Job No." := ICOutboxSalesLine."Job No.";
      ICInboxPurchLine."VAT Base Amount" := ICOutboxSalesLine."VAT Base Amount";
      ICInboxPurchLine."Unit Cost" := ICOutboxSalesLine."Unit Price";
      ICInboxPurchLine."Line Amount" := ICOutboxSalesLine."Line Amount";
      ICInboxPurchLine."Line Discount %" := ICOutboxSalesLine."Line Discount %";
      ICInboxPurchLine."Unit of Measure Code" := ICOutboxSalesLine."Unit of Measure Code";
      ICInboxPurchLine."Requested Receipt Date" := ICOutboxSalesLine."Requested Delivery Date";
      ICInboxPurchLine."Promised Receipt Date" := ICOutboxSalesLine."Promised Delivery Date";
      ICInboxPurchLine."Receipt No." := ICOutboxSalesLine."Shipment No.";
      ICInboxPurchLine."Receipt Line No." := ICOutboxSalesLine."Shipment Line No.";
      ICInboxPurchLine."Return Shipment No." := ICOutboxSalesLine."Return Receipt No.";
      ICInboxPurchLine."Return Shipment Line No." := ICOutboxSalesLine."Return Receipt Line No.";
      ICInboxPurchLine.INSERT;
    END;

    [External]
    PROCEDURE OutboxPurchHdrToInbox@28(VAR ICInboxTrans@1002 : Record 418;VAR ICOutboxPurchHdr@1000 : Record 428;VAR ICInboxSalesHdr@1001 : Record 434);
    VAR
      ICPartner@1003 : Record 413;
      Customer@1004 : Record 18;
    BEGIN
      GetCompanyInfo;
      IF ICOutboxPurchHdr."IC Partner Code" = CompanyInfo."IC Partner Code" THEN
        ICPartner.GET(ICInboxTrans."IC Partner Code")
      ELSE BEGIN
        ICPartner.GET(ICOutboxPurchHdr."IC Partner Code");
        ICPartner.TESTFIELD("Inbox Type",ICPartner."Inbox Type"::Database);
        ICPartner.TESTFIELD("Inbox Details");
        ICPartner.CHANGECOMPANY(ICPartner."Inbox Details");
        ICPartner.GET(ICInboxTrans."IC Partner Code");
      END;
      IF ICPartner."Customer No." = '' THEN
        ERROR(Text001,ICPartner.TABLECAPTION,ICPartner.Code,Customer.TABLECAPTION);

      ICInboxSalesHdr."IC Transaction No." := ICInboxTrans."Transaction No.";
      ICInboxSalesHdr."IC Partner Code" := ICInboxTrans."IC Partner Code";
      ICInboxSalesHdr."Transaction Source" := ICInboxTrans."Transaction Source";
      ICInboxSalesHdr."Document Type" := ICOutboxPurchHdr."Document Type";
      ICInboxSalesHdr."No." := ICOutboxPurchHdr."No.";
      ICInboxSalesHdr."Ship-to Name" := ICOutboxPurchHdr."Ship-to Name";
      ICInboxSalesHdr."Ship-to Address" := ICOutboxPurchHdr."Ship-to Address";
      ICInboxSalesHdr."Ship-to Address 2" := ICOutboxPurchHdr."Ship-to Address 2";
      ICInboxSalesHdr."Ship-to City" := ICOutboxPurchHdr."Ship-to City";
      ICInboxSalesHdr."Ship-to Post Code" := ICOutboxPurchHdr."Ship-to Post Code";
      ICInboxSalesHdr."Posting Date" := ICOutboxPurchHdr."Posting Date";
      ICInboxSalesHdr."Due Date" := ICOutboxPurchHdr."Due Date";
      ICInboxSalesHdr."Payment Discount %" := ICOutboxPurchHdr."Payment Discount %";
      ICInboxSalesHdr."Pmt. Discount Date" := ICOutboxPurchHdr."Pmt. Discount Date";
      ICInboxSalesHdr."Currency Code" := ICOutboxPurchHdr."Currency Code";
      ICInboxSalesHdr."Document Date" := ICOutboxPurchHdr."Document Date";
      ICInboxSalesHdr."Sell-to Customer No." := ICPartner."Customer No.";
      ICInboxSalesHdr."Bill-to Customer No." := ICPartner."Customer No.";
      ICInboxSalesHdr."Prices Including VAT" := ICOutboxPurchHdr."Prices Including VAT";
      ICInboxSalesHdr."Requested Delivery Date" := ICOutboxPurchHdr."Requested Receipt Date";
      ICInboxSalesHdr."Promised Delivery Date" := ICOutboxPurchHdr."Promised Receipt Date";
      ICInboxSalesHdr.INSERT;
    END;

    [External]
    PROCEDURE OutboxPurchLineToInbox@27(VAR ICInboxTrans@1002 : Record 418;VAR ICOutboxPurchLine@1000 : Record 429;VAR ICInboxSalesLine@1001 : Record 435);
    BEGIN
      ICInboxSalesLine."IC Transaction No." := ICInboxTrans."Transaction No.";
      ICInboxSalesLine."IC Partner Code" := ICInboxTrans."IC Partner Code";
      ICInboxSalesLine."Transaction Source" := ICInboxTrans."Transaction Source";
      ICInboxSalesLine."Line No." := ICOutboxPurchLine."Line No.";
      ICInboxSalesLine."Document Type" := ICOutboxPurchLine."Document Type";
      ICInboxSalesLine."Document No." := ICOutboxPurchLine."Document No.";
      IF ICOutboxPurchLine."IC Partner Ref. Type" = ICOutboxPurchLine."IC Partner Ref. Type"::"Vendor Item No." THEN
        ICInboxSalesLine."IC Partner Ref. Type" := ICInboxSalesLine."IC Partner Ref. Type"::Item
      ELSE
        ICInboxSalesLine."IC Partner Ref. Type" := ICOutboxPurchLine."IC Partner Ref. Type";
      ICInboxSalesLine."IC Partner Reference" := ICOutboxPurchLine."IC Partner Reference";
      ICInboxSalesLine.Description := ICOutboxPurchLine.Description;
      ICInboxSalesLine.Quantity := ICOutboxPurchLine.Quantity;
      ICInboxSalesLine."Line Discount Amount" := ICOutboxPurchLine."Line Discount Amount";
      ICInboxSalesLine."Amount Including VAT" := ICOutboxPurchLine."Amount Including VAT";
      ICInboxSalesLine."Job No." := ICOutboxPurchLine."Job No.";
      ICInboxSalesLine."VAT Base Amount" := ICOutboxPurchLine."VAT Base Amount";
      ICInboxSalesLine."Unit Price" := ICOutboxPurchLine."Direct Unit Cost";
      ICInboxSalesLine."Line Amount" := ICOutboxPurchLine."Line Amount";
      ICInboxSalesLine."Line Discount %" := ICOutboxPurchLine."Line Discount %";
      ICInboxSalesLine."Unit of Measure Code" := ICOutboxPurchLine."Unit of Measure Code";
      ICInboxSalesLine."Requested Delivery Date" := ICOutboxPurchLine."Requested Receipt Date";
      ICInboxSalesLine."Promised Delivery Date" := ICOutboxPurchLine."Promised Receipt Date";
      ICInboxSalesLine.INSERT;
    END;

    [External]
    PROCEDURE OutboxJnlLineDimToInbox@26(VAR ICInboxJnlLine@1000 : Record 419;VAR ICOutboxJnlLineDim@1002 : Record 423;VAR ICInboxJnlLineDim@1001 : Record 423;ICInboxTableID@1003 : Integer);
    BEGIN
      ICInboxJnlLineDim := ICOutboxJnlLineDim;
      ICInboxJnlLineDim."Table ID" := ICInboxTableID;
      ICInboxJnlLineDim."IC Partner Code" := ICInboxJnlLine."IC Partner Code";
      ICInboxJnlLineDim."Transaction Source" := ICInboxJnlLine."Transaction Source";
      ICInboxJnlLineDim.INSERT;
    END;

    [External]
    PROCEDURE OutboxDocDimToInbox@25(VAR ICOutboxDocDim@1000 : Record 442;VAR ICInboxDocDim@1001 : Record 442;InboxTableID@1002 : Integer;InboxICPartnerCode@1003 : Code[20];InboxTransSource@1004 : Integer);
    BEGIN
      ICInboxDocDim := ICOutboxDocDim;
      ICInboxDocDim."Table ID" := InboxTableID;
      ICInboxDocDim."IC Partner Code" := InboxICPartnerCode;
      ICInboxDocDim."Transaction Source" := InboxTransSource;
      ICInboxDocDim.INSERT;
    END;

    [External]
    PROCEDURE MoveICJnlDimToHandled@8(TableID@1003 : Integer;NewTableID@1002 : Integer;TransactionNo@1001 : Integer;ICPartner@1000 : Code[20];LineNoFilter@1006 : Boolean;LineNo@1007 : Integer);
    VAR
      InOutboxJnlLineDim@1004 : Record 423;
      TempInOutboxJnlLineDim@1005 : TEMPORARY Record 423;
    BEGIN
      InOutboxJnlLineDim.SETRANGE("Table ID",TableID);
      InOutboxJnlLineDim.SETRANGE("Transaction No.",TransactionNo);
      InOutboxJnlLineDim.SETRANGE("IC Partner Code",ICPartner);
      IF LineNoFilter THEN
        InOutboxJnlLineDim.SETRANGE("Line No.",LineNo);
      IF InOutboxJnlLineDim.FIND('-') THEN BEGIN
        REPEAT
          TempInOutboxJnlLineDim := InOutboxJnlLineDim;
          InOutboxJnlLineDim.DELETE;
          TempInOutboxJnlLineDim."Table ID" := NewTableID;
          TempInOutboxJnlLineDim.INSERT;
        UNTIL InOutboxJnlLineDim.NEXT = 0;
        IF TempInOutboxJnlLineDim.FIND('-') THEN
          REPEAT
            InOutboxJnlLineDim := TempInOutboxJnlLineDim;
            InOutboxJnlLineDim.INSERT;
          UNTIL TempInOutboxJnlLineDim.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE MoveICDocDimToHandled@46(FromTableID@1002 : Integer;ToTableID@1007 : Integer;TransactionNo@1003 : Integer;PartnerCode@1004 : Code[20];TransactionSource@1005 : Option;LineNo@1006 : Integer);
    VAR
      ICDocDim@1000 : Record 442;
      HandledICDocDim@1001 : Record 442;
    BEGIN
      ICDocDim.SETRANGE("Table ID",FromTableID);
      ICDocDim.SETRANGE("Transaction No.",TransactionNo);
      ICDocDim.SETRANGE("IC Partner Code",PartnerCode);
      ICDocDim.SETRANGE("Transaction Source",TransactionSource);
      ICDocDim.SETRANGE("Line No.",LineNo);
      IF ICDocDim.FIND('-') THEN
        REPEAT
          HandledICDocDim.TRANSFERFIELDS(ICDocDim,TRUE);
          HandledICDocDim."Table ID" := ToTableID;
          HandledICDocDim.INSERT;
          ICDocDim.DELETE;
        UNTIL ICDocDim.NEXT = 0;
    END;

    [External]
    PROCEDURE MoveOutboxTransToHandledOutbox@37(VAR ICOutboxTrans@1000 : Record 414);
    VAR
      HandledICOutboxTrans@1015 : Record 416;
      ICOutboxJnlLine@1001 : Record 415;
      HandledICOutboxJnlLine@1002 : Record 417;
      ICOutboxSalesHdr@1003 : Record 426;
      HandledICOutboxSalesHdr@1004 : Record 430;
      ICOutboxSalesLine@1005 : Record 427;
      HandledICOutboxSalesLine@1006 : Record 431;
      ICOutboxPurchHdr@1010 : Record 428;
      HandledICOutboxPurchHdr@1009 : Record 432;
      ICOutboxPurchLine@1008 : Record 429;
      HandledICOutboxPurchLine@1007 : Record 433;
      ICInOutJnlLineDim@1011 : Record 423;
      HandledICInOutJnlLineDim@1013 : Record 423;
      ICCommentLine@1016 : Record 424;
      HandledICCommentLine@1017 : Record 424;
    BEGIN
      ICOutboxJnlLine.SETRANGE("Transaction No.",ICOutboxTrans."Transaction No.");
      IF ICOutboxJnlLine.FIND('-') THEN
        REPEAT
          HandledICOutboxJnlLine.TRANSFERFIELDS(ICOutboxJnlLine,TRUE);
          HandledICOutboxJnlLine.INSERT;
          ICInOutJnlLineDim.SETRANGE("Table ID",DATABASE::"IC Outbox Jnl. Line");
          ICInOutJnlLineDim.SETRANGE("Transaction No.",ICOutboxJnlLine."Transaction No.");
          ICInOutJnlLineDim.SETRANGE("IC Partner Code",ICOutboxJnlLine."IC Partner Code");
          ICInOutJnlLineDim.SETRANGE("Transaction Source",ICOutboxJnlLine."Transaction Source");
          ICInOutJnlLineDim.SETRANGE("Line No.",ICOutboxJnlLine."Line No.");
          IF ICInOutJnlLineDim.FIND('-') THEN
            REPEAT
              HandledICInOutJnlLineDim := ICInOutJnlLineDim;
              HandledICInOutJnlLineDim."Table ID" := DATABASE::"Handled IC Outbox Jnl. Line";
              HandledICInOutJnlLineDim.INSERT;
              ICInOutJnlLineDim.DELETE;
            UNTIL ICInOutJnlLineDim.NEXT = 0;
          ICOutboxJnlLine.DELETE;
        UNTIL ICOutboxJnlLine.NEXT = 0;

      ICOutboxSalesHdr.SETRANGE("IC Transaction No.",ICOutboxTrans."Transaction No.");
      IF ICOutboxSalesHdr.FIND('-') THEN
        REPEAT
          HandledICOutboxSalesHdr.TRANSFERFIELDS(ICOutboxSalesHdr,TRUE);
          HandledICOutboxSalesHdr.INSERT;
          MoveICDocDimToHandled(
            DATABASE::"IC Outbox Sales Header",DATABASE::"Handled IC Outbox Sales Header",ICOutboxSalesHdr."IC Transaction No.",
            ICOutboxSalesHdr."IC Partner Code",ICOutboxSalesHdr."Transaction Source",0);

          ICOutboxSalesLine.SETRANGE("IC Transaction No.",ICOutboxSalesHdr."IC Transaction No.");
          ICOutboxSalesLine.SETRANGE("IC Partner Code",ICOutboxSalesHdr."IC Partner Code");
          ICOutboxSalesLine.SETRANGE("Transaction Source",ICOutboxSalesHdr."Transaction Source");
          IF ICOutboxSalesLine.FIND('-') THEN
            REPEAT
              HandledICOutboxSalesLine.TRANSFERFIELDS(ICOutboxSalesLine,TRUE);
              HandledICOutboxSalesLine.INSERT;
              MoveICDocDimToHandled(
                DATABASE::"IC Outbox Sales Line",DATABASE::"Handled IC Outbox Sales Line",ICOutboxSalesHdr."IC Transaction No.",
                ICOutboxSalesHdr."IC Partner Code",ICOutboxSalesHdr."Transaction Source",ICOutboxSalesLine."Line No.");
              ICOutboxSalesLine.DELETE;
            UNTIL ICOutboxSalesLine.NEXT = 0;
          ICOutboxSalesHdr.DELETE;
        UNTIL ICOutboxSalesHdr.NEXT = 0;

      ICOutboxPurchHdr.SETRANGE("IC Transaction No.",ICOutboxTrans."Transaction No.");
      IF ICOutboxPurchHdr.FIND('-') THEN
        REPEAT
          HandledICOutboxPurchHdr.TRANSFERFIELDS(ICOutboxPurchHdr,TRUE);
          HandledICOutboxPurchHdr.INSERT;
          MoveICDocDimToHandled(
            DATABASE::"IC Outbox Purchase Header",DATABASE::"Handled IC Outbox Purch. Hdr",ICOutboxPurchHdr."IC Transaction No.",
            ICOutboxPurchHdr."IC Partner Code",ICOutboxPurchHdr."Transaction Source",0);

          ICOutboxPurchLine.SETRANGE("IC Transaction No.",ICOutboxPurchHdr."IC Transaction No.");
          ICOutboxPurchLine.SETRANGE("IC Partner Code",ICOutboxPurchHdr."IC Partner Code");
          ICOutboxPurchLine.SETRANGE("Transaction Source",ICOutboxPurchHdr."Transaction Source");
          IF ICOutboxPurchLine.FIND('-') THEN
            REPEAT
              HandledICOutboxPurchLine.TRANSFERFIELDS(ICOutboxPurchLine,TRUE);
              HandledICOutboxPurchLine.INSERT;
              MoveICDocDimToHandled(
                DATABASE::"IC Outbox Purchase Line",DATABASE::"Handled IC Outbox Purch. Line",ICOutboxPurchHdr."IC Transaction No.",
                ICOutboxPurchHdr."IC Partner Code",ICOutboxPurchHdr."Transaction Source",ICOutboxPurchLine."Line No.");
              ICOutboxPurchLine.DELETE;
            UNTIL ICOutboxPurchLine.NEXT = 0;
          ICOutboxPurchHdr.DELETE;
        UNTIL ICOutboxPurchHdr.NEXT = 0;

      HandledICOutboxTrans.TRANSFERFIELDS(ICOutboxTrans,TRUE);
      CASE ICOutboxTrans."Line Action" OF
        ICOutboxTrans."Line Action"::"Send to IC Partner":
          IF ICOutboxTrans."Transaction Source" = ICOutboxTrans."Transaction Source"::"Created by Current Company" THEN
            HandledICOutboxTrans.Status := HandledICOutboxTrans.Status::"Sent to IC Partner"
          ELSE
            HandledICOutboxTrans.Status := HandledICOutboxTrans.Status::"Rejection Sent to IC Partner";
        ICOutboxTrans."Line Action"::Cancel:
          HandledICOutboxTrans.Status := HandledICOutboxTrans.Status::Cancelled;
      END;
      HandledICOutboxTrans.INSERT;
      ICOutboxTrans.DELETE;

      ICCommentLine.SETRANGE("Table Name",ICCommentLine."Table Name"::"IC Outbox Transaction");
      ICCommentLine.SETRANGE("Transaction No.",ICOutboxTrans."Transaction No.");
      ICCommentLine.SETRANGE("IC Partner Code",ICOutboxTrans."IC Partner Code");
      ICCommentLine.SETRANGE("Transaction Source",ICOutboxTrans."Transaction Source");
      IF ICCommentLine.FIND('-') THEN
        REPEAT
          HandledICCommentLine := ICCommentLine;
          HandledICCommentLine."Table Name" := HandledICCommentLine."Table Name"::"Handled IC Outbox Transaction";
          HandledICCommentLine.INSERT;
          ICCommentLine.DELETE;
        UNTIL ICCommentLine.NEXT = 0;
    END;

    [External]
    PROCEDURE CreateICDocDimFromPostedDocDim@36(ICDocDim@1000 : Record 442;DimSetID@1003 : Integer;TableNo@1001 : Integer);
    VAR
      DimSetEntry@1002 : Record 480;
    BEGIN
      DimSetEntry.RESET;
      DimSetEntry.SETRANGE("Dimension Set ID",DimSetID);
      IF DimSetEntry.FINDSET THEN
        REPEAT
          ICDocDim."Table ID" := TableNo;
          ICDocDim."Dimension Code" := DimMgt.ConvertDimtoICDim(DimSetEntry."Dimension Code");
          ICDocDim."Dimension Value Code" :=
            DimMgt.ConvertDimValuetoICDimVal(DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
          IF (ICDocDim."Dimension Code" <> '') AND (ICDocDim."Dimension Value Code" <> '') THEN
            ICDocDim.INSERT;
        UNTIL DimSetEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE FindReceiptLine@12(VAR PurchRcptLine@1002 : Record 121;PurchaseLineSource@1003 : Record 39) : Boolean;
    VAR
      PurchaseHeader@1000 : Record 38;
      PurchaseLine@1001 : Record 39;
    BEGIN
      IF NOT PurchaseHeader.GET(PurchaseHeader."Document Type"::Order,PurchaseLineSource."Receipt No.") THEN
        EXIT(FALSE);

      WITH PurchRcptLine DO BEGIN
        SETCURRENTKEY("Order No.");
        SETRANGE("Order No.",PurchaseHeader."No.");
        SETRANGE("Order Line No.",PurchaseLineSource."Receipt Line No.");
        SETRANGE(Type,PurchaseLineSource.Type);
        SETRANGE("No.",PurchaseLineSource."No.");
        SETFILTER("Qty. Rcd. Not Invoiced",'<>%1',0);
        IF NOT FINDFIRST THEN
          EXIT(FALSE);
      END;

      WITH PurchaseLine DO
        IF ABS(PurchRcptLine."Qty. Rcd. Not Invoiced") >= ABS(PurchaseLineSource.Quantity) THEN BEGIN
          SETCURRENTKEY("Document Type","Receipt No.");
          SETRANGE("Document Type","Document Type"::Invoice);
          SETRANGE("Receipt No.",PurchRcptLine."Document No.");
          SETRANGE("Receipt Line No.",PurchRcptLine."Line No.");
          SETRANGE(Type,PurchaseLineSource.Type);
          SETRANGE("No.",PurchaseLineSource."No.");
          SETFILTER(Quantity,'<>%1',0);
          EXIT(ISEMPTY);
        END;
    END;

    LOCAL PROCEDURE FindShipmentLine@34(VAR ReturnShptLine@1004 : Record 6651;PurchaseLineSource@1003 : Record 39) : Boolean;
    VAR
      PurchaseHeader@1001 : Record 38;
      PurchaseLine@1000 : Record 39;
    BEGIN
      IF NOT PurchaseHeader.GET(PurchaseHeader."Document Type"::"Return Order",PurchaseLineSource."Return Shipment No.") THEN
        EXIT(FALSE);

      WITH ReturnShptLine DO BEGIN
        SETCURRENTKEY("Return Order No.");
        SETRANGE("Return Order No.",PurchaseHeader."No.");
        SETRANGE("Return Order Line No.",PurchaseLineSource."Return Shipment Line No.");
        SETRANGE(Type,PurchaseLineSource.Type);
        SETRANGE("No.",PurchaseLineSource."No.");
        SETFILTER("Return Qty. Shipped Not Invd.",'<>%1',0);
        IF NOT FINDFIRST THEN
          EXIT(FALSE);
      END;

      WITH PurchaseLine DO
        IF ABS(ReturnShptLine."Return Qty. Shipped Not Invd.") >= ABS(PurchaseLineSource.Quantity) THEN BEGIN
          SETRANGE("Document Type","Document Type"::"Credit Memo");
          SETRANGE("Return Shipment No.",ReturnShptLine."Document No.");
          SETRANGE("Return Shipment Line No.",ReturnShptLine."Line No.");
          SETRANGE(Type,PurchaseLineSource.Type);
          SETRANGE("No.",PurchaseLineSource."No.");
          SETFILTER(Quantity,'<>%1',0);
          EXIT(ISEMPTY);
        END;
    END;

    LOCAL PROCEDURE FindRoundingSalesInvLine@42(DocumentNo@1000 : Code[20]) : Integer;
    VAR
      SalesInvoiceLine@1004 : Record 113;
    BEGIN
      WITH SalesInvoiceLine DO BEGIN
        SETRANGE("Document No.",DocumentNo);
        IF FINDLAST THEN
          IF Type = Type::"G/L Account" THEN
            IF "No." <> '' THEN
              IF "No." = GetCustInvRndgAccNo("Bill-to Customer No.") THEN
                EXIT("Line No.");
        EXIT(0);
      END;
    END;

    LOCAL PROCEDURE FindRoundingSalesCrMemoLine@44(DocumentNo@1000 : Code[20]) : Integer;
    VAR
      SalesCrMemoLine@1004 : Record 115;
    BEGIN
      WITH SalesCrMemoLine DO BEGIN
        SETRANGE("Document No.",DocumentNo);
        IF FINDLAST THEN
          IF Type = Type::"G/L Account" THEN
            IF "No." <> '' THEN
              IF "No." = GetCustInvRndgAccNo("Bill-to Customer No.") THEN
                EXIT("Line No.");
        EXIT(0);
      END;
    END;

    LOCAL PROCEDURE UpdateSalesLineICPartnerReference@40(VAR SalesLine@1003 : Record 37;SalesHeader@1002 : Record 36;ICInboxSalesLine@1000 : Record 435);
    VAR
      ICPartner@1001 : Record 413;
      ItemCrossReference@1004 : Record 5717;
      GLAccount@1005 : Record 15;
    BEGIN
      WITH ICInboxSalesLine DO
        IF ("IC Partner Ref. Type" <> "IC Partner Ref. Type"::"G/L Account") AND
           ("IC Partner Ref. Type" <> 0) AND
           ("IC Partner Ref. Type" <> "IC Partner Ref. Type"::"Charge (Item)") AND
           ("IC Partner Ref. Type" <> "IC Partner Ref. Type"::"Cross reference")
        THEN BEGIN
          ICPartner.GET(SalesHeader."Sell-to IC Partner Code");
          CASE ICPartner."Outbound Sales Item No. Type" OF
            ICPartner."Outbound Sales Item No. Type"::"Common Item No.":
              SalesLine.VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Common Item No.");
            ICPartner."Outbound Sales Item No. Type"::"Internal No.":
              BEGIN
                SalesLine."IC Partner Ref. Type" := "IC Partner Ref. Type"::Item;
                SalesLine."IC Partner Reference" := "IC Partner Reference";
              END;
            ICPartner."Outbound Sales Item No. Type"::"Cross Reference":
              BEGIN
                SalesLine.VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Cross reference");
                ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Customer);
                ItemCrossReference.SETRANGE("Cross-Reference Type No.",SalesHeader."Sell-to Customer No.");
                ItemCrossReference.SETRANGE("Item No.","IC Partner Reference");
                IF ItemCrossReference.FINDFIRST THEN
                  SalesLine."IC Partner Reference" := ItemCrossReference."Cross-Reference No.";
              END;
          END;
        END ELSE BEGIN
          SalesLine."IC Partner Ref. Type" := "IC Partner Ref. Type";
          IF "IC Partner Ref. Type" <> "IC Partner Ref. Type"::"G/L Account" THEN
            SalesLine."IC Partner Reference" := "IC Partner Reference"
          ELSE
            IF GLAccount.GET(TranslateICGLAccount("IC Partner Reference")) THEN
              SalesLine."IC Partner Reference" := GLAccount."Default IC Partner G/L Acc. No";
        END;
    END;

    LOCAL PROCEDURE UpdatePurchLineICPartnerReference@43(VAR PurchaseLine@1002 : Record 39;PurchaseHeader@1001 : Record 38;ICInboxPurchLine@1000 : Record 437);
    VAR
      ICPartner@1003 : Record 413;
      ItemCrossReference@1004 : Record 5717;
      GLAccount@1005 : Record 15;
    BEGIN
      WITH ICInboxPurchLine DO
        IF ("IC Partner Ref. Type" <> "IC Partner Ref. Type"::"G/L Account") AND
           ("IC Partner Ref. Type" <> 0) AND
           ("IC Partner Ref. Type" <> "IC Partner Ref. Type"::"Charge (Item)") AND
           ("IC Partner Ref. Type" <> "IC Partner Ref. Type"::"Cross reference")
        THEN BEGIN
          ICPartner.GET(PurchaseHeader."Buy-from IC Partner Code");
          CASE ICPartner."Outbound Purch. Item No. Type" OF
            ICPartner."Outbound Purch. Item No. Type"::"Common Item No.":
              PurchaseLine.VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Common Item No.");
            ICPartner."Outbound Purch. Item No. Type"::"Internal No.":
              BEGIN
                PurchaseLine."IC Partner Ref. Type" := "IC Partner Ref. Type"::Item;
                PurchaseLine."IC Partner Reference" := "IC Partner Reference";
              END;
            ICPartner."Outbound Purch. Item No. Type"::"Cross Reference":
              BEGIN
                PurchaseLine.VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Cross reference");
                ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Vendor);
                ItemCrossReference.SETRANGE("Cross-Reference Type No.",PurchaseHeader."Buy-from Vendor No.");
                ItemCrossReference.SETRANGE("Item No.","IC Partner Reference");
                IF ItemCrossReference.FINDFIRST THEN
                  PurchaseLine."IC Partner Reference" := ItemCrossReference."Cross-Reference No.";
              END;
            ICPartner."Outbound Purch. Item No. Type"::"Vendor Item No.":
              BEGIN
                PurchaseLine."IC Partner Ref. Type" := "IC Partner Ref. Type"::"Vendor Item No.";
                PurchaseLine."IC Partner Reference" := PurchaseLine."Vendor Item No.";
              END;
          END;
        END ELSE BEGIN
          PurchaseLine."IC Partner Ref. Type" := "IC Partner Ref. Type";
          IF "IC Partner Ref. Type" <> "IC Partner Ref. Type"::"G/L Account" THEN
            PurchaseLine."IC Partner Reference" := "IC Partner Reference"
          ELSE
            IF GLAccount.GET(TranslateICGLAccount("IC Partner Reference")) THEN
              PurchaseLine."IC Partner Reference" := GLAccount."Default IC Partner G/L Acc. No";
        END;
    END;

    LOCAL PROCEDURE UpdatePurchLineReceiptShipment@41(VAR PurchaseLine@1002 : Record 39);
    VAR
      PurchRcptLine@1000 : Record 121;
      ReturnShptLine@1001 : Record 6651;
      PurchaseOrderLine@1004 : Record 39;
      ItemTrackingMgt@1005 : Codeunit 6500;
      OrderDocumentNo@1003 : Code[20];
    BEGIN
      IF FindReceiptLine(PurchRcptLine,PurchaseLine) THEN BEGIN
        OrderDocumentNo := PurchaseLine."Receipt No.";
        PurchaseLine."Location Code" := PurchRcptLine."Location Code";
        PurchaseLine."Receipt No." := PurchRcptLine."Document No.";
        PurchaseLine."Receipt Line No." := PurchRcptLine."Line No.";
        IF PurchaseOrderLine.GET(PurchaseOrderLine."Document Type"::Order,OrderDocumentNo,PurchaseLine."Receipt Line No.") THEN
          ItemTrackingMgt.CopyHandledItemTrkgToPurchLineWithLineQty(PurchaseOrderLine,PurchaseLine);
      END ELSE BEGIN
        PurchaseLine."Receipt No." := '';
        PurchaseLine."Receipt Line No." := 0;
      END;

      IF FindShipmentLine(ReturnShptLine,PurchaseLine) THEN BEGIN
        OrderDocumentNo := PurchaseLine."Return Shipment No.";
        PurchaseLine."Location Code" := ReturnShptLine."Location Code";
        PurchaseLine."Return Shipment No." := ReturnShptLine."Document No.";
        PurchaseLine."Return Shipment Line No." := ReturnShptLine."Line No.";
        IF PurchaseOrderLine.GET(
             PurchaseOrderLine."Document Type"::"Return Order",OrderDocumentNo,PurchaseLine."Return Shipment Line No.")
        THEN
          ItemTrackingMgt.CopyHandledItemTrkgToInvLine2(PurchaseOrderLine,PurchaseLine);
      END ELSE BEGIN
        PurchaseLine."Return Shipment No." := '';
        PurchaseLine."Return Shipment Line No." := 0;
      END;
    END;

    LOCAL PROCEDURE UpdateICOutboxSalesLineReceiptShipment@45(VAR ICOutboxSalesLine@1000 : Record 427;ICOutboxSalesHeader@1001 : Record 426);
    VAR
      SalesShipmentHeader@1002 : Record 110;
      ReturnReceiptHeader@1003 : Record 6660;
    BEGIN
      WITH ICOutboxSalesLine DO
        CASE "Document Type" OF
          "Document Type"::Order,
          "Document Type"::Invoice:
            IF "Shipment No." = '' THEN BEGIN
              "Shipment No." := COPYSTR(ICOutboxSalesHeader."External Document No.",1,MAXSTRLEN("Shipment No."));
              "Shipment Line No." := "Line No.";
            END ELSE
              IF SalesShipmentHeader.GET("Shipment No.") THEN
                "Shipment No." := COPYSTR(SalesShipmentHeader."External Document No.",1,MAXSTRLEN("Shipment No."));
          "Document Type"::"Credit Memo",
          "Document Type"::"Return Order":
            IF "Return Receipt No." = '' THEN BEGIN
              "Return Receipt No." := COPYSTR(ICOutboxSalesHeader."External Document No.",1,MAXSTRLEN("Return Receipt No."));
              "Return Receipt Line No." := "Line No.";
            END ELSE
              IF ReturnReceiptHeader.GET("Return Receipt No.") THEN
                "Return Receipt No." := COPYSTR(ReturnReceiptHeader."External Document No.",1,MAXSTRLEN("Return Receipt No."));
        END;
    END;

    LOCAL PROCEDURE AssignCurrencyCodeInOutBoxDoc@47(VAR CurrencyCode@1000 : Code[10];ICPartnerCode@1002 : Code[20]);
    VAR
      AnotherCompGLSetup@1001 : Record 98;
      ICPartner@1003 : Record 413;
    BEGIN
      IF CurrencyCode = '' THEN BEGIN
        ICPartner.GET(ICPartnerCode);
        IF ICPartner."Inbox Type" = ICPartner."Inbox Type"::Database THEN BEGIN
          GetGLSetup;
          AnotherCompGLSetup.CHANGECOMPANY(ICPartner."Inbox Details");
          AnotherCompGLSetup.GET;
          IF GLSetup."LCY Code" <> AnotherCompGLSetup."LCY Code" THEN
            CurrencyCode := GLSetup."LCY Code";
        END;
      END;
    END;

    [Integration(TRUE)]
    [External]
    PROCEDURE ICOutboxTransactionCreated@90(VAR ICOutboxTransaction@1000 : Record 414);
    BEGIN
    END;

    BEGIN
    END.
  }
}

