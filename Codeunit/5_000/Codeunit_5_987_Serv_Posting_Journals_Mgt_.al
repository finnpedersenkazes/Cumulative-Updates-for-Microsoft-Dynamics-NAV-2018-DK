OBJECT Codeunit 5987 Serv-Posting Journals Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    Permissions=TableData 49=imd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ServiceHeader@1002 : Record 5900;
      Currency@1018 : Record 4;
      CurrExchRate@1012 : Record 330;
      SalesSetup@1013 : Record 311;
      TempValueEntryRelation@1011 : TEMPORARY Record 6508;
      ServITRMgt@1001 : Codeunit 5985;
      GenJnlPostLine@1004 : Codeunit 12;
      ItemJnlPostLine@1000 : Codeunit 22;
      ResJnlPostLine@1005 : Codeunit 212;
      ServLedgEntryPostSale@1025 : Codeunit 5912;
      TimeSheetMgt@1010 : Codeunit 950;
      WhseJnlRegisterLine@1007 : Codeunit 7301;
      GenJnlLineDocNo@1016 : Code[20];
      GenJnlLineExtDocNo@1006 : Code[20];
      SrcCode@1003 : Code[10];
      Consume@1008 : Boolean;
      Invoice@1009 : Boolean;
      ItemJnlRollRndg@1015 : Boolean;
      ServiceLinePostingDate@1020 : Date;

    [External]
    PROCEDURE Initialize@9(VAR TempServHeader@1000 : Record 5900;TmpConsume@1003 : Boolean;TmpInvoice@1004 : Boolean);
    VAR
      SrcCodeSetup@1001 : Record 242;
    BEGIN
      ServiceHeader := TempServHeader;
      SetPostingOptions(TmpConsume,TmpInvoice);
      SrcCodeSetup.GET;
      SalesSetup.GET;
      SrcCode := SrcCodeSetup."Service Management";
      Currency.Initialize(ServiceHeader."Currency Code");
      ItemJnlRollRndg := FALSE;
      GenJnlLineDocNo := '';
      GenJnlLineExtDocNo := '';
    END;

    [External]
    PROCEDURE Finalize@7();
    BEGIN
      CLEAR(GenJnlPostLine);
      CLEAR(ResJnlPostLine);
      CLEAR(ItemJnlPostLine);
      CLEAR(ServLedgEntryPostSale);
    END;

    [External]
    PROCEDURE SetPostingOptions@23(PassedConsume@1001 : Boolean;PassedInvoice@1002 : Boolean);
    BEGIN
      Consume := PassedConsume;
      Invoice := PassedInvoice;
    END;

    [External]
    PROCEDURE SetItemJnlRollRndg@12(PassedItemJnlRollRndg@1000 : Boolean);
    BEGIN
      ItemJnlRollRndg := PassedItemJnlRollRndg;
    END;

    [External]
    PROCEDURE SetGenJnlLineDocNos@21(DocNo@1001 : Code[20];ExtDocNo@1002 : Code[20]);
    BEGIN
      GenJnlLineDocNo := DocNo;
      GenJnlLineExtDocNo := ExtDocNo;
    END;

    LOCAL PROCEDURE IsWarehouseShipment@29(ServiceLine@1001 : Record 5902) : Boolean;
    VAR
      WarehouseShipmentLine@1000 : Record 7321;
    BEGIN
      WITH WarehouseShipmentLine DO BEGIN
        SETRANGE("Source Type",DATABASE::"Service Line");
        SETRANGE("Source Subtype",1);
        SETRANGE("Source No.",ServiceLine."Document No.");
        SETRANGE("Source Line No.",ServiceLine."Line No.");
        EXIT(NOT ISEMPTY);
      END;
    END;

    LOCAL PROCEDURE GetLocation@7300(LocationCode@1000 : Code[10];VAR Location@1001 : Record 14);
    BEGIN
      IF LocationCode = '' THEN
        Location.GetLocationSetup(LocationCode,Location)
      ELSE
        IF Location.Code <> LocationCode THEN
          Location.GET(LocationCode);
    END;

    [Internal]
    PROCEDURE PostItemJnlLine@10(VAR ServiceLine@1000 : Record 5902;QtyToBeShipped@1001 : Decimal;QtyToBeShippedBase@1002 : Decimal;QtyToBeConsumed@1016 : Decimal;QtyToBeConsumedBase@1017 : Decimal;QtyToBeInvoiced@1003 : Decimal;QtyToBeInvoicedBase@1004 : Decimal;ItemLedgShptEntryNo@1005 : Integer;VAR TrackingSpecification@1009 : Record 336;VAR TempTrackingSpecificationInv@1024 : Record 336;VAR TempHandlingSpecification@1023 : Record 336;VAR TempTrackingSpecification@1008 : TEMPORARY Record 336;VAR ServShptHeader@1006 : Record 5990;ServShptLineDocNo@1022 : Code[20]) : Integer;
    VAR
      ItemJnlLine@1014 : Record 83;
      Location@1013 : Record 14;
      TempWhseJnlLine@1012 : TEMPORARY Record 7311;
      TempWhseJnlLine2@1011 : TEMPORARY Record 7311;
      RemAmt@1021 : Decimal;
      RemDiscAmt@1019 : Decimal;
      PostWhseJnlLine@1010 : Boolean;
      CheckApplFromItemEntry@1020 : Boolean;
    BEGIN
      CLEAR(ItemJnlPostLine);
      IF NOT ItemJnlRollRndg THEN BEGIN
        RemAmt := 0;
        RemDiscAmt := 0;
      END;

      WITH ItemJnlLine DO BEGIN
        INIT;
        CopyFromServHeader(ServiceHeader);
        CopyFromServLine(ServiceLine);

        CopyTrackingFromSpec(TrackingSpecification);

        IF QtyToBeShipped = 0 THEN BEGIN
          IF ServiceLine."Document Type" = ServiceLine."Document Type"::"Credit Memo" THEN
            "Document Type" := "Document Type"::"Service Credit Memo"
          ELSE
            "Document Type" := "Document Type"::"Service Invoice";
          IF QtyToBeConsumed <> 0 THEN BEGIN
            "Entry Type" := "Entry Type"::"Negative Adjmt.";
            "Document No." := ServShptLineDocNo;
            "External Document No." := '';
            "Document Type" := "Document Type"::"Service Shipment";
          END ELSE BEGIN
            "Document No." := GenJnlLineDocNo;
            "External Document No." := GenJnlLineExtDocNo;
          END;
          "Posting No. Series" := ServiceHeader."Posting No. Series";
        END ELSE BEGIN
          IF ServiceLine."Document Type" <> ServiceLine."Document Type"::"Credit Memo" THEN BEGIN
            "Document Type" := "Document Type"::"Service Shipment";
            "Document No." := ServShptHeader."No.";
            "Posting No. Series" := ServShptHeader."No. Series";
          END;
          IF (QtyToBeInvoiced <> 0) OR (QtyToBeConsumed <> 0) THEN BEGIN
            IF QtyToBeConsumed <> 0 THEN
              "Entry Type" := "Entry Type"::"Negative Adjmt.";
            "Invoice No." := GenJnlLineDocNo;
            "External Document No." := GenJnlLineExtDocNo;
            IF "Document No." = '' THEN BEGIN
              IF ServiceLine."Document Type" = ServiceLine."Document Type"::"Credit Memo" THEN
                "Document Type" := "Document Type"::"Service Credit Memo"
              ELSE
                "Document Type" := "Document Type"::"Service Invoice";
              "Document No." := GenJnlLineDocNo;
            END;
            "Posting No. Series" := ServiceHeader."Posting No. Series";
          END;
          IF (QtyToBeConsumed <> 0) AND ("Document No." = '') THEN
            "Document No." := ServShptLineDocNo;
        END;

        "Document Line No." := ServiceLine."Line No.";
        Quantity := -QtyToBeShipped;
        "Quantity (Base)" := -QtyToBeShippedBase;
        IF QtyToBeInvoiced <> 0 THEN BEGIN
          "Invoiced Quantity" := -QtyToBeInvoiced;
          "Invoiced Qty. (Base)" := -QtyToBeInvoicedBase;
        END ELSE
          IF QtyToBeConsumed <> 0 THEN BEGIN
            "Invoiced Quantity" := -QtyToBeConsumed;
            "Invoiced Qty. (Base)" := -QtyToBeConsumedBase;
          END;
        "Unit Cost" := ServiceLine."Unit Cost (LCY)";
        "Source Currency Code" := ServiceHeader."Currency Code";
        "Unit Cost (ACY)" := ServiceLine."Unit Cost";
        "Value Entry Type" := "Value Entry Type"::"Direct Cost";
        "Applies-from Entry" := ServiceLine."Appl.-from Item Entry";

        IF Invoice AND (QtyToBeInvoiced <> 0) THEN BEGIN
          Amount := -(ServiceLine.Amount * (QtyToBeInvoiced / ServiceLine."Qty. to Invoice") - RemAmt);
          IF ServiceHeader."Prices Including VAT" THEN
            "Discount Amount" :=
              -((ServiceLine."Line Discount Amount" + ServiceLine."Inv. Discount Amount") / (1 + ServiceLine."VAT %" / 100) *
                (QtyToBeInvoiced / ServiceLine."Qty. to Invoice") - RemDiscAmt)
          ELSE
            "Discount Amount" :=
              -((ServiceLine."Line Discount Amount" + ServiceLine."Inv. Discount Amount") *
                (QtyToBeInvoiced / ServiceLine."Qty. to Invoice") - RemDiscAmt);
        END ELSE
          IF Consume AND (QtyToBeConsumed <> 0) THEN BEGIN
            Amount := -(ServiceLine.Amount * QtyToBeConsumed - RemAmt);
            "Discount Amount" :=
              -(ServiceLine."Line Discount Amount" * QtyToBeConsumed - RemDiscAmt);
          END;

        IF (QtyToBeInvoiced <> 0) OR (QtyToBeConsumed <> 0) THEN BEGIN
          RemAmt := Amount - ROUND(Amount);
          RemDiscAmt := "Discount Amount" - ROUND("Discount Amount");
          Amount := ROUND(Amount);
          "Discount Amount" := ROUND("Discount Amount");
        END ELSE BEGIN
          IF ServiceHeader."Prices Including VAT" THEN
            Amount :=
              -((QtyToBeShipped *
                 ServiceLine."Unit Price" * (1 - ServiceLine."Line Discount %" / 100) / (1 + ServiceLine."VAT %" / 100)) - RemAmt)
          ELSE
            Amount :=
              -((QtyToBeShipped * ServiceLine."Unit Price" * (1 - ServiceLine."Line Discount %" / 100)) - RemAmt);
          RemAmt := Amount - ROUND(Amount);
          IF ServiceHeader."Currency Code" <> '' THEN
            Amount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  ServiceLine."Posting Date",ServiceHeader."Currency Code",
                  Amount,ServiceHeader."Currency Factor"))
          ELSE
            Amount := ROUND(Amount);
        END;

        "Source Code" := SrcCode;
        "Item Shpt. Entry No." := ItemLedgShptEntryNo;
        "Invoice-to Source No." := ServiceLine."Bill-to Customer No.";

        IF SalesSetup."Exact Cost Reversing Mandatory" AND (ServiceLine.Type = ServiceLine.Type::Item) THEN
          IF ServiceLine."Document Type" = ServiceLine."Document Type"::"Credit Memo" THEN
            CheckApplFromItemEntry := ServiceLine.Quantity > 0
          ELSE
            CheckApplFromItemEntry := ServiceLine.Quantity < 0;

        IF (ServiceLine."Location Code" <> '') AND (ServiceLine.Type = ServiceLine.Type::Item) AND (Quantity <> 0) THEN BEGIN
          GetLocation(ServiceLine."Location Code",Location);
          IF ((ServiceLine."Document Type" IN [ServiceLine."Document Type"::Invoice,ServiceLine."Document Type"::"Credit Memo"]) AND
              Location."Directed Put-away and Pick") OR
             (Location."Bin Mandatory" AND NOT IsWarehouseShipment(ServiceLine))
          THEN BEGIN
            CreateWhseJnlLine(ItemJnlLine,ServiceLine,TempWhseJnlLine,Location);
            PostWhseJnlLine := TRUE;
          END;
        END;

        IF QtyToBeShippedBase <> 0 THEN
          IF ServiceLine."Document Type" = ServiceLine."Document Type"::"Credit Memo" THEN
            ServITRMgt.TransServLineToItemJnlLine(ServiceLine,ItemJnlLine,QtyToBeShippedBase,CheckApplFromItemEntry)
          ELSE
            ServITRMgt.TransferReservToItemJnlLine(
              ServiceLine,ItemJnlLine,-QtyToBeShippedBase,CheckApplFromItemEntry);

        IF CheckApplFromItemEntry THEN
          ServiceLine.TESTFIELD("Appl.-from Item Entry");

        ItemJnlPostLine.RunWithCheck(ItemJnlLine);

        ItemJnlPostLine.CollectValueEntryRelation(TempValueEntryRelation,'');

        IF ItemJnlPostLine.CollectTrackingSpecification(TempHandlingSpecification) THEN
          ServITRMgt.InsertTempHandlngSpecification(DATABASE::"Service Line",
            ServiceLine,TempHandlingSpecification,
            TempTrackingSpecification,TempTrackingSpecificationInv,
            QtyToBeInvoiced <> 0);

        IF PostWhseJnlLine THEN BEGIN
          ServITRMgt.SplitWhseJnlLine(TempWhseJnlLine,TempWhseJnlLine2,TempTrackingSpecification,FALSE);
          IF TempWhseJnlLine2.FIND('-') THEN
            REPEAT
              WhseJnlRegisterLine.RegisterWhseJnlLine(TempWhseJnlLine2);
            UNTIL TempWhseJnlLine2.NEXT = 0;
        END;
        EXIT("Item Shpt. Entry No.");
      END;
    END;

    LOCAL PROCEDURE CreateWhseJnlLine@7302(ItemJnlLine@1000 : Record 83;ServLine@1001 : Record 5902;VAR TempWhseJnlLine@1002 : TEMPORARY Record 7311;Location@1005 : Record 14);
    VAR
      WMSMgmt@1004 : Codeunit 7302;
      WhseMgt@1003 : Codeunit 5775;
    BEGIN
      WITH ServLine DO BEGIN
        WMSMgmt.CheckAdjmtBin(Location,ItemJnlLine.Quantity,TRUE);
        WMSMgmt.CreateWhseJnlLine(ItemJnlLine,0,TempWhseJnlLine,FALSE);
        TempWhseJnlLine."Source Type" := DATABASE::"Service Line";
        TempWhseJnlLine."Source Subtype" := "Document Type";
        TempWhseJnlLine."Source Code" := SrcCode;
        TempWhseJnlLine."Source Document" := WhseMgt.GetSourceDocument(TempWhseJnlLine."Source Type",TempWhseJnlLine."Source Subtype");
        TempWhseJnlLine."Source No." := "Document No.";
        TempWhseJnlLine."Source Line No." := "Line No.";
        CASE "Document Type" OF
          "Document Type"::Order:
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted Shipment";
          "Document Type"::Invoice:
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted S. Inv.";
          "Document Type"::"Credit Memo":
            TempWhseJnlLine."Reference Document" :=
              TempWhseJnlLine."Reference Document"::"Posted S. Cr. Memo";
        END;
        TempWhseJnlLine."Reference No." := ItemJnlLine."Document No.";
      END;
    END;

    [Internal]
    PROCEDURE PostInvoicePostBufferLine@2(VAR InvoicePostBuffer@1002 : Record 49;DocType@1003 : Integer;DocNo@1004 : Code[20];ExtDocNo@1005 : Code[20]);
    VAR
      GenJnlLine@1000 : Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          ServiceLinePostingDate,ServiceHeader."Document Date",ServiceHeader."Posting Description",
          InvoicePostBuffer."Global Dimension 1 Code",InvoicePostBuffer."Global Dimension 2 Code",
          InvoicePostBuffer."Dimension Set ID",ServiceHeader."Reason Code");

        CopyDocumentFields(DocType,DocNo,ExtDocNo,SrcCode,'');

        CopyFromServiceHeader(ServiceHeader);
        CopyFromInvoicePostBuffer(InvoicePostBuffer);
        "Gen. Posting Type" := "Gen. Posting Type"::Sale;

        GenJnlPostLine.RunWithCheck(GenJnlLine);
      END;
    END;

    [Internal]
    PROCEDURE PostCustomerEntry@3(VAR TotalServiceLine@1004 : Record 5902;VAR TotalServiceLineLCY@1005 : Record 5902;DocType@1003 : Integer;DocNo@1002 : Code[20];ExtDocNo@1001 : Code[20]);
    VAR
      GenJnlLine@1000 : Record 81;
    BEGIN
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          ServiceLinePostingDate,ServiceHeader."Document Date",ServiceHeader."Posting Description",
          ServiceHeader."Shortcut Dimension 1 Code",ServiceHeader."Shortcut Dimension 2 Code",
          ServiceHeader."Dimension Set ID",ServiceHeader."Reason Code");

        CopyDocumentFields(DocType,DocNo,ExtDocNo,SrcCode,'');

        "Account Type" := "Account Type"::Customer;
        "Account No." := ServiceHeader."Bill-to Customer No.";
        CopyFromServiceHeader(ServiceHeader);
        SetCurrencyFactor(ServiceHeader."Currency Code",ServiceHeader."Currency Factor");

        CopyFromServiceHeaderApplyTo(ServiceHeader);
        CopyFromServiceHeaderPayment(ServiceHeader);

        Amount := -TotalServiceLine."Amount Including VAT";
        "Source Currency Amount" := -TotalServiceLine."Amount Including VAT";
        "Amount (LCY)" := -TotalServiceLineLCY."Amount Including VAT";
        "Sales/Purch. (LCY)" := -TotalServiceLineLCY.Amount;
        "Profit (LCY)" := -(TotalServiceLineLCY.Amount - TotalServiceLineLCY."Unit Cost (LCY)");
        "Inv. Discount (LCY)" := -TotalServiceLineLCY."Inv. Discount Amount";
        "System-Created Entry" := TRUE;

        GenJnlPostLine.RunWithCheck(GenJnlLine);
      END;
    END;

    [Internal]
    PROCEDURE PostBalancingEntry@11(VAR TotalServiceLine@1002 : Record 5902;VAR TotalServiceLineLCY@1006 : Record 5902;DocType@1005 : Integer;DocNo@1004 : Code[20];ExtDocNo@1003 : Code[20]);
    VAR
      CustLedgEntry@1000 : Record 21;
      GenJnlLine@1001 : Record 81;
    BEGIN
      CustLedgEntry.FINDLAST;
      WITH GenJnlLine DO BEGIN
        InitNewLine(
          ServiceLinePostingDate,ServiceHeader."Document Date",ServiceHeader."Posting Description",
          ServiceHeader."Shortcut Dimension 1 Code",ServiceHeader."Shortcut Dimension 2 Code",
          ServiceHeader."Dimension Set ID",ServiceHeader."Reason Code");

        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::"Credit Memo" THEN
          CopyDocumentFields("Document Type"::Refund,DocNo,ExtDocNo,SrcCode,'')
        ELSE
          CopyDocumentFields("Document Type"::Payment,DocNo,ExtDocNo,SrcCode,'');

        "Account Type" := "Account Type"::Customer;
        "Account No." := ServiceHeader."Bill-to Customer No.";
        CopyFromServiceHeader(ServiceHeader);
        SetCurrencyFactor(ServiceHeader."Currency Code",ServiceHeader."Currency Factor");

        SetApplyToDocNo(ServiceHeader,GenJnlLine,DocType,DocNo);

        Amount := TotalServiceLine."Amount Including VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
        "Source Currency Amount" := Amount;
        CustLedgEntry.CALCFIELDS(Amount);
        IF CustLedgEntry.Amount = 0 THEN
          "Amount (LCY)" := TotalServiceLineLCY."Amount Including VAT"
        ELSE
          "Amount (LCY)" :=
            TotalServiceLineLCY."Amount Including VAT" +
            ROUND(CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");

        GenJnlPostLine.RunWithCheck(GenJnlLine);
      END;
    END;

    LOCAL PROCEDURE SetApplyToDocNo@17(ServiceHeader@1000 : Record 5900;VAR GenJnlLine@1001 : Record 81;DocType@1002 : Option;DocNo@1003 : Code[20]);
    BEGIN
      WITH GenJnlLine DO BEGIN
        IF ServiceHeader."Bal. Account Type" = ServiceHeader."Bal. Account Type"::"Bank Account" THEN
          "Bal. Account Type" := "Bal. Account Type"::"Bank Account";
        "Bal. Account No." := ServiceHeader."Bal. Account No.";
        "Applies-to Doc. Type" := DocType;
        "Applies-to Doc. No." := DocNo;
      END;
    END;

    [External]
    PROCEDURE PostResJnlLineShip@8(VAR ServiceLine@1002 : Record 5902;DocNo@1003 : Code[20];ExtDocNo@1004 : Code[20]);
    VAR
      ResJnlLine@1000 : Record 207;
    BEGIN
      IF ServiceLine."Time Sheet No." <> '' THEN
        TimeSheetMgt.CheckServiceLine(ServiceLine);

      PostResJnlLine(
        ServiceHeader,ServiceLine,
        DocNo,ExtDocNo,SrcCode,ServiceHeader."Posting No. Series",
        ResJnlLine."Entry Type"::Usage,-ServiceLine."Qty. to Ship",
        ServiceLine.Amount / ServiceLine."Qty. to Ship",-ServiceLine.Amount);

      TimeSheetMgt.CreateTSLineFromServiceLine(ServiceLine,GenJnlLineDocNo,TRUE);
    END;

    [External]
    PROCEDURE PostResJnlLineUndoUsage@24(VAR ServiceLine@1002 : Record 5902;DocNo@1003 : Code[20];ExtDocNo@1004 : Code[20]);
    VAR
      ResJnlLine@1000 : Record 207;
    BEGIN
      PostResJnlLine(
        ServiceHeader,ServiceLine,
        DocNo,ExtDocNo,SrcCode,ServiceHeader."Posting No. Series",
        ResJnlLine."Entry Type"::Usage,-ServiceLine."Qty. to Invoice",
        ServiceLine.Amount / ServiceLine."Qty. to Invoice",-ServiceLine.Amount);
    END;

    [External]
    PROCEDURE PostResJnlLineSale@66(VAR ServiceLine@1002 : Record 5902;DocNo@1003 : Code[20];ExtDocNo@1004 : Code[20]);
    VAR
      ResJnlLine@1000 : Record 207;
    BEGIN
      PostResJnlLine(
        ServiceHeader,ServiceLine,DocNo,ExtDocNo,SrcCode,ServiceHeader."Posting No. Series",
        ResJnlLine."Entry Type"::Sale,-ServiceLine."Qty. to Invoice",
        -ServiceLine.Amount / ServiceLine.Quantity,-ServiceLine.Amount);
    END;

    [External]
    PROCEDURE PostResJnlLineConsume@22(VAR ServiceLine@1002 : Record 5902;VAR ServShptHeader@1005 : Record 5990);
    VAR
      ResJnlLine@1004 : Record 207;
    BEGIN
      IF ServiceLine."Time Sheet No." <> '' THEN
        TimeSheetMgt.CheckServiceLine(ServiceLine);

      PostResJnlLine(
        ServiceHeader,ServiceLine,
        ServShptHeader."No.",'',SrcCode,ServShptHeader."No. Series",
        ResJnlLine."Entry Type"::Usage,-ServiceLine."Qty. to Consume",0,0);

      TimeSheetMgt.CreateTSLineFromServiceLine(ServiceLine,GenJnlLineDocNo,FALSE);
    END;

    LOCAL PROCEDURE PostResJnlLine@4(ServiceHeader@1001 : Record 5900;ServiceLine@1010 : Record 5902;DocNo@1002 : Code[20];ExtDocNo@1003 : Code[35];SrcCode@1004 : Code[10];PostingNoSeries@1005 : Code[20];EntryType@1006 : Option;Qty@1007 : Decimal;UnitPrice@1008 : Decimal;TotalPrice@1009 : Decimal);
    VAR
      ResJnlLine@1000 : Record 207;
    BEGIN
      WITH ResJnlLine DO BEGIN
        INIT;
        CopyDocumentFields(DocNo,ExtDocNo,SrcCode,PostingNoSeries);
        CopyFromServHeader(ServiceHeader);
        CopyFromServLine(ServiceLine);

        "Entry Type" := EntryType;
        Quantity := Qty;
        "Unit Cost" := ServiceLine."Unit Cost (LCY)";
        "Total Cost" := ServiceLine."Unit Cost (LCY)" * Quantity;
        "Unit Price" := UnitPrice;
        "Total Price" := TotalPrice;

        ResJnlPostLine.RunWithCheck(ResJnlLine);
      END;
    END;

    [External]
    PROCEDURE InitServiceRegister@19(VAR NextServLedgerEntryNo@1000 : Integer;VAR NextWarrantyLedgerEntryNo@1001 : Integer);
    BEGIN
      ServLedgEntryPostSale.InitServiceRegister(NextServLedgerEntryNo,NextWarrantyLedgerEntryNo);
    END;

    [External]
    PROCEDURE FinishServiceRegister@14(VAR nextServEntryNo@1000 : Integer;VAR nextWarrantyEntryNo@1001 : Integer);
    BEGIN
      ServLedgEntryPostSale.FinishServiceRegister(nextServEntryNo,nextWarrantyEntryNo);
    END;

    [Internal]
    PROCEDURE InsertServLedgerEntry@6(VAR NextEntryNo@1002 : Integer;VAR ServiceHeader@1006 : Record 5900;VAR ServiceLine@1000 : Record 5902;VAR ServItemLine@1003 : Record 5901;Qty@1001 : Decimal;DocNo@1005 : Code[20]) : Integer;
    BEGIN
      EXIT(
        ServLedgEntryPostSale.InsertServLedgerEntry(NextEntryNo,ServiceHeader,ServiceLine,ServItemLine,Qty,DocNo));
    END;

    [Internal]
    PROCEDURE InsertServLedgerEntrySale@16(VAR passedNextEntryNo@1005 : Integer;VAR ServHeader@1004 : Record 5900;VAR ServLine@1003 : Record 5902;VAR ServItemLine@1006 : Record 5901;Qty@1002 : Decimal;QtyToCharge@1001 : Decimal;GenJnlLineDocNo@1000 : Code[20];DocLineNo@1007 : Integer);
    BEGIN
      ServLedgEntryPostSale.InsertServLedgerEntrySale(
        passedNextEntryNo,ServHeader,ServLine,ServItemLine,Qty,QtyToCharge,GenJnlLineDocNo,DocLineNo);
    END;

    [Internal]
    PROCEDURE CreateCreditEntry@20(VAR passedNextEntryNo@1003 : Integer;VAR ServHeader@1002 : Record 5900;VAR ServLine@1001 : Record 5902;GenJnlLineDocNo@1000 : Code[20]);
    BEGIN
      ServLedgEntryPostSale.CreateCreditEntry(passedNextEntryNo,ServHeader,ServLine,GenJnlLineDocNo);
    END;

    [Internal]
    PROCEDURE InsertWarrantyLedgerEntry@1(VAR NextWarrantyEntryNo@1001 : Integer;VAR ServiceHeader@1002 : Record 5900;VAR ServiceLine@1000 : Record 5902;VAR ServItemLine@1003 : Record 5901;Qty@1006 : Decimal;GenJnlLineDocNo@1005 : Code[20]) : Integer;
    BEGIN
      EXIT(
        ServLedgEntryPostSale.InsertWarrantyLedgerEntry(
          NextWarrantyEntryNo,ServiceHeader,ServiceLine,ServItemLine,Qty,GenJnlLineDocNo));
    END;

    [External]
    PROCEDURE CalcSLEDivideAmount@18(Qty@1000 : Decimal;VAR passedServHeader@1001 : Record 5900;VAR passedTempServLine@1002 : Record 5902;VAR passedVATAmountLine@1003 : Record 290);
    BEGIN
      ServLedgEntryPostSale.CalcDivideAmount(Qty,passedServHeader,passedTempServLine,passedVATAmountLine);
    END;

    [External]
    PROCEDURE TestSrvCostDirectPost@13(ServLineNo@1000 : Code[20]);
    VAR
      ServCost@1001 : Record 5905;
      GLAcc@1002 : Record 15;
    BEGIN
      ServCost.GET(ServLineNo);
      GLAcc.GET(ServCost."Account No.");
      GLAcc.TESTFIELD("Direct Posting",TRUE);
    END;

    [External]
    PROCEDURE TestGLAccDirectPost@15(ServLineNo@1000 : Code[20]);
    VAR
      GLAcc@1001 : Record 15;
    BEGIN
      GLAcc.GET(ServLineNo);
      GLAcc.TESTFIELD("Direct Posting",TRUE);
    END;

    [External]
    PROCEDURE CollectValueEntryRelation@5(VAR PassedValueEntryRelation@1000 : Record 6508;RowId@1001 : Text[100]);
    BEGIN
      TempValueEntryRelation.RESET;
      PassedValueEntryRelation.RESET;

      IF TempValueEntryRelation.FINDSET THEN
        REPEAT
          PassedValueEntryRelation := TempValueEntryRelation;
          PassedValueEntryRelation."Source RowId" := RowId;
          PassedValueEntryRelation.INSERT;
        UNTIL TempValueEntryRelation.NEXT = 0;

      TempValueEntryRelation.DELETEALL;
    END;

    [Internal]
    PROCEDURE PostJobJnlLine@38(VAR ServHeader@1004 : Record 5900;ServLine@1012 : Record 5902;QtyToBeConsumed@1018 : Decimal) : Boolean;
    VAR
      JobJnlLine@1000 : Record 210;
      SourceCodeSetup@1006 : Record 242;
      ServiceCost@1011 : Record 5905;
      Job@1016 : Record 167;
      JT@1015 : Record 1001;
      Item@1017 : Record 27;
      JobJnlPostLine@1008 : Codeunit 1012;
      CurrencyFactor@1001 : Decimal;
      UnitPriceLCY@1003 : Decimal;
    BEGIN
      WITH ServLine DO BEGIN
        IF ("Job No." = '') OR (QtyToBeConsumed = 0) THEN
          EXIT(FALSE);

        TESTFIELD("Job Task No.");
        Job.LOCKTABLE;
        JT.LOCKTABLE;
        Job.GET("Job No.");
        JT.GET("Job No.","Job Task No.");

        JobJnlLine.INIT;

        JobJnlLine.DontCheckStdCost;

        JobJnlLine.VALIDATE("Job No.","Job No.");
        JobJnlLine.VALIDATE("Job Task No.","Job Task No.");
        JobJnlLine.VALIDATE("Line Type","Job Line Type");
        JobJnlLine.VALIDATE("Posting Date","Posting Date");
        JobJnlLine."Job Posting Only" := TRUE;
        JobJnlLine."No." := "No.";

        CASE Type OF
          Type::"G/L Account":
            JobJnlLine.Type := JobJnlLine.Type::"G/L Account";
          Type::Item:
            JobJnlLine.Type := JobJnlLine.Type::Item;
          Type::Resource:
            JobJnlLine.Type := JobJnlLine.Type::Resource;
          Type::Cost:
            BEGIN
              ServiceCost.SETRANGE(Code,"No.");
              ServiceCost.FINDFIRST;
              JobJnlLine.Type := JobJnlLine.Type::"G/L Account";
              JobJnlLine."No." := ServiceCost."Account No.";
            END;
        END; // Case Type
        JobJnlLine.VALIDATE("No.");
        JobJnlLine.Description := Description;
        JobJnlLine."Description 2" := "Description 2";

        JobJnlLine."Variant Code" := "Variant Code";

        JobJnlLine."Unit of Measure Code" := "Unit of Measure Code";
        JobJnlLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
        JobJnlLine.VALIDATE(Quantity,-QtyToBeConsumed);

        JobJnlLine."Document No." := ServHeader."Shipping No.";
        JobJnlLine."Service Order No." := "Document No.";
        JobJnlLine."External Document No." := ServHeader."Shipping No.";
        JobJnlLine."Posted Service Shipment No." := ServHeader."Shipping No.";

        IF Type = Type::Item THEN BEGIN
          Item.GET("No.");
          IF Item."Costing Method" = Item."Costing Method"::Standard THEN
            JobJnlLine.VALIDATE("Unit Cost (LCY)",Item."Standard Cost")
          ELSE
            JobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)")
        END ELSE
          JobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");

        IF "Currency Code" = Job."Currency Code" THEN
          JobJnlLine.VALIDATE("Unit Price","Unit Price");
        IF "Currency Code" <> '' THEN BEGIN
          Currency.GET("Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
          CurrencyFactor := CurrExchRate.ExchangeRate("Posting Date","Currency Code");
          UnitPriceLCY :=
            ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code","Unit Price",CurrencyFactor),
              Currency."Amount Rounding Precision");
          JobJnlLine.VALIDATE("Unit Price (LCY)",UnitPriceLCY);
        END ELSE
          JobJnlLine.VALIDATE("Unit Price (LCY)","Unit Price");

        JobJnlLine.VALIDATE("Line Discount %","Line Discount %");

        JobJnlLine."Job Planning Line No." := "Job Planning Line No.";
        JobJnlLine."Remaining Qty." := "Job Remaining Qty.";
        JobJnlLine."Remaining Qty. (Base)" := "Job Remaining Qty. (Base)";

        JobJnlLine."Location Code" := "Location Code";
        JobJnlLine."Entry Type" := JobJnlLine."Entry Type"::Usage;

        JobJnlLine."Posting Group" := "Posting Group";
        JobJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
        JobJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
        JobJnlLine."Customer Price Group" := "Customer Price Group";

        SourceCodeSetup.GET;
        JobJnlLine."Source Code" := SourceCodeSetup."Service Management";

        JobJnlLine."Work Type Code" := "Work Type Code";

        JobJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        JobJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        JobJnlLine."Dimension Set ID" := "Dimension Set ID";
      END;

      JobJnlPostLine.RunWithCheck(JobJnlLine);
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE SetPostingDate@39(PostingDate@1000 : Date);
    BEGIN
      ServiceLinePostingDate := PostingDate;
    END;

    BEGIN
    END.
  }
}

