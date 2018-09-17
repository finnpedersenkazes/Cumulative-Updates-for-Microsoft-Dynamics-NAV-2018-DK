OBJECT Codeunit 99000813 Carry Out Action
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    TableNo=246;
    OnRun=BEGIN
            ProductionExist := TRUE;
            AssemblyExist := TRUE;
            CASE TrySourceType OF
              TrySourceType::Purchase:
                CarryOutToReqWksh(Rec,TryWkshTempl,TryWkshName);
              TrySourceType::Transfer:
                CarryOutTransOrder(Rec,TryChoice,TryWkshTempl,TryWkshName);
              TrySourceType::Production:
                ProductionExist := CarryOutProdOrder(Rec,TryChoice,TryWkshTempl,TryWkshName);
              TrySourceType::Assembly:
                AssemblyExist := CarryOutAsmOrder(Rec,TryChoice);
            END;

            IF "Action Message" = "Action Message"::Cancel THEN
              DELETE(TRUE);

            ReservEntry.SETCURRENTKEY(
              "Source ID","Source Ref. No.","Source Type","Source Subtype",
              "Source Batch Name","Source Prod. Order Line");
            ReqLineReserve.FilterReservFor(ReservEntry,Rec);
            ReservEntry.DELETEALL(TRUE);

            IF NOT ("Action Message" = "Action Message"::Cancel) THEN BEGIN
              BlockDynamicTracking(TRUE);
              IF TrySourceType = TrySourceType::Production THEN
                BlockDynamicTrackingOnComp(TRUE);
              IF ProductionExist AND AssemblyExist THEN
                DELETE(TRUE);
              BlockDynamicTracking(FALSE);
            END;
          END;

  }
  CODE
  {
    VAR
      TempProductionOrder@1005 : TEMPORARY Record 5405;
      LastTransHeader@1015 : Record 5740;
      TempTransHeaderToPrint@1017 : TEMPORARY Record 5740;
      ReservEntry@1009 : Record 337;
      TempDocumentEntry@1006 : TEMPORARY Record 265;
      CarryOutAction@1014 : Codeunit 99000813;
      CalcProdOrder@1000 : Codeunit 99000773;
      ReservMgt@1001 : Codeunit 99000845;
      ReqLineReserve@1002 : Codeunit 99000833;
      ReservePlanningComponent@1003 : Codeunit 99000840;
      CheckDateConflict@1004 : Codeunit 99000815;
      PrintOrder@1008 : Boolean;
      SplitTransferOrders@1016 : Boolean;
      ProductionExist@1019 : Boolean;
      AssemblyExist@1020 : Boolean;
      TrySourceType@1013 : 'Purchase,Transfer,Production,Assembly';
      TryChoice@1012 : Option;
      TryWkshTempl@1011 : Code[10];
      TryWkshName@1010 : Code[10];
      LineNo@1007 : Integer;
      CouldNotChangeSupplyTxt@1021 : TextConst '@@@=%1 - Production Order No. or Assembly Header No. or Purchase Header No., %2 - Production Order Line or Assembly Line No. or Purchase Line No.;DAN=Leveringstypen kunne ikke �ndres i ordre %1, ordrelinje %2.;ENU=The supply type could not be changed in order %1, order line %2.';

    [External]
    PROCEDURE TryCarryOutAction@20(SourceType@1004 : 'Purchase,Transfer,Production,Assembly';VAR ReqLine@1003 : Record 246;Choice@1002 : Option;WkshTempl@1001 : Code[10];WkshName@1000 : Code[10]) : Boolean;
    BEGIN
      CarryOutAction.SetSplitTransferOrders(SplitTransferOrders);
      CarryOutAction.SetTryParameters(SourceType,Choice,WkshTempl,WkshName);
      EXIT(CarryOutAction.RUN(ReqLine));
    END;

    [External]
    PROCEDURE SetTryParameters@21(SourceType@1004 : 'Purchase,Transfer,Production,Assembly';Choice@1002 : Option;WkshTempl@1001 : Code[10];WkshName@1000 : Code[10]);
    BEGIN
      TrySourceType := SourceType;
      TryChoice := Choice;
      TryWkshTempl := WkshTempl;
      TryWkshName := WkshName;
    END;

    [External]
    PROCEDURE CarryOutProdOrder@1(ReqLine@1000 : Record 246;ProdOrderChoice@1001 : ' ,Planned,Firm Planned,Firm Planned & Print,Copy to Req. Wksh';ProdWkshTempl@1003 : Code[10];ProdWkshName@1002 : Code[10]) : Boolean;
    BEGIN
      PrintOrder := ProdOrderChoice = ProdOrderChoice::"Firm Planned & Print";
      CASE ReqLine."Action Message" OF
        ReqLine."Action Message"::New:
          IF ProdOrderChoice = ProdOrderChoice::"Copy to Req. Wksh" THEN
            CarryOutToReqWksh(ReqLine,ProdWkshTempl,ProdWkshName)
          ELSE
            InsertProdOrder(ReqLine,ProdOrderChoice);
        ReqLine."Action Message"::"Change Qty.",
        ReqLine."Action Message"::Reschedule,
        ReqLine."Action Message"::"Resched. & Chg. Qty.":
          EXIT(ProdOrderChgAndReshedule(ReqLine));
        ReqLine."Action Message"::Cancel:
          DeleteOrderLines(ReqLine);
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CarryOutTransOrder@3(ReqLine@1000 : Record 246;TransOrderChoice@1001 : ' ,Make Trans. Orders,Make Trans. Orders & Print,Copy to Req. Wksh';TransWkshTempName@1002 : Code[10];TransJournalName@1003 : Code[10]);
    BEGIN
      PrintOrder := TransOrderChoice = TransOrderChoice::"Make Trans. Orders & Print";

      IF SplitTransferOrders THEN
        CLEAR(LastTransHeader);

      IF TransOrderChoice = TransOrderChoice::"Copy to Req. Wksh" THEN
        CarryOutToReqWksh(ReqLine,TransWkshTempName,TransJournalName)
      ELSE
        CASE ReqLine."Action Message" OF
          ReqLine."Action Message"::New:
            InsertTransLine(ReqLine,LastTransHeader);
          ReqLine."Action Message"::"Change Qty.",
          ReqLine."Action Message"::Reschedule,
          ReqLine."Action Message"::"Resched. & Chg. Qty.":
            TransOrderChgAndReshedule(ReqLine);
          ReqLine."Action Message"::Cancel:
            DeleteOrderLines(ReqLine);
        END;
    END;

    PROCEDURE CarryOutAsmOrder@26(ReqLine@1003 : Record 246;AsmOrderChoice@1002 : ' ,Make Assembly Orders,Make Assembly Orders & Print') : Boolean;
    VAR
      AsmHeader@1000 : Record 900;
    BEGIN
      PrintOrder := AsmOrderChoice = AsmOrderChoice::"Make Assembly Orders & Print";
      CASE ReqLine."Action Message" OF
        ReqLine."Action Message"::New:
          InsertAsmHeader(ReqLine,AsmHeader);
        ReqLine."Action Message"::"Change Qty.",
        ReqLine."Action Message"::Reschedule,
        ReqLine."Action Message"::"Resched. & Chg. Qty.":
          EXIT(AsmOrderChgAndReshedule(ReqLine));
        ReqLine."Action Message"::Cancel:
          DeleteOrderLines(ReqLine);
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE CarryOutToReqWksh@6(ReqLine@1000 : Record 246;ReqWkshTempName@1001 : Code[10];ReqJournalName@1002 : Code[10]);
    VAR
      ReqLine2@1003 : Record 246;
      PlanningComp@1005 : Record 99000829;
      PlanningRoutingLine@1006 : Record 99000830;
      ProdOrderCapNeed@1010 : Record 5410;
      PlanningComp2@1008 : Record 99000829;
      PlanningRoutingLine2@1007 : Record 99000830;
      ProdOrderCapNeed2@1009 : Record 5410;
      ReqLine3@1004 : Record 246;
    BEGIN
      ReqLine2 := ReqLine;
      ReqLine2."Worksheet Template Name" := ReqWkshTempName;
      ReqLine2."Journal Batch Name" := ReqJournalName;
      IF ReqLine2."Planning Line Origin" = ReqLine2."Planning Line Origin"::"Order Planning" THEN BEGIN
        ReqLine2."Planning Line Origin" := ReqLine2."Planning Line Origin"::" ";
        ReqLine2.Level := 0;
        ReqLine2.Status := 0;
        ReqLine2.Reserve := FALSE;
        ReqLine2."Demand Type" := 0;
        ReqLine2."Demand Subtype" := 0;
        ReqLine2."Demand Order No." := '';
        ReqLine2."Demand Line No." := 0;
        ReqLine2."Demand Ref. No." := 0;
        ReqLine2."Demand Date" := 0D;
        ReqLine2."Demand Quantity" := 0;
        ReqLine2."Demand Quantity (Base)" := 0;
        ReqLine2."Needed Quantity" := 0;
        ReqLine2."Needed Quantity (Base)" := 0;
        ReqLine2."Qty. per UOM (Demand)" := 0;
        ReqLine2."Unit Of Measure Code (Demand)" := '';

        IF LineNo = 0 THEN BEGIN
          // we need to find the last line in worksheet
          ReqLine3.SETCURRENTKEY("Worksheet Template Name","Journal Batch Name","Line No.");
          ReqLine3.SETRANGE("Worksheet Template Name",ReqWkshTempName);
          ReqLine3.SETRANGE("Journal Batch Name",ReqJournalName);
          IF ReqLine3.FINDLAST THEN
            LineNo := ReqLine3."Line No.";
        END;
        LineNo += 10000;
        ReqLine2."Line No." := LineNo;
      END;
      ReqLine2.INSERT;

      ReqLineReserve.TransferReqLineToReqLine(ReqLine,ReqLine2,0,TRUE);
      IF ReqLine.Reserve THEN
        ReserveBindingOrderToReqline(ReqLine2,ReqLine);

      PlanningComp.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningComp.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningComp.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      IF PlanningComp.FIND('-') THEN
        REPEAT
          PlanningComp2 := PlanningComp;
          PlanningComp2."Worksheet Template Name" := ReqWkshTempName;
          PlanningComp2."Worksheet Batch Name" := ReqJournalName;

          IF PlanningComp2."Planning Line Origin" = PlanningComp2."Planning Line Origin"::"Order Planning" THEN
            PlanningComp2."Planning Line Origin" := PlanningComp2."Planning Line Origin"::" ";
          PlanningComp2."Dimension Set ID" := ReqLine2."Dimension Set ID";
          PlanningComp2.INSERT;
        UNTIL PlanningComp.NEXT = 0;

      PlanningRoutingLine.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningRoutingLine.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningRoutingLine.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      IF PlanningRoutingLine.FIND('-') THEN
        REPEAT
          PlanningRoutingLine2 := PlanningRoutingLine;
          PlanningRoutingLine2."Worksheet Template Name" := ReqWkshTempName;
          PlanningRoutingLine2."Worksheet Batch Name" := ReqJournalName;

          PlanningRoutingLine2.INSERT;
        UNTIL PlanningRoutingLine.NEXT = 0;

      ProdOrderCapNeed.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      ProdOrderCapNeed.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      ProdOrderCapNeed.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      IF ProdOrderCapNeed.FIND('-') THEN
        REPEAT
          ProdOrderCapNeed2 := ProdOrderCapNeed;
          ProdOrderCapNeed2."Worksheet Template Name" := ReqWkshTempName;
          ProdOrderCapNeed2."Worksheet Batch Name" := ReqJournalName;

          ProdOrderCapNeed.DELETE;
          ProdOrderCapNeed2.INSERT;
        UNTIL ProdOrderCapNeed.NEXT = 0;
    END;

    [External]
    PROCEDURE GetTransferOrdersToPrint@36(VAR TransferHeader@1000 : Record 5740);
    BEGIN
      IF TempTransHeaderToPrint.FINDSET THEN
        REPEAT
          TransferHeader := TempTransHeaderToPrint;
          TransferHeader.INSERT;
        UNTIL TempTransHeaderToPrint.NEXT = 0;
    END;

    [External]
    PROCEDURE ProdOrderChgAndReshedule@17(ReqLine@1000 : Record 246) : Boolean;
    VAR
      ProdOrderLine@1001 : Record 5406;
      PlanningComponent@1002 : Record 99000829;
      ProdOrderCapNeed@1003 : Record 5410;
      ProdOrderComp@1004 : Record 5407;
      ProdOrder@1005 : Record 5405;
    BEGIN
      WITH ReqLine DO BEGIN
        TESTFIELD("Ref. Order Type","Ref. Order Type"::"Prod. Order");
        ProdOrderLine.LOCKTABLE;
        IF ProdOrderLine.GET("Ref. Order Status","Ref. Order No.","Ref. Line No.") THEN BEGIN
          ProdOrderCapNeed.SETCURRENTKEY("Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.");
          ProdOrderCapNeed.SETRANGE("Worksheet Template Name","Worksheet Template Name");
          ProdOrderCapNeed.SETRANGE("Worksheet Batch Name","Journal Batch Name");
          ProdOrderCapNeed.SETRANGE("Worksheet Line No.","Line No.");
          ProdOrderCapNeed.DELETEALL;
          ProdOrderLine.BlockDynamicTracking(TRUE);
          ProdOrderLine.VALIDATE(Quantity,Quantity);
          ProdOrderLine."Ending Time" := "Ending Time";
          ProdOrderLine."Due Date" := "Due Date";
          ProdOrderLine.VALIDATE("Planning Flexibility","Planning Flexibility");
          ProdOrderLine.VALIDATE("Ending Date","Ending Date");
          ReqLineReserve.TransferPlanningLineToPOLine(ReqLine,ProdOrderLine,0,TRUE);
          ReqLineReserve.UpdateDerivedTracking(ReqLine);
          ReservMgt.SetProdOrderLine(ProdOrderLine);
          ReservMgt.DeleteReservEntries(FALSE,ProdOrderLine."Remaining Qty. (Base)");
          ReservMgt.ClearSurplus;
          ReservMgt.AutoTrack(ProdOrderLine."Remaining Qty. (Base)");
          PlanningComponent.SETRANGE("Worksheet Template Name","Worksheet Template Name");
          PlanningComponent.SETRANGE("Worksheet Batch Name","Journal Batch Name");
          PlanningComponent.SETRANGE("Worksheet Line No.","Line No.");
          IF PlanningComponent.FIND('-') THEN
            REPEAT
              IF ProdOrderComp.GET(
                   ProdOrderLine.Status,ProdOrderLine."Prod. Order No.",ProdOrderLine."Line No.",PlanningComponent."Line No.")
              THEN BEGIN
                ReservePlanningComponent.TransferPlanningCompToPOComp(PlanningComponent,ProdOrderComp,0,TRUE);
                ReservePlanningComponent.UpdateDerivedTracking(PlanningComponent);
                ReservMgt.SetProdOrderComponent(ProdOrderComp);
                ReservMgt.DeleteReservEntries(FALSE,ProdOrderComp."Remaining Qty. (Base)");
                ReservMgt.ClearSurplus;
                ReservMgt.AutoTrack(ProdOrderComp."Remaining Qty. (Base)");
                CheckDateConflict.ProdOrderComponentCheck(ProdOrderComp,FALSE,FALSE);
              END ELSE
                PlanningComponent.DELETE(TRUE);
            UNTIL PlanningComponent.NEXT = 0;

          IF "Planning Level" = 0 THEN
            IF ProdOrder.GET("Ref. Order Status","Ref. Order No.") THEN BEGIN
              ProdOrder.Quantity := Quantity;
              ProdOrder."Starting Time" := "Starting Time";
              ProdOrder."Starting Date" := "Starting Date";
              ProdOrder."Ending Time" := "Ending Time";
              ProdOrder."Ending Date" := "Ending Date";
              ProdOrder."Due Date" := "Due Date";
              ProdOrder.MODIFY;

              FinalizeOrderHeader(ProdOrder);
            END;
        END ELSE BEGIN
          MESSAGE(STRSUBSTNO(CouldNotChangeSupplyTxt,"Ref. Order No.","Ref. Line No."));
          EXIT(FALSE);
        END;
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE PurchOrderChgAndReshedule@22(ReqLine@1000 : Record 246);
    VAR
      PurchLine@1001 : Record 39;
      PurchHeader@1002 : Record 38;
    BEGIN
      ReqLine.TESTFIELD("Ref. Order Type",ReqLine."Ref. Order Type"::Purchase);
      IF PurchLine.GET(
           PurchLine."Document Type"::Order,
           ReqLine."Ref. Order No.",
           ReqLine."Ref. Line No.")
      THEN BEGIN
        PurchLine.BlockDynamicTracking(TRUE);
        PurchLine.VALIDATE(Quantity,ReqLine.Quantity);
        PurchLine.VALIDATE("Expected Receipt Date",ReqLine."Due Date");
        PurchLine.VALIDATE("Planning Flexibility",ReqLine."Planning Flexibility");
        PurchLine.MODIFY(TRUE);
        ReqLineReserve.TransferReqLineToPurchLine(ReqLine,PurchLine,0,TRUE);
        ReqLineReserve.UpdateDerivedTracking(ReqLine);
        ReservMgt.SetPurchLine(PurchLine);
        ReservMgt.DeleteReservEntries(FALSE,PurchLine."Outstanding Qty. (Base)");
        ReservMgt.ClearSurplus;
        ReservMgt.AutoTrack(PurchLine."Outstanding Qty. (Base)");

        PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");
        PrintPurchaseOrder(PurchHeader);
      END ELSE
        ERROR(STRSUBSTNO(CouldNotChangeSupplyTxt,ReqLine."Ref. Order No.",ReqLine."Ref. Line No."));
    END;

    [External]
    PROCEDURE TransOrderChgAndReshedule@25(ReqLine@1000 : Record 246);
    VAR
      TransLine@1002 : Record 5741;
      TransHeader@1001 : Record 5740;
    BEGIN
      ReqLine.TESTFIELD("Ref. Order Type",ReqLine."Ref. Order Type"::Transfer);

      IF TransLine.GET(ReqLine."Ref. Order No.",ReqLine."Ref. Line No.") THEN BEGIN
        TransLine.BlockDynamicTracking(TRUE);
        TransLine.VALIDATE(Quantity,ReqLine.Quantity);
        TransLine.VALIDATE("Receipt Date",ReqLine."Due Date");
        TransLine."Shipment Date" := ReqLine."Transfer Shipment Date";
        TransLine.VALIDATE("Planning Flexibility",ReqLine."Planning Flexibility");
        TransLine.MODIFY(TRUE);
        ReqLineReserve.TransferReqLineToTransLine(ReqLine,TransLine,0,TRUE);
        ReqLineReserve.UpdateDerivedTracking(ReqLine);
        ReservMgt.SetTransferLine(TransLine,0);
        ReservMgt.DeleteReservEntries(FALSE,TransLine."Outstanding Qty. (Base)");
        ReservMgt.ClearSurplus;
        ReservMgt.AutoTrack(TransLine."Outstanding Qty. (Base)");
        ReservMgt.SetTransferLine(TransLine,1);
        ReservMgt.DeleteReservEntries(FALSE,TransLine."Outstanding Qty. (Base)");
        ReservMgt.ClearSurplus;
        ReservMgt.AutoTrack(TransLine."Outstanding Qty. (Base)");
        TransHeader.GET(TransLine."Document No.");
        PrintTransferOrder(TransHeader);
      END;
    END;

    [External]
    PROCEDURE AsmOrderChgAndReshedule@32(ReqLine@1000 : Record 246) : Boolean;
    VAR
      AsmHeader@1001 : Record 900;
      PlanningComponent@1002 : Record 99000829;
      AsmLine@1004 : Record 901;
    BEGIN
      WITH ReqLine DO BEGIN
        TESTFIELD("Ref. Order Type","Ref. Order Type"::Assembly);
        AsmHeader.LOCKTABLE;
        IF AsmHeader.GET(AsmHeader."Document Type"::Order,"Ref. Order No.") THEN BEGIN
          AsmHeader.SetWarningsOff;
          AsmHeader.VALIDATE(Quantity,Quantity);
          AsmHeader.VALIDATE("Planning Flexibility","Planning Flexibility");
          AsmHeader.VALIDATE("Due Date","Due Date");
          AsmHeader.MODIFY(TRUE);
          ReqLineReserve.TransferPlanningLineToAsmHdr(ReqLine,AsmHeader,0,TRUE);
          ReqLineReserve.UpdateDerivedTracking(ReqLine);
          ReservMgt.SetAssemblyHeader(AsmHeader);
          ReservMgt.DeleteReservEntries(FALSE,AsmHeader."Remaining Quantity (Base)");
          ReservMgt.ClearSurplus;
          ReservMgt.AutoTrack(AsmHeader."Remaining Quantity (Base)");

          PlanningComponent.SETRANGE("Worksheet Template Name","Worksheet Template Name");
          PlanningComponent.SETRANGE("Worksheet Batch Name","Journal Batch Name");
          PlanningComponent.SETRANGE("Worksheet Line No.","Line No.");
          IF PlanningComponent.FIND('-') THEN
            REPEAT
              IF AsmLine.GET(AsmHeader."Document Type",AsmHeader."No.",PlanningComponent."Line No.") THEN BEGIN
                ReservePlanningComponent.TransferPlanningCompToAsmLine(PlanningComponent,AsmLine,0,TRUE);
                ReservePlanningComponent.UpdateDerivedTracking(PlanningComponent);
                ReservMgt.SetAssemblyLine(AsmLine);
                ReservMgt.DeleteReservEntries(FALSE,AsmLine."Remaining Quantity (Base)");
                ReservMgt.ClearSurplus;
                ReservMgt.AutoTrack(AsmLine."Remaining Quantity (Base)");
                CheckDateConflict.AssemblyLineCheck(AsmLine,FALSE);
              END ELSE
                PlanningComponent.DELETE(TRUE);
            UNTIL PlanningComponent.NEXT = 0;

          PrintAsmOrder(AsmHeader);
        END ELSE BEGIN
          MESSAGE(STRSUBSTNO(CouldNotChangeSupplyTxt,"Ref. Order No.","Ref. Line No."));
          EXIT(FALSE);
        END;
      END;
      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DeleteOrderLines@4(ReqLine@1000 : Record 246);
    VAR
      ProdOrder@1001 : Record 5405;
      ProdOrderLine@1002 : Record 5406;
      PurchHeader@1003 : Record 38;
      PurchLine@1004 : Record 39;
      TransHeader@1006 : Record 5740;
      TransLine@1005 : Record 5741;
      AsmHeader@1007 : Record 900;
    BEGIN
      CASE ReqLine."Ref. Order Type" OF
        ReqLine."Ref. Order Type"::"Prod. Order":
          BEGIN
            ProdOrderLine.SETCURRENTKEY(Status,"Prod. Order No.","Line No.");
            ProdOrderLine.SETFILTER("Item No.",'<>%1','');
            ProdOrderLine.SETRANGE(Status,ReqLine."Ref. Order Status");
            ProdOrderLine.SETRANGE("Prod. Order No.",ReqLine."Ref. Order No.");
            IF ProdOrderLine.COUNT IN [0,1] THEN BEGIN
              IF ProdOrder.GET(ReqLine."Ref. Order Status",ReqLine."Ref. Order No.") THEN
                ProdOrder.DELETE(TRUE);
            END ELSE BEGIN
              ProdOrderLine.SETRANGE("Line No.",ReqLine."Ref. Line No.");
              IF ProdOrderLine.FINDFIRST THEN
                ProdOrderLine.DELETE(TRUE);
            END;
          END;
        ReqLine."Ref. Order Type"::Purchase:
          BEGIN
            PurchLine.SETCURRENTKEY("Document Type","Document No.","Line No.");
            PurchLine.SETFILTER(Type,'<>%1',PurchLine.Type::" ");
            PurchLine.SETRANGE("Document Type",PurchLine."Document Type"::Order);
            PurchLine.SETRANGE("Document No.",ReqLine."Ref. Order No.");
            IF PurchLine.COUNT IN [0,1] THEN BEGIN
              IF PurchHeader.GET(PurchHeader."Document Type"::Order,ReqLine."Ref. Order No.") THEN
                PurchHeader.DELETE(TRUE);
            END ELSE BEGIN
              PurchLine.SETRANGE("Line No.",ReqLine."Ref. Line No.");
              IF PurchLine.FINDFIRST THEN
                PurchLine.DELETE(TRUE);
            END;
          END;
        ReqLine."Ref. Order Type"::Transfer:
          BEGIN
            TransLine.SETCURRENTKEY("Document No.","Line No.");
            TransLine.SETRANGE("Document No.",ReqLine."Ref. Order No.");
            IF TransLine.COUNT IN [0,1] THEN BEGIN
              IF TransHeader.GET(ReqLine."Ref. Order No.") THEN
                TransHeader.DELETE(TRUE);
            END ELSE BEGIN
              TransLine.SETRANGE("Line No.",ReqLine."Ref. Line No.");
              IF TransLine.FINDFIRST THEN
                TransLine.DELETE(TRUE);
            END;
          END;
        ReqLine."Ref. Order Type"::Assembly:
          BEGIN
            AsmHeader.GET(AsmHeader."Document Type"::Order,ReqLine."Ref. Order No.");
            AsmHeader.DELETE(TRUE);
          END;
      END;
    END;

    [External]
    PROCEDURE InsertProdOrder@8(ReqLine@1000 : Record 246;ProdOrderChoise@1001 : ' ,Planned,Firm Planned,Firm Planned & Print');
    VAR
      MfgSetup@1002 : Record 99000765;
      Item@1003 : Record 27;
      ProdOrder@1004 : Record 5405;
      HeaderExist@1008 : Boolean;
    BEGIN
      Item.GET(ReqLine."No.");
      MfgSetup.GET;
      IF FindTempProdOrder(ReqLine) THEN
        HeaderExist := ProdOrder.GET(TempProductionOrder.Status,TempProductionOrder."No.");

      IF NOT HeaderExist THEN BEGIN
        CASE ProdOrderChoise OF
          ProdOrderChoise::Planned:
            MfgSetup.TESTFIELD("Planned Order Nos.");
          ProdOrderChoise::"Firm Planned",ProdOrderChoise::"Firm Planned & Print":
            MfgSetup.TESTFIELD("Firm Planned Order Nos.");
        END;

        ProdOrder.INIT;
        IF ProdOrderChoise = ProdOrderChoise::"Firm Planned & Print" THEN
          ProdOrder.Status := ProdOrder.Status::"Firm Planned"
        ELSE
          ProdOrder.Status := ProdOrderChoise;
        ProdOrder."No. Series" := ProdOrder.GetNoSeriesCode;
        IF ProdOrder."No. Series" = ReqLine."No. Series" THEN
          ProdOrder."No." := ReqLine."Ref. Order No.";
        ProdOrder.INSERT(TRUE);
        ProdOrder."Source Type" := ProdOrder."Source Type"::Item;
        ProdOrder."Source No." := ReqLine."No.";
        ProdOrder.VALIDATE(Description,ReqLine.Description);
        ProdOrder."Description 2" := ReqLine."Description 2";
        ProdOrder."Creation Date" := TODAY;
        ProdOrder."Last Date Modified" := TODAY;
        ProdOrder."Inventory Posting Group" := Item."Inventory Posting Group";
        ProdOrder."Gen. Prod. Posting Group" := ReqLine."Gen. Prod. Posting Group";
        ProdOrder."Gen. Bus. Posting Group" := ReqLine."Gen. Business Posting Group";
        ProdOrder."Due Date" := ReqLine."Due Date";
        ProdOrder."Starting Time" := ReqLine."Starting Time";
        ProdOrder."Starting Date" := ReqLine."Starting Date";
        ProdOrder."Ending Time" := ReqLine."Ending Time";
        ProdOrder."Ending Date" := ReqLine."Ending Date";
        ProdOrder."Location Code" := ReqLine."Location Code";
        ProdOrder."Bin Code" := ReqLine."Bin Code";
        ProdOrder."Low-Level Code" := ReqLine."Low-Level Code";
        ProdOrder."Routing No." := ReqLine."Routing No.";
        ProdOrder.Quantity := ReqLine.Quantity;
        ProdOrder."Unit Cost" := ReqLine."Unit Cost";
        ProdOrder."Cost Amount" := ReqLine."Cost Amount";
        ProdOrder."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
        ProdOrder."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
        ProdOrder."Dimension Set ID" := ReqLine."Dimension Set ID";
        ProdOrder.UpdateDatetime;
        OnInsertProdOrderWithReqLine(ProdOrder,ReqLine);
        ProdOrder.MODIFY;
        InsertTempProdOrder(ReqLine,ProdOrder);
      END;
      InsertProdOrderLine(ReqLine,ProdOrder,Item);
    END;

    [External]
    PROCEDURE InsertProdOrderLine@9(ReqLine@1000 : Record 246;ProdOrder@1001 : Record 5405;Item@1002 : Record 27);
    VAR
      ProdOrderLine@1004 : Record 5406;
      NextLineNo@1005 : Integer;
    BEGIN
      ProdOrderLine.SETRANGE("Prod. Order No.",ProdOrder."No.");
      ProdOrderLine.SETRANGE(Status,ProdOrder.Status);
      ProdOrderLine.LOCKTABLE;
      IF ProdOrderLine.FINDLAST THEN
        NextLineNo := ProdOrderLine."Line No." + 10000
      ELSE
        NextLineNo := 10000;

      ProdOrderLine.INIT;
      ProdOrderLine.BlockDynamicTracking(TRUE);
      ProdOrderLine.Status := ProdOrder.Status;
      ProdOrderLine."Prod. Order No." := ProdOrder."No.";
      ProdOrderLine."Line No." := NextLineNo;
      ProdOrderLine."Item No." := ReqLine."No.";
      ProdOrderLine.VALIDATE("Unit of Measure Code",ReqLine."Unit of Measure Code");
      ProdOrderLine."Production BOM Version Code" := ReqLine."Production BOM Version Code";
      ProdOrderLine."Routing Version Code" := ReqLine."Routing Version Code";
      ProdOrderLine."Routing Type" := ReqLine."Routing Type";
      ProdOrderLine."Routing Reference No." := ProdOrderLine."Line No.";
      ProdOrderLine.Description := ReqLine.Description;
      ProdOrderLine."Description 2" := ReqLine."Description 2";
      ProdOrderLine."Variant Code" := ReqLine."Variant Code";
      ProdOrderLine."Location Code" := ReqLine."Location Code";
      IF ReqLine."Bin Code" <> '' THEN
        ProdOrderLine.VALIDATE("Bin Code",ReqLine."Bin Code")
      ELSE
        CalcProdOrder.SetProdOrderLineBinCodeFromRoute(ProdOrderLine,ProdOrder."Location Code",ProdOrder."Routing No.");
      ProdOrderLine."Scrap %" := ReqLine."Scrap %";
      ProdOrderLine."Production BOM No." := ReqLine."Production BOM No.";
      ProdOrderLine."Inventory Posting Group" := Item."Inventory Posting Group";
      ProdOrderLine.VALIDATE("Unit Cost",ReqLine."Unit Cost");
      ProdOrderLine."Routing No." := ReqLine."Routing No.";
      ProdOrderLine."Starting Time" := ReqLine."Starting Time";
      ProdOrderLine."Starting Date" := ReqLine."Starting Date";
      ProdOrderLine."Ending Time" := ReqLine."Ending Time";
      ProdOrderLine."Ending Date" := ReqLine."Ending Date";
      ProdOrderLine."Due Date" := ReqLine."Due Date";
      ProdOrderLine.Status := ProdOrder.Status;
      ProdOrderLine."Planning Level Code" := ReqLine."Planning Level";
      ProdOrderLine."Indirect Cost %" := ReqLine."Indirect Cost %";
      ProdOrderLine."Overhead Rate" := ReqLine."Overhead Rate";
      ProdOrderLine.VALIDATE(Quantity,ReqLine.Quantity);
      IF NOT (ProdOrder.Status = ProdOrder.Status::Planned) THEN
        ProdOrderLine."Planning Flexibility" := ReqLine."Planning Flexibility";
      ProdOrderLine.UpdateDatetime;
      ProdOrderLine."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
      ProdOrderLine."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
      ProdOrderLine."Dimension Set ID" := ReqLine."Dimension Set ID";
      OnInsertProdOrderLineWithReqLine(ProdOrderLine,ReqLine);
      ProdOrderLine.INSERT;

      ReqLineReserve.TransferPlanningLineToPOLine(ReqLine,ProdOrderLine,ReqLine."Net Quantity (Base)",FALSE);
      IF ReqLine.Reserve AND NOT (ProdOrderLine.Status = ProdOrderLine.Status::Planned) THEN
        ReserveBindingOrderToProd(ProdOrderLine,ReqLine);

      ProdOrderLine.MODIFY;
      IF TransferRouting(ReqLine,ProdOrder,ProdOrderLine."Routing No.",ProdOrderLine."Routing Reference No.") THEN BEGIN
        CalcProdOrder.SetProdOrderLineBinCodeFromPlanningRtngLines(ProdOrderLine,ReqLine);
        ProdOrderLine.MODIFY;
      END;
      TransferBOM(ReqLine,ProdOrder,ProdOrderLine."Line No.");
      TransferCapNeed(ReqLine,ProdOrder,ProdOrderLine."Routing No.",ProdOrderLine."Routing Reference No.");

      IF ProdOrderLine."Planning Level Code" > 0 THEN
        UpdateComponentLink(ProdOrderLine);

      OnAfterInsertProdOrderLine(ReqLine,ProdOrder,ProdOrderLine,Item);

      FinalizeOrderHeader(ProdOrder);
    END;

    PROCEDURE InsertAsmHeader@28(ReqLine@1000 : Record 246;VAR AsmHeader@1001 : Record 900);
    VAR
      BOMComp@1006 : Record 90;
      Item@1002 : Record 27;
    BEGIN
      Item.GET(ReqLine."No.");
      AsmHeader.INIT;
      AsmHeader."Document Type" := AsmHeader."Document Type"::Order;
      AsmHeader.INSERT(TRUE);
      AsmHeader.SetWarningsOff;
      AsmHeader.VALIDATE("Item No.",ReqLine."No.");
      AsmHeader.VALIDATE("Unit of Measure Code",ReqLine."Unit of Measure Code");
      AsmHeader.Description := ReqLine.Description;
      AsmHeader."Description 2" := ReqLine."Description 2";
      AsmHeader."Variant Code" := ReqLine."Variant Code";
      AsmHeader."Location Code" := ReqLine."Location Code";
      AsmHeader."Inventory Posting Group" := Item."Inventory Posting Group";
      AsmHeader.VALIDATE("Unit Cost",ReqLine."Unit Cost");
      AsmHeader."Due Date" := ReqLine."Due Date";
      AsmHeader."Starting Date" := ReqLine."Starting Date";
      AsmHeader."Ending Date" := ReqLine."Ending Date";

      AsmHeader.Quantity := ReqLine.Quantity;
      AsmHeader."Quantity (Base)" := ReqLine."Quantity (Base)";
      AsmHeader.InitRemainingQty;
      AsmHeader.InitQtyToAssemble;
      IF ReqLine."Bin Code" <> '' THEN
        AsmHeader."Bin Code" := ReqLine."Bin Code"
      ELSE
        AsmHeader.GetDefaultBin;

      AsmHeader."Planning Flexibility" := ReqLine."Planning Flexibility";
      AsmHeader."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
      AsmHeader."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
      AsmHeader."Dimension Set ID" := ReqLine."Dimension Set ID";
      ReqLineReserve.TransferPlanningLineToAsmHdr(ReqLine,AsmHeader,ReqLine."Net Quantity (Base)",FALSE);
      IF ReqLine.Reserve THEN
        ReserveBindingOrderToAsm(AsmHeader,ReqLine);
      AsmHeader.MODIFY;

      TransferAsmPlanningComp(ReqLine,AsmHeader);

      BOMComp.SETRANGE("Parent Item No.",ReqLine."No.");
      BOMComp.SETRANGE(Type,BOMComp.Type::Resource);
      IF BOMComp.FIND('-') THEN
        REPEAT
          AsmHeader.AddBOMLine(BOMComp);
        UNTIL BOMComp.NEXT = 0;

      OnAfterInsertAsmHeader(ReqLine,AsmHeader);

      PrintAsmOrder(AsmHeader);
      TempDocumentEntry.INIT;
      TempDocumentEntry."Table ID" := DATABASE::"Assembly Header";
      TempDocumentEntry."Document Type" := AsmHeader."Document Type"::Order;
      TempDocumentEntry."Document No." := AsmHeader."No.";
      TempDocumentEntry."Entry No." := TempDocumentEntry.COUNT + 1;
      TempDocumentEntry.INSERT;
    END;

    [External]
    PROCEDURE TransferAsmPlanningComp@27(ReqLine@1000 : Record 246;AsmHeader@1001 : Record 900);
    VAR
      AsmLine@1004 : Record 901;
      PlanningComponent@1003 : Record 99000829;
    BEGIN
      PlanningComponent.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningComponent.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningComponent.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      IF PlanningComponent.FIND('-') THEN
        REPEAT
          AsmLine.INIT;
          AsmLine."Document Type" := AsmHeader."Document Type";
          AsmLine."Document No." := AsmHeader."No.";
          AsmLine."Line No." := PlanningComponent."Line No.";
          AsmLine.Type := AsmLine.Type::Item;
          AsmLine."Dimension Set ID" := PlanningComponent."Dimension Set ID";
          AsmLine.VALIDATE("No.",PlanningComponent."Item No.");
          AsmLine.Description := PlanningComponent.Description;
          AsmLine."Unit of Measure Code" := PlanningComponent."Unit of Measure Code";
          AsmLine."Lead-Time Offset" := PlanningComponent."Lead-Time Offset";
          AsmLine.Position := PlanningComponent.Position;
          AsmLine."Position 2" := PlanningComponent."Position 2";
          AsmLine."Position 3" := PlanningComponent."Position 3";
          AsmLine."Variant Code" := PlanningComponent."Variant Code";
          AsmLine."Location Code" := PlanningComponent."Location Code";

          AsmLine."Quantity per" := PlanningComponent."Quantity per";
          AsmLine."Qty. per Unit of Measure" := PlanningComponent."Qty. per Unit of Measure";
          AsmLine.Quantity := PlanningComponent."Expected Quantity";
          AsmLine."Quantity (Base)" := PlanningComponent."Expected Quantity (Base)";
          AsmLine.InitRemainingQty;
          AsmLine.InitQtyToConsume;
          IF PlanningComponent."Bin Code" <> '' THEN
            AsmLine."Bin Code" := PlanningComponent."Bin Code"
          ELSE
            AsmLine.GetDefaultBin;

          AsmLine."Due Date" := PlanningComponent."Due Date";
          AsmLine."Unit Cost" := PlanningComponent."Unit Cost";
          AsmLine."Variant Code" := PlanningComponent."Variant Code";
          AsmLine."Cost Amount" := PlanningComponent."Cost Amount";

          AsmLine."Shortcut Dimension 1 Code" := PlanningComponent."Shortcut Dimension 1 Code";
          AsmLine."Shortcut Dimension 2 Code" := PlanningComponent."Shortcut Dimension 2 Code";

          OnAfterTransferAsmPlanningComp(PlanningComponent,AsmLine);

          AsmLine.INSERT;

          ReservePlanningComponent.TransferPlanningCompToAsmLine(PlanningComponent,AsmLine,0,TRUE);
          AsmLine.AutoReserve;
          ReservMgt.SetAssemblyLine(AsmLine);
          ReservMgt.AutoTrack(AsmLine."Remaining Quantity (Base)");
        UNTIL PlanningComponent.NEXT = 0;
    END;

    [External]
    PROCEDURE InsertTransHeader@23(ReqLine@1000 : Record 246;VAR TransHeader@1001 : Record 5740);
    VAR
      InvtSetup@1002 : Record 313;
    BEGIN
      InvtSetup.GET;
      InvtSetup.TESTFIELD("Transfer Order Nos.");

      WITH ReqLine DO BEGIN
        TransHeader.INIT;
        TransHeader."No." := '';
        TransHeader."Posting Date" := WORKDATE;
        TransHeader.INSERT(TRUE);
        TransHeader.VALIDATE("Transfer-from Code","Transfer-from Code");
        TransHeader.VALIDATE("Transfer-to Code","Location Code");
        TransHeader."Receipt Date" := "Due Date";
        TransHeader."Shipment Date" := "Transfer Shipment Date";
        TransHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        TransHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        TransHeader."Dimension Set ID" := "Dimension Set ID";
        TransHeader.MODIFY;
        TempDocumentEntry.INIT;
        TempDocumentEntry."Table ID" := DATABASE::"Transfer Header";
        TempDocumentEntry."Document No." := TransHeader."No.";
        TempDocumentEntry."Entry No." := TempDocumentEntry.COUNT + 1;
        TempDocumentEntry.INSERT;
      END;

      IF PrintOrder THEN BEGIN
        TempTransHeaderToPrint."No." := TransHeader."No.";
        TempTransHeaderToPrint.INSERT;
      END;
    END;

    [External]
    PROCEDURE InsertTransLine@24(ReqLine@1000 : Record 246;VAR TransHeader@1001 : Record 5740);
    VAR
      TransLine@1002 : Record 5741;
      NextLineNo@1003 : Integer;
    BEGIN
      IF (ReqLine."Transfer-from Code" <> TransHeader."Transfer-from Code") OR
         (ReqLine."Location Code" <> TransHeader."Transfer-to Code")
      THEN
        InsertTransHeader(ReqLine,TransHeader);

      TransLine.SETRANGE("Document No.",TransHeader."No.");
      IF TransLine.FINDLAST THEN
        NextLineNo := TransLine."Line No." + 10000
      ELSE
        NextLineNo := 10000;

      TransLine.INIT;
      TransLine.BlockDynamicTracking(TRUE);
      TransLine."Document No." := TransHeader."No.";
      TransLine."Line No." := NextLineNo;
      TransLine.VALIDATE("Item No.",ReqLine."No.");
      TransLine.Description := ReqLine.Description;
      TransLine."Description 2" := ReqLine."Description 2";
      TransLine.VALIDATE("Variant Code",ReqLine."Variant Code");
      TransLine.VALIDATE("Transfer-from Code",ReqLine."Transfer-from Code");
      TransLine.VALIDATE("Transfer-to Code",ReqLine."Location Code");
      TransLine.VALIDATE(Quantity,ReqLine.Quantity);
      TransLine.VALIDATE("Unit of Measure Code",ReqLine."Unit of Measure Code");
      TransLine."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
      TransLine."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
      TransLine."Dimension Set ID" := ReqLine."Dimension Set ID";
      TransLine."Receipt Date" := ReqLine."Due Date";
      TransLine."Shipment Date" := ReqLine."Transfer Shipment Date";
      TransLine.VALIDATE("Planning Flexibility",ReqLine."Planning Flexibility");
      OnInsertTransLineWithReqLine(TransLine,ReqLine);
      TransLine.INSERT;

      ReqLineReserve.TransferReqLineToTransLine(ReqLine,TransLine,ReqLine."Quantity (Base)",FALSE);
      IF ReqLine.Reserve THEN
        ReserveBindingOrderToTrans(TransLine,ReqLine);
    END;

    [External]
    PROCEDURE PrintTransferOrders@34();
    BEGIN
      CarryOutAction.GetTransferOrdersToPrint(TempTransHeaderToPrint);
      IF TempTransHeaderToPrint.FINDSET THEN BEGIN
        PrintOrder := TRUE;
        REPEAT
          PrintTransferOrder(TempTransHeaderToPrint);
        UNTIL TempTransHeaderToPrint.NEXT = 0;

        TempTransHeaderToPrint.DELETEALL;
      END;
    END;

    [External]
    PROCEDURE PrintTransferOrder@13(TransHeader@1003 : Record 5740);
    VAR
      ReportSelection@1001 : Record 77;
      TransHeader2@1000 : Record 5740;
    BEGIN
      IF PrintOrder THEN BEGIN
        TransHeader2 := TransHeader;
        TransHeader2.SETRECFILTER;
        ReportSelection.PrintWithGUIYesNoWithCheck(ReportSelection.Usage::Inv1,TransHeader2,FALSE,0);
      END;
    END;

    [External]
    PROCEDURE PrintPurchaseOrder@19(PurchHeader@1000 : Record 38);
    VAR
      ReportSelection@1001 : Record 77;
      PurchHeader2@1002 : Record 38;
      PurchSetup@1003 : Record 312;
      PurchLine@1004 : Record 39;
    BEGIN
      IF PrintOrder AND (PurchHeader."Buy-from Vendor No." <> '') THEN BEGIN
        PurchHeader2 := PurchHeader;
        PurchSetup.GET;
        IF PurchSetup."Calc. Inv. Discount" THEN BEGIN
          PurchLine.RESET;
          PurchLine.SETRANGE("Document Type",PurchHeader."Document Type");
          PurchLine.SETRANGE("Document No.",PurchHeader."No.");
          PurchLine.FINDFIRST;
          CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",PurchLine);
        END;
        PurchHeader2.SETRECFILTER;
        ReportSelection.PrintWithGUIYesNoWithCheckVendor(
          ReportSelection.Usage::"P.Order",PurchHeader2,FALSE,PurchHeader2.FIELDNO("Buy-from Vendor No."));
      END;
    END;

    [External]
    PROCEDURE PrintAsmOrder@33(AsmHeader@1000 : Record 900);
    VAR
      ReportSelections@1005 : Record 77;
      AsmHeader2@1004 : Record 900;
    BEGIN
      IF PrintOrder AND (AsmHeader."Item No." <> '') THEN BEGIN
        AsmHeader2 := AsmHeader;
        AsmHeader2.SETRECFILTER;
        ReportSelections.PrintWithGUIYesNoWithCheck(ReportSelections.Usage::"Asm. Order",AsmHeader2,FALSE,0);
      END;
    END;

    LOCAL PROCEDURE FinalizeOrderHeader@16(ProdOrder@1000 : Record 5405);
    VAR
      ReportSelection@1001 : Record 77;
      ProdOrder2@1002 : Record 5405;
    BEGIN
      IF PrintOrder AND (ProdOrder."No." <> '') THEN BEGIN
        ProdOrder2 := ProdOrder;
        ProdOrder2.SETRECFILTER;
        ReportSelection.PrintWithGUIYesNoWithCheck(ReportSelection.Usage::"Prod. Order",ProdOrder2,FALSE,0);
      END;
    END;

    [External]
    PROCEDURE TransferRouting@14(ReqLine@1000 : Record 246;ProdOrder@1001 : Record 5405;RoutingNo@1002 : Code[20];RoutingRefNo@1003 : Integer) : Boolean;
    VAR
      WorkCenter@1004 : Record 99000754;
      MachineCenter@1005 : Record 99000758;
      PlanningRtngLine@1006 : Record 99000830;
      ProdOrderRtngLine@1007 : Record 5409;
      WMSManagement@1008 : Codeunit 7302;
      FlushingMethod@1009 : Option;
    BEGIN
      PlanningRtngLine.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningRtngLine.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningRtngLine.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      IF PlanningRtngLine.FIND('-') THEN
        REPEAT
          ProdOrderRtngLine.INIT;
          ProdOrderRtngLine.Status := ProdOrder.Status;
          ProdOrderRtngLine."Prod. Order No." := ProdOrder."No.";
          ProdOrderRtngLine."Routing No." := RoutingNo;
          ProdOrderRtngLine."Routing Reference No." := RoutingRefNo;
          ProdOrderRtngLine."Operation No." := PlanningRtngLine."Operation No.";
          ProdOrderRtngLine."Next Operation No." := PlanningRtngLine."Next Operation No.";
          ProdOrderRtngLine."Previous Operation No." := PlanningRtngLine."Previous Operation No.";
          ProdOrderRtngLine.Type := PlanningRtngLine.Type;
          ProdOrderRtngLine."No." := PlanningRtngLine."No.";
          ProdOrderRtngLine."Work Center No." := PlanningRtngLine."Work Center No.";
          ProdOrderRtngLine."Work Center Group Code" := PlanningRtngLine."Work Center Group Code";
          ProdOrderRtngLine.Description := PlanningRtngLine.Description;
          ProdOrderRtngLine."Setup Time" := PlanningRtngLine."Setup Time";
          ProdOrderRtngLine."Run Time" := PlanningRtngLine."Run Time";
          ProdOrderRtngLine."Wait Time" := PlanningRtngLine."Wait Time";
          ProdOrderRtngLine."Move Time" := PlanningRtngLine."Move Time";
          ProdOrderRtngLine."Fixed Scrap Quantity" := PlanningRtngLine."Fixed Scrap Quantity";
          ProdOrderRtngLine."Lot Size" := PlanningRtngLine."Lot Size";
          ProdOrderRtngLine."Scrap Factor %" := PlanningRtngLine."Scrap Factor %";
          ProdOrderRtngLine."Setup Time Unit of Meas. Code" := PlanningRtngLine."Setup Time Unit of Meas. Code";
          ProdOrderRtngLine."Run Time Unit of Meas. Code" := PlanningRtngLine."Run Time Unit of Meas. Code";
          ProdOrderRtngLine."Wait Time Unit of Meas. Code" := PlanningRtngLine."Wait Time Unit of Meas. Code";
          ProdOrderRtngLine."Move Time Unit of Meas. Code" := PlanningRtngLine."Move Time Unit of Meas. Code";
          ProdOrderRtngLine."Minimum Process Time" := PlanningRtngLine."Minimum Process Time";
          ProdOrderRtngLine."Maximum Process Time" := PlanningRtngLine."Maximum Process Time";
          ProdOrderRtngLine."Concurrent Capacities" := PlanningRtngLine."Concurrent Capacities";
          ProdOrderRtngLine."Send-Ahead Quantity" := PlanningRtngLine."Send-Ahead Quantity";
          ProdOrderRtngLine."Routing Link Code" := PlanningRtngLine."Routing Link Code";
          ProdOrderRtngLine."Standard Task Code" := PlanningRtngLine."Standard Task Code";
          ProdOrderRtngLine."Unit Cost per" := PlanningRtngLine."Unit Cost per";
          ProdOrderRtngLine.Recalculate := PlanningRtngLine.Recalculate;
          ProdOrderRtngLine."Sequence No. (Forward)" := PlanningRtngLine."Sequence No.(Forward)";
          ProdOrderRtngLine."Sequence No. (Backward)" := PlanningRtngLine."Sequence No.(Backward)";
          ProdOrderRtngLine."Fixed Scrap Qty. (Accum.)" := PlanningRtngLine."Fixed Scrap Qty. (Accum.)";
          ProdOrderRtngLine."Scrap Factor % (Accumulated)" := PlanningRtngLine."Scrap Factor % (Accumulated)";
          ProdOrderRtngLine."Sequence No. (Actual)" := PlanningRtngLine."Sequence No. (Actual)";
          ProdOrderRtngLine."Starting Time" := PlanningRtngLine."Starting Time";
          ProdOrderRtngLine."Starting Date" := PlanningRtngLine."Starting Date";
          ProdOrderRtngLine."Ending Time" := PlanningRtngLine."Ending Time";
          ProdOrderRtngLine."Ending Date" := PlanningRtngLine."Ending Date";
          ProdOrderRtngLine."Unit Cost Calculation" := PlanningRtngLine."Unit Cost Calculation";
          ProdOrderRtngLine."Input Quantity" := PlanningRtngLine."Input Quantity";
          ProdOrderRtngLine."Critical Path" := PlanningRtngLine."Critical Path";
          ProdOrderRtngLine."Direct Unit Cost" := PlanningRtngLine."Direct Unit Cost";
          ProdOrderRtngLine."Indirect Cost %" := PlanningRtngLine."Indirect Cost %";
          ProdOrderRtngLine."Overhead Rate" := PlanningRtngLine."Overhead Rate";
          CASE ProdOrderRtngLine.Type OF
            ProdOrderRtngLine.Type::"Work Center":
              BEGIN
                WorkCenter.GET(PlanningRtngLine."No.");
                ProdOrderRtngLine."Flushing Method" := WorkCenter."Flushing Method";
              END;
            ProdOrderRtngLine.Type::"Machine Center":
              BEGIN
                MachineCenter.GET(ProdOrderRtngLine."No.");
                ProdOrderRtngLine."Flushing Method" := MachineCenter."Flushing Method";
              END;
          END;
          ProdOrderRtngLine."Expected Operation Cost Amt." := PlanningRtngLine."Expected Operation Cost Amt.";
          ProdOrderRtngLine."Expected Capacity Ovhd. Cost" := PlanningRtngLine."Expected Capacity Ovhd. Cost";
          ProdOrderRtngLine."Expected Capacity Need" := PlanningRtngLine."Expected Capacity Need";

          ProdOrderRtngLine."Location Code" := ReqLine."Location Code";
          ProdOrderRtngLine."From-Production Bin Code" :=
            WMSManagement.GetProdCenterBinCode(PlanningRtngLine.Type,PlanningRtngLine."No.",ReqLine."Location Code",FALSE,0);

          FlushingMethod := ProdOrderRtngLine."Flushing Method";
          IF ProdOrderRtngLine."Flushing Method" = ProdOrderRtngLine."Flushing Method"::Manual THEN
            ProdOrderRtngLine."To-Production Bin Code" := WMSManagement.GetProdCenterBinCode(
                PlanningRtngLine.Type,PlanningRtngLine."No.",ReqLine."Location Code",TRUE,
                FlushingMethod)
          ELSE
            ProdOrderRtngLine."Open Shop Floor Bin Code" := WMSManagement.GetProdCenterBinCode(
                PlanningRtngLine.Type,PlanningRtngLine."No.",ReqLine."Location Code",TRUE,
                FlushingMethod);

          ProdOrderRtngLine.UpdateDatetime;
          OnAfterTransferPlanningRtngLine(PlanningRtngLine,ProdOrderRtngLine);
          ProdOrderRtngLine.INSERT;
          CalcProdOrder.TransferTaskInfo(ProdOrderRtngLine,ReqLine."Routing Version Code");
        UNTIL PlanningRtngLine.NEXT = 0;

      EXIT(NOT PlanningRtngLine.ISEMPTY);
    END;

    [External]
    PROCEDURE TransferBOM@11(ReqLine@1000 : Record 246;ProdOrder@1001 : Record 5405;ProdOrderLineNo@1002 : Integer);
    VAR
      PlanningComponent@1004 : Record 99000829;
      ProdOrderComp2@1005 : Record 5407;
    BEGIN
      PlanningComponent.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningComponent.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningComponent.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      IF PlanningComponent.FIND('-') THEN
        REPEAT
          ProdOrderComp2.INIT;
          ProdOrderComp2.Status := ProdOrder.Status;
          ProdOrderComp2."Prod. Order No." := ProdOrder."No.";
          ProdOrderComp2."Prod. Order Line No." := ProdOrderLineNo;
          ProdOrderComp2."Line No." := PlanningComponent."Line No.";
          ProdOrderComp2."Item No." := PlanningComponent."Item No.";
          ProdOrderComp2.Description := PlanningComponent.Description;
          ProdOrderComp2."Unit of Measure Code" := PlanningComponent."Unit of Measure Code";
          ProdOrderComp2."Quantity per" := PlanningComponent."Quantity per";
          ProdOrderComp2.Quantity := PlanningComponent.Quantity;
          ProdOrderComp2.Position := PlanningComponent.Position;
          ProdOrderComp2."Position 2" := PlanningComponent."Position 2";
          ProdOrderComp2."Position 3" := PlanningComponent."Position 3";
          ProdOrderComp2."Lead-Time Offset" := PlanningComponent."Lead-Time Offset";
          ProdOrderComp2."Routing Link Code" := PlanningComponent."Routing Link Code";
          ProdOrderComp2."Scrap %" := PlanningComponent."Scrap %";
          ProdOrderComp2."Variant Code" := PlanningComponent."Variant Code";
          ProdOrderComp2."Flushing Method" := PlanningComponent."Flushing Method";
          ProdOrderComp2."Location Code" := PlanningComponent."Location Code";
          IF  PlanningComponent."Bin Code" <> '' THEN
            ProdOrderComp2."Bin Code" := PlanningComponent."Bin Code"
          ELSE
            ProdOrderComp2.GetDefaultBin;
          ProdOrderComp2.Length := PlanningComponent.Length;
          ProdOrderComp2.Width := PlanningComponent.Width;
          ProdOrderComp2.Weight := PlanningComponent.Weight;
          ProdOrderComp2.Depth := PlanningComponent.Depth;
          ProdOrderComp2."Calculation Formula" := PlanningComponent."Calculation Formula";
          ProdOrderComp2."Qty. per Unit of Measure" := PlanningComponent."Qty. per Unit of Measure";
          ProdOrderComp2."Quantity (Base)" := PlanningComponent."Quantity (Base)";
          ProdOrderComp2."Due Date" := PlanningComponent."Due Date";
          ProdOrderComp2."Due Time" := PlanningComponent."Due Time";
          ProdOrderComp2."Unit Cost" := PlanningComponent."Unit Cost";
          ProdOrderComp2."Direct Unit Cost" := PlanningComponent."Direct Unit Cost";
          ProdOrderComp2."Indirect Cost %" := PlanningComponent."Indirect Cost %";
          ProdOrderComp2."Variant Code" := PlanningComponent."Variant Code";
          ProdOrderComp2."Overhead Rate" := PlanningComponent."Overhead Rate";
          ProdOrderComp2."Expected Quantity" := PlanningComponent."Expected Quantity";
          ProdOrderComp2."Expected Qty. (Base)" := PlanningComponent."Expected Quantity (Base)";
          ProdOrderComp2."Cost Amount" := PlanningComponent."Cost Amount";
          ProdOrderComp2."Overhead Amount" := PlanningComponent."Overhead Amount";
          ProdOrderComp2."Direct Cost Amount" := PlanningComponent."Direct Cost Amount";
          ProdOrderComp2."Planning Level Code" := PlanningComponent."Planning Level Code";
          IF ProdOrderComp2.Status IN [ProdOrderComp2.Status::Released,ProdOrderComp2.Status::Finished] THEN
            ProdOrderComp2.CALCFIELDS("Act. Consumption (Qty)");
          ProdOrderComp2."Remaining Quantity" :=
            ProdOrderComp2."Expected Quantity" - ProdOrderComp2."Act. Consumption (Qty)";
          ProdOrderComp2."Remaining Qty. (Base)" :=
            ROUND(ProdOrderComp2."Remaining Quantity" * ProdOrderComp2."Qty. per Unit of Measure",0.00001);
          ProdOrderComp2."Shortcut Dimension 1 Code" := PlanningComponent."Shortcut Dimension 1 Code";
          ProdOrderComp2."Shortcut Dimension 2 Code" := PlanningComponent."Shortcut Dimension 2 Code";
          ProdOrderComp2."Dimension Set ID" := PlanningComponent."Dimension Set ID";
          ProdOrderComp2.UpdateDatetime;
          OnAfterTransferPlanningComp(PlanningComponent,ProdOrderComp2);
          ProdOrderComp2.INSERT;
          ReservePlanningComponent.TransferPlanningCompToPOComp(PlanningComponent,ProdOrderComp2,0,TRUE);
          IF ProdOrderComp2.Status IN [ProdOrderComp2.Status::"Firm Planned",ProdOrderComp2.Status::Released] THEN
            ProdOrderComp2.AutoReserve;

          ReservMgt.SetProdOrderComponent(ProdOrderComp2);
          ReservMgt.AutoTrack(ProdOrderComp2."Remaining Qty. (Base)");
        UNTIL PlanningComponent.NEXT = 0;
    END;

    [External]
    PROCEDURE TransferCapNeed@10(ReqLine@1000 : Record 246;ProdOrder@1001 : Record 5405;RoutingNo@1002 : Code[20];RoutingRefNo@1005 : Integer);
    VAR
      ProdOrderCapNeed@1003 : Record 5410;
      NewProdOrderCapNeed@1004 : Record 5410;
    BEGIN
      ProdOrderCapNeed.SETCURRENTKEY("Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.");
      ProdOrderCapNeed.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      ProdOrderCapNeed.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      ProdOrderCapNeed.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      IF ProdOrderCapNeed.FIND('-') THEN
        REPEAT
          NewProdOrderCapNeed.INIT;
          NewProdOrderCapNeed := ProdOrderCapNeed;
          NewProdOrderCapNeed."Requested Only" := FALSE;
          NewProdOrderCapNeed.Status := ProdOrder.Status;
          NewProdOrderCapNeed."Prod. Order No." := ProdOrder."No.";
          NewProdOrderCapNeed."Routing No." := RoutingNo;
          NewProdOrderCapNeed."Routing Reference No." := RoutingRefNo;
          NewProdOrderCapNeed."Worksheet Template Name" := '';
          NewProdOrderCapNeed."Worksheet Batch Name" := '';
          NewProdOrderCapNeed."Worksheet Line No." := 0;
          NewProdOrderCapNeed.UpdateDatetime;
          NewProdOrderCapNeed.INSERT;
        UNTIL ProdOrderCapNeed.NEXT = 0;
    END;

    [External]
    PROCEDURE UpdateComponentLink@15(ProdOrderLine@1000 : Record 5406);
    VAR
      ProdOrderComp@1001 : Record 5407;
    BEGIN
      ProdOrderComp.SETCURRENTKEY(Status,"Prod. Order No.","Prod. Order Line No.","Item No.");
      ProdOrderComp.SETRANGE(Status,ProdOrderLine.Status);
      ProdOrderComp.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
      ProdOrderComp.SETRANGE("Item No.",ProdOrderLine."Item No.");
      IF ProdOrderComp.FIND('-') THEN
        REPEAT
          ProdOrderComp."Supplied-by Line No." := ProdOrderLine."Line No.";
          ProdOrderComp.MODIFY;
        UNTIL ProdOrderComp.NEXT = 0;
    END;

    PROCEDURE SetCreatedDocumentBuffer@37(VAR TempDocumentEntryNew@1000 : TEMPORARY Record 265);
    BEGIN
      TempDocumentEntry.COPY(TempDocumentEntryNew,TRUE);
    END;

    LOCAL PROCEDURE InsertTempProdOrder@5(VAR RequisitionLine@1000 : Record 246;VAR NewProdOrder@1001 : Record 5405);
    BEGIN
      IF TempProductionOrder.GET(NewProdOrder.Status,NewProdOrder."No.") THEN
        EXIT;

      TempDocumentEntry.INIT;
      TempDocumentEntry."Table ID" := DATABASE::"Production Order";
      TempDocumentEntry."Document Type" := NewProdOrder.Status;
      TempDocumentEntry."Document No." := NewProdOrder."No.";
      TempDocumentEntry."Entry No." := TempDocumentEntry.COUNT + 1;
      TempDocumentEntry.INSERT;

      TempProductionOrder := NewProdOrder;
      IF RequisitionLine."Ref. Order Status" = RequisitionLine."Ref. Order Status"::Planned THEN BEGIN
        TempProductionOrder."Planned Order No." := RequisitionLine."Ref. Order No.";
        TempProductionOrder.INSERT;
      END;
    END;

    LOCAL PROCEDURE FindTempProdOrder@12(VAR RequisitionLine@1000 : Record 246) : Boolean;
    BEGIN
      IF RequisitionLine."Ref. Order Status" = RequisitionLine."Ref. Order Status"::Planned THEN BEGIN
        TempProductionOrder.SETRANGE("Planned Order No.",RequisitionLine."Ref. Order No.");
        EXIT(TempProductionOrder.FINDFIRST);
      END;
    END;

    [External]
    PROCEDURE SetPrintOrder@18(OrderPrinting@1000 : Boolean);
    BEGIN
      PrintOrder := OrderPrinting;
    END;

    [External]
    PROCEDURE SetSplitTransferOrders@31(Split@1000 : Boolean);
    BEGIN
      SplitTransferOrders := Split;
    END;

    [External]
    PROCEDURE ReserveBindingOrderToProd@2(VAR ProdOrderLine@1005 : Record 5406;VAR ReqLine@1000 : Record 246);
    VAR
      SalesLine@1004 : Record 37;
      ProdOrderComp@1006 : Record 5407;
      AsmLine@1011 : Record 901;
      SalesLineReserve@1002 : Codeunit 99000832;
      ProdOrderCompReserve@1007 : Codeunit 99000838;
      AsmLineReserve@1008 : Codeunit 926;
      ReservQty@1009 : Decimal;
      ReservQtyBase@1001 : Decimal;
    BEGIN
      ProdOrderLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
      IF ProdOrderLine."Remaining Qty. (Base)" - ProdOrderLine."Reserved Qty. (Base)" >
         ReqLine."Demand Quantity (Base)"
      THEN BEGIN
        ReservQty := ReqLine."Demand Quantity";
        ReservQtyBase := ReqLine."Demand Quantity (Base)";
      END ELSE BEGIN
        ReservQty := ProdOrderLine."Remaining Quantity" - ProdOrderLine."Reserved Quantity";
        ReservQtyBase := ProdOrderLine."Remaining Qty. (Base)" - ProdOrderLine."Reserved Qty. (Base)";
      END;

      CASE ReqLine."Demand Type" OF
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrderComp.GET(
              ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.",ReqLine."Demand Ref. No.");
            ProdOrderCompReserve.BindToProdOrder(ProdOrderComp,ProdOrderLine,ReservQty,ReservQtyBase);
          END;
        DATABASE::"Sales Line":
          BEGIN
            SalesLine.GET(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
            SalesLineReserve.BindToProdOrder(SalesLine,ProdOrderLine,ReservQty,ReservQtyBase);
            IF SalesLine.Reserve = SalesLine.Reserve::Never THEN BEGIN
              SalesLine.Reserve := SalesLine.Reserve::Optional;
              SalesLine.MODIFY;
            END;
          END;
        DATABASE::"Assembly Line":
          BEGIN
            AsmLine.GET(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
            AsmLineReserve.BindToProdOrder(AsmLine,ProdOrderLine,ReservQty,ReservQtyBase);
            IF AsmLine.Reserve = AsmLine.Reserve::Never THEN BEGIN
              AsmLine.Reserve := AsmLine.Reserve::Optional;
              AsmLine.MODIFY;
            END;
          END;
      END;
      ProdOrderLine.MODIFY;
    END;

    [External]
    PROCEDURE ReserveBindingOrderToTrans@7(VAR TransLine@1005 : Record 5741;VAR ReqLine@1000 : Record 246);
    VAR
      ProdOrderComp@1004 : Record 5407;
      SalesLine@1007 : Record 37;
      AsmLine@1012 : Record 901;
      ProdOrderCompReserve@1002 : Codeunit 99000838;
      SalesLineReserve@1008 : Codeunit 99000832;
      AsmLineReserve@1011 : Codeunit 926;
      ReservQty@1009 : Decimal;
      ReservQtyBase@1001 : Decimal;
    BEGIN
      TransLine.CALCFIELDS("Reserved Quantity Inbnd.","Reserved Qty. Inbnd. (Base)");
      IF (TransLine."Outstanding Qty. (Base)" - TransLine."Reserved Qty. Inbnd. (Base)") > ReqLine."Demand Quantity (Base)" THEN BEGIN
        ReservQty := ReqLine."Demand Quantity";
        ReservQtyBase := ReqLine."Demand Quantity (Base)";
      END ELSE BEGIN
        ReservQty := TransLine."Outstanding Quantity" - TransLine."Reserved Quantity Inbnd.";
        ReservQtyBase := TransLine."Outstanding Qty. (Base)" - TransLine."Reserved Qty. Inbnd. (Base)";
      END;

      CASE ReqLine."Demand Type" OF
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrderComp.GET(
              ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.",ReqLine."Demand Ref. No.");
            ProdOrderCompReserve.BindToTransfer(ProdOrderComp,TransLine,ReservQty,ReservQtyBase);
          END;
        DATABASE::"Sales Line":
          BEGIN
            SalesLine.GET(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
            SalesLineReserve.BindToTransfer(SalesLine,TransLine,ReservQty,ReservQtyBase);
            IF SalesLine.Reserve = SalesLine.Reserve::Never THEN BEGIN
              SalesLine.Reserve := SalesLine.Reserve::Optional;
              SalesLine.MODIFY;
            END;
          END;
        DATABASE::"Assembly Line":
          BEGIN
            AsmLine.GET(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
            AsmLineReserve.BindToTransfer(AsmLine,TransLine,ReservQty,ReservQtyBase);
            IF AsmLine.Reserve = AsmLine.Reserve::Never THEN BEGIN
              AsmLine.Reserve := AsmLine.Reserve::Optional;
              AsmLine.MODIFY;
            END;
          END;
      END;
      TransLine.MODIFY;
    END;

    [External]
    PROCEDURE ReserveBindingOrderToAsm@29(VAR AsmHeader@1005 : Record 900;VAR ReqLine@1000 : Record 246);
    VAR
      SalesLine@1004 : Record 37;
      ProdOrderComp@1006 : Record 5407;
      AsmLine@1013 : Record 901;
      SalesLineReserve@1002 : Codeunit 99000832;
      ProdOrderCompReserve@1007 : Codeunit 99000838;
      AsmLineReserve@1012 : Codeunit 926;
      ReservQty@1008 : Decimal;
      ReservQtyBase@1001 : Decimal;
    BEGIN
      AsmHeader.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
      IF AsmHeader."Remaining Quantity (Base)" - AsmHeader."Reserved Qty. (Base)" >
         ReqLine."Demand Quantity (Base)"
      THEN BEGIN
        ReservQty := ReqLine."Demand Quantity";
        ReservQtyBase := ReqLine."Demand Quantity (Base)";
      END ELSE BEGIN
        ReservQty := AsmHeader."Remaining Quantity" - AsmHeader."Reserved Quantity";
        ReservQtyBase := AsmHeader."Remaining Quantity (Base)" - AsmHeader."Reserved Qty. (Base)";
      END;

      CASE ReqLine."Demand Type" OF
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrderComp.GET(
              ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.",ReqLine."Demand Ref. No.");
            ProdOrderCompReserve.BindToAssembly(ProdOrderComp,AsmHeader,ReservQty,ReservQtyBase);
          END;
        DATABASE::"Sales Line":
          BEGIN
            SalesLine.GET(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
            SalesLineReserve.BindToAssembly(SalesLine,AsmHeader,ReservQty,ReservQtyBase);
            IF SalesLine.Reserve = SalesLine.Reserve::Never THEN BEGIN
              SalesLine.Reserve := SalesLine.Reserve::Optional;
              SalesLine.MODIFY;
            END;
          END;
        DATABASE::"Assembly Line":
          BEGIN
            AsmLine.GET(ReqLine."Demand Subtype",ReqLine."Demand Order No.",ReqLine."Demand Line No.");
            AsmLineReserve.BindToAssembly(AsmLine,AsmHeader,ReservQty,ReservQtyBase);
            IF AsmLine.Reserve = AsmLine.Reserve::Never THEN BEGIN
              AsmLine.Reserve := AsmLine.Reserve::Optional;
              AsmLine.MODIFY;
            END;
          END;
      END;
      AsmHeader.MODIFY;
    END;

    [External]
    PROCEDURE ReserveBindingOrderToReqline@30(VAR DemandReqLine@1000 : Record 246;VAR SupplyReqLine@1001 : Record 246);
    VAR
      ProdOrderComp@1002 : Record 5407;
      SalesLine@1003 : Record 37;
      ServiceLine@1008 : Record 5902;
      ProdOrderCompReserve@1005 : Codeunit 99000838;
      SalesLineReserve@1006 : Codeunit 99000832;
      ServiceLineReserve@1009 : Codeunit 99000842;
    BEGIN
      CASE SupplyReqLine."Demand Type" OF
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrderComp.GET(
              SupplyReqLine."Demand Subtype",SupplyReqLine."Demand Order No.",SupplyReqLine."Demand Line No.",
              SupplyReqLine."Demand Ref. No.");
            ProdOrderCompReserve.BindToRequisition(
              ProdOrderComp,DemandReqLine,SupplyReqLine."Demand Quantity",SupplyReqLine."Demand Quantity (Base)");
          END;
        DATABASE::"Sales Line":
          BEGIN
            SalesLine.GET(SupplyReqLine."Demand Subtype",SupplyReqLine."Demand Order No.",SupplyReqLine."Demand Line No.");
            IF (SalesLine.Reserve = SalesLine.Reserve::Never) AND NOT SalesLine."Drop Shipment" THEN BEGIN
              SalesLine.Reserve := SalesLine.Reserve::Optional;
              SalesLine.MODIFY;
            END;
            SalesLineReserve.BindToRequisition(
              SalesLine,DemandReqLine,SupplyReqLine."Demand Quantity",SupplyReqLine."Demand Quantity (Base)");
          END;
        DATABASE::"Service Line":
          BEGIN
            ServiceLine.GET(SupplyReqLine."Demand Subtype",SupplyReqLine."Demand Order No.",SupplyReqLine."Demand Line No.");
            ServiceLineReserve.BindToRequisition(
              ServiceLine,DemandReqLine,SupplyReqLine."Demand Quantity",SupplyReqLine."Demand Quantity (Base)");
          END;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertProdOrderLine@45(ReqLine@1000 : Record 246;ProdOrder@1001 : Record 5405;VAR ProdOrderLine@1002 : Record 5406;Item@1003 : Record 27);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterInsertAsmHeader@46(VAR ReqLine@1000 : Record 246;VAR AsmHeader@1001 : Record 900);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferAsmPlanningComp@47(VAR PlanningComponent@1000 : Record 99000829;VAR AssemblyLine@1001 : Record 901);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferPlanningRtngLine@48(VAR PlanningRtngLine@1000 : Record 99000830;VAR ProdOrderRtngLine@1001 : Record 5409);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferPlanningComp@49(VAR PlanningComponent@1000 : Record 99000829;VAR ProdOrderComponent@1001 : Record 5407);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnInsertProdOrderWithReqLine@50(VAR ProductionOrder@1000 : Record 5405;VAR RequisitionLine@1001 : Record 246);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnInsertProdOrderLineWithReqLine@51(VAR ProdOrderLine@1000 : Record 5406;VAR RequisitionLine@1001 : Record 246);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnInsertTransLineWithReqLine@52(VAR TransferLine@1000 : Record 5741;VAR RequisitionLine@1001 : Record 246);
    BEGIN
    END;

    BEGIN
    END.
  }
}

