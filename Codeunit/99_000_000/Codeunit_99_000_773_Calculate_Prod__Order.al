OBJECT Codeunit 99000773 Calculate Prod. Order
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 27=r,
                TableData 5406=rimd,
                TableData 5407=rimd,
                TableData 99000765=r,
                TableData 99000772=rimd,
                TableData 99000776=rimd,
                TableData 5405=rimd,
                TableData 5416=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Fantomstyklistestruktur for %1 er mere end 50 niveauer.;ENU=BOM phantom structure for %1 is higher than 50 levels.';
      Text001@1001 : TextConst 'DAN=%1 %2 %3 kan ikke beregnes, hvis mindst �n %4 er blevet bogf�rt.;ENU=%1 %2 %3 can not be calculated, if at least one %4 has been posted.';
      Text002@1002 : TextConst 'DAN=Operation nr. %1 kan ikke komme efter en anden operation i ruten for denne produktionsordrelinje;ENU=Operation No. %1 cannot follow another operation in the routing of this Prod. Order Line';
      Text003@1003 : TextConst 'DAN=Operation nr. %1 kan ikke komme f�r en anden operation i ruten for denne produktionsordrelinje;ENU=Operation No. %1 cannot precede another operation in the routing of this Prod. Order Line';
      Item@1004 : Record 27;
      Location@1006 : Record 14;
      SKU@1005 : Record 5700;
      ProdOrder@1007 : Record 5405;
      ProdOrderLine@1008 : Record 5406;
      ProdOrderComp@1009 : Record 5407;
      ProdOrderRoutingLine2@1010 : Record 5409;
      ProdOrderBOMCompComment@1011 : Record 5416;
      ProdBOMLine@1012 : ARRAY [99] OF Record 99000772;
      UOMMgt@1014 : Codeunit 5402;
      CostCalcMgt@1015 : Codeunit 5836;
      VersionMgt@1016 : Codeunit 99000756;
      ProdOrderRouteMgt@1017 : Codeunit 99000772;
      GetPlanningParameters@1018 : Codeunit 99000855;
      LeadTimeMgt@1019 : Codeunit 5404;
      CalendarMgt@1023 : Codeunit 99000755;
      WMSManagement@1024 : Codeunit 7302;
      NextProdOrderCompLineNo@1020 : Integer;
      Blocked@1021 : Boolean;
      ProdOrderModify@1022 : Boolean;

    LOCAL PROCEDURE TransferRouting@5();
    VAR
      RoutingHeader@1000 : Record 99000763;
      RoutingLine@1001 : Record 99000764;
      ProdOrderRoutingLine@1002 : Record 5409;
      WorkCenter@1003 : Record 99000754;
      MachineCenter@1004 : Record 99000758;
    BEGIN
      IF ProdOrderLine."Routing No." = '' THEN
        EXIT;

      RoutingHeader.GET(ProdOrderLine."Routing No.");

      ProdOrderRoutingLine.SETRANGE(Status,ProdOrderLine.Status);
      ProdOrderRoutingLine.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
      ProdOrderRoutingLine.SETRANGE("Routing Reference No.",ProdOrderLine."Routing Reference No.");
      ProdOrderRoutingLine.SETRANGE("Routing No.",ProdOrderLine."Routing No.");
      IF NOT ProdOrderRoutingLine.ISEMPTY THEN
        EXIT;

      RoutingLine.SETRANGE("Routing No.",ProdOrderLine."Routing No.");
      RoutingLine.SETRANGE("Version Code",ProdOrderLine."Routing Version Code");
      IF RoutingLine.FIND('-') THEN
        REPEAT
          RoutingLine.TESTFIELD(Recalculate,FALSE);
          ProdOrderRoutingLine.INIT;
          ProdOrderRoutingLine.Status := ProdOrderLine.Status;
          ProdOrderRoutingLine."Prod. Order No." := ProdOrderLine."Prod. Order No.";
          ProdOrderRoutingLine."Routing Reference No." := ProdOrderLine."Routing Reference No.";
          ProdOrderRoutingLine."Routing No." := ProdOrderLine."Routing No.";
          ProdOrderRoutingLine."Operation No." := RoutingLine."Operation No.";
          ProdOrderRoutingLine."Next Operation No." := RoutingLine."Next Operation No.";
          ProdOrderRoutingLine."Previous Operation No." := RoutingLine."Previous Operation No.";
          ProdOrderRoutingLine.Type := RoutingLine.Type;
          ProdOrderRoutingLine."No." := RoutingLine."No.";
          ProdOrderRoutingLine.FillDefaultLocationAndBins;
          ProdOrderRoutingLine."Work Center No." := RoutingLine."Work Center No.";
          ProdOrderRoutingLine."Work Center Group Code" := RoutingLine."Work Center Group Code";
          ProdOrderRoutingLine.Description := RoutingLine.Description;
          ProdOrderRoutingLine."Setup Time" := RoutingLine."Setup Time";
          ProdOrderRoutingLine."Run Time" := RoutingLine."Run Time";
          ProdOrderRoutingLine."Wait Time" := RoutingLine."Wait Time";
          ProdOrderRoutingLine."Move Time" := RoutingLine."Move Time";
          ProdOrderRoutingLine."Fixed Scrap Quantity" := RoutingLine."Fixed Scrap Quantity";
          ProdOrderRoutingLine."Lot Size" := RoutingLine."Lot Size";
          ProdOrderRoutingLine."Scrap Factor %" := RoutingLine."Scrap Factor %";
          ProdOrderRoutingLine."Minimum Process Time" := RoutingLine."Minimum Process Time";
          ProdOrderRoutingLine."Maximum Process Time" := RoutingLine."Maximum Process Time";
          ProdOrderRoutingLine."Concurrent Capacities" := RoutingLine."Concurrent Capacities";
          IF ProdOrderRoutingLine."Concurrent Capacities" = 0 THEN
            ProdOrderRoutingLine."Concurrent Capacities" := 1;
          ProdOrderRoutingLine."Send-Ahead Quantity" := RoutingLine."Send-Ahead Quantity";
          ProdOrderRoutingLine."Setup Time Unit of Meas. Code" := RoutingLine."Setup Time Unit of Meas. Code";
          ProdOrderRoutingLine."Run Time Unit of Meas. Code" := RoutingLine."Run Time Unit of Meas. Code";
          ProdOrderRoutingLine."Wait Time Unit of Meas. Code" := RoutingLine."Wait Time Unit of Meas. Code";
          ProdOrderRoutingLine."Move Time Unit of Meas. Code" := RoutingLine."Move Time Unit of Meas. Code";
          ProdOrderRoutingLine."Routing Link Code" := RoutingLine."Routing Link Code";
          ProdOrderRoutingLine."Standard Task Code" := RoutingLine."Standard Task Code";
          ProdOrderRoutingLine."Sequence No. (Forward)" := RoutingLine."Sequence No. (Forward)";
          ProdOrderRoutingLine."Sequence No. (Backward)" := RoutingLine."Sequence No. (Backward)";
          ProdOrderRoutingLine."Fixed Scrap Qty. (Accum.)" := RoutingLine."Fixed Scrap Qty. (Accum.)";
          ProdOrderRoutingLine."Scrap Factor % (Accumulated)" := RoutingLine."Scrap Factor % (Accumulated)";
          ProdOrderRoutingLine."Unit Cost per" := RoutingLine."Unit Cost per";
          CASE ProdOrderRoutingLine.Type OF
            ProdOrderRoutingLine.Type::"Work Center":
              BEGIN
                WorkCenter.GET(RoutingLine."Work Center No.");
                ProdOrderRoutingLine."Flushing Method" := WorkCenter."Flushing Method";
              END;
            ProdOrderRoutingLine.Type::"Machine Center":
              BEGIN
                MachineCenter.GET(ProdOrderRoutingLine."No.");
                ProdOrderRoutingLine."Flushing Method" := MachineCenter."Flushing Method";
              END;
          END;
          CostCalcMgt.RoutingCostPerUnit(
            ProdOrderRoutingLine.Type,
            ProdOrderRoutingLine."No.",
            ProdOrderRoutingLine."Direct Unit Cost",
            ProdOrderRoutingLine."Indirect Cost %",
            ProdOrderRoutingLine."Overhead Rate",
            ProdOrderRoutingLine."Unit Cost per",
            ProdOrderRoutingLine."Unit Cost Calculation");
          ProdOrderRoutingLine.VALIDATE("Direct Unit Cost");
          ProdOrderRoutingLine."Starting Time" := ProdOrderLine."Starting Time";
          ProdOrderRoutingLine."Starting Date" := ProdOrderLine."Starting Date";
          ProdOrderRoutingLine."Ending Time" := ProdOrderLine."Ending Time";
          ProdOrderRoutingLine."Ending Date" := ProdOrderLine."Ending Date";
          ProdOrderRoutingLine.UpdateDatetime;
          OnAfterTransferRoutingLine(ProdOrderLine,RoutingLine,ProdOrderRoutingLine);
          ProdOrderRoutingLine.INSERT;
          TransferTaskInfo(ProdOrderRoutingLine,ProdOrderLine."Routing Version Code");
        UNTIL RoutingLine.NEXT = 0;

      OnAfterTransferRouting(ProdOrderLine);
    END;

    [External]
    PROCEDURE TransferTaskInfo@3(VAR FromProdOrderRoutingLine@1000 : Record 5409;VersionCode@1009 : Code[20]);
    VAR
      RoutingTool@1001 : Record 99000802;
      RoutingPersonnel@1002 : Record 99000803;
      RoutingQualityMeasure@1003 : Record 99000805;
      RoutingCommentLine@1004 : Record 99000775;
      ProdOrderRoutingTool@1005 : Record 5411;
      ProdOrderRoutingPersonnel@1006 : Record 5412;
      ProdOrderRtngQltyMeas@1007 : Record 5413;
      ProdOrderRtngCommentLine@1008 : Record 5415;
    BEGIN
      RoutingTool.SETRANGE("Routing No.",FromProdOrderRoutingLine."Routing No.");
      RoutingTool.SETRANGE("Operation No.",FromProdOrderRoutingLine."Operation No.");
      RoutingTool.SETRANGE("Version Code",VersionCode);
      IF RoutingTool.FIND('-') THEN
        REPEAT
          ProdOrderRoutingTool.TRANSFERFIELDS(RoutingTool);
          ProdOrderRoutingTool.Status := FromProdOrderRoutingLine.Status;
          ProdOrderRoutingTool."Prod. Order No." := FromProdOrderRoutingLine."Prod. Order No.";
          ProdOrderRoutingTool."Routing Reference No." := FromProdOrderRoutingLine."Routing Reference No.";
          ProdOrderRoutingTool.INSERT;
        UNTIL RoutingTool.NEXT = 0;

      RoutingPersonnel.SETRANGE("Routing No.",FromProdOrderRoutingLine."Routing No.");
      RoutingPersonnel.SETRANGE("Operation No.",FromProdOrderRoutingLine."Operation No.");
      RoutingPersonnel.SETRANGE("Version Code",VersionCode);
      IF RoutingPersonnel.FIND('-') THEN
        REPEAT
          ProdOrderRoutingPersonnel.TRANSFERFIELDS(RoutingPersonnel);
          ProdOrderRoutingPersonnel.Status := FromProdOrderRoutingLine.Status;
          ProdOrderRoutingPersonnel."Prod. Order No." := FromProdOrderRoutingLine."Prod. Order No.";
          ProdOrderRoutingPersonnel."Routing Reference No." := FromProdOrderRoutingLine."Routing Reference No.";
          ProdOrderRoutingPersonnel.INSERT;
        UNTIL RoutingPersonnel.NEXT = 0;

      RoutingQualityMeasure.SETRANGE("Routing No.",FromProdOrderRoutingLine."Routing No.");
      RoutingQualityMeasure.SETRANGE("Operation No.",FromProdOrderRoutingLine."Operation No.");
      RoutingQualityMeasure.SETRANGE("Version Code",VersionCode);
      IF RoutingQualityMeasure.FIND('-') THEN
        REPEAT
          ProdOrderRtngQltyMeas.TRANSFERFIELDS(RoutingQualityMeasure);
          ProdOrderRtngQltyMeas.Status := FromProdOrderRoutingLine.Status;
          ProdOrderRtngQltyMeas."Prod. Order No." := FromProdOrderRoutingLine."Prod. Order No.";
          ProdOrderRtngQltyMeas."Routing Reference No." := FromProdOrderRoutingLine."Routing Reference No.";
          ProdOrderRtngQltyMeas.INSERT;
        UNTIL RoutingQualityMeasure.NEXT = 0;

      RoutingCommentLine.SETRANGE("Routing No.",FromProdOrderRoutingLine."Routing No.");
      RoutingCommentLine.SETRANGE("Operation No.",FromProdOrderRoutingLine."Operation No.");
      RoutingCommentLine.SETRANGE("Version Code",VersionCode);
      IF RoutingCommentLine.FIND('-') THEN
        REPEAT
          ProdOrderRtngCommentLine.TRANSFERFIELDS(RoutingCommentLine);
          ProdOrderRtngCommentLine.Status := FromProdOrderRoutingLine.Status;
          ProdOrderRtngCommentLine."Prod. Order No." := FromProdOrderRoutingLine."Prod. Order No.";
          ProdOrderRtngCommentLine."Routing Reference No." := FromProdOrderRoutingLine."Routing Reference No.";
          ProdOrderRtngCommentLine.INSERT;
        UNTIL RoutingCommentLine.NEXT = 0;

      OnAfterTransferTaskInfo(FromProdOrderRoutingLine,VersionCode);
    END;

    LOCAL PROCEDURE TransferBOM@4(ProdBOMNo@1000 : Code[20];Level@1001 : Integer;LineQtyPerUOM@1002 : Decimal;ItemQtyPerUOM@1010 : Decimal) : Boolean;
    VAR
      BOMHeader@1003 : Record 99000771;
      ComponentSKU@1004 : Record 5700;
      Item2@1007 : Record 27;
      ProductionBOMVersion@1009 : Record 99000779;
      ProdBOMCommentLine@1011 : Record 99000776;
      ReqQty@1006 : Decimal;
      ErrorOccured@1005 : Boolean;
      VersionCode@1008 : Code[20];
    BEGIN
      IF ProdBOMNo = '' THEN
        EXIT;

      ProdOrderComp.LOCKTABLE;

      IF Level > 50 THEN
        ERROR(
          Text000,
          ProdBOMNo);

      BOMHeader.GET(ProdBOMNo);

      IF Level > 1 THEN
        VersionCode := VersionMgt.GetBOMVersion(ProdBOMNo,ProdOrderLine."Starting Date",TRUE)
      ELSE
        VersionCode := ProdOrderLine."Production BOM Version Code";

      IF VersionCode <> '' THEN BEGIN
        ProductionBOMVersion.GET(ProdBOMNo,VersionCode);
        ProductionBOMVersion.TESTFIELD(Status,ProductionBOMVersion.Status::Certified);
      END ELSE
        BOMHeader.TESTFIELD(Status,BOMHeader.Status::Certified);

      ProdBOMLine[Level].SETRANGE("Production BOM No.",ProdBOMNo);
      ProdBOMLine[Level].SETRANGE("Version Code",VersionCode);
      ProdBOMLine[Level].SETFILTER("Starting Date",'%1|..%2',0D,ProdOrderLine."Starting Date");
      ProdBOMLine[Level].SETFILTER("Ending Date",'%1|%2..',0D,ProdOrderLine."Starting Date");
      IF ProdBOMLine[Level].FIND('-') THEN
        REPEAT
          IF ProdBOMLine[Level]."Routing Link Code" <> '' THEN BEGIN
            ProdOrderRoutingLine2.SETRANGE(Status,ProdOrderLine.Status);
            ProdOrderRoutingLine2.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
            ProdOrderRoutingLine2.SETRANGE("Routing Link Code",ProdBOMLine[Level]."Routing Link Code");
            ProdOrderRoutingLine2.FINDFIRST;
            ReqQty :=
              ProdBOMLine[Level].Quantity *
              (1 + ProdBOMLine[Level]."Scrap %" / 100) *
              (1 + ProdOrderRoutingLine2."Scrap Factor % (Accumulated)") *
              LineQtyPerUOM / ItemQtyPerUOM +
              ProdOrderRoutingLine2."Fixed Scrap Qty. (Accum.)";
          END ELSE
            ReqQty :=
              ProdBOMLine[Level].Quantity *
              (1 + ProdBOMLine[Level]."Scrap %" / 100) *
              LineQtyPerUOM / ItemQtyPerUOM;

          CASE ProdBOMLine[Level].Type OF
            ProdBOMLine[Level].Type::Item:
              BEGIN
                IF ReqQty <> 0 THEN BEGIN
                  ProdOrderComp.SETCURRENTKEY(Status,"Prod. Order No.","Prod. Order Line No.","Item No.");
                  ProdOrderComp.SETRANGE(Status,ProdOrderLine.Status);
                  ProdOrderComp.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
                  ProdOrderComp.SETRANGE("Prod. Order Line No.",ProdOrderLine."Line No.");
                  ProdOrderComp.SETRANGE("Item No.",ProdBOMLine[Level]."No.");
                  ProdOrderComp.SETRANGE("Variant Code",ProdBOMLine[Level]."Variant Code");
                  ProdOrderComp.SETRANGE("Routing Link Code",ProdBOMLine[Level]."Routing Link Code");
                  ProdOrderComp.SETRANGE(Position,ProdBOMLine[Level].Position);
                  ProdOrderComp.SETRANGE("Position 2",ProdBOMLine[Level]."Position 2");
                  ProdOrderComp.SETRANGE("Position 3",ProdBOMLine[Level]."Position 3");
                  ProdOrderComp.SETRANGE(Length,ProdBOMLine[Level].Length);
                  ProdOrderComp.SETRANGE(Width,ProdBOMLine[Level].Width);
                  ProdOrderComp.SETRANGE(Weight,ProdBOMLine[Level].Weight);
                  ProdOrderComp.SETRANGE(Depth,ProdBOMLine[Level].Depth);
                  ProdOrderComp.SETRANGE("Unit of Measure Code",ProdBOMLine[Level]."Unit of Measure Code");
                  IF NOT ProdOrderComp.FINDFIRST THEN BEGIN
                    ProdOrderComp.RESET;
                    ProdOrderComp.SETRANGE(Status,ProdOrderLine.Status);
                    ProdOrderComp.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
                    ProdOrderComp.SETRANGE("Prod. Order Line No.",ProdOrderLine."Line No.");
                    IF ProdOrderComp.FINDLAST THEN
                      NextProdOrderCompLineNo := ProdOrderComp."Line No." + 10000
                    ELSE
                      NextProdOrderCompLineNo := 10000;
                    ProdOrderComp.INIT;
                    ProdOrderComp.SetIgnoreErrors;
                    ProdOrderComp.BlockDynamicTracking(Blocked);
                    ProdOrderComp.Status := ProdOrderLine.Status;
                    ProdOrderComp."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                    ProdOrderComp."Prod. Order Line No." := ProdOrderLine."Line No.";
                    ProdOrderComp."Line No." := NextProdOrderCompLineNo;
                    ProdOrderComp.VALIDATE("Item No.",ProdBOMLine[Level]."No.");
                    ProdOrderComp."Variant Code" := ProdBOMLine[Level]."Variant Code";
                    ProdOrderComp."Location Code" := SKU."Components at Location";
                    ProdOrderComp."Bin Code" := GetDefaultBin;
                    ProdOrderComp.Description := ProdBOMLine[Level].Description;
                    ProdOrderComp.VALIDATE("Unit of Measure Code",ProdBOMLine[Level]."Unit of Measure Code");
                    ProdOrderComp."Quantity per" := ProdBOMLine[Level]."Quantity per" * LineQtyPerUOM / ItemQtyPerUOM;
                    ProdOrderComp.Length := ProdBOMLine[Level].Length;
                    ProdOrderComp.Width := ProdBOMLine[Level].Width;
                    ProdOrderComp.Weight := ProdBOMLine[Level].Weight;
                    ProdOrderComp.Depth := ProdBOMLine[Level].Depth;
                    ProdOrderComp.Position := ProdBOMLine[Level].Position;
                    ProdOrderComp."Position 2" := ProdBOMLine[Level]."Position 2";
                    ProdOrderComp."Position 3" := ProdBOMLine[Level]."Position 3";
                    ProdOrderComp."Lead-Time Offset" := ProdBOMLine[Level]."Lead-Time Offset";
                    ProdOrderComp.VALIDATE("Routing Link Code",ProdBOMLine[Level]."Routing Link Code");
                    ProdOrderComp.VALIDATE("Scrap %",ProdBOMLine[Level]."Scrap %");
                    ProdOrderComp.VALIDATE("Calculation Formula",ProdBOMLine[Level]."Calculation Formula");

                    GetPlanningParameters.AtSKU(
                      ComponentSKU,ProdOrderComp."Item No.",
                      ProdOrderComp."Variant Code",
                      ProdOrderComp."Location Code");

                    ProdOrderComp."Flushing Method" := ComponentSKU."Flushing Method";
                    IF (SKU."Manufacturing Policy" = SKU."Manufacturing Policy"::"Make-to-Order") AND
                       (ComponentSKU."Manufacturing Policy" = ComponentSKU."Manufacturing Policy"::"Make-to-Order") AND
                       (ComponentSKU."Replenishment System" = ComponentSKU."Replenishment System"::"Prod. Order")
                    THEN BEGIN
                      ProdOrderComp."Planning Level Code" := ProdOrderLine."Planning Level Code" + 1;
                      Item2.GET(ProdOrderComp."Item No.");
                      ProdOrderComp."Item Low-Level Code" := Item2."Low-Level Code";
                    END;
                    ProdOrderComp.GetDefaultBin;
                    OnAfterTransferBOMComponent(ProdOrderLine,ProdBOMLine[Level],ProdOrderComp);
                    ProdOrderComp.INSERT(TRUE);
                  END ELSE BEGIN
                    ProdOrderComp.SetIgnoreErrors;
                    ProdOrderComp.SETCURRENTKEY(Status,"Prod. Order No."); // Reset key
                    ProdOrderComp.BlockDynamicTracking(Blocked);
                    ProdOrderComp.VALIDATE(
                      "Quantity per",
                      ProdOrderComp."Quantity per" + ProdBOMLine[Level]."Quantity per" * LineQtyPerUOM / ItemQtyPerUOM);
                    ProdOrderComp.VALIDATE("Routing Link Code",ProdBOMLine[Level]."Routing Link Code");
                    ProdOrderComp.MODIFY;
                  END;
                  IF ProdOrderComp.HasErrorOccured THEN
                    ErrorOccured := TRUE;
                  ProdOrderComp.AutoReserve;

                  ProdBOMCommentLine.SETRANGE("Production BOM No.",ProdBOMLine[Level]."Production BOM No.");
                  ProdBOMCommentLine.SETRANGE("BOM Line No.",ProdBOMLine[Level]."Line No.");
                  ProdBOMCommentLine.SETRANGE("Version Code",ProdBOMLine[Level]."Version Code");
                  IF ProdBOMCommentLine.FIND('-') THEN
                    REPEAT
                      ProdOrderBOMCompComment.TRANSFERFIELDS(ProdBOMCommentLine);
                      ProdOrderBOMCompComment.Status := ProdOrderComp.Status;
                      ProdOrderBOMCompComment."Prod. Order No." := ProdOrderComp."Prod. Order No.";
                      ProdOrderBOMCompComment."Prod. Order Line No." := ProdOrderComp."Prod. Order Line No.";
                      ProdOrderBOMCompComment."Prod. Order BOM Line No." := ProdOrderComp."Line No.";
                      IF NOT ProdOrderBOMCompComment.INSERT THEN
                        ProdOrderBOMCompComment.MODIFY;
                    UNTIL ProdBOMCommentLine.NEXT = 0;
                END;
              END;
            ProdBOMLine[Level].Type::"Production BOM":
              BEGIN
                TransferBOM(ProdBOMLine[Level]."No.",Level + 1,ReqQty,1);
                ProdBOMLine[Level].SETRANGE("Production BOM No.",ProdBOMNo);
                IF Level > 1 THEN
                  ProdBOMLine[Level].SETRANGE("Version Code",VersionMgt.GetBOMVersion(ProdBOMNo,ProdOrderLine."Starting Date",TRUE))
                ELSE
                  ProdBOMLine[Level].SETRANGE("Version Code",ProdOrderLine."Production BOM Version Code");
                ProdBOMLine[Level].SETFILTER("Starting Date",'%1|..%2',0D,ProdOrderLine."Starting Date");
                ProdBOMLine[Level].SETFILTER("Ending Date",'%1|%2..',0D,ProdOrderLine."Starting Date");
              END;
          END;
        UNTIL ProdBOMLine[Level].NEXT = 0;
      EXIT(NOT ErrorOccured);
    END;

    [External]
    PROCEDURE CalculateComponents@7();
    VAR
      ProdOrderComp@1000 : Record 5407;
    BEGIN
      ProdOrderComp.SETRANGE(Status,ProdOrderLine.Status);
      ProdOrderComp.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
      ProdOrderComp.SETRANGE("Prod. Order Line No.",ProdOrderLine."Line No.");
      IF ProdOrderComp.FIND('-') THEN
        REPEAT
          ProdOrderComp.BlockDynamicTracking(Blocked);
          ProdOrderComp.VALIDATE("Routing Link Code");
          ProdOrderComp.MODIFY;
          ProdOrderComp.AutoReserve;
        UNTIL ProdOrderComp.NEXT = 0;
    END;

    [External]
    PROCEDURE CalculateRoutingFromActual@11(ProdOrderRoutingLine@1000 : Record 5409;Direction@1001 : 'Forward,Backward';CalcStartEndDate@1002 : Boolean);
    VAR
      CalculateRoutingLine@1003 : Codeunit 99000774;
    BEGIN
      IF ProdOrderRouteMgt.NeedsCalculation(
           ProdOrderRoutingLine.Status,
           ProdOrderRoutingLine."Prod. Order No.",
           ProdOrderRoutingLine."Routing Reference No.",
           ProdOrderRoutingLine."Routing No.")
      THEN BEGIN
        ProdOrderLine.SETRANGE(Status,ProdOrderRoutingLine.Status);
        ProdOrderLine.SETRANGE("Prod. Order No.",ProdOrderRoutingLine."Prod. Order No.");
        ProdOrderLine.SETRANGE("Routing Reference No.",ProdOrderRoutingLine."Routing Reference No.");
        ProdOrderLine.SETRANGE("Routing No.",ProdOrderRoutingLine."Routing No.");
        ProdOrderLine.FINDFIRST;
        ProdOrderRouteMgt.Calculate(ProdOrderLine);
        ProdOrderRoutingLine.GET(
          ProdOrderRoutingLine.Status,
          ProdOrderRoutingLine."Prod. Order No.",
          ProdOrderRoutingLine."Routing Reference No.",
          ProdOrderRoutingLine."Routing No.",
          ProdOrderRoutingLine."Operation No.");
      END;
      IF Direction = Direction::Forward THEN
        ProdOrderRoutingLine.SETCURRENTKEY(Status,"Prod. Order No.","Routing Reference No.",
          "Routing No.","Sequence No. (Forward)")
      ELSE
        ProdOrderRoutingLine.SETCURRENTKEY(Status,"Prod. Order No.","Routing Reference No.",
          "Routing No.","Sequence No. (Backward)");

      ProdOrderRoutingLine.SETRANGE(Status,ProdOrderRoutingLine.Status);
      ProdOrderRoutingLine.SETRANGE("Prod. Order No.",ProdOrderRoutingLine."Prod. Order No.");
      ProdOrderRoutingLine.SETRANGE("Routing Reference No.",ProdOrderRoutingLine."Routing Reference No.");
      ProdOrderRoutingLine.SETRANGE("Routing No.",ProdOrderRoutingLine."Routing No.");
      ProdOrderRoutingLine.SETFILTER("Routing Status",'<>%1',ProdOrderRoutingLine."Routing Status"::Finished);
      REPEAT
        IF CalcStartEndDate AND NOT ProdOrderRoutingLine."Schedule Manually" THEN BEGIN
          IF ((Direction = Direction::Forward) AND (ProdOrderRoutingLine."Previous Operation No." <> '')) OR
             ((Direction = Direction::Backward) AND (ProdOrderRoutingLine."Next Operation No." <> ''))
          THEN BEGIN
            ProdOrderRoutingLine."Starting Time" := 0T;
            ProdOrderRoutingLine."Starting Date" := 0D;
            ProdOrderRoutingLine."Ending Time" := 235959T;
            ProdOrderRoutingLine."Ending Date" := CalendarMgt.GetMaxDate;
          END;
        END;
        CalculateRoutingLine.CalculateRoutingLine(ProdOrderRoutingLine,Direction,CalcStartEndDate);
        CalcStartEndDate := TRUE;
      UNTIL ProdOrderRoutingLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CalculateRouting@6(Direction@1000 : 'Forward,Backward';LetDueDateDecrease@1003 : Boolean);
    VAR
      ProdOrderRoutingLine@1001 : Record 5409;
      LeadTime@1002 : Code[20];
    BEGIN
      IF ProdOrderRouteMgt.NeedsCalculation(
           ProdOrderLine.Status,
           ProdOrderLine."Prod. Order No.",
           ProdOrderLine."Routing Reference No.",
           ProdOrderLine."Routing No.")
      THEN
        ProdOrderRouteMgt.Calculate(ProdOrderLine);

      IF Direction = Direction::Forward THEN
        ProdOrderRoutingLine.SETCURRENTKEY(Status,"Prod. Order No.","Routing Reference No.","Routing No.",
          "Sequence No. (Forward)")
      ELSE
        ProdOrderRoutingLine.SETCURRENTKEY(Status,"Prod. Order No.","Routing Reference No.","Routing No.",
          "Sequence No. (Backward)");

      ProdOrderRoutingLine.SETRANGE(Status,ProdOrderLine.Status);
      ProdOrderRoutingLine.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
      ProdOrderRoutingLine.SETRANGE("Routing Reference No.",ProdOrderLine."Routing Reference No.");
      ProdOrderRoutingLine.SETRANGE("Routing No.",ProdOrderLine."Routing No.");
      ProdOrderRoutingLine.SETFILTER("Routing Status",'<>%1',ProdOrderRoutingLine."Routing Status"::Finished);
      IF NOT ProdOrderRoutingLine.FINDFIRST THEN BEGIN
        LeadTime :=
          LeadTimeMgt.ManufacturingLeadTime(
            ProdOrderLine."Item No.",
            ProdOrderLine."Location Code",
            ProdOrderLine."Variant Code");
        IF Direction = Direction::Forward THEN
          // Ending Date calculated forward from Starting Date
          ProdOrderLine."Ending Date" :=
            LeadTimeMgt.PlannedEndingDate2(
              ProdOrderLine."Item No.",
              ProdOrderLine."Location Code",
              ProdOrderLine."Variant Code",
              '',
              LeadTime,
              2,
              ProdOrderLine."Starting Date")
        ELSE
          // Starting Date calculated backward from Ending Date
          ProdOrderLine."Starting Date" :=
            LeadTimeMgt.PlannedStartingDate(
              ProdOrderLine."Item No.",
              ProdOrderLine."Location Code",
              ProdOrderLine."Variant Code",
              '',
              LeadTime,
              2,
              ProdOrderLine."Ending Date");

        CalculateProdOrderDates(ProdOrderLine,LetDueDateDecrease);
        EXIT;
      END;

      IF Direction = Direction::Forward THEN BEGIN
        ProdOrderRoutingLine."Starting Date" := ProdOrderLine."Starting Date";
        ProdOrderRoutingLine."Starting Time" := ProdOrderLine."Starting Time";
      END ELSE BEGIN
        ProdOrderRoutingLine."Ending Date" := ProdOrderLine."Ending Date";
        ProdOrderRoutingLine."Ending Time" := ProdOrderLine."Ending Time";
      END;
      ProdOrderRoutingLine.UpdateDatetime;
      CalculateRoutingFromActual(ProdOrderRoutingLine,Direction,FALSE);

      CalculateProdOrderDates(ProdOrderLine,LetDueDateDecrease);
    END;

    [External]
    PROCEDURE CalculateProdOrderDates@12(VAR ProdOrderLine@1000 : Record 5406;LetDueDateDecrease@1003 : Boolean);
    VAR
      ProdOrderLine2@1001 : Record 5406;
      ProdOrderRoutingLine@1002 : Record 5409;
      NewDueDate@1004 : Date;
    BEGIN
      ProdOrder.GET(ProdOrderLine.Status,ProdOrderLine."Prod. Order No.");

      ProdOrderRoutingLine.SETRANGE(Status,ProdOrderLine.Status);
      ProdOrderRoutingLine.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
      ProdOrderRoutingLine.SETRANGE("Routing No.",ProdOrderLine."Routing No.");
      IF ProdOrder."Source Type" <> ProdOrder."Source Type"::Family THEN
        ProdOrderRoutingLine.SETRANGE("Routing Reference No.",ProdOrderLine."Line No.")
      ELSE
        ProdOrderRoutingLine.SETRANGE("Routing Reference No.",0);
      ProdOrderRoutingLine.SETFILTER("Routing Status",'<>%1',ProdOrderRoutingLine."Routing Status"::Finished);
      ProdOrderRoutingLine.SETFILTER("Next Operation No.",'%1','');

      IF ProdOrderRoutingLine.FINDFIRST THEN BEGIN
        ProdOrderLine."Ending Date" := ProdOrderRoutingLine."Ending Date";
        ProdOrderLine."Ending Time" := ProdOrderRoutingLine."Ending Time";
      END;

      ProdOrderRoutingLine.SETRANGE("Next Operation No.");
      ProdOrderRoutingLine.SETFILTER("Previous Operation No.",'%1','');

      IF ProdOrderRoutingLine.FINDFIRST THEN BEGIN
        ProdOrderLine."Starting Date" := ProdOrderRoutingLine."Starting Date";
        ProdOrderLine."Starting Time" := ProdOrderRoutingLine."Starting Time";
      END;

      IF ProdOrderLine."Planning Level Code" = 0 THEN
        NewDueDate :=
          LeadTimeMgt.PlannedDueDate(
            ProdOrderLine."Item No.",
            ProdOrderLine."Location Code",
            ProdOrderLine."Variant Code",
            ProdOrderLine."Ending Date",
            '',
            2)
      ELSE
        NewDueDate := ProdOrderLine."Ending Date";

      IF LetDueDateDecrease OR (NewDueDate > ProdOrderLine."Due Date") THEN
        ProdOrderLine."Due Date" := NewDueDate;

      ProdOrderLine.UpdateDatetime;

      ProdOrderLine.MODIFY;

      ProdOrder."Due Date" := 0D;
      ProdOrder."Ending Date" := 0D;
      ProdOrder."Ending Time" := 0T;
      ProdOrder."Starting Date" := CalendarMgt.GetMaxDate;
      ProdOrder."Starting Time" := 235959T;

      ProdOrderLine2.SETRANGE(Status,ProdOrderLine.Status);
      ProdOrderLine2.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
      IF ProdOrderLine2.FIND('-') THEN
        REPEAT
          IF (ProdOrderLine2."Ending Date" > ProdOrder."Ending Date") OR
             ((ProdOrderLine2."Ending Date" = ProdOrder."Ending Date") AND
              (ProdOrderLine2."Ending Time" > ProdOrder."Ending Time"))
          THEN BEGIN
            ProdOrder."Ending Date" := ProdOrderLine2."Ending Date";
            ProdOrder."Ending Time" := ProdOrderLine2."Ending Time";
          END;
          IF (ProdOrderLine2."Starting Date" < ProdOrder."Starting Date") OR
             ((ProdOrderLine2."Starting Date" = ProdOrder."Starting Date") AND
              (ProdOrderLine2."Starting Time" < ProdOrder."Starting Time"))
          THEN BEGIN
            ProdOrder."Starting Date" := ProdOrderLine2."Starting Date";
            ProdOrder."Starting Time" := ProdOrderLine2."Starting Time";
          END;

          IF ProdOrderLine2."Due Date" > ProdOrder."Due Date" THEN
            ProdOrder."Due Date" := ProdOrderLine2."Due Date";
        UNTIL ProdOrderLine2.NEXT = 0;

      ProdOrder.UpdateDatetime;

      IF NOT ProdOrderModify THEN
        ProdOrder.MODIFY;
    END;

    [Internal]
    PROCEDURE Calculate@1(ProdOrderLine2@1000 : Record 5406;Direction@1001 : 'Forward,Backward';CalcRouting@1002 : Boolean;CalcComponents@1003 : Boolean;DeleteRelations@1004 : Boolean;LetDueDateDecrease@1012 : Boolean) : Boolean;
    VAR
      CapLedgEntry@1005 : Record 5832;
      ItemLedgEntry@1009 : Record 32;
      ProdOrderRoutingLine3@1006 : Record 5409;
      ProdOrderRoutingLine4@1007 : Record 5409;
      RoutingHeader@1008 : Record 99000763;
      ProdOrderRoutingLine@1010 : Record 5409;
      ErrorOccured@1011 : Boolean;
    BEGIN
      ProdOrderLine := ProdOrderLine2;

      IF ProdOrderLine.Status = ProdOrderLine.Status::Released THEN BEGIN
        ItemLedgEntry.SETCURRENTKEY("Order Type","Order No.");
        ItemLedgEntry.SETRANGE("Order Type",ItemLedgEntry."Order Type"::Production);
        ItemLedgEntry.SETRANGE("Order No.",ProdOrderLine."Prod. Order No.");
        IF NOT ItemLedgEntry.ISEMPTY THEN
          ERROR(
            Text001,
            ProdOrderLine.Status,ProdOrderLine.TABLECAPTION,ProdOrderLine."Prod. Order No.",
            ItemLedgEntry.TABLECAPTION);

        CapLedgEntry.SETCURRENTKEY("Order Type","Order No.");
        CapLedgEntry.SETRANGE("Order Type",CapLedgEntry."Order Type"::Production);
        CapLedgEntry.SETRANGE("Order No.",ProdOrderLine."Prod. Order No.");
        IF NOT CapLedgEntry.ISEMPTY THEN
          ERROR(
            Text001,
            ProdOrderLine.Status,ProdOrderLine.TABLECAPTION,ProdOrderLine."Prod. Order No.",
            CapLedgEntry.TABLECAPTION);
      END;

      ProdOrderLine.TESTFIELD(Quantity);
      IF Direction = Direction::Backward THEN
        ProdOrderLine.TESTFIELD("Ending Date")
      ELSE
        ProdOrderLine.TESTFIELD("Starting Date");

      IF DeleteRelations THEN
        ProdOrderLine.DeleteRelations;

      IF CalcRouting THEN BEGIN
        TransferRouting;
        IF NOT CalcComponents THEN BEGIN // components will not be calculated later- update bin code
          ProdOrderRoutingLine.SETRANGE(Status,ProdOrderLine.Status);
          ProdOrderRoutingLine.SETRANGE("Prod. Order No.",ProdOrderLine."Prod. Order No.");
          ProdOrderRoutingLine.SETRANGE("Routing Reference No.",ProdOrderLine."Routing Reference No.");
          ProdOrderRoutingLine.SETRANGE("Routing No.",ProdOrderLine."Routing No.");
          IF NOT ProdOrderRouteMgt.UpdateComponentsBin(ProdOrderRoutingLine,TRUE) THEN
            ErrorOccured := TRUE;
        END;
      END ELSE BEGIN
        IF RoutingHeader.GET(ProdOrderLine2."Routing No.") OR (ProdOrderLine2."Routing No." = '') THEN
          IF RoutingHeader.Type <> RoutingHeader.Type::Parallel THEN BEGIN
            ProdOrderRoutingLine3.SETRANGE(Status,ProdOrderLine2.Status);
            ProdOrderRoutingLine3.SETRANGE("Prod. Order No.",ProdOrderLine2."Prod. Order No.");
            ProdOrderRoutingLine3.SETRANGE("Routing Reference No.",ProdOrderLine2."Routing Reference No.");
            ProdOrderRoutingLine3.SETRANGE("Routing No.",ProdOrderLine2."Routing No.");
            ProdOrderRoutingLine3.SETFILTER("Routing Status",'<>%1',ProdOrderRoutingLine3."Routing Status"::Finished);
            ProdOrderRoutingLine4.COPYFILTERS(ProdOrderRoutingLine3);
            IF ProdOrderRoutingLine3.FIND('-') THEN
              REPEAT
                IF ProdOrderRoutingLine3."Next Operation No." <> '' THEN BEGIN
                  ProdOrderRoutingLine4.SETRANGE("Operation No.",ProdOrderRoutingLine3."Next Operation No.");
                  IF ProdOrderRoutingLine4.ISEMPTY THEN
                    ERROR(
                      Text002,
                      ProdOrderRoutingLine3."Next Operation No.");
                END;
                IF ProdOrderRoutingLine3."Previous Operation No." <> '' THEN BEGIN
                  ProdOrderRoutingLine4.SETRANGE("Operation No.",ProdOrderRoutingLine3."Previous Operation No.");
                  IF ProdOrderRoutingLine4.ISEMPTY THEN
                    ERROR(
                      Text003,
                      ProdOrderRoutingLine3."Previous Operation No.");
                END;
              UNTIL ProdOrderRoutingLine3.NEXT = 0;
          END;
      END;

      IF CalcComponents THEN BEGIN
        IF ProdOrderLine."Production BOM No." <> '' THEN BEGIN
          Item.GET(ProdOrderLine."Item No.");
          GetPlanningParameters.AtSKU(
            SKU,
            ProdOrderLine."Item No.",
            ProdOrderLine."Variant Code",
            ProdOrderLine."Location Code");

          IF NOT TransferBOM(
               ProdOrderLine."Production BOM No.",
               1,
               ProdOrderLine."Qty. per Unit of Measure",
               UOMMgt.GetQtyPerUnitOfMeasure(
                 Item,
                 VersionMgt.GetBOMUnitOfMeasure(
                   ProdOrderLine."Production BOM No.",
                   ProdOrderLine."Production BOM Version Code")))
          THEN
            ErrorOccured := TRUE;
        END;
      END;
      Recalculate(ProdOrderLine,Direction,LetDueDateDecrease);
      EXIT(NOT ErrorOccured);
    END;

    [External]
    PROCEDURE Recalculate@2(VAR ProdOrderLine2@1000 : Record 5406;Direction@1001 : 'Forward,Backward';LetDueDateDecrease@1002 : Boolean);
    BEGIN
      ProdOrderLine := ProdOrderLine2;
      ProdOrderLine.BlockDynamicTracking(Blocked);

      CalculateRouting(Direction,LetDueDateDecrease);
      CalculateComponents;
      ProdOrderLine2 := ProdOrderLine;
    END;

    [External]
    PROCEDURE BlockDynamicTracking@17(SetBlock@1000 : Boolean);
    BEGIN
      Blocked := SetBlock;
    END;

    [External]
    PROCEDURE SetParameter@8(NewProdOrderModify@1000 : Boolean);
    BEGIN
      ProdOrderModify := NewProdOrderModify;
    END;

    LOCAL PROCEDURE GetDefaultBin@9() BinCode : Code[20];
    VAR
      WMSMgt@1000 : Codeunit 7302;
    BEGIN
      WITH ProdOrderComp DO
        IF "Location Code" <> '' THEN BEGIN
          IF Location.Code <> "Location Code" THEN
            Location.GET("Location Code");
          IF Location."Bin Mandatory" AND (NOT Location."Directed Put-away and Pick") THEN
            WMSMgt.GetDefaultBin("Item No.","Variant Code","Location Code",BinCode);
        END;
    END;

    [External]
    PROCEDURE SetProdOrderLineBinCodeFromRoute@35(VAR ProdOrderLine@1000 : Record 5406;ParentLocationCode@1001 : Code[10];RoutingNo@1003 : Code[20]);
    VAR
      RouteBinCode@1005 : Code[20];
    BEGIN
      RouteBinCode :=
        WMSManagement.GetLastOperationFromBinCode(
          RoutingNo,
          ProdOrderLine."Routing Version Code",
          ProdOrderLine."Location Code",
          FALSE,
          0);
      SetProdOrderLineBinCode(ProdOrderLine,RouteBinCode,ParentLocationCode);
    END;

    [External]
    PROCEDURE SetProdOrderLineBinCodeFromProdRtngLines@10(VAR ProdOrderLine@1000 : Record 5406);
    VAR
      ProdOrderRoutingLineBinCode@1005 : Code[20];
    BEGIN
      IF ProdOrderLine."Planning Level Code" > 0 THEN
        EXIT;

      ProdOrderRoutingLineBinCode :=
        WMSManagement.GetProdRtngLastOperationFromBinCode(
          ProdOrderLine.Status,
          ProdOrderLine."Prod. Order No.",
          ProdOrderLine."Line No.",
          ProdOrderLine."Routing No.",
          ProdOrderLine."Location Code");
      SetProdOrderLineBinCode(ProdOrderLine,ProdOrderRoutingLineBinCode,ProdOrderLine."Location Code");
    END;

    [External]
    PROCEDURE SetProdOrderLineBinCodeFromPlanningRtngLines@19(VAR ProdOrderLine@1000 : Record 5406;ReqLine@1003 : Record 246);
    VAR
      PlanningLinesBinCode@1005 : Code[20];
    BEGIN
      IF ProdOrderLine."Planning Level Code" > 0 THEN
        EXIT;

      PlanningLinesBinCode :=
        WMSManagement.GetPlanningRtngLastOperationFromBinCode(
          ReqLine."Worksheet Template Name",
          ReqLine."Journal Batch Name",
          ReqLine."Line No.",
          ReqLine."Location Code");
      SetProdOrderLineBinCode(ProdOrderLine,PlanningLinesBinCode,ReqLine."Location Code");
    END;

    LOCAL PROCEDURE SetProdOrderLineBinCode@20(VAR ProdOrderLine@1001 : Record 5406;ParentBinCode@1000 : Code[20];ParentLocationCode@1003 : Code[10]);
    VAR
      Location@1002 : Record 14;
      FromProdBinCode@1004 : Code[20];
    BEGIN
      IF ParentBinCode <> '' THEN
        ProdOrderLine.VALIDATE("Bin Code",ParentBinCode)
      ELSE
        IF ProdOrderLine."Bin Code" = '' THEN BEGIN
          IF Location.GET(ParentLocationCode) THEN
            FromProdBinCode := Location."From-Production Bin Code";
          IF FromProdBinCode <> '' THEN
            ProdOrderLine.VALIDATE("Bin Code",FromProdBinCode)
          ELSE
            IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
              IF WMSManagement.GetDefaultBin(ProdOrderLine."Item No.",ProdOrderLine."Variant Code",Location.Code,FromProdBinCode) THEN
                ProdOrderLine.VALIDATE("Bin Code",FromProdBinCode);
        END;
    END;

    [External]
    PROCEDURE FindAndSetProdOrderLineBinCodeFromProdRtngLines@13(ProdOrderStatus@1002 : Option;ProdOrderNo@1001 : Code[20];ProdOrderLineNo@1000 : Integer);
    BEGIN
      IF ProdOrderLine.GET(ProdOrderStatus,ProdOrderNo,ProdOrderLineNo) THEN BEGIN
        SetProdOrderLineBinCodeFromProdRtngLines(ProdOrderLine);
        ProdOrderLine.MODIFY;
      END;
    END;

    [External]
    PROCEDURE AssignProdOrderLineBinCodeFromProdRtngLineMachineCenter@14(VAR ProdOrderRoutingLine@1001 : Record 5409);
    VAR
      MachineCenter@1000 : Record 99000758;
    BEGIN
      MachineCenter.SETRANGE("Work Center No.",ProdOrderRoutingLine."Work Center No.");
      IF PAGE.RUNMODAL(PAGE::"Machine Center List",MachineCenter) = ACTION::LookupOK THEN
        IF (ProdOrderRoutingLine."No." <> MachineCenter."No.") OR
           (ProdOrderRoutingLine.Type = ProdOrderRoutingLine.Type::"Work Center")
        THEN BEGIN
          ProdOrderRoutingLine.Type := ProdOrderRoutingLine.Type::"Machine Center";
          ProdOrderRoutingLine.VALIDATE("No.",MachineCenter."No.");
          FindAndSetProdOrderLineBinCodeFromProdRtngLines(
            ProdOrderRoutingLine.Status,ProdOrderRoutingLine."Prod. Order No.",ProdOrderRoutingLine."Routing Reference No.");
        END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferTaskInfo@15(VAR ProdOrderRoutingLine@1000 : Record 5409;VersionCode@1001 : Code[20]);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferRouting@18(VAR ProdOrderLine@1000 : Record 5406);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferRoutingLine@22(VAR ProdOrderLine@1000 : Record 5406;VAR RoutingLine@1001 : Record 99000764;VAR ProdOrderRoutingLine@1002 : Record 5409);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferBOMComponent@21(VAR ProdOrderLine@1000 : Record 5406;VAR ProductionBOMLine@1001 : Record 99000772;VAR ProdOrderComponent@1002 : Record 5407);
    BEGIN
    END;

    BEGIN
    END.
  }
}

