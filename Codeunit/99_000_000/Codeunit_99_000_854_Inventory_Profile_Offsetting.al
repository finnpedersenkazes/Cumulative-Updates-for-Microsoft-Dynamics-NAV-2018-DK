OBJECT Codeunit 99000854 Inventory Profile Offsetting
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    Permissions=TableData 337=id;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      ReqLine@1003 : Record 246;
      ItemLedgEntry@1004 : Record 32;
      TempSKU@1005 : TEMPORARY Record 5700;
      TempTransferSKU@1035 : TEMPORARY Record 5700;
      ManufacturingSetup@1007 : Record 99000765;
      InvtSetup@1008 : Record 313;
      ReservEntry@1009 : Record 337;
      TempTrkgReservEntry@1010 : TEMPORARY Record 337;
      TempItemTrkgEntry@1000 : TEMPORARY Record 337;
      ActionMsgEntry@1011 : Record 99000849;
      TempPlanningCompList@1013 : TEMPORARY Record 99000829;
      DummyInventoryProfileTrackBuffer@1048 : Record 99000854;
      CustomizedCalendarChange@1047 : Record 7602;
      CalendarManagement@1012 : Codeunit 7600;
      LeadTimeMgt@1014 : Codeunit 5404;
      PlngLnMgt@1031 : Codeunit 99000809;
      Transparency@1034 : Codeunit 99000856;
      BucketSize@1041 : DateFormula;
      ExcludeForecastBefore@1006 : Date;
      ScheduleDirection@1025 : 'Forward,Backward';
      PlanningLineStage@1022 : ' ,Line Created,Routing Created,Exploded,Obsolete';
      SurplusType@1021 : 'None,Forecast,BlanketOrder,SafetyStock,ReorderPoint,MaxInventory,FixedOrderQty,MaxOrder,MinOrder,OrderMultiple,DampenerQty,PlanningFlexibility,Undefined,EmergencyOrder';
      CurrWorksheetType@1049 : 'Requisition,Planning';
      DampenerQty@1020 : Decimal;
      FutureSupplyWithinLeadtime@1044 : Decimal;
      LineNo@1019 : Integer;
      DampenersDays@1018 : Integer;
      BucketSizeInDays@1042 : Integer;
      CurrTemplateName@1016 : Code[10];
      CurrWorksheetName@1017 : Code[10];
      CurrForecast@1028 : Code[10];
      PlanMRP@1023 : Boolean;
      SpecificLotTracking@1001 : Boolean;
      SpecificSNTracking@1024 : Boolean;
      Text001@1029 : TextConst 'DAN=Programfejl: %1.;ENU=Assertion failed: %1.';
      UseParm@1030 : Boolean;
      PlanningResilicency@1002 : Boolean;
      Text002@1033 : TextConst 'DAN=%1 fra ''%2'' til ''%3'' findes ikke.;ENU=The %1 from ''%2'' to ''%3'' does not exist.';
      Text003@1032 : TextConst 'DAN=%1 for %2 %3 %4 %5 findes ikke.;ENU=The %1 for %2 %3 %4 %5 does not exist.';
      Text004@1026 : TextConst 'DAN=%1 m� ikke v�re %2 i %3 %4 %5 %6, n�r %7 er %8.;ENU=%1 must not be %2 in %3 %4 %5 %6 when %7 is %8.';
      Text005@1027 : TextConst 'DAN=%1 m� ikke v�re %2 i %3 %4, n�r %5 er %6.;ENU=%1 must not be %2 in %3 %4 when %5 is %6.';
      Text006@1037 : TextConst 'DAN=%1: Den forventede disponible beholdning er %2 p� den planlagte startdato, %3.;ENU=%1: The projected available inventory is %2 on the planning starting date %3.';
      Text007@1038 : TextConst 'DAN=%1: Den forventede disponible beholdning er under %2 %3 den %4.;ENU=%1: The projected available inventory is below %2 %3 on %4.';
      Text008@1039 : TextConst 'DAN=%1: %2 %3 er f�r arbejdsdatoen %4.;ENU=%1: The %2 %3 is before the work date %4.';
      Text009@1040 : TextConst 'DAN=%1: %2 for %3 %4 er %5.;ENU=%1: The %2 of %3 %4 is %5.';
      Text010@1043 : TextConst 'DAN=Den planlagte beholdning %1 er st�rre end overl�bsniveauet %2 p� %3.;ENU=The projected inventory %1 is higher than the overflow level %2 on %3.';
      PlanToDate@1045 : Date;
      OverflowLevel@1046 : Decimal;
      ExceedROPqty@1015 : Decimal;
      NextStateTxt@1036 : TextConst 'DAN=StartOver,MatchDates,MatchQty,CreateSupply,ReduceSupply,CloseDemand,CloseSupply,CloseLoop;ENU=StartOver,MatchDates,MatchQty,CreateSupply,ReduceSupply,CloseDemand,CloseSupply,CloseLoop';
      NextState@1050 : 'StartOver,MatchDates,MatchQty,CreateSupply,ReduceSupply,CloseDemand,CloseSupply,CloseLoop';
      LotAccumulationPeriodStartDate@1051 : Date;

    [Internal]
    PROCEDURE CalculatePlanFromWorksheet@3(VAR Item@1000 : Record 27;ManufacturingSetup2@1001 : Record 99000765;TemplateName@1002 : Code[10];WorksheetName@1003 : Code[10];OrderDate@1004 : Date;ToDate@1005 : Date;MRPPlanning@1006 : Boolean;RespectPlanningParm@1008 : Boolean);
    VAR
      InventoryProfile@1007 : ARRAY [2] OF TEMPORARY Record 99000853;
    BEGIN
      PlanToDate := ToDate;
      InitVariables(InventoryProfile[1],ManufacturingSetup2,Item,TemplateName,WorksheetName,MRPPlanning);
      DemandtoInvProfile(InventoryProfile[1],Item,ToDate);
      OrderDate := ForecastConsumption(InventoryProfile[1],Item,OrderDate,ToDate);
      BlanketOrderConsump(InventoryProfile[1],Item,ToDate);
      SupplytoInvProfile(InventoryProfile[1],Item,ToDate);
      UnfoldItemTracking(InventoryProfile[1],InventoryProfile[2]);
      FindCombination(InventoryProfile[1],InventoryProfile[2],Item);
      PlanItem(InventoryProfile[1],InventoryProfile[2],OrderDate,ToDate,RespectPlanningParm);
      CommitTracking;
    END;

    LOCAL PROCEDURE InitVariables@12(VAR InventoryProfile@1000 : Record 99000853;ManufacturingSetup2@1001 : Record 99000765;Item@1006 : Record 27;TemplateName@1002 : Code[10];WorksheetName@1003 : Code[10];MRPPlanning@1005 : Boolean);
    VAR
      ItemTrackingCode@1007 : Record 6502;
    BEGIN
      ManufacturingSetup := ManufacturingSetup2;
      InvtSetup.GET;
      CurrTemplateName := TemplateName;
      CurrWorksheetName := WorksheetName;
      InventoryProfile.RESET;
      InventoryProfile.DELETEALL;
      TempSKU.RESET;
      TempSKU.DELETEALL;
      CLEAR(TempSKU);
      TempTransferSKU.RESET;
      TempTransferSKU.DELETEALL;
      CLEAR(TempTransferSKU);
      TempTrkgReservEntry.RESET;
      TempTrkgReservEntry.DELETEALL;
      TempItemTrkgEntry.RESET;
      TempItemTrkgEntry.DELETEALL;
      PlanMRP := MRPPlanning;
      IF Item."Item Tracking Code" <> '' THEN BEGIN
        ItemTrackingCode.GET(Item."Item Tracking Code");
        SpecificLotTracking := ItemTrackingCode."Lot Specific Tracking";
        SpecificSNTracking := ItemTrackingCode."SN Specific Tracking";
      END ELSE BEGIN
        SpecificLotTracking := FALSE;
        SpecificSNTracking := FALSE;
      END;
      LineNo := 0; // Global variable
      Transparency.SetTemplAndWorksheet(CurrTemplateName,CurrWorksheetName);
    END;

    LOCAL PROCEDURE CreateTempSKUForLocation@115(ItemNo@1000 : Code[20];LocationCode@1001 : Code[10]);
    BEGIN
      TempSKU.INIT;
      TempSKU."Item No." := ItemNo;
      TransferPlanningParameters(TempSKU);
      TempSKU."Location Code" := LocationCode;
      TempSKU.INSERT;
    END;

    LOCAL PROCEDURE DemandtoInvProfile@6(VAR InventoryProfile@1000 : Record 99000853;VAR Item@1001 : Record 27;ToDate@1003 : Date);
    VAR
      CopyOfItem@1002 : Record 27;
    BEGIN
      InventoryProfile.SETCURRENTKEY("Line No.");

      CopyOfItem.COPY(Item);
      Item.SETRANGE("Date Filter",0D,ToDate);

      TransSalesLineToProfile(InventoryProfile,Item);
      TransServLineToProfile(InventoryProfile,Item);
      TransJobPlanningLineToProfile(InventoryProfile,Item);
      TransProdOrderCompToProfile(InventoryProfile,Item);
      TransAsmLineToProfile(InventoryProfile,Item);
      TransPlanningCompToProfile(InventoryProfile,Item);
      TransTransReqLineToProfile(InventoryProfile,Item,ToDate);
      TransShptTransLineToProfile(InventoryProfile,Item);

      OnAfterDemandToInvProfile(InventoryProfile,Item,TempItemTrkgEntry,LineNo);

      Item.COPY(CopyOfItem);
    END;

    LOCAL PROCEDURE SupplytoInvProfile@9(VAR InventoryProfile@1000 : Record 99000853;VAR Item@1001 : Record 27;ToDate@1002 : Date);
    VAR
      CopyOfItem@1003 : Record 27;
    BEGIN
      InventoryProfile.RESET;
      ItemLedgEntry.RESET;
      InventoryProfile.SETCURRENTKEY("Line No.");

      CopyOfItem.COPY(Item);
      Item.SETRANGE("Date Filter");

      TransItemLedgEntryToProfile(InventoryProfile,Item);
      TransReqLineToProfile(InventoryProfile,Item,ToDate);
      TransPurchLineToProfile(InventoryProfile,Item,ToDate);
      TransProdOrderToProfile(InventoryProfile,Item,ToDate);
      TransAsmHeaderToProfile(InventoryProfile,Item,ToDate);
      TransRcptTransLineToProfile(InventoryProfile,Item,ToDate);

      OnAfterSupplyToInvProfile(InventoryProfile,Item,ToDate,TempItemTrkgEntry,LineNo);

      Item.COPY(CopyOfItem);
    END;

    LOCAL PROCEDURE InsertSupplyProfile@22(VAR InventoryProfile@1002 : Record 99000853;ToDate@1000 : Date);
    BEGIN
      IF InventoryProfile.IsSupply THEN BEGIN
        IF InventoryProfile."Due Date" > ToDate THEN
          InventoryProfile."Planning Flexibility" := InventoryProfile."Planning Flexibility"::None;
        InventoryProfile.INSERT;
      END ELSE
        IF InventoryProfile."Due Date" <= ToDate THEN BEGIN
          InventoryProfile.ChangeSign;
          InventoryProfile."Planning Flexibility" := InventoryProfile."Planning Flexibility"::None;
          InventoryProfile.INSERT;
        END;
    END;

    LOCAL PROCEDURE TransSalesLineToProfile@55(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27);
    VAR
      SalesLine@1007 : Record 37;
    BEGIN
      IF SalesLine.FindLinesWithItemToPlan(Item,SalesLine."Document Type"::Order) THEN
        REPEAT
          IF SalesLine."Shipment Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile.TransferFromSalesLine(SalesLine,TempItemTrkgEntry);
            IF InventoryProfile.IsSupply THEN
              InventoryProfile.ChangeSign;
            InventoryProfile."MPS Order" := TRUE;
            InventoryProfile.INSERT;
          END;
        UNTIL SalesLine.NEXT = 0;

      IF SalesLine.FindLinesWithItemToPlan(Item,SalesLine."Document Type"::"Return Order") THEN
        REPEAT
          IF SalesLine."Shipment Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile.TransferFromSalesLine(SalesLine,TempItemTrkgEntry);
            IF InventoryProfile.IsSupply THEN
              InventoryProfile.ChangeSign;
            InventoryProfile.INSERT;
          END;
        UNTIL SalesLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransServLineToProfile@56(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27);
    VAR
      ServLine@1006 : Record 5902;
    BEGIN
      IF ServLine.FindLinesWithItemToPlan(Item) THEN
        REPEAT
          IF ServLine."Needed by Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile.TransferFromServLine(ServLine,TempItemTrkgEntry);
            IF InventoryProfile.IsSupply THEN
              InventoryProfile.ChangeSign;
            InventoryProfile.INSERT;
          END;
        UNTIL ServLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransJobPlanningLineToProfile@121(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27);
    VAR
      JobPlanningLine@1005 : Record 1003;
    BEGIN
      IF JobPlanningLine.FindLinesWithItemToPlan(Item) THEN
        REPEAT
          IF JobPlanningLine."Planning Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile.TransferFromJobPlanningLine(JobPlanningLine,TempItemTrkgEntry);
            IF InventoryProfile.IsSupply THEN
              InventoryProfile.ChangeSign;
            InventoryProfile.INSERT;
          END;
        UNTIL JobPlanningLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransProdOrderCompToProfile@70(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27);
    VAR
      ProdOrderComp@1004 : Record 5407;
    BEGIN
      IF ProdOrderComp.FindLinesWithItemToPlan(Item,TRUE) THEN
        REPEAT
          IF ProdOrderComp."Due Date" <> 0D THEN BEGIN
            ReqLine.SetRefFilter(
              ReqLine."Ref. Order Type"::"Prod. Order",ProdOrderComp.Status,
              ProdOrderComp."Prod. Order No.",ProdOrderComp."Prod. Order Line No.");
            ReqLine.SETRANGE("Operation No.",'');
            IF NOT ReqLine.FINDFIRST THEN BEGIN
              InventoryProfile.INIT;
              InventoryProfile."Line No." := NextLineNo;
              InventoryProfile.TransferFromComponent(ProdOrderComp,TempItemTrkgEntry);
              IF InventoryProfile.IsSupply THEN
                InventoryProfile.ChangeSign;
              InventoryProfile.INSERT;
            END;
          END;
        UNTIL ProdOrderComp.NEXT = 0;
    END;

    LOCAL PROCEDURE TransPlanningCompToProfile@74(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27);
    VAR
      PlanningComponent@1003 : Record 99000829;
    BEGIN
      IF NOT PlanMRP THEN
        EXIT;

      IF PlanningComponent.FindLinesWithItemToPlan(Item) THEN
        REPEAT
          IF PlanningComponent."Due Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile."Item No." := Item."No.";
            InventoryProfile.TransferFromPlanComponent(PlanningComponent,TempItemTrkgEntry);
            IF InventoryProfile.IsSupply THEN
              InventoryProfile.ChangeSign;
            InventoryProfile.INSERT;
          END;
        UNTIL PlanningComponent.NEXT = 0;
    END;

    LOCAL PROCEDURE TransAsmLineToProfile@90(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27);
    VAR
      AsmHeader@1006 : Record 900;
      AsmLine@1007 : Record 901;
      RemRatio@1005 : Decimal;
    BEGIN
      IF AsmLine.FindLinesWithItemToPlan(Item,AsmLine."Document Type"::Order) THEN
        REPEAT
          IF AsmLine."Due Date" <> 0D THEN BEGIN
            ReqLine.SetRefFilter(
              ReqLine."Ref. Order Type"::Assembly,AsmLine."Document Type",AsmLine."Document No.",0);
            ReqLine.SETRANGE("Operation No.",'');
            IF NOT ReqLine.FINDFIRST THEN
              InsertAsmLineToProfile(InventoryProfile,AsmLine,1);
          END;
        UNTIL AsmLine.NEXT = 0;

      IF AsmLine.FindLinesWithItemToPlan(Item,AsmLine."Document Type"::"Blanket Order") THEN
        REPEAT
          IF AsmLine."Due Date" <> 0D THEN BEGIN
            ReqLine.SetRefFilter(ReqLine."Ref. Order Type"::Assembly,AsmLine."Document Type",AsmLine."Document No.",0);
            ReqLine.SETRANGE("Operation No.",'');
            IF NOT ReqLine.FINDFIRST THEN BEGIN
              AsmHeader.GET(AsmLine."Document Type",AsmLine."Document No.");
              RemRatio := (AsmHeader."Quantity (Base)" - CalcSalesOrderQty(AsmLine)) / AsmHeader."Quantity (Base)";
              InsertAsmLineToProfile(InventoryProfile,AsmLine,RemRatio);
            END;
          END;
        UNTIL AsmLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransTransReqLineToProfile@85(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27;ToDate@1003 : Date);
    VAR
      TransferReqLine@1002 : Record 246;
    BEGIN
      TransferReqLine.SETCURRENTKEY("Replenishment System",Type,"No.","Variant Code","Transfer-from Code","Transfer Shipment Date");
      TransferReqLine.SETRANGE("Replenishment System",TransferReqLine."Replenishment System"::Transfer);
      TransferReqLine.SETRANGE(Type,TransferReqLine.Type::Item);
      TransferReqLine.SETRANGE("No.",Item."No.");
      Item.COPYFILTER("Location Filter",TransferReqLine."Transfer-from Code");
      Item.COPYFILTER("Variant Filter",TransferReqLine."Variant Code");
      TransferReqLine.SETFILTER("Transfer Shipment Date",'>%1&<=%2',0D,ToDate);
      IF TransferReqLine.FINDSET THEN
        REPEAT
          InventoryProfile.INIT;
          InventoryProfile."Line No." := NextLineNo;
          InventoryProfile."Item No." := Item."No.";
          InventoryProfile.TransferFromOutboundTransfPlan(TransferReqLine,TempItemTrkgEntry);
          IF InventoryProfile.IsSupply THEN
            InventoryProfile.ChangeSign;
          InventoryProfile.INSERT;
        UNTIL TransferReqLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransShptTransLineToProfile@75(VAR InventoryProfile@1003 : Record 99000853;VAR Item@1002 : Record 27);
    VAR
      TransLine@1001 : Record 5741;
      FilterIsSetOnLocation@1000 : Boolean;
    BEGIN
      FilterIsSetOnLocation := Item.GETFILTER("Location Filter") <> '';
      IF TransLine.FindLinesWithItemToPlan(Item,FALSE,TRUE) THEN
        REPEAT
          IF TransLine."Shipment Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile."Item No." := Item."No.";
            InventoryProfile.TransferFromOutboundTransfer(TransLine,TempItemTrkgEntry);
            IF InventoryProfile.IsSupply THEN
              InventoryProfile.ChangeSign;
            IF FilterIsSetOnLocation THEN
              InventoryProfile."Transfer Location Not Planned" := TransferLocationIsFilteredOut(Item,TransLine);
            SyncTransferDemandWithReqLine(InventoryProfile,TransLine."Transfer-to Code");
            InventoryProfile.INSERT;
          END;
        UNTIL TransLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransItemLedgEntryToProfile@76(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27);
    BEGIN
      IF ItemLedgEntry.FindLinesWithItemToPlan(Item,FALSE) THEN
        REPEAT
          InventoryProfile.INIT;
          InventoryProfile."Line No." := NextLineNo;
          InventoryProfile.TransferFromItemLedgerEntry(ItemLedgEntry,TempItemTrkgEntry);
          InventoryProfile."Due Date" := 0D;
          IF NOT InventoryProfile.IsSupply THEN
            InventoryProfile.ChangeSign;
          InventoryProfile.INSERT;
        UNTIL ItemLedgEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE TransReqLineToProfile@78(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27;ToDate@1002 : Date);
    VAR
      ReqLine@1003 : Record 246;
    BEGIN
      IF ReqLine.FindLinesWithItemToPlan(Item) THEN
        REPEAT
          IF ReqLine."Due Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile."Item No." := Item."No.";
            InventoryProfile.TransferFromRequisitionLine(ReqLine,TempItemTrkgEntry);
            InsertSupplyProfile(InventoryProfile,ToDate);
          END;
        UNTIL ReqLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransPurchLineToProfile@79(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27;ToDate@1002 : Date);
    VAR
      PurchLine@1009 : Record 39;
    BEGIN
      IF PurchLine.FindLinesWithItemToPlan(Item,PurchLine."Document Type"::Order) THEN
        REPEAT
          IF PurchLine."Expected Receipt Date" <> 0D THEN
            IF PurchLine."Prod. Order No." = '' THEN
              InsertPurchLineToProfile(InventoryProfile,PurchLine,ToDate);
        UNTIL PurchLine.NEXT = 0;

      IF PurchLine.FindLinesWithItemToPlan(Item,PurchLine."Document Type"::"Return Order") THEN
        REPEAT
          IF PurchLine."Expected Receipt Date" <> 0D THEN
            IF PurchLine."Prod. Order No." = '' THEN
              InsertPurchLineToProfile(InventoryProfile,PurchLine,ToDate);
        UNTIL PurchLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransProdOrderToProfile@82(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27;ToDate@1002 : Date);
    VAR
      ProdOrderLine@1008 : Record 5406;
      CapLedgEntry@1005 : Record 5832;
      ProdOrderComp@1009 : Record 5407;
    BEGIN
      IF ProdOrderLine.FindLinesWithItemToPlan(Item,TRUE) THEN
        REPEAT
          IF ProdOrderLine."Due Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile.TransferFromProdOrderLine(ProdOrderLine,TempItemTrkgEntry);
            IF (ProdOrderLine."Planning Flexibility" = ProdOrderLine."Planning Flexibility"::Unlimited) AND
               (ProdOrderLine.Status = ProdOrderLine.Status::Released)
            THEN BEGIN
              CapLedgEntry.SETCURRENTKEY("Order Type","Order No.");
              CapLedgEntry.SETRANGE("Order Type",CapLedgEntry."Order Type"::Production);
              CapLedgEntry.SETRANGE("Order No.",ProdOrderLine."Prod. Order No.");
              ItemLedgEntry.RESET;
              ItemLedgEntry.SETCURRENTKEY("Order Type","Order No.");
              ItemLedgEntry.SETRANGE("Order Type",ItemLedgEntry."Order Type"::Production);
              ItemLedgEntry.SETRANGE("Order No.",ProdOrderLine."Prod. Order No.");
              IF NOT (CapLedgEntry.ISEMPTY AND ItemLedgEntry.ISEMPTY) THEN
                InventoryProfile."Planning Flexibility" := InventoryProfile."Planning Flexibility"::None
              ELSE BEGIN
                ProdOrderComp.SETRANGE(Status,ProdOrderLine.Status);
                ProdOrderComp.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
                ProdOrderComp.SETRANGE("Prod. Order Line No.",ProdOrderLine."Line No.");
                ProdOrderComp.SETFILTER("Qty. Picked (Base)",'>0');
                IF NOT ProdOrderComp.ISEMPTY THEN
                  InventoryProfile."Planning Flexibility" := InventoryProfile."Planning Flexibility"::None;
              END;
            END;
            InsertSupplyProfile(InventoryProfile,ToDate);
          END;
        UNTIL ProdOrderLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransAsmHeaderToProfile@91(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27;ToDate@1002 : Date);
    VAR
      AsmHeader@1009 : Record 900;
    BEGIN
      IF AsmHeader.FindLinesWithItemToPlan(Item,AsmHeader."Document Type"::Order) THEN
        REPEAT
          IF AsmHeader."Due Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile.TransferFromAsmHeader(AsmHeader,TempItemTrkgEntry);
            IF InventoryProfile."Finished Quantity" > 0 THEN
              InventoryProfile."Planning Flexibility" := InventoryProfile."Planning Flexibility"::None;
            InsertSupplyProfile(InventoryProfile,ToDate);
          END;
        UNTIL AsmHeader.NEXT = 0;
    END;

    LOCAL PROCEDURE TransRcptTransLineToProfile@83(VAR InventoryProfile@1001 : Record 99000853;VAR Item@1000 : Record 27;ToDate@1004 : Date);
    VAR
      TransLine@1006 : Record 5741;
      WhseEntry@1003 : Record 7312;
      FilterIsSetOnLocation@1002 : Boolean;
    BEGIN
      FilterIsSetOnLocation := Item.GETFILTER("Location Filter") <> '';
      IF TransLine.FindLinesWithItemToPlan(Item,TRUE,TRUE) THEN
        REPEAT
          IF TransLine."Receipt Date" <> 0D THEN BEGIN
            InventoryProfile.INIT;
            InventoryProfile."Line No." := NextLineNo;
            InventoryProfile.TransferFromInboundTransfer(TransLine,TempItemTrkgEntry);
            IF TransLine."Planning Flexibility" = TransLine."Planning Flexibility"::Unlimited THEN
              IF (InventoryProfile."Finished Quantity" > 0) OR
                 (TransLine."Quantity Shipped" > 0) OR (TransLine."Derived From Line No." > 0)
              THEN
                InventoryProfile."Planning Flexibility" := InventoryProfile."Planning Flexibility"::None
              ELSE BEGIN
                WhseEntry.SetSourceFilter(
                  DATABASE::"Transfer Line",0,InventoryProfile."Source ID",InventoryProfile."Source Ref. No.",TRUE);
                IF NOT WhseEntry.ISEMPTY THEN
                  InventoryProfile."Planning Flexibility" := InventoryProfile."Planning Flexibility"::None;
              END;
            IF FilterIsSetOnLocation THEN
              InventoryProfile."Transfer Location Not Planned" := TransferLocationIsFilteredOut(Item,TransLine);
            InsertSupplyProfile(InventoryProfile,ToDate);
            InsertTempTransferSKU(TransLine);
          END;
        UNTIL TransLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransferLocationIsFilteredOut@39(VAR Item@1000 : Record 27;VAR TransLine@1001 : Record 5741) : Boolean;
    VAR
      TempTransLine@1002 : TEMPORARY Record 5741;
    BEGIN
      TempTransLine := TransLine;
      TempTransLine.INSERT;
      Item.COPYFILTER("Location Filter",TempTransLine."Transfer-from Code");
      Item.COPYFILTER("Location Filter",TempTransLine."Transfer-to Code");
      EXIT(TempTransLine.ISEMPTY);
    END;

    LOCAL PROCEDURE InsertPurchLineToProfile@125(VAR InventoryProfile@1000 : Record 99000853;PurchLine@1001 : Record 39;ToDate@1002 : Date);
    BEGIN
      InventoryProfile.INIT;
      InventoryProfile."Line No." := NextLineNo;
      InventoryProfile.TransferFromPurchaseLine(PurchLine,TempItemTrkgEntry);
      IF InventoryProfile."Finished Quantity" > 0 THEN
        InventoryProfile."Planning Flexibility" := InventoryProfile."Planning Flexibility"::None;
      InsertSupplyProfile(InventoryProfile,ToDate);
    END;

    LOCAL PROCEDURE InsertAsmLineToProfile@126(VAR InventoryProfile@1000 : Record 99000853;AsmLine@1001 : Record 901;RemRatio@1002 : Decimal);
    BEGIN
      InventoryProfile.INIT;
      InventoryProfile."Line No." := NextLineNo;
      InventoryProfile.TransferFromAsmLine(AsmLine,TempItemTrkgEntry);
      IF RemRatio <> 1 THEN BEGIN
        InventoryProfile."Untracked Quantity" := ROUND(InventoryProfile."Untracked Quantity" * RemRatio,0.00001);
        InventoryProfile."Remaining Quantity (Base)" := InventoryProfile."Untracked Quantity";
      END;
      IF InventoryProfile.IsSupply THEN
        InventoryProfile.ChangeSign;
      InventoryProfile.INSERT;
    END;

    LOCAL PROCEDURE ForecastConsumption@1(VAR Demand@1000 : Record 99000853;VAR Item@1001 : Record 27;OrderDate@1002 : Date;ToDate@1003 : Date) UpdatedOrderDate : Date;
    VAR
      ForecastEntry@1004 : Record 99000852;
      ForecastEntry2@1005 : Record 99000852;
      NextForecast@1006 : Record 99000852;
      TotalForecastQty@1009 : Decimal;
      ReplenishmentLocation@1011 : Code[10];
      ForecastExist@1007 : Boolean;
      NextForecastExist@1010 : Boolean;
      ReplenishmentLocationFound@1014 : Boolean;
      ComponentForecast@1016 : Boolean;
      ComponentForecastFrom@1017 : Boolean;
    BEGIN
      UpdatedOrderDate := OrderDate;
      ComponentForecastFrom := FALSE;
      IF NOT ManufacturingSetup."Use Forecast on Locations" THEN BEGIN
        ReplenishmentLocationFound := FindReplishmentLocation(ReplenishmentLocation,Item);
        IF InvtSetup."Location Mandatory" AND NOT ReplenishmentLocationFound THEN
          ComponentForecastFrom := TRUE;

        ForecastEntry.SETCURRENTKEY(
          "Production Forecast Name","Item No.","Component Forecast","Forecast Date","Location Code");
      END ELSE
        ForecastEntry.SETCURRENTKEY(
          "Production Forecast Name","Item No.","Location Code","Forecast Date","Component Forecast");

      ItemLedgEntry.RESET;
      ItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code");
      Demand.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Due Date");

      NextForecast.COPY(ForecastEntry);

      IF NOT UseParm THEN
        CurrForecast := ManufacturingSetup."Current Production Forecast";

      ForecastEntry.SETRANGE("Production Forecast Name",CurrForecast);
      ForecastEntry.SETRANGE("Forecast Date",ExcludeForecastBefore,ToDate);

      ForecastEntry.SETRANGE("Item No.",Item."No.");
      ForecastEntry2.COPY(ForecastEntry);
      Item.COPYFILTER("Location Filter",ForecastEntry2."Location Code");

      FOR ComponentForecast := ComponentForecastFrom TO TRUE DO BEGIN
        IF ComponentForecast THEN BEGIN
          ReplenishmentLocation := ManufacturingSetup."Components at Location";
          IF InvtSetup."Location Mandatory" AND (ReplenishmentLocation = '') THEN
            EXIT;
        END;
        ForecastEntry.SETRANGE("Component Forecast",ComponentForecast);
        ForecastEntry2.SETRANGE("Component Forecast",ComponentForecast);
        IF ForecastEntry2.FIND('-') THEN
          REPEAT
            IF ManufacturingSetup."Use Forecast on Locations" THEN BEGIN
              ForecastEntry2.SETRANGE("Location Code",ForecastEntry2."Location Code");
              ItemLedgEntry.SETRANGE("Location Code",ForecastEntry2."Location Code");
              Demand.SETRANGE("Location Code",ForecastEntry2."Location Code");
            END ELSE BEGIN
              Item.COPYFILTER("Location Filter",ForecastEntry2."Location Code");
              Item.COPYFILTER("Location Filter",ItemLedgEntry."Location Code");
              Item.COPYFILTER("Location Filter",Demand."Location Code");
            END;
            ForecastEntry2.FIND('+');
            ForecastEntry2.COPYFILTER("Location Code",ForecastEntry."Location Code");
            Item.COPYFILTER("Location Filter",ForecastEntry2."Location Code");

            ForecastExist := CheckForecastExist(ForecastEntry,OrderDate,ToDate);

            IF ForecastExist THEN
              REPEAT
                ForecastEntry.SETRANGE("Forecast Date",ForecastEntry."Forecast Date");
                ForecastEntry.CALCSUMS("Forecast Quantity (Base)");
                TotalForecastQty := ForecastEntry."Forecast Quantity (Base)";
                ForecastEntry.FIND('+');
                NextForecast.COPYFILTERS(ForecastEntry);
                NextForecast.SETRANGE("Forecast Date",ForecastEntry."Forecast Date" + 1,ToDate);
                IF NOT NextForecast.FINDFIRST THEN
                  NextForecast."Forecast Date" := ToDate + 1
                ELSE
                  REPEAT
                    NextForecast.SETRANGE("Forecast Date",NextForecast."Forecast Date");
                    NextForecast.CALCSUMS("Forecast Quantity (Base)");
                    IF NextForecast."Forecast Quantity (Base)" = 0 THEN BEGIN
                      NextForecast.SETRANGE("Forecast Date",NextForecast."Forecast Date" + 1,ToDate);
                      IF NOT NextForecast.FINDFIRST THEN
                        NextForecast."Forecast Date" := ToDate + 1
                    END ELSE
                      NextForecastExist := TRUE
                  UNTIL (NextForecast."Forecast Date" = ToDate + 1) OR NextForecastExist;
                NextForecastExist := FALSE;

                ItemLedgEntry.SETRANGE("Item No.",Item."No.");
                ItemLedgEntry.SETRANGE(Positive,FALSE);
                ItemLedgEntry.SETRANGE(Open);
                ItemLedgEntry.SETRANGE(
                  "Posting Date",ForecastEntry."Forecast Date",NextForecast."Forecast Date" - 1);
                Item.COPYFILTER("Variant Filter",ItemLedgEntry."Variant Code");
                IF ComponentForecast THEN BEGIN
                  ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Consumption);
                  ItemLedgEntry.CALCSUMS(Quantity);
                  TotalForecastQty += ItemLedgEntry.Quantity;
                END ELSE BEGIN
                  ItemLedgEntry.SETRANGE("Entry Type",ItemLedgEntry."Entry Type"::Sale);
                  ItemLedgEntry.SETRANGE("Derived from Blanket Order",FALSE);
                  ItemLedgEntry.CALCSUMS(Quantity);
                  TotalForecastQty += ItemLedgEntry.Quantity;
                  ItemLedgEntry.SETRANGE("Derived from Blanket Order");
                  // Undo shipment shall neutralize consumption from sales
                  ItemLedgEntry.SETRANGE(Positive,TRUE);
                  ItemLedgEntry.SETRANGE(Correction,TRUE);
                  ItemLedgEntry.CALCSUMS(Quantity);
                  TotalForecastQty += ItemLedgEntry.Quantity;
                  ItemLedgEntry.SETRANGE(Correction);
                END;

                Demand.SETRANGE("Item No.",ForecastEntry."Item No.");
                Demand.SETRANGE(
                  "Due Date",ForecastEntry."Forecast Date",NextForecast."Forecast Date" - 1);
                IF ComponentForecast THEN
                  Demand.SETFILTER(
                    "Source Type",
                    '%1|%2|%3',
                    DATABASE::"Prod. Order Component",
                    DATABASE::"Planning Component",
                    DATABASE::"Assembly Line")
                ELSE
                  Demand.SETFILTER(
                    "Source Type",
                    '%1|%2',
                    DATABASE::"Sales Line",
                    DATABASE::"Service Line");
                IF Demand.FIND('-') THEN
                  REPEAT
                    IF NOT (Demand.IsSupply OR Demand."Derived from Blanket Order")
                    THEN
                      TotalForecastQty := TotalForecastQty - Demand."Remaining Quantity (Base)";
                  UNTIL (Demand.NEXT = 0) OR (TotalForecastQty < 0);
                IF TotalForecastQty > 0 THEN BEGIN
                  ForecastInitDemand(Demand,ForecastEntry,Item."No.",ReplenishmentLocation,TotalForecastQty);
                  Demand."Due Date" :=
                    CalendarManagement.CalcDateBOC2(
                      '<0D>',ForecastEntry."Forecast Date",
                      CustomizedCalendarChange."Source Type"::Location,Demand."Location Code",'',
                      CustomizedCalendarChange."Source Type"::Location,Demand."Location Code",'',FALSE);
                  IF Demand."Due Date" < UpdatedOrderDate THEN
                    UpdatedOrderDate := Demand."Due Date";
                  Demand.INSERT;
                END;
                ForecastEntry.SETRANGE("Forecast Date",ExcludeForecastBefore,ToDate);
              UNTIL ForecastEntry.NEXT = 0;
          UNTIL ForecastEntry2.NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE BlanketOrderConsump@38(VAR InventoryProfile@1000 : Record 99000853;VAR Item@1001 : Record 27;ToDate@1002 : Date);
    VAR
      BlanketSalesLine@1003 : Record 37;
      QtyReleased@1005 : Decimal;
    BEGIN
      InventoryProfile.RESET;
      WITH BlanketSalesLine DO BEGIN
        SETCURRENTKEY("Document Type","Document No.",Type,"No.");
        SETRANGE("Document Type","Document Type"::"Blanket Order");
        SETRANGE(Type,Type::Item);
        SETRANGE("No.",Item."No.");
        Item.COPYFILTER("Location Filter","Location Code");
        Item.COPYFILTER("Variant Filter","Variant Code");
        SETFILTER("Outstanding Qty. (Base)",'<>0');
        SETFILTER("Shipment Date",'>%1&<=%2',0D,ToDate);
        IF FIND('-') THEN
          REPEAT
            QtyReleased += CalcInventoryProfileRemainingQty(InventoryProfile,"Document No.");
            SETRANGE("Document No.","Document No.");
            BlanketSalesOrderLinesToProfile(InventoryProfile,BlanketSalesLine,QtyReleased);
            SETRANGE("Document No.");
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE BlanketSalesOrderLinesToProfile@128(VAR InventoryProfile@1000 : Record 99000853;VAR BlanketSalesLine@1002 : Record 37;VAR QtyReleased@1001 : Decimal);
    VAR
      IsSalesOrderLineCreated@1003 : Boolean;
    BEGIN
      WITH BlanketSalesLine DO
        FOR IsSalesOrderLineCreated := TRUE DOWNTO FALSE DO BEGIN
          FIND('-');
          REPEAT
            IF "Quantity (Base)" <> "Qty. to Asm. to Order (Base)" THEN
              IF DoProcessBlanketLine("Document No.","Line No.",IsSalesOrderLineCreated) THEN
                IF "Outstanding Qty. (Base)" - "Qty. to Asm. to Order (Base)" > QtyReleased THEN BEGIN
                  InventoryProfile.INIT;
                  InventoryProfile."Line No." := NextLineNo;
                  InventoryProfile.TransferFromSalesLine(BlanketSalesLine,TempItemTrkgEntry);
                  InventoryProfile."Untracked Quantity" := "Outstanding Qty. (Base)" - QtyReleased;
                  InventoryProfile."Remaining Quantity (Base)" := InventoryProfile."Untracked Quantity";
                  QtyReleased := 0;
                  InventoryProfile.INSERT;
                END ELSE
                  QtyReleased -= "Outstanding Qty. (Base)";
          UNTIL NEXT = 0;
        END;
    END;

    LOCAL PROCEDURE DoProcessBlanketLine@130(BlanketOrderNo@1000 : Code[20];BlanketOrderLineNo@1001 : Integer;IsSalesOrderLineCreated@1002 : Boolean) : Boolean;
    VAR
      SalesLine@1003 : Record 37;
    BEGIN
      SalesLine.SETRANGE("Blanket Order No.",BlanketOrderNo);
      SalesLine.SETRANGE("Blanket Order Line No.",BlanketOrderLineNo);
      EXIT(NOT SalesLine.ISEMPTY = IsSalesOrderLineCreated)
    END;

    LOCAL PROCEDURE CheckForecastExist@36(VAR ForecastEntry@1000 : Record 99000852;OrderDate@1001 : Date;ToDate@1002 : Date) : Boolean;
    VAR
      ForecastExist@1003 : Boolean;
    BEGIN
      ForecastEntry.SETRANGE("Forecast Date",ExcludeForecastBefore,OrderDate);
      IF ForecastEntry.FIND('+') THEN
        REPEAT
          ForecastEntry.SETRANGE("Forecast Date",ForecastEntry."Forecast Date");
          ForecastEntry.CALCSUMS("Forecast Quantity (Base)");
          IF ForecastEntry."Forecast Quantity (Base)" <> 0 THEN
            ForecastExist := TRUE
          ELSE
            ForecastEntry.SETRANGE("Forecast Date",ExcludeForecastBefore,ForecastEntry."Forecast Date" - 1);
        UNTIL (NOT ForecastEntry.FIND('+')) OR ForecastExist;

      IF NOT ForecastExist THEN BEGIN
        IF ExcludeForecastBefore > OrderDate THEN
          ForecastEntry.SETRANGE("Forecast Date",ExcludeForecastBefore,ToDate)
        ELSE
          ForecastEntry.SETRANGE("Forecast Date",OrderDate + 1,ToDate);
        IF ForecastEntry.FIND('-') THEN
          REPEAT
            ForecastEntry.SETRANGE("Forecast Date",ForecastEntry."Forecast Date");
            ForecastEntry.CALCSUMS("Forecast Quantity (Base)");
            IF ForecastEntry."Forecast Quantity (Base)" <> 0 THEN
              ForecastExist := TRUE
            ELSE
              ForecastEntry.SETRANGE("Forecast Date",ForecastEntry."Forecast Date" + 1,ToDate);
          UNTIL (NOT ForecastEntry.FIND('-')) OR ForecastExist
      END;
      EXIT(ForecastExist);
    END;

    LOCAL PROCEDURE FindReplishmentLocation@42(VAR ReplenishmentLocation@1000 : Code[10];VAR Item@1003 : Record 27) : Boolean;
    VAR
      SKU@1001 : Record 5700;
    BEGIN
      ReplenishmentLocation := '';
      SKU.SETCURRENTKEY("Item No.","Location Code","Variant Code");
      SKU.SETRANGE("Item No.",Item."No.");
      Item.COPYFILTER("Location Filter",SKU."Location Code");
      Item.COPYFILTER("Variant Filter",SKU."Variant Code");
      SKU.SETRANGE("Replenishment System",Item."Replenishment System"::Purchase,Item."Replenishment System"::"Prod. Order");
      SKU.SETFILTER("Reordering Policy",'<>%1',SKU."Reordering Policy"::" ");
      IF SKU.FIND('-') THEN
        IF SKU.NEXT = 0 THEN
          ReplenishmentLocation := SKU."Location Code";
      EXIT(ReplenishmentLocation <> '');
    END;

    LOCAL PROCEDURE FindCombination@7(VAR Demand@1000 : Record 99000853;VAR Supply@1001 : Record 99000853;VAR Item@1002 : Record 27);
    VAR
      SKU@1008 : Record 5700;
      Location@1003 : Record 14;
      PlanningGetParameters@1010 : Codeunit 99000855;
      WMSManagement@1009 : Codeunit 7302;
      VersionManagement@1011 : Codeunit 99000756;
      State@1007 : 'DemandExist,SupplyExist,BothExist';
      DemandBool@1004 : Boolean;
      SupplyBool@1005 : Boolean;
      TransitLocation@1006 : Boolean;
    BEGIN
      CreateTempSKUForComponentsLocation(Item);

      SKU.SETCURRENTKEY("Item No.","Location Code","Variant Code");
      SKU.SETRANGE("Item No.",Item."No.");
      Item.COPYFILTER("Variant Filter",SKU."Variant Code");
      Item.COPYFILTER("Location Filter",SKU."Location Code");

      IF SKU.FINDSET THEN BEGIN
        REPEAT
          PlanningGetParameters.AdjustInvalidSettings(SKU);
          IF (SKU."Safety Stock Quantity" <> 0) OR (SKU."Reorder Point" <> 0) OR
             (SKU."Reorder Quantity" <> 0) OR (SKU."Maximum Inventory" <> 0)
          THEN BEGIN
            TempSKU.TRANSFERFIELDS(SKU);
            IF TempSKU.INSERT THEN ;
            WHILE (TempSKU."Replenishment System" = TempSKU."Replenishment System"::Transfer) AND
                  (TempSKU."Reordering Policy" <> TempSKU."Reordering Policy"::" ")
            DO BEGIN
              TempSKU."Location Code" := TempSKU."Transfer-from Code";
              TransferPlanningParameters(TempSKU);
              IF TempSKU."Reordering Policy" <> TempSKU."Reordering Policy"::" " THEN
                InsertTempSKU;
            END;
          END;
        UNTIL SKU.NEXT = 0;
      END ELSE
        IF (NOT InvtSetup."Location Mandatory") AND (ManufacturingSetup."Components at Location" = '') THEN
          CreateTempSKUForLocation(
            Item."No.",
            WMSManagement.GetLastOperationLocationCode(
              Item."Routing No.",VersionManagement.GetRtngVersion(Item."Routing No.",Supply."Due Date",TRUE)));

      CLEAR(Demand);
      CLEAR(Supply);
      Demand.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Due Date","Attribute Priority","Order Priority");
      Supply.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Due Date","Attribute Priority","Order Priority");
      Demand.SETRANGE(IsSupply,FALSE);
      Supply.SETRANGE(IsSupply,TRUE);
      DemandBool := Demand.FIND('-');
      SupplyBool := Supply.FIND('-');

      WHILE DemandBool OR SupplyBool DO BEGIN
        IF  DemandBool THEN BEGIN
          TempSKU."Item No." := Demand."Item No.";
          TempSKU."Variant Code" := Demand."Variant Code";
          TempSKU."Location Code" := Demand."Location Code";
        END ELSE BEGIN
          TempSKU."Item No." := Supply."Item No.";
          TempSKU."Variant Code" := Supply."Variant Code";
          TempSKU."Location Code" := Supply."Location Code";
        END;

        IF DemandBool AND SupplyBool THEN
          State := State::BothExist
        ELSE
          IF DemandBool THEN
            State := State::DemandExist
          ELSE
            State := State::SupplyExist;

        CASE State OF
          State::DemandExist:
            DemandBool := FindNextSKU(Demand);
          State::SupplyExist:
            SupplyBool := FindNextSKU(Supply);
          State::BothExist:
            IF Demand."Variant Code" = Supply."Variant Code" THEN BEGIN
              IF Demand."Location Code" = Supply."Location Code" THEN BEGIN
                DemandBool := FindNextSKU(Demand);
                SupplyBool := FindNextSKU(Supply);
              END ELSE
                IF Demand."Location Code" < Supply."Location Code" THEN
                  DemandBool := FindNextSKU(Demand)
                ELSE
                  SupplyBool := FindNextSKU(Supply)
            END ELSE
              IF Demand."Variant Code" < Supply."Variant Code" THEN
                DemandBool := FindNextSKU(Demand)
              ELSE
                SupplyBool := FindNextSKU(Supply);
        END;

        IF TempSKU."Location Code" <> '' THEN BEGIN
          Location.GET(TempSKU."Location Code"); // Assert: will fail if location cannot be found.
          TransitLocation := Location."Use As In-Transit";
        END ELSE
          TransitLocation := FALSE; // Variant SKU only - no location code involved.

        IF NOT TransitLocation THEN BEGIN
          TransferPlanningParameters(TempSKU);
          InsertTempSKU;
          WHILE (TempSKU."Replenishment System" = TempSKU."Replenishment System"::Transfer) AND
                (TempSKU."Reordering Policy" <> TempSKU."Reordering Policy"::" ")
          DO BEGIN
            TempSKU."Location Code" := TempSKU."Transfer-from Code";
            TransferPlanningParameters(TempSKU);
            IF TempSKU."Reordering Policy" <> TempSKU."Reordering Policy"::" " THEN
              InsertTempSKU;
          END;
        END;
      END;

      Item.COPYFILTER("Location Filter",TempSKU."Location Code");
      Item.COPYFILTER("Variant Filter",TempSKU."Variant Code");
    END;

    LOCAL PROCEDURE InsertTempSKU@14();
    VAR
      SKU2@1002 : Record 5700;
      PlanningGetParameters@1000 : Codeunit 99000855;
    BEGIN
      WITH TempSKU DO
        IF NOT FIND('=') THEN BEGIN
          PlanningGetParameters.SetLotForLot;
          PlanningGetParameters.AtSKU(SKU2,"Item No.","Variant Code","Location Code");
          TempSKU := SKU2;
          IF "Reordering Policy" <> "Reordering Policy"::" " THEN
            INSERT;
        END;
    END;

    LOCAL PROCEDURE FindNextSKU@2(VAR InventoryProfile@1000 : Record 99000853) : Boolean;
    BEGIN
      TempSKU."Variant Code" := InventoryProfile."Variant Code";
      TempSKU."Location Code" := InventoryProfile."Location Code";

      InventoryProfile.SETRANGE("Variant Code",TempSKU."Variant Code");
      InventoryProfile.SETRANGE("Location Code",TempSKU."Location Code");
      InventoryProfile.FINDLAST;
      InventoryProfile.SETRANGE("Variant Code");
      InventoryProfile.SETRANGE("Location Code");
      EXIT(InventoryProfile.NEXT <> 0);
    END;

    LOCAL PROCEDURE TransferPlanningParameters@40(VAR SKU@1000 : Record 5700);
    VAR
      SKU2@1001 : Record 5700;
      PlanningGetParameters@1002 : Codeunit 99000855;
    BEGIN
      PlanningGetParameters.AtSKU(SKU2,SKU."Item No.",SKU."Variant Code",SKU."Location Code");
      SKU := SKU2;
    END;

    LOCAL PROCEDURE DeleteTracking@25(VAR SKU@1000 : Record 5700;ToDate@1001 : Date;VAR SupplyInventoryProfile@1002 : Record 99000853);
    VAR
      Item@1004 : Record 27;
      ReservEntry1@1005 : Record 337;
      ResEntryWasDeleted@1003 : Boolean;
    BEGIN
      ActionMsgEntry.SETCURRENTKEY("Reservation Entry");

      WITH ReservEntry DO BEGIN
        RESET;
        SETCURRENTKEY("Item No.","Variant Code","Location Code");
        SETRANGE("Item No.",SKU."Item No.");
        SETRANGE("Variant Code",SKU."Variant Code");
        SETRANGE("Location Code",SKU."Location Code");
        SETFILTER("Reservation Status",'<>%1',"Reservation Status"::Prospect);
        IF FIND('-') THEN
          REPEAT
            Item.GET("Item No.");
            IF NOT IsTrkgForSpecialOrderOrDropShpt(ReservEntry) THEN BEGIN
              IF ShouldDeleteReservEntry(ReservEntry,ToDate) THEN BEGIN
                ResEntryWasDeleted := TRUE;
                IF ("Source Type" = DATABASE::"Item Ledger Entry") AND
                   ("Reservation Status" = "Reservation Status"::Tracking)
                THEN
                  IF ReservEntry1.GET("Entry No.",NOT Positive) THEN
                    ReservEntry1.DELETE;
                DELETE;
              END ELSE
                ResEntryWasDeleted := CloseTracking(ReservEntry,SupplyInventoryProfile,ToDate);

              IF ResEntryWasDeleted THEN BEGIN
                ActionMsgEntry.SETRANGE("Reservation Entry","Entry No.");
                ActionMsgEntry.DELETEALL;
              END;
            END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE ShouldDeleteReservEntry@135(ReservEntry@1000 : Record 337;ToDate@1001 : Date) : Boolean;
    VAR
      Item@1002 : Record 27;
      IsReservedForProdComponent@1003 : Boolean;
    BEGIN
      IsReservedForProdComponent := ReservedForProdComponent(ReservEntry);
      IF IsReservedForProdComponent AND IsProdOrderPlanned(ReservEntry) AND
         (ReservEntry."Reservation Status" > ReservEntry."Reservation Status"::Tracking)
      THEN
        EXIT(FALSE);

      Item.GET(ReservEntry."Item No.");
      WITH ReservEntry DO
        EXIT(
          (("Reservation Status" <> "Reservation Status"::Reservation) AND
           ("Expected Receipt Date" <= ToDate) AND
           ("Shipment Date" <= ToDate)) OR
          ((Binding = Binding::"Order-to-Order") AND ("Shipment Date" <= ToDate) AND
           (Item."Manufacturing Policy" = Item."Manufacturing Policy"::"Make-to-Stock") AND
           (Item."Replenishment System" = Item."Replenishment System"::"Prod. Order") AND
           (NOT IsReservedForProdComponent)));
    END;

    LOCAL PROCEDURE IsProdOrderPlanned@133(ReservationEntry@1000 : Record 337) : Boolean;
    VAR
      ProdOrderComp@1001 : Record 5407;
      RequisitionLine@1002 : Record 246;
    BEGIN
      IF NOT ProdOrderComp.GET(
           ReservationEntry."Source Subtype",ReservationEntry."Source ID",
           ReservationEntry."Source Prod. Order Line",ReservationEntry."Source Ref. No.")
      THEN
        EXIT;

      RequisitionLine.SetRefFilter(
        RequisitionLine."Ref. Order Type"::"Prod. Order",ProdOrderComp.Status,
        ProdOrderComp."Prod. Order No.",ProdOrderComp."Prod. Order Line No.");
      RequisitionLine.SETRANGE("Operation No.",'');

      EXIT(NOT RequisitionLine.ISEMPTY);
    END;

    LOCAL PROCEDURE RemoveOrdinaryInventory@46(VAR Supply@1000 : Record 99000853);
    VAR
      Supply2@1001 : Record 99000853;
    BEGIN
      Supply2.COPY(Supply);
      WITH Supply DO BEGIN
        SETRANGE(IsSupply);
        SETRANGE("Source Type",DATABASE::"Item Ledger Entry");
        SETFILTER(Binding,'<>%1',Supply2.Binding::"Order-to-Order");
        DELETEALL;
        COPY(Supply2);
      END;
    END;

    LOCAL PROCEDURE UnfoldItemTracking@48(VAR ParentInvProfile@1000 : Record 99000853;VAR ChildInvProfile@1002 : Record 99000853);
    BEGIN
      ParentInvProfile.RESET;
      TempItemTrkgEntry.RESET;
      IF NOT TempItemTrkgEntry.FIND('-') THEN
        EXIT;
      ParentInvProfile.SETFILTER("Source Type",'<>%1',DATABASE::"Item Ledger Entry");
      ParentInvProfile.SETRANGE("Tracking Reference",0);
      IF ParentInvProfile.FIND('-') THEN
        REPEAT
          TempItemTrkgEntry.RESET;
          TempItemTrkgEntry.SetSourceFilter(
            ParentInvProfile."Source Type",ParentInvProfile."Source Order Status",ParentInvProfile."Source ID",
            ParentInvProfile."Source Ref. No.",FALSE);
          TempItemTrkgEntry.SetSourceFilter2(ParentInvProfile."Source Batch Name",ParentInvProfile."Source Prod. Order Line");
          IF TempItemTrkgEntry.FIND('-') THEN BEGIN
            IF ParentInvProfile.IsSupply AND
               (ParentInvProfile.Binding <> ParentInvProfile.Binding::"Order-to-Order")
            THEN
              ParentInvProfile."Planning Flexibility" := ParentInvProfile."Planning Flexibility"::None;
            REPEAT
              ChildInvProfile := ParentInvProfile;
              ChildInvProfile."Line No." := NextLineNo;
              ChildInvProfile."Tracking Reference" := ParentInvProfile."Line No.";
              ChildInvProfile."Lot No." := TempItemTrkgEntry."Lot No.";
              ChildInvProfile."Serial No." := TempItemTrkgEntry."Serial No.";
              ChildInvProfile."Expiration Date" := TempItemTrkgEntry."Expiration Date";
              ChildInvProfile.TransferQtyFromItemTrgkEntry(TempItemTrkgEntry);
              OnAfterTransToChildInvProfile(TempItemTrkgEntry,ChildInvProfile);
              ChildInvProfile.INSERT;
              ParentInvProfile.ReduceQtyByItemTracking(ChildInvProfile);
              ParentInvProfile.MODIFY;
            UNTIL TempItemTrkgEntry.NEXT = 0;
          END;
        UNTIL ParentInvProfile.NEXT = 0;
    END;

    LOCAL PROCEDURE MatchAttributes@54(VAR Supply@1000 : Record 99000853;VAR Demand@1001 : Record 99000853;RespectPlanningParm@1007 : Boolean);
    VAR
      xDemand@1002 : Record 99000853;
      xSupply@1003 : Record 99000853;
      NewSupplyDate@1005 : Date;
      SupplyExists@1004 : Boolean;
      CanBeRescheduled@1008 : Boolean;
      ItemInventoryExists@1006 : Boolean;
    BEGIN
      xDemand.COPYFILTERS(Demand);
      xSupply.COPYFILTERS(Supply);
      ItemInventoryExists := CheckItemInventoryExists(Supply);
      Demand.SETRANGE("Attribute Priority",1,7);
      Demand.SETFILTER("Source Type",'<>%1',DATABASE::"Requisition Line");
      IF Demand.FINDSET(TRUE) THEN
        REPEAT
          Supply.SETRANGE(Binding,Demand.Binding);
          Supply.SETRANGE("Primary Order Status",Demand."Primary Order Status");
          Supply.SETRANGE("Primary Order No.",Demand."Primary Order No.");
          Supply.SETRANGE("Primary Order Line",Demand."Primary Order Line");
          IF (Demand."Ref. Order Type" = Demand."Ref. Order Type"::Assembly) AND
             (Demand.Binding = Demand.Binding::"Order-to-Order") AND
             (Demand."Primary Order No." = '')
          THEN
            Supply.SETRANGE("Source Prod. Order Line",Demand."Source Prod. Order Line");

          Supply.SetTrackingFilter(Demand);
          SupplyExists := Supply.FINDFIRST;
          WHILE (Demand."Untracked Quantity" > 0) AND (NOT ApplyUntrackedQuantityToItemInventory(SupplyExists,ItemInventoryExists)) DO BEGIN
            IF SupplyExists AND (Demand.Binding = Demand.Binding::"Order-to-Order") THEN BEGIN
              NewSupplyDate := Supply."Due Date";
              CanBeRescheduled :=
                (Supply."Fixed Date" = 0D) AND
                ((Supply."Due Date" <> Demand."Due Date") OR (Supply."Due Time" <> Demand."Due Time"));
              IF CanBeRescheduled THEN
                IF (Supply."Due Date" > Demand."Due Date") OR (Supply."Due Time" > Demand."Due Time") THEN
                  CanBeRescheduled := CheckScheduleIn(Supply,Demand."Due Date",NewSupplyDate,FALSE)
                ELSE
                  CanBeRescheduled := CheckScheduleOut(Supply,Demand."Due Date",NewSupplyDate,FALSE);
              IF CanBeRescheduled AND
                 ((NewSupplyDate <> Supply."Due Date") OR (Supply."Planning Level Code" > 0))
              THEN BEGIN
                Reschedule(Supply,Demand."Due Date",Demand."Due Time");
                Supply."Fixed Date" := Supply."Due Date";
              END;
            END;
            IF NOT SupplyExists OR (Supply."Due Date" > Demand."Due Date") THEN BEGIN
              InitSupply(Supply,Demand."Untracked Quantity",Demand."Due Date");
              TransferAttributes(Supply,Demand);
              Supply."Fixed Date" := Supply."Due Date";
              Supply.INSERT;
              SupplyExists := TRUE;
            END;

            IF Demand.Binding = Demand.Binding::"Order-to-Order" THEN
              IF (Demand."Untracked Quantity" > Supply."Untracked Quantity") AND
                 (Supply."Due Date" <= Demand."Due Date")
              THEN
                IncreaseQtyToMeetDemand(Supply,Demand,FALSE,RespectPlanningParm,FALSE);

            IF Supply."Untracked Quantity" < Demand."Untracked Quantity" THEN
              SupplyExists := CloseSupply(Demand,Supply)
            ELSE
              CloseDemand(Demand,Supply);
          END;
        UNTIL Demand.NEXT = 0;

      // Neutralize or generalize excess Order-To-Order Supply
      Supply.COPYFILTERS(xSupply);
      Supply.SETRANGE(Binding,Supply.Binding::"Order-to-Order");
      Supply.SETFILTER("Untracked Quantity",'>=0');
      IF Supply.FINDSET THEN
        REPEAT
          IF Supply."Untracked Quantity" > 0 THEN BEGIN
            IF DecreaseQty(Supply,Supply."Untracked Quantity") THEN BEGIN
              // Assertion: New specific Supply shall match the Demand exactly and must not update
              // the Planning Line again since that will double the derived demand in case of transfers
              IF Supply."Action Message" = Supply."Action Message"::New THEN
                Supply.FIELDERROR("Action Message");
              MaintainPlanningLine(Supply,PlanningLineStage::Exploded,ScheduleDirection::Backward)
            END ELSE BEGIN
              // Evaluate excess supply
              IF TempSKU."Include Inventory" THEN BEGIN
                // Release the remaining Untracked Quantity
                Supply.Binding := Supply.Binding::" ";
                Supply."Primary Order Type" := 0;
                Supply."Primary Order Status" := 0;
                Supply."Primary Order No." := '';
                Supply."Primary Order Line" := 0;
                SetAttributePriority(Supply);
              END ELSE
                Supply."Untracked Quantity" := 0;
            END;
            // Ensure that the directly allocated quantity will not be part of Projected Inventory
            IF Supply."Untracked Quantity" <> 0 THEN BEGIN
              UpdateQty(Supply,Supply."Untracked Quantity");
              Supply.MODIFY;
            END;
          END;
          IF Supply."Untracked Quantity" = 0 THEN
            Supply.DELETE;
        UNTIL Supply.NEXT = 0;

      Demand.COPYFILTERS(xDemand);
      Supply.COPYFILTERS(xSupply);
    END;

    LOCAL PROCEDURE MatchReservationEntries@116(VAR FromTrkgReservEntry@1000 : Record 337;VAR ToTrkgReservEntry@1001 : Record 337);
    BEGIN
      IF (FromTrkgReservEntry."Reservation Status" = FromTrkgReservEntry."Reservation Status"::Reservation) XOR
         (ToTrkgReservEntry."Reservation Status" = ToTrkgReservEntry."Reservation Status"::Reservation)
      THEN BEGIN
        SwitchTrackingToReservationStatus(FromTrkgReservEntry);
        SwitchTrackingToReservationStatus(ToTrkgReservEntry);
      END;
    END;

    LOCAL PROCEDURE SwitchTrackingToReservationStatus@111(VAR ReservEntry@1000 : Record 337);
    BEGIN
      IF ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Tracking THEN
        ReservEntry."Reservation Status" := ReservEntry."Reservation Status"::Reservation;
    END;

    LOCAL PROCEDURE PlanItem@41(VAR Demand@1000 : Record 99000853;VAR Supply@1001 : Record 99000853;PlanningStartDate@1002 : Date;ToDate@1003 : Date;RespectPlanningParm@1019 : Boolean);
    VAR
      InvChangeReminder@1004 : TEMPORARY Record 99000853;
      PlanningGetParameters@1020 : Codeunit 99000855;
      OriginalSupplyDate@1014 : Date;
      NewSupplyDate@1013 : Date;
      LatestBucketStartDate@1012 : Date;
      LastProjectedInventory@1005 : Decimal;
      LastAvailableInventory@1007 : Decimal;
      SupplyWithinLeadtime@1015 : Decimal;
      DemandExists@1008 : Boolean;
      SupplyExists@1009 : Boolean;
      PlanThisSKU@1017 : Boolean;
      ROPHasBeenCrossed@1010 : Boolean;
      NewSupplyHasTakenOver@1026 : Boolean;
      WeAreSureThatDatesMatch@1027 : Boolean;
      IsReorderPointPlanning@1033 : Boolean;
      IsExceptionOrder@1006 : Boolean;
      SupplyAvailableWithinLeadTime@1016 : Decimal;
      NeedOfPublishSurplus@1018 : Boolean;
      InitialProjectedInventory@1021 : Decimal;
    BEGIN
      ReqLine.RESET;
      ReqLine.SETRANGE("Worksheet Template Name",CurrTemplateName);
      ReqLine.SETRANGE("Journal Batch Name",CurrWorksheetName);
      ReqLine.LOCKTABLE;
      IF ReqLine.FINDLAST THEN;

      IF PlanningResilicency THEN
        ReqLine.SetResiliencyOn(CurrTemplateName,CurrWorksheetName,TempSKU."Item No.");

      Demand.RESET;
      Supply.RESET;
      Demand.SETRANGE(IsSupply,FALSE);
      Supply.SETRANGE(IsSupply,TRUE);

      UpdateTempSKUTransferLevels;

      TempSKU.SETCURRENTKEY("Item No.","Transfer-Level Code");
      Demand.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Due Date","Attribute Priority","Order Priority");
      Supply.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Due Date","Attribute Priority","Order Priority");
      InvChangeReminder.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Due Date");

      Supply.SETRANGE("Drop Shipment",FALSE);
      Supply.SETRANGE("Special Order",FALSE);
      Demand.SETRANGE("Drop Shipment",FALSE);
      Demand.SETRANGE("Special Order",FALSE);

      ExceedROPqty := 0.000000001;

      IF TempSKU.FIND('-') THEN
        REPEAT
          IsReorderPointPlanning :=
            (TempSKU."Reorder Point" > TempSKU."Safety Stock Quantity") OR
            (TempSKU."Reordering Policy" = TempSKU."Reordering Policy"::"Maximum Qty.") OR
            (TempSKU."Reordering Policy" = TempSKU."Reordering Policy"::"Fixed Reorder Qty.");

          BucketSize := TempSKU."Time Bucket";
          // Minimum bucket size is 1 day:
          IF CALCDATE(BucketSize) <= TODAY THEN
            EVALUATE(BucketSize,'<1D>');
          BucketSizeInDays := CALCDATE(BucketSize) - TODAY;

          FilterDemandSupplyRelatedToSKU(Demand);
          FilterDemandSupplyRelatedToSKU(Supply);

          DampenersDays := PlanningGetParameters.CalcDampenerDays(TempSKU);
          DampenerQty := PlanningGetParameters.CalcDampenerQty(TempSKU);
          OverflowLevel := PlanningGetParameters.CalcOverflowLevel(TempSKU);

          IF NOT TempSKU."Include Inventory" THEN
            RemoveOrdinaryInventory(Supply);
          InsertSafetyStockDemands(Demand,PlanningStartDate);
          UpdatePriorities(Supply,IsReorderPointPlanning,ToDate);

          DemandExists := Demand.FINDSET;
          SupplyExists := Supply.FINDSET;
          LatestBucketStartDate := PlanningStartDate;
          LastProjectedInventory := 0;
          LastAvailableInventory := 0;
          PlanThisSKU := CheckPlanSKU(TempSKU,DemandExists,SupplyExists,IsReorderPointPlanning);

          IF PlanThisSKU THEN BEGIN
            PrepareDemand(Demand,IsReorderPointPlanning,ToDate);
            PlanThisSKU := NOT (DemandMatchedSupply(Demand,Supply,TempSKU) AND DemandMatchedSupply(Supply,Demand,TempSKU));
          END;
          IF PlanThisSKU THEN BEGIN
            // Preliminary clean of tracking
            IF DemandExists OR SupplyExists THEN
              DeleteTracking(TempSKU,ToDate,Supply);

            MatchAttributes(Supply,Demand,RespectPlanningParm);

            // Calculate initial inventory
            Demand.SETRANGE("Due Date",0D,PlanningStartDate - 1);
            Supply.SETRANGE("Due Date",0D,PlanningStartDate - 1);
            DemandExists := Demand.FINDSET;
            SupplyExists := Supply.FINDSET;
            WHILE DemandExists AND SupplyExists DO
              IF Demand."Untracked Quantity" > Supply."Untracked Quantity" THEN BEGIN
                LastProjectedInventory += Supply."Remaining Quantity (Base)";
                Demand."Untracked Quantity" -= Supply."Untracked Quantity";
                FrozenZoneTrack(Supply,Demand);
                Supply."Untracked Quantity" := 0;
                Supply.MODIFY;
                SupplyExists := Supply.NEXT <> 0;
              END ELSE BEGIN
                LastProjectedInventory -= Demand."Remaining Quantity (Base)";
                Supply."Untracked Quantity" -= Demand."Untracked Quantity";
                FrozenZoneTrack(Demand,Supply);
                Demand."Untracked Quantity" := 0;
                Demand.MODIFY;
                DemandExists := Demand.NEXT <> 0;
                IF NOT DemandExists THEN
                  Supply.MODIFY;
              END;

            WHILE DemandExists DO BEGIN
              LastProjectedInventory -= Demand."Remaining Quantity (Base)";
              LastAvailableInventory -= Demand."Untracked Quantity";
              Demand."Untracked Quantity" := 0;
              Demand.MODIFY;
              DemandExists := Demand.NEXT <> 0;
            END;

            WHILE SupplyExists DO BEGIN
              LastProjectedInventory += Supply."Remaining Quantity (Base)";
              LastAvailableInventory += Supply."Untracked Quantity";
              Supply."Planning Flexibility" := Supply."Planning Flexibility"::None;
              Supply.MODIFY;
              SupplyExists := Supply.NEXT <> 0;
            END;

            IF LastAvailableInventory < 0 THEN BEGIN // Emergency order
              // Insert Supply
              InitSupply(Supply,-LastAvailableInventory,PlanningStartDate - 1);
              Supply."Planning Flexibility" := Supply."Planning Flexibility"::None;
              Supply.INSERT;
              MaintainPlanningLine(Supply,PlanningLineStage::Exploded,ScheduleDirection::Backward);
              Track(Supply,Demand,TRUE,FALSE,Supply.Binding::" ");
              LastProjectedInventory += Supply."Remaining Quantity (Base)";
              LastAvailableInventory += Supply."Untracked Quantity";
              Transparency.LogSurplus(Supply."Line No.",Supply."Line No.",0,'',
                Supply."Untracked Quantity",SurplusType::EmergencyOrder);
              Supply."Untracked Quantity" := 0;
              IF Supply."Planning Line No." <> ReqLine."Line No." THEN
                ReqLine.GET(CurrTemplateName,CurrWorksheetName,Supply."Planning Line No.");
              Transparency.PublishSurplus(Supply,TempSKU,ReqLine,TempTrkgReservEntry);
              DummyInventoryProfileTrackBuffer."Warning Level" := DummyInventoryProfileTrackBuffer."Warning Level"::Emergency;
              Transparency.LogWarning(0,ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",
                STRSUBSTNO(Text006,DummyInventoryProfileTrackBuffer."Warning Level",-Supply."Remaining Quantity (Base)",
                  PlanningStartDate));
              Supply.DELETE;
            END;

            IF LastAvailableInventory < TempSKU."Safety Stock Quantity" THEN BEGIN // Initial Safety Stock Warning
              SupplyAvailableWithinLeadTime := SumUpAvailableSupply(Supply,PlanningStartDate,PlanningStartDate);
              InitialProjectedInventory := LastAvailableInventory + SupplyAvailableWithinLeadTime;
              IF InitialProjectedInventory < TempSKU."Safety Stock Quantity" THEN
                CreateSupplyForInitialSafetyStockWarning(
                  Supply,
                  InitialProjectedInventory,LastProjectedInventory,LastAvailableInventory,
                  PlanningStartDate,RespectPlanningParm,IsReorderPointPlanning);
            END;

            IF IsReorderPointPlanning THEN BEGIN
              SupplyWithinLeadtime := SumUpProjectedSupply(Supply,PlanningStartDate,PlanningStartDate + BucketSizeInDays - 1);

              IF LastProjectedInventory + SupplyWithinLeadtime <= TempSKU."Reorder Point" THEN BEGIN
                InitSupply(Supply,0,0D);
                IF LastAvailableInventory < TempSKU."Safety Stock Quantity" THEN
                  CreateSupplyForward(Supply,PlanningStartDate,
                    TempSKU."Safety Stock Quantity" - LastAvailableInventory + LastProjectedInventory,
                    NewSupplyHasTakenOver,Demand."Due Date")
                ELSE
                  CreateSupplyForward(Supply,PlanningStartDate,LastProjectedInventory,NewSupplyHasTakenOver,Demand."Due Date");

                NeedOfPublishSurplus := Supply."Due Date" > ToDate;
              END;
            END;

            // Common balancing
            Demand.SETRANGE("Due Date",PlanningStartDate,ToDate);

            DemandExists := Demand.FINDSET;
            Demand.SETRANGE("Due Date");

            Supply.SETFILTER("Untracked Quantity",'>=0');
            SupplyExists := Supply.FINDSET;

            Supply.SETRANGE("Untracked Quantity");
            Supply.SETRANGE("Due Date");

            IF NOT SupplyExists THEN
              IF NOT Supply.ISEMPTY THEN BEGIN
                Supply.SETRANGE("Due Date",PlanningStartDate,ToDate);
                SupplyExists := Supply.FINDSET;
                Supply.SETRANGE("Due Date");
                IF NeedOfPublishSurplus AND NOT (DemandExists OR SupplyExists) THEN BEGIN
                  Track(Supply,Demand,TRUE,FALSE,Supply.Binding::" ");
                  Transparency.PublishSurplus(Supply,TempSKU,ReqLine,TempTrkgReservEntry);
                END;
              END;

            IF IsReorderPointPlanning THEN
              ChkInitialOverflow(Demand,Supply,
                OverflowLevel,LastProjectedInventory,PlanningStartDate,ToDate);

            CheckSupplyWithSKU(Supply,TempSKU);

            LotAccumulationPeriodStartDate := 0D;
            NextState := NextState::StartOver;
            WHILE PlanThisSKU DO
              CASE NextState OF
                NextState::StartOver:
                  BEGIN
                    IF DemandExists AND (Demand."Source Type" = DATABASE::"Transfer Line") THEN
                      WHILE CancelTransfer(Supply,Demand,DemandExists) DO
                        DemandExists := Demand.NEXT <> 0;

                    IF DemandExists THEN
                      IF Demand."Untracked Quantity" = 0 THEN
                        NextState := NextState::CloseDemand
                      ELSE
                        IF SupplyExists THEN
                          NextState := NextState::MatchDates
                        ELSE
                          NextState := NextState::CreateSupply
                    ELSE
                      IF SupplyExists THEN
                        NextState := NextState::ReduceSupply
                      ELSE
                        NextState := NextState::CloseLoop;
                  END;
                NextState::MatchDates:
                  BEGIN
                    OriginalSupplyDate := Supply."Due Date";
                    NewSupplyDate := Supply."Due Date";
                    WeAreSureThatDatesMatch := FALSE;

                    IF Demand."Due Date" < Supply."Due Date" THEN BEGIN
                      IF CheckScheduleIn(Supply,Demand."Due Date",NewSupplyDate,TRUE) THEN
                        WeAreSureThatDatesMatch := TRUE
                      ELSE
                        NextState := NextState::CreateSupply;
                    END ELSE
                      IF Demand."Due Date" > Supply."Due Date" THEN BEGIN
                        IF CheckScheduleOut(Supply,Demand."Due Date",NewSupplyDate,TRUE) THEN
                          WeAreSureThatDatesMatch := NOT ScheduleAllOutChangesSequence(Supply,NewSupplyDate)
                        ELSE
                          NextState := NextState::ReduceSupply;
                      END ELSE
                        WeAreSureThatDatesMatch := TRUE;

                    IF WeAreSureThatDatesMatch AND IsReorderPointPlanning THEN BEGIN
                      // Now we know the final position on the timeline of the supply.
                      MaintainProjectedInv(
                        InvChangeReminder,NewSupplyDate,LastProjectedInventory,LatestBucketStartDate,ROPHasBeenCrossed);
                      IF ROPHasBeenCrossed THEN BEGIN
                        CreateSupplyForward(Supply,LatestBucketStartDate,
                          LastProjectedInventory,NewSupplyHasTakenOver,Demand."Due Date");
                        IF NewSupplyHasTakenOver THEN BEGIN
                          WeAreSureThatDatesMatch := FALSE;
                          NextState := NextState::MatchDates;
                        END;
                      END;
                    END;

                    IF WeAreSureThatDatesMatch THEN BEGIN
                      IF NewSupplyDate <> OriginalSupplyDate THEN
                        Reschedule(Supply,NewSupplyDate,0T);
                      Supply.TESTFIELD("Due Date",NewSupplyDate);
                      Supply."Fixed Date" := Supply."Due Date"; // We note the latest possible date on the supply.
                      NextState := NextState::MatchQty;
                    END;
                  END;
                NextState::MatchQty:
                  PlanItemNextStateMatchQty(Demand,Supply,LastProjectedInventory,IsReorderPointPlanning,RespectPlanningParm);
                NextState::CreateSupply:
                  BEGIN
                    WeAreSureThatDatesMatch := TRUE; // We assume this is true at this point.....
                    IF FromLotAccumulationPeriodStartDate(LotAccumulationPeriodStartDate,Demand."Due Date") THEN
                      NewSupplyDate := LotAccumulationPeriodStartDate
                    ELSE BEGIN
                      NewSupplyDate := Demand."Due Date";
                      LotAccumulationPeriodStartDate := 0D;
                    END;
                    IF (NewSupplyDate >= LatestBucketStartDate) AND IsReorderPointPlanning THEN
                      MaintainProjectedInv(
                        InvChangeReminder,NewSupplyDate,LastProjectedInventory,LatestBucketStartDate,ROPHasBeenCrossed);
                    IF ROPHasBeenCrossed THEN BEGIN
                      CreateSupplyForward(Supply,LatestBucketStartDate,LastProjectedInventory,
                        NewSupplyHasTakenOver,Demand."Due Date");
                      IF NewSupplyHasTakenOver THEN BEGIN
                        SupplyExists := TRUE;
                        WeAreSureThatDatesMatch := FALSE;
                        NextState := NextState::MatchDates;
                      END;
                    END;

                    IF WeAreSureThatDatesMatch THEN BEGIN
                      IsExceptionOrder := IsReorderPointPlanning;
                      CreateSupply(Supply,Demand,
                        LastProjectedInventory +
                        QtyFromPendingReminders(InvChangeReminder,Demand."Due Date",LatestBucketStartDate) -
                        Demand."Remaining Quantity (Base)",
                        IsExceptionOrder,RespectPlanningParm);
                      Supply."Due Date" := NewSupplyDate;
                      Supply."Fixed Date" := Supply."Due Date"; // We note the latest possible date on the supply.
                      SupplyExists := TRUE;
                      IF IsExceptionOrder THEN BEGIN
                        DummyInventoryProfileTrackBuffer."Warning Level" :=
                          DummyInventoryProfileTrackBuffer."Warning Level"::Exception;
                        Transparency.LogWarning(Supply."Line No.",ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",
                          STRSUBSTNO(Text007,DummyInventoryProfileTrackBuffer."Warning Level",
                            TempSKU.FIELDCAPTION("Safety Stock Quantity"),TempSKU."Safety Stock Quantity",Demand."Due Date"));
                      END;
                      NextState := NextState::MatchQty;
                    END;
                  END;
                NextState::ReduceSupply:
                  BEGIN
                    IF IsReorderPointPlanning AND (Supply."Due Date" >= LatestBucketStartDate) THEN
                      MaintainProjectedInv(
                        InvChangeReminder,Supply."Due Date",LastProjectedInventory,LatestBucketStartDate,ROPHasBeenCrossed);
                    NewSupplyHasTakenOver := FALSE;
                    IF ROPHasBeenCrossed THEN BEGIN
                      CreateSupplyForward(Supply,LatestBucketStartDate,LastProjectedInventory,NewSupplyHasTakenOver,Supply."Due Date");
                      IF NewSupplyHasTakenOver THEN BEGIN
                        IF DemandExists THEN
                          NextState := NextState::MatchDates
                        ELSE
                          NextState := NextState::CloseSupply;
                      END;
                    END;

                    IF NOT NewSupplyHasTakenOver THEN
                      IF DecreaseQty(Supply,Supply."Untracked Quantity") THEN
                        NextState := NextState::CloseSupply
                      ELSE BEGIN
                        Supply."Max. Quantity" := Supply."Remaining Quantity (Base)";
                        IF DemandExists THEN
                          NextState := NextState::MatchQty
                        ELSE
                          NextState := NextState::CloseSupply;
                      END;
                  END;
                NextState::CloseDemand:
                  BEGIN
                    IF Demand."Due Date" < PlanningStartDate THEN
                      ERROR(Text001,Demand.FIELDCAPTION("Due Date"));

                    IF Demand."Order Relation" = Demand."Order Relation"::"Safety Stock" THEN BEGIN
                      AllocateSafetystock(Supply,Demand."Untracked Quantity",Demand."Due Date");
                      IF IsReorderPointPlanning AND (Supply."Due Date" >= LatestBucketStartDate) THEN
                        PostInvChgReminder(InvChangeReminder,Supply,TRUE);
                    END ELSE BEGIN
                      IF IsReorderPointPlanning THEN
                        PostInvChgReminder(InvChangeReminder,Demand,FALSE);

                      IF Demand."Untracked Quantity" <> 0 THEN BEGIN
                        Supply."Untracked Quantity" -= Demand."Untracked Quantity";

                        IF Supply."Untracked Quantity" < Supply."Safety Stock Quantity" THEN
                          Supply."Safety Stock Quantity" := Supply."Untracked Quantity";

                        IF Supply."Action Message" <> Supply."Action Message"::" " THEN
                          MaintainPlanningLine(Supply,PlanningLineStage::"Line Created",ScheduleDirection::Backward);
                        Supply.MODIFY;

                        IF IsReorderPointPlanning AND (Supply."Due Date" >= LatestBucketStartDate) THEN
                          PostInvChgReminder(InvChangeReminder,Supply,TRUE);

                        CheckSupplyAndTrack(Demand,Supply);
                        SurplusType := Transparency.FindReason(Demand);
                        IF SurplusType <> SurplusType::None THEN
                          Transparency.LogSurplus(
                            Supply."Line No.",Demand."Line No.",
                            Demand."Source Type",Demand."Source ID",
                            Demand."Untracked Quantity",SurplusType);
                      END;
                    END;

                    Demand.DELETE;

                    // If just handled demand was safetystock
                    IF Demand."Order Relation" = Demand."Order Relation"::"Safety Stock" THEN
                      SupplyExists := Supply.FINDSET(TRUE); // We assume that next profile is NOT safety stock

                    DemandExists := Demand.NEXT <> 0;
                    NextState := NextState::StartOver;
                  END;
                NextState::CloseSupply:
                  BEGIN
                    IF DemandExists AND (Supply."Untracked Quantity" > 0) THEN BEGIN
                      Demand."Untracked Quantity" -= Supply."Untracked Quantity";
                      Demand.MODIFY;
                    END;

                    IF DemandExists AND (Demand."Order Relation" = Demand."Order Relation"::"Safety Stock") THEN BEGIN
                      AllocateSafetystock(Supply,Supply."Untracked Quantity",Demand."Due Date");
                      IF IsReorderPointPlanning AND (Supply."Due Date" >= LatestBucketStartDate) THEN
                        PostInvChgReminder(InvChangeReminder,Supply,TRUE);
                    END ELSE BEGIN
                      IF IsReorderPointPlanning AND (Supply."Due Date" >= LatestBucketStartDate) THEN
                        PostInvChgReminder(InvChangeReminder,Supply,FALSE);

                      IF Supply."Action Message" <> Supply."Action Message"::" " THEN
                        MaintainPlanningLine(Supply,PlanningLineStage::Exploded,ScheduleDirection::Backward)
                      ELSE
                        Supply.TESTFIELD("Planning Line No.",0);

                      IF (Supply."Action Message" = Supply."Action Message"::New) OR
                         (Supply."Due Date" <= ToDate)
                      THEN
                        IF DemandExists THEN
                          Track(Supply,Demand,FALSE,FALSE,Supply.Binding)
                        ELSE
                          Track(Supply,Demand,TRUE,FALSE,Supply.Binding::" ");
                      Supply.DELETE;

                      // Planning Transparency
                      IF DemandExists THEN BEGIN
                        SurplusType := Transparency.FindReason(Demand);
                        IF SurplusType <> SurplusType::None THEN
                          Transparency.LogSurplus(Supply."Line No.",Demand."Line No.",
                            Demand."Source Type",Demand."Source ID",
                            Supply."Untracked Quantity",SurplusType);
                      END;
                      IF Supply."Planning Line No." <> 0 THEN BEGIN
                        IF Supply."Safety Stock Quantity" > 0 THEN
                          Transparency.LogSurplus(Supply."Line No.",Supply."Line No.",0,'',
                            Supply."Safety Stock Quantity",SurplusType::SafetyStock);
                        IF Supply."Planning Line No." <> ReqLine."Line No." THEN
                          ReqLine.GET(CurrTemplateName,CurrWorksheetName,Supply."Planning Line No.");
                        Transparency.PublishSurplus(Supply,TempSKU,ReqLine,TempTrkgReservEntry);
                      END ELSE
                        Transparency.CleanLog(Supply."Line No.");
                    END;
                    IF TempSKU."Maximum Order Quantity" > 0 THEN
                      CheckSupplyRemQtyAndUntrackQty(Supply);
                    SupplyExists := Supply.NEXT <> 0;
                    NextState := NextState::StartOver;
                  END;
                NextState::CloseLoop:
                  BEGIN
                    IF IsReorderPointPlanning THEN
                      MaintainProjectedInv(
                        InvChangeReminder,ToDate,LastProjectedInventory,LatestBucketStartDate,ROPHasBeenCrossed);
                    IF ROPHasBeenCrossed THEN BEGIN
                      CreateSupplyForward(Supply,LatestBucketStartDate,LastProjectedInventory,NewSupplyHasTakenOver,Demand."Due Date");
                      SupplyExists := TRUE;
                      NextState := NextState::StartOver;
                    END ELSE
                      PlanThisSKU := FALSE;
                  END;
                ELSE
                  ERROR(Text001,SELECTSTR(NextState + 1,NextStateTxt));
              END;
          END;
        UNTIL TempSKU.NEXT = 0;
      SetAcceptAction(TempSKU."Item No.");
    END;

    LOCAL PROCEDURE PlanItemNextStateMatchQty@134(VAR DemandInventoryProfile@1001 : Record 99000853;VAR SupplyInventoryProfile@1000 : Record 99000853;VAR LastProjectedInventory@1004 : Decimal;IsReorderPointPlanning@1002 : Boolean;RespectPlanningParm@1003 : Boolean);
    BEGIN
      CASE TRUE OF
        SupplyInventoryProfile."Untracked Quantity" >= DemandInventoryProfile."Untracked Quantity":
          NextState := NextState::CloseDemand;
        ShallSupplyBeClosed(SupplyInventoryProfile,DemandInventoryProfile."Due Date",IsReorderPointPlanning):
          NextState := NextState::CloseSupply;
        IncreaseQtyToMeetDemand(
          SupplyInventoryProfile,DemandInventoryProfile,TRUE,RespectPlanningParm,
          NOT SKURequiresLotAccumulation(TempSKU)):
          BEGIN
            NextState := NextState::CloseDemand;
            // initial Safety Stock can be changed to normal, if we can increase qty for normal demand
            IF (SupplyInventoryProfile."Order Relation" = SupplyInventoryProfile."Order Relation"::"Safety Stock") AND
               (DemandInventoryProfile."Order Relation" = DemandInventoryProfile."Order Relation"::Normal)
            THEN BEGIN
              SupplyInventoryProfile."Order Relation" := SupplyInventoryProfile."Order Relation"::Normal;
              LastProjectedInventory -= TempSKU."Safety Stock Quantity";
            END;
          END;
        ELSE BEGIN
          NextState := NextState::CloseSupply;
          IF TempSKU."Maximum Order Quantity" > 0 THEN
            LotAccumulationPeriodStartDate := SupplyInventoryProfile."Due Date";
        END;
      END;
    END;

    LOCAL PROCEDURE FilterDemandSupplyRelatedToSKU@23(VAR InventoryProfile@1000 : Record 99000853);
    BEGIN
      InventoryProfile.SETRANGE("Item No.",TempSKU."Item No.");
      InventoryProfile.SETRANGE("Variant Code",TempSKU."Variant Code");
      InventoryProfile.SETRANGE("Location Code",TempSKU."Location Code");
    END;

    LOCAL PROCEDURE ScheduleForward@33(VAR Supply@1000 : Record 99000853;StartingDate@1001 : Date);
    BEGIN
      Supply."Starting Date" := StartingDate;
      MaintainPlanningLine(Supply,PlanningLineStage::"Routing Created",ScheduleDirection::Forward);
      IF (Supply."Fixed Date" > 0D) AND
         (Supply."Fixed Date" < Supply."Due Date")
      THEN
        Supply."Due Date" := Supply."Fixed Date"
      ELSE
        Supply."Fixed Date" := Supply."Due Date";
    END;

    LOCAL PROCEDURE IncreaseQtyToMeetDemand@8(VAR Supply@1000 : Record 99000853;DemandInvtProfile@1001 : Record 99000853;LimitedHorizon@1004 : Boolean;RespectPlanningParm@1003 : Boolean;CheckSourceType@1005 : Boolean) : Boolean;
    VAR
      TotalDemandedQty@1002 : Decimal;
    BEGIN
      IF Supply."Planning Flexibility" <> Supply."Planning Flexibility"::Unlimited THEN
        EXIT(FALSE);

      IF CheckSourceType THEN
        IF (DemandInvtProfile."Source Type" = DATABASE::"Planning Component") AND
           (Supply."Source Type" = DATABASE::"Prod. Order Line")
        THEN
          EXIT(FALSE);

      IF (Supply."Max. Quantity" > 0) OR (Supply."Action Message" = Supply."Action Message"::Cancel) THEN
        IF Supply."Max. Quantity" <= Supply."Remaining Quantity (Base)" THEN
          EXIT(FALSE);

      IF LimitedHorizon THEN
        IF NOT AllowLotAccumulation(Supply,DemandInvtProfile."Due Date") THEN
          EXIT(FALSE);

      TotalDemandedQty := DemandInvtProfile."Untracked Quantity";
      IncreaseQty(Supply,DemandInvtProfile."Untracked Quantity" - Supply."Untracked Quantity",RespectPlanningParm);
      EXIT(TotalDemandedQty <= Supply."Untracked Quantity");
    END;

    LOCAL PROCEDURE IncreaseQty@28(VAR Supply@1000 : Record 99000853;NeededQty@1001 : Decimal;RespectPlanningParm@1003 : Boolean);
    VAR
      TempQty@1002 : Decimal;
    BEGIN
      TempQty := Supply."Remaining Quantity (Base)";

      IF NOT Supply."Is Exception Order" OR RespectPlanningParm THEN
        Supply."Remaining Quantity (Base)" += NeededQty +
          AdjustReorderQty(
            Supply."Remaining Quantity (Base)" + NeededQty,TempSKU,Supply."Line No.",Supply."Min. Quantity")
      ELSE
        Supply."Remaining Quantity (Base)" += NeededQty;

      IF TempSKU."Maximum Order Quantity" > 0 THEN
        IF Supply."Remaining Quantity (Base)" > TempSKU."Maximum Order Quantity" THEN
          Supply."Remaining Quantity (Base)" := TempSKU."Maximum Order Quantity";
      IF (Supply."Action Message" <> Supply."Action Message"::New) AND
         (Supply."Remaining Quantity (Base)" <> TempQty)
      THEN BEGIN
        IF Supply."Original Quantity" = 0 THEN
          Supply."Original Quantity" := Supply.Quantity;
        IF Supply."Original Due Date" = 0D THEN
          Supply."Action Message" := Supply."Action Message"::"Change Qty."
        ELSE
          Supply."Action Message" := Supply."Action Message"::"Resched.& Chg. Qty.";
      END;

      Supply."Untracked Quantity" :=
        Supply."Untracked Quantity" +
        Supply."Remaining Quantity (Base)" -
        TempQty;

      Supply."Quantity (Base)" :=
        Supply."Quantity (Base)" +
        Supply."Remaining Quantity (Base)" -
        TempQty;
      Supply.MODIFY;
    END;

    LOCAL PROCEDURE DecreaseQty@63(VAR Supply@1000 : Record 99000853;ReduceQty@1001 : Decimal) : Boolean;
    VAR
      TempQty@1002 : Decimal;
    BEGIN
      IF NOT CanDecreaseSupply(Supply,ReduceQty) THEN BEGIN
        IF (ReduceQty <= DampenerQty) AND (Supply."Planning Level Code" = 0) THEN
          Transparency.LogSurplus(
            Supply."Line No.",0,
            DATABASE::"Manufacturing Setup",Supply."Source ID",
            DampenerQty,SurplusType::DampenerQty);
        EXIT(FALSE);
      END;

      IF ReduceQty > 0 THEN BEGIN
        TempQty := Supply."Remaining Quantity (Base)";

        Supply."Remaining Quantity (Base)" :=
          Supply."Remaining Quantity (Base)" - ReduceQty +
          AdjustReorderQty(Supply."Remaining Quantity (Base)" - ReduceQty,TempSKU,Supply."Line No.",Supply."Min. Quantity");

        IF TempSKU."Maximum Order Quantity" > 0 THEN
          IF Supply."Remaining Quantity (Base)" > TempSKU."Maximum Order Quantity" THEN
            Supply."Remaining Quantity (Base)" := TempSKU."Maximum Order Quantity";
        IF (Supply."Action Message" <> Supply."Action Message"::New) AND
           (TempQty <> Supply."Remaining Quantity (Base)")
        THEN BEGIN
          IF Supply."Original Quantity" = 0 THEN
            Supply."Original Quantity" := Supply.Quantity;
          IF Supply."Remaining Quantity (Base)" = 0 THEN
            Supply."Action Message" := Supply."Action Message"::Cancel
          ELSE
            IF Supply."Original Due Date" = 0D THEN
              Supply."Action Message" := Supply."Action Message"::"Change Qty."
            ELSE
              Supply."Action Message" := Supply."Action Message"::"Resched.& Chg. Qty.";
        END;

        Supply."Untracked Quantity" :=
          Supply."Untracked Quantity" -
          TempQty +
          Supply."Remaining Quantity (Base)";

        Supply."Quantity (Base)" :=
          Supply."Quantity (Base)" -
          TempQty +
          Supply."Remaining Quantity (Base)";

        Supply.MODIFY;
      END;

      EXIT(Supply."Untracked Quantity" = 0);
    END;

    LOCAL PROCEDURE CanDecreaseSupply@154(InventoryProfileSupply@1000 : Record 99000853;VAR ReduceQty@1001 : Decimal) : Boolean;
    VAR
      TrackedQty@1002 : Decimal;
    BEGIN
      WITH InventoryProfileSupply DO BEGIN
        IF ReduceQty > "Untracked Quantity" THEN
          ReduceQty := "Untracked Quantity";
        IF "Min. Quantity" > "Remaining Quantity (Base)" - ReduceQty THEN
          ReduceQty := "Remaining Quantity (Base)" - "Min. Quantity";

        // Ensure leaving enough untracked qty. to cover the safety stock
        TrackedQty := "Remaining Quantity (Base)" - "Untracked Quantity";
        IF TrackedQty + "Safety Stock Quantity" > "Remaining Quantity (Base)" - ReduceQty THEN
          ReduceQty := "Remaining Quantity (Base)" - (TrackedQty + "Safety Stock Quantity");

        // Planning Transparency
        IF (ReduceQty <= DampenerQty) AND ("Planning Level Code" = 0) THEN
          EXIT(FALSE);

        IF ("Planning Flexibility" = "Planning Flexibility"::None) OR
           ((ReduceQty <= DampenerQty) AND
            ("Planning Level Code" = 0))
        THEN
          EXIT(FALSE);

        EXIT(TRUE);
      END;
    END;

    LOCAL PROCEDURE CreateSupply@53(VAR Supply@1000 : Record 99000853;VAR Demand@1002 : Record 99000853;ProjectedInventory@1006 : Decimal;IsExceptionOrder@1001 : Boolean;RespectPlanningParm@1003 : Boolean);
    VAR
      ReorderQty@1005 : Decimal;
    BEGIN
      InitSupply(Supply,0,Demand."Due Date");
      ReorderQty := Demand."Untracked Quantity";
      IF (NOT IsExceptionOrder) OR RespectPlanningParm THEN BEGIN
        IF NOT RespectPlanningParm THEN
          ReorderQty := CalcReorderQty(ReorderQty,ProjectedInventory,Supply."Line No.")
        ELSE
          IF IsExceptionOrder THEN BEGIN
            IF Demand."Order Relation" = Demand."Order Relation"::"Safety Stock" THEN // Compensate for Safety Stock offset
              ProjectedInventory := ProjectedInventory + Demand."Remaining Quantity (Base)";
            ReorderQty := CalcReorderQty(ReorderQty,ProjectedInventory,Supply."Line No.");
            IF ReorderQty < -ProjectedInventory THEN
              ReorderQty :=
                ROUND(-ProjectedInventory / TempSKU."Reorder Quantity" + ExceedROPqty,1,'>') *
                TempSKU."Reorder Quantity";
          END;

        ReorderQty += AdjustReorderQty(ReorderQty,TempSKU,Supply."Line No.",Supply."Min. Quantity");
        Supply."Max. Quantity" := TempSKU."Maximum Order Quantity";
      END;
      UpdateQty(Supply,ReorderQty);
      IF TempSKU."Maximum Order Quantity" > 0 THEN BEGIN
        IF Supply."Remaining Quantity (Base)" > TempSKU."Maximum Order Quantity" THEN
          Supply."Remaining Quantity (Base)" := TempSKU."Maximum Order Quantity";
        IF Supply."Untracked Quantity" >= TempSKU."Maximum Order Quantity" THEN
          Supply."Untracked Quantity" :=
            Supply."Untracked Quantity" -
            ReorderQty +
            Supply."Remaining Quantity (Base)";
      END;
      Supply."Min. Quantity" := Supply."Remaining Quantity (Base)";
      TransferAttributes(Supply,Demand);
      Supply."Is Exception Order" := IsExceptionOrder;
      Supply.INSERT;
      IF (NOT IsExceptionOrder OR RespectPlanningParm) AND (OverflowLevel > 0) THEN
        // the new supply might cause overflow in inventory since
        // it wasn't considered when Overflow was calculated
        CheckNewOverflow(Supply,ProjectedInventory + ReorderQty,ReorderQty,Supply."Due Date");
    END;

    LOCAL PROCEDURE CreateDemand@17(VAR Demand@1000 : Record 99000853;VAR SKU@1001 : Record 5700;NeededQuantity@1002 : Decimal;NeededDueDate@1003 : Date;OrderRelation@1004 : 'Normal,Safety Stock,Reorder Point');
    BEGIN
      Demand.INIT;
      Demand."Line No." := NextLineNo;
      Demand."Item No." := SKU."Item No.";
      Demand."Variant Code" := SKU."Variant Code";
      Demand."Location Code" := SKU."Location Code";
      Demand."Quantity (Base)" := NeededQuantity;
      Demand."Remaining Quantity (Base)" := NeededQuantity;
      Demand.IsSupply := FALSE;
      Demand."Order Relation" := OrderRelation;
      Demand."Source Type" := 0;
      Demand."Untracked Quantity" := NeededQuantity;
      Demand."Due Date" := NeededDueDate;
      Demand."Planning Flexibility" := Demand."Planning Flexibility"::None;
      Demand.INSERT;
    END;

    LOCAL PROCEDURE Track@19(FromProfile@1000 : Record 99000853;ToProfile@1001 : Record 99000853;IsSurplus@1002 : Boolean;IssueActionMessage@1003 : Boolean;Binding@1004 : ' ,Order-to-Order');
    VAR
      TrkgReservEntryArray@1005 : ARRAY [6] OF Record 337;
      SplitState@1009 : 'NoSplit,SplitFromProfile,SplitToProfile,Cancel';
      SplitQty@1006 : Decimal;
      SplitQty2@1007 : Decimal;
      TrackQty@1008 : Decimal;
      DecreaseSupply@1010 : Boolean;
    BEGIN
      DecreaseSupply :=
        FromProfile.IsSupply AND
        (FromProfile."Action Message" IN [FromProfile."Action Message"::"Change Qty.",
                                          FromProfile."Action Message"::"Resched.& Chg. Qty."]) AND
        (FromProfile."Quantity (Base)" < FromProfile."Original Quantity" * FromProfile."Qty. per Unit of Measure");

      IF ((FromProfile."Action Message" = FromProfile."Action Message"::Cancel) AND
          (FromProfile."Untracked Quantity" = 0)) OR (DecreaseSupply AND IsSurplus)
      THEN BEGIN
        IsSurplus := FALSE;
        IF DecreaseSupply THEN
          FromProfile."Untracked Quantity" :=
            FromProfile."Original Quantity" * FromProfile."Qty. per Unit of Measure" - FromProfile."Quantity (Base)"
        ELSE
          IF FromProfile.IsSupply THEN
            FromProfile."Untracked Quantity" := FromProfile."Remaining Quantity" * FromProfile."Qty. per Unit of Measure"
          ELSE
            FromProfile."Untracked Quantity" := -FromProfile."Remaining Quantity" * FromProfile."Qty. per Unit of Measure";
        FromProfile.TransferToTrackingEntry(TrkgReservEntryArray[1],FALSE);
        TrkgReservEntryArray[3] := TrkgReservEntryArray[1];
        ReqLine.TransferToTrackingEntry(TrkgReservEntryArray[3],TRUE);
        IF FromProfile.IsSupply THEN
          TrkgReservEntryArray[3]."Shipment Date" := FromProfile."Due Date"
        ELSE
          TrkgReservEntryArray[3]."Expected Receipt Date" := FromProfile."Due Date";
        SplitState := SplitState::Cancel;
      END ELSE BEGIN
        TrackQty := FromProfile."Untracked Quantity";

        IF FromProfile.IsSupply THEN BEGIN
          IF NOT ((FromProfile."Original Quantity" * FromProfile."Qty. per Unit of Measure" > FromProfile."Quantity (Base)") OR
                  (FromProfile."Untracked Quantity" > 0))
          THEN
            EXIT;

          SplitQty := FromProfile."Original Quantity" * FromProfile."Qty. per Unit of Measure" +
            FromProfile."Untracked Quantity" - FromProfile."Quantity (Base)";

          CASE FromProfile."Action Message" OF
            FromProfile."Action Message"::"Resched.& Chg. Qty.",
            FromProfile."Action Message"::Reschedule,
            FromProfile."Action Message"::New,
            FromProfile."Action Message"::"Change Qty.":
              BEGIN
                IF (SplitQty > 0) AND (SplitQty < TrackQty) THEN BEGIN
                  SplitState := SplitState::SplitFromProfile;
                  FromProfile.TransferToTrackingEntry(TrkgReservEntryArray[1],
                    (FromProfile."Action Message" = FromProfile."Action Message"::Reschedule) OR
                    (FromProfile."Action Message" = FromProfile."Action Message"::"Resched.& Chg. Qty."));
                  TrkgReservEntryArray[3] := TrkgReservEntryArray[1];
                  ReqLine.TransferToTrackingEntry(TrkgReservEntryArray[3],TRUE);
                  IF IsSurplus THEN BEGIN
                    TrkgReservEntryArray[3]."Quantity (Base)" := TrackQty - SplitQty;
                    TrkgReservEntryArray[1]."Quantity (Base)" := SplitQty;
                  END ELSE BEGIN
                    TrkgReservEntryArray[1]."Quantity (Base)" := TrackQty - SplitQty;
                    TrkgReservEntryArray[3]."Quantity (Base)" := SplitQty;
                  END;
                  TrkgReservEntryArray[1].Quantity :=
                    ROUND(TrkgReservEntryArray[1]."Quantity (Base)" / TrkgReservEntryArray[1]."Qty. per Unit of Measure",0.00001);
                  TrkgReservEntryArray[3].Quantity :=
                    ROUND(TrkgReservEntryArray[3]."Quantity (Base)" / TrkgReservEntryArray[3]."Qty. per Unit of Measure",0.00001);
                END ELSE BEGIN
                  FromProfile.TransferToTrackingEntry(TrkgReservEntryArray[1],FALSE);
                  ReqLine.TransferToTrackingEntry(TrkgReservEntryArray[1],TRUE);
                END;
                IF IsSurplus THEN BEGIN
                  TrkgReservEntryArray[4] := TrkgReservEntryArray[1];
                  ReqLine.TransferToTrackingEntry(TrkgReservEntryArray[4],TRUE);
                  TrkgReservEntryArray[4]."Shipment Date" := ReqLine."Due Date";
                END;
                ToProfile.TransferToTrackingEntry(TrkgReservEntryArray[2],FALSE);
              END;
            ELSE
              FromProfile.TransferToTrackingEntry(TrkgReservEntryArray[1],FALSE);
              ToProfile.TransferToTrackingEntry(TrkgReservEntryArray[2],
                (ToProfile."Source Type" = DATABASE::"Planning Component") AND
                (ToProfile."Primary Order Status" > 1)); // Firm Planned, Released Prod.Order
          END;
        END ELSE BEGIN
          ToProfile.TESTFIELD(IsSupply,TRUE);
          SplitQty := ToProfile."Remaining Quantity" * ToProfile."Qty. per Unit of Measure" + ToProfile."Untracked Quantity" +
            FromProfile."Untracked Quantity" - ToProfile."Quantity (Base)";

          IF FromProfile."Source Type" = DATABASE::"Planning Component" THEN BEGIN
            SplitQty2 := FromProfile."Original Quantity" * FromProfile."Qty. per Unit of Measure";
            IF FromProfile."Untracked Quantity" < SplitQty2 THEN
              SplitQty2 := FromProfile."Untracked Quantity";
            IF SplitQty2 > SplitQty THEN
              SplitQty2 := SplitQty;
          END;

          IF SplitQty2 > 0 THEN BEGIN
            ToProfile.TransferToTrackingEntry(TrkgReservEntryArray[5],FALSE);
            IF ToProfile."Action Message" = ToProfile."Action Message"::New THEN BEGIN
              ReqLine.TransferToTrackingEntry(TrkgReservEntryArray[5],TRUE);
              FromProfile.TransferToTrackingEntry(TrkgReservEntryArray[6],FALSE);
            END ELSE
              FromProfile.TransferToTrackingEntry(TrkgReservEntryArray[6],TRUE);
            TrkgReservEntryArray[5]."Quantity (Base)" := SplitQty2;
            TrkgReservEntryArray[5].Quantity :=
              ROUND(TrkgReservEntryArray[5]."Quantity (Base)" / TrkgReservEntryArray[5]."Qty. per Unit of Measure",0.00001);
            FromProfile."Untracked Quantity" := FromProfile."Untracked Quantity" - SplitQty2;
            TrackQty := TrackQty - SplitQty2;
            SplitQty := SplitQty - SplitQty2;
            PrepareTempTracking(TrkgReservEntryArray[5],TrkgReservEntryArray[6],IsSurplus,IssueActionMessage,Binding);
          END;

          IF (ToProfile."Action Message" <> ToProfile."Action Message"::" ") AND
             (SplitQty < TrackQty)
          THEN BEGIN
            IF (SplitQty > 0) AND (SplitQty < TrackQty) THEN BEGIN
              SplitState := SplitState::SplitToProfile;
              ToProfile.TransferToTrackingEntry(TrkgReservEntryArray[2],
                (FromProfile."Action Message" = FromProfile."Action Message"::Reschedule) OR
                (FromProfile."Action Message" = FromProfile."Action Message"::"Resched.& Chg. Qty."));
              TrkgReservEntryArray[3] := TrkgReservEntryArray[2];
              ReqLine.TransferToTrackingEntry(TrkgReservEntryArray[2],TRUE);
              TrkgReservEntryArray[2]."Quantity (Base)" := TrackQty - SplitQty;
              TrkgReservEntryArray[3]."Quantity (Base)" := SplitQty;
              TrkgReservEntryArray[2].Quantity :=
                ROUND(TrkgReservEntryArray[2]."Quantity (Base)" / TrkgReservEntryArray[2]."Qty. per Unit of Measure",0.00001);
              TrkgReservEntryArray[3].Quantity :=
                ROUND(TrkgReservEntryArray[3]."Quantity (Base)" / TrkgReservEntryArray[3]."Qty. per Unit of Measure",0.00001);
            END ELSE BEGIN
              ToProfile.TransferToTrackingEntry(TrkgReservEntryArray[2],FALSE);
              ReqLine.TransferToTrackingEntry(TrkgReservEntryArray[2],TRUE);
            END;
          END ELSE
            ToProfile.TransferToTrackingEntry(TrkgReservEntryArray[2],FALSE);
          FromProfile.TransferToTrackingEntry(TrkgReservEntryArray[1],FALSE);
        END;
      END;

      CASE SplitState OF
        SplitState::NoSplit:
          PrepareTempTracking(TrkgReservEntryArray[1],TrkgReservEntryArray[2],IsSurplus,IssueActionMessage,Binding);
        SplitState::SplitFromProfile:
          IF IsSurplus THEN BEGIN
            PrepareTempTracking(TrkgReservEntryArray[1],TrkgReservEntryArray[4],FALSE,IssueActionMessage,Binding);
            PrepareTempTracking(TrkgReservEntryArray[3],TrkgReservEntryArray[4],TRUE,IssueActionMessage,Binding);
          END ELSE BEGIN
            TrkgReservEntryArray[4] := TrkgReservEntryArray[2];
            PrepareTempTracking(TrkgReservEntryArray[1],TrkgReservEntryArray[2],IsSurplus,IssueActionMessage,Binding);
            PrepareTempTracking(TrkgReservEntryArray[3],TrkgReservEntryArray[4],IsSurplus,IssueActionMessage,Binding);
          END;
        SplitState::SplitToProfile:
          BEGIN
            TrkgReservEntryArray[4] := TrkgReservEntryArray[1];
            PrepareTempTracking(TrkgReservEntryArray[2],TrkgReservEntryArray[1],IsSurplus,IssueActionMessage,Binding);
            PrepareTempTracking(TrkgReservEntryArray[3],TrkgReservEntryArray[4],IsSurplus,IssueActionMessage,Binding);
          END;
        SplitState::Cancel:
          PrepareTempTracking(TrkgReservEntryArray[1],TrkgReservEntryArray[3],IsSurplus,IssueActionMessage,Binding);
      END;
    END;

    LOCAL PROCEDURE PrepareTempTracking@35(VAR FromTrkgReservEntry@1000 : Record 337;VAR ToTrkgReservEntry@1001 : Record 337;IsSurplus@1002 : Boolean;IssueActionMessage@1003 : Boolean;Binding@1004 : ' ,Order-to-Order');
    BEGIN
      IF NOT IsSurplus THEN BEGIN
        ToTrkgReservEntry."Quantity (Base)" := -FromTrkgReservEntry."Quantity (Base)";
        ToTrkgReservEntry.Quantity :=
          ROUND(ToTrkgReservEntry."Quantity (Base)" / ToTrkgReservEntry."Qty. per Unit of Measure",0.00001);
      END ELSE
        ToTrkgReservEntry."Suppressed Action Msg." := NOT IssueActionMessage;

      ToTrkgReservEntry.Positive := ToTrkgReservEntry."Quantity (Base)" > 0;
      FromTrkgReservEntry.Positive := FromTrkgReservEntry."Quantity (Base)" > 0;

      FromTrkgReservEntry.Binding := Binding;
      ToTrkgReservEntry.Binding := Binding;

      IF IsSurplus OR (ToTrkgReservEntry."Reservation Status" = ToTrkgReservEntry."Reservation Status"::Surplus) THEN BEGIN
        FromTrkgReservEntry."Reservation Status" := FromTrkgReservEntry."Reservation Status"::Surplus;
        FromTrkgReservEntry."Suppressed Action Msg." := ToTrkgReservEntry."Suppressed Action Msg.";
        InsertTempTracking(FromTrkgReservEntry,ToTrkgReservEntry);
        EXIT;
      END;

      IF FromTrkgReservEntry."Reservation Status" = FromTrkgReservEntry."Reservation Status"::Surplus THEN BEGIN
        ToTrkgReservEntry."Reservation Status" := ToTrkgReservEntry."Reservation Status"::Surplus;
        ToTrkgReservEntry."Suppressed Action Msg." := FromTrkgReservEntry."Suppressed Action Msg.";
        InsertTempTracking(ToTrkgReservEntry,FromTrkgReservEntry);
        EXIT;
      END;

      InsertTempTracking(FromTrkgReservEntry,ToTrkgReservEntry);
    END;

    LOCAL PROCEDURE InsertTempTracking@26(VAR FromTrkgReservEntry@1000 : Record 337;VAR ToTrkgReservEntry@1001 : Record 337);
    VAR
      NextEntryNo@1002 : Integer;
      ShouldInsert@1004 : Boolean;
    BEGIN
      IF FromTrkgReservEntry."Quantity (Base)" = 0 THEN
        EXIT;
      NextEntryNo := TempTrkgReservEntry."Entry No." + 1;

      IF FromTrkgReservEntry."Reservation Status" = FromTrkgReservEntry."Reservation Status"::Surplus THEN BEGIN
        TempTrkgReservEntry := FromTrkgReservEntry;
        TempTrkgReservEntry."Entry No." := NextEntryNo;
        SetQtyToHandle(TempTrkgReservEntry);
        TempTrkgReservEntry.INSERT;
      END ELSE BEGIN
        MatchReservationEntries(FromTrkgReservEntry,ToTrkgReservEntry);
        IF FromTrkgReservEntry.Positive THEN BEGIN
          FromTrkgReservEntry."Shipment Date" := ToTrkgReservEntry."Shipment Date";
          IF ToTrkgReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN
            ToTrkgReservEntry."Shipment Date" := DMY2DATE(31,12,9999);
          ToTrkgReservEntry."Expected Receipt Date" := FromTrkgReservEntry."Expected Receipt Date";
        END ELSE BEGIN
          ToTrkgReservEntry."Shipment Date" := FromTrkgReservEntry."Shipment Date";
          IF FromTrkgReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN
            FromTrkgReservEntry."Shipment Date" := DMY2DATE(31,12,9999);
          FromTrkgReservEntry."Expected Receipt Date" := ToTrkgReservEntry."Expected Receipt Date";
        END;

        IF FromTrkgReservEntry.Positive THEN
          ShouldInsert := ShouldInsertTrackingEntry(FromTrkgReservEntry)
        ELSE
          ShouldInsert := ShouldInsertTrackingEntry(ToTrkgReservEntry);

        IF ShouldInsert THEN BEGIN
          TempTrkgReservEntry := FromTrkgReservEntry;
          TempTrkgReservEntry."Entry No." := NextEntryNo;
          SetQtyToHandle(TempTrkgReservEntry);
          TempTrkgReservEntry.INSERT;

          TempTrkgReservEntry := ToTrkgReservEntry;
          TempTrkgReservEntry."Entry No." := NextEntryNo;
          SetQtyToHandle(TempTrkgReservEntry);
          TempTrkgReservEntry.INSERT;
        END;
      END;
    END;

    LOCAL PROCEDURE SetQtyToHandle@51(VAR TrkgReservEntry@1000 : Record 337);
    VAR
      PickedQty@1001 : Decimal;
    BEGIN
      IF NOT TrkgReservEntry.TrackingExists THEN
        EXIT;

      PickedQty := QtyPickedForSourceDocument(TrkgReservEntry);

      IF PickedQty <> 0 THEN BEGIN
        TrkgReservEntry."Qty. to Handle (Base)" := PickedQty;
        TrkgReservEntry."Qty. to Invoice (Base)" := PickedQty;
      END ELSE BEGIN
        TrkgReservEntry."Qty. to Handle (Base)" := TrkgReservEntry."Quantity (Base)";
        TrkgReservEntry."Qty. to Invoice (Base)" := TrkgReservEntry."Quantity (Base)";
      END;
    END;

    LOCAL PROCEDURE CommitTracking@29();
    VAR
      PrevTempEntryNo@1000 : Integer;
      PrevInsertedEntryNo@1001 : Integer;
    BEGIN
      IF NOT TempTrkgReservEntry.FIND('-') THEN
        EXIT;

      REPEAT
        ReservEntry := TempTrkgReservEntry;
        IF TempTrkgReservEntry."Entry No." = PrevTempEntryNo THEN
          ReservEntry."Entry No." := PrevInsertedEntryNo
        ELSE
          ReservEntry."Entry No." := 0;
        ReservEntry.UpdateItemTracking;
        UpdateAppliedItemEntry(ReservEntry);
        ReservEntry.INSERT;
        PrevTempEntryNo := TempTrkgReservEntry."Entry No.";
        PrevInsertedEntryNo := ReservEntry."Entry No.";
        TempTrkgReservEntry.DELETE;
      UNTIL TempTrkgReservEntry.NEXT = 0;
      CLEAR(TempTrkgReservEntry);
    END;

    LOCAL PROCEDURE MaintainPlanningLine@27(VAR Supply@1000 : Record 99000853;NewPhase@1001 : ' ,Line Created,Routing Created,Exploded,Obsolete';Direction@1002 : 'Forward,Backward');
    VAR
      PurchaseLine@1003 : Record 39;
      ProdOrderLine@1004 : Record 5406;
      AsmHeader@1008 : Record 900;
      TransLine@1007 : Record 5741;
      CrntSupply@1005 : Record 99000853;
      PlanLineNo@1006 : Integer;
      RecalculationRequired@1009 : Boolean;
    BEGIN
      IF (NewPhase = NewPhase::"Line Created") OR
         (Supply."Planning Line Phase" < Supply."Planning Line Phase"::"Line Created")
      THEN
        IF Supply."Planning Line No." = 0 THEN
          WITH ReqLine DO BEGIN
            BlockDynamicTracking(TRUE);
            IF FINDLAST THEN
              PlanLineNo := "Line No." + 10000
            ELSE
              PlanLineNo := 10000;
            INIT;
            "Worksheet Template Name" := CurrTemplateName;
            "Journal Batch Name" := CurrWorksheetName;
            "Line No." := PlanLineNo;
            Type := Type::Item;
            "No." := Supply."Item No.";
            "Variant Code" := Supply."Variant Code";
            "Location Code" := Supply."Location Code";
            "Bin Code" := Supply."Bin Code";
            "Planning Line Origin" := "Planning Line Origin"::Planning;
            IF Supply."Action Message" = Supply."Action Message"::New
            THEN BEGIN
              "Order Date" := Supply."Due Date";
              "Planning Level" := Supply."Planning Level Code";
              CASE TempSKU."Replenishment System" OF
                TempSKU."Replenishment System"::Purchase:
                  "Ref. Order Type" := "Ref. Order Type"::Purchase;
                TempSKU."Replenishment System"::"Prod. Order":
                  BEGIN
                    "Ref. Order Type" := "Ref. Order Type"::"Prod. Order";
                    IF "Planning Level" > 0 THEN BEGIN
                      "Ref. Order Status" := Supply."Primary Order Status";
                      "Ref. Order No." := Supply."Primary Order No.";
                    END;
                  END;
                TempSKU."Replenishment System"::Assembly:
                  "Ref. Order Type" := "Ref. Order Type"::Assembly;
                TempSKU."Replenishment System"::Transfer:
                  "Ref. Order Type" := "Ref. Order Type"::Transfer;
              END;
              VALIDATE("No.");
              VALIDATE("Variant Code");
              VALIDATE("Unit of Measure Code",Supply."Unit of Measure Code");
              "Starting Time" := ManufacturingSetup."Normal Starting Time";
              "Ending Time" := ManufacturingSetup."Normal Ending Time";
            END ELSE
              CASE Supply."Source Type" OF
                DATABASE::"Purchase Line":
                  SetPurchase(PurchaseLine,Supply);
                DATABASE::"Prod. Order Line":
                  SetProdOrder(ProdOrderLine,Supply);
                DATABASE::"Assembly Header":
                  SetAssembly(AsmHeader,Supply);
                DATABASE::"Transfer Line":
                  SetTransfer(TransLine,Supply);
              END;
            AdjustPlanLine(Supply);
            "Accept Action Message" := TRUE;
            "Routing Reference No." := "Line No.";
            UpdateDatetime;
            "MPS Order" := Supply."MPS Order";
            INSERT;
            Supply."Planning Line No." := "Line No.";
            IF NewPhase = NewPhase::"Line Created" THEN
              Supply."Planning Line Phase" := Supply."Planning Line Phase"::"Line Created";
          END ELSE BEGIN
          IF Supply."Planning Line No." <> ReqLine."Line No." THEN
            ReqLine.GET(CurrTemplateName,CurrWorksheetName,Supply."Planning Line No.");
          ReqLine.BlockDynamicTracking(TRUE);
          AdjustPlanLine(Supply);
          IF NewPhase = NewPhase::"Line Created" THEN
            ReqLine.MODIFY;
        END;

      IF (NewPhase = NewPhase::"Routing Created") OR
         ((NewPhase > NewPhase::"Routing Created") AND
          (Supply."Planning Line Phase" < Supply."Planning Line Phase"::"Routing Created"))
      THEN BEGIN
        ReqLine.BlockDynamicTracking(TRUE);
        IF Supply."Planning Line No." <> ReqLine."Line No." THEN
          ReqLine.GET(CurrTemplateName,CurrWorksheetName,Supply."Planning Line No.");
        AdjustPlanLine(Supply);
        IF ReqLine.Quantity > 0 THEN BEGIN
          IF Supply."Starting Date" <> 0D THEN
            ReqLine."Starting Date" := Supply."Starting Date"
          ELSE
            ReqLine."Starting Date" := Supply."Due Date";
          GetRouting(ReqLine);
          RecalculationRequired := TRUE;
          IF NewPhase = NewPhase::"Routing Created" THEN
            Supply."Planning Line Phase" := Supply."Planning Line Phase"::"Routing Created";
        END;
        ReqLine.MODIFY;
      END;

      IF NewPhase = NewPhase::Exploded THEN BEGIN
        IF Supply."Planning Line No." <> ReqLine."Line No." THEN
          ReqLine.GET(CurrTemplateName,CurrWorksheetName,Supply."Planning Line No.");
        ReqLine.BlockDynamicTracking(TRUE);
        AdjustPlanLine(Supply);
        IF ReqLine.Quantity = 0 THEN
          IF ReqLine."Action Message" = ReqLine."Action Message"::New THEN BEGIN
            ReqLine.BlockDynamicTracking(TRUE);
            ReqLine.DELETE(TRUE);

            RecalculationRequired := FALSE;
          END ELSE
            DisableRelations
        ELSE BEGIN
          GetComponents(ReqLine);
          RecalculationRequired := TRUE;
        END;

        IF (ReqLine."Ref. Order Type" = ReqLine."Ref. Order Type"::Transfer) AND
           NOT ((ReqLine.Quantity = 0) AND (ReqLine."Action Message" = ReqLine."Action Message"::New))
        THEN BEGIN
          AdjustTransferDates(ReqLine);
          IF ReqLine."Action Message" = ReqLine."Action Message"::New THEN BEGIN
            CrntSupply.COPY(Supply);
            Supply.INIT;
            Supply."Line No." := NextLineNo;
            Supply."Item No." := ReqLine."No.";
            Supply.TransferFromOutboundTransfPlan(ReqLine,TempItemTrkgEntry);
            Supply."Lot No." := CrntSupply."Lot No.";
            Supply."Serial No." := CrntSupply."Serial No.";
            IF Supply.IsSupply THEN
              Supply.ChangeSign;
            Supply.INSERT;

            Supply.COPY(CrntSupply);
          END ELSE
            SynchronizeTransferProfiles(Supply,ReqLine);
        END;
      END;

      IF RecalculationRequired THEN BEGIN
        Recalculate(ReqLine,Direction);
        ReqLine.UpdateDatetime;
        ReqLine.MODIFY;

        Supply."Starting Date" := ReqLine."Starting Date";
        Supply."Due Date" := ReqLine."Due Date";
      END;

      IF NewPhase = NewPhase::Obsolete THEN BEGIN
        IF Supply."Planning Line No." <> ReqLine."Line No." THEN
          ReqLine.GET(CurrTemplateName,CurrWorksheetName,Supply."Planning Line No.");
        ReqLine.DELETE(TRUE);
        Supply."Planning Line No." := 0;
        Supply."Planning Line Phase" := Supply."Planning Line Phase"::" ";
      END;

      Supply.MODIFY;
    END;

    [External]
    PROCEDURE AdjustReorderQty@20(OrderQty@1001 : Decimal;SKU@1002 : Record 5700;SupplyLineNo@1003 : Integer;MinQty@1005 : Decimal) : Decimal;
    VAR
      DeltaQty@1000 : Decimal;
      Rounding@1004 : Decimal;
    BEGIN
      // Copy of this procedure exists in COD5400- Available Management
      IF OrderQty <= 0 THEN
        EXIT(0);

      IF (SKU."Maximum Order Quantity" < OrderQty) AND
         (SKU."Maximum Order Quantity" <> 0) AND
         (SKU."Maximum Order Quantity" > MinQty)
      THEN BEGIN
        DeltaQty := SKU."Maximum Order Quantity" - OrderQty;
        Transparency.LogSurplus(
          SupplyLineNo,0,DATABASE::Item,TempSKU."Item No.",
          DeltaQty,SurplusType::MaxOrder);
      END ELSE
        DeltaQty := 0;
      IF SKU."Minimum Order Quantity" > (OrderQty + DeltaQty) THEN BEGIN
        DeltaQty := SKU."Minimum Order Quantity" - OrderQty;
        Transparency.LogSurplus(
          SupplyLineNo,0,DATABASE::Item,TempSKU."Item No.",
          SKU."Minimum Order Quantity",SurplusType::MinOrder);
      END;
      IF SKU."Order Multiple" <> 0 THEN BEGIN
        Rounding := ROUND(OrderQty + DeltaQty,SKU."Order Multiple",'>') - (OrderQty + DeltaQty);
        DeltaQty += Rounding;
        IF DeltaQty <> 0 THEN
          Transparency.LogSurplus(
            SupplyLineNo,0,DATABASE::Item,TempSKU."Item No.",
            Rounding,SurplusType::OrderMultiple);
      END;
      EXIT(DeltaQty);
    END;

    LOCAL PROCEDURE CalcInventoryProfileRemainingQty@109(VAR InventoryProfile@1000 : Record 99000853;DocumentNo@1001 : Code[20]) : Decimal;
    BEGIN
      WITH InventoryProfile DO BEGIN
        SETRANGE("Source Type",DATABASE::"Sales Line");
        SETRANGE("Ref. Blanket Order No.",DocumentNo);
        CALCSUMS("Remaining Quantity (Base)");
        EXIT("Remaining Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE CalcReorderQty@15(NeededQty@1000 : Decimal;ProjectedInventory@1001 : Decimal;SupplyLineNo@1002 : Integer) QtyToOrder : Decimal;
    VAR
      Item@1005 : Record 27;
      SKU@1004 : Record 5700;
    BEGIN
      // Calculate qty to order:
      // If Max:   QtyToOrder = MaxInv - ProjInvLevel
      // If Fixed: QtyToOrder = FixedReorderQty
      // Copy of this procedure exists in COD5400- Available Management
      CASE TempSKU."Reordering Policy" OF
        TempSKU."Reordering Policy"::"Maximum Qty.":
          BEGIN
            IF TempSKU."Maximum Inventory" <= TempSKU."Reorder Point" THEN BEGIN
              IF PlanningResilicency THEN
                IF SKU.GET(TempSKU."Location Code",TempSKU."Item No.",TempSKU."Variant Code") THEN
                  ReqLine.SetResiliencyError(
                    STRSUBSTNO(
                      Text004,SKU.FIELDCAPTION("Maximum Inventory"),SKU."Maximum Inventory",SKU.TABLECAPTION,
                      SKU."Location Code",SKU."Item No.",SKU."Variant Code",
                      SKU.FIELDCAPTION("Reorder Point"),SKU."Reorder Point"),
                    DATABASE::"Stockkeeping Unit",SKU.GETPOSITION)
                ELSE
                  IF Item.GET(TempSKU."Item No.") THEN
                    ReqLine.SetResiliencyError(
                      STRSUBSTNO(
                        Text005,Item.FIELDCAPTION("Maximum Inventory"),Item."Maximum Inventory",Item.TABLECAPTION,
                        Item."No.",Item.FIELDCAPTION("Reorder Point"),Item."Reorder Point"),
                      DATABASE::Item,Item.GETPOSITION);
              TempSKU.TESTFIELD("Maximum Inventory",TempSKU."Reorder Point" + 1); // Assertion
            END;

            QtyToOrder := TempSKU."Maximum Inventory" - ProjectedInventory;
            Transparency.LogSurplus(
              SupplyLineNo,0,DATABASE::Item,TempSKU."Item No.",
              QtyToOrder,SurplusType::MaxInventory);
          END;
        TempSKU."Reordering Policy"::"Fixed Reorder Qty.":
          BEGIN
            IF PlanningResilicency AND (TempSKU."Reorder Quantity" = 0) THEN
              IF SKU.GET(TempSKU."Location Code",TempSKU."Item No.",TempSKU."Variant Code") THEN
                ReqLine.SetResiliencyError(
                  STRSUBSTNO(
                    Text004,SKU.FIELDCAPTION("Reorder Quantity"),0,SKU.TABLECAPTION,
                    SKU."Location Code",SKU."Item No.",SKU."Variant Code",
                    SKU.FIELDCAPTION("Reordering Policy"),SKU."Reordering Policy"),
                  DATABASE::"Stockkeeping Unit",SKU.GETPOSITION)
              ELSE
                IF Item.GET(TempSKU."Item No.") THEN
                  ReqLine.SetResiliencyError(
                    STRSUBSTNO(
                      Text005,Item.FIELDCAPTION("Reorder Quantity"),0,Item.TABLECAPTION,
                      Item."No.",Item.FIELDCAPTION("Reordering Policy"),Item."Reordering Policy"),
                    DATABASE::Item,Item.GETPOSITION);

            TempSKU.TESTFIELD("Reorder Quantity"); // Assertion
            QtyToOrder := TempSKU."Reorder Quantity";
            Transparency.LogSurplus(
              SupplyLineNo,0,DATABASE::Item,TempSKU."Item No.",
              QtyToOrder,SurplusType::FixedOrderQty);
          END;
        ELSE
          QtyToOrder := NeededQty;
      END;
    END;

    LOCAL PROCEDURE CalcOrderQty@95(NeededQty@1000 : Decimal;ProjectedInventory@1001 : Decimal;SupplyLineNo@1002 : Integer) QtyToOrder : Decimal;
    BEGIN
      QtyToOrder := CalcReorderQty(NeededQty,ProjectedInventory,SupplyLineNo);
      // Ensure that QtyToOrder is large enough to exceed ROP:
      IF QtyToOrder <= (TempSKU."Reorder Point" - ProjectedInventory) THEN
        QtyToOrder :=
          ROUND((TempSKU."Reorder Point" - ProjectedInventory) / TempSKU."Reorder Quantity" + 0.000000001,1,'>') *
          TempSKU."Reorder Quantity";
    END;

    LOCAL PROCEDURE CalcSalesOrderQty@129(AsmLine@1000 : Record 901) QtyOnSalesOrder : Decimal;
    VAR
      SalesOrderLine@1001 : Record 37;
      ATOLink@1002 : Record 904;
    BEGIN
      QtyOnSalesOrder := 0;
      ATOLink.GET(AsmLine."Document Type",AsmLine."Document No.");
      SalesOrderLine.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
      SalesOrderLine.SETRANGE("Document Type",SalesOrderLine."Document Type"::Order);
      SalesOrderLine.SETRANGE("Blanket Order No.",ATOLink."Document No.");
      SalesOrderLine.SETRANGE("Blanket Order Line No.",ATOLink."Document Line No.");
      IF SalesOrderLine.FIND('-') THEN
        REPEAT
          QtyOnSalesOrder += SalesOrderLine."Quantity (Base)";
        UNTIL SalesOrderLine.NEXT = 0;
    END;

    LOCAL PROCEDURE AdjustPlanLine@24(VAR Supply@1000 : Record 99000853);
    BEGIN
      WITH Supply DO BEGIN
        ReqLine."Action Message" := "Action Message";
        ReqLine.BlockDynamicTracking(TRUE);
        IF "Action Message" IN
           ["Action Message"::New,
            "Action Message"::"Change Qty.",
            "Action Message"::Reschedule,
            "Action Message"::"Resched.& Chg. Qty.",
            "Action Message"::Cancel]
        THEN BEGIN
          IF "Qty. per Unit of Measure" = 0 THEN
            "Qty. per Unit of Measure" := 1;
          ReqLine.VALIDATE(
            Quantity,
            ROUND("Remaining Quantity (Base)" / "Qty. per Unit of Measure",0.00001));
          ReqLine."Original Quantity" := "Original Quantity";
          ReqLine."Net Quantity (Base)" :=
            (ReqLine."Remaining Quantity" - ReqLine."Original Quantity") *
            ReqLine."Qty. per Unit of Measure";
        END;
        ReqLine."Original Due Date" := "Original Due Date";
        ReqLine."Due Date" := "Due Date";
        IF "Planning Level Code" = 0 THEN
          ReqLine."Ending Date" :=
            LeadTimeMgt.PlannedEndingDate(
              "Item No.","Location Code","Variant Code","Due Date",'',ReqLine."Ref. Order Type")
        ELSE BEGIN
          ReqLine."Ending Date" := "Due Date";
          ReqLine."Ending Time" := "Due Time";
        END;
        IF (ReqLine."Starting Date" = 0D) OR
           (ReqLine."Starting Date" > ReqLine."Ending Date")
        THEN
          ReqLine."Starting Date" := ReqLine."Ending Date";
      END;
    END;

    LOCAL PROCEDURE DisableRelations@37();
    VAR
      PlanningComponent@1000 : Record 99000829;
      PlanningRtngLine@1001 : Record 99000830;
      ProdOrderCapNeed@1002 : Record 5410;
    BEGIN
      IF ReqLine.Type <> ReqLine.Type::Item THEN
        EXIT;
      PlanningComponent.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningComponent.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningComponent.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      IF PlanningComponent.FIND('-') THEN
        REPEAT
          PlanningComponent.BlockDynamicTracking(FALSE);
          PlanningComponent.DELETE(TRUE);
        UNTIL PlanningComponent.NEXT = 0;

      PlanningRtngLine.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningRtngLine.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningRtngLine.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      PlanningRtngLine.DELETEALL;

      WITH ProdOrderCapNeed DO BEGIN
        SETCURRENTKEY("Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.");
        SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
        SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
        SETRANGE("Worksheet Line No.",ReqLine."Line No.");
        DELETEALL;
        RESET;
        SETCURRENTKEY(Status,"Prod. Order No.",Active);
        SETRANGE(Status,ReqLine."Ref. Order Status");
        SETRANGE("Prod. Order No.",ReqLine."Ref. Order No.");
        SETRANGE(Active,TRUE);
        MODIFYALL(Active,FALSE);
      END
    END;

    LOCAL PROCEDURE SynchronizeTransferProfiles@65(VAR InventoryProfile@1001 : Record 99000853;VAR TransferReqLine@1004 : Record 246);
    VAR
      Supply@1000 : Record 99000853;
    BEGIN
      IF InventoryProfile."Transfer Location Not Planned" THEN
        EXIT;
      Supply.COPY(InventoryProfile);
      IF GetTransferSisterProfile(Supply,InventoryProfile) THEN BEGIN
        TransferReqLineToInvProfiles(InventoryProfile,TransferReqLine);
        InventoryProfile.MODIFY;
      END;
      InventoryProfile.COPY(Supply);
    END;

    LOCAL PROCEDURE TransferReqLineToInvProfiles@105(VAR InventoryProfile@1000 : Record 99000853;VAR TransferReqLine@1001 : Record 246);
    BEGIN
      WITH InventoryProfile DO BEGIN
        TESTFIELD("Location Code",TransferReqLine."Transfer-from Code");

        "Min. Quantity" := "Remaining Quantity (Base)";
        "Original Quantity" := TransferReqLine."Original Quantity";
        Quantity := TransferReqLine.Quantity;
        "Remaining Quantity" := TransferReqLine.Quantity;
        "Quantity (Base)" := TransferReqLine."Quantity (Base)";
        "Remaining Quantity (Base)" := TransferReqLine."Quantity (Base)";
        "Untracked Quantity" := TransferReqLine."Quantity (Base)";
        "Unit of Measure Code" := TransferReqLine."Unit of Measure Code";
        "Qty. per Unit of Measure" := TransferReqLine."Qty. per Unit of Measure";
        "Due Date" := TransferReqLine."Transfer Shipment Date";
      END;
    END;

    LOCAL PROCEDURE SyncTransferDemandWithReqLine@104(VAR InventoryProfile@1000 : Record 99000853;LocationCode@1002 : Code[10]);
    VAR
      TransferReqLine@1001 : Record 246;
    BEGIN
      WITH TransferReqLine DO BEGIN
        SETRANGE("Ref. Order Type","Ref. Order Type"::Transfer);
        SETRANGE("Ref. Order No.",InventoryProfile."Source ID");
        SETRANGE("Ref. Line No.",InventoryProfile."Source Ref. No.");
        SETRANGE("Transfer-from Code",InventoryProfile."Location Code");
        SETRANGE("Location Code",LocationCode);
        SETFILTER("Action Message",'<>%1',"Action Message"::New);
        IF FINDFIRST THEN
          TransferReqLineToInvProfiles(InventoryProfile,TransferReqLine);
      END;
    END;

    LOCAL PROCEDURE GetTransferSisterProfile@71(CurrInvProfile@1000 : Record 99000853;VAR SisterInvProfile@1001 : Record 99000853) Ok : Boolean;
    BEGIN
      // Finds the invprofile which represents the opposite side of a transfer order.
      IF (CurrInvProfile."Source Type" <> DATABASE::"Transfer Line") OR
         (CurrInvProfile."Action Message" = CurrInvProfile."Action Message"::New)
      THEN
        EXIT(FALSE);

      WITH SisterInvProfile DO BEGIN
        CLEAR(SisterInvProfile);
        SETRANGE("Source Type",DATABASE::"Transfer Line");
        SETRANGE("Source ID",CurrInvProfile."Source ID");
        SETRANGE("Source Ref. No.",CurrInvProfile."Source Ref. No.");
        SETRANGE("Lot No.",CurrInvProfile."Lot No.");
        SETRANGE("Serial No.",CurrInvProfile."Serial No.");
        SETRANGE(IsSupply,NOT CurrInvProfile.IsSupply);

        Ok := FIND('-');

        // Assertion: only 1 outbound transfer record may exist:
        IF Ok THEN
          IF NEXT <> 0 THEN
            ERROR(Text001,TABLECAPTION);

        EXIT;
      END;
    END;

    LOCAL PROCEDURE AdjustTransferDates@60(VAR TransferReqLine@1012 : Record 246);
    VAR
      TransferRoute@1003 : Record 5742;
      ShippingAgentServices@1013 : Record 5790;
      Location@1009 : Record 14;
      SKU@1001 : Record 5700;
      ShippingTime@1006 : DateFormula;
      OutboundWhseTime@1007 : DateFormula;
      InboundWhseTime@1008 : DateFormula;
      OK@1000 : Boolean;
    BEGIN
      // Used for planning lines handling transfer orders.
      // "Ending Date", Starting Date and "Transfer Shipment Date" are calculated backwards from "Due Date".

      TransferReqLine.TESTFIELD("Ref. Order Type",TransferReqLine."Ref. Order Type"::Transfer);
      WITH TransferReqLine DO BEGIN
        OK := Location.GET("Transfer-from Code");
        IF PlanningResilicency AND NOT OK THEN
          IF SKU.GET("Location Code","No.","Variant Code") THEN
            ReqLine.SetResiliencyError(
              STRSUBSTNO(
                Text003,SKU.FIELDCAPTION("Transfer-from Code"),SKU.TABLECAPTION,
                SKU."Location Code",SKU."Item No.",SKU."Variant Code"),
              DATABASE::"Stockkeeping Unit",SKU.GETPOSITION);
        IF NOT OK THEN
          Location.GET("Transfer-from Code");
        OutboundWhseTime := Location."Outbound Whse. Handling Time";

        Location.GET("Location Code");
        InboundWhseTime := Location."Inbound Whse. Handling Time";

        OK := TransferRoute.GET("Transfer-from Code","Location Code");
        IF PlanningResilicency AND NOT OK THEN
          ReqLine.SetResiliencyError(
            STRSUBSTNO(
              Text002,TransferRoute.TABLECAPTION,
              "Transfer-from Code","Location Code"),
            DATABASE::"Transfer Route",'');
        IF NOT OK THEN
          TransferRoute.GET("Transfer-from Code","Location Code");

        IF ShippingAgentServices.GET(TransferRoute."Shipping Agent Code",TransferRoute."Shipping Agent Service Code") THEN
          ShippingTime := ShippingAgentServices."Shipping Time"
        ELSE
          EVALUATE(ShippingTime,'');

        // The calculation will run through the following steps:
        // ShipmentDate <- PlannedShipmentDate <- PlannedReceiptDate <- ReceiptDate

        // Calc Planned Receipt Date (Ending Date) backward from ReceiptDate
        TransferRoute.CalcPlanReceiptDateBackward(
          "Ending Date","Due Date",InboundWhseTime,
          "Location Code",TransferRoute."Shipping Agent Code",TransferRoute."Shipping Agent Service Code");

        // Calc Planned Shipment Date (Starting Date) backward from Planned ReceiptDate (Ending Date)
        TransferRoute.CalcPlanShipmentDateBackward(
          "Starting Date","Ending Date",ShippingTime,
          "Transfer-from Code",TransferRoute."Shipping Agent Code",TransferRoute."Shipping Agent Service Code");

        // Calc Shipment Date backward from Planned Shipment Date (Starting Date)
        TransferRoute.CalcShipmentDateBackward(
          "Transfer Shipment Date","Starting Date",OutboundWhseTime,"Transfer-from Code");

        UpdateDatetime;
        MODIFY;
      END;
    END;

    LOCAL PROCEDURE InsertTempTransferSKU@66(VAR TransLine@1000 : Record 5741);
    VAR
      SKU@1001 : Record 5700;
    BEGIN
      TempTransferSKU.INIT;
      TempTransferSKU."Item No." := TransLine."Item No.";
      TempTransferSKU."Variant Code" := TransLine."Variant Code";
      IF TransLine.Quantity > 0 THEN
        TempTransferSKU."Location Code" := TransLine."Transfer-to Code"
      ELSE
        TempTransferSKU."Location Code" := TransLine."Transfer-from Code";
      IF SKU.GET(TempTransferSKU."Location Code",TempTransferSKU."Item No.",TempTransferSKU."Variant Code") THEN
        TempTransferSKU."Transfer-from Code" := SKU."Transfer-from Code"
      ELSE
        TempTransferSKU."Transfer-from Code" := '';
      IF TempTransferSKU.INSERT THEN;
    END;

    LOCAL PROCEDURE UpdateTempSKUTransferLevels@61();
    VAR
      SKU@1003 : Record 5700;
    BEGIN
      SKU.COPY(TempSKU);
      WITH TempTransferSKU DO BEGIN
        RESET;
        IF FIND('-') THEN
          REPEAT
            TempSKU.RESET;
            IF TempSKU.GET("Location Code","Item No.","Variant Code") THEN
              IF TempSKU."Transfer-from Code" = '' THEN BEGIN
                TempSKU.SETRANGE("Location Code","Transfer-from Code");
                TempSKU.SETRANGE("Item No.","Item No.");
                TempSKU.SETRANGE("Variant Code","Variant Code");
                IF NOT TempSKU.FIND('-') THEN
                  "Transfer-Level Code" := -1
                ELSE
                  "Transfer-Level Code" := TempSKU."Transfer-Level Code" - 1;
                TempSKU.GET("Location Code","Item No.","Variant Code");
                TempSKU."Transfer-from Code" := "Transfer-from Code";
                TempSKU."Transfer-Level Code" := "Transfer-Level Code";
                TempSKU.MODIFY;
                TempSKU.UpdateTempSKUTransferLevels(TempSKU,TempSKU,TempSKU."Transfer-from Code");
              END;
          UNTIL NEXT = 0;
      END;
      TempSKU.COPY(SKU);
    END;

    LOCAL PROCEDURE CancelTransfer@69(VAR Supply@1000 : Record 99000853;VAR Demand@1001 : Record 99000853;DemandExists@1004 : Boolean) Cancel : Boolean;
    VAR
      xSupply2@1002 : Record 99000853;
    BEGIN
      // Used to handle transfers where supply is planned with a higher Transfer Level Code than demand.
      // If you encounter the demand before the supply, the supply must be removed.

      IF NOT DemandExists THEN
        EXIT(FALSE);
      IF Demand."Source Type" <> DATABASE::"Transfer Line" THEN
        EXIT(FALSE);
      Demand.TESTFIELD(IsSupply,FALSE);

      xSupply2.COPY(Supply);
      IF GetTransferSisterProfile(Demand,Supply) THEN BEGIN
        IF Supply."Action Message" = Supply."Action Message"::New THEN
          Supply.FIELDERROR("Action Message");

        IF Supply."Planning Flexibility" = Supply."Planning Flexibility"::Unlimited THEN BEGIN
          Supply."Original Quantity" := Supply.Quantity;
          Supply."Max. Quantity" := Supply."Remaining Quantity (Base)";
          Supply."Quantity (Base)" := Supply."Min. Quantity";
          Supply."Remaining Quantity (Base)" := Supply."Min. Quantity";
          Supply."Untracked Quantity" := 0;

          IF Supply."Remaining Quantity (Base)" = 0 THEN
            Supply."Action Message" := Supply."Action Message"::Cancel
          ELSE
            Supply."Action Message" := Supply."Action Message"::"Change Qty.";
          Supply.MODIFY;

          MaintainPlanningLine(Supply,PlanningLineStage::Exploded,ScheduleDirection::Backward);
          Track(Supply,Demand,TRUE,FALSE,Supply.Binding::" ");
          Supply.DELETE;

          Cancel := (Supply."Action Message" = Supply."Action Message"::Cancel);

          // IF supply is fully cancelled, demand is deleted, otherwise demand is modified:
          IF Cancel THEN
            Demand.DELETE
          ELSE BEGIN
            Demand.GET(Demand."Line No."); // Get the updated version
            Demand."Untracked Quantity" -= (Demand."Original Quantity" - Demand."Quantity (Base)");
            Demand.MODIFY;
          END;
        END;
      END;
      Supply.COPY(xSupply2);
    END;

    LOCAL PROCEDURE PostInvChgReminder@43(VAR InvChangeReminder@1000 : Record 99000853;InvProfile@1001 : Record 99000853;PostOnlyMinimum@1002 : Boolean);
    BEGIN
      // Update information on changes in the Projected Inventory over time
      // Only the quantity that is known for sure should be posted

      InvChangeReminder := InvProfile;

      IF PostOnlyMinimum THEN BEGIN
        InvChangeReminder."Remaining Quantity (Base)" -= InvProfile."Untracked Quantity";
        InvChangeReminder."Remaining Quantity (Base)" += InvProfile."Safety Stock Quantity";
      END;

      IF NOT InvChangeReminder.INSERT THEN
        InvChangeReminder.MODIFY;
    END;

    LOCAL PROCEDURE QtyFromPendingReminders@31(VAR InvChangeReminder@1002 : Record 99000853;AtDate@1001 : Date;LatestBucketStartDate@1000 : Date) PendingQty : Decimal;
    VAR
      xInvChangeReminder@1003 : Record 99000853;
    BEGIN
      // Calculates the sum of queued up adjustments to the projected inventory level
      xInvChangeReminder.COPY(InvChangeReminder);

      InvChangeReminder.SETRANGE("Due Date",LatestBucketStartDate,AtDate);
      IF InvChangeReminder.FINDSET THEN
        REPEAT
          IF InvChangeReminder.IsSupply THEN
            PendingQty += InvChangeReminder."Remaining Quantity (Base)"
          ELSE
            PendingQty -= InvChangeReminder."Remaining Quantity (Base)";
        UNTIL InvChangeReminder.NEXT = 0;

      InvChangeReminder.COPY(xInvChangeReminder);
    END;

    LOCAL PROCEDURE MaintainProjectedInv@44(VAR InvChangeReminder@1000 : Record 99000853;AtDate@1001 : Date;VAR LastProjectedInventory@1002 : Decimal;VAR LatestBucketStartDate@1003 : Date;VAR ROPHasBeenCrossed@1005 : Boolean);
    VAR
      NextBucketEndDate@1004 : Date;
      NewProjectedInv@1006 : Decimal;
      SupplyIncrementQty@1007 : Decimal;
      DemandIncrementQty@1008 : Decimal;
    BEGIN
      // Updates information about projected inventory up until AtDate or until reorder point is crossed.
      // The check is performed within time buckets.

      ROPHasBeenCrossed := FALSE;
      LatestBucketStartDate := FindNextBucketStartDate(InvChangeReminder,AtDate,LatestBucketStartDate);
      NextBucketEndDate := LatestBucketStartDate + BucketSizeInDays - 1;

      WHILE (NextBucketEndDate < AtDate) AND NOT ROPHasBeenCrossed DO BEGIN
        InvChangeReminder.SETFILTER("Due Date",'%1..%2',LatestBucketStartDate,NextBucketEndDate);
        SupplyIncrementQty := 0;
        DemandIncrementQty := 0;
        IF InvChangeReminder.FINDSET THEN
          REPEAT
            IF InvChangeReminder.IsSupply THEN BEGIN
              IF InvChangeReminder."Order Relation" <> InvChangeReminder."Order Relation"::"Safety Stock" THEN
                SupplyIncrementQty += InvChangeReminder."Remaining Quantity (Base)";
            END ELSE
              DemandIncrementQty -= InvChangeReminder."Remaining Quantity (Base)";
            InvChangeReminder.DELETE;
          UNTIL InvChangeReminder.NEXT = 0;

        NewProjectedInv := LastProjectedInventory + SupplyIncrementQty + DemandIncrementQty;
        IF FutureSupplyWithinLeadtime > SupplyIncrementQty THEN
          FutureSupplyWithinLeadtime -= SupplyIncrementQty
        ELSE
          FutureSupplyWithinLeadtime := 0;
        ROPHasBeenCrossed :=
          (LastProjectedInventory + SupplyIncrementQty > TempSKU."Reorder Point") AND
          (NewProjectedInv <= TempSKU."Reorder Point") OR
          (NewProjectedInv + FutureSupplyWithinLeadtime <= TempSKU."Reorder Point");
        LastProjectedInventory := NewProjectedInv;
        IF ROPHasBeenCrossed THEN
          LatestBucketStartDate := NextBucketEndDate + 1
        ELSE
          LatestBucketStartDate := FindNextBucketStartDate(InvChangeReminder,AtDate,LatestBucketStartDate);
        NextBucketEndDate := LatestBucketStartDate + BucketSizeInDays - 1;
      END;
    END;

    LOCAL PROCEDURE FindNextBucketStartDate@18(VAR InvChangeReminder@1000 : Record 99000853;AtDate@1001 : Date;LatestBucketStartDate@1003 : Date) NextBucketStartDate : Date;
    VAR
      NumberOfDaysToNextReminder@1005 : Integer;
    BEGIN
      IF AtDate = 0D THEN
        EXIT(LatestBucketStartDate);

      InvChangeReminder.SETFILTER("Due Date",'%1..%2',LatestBucketStartDate,AtDate);
      IF InvChangeReminder.FINDFIRST THEN
        AtDate := InvChangeReminder."Due Date";

      NumberOfDaysToNextReminder := AtDate - LatestBucketStartDate;
      NextBucketStartDate := AtDate - (NumberOfDaysToNextReminder MOD BucketSizeInDays);
    END;

    LOCAL PROCEDURE SetIgnoreOverflow@49(VAR SupplyInvtProfile@1000 : Record 99000853);
    BEGIN
      // Apply a minimum quantity to the existing orders to protect the
      // remaining valid surplus from being reduced in the common balancing act

      WITH SupplyInvtProfile DO BEGIN
        IF FINDSET(TRUE) THEN
          REPEAT
            "Min. Quantity" := "Remaining Quantity (Base)";
            MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE ChkInitialOverflow@50(VAR DemandInvtProfile@1002 : Record 99000853;VAR SupplyInvtProfile@1001 : Record 99000853;OverflowLevel@1004 : Decimal;InventoryLevel@1007 : Decimal;FromDate@1013 : Date;ToDate@1012 : Date);
    VAR
      xDemandInvtProfile@1005 : Record 99000853;
      xSupplyInvtProfile@1006 : Record 99000853;
      OverflowQty@1008 : Decimal;
      OriginalSupplyQty@1009 : Decimal;
      DecreasedSupplyQty@1015 : Decimal;
      PrevBucketStartDate@1010 : Date;
      PrevBucketEndDate@1011 : Date;
      CurrBucketStartDate@1003 : Date;
      CurrBucketEndDate@1014 : Date;
      NumberOfDaysToNextSupply@1000 : Integer;
    BEGIN
      xDemandInvtProfile.COPY(DemandInvtProfile);
      xSupplyInvtProfile.COPY(SupplyInvtProfile);
      SupplyInvtProfile.SETRANGE("Is Exception Order",FALSE);

      IF OverflowLevel > 0 THEN BEGIN
        // Detect if there is overflow in inventory within any time bucket
        // In that case: Decrease superfluous Supply; latest first
        // Apply a minimum quantity to the existing orders to protect the
        // remaining valid surplus from being reduced in the common balancing act

        // Avoid Safety Stock Demand
        DemandInvtProfile.SETRANGE("Order Relation",DemandInvtProfile."Order Relation"::Normal);

        PrevBucketStartDate := FromDate;
        CurrBucketEndDate := ToDate;

        WHILE PrevBucketStartDate <= ToDate DO BEGIN
          SupplyInvtProfile.SETRANGE("Due Date",PrevBucketStartDate,ToDate);
          IF SupplyInvtProfile.FINDFIRST THEN BEGIN
            NumberOfDaysToNextSupply := SupplyInvtProfile."Due Date" - PrevBucketStartDate;
            CurrBucketEndDate :=
              SupplyInvtProfile."Due Date" - (NumberOfDaysToNextSupply MOD BucketSizeInDays) + BucketSizeInDays - 1;
            CurrBucketStartDate := CurrBucketEndDate - BucketSizeInDays + 1;
            PrevBucketEndDate := CurrBucketStartDate - 1;

            DemandInvtProfile.SETRANGE("Due Date",PrevBucketStartDate,PrevBucketEndDate);
            IF DemandInvtProfile.FINDSET THEN
              REPEAT
                InventoryLevel -= DemandInvtProfile."Remaining Quantity (Base)";
              UNTIL DemandInvtProfile.NEXT = 0;

            // Negative inventory from previous buckets shall not influence
            // possible overflow in the current time bucket
            IF InventoryLevel < 0 THEN
              InventoryLevel := 0;

            DemandInvtProfile.SETRANGE("Due Date",CurrBucketStartDate,CurrBucketEndDate);
            IF DemandInvtProfile.FINDSET THEN
              REPEAT
                InventoryLevel -= DemandInvtProfile."Remaining Quantity (Base)";
              UNTIL DemandInvtProfile.NEXT = 0;

            SupplyInvtProfile.SETRANGE("Due Date",CurrBucketStartDate,CurrBucketEndDate);
            IF SupplyInvtProfile.FIND('-') THEN BEGIN
              REPEAT
                InventoryLevel += SupplyInvtProfile."Remaining Quantity (Base)";
              UNTIL SupplyInvtProfile.NEXT = 0;

              OverflowQty := InventoryLevel - OverflowLevel;
              REPEAT
                IF OverflowQty > 0 THEN BEGIN
                  OriginalSupplyQty := SupplyInvtProfile."Quantity (Base)";
                  SupplyInvtProfile."Min. Quantity" := 0;
                  DecreaseQty(SupplyInvtProfile,OverflowQty);

                  // If the supply has not been decreased as planned, try to cancel it.
                  DecreasedSupplyQty := SupplyInvtProfile."Quantity (Base)";
                  IF (DecreasedSupplyQty > 0) AND (OriginalSupplyQty - DecreasedSupplyQty < OverflowQty) AND
                     (SupplyInvtProfile."Order Priority" < 1000)
                  THEN
                    IF CanDecreaseSupply(SupplyInvtProfile,OverflowQty) THEN
                      DecreaseQty(SupplyInvtProfile,DecreasedSupplyQty);

                  IF OriginalSupplyQty <> SupplyInvtProfile."Quantity (Base)" THEN BEGIN
                    DummyInventoryProfileTrackBuffer."Warning Level" := DummyInventoryProfileTrackBuffer."Warning Level"::Attention;
                    Transparency.LogWarning(SupplyInvtProfile."Line No.",ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",
                      STRSUBSTNO(Text010,InventoryLevel,OverflowLevel,CurrBucketEndDate));
                    OverflowQty -= (OriginalSupplyQty - SupplyInvtProfile."Quantity (Base)");
                    InventoryLevel -= (OriginalSupplyQty - SupplyInvtProfile."Quantity (Base)");
                  END;
                END;
                SupplyInvtProfile."Min. Quantity" := SupplyInvtProfile."Remaining Quantity (Base)";
                SupplyInvtProfile.MODIFY;
                IF SupplyInvtProfile."Line No." = xSupplyInvtProfile."Line No." THEN
                  xSupplyInvtProfile := SupplyInvtProfile;
              UNTIL (SupplyInvtProfile.NEXT(-1) = 0);
            END;

            IF InventoryLevel < 0 THEN
              InventoryLevel := 0;
            PrevBucketStartDate := CurrBucketEndDate + 1;
          END ELSE
            PrevBucketStartDate := ToDate + 1;
        END;
      END ELSE
        IF OverflowLevel = 0 THEN
          SetIgnoreOverflow(SupplyInvtProfile);

      DemandInvtProfile.COPY(xDemandInvtProfile);
      SupplyInvtProfile.COPY(xSupplyInvtProfile);
    END;

    LOCAL PROCEDURE CheckNewOverflow@45(VAR SupplyInvtProfile@1000 : Record 99000853;InventoryLevel@1002 : Decimal;QtyToDecreaseOverFlow@1004 : Decimal;LastDueDate@1006 : Date);
    VAR
      xSupplyInvtProfile@1001 : Record 99000853;
      OriginalSupplyQty@1003 : Decimal;
      QtyToDecrease@1005 : Decimal;
    BEGIN
      // the function tries to avoid overflow when a new supply was suggested
      xSupplyInvtProfile.COPY(SupplyInvtProfile);
      SupplyInvtProfile.SETRANGE("Due Date",LastDueDate + 1,PlanToDate);
      SupplyInvtProfile.SETFILTER("Remaining Quantity (Base)",'>0');

      IF SupplyInvtProfile.FINDSET(TRUE) THEN
        REPEAT
          IF SupplyInvtProfile."Original Quantity" > 0 THEN
            InventoryLevel := InventoryLevel + SupplyInvtProfile."Original Quantity" * SupplyInvtProfile."Qty. per Unit of Measure"
          ELSE
            InventoryLevel := InventoryLevel + SupplyInvtProfile."Remaining Quantity (Base)";
          OriginalSupplyQty := SupplyInvtProfile."Quantity (Base)";

          IF InventoryLevel > OverflowLevel THEN BEGIN
            SupplyInvtProfile."Min. Quantity" := 0;
            DummyInventoryProfileTrackBuffer."Warning Level" := DummyInventoryProfileTrackBuffer."Warning Level"::Attention;
            QtyToDecrease := InventoryLevel - OverflowLevel;

            IF QtyToDecrease > QtyToDecreaseOverFlow THEN
              QtyToDecrease := QtyToDecreaseOverFlow;

            IF QtyToDecrease > SupplyInvtProfile."Remaining Quantity (Base)" THEN
              QtyToDecrease := SupplyInvtProfile."Remaining Quantity (Base)";

            DecreaseQty(SupplyInvtProfile,QtyToDecrease);

            Transparency.LogWarning(
              SupplyInvtProfile."Line No.",ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",
              STRSUBSTNO(
                Text010,
                InventoryLevel,
                OverflowLevel,SupplyInvtProfile."Due Date"));

            QtyToDecreaseOverFlow := QtyToDecreaseOverFlow - (OriginalSupplyQty - SupplyInvtProfile."Quantity (Base)");
            InventoryLevel := InventoryLevel - (OriginalSupplyQty - SupplyInvtProfile."Quantity (Base)");
            SupplyInvtProfile."Min. Quantity" := SupplyInvtProfile."Remaining Quantity (Base)";
            SupplyInvtProfile.MODIFY;
          END;
        UNTIL (SupplyInvtProfile.NEXT = 0) OR (QtyToDecreaseOverFlow <= 0);

      SupplyInvtProfile.COPY(xSupplyInvtProfile);
    END;

    LOCAL PROCEDURE CheckScheduleIn@62(VAR Supply@1000 : Record 99000853;TargetDate@1001 : Date;VAR PossibleDate@1002 : Date;LimitedHorizon@1004 : Boolean) : Boolean;
    BEGIN
      IF Supply."Planning Flexibility" <> Supply."Planning Flexibility"::Unlimited THEN
        EXIT(FALSE);

      IF LimitedHorizon AND NOT AllowScheduleIn(Supply,TargetDate) THEN
        PossibleDate := Supply."Due Date"
      ELSE
        PossibleDate := TargetDate;

      EXIT(TargetDate = PossibleDate);
    END;

    LOCAL PROCEDURE CheckScheduleOut@67(VAR Supply@1000 : Record 99000853;TargetDate@1001 : Date;VAR PossibleDate@1002 : Date;LimitedHorizon@1003 : Boolean) : Boolean;
    BEGIN
      IF Supply."Planning Flexibility" <> Supply."Planning Flexibility"::Unlimited THEN
        EXIT(FALSE);

      IF (TargetDate - Supply."Due Date") <= DampenersDays THEN
        PossibleDate := Supply."Due Date"
      ELSE
        IF NOT LimitedHorizon OR
           (Supply."Planning Level Code" > 0)
        THEN
          PossibleDate := TargetDate
        ELSE
          IF AllowScheduleOut(Supply,TargetDate) THEN
            PossibleDate := TargetDate
          ELSE BEGIN
            // Do not reschedule but may be lot accumulation is still an option
            PossibleDate := Supply."Due Date";
            IF Supply."Fixed Date" <> 0D THEN
              EXIT(AllowLotAccumulation(Supply,TargetDate));
            EXIT(FALSE);
          END;

      // Limit possible rescheduling in case the supply is already linked up to another demand
      IF (Supply."Fixed Date" <> 0D) AND
         (Supply."Fixed Date" < PossibleDate)
      THEN BEGIN
        IF NOT AllowLotAccumulation(Supply,TargetDate) THEN // but reschedule only if lot accumulation is allowed for target date
          EXIT(FALSE);

        PossibleDate := Supply."Fixed Date";
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CheckSupplyWithSKU@99(VAR InventoryProfile@1000 : Record 99000853;VAR SKU@1001 : Record 5700);
    VAR
      xInventoryProfile@1002 : Record 99000853;
    BEGIN
      xInventoryProfile.COPY(InventoryProfile);

      WITH InventoryProfile DO BEGIN
        IF SKU."Maximum Order Quantity" > 0 THEN
          IF FIND('-') THEN
            REPEAT
              IF (SKU."Maximum Order Quantity" > "Max. Quantity") AND
                 ("Quantity (Base)" > 0) AND
                 ("Max. Quantity" = 0)
              THEN BEGIN
                "Max. Quantity" := SKU."Maximum Order Quantity";
                MODIFY;
              END;
            UNTIL NEXT = 0;
      END;
      InventoryProfile.COPY(xInventoryProfile);
      IF InventoryProfile.GET(InventoryProfile."Line No.") THEN;
    END;

    LOCAL PROCEDURE CreateSupplyForward@68(VAR Supply@1000 : Record 99000853;AtDate@1001 : Date;ProjectedInventory@1003 : Decimal;VAR NewSupplyHasTakenOver@1005 : Boolean;CurrDueDate@1012 : Date);
    VAR
      InterimSupply@1006 : TEMPORARY Record 99000853;
      CurrSupply@1008 : Record 99000853;
      LeadTimeEndDate@1007 : Date;
      QtyToOrder@1002 : Decimal;
      QtyToOrderThisLine@1010 : Decimal;
      SupplyWithinLeadtime@1004 : Decimal;
      HasLooped@1009 : Boolean;
      CurrSupplyExists@1011 : Boolean;
      QtyToDecreaseOverFlow@1013 : Decimal;
    BEGIN
      // Save current supply and check if it is real
      CurrSupply := Supply;
      CurrSupplyExists := Supply.FIND('=');

      // Initiate new supplyprofile
      InitSupply(InterimSupply,0,AtDate);

      // Make sure VAR boolean is reset:
      NewSupplyHasTakenOver := FALSE;
      QtyToOrder := CalcOrderQty(QtyToOrder,ProjectedInventory,InterimSupply."Line No.");

      // Use new supplyprofile to determine lead-time
      UpdateQty(InterimSupply,QtyToOrder + AdjustReorderQty(QtyToOrder,TempSKU,InterimSupply."Line No.",0));
      InterimSupply.INSERT;
      ScheduleForward(InterimSupply,AtDate);
      LeadTimeEndDate := InterimSupply."Due Date";

      // Find supply within leadtime, returns a qty
      SupplyWithinLeadtime := SumUpProjectedSupply(Supply,AtDate,LeadTimeEndDate);
      FutureSupplyWithinLeadtime := SupplyWithinLeadtime;

      // If found supply + projinvlevel covers ROP then the situation has already been taken care of: roll back and (exit)
      IF SupplyWithinLeadtime + ProjectedInventory > TempSKU."Reorder Point" THEN BEGIN
        // Delete obsolete Planning Line
        MaintainPlanningLine(InterimSupply,PlanningLineStage::Obsolete,ScheduleDirection::Backward);
        Transparency.CleanLog(InterimSupply."Line No.");
        EXIT;
      END;

      // If Max: Deduct found supply in order to stay below max inventory and adjust transparency log
      IF TempSKU."Reordering Policy" = TempSKU."Reordering Policy"::"Maximum Qty." THEN
        IF SupplyWithinLeadtime <> 0 THEN BEGIN
          QtyToOrder -= SupplyWithinLeadtime;
          Transparency.ModifyLogEntry(
            InterimSupply."Line No.",0,DATABASE::Item,TempSKU."Item No.",-SupplyWithinLeadtime,SurplusType::MaxInventory);
        END;

      LeadTimeEndDate := AtDate;

      WHILE QtyToOrder > 0 DO BEGIN
        // In case of max order the new supply could be split in several new supplies:
        IF HasLooped THEN BEGIN
          InitSupply(InterimSupply,0,AtDate);
          CASE TempSKU."Reordering Policy" OF
            TempSKU."Reordering Policy"::"Maximum Qty.":
              SurplusType := SurplusType::MaxInventory;
            TempSKU."Reordering Policy"::"Fixed Reorder Qty.":
              SurplusType := SurplusType::FixedOrderQty;
          END;
          Transparency.LogSurplus(InterimSupply."Line No.",0,0,'',QtyToOrder,SurplusType);
          QtyToOrderThisLine := QtyToOrder + AdjustReorderQty(QtyToOrder,TempSKU,InterimSupply."Line No.",0);
          UpdateQty(InterimSupply,QtyToOrderThisLine);
          InterimSupply.INSERT;
          ScheduleForward(InterimSupply,AtDate);
        END ELSE BEGIN
          QtyToOrderThisLine := QtyToOrder + AdjustReorderQty(QtyToOrder,TempSKU,InterimSupply."Line No.",0);
          IF QtyToOrderThisLine <> InterimSupply."Remaining Quantity (Base)" THEN BEGIN
            UpdateQty(InterimSupply,QtyToOrderThisLine);
            ScheduleForward(InterimSupply,AtDate);
          END;
          HasLooped := TRUE;
        END;

        // The supply is inserted into the overall supply dataset
        Supply := InterimSupply;
        InterimSupply.DELETE;
        Supply."Min. Quantity" := Supply."Remaining Quantity (Base)";
        Supply."Max. Quantity" := TempSKU."Maximum Order Quantity";
        Supply."Fixed Date" := Supply."Due Date";
        Supply."Order Priority" := 1000; // Make sure to give last priority if supply exists on the same date
        Supply."Attribute Priority" := 1000;
        Supply.INSERT;

        // Planning Transparency
        Transparency.LogSurplus(Supply."Line No.",0,0,'',Supply."Untracked Quantity",SurplusType::ReorderPoint);

        IF Supply."Due Date" < CurrDueDate THEN BEGIN
          CurrSupply := Supply;
          CurrDueDate := Supply."Due Date";
          NewSupplyHasTakenOver := TRUE
        END;

        IF LeadTimeEndDate < Supply."Due Date" THEN
          LeadTimeEndDate := Supply."Due Date";

        IF (NOT CurrSupplyExists) OR
           (Supply."Due Date" < CurrSupply."Due Date")
        THEN BEGIN
          CurrSupply := Supply;
          CurrSupplyExists := TRUE;
          NewSupplyHasTakenOver := CurrSupply."Due Date" <= CurrDueDate;
        END;

        QtyToOrder -= Supply."Remaining Quantity (Base)";
        FutureSupplyWithinLeadtime += Supply."Remaining Quantity (Base)";
        QtyToDecreaseOverFlow += Supply."Quantity (Base)";
      END;

      IF HasLooped AND (OverflowLevel > 0) THEN
        // the new supply might cause overflow in inventory since
        // it wasn't considered when Overflow was calculated
        CheckNewOverflow(Supply,ProjectedInventory + QtyToDecreaseOverFlow,QtyToDecreaseOverFlow,LeadTimeEndDate);

      Supply := CurrSupply;
    END;

    LOCAL PROCEDURE AllowScheduleIn@58(SupplyInvtProfile@1000 : Record 99000853;TargetDate@1001 : Date) CanReschedule : Boolean;
    BEGIN
      CanReschedule := CALCDATE(TempSKU."Rescheduling Period",TargetDate) >= SupplyInvtProfile."Due Date";
    END;

    LOCAL PROCEDURE AllowScheduleOut@87(SupplyInvtProfile@1000 : Record 99000853;TargetDate@1001 : Date) CanReschedule : Boolean;
    BEGIN
      CanReschedule := CALCDATE(TempSKU."Rescheduling Period",SupplyInvtProfile."Due Date") >= TargetDate;
    END;

    LOCAL PROCEDURE AllowLotAccumulation@88(SupplyInvtProfile@1000 : Record 99000853;DemandDueDate@1001 : Date) AccumulationOK : Boolean;
    BEGIN
      AccumulationOK := CALCDATE(TempSKU."Lot Accumulation Period",SupplyInvtProfile."Due Date") >= DemandDueDate;
    END;

    LOCAL PROCEDURE ShallSupplyBeClosed@89(SupplyInventoryProfile@1000 : Record 99000853;DemandDueDate@1001 : Date;IsReorderPointPlanning@1002 : Boolean) : Boolean;
    VAR
      CloseSupply@1003 : Boolean;
    BEGIN
      IF SupplyInventoryProfile."Is Exception Order" THEN BEGIN
        IF TempSKU."Reordering Policy" = TempSKU."Reordering Policy"::"Lot-for-Lot" THEN
          // supply within Lot Accumulation Period will be summed up with Exception order
          CloseSupply := NOT AllowLotAccumulation(SupplyInventoryProfile,DemandDueDate)
        ELSE
          // only demand in the same day as Exception will be summed up
          CloseSupply := SupplyInventoryProfile."Due Date" <> DemandDueDate;
      END ELSE
        CloseSupply := IsReorderPointPlanning;

      EXIT(CloseSupply);
    END;

    LOCAL PROCEDURE NextLineNo@64() : Integer;
    BEGIN
      LineNo += 1;
      EXIT(LineNo);
    END;

    LOCAL PROCEDURE Reschedule@57(VAR Supply@1001 : Record 99000853;TargetDate@1000 : Date;TargetTime@1003 : Time);
    BEGIN
      Supply.TESTFIELD("Planning Flexibility",Supply."Planning Flexibility"::Unlimited);

      IF (TargetDate <> Supply."Due Date") AND
         (Supply."Action Message" <> Supply."Action Message"::New)
      THEN BEGIN
        IF Supply."Original Due Date" = 0D THEN
          Supply."Original Due Date" := Supply."Due Date";
        IF Supply."Original Quantity" = 0 THEN
          Supply."Action Message" := Supply."Action Message"::Reschedule
        ELSE
          Supply."Action Message" := Supply."Action Message"::"Resched.& Chg. Qty.";
      END;
      Supply."Due Date" := TargetDate;
      IF (Supply."Due Time" = 0T) OR
         (Supply."Due Time" > TargetTime)
      THEN
        Supply."Due Time" := TargetTime;
      Supply.MODIFY;
    END;

    LOCAL PROCEDURE InitSupply@72(VAR Supply@1001 : Record 99000853;OrderQty@1002 : Decimal;DueDate@1000 : Date);
    VAR
      Item@1003 : Record 27;
      ItemUnitOfMeasure@1004 : Record 5404;
    BEGIN
      Supply.INIT;
      Supply."Line No." := NextLineNo;
      Supply."Item No." := TempSKU."Item No.";
      Supply."Variant Code" := TempSKU."Variant Code";
      Supply."Location Code" := TempSKU."Location Code";
      Supply."Action Message" := Supply."Action Message"::New;
      UpdateQty(Supply,OrderQty);
      Supply."Due Date" := DueDate;
      Supply.IsSupply := TRUE;
      Item.GET(TempSKU."Item No.");
      Supply."Unit of Measure Code" := Item."Base Unit of Measure";
      Supply."Qty. per Unit of Measure" := 1;

      CASE TempSKU."Replenishment System" OF
        TempSKU."Replenishment System"::Purchase:
          BEGIN
            Supply."Source Type" := DATABASE::"Purchase Line";
            Supply."Unit of Measure Code" := Item."Purch. Unit of Measure";
            IF Supply."Unit of Measure Code" <> Item."Base Unit of Measure" THEN BEGIN
              ItemUnitOfMeasure.GET(TempSKU."Item No.",Item."Purch. Unit of Measure");
              Supply."Qty. per Unit of Measure" := ItemUnitOfMeasure."Qty. per Unit of Measure";
            END;
          END;
        TempSKU."Replenishment System"::"Prod. Order":
          Supply."Source Type" := DATABASE::"Prod. Order Line";
        TempSKU."Replenishment System"::Assembly:
          Supply."Source Type" := DATABASE::"Assembly Header";
        TempSKU."Replenishment System"::Transfer:
          Supply."Source Type" := DATABASE::"Transfer Line";
      END;
    END;

    LOCAL PROCEDURE UpdateQty@13(VAR InvProfile@1001 : Record 99000853;Qty@1002 : Decimal);
    BEGIN
      WITH InvProfile DO BEGIN
        "Untracked Quantity" := Qty;
        "Quantity (Base)" := "Untracked Quantity";
        "Remaining Quantity (Base)" := "Quantity (Base)";
      END;
    END;

    LOCAL PROCEDURE TransferAttributes@73(VAR ToInvProfile@1000 : Record 99000853;VAR FromInvProfile@1001 : Record 99000853);
    BEGIN
      IF SpecificLotTracking THEN
        ToInvProfile."Lot No." := FromInvProfile."Lot No.";
      IF SpecificSNTracking THEN
        ToInvProfile."Serial No." := FromInvProfile."Serial No.";

      IF TempSKU."Replenishment System" = TempSKU."Replenishment System"::"Prod. Order" THEN
        IF FromInvProfile."Planning Level Code" > 0 THEN BEGIN
          ToInvProfile.Binding := ToInvProfile.Binding::"Order-to-Order";
          ToInvProfile."Planning Level Code" := FromInvProfile."Planning Level Code";
          ToInvProfile."Due Time" := FromInvProfile."Due Time";
          ToInvProfile."Bin Code" := FromInvProfile."Bin Code";
        END;

      IF FromInvProfile.Binding = FromInvProfile.Binding::"Order-to-Order" THEN BEGIN
        ToInvProfile.Binding := ToInvProfile.Binding::"Order-to-Order";
        ToInvProfile."Primary Order Status" := FromInvProfile."Primary Order Status";
        ToInvProfile."Primary Order No." := FromInvProfile."Primary Order No.";
        ToInvProfile."Primary Order Line" := FromInvProfile."Primary Order Line";
      END;

      ToInvProfile."MPS Order" := FromInvProfile."MPS Order";

      IF ToInvProfile.TrackingExists THEN
        ToInvProfile."Planning Flexibility" := ToInvProfile."Planning Flexibility"::None;
    END;

    LOCAL PROCEDURE AllocateSafetystock@77(VAR Supply@1000 : Record 99000853;QtyToAllocate@1001 : Decimal;AtDate@1003 : Date);
    VAR
      MinQtyToCoverSafetyStock@1002 : Decimal;
    BEGIN
      IF QtyToAllocate > Supply."Safety Stock Quantity" THEN BEGIN
        Supply."Safety Stock Quantity" := QtyToAllocate;
        MinQtyToCoverSafetyStock :=
          Supply."Remaining Quantity (Base)" - Supply."Untracked Quantity" + Supply."Safety Stock Quantity";
        IF Supply."Min. Quantity" < MinQtyToCoverSafetyStock THEN
          Supply."Min. Quantity" := MinQtyToCoverSafetyStock;
        IF Supply."Min. Quantity" > Supply."Remaining Quantity (Base)" THEN
          ERROR(Text001,Supply.FIELDCAPTION("Safety Stock Quantity"));
        IF (Supply."Fixed Date" = 0D) OR (Supply."Fixed Date" > AtDate) THEN
          Supply."Fixed Date" := AtDate;
        Supply.MODIFY;
      END;
    END;

    LOCAL PROCEDURE SumUpProjectedSupply@81(VAR Supply@1002 : Record 99000853;FromDate@1000 : Date;ToDate@1001 : Date) ProjectedQty : Decimal;
    VAR
      xSupply@1003 : Record 99000853;
    BEGIN
      // Sums up the contribution to the projected inventory

      xSupply.COPY(Supply);
      Supply.SETRANGE("Due Date",FromDate,ToDate);

      IF Supply.FINDSET THEN
        REPEAT
          IF (Supply.Binding <> Supply.Binding::"Order-to-Order") AND
             (Supply."Order Relation" <> Supply."Order Relation"::"Safety Stock")
          THEN
            ProjectedQty += Supply."Remaining Quantity (Base)";
        UNTIL Supply.NEXT = 0;

      Supply.COPY(xSupply);
    END;

    LOCAL PROCEDURE SumUpAvailableSupply@30(VAR Supply@1002 : Record 99000853;FromDate@1000 : Date;ToDate@1001 : Date) AvailableQty : Decimal;
    VAR
      xSupply@1003 : Record 99000853;
    BEGIN
      // Sums up the contribution to the available inventory

      xSupply.COPY(Supply);
      Supply.SETRANGE("Due Date",FromDate,ToDate);

      IF Supply.FINDSET THEN
        REPEAT
          AvailableQty += Supply."Untracked Quantity";
        UNTIL Supply.NEXT = 0;

      Supply.COPY(xSupply);
    END;

    LOCAL PROCEDURE SetPriority@80(VAR InvProfile@1000 : Record 99000853;IsReorderPointPlanning@1001 : Boolean;ToDate@1002 : Date);
    BEGIN
      WITH InvProfile DO BEGIN
        IF IsSupply THEN BEGIN
          IF "Due Date" > ToDate THEN
            "Planning Flexibility" := "Planning Flexibility"::None;

          IF IsReorderPointPlanning AND (Binding <> Binding::"Order-to-Order") AND
             ("Planning Flexibility" <> "Planning Flexibility"::None)
          THEN
            "Planning Flexibility" := "Planning Flexibility"::"Reduce Only";

          CASE "Source Type" OF
            DATABASE::"Item Ledger Entry":
              "Order Priority" := 100;
            DATABASE::"Sales Line":
              CASE "Source Order Status" OF // Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                5:
                  "Order Priority" := 200; // Return Order
                1:
                  "Order Priority" := 200; // Negative Sales Order
              END;
            DATABASE::"Job Planning Line":
              "Order Priority" := 230;
            DATABASE::"Transfer Line",DATABASE::"Requisition Line",DATABASE::"Planning Component":
              "Order Priority" := 300;
            DATABASE::"Assembly Header":
              "Order Priority" := 320;
            DATABASE::"Prod. Order Line":
              CASE "Source Order Status" OF // Simulated,Planned,Firm Planned,Released,Finished
                3:
                  "Order Priority" := 400; // Released
                2:
                  "Order Priority" := 410; // Firm Planned
                1:
                  "Order Priority" := 420; // Planned
              END;
            DATABASE::"Purchase Line":
              "Order Priority" := 500;
            DATABASE::"Prod. Order Component":
              CASE "Source Order Status" OF // Simulated,Planned,Firm Planned,Released,Finished
                3:
                  "Order Priority" := 600; // Released
                2:
                  "Order Priority" := 610; // Firm Planned
                1:
                  "Order Priority" := 620; // Planned
              END;
          END;
        END ELSE  // Demand
          CASE "Source Type" OF
            DATABASE::"Item Ledger Entry":
              "Order Priority" := 100;
            DATABASE::"Purchase Line":
              "Order Priority" := 200;
            DATABASE::"Sales Line":
              CASE "Source Order Status" OF // Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                1:
                  "Order Priority" := 300; // Order
                4:
                  "Order Priority" := 700; // Blanket Order
                5:
                  "Order Priority" := 300; // Negative Return Order
              END;
            DATABASE::"Service Line":
              "Order Priority" := 400;
            DATABASE::"Job Planning Line":
              "Order Priority" := 450;
            DATABASE::"Assembly Line":
              "Order Priority" := 470;
            DATABASE::"Prod. Order Component":
              CASE "Source Order Status" OF // Simulated,Planned,Firm Planned,Released,Finished
                3:
                  "Order Priority" := 500; // Released
                2:
                  "Order Priority" := 510; // Firm Planned
                1:
                  "Order Priority" := 520; // Planned
              END;
            DATABASE::"Transfer Line",DATABASE::"Requisition Line",DATABASE::"Planning Component":
              "Order Priority" := 600;
            DATABASE::"Production Forecast Entry":
              "Order Priority" := 800;
          END;

        OnAfterSetOrderPriority(InvProfile);

        TESTFIELD("Order Priority");

        // Inflexible supply must be handled before all other supply and is therefore grouped
        // together with inventory in group 100:
        IF IsSupply AND ("Source Type" <> DATABASE::"Item Ledger Entry") THEN
          IF "Planning Flexibility" <> "Planning Flexibility"::Unlimited THEN
            "Order Priority" := 100 + ("Order Priority" / 10);

        IF "Planning Flexibility" = "Planning Flexibility"::Unlimited THEN
          IF ActiveInWarehouse THEN
            "Order Priority" -= 1;

        SetAttributePriority(InvProfile);

        MODIFY;
      END;
    END;

    LOCAL PROCEDURE SetAttributePriority@47(VAR InvProfile@1000 : Record 99000853);
    VAR
      HandleLot@1002 : Boolean;
      HandleSN@1001 : Boolean;
    BEGIN
      WITH InvProfile DO BEGIN
        HandleSN := ("Serial No." <> '') AND SpecificSNTracking;
        HandleLot := ("Lot No." <> '') AND SpecificLotTracking;

        IF HandleSN THEN BEGIN
          IF HandleLot THEN
            IF Binding = Binding::"Order-to-Order" THEN
              "Attribute Priority" := 1
            ELSE
              "Attribute Priority" := 4
          ELSE
            IF Binding = Binding::"Order-to-Order" THEN
              "Attribute Priority" := 2
            ELSE
              "Attribute Priority" := 5;
        END ELSE BEGIN
          IF HandleLot THEN
            IF Binding = Binding::"Order-to-Order" THEN
              "Attribute Priority" := 3
            ELSE
              "Attribute Priority" := 6
          ELSE
            IF Binding = Binding::"Order-to-Order" THEN
              "Attribute Priority" := 7
            ELSE
              "Attribute Priority" := 8;
        END;
      END;
    END;

    LOCAL PROCEDURE UpdatePriorities@86(VAR InvProfile@1000 : Record 99000853;IsReorderPointPlanning@1002 : Boolean;ToDate@1003 : Date);
    VAR
      xInvProfile@1001 : Record 99000853;
    BEGIN
      xInvProfile.COPY(InvProfile);
      InvProfile.SETCURRENTKEY("Line No.");
      IF InvProfile.FINDSET(TRUE) THEN
        REPEAT
          SetPriority(InvProfile,IsReorderPointPlanning,ToDate);
        UNTIL InvProfile.NEXT = 0;
      InvProfile.COPY(xInvProfile);
    END;

    LOCAL PROCEDURE InsertSafetyStockDemands@84(VAR Demand@1000 : Record 99000853;PlanningStartDate@1004 : Date);
    VAR
      xDemand@1002 : Record 99000853;
      SafetyStockDemandBuffer@1001 : TEMPORARY Record 99000853;
      OrderRelation@1003 : 'Normal,Safety Stock,Reorder Point';
    BEGIN
      IF TempSKU."Safety Stock Quantity" = 0 THEN
        EXIT;
      xDemand.COPY(Demand);

      Demand.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Due Date","Attribute Priority","Order Priority");
      Demand.SETFILTER("Due Date",'%1..',PlanningStartDate);

      IF Demand.FINDSET THEN
        REPEAT
          IF SafetyStockDemandBuffer."Due Date" <> Demand."Due Date" THEN
            CreateDemand(SafetyStockDemandBuffer,TempSKU,TempSKU."Safety Stock Quantity",
              Demand."Due Date",OrderRelation::"Safety Stock");
        UNTIL Demand.NEXT = 0;

      Demand.SETRANGE("Due Date",PlanningStartDate);
      IF Demand.ISEMPTY THEN
        CreateDemand(SafetyStockDemandBuffer,TempSKU,TempSKU."Safety Stock Quantity",PlanningStartDate,OrderRelation::"Safety Stock");

      IF SafetyStockDemandBuffer.FINDSET(TRUE) THEN
        REPEAT
          Demand := SafetyStockDemandBuffer;
          Demand."Order Priority" := 1000;
          Demand.INSERT;
        UNTIL SafetyStockDemandBuffer.NEXT = 0;

      Demand.COPY(xDemand)
    END;

    LOCAL PROCEDURE ScheduleAllOutChangesSequence@10(VAR Supply@1000 : Record 99000853;NewDate@1006 : Date) : Boolean;
    VAR
      xSupply@1004 : Record 99000853;
      TempRescheduledSupply@1002 : TEMPORARY Record 99000853;
      TryRescheduleSupply@1003 : Boolean;
      HasLooped@1005 : Boolean;
      Continue@1007 : Boolean;
      NumberofSupplies@1008 : Integer;
    BEGIN
      xSupply.COPY(Supply);
      IF (Supply."Due Date" = 0D) OR
         (Supply."Planning Flexibility" <> Supply."Planning Flexibility"::Unlimited)
      THEN
        EXIT(FALSE);

      IF NOT AllowScheduleOut(Supply,NewDate) THEN
        EXIT(FALSE);

      Continue := TRUE;
      TryRescheduleSupply := TRUE;

      WHILE Continue DO BEGIN
        NumberofSupplies += 1;
        TempRescheduledSupply := Supply;
        TempRescheduledSupply."Line No." := -TempRescheduledSupply."Line No."; // Use negative Line No. to shift sequence
        TempRescheduledSupply.INSERT;
        IF TryRescheduleSupply THEN BEGIN
          Reschedule(TempRescheduledSupply,NewDate,0T);
          Continue := TempRescheduledSupply."Due Date" <> Supply."Due Date";
        END;
        IF Continue THEN
          IF Supply.NEXT <> 0 THEN BEGIN
            Continue := Supply."Due Date" <= NewDate;
            TryRescheduleSupply :=
              (Supply."Planning Flexibility" = Supply."Planning Flexibility"::Unlimited) AND (Supply."Fixed Date" = 0D);
          END ELSE
            Continue := FALSE;
      END;

      // If there is only one supply before the demand we roll back
      IF NumberofSupplies = 1 THEN BEGIN
        Supply.COPY(xSupply);
        EXIT(FALSE);
      END;

      TempRescheduledSupply.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Due Date","Attribute Priority","Order Priority");

      // If we have resheduled we replace the original supply records with the resceduled ones,
      // we re-write the primary key to make sure that the supplies are handled in the right order.
      IF TempRescheduledSupply.FINDSET THEN BEGIN
        REPEAT
          Supply."Line No." := -TempRescheduledSupply."Line No.";
          Supply.DELETE;
          Supply := TempRescheduledSupply;
          Supply."Line No." := NextLineNo;
          Supply.INSERT;
          IF NOT HasLooped THEN BEGIN
            xSupply := Supply; // The first supply is bookmarked
            HasLooped := TRUE;
          END;
        UNTIL TempRescheduledSupply.NEXT = 0;
        Supply := xSupply;
      END;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE PrepareOrderToOrderLink@16(VAR InventoryProfile@1000 : Record 99000853);
    BEGIN
      // Prepare new demand for order-to-order planning
      WITH InventoryProfile DO BEGIN
        IF FINDSET(TRUE) THEN
          REPEAT
            IF NOT IsSupply THEN
              IF NOT ("Source Type" = DATABASE::"Production Forecast Entry") THEN
                IF NOT (("Source Type" = DATABASE::"Sales Line") AND ("Source Order Status" = 4)) THEN // Blanket Order
                  IF (TempSKU."Reordering Policy" = TempSKU."Reordering Policy"::Order) OR
                     ("Planning Level Code" <> 0)
                  THEN BEGIN
                    IF "Source Type" = DATABASE::"Planning Component" THEN BEGIN
                      // Primary Order references have already been set on Component Lines
                      Binding := Binding::"Order-to-Order";
                    END ELSE BEGIN
                      Binding := Binding::"Order-to-Order";
                      "Primary Order Type" := "Source Type";
                      "Primary Order Status" := "Source Order Status";
                      "Primary Order No." := "Source ID";
                      IF "Source Type" <> DATABASE::"Prod. Order Component" THEN
                        "Primary Order Line" := "Source Ref. No.";
                    END;
                    MODIFY;
                  END;
          UNTIL NEXT = 0;
      END;
    END;

    LOCAL PROCEDURE SetAcceptAction@5(ItemNo@1000 : Code[20]);
    VAR
      ReqLine@1001 : Record 246;
      PurchHeader@1002 : Record 38;
      ProdOrder@1003 : Record 5405;
      TransHeader@1004 : Record 5740;
      AsmHeader@1007 : Record 900;
      ReqWkshTempl@1006 : Record 244;
      AcceptActionMsg@1005 : Boolean;
    BEGIN
      WITH ReqLine DO BEGIN
        ReqWkshTempl.GET(CurrTemplateName);
        IF ReqWkshTempl.Type <> ReqWkshTempl.Type::Planning THEN
          EXIT;
        SETCURRENTKEY("Worksheet Template Name","Journal Batch Name",Type,"No.");
        SETRANGE("Worksheet Template Name",CurrTemplateName);
        SETRANGE("Journal Batch Name",CurrWorksheetName);
        SETRANGE(Type,Type::Item);
        SETRANGE("No.",ItemNo);
        DummyInventoryProfileTrackBuffer."Warning Level" := DummyInventoryProfileTrackBuffer."Warning Level"::Attention;

        IF FINDSET(TRUE) THEN
          REPEAT
            AcceptActionMsg := "Starting Date" >= WORKDATE;
            IF NOT AcceptActionMsg THEN
              Transparency.LogWarning(0,ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",
                STRSUBSTNO(Text008,DummyInventoryProfileTrackBuffer."Warning Level",FIELDCAPTION("Starting Date"),
                  "Starting Date",WORKDATE));

            IF "Action Message" <> "Action Message"::New THEN
              CASE "Ref. Order Type" OF
                "Ref. Order Type"::Purchase:
                  IF (PurchHeader.GET(PurchHeader."Document Type"::Order,"Ref. Order No.") AND
                      (PurchHeader.Status = PurchHeader.Status::Released))
                  THEN BEGIN
                    AcceptActionMsg := FALSE;
                    Transparency.LogWarning(0,ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",STRSUBSTNO(Text009,
                        DummyInventoryProfileTrackBuffer."Warning Level",PurchHeader.FIELDCAPTION(Status),"Ref. Order Type",
                        "Ref. Order No.",PurchHeader.Status));
                  END;
                "Ref. Order Type"::"Prod. Order":
                  IF "Ref. Order Status" = ProdOrder.Status::Released THEN BEGIN
                    AcceptActionMsg := FALSE;
                    Transparency.LogWarning(0,ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",STRSUBSTNO(Text009,
                        DummyInventoryProfileTrackBuffer."Warning Level",ProdOrder.FIELDCAPTION(Status),"Ref. Order Type",
                        "Ref. Order No.","Ref. Order Status"));
                  END;
                "Ref. Order Type"::Assembly:
                  IF AsmHeader.GET("Ref. Order Status","Ref. Order No.") AND
                     (AsmHeader.Status = AsmHeader.Status::Released)
                  THEN BEGIN
                    AcceptActionMsg := FALSE;
                    Transparency.LogWarning(0,ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",STRSUBSTNO(Text009,
                        DummyInventoryProfileTrackBuffer."Warning Level",AsmHeader.FIELDCAPTION(Status),"Ref. Order Type",
                        "Ref. Order No.",AsmHeader.Status));
                  END;
                "Ref. Order Type"::Transfer:
                  IF (TransHeader.GET("Ref. Order No.") AND
                      (TransHeader.Status = TransHeader.Status::Released))
                  THEN BEGIN
                    AcceptActionMsg := FALSE;
                    Transparency.LogWarning(0,ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",STRSUBSTNO(Text009,
                        DummyInventoryProfileTrackBuffer."Warning Level",TransHeader.FIELDCAPTION(Status),"Ref. Order Type",
                        "Ref. Order No.",TransHeader.Status));
                  END;
              END;

            IF AcceptActionMsg THEN
              AcceptActionMsg := Transparency.ReqLineWarningLevel(ReqLine) = 0;

            IF NOT AcceptActionMsg THEN BEGIN
              "Accept Action Message" := FALSE;
              MODIFY;
            END;
          UNTIL NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE GetRouting@21(VAR ReqLine@1000 : Record 246);
    VAR
      PlanRoutingLine@1002 : Record 99000830;
      ProdOrderRoutingLine@1003 : Record 5409;
      ProdOrderLine@1006 : Record 5406;
      VersionMgt@1004 : Codeunit 99000756;
    BEGIN
      WITH ReqLine DO BEGIN
        IF Quantity <= 0 THEN
          EXIT;

        IF ("Action Message" = "Action Message"::New) OR
           ("Ref. Order Type" = "Ref. Order Type"::Purchase)
        THEN BEGIN
          IF "Routing No." <> '' THEN
            VALIDATE("Routing Version Code",
              VersionMgt.GetRtngVersion("Routing No.","Due Date",TRUE));
          CLEAR(PlngLnMgt);
          IF PlanningResilicency THEN
            PlngLnMgt.SetResiliencyOn("Worksheet Template Name","Journal Batch Name","No.");
        END ELSE
          IF "Ref. Order Type" = "Ref. Order Type"::"Prod. Order" THEN BEGIN
            ProdOrderLine.GET("Ref. Order Status","Ref. Order No.","Ref. Line No.");
            ProdOrderRoutingLine.SETRANGE(Status,ProdOrderLine.Status);
            ProdOrderRoutingLine.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
            ProdOrderRoutingLine.SETRANGE("Routing Reference No.",ProdOrderLine."Routing Reference No.");
            ProdOrderRoutingLine.SETRANGE("Routing No.",ProdOrderLine."Routing No.");
            DisableRelations;
            IF ProdOrderRoutingLine.FIND('-') THEN
              REPEAT
                PlanRoutingLine.INIT;
                PlanRoutingLine."Worksheet Template Name" := "Worksheet Template Name";
                PlanRoutingLine."Worksheet Batch Name" := "Journal Batch Name";
                PlanRoutingLine."Worksheet Line No." := "Line No.";
                PlanRoutingLine.TransferFromProdOrderRouting(ProdOrderRoutingLine);
                PlanRoutingLine.INSERT;
              UNTIL ProdOrderRoutingLine.NEXT = 0;
          END;
      END;
    END;

    [External]
    PROCEDURE GetComponents@32(VAR ReqLine@1000 : Record 246);
    VAR
      PlanComponent@1003 : Record 99000829;
      ProdOrderComp@1004 : Record 5407;
      AsmLine@1006 : Record 901;
      VersionMgt@1005 : Codeunit 99000756;
    BEGIN
      WITH ReqLine DO BEGIN
        BlockDynamicTracking(TRUE);
        CLEAR(PlngLnMgt);
        IF PlanningResilicency THEN
          PlngLnMgt.SetResiliencyOn("Worksheet Template Name","Journal Batch Name","No.");
        PlngLnMgt.BlockDynamicTracking(TRUE);
        IF "Action Message" = "Action Message"::New THEN BEGIN
          IF "Production BOM No." <> '' THEN
            VALIDATE("Production BOM Version Code",
              VersionMgt.GetBOMVersion("Production BOM No.","Due Date",TRUE));
        END ELSE
          CASE "Ref. Order Type" OF
            "Ref. Order Type"::"Prod. Order":
              BEGIN
                ProdOrderComp.SETRANGE(Status,"Ref. Order Status");
                ProdOrderComp.SETRANGE("Prod. Order No.","Ref. Order No.");
                ProdOrderComp.SETRANGE("Prod. Order Line No.","Ref. Line No.");
                IF ProdOrderComp.FIND('-') THEN
                  REPEAT
                    PlanComponent.INIT;
                    PlanComponent."Worksheet Template Name" := "Worksheet Template Name";
                    PlanComponent."Worksheet Batch Name" := "Journal Batch Name";
                    PlanComponent."Worksheet Line No." := "Line No.";
                    PlanComponent."Planning Line Origin" := "Planning Line Origin";
                    PlanComponent.TransferFromComponent(ProdOrderComp);
                    PlanComponent.INSERT;
                    TempPlanningCompList := PlanComponent;
                    IF NOT TempPlanningCompList.INSERT THEN
                      TempPlanningCompList.MODIFY;
                  UNTIL ProdOrderComp.NEXT = 0;
              END;
            "Ref. Order Type"::Assembly:
              BEGIN
                AsmLine.SETRANGE("Document Type",AsmLine."Document Type"::Order);
                AsmLine.SETRANGE("Document No.","Ref. Order No.");
                AsmLine.SETRANGE(Type,AsmLine.Type::Item);
                IF AsmLine.FIND('-') THEN
                  REPEAT
                    PlanComponent.INIT;
                    PlanComponent."Worksheet Template Name" := "Worksheet Template Name";
                    PlanComponent."Worksheet Batch Name" := "Journal Batch Name";
                    PlanComponent."Worksheet Line No." := "Line No.";
                    PlanComponent."Planning Line Origin" := "Planning Line Origin";
                    PlanComponent.TransferFromAsmLine(AsmLine);
                    PlanComponent.INSERT;
                    TempPlanningCompList := PlanComponent;
                    IF NOT TempPlanningCompList.INSERT THEN
                      TempPlanningCompList.MODIFY;
                  UNTIL AsmLine.NEXT = 0;
              END;
          END;
      END;
    END;

    [Internal]
    PROCEDURE Recalculate@117(VAR ReqLine@1000 : Record 246;Direction@1001 : 'Forward,Backward');
    VAR
      RefreshRouting@1003 : Boolean;
    BEGIN
      WITH ReqLine DO BEGIN
        RefreshRouting := ("Action Message" = "Action Message"::New) OR ("Ref. Order Type" = "Ref. Order Type"::Purchase);

        PlngLnMgt.Calculate(ReqLine,Direction,RefreshRouting,"Action Message" = "Action Message"::New,-1);
        IF "Action Message" = "Action Message"::New THEN
          PlngLnMgt.GetPlanningCompList(TempPlanningCompList);
      END;
    END;

    [External]
    PROCEDURE GetPlanningCompList@34(VAR PlanningCompList@1000 : TEMPORARY Record 99000829);
    BEGIN
      IF TempPlanningCompList.FIND('-') THEN
        REPEAT
          PlanningCompList := TempPlanningCompList;
          IF NOT PlanningCompList.INSERT THEN
            PlanningCompList.MODIFY;
          TempPlanningCompList.DELETE;
        UNTIL TempPlanningCompList.NEXT = 0;
    END;

    [External]
    PROCEDURE SetParm@59(Forecast@1000 : Code[10];ExclBefore@1001 : Date;WorksheetType@1002 : 'Requisition,Planning');
    BEGIN
      CurrForecast := Forecast;
      ExcludeForecastBefore := ExclBefore;
      UseParm := TRUE;
      CurrWorksheetType := WorksheetType;
    END;

    [External]
    PROCEDURE SetResiliencyOn@11();
    BEGIN
      PlanningResilicency := TRUE;
    END;

    [External]
    PROCEDURE GetResiliencyError@4(VAR PlanningErrorLog@1000 : Record 5430) : Boolean;
    BEGIN
      IF ReqLine.GetResiliencyError(PlanningErrorLog) THEN
        EXIT(TRUE);
      EXIT(PlngLnMgt.GetResiliencyError(PlanningErrorLog));
    END;

    LOCAL PROCEDURE CloseTracking@92(ReservEntry@1000 : Record 337;VAR SupplyInventoryProfile@1001 : Record 99000853;ToDate@1002 : Date) : Boolean;
    VAR
      xSupplyInventoryProfile@1003 : Record 99000853;
      ReservationEngineMgt@1004 : Codeunit 99000831;
      Closed@1005 : Boolean;
    BEGIN
      WITH ReservEntry DO BEGIN
        IF "Reservation Status" <> "Reservation Status"::Tracking THEN
          EXIT(FALSE);

        xSupplyInventoryProfile.COPY(SupplyInventoryProfile);
        Closed := FALSE;

        IF ("Expected Receipt Date" <= ToDate) AND
           ("Shipment Date" > ToDate)
        THEN BEGIN
          // tracking exists with demand in future
          SupplyInventoryProfile.SETCURRENTKEY(
            "Source Type","Source Order Status","Source ID","Source Batch Name","Source Ref. No.","Source Prod. Order Line",IsSupply,
            "Due Date");
          SupplyInventoryProfile.SETRANGE("Source Type","Source Type");
          SupplyInventoryProfile.SETRANGE("Source Order Status","Source Subtype");
          SupplyInventoryProfile.SETRANGE("Source ID","Source ID");
          SupplyInventoryProfile.SETRANGE("Source Batch Name","Source Batch Name");
          SupplyInventoryProfile.SETRANGE("Source Ref. No.","Source Ref. No.");
          SupplyInventoryProfile.SETRANGE("Source Prod. Order Line","Source Prod. Order Line");
          SupplyInventoryProfile.SETRANGE("Due Date",0D,ToDate);

          IF NOT SupplyInventoryProfile.ISEMPTY THEN BEGIN
            // demand is either deleted as well or will get Surplus status
            ReservationEngineMgt.CloseReservEntry(ReservEntry,FALSE,FALSE);
            Closed := TRUE;
          END;
        END;
      END;

      SupplyInventoryProfile.COPY(xSupplyInventoryProfile);
      EXIT(Closed);
    END;

    LOCAL PROCEDURE FrozenZoneTrack@52(FromInventoryProfile@1000 : Record 99000853;ToInventoryProfile@1001 : Record 99000853);
    BEGIN
      IF FromInventoryProfile.TrackingExists THEN
        Track(FromInventoryProfile,ToInventoryProfile,TRUE,FALSE,FromInventoryProfile.Binding::" ");

      IF ToInventoryProfile.TrackingExists THEN BEGIN
        ToInventoryProfile."Untracked Quantity" := FromInventoryProfile."Untracked Quantity";
        ToInventoryProfile."Quantity (Base)" := FromInventoryProfile."Untracked Quantity";
        ToInventoryProfile."Original Quantity" := 0;
        Track(ToInventoryProfile,FromInventoryProfile,TRUE,FALSE,ToInventoryProfile.Binding::" ");
      END;
    END;

    LOCAL PROCEDURE ExceedROPinException@93(RespectPlanningParm@1000 : Boolean) : Boolean;
    BEGIN
      IF NOT RespectPlanningParm THEN
        EXIT(FALSE);

      EXIT(TempSKU."Reordering Policy" = TempSKU."Reordering Policy"::"Fixed Reorder Qty.");
    END;

    LOCAL PROCEDURE CreateSupplyForInitialSafetyStockWarning@97(VAR SupplyInventoryProfile@1004 : Record 99000853;ProjectedInventory@1000 : Decimal;VAR LastProjectedInventory@1006 : Decimal;VAR LastAvailableInventory@1007 : Decimal;PlanningStartDate@1005 : Date;RespectPlanningParm@1002 : Boolean;IsReorderPointPlanning@1008 : Boolean);
    VAR
      OrderQty@1001 : Decimal;
      ReorderQty@1003 : Decimal;
    BEGIN
      OrderQty := TempSKU."Safety Stock Quantity" - ProjectedInventory;
      IF ExceedROPinException(RespectPlanningParm) THEN
        OrderQty := TempSKU."Reorder Point" - ProjectedInventory;

      ReorderQty := OrderQty;

      REPEAT
        InitSupply(SupplyInventoryProfile,ReorderQty,PlanningStartDate);
        IF RespectPlanningParm THEN BEGIN
          IF IsReorderPointPlanning THEN
            ReorderQty := CalcOrderQty(ReorderQty,ProjectedInventory,SupplyInventoryProfile."Line No.");

          ReorderQty += AdjustReorderQty(ReorderQty,TempSKU,SupplyInventoryProfile."Line No.",SupplyInventoryProfile."Min. Quantity");
          SupplyInventoryProfile."Max. Quantity" := TempSKU."Maximum Order Quantity";
          UpdateQty(SupplyInventoryProfile,ReorderQty);
          SupplyInventoryProfile."Min. Quantity" := SupplyInventoryProfile."Quantity (Base)";
        END;
        SupplyInventoryProfile."Fixed Date" := SupplyInventoryProfile."Due Date";
        SupplyInventoryProfile."Order Relation" := SupplyInventoryProfile."Order Relation"::"Safety Stock";
        SupplyInventoryProfile."Is Exception Order" := TRUE;
        SupplyInventoryProfile.INSERT;

        DummyInventoryProfileTrackBuffer."Warning Level" := DummyInventoryProfileTrackBuffer."Warning Level"::Exception;
        Transparency.LogWarning(SupplyInventoryProfile."Line No.",ReqLine,DummyInventoryProfileTrackBuffer."Warning Level",
          STRSUBSTNO(Text007,DummyInventoryProfileTrackBuffer."Warning Level",TempSKU.FIELDCAPTION("Safety Stock Quantity"),
            TempSKU."Safety Stock Quantity",PlanningStartDate));

        LastProjectedInventory += SupplyInventoryProfile."Remaining Quantity (Base)";
        ProjectedInventory += SupplyInventoryProfile."Remaining Quantity (Base)";
        LastAvailableInventory += SupplyInventoryProfile."Untracked Quantity";

        OrderQty -= ReorderQty;
        IF ExceedROPinException(RespectPlanningParm) AND (OrderQty = 0) THEN
          OrderQty := ExceedROPqty;
        ReorderQty := OrderQty;
      UNTIL OrderQty <= 0; // Create supplies until Safety Stock is met or Reorder point is exceeded
    END;

    LOCAL PROCEDURE IsTrkgForSpecialOrderOrDropShpt@94(ReservEntry@1000 : Record 337) : Boolean;
    VAR
      SalesLine@1001 : Record 37;
      PurchLine@1002 : Record 39;
    BEGIN
      CASE ReservEntry."Source Type" OF
        DATABASE::"Sales Line":
          IF SalesLine.GET(ReservEntry."Source Subtype",ReservEntry."Source ID",ReservEntry."Source Ref. No.") THEN
            EXIT(SalesLine."Special Order" OR SalesLine."Drop Shipment");
        DATABASE::"Purchase Line":
          IF PurchLine.GET(ReservEntry."Source Subtype",ReservEntry."Source ID",ReservEntry."Source Ref. No.") THEN
            EXIT(PurchLine."Special Order" OR PurchLine."Drop Shipment");
      END;

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE CheckSupplyRemQtyAndUntrackQty@96(VAR InventoryProfile@1001 : Record 99000853);
    VAR
      RemQty@1002 : Decimal;
    BEGIN
      WITH InventoryProfile DO BEGIN
        IF "Source Type" = DATABASE::"Item Ledger Entry" THEN
          EXIT;

        IF "Remaining Quantity (Base)" >= TempSKU."Maximum Order Quantity" THEN BEGIN
          RemQty := "Remaining Quantity (Base)";
          "Remaining Quantity (Base)" := TempSKU."Maximum Order Quantity";
          IF NOT ("Action Message" IN ["Action Message"::New,"Action Message"::Reschedule]) THEN
            "Original Quantity" := "Quantity (Base)";
        END;
        IF "Untracked Quantity" >= TempSKU."Maximum Order Quantity" THEN
          "Untracked Quantity" := "Untracked Quantity" - RemQty + "Remaining Quantity (Base)";
      END;
    END;

    LOCAL PROCEDURE CheckItemInventoryExists@98(VAR InventoryProfile@1000 : Record 99000853) ItemInventoryExists : Boolean;
    BEGIN
      WITH InventoryProfile DO BEGIN
        SETRANGE("Source Type",DATABASE::"Item Ledger Entry");
        SETFILTER(Binding,'<>%1',Binding::"Order-to-Order");
        ItemInventoryExists := NOT ISEMPTY;
        SETRANGE("Source Type");
        SETRANGE(Binding);
      END;
    END;

    LOCAL PROCEDURE ApplyUntrackedQuantityToItemInventory@101(SupplyExists@1001 : Boolean;ItemInventoryExists@1000 : Boolean) : Boolean;
    BEGIN
      IF SupplyExists THEN
        EXIT(FALSE);
      EXIT(ItemInventoryExists);
    END;

    LOCAL PROCEDURE UpdateAppliedItemEntry@102(VAR ReservEntry@1000 : Record 337);
    BEGIN
      WITH TempItemTrkgEntry DO BEGIN
        SetSourceFilter(
          ReservEntry."Source Type",ReservEntry."Source Subtype",ReservEntry."Source ID",ReservEntry."Source Ref. No.",TRUE);
        IF ReservEntry."Lot No." <> '' THEN
          SETRANGE("Lot No.",ReservEntry."Lot No.");
        IF ReservEntry."Serial No." <> '' THEN
          SETRANGE("Serial No.",ReservEntry."Serial No.");
        IF FINDFIRST THEN BEGIN
          ReservEntry."Appl.-from Item Entry" := "Appl.-from Item Entry";
          ReservEntry."Appl.-to Item Entry" := "Appl.-to Item Entry";
        END;
      END;
    END;

    LOCAL PROCEDURE CheckSupplyAndTrack@100(InventoryProfileFromDemand@1001 : Record 99000853;InventoryProfileFromSupply@1000 : Record 99000853);
    BEGIN
      IF InventoryProfileFromSupply."Source Type" = DATABASE::"Item Ledger Entry" THEN
        Track(InventoryProfileFromDemand,InventoryProfileFromSupply,FALSE,FALSE,InventoryProfileFromSupply.Binding)
      ELSE
        Track(InventoryProfileFromDemand,InventoryProfileFromSupply,FALSE,FALSE,InventoryProfileFromDemand.Binding);
    END;

    LOCAL PROCEDURE CheckPlanSKU@103(SKU@1003 : Record 5700;DemandExists@1000 : Boolean;SupplyExists@1001 : Boolean;IsReorderPointPlanning@1002 : Boolean) : Boolean;
    BEGIN
      IF (CurrWorksheetType = CurrWorksheetType::Requisition) AND
         (SKU."Replenishment System" IN [SKU."Replenishment System"::"Prod. Order",SKU."Replenishment System"::Assembly])
      THEN
        EXIT(FALSE);

      IF DemandExists OR SupplyExists OR IsReorderPointPlanning THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE PrepareDemand@107(VAR InventoryProfile@1000 : Record 99000853;IsReorderPointPlanning@1002 : Boolean;ToDate@1001 : Date);
    BEGIN
      // Transfer attributes
      IF (TempSKU."Reordering Policy" = TempSKU."Reordering Policy"::Order) OR
         (TempSKU."Manufacturing Policy" = TempSKU."Manufacturing Policy"::"Make-to-Order")
      THEN
        PrepareOrderToOrderLink(InventoryProfile);
      UpdatePriorities(InventoryProfile,IsReorderPointPlanning,ToDate);
    END;

    LOCAL PROCEDURE DemandMatchedSupply@106(VAR FromInventoryProfile@1000 : Record 99000853;VAR ToInventoryProfile@1001 : Record 99000853;SKU@1006 : Record 5700) : Boolean;
    VAR
      xFromInventoryProfile@1002 : Record 99000853;
      xToInventoryProfile@1003 : Record 99000853;
      UntrackedQty@1005 : Decimal;
    BEGIN
      xToInventoryProfile.COPYFILTERS(FromInventoryProfile);
      xFromInventoryProfile.COPYFILTERS(ToInventoryProfile);
      WITH FromInventoryProfile DO BEGIN
        SETRANGE("Attribute Priority",1,7);
        IF FINDSET THEN BEGIN
          REPEAT
            ToInventoryProfile.SETRANGE(Binding,Binding);
            ToInventoryProfile.SETRANGE("Primary Order Status","Primary Order Status");
            ToInventoryProfile.SETRANGE("Primary Order No.","Primary Order No.");
            ToInventoryProfile.SETRANGE("Primary Order Line","Primary Order Line");
            ToInventoryProfile.SetTrackingFilter(FromInventoryProfile);
            IF ToInventoryProfile.FINDSET THEN
              REPEAT
                UntrackedQty += ToInventoryProfile."Untracked Quantity";
              UNTIL ToInventoryProfile.NEXT = 0;
            UntrackedQty -= "Untracked Quantity";
          UNTIL NEXT = 0;
          IF (UntrackedQty = 0) AND (SKU."Reordering Policy" = SKU."Reordering Policy"::"Lot-for-Lot") THEN BEGIN
            SETRANGE("Attribute Priority",8);
            CALCSUMS("Untracked Quantity");
            IF "Untracked Quantity" = 0 THEN BEGIN
              COPYFILTERS(xToInventoryProfile);
              ToInventoryProfile.COPYFILTERS(xFromInventoryProfile);
              EXIT(TRUE);
            END;
          END;
        END;
        COPYFILTERS(xToInventoryProfile);
        ToInventoryProfile.COPYFILTERS(xFromInventoryProfile);
        EXIT(FALSE);
      END;
    END;

    LOCAL PROCEDURE ReservedForProdComponent@108(ReservationEntry@1000 : Record 337) : Boolean;
    BEGIN
      IF NOT ReservationEntry.Positive THEN
        EXIT(ReservationEntry."Source Type" = DATABASE::"Prod. Order Component");
      IF ReservationEntry.GET(ReservationEntry."Entry No.",FALSE) THEN
        EXIT(ReservationEntry."Source Type" = DATABASE::"Prod. Order Component");
    END;

    LOCAL PROCEDURE ShouldInsertTrackingEntry@110(FromTrkgReservEntry@1001 : Record 337) : Boolean;
    VAR
      InsertedReservEntry@1002 : Record 337;
    BEGIN
      WITH InsertedReservEntry DO BEGIN
        SETRANGE("Source ID",FromTrkgReservEntry."Source ID");
        SETRANGE("Source Ref. No.",FromTrkgReservEntry."Source Ref. No.");
        SETRANGE("Source Type",FromTrkgReservEntry."Source Type");
        SETRANGE("Source Subtype",FromTrkgReservEntry."Source Subtype");
        SETRANGE("Source Batch Name",FromTrkgReservEntry."Source Batch Name");
        SETRANGE("Source Prod. Order Line",FromTrkgReservEntry."Source Prod. Order Line");
        SETRANGE("Reservation Status",FromTrkgReservEntry."Reservation Status");
        EXIT(ISEMPTY);
      END;
    END;

    LOCAL PROCEDURE CloseInventoryProfile@114(VAR ClosedInvtProfile@1000 : Record 99000853;VAR OpenInvtProfile@1001 : Record 99000853;ActionMessage@1003 : ' ,New,Change Qty.,Reschedule,Resched.& Chg. Qty.,Cancel');
    VAR
      PlanningStageToMaintain@1002 : ' ,Line Created,Routing Created,Exploded,Obsolete';
    BEGIN
      OpenInvtProfile."Untracked Quantity" -= ClosedInvtProfile."Untracked Quantity";
      OpenInvtProfile.MODIFY;

      IF OpenInvtProfile.Binding = OpenInvtProfile.Binding::"Order-to-Order" THEN
        PlanningStageToMaintain := PlanningStageToMaintain::Exploded
      ELSE
        PlanningStageToMaintain := PlanningStageToMaintain::"Line Created";

      IF ActionMessage <> ActionMessage::" " THEN
        IF OpenInvtProfile.IsSupply THEN
          MaintainPlanningLine(OpenInvtProfile,PlanningStageToMaintain,ScheduleDirection::Backward)
        ELSE
          MaintainPlanningLine(ClosedInvtProfile,PlanningStageToMaintain,ScheduleDirection::Backward);

      Track(ClosedInvtProfile,OpenInvtProfile,FALSE,FALSE,OpenInvtProfile.Binding);

      IF ClosedInvtProfile.Binding = ClosedInvtProfile.Binding::"Order-to-Order" THEN
        ClosedInvtProfile."Remaining Quantity (Base)" -= ClosedInvtProfile."Untracked Quantity";

      ClosedInvtProfile."Untracked Quantity" := 0;
      IF ClosedInvtProfile."Remaining Quantity (Base)" = 0 THEN
        ClosedInvtProfile.DELETE
      ELSE
        ClosedInvtProfile.MODIFY;
    END;

    LOCAL PROCEDURE CloseDemand@123(VAR DemandInvtProfile@1001 : Record 99000853;VAR SupplyInvtProfile@1000 : Record 99000853);
    BEGIN
      CloseInventoryProfile(DemandInvtProfile,SupplyInvtProfile,SupplyInvtProfile."Action Message");
    END;

    LOCAL PROCEDURE CloseSupply@124(VAR DemandInvtProfile@1001 : Record 99000853;VAR SupplyInvtProfile@1000 : Record 99000853) : Boolean;
    BEGIN
      CloseInventoryProfile(SupplyInvtProfile,DemandInvtProfile,SupplyInvtProfile."Action Message");
      EXIT(SupplyInvtProfile.NEXT <> 0);
    END;

    LOCAL PROCEDURE QtyPickedForSourceDocument@113(TrkgReservEntry@1001 : Record 337) : Decimal;
    VAR
      WhseEntry@1000 : Record 7312;
    BEGIN
      WhseEntry.SETRANGE("Item No.",TrkgReservEntry."Item No.");
      WhseEntry.SetSourceFilter(
        TrkgReservEntry."Source Type",TrkgReservEntry."Source Subtype",TrkgReservEntry."Source ID",
        TrkgReservEntry."Source Ref. No.",FALSE);
      WhseEntry.SETRANGE("Lot No.",TrkgReservEntry."Lot No.");
      WhseEntry.SETRANGE("Serial No.",TrkgReservEntry."Serial No.");
      WhseEntry.SETFILTER("Qty. (Base)",'<0');
      WhseEntry.CALCSUMS("Qty. (Base)");
      EXIT(WhseEntry."Qty. (Base)");
    END;

    LOCAL PROCEDURE CreateTempSKUForComponentsLocation@112(VAR Item@1001 : Record 27);
    VAR
      SKU@1000 : Record 5700;
    BEGIN
      IF ManufacturingSetup."Components at Location" = '' THEN
        EXIT;

      SKU.SETRANGE("Item No.",Item."No.");
      SKU.SETRANGE("Location Code",ManufacturingSetup."Components at Location");
      Item.COPYFILTER("Variant Filter",SKU."Variant Code");
      IF SKU.ISEMPTY THEN
        CreateTempSKUForLocation(Item."No.",ManufacturingSetup."Components at Location");
    END;

    LOCAL PROCEDURE ForecastInitDemand@127(VAR InventoryProfile@1000 : Record 99000853;ProductionForecastEntry@1003 : Record 99000852;ItemNo@1004 : Code[20];LocationCode@1001 : Code[10];TotalForecastQty@1002 : Decimal);
    BEGIN
      WITH InventoryProfile DO BEGIN
        INIT;
        "Line No." := NextLineNo;
        "Source Type" := DATABASE::"Production Forecast Entry";
        "Planning Flexibility" := "Planning Flexibility"::None;
        "Qty. per Unit of Measure" := 1;
        "MPS Order" := TRUE;
        "Source ID" := ProductionForecastEntry."Production Forecast Name";
        "Item No." := ItemNo;
        IF ManufacturingSetup."Use Forecast on Locations" THEN
          "Location Code" := ProductionForecastEntry."Location Code"
        ELSE
          "Location Code" := LocationCode;
        "Remaining Quantity (Base)" := TotalForecastQty;
        "Untracked Quantity" := TotalForecastQty;
      END;
    END;

    LOCAL PROCEDURE SetPurchase@118(VAR PurchaseLine@1003 : Record 39;VAR InventoryProfile@1000 : Record 99000853);
    BEGIN
      WITH ReqLine DO BEGIN
        "Ref. Order Type" := "Ref. Order Type"::Purchase;
        "Ref. Order No." := InventoryProfile."Source ID";
        "Ref. Line No." := InventoryProfile."Source Ref. No.";
        PurchaseLine.GET(PurchaseLine."Document Type"::Order,"Ref. Order No.","Ref. Line No.");
        TransferFromPurchaseLine(PurchaseLine);
      END;
    END;

    LOCAL PROCEDURE SetProdOrder@119(VAR ProdOrderLine@1002 : Record 5406;VAR InventoryProfile@1000 : Record 99000853);
    BEGIN
      WITH ReqLine DO BEGIN
        "Ref. Order Type" := "Ref. Order Type"::"Prod. Order";
        "Ref. Order Status" := InventoryProfile."Source Order Status";
        "Ref. Order No." := InventoryProfile."Source ID";
        "Ref. Line No." := InventoryProfile."Source Prod. Order Line";
        ProdOrderLine.GET("Ref. Order Status","Ref. Order No.","Ref. Line No.");
        TransferFromProdOrderLine(ProdOrderLine);
      END;
    END;

    LOCAL PROCEDURE SetAssembly@122(VAR AsmHeader@1001 : Record 900;VAR InventoryProfile@1000 : Record 99000853);
    BEGIN
      WITH ReqLine DO BEGIN
        "Ref. Order Type" := "Ref. Order Type"::Assembly;
        "Ref. Order No." := InventoryProfile."Source ID";
        "Ref. Line No." := 0;
        AsmHeader.GET(AsmHeader."Document Type"::Order,"Ref. Order No.");
        TransferFromAsmHeader(AsmHeader);
      END;
    END;

    LOCAL PROCEDURE SetTransfer@120(VAR TransLine@1000 : Record 5741;VAR InventoryProfile@1001 : Record 99000853);
    BEGIN
      WITH ReqLine DO BEGIN
        "Ref. Order Type" := "Ref. Order Type"::Transfer;
        "Ref. Order Status" := 0; // A Transfer Order has no status
        "Ref. Order No." := InventoryProfile."Source ID";
        "Ref. Line No." := InventoryProfile."Source Ref. No.";
        TransLine.GET("Ref. Order No.","Ref. Line No.");
        TransferFromTransLine(TransLine);
      END;
    END;

    LOCAL PROCEDURE SKURequiresLotAccumulation@131(VAR StockkeepingUnit@1000 : Record 5700) : Boolean;
    VAR
      BlankPeriod@1001 : DateFormula;
    BEGIN
      WITH StockkeepingUnit DO
        IF "Reordering Policy" = "Reordering Policy"::"Lot-for-Lot" THEN BEGIN
          EVALUATE(BlankPeriod,'');
          EXIT("Lot Accumulation Period" <> BlankPeriod);
        END;
      EXIT(FALSE);
    END;

    LOCAL PROCEDURE FromLotAccumulationPeriodStartDate@138(LotAccumulationPeriodStartDate@1000 : Date;DemandDueDate@1001 : Date) : Boolean;
    BEGIN
      IF LotAccumulationPeriodStartDate > 0D THEN
        EXIT(CALCDATE(TempSKU."Lot Accumulation Period",LotAccumulationPeriodStartDate) >= DemandDueDate);
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransToChildInvProfile@132(VAR ReservEntry@1000 : Record 337;VAR ChildInvtProfile@1001 : Record 99000853);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterDemandToInvProfile@1002(VAR InventoryProfile@1000 : Record 99000853;VAR Item@1001 : Record 27;VAR ReservEntry@1002 : Record 337;VAR NextLineNo@1003 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSupplyToInvProfile@1003(VAR InventoryProfile@1000 : Record 99000853;VAR Item@1001 : Record 27;VAR ToDate@1002 : Date;VAR ReservEntry@1003 : Record 337;VAR NextLineNo@1004 : Integer);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterSetOrderPriority@1005(VAR InventoryProfile@1000 : Record 99000853);
    BEGIN
    END;

    BEGIN
    END.
  }
}

