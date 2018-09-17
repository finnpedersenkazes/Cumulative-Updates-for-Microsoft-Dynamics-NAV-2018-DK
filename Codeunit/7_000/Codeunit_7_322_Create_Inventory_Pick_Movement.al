OBJECT Codeunit 7322 Create Inventory Pick/Movement
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    TableNo=5766;
    Permissions=TableData 6550=rimd;
    OnRun=BEGIN
            WhseActivHeader := Rec;
            Code;
            Rec := WhseActivHeader;
          END;

  }
  CODE
  {
    VAR
      WhseRequest@1009 : Record 5765;
      WhseActivHeader@1000 : Record 5766;
      Text000@1001 : TextConst 'DAN=Der er intet at h�ndtere.;ENU=There is nothing to handle.';
      TempHandlingSpecification@1006 : TEMPORARY Record 336;
      Location@1019 : Record 14;
      Item@1018 : Record 27;
      TempReservEntry@1028 : TEMPORARY Record 337;
      PurchHeader@1013 : Record 38;
      SalesHeader@1012 : Record 36;
      TransferHeader@1011 : Record 5740;
      ProdHeader@1010 : Record 5405;
      AssemblyHeader@1035 : Record 900;
      WMSMgt@1021 : Codeunit 7302;
      ItemTrackingMgt@1032 : Codeunit 6500;
      PostingDate@1016 : Date;
      VendorDocNo@1017 : Code[35];
      NextLineNo@1002 : Integer;
      LastTempHandlingSpecNo@1024 : Integer;
      HideDialog@1008 : Boolean;
      SNRequired@1005 : Boolean;
      LNRequired@1004 : Boolean;
      Text001@1007 : TextConst 'DAN=Det disponible antal til pluk er ikke tilstr�kkeligt til at opfylde afsendelsesadvisen %1 for salgslinjen med dokumenttypen %2, dokumentnr. %3, linjenr. %4.;ENU=Quantity available to pick is not sufficient to fulfill shipping advise %1 for sales line with Document Type %2, Document No. %3, Line No. %4.';
      CheckLineExist@1014 : Boolean;
      AutoCreation@1015 : Boolean;
      LineCreated@1020 : Boolean;
      CompleteShipment@1022 : Boolean;
      PrintDocument@1036 : Boolean;
      ShowError@1023 : Boolean;
      Text002@1025 : TextConst 'DAN=Det disponible antal til pluk er ikke tilstr�kkeligt til at opfylde afsendelsesadvisen %1 for overf�rselslinjen med dokumentnr. %2, linjenr. %3.;ENU=Quantity available to pick is not sufficient to fulfill shipping advise %1 for transfer line with Document No. %2, Line No. %3.';
      IsInvtMovement@1026 : Boolean;
      IsBlankInvtMovement@1027 : Boolean;
      Text003@1029 : TextConst 'DAN=%1-aktivitet nr. %2 er blevet oprettet.;ENU=%1 activity no. %2 has been created.';
      Text004@1030 : TextConst 'DAN=Vil du oprette en flytning (lager)?;ENU=Do you want to create Inventory Movement?';
      FromBinCode@1031 : Code[20];
      HasExpiredItems@1033 : Boolean;
      ExpiredItemMessageText@1034 : Text[100];
      ATOInvtMovementsCreated@1037 : Integer;
      TotalATOInvtMovementsToBeCreated@1038 : Integer;

    LOCAL PROCEDURE Code@11();
    BEGIN
      WhseActivHeader.TESTFIELD("No.");
      WhseActivHeader.TESTFIELD("Location Code");

      IF NOT HideDialog THEN
        IF NOT GetWhseRequest(WhseRequest) THEN
          EXIT;

      GetSourceDocHeader;
      UpdateWhseActivHeader(WhseRequest);

      CASE WhseRequest."Source Document" OF
        WhseRequest."Source Document"::"Purchase Order":
          CreatePickOrMoveFromPurchase(PurchHeader);
        WhseRequest."Source Document"::"Purchase Return Order":
          CreatePickOrMoveFromPurchase(PurchHeader);
        WhseRequest."Source Document"::"Sales Order":
          CreatePickOrMoveFromSales(SalesHeader);
        WhseRequest."Source Document"::"Sales Return Order":
          CreatePickOrMoveFromSales(SalesHeader);
        WhseRequest."Source Document"::"Outbound Transfer":
          CreatePickOrMoveFromTransfer(TransferHeader);
        WhseRequest."Source Document"::"Prod. Consumption":
          CreatePickOrMoveFromProduction(ProdHeader);
        WhseRequest."Source Document"::"Assembly Consumption":
          CreatePickOrMoveFromAssembly(AssemblyHeader);
      END;

      IF LineCreated THEN
        WhseActivHeader.MODIFY
      ELSE
        IF NOT AutoCreation THEN
          MESSAGE(Text000 + ExpiredItemMessageText);
    END;

    LOCAL PROCEDURE GetWhseRequest@1(VAR WhseRequest@1000 : Record 5765) : Boolean;
    BEGIN
      WITH WhseRequest DO BEGIN
        FILTERGROUP := 2;
        SETRANGE(Type,Type::Outbound);
        SETRANGE("Location Code",WhseActivHeader."Location Code");
        SETRANGE("Document Status","Document Status"::Released);
        IF WhseActivHeader."Source Document" <> 0 THEN
          SETRANGE("Source Document",WhseActivHeader."Source Document")
        ELSE
          IF WhseActivHeader.Type = WhseActivHeader.Type::"Invt. Movement" THEN
            SETFILTER("Source Document",'%1|%2|%3',
              WhseActivHeader."Source Document"::"Prod. Consumption",
              WhseActivHeader."Source Document"::"Prod. Output",
              WhseActivHeader."Source Document"::"Assembly Consumption");
        IF WhseActivHeader."Source No." <> '' THEN
          SETRANGE("Source No.",WhseActivHeader."Source No.");
        SETRANGE("Completely Handled",FALSE);
        FILTERGROUP := 0;
        IF PAGE.RUNMODAL(PAGE::"Source Documents",WhseRequest,"Source No.") = ACTION::LookupOK THEN
          EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE GetSourceDocHeader@13();
    BEGIN
      CASE WhseRequest."Source Document" OF
        WhseRequest."Source Document"::"Purchase Order":
          BEGIN
            PurchHeader.GET(PurchHeader."Document Type"::Order,WhseRequest."Source No.");
            PostingDate := PurchHeader."Posting Date";
            VendorDocNo := PurchHeader."Vendor Invoice No.";
          END;
        WhseRequest."Source Document"::"Purchase Return Order":
          BEGIN
            PurchHeader.GET(PurchHeader."Document Type"::"Return Order",WhseRequest."Source No.");
            PostingDate := PurchHeader."Posting Date";
            VendorDocNo := PurchHeader."Vendor Cr. Memo No.";
          END;
        WhseRequest."Source Document"::"Sales Order":
          BEGIN
            SalesHeader.GET(SalesHeader."Document Type"::Order,WhseRequest."Source No.");
            PostingDate := SalesHeader."Posting Date";
          END;
        WhseRequest."Source Document"::"Sales Return Order":
          BEGIN
            SalesHeader.GET(SalesHeader."Document Type"::"Return Order",WhseRequest."Source No.");
            PostingDate := SalesHeader."Posting Date";
          END;
        WhseRequest."Source Document"::"Outbound Transfer":
          BEGIN
            TransferHeader.GET(WhseRequest."Source No.");
            PostingDate := TransferHeader."Posting Date";
          END;
        WhseRequest."Source Document"::"Prod. Consumption":
          BEGIN
            ProdHeader.GET(WhseRequest."Source Subtype",WhseRequest."Source No.");
            PostingDate := WORKDATE;
          END;
        WhseRequest."Source Document"::"Assembly Consumption":
          BEGIN
            AssemblyHeader.GET(WhseRequest."Source Subtype",WhseRequest."Source No.");
            PostingDate := AssemblyHeader."Posting Date";
          END;
      END;
    END;

    LOCAL PROCEDURE UpdateWhseActivHeader@2(WhseRequest@1001 : Record 5765);
    BEGIN
      WITH WhseRequest DO BEGIN
        IF WhseActivHeader."Source Document" = 0 THEN BEGIN
          WhseActivHeader."Source Document" := "Source Document";
          WhseActivHeader."Source Type" := "Source Type";
          WhseActivHeader."Source Subtype" := "Source Subtype";
        END ELSE
          WhseActivHeader.TESTFIELD("Source Document","Source Document");
        IF WhseActivHeader."Source No." = '' THEN
          WhseActivHeader."Source No." := "Source No."
        ELSE
          WhseActivHeader.TESTFIELD("Source No.","Source No.");

        WhseActivHeader."Destination Type" := "Destination Type";
        WhseActivHeader."Destination No." := "Destination No.";
        WhseActivHeader."External Document No." := "External Document No.";
        WhseActivHeader."Shipment Date" := "Shipment Date";
        WhseActivHeader."Posting Date" := PostingDate;
        WhseActivHeader."External Document No.2" := VendorDocNo;
        GetLocation("Location Code");
      END;
    END;

    LOCAL PROCEDURE CreatePickOrMoveFromPurchase@7(PurchHeader@1000 : Record 38);
    VAR
      PurchLine@1001 : Record 39;
      NewWhseActivLine@1005 : Record 5767;
      RemQtyToPickBase@1007 : Decimal;
    BEGIN
      WITH PurchLine DO BEGIN
        IF NOT SetFilterPurchLine(PurchLine,PurchHeader) THEN BEGIN
          IF NOT HideDialog THEN
            MESSAGE(Text000);
          EXIT;
        END;

        FindNextLineNo;

        REPEAT
          IF NOT NewWhseActivLine.ActivityExists(DATABASE::"Purchase Line","Document Type","Document No.","Line No.",0,0) THEN BEGIN
            NewWhseActivLine.INIT;
            NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
            NewWhseActivLine."No." := WhseActivHeader."No.";
            IF Location."Bin Mandatory" THEN
              NewWhseActivLine."Action Type" := NewWhseActivLine."Action Type"::Take;
            NewWhseActivLine.SetSource(DATABASE::"Purchase Line","Document Type","Document No.","Line No.",0);
            NewWhseActivLine."Location Code" := "Location Code";
            NewWhseActivLine."Bin Code" := "Bin Code";
            NewWhseActivLine."Item No." := "No.";
            NewWhseActivLine."Variant Code" := "Variant Code";
            NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
            NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            NewWhseActivLine.Description := Description;
            NewWhseActivLine."Description 2" := "Description 2";
            NewWhseActivLine."Due Date" := "Expected Receipt Date";
            NewWhseActivLine."Destination Type" := NewWhseActivLine."Destination Type"::Vendor;
            NewWhseActivLine."Destination No." := PurchHeader."Buy-from Vendor No.";
            IF "Document Type" = "Document Type"::Order THEN BEGIN
              NewWhseActivLine."Source Document" := NewWhseActivLine."Source Document"::"Purchase Order";
              RemQtyToPickBase := -"Qty. to Receive (Base)";
            END ELSE BEGIN
              NewWhseActivLine."Source Document" :=
                NewWhseActivLine."Source Document"::"Purchase Return Order";
              RemQtyToPickBase := "Return Qty. to Ship (Base)";
            END;

            CALCFIELDS("Reserved Quantity");
            CreatePickOrMoveLine(
              NewWhseActivLine,RemQtyToPickBase,"Outstanding Qty. (Base)","Reserved Quantity" <> 0);
          END;
        UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetFilterPurchLine@14(VAR PurchLine@1000 : Record 39;PurchHeader@1001 : Record 38) : Boolean;
    BEGIN
      WITH PurchLine DO BEGIN
        SETCURRENTKEY("Document Type","Document No.","Location Code");
        SETRANGE("Document Type",PurchHeader."Document Type");
        SETRANGE("Document No.",PurchHeader."No.");
        SETRANGE("Drop Shipment",FALSE);
        IF NOT CheckLineExist THEN
          SETRANGE("Location Code",WhseActivHeader."Location Code");
        SETRANGE(Type,Type::Item);
        IF PurchHeader."Document Type" = PurchHeader."Document Type"::Order THEN
          SETFILTER("Qty. to Receive",'<%1',0)
        ELSE
          SETFILTER("Return Qty. to Ship",'>%1',0);
        EXIT(FIND('-'));
      END;
    END;

    LOCAL PROCEDURE CreatePickOrMoveFromSales@8(SalesHeader@1000 : Record 36);
    VAR
      SalesLine@1006 : Record 37;
      NewWhseActivLine@1003 : Record 5767;
      RemQtyToPickBase@1001 : Decimal;
    BEGIN
      WITH SalesLine DO BEGIN
        IF NOT SetFilterSalesLine(SalesLine,SalesHeader) THEN BEGIN
          IF NOT HideDialog THEN
            MESSAGE(Text000);
          EXIT;
        END;
        CompleteShipment := TRUE;

        FindNextLineNo;

        REPEAT
          IF NOT NewWhseActivLine.ActivityExists(DATABASE::"Sales Line","Document Type","Document No.","Line No.",0,0) THEN BEGIN
            NewWhseActivLine.INIT;
            NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
            NewWhseActivLine."No." := WhseActivHeader."No.";
            IF Location."Bin Mandatory" THEN
              NewWhseActivLine."Action Type" := NewWhseActivLine."Action Type"::Take;
            NewWhseActivLine.SetSource(DATABASE::"Sales Line","Document Type","Document No.","Line No.",0);
            NewWhseActivLine."Location Code" := "Location Code";
            NewWhseActivLine."Bin Code" := "Bin Code";
            NewWhseActivLine."Item No." := "No.";
            NewWhseActivLine."Variant Code" := "Variant Code";
            NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
            NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            NewWhseActivLine.Description := Description;
            NewWhseActivLine."Description 2" := "Description 2";
            NewWhseActivLine."Due Date" := "Planned Shipment Date";
            NewWhseActivLine."Shipping Advice" := SalesHeader."Shipping Advice";
            NewWhseActivLine."Shipping Agent Code" := "Shipping Agent Code";
            NewWhseActivLine."Shipping Agent Service Code" := "Shipping Agent Service Code";
            NewWhseActivLine."Shipment Method Code" := SalesHeader."Shipment Method Code";
            NewWhseActivLine."Destination Type" := NewWhseActivLine."Destination Type"::Customer;
            NewWhseActivLine."Destination No." := SalesHeader."Sell-to Customer No.";

            IF "Document Type" = "Document Type"::Order THEN BEGIN
              NewWhseActivLine."Source Document" := NewWhseActivLine."Source Document"::"Sales Order";
              RemQtyToPickBase := "Qty. to Ship (Base)";
            END ELSE BEGIN
              NewWhseActivLine."Source Document" := NewWhseActivLine."Source Document"::"Sales Return Order";
              RemQtyToPickBase := -"Return Qty. to Receive (Base)";
            END;

            CALCFIELDS("Reserved Quantity");
            CreatePickOrMoveLine(
              NewWhseActivLine,RemQtyToPickBase,"Outstanding Qty. (Base)","Reserved Quantity" <> 0);

            IF SalesHeader."Shipping Advice" = SalesHeader."Shipping Advice"::Complete THEN BEGIN
              IF RemQtyToPickBase < 0 THEN BEGIN
                IF AutoCreation THEN BEGIN
                  IF WhseActivHeader.DELETE(TRUE) THEN
                    LineCreated := FALSE;
                  EXIT;
                END;
                ERROR(Text001,SalesHeader."Shipping Advice","Document Type","Document No.","Line No.");
              END;
              IF (RemQtyToPickBase = 0) AND NOT CompleteShipment THEN BEGIN
                IF ShowError THEN
                  ERROR(Text001,SalesHeader."Shipping Advice","Document Type","Document No.","Line No.");
                IF WhseActivHeader.DELETE(TRUE) THEN ;
                LineCreated := FALSE;
                EXIT;
              END;
            END;
          END;
        UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetFilterSalesLine@15(VAR SalesLine@1000 : Record 37;SalesHeader@1001 : Record 36) : Boolean;
    BEGIN
      WITH SalesLine DO BEGIN
        SETCURRENTKEY("Document Type","Document No.","Location Code");
        SETRANGE("Document Type",SalesHeader."Document Type");
        SETRANGE("Document No.",SalesHeader."No.");
        SETRANGE("Drop Shipment",FALSE);
        IF NOT CheckLineExist THEN
          SETRANGE("Location Code",WhseActivHeader."Location Code");
        SETRANGE(Type,Type::Item);
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN
          SETFILTER("Qty. to Ship",'>%1',0)
        ELSE
          SETFILTER("Return Qty. to Receive",'<%1',0);
        EXIT(FIND('-'));
      END;
    END;

    LOCAL PROCEDURE CreatePickOrMoveFromTransfer@9(TransferHeader@1000 : Record 5740);
    VAR
      TransferLine@1006 : Record 5741;
      NewWhseActivLine@1003 : Record 5767;
      RemQtyToPickBase@1001 : Decimal;
    BEGIN
      WITH TransferLine DO BEGIN
        IF NOT SetFilterTransferLine(TransferLine,TransferHeader) THEN BEGIN
          IF NOT HideDialog THEN
            MESSAGE(Text000);
          EXIT;
        END;
        CompleteShipment := TRUE;

        FindNextLineNo;

        REPEAT
          IF NOT NewWhseActivLine.ActivityExists(DATABASE::"Transfer Line",0,"Document No.","Line No.",0,0) THEN BEGIN
            NewWhseActivLine.INIT;
            NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
            NewWhseActivLine."No." := WhseActivHeader."No.";
            IF Location."Bin Mandatory" THEN
              NewWhseActivLine."Action Type" := NewWhseActivLine."Action Type"::Take;
            NewWhseActivLine.SetSource(DATABASE::"Transfer Line",0,"Document No.","Line No.",0);
            NewWhseActivLine."Source Document" := NewWhseActivLine."Source Document"::"Outbound Transfer";
            NewWhseActivLine."Location Code" := "Transfer-from Code";
            NewWhseActivLine."Bin Code" := "Transfer-from Bin Code";
            NewWhseActivLine."Item No." := "Item No.";
            NewWhseActivLine."Variant Code" := "Variant Code";
            NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
            NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            NewWhseActivLine.Description := Description;
            NewWhseActivLine."Description 2" := "Description 2";
            NewWhseActivLine."Due Date" := "Shipment Date";
            NewWhseActivLine."Shipping Advice" := TransferHeader."Shipping Advice";
            NewWhseActivLine."Shipping Agent Code" := "Shipping Agent Code";
            NewWhseActivLine."Shipping Agent Service Code" := "Shipping Agent Service Code";
            NewWhseActivLine."Shipment Method Code" := TransferHeader."Shipment Method Code";
            NewWhseActivLine."Destination Type" := NewWhseActivLine."Destination Type"::Location;
            NewWhseActivLine."Destination No." := TransferHeader."Transfer-to Code";
            RemQtyToPickBase := "Qty. to Ship (Base)";

            CALCFIELDS("Reserved Quantity Outbnd.");
            CreatePickOrMoveLine(
              NewWhseActivLine,RemQtyToPickBase,
              "Outstanding Qty. (Base)","Reserved Quantity Outbnd." <> 0);

            IF TransferHeader."Shipping Advice" = TransferHeader."Shipping Advice"::Complete THEN BEGIN
              IF RemQtyToPickBase > 0 THEN BEGIN
                IF AutoCreation THEN BEGIN
                  WhseActivHeader.DELETE(TRUE);
                  LineCreated := FALSE;
                  EXIT;
                END;
                ERROR(Text002,TransferHeader."Shipping Advice","Document No.","Line No.");
              END;
              IF (RemQtyToPickBase = 0) AND NOT CompleteShipment THEN BEGIN
                IF ShowError THEN
                  ERROR(Text002,TransferHeader."Shipping Advice","Document No.","Line No.");
                IF WhseActivHeader.DELETE(TRUE) THEN ;
                LineCreated := FALSE;
                EXIT;
              END;
            END;
          END;
        UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetFilterTransferLine@16(VAR TransferLine@1000 : Record 5741;TransferHeader@1001 : Record 5740) : Boolean;
    BEGIN
      WITH TransferLine DO BEGIN
        SETRANGE("Document No.",TransferHeader."No.");
        SETRANGE("Derived From Line No.",0);
        IF NOT CheckLineExist THEN
          SETRANGE("Transfer-from Code",WhseActivHeader."Location Code");
        SETFILTER("Qty. to Ship",'>%1',0);
        EXIT(FIND('-'));
      END;
    END;

    LOCAL PROCEDURE CreatePickOrMoveFromProduction@6(ProdOrder@1000 : Record 5405);
    VAR
      ProdOrderComp@1001 : Record 5407;
      NewWhseActivLine@1003 : Record 5767;
      RemQtyToPickBase@1005 : Decimal;
    BEGIN
      WITH ProdOrderComp DO BEGIN
        IF NOT SetFilterProductionLine(ProdOrderComp,ProdOrder) THEN BEGIN
          IF NOT HideDialog THEN
            MESSAGE(Text000);
          EXIT;
        END;

        FindNextLineNo;

        REPEAT
          IF NOT
             NewWhseActivLine.ActivityExists(
               DATABASE::"Prod. Order Component",Status,"Prod. Order No.","Prod. Order Line No.","Line No.",0)
          THEN BEGIN
            NewWhseActivLine.INIT;
            NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
            NewWhseActivLine."No." := WhseActivHeader."No.";
            IF Location."Bin Mandatory" THEN
              NewWhseActivLine."Action Type" := NewWhseActivLine."Action Type"::Take;
            NewWhseActivLine.SetSource(DATABASE::"Prod. Order Component",Status,"Prod. Order No.","Prod. Order Line No.","Line No.");
            NewWhseActivLine."Location Code" := "Location Code";
            NewWhseActivLine."Bin Code" := "Bin Code";
            NewWhseActivLine."Item No." := "Item No.";
            NewWhseActivLine."Variant Code" := "Variant Code";
            NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
            NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            NewWhseActivLine.Description := Description;
            NewWhseActivLine."Source Document" := NewWhseActivLine."Source Document"::"Prod. Consumption";
            NewWhseActivLine."Due Date" := "Due Date";
            IF WhseActivHeader.Type = WhseActivHeader.Type::"Invt. Pick" THEN
              RemQtyToPickBase := "Remaining Qty. (Base)"
            ELSE
              RemQtyToPickBase := "Expected Qty. (Base)" - "Qty. Picked (Base)";

            CALCFIELDS("Reserved Quantity");
            CreatePickOrMoveLine(
              NewWhseActivLine,RemQtyToPickBase,RemQtyToPickBase,"Reserved Quantity" <> 0);
          END;
        UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE CreatePickOrMoveFromAssembly@37(AsmHeader@1000 : Record 900);
    VAR
      AssemblyLine@1001 : Record 901;
      NewWhseActivLine@1003 : Record 5767;
      RemQtyToPickBase@1005 : Decimal;
    BEGIN
      WITH AssemblyLine DO BEGIN
        IF NOT SetFilterAssemblyLine(AssemblyLine,AsmHeader) THEN BEGIN
          IF NOT HideDialog THEN
            MESSAGE(Text000);
          EXIT;
        END;

        IF WhseActivHeader.Type = WhseActivHeader.Type::"Invt. Pick" THEN // no support for inventory pick on assembly
          EXIT;

        FindNextLineNo;

        REPEAT
          IF NOT
             NewWhseActivLine.ActivityExists(DATABASE::"Assembly Line","Document Type","Document No.","Line No.",0,0)
          THEN BEGIN
            NewWhseActivLine.INIT;
            NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
            NewWhseActivLine."No." := WhseActivHeader."No.";
            IF Location."Bin Mandatory" THEN
              NewWhseActivLine."Action Type" := NewWhseActivLine."Action Type"::Take;
            NewWhseActivLine.SetSource(DATABASE::"Assembly Line","Document Type","Document No.","Line No.",0);
            NewWhseActivLine."Location Code" := "Location Code";
            NewWhseActivLine."Bin Code" := "Bin Code";
            NewWhseActivLine."Item No." := "No.";
            NewWhseActivLine."Variant Code" := "Variant Code";
            NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
            NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            NewWhseActivLine.Description := Description;
            NewWhseActivLine."Source Document" := NewWhseActivLine."Source Document"::"Assembly Consumption";
            NewWhseActivLine."Due Date" := "Due Date";
            NewWhseActivLine."Destination Type" := NewWhseActivLine."Destination Type"::Item;
            NewWhseActivLine."Destination No." := AssemblyHeader."Item No.";
            RemQtyToPickBase := "Quantity (Base)" - "Remaining Quantity (Base)" +
              "Quantity to Consume (Base)" - "Qty. Picked (Base)";

            CALCFIELDS("Reserved Quantity");
            CreatePickOrMoveLine(
              NewWhseActivLine,RemQtyToPickBase,RemQtyToPickBase,"Reserved Quantity" <> 0);
          END;
        UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetFilterProductionLine@18(VAR ProdOrderComp@1000 : Record 5407;ProdOrder@1001 : Record 5405) : Boolean;
    BEGIN
      WITH ProdOrderComp DO BEGIN
        SETRANGE(Status,ProdOrder.Status);
        SETRANGE("Prod. Order No.",ProdOrder."No.");
        IF NOT CheckLineExist THEN
          SETRANGE("Location Code",WhseActivHeader."Location Code");
        SETRANGE("Planning Level Code",0);
        IF IsInvtMovement THEN BEGIN
          SETFILTER("Bin Code",'<>%1','');
          SETFILTER("Flushing Method",'%1|%2|%3',
            "Flushing Method"::Manual,
            "Flushing Method"::"Pick + Forward",
            "Flushing Method"::"Pick + Backward");
        END ELSE
          SETRANGE("Flushing Method","Flushing Method"::Manual);
        SETFILTER("Remaining Quantity",'>0');
        EXIT(FIND('-'));
      END;
    END;

    LOCAL PROCEDURE SetFilterAssemblyLine@38(VAR AssemblyLine@1000 : Record 901;AsmHeader@1001 : Record 900) : Boolean;
    BEGIN
      WITH AssemblyLine DO BEGIN
        SETRANGE("Document Type",AsmHeader."Document Type");
        SETRANGE("Document No.",AsmHeader."No.");
        SETRANGE(Type,Type::Item);
        IF NOT CheckLineExist THEN
          SETRANGE("Location Code",WhseActivHeader."Location Code");
        IF IsInvtMovement THEN
          SETFILTER("Bin Code",'<>%1','');
        SETFILTER("Remaining Quantity",'>0');
        EXIT(FIND('-'));
      END;
    END;

    LOCAL PROCEDURE FindNextLineNo@24();
    VAR
      WhseActivLine@1000 : Record 5767;
    BEGIN
      WITH WhseActivHeader DO BEGIN
        IF IsInvtMovement THEN
          WhseActivLine.SETRANGE("Activity Type",WhseActivLine."Activity Type"::"Invt. Movement")
        ELSE
          WhseActivLine.SETRANGE("Activity Type",WhseActivLine."Activity Type"::"Invt. Pick");
        WhseActivLine.SETRANGE("No.","No.");
        IF WhseActivLine.FINDLAST THEN
          NextLineNo := WhseActivLine."Line No." + 10000
        ELSE
          NextLineNo := 10000;
      END;
    END;

    LOCAL PROCEDURE CreatePickOrMoveLine@5(NewWhseActivLine@1003 : Record 5767;VAR RemQtyToPickBase@1004 : Decimal;OutstandingQtyBase@1006 : Decimal;ReservationExists@1007 : Boolean);
    VAR
      ReservationEntry@1009 : Record 337;
      ATOSalesLine@1010 : Record 37;
      ItemTrackingMgt@1002 : Codeunit 6500;
      QtyAvailToPickBase@1005 : Decimal;
      OriginalRemQtyToPickBase@1011 : Decimal;
      ITQtyToPickBase@1001 : Decimal;
      TotalITQtyToPickBase@1012 : Decimal;
      QtyToTrackBase@1000 : Decimal;
      EntriesExist@1008 : Boolean;
    BEGIN
      IF ReservationExists THEN
        CalcRemQtyToPickOrMoveBase(NewWhseActivLine,OutstandingQtyBase,RemQtyToPickBase);
      IF RemQtyToPickBase <= 0 THEN
        EXIT;

      OriginalRemQtyToPickBase := RemQtyToPickBase;

      QtyAvailToPickBase := CalcInvtAvailability(NewWhseActivLine,'','');
      IF WMSMgt.GetATOSalesLine(
           NewWhseActivLine."Source Type",NewWhseActivLine."Source Subtype",NewWhseActivLine."Source No.",
           NewWhseActivLine."Source Line No.",ATOSalesLine)
      THEN
        QtyAvailToPickBase += ATOSalesLine.QtyToAsmBaseOnATO;

      IF RemQtyToPickBase > QtyAvailToPickBase THEN BEGIN
        RemQtyToPickBase := QtyAvailToPickBase;
        CompleteShipment := FALSE;
      END;

      IF RemQtyToPickBase > 0 THEN BEGIN
        ItemTrackingMgt.CheckWhseItemTrkgSetup(NewWhseActivLine."Item No.",SNRequired,LNRequired,FALSE);
        IF SNRequired OR LNRequired THEN BEGIN
          IF IsBlankInvtMovement THEN
            ItemTrackingMgt.SumUpItemTrackingOnlyInventoryOrATO(TempReservEntry,TempHandlingSpecification,TRUE,TRUE)
          ELSE BEGIN
            SetFilterReservEntry(ReservationEntry,NewWhseActivLine);
            ItemTrackingMgt.SumUpItemTrackingOnlyInventoryOrATO(ReservationEntry,TempHandlingSpecification,TRUE,TRUE);
          END;
          IF PickOrMoveAccordingToFEFO(NewWhseActivLine."Location Code") OR
             PickStrictExpirationPosting(NewWhseActivLine."Item No.")
          THEN BEGIN
            QtyToTrackBase := RemQtyToPickBase;
            IF UndefinedItemTrkg(QtyToTrackBase) THEN
              CreateTempHandlingSpec(NewWhseActivLine,QtyToTrackBase);
          END;

          TempHandlingSpecification.RESET;
          IF TempHandlingSpecification.FIND('-') THEN
            REPEAT
              ITQtyToPickBase := ABS(TempHandlingSpecification."Qty. to Handle (Base)");
              TotalITQtyToPickBase += ITQtyToPickBase;
              IF ITQtyToPickBase > 0 THEN BEGIN
                NewWhseActivLine.CopyTrackingFromSpec(TempHandlingSpecification);
                IF NewWhseActivLine.TrackingExists THEN
                  NewWhseActivLine."Expiration Date" :=
                    ItemTrackingMgt.ExistingExpirationDate(NewWhseActivLine."Item No.",
                      NewWhseActivLine."Variant Code",NewWhseActivLine."Lot No.",NewWhseActivLine."Serial No.",
                      FALSE,EntriesExist);

                IF Location."Bin Mandatory" THEN BEGIN
                  // find Take qty. for bin code of source line
                  IF (NewWhseActivLine."Bin Code" <> '') AND (NOT IsInvtMovement OR IsBlankInvtMovement) THEN
                    InsertPickOrMoveBinWhseActLine(
                      NewWhseActivLine,NewWhseActivLine."Bin Code",FALSE,ITQtyToPickBase);

                  // Invt. movement without document has to be created
                  IF IsBlankInvtMovement THEN
                    ITQtyToPickBase := 0;

                  // find Take qty. for default bin
                  IF ITQtyToPickBase > 0 THEN
                    InsertPickOrMoveBinWhseActLine(NewWhseActivLine,'',TRUE,ITQtyToPickBase);

                  // find Take qty. for other bins
                  IF ITQtyToPickBase > 0 THEN
                    InsertPickOrMoveBinWhseActLine(NewWhseActivLine,'',FALSE,ITQtyToPickBase);
                  IF (ITQtyToPickBase = 0) AND IsInvtMovement AND NOT IsBlankInvtMovement THEN
                    SynchronizeWhseItemTracking(TempHandlingSpecification);
                END ELSE
                  IF ITQtyToPickBase > 0 THEN
                    InsertShelfWhseActivLine(NewWhseActivLine,ITQtyToPickBase);

                RemQtyToPickBase :=
                  RemQtyToPickBase + ITQtyToPickBase +
                  TempHandlingSpecification."Qty. to Handle (Base)";
              END;
              NewWhseActivLine.ClearTracking;
            UNTIL (TempHandlingSpecification.NEXT = 0) OR (RemQtyToPickBase <= 0);

          RemQtyToPickBase := Minimum(RemQtyToPickBase,OriginalRemQtyToPickBase - TotalITQtyToPickBase);
        END;

        IF Location."Bin Mandatory" THEN BEGIN
          // find Take qty. for bin code of source line
          IF (RemQtyToPickBase > 0) AND
             (NewWhseActivLine."Bin Code" <> '') AND
             (NOT IsInvtMovement OR IsBlankInvtMovement) AND
             (NOT HasExpiredItems)
          THEN
            InsertPickOrMoveBinWhseActLine(
              NewWhseActivLine,NewWhseActivLine."Bin Code",FALSE,RemQtyToPickBase);

          // Invt. movement without document has to be created
          IF IsBlankInvtMovement THEN
            RemQtyToPickBase := 0;

          // find Take qty. for default bin
          IF (RemQtyToPickBase > 0) AND (NOT HasExpiredItems) THEN
            InsertPickOrMoveBinWhseActLine(NewWhseActivLine,'',TRUE,RemQtyToPickBase);

          // find Take qty. for other bins
          IF (RemQtyToPickBase > 0) AND (NOT HasExpiredItems) THEN
            InsertPickOrMoveBinWhseActLine(NewWhseActivLine,'',FALSE,RemQtyToPickBase)
        END ELSE
          IF (RemQtyToPickBase > 0) AND (NOT HasExpiredItems) THEN
            InsertShelfWhseActivLine(NewWhseActivLine,RemQtyToPickBase);
      END;
    END;

    LOCAL PROCEDURE CalcRemQtyToPickOrMoveBase@26(NewWhseActivLine@1001 : Record 5767;OutstandingQtyBase@1002 : Decimal;VAR RemQtyToPickBase@1000 : Decimal);
    VAR
      ATOSalesLine@1004 : Record 37;
      MaxQtyToPickBase@1003 : Decimal;
    BEGIN
      WITH NewWhseActivLine DO BEGIN
        MaxQtyToPickBase :=
          OutstandingQtyBase -
          WMSMgt.CalcLineReservedQtyNotonInvt(
            "Source Type","Source Subtype","Source No.",
            "Source Line No.","Source Subline No.");

        IF WMSMgt.GetATOSalesLine("Source Type","Source Subtype","Source No.","Source Line No.",ATOSalesLine) THEN
          MaxQtyToPickBase += ATOSalesLine.QtyAsmRemainingBaseOnATO;

        IF RemQtyToPickBase > MaxQtyToPickBase THEN BEGIN
          RemQtyToPickBase := MaxQtyToPickBase;
          IF "Shipping Advice" = "Shipping Advice"::Complete THEN
            CompleteShipment := FALSE;
        END;
      END;
    END;

    LOCAL PROCEDURE InsertPickOrMoveBinWhseActLine@4(NewWhseActivLine@1004 : Record 5767;BinCode@1000 : Code[20];DefaultBin@1005 : Boolean;VAR RemQtyToPickBase@1003 : Decimal);
    VAR
      FromBinContent@1002 : Record 7302;
      QtyToPickBase@1001 : Decimal;
      QtyAvailToPickBase@1006 : Decimal;
    BEGIN
      CreateATOPickLine(NewWhseActivLine,BinCode,RemQtyToPickBase);
      IF RemQtyToPickBase = 0 THEN
        EXIT;

      WITH FromBinContent DO BEGIN
        SETCURRENTKEY(Default,"Location Code","Item No.","Variant Code","Bin Code");
        SETRANGE(Default,DefaultBin);
        SETRANGE("Location Code",NewWhseActivLine."Location Code");
        SETRANGE("Item No.",NewWhseActivLine."Item No.");
        SETRANGE("Variant Code",NewWhseActivLine."Variant Code");

        IF (BinCode <> '') AND NOT IsInvtMovement THEN
          SETRANGE("Bin Code",BinCode);

        IF (NewWhseActivLine."Bin Code" <> '') AND IsInvtMovement THEN
          // not movement within the same bin
          SETFILTER("Bin Code",'<>%1',NewWhseActivLine."Bin Code");

        IF IsBlankInvtMovement THEN BEGIN
          // inventory movement without source document, created from Internal Movement
          SETRANGE("Bin Code",FromBinCode);
          SETRANGE(Default);
        END;

        IF NewWhseActivLine."Serial No." <> '' THEN
          SETRANGE("Serial No. Filter",NewWhseActivLine."Serial No.");
        IF NewWhseActivLine."Lot No." <> '' THEN
          SETRANGE("Lot No. Filter",NewWhseActivLine."Lot No.");
        IF FIND('-') THEN
          REPEAT
            QtyAvailToPickBase := CalcQtyAvailToPick(0);
            IF RemQtyToPickBase < QtyAvailToPickBase THEN
              QtyAvailToPickBase := RemQtyToPickBase;
            IF QtyAvailToPickBase > 0 THEN BEGIN
              IF SNRequired THEN BEGIN
                QtyAvailToPickBase := ROUND(QtyAvailToPickBase,1,'<');
                QtyToPickBase := 1;
              END ELSE
                QtyToPickBase := QtyAvailToPickBase;

              MakeHeader;

              REPEAT
                MakeLine(NewWhseActivLine,"Bin Code",QtyToPickBase,RemQtyToPickBase);
                QtyAvailToPickBase := QtyAvailToPickBase - QtyToPickBase;
              UNTIL QtyAvailToPickBase <= 0;
            END;
          UNTIL (NEXT = 0) OR (RemQtyToPickBase = 0);
      END;
    END;

    LOCAL PROCEDURE InsertShelfWhseActivLine@25(NewWhseActivLine@1001 : Record 5767;VAR RemQtyToPickBase@1000 : Decimal);
    VAR
      QtyToPickBase@1002 : Decimal;
    BEGIN
      CreateATOPickLine(NewWhseActivLine,'',RemQtyToPickBase);
      IF RemQtyToPickBase = 0 THEN
        EXIT;

      IF SNRequired THEN BEGIN
        RemQtyToPickBase := ROUND(RemQtyToPickBase,1,'<');
        QtyToPickBase := 1;
      END ELSE
        QtyToPickBase := RemQtyToPickBase;

      MakeHeader;

      REPEAT
        MakeLine(NewWhseActivLine,'',QtyToPickBase,RemQtyToPickBase);
      UNTIL RemQtyToPickBase = 0;
    END;

    LOCAL PROCEDURE CalcInvtAvailability@28(WhseActivLine@1000 : Record 5767;LotNo@1010 : Code[20];SerialNo@1009 : Code[20]) : Decimal;
    VAR
      Item2@1002 : Record 27;
      TempWhseActivLine2@1004 : TEMPORARY Record 5767;
      WhseAvailMgt@1006 : Codeunit 7314;
      QtyAssgndtoPick@1003 : Decimal;
      LineReservedQty@1001 : Decimal;
      QtyReservedOnPickShip@1005 : Decimal;
      QtyOnDedicatedBins@1007 : Decimal;
      QtyBlocked@1008 : Decimal;
    BEGIN
      WITH WhseActivLine DO BEGIN
        GetItem("Item No.");
        Item2 := Item;
        Item2.SETRANGE("Location Filter","Location Code");
        Item2.SETRANGE("Variant Filter","Variant Code");
        IF SerialNo <> '' THEN
          Item2.SETRANGE("Serial No. Filter",SerialNo);
        IF LotNo <> '' THEN
          Item2.SETRANGE("Lot No. Filter",LotNo);
        Item2.CALCFIELDS(Inventory);
        IF NOT IsBlankInvtMovement THEN
          Item2.CALCFIELDS("Reserved Qty. on Inventory");

        QtyAssgndtoPick := WhseAvailMgt.CalcQtyAssgndtoPick(Location,"Item No.","Variant Code",'');
        QtyOnDedicatedBins := WhseAvailMgt.CalcQtyOnDedicatedBins("Location Code","Item No.","Variant Code",LotNo,SerialNo);
        QtyBlocked :=
          WhseAvailMgt.CalcQtyOnBlockedITOrOnBlockedOutbndBins("Location Code","Item No.","Variant Code",LotNo,SerialNo,FALSE,FALSE);
        LineReservedQty :=
          WhseAvailMgt.CalcLineReservedQtyOnInvt(
            "Source Type","Source Subtype","Source No.","Source Line No.","Source Subline No.",TRUE,LotNo,SerialNo,TempWhseActivLine2);
        QtyReservedOnPickShip :=
          WhseAvailMgt.CalcReservQtyOnPicksShips("Location Code","Item No.","Variant Code",TempWhseActivLine2);
      END;
      EXIT(
        Item2.Inventory - ABS(Item2."Reserved Qty. on Inventory") - QtyAssgndtoPick - QtyOnDedicatedBins - QtyBlocked +
        LineReservedQty + QtyReservedOnPickShip);
    END;

    LOCAL PROCEDURE GetLocation@22(LocationCode@1000 : Code[10]);
    BEGIN
      IF LocationCode <> Location.Code THEN BEGIN
        IF LocationCode = '' THEN
          Location.GetLocationSetup('',Location)
        ELSE
          Location.GET(LocationCode);
      END;
    END;

    LOCAL PROCEDURE GetShelfNo@21(ItemNo@1000 : Code[20]) : Code[10];
    BEGIN
      GetItem(ItemNo);
      EXIT(Item."Shelf No.");
    END;

    LOCAL PROCEDURE GetItem@19(ItemNo@1000 : Code[20]);
    BEGIN
      IF ItemNo <> Item."No." THEN
        Item.GET(ItemNo);
    END;

    [External]
    PROCEDURE SetWhseRequest@10(NewWhseRequest@1000 : Record 5765;SetHideDialog@1001 : Boolean);
    BEGIN
      WhseRequest := NewWhseRequest;
      HideDialog := SetHideDialog;
      LineCreated := FALSE;
    END;

    [External]
    PROCEDURE CheckSourceDoc@12(NewWhseRequest@1000 : Record 5765) : Boolean;
    VAR
      PurchLine@1001 : Record 39;
      SalesLine@1002 : Record 37;
      TransferLine@1003 : Record 5741;
      ProdOrderComp@1004 : Record 5407;
      AssemblyLine@1005 : Record 901;
    BEGIN
      WhseRequest := NewWhseRequest;
      IF Location.RequireShipment(WhseRequest."Location Code") THEN
        EXIT(FALSE);

      GetSourceDocHeader;
      CheckLineExist := TRUE;
      CASE WhseRequest."Source Document" OF
        WhseRequest."Source Document"::"Purchase Order":
          EXIT(SetFilterPurchLine(PurchLine,PurchHeader));
        WhseRequest."Source Document"::"Purchase Return Order":
          EXIT(SetFilterPurchLine(PurchLine,PurchHeader));
        WhseRequest."Source Document"::"Sales Order":
          EXIT(SetFilterSalesLine(SalesLine,SalesHeader));
        WhseRequest."Source Document"::"Sales Return Order":
          EXIT(SetFilterSalesLine(SalesLine,SalesHeader));
        WhseRequest."Source Document"::"Outbound Transfer":
          EXIT(SetFilterTransferLine(TransferLine,TransferHeader));
        WhseRequest."Source Document"::"Prod. Consumption":
          EXIT(SetFilterProductionLine(ProdOrderComp,ProdHeader));
        WhseRequest."Source Document"::"Assembly Consumption":
          EXIT(SetFilterAssemblyLine(AssemblyLine,AssemblyHeader));
      END;
    END;

    [External]
    PROCEDURE AutoCreatePickOrMove@17(VAR WhseActivHeaderNew@1000 : Record 5766);
    BEGIN
      WhseActivHeader := WhseActivHeaderNew;
      CheckLineExist := FALSE;
      AutoCreation := TRUE;
      GetLocation(WhseRequest."Location Code");

      CASE WhseRequest."Source Document" OF
        WhseRequest."Source Document"::"Purchase Order":
          CreatePickOrMoveFromPurchase(PurchHeader);
        WhseRequest."Source Document"::"Purchase Return Order":
          CreatePickOrMoveFromPurchase(PurchHeader);
        WhseRequest."Source Document"::"Sales Order":
          CreatePickOrMoveFromSales(SalesHeader);
        WhseRequest."Source Document"::"Sales Return Order":
          CreatePickOrMoveFromSales(SalesHeader);
        WhseRequest."Source Document"::"Outbound Transfer":
          CreatePickOrMoveFromTransfer(TransferHeader);
        WhseRequest."Source Document"::"Prod. Consumption":
          CreatePickOrMoveFromProduction(ProdHeader);
        WhseRequest."Source Document"::"Assembly Consumption":
          CreatePickOrMoveFromAssembly(AssemblyHeader);
      END;

      IF LineCreated THEN BEGIN
        WhseActivHeader.MODIFY;
        WhseActivHeaderNew := WhseActivHeader;
      END;
    END;

    [External]
    PROCEDURE SetReportGlobals@23(PrintDocument2@1000 : Boolean;ShowError2@1001 : Boolean);
    BEGIN
      PrintDocument := PrintDocument2;
      ShowError := ShowError2;
    END;

    LOCAL PROCEDURE SetFilterReservEntry@31(VAR ReservationEntry@1001 : Record 337;WhseActivLine@1000 : Record 5767);
    BEGIN
      WITH ReservationEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line");
        SETRANGE("Source ID",WhseActivLine."Source No.");
        IF WhseActivLine."Source Type" = DATABASE::"Prod. Order Component" THEN
          SETRANGE("Source Ref. No.",WhseActivLine."Source Subline No.")
        ELSE
          SETRANGE("Source Ref. No.",WhseActivLine."Source Line No.");
        SETRANGE("Source Type",WhseActivLine."Source Type");
        SETRANGE("Source Subtype",WhseActivLine."Source Subtype");
        IF WhseActivLine."Source Type" = DATABASE::"Prod. Order Component" THEN
          SETRANGE("Source Prod. Order Line",WhseActivLine."Source Line No.");
        SETRANGE(Positive,FALSE);
      END;
    END;

    [External]
    PROCEDURE SetInvtMovement@3(InvtMovement@1000 : Boolean);
    BEGIN
      IsInvtMovement := InvtMovement;
    END;

    LOCAL PROCEDURE PickOrMoveAccordingToFEFO@50(LocationCode@1000 : Code[10]) : Boolean;
    BEGIN
      GetLocation(LocationCode);

      EXIT(Location."Pick According to FEFO" AND (SNRequired OR LNRequired));
    END;

    LOCAL PROCEDURE UndefinedItemTrkg@58(VAR QtyToTrackBase@1000 : Decimal) : Boolean;
    BEGIN
      QtyToTrackBase := QtyToTrackBase + ItemTrackedQuantity('','');

      EXIT(QtyToTrackBase > 0);
    END;

    LOCAL PROCEDURE ItemTrackedQuantity@63(LotNo@1003 : Code[20];SerialNo@1002 : Code[20]) : Decimal;
    BEGIN
      WITH TempHandlingSpecification DO BEGIN
        RESET;
        IF (LotNo = '') AND (SerialNo = '') THEN
          IF ISEMPTY THEN
            EXIT(0);

        IF SerialNo <> '' THEN BEGIN
          SETCURRENTKEY("Lot No.","Serial No.");
          SETRANGE("Serial No.",SerialNo);
          IF ISEMPTY THEN
            EXIT(0);

          EXIT(1);
        END;

        IF LotNo <> '' THEN BEGIN
          SETCURRENTKEY("Lot No.","Serial No.");
          SETRANGE("Lot No.",LotNo);
          IF ISEMPTY THEN
            EXIT(0);
        END;

        SETCURRENTKEY(
          "Source ID","Source Type","Source Subtype","Source Batch Name",
          "Source Prod. Order Line","Source Ref. No.");
        IF LotNo <> '' THEN
          SETRANGE("Lot No.",LotNo);
        CALCSUMS("Qty. to Handle (Base)");
        EXIT("Qty. to Handle (Base)");
      END;
    END;

    LOCAL PROCEDURE CreateTempHandlingSpec@51(WhseActivLine@1004 : Record 5767;TotalQtytoPickBase@1002 : Decimal);
    VAR
      EntrySummary@1007 : Record 338;
      WhseItemTrackingFEFO@1001 : Codeunit 7326;
      TotalAvailQtyToPickBase@1006 : Decimal;
      RemQtyToPickBase@1009 : Decimal;
      QtyToPickBase@1008 : Decimal;
      QtyTracked@1000 : Decimal;
    BEGIN
      IF Location."Bin Mandatory" THEN
        IF NOT IsItemOnBins(WhseActivLine) THEN
          EXIT;

      WhseItemTrackingFEFO.SetSource(
        WhseActivLine."Source Type",WhseActivLine."Source Subtype",WhseActivLine."Source No.",
        WhseActivLine."Source Line No.",WhseActivLine."Source Subline No.");
      WhseItemTrackingFEFO.CreateEntrySummaryFEFO(Location,WhseActivLine."Item No.",WhseActivLine."Variant Code",TRUE);
      IF WhseItemTrackingFEFO.FindFirstEntrySummaryFEFO(EntrySummary) THEN BEGIN
        InitTempHandlingSpec;
        RemQtyToPickBase := TotalQtytoPickBase;

        REPEAT
          IF EntrySummary."Expiration Date" <> 0D THEN BEGIN
            QtyTracked := ItemTrackedQuantity(EntrySummary."Lot No.",EntrySummary."Serial No.");
            IF NOT ((EntrySummary."Serial No." <> '') AND (QtyTracked > 0)) THEN BEGIN
              IF Location."Bin Mandatory" THEN
                TotalAvailQtyToPickBase :=
                  CalcQtyAvailToPickOnBins(WhseActivLine,EntrySummary."Lot No.",EntrySummary."Serial No.",RemQtyToPickBase)
              ELSE
                TotalAvailQtyToPickBase := CalcInvtAvailability(WhseActivLine,EntrySummary."Lot No.",EntrySummary."Serial No.");

              TotalAvailQtyToPickBase := TotalAvailQtyToPickBase - QtyTracked;
              QtyToPickBase := 0;

              IF TotalAvailQtyToPickBase > 0 THEN
                IF TotalAvailQtyToPickBase >= RemQtyToPickBase THEN BEGIN
                  QtyToPickBase := RemQtyToPickBase;
                  RemQtyToPickBase := 0
                END ELSE BEGIN
                  QtyToPickBase := TotalAvailQtyToPickBase;
                  RemQtyToPickBase := RemQtyToPickBase - QtyToPickBase;
                END;

              IF QtyToPickBase > 0 THEN
                InsertTempHandlingSpec(
                  Location.Code,WhseActivLine."Item No.",WhseActivLine."Variant Code",EntrySummary,QtyToPickBase);
            END;
          END;
        UNTIL NOT WhseItemTrackingFEFO.FindNextEntrySummaryFEFO(EntrySummary) OR (RemQtyToPickBase = 0);
      END;
      HasExpiredItems := WhseItemTrackingFEFO.GetHasExpiredItems;
      ExpiredItemMessageText := WhseItemTrackingFEFO.GetResultMessageForExpiredItem;
    END;

    LOCAL PROCEDURE InitTempHandlingSpec@29();
    BEGIN
      WITH TempHandlingSpecification DO BEGIN
        RESET;
        IF FINDLAST THEN
          LastTempHandlingSpecNo := "Entry No."
        ELSE
          LastTempHandlingSpecNo := 0;
      END;
    END;

    LOCAL PROCEDURE InsertTempHandlingSpec@59(LocationCode@1003 : Code[10];ItemNo@1002 : Code[20];VariantCode@1000 : Code[10];EntrySummary@1004 : Record 338;QuantityBase@1001 : Decimal);
    BEGIN
      WITH TempHandlingSpecification DO BEGIN
        INIT;
        "Entry No." := LastTempHandlingSpecNo + 1;
        "Location Code" := LocationCode;
        "Item No." := ItemNo;
        "Variant Code" := VariantCode;
        "Lot No." := EntrySummary."Lot No.";
        "Serial No." := EntrySummary."Serial No.";
        "Expiration Date" := EntrySummary."Expiration Date";
        VALIDATE("Quantity (Base)",-QuantityBase);
        INSERT;
        LastTempHandlingSpecNo := "Entry No.";
      END;
    END;

    LOCAL PROCEDURE SetFilterInternalMomement@30(VAR InternalMovementLine@1000 : Record 7347;InternalMovementHeader@1001 : Record 7346) : Boolean;
    BEGIN
      WITH InternalMovementLine DO BEGIN
        SETRANGE("No.",InternalMovementHeader."No.");
        SETFILTER("Qty. (Base)",'>0');
        EXIT(FIND('-'));
      END;
    END;

    [External]
    PROCEDURE CreateInvtMvntWithoutSource@32(VAR InternalMovementHeader@1000 : Record 7346);
    VAR
      InternalMovementLine@1001 : Record 7347;
      NewWhseActivLine@1002 : Record 5767;
      RemQtyToPickBase@1003 : Decimal;
    BEGIN
      IF NOT CONFIRM(Text004,FALSE) THEN
        EXIT;

      IsInvtMovement := TRUE;
      IsBlankInvtMovement := TRUE;

      InternalMovementHeader.TESTFIELD("Location Code");

      WITH InternalMovementLine DO BEGIN
        IF NOT SetFilterInternalMomement(InternalMovementLine,InternalMovementHeader) THEN BEGIN
          IF NOT HideDialog THEN
            MESSAGE(Text000);
          EXIT;
        END;

        // creating Inventory Movement Header
        CLEAR(WhseActivHeader);
        WhseActivHeader.Type := WhseActivHeader.Type::"Invt. Movement";
        WhseActivHeader.INSERT(TRUE);
        WhseActivHeader.VALIDATE("Location Code",InternalMovementHeader."Location Code");
        WhseActivHeader.VALIDATE("Posting Date",InternalMovementHeader."Due Date");
        WhseActivHeader.VALIDATE("Assigned User ID",InternalMovementHeader."Assigned User ID");
        WhseActivHeader.VALIDATE("Assignment Date",InternalMovementHeader."Assignment Date");
        WhseActivHeader.VALIDATE("Assignment Time",InternalMovementHeader."Assignment Time");
        WhseActivHeader.MODIFY;

        FindNextLineNo;

        REPEAT
          NewWhseActivLine.INIT;
          NewWhseActivLine."Activity Type" := WhseActivHeader.Type;
          NewWhseActivLine."No." := WhseActivHeader."No.";
          TESTFIELD("Location Code");
          GetLocation("Location Code");
          IF Location."Bin Mandatory" THEN
            NewWhseActivLine."Action Type" := NewWhseActivLine."Action Type"::Take;
          NewWhseActivLine."Location Code" := "Location Code";
          TESTFIELD("From Bin Code");
          FromBinCode := "From Bin Code";
          TESTFIELD("To Bin Code");
          NewWhseActivLine."Bin Code" := "To Bin Code";
          NewWhseActivLine."Item No." := "Item No.";
          NewWhseActivLine."Variant Code" := "Variant Code";
          NewWhseActivLine."Unit of Measure Code" := "Unit of Measure Code";
          NewWhseActivLine."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          NewWhseActivLine.Description := Description;
          NewWhseActivLine."Due Date" := "Due Date";
          RemQtyToPickBase := "Qty. (Base)";

          PrepareItemTrackingFromWhseIT(InternalMovementLine);
          CreatePickOrMoveLine(NewWhseActivLine,RemQtyToPickBase,RemQtyToPickBase,FALSE);
        UNTIL NEXT = 0;
      END;

      IF NextLineNo = 10000 THEN
        ERROR(Text000);

      MoveWhseComments(InternalMovementHeader,WhseActivHeader."No.");
      InternalMovementHeader.DELETE(TRUE);

      MESSAGE(Text003,WhseActivHeader.Type,WhseActivHeader."No.");
    END;

    LOCAL PROCEDURE PrepareItemTrackingFromWhseIT@27(InternalMovementLine@1000 : Record 7347);
    VAR
      WhseItemTrackingLine@1001 : Record 6550;
      EntryNo@1002 : Integer;
    BEGIN
      // function recopies warehouse item tracking into temporary item tracking table
      // when Invt. Movement is created from Internal Movement
      TempReservEntry.RESET;
      TempReservEntry.DELETEALL;

      WhseItemTrackingLine.SETCURRENTKEY("Source ID","Source Type","Source Subtype","Source Batch Name");
      WhseItemTrackingLine.SETRANGE("Source Type",DATABASE::"Internal Movement Line");
      WhseItemTrackingLine.SETRANGE("Source ID",InternalMovementLine."No.");
      WhseItemTrackingLine.SETRANGE("Source Ref. No.",InternalMovementLine."Line No.");

      IF WhseItemTrackingLine.FIND('-') THEN
        REPEAT
          TempReservEntry.TRANSFERFIELDS(WhseItemTrackingLine);
          EntryNo += 1;
          TempReservEntry."Entry No." := EntryNo;
          TempReservEntry.Positive := FALSE;
          TempReservEntry."Reservation Status" := TempReservEntry."Reservation Status"::Surplus;
          TempReservEntry.VALIDATE("Quantity (Base)",-TempReservEntry."Quantity (Base)");
          TempReservEntry.UpdateItemTracking;
          TempReservEntry.INSERT;
        UNTIL WhseItemTrackingLine.NEXT = 0;
    END;

    LOCAL PROCEDURE SynchronizeWhseItemTracking@33(VAR TrackingSpecification@1000 : Record 336);
    VAR
      WhseItemTrackingLine@1001 : Record 6550;
      EntryNo@1002 : Integer;
    BEGIN
      // documents which have defined item tracking - table 337 will have to synchronize these records with 6550 table for invt. movement
      IF WhseItemTrackingLine.FINDLAST THEN
        EntryNo := WhseItemTrackingLine."Entry No.";
      EntryNo += 1;
      CLEAR(WhseItemTrackingLine);
      WhseItemTrackingLine.TRANSFERFIELDS(TrackingSpecification);
      WhseItemTrackingLine.VALIDATE("Quantity (Base)",ABS(WhseItemTrackingLine."Quantity (Base)"));
      WhseItemTrackingLine.VALIDATE("Qty. to Invoice (Base)",ABS(WhseItemTrackingLine."Qty. to Invoice (Base)"));
      WhseItemTrackingLine."Entry No." := EntryNo;
      WhseItemTrackingLine.INSERT;
    END;

    LOCAL PROCEDURE MoveWhseComments@34(InternalMovementHeader@1000 : Record 7346;InvtMovementNo@1003 : Code[20]);
    VAR
      WhseCommentLine@1001 : Record 5770;
      WhseCommentLine2@1002 : Record 5770;
    BEGIN
      WhseCommentLine.SETRANGE("Table Name",WhseCommentLine."Table Name"::"Internal Movement");
      WhseCommentLine.SETRANGE("No.",InternalMovementHeader."No.");
      WhseCommentLine.LOCKTABLE;

      IF WhseCommentLine.FIND('-') THEN BEGIN
        REPEAT
          WhseCommentLine2.INIT;
          WhseCommentLine2 := WhseCommentLine;
          WhseCommentLine2."Table Name" := WhseCommentLine2."Table Name"::"Whse. Activity Header";
          WhseCommentLine2.Type := WhseCommentLine.Type::"Invt. Movement";
          WhseCommentLine2."No." := InvtMovementNo;
          WhseCommentLine2.INSERT;
        UNTIL WhseCommentLine.NEXT = 0;
        WhseCommentLine.DELETEALL;
      END;
    END;

    [External]
    PROCEDURE GetExpiredItemMessage@35() : Text[100];
    BEGIN
      EXIT(ExpiredItemMessageText);
    END;

    LOCAL PROCEDURE PickStrictExpirationPosting@36(ItemNo@1000 : Code[20]) : Boolean;
    BEGIN
      EXIT(ItemTrackingMgt.StrictExpirationPosting(ItemNo) AND (SNRequired OR LNRequired));
    END;

    LOCAL PROCEDURE MakeHeader@42();
    BEGIN
      IF AutoCreation AND NOT LineCreated THEN BEGIN
        WhseActivHeader."No." := '';
        WhseActivHeader.INSERT(TRUE);
        UpdateWhseActivHeader(WhseRequest);
        NextLineNo := 10000;
        COMMIT;
      END;
    END;

    LOCAL PROCEDURE MakeLine@43(VAR NewWhseActivLine@1000 : Record 5767;TakeBinCode@1001 : Code[20];QtyToPickBase@1003 : Decimal;VAR RemQtyToPickBase@1004 : Decimal);
    VAR
      PlaceBinCode@1002 : Code[20];
    BEGIN
      PlaceBinCode := NewWhseActivLine."Bin Code";

      NewWhseActivLine."No." := WhseActivHeader."No.";
      NewWhseActivLine."Line No." := NextLineNo;
      IF Location."Bin Mandatory" THEN BEGIN
        NewWhseActivLine."Action Type" := NewWhseActivLine."Action Type"::Take;
        NewWhseActivLine."Bin Code" := TakeBinCode;
      END ELSE
        NewWhseActivLine."Shelf No." := GetShelfNo(NewWhseActivLine."Item No.");
      NewWhseActivLine.Quantity := NewWhseActivLine.CalcQty(QtyToPickBase);
      NewWhseActivLine."Qty. (Base)" := QtyToPickBase;
      NewWhseActivLine."Qty. Outstanding" := NewWhseActivLine.Quantity;
      NewWhseActivLine."Qty. Outstanding (Base)" := NewWhseActivLine."Qty. (Base)";
      NewWhseActivLine."Qty. to Handle" := 0;
      NewWhseActivLine."Qty. to Handle (Base)" := 0;
      RemQtyToPickBase := RemQtyToPickBase - QtyToPickBase;
      NewWhseActivLine.INSERT;

      IF Location."Bin Mandatory" AND IsInvtMovement THEN BEGIN
        // Place Action for inventory movement
        NextLineNo := NextLineNo + 10000;
        NewWhseActivLine."Line No." := NextLineNo;
        NewWhseActivLine."Action Type" := NewWhseActivLine."Action Type"::Place;
        NewWhseActivLine."Bin Code" := PlaceBinCode;
        NewWhseActivLine.INSERT;
      END;

      LineCreated := TRUE;
      NextLineNo := NextLineNo + 10000;
    END;

    LOCAL PROCEDURE CreateATOPickLine@39(NewWhseActivLine@1002 : Record 5767;BinCode@1001 : Code[20];VAR RemQtyToPickBase@1000 : Decimal);
    VAR
      ATOSalesLine@1005 : Record 37;
      AsmHeader@1004 : Record 900;
      AssemblySetup@1003 : Record 905;
      ReservationEntry@1010 : Record 337;
      TempTrackingSpecification@1009 : TEMPORARY Record 336;
      AssemblyHeaderReserve@1012 : Codeunit 925;
      QtyToAsmBase@1011 : Decimal;
      QtyToPickBase@1006 : Decimal;
      MovementsCreated@1007 : Integer;
      TotalMovementsCreated@1008 : Integer;
    BEGIN
      IF (NOT IsInvtMovement) AND
         WMSMgt.GetATOSalesLine(NewWhseActivLine."Source Type",
           NewWhseActivLine."Source Subtype",
           NewWhseActivLine."Source No.",
           NewWhseActivLine."Source Line No.",
           ATOSalesLine)
      THEN BEGIN
        ATOSalesLine.AsmToOrderExists(AsmHeader);
        IF NewWhseActivLine.TrackingExists THEN BEGIN
          AssemblyHeaderReserve.FilterReservFor(ReservationEntry,AsmHeader);
          ReservationEntry.SetTrackingFilter(NewWhseActivLine."Serial No.",NewWhseActivLine."Lot No.");
          ReservationEntry.SETRANGE(Positive,TRUE);
          IF ItemTrackingMgt.SumUpItemTracking(ReservationEntry,TempTrackingSpecification,TRUE,TRUE) THEN
            QtyToAsmBase := ABS(TempTrackingSpecification."Qty. to Handle (Base)");
        END ELSE
          QtyToAsmBase := ATOSalesLine.QtyToAsmBaseOnATO;
        QtyToPickBase := QtyToAsmBase -
          WMSMgt.CalcQtyBaseOnATOInvtPick(ATOSalesLine,NewWhseActivLine."Serial No.",NewWhseActivLine."Lot No.");
        IF QtyToPickBase > 0 THEN BEGIN
          MakeHeader;
          IF Location."Bin Mandatory" AND (BinCode = '') THEN
            ATOSalesLine.GetATOBin(Location,BinCode);
          NewWhseActivLine."Assemble to Order" := TRUE;
          MakeLine(NewWhseActivLine,BinCode,QtyToPickBase,RemQtyToPickBase);

          AssemblySetup.GET;
          IF AssemblySetup."Create Movements Automatically" THEN BEGIN
            AsmHeader.CreateInvtMovement(TRUE,PrintDocument,ShowError,MovementsCreated,TotalMovementsCreated);
            ATOInvtMovementsCreated += MovementsCreated;
            TotalATOInvtMovementsToBeCreated += TotalMovementsCreated;
          END;
        END;
      END;
    END;

    [External]
    PROCEDURE GetATOMovementsCounters@40(VAR MovementsCreated@1000 : Integer;VAR TotalMovementsCreated@1001 : Integer);
    BEGIN
      MovementsCreated := ATOInvtMovementsCreated;
      TotalMovementsCreated := TotalATOInvtMovementsToBeCreated;
    END;

    LOCAL PROCEDURE Minimum@41(a@1000 : Decimal;b@1001 : Decimal) : Decimal;
    BEGIN
      IF a < b THEN
        EXIT(a);

      EXIT(b);
    END;

    LOCAL PROCEDURE CalcQtyAvailToPickOnBins@45(WhseActivLine@1000 : Record 5767;LotNo@1002 : Code[20];SerialNo@1003 : Code[20];RemQtyToPickBase@1004 : Decimal) : Decimal;
    VAR
      BinContent@1005 : Record 7302;
      TotalAvailQtyToPickBase@1006 : Decimal;
    BEGIN
      TotalAvailQtyToPickBase := 0;

      WITH BinContent DO BEGIN
        SETRANGE("Location Code",WhseActivLine."Location Code");
        SETRANGE("Item No.",WhseActivLine."Item No.");
        SETRANGE("Variant Code",WhseActivLine."Variant Code");
        SETRANGE("Serial No. Filter",SerialNo);
        SETRANGE("Lot No. Filter",LotNo);
        IF FIND('-') THEN
          REPEAT
            TotalAvailQtyToPickBase += CalcQtyAvailToPick(0);
          UNTIL (NEXT = 0) OR (TotalAvailQtyToPickBase >= RemQtyToPickBase);
      END;

      EXIT(TotalAvailQtyToPickBase);
    END;

    LOCAL PROCEDURE IsItemOnBins@44(WhseActivLine@1000 : Record 5767) : Boolean;
    VAR
      BinContent@1003 : Record 7302;
    BEGIN
      WITH BinContent DO BEGIN
        SETRANGE("Location Code",WhseActivLine."Location Code");
        SETRANGE("Item No.",WhseActivLine."Item No.");
        SETRANGE("Variant Code",WhseActivLine."Variant Code");
        EXIT(NOT ISEMPTY);
      END;
    END;

    BEGIN
    END.
  }
}

