OBJECT Codeunit 5988 Serv-Documents Mgt.
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 49=imd,
                TableData 5900=imd,
                TableData 5901=imd,
                TableData 5902=imd,
                TableData 5907=m,
                TableData 5908=m,
                TableData 5989=imd,
                TableData 5990=imd,
                TableData 5991=imd,
                TableData 5992=imd,
                TableData 5993=imd,
                TableData 5994=imd,
                TableData 5995=imd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ServHeader@1002 : TEMPORARY Record 5900;
      ServLine@1003 : TEMPORARY Record 5902;
      TempServiceLine@1035 : TEMPORARY Record 5902;
      ServItemLine@1004 : TEMPORARY Record 5901;
      ServShptHeader@1018 : TEMPORARY Record 5990;
      ServShptItemLine@1047 : TEMPORARY Record 5989;
      ServShptLine@1019 : TEMPORARY Record 5991;
      ServInvHeader@1020 : TEMPORARY Record 5992;
      ServInvLine@1021 : TEMPORARY Record 5993;
      ServCrMemoHeader@1022 : TEMPORARY Record 5994;
      ServCrMemoLine@1023 : TEMPORARY Record 5995;
      PServLine@1052 : Record 5902;
      PServItemLine@1053 : Record 5901;
      TempHandlingSpecification@1058 : TEMPORARY Record 336;
      TempInvoicingSpecification@1056 : TEMPORARY Record 336;
      TempTrackingSpecification@1039 : TEMPORARY Record 336;
      TempTrackingSpecificationInv@1057 : TEMPORARY Record 336;
      TempValueEntryRelation@1042 : TEMPORARY Record 6508;
      SalesSetup@1029 : Record 311;
      ServMgtSetup@1016 : Record 5911;
      ServDocReg@1034 : Record 5936;
      DummyServCommentLine@1043 : Record 5906;
      ServiceCommentLine@1063 : Record 5906;
      TempWarrantyLedgerEntry@1065 : TEMPORARY Record 5908;
      ServPostingJnlsMgt@1000 : Codeunit 5987;
      ServAmountsMgt@1001 : Codeunit 5986;
      ServITRMgt@1060 : Codeunit 5985;
      ServCalcDisc@1054 : Codeunit 5950;
      ServOrderMgt@1038 : Codeunit 5900;
      ServLogMgt@1048 : Codeunit 5906;
      DimMgt@1011 : Codeunit 408;
      ServAllocMgt@1031 : Codeunit 5930;
      GenJnlLineExtDocNo@1024 : Code[20];
      GenJnlLineDocNo@1025 : Code[20];
      SrcCode@1017 : Code[10];
      GenJnlLineDocType@1026 : Integer;
      ItemLedgShptEntryNo@1041 : Integer;
      NextServLedgerEntryNo@1045 : Integer;
      NextWarrantyLedgerEntryNo@1044 : Integer;
      Ship@1006 : Boolean;
      Consume@1007 : Boolean;
      Invoice@1008 : Boolean;
      Text001@1005 : TextConst 'DAN=Der er intet at bogf�re.;ENU=There is nothing to post.';
      Text007@1028 : TextConst 'DAN=%1 %2 -> Faktura %3;ENU=%1 %2 -> Invoice %3';
      Text008@1027 : TextConst 'DAN=%1 %2 -> kreditnota %3;ENU=%1 %2 -> Credit Memo %3';
      Text011@1033 : TextConst 'DAN=skal have samme fortegn som salgsleverancen.;ENU=must have the same sign as the shipment.';
      Text013@1032 : TextConst 'DAN=Salgsleverancelinjerne er slettet.;ENU=The shipment lines have been deleted.';
      Text014@1037 : TextConst 'DAN=Du kan ikke fakturere ordre %1 for mere, end der er leveret.;ENU=You cannot invoice more than you have shipped for order %1.';
      Text015@1040 : TextConst 'DAN="Den %1, du vil fakturere, har angivet en %2.\Du skal muligvis k�re en prisjustering. Vil du forts�tte bogf�ringen? ";ENU="The %1 you are going to invoice has a %2 entered.\You may need to run price adjustment. Do you want to continue posting? "';
      Text023@1061 : TextConst 'DAN=Denne ordre skal v�re en fuld leverance.;ENU=This order must be a complete Shipment.';
      Text026@1062 : TextConst 'DAN=Linje %1 i leverancen %2, som du fors�ger at fakturere, er allerede blevet faktureret.;ENU=Line %1 of the shipment %2, which you are attempting to invoice, has already been invoiced.';
      Text027@1030 : TextConst 'DAN=Det antal, som du fors�ger at fakturere, er st�rre end antallet i leverancen %1.;ENU=The quantity you are attempting to invoice is greater than the quantity in shipment %1.';
      Text028@1015 : TextConst 'DAN=Kombinationen af de dimensioner, der bliver brugt i %1 %2, er sp�rret. %3;ENU=The combination of dimensions used in %1 %2 is blocked. %3';
      Text029@1014 : TextConst 'DAN=Kombinationen af de dimensioner, der bliver brugt i %1 %2 linjenr. %3 er sp�rret. %4;ENU=The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
      Text030@1013 : TextConst 'DAN=De dimensioner, der bliver brugt i %1 %2, er ugyldige. %3;ENU=The dimensions used in %1 %2 are invalid. %3';
      Text031@1012 : TextConst 'DAN=De dimensioner, der bliver brugt i %1 %2 linjenr. %3, er ugyldige. %4;ENU=The dimensions used in %1 %2, line no. %3 are invalid. %4';
      CloseCondition@1036 : Boolean;
      ServLinesPassed@1046 : Boolean;
      Text035@1051 : TextConst 'DAN=%1 %2 er knyttet til samme %3 som %1 %4.;ENU=The %1 %2 relates to the same %3 as %1 %4.';
      Text039@1050 : TextConst 'DAN=%1 %2 p� %3 %4 er relateret til %5, som allerede er faktureret.;ENU=%1 %2 on %3 %4 relates to a %5 that has already been invoiced.';
      Text041@1049 : TextConst 'DAN=Der er fundet gamle serviceposter af typen %1 for servicekontrakten %2.\Du skal lukke dem ved at bogf�re de gamle servicefakturaer.;ENU=Old %1 service ledger entries have been found for service contract %2.\You must close them by posting the old service invoices.';
      TrackingSpecificationExists@1059 : Boolean;
      ServLineInvoicedConsumedQty@1064 : Decimal;
      ServLedgEntryNo@1009 : Integer;

    [External]
    PROCEDURE Initialize@1(VAR PassedServiceHeader@1000 : Record 5900;VAR PassedServiceLine@1001 : Record 5902);
    VAR
      SrcCodeSetup@1002 : Record 242;
    BEGIN
      CloseCondition := TRUE;
      CLEAR(ServPostingJnlsMgt);
      CLEAR(ServAmountsMgt);
      PassedServiceHeader.ValidateSalesPersonOnServiceHeader(PassedServiceHeader,TRUE,TRUE);
      PrepareDocument(PassedServiceHeader,PassedServiceLine);
      CheckSysCreatedEntry;
      CheckShippingAdvice;
      CheckDim;
      ServMgtSetup.GET;
      GetAndCheckCustomer;
      SalesSetup.GET;
      SrcCodeSetup.GET;
      SrcCode := SrcCodeSetup."Service Management";
      ServPostingJnlsMgt.Initialize(ServHeader,Consume,Invoice);
      ServAmountsMgt.Initialize(ServHeader."Currency Code"); // roundingLineInserted is set to FALSE;
      TrackingSpecificationExists := FALSE;
    END;

    [Internal]
    PROCEDURE CalcInvDiscount@39();
    BEGIN
      IF SalesSetup."Calc. Inv. Discount" THEN BEGIN
        ServLine.FIND('-');
        ServCalcDisc.CalculateWithServHeader(ServHeader,PServLine,ServLine);
      END;
    END;

    [Internal]
    PROCEDURE PostDocumentLines@10(VAR Window@1000 : Dialog);
    VAR
      ServiceLineACY@1010 : Record 5902;
      TotalServiceLine@1008 : Record 5902;
      TotalServiceLineLCY@1009 : Record 5902;
      ServLineOld@1022 : Record 5902;
      TempServLine@1011 : TEMPORARY Record 5902;
      TempVATAmountLine@1006 : TEMPORARY Record 290;
      TempVATAmountLineForSLE@1018 : TEMPORARY Record 290;
      TempVATAmountLineRemainder@1003 : TEMPORARY Record 290;
      InvPostingBuffer@1004 : ARRAY [2] OF TEMPORARY Record 49;
      DummyTrackingSpecification@1016 : Record 336;
      Item@1021 : Record 27;
      ServItemMgt@1020 : Codeunit 5920;
      RemQtyToBeInvoiced@1012 : Decimal;
      RemQtyToBeInvoicedBase@1013 : Decimal;
      RemQtyToBeConsumed@1014 : Decimal;
      RemQtyToBeConsumedBase@1015 : Decimal;
      LineCount@1001 : Integer;
      ApplToServEntryNo@1023 : Integer;
      WarrantyNo@1019 : Integer;
      BiggestLineNo@1024 : Integer;
      LastLineRetrieved@1017 : Boolean;
    BEGIN
      LineCount := 0;

      // init cu for posting SLE type Usage
      ServPostingJnlsMgt.InitServiceRegister(NextServLedgerEntryNo,NextWarrantyLedgerEntryNo);

      ServLine.CalcVATAmountLines(1,ServHeader,ServLine,TempVATAmountLine,Ship);
      ServLine.CalcVATAmountLines(2,ServHeader,ServLine,TempVATAmountLineForSLE,Ship);

      ServLine.RESET;
      SortLines(ServLine);
      ServLedgEntryNo := FindFirstServLedgEntry(ServLine);
      IF ServLine.FIND('-') THEN
        REPEAT
          ServPostingJnlsMgt.SetItemJnlRollRndg(FALSE);
          IF ServLine.Type = ServLine.Type::Item THEN
            DummyTrackingSpecification.CheckItemTrackingQuantity(
              DATABASE::"Service Line",ServLine."Document Type",ServLine."Document No.",ServLine."Line No.",
              ServLine."Qty. to Ship (Base)",ServLine."Qty. to Invoice (Base)",Ship,Invoice);
          LineCount += 1;
          Window.UPDATE(2,LineCount);

          WITH ServLine DO BEGIN
            IF Ship AND ("Qty. to Ship" <> 0) OR Invoice AND ("Qty. to Invoice" <> 0) THEN
              ServOrderMgt.CheckServItemRepairStatus(ServHeader,ServItemLine,ServLine);

            ServLineOld := ServLine;
            IF "Spare Part Action" IN
               ["Spare Part Action"::"Component Replaced",
                "Spare Part Action"::Permanent,
                "Spare Part Action"::"Temporary"]
            THEN BEGIN
              "Spare Part Action" := "Spare Part Action"::"Component Installed";
              MODIFY
            END;

            // post Service Ledger Entry of type Usage, on shipment
            IF (Ship AND ("Document Type" = "Document Type"::Order) OR
                ("Document Type" = "Document Type"::Invoice)) AND
               ("Qty. to Ship" <> 0) AND NOT ServAmountsMgt.RoundingLineInserted
            THEN BEGIN
              TempServLine := ServLine;
              ServPostingJnlsMgt.CalcSLEDivideAmount("Qty. to Ship",ServHeader,TempServLine,TempVATAmountLineForSLE);

              ApplToServEntryNo :=
                ServPostingJnlsMgt.InsertServLedgerEntry(NextServLedgerEntryNo,
                  ServHeader,TempServLine,ServItemLine,"Qty. to Ship",ServHeader."Shipping No.");

              IF "Appl.-to Service Entry" = 0 THEN
                "Appl.-to Service Entry" := ApplToServEntryNo;
            END;

            IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
              GetItem(ServLine,Item);
              IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT IsShipment THEN
                GetUnitCost;
            END;

            IF CheckCloseCondition(
                 Quantity,"Qty. to Invoice","Qty. to Consume","Quantity Invoiced","Quantity Consumed") = FALSE
            THEN
              CloseCondition := FALSE;

            IF Quantity = 0 THEN
              TESTFIELD("Line Amount",0)
            ELSE BEGIN
              TestBinCode;
              TESTFIELD("No.");
              TESTFIELD(Type);
              TESTFIELD("Gen. Bus. Posting Group");
              TESTFIELD("Gen. Prod. Posting Group");
              ServAmountsMgt.DivideAmount(1,"Qty. to Invoice",ServHeader,ServLine,
                TempVATAmountLine,TempVATAmountLineRemainder);
            END;

            ServAmountsMgt.RoundAmount("Qty. to Invoice",ServHeader,ServLine,
              TempServiceLine,TotalServiceLine,TotalServiceLineLCY,ServiceLineACY);

            IF "Document Type" <> "Document Type"::"Credit Memo" THEN BEGIN
              ServAmountsMgt.ReverseAmount(ServLine);
              ServAmountsMgt.ReverseAmount(ServiceLineACY);
            END;

            // post Service Ledger Entry of type Sale, on invoice
            IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
              CheckIfServDuplicateLine(ServLine);
              ServPostingJnlsMgt.CreateCreditEntry(NextServLedgerEntryNo,
                ServHeader,ServLine,GenJnlLineDocNo);
            END ELSE
              IF (Invoice OR ("Document Type" = "Document Type"::Invoice)) AND
                 ("Qty. to Invoice" <> 0) AND NOT ServAmountsMgt.RoundingLineInserted
              THEN BEGIN
                CheckIfServDuplicateLine(ServLine);
                ServPostingJnlsMgt.InsertServLedgerEntrySale(NextServLedgerEntryNo,
                  ServHeader,ServLine,ServItemLine,"Qty. to Invoice","Qty. to Invoice",GenJnlLineDocNo,"Line No.");
              END;

            IF Consume AND ("Document Type" = "Document Type"::Order) AND
               ("Qty. to Consume" <> 0)
            THEN
              ServPostingJnlsMgt.InsertServLedgerEntrySale(NextServLedgerEntryNo,
                ServHeader,ServLine,ServItemLine,"Qty. to Consume",0,ServHeader."Shipping No.","Line No.");

            RemQtyToBeInvoiced := "Qty. to Invoice";
            RemQtyToBeConsumed := "Qty. to Consume";
            RemQtyToBeInvoicedBase := "Qty. to Invoice (Base)";
            RemQtyToBeConsumedBase := "Qty. to Consume (Base)";

            IF Invoice THEN
              IF "Qty. to Invoice" = 0 THEN
                TrackingSpecificationExists := FALSE
              ELSE
                TrackingSpecificationExists :=
                  ServITRMgt.RetrieveInvoiceSpecification(ServLine,TempInvoicingSpecification,FALSE);

            IF Consume THEN
              IF "Qty. to Consume" = 0 THEN
                TrackingSpecificationExists := FALSE
              ELSE
                TrackingSpecificationExists :=
                  ServITRMgt.RetrieveInvoiceSpecification(ServLine,TempInvoicingSpecification,TRUE);

            // update previously shipped lines with invoicing information.
            IF "Document Type" = "Document Type"::"Credit Memo" THEN
              UpdateRcptLinesOnInv
            ELSE // Order or Invoice
              UpdateShptLinesOnInv(ServLine,
                RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
                RemQtyToBeConsumed,RemQtyToBeConsumedBase);

            IF TrackingSpecificationExists THEN
              ServITRMgt.SaveInvoiceSpecification(TempInvoicingSpecification,TempTrackingSpecification);

            // post service line via journals
            CASE Type OF
              Type::Item:
                BEGIN
                  IF Ship AND ("Document Type" = "Document Type"::Order) THEN BEGIN
                    TempServLine := ServLine;
                    ServPostingJnlsMgt.CalcSLEDivideAmount("Qty. to Ship",ServHeader,TempServLine,TempVATAmountLineForSLE);
                    WarrantyNo :=
                      ServPostingJnlsMgt.InsertWarrantyLedgerEntry(
                        NextWarrantyLedgerEntryNo,ServHeader,TempServLine,ServItemLine,
                        "Qty. to Ship",ServHeader."Shipping No.");
                  END;

                  IF Invoice AND (RemQtyToBeInvoiced <> 0) THEN
                    ItemLedgShptEntryNo := ServPostingJnlsMgt.PostItemJnlLine(
                        ServLine,RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
                        0,0,RemQtyToBeInvoiced,RemQtyToBeInvoicedBase,
                        0,DummyTrackingSpecification,
                        TempTrackingSpecificationInv,TempHandlingSpecification,
                        TempTrackingSpecification,
                        ServShptHeader,'');

                  IF Consume AND (RemQtyToBeConsumed <> 0) THEN
                    ItemLedgShptEntryNo := ServPostingJnlsMgt.PostItemJnlLine(
                        ServLine,RemQtyToBeConsumed,RemQtyToBeConsumedBase,
                        RemQtyToBeConsumed,RemQtyToBeConsumedBase,0,0,
                        0,DummyTrackingSpecification,
                        TempTrackingSpecificationInv,TempHandlingSpecification,
                        TempTrackingSpecification,
                        ServShptHeader,'');

                  IF NOT ("Document Type" IN ["Document Type"::"Credit Memo"]) THEN
                    IF ((ABS("Qty. to Ship") - ABS("Qty. to Consume") - ABS("Qty. to Invoice")) > ABS(RemQtyToBeConsumed)) OR
                       ((ABS("Qty. to Ship") - ABS("Qty. to Consume") - ABS("Qty. to Invoice")) > ABS(RemQtyToBeInvoiced))
                    THEN
                      ItemLedgShptEntryNo := ServPostingJnlsMgt.PostItemJnlLine(
                          ServLine,
                          "Qty. to Ship" - RemQtyToBeInvoiced - RemQtyToBeConsumed,
                          "Qty. to Ship (Base)" - RemQtyToBeInvoicedBase - RemQtyToBeConsumedBase,
                          0,0,0,0,0,DummyTrackingSpecification,TempTrackingSpecificationInv,
                          TempHandlingSpecification,TempTrackingSpecification,ServShptHeader,'');
                END;// type:Item
              Type::Resource:
                BEGIN
                  TempServLine := ServLine;
                  ServPostingJnlsMgt.CalcSLEDivideAmount("Qty. to Ship",ServHeader,TempServLine,TempVATAmountLineForSLE);

                  IF Ship AND ("Document Type" = "Document Type"::Order) THEN
                    WarrantyNo := ServPostingJnlsMgt.InsertWarrantyLedgerEntry(NextWarrantyLedgerEntryNo,
                        ServHeader,TempServLine,ServItemLine,"Qty. to Ship",ServHeader."Shipping No.");

                  IF "Document Type" = "Document Type"::"Credit Memo" THEN
                    ServPostingJnlsMgt.PostResJnlLineUndoUsage(ServLine,GenJnlLineDocNo,GenJnlLineExtDocNo)
                  ELSE
                    PostResourceUsage(TempServLine);

                  IF "Qty. to Invoice" <> 0 THEN
                    ServPostingJnlsMgt.PostResJnlLineSale(ServLine,GenJnlLineDocNo,GenJnlLineExtDocNo);
                END;
            END; // Case Type

            IF Consume AND ("Document Type" = "Document Type"::Order) THEN BEGIN
              IF ServPostingJnlsMgt.PostJobJnlLine(ServHeader,ServLine,RemQtyToBeConsumed) THEN
                UpdateServiceLedgerEntry(NextServLedgerEntryNo - 1)
              ELSE
                IF (Type = Type::Resource) AND (RemQtyToBeConsumed <> 0) THEN
                  ServPostingJnlsMgt.PostResJnlLineConsume(ServLine,ServShptHeader);
            END;

            IF Ship AND ("Document Type" = "Document Type"::Order) THEN BEGIN
              // component spare part action
              ServItemMgt.AddOrReplaceSIComponent(ServLineOld,ServHeader,
                ServHeader."Shipping No.",ServLineOld."Line No.",TempTrackingSpecification);
              // allocations
              ServAllocMgt.SetServLineAllocStatus(TempServiceLine);
            END;

            IF (Type <> Type::" ") AND ("Qty. to Invoice" <> 0) THEN
              // Copy sales to buffer
              ServAmountsMgt.FillInvPostingBuffer(InvPostingBuffer,ServLine,ServiceLineACY,ServHeader);

            // prepare posted document lines
            IF Ship THEN
              PrepareShipmentLine(TempServiceLine,WarrantyNo);
            IF Invoice THEN
              IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
                PrepareInvoiceLine(TempServiceLine)
              ELSE
                PrepareCrMemoLine(TempServiceLine);

            IF Invoice OR Consume THEN
              CollectValueEntryRelation;

            IF ServAmountsMgt.RoundingLineInserted THEN
              LastLineRetrieved := TRUE
            ELSE BEGIN
              BiggestLineNo := ServAmountsMgt.MAX(ServAmountsMgt.GetLastLineNo(ServLine),"Line No.");
              LastLineRetrieved := NEXT = 0; // ServLine
              IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
                ServAmountsMgt.InvoiceRounding(ServHeader,ServLine,TotalServiceLine,
                  LastLineRetrieved,FALSE,BiggestLineNo);
            END;
          END; // With ServLine
        UNTIL LastLineRetrieved;

      WITH ServHeader DO BEGIN
        // again reverse amount
        IF "Document Type" <> "Document Type"::"Credit Memo" THEN BEGIN
          ServAmountsMgt.ReverseAmount(TotalServiceLine);
          ServAmountsMgt.ReverseAmount(TotalServiceLineLCY);
          TotalServiceLineLCY."Unit Cost (LCY)" := -TotalServiceLineLCY."Unit Cost (LCY)";
        END;

        ServPostingJnlsMgt.FinishServiceRegister(NextServLedgerEntryNo,NextWarrantyLedgerEntryNo);

        IF Invoice OR ("Document Type" = "Document Type"::Invoice) THEN BEGIN
          CLEAR(ServDocReg);
          // fake service register entry to be used in the following PostServSalesDocument()
          IF Invoice AND ("Document Type" = "Document Type"::Order) AND (ServLine."Contract No." <> '') THEN
            ServDocReg.InsertServSalesDocument(
              ServDocReg."Source Document Type"::Contract,ServLine."Contract No.",
              ServDocReg."Destination Document Type"::Invoice,ServLine."Document No.");
          ServDocReg.PostServSalesDocument(
            ServDocReg."Destination Document Type"::Invoice,
            ServLine."Document No.",ServInvHeader."No.");
        END;
        IF Invoice OR ("Document Type" = "Document Type"::"Credit Memo") THEN BEGIN
          CLEAR(ServDocReg);
          ServDocReg.PostServSalesDocument(
            ServDocReg."Destination Document Type"::"Credit Memo",
            ServLine."Document No.",
            ServCrMemoHeader."No.");
        END;

        // Post sales and VAT to G/L entries from posting buffer
        IF Invoice THEN BEGIN
          LineCount := 0;
          IF InvPostingBuffer[1].FIND('+') THEN
            REPEAT
              LineCount += 1;
              Window.UPDATE(3,LineCount);
              ServPostingJnlsMgt.SetPostingDate("Posting Date");
              ServPostingJnlsMgt.PostInvoicePostBufferLine(
                InvPostingBuffer[1],GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo);
            UNTIL InvPostingBuffer[1].NEXT(-1) = 0;

          // Post customer entry
          Window.UPDATE(4,1);
          ServPostingJnlsMgt.SetPostingDate("Posting Date");
          ServPostingJnlsMgt.PostCustomerEntry(
            TotalServiceLine,TotalServiceLineLCY,
            GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo);

          // post Balancing account
          IF "Bal. Account No." <> '' THEN BEGIN
            Window.UPDATE(5,1);
            ServPostingJnlsMgt.SetPostingDate("Posting Date");
            ServPostingJnlsMgt.PostBalancingEntry(
              TotalServiceLine,TotalServiceLineLCY,
              GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo);
          END;
        END; // end posting sales,receivables,balancing

        MakeInvtAdjustment;
        IF Ship THEN BEGIN
          "Last Shipping No." := "Shipping No.";
          "Shipping No." := '';
        END;

        IF Invoice THEN BEGIN
          "Last Posting No." := "Posting No.";
          "Posting No." := '';
        END;

        MODIFY;
      END;// with header
    END;

    LOCAL PROCEDURE MakeInvtAdjustment@46();
    VAR
      InvtSetup@1001 : Record 313;
      InvtAdjmt@1002 : Codeunit 5895;
    BEGIN
      InvtSetup.GET;
      IF InvtSetup."Automatic Cost Adjustment" <>
         InvtSetup."Automatic Cost Adjustment"::Never
      THEN BEGIN
        InvtAdjmt.SetProperties(TRUE,InvtSetup."Automatic Cost Posting");
        InvtAdjmt.MakeMultiLevelAdjmt;
      END;
    END;

    [Internal]
    PROCEDURE UpdateDocumentLines@17();
    BEGIN
      WITH ServHeader DO BEGIN
        MODIFY;
        IF ("Document Type" = "Document Type"::Order) AND NOT CloseCondition THEN BEGIN
          ServITRMgt.InsertTrackingSpecification(ServHeader,TempTrackingSpecification);

          // update service line quantities according to posted values
          UpdateServLinesOnPostOrder;
        END ELSE BEGIN
          // close condition met for order, or we post Invoice or CrMemo

          IF ServLinesPassed THEN
            UpdateServLinesOnPostOrder;

          CASE "Document Type" OF
            "Document Type"::Invoice:
              UpdateServLinesOnPostInvoice;
            "Document Type"::"Credit Memo":
              UpdateServLinesOnPostCrMemo;
          END;// case

          ServAllocMgt.SetServOrderAllocStatus(ServHeader);
        END; // End CloseConditionMet
      END;
    END;

    LOCAL PROCEDURE PrepareDocument@8(VAR PassedServHeader@1000 : Record 5900;VAR PassedServLine@1003 : Record 5902);
    BEGIN
      // fill ServiceHeader we will work with (tempTable)
      ServHeader.DELETEALL;
      ServHeader.COPY(PassedServHeader);
      ServHeader.INSERT; // temporary table

      // Fetch persistent Service Lines and Service Item Lines bound to Service Header.
      // Copy persistent records to temporary.
      WITH ServHeader DO BEGIN
        ServLine.DELETEALL;
        PassedServLine.RESET;

        // collect passed lines
        IF PassedServLine.FIND('-') THEN BEGIN
          REPEAT
            ServLine.COPY(PassedServLine);
            ServLine.INSERT; // temptable
          UNTIL PassedServLine.NEXT = 0;
          ServLinesPassed := TRUE; // indicate either we collect passed or all SLs.
        END ELSE BEGIN
          // collect persistent lines related to ServHeader
          PServLine.RESET;
          PServLine.SETRANGE("Document Type","Document Type");
          PServLine.SETRANGE("Document No.","No.");
          IF PServLine.FIND('-') THEN
            REPEAT
              ServLine.COPY(PServLine);
              ServLine."Posting Date" := "Posting Date";
              ServLine.INSERT; // temptable
            UNTIL PServLine.NEXT = 0;
          ServLinesPassed := FALSE;
        END;

        RemoveLinesNotSatisfyPosting;

        ServItemLine.DELETEALL;
        PServItemLine.RESET;
        PServItemLine.SETRANGE("Document Type","Document Type");
        PServItemLine.SETRANGE("Document No.","No.");
        IF PServItemLine.FIND('-') THEN
          REPEAT
            ServItemLine.COPY(PServItemLine);
            ServItemLine.INSERT; // temptable
          UNTIL PServItemLine.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE PrepareShipmentHeader@11();
    VAR
      ServLine@1003 : Record 5902;
      PServShptHeader@1001 : Record 5990;
      PServShptLine@1000 : Record 5991;
      ServItemMgt@1002 : Codeunit 5920;
      RecordLinkManagement@1004 : Codeunit 447;
    BEGIN
      WITH ServHeader DO BEGIN
        IF ("Document Type" = "Document Type"::Order) OR
           (("Document Type" = "Document Type"::Invoice) AND ServMgtSetup."Shipment on Invoice")
        THEN BEGIN
          PServShptHeader.LOCKTABLE;
          PServShptLine.LOCKTABLE;
          ServShptHeader.INIT;
          ServShptHeader.TRANSFERFIELDS(ServHeader);

          ServShptHeader."No." := "Shipping No.";
          IF "Document Type" = "Document Type"::Order THEN BEGIN
            ServShptHeader."Order No. Series" := "No. Series";
            ServShptHeader."Order No." := "No.";
          END;

          IF ServMgtSetup."Copy Comments Order to Shpt." THEN
            RecordLinkManagement.CopyLinks(ServHeader,ServShptHeader);

          ServShptHeader."Source Code" := SrcCode;
          ServShptHeader."User ID" := USERID;
          ServShptHeader."No. Printed" := 0;
          ServShptHeader.INSERT;

          CLEAR(ServLogMgt);
          ServLogMgt.ServOrderShipmentPost("No.",ServShptHeader."No.");

          IF ("Document Type" = "Document Type"::Order) AND ServMgtSetup."Copy Comments Order to Shpt." THEN
            ServOrderMgt.CopyCommentLines(
              DummyServCommentLine."Table Name"::"Service Header",
              DummyServCommentLine."Table Name"::"Service Shipment Header",
              "No.",ServShptHeader."No.");

          // create Service Shipment Item Lines
          ServItemLine.RESET;
          IF ServItemLine.FIND('-') THEN
            REPEAT
              // create SSIL
              ServShptItemLine.TRANSFERFIELDS(ServItemLine);
              ServShptItemLine."No." := ServShptHeader."No.";
              ServShptItemLine.INSERT;

              // set mgt. date and service dates
              IF (ServItemLine."Contract No." <> '') AND (ServItemLine."Contract Line No." <> 0) AND
                 ("Contract No." <> '')
              THEN BEGIN
                ServLine.SETRANGE("Document Type","Document Type");
                ServLine.SETRANGE("Document No.","No.");
                ServLine.SETFILTER("Quantity Shipped",'>%1',0);
                IF NOT ServLine.FINDFIRST THEN
                  ServOrderMgt.CalcContractDates(ServHeader,ServItemLine);
              END;
              ServOrderMgt.CalcServItemDates(ServHeader,ServItemLine."Service Item No.");
            UNTIL ServItemLine.NEXT = 0
          ELSE BEGIN
            ServShptItemLine.INIT;
            ServShptItemLine."No." := ServShptHeader."No.";
            ServShptItemLine."Line No." := 10000;
            ServShptItemLine.Description := FORMAT("Document Type") + ' ' + "No.";
            ServShptItemLine.INSERT;
          END;
        END;

        ServItemMgt.CopyReservationEntryService(ServHeader);
      END;
    END;

    LOCAL PROCEDURE PrepareShipmentLine@22(VAR passedServLine@1000 : Record 5902;passedWarrantyNo@1001 : Integer);
    VAR
      WarrantyLedgerEntry@1002 : Record 5908;
    BEGIN
      WITH passedServLine DO BEGIN
        IF (ServShptHeader."No." <> '') AND ("Shipment No." = '') AND NOT ServAmountsMgt.RoundingLineInserted
        THEN BEGIN
          // Insert shipment line
          ServShptLine.INIT;
          ServShptLine.TRANSFERFIELDS(passedServLine);
          ServShptLine."Document No." := ServShptHeader."No.";
          ServShptLine.Quantity := "Qty. to Ship";
          ServShptLine."Quantity (Base)" := "Qty. to Ship (Base)";
          ServShptLine."Appl.-to Warranty Entry" := passedWarrantyNo;

          IF ABS("Qty. to Consume") > ABS("Qty. to Ship" - "Qty. to Invoice")
          THEN BEGIN
            ServShptLine."Quantity Consumed" := "Qty. to Ship" - "Qty. to Invoice";
            ServShptLine."Qty. Consumed (Base)" := "Qty. to Ship (Base)" - "Qty. to Invoice (Base)";
          END ELSE BEGIN
            ServShptLine."Quantity Consumed" := "Qty. to Consume";
            ServShptLine."Qty. Consumed (Base)" := "Qty. to Consume (Base)";
          END;

          IF ABS("Qty. to Invoice") > ABS("Qty. to Ship" - "Qty. to Consume")
          THEN BEGIN
            ServShptLine."Quantity Invoiced" := "Qty. to Ship" - "Qty. to Consume";
            ServShptLine."Qty. Invoiced (Base)" := "Qty. to Ship (Base)" - "Qty. to Consume (Base)";
          END ELSE BEGIN
            ServShptLine."Quantity Invoiced" := "Qty. to Invoice";
            ServShptLine."Qty. Invoiced (Base)" := "Qty. to Invoice (Base)";
          END;

          ServShptLine."Qty. Shipped Not Invoiced" := ServShptLine.Quantity -
            ServShptLine."Quantity Invoiced" - ServShptLine."Quantity Consumed";
          ServShptLine."Qty. Shipped Not Invd. (Base)" := ServShptLine."Quantity (Base)" -
            ServShptLine."Qty. Invoiced (Base)" - ServShptLine."Qty. Consumed (Base)";
          IF "Document Type" = "Document Type"::Order THEN BEGIN
            ServShptLine."Order No." := "Document No.";
            ServShptLine."Order Line No." := "Line No.";
          END;

          IF (Type = Type::Item) AND ("Qty. to Ship" <> 0) THEN
            ServShptLine."Item Shpt. Entry No." :=
              ServITRMgt.InsertShptEntryRelation(ServShptLine,
                TempHandlingSpecification,TempTrackingSpecificationInv,ItemLedgShptEntryNo);

          CALCFIELDS("Service Item Line Description");
          ServShptLine."Service Item Line Description" := "Service Item Line Description";

          ServShptLine.INSERT;
          CheckCertificateOfSupplyStatus(ServShptHeader,ServShptLine);
        END;
        // end inserting Service Shipment Line

        IF Invoice AND Ship THEN BEGIN
          WarrantyLedgerEntry.RESET;
          WarrantyLedgerEntry.SETCURRENTKEY("Service Order No.","Posting Date","Document No.");
          WarrantyLedgerEntry.SETRANGE("Service Order No.",ServShptLine."Order No.");
          WarrantyLedgerEntry.SETRANGE("Document No.",ServShptLine."Document No.");
          WarrantyLedgerEntry.SETRANGE(Type,ServShptLine.Type);
          WarrantyLedgerEntry.SETRANGE("No.",ServShptLine."No.");
          WarrantyLedgerEntry.SETRANGE(Open,TRUE);
          WarrantyLedgerEntry.MODIFYALL(Open,FALSE);
        END;
      END;
    END;

    [External]
    PROCEDURE PrepareInvoiceHeader@12(VAR Window@1001 : Dialog);
    VAR
      RecordLinkManagement@1000 : Codeunit 447;
    BEGIN
      WITH ServHeader DO BEGIN
        ServInvHeader.INIT;
        ServInvHeader.TRANSFERFIELDS(ServHeader);

        IF "Document Type" = "Document Type"::Order THEN BEGIN
          ServInvHeader."No." := "Posting No.";
          ServInvHeader."Pre-Assigned No. Series" := '';
          ServInvHeader."Order No. Series" := "No. Series";
          ServInvHeader."Order No." := "No.";
          Window.UPDATE(1,STRSUBSTNO(Text007,"Document Type","No.",ServInvHeader."No."));
        END ELSE BEGIN
          ServInvHeader."Pre-Assigned No. Series" := "No. Series";
          ServInvHeader."Pre-Assigned No." := "No.";
          IF "Posting No." <> '' THEN BEGIN
            ServInvHeader."No." := "Posting No.";
            Window.UPDATE(1,STRSUBSTNO(Text007,"Document Type","No.",ServInvHeader."No."));
          END;
        END;

        IF ServMgtSetup."Copy Comments Order to Invoice" THEN
          RecordLinkManagement.CopyLinks(ServHeader,ServInvHeader);

        ServInvHeader."Source Code" := SrcCode;
        ServInvHeader."User ID" := USERID;
        ServInvHeader."No. Printed" := 0;
        ServInvHeader.INSERT;

        CLEAR(ServLogMgt);
        CASE "Document Type" OF
          "Document Type"::Invoice:
            ServLogMgt.ServInvoicePost("No.",ServInvHeader."No.");
          "Document Type"::Order:
            ServLogMgt.ServOrderInvoicePost("No.",ServInvHeader."No.");
        END;

        SetGenJnlLineDocNos(2,// Invoice
          ServInvHeader."No.","No.");

        IF ("Document Type" = "Document Type"::Invoice) OR
           ("Document Type" = "Document Type"::Order) AND ServMgtSetup."Copy Comments Order to Invoice"
        THEN
          ServOrderMgt.CopyCommentLinesWithSubType(
            DummyServCommentLine."Table Name"::"Service Header",
            DummyServCommentLine."Table Name"::"Service Invoice Header",
            "No.",ServInvHeader."No.","Document Type");
      END;
    END;

    LOCAL PROCEDURE PrepareInvoiceLine@35(VAR passedServLine@1000 : Record 5902);
    BEGIN
      WITH passedServLine DO BEGIN
        ServInvLine.INIT;
        ServInvLine.TRANSFERFIELDS(passedServLine);
        ServInvLine."Document No." := ServInvHeader."No.";
        ServInvLine.Quantity := "Qty. to Invoice";
        ServInvLine."Quantity (Base)" := "Qty. to Invoice (Base)";

        CALCFIELDS("Service Item Line Description");
        ServInvLine."Service Item Line Description" := "Service Item Line Description";
        ServInvLine.INSERT;
      END;
    END;

    [External]
    PROCEDURE PrepareCrMemoHeader@14(VAR Window@1001 : Dialog);
    VAR
      RecordLinkManagement@1000 : Codeunit 447;
    BEGIN
      WITH ServHeader DO BEGIN
        ServCrMemoHeader.INIT;
        ServCrMemoHeader.TRANSFERFIELDS(ServHeader);
        ServCrMemoHeader."Pre-Assigned No. Series" := "No. Series";
        ServCrMemoHeader."Pre-Assigned No." := "No.";
        IF "Posting No." <> '' THEN BEGIN
          ServCrMemoHeader."No." := "Posting No.";
          Window.UPDATE(1,STRSUBSTNO(Text008,"Document Type","No.",ServCrMemoHeader."No."));
        END;

        RecordLinkManagement.CopyLinks(ServHeader,ServCrMemoHeader);

        ServCrMemoHeader."Source Code" := SrcCode;
        ServCrMemoHeader."User ID" := USERID;
        ServCrMemoHeader."No. Printed" := 0;
        ServCrMemoHeader.INSERT;

        CLEAR(ServLogMgt);
        ServLogMgt.ServCrMemoPost("No.",ServCrMemoHeader."No.");

        SetGenJnlLineDocNos(3,// Credit Memo
          ServCrMemoHeader."No.","No.");

        ServOrderMgt.CopyCommentLines(
          DummyServCommentLine."Table Name"::"Service Header",
          DummyServCommentLine."Table Name"::"Service Cr.Memo Header",
          "No.",ServCrMemoHeader."No.");
      END;
    END;

    LOCAL PROCEDURE PrepareCrMemoLine@36(VAR passedServLine@1001 : Record 5902);
    BEGIN
      WITH passedServLine DO BEGIN
        // TempSrvLine is initialized (in Sales module) in RoundAmount
        // procedure, and likely does not differ from initial ServLine.

        ServCrMemoLine.INIT;
        ServCrMemoLine.TRANSFERFIELDS(passedServLine);
        ServCrMemoLine."Document No." := ServCrMemoHeader."No.";
        ServCrMemoLine.Quantity := "Qty. to Invoice";
        ServCrMemoLine."Quantity (Base)" := "Qty. to Invoice (Base)";
        CALCFIELDS("Service Item Line Description");
        ServCrMemoLine."Service Item Line Description" := "Service Item Line Description";
        ServCrMemoLine.INSERT;
      END;
    END;

    [External]
    PROCEDURE Finalize@9(VAR PassedServHeader@1000 : Record 5900);
    BEGIN
      // finalize codeunits calls
      ServPostingJnlsMgt.Finalize;

      // finalize posted documents
      FinalizeShipmentDocument;
      FinalizeInvoiceDocument;
      FinalizeCrMemoDocument;
      FinalizeWarrantyLedgerEntries(PassedServHeader,CloseCondition);

      IF ((ServHeader."Document Type" = ServHeader."Document Type"::Order) AND CloseCondition) OR
         (ServHeader."Document Type" <> ServHeader."Document Type"::Order)
      THEN BEGIN
        // Service Lines, Service Item Lines, Service Header
        FinalizeDeleteLines;
        FinalizeDeleteServOrdAllocat;
        FinalizeDeleteItemLines;
        FinalizeDeleteComments(PassedServHeader."Document Type");
        FinalizeDeleteHeader(PassedServHeader);
      END ELSE BEGIN
        // Service Lines, Service Item Lines, Service Header
        FinalizeLines;
        FinalizeItemLines;
        FinalizeHeader(PassedServHeader);
      END;
    END;

    LOCAL PROCEDURE FinalizeHeader@3(VAR PassedServHeader@1000 : Record 5900);
    BEGIN
      // finalize Service Header
      PassedServHeader.COPY(ServHeader);
      ServHeader.DELETEALL;
    END;

    LOCAL PROCEDURE FinalizeLines@4();
    BEGIN
      // copy Service Lines to persistent from temporary
      PServLine.RESET;
      ServLine.RESET;
      ServLine.SETFILTER(Quantity,'<>0');
      IF ServLine.FIND('-') THEN
        REPEAT
          WITH ServLine DO
            IF PServLine.GET("Document Type","Document No.","Line No.") THEN BEGIN
              PServLine.COPY(ServLine);
              PServLine.MODIFY;
            END ELSE
              // invoice discount lines only
              IF (Type = Type::"G/L Account") AND "System-Created Entry" THEN BEGIN
                PServLine.INIT;
                PServLine.COPY(ServLine);
                PServLine.INSERT;
              END;
        UNTIL ServLine.NEXT = 0;
      ServLine.RESET;
      ServLine.DELETEALL; // just temp records
    END;

    LOCAL PROCEDURE FinalizeItemLines@5();
    BEGIN
      // copy Service Item Lines to persistent from temporary
      ServItemLine.RESET;
      IF ServItemLine.FIND('-') THEN
        REPEAT
          WITH ServItemLine DO BEGIN
            PServItemLine.GET("Document Type","Document No.","Line No.");
            PServItemLine.COPY(ServItemLine);
            PServItemLine.MODIFY;
          END;
        UNTIL ServItemLine.NEXT = 0;
      ServItemLine.DELETEALL; // just temp records
    END;

    LOCAL PROCEDURE FinalizeDeleteHeader@32(VAR PassedServHeader@1000 : Record 5900);
    BEGIN
      WITH PassedServHeader DO BEGIN
        DELETE;
        ServITRMgt.DeleteInvoiceSpecFromHeader(ServHeader);
      END;

      ServHeader.DELETEALL;
    END;

    LOCAL PROCEDURE FinalizeDeleteLines@27();
    BEGIN
      // delete Service Lines persistent and temporary
      PServLine.RESET;
      PServLine.SETRANGE("Document Type",ServHeader."Document Type");
      PServLine.SETRANGE("Document No.",ServHeader."No.");
      PServLine.DELETEALL;

      ServLine.RESET;
      ServLine.DELETEALL;
    END;

    LOCAL PROCEDURE FinalizeDeleteItemLines@29();
    BEGIN
      // delete Service Item Lines persistent and temporary
      PServItemLine.RESET;
      PServItemLine.SETRANGE("Document Type",ServHeader."Document Type");
      PServItemLine.SETRANGE("Document No.",ServHeader."No.");
      PServItemLine.DELETEALL;

      ServItemLine.RESET;
      ServItemLine.DELETEALL;
    END;

    LOCAL PROCEDURE FinalizeShipmentDocument@43();
    VAR
      PServShptHeader@1001 : Record 5990;
      PServShptItemLine@1003 : Record 5989;
      PServShptLine@1000 : Record 5991;
    BEGIN
      ServShptHeader.RESET;
      IF ServShptHeader.FINDFIRST THEN BEGIN
        PServShptHeader.INIT;
        PServShptHeader.COPY(ServShptHeader);
        PServShptHeader.INSERT;
      END;
      ServShptHeader.DELETEALL;

      ServShptItemLine.RESET;
      IF ServShptItemLine.FIND('-') THEN
        REPEAT
          PServShptItemLine.INIT;
          PServShptItemLine.COPY(ServShptItemLine);
          PServShptItemLine.INSERT;
        UNTIL ServShptItemLine.NEXT = 0;
      ServShptItemLine.DELETEALL;

      ServShptLine.RESET;
      IF ServShptLine.FIND('-') THEN
        REPEAT
          PServShptLine.INIT;
          PServShptLine.COPY(ServShptLine);
          PServShptLine.INSERT;
        UNTIL ServShptLine.NEXT = 0;
      ServShptLine.DELETEALL;
    END;

    LOCAL PROCEDURE FinalizeInvoiceDocument@42();
    VAR
      PServInvHeader@1000 : Record 5992;
      PServInvLine@1001 : Record 5993;
    BEGIN
      ServInvHeader.RESET;
      IF ServInvHeader.FINDFIRST THEN BEGIN
        PServInvHeader.INIT;
        PServInvHeader.COPY(ServInvHeader);
        PServInvHeader.INSERT;
      END;
      ServInvHeader.DELETEALL;

      ServInvLine.RESET;
      IF ServInvLine.FIND('-') THEN
        REPEAT
          PServInvLine.INIT;
          PServInvLine.COPY(ServInvLine);
          PServInvLine.INSERT;
        UNTIL ServInvLine.NEXT = 0;
      ServInvLine.DELETEALL;
    END;

    LOCAL PROCEDURE FinalizeCrMemoDocument@41();
    VAR
      PServCrMemoHeader@1000 : Record 5994;
      PServCrMemoLine@1001 : Record 5995;
    BEGIN
      ServCrMemoHeader.RESET;
      IF ServCrMemoHeader.FINDFIRST THEN BEGIN
        PServCrMemoHeader.INIT;
        PServCrMemoHeader.COPY(ServCrMemoHeader);
        PServCrMemoHeader.INSERT;
      END;
      ServCrMemoHeader.DELETEALL;

      ServCrMemoLine.RESET;
      IF ServCrMemoLine.FIND('-') THEN
        REPEAT
          PServCrMemoLine.INIT;
          PServCrMemoLine.COPY(ServCrMemoLine);
          PServCrMemoLine.INSERT;
        UNTIL ServCrMemoLine.NEXT = 0;
      ServCrMemoLine.DELETEALL;
    END;

    LOCAL PROCEDURE GetAndCheckCustomer@6();
    VAR
      Cust@1000 : Record 18;
    BEGIN
      WITH ServHeader DO BEGIN
        Cust.GET("Customer No.");

        IF Ship OR ServMgtSetup."Shipment on Invoice" AND
           ("Document Type" = "Document Type"::Invoice)
        THEN BEGIN
          ServLine.RESET;
          ServLine.SETRANGE("Document Type","Document Type");
          ServLine.SETRANGE("Document No.","No.");
          ServLine.SETFILTER("Qty. to Ship",'<>0');
          ServLine.SETRANGE("Shipment No.",'');
          IF NOT ServLine.ISEMPTY THEN
            Cust.CheckBlockedCustOnDocs(Cust,"Document Type",TRUE,TRUE);
        END ELSE
          Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,TRUE);

        IF "Bill-to Customer No." <> "Customer No." THEN BEGIN
          Cust.GET("Bill-to Customer No.");
          IF Ship OR ServMgtSetup."Shipment on Invoice" AND
             ("Document Type" = "Document Type"::Invoice)
          THEN BEGIN
            ServLine.RESET;
            ServLine.SETRANGE("Document Type","Document Type");
            ServLine.SETRANGE("Document No.","No.");
            ServLine.SETFILTER("Qty. to Ship",'<>0');
            IF NOT ServLine.ISEMPTY THEN
              Cust.CheckBlockedCustOnDocs(Cust,"Document Type",TRUE,TRUE);
          END ELSE
            Cust.CheckBlockedCustOnDocs(Cust,"Document Type",FALSE,TRUE);
        END;
        ServLine.RESET;
      END;
    END;

    LOCAL PROCEDURE GetItem@49(ServLine@1000 : Record 5902;VAR Item@1001 : Record 27);
    BEGIN
      WITH ServLine DO BEGIN
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        IF "No." <> Item."No." THEN
          Item.GET("No.");
      END;
    END;

    LOCAL PROCEDURE CheckDim@34();
    VAR
      ServiceLine2@1001 : Record 5902;
    BEGIN
      ServiceLine2."Line No." := 0;
      CheckDimComb(ServiceLine2);
      CheckDimValuePosting(ServiceLine2);

      ServLine.SETFILTER(Type,'<>%1',ServLine.Type::" ");
      IF ServLine.FIND('-') THEN
        REPEAT
          IF (Invoice AND (ServLine."Qty. to Invoice" <> 0)) OR
             (Ship AND (ServLine."Qty. to Ship" <> 0))
          THEN BEGIN
            CheckDimComb(ServLine);
            CheckDimValuePosting(ServLine);
          END;
        UNTIL ServLine.NEXT = 0;
      ServLine.RESET;
    END;

    LOCAL PROCEDURE CollectValueEntryRelation@25();
    BEGIN
      WITH ServHeader DO BEGIN
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice] THEN
          ServPostingJnlsMgt.CollectValueEntryRelation(TempValueEntryRelation,ServInvLine.RowID1)
        ELSE
          ServPostingJnlsMgt.CollectValueEntryRelation(TempValueEntryRelation,ServCrMemoLine.RowID1);
      END;
    END;

    [External]
    PROCEDURE InsertValueEntryRelation@24();
    BEGIN
      ServITRMgt.InsertValueEntryRelation(TempValueEntryRelation);
    END;

    LOCAL PROCEDURE CheckIfServDuplicateLine@44(VAR CurrentServLine@1000 : Record 5902);
    VAR
      ServLine2@1002 : Record 5902;
      ServLedgEntry@1003 : Record 5907;
    BEGIN
      IF CurrentServLine."Appl.-to Service Entry" = 0 THEN
        EXIT;
      ServLine2.RESET;
      ServLine2.SETRANGE("Document Type",CurrentServLine."Document Type");
      ServLine2.SETRANGE("Document No.",CurrentServLine."Document No.");
      ServLine2.SETFILTER("Line No.",'<>%1',CurrentServLine."Line No.");
      ServLine2.SETRANGE("Appl.-to Service Entry",CurrentServLine."Appl.-to Service Entry");
      IF ServLine2.FINDFIRST THEN
        ERROR(
          Text035,ServLine2.FIELDCAPTION("Line No."),
          ServLine2."Line No.",ServLedgEntry.TABLECAPTION,CurrentServLine."Line No.");

      IF CurrentServLine."Document Type" = CurrentServLine."Document Type"::Invoice THEN
        IF ServLedgEntry.GET(CurrentServLine."Appl.-to Service Entry") AND
           (ServLedgEntry.Open = FALSE) AND
           ((ServLedgEntry."Document Type" = ServLedgEntry."Document Type"::Invoice) OR
            (ServLedgEntry."Document Type" = ServLedgEntry."Document Type"::"Credit Memo"))
        THEN
          ERROR(
            Text039,ServLine2.FIELDCAPTION("Line No."),CurrentServLine."Line No.",
            FORMAT(ServLine2."Document Type"),ServHeader."No.",
            ServLedgEntry.TABLECAPTION);

      IF (CurrentServLine."Contract No." <> '') AND
         (CurrentServLine."Shipment No." = '') AND
         (CurrentServLine."Document Type" <> CurrentServLine."Document Type"::Order)
      THEN BEGIN
        ServLedgEntry.RESET;
        ServLedgEntry.SETCURRENTKEY("Service Contract No.");
        ServLedgEntry.SETRANGE("Service Contract No.",CurrentServLine."Contract No.");
        ServLedgEntry.SETRANGE("Service Order No.",'');
        ServLedgEntry.SETRANGE(Open,TRUE);
        ServLedgEntry.SETFILTER("Entry No.",'<%1',ServLedgEntryNo);
        IF NOT ServLedgEntry.ISEMPTY AND (ServHeader."Contract No." <> '') THEN
          ERROR(Text041,ServLedgEntry.FIELDCAPTION(Open),CurrentServLine."Contract No.");
      END;
    END;

    LOCAL PROCEDURE FindFirstServLedgEntry@20(VAR TempServiceLine@1000 : TEMPORARY Record 5902) : Integer;
    VAR
      ApplServLedgEntryNo@1001 : Integer;
    BEGIN
      IF NOT TempServiceLine.FIND('-') THEN
        EXIT(0);
      ApplServLedgEntryNo := 0;
      WITH TempServiceLine DO
        REPEAT
          IF "Appl.-to Service Entry" <> 0 THEN
            IF ApplServLedgEntryNo = 0 THEN
              ApplServLedgEntryNo := "Appl.-to Service Entry"
            ELSE
              IF "Appl.-to Service Entry" < ApplServLedgEntryNo THEN
                ApplServLedgEntryNo := "Appl.-to Service Entry";
        UNTIL NEXT = 0;
      EXIT(ApplServLedgEntryNo);
    END;

    LOCAL PROCEDURE CheckDimComb@30(ServiceLine@1000 : Record 5902);
    BEGIN
      IF ServiceLine."Line No." = 0 THEN
        IF NOT DimMgt.CheckDimIDComb(ServHeader."Dimension Set ID") THEN
          ERROR(Text028,
            ServHeader."Document Type",ServHeader."No.",DimMgt.GetDimCombErr);

      IF ServiceLine."Line No." <> 0 THEN
        IF NOT DimMgt.CheckDimIDComb(ServiceLine."Dimension Set ID") THEN
          ERROR(Text029,
            ServHeader."Document Type",ServHeader."No.",ServiceLine."Line No.",DimMgt.GetDimCombErr);
    END;

    LOCAL PROCEDURE CheckDimValuePosting@28(VAR ServiceLine2@1000 : Record 5902);
    VAR
      TableIDArr@1002 : ARRAY [10] OF Integer;
      NumberArr@1003 : ARRAY [10] OF Code[20];
    BEGIN
      IF ServiceLine2."Line No." = 0 THEN BEGIN
        TableIDArr[1] := DATABASE::Customer;
        NumberArr[1] := ServHeader."Bill-to Customer No.";
        TableIDArr[2] := DATABASE::"Salesperson/Purchaser";
        NumberArr[2] := ServHeader."Salesperson Code";
        TableIDArr[3] := DATABASE::"Responsibility Center";
        NumberArr[3] := ServHeader."Responsibility Center";
        TableIDArr[4] := DATABASE::"Service Order Type";
        NumberArr[4] := ServHeader."Service Order Type";

        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,ServHeader."Dimension Set ID") THEN
          ERROR(
            Text030,
            ServHeader."Document Type",ServHeader."No.",DimMgt.GetDimValuePostingErr);
      END ELSE BEGIN
        TableIDArr[1] := DimMgt.TypeToTableID5(ServiceLine2.Type);
        NumberArr[1] := ServiceLine2."No.";
        TableIDArr[2] := DATABASE::Job;
        NumberArr[2] := ServiceLine2."Job No.";

        TableIDArr[3] := DATABASE::"Responsibility Center";
        NumberArr[3] := ServiceLine2."Responsibility Center";

        IF ServiceLine2."Service Item Line No." <> 0 THEN BEGIN
          ServItemLine.RESET;
          ServItemLine.SETRANGE("Document Type",ServiceLine2."Document Type");
          ServItemLine.SETRANGE("Document No.",ServiceLine2."Document No.");
          ServItemLine.SETRANGE("Line No.",ServiceLine2."Service Item Line No.");
          IF ServItemLine.FIND('-') THEN BEGIN
            TableIDArr[4] := DATABASE::"Service Item";
            NumberArr[4] := ServItemLine."Service Item No.";
            TableIDArr[5] := DATABASE::"Service Item Group";
            NumberArr[5] := ServItemLine."Service Item Group Code";
          END;
          ServItemLine.RESET;
        END;

        IF NOT DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,ServiceLine2."Dimension Set ID") THEN
          ERROR(Text031,
            ServHeader."Document Type",ServHeader."No.",ServiceLine2."Line No.",DimMgt.GetDimValuePostingErr);
      END;
    END;

    [External]
    PROCEDURE CheckAndSetPostingConstants@2(VAR PassedShip@1000 : Boolean;VAR PassedConsume@1001 : Boolean;VAR PassedInvoice@1002 : Boolean);
    BEGIN
      WITH ServHeader DO BEGIN
        IF PassedConsume THEN BEGIN
          ServLine.RESET;
          ServLine.SETFILTER(Quantity,'<>0');
          IF "Document Type" = "Document Type"::Order THEN
            ServLine.SETFILTER("Qty. to Consume",'<>0');
          PassedConsume := ServLine.FIND('-');
          IF PassedConsume AND ("Document Type" = "Document Type"::Order) AND NOT PassedShip THEN BEGIN
            PassedConsume := FALSE;
            REPEAT
              PassedConsume :=
                (ServLine."Quantity Shipped" - ServLine."Quantity Invoiced" - ServLine."Quantity Consumed" <> 0);
            UNTIL PassedConsume OR (ServLine.NEXT = 0);
          END;
        END;
        IF PassedInvoice THEN BEGIN
          ServLine.RESET;
          ServLine.SETFILTER(Quantity,'<>0');
          IF "Document Type" = "Document Type"::Order THEN
            ServLine.SETFILTER("Qty. to Invoice",'<>0');
          PassedInvoice := ServLine.FIND('-');
          IF PassedInvoice AND ("Document Type" = "Document Type"::Order) AND NOT PassedShip THEN BEGIN
            PassedInvoice := FALSE;
            REPEAT
              PassedInvoice :=
                (ServLine."Quantity Shipped" - ServLine."Quantity Invoiced" - ServLine."Quantity Consumed" <> 0);
            UNTIL PassedInvoice OR (ServLine.NEXT = 0);
          END;
        END;
        IF PassedShip THEN BEGIN
          ServLine.RESET;
          ServLine.SETFILTER(Quantity,'<>0');
          IF "Document Type" = "Document Type"::Order THEN
            ServLine.SETFILTER("Qty. to Ship",'<>0');
          ServLine.SETRANGE("Shipment No.",'');
          PassedShip := ServLine.FIND('-');
          IF PassedShip THEN
            ServITRMgt.CheckTrackingSpecification(ServHeader,ServLine);
        END;
      END;

      SetPostingOptions(PassedShip,PassedConsume,PassedInvoice);
      ServLine.RESET;
    END;

    [External]
    PROCEDURE CheckAndBlankQtys@37(ServDocType@1000 : Integer);
    BEGIN
      ServLine.RESET;
      IF ServLine.FIND('-') THEN
        REPEAT
          WITH ServLine DO BEGIN
            // Service Charge line should not be tested.
            IF (Type <> Type::" ") AND NOT "System-Created Entry" THEN BEGIN
              IF ServDocType = DATABASE::"Service Contract Header" THEN
                TESTFIELD("Contract No.");
              IF ServDocType = DATABASE::"Service Header" THEN
                TESTFIELD("Shipment No.");
            END;

            IF "Qty. per Unit of Measure" = 0 THEN
              "Qty. per Unit of Measure" := 1;
            CASE "Document Type" OF
              "Document Type"::Invoice:
                BEGIN
                  IF "Shipment No." = '' THEN
                    TESTFIELD("Qty. to Ship",Quantity);
                  TESTFIELD("Qty. to Invoice",Quantity);
                END;
              "Document Type"::"Credit Memo":
                BEGIN
                  TESTFIELD("Qty. to Ship",0);
                  TESTFIELD("Qty. to Invoice",Quantity);
                END;
            END;

            IF NOT (Ship OR ServAmountsMgt.RoundingLineInserted) THEN BEGIN
              "Qty. to Ship" := 0;
              "Qty. to Ship (Base)" := 0;
            END;

            IF ("Document Type" = "Document Type"::Invoice) AND ("Shipment No." <> '') THEN BEGIN
              "Quantity Shipped" := Quantity;
              "Qty. Shipped (Base)" := "Quantity (Base)";
              "Qty. to Ship" := 0;
              "Qty. to Ship (Base)" := 0;
            END;

            IF Invoice THEN BEGIN
              IF ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice) THEN BEGIN
                "Qty. to Consume" := 0;
                "Qty. to Consume (Base)" := 0;
                InitQtyToInvoice;
              END
            END ELSE BEGIN
              "Qty. to Invoice" := 0;
              "Qty. to Invoice (Base)" := 0;
            END;

            IF Consume THEN BEGIN
              IF ABS("Qty. to Consume") > ABS(MaxQtyToConsume) THEN BEGIN
                "Qty. to Consume" := MaxQtyToConsume;
                "Qty. to Consume (Base)" := MaxQtyToConsumeBase;
              END;
            END ELSE BEGIN
              "Qty. to Consume" := 0;
              "Qty. to Consume (Base)" := 0;
            END;

            MODIFY;
          END;

        UNTIL ServLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckCloseCondition@13(Qty@1000 : Decimal;QtytoInv@1001 : Decimal;QtyToCsm@1002 : Decimal;QtyInvd@1003 : Decimal;QtyCsmd@1004 : Decimal) : Boolean;
    VAR
      ServiceItemLineTemp@1007 : Record 5901;
      ServiceLineTemp@1008 : Record 5902;
      QtyClosedCondition@1005 : Boolean;
      ServiceItemClosedCondition@1006 : Boolean;
    BEGIN
      QtyClosedCondition := (Qty = QtyToCsm + QtytoInv + QtyCsmd + QtyInvd);
      ServiceItemClosedCondition := TRUE;
      ServiceItemLineTemp.SETCURRENTKEY("Document Type","Document No.","Line No.");
      ServiceItemLineTemp.SETRANGE("Document Type",ServItemLine."Document Type");
      ServiceItemLineTemp.SETRANGE("Document No.",ServItemLine."Document No.");
      ServiceItemLineTemp.SETFILTER("Service Item No.",'<>%1','');
      IF ServiceItemLineTemp.FINDSET THEN
        REPEAT
          ServiceLineTemp.SETCURRENTKEY("Document Type","Document No.","Service Item No.");
          ServiceLineTemp.SETRANGE("Document Type",ServiceItemLineTemp."Document Type");
          ServiceLineTemp.SETRANGE("Document No.",ServiceItemLineTemp."Document No.");
          ServiceLineTemp.SETRANGE("Service Item No.",ServiceItemLineTemp."Service Item No.");
          IF NOT ServiceLineTemp.FINDFIRST THEN
            ServiceItemClosedCondition := FALSE
        UNTIL (ServiceItemLineTemp.NEXT = 0) OR (NOT ServiceItemClosedCondition);
      EXIT(QtyClosedCondition AND ServiceItemClosedCondition);
    END;

    LOCAL PROCEDURE CheckSysCreatedEntry@45();
    BEGIN
      WITH ServLine DO
        IF ServHeader."Document Type" = ServHeader."Document Type"::Invoice THEN BEGIN
          RESET;
          SETRANGE("System-Created Entry",FALSE);
          SETFILTER(Quantity,'<>0');
          IF NOT FIND('-') THEN
            ERROR(Text001);
          RESET;
        END;
    END;

    LOCAL PROCEDURE CheckShippingAdvice@40();
    BEGIN
      IF ServHeader."Shipping Advice" = ServHeader."Shipping Advice"::Complete THEN
        WITH ServLine DO
          IF FINDSET THEN
            REPEAT
              IF IsShipment THEN BEGIN
                IF NOT GetShippingAdvice THEN
                  ERROR(Text023);
                EXIT;
              END;
            UNTIL NEXT = 0;
    END;

    [External]
    PROCEDURE CheckAdjustedLines@18();
    VAR
      ServPriceMgt@1001 : Codeunit 6080;
    BEGIN
      WITH ServLine DO BEGIN
        IF ServItemLine.GET("Document Type","Document No.","Service Item Line No.") THEN
          IF ServItemLine."Service Price Group Code" <> '' THEN
            IF ServPriceMgt.IsLineToAdjustFirstInvoiced(ServLine) THEN
              IF NOT CONFIRM(STRSUBSTNO(Text015,TABLECAPTION,FIELDCAPTION("Service Price Group Code"))) THEN
                ERROR('');
        RESET;
      END;
    END;

    [External]
    PROCEDURE IsCloseConditionMet@33() : Boolean;
    BEGIN
      EXIT(CloseCondition);
    END;

    [External]
    PROCEDURE SetNoSeries@7(VAR PServHeader@1001 : Record 5900) : Boolean;
    VAR
      NoSeriesMgt@1000 : Codeunit 396;
      ModifyHeader@1002 : Boolean;
    BEGIN
      ModifyHeader := FALSE;
      WITH ServHeader DO BEGIN
        IF Ship AND ("Shipping No." = '') THEN
          IF ("Document Type" = "Document Type"::Order) OR
             (("Document Type" = "Document Type"::Invoice) AND ServMgtSetup."Shipment on Invoice")
          THEN BEGIN
            TESTFIELD("Shipping No. Series");
            "Shipping No." := NoSeriesMgt.GetNextNo("Shipping No. Series","Posting Date",TRUE);
            ModifyHeader := TRUE;
          END;

        IF Invoice AND ("Posting No." = '') THEN BEGIN
          IF ("No. Series" <> '') OR ("Document Type" = "Document Type"::Order)
          THEN
            TESTFIELD("Posting No. Series");
          IF ("No. Series" <> "Posting No. Series") OR ("Document Type" = "Document Type"::Order)
          THEN BEGIN
            "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",TRUE);
            ModifyHeader := TRUE;
          END;
        END;

        OnBeforeModifyServiceDocNoSeries(ServHeader,PServHeader,ModifyHeader);
        MODIFY;

        IF ModifyHeader THEN BEGIN
          PServHeader."Shipping No." := "Shipping No.";
          PServHeader."Posting No." := "Posting No.";
        END;
      END;
      EXIT(ModifyHeader);
    END;

    [External]
    PROCEDURE SetLastNos@23(VAR PServHeader@1000 : Record 5900);
    BEGIN
      IF Ship THEN BEGIN
        PServHeader."Last Shipping No." := ServHeader."Last Shipping No.";
        PServHeader."Shipping No." := '';
      END;

      IF Invoice THEN BEGIN
        PServHeader."Last Posting No." := ServHeader."Last Posting No.";
        PServHeader."Posting No." := '';
      END;
      IF ServLinesPassed AND CloseCondition THEN
        PServHeader.Status := ServHeader.Status::Finished;
    END;

    [External]
    PROCEDURE SetPostingOptions@47(passedShip@1000 : Boolean;passedConsume@1001 : Boolean;passedInvoice@1002 : Boolean);
    BEGIN
      Ship := passedShip;
      Consume := passedConsume;
      Invoice := passedInvoice;
      ServPostingJnlsMgt.SetPostingOptions(passedConsume,passedInvoice);
    END;

    LOCAL PROCEDURE SetGenJnlLineDocNos@15(DocType@1000 : Integer;DocNo@1001 : Code[20];ExtDocNo@1002 : Code[20]);
    BEGIN
      GenJnlLineDocType := DocType;
      GenJnlLineDocNo := DocNo;
      IF SalesSetup."Ext. Doc. No. Mandatory" THEN
        GenJnlLineExtDocNo := ExtDocNo
      ELSE
        GenJnlLineExtDocNo := '';
      ServPostingJnlsMgt.SetGenJnlLineDocNos(GenJnlLineDocNo,GenJnlLineExtDocNo);
    END;

    LOCAL PROCEDURE UpdateRcptLinesOnInv@21();
    BEGIN
    END;

    LOCAL PROCEDURE UpdateShptLinesOnInv@52(VAR ServiceLine@1001 : Record 5902;VAR RemQtyToBeInvoiced@1002 : Decimal;VAR RemQtyToBeInvoicedBase@1003 : Decimal;VAR RemQtyToBeConsumed@1004 : Decimal;VAR RemQtyToBeConsumedBase@1005 : Decimal);
    VAR
      ServiceShptLine@1006 : Record 5991;
      ItemEntryRelation@1000 : Record 6507;
      QtyToBeInvoiced@1008 : Decimal;
      QtyToBeInvoicedBase@1009 : Decimal;
      QtyToBeConsumed@1010 : Decimal;
      QtyToBeConsumedBase@1011 : Decimal;
      EndLoop@1013 : Boolean;
    BEGIN
      EndLoop := FALSE;
      IF ((ABS(RemQtyToBeInvoiced) > ABS(ServiceLine."Qty. to Ship")) AND Invoice) OR
         ((ABS(RemQtyToBeConsumed) > ABS(ServiceLine."Qty. to Ship")) AND Consume)
      THEN BEGIN
        ServiceShptLine.RESET;
        CASE ServHeader."Document Type" OF
          ServHeader."Document Type"::Order:
            BEGIN
              ServiceShptLine.SETCURRENTKEY("Order No.","Order Line No.");
              ServiceShptLine.SETRANGE("Order No.",ServiceLine."Document No.");
              ServiceShptLine.SETRANGE("Order Line No.",ServiceLine."Line No.");
            END;
          ServHeader."Document Type"::Invoice:
            BEGIN
              ServiceShptLine.SETRANGE("Document No.",ServiceLine."Shipment No.");
              ServiceShptLine.SETRANGE("Line No.",ServiceLine."Shipment Line No.");
            END;
        END;

        ServiceShptLine.SETFILTER("Qty. Shipped Not Invoiced",'<>0');
        IF ServiceShptLine.FIND('-') THEN BEGIN
          ServPostingJnlsMgt.SetItemJnlRollRndg(TRUE);
          REPEAT
            IF TrackingSpecificationExists THEN BEGIN
              ItemEntryRelation.GET(TempInvoicingSpecification."Item Ledger Entry No.");
              ServiceShptLine.GET(ItemEntryRelation."Source ID",ItemEntryRelation."Source Ref. No.");
            END ELSE
              ItemEntryRelation."Item Entry No." := ServiceShptLine."Item Shpt. Entry No.";
            ServiceShptLine.TESTFIELD("Customer No.",ServiceLine."Customer No.");
            ServiceShptLine.TESTFIELD(Type,ServiceLine.Type);
            ServiceShptLine.TESTFIELD("No.",ServiceLine."No.");
            ServiceShptLine.TESTFIELD("Gen. Bus. Posting Group",ServiceLine."Gen. Bus. Posting Group");
            ServiceShptLine.TESTFIELD("Gen. Prod. Posting Group",ServiceLine."Gen. Prod. Posting Group");

            ServiceShptLine.TESTFIELD("Unit of Measure Code",ServiceLine."Unit of Measure Code");
            ServiceShptLine.TESTFIELD("Variant Code",ServiceLine."Variant Code");
            IF -ServiceLine."Qty. to Invoice" * ServiceShptLine.Quantity < 0 THEN
              ServiceLine.FIELDERROR("Qty. to Invoice",Text011);

            IF TrackingSpecificationExists THEN BEGIN
              IF Invoice THEN BEGIN
                QtyToBeInvoiced := TempInvoicingSpecification."Qty. to Invoice";
                QtyToBeInvoicedBase := TempInvoicingSpecification."Qty. to Invoice (Base)";
              END;
              IF Consume THEN BEGIN
                QtyToBeConsumed := TempInvoicingSpecification."Qty. to Invoice";
                QtyToBeConsumedBase := TempInvoicingSpecification."Qty. to Invoice (Base)";
              END;
            END ELSE BEGIN
              IF Invoice THEN BEGIN
                QtyToBeInvoiced := RemQtyToBeInvoiced - ServiceLine."Qty. to Ship" - ServiceLine."Qty. to Consume";
                QtyToBeInvoicedBase :=
                  RemQtyToBeInvoicedBase - ServiceLine."Qty. to Ship (Base)" - ServiceLine."Qty. to Consume (Base)";
              END;
              IF Consume THEN BEGIN
                QtyToBeConsumed := RemQtyToBeConsumed - ServiceLine."Qty. to Ship" - ServiceLine."Qty. to Invoice";
                QtyToBeConsumedBase :=
                  RemQtyToBeConsumedBase - ServiceLine."Qty. to Ship (Base)" - ServiceLine."Qty. to Invoice (Base)";
              END;
            END;

            IF Invoice THEN BEGIN
              IF ABS(QtyToBeInvoiced) >
                 ABS(ServiceShptLine.Quantity - ServiceShptLine."Quantity Invoiced" - ServiceShptLine."Quantity Consumed")
              THEN BEGIN
                QtyToBeInvoiced :=
                  -(ServiceShptLine.Quantity - ServiceShptLine."Quantity Invoiced" - ServiceShptLine."Quantity Consumed");
                QtyToBeInvoicedBase :=
                  -(ServiceShptLine."Quantity (Base)" - ServiceShptLine."Qty. Invoiced (Base)" -
                    ServiceShptLine."Qty. Consumed (Base)");
              END;

              IF TrackingSpecificationExists THEN
                ServITRMgt.AdjustQuantityRounding(
                  RemQtyToBeInvoiced,QtyToBeInvoiced,
                  RemQtyToBeInvoicedBase,QtyToBeInvoicedBase);

              RemQtyToBeInvoiced := RemQtyToBeInvoiced - QtyToBeInvoiced;
              RemQtyToBeInvoicedBase := RemQtyToBeInvoicedBase - QtyToBeInvoicedBase;

              ServiceShptLine."Quantity Invoiced" := ServiceShptLine."Quantity Invoiced" - QtyToBeInvoiced;
              ServiceShptLine."Qty. Invoiced (Base)" := ServiceShptLine."Qty. Invoiced (Base)" - QtyToBeInvoicedBase;
            END;

            IF Consume THEN BEGIN
              IF ABS(QtyToBeConsumed) >
                 ABS(ServiceShptLine.Quantity - ServiceShptLine."Quantity Invoiced" - ServiceShptLine."Quantity Consumed")
              THEN BEGIN
                QtyToBeConsumed :=
                  -(ServiceShptLine.Quantity - ServiceShptLine."Quantity Invoiced" - ServiceShptLine."Quantity Consumed");
                QtyToBeConsumedBase :=
                  -(ServiceShptLine."Quantity (Base)" - ServiceShptLine."Qty. Invoiced (Base)" -
                    ServiceShptLine."Qty. Consumed (Base)");
              END;

              IF TrackingSpecificationExists THEN
                ServITRMgt.AdjustQuantityRounding(
                  RemQtyToBeConsumed,QtyToBeConsumed,
                  RemQtyToBeConsumedBase,QtyToBeConsumedBase);

              RemQtyToBeConsumed := RemQtyToBeConsumed - QtyToBeConsumed;
              RemQtyToBeConsumedBase := RemQtyToBeConsumedBase - QtyToBeConsumedBase;

              ServiceShptLine."Quantity Consumed" :=
                ServiceShptLine."Quantity Consumed" - QtyToBeConsumed;
              ServiceShptLine."Qty. Consumed (Base)" :=
                ServiceShptLine."Qty. Consumed (Base)" - QtyToBeConsumedBase;
            END;

            ServiceShptLine."Qty. Shipped Not Invoiced" :=
              ServiceShptLine.Quantity - ServiceShptLine."Quantity Invoiced" - ServiceShptLine."Quantity Consumed";
            ServiceShptLine."Qty. Shipped Not Invd. (Base)" :=
              ServiceShptLine."Quantity (Base)" - ServiceShptLine."Qty. Invoiced (Base)" - ServiceShptLine."Qty. Consumed (Base)";
            ServiceShptLine.MODIFY;

            IF ServiceLine.Type = ServiceLine.Type::Item THEN BEGIN
              IF Consume THEN
                ServPostingJnlsMgt.PostItemJnlLine(
                  ServiceLine,0,0,
                  QtyToBeConsumed,QtyToBeConsumedBase,
                  QtyToBeInvoiced,QtyToBeInvoicedBase,
                  ItemEntryRelation."Item Entry No.",
                  TempInvoicingSpecification,TempTrackingSpecificationInv,
                  TempHandlingSpecification,TempTrackingSpecification,
                  ServShptHeader,ServiceShptLine."Document No.");

              IF Invoice THEN
                ServPostingJnlsMgt.PostItemJnlLine(
                  ServiceLine,0,0,
                  QtyToBeConsumed,QtyToBeConsumedBase,
                  QtyToBeInvoiced,QtyToBeInvoicedBase,
                  ItemEntryRelation."Item Entry No.",
                  TempInvoicingSpecification,TempTrackingSpecificationInv,
                  TempHandlingSpecification,TempTrackingSpecification,
                  ServShptHeader,ServiceShptLine."Document No.");
            END;

            IF TrackingSpecificationExists THEN
              EndLoop := (TempInvoicingSpecification.NEXT = 0)
            ELSE
              EndLoop :=
                (ServiceShptLine.NEXT = 0) OR
                ((Invoice AND (ABS(RemQtyToBeInvoiced) <= ABS(ServiceLine."Qty. to Ship"))) OR
                 (Consume AND (ABS(RemQtyToBeConsumed) <= ABS(ServiceLine."Qty. to Ship"))));
          UNTIL EndLoop;
        END ELSE
          IF ServiceLine."Shipment Line No." <> 0 THEN
            ERROR(Text026,ServiceLine."Shipment Line No.",ServiceLine."Shipment No.")
          ELSE
            ERROR(Text001);
      END;

      IF (Invoice AND (ABS(RemQtyToBeInvoiced) > ABS(ServiceLine."Qty. to Ship"))) OR
         (Consume AND (ABS(RemQtyToBeConsumed) > ABS(ServiceLine."Qty. to Ship")))
      THEN BEGIN
        IF ServHeader."Document Type" = ServHeader."Document Type"::Invoice THEN
          ERROR(Text027,ServiceShptLine."Document No.");
        ERROR(Text013);
      END;
    END;

    LOCAL PROCEDURE UpdateServLinesOnPostOrder@26();
    VAR
      CalcInvDiscAmt@1000 : Boolean;
      OldInvDiscountAmount@1001 : Decimal;
    BEGIN
      CalcInvDiscAmt := FALSE;
      WITH ServLine DO BEGIN
        IF FIND('-') THEN
          REPEAT
            IF Quantity <> 0 THEN BEGIN
              OldInvDiscountAmount := "Inv. Discount Amount";

              IF Ship THEN BEGIN
                "Quantity Shipped" := "Quantity Shipped" + "Qty. to Ship";
                "Qty. Shipped (Base)" := "Qty. Shipped (Base)" + "Qty. to Ship (Base)";
              END;

              IF Consume THEN BEGIN
                IF ABS("Quantity Consumed" + "Qty. to Consume") >
                   ABS("Quantity Shipped" - "Quantity Invoiced")
                THEN BEGIN
                  VALIDATE("Qty. to Consume","Quantity Shipped" - "Quantity Invoiced" - "Quantity Consumed");
                  "Qty. to Consume (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)" - "Qty. Consumed (Base)";
                END;
                "Quantity Consumed" := "Quantity Consumed" + "Qty. to Consume";
                "Qty. Consumed (Base)" := "Qty. Consumed (Base)" + "Qty. to Consume (Base)";
                VALIDATE("Qty. to Consume",0);
                "Qty. to Consume (Base)" := 0;
              END;

              IF Invoice THEN BEGIN
                IF ABS("Quantity Invoiced" + "Qty. to Invoice") >
                   ABS("Quantity Shipped" - "Quantity Consumed")
                THEN BEGIN
                  VALIDATE("Qty. to Invoice","Quantity Shipped" - "Quantity Invoiced" - "Quantity Consumed");
                  "Qty. to Invoice (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)" - "Qty. Consumed (Base)";
                END;
                "Quantity Invoiced" := "Quantity Invoiced" + "Qty. to Invoice";
                "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" + "Qty. to Invoice (Base)";
              END;

              InitOutstanding;
              InitQtyToShip;

              IF "Inv. Discount Amount" <> OldInvDiscountAmount THEN
                CalcInvDiscAmt := TRUE;

              MODIFY;
            END;
          UNTIL NEXT = 0;

        IF FIND('-') THEN
          IF SalesSetup."Calc. Inv. Discount" OR CalcInvDiscAmt THEN BEGIN
            ServHeader.GET("Document Type","Document No.");
            CLEAR(ServCalcDisc);
            ServCalcDisc.CalculateWithServHeader(ServHeader,PServLine,ServLine);
          END;
      END;
    END;

    LOCAL PROCEDURE UpdateServLinesOnPostInvoice@16();
    VAR
      PServShptLine@1000 : Record 5991;
    BEGIN
      ServLine.SETFILTER("Shipment No.",'<>%1','');
      IF ServLine.FIND('-') THEN
        REPEAT
          IF ServLine.Type <> ServLine.Type::" " THEN
            WITH PServLine DO BEGIN
              PServShptLine.GET(ServLine."Shipment No.",ServLine."Shipment Line No.");
              GET("Document Type"::Order,PServShptLine."Order No.",PServShptLine."Order Line No.");
              "Quantity Invoiced" := "Quantity Invoiced" + ServLine."Qty. to Invoice";
              "Qty. Invoiced (Base)" := "Qty. Invoiced (Base)" + ServLine."Qty. to Invoice (Base)";
              IF ABS("Quantity Invoiced") > ABS("Quantity Shipped") THEN
                ERROR(Text014,"Document No.");
              VALIDATE("Qty. to Consume",0);
              InitQtyToInvoice;
              InitOutstanding;
              MODIFY;
            END;

        UNTIL ServLine.NEXT = 0;
      ServITRMgt.InsertTrackingSpecification(ServHeader,TempTrackingSpecification);
      ServLine.SETRANGE("Shipment No.");
    END;

    LOCAL PROCEDURE UpdateServLinesOnPostCrMemo@19();
    BEGIN
    END;

    LOCAL PROCEDURE GetShippingAdvice@38() : Boolean;
    VAR
      ServLine2@1000 : Record 5902;
    BEGIN
      ServLine2.SETRANGE("Document Type",ServHeader."Document Type");
      ServLine2.SETRANGE("Document No.",ServHeader."No.");
      IF ServLine2.FINDSET THEN
        REPEAT
          IF ServLine2.IsShipment THEN BEGIN
            IF ServLine2."Document Type" <> ServLine2."Document Type"::"Credit Memo" THEN
              IF ServLine2."Quantity (Base)" <>
                 ServLine2."Qty. to Ship (Base)" + ServLine2."Qty. Shipped (Base)"
              THEN
                EXIT(FALSE);
          END;
        UNTIL ServLine2.NEXT = 0;
      EXIT(TRUE);
    END;

    LOCAL PROCEDURE RemoveLinesNotSatisfyPosting@1102601001();
    VAR
      ServLine2@1102601000 : Record 5902;
    BEGIN
      // Find ServLines not selected to post, and check if they were completely posted
      IF ServLine.FINDFIRST THEN BEGIN
        ServLine2.SETRANGE("Document Type",ServHeader."Document Type");
        ServLine2.SETRANGE("Document No.",ServHeader."No.");
        ServLine2.FINDSET;
        IF ServLine.COUNT <> ServLine2.COUNT THEN
          REPEAT
            IF NOT ServLine.GET(ServLine2."Document Type",ServLine2."Document No.",ServLine2."Line No.") THEN
              IF ServLine2.Quantity <> ServLine2."Quantity Invoiced" + ServLine2."Quantity Consumed" THEN
                CloseCondition := FALSE;
          UNTIL (ServLine2.NEXT = 0) OR (NOT CloseCondition);
      END;
      // Remove ServLines that do not meet the posting conditions from the selected to post lines
      WITH ServLine DO
        IF FINDSET THEN
          REPEAT
            IF ((Ship AND NOT Consume AND NOT Invoice AND (("Qty. to Consume" <> 0) OR ("Qty. to Ship" = 0))) OR
                ((Ship AND Consume) AND ("Qty. to Consume" = 0)) OR
                ((Ship AND Invoice) AND (("Qty. to Consume" <> 0) OR (("Qty. to Ship" = 0) AND ("Qty. to Invoice" = 0)))) OR
                ((NOT Ship AND Invoice) AND (("Qty. to Invoice" = 0) OR
                                             ("Quantity Shipped" - "Quantity Invoiced" - "Quantity Consumed" = 0)))) AND
               ("Attached to Line No." = 0)
            THEN BEGIN
              IF Quantity <> "Quantity Invoiced" + "Quantity Consumed" THEN
                CloseCondition := FALSE;
              IF ((Type <> Type::" ") AND (Description = '') AND ("No." = '')) OR
                 ((Type <> Type::" ") AND (Description <> '') AND ("No." <> ''))
              THEN BEGIN
                ServLine2 := ServLine;
                IF ServLine2.FIND THEN BEGIN
                  ServLine2.InitOutstanding;
                  ServLine2.InitQtyToShip;
                  ServLine2.MODIFY;
                END;
                DeleteWithAttachedLines;
              END;
            END;
          UNTIL NEXT = 0;
    END;

    LOCAL PROCEDURE FinalizeDeleteComments@48(TableSubType@1000 : Option);
    BEGIN
      ServiceCommentLine.SETRANGE("No.",ServHeader."No.");
      ServiceCommentLine.SETRANGE(Type,ServiceCommentLine.Type::General);
      ServiceCommentLine.SETRANGE("Table Name",ServiceCommentLine."Table Name"::"Service Header");
      ServiceCommentLine.SETRANGE("Table Subtype",TableSubType);
      ServiceCommentLine.DELETEALL;
    END;

    LOCAL PROCEDURE FinalizeDeleteServOrdAllocat@50();
    VAR
      ServiceOrderAllocationRec@1000 : Record 5950;
    BEGIN
      IF NOT (ServHeader."Document Type" IN [ServHeader."Document Type"::Quote,ServHeader."Document Type"::Order]) THEN
        EXIT;
      ServiceOrderAllocationRec.RESET;
      ServiceOrderAllocationRec.SETCURRENTKEY("Document Type","Document No.");
      ServiceOrderAllocationRec.SETRANGE("Document Type",ServHeader."Document Type");
      ServiceOrderAllocationRec.SETRANGE("Document No.",ServHeader."No.");
      ServiceOrderAllocationRec.DELETEALL;
    END;

    LOCAL PROCEDURE FinalizeWarrantyLedgerEntries@54(VAR ServiceHeader@1000 : Record 5900;CloseCondition@1002 : Boolean);
    VAR
      WarrantyLedgerEntry@1001 : Record 5908;
    BEGIN
      WarrantyLedgerEntry.RESET;
      WarrantyLedgerEntry.SETCURRENTKEY("Service Order No.","Posting Date","Document No.");
      WarrantyLedgerEntry.SETRANGE("Service Order No.",ServiceHeader."No.");
      IF WarrantyLedgerEntry.ISEMPTY THEN
        EXIT;
      IF CloseCondition THEN BEGIN
        WarrantyLedgerEntry.MODIFYALL(Open,FALSE);
        EXIT;
      END;
      IF NOT ServLine.FIND('-') THEN
        EXIT;
      REPEAT
        FillTempWarrantyLedgerEntry(ServLine,WarrantyLedgerEntry);
        ServLineInvoicedConsumedQty := ServLine."Quantity Invoiced" + ServLine."Quantity Consumed";
        UpdateTempWarrantyLedgerEntry;
        UpdWarrantyLedgEntriesFromTemp;
      UNTIL ServLine.NEXT = 0;
    END;

    LOCAL PROCEDURE FillTempWarrantyLedgerEntry@56(TempServiceLineParam@1000 : TEMPORARY Record 5902;VAR WarrantyLedgerEntryPar@1001 : Record 5908);
    BEGIN
      TempWarrantyLedgerEntry.DELETEALL;
      WarrantyLedgerEntryPar.FIND('-');
      REPEAT
        IF WarrantyLedgerEntryPar."Service Order Line No." = TempServiceLineParam."Line No." THEN BEGIN
          TempWarrantyLedgerEntry := WarrantyLedgerEntryPar;
          TempWarrantyLedgerEntry.INSERT;
        END;
      UNTIL WarrantyLedgerEntryPar.NEXT = 0;
    END;

    LOCAL PROCEDURE UpdateTempWarrantyLedgerEntry@53();
    VAR
      Reduction@1002 : Decimal;
    BEGIN
      IF NOT TempWarrantyLedgerEntry.FIND('-') THEN
        EXIT;
      REPEAT
        Reduction := FindMinimumNumber(ServLineInvoicedConsumedQty,TempWarrantyLedgerEntry.Quantity);
        ServLineInvoicedConsumedQty -= Reduction;
        TempWarrantyLedgerEntry.Quantity -= Reduction;
        TempWarrantyLedgerEntry.MODIFY;
      UNTIL (TempWarrantyLedgerEntry.NEXT = 0) OR (ServLineInvoicedConsumedQty <= 0);
      TempWarrantyLedgerEntry.FIND('-');
      REPEAT
        TempWarrantyLedgerEntry.Open := TempWarrantyLedgerEntry.Quantity > 0;
        TempWarrantyLedgerEntry.MODIFY;
      UNTIL (TempWarrantyLedgerEntry.NEXT = 0);
    END;

    LOCAL PROCEDURE FindMinimumNumber@51(DecimalNumber1@1000 : Decimal;DecimalNumber2@1001 : Decimal) : Decimal;
    BEGIN
      IF DecimalNumber1 < DecimalNumber2 THEN
        EXIT(DecimalNumber1);
      EXIT(DecimalNumber2);
    END;

    LOCAL PROCEDURE SortLines@57(VAR ServLine@1000 : Record 5902);
    VAR
      GLSetup@1002 : Record 98;
    BEGIN
      GLSetup.GET;
      IF GLSetup.OptimGLEntLockForMultiuserEnv THEN
        ServLine.SETCURRENTKEY("Document Type","Document No.",Type,"No.")
      ELSE
        ServLine.SETCURRENTKEY("Document Type","Document No.","Line No.");
    END;

    LOCAL PROCEDURE UpdateServiceLedgerEntry@58(ServLedgEntryNo@1000 : Integer);
    VAR
      ServiceLedgerEntry@1001 : Record 5907;
    BEGIN
      ServiceLedgerEntry.GET(ServLedgEntryNo);
      ServiceLedgerEntry."Job Posted" := TRUE;
      ServiceLedgerEntry.MODIFY;
    END;

    LOCAL PROCEDURE UpdWarrantyLedgEntriesFromTemp@62();
    VAR
      WarrantyLedgerEntryLocal@1000 : Record 5908;
    BEGIN
      IF NOT TempWarrantyLedgerEntry.FIND('-') THEN
        EXIT;
      REPEAT
        WarrantyLedgerEntryLocal.GET(TempWarrantyLedgerEntry."Entry No.");
        IF WarrantyLedgerEntryLocal.Open AND NOT TempWarrantyLedgerEntry.Open THEN BEGIN
          WarrantyLedgerEntryLocal.Open := FALSE;
          WarrantyLedgerEntryLocal.MODIFY;
        END;
      UNTIL TempWarrantyLedgerEntry.NEXT = 0;
      TempWarrantyLedgerEntry.DELETEALL;
    END;

    LOCAL PROCEDURE CheckCertificateOfSupplyStatus@88(ServShptHeader@1001 : Record 5990;ServShptLine@1000 : Record 5991);
    VAR
      CertificateOfSupply@1002 : Record 780;
      VATPostingSetup@1003 : Record 325;
    BEGIN
      IF ServShptLine.Quantity <> 0 THEN
        IF VATPostingSetup.GET(ServShptHeader."VAT Bus. Posting Group",ServShptLine."VAT Prod. Posting Group") AND
           VATPostingSetup."Certificate of Supply Required"
        THEN BEGIN
          CertificateOfSupply.InitFromService(ServShptHeader);
          CertificateOfSupply.SetRequired(ServShptHeader."No.");
        END
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeModifyServiceDocNoSeries@31(VAR ServHeader@1000 : Record 5900;PServHeader@1001 : Record 5900;ModifyHeader@1002 : Boolean);
    BEGIN
    END;

    [External]
    PROCEDURE CollectTrackingSpecification@55(VAR TempTargetTrackingSpecification@1001 : TEMPORARY Record 336);
    BEGIN
      TempTrackingSpecification.RESET;
      TempTargetTrackingSpecification.RESET;
      TempTargetTrackingSpecification.DELETEALL;

      IF TempTrackingSpecification.FINDSET THEN
        REPEAT
          TempTargetTrackingSpecification := TempTrackingSpecification;
          TempTargetTrackingSpecification.INSERT;
        UNTIL TempTrackingSpecification.NEXT = 0;
    END;

    LOCAL PROCEDURE PostResourceUsage@61(TempServLine@1000 : TEMPORARY Record 5902);
    VAR
      DocNo@1001 : Code[20];
    BEGIN
      IF Consume OR NOT Ship OR (ServLine."Qty. to Ship" = 0) OR
         NOT (ServLine."Document Type" = ServLine."Document Type"::Invoice) AND
         NOT (ServLine."Document Type" = ServLine."Document Type"::Order)
      THEN
        EXIT;

      IF (ServLine."Document Type" = ServLine."Document Type"::Invoice) AND (ServShptHeader."No." = '') THEN
        DocNo := GenJnlLineDocNo
      ELSE
        DocNo := ServShptHeader."No.";

      ServPostingJnlsMgt.PostResJnlLineShip(TempServLine,DocNo,'');
    END;

    BEGIN
    END.
  }
}

