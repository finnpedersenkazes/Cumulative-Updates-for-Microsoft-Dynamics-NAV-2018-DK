OBJECT Codeunit 99000809 Planning Line Management
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Permissions=TableData 99000765=rm,
                TableData 99000772=r,
                TableData 5410=rd,
                TableData 99000829=rimd,
                TableData 99000830=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Fantomstyklistestruktur for %1 er mere end 50 niveauer.;ENU=BOM phantom structure for %1 is higher than 50 levels.';
      Text002@1002 : TextConst 'DAN=Der er ikke plads til at inds�tte underliggende Fremstil-til-ordre-linjer.;ENU=There is not enough space to insert lower level Make-to-Order lines.';
      Item@1003 : Record 27;
      SKU@1004 : Record 5700;
      ReqLine@1005 : Record 246;
      ProdBOMLine@1006 : ARRAY [50] OF Record 99000772;
      AsmBOMComp@1026 : ARRAY [50] OF Record 90;
      PlanningRtngLine2@1007 : Record 99000830;
      PlanningComponent@1008 : Record 99000829;
      TempPlanningComponent@1010 : TEMPORARY Record 99000829;
      TempPlanningErrorLog@1001 : TEMPORARY Record 5430;
      CalcPlanningRtngLine@1020 : Codeunit 99000810;
      UOMMgt@1011 : Codeunit 5402;
      CostCalcMgt@1012 : Codeunit 5836;
      PlanningRoutingMgt@1013 : Codeunit 99000808;
      VersionMgt@1014 : Codeunit 99000756;
      GetPlanningParameters@1015 : Codeunit 99000855;
      LeadTimeMgt@1016 : Codeunit 5404;
      CalendarMgt@1027 : Codeunit 99000755;
      LineSpacing@1018 : ARRAY [50] OF Integer;
      NextPlanningCompLineNo@1025 : Integer;
      Blocked@1019 : Boolean;
      PlanningResiliency@1017 : Boolean;
      Text010@1021 : TextConst 'DAN=Linjen med %1 %2 for %3 %4 eller en af de tilh�rende versioner har ikke defineret %5.;ENU=The line with %1 %2 for %3 %4 or one of its versions, has no %5 defined.';
      Text011@1022 : TextConst 'DAN=Genberegning for %1 er angivet til falsk.;ENU=%1 has recalculate set to false.';
      Text012@1009 : TextConst 'DAN=Du skal angive %1 i %2 %3.;ENU=You must specify %1 in %2 %3.';
      Text014@1023 : TextConst 'DAN=Produktionsstyklistehoved nr. %1, der bruges af vare %2, har styklisteniveauer, som overstiger 50.;ENU=Production BOM Header No. %1 used by Item %2 has BOM levels that exceed 50.';
      Text015@1024 : TextConst 'DAN=Der er ikke mere plads til at inds�tte endnu en linje i regnearket.;ENU=There is no more space to insert another line in the worksheet.';

    LOCAL PROCEDURE TransferRouting@3();
    VAR
      RtngHeader@1003 : Record 99000763;
      RtngLine@1000 : Record 99000764;
      PlanningRtngLine@1001 : Record 99000830;
      MachCenter@1002 : Record 99000758;
    BEGIN
      IF ReqLine."Routing No." = '' THEN
        EXIT;

      RtngHeader.GET(ReqLine."Routing No.");
      RtngLine.SETRANGE("Routing No.",ReqLine."Routing No.");
      RtngLine.SETRANGE("Version Code",ReqLine."Routing Version Code");
      IF RtngLine.FIND('-') THEN
        REPEAT
          IF PlanningResiliency AND PlanningRtngLine.Recalculate THEN
            TempPlanningErrorLog.SetError(
              STRSUBSTNO(Text011,PlanningRtngLine.TABLECAPTION),
              DATABASE::"Routing Header",RtngHeader.GETPOSITION);
          PlanningRtngLine.TESTFIELD(Recalculate,FALSE);

          PlanningRtngLine."Worksheet Template Name" := ReqLine."Worksheet Template Name";
          PlanningRtngLine."Worksheet Batch Name" := ReqLine."Journal Batch Name";
          PlanningRtngLine."Worksheet Line No." := ReqLine."Line No.";
          PlanningRtngLine."Operation No." := RtngLine."Operation No.";
          PlanningRtngLine."Next Operation No." := RtngLine."Next Operation No.";
          PlanningRtngLine."Previous Operation No." := RtngLine."Previous Operation No.";
          PlanningRtngLine.Type := RtngLine.Type;
          PlanningRtngLine."No." := RtngLine."No.";
          IF PlanningResiliency AND (RtngLine."No." = '') THEN BEGIN
            RtngHeader.GET(RtngLine."Routing No.");
            TempPlanningErrorLog.SetError(
              STRSUBSTNO(
                Text010,
                RtngLine.FIELDCAPTION("Operation No."),RtngLine."Operation No.",
                RtngHeader.TABLECAPTION,RtngHeader."No.",
                RtngLine.FIELDCAPTION("No.")),
              DATABASE::"Routing Header",RtngHeader.GETPOSITION);
          END;
          RtngLine.TESTFIELD("No.");

          IF PlanningResiliency AND (RtngLine."Work Center No." = '') THEN BEGIN
            MachCenter.GET(RtngLine."No.");
            TempPlanningErrorLog.SetError(
              STRSUBSTNO(
                Text012,
                MachCenter.FIELDCAPTION("Work Center No."),
                MachCenter.TABLECAPTION,
                MachCenter."No."),
              DATABASE::"Machine Center",MachCenter.GETPOSITION);
          END;
          RtngLine.TESTFIELD("Work Center No.");

          PlanningRtngLine."Work Center No." := RtngLine."Work Center No.";
          PlanningRtngLine."Work Center Group Code" := RtngLine."Work Center Group Code";
          PlanningRtngLine.Description := RtngLine.Description;
          PlanningRtngLine."Setup Time" := RtngLine."Setup Time";
          PlanningRtngLine."Run Time" := RtngLine."Run Time";
          PlanningRtngLine."Wait Time" := RtngLine."Wait Time";
          PlanningRtngLine."Move Time" := RtngLine."Move Time";
          PlanningRtngLine."Fixed Scrap Quantity" := RtngLine."Fixed Scrap Quantity";
          PlanningRtngLine."Lot Size" := RtngLine."Lot Size";
          PlanningRtngLine."Scrap Factor %" := RtngLine."Scrap Factor %";
          PlanningRtngLine."Setup Time Unit of Meas. Code" := RtngLine."Setup Time Unit of Meas. Code";
          PlanningRtngLine."Run Time Unit of Meas. Code" := RtngLine."Run Time Unit of Meas. Code";
          PlanningRtngLine."Wait Time Unit of Meas. Code" := RtngLine."Wait Time Unit of Meas. Code";
          PlanningRtngLine."Move Time Unit of Meas. Code" := RtngLine."Move Time Unit of Meas. Code";
          PlanningRtngLine."Minimum Process Time" := RtngLine."Minimum Process Time";
          PlanningRtngLine."Maximum Process Time" := RtngLine."Maximum Process Time";
          PlanningRtngLine."Concurrent Capacities" := RtngLine."Concurrent Capacities";
          IF PlanningRtngLine."Concurrent Capacities" = 0 THEN
            PlanningRtngLine."Concurrent Capacities" := 1;

          PlanningRtngLine."Send-Ahead Quantity" := RtngLine."Send-Ahead Quantity";
          PlanningRtngLine."Routing Link Code" := RtngLine."Routing Link Code";
          PlanningRtngLine."Standard Task Code" := RtngLine."Standard Task Code";
          PlanningRtngLine."Unit Cost per" := RtngLine."Unit Cost per";
          CostCalcMgt.RoutingCostPerUnit(
            PlanningRtngLine.Type,
            PlanningRtngLine."No.",
            PlanningRtngLine."Direct Unit Cost",
            PlanningRtngLine."Indirect Cost %",
            PlanningRtngLine."Overhead Rate",
            PlanningRtngLine."Unit Cost per",
            PlanningRtngLine."Unit Cost Calculation");
          PlanningRtngLine.VALIDATE("Direct Unit Cost");
          PlanningRtngLine."Sequence No.(Forward)" := RtngLine."Sequence No. (Forward)";
          PlanningRtngLine."Sequence No.(Backward)" := RtngLine."Sequence No. (Backward)";
          PlanningRtngLine."Fixed Scrap Qty. (Accum.)" := RtngLine."Fixed Scrap Qty. (Accum.)";
          PlanningRtngLine."Scrap Factor % (Accumulated)" := RtngLine."Scrap Factor % (Accumulated)";
          PlanningRtngLine."Output Quantity" := ReqLine.Quantity;
          PlanningRtngLine."Starting Date" := ReqLine."Starting Date";
          PlanningRtngLine."Starting Time" := ReqLine."Starting Time";
          PlanningRtngLine."Ending Date" := ReqLine."Ending Date";
          PlanningRtngLine."Ending Time" := ReqLine."Ending Time";
          PlanningRtngLine."Input Quantity" := ReqLine.Quantity;
          PlanningRtngLine.UpdateDatetime;
          OnAfterTransferRtngLine(ReqLine,RtngLine,PlanningRtngLine);
          PlanningRtngLine.INSERT;
        UNTIL RtngLine.NEXT = 0;
    END;

    LOCAL PROCEDURE TransferBOM@4(ProdBOMNo@1000 : Code[20];Level@1001 : Integer;LineQtyPerUOM@1002 : Decimal;ItemQtyPerUOM@1010 : Decimal);
    VAR
      BOMHeader@1003 : Record 99000771;
      CompSKU@1004 : Record 5700;
      Item2@1006 : Record 27;
      ReqQty@1007 : Decimal;
    BEGIN
      IF ReqLine."Production BOM No." = '' THEN
        EXIT;

      PlanningComponent.LOCKTABLE;

      IF Level > 50 THEN BEGIN
        IF PlanningResiliency THEN BEGIN
          BOMHeader.GET(ReqLine."Production BOM No.");
          TempPlanningErrorLog.SetError(
            STRSUBSTNO(Text014,ReqLine."Production BOM No.",ReqLine."No."),
            DATABASE::"Production BOM Header",BOMHeader.GETPOSITION);
        END;
        ERROR(
          Text000,
          ProdBOMNo);
      END;

      IF NextPlanningCompLineNo = 0 THEN BEGIN
        PlanningComponent.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
        PlanningComponent.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
        PlanningComponent.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
        IF PlanningComponent.FIND('+') THEN
          NextPlanningCompLineNo := PlanningComponent."Line No.";
        PlanningComponent.RESET;
      END;

      BOMHeader.GET(ProdBOMNo);

      ProdBOMLine[Level].SETRANGE("Production BOM No.",ProdBOMNo);
      IF Level > 1 THEN
        ProdBOMLine[Level].SETRANGE("Version Code",VersionMgt.GetBOMVersion(BOMHeader."No.",ReqLine."Starting Date",TRUE))
      ELSE
        ProdBOMLine[Level].SETRANGE("Version Code",ReqLine."Production BOM Version Code");

      ProdBOMLine[Level].SETFILTER("Starting Date",'%1|..%2',0D,ReqLine."Starting Date");
      ProdBOMLine[Level].SETFILTER("Ending Date",'%1|%2..',0D,ReqLine."Starting Date");
      IF ProdBOMLine[Level].FIND('-') THEN
        REPEAT
          IF ProdBOMLine[Level]."Routing Link Code" <> '' THEN BEGIN
            PlanningRtngLine2.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
            PlanningRtngLine2.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
            PlanningRtngLine2.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
            PlanningRtngLine2.SETRANGE("Routing Link Code",ProdBOMLine[Level]."Routing Link Code");
            PlanningRtngLine2.FINDFIRST;
            ReqQty :=
              ProdBOMLine[Level].Quantity *
              (1 + ProdBOMLine[Level]."Scrap %" / 100) *
              (1 + PlanningRtngLine2."Scrap Factor % (Accumulated)") *
              (1 + ReqLine."Scrap %" / 100) *
              LineQtyPerUOM /
              ItemQtyPerUOM +
              PlanningRtngLine2."Fixed Scrap Qty. (Accum.)";
          END ELSE
            ReqQty :=
              ProdBOMLine[Level].Quantity *
              (1 + ProdBOMLine[Level]."Scrap %" / 100) *
              (1 + ReqLine."Scrap %" / 100) *
              LineQtyPerUOM /
              ItemQtyPerUOM;
          CASE ProdBOMLine[Level].Type OF
            ProdBOMLine[Level].Type::Item:
              BEGIN
                IF ReqQty <> 0 THEN BEGIN
                  IF NOT IsPlannedComp(PlanningComponent,ReqLine,ProdBOMLine[Level]) THEN BEGIN
                    NextPlanningCompLineNo := NextPlanningCompLineNo + 10000;

                    PlanningComponent.RESET;
                    PlanningComponent.INIT;
                    PlanningComponent.BlockDynamicTracking(Blocked);
                    PlanningComponent."Worksheet Template Name" := ReqLine."Worksheet Template Name";
                    PlanningComponent."Worksheet Batch Name" := ReqLine."Journal Batch Name";
                    PlanningComponent."Worksheet Line No." := ReqLine."Line No.";
                    PlanningComponent."Line No." := NextPlanningCompLineNo;
                    PlanningComponent.VALIDATE("Item No.",ProdBOMLine[Level]."No.");
                    PlanningComponent."Variant Code" := ProdBOMLine[Level]."Variant Code";
                    PlanningComponent."Location Code" := SKU."Components at Location";
                    PlanningComponent.Description := ProdBOMLine[Level].Description;
                    PlanningComponent."Planning Line Origin" := ReqLine."Planning Line Origin";
                    PlanningComponent.VALIDATE("Unit of Measure Code",ProdBOMLine[Level]."Unit of Measure Code");
                    PlanningComponent."Quantity per" := ProdBOMLine[Level]."Quantity per" * LineQtyPerUOM / ItemQtyPerUOM;
                    PlanningComponent.VALIDATE("Routing Link Code",ProdBOMLine[Level]."Routing Link Code");
                    OnTransferBOMOnBeforeGetDefaultBin(PlanningComponent,ProdBOMLine[Level]);
                    PlanningComponent.GetDefaultBin;
                    PlanningComponent.Length := ProdBOMLine[Level].Length;
                    PlanningComponent.Width := ProdBOMLine[Level].Width;
                    PlanningComponent.Weight := ProdBOMLine[Level].Weight;
                    PlanningComponent.Depth := ProdBOMLine[Level].Depth;
                    PlanningComponent.Quantity := ProdBOMLine[Level].Quantity;
                    PlanningComponent.Position := ProdBOMLine[Level].Position;
                    PlanningComponent."Position 2" := ProdBOMLine[Level]."Position 2";
                    PlanningComponent."Position 3" := ProdBOMLine[Level]."Position 3";
                    PlanningComponent."Lead-Time Offset" := ProdBOMLine[Level]."Lead-Time Offset";
                    PlanningComponent.VALIDATE("Scrap %",ProdBOMLine[Level]."Scrap %");
                    PlanningComponent.VALIDATE("Calculation Formula",ProdBOMLine[Level]."Calculation Formula");

                    GetPlanningParameters.AtSKU(
                      CompSKU,
                      PlanningComponent."Item No.",
                      PlanningComponent."Variant Code",
                      PlanningComponent."Location Code");
                    IF Item2.GET(PlanningComponent."Item No.") THEN
                      PlanningComponent.Critical := Item2.Critical;

                    PlanningComponent."Flushing Method" := CompSKU."Flushing Method";
                    IF (SKU."Manufacturing Policy" = SKU."Manufacturing Policy"::"Make-to-Order") AND
                       (CompSKU."Manufacturing Policy" = CompSKU."Manufacturing Policy"::"Make-to-Order") AND
                       (CompSKU."Replenishment System" = CompSKU."Replenishment System"::"Prod. Order")
                    THEN
                      PlanningComponent."Planning Level Code" := ReqLine."Planning Level" + 1;

                    PlanningComponent."Ref. Order Type" := ReqLine."Ref. Order Type";
                    PlanningComponent."Ref. Order Status" := ReqLine."Ref. Order Status";
                    PlanningComponent."Ref. Order No." := ReqLine."Ref. Order No.";
                    OnBeforeInsertPlanningComponent(ReqLine,ProdBOMLine[Level],PlanningComponent);
                    PlanningComponent.INSERT;
                  END ELSE BEGIN
                    PlanningComponent.RESET;
                    PlanningComponent.BlockDynamicTracking(Blocked);
                    PlanningComponent.VALIDATE(
                      "Quantity per",
                      PlanningComponent."Quantity per" + ProdBOMLine[Level]."Quantity per" * LineQtyPerUOM / ItemQtyPerUOM);
                    PlanningComponent.VALIDATE("Routing Link Code",ProdBOMLine[Level]."Routing Link Code");
                    OnBeforeModifyPlanningComponent(ReqLine,ProdBOMLine[Level],PlanningComponent);
                    PlanningComponent.MODIFY;
                  END;

                  // A temporary list of Planning Components handled is sustained:
                  TempPlanningComponent := PlanningComponent;
                  IF NOT TempPlanningComponent.INSERT THEN
                    TempPlanningComponent.MODIFY;
                END;
              END;
            ProdBOMLine[Level].Type::"Production BOM":
              BEGIN
                TransferBOM(ProdBOMLine[Level]."No.",Level + 1,ReqQty,1);
                ProdBOMLine[Level].SETRANGE("Production BOM No.",ProdBOMNo);
                ProdBOMLine[Level].SETRANGE(
                  "Version Code",VersionMgt.GetBOMVersion(ProdBOMNo,ReqLine."Starting Date",TRUE));
                ProdBOMLine[Level].SETFILTER("Starting Date",'%1|..%2',0D,ReqLine."Starting Date");
                ProdBOMLine[Level].SETFILTER("Ending Date",'%1|%2..',0D,ReqLine."Starting Date");
              END;
          END;
        UNTIL ProdBOMLine[Level].NEXT = 0;
    END;

    LOCAL PROCEDURE TransferAsmBOM@13(ParentItemNo@1000 : Code[20];Level@1001 : Integer;Quantity@1002 : Decimal);
    VAR
      ParentItem@1003 : Record 27;
      CompSKU@1004 : Record 5700;
      Item2@1006 : Record 27;
      ReqQty@1007 : Decimal;
    BEGIN
      PlanningComponent.LOCKTABLE;

      IF Level > 50 THEN BEGIN
        IF PlanningResiliency THEN BEGIN
          Item.GET(ReqLine."No.");
          TempPlanningErrorLog.SetError(
            STRSUBSTNO(Text014,ReqLine."No.",ReqLine."No."),
            DATABASE::Item,Item.GETPOSITION);
        END;
        ERROR(
          Text000,
          ParentItemNo);
      END;

      IF NextPlanningCompLineNo = 0 THEN BEGIN
        PlanningComponent.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
        PlanningComponent.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
        PlanningComponent.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
        IF PlanningComponent.FIND('+') THEN
          NextPlanningCompLineNo := PlanningComponent."Line No.";
        PlanningComponent.RESET;
      END;

      ParentItem.GET(ParentItemNo);

      AsmBOMComp[Level].SETRANGE("Parent Item No.",ParentItemNo);
      IF AsmBOMComp[Level].FIND('-') THEN
        REPEAT
          ReqQty := Quantity * AsmBOMComp[Level]."Quantity per";
          CASE AsmBOMComp[Level].Type OF
            AsmBOMComp[Level].Type::Item:
              BEGIN
                IF ReqQty <> 0 THEN BEGIN
                  IF NOT IsPlannedAsmComp(PlanningComponent,ReqLine,AsmBOMComp[Level]) THEN BEGIN
                    NextPlanningCompLineNo := NextPlanningCompLineNo + 10000;

                    PlanningComponent.RESET;
                    PlanningComponent.INIT;
                    PlanningComponent.BlockDynamicTracking(Blocked);
                    PlanningComponent."Worksheet Template Name" := ReqLine."Worksheet Template Name";
                    PlanningComponent."Worksheet Batch Name" := ReqLine."Journal Batch Name";
                    PlanningComponent."Worksheet Line No." := ReqLine."Line No.";
                    PlanningComponent."Line No." := NextPlanningCompLineNo;
                    PlanningComponent.VALIDATE("Item No.",AsmBOMComp[Level]."No.");
                    PlanningComponent."Variant Code" := AsmBOMComp[Level]."Variant Code";
                    PlanningComponent."Location Code" := SKU."Components at Location";
                    PlanningComponent.Description := COPYSTR(AsmBOMComp[Level].Description,1,MAXSTRLEN(PlanningComponent.Description));
                    PlanningComponent."Planning Line Origin" := ReqLine."Planning Line Origin";
                    PlanningComponent.VALIDATE("Unit of Measure Code",AsmBOMComp[Level]."Unit of Measure Code");
                    PlanningComponent."Quantity per" := Quantity * AsmBOMComp[Level]."Quantity per";
                    PlanningComponent.GetDefaultBin;
                    PlanningComponent.Quantity := AsmBOMComp[Level]."Quantity per";
                    PlanningComponent.Position := AsmBOMComp[Level].Position;
                    PlanningComponent."Position 2" := AsmBOMComp[Level]."Position 2";
                    PlanningComponent."Position 3" := AsmBOMComp[Level]."Position 3";
                    PlanningComponent."Lead-Time Offset" := AsmBOMComp[Level]."Lead-Time Offset";
                    PlanningComponent.VALIDATE("Routing Link Code");
                    PlanningComponent.VALIDATE("Scrap %",0);
                    PlanningComponent.VALIDATE("Calculation Formula",PlanningComponent."Calculation Formula"::" ");

                    GetPlanningParameters.AtSKU(
                      CompSKU,
                      PlanningComponent."Item No.",
                      PlanningComponent."Variant Code",
                      PlanningComponent."Location Code");
                    IF Item2.GET(PlanningComponent."Item No.") THEN
                      PlanningComponent.Critical := Item2.Critical;

                    PlanningComponent."Flushing Method" := CompSKU."Flushing Method";
                    PlanningComponent."Ref. Order Type" := ReqLine."Ref. Order Type";
                    PlanningComponent."Ref. Order Status" := ReqLine."Ref. Order Status";
                    PlanningComponent."Ref. Order No." := ReqLine."Ref. Order No.";
                    OnBeforeInsertAsmPlanningComponent(ReqLine,AsmBOMComp[Level],PlanningComponent);
                    PlanningComponent.INSERT;
                  END ELSE BEGIN
                    PlanningComponent.RESET;
                    PlanningComponent.BlockDynamicTracking(Blocked);
                    PlanningComponent.VALIDATE(
                      "Quantity per",
                      PlanningComponent."Quantity per" +
                      Quantity *
                      AsmBOMComp[Level]."Quantity per");
                    PlanningComponent.VALIDATE("Routing Link Code",'');
                    PlanningComponent.MODIFY;
                  END;

                  // A temporary list of Planning Components handled is sustained:
                  TempPlanningComponent := PlanningComponent;
                  IF NOT TempPlanningComponent.INSERT THEN
                    TempPlanningComponent.MODIFY;
                END;
              END;
          END;
        UNTIL AsmBOMComp[Level].NEXT = 0;
    END;

    LOCAL PROCEDURE CalculateComponents@6();
    VAR
      PlanningAssignment@1000 : Record 99000850;
    BEGIN
      PlanningComponent.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningComponent.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningComponent.SETRANGE("Worksheet Line No.",ReqLine."Line No.");

      IF PlanningComponent.FIND('-') THEN
        REPEAT
          PlanningComponent.BlockDynamicTracking(Blocked);
          PlanningComponent.VALIDATE("Routing Link Code");
          PlanningComponent.MODIFY;
          WITH PlanningComponent DO
            PlanningAssignment.ChkAssignOne("Item No.","Variant Code","Location Code","Due Date");
        UNTIL PlanningComponent.NEXT = 0;
    END;

    [External]
    PROCEDURE CalculateRoutingFromActual@11(PlanningRtngLine@1000 : Record 99000830;Direction@1001 : 'Forward,Backward';CalcStartEndDate@1002 : Boolean);
    BEGIN
      IF (ReqLine."Worksheet Template Name" <> PlanningRtngLine."Worksheet Template Name") OR
         (ReqLine."Journal Batch Name" <> PlanningRtngLine."Worksheet Batch Name") OR
         (ReqLine."Line No." <> PlanningRtngLine."Worksheet Line No.")
      THEN
        ReqLine.GET(
          PlanningRtngLine."Worksheet Template Name",
          PlanningRtngLine."Worksheet Batch Name",PlanningRtngLine."Worksheet Line No.");

      IF  PlanningRoutingMgt.NeedsCalculation(
           PlanningRtngLine."Worksheet Template Name",
           PlanningRtngLine."Worksheet Batch Name",
           PlanningRtngLine."Worksheet Line No.")
      THEN BEGIN
        PlanningRoutingMgt.Calculate(ReqLine);
        PlanningRtngLine.GET(
          PlanningRtngLine."Worksheet Template Name",
          PlanningRtngLine."Worksheet Batch Name",
          PlanningRtngLine."Worksheet Line No.",PlanningRtngLine."Operation No.");
      END;
      IF Direction = Direction::Forward THEN
        PlanningRtngLine.SETCURRENTKEY(
          "Worksheet Template Name",
          "Worksheet Batch Name",
          "Worksheet Line No.",
          "Sequence No.(Forward)")
      ELSE
        PlanningRtngLine.SETCURRENTKEY(
          "Worksheet Template Name",
          "Worksheet Batch Name",
          "Worksheet Line No.",
          "Sequence No.(Backward)");

      PlanningRtngLine.SETRANGE("Worksheet Template Name",PlanningRtngLine."Worksheet Template Name");
      PlanningRtngLine.SETRANGE("Worksheet Batch Name",PlanningRtngLine."Worksheet Batch Name");
      PlanningRtngLine.SETRANGE("Worksheet Line No.",PlanningRtngLine."Worksheet Line No.");

      REPEAT
        IF CalcStartEndDate THEN BEGIN
          IF ((Direction = Direction::Forward) AND (PlanningRtngLine."Previous Operation No." <> '')) OR
             ((Direction = Direction::Backward) AND (PlanningRtngLine."Next Operation No." <> ''))
          THEN BEGIN
            PlanningRtngLine."Starting Time" := 0T;
            PlanningRtngLine."Starting Date" := 0D;
            PlanningRtngLine."Ending Time" := 235959T;
            PlanningRtngLine."Ending Date" := CalendarMgt.GetMaxDate;
          END;
        END;
        CLEAR(CalcPlanningRtngLine);
        IF PlanningResiliency THEN
          CalcPlanningRtngLine.SetResiliencyOn(
            ReqLine."Worksheet Template Name",ReqLine."Journal Batch Name",ReqLine."No.");
        CalcPlanningRtngLine.CalculateRouteLine(PlanningRtngLine,Direction,CalcStartEndDate,ReqLine);
        CalcStartEndDate := TRUE;
      UNTIL PlanningRtngLine.NEXT = 0;
    END;

    LOCAL PROCEDURE CalculateRouting@7(Direction@1000 : 'Forward,Backward');
    VAR
      PlanningRtngLine@1001 : Record 99000830;
    BEGIN
      IF PlanningRoutingMgt.NeedsCalculation(
           ReqLine."Worksheet Template Name",
           ReqLine."Journal Batch Name",
           ReqLine."Line No.")
      THEN
        PlanningRoutingMgt.Calculate(ReqLine);

      IF Direction = Direction::Forward THEN
        PlanningRtngLine.SETCURRENTKEY(
          "Worksheet Template Name",
          "Worksheet Batch Name",
          "Worksheet Line No.",
          "Sequence No.(Forward)")
      ELSE
        PlanningRtngLine.SETCURRENTKEY(
          "Worksheet Template Name",
          "Worksheet Batch Name",
          "Worksheet Line No.",
          "Sequence No.(Backward)");

      PlanningRtngLine.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      PlanningRtngLine.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
      PlanningRtngLine.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
      IF NOT PlanningRtngLine.FINDFIRST THEN BEGIN
        IF Direction = Direction::Forward THEN
          ReqLine.CalcEndingDate('')
        ELSE
          ReqLine.CalcStartingDate('');
        ReqLine.UpdateDatetime;
        EXIT;
      END;

      IF Direction = Direction::Forward THEN BEGIN
        PlanningRtngLine."Starting Date" := ReqLine."Starting Date";
        PlanningRtngLine."Starting Time" := ReqLine."Starting Time";
      END ELSE BEGIN
        PlanningRtngLine."Ending Date" := ReqLine."Ending Date";
        PlanningRtngLine."Ending Time" := ReqLine."Ending Time";
      END;
      CalculateRoutingFromActual(PlanningRtngLine,Direction,FALSE);

      CalculatePlanningLineDates(ReqLine);
    END;

    [External]
    PROCEDURE CalculatePlanningLineDates@12(VAR ReqLine2@1000 : Record 246);
    VAR
      PlanningRtngLine@1001 : Record 99000830;
      IsLineModified@1002 : Boolean;
    BEGIN
      PlanningRtngLine.SETRANGE("Worksheet Template Name",ReqLine2."Worksheet Template Name");
      PlanningRtngLine.SETRANGE("Worksheet Batch Name",ReqLine2."Journal Batch Name");
      PlanningRtngLine.SETRANGE("Worksheet Line No.",ReqLine2."Line No.");
      PlanningRtngLine.SETFILTER("Next Operation No.",'%1','');

      IF PlanningRtngLine.FINDFIRST THEN BEGIN
        ReqLine2."Ending Date" := PlanningRtngLine."Ending Date";
        ReqLine2."Ending Time" := PlanningRtngLine."Ending Time";
        IsLineModified := TRUE;
      END;

      PlanningRtngLine.SETRANGE("Next Operation No.");
      PlanningRtngLine.SETFILTER("Previous Operation No.",'%1','');
      IF PlanningRtngLine.FINDFIRST THEN BEGIN
        ReqLine2."Starting Date" := PlanningRtngLine."Starting Date";
        ReqLine2."Starting Time" := PlanningRtngLine."Starting Time";
        ReqLine2."Order Date" := PlanningRtngLine."Starting Date";
        IsLineModified := TRUE;
      END;

      IF IsLineModified THEN BEGIN
        ReqLine2.UpdateDatetime;
        ReqLine2.MODIFY;
      END;
    END;

    PROCEDURE Calculate@8(VAR ReqLine2@1000 : Record 246;Direction@1001 : 'Forward,Backward';CalcRouting@1002 : Boolean;CalcComponents@1003 : Boolean;PlanningLevel@1004 : Integer);
    VAR
      PlanningRtngLine@1005 : Record 99000830;
      ProdOrderCapNeed@1006 : Record 5410;
    BEGIN
      ReqLine := ReqLine2;
      IF ReqLine."Action Message" <> ReqLine."Action Message"::Cancel THEN
        ReqLine.TESTFIELD(Quantity);
      IF Direction = Direction::Backward THEN
        ReqLine.TESTFIELD("Ending Date")
      ELSE
        ReqLine.TESTFIELD("Starting Date");

      IF CalcRouting THEN BEGIN
        PlanningRtngLine.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
        PlanningRtngLine.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
        PlanningRtngLine.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
        PlanningRtngLine.DELETEALL;

        ProdOrderCapNeed.SETCURRENTKEY(
          "Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.");
        ProdOrderCapNeed.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
        ProdOrderCapNeed.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
        ProdOrderCapNeed.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
        ProdOrderCapNeed.DELETEALL;
        TransferRouting;
      END;

      IF CalcComponents THEN BEGIN
        PlanningComponent.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
        PlanningComponent.SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
        PlanningComponent.SETRANGE("Worksheet Line No.",ReqLine."Line No.");
        IF PlanningComponent.FIND('-') THEN
          REPEAT
            PlanningComponent.BlockDynamicTracking(Blocked);
            PlanningComponent.DELETE(TRUE);
          UNTIL PlanningComponent.NEXT = 0;
        IF ReqLine."Planning Level" = 0 THEN
          ReqLine.DeleteMultiLevel;
        IF (ReqLine."Replenishment System" = ReqLine."Replenishment System"::Assembly) OR
           ((ReqLine."Replenishment System" = ReqLine."Replenishment System"::"Prod. Order") AND (ReqLine."Production BOM No." <> ''))
        THEN BEGIN
          Item.GET(ReqLine."No.");
          GetPlanningParameters.AtSKU(
            SKU,
            ReqLine."No.",
            ReqLine."Variant Code",
            ReqLine."Location Code");

          IF ReqLine."Replenishment System" = ReqLine."Replenishment System"::Assembly THEN
            TransferAsmBOM(
              Item."No.",
              1,
              ReqLine."Qty. per Unit of Measure")
          ELSE
            TransferBOM(
              ReqLine."Production BOM No.",
              1,
              ReqLine."Qty. per Unit of Measure",
              UOMMgt.GetQtyPerUnitOfMeasure(
                Item,
                VersionMgt.GetBOMUnitOfMeasure(ReqLine."Production BOM No.",ReqLine."Production BOM Version Code")));
        END;
      END;
      Recalculate(ReqLine,Direction);
      ReqLine2 := ReqLine;
      IF CalcComponents AND
         (SKU."Manufacturing Policy" = SKU."Manufacturing Policy"::"Make-to-Order")
      THEN
        CheckMultiLevelStructure(ReqLine,CalcRouting,CalcComponents,PlanningLevel);
    END;

    [External]
    PROCEDURE Recalculate@9(VAR ReqLine2@1000 : Record 246;Direction@1001 : 'Forward,Backward');
    BEGIN
      RecalculateWithOptionalModify(ReqLine2,Direction,TRUE);
    END;

    [External]
    PROCEDURE RecalculateWithOptionalModify@15(VAR ReqLine2@1000 : Record 246;Direction@1001 : 'Forward,Backward';ModifyRec@1002 : Boolean);
    BEGIN
      ReqLine := ReqLine2;

      CalculateRouting(Direction);
      IF ModifyRec THEN
        ReqLine.MODIFY(TRUE);
      CalculateComponents;
      IF ReqLine."Planning Level" > 0 THEN BEGIN
        IF Direction = Direction::Forward THEN
          ReqLine."Due Date" := ReqLine."Ending Date"
      END ELSE
        IF (ReqLine."Due Date" < ReqLine."Ending Date") OR
           (Direction = Direction::Forward)
        THEN
          ReqLine."Due Date" :=
            LeadTimeMgt.PlannedDueDate(
              ReqLine."No.",
              ReqLine."Location Code",
              ReqLine."Variant Code",
              ReqLine."Ending Date",
              ReqLine."Vendor No.",
              ReqLine."Ref. Order Type");
      ReqLine.UpdateDatetime;
      ReqLine2 := ReqLine;
    END;

    LOCAL PROCEDURE CheckMultiLevelStructure@1(ReqLine2@1000 : Record 246;CalcRouting@1001 : Boolean;CalcComponents@1002 : Boolean;PlanningLevel@1003 : Integer);
    VAR
      ReqLine3@1004 : Record 246;
      Item3@1005 : Record 27;
      PlanningComp@1006 : Record 99000829;
      PlngComponentReserve@1009 : Codeunit 99000840;
      PlanningLineNo@1008 : Integer;
      NoOfComponents@1011 : Integer;
    BEGIN
      IF PlanningLevel < 0 THEN
        EXIT;

      IF NOT Item3.GET(ReqLine2."No.") THEN
        EXIT;
      IF Item3."Manufacturing Policy" <> Item3."Manufacturing Policy"::"Make-to-Order" THEN
        EXIT;

      PlanningLineNo := ReqLine2."Line No.";

      PlanningComp.SETRANGE("Worksheet Line No.",ReqLine2."Line No.");
      PlanningComp.SETFILTER("Item No.",'<>%1','');
      PlanningComp.SETFILTER("Expected Quantity",'<>0');
      PlanningComp.SETFILTER("Planning Level Code",'>0');
      NoOfComponents := PlanningComp.COUNT;
      IF PlanningLevel = 0 THEN BEGIN
        ReqLine3.RESET;
        ReqLine3.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
        ReqLine3.SETRANGE("Journal Batch Name",ReqLine."Journal Batch Name");
        ReqLine3 := ReqLine2;
        IF ReqLine3.FIND('>') THEN
          LineSpacing[1] := (ReqLine3."Line No." - ReqLine."Line No.") DIV (1 + NoOfComponents)
        ELSE
          LineSpacing[1] := 10000;
      END ELSE
        IF (PlanningLevel > 0) AND (PlanningLevel < 50) THEN
          LineSpacing[PlanningLevel + 1] := LineSpacing[PlanningLevel] DIV (1 + NoOfComponents);

      IF PlanningComp.FIND('-') THEN
        REPEAT
          IF LineSpacing[PlanningLevel + 1] = 0 THEN BEGIN
            IF PlanningResiliency THEN
              TempPlanningErrorLog.SetError(Text015,DATABASE::"Requisition Line",ReqLine.GETPOSITION);
            ERROR(Text002);
          END;
          ReqLine3.INIT;
          ReqLine3.BlockDynamicTracking(Blocked);
          ReqLine3."Worksheet Template Name" := ReqLine2."Worksheet Template Name";
          ReqLine3."Journal Batch Name" := ReqLine2."Journal Batch Name";
          PlanningLineNo := PlanningLineNo + LineSpacing[PlanningLevel + 1];
          ReqLine3."Line No." := PlanningLineNo;
          ReqLine3."Ref. Order Type" := ReqLine2."Ref. Order Type";
          ReqLine3."Ref. Order Status" := ReqLine2."Ref. Order Status";
          ReqLine3."Ref. Order No." := ReqLine2."Ref. Order No.";

          ReqLine3."Planning Line Origin" := ReqLine2."Planning Line Origin";
          ReqLine3.Level := ReqLine2.Level;
          ReqLine3."Demand Type" := ReqLine2."Demand Type";
          ReqLine3."Demand Subtype" := ReqLine2."Demand Subtype";
          ReqLine3."Demand Order No." := ReqLine2."Demand Order No.";
          ReqLine3."Demand Line No." := ReqLine2."Demand Line No.";
          ReqLine3."Demand Ref. No." := ReqLine2."Demand Ref. No.";
          ReqLine3."Demand Ref. No." := ReqLine2."Demand Ref. No.";
          ReqLine3."Demand Date" := ReqLine2."Demand Date";
          ReqLine3.Status := ReqLine2.Status;
          ReqLine3."User ID" := ReqLine2."User ID";

          ReqLine3.Type := ReqLine3.Type::Item;
          ReqLine3.VALIDATE("No.",PlanningComp."Item No.");
          ReqLine3."Action Message" := ReqLine2."Action Message";
          ReqLine3."Accept Action Message" := ReqLine2."Accept Action Message";
          ReqLine3.Description := PlanningComp.Description;
          ReqLine3."Variant Code" := PlanningComp."Variant Code";
          ReqLine3."Unit of Measure Code" := PlanningComp."Unit of Measure Code";
          ReqLine3."Location Code" := PlanningComp."Location Code";
          ReqLine3."Bin Code" := PlanningComp."Bin Code";
          ReqLine3."Ending Date" := PlanningComp."Due Date";
          ReqLine3.VALIDATE("Ending Time",PlanningComp."Due Time");
          ReqLine3."Due Date" := PlanningComp."Due Date";
          ReqLine3."Demand Date" := PlanningComp."Due Date";
          ReqLine3.VALIDATE(Quantity,PlanningComp."Expected Quantity");
          ReqLine3.VALIDATE("Needed Quantity",PlanningComp."Expected Quantity");
          ReqLine3.VALIDATE("Demand Quantity",PlanningComp."Expected Quantity");
          ReqLine3."Demand Qty. Available" := 0;

          ReqLine3."Planning Level" := PlanningLevel + 1;
          ReqLine3."Related to Planning Line" := ReqLine2."Line No.";
          ReqLine3."Order Promising ID" := ReqLine2."Order Promising ID";
          ReqLine3."Order Promising Line ID" := ReqLine2."Order Promising Line ID";
          OnCheckMultiLevelStructureOnBeforeInsertPlanningLine(ReqLine3,PlanningComp);
          InsertPlanningLine(ReqLine3);
          ReqLine3.Quantity :=
            ROUND(
              ReqLine3."Quantity (Base)" /
              ReqLine3."Qty. per Unit of Measure",0.00001);
          ReqLine3."Net Quantity (Base)" :=
            (ReqLine3.Quantity -
             ReqLine3."Original Quantity") *
            ReqLine3."Qty. per Unit of Measure";
          ReqLine3.MODIFY;
          PlngComponentReserve.BindToRequisition(
            PlanningComp,ReqLine3,PlanningComp."Expected Quantity",PlanningComp."Expected Quantity (Base)");
          PlanningComp."Supplied-by Line No." := ReqLine3."Line No.";
          PlanningComp.MODIFY;
          ReqLine3.VALIDATE("Production BOM No.");
          ReqLine3.VALIDATE("Routing No.");
          ReqLine3.MODIFY;
          Calculate(ReqLine3,1,CalcRouting,CalcComponents,PlanningLevel + 1);
          ReqLine3.MODIFY;
        UNTIL PlanningComp.NEXT = 0;
    END;

    LOCAL PROCEDURE InsertPlanningLine@2(VAR ReqLine@1000 : Record 246);
    VAR
      ReqLine2@1001 : Record 246;
    BEGIN
      ReqLine2 := ReqLine;
      ReqLine2.SETCURRENTKEY("Worksheet Template Name","Journal Batch Name",Type,"No.");
      ReqLine2.SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
      ReqLine2.SETRANGE("Journal Batch Name",ReqLine."Journal Batch Name");
      ReqLine2.SETRANGE(Type,ReqLine.Type::Item);
      ReqLine2.SETRANGE("No.",ReqLine."No.");
      ReqLine2.SETRANGE("Variant Code",ReqLine."Variant Code");
      ReqLine2.SETRANGE("Ref. Order Type",ReqLine."Ref. Order Type");
      ReqLine2.SETRANGE("Ref. Order Status",ReqLine."Ref. Order Status");
      ReqLine2.SETRANGE("Ref. Order No.",ReqLine."Ref. Order No.");
      ReqLine2.SETFILTER("Planning Level",'>%1',0);

      IF ReqLine2.FINDFIRST THEN BEGIN
        ReqLine2.BlockDynamicTracking(Blocked);
        ReqLine2.VALIDATE(Quantity,ReqLine2.Quantity + ReqLine.Quantity);

        IF ReqLine2."Due Date" > ReqLine."Due Date" THEN
          ReqLine2."Due Date" := ReqLine."Due Date";

        IF ReqLine2."Ending Date" > ReqLine."Ending Date" THEN BEGIN
          ReqLine2."Ending Date" := ReqLine."Ending Date";
          ReqLine2."Ending Time" := ReqLine."Ending Time";
        END ELSE
          IF (ReqLine2."Ending Date" = ReqLine."Ending Date") AND
             (ReqLine2."Ending Time" > ReqLine."Ending Time")
          THEN
            ReqLine2."Ending Time" := ReqLine."Ending Time";

        IF ReqLine2."Planning Level" < ReqLine."Planning Level" THEN
          ReqLine2."Planning Level" := ReqLine."Planning Level";

        ReqLine2.MODIFY;
        ReqLine := ReqLine2;
      END ELSE
        ReqLine.INSERT;
    END;

    [External]
    PROCEDURE BlockDynamicTracking@17(SetBlock@1000 : Boolean);
    BEGIN
      Blocked := SetBlock;
    END;

    [External]
    PROCEDURE GetPlanningCompList@5(VAR PlanningCompList@1000 : TEMPORARY Record 99000829);
    BEGIN
      // The procedure returns a list of the Planning Components handled.
      IF TempPlanningComponent.FIND('-') THEN
        REPEAT
          PlanningCompList := TempPlanningComponent;
          IF NOT PlanningCompList.INSERT THEN
            PlanningCompList.MODIFY;
          TempPlanningComponent.DELETE;
        UNTIL TempPlanningComponent.NEXT = 0;
    END;

    LOCAL PROCEDURE IsPlannedComp@10(VAR PlanningComp@1000 : Record 99000829;ReqLine@1001 : Record 246;ProdBOMLine@1002 : Record 99000772) : Boolean;
    VAR
      PlanningComp2@1003 : Record 99000829;
    BEGIN
      WITH PlanningComp DO BEGIN
        PlanningComp2 := PlanningComp;

        SETCURRENTKEY(
          "Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.","Item No.");
        SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
        SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
        SETRANGE("Worksheet Line No.",ReqLine."Line No.");
        SETRANGE("Item No.",ProdBOMLine."No.");
        IF FIND('-') THEN
          REPEAT
            IF ("Variant Code" = ProdBOMLine."Variant Code") AND
               ("Routing Link Code" = ProdBOMLine."Routing Link Code") AND
               (Position = ProdBOMLine.Position) AND
               ("Position 2" = ProdBOMLine."Position 2") AND
               ("Position 3" = ProdBOMLine."Position 3") AND
               (Length = ProdBOMLine.Length) AND
               (Width = ProdBOMLine.Width) AND
               (Weight = ProdBOMLine.Weight) AND
               (Depth = ProdBOMLine.Depth) AND
               ("Unit of Measure Code" = ProdBOMLine."Unit of Measure Code")
            THEN
              EXIT(TRUE);
          UNTIL NEXT = 0;

        PlanningComp := PlanningComp2;
        EXIT(FALSE);
      END;
    END;

    LOCAL PROCEDURE IsPlannedAsmComp@14(VAR PlanningComp@1000 : Record 99000829;ReqLine@1001 : Record 246;AsmBOMComp@1002 : Record 90) : Boolean;
    VAR
      PlanningComp2@1003 : Record 99000829;
    BEGIN
      WITH PlanningComp DO BEGIN
        PlanningComp2 := PlanningComp;

        SETCURRENTKEY(
          "Worksheet Template Name","Worksheet Batch Name","Worksheet Line No.","Item No.");
        SETRANGE("Worksheet Template Name",ReqLine."Worksheet Template Name");
        SETRANGE("Worksheet Batch Name",ReqLine."Journal Batch Name");
        SETRANGE("Worksheet Line No.",ReqLine."Line No.");
        SETRANGE("Item No.",AsmBOMComp."No.");
        IF FIND('-') THEN
          REPEAT
            IF ("Variant Code" = AsmBOMComp."Variant Code") AND
               (Position = AsmBOMComp.Position) AND
               ("Position 2" = AsmBOMComp."Position 2") AND
               ("Position 3" = AsmBOMComp."Position 3") AND
               ("Unit of Measure Code" = AsmBOMComp."Unit of Measure Code")
            THEN
              EXIT(TRUE);
          UNTIL NEXT = 0;

        PlanningComp := PlanningComp2;
        EXIT(FALSE);
      END;
    END;

    [External]
    PROCEDURE SetResiliencyOn@48(WkshTemplName@1001 : Code[10];JnlBatchName@1000 : Code[10];ItemNo@1002 : Code[20]);
    BEGIN
      PlanningResiliency := TRUE;
      TempPlanningErrorLog.SetJnlBatch(WkshTemplName,JnlBatchName,ItemNo);
    END;

    [External]
    PROCEDURE GetResiliencyError@47(VAR PlanningErrorLog@1000 : Record 5430) : Boolean;
    BEGIN
      TempPlanningComponent.DELETEALL;
      IF CalcPlanningRtngLine.GetResiliencyError(PlanningErrorLog) THEN
        EXIT(TRUE);
      EXIT(TempPlanningErrorLog.GetError(PlanningErrorLog));
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterTransferRtngLine@49(VAR ReqLine@1000 : Record 246;VAR RoutingLine@1001 : Record 99000764;VAR PlanningRoutingLine@1002 : Record 99000830);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnTransferBOMOnBeforeGetDefaultBin@53(VAR PlanningComponent@1000 : Record 99000829;VAR ProductionBOMLine@1001 : Record 99000772);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertPlanningComponent@50(VAR ReqLine@1000 : Record 246;VAR ProductionBOMLine@1001 : Record 99000772;VAR PlanningComponent@1002 : Record 99000829);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeModifyPlanningComponent@51(VAR ReqLine@1000 : Record 246;VAR ProductionBOMLine@1001 : Record 99000772;VAR PlanningComponent@1002 : Record 99000829);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeInsertAsmPlanningComponent@52(VAR ReqLine@1000 : Record 246;VAR BOMComponent@1001 : Record 90;VAR PlanningComponent@1002 : Record 99000829);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnCheckMultiLevelStructureOnBeforeInsertPlanningLine@54(VAR ReqLine@1000 : Record 246;VAR PlanningComponent@1001 : Record 99000829);
    BEGIN
    END;

    BEGIN
    END.
  }
}

