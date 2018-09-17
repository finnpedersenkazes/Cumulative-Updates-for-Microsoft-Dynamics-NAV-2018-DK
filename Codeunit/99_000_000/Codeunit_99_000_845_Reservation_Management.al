OBJECT Codeunit 99000845 Reservation Management
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    Permissions=TableData 32=rm,
                TableData 337=rimd,
                TableData 99000849=rimd;
    OnRun=BEGIN
          END;

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Fastlagt %1;ENU=Firm Planned %1';
      Text001@1001 : TextConst 'DAN=Frigivet %1;ENU=Released %1';
      Text003@1002 : TextConst 'DAN=CU99000845: CalculateRemainingQty - Source type missing;ENU=CU99000845: CalculateRemainingQty - Source type missing';
      Text004@1003 : TextConst 'DAN=Codeunit 99000845: Illegal FieldFilter parameter;ENU=Codeunit 99000845: Illegal FieldFilter parameter';
      Text006@1005 : TextConst 'DAN=Udg�ende,Indg�ende;ENU=Outbound,Inbound';
      Text007@1006 : TextConst 'DAN=CU99000845 DeleteReservEntries2: Surplus order tracking double record detected.;ENU=CU99000845 DeleteReservEntries2: Surplus order tracking double record detected.';
      CalcReservEntry@1007 : Record 337;
      CalcReservEntry2@1008 : Record 337;
      ForItemLedgEntry@1009 : Record 32;
      CalcItemLedgEntry@1010 : Record 32;
      ForSalesLine@1011 : Record 37;
      CalcSalesLine@1012 : Record 37;
      ForPurchLine@1013 : Record 39;
      CalcPurchLine@1014 : Record 39;
      ForItemJnlLine@1015 : Record 83;
      ForReqLine@1016 : Record 246;
      CalcReqLine@1017 : Record 246;
      ForProdOrderLine@1018 : Record 5406;
      CalcProdOrderLine@1019 : Record 5406;
      ForProdOrderComp@1020 : Record 5407;
      CalcProdOrderComp@1021 : Record 5407;
      ForPlanningComponent@1022 : Record 99000829;
      CalcPlanningComponent@1023 : Record 99000829;
      ForAssemblyHeader@1070 : Record 900;
      CalcAssemblyHeader@1073 : Record 900;
      ForAssemblyLine@1071 : Record 901;
      CalcAssemblyLine@1072 : Record 901;
      ForTransLine@1024 : Record 5741;
      CalcTransLine@1025 : Record 5741;
      ForServiceLine@1026 : Record 5902;
      CalcServiceLine@1027 : Record 5902;
      ForJobPlanningLine@1067 : Record 1003;
      CalcJobPlanningLine@1066 : Record 1003;
      ActionMessageEntry@1028 : Record 99000849;
      Item@1029 : Record 27;
      Location@1061 : Record 14;
      MfgSetup@1030 : Record 99000765;
      SKU@1031 : Record 5700;
      ItemTrackingCode@1004 : Record 6502;
      TempTrackingSpecification@1055 : TEMPORARY Record 336;
      CallTrackingSpecification@1056 : Record 336;
      ForJobJnlLine@1065 : Record 210;
      CreateReservEntry@1032 : Codeunit 99000830;
      ReservEngineMgt@1033 : Codeunit 99000831;
      ReserveSalesLine@1034 : Codeunit 99000832;
      ReserveReqLine@1035 : Codeunit 99000833;
      ReservePurchLine@1036 : Codeunit 99000834;
      ReserveItemJnlLine@1037 : Codeunit 99000835;
      ReserveProdOrderLine@1038 : Codeunit 99000837;
      ReserveProdOrderComp@1039 : Codeunit 99000838;
      AssemblyHeaderReserve@1075 : Codeunit 925;
      AssemblyLineReserve@1074 : Codeunit 926;
      ReservePlanningComponent@1040 : Codeunit 99000840;
      ReserveServiceInvLine@1041 : Codeunit 99000842;
      ReserveTransLine@1042 : Codeunit 99000836;
      JobPlanningLineReserve@1068 : Codeunit 1032;
      GetPlanningParameters@1043 : Codeunit 99000855;
      CreatePick@1058 : Codeunit 7312;
      Positive@1044 : Boolean;
      CurrentBindingIsSet@1045 : Boolean;
      HandleItemTracking@1060 : Boolean;
      InvSearch@1046 : Text[1];
      FieldFilter@1047 : Text[80];
      InvNextStep@1048 : Integer;
      ValueArray@1049 : ARRAY [18] OF Integer;
      CurrentBinding@1050 : ',Order-to-Order';
      ItemTrackingHandling@1051 : 'None,Allow deletion,Match';
      Text008@1053 : TextConst 'DAN=Den varesporing, der er angivet for %1 i %2, bel�ber sig til mere end det antal, du har angivet.\Du skal regulere den eksisterende varesporing og derefter indtaste det nye antal igen.;ENU=Item tracking defined for item %1 in the %2 accounts for more than the quantity you have entered.\You must adjust the existing item tracking and then reenter the new quantity.';
      Text009@1052 : TextConst 'DAN=Varesporing blev ikke fundet.\Serienr.: %1, lotnr.: %2, udest�ende antal: %3.;ENU=Item Tracking cannot be fully matched.\Serial No.: %1, Lot No.: %2, outstanding quantity: %3.';
      Text010@1054 : TextConst 'DAN=Der er angivet varesporing for %1 i %2.\Du skal slette den eksisterende varesporing, f�r du �ndrer eller sletter %2.;ENU=Item tracking is defined for item %1 in the %2.\You must delete the existing item tracking before modifying or deleting the %2.';
      TotalAvailQty@1062 : Decimal;
      QtyAllocInWhse@1057 : Decimal;
      QtyOnOutBound@1059 : Decimal;
      Text011@1063 : TextConst 'DAN=Der er angivet varesporing for %1 i %2.\Vil du slette %2 og varesporingslinjerne?;ENU=Item tracking is defined for item %1 in the %2.\Do you want to delete the %2 and the item tracking lines?';
      QtyReservedOnPickShip@1069 : Decimal;
      AssemblyTxt@1076 : TextConst 'DAN=Montage;ENU=Assembly';
      DeleteDocLineWithItemReservQst@1064 : TextConst '@@@="%1 = Document Type, %2 = Document No.";DAN=%1 %2 har varereservation. Vil du slette den alligevel?;ENU=%1 %2 has item reservation. Do you want to delete it anyway?';
      DeleteTransLineWithItemReservQst@1079 : TextConst '@@@="%1 = Document No.";DAN=Overf�rselsordren %1 har varereservation. Vil du slette den alligevel?;ENU=Transfer order %1 has item reservation. Do you want to delete it anyway?';
      DeleteProdOrderLineWithItemReservQst@1080 : TextConst '@@@="%1 = Status, %2 = Prod. Order No.";DAN=%1 produktionsordren %2 har varereservation. Vil du slette den alligevel?;ENU=%1 production order %2 has item reservation. Do you want to delete it anyway?';

    [External]
    PROCEDURE IsPositive@18() : Boolean;
    BEGIN
      EXIT(Positive);
    END;

    [External]
    PROCEDURE FormatQty@22(Quantity@1000 : Decimal) : Decimal;
    BEGIN
      IF Positive THEN
        EXIT(Quantity);

      EXIT(-Quantity);
    END;

    [External]
    PROCEDURE SetCalcReservEntry@70(TrackingSpecification@1000 : Record 336;VAR ReservEntry@1001 : Record 337);
    BEGIN
      // Late Binding
      CalcReservEntry.TRANSFERFIELDS(TrackingSpecification);
      SourceQuantity(CalcReservEntry,TRUE);
      CalcReservEntry.CopyTrackingFromSpec(TrackingSpecification);
      ReservEntry := CalcReservEntry;
      HandleItemTracking := TRUE;
    END;

    [External]
    PROCEDURE SetSalesLine@1(NewSalesLine@1000 : Record 37);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForSalesLine := NewSalesLine;

      CalcReservEntry.SetSource(
        DATABASE::"Sales Line",ForSalesLine."Document Type",NewSalesLine."Document No.",NewSalesLine."Line No.",'',0);
      CalcReservEntry.SetItemData(
        NewSalesLine."No.",NewSalesLine.Description,NewSalesLine."Location Code",NewSalesLine."Variant Code",
        NewSalesLine."Qty. per Unit of Measure");
      IF NewSalesLine.Type <> NewSalesLine.Type::Item THEN
        CalcReservEntry."Item No." := '';
      CalcReservEntry."Expected Receipt Date" := NewSalesLine."Shipment Date";
      CalcReservEntry."Shipment Date" := NewSalesLine."Shipment Date";

      UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ForSalesLine."Outstanding Qty. (Base)") <= 0);
    END;

    [External]
    PROCEDURE SetReqLine@13(NewReqLine@1000 : Record 246);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForReqLine := NewReqLine;

      CalcReservEntry.SetSource(
        DATABASE::"Requisition Line",0,NewReqLine."Worksheet Template Name",NewReqLine."Line No.",NewReqLine."Journal Batch Name",0);
      CalcReservEntry.SetItemData(
        NewReqLine."No.",NewReqLine.Description,NewReqLine."Location Code",NewReqLine."Variant Code",
        NewReqLine."Qty. per Unit of Measure");
      IF NewReqLine.Type <> NewReqLine.Type::Item THEN
        CalcReservEntry."Item No." := '';
      CalcReservEntry."Expected Receipt Date" := NewReqLine."Due Date";
      CalcReservEntry."Shipment Date" := NewReqLine."Due Date";
      CalcReservEntry."Planning Flexibility" := NewReqLine."Planning Flexibility";

      UpdateReservation(ForReqLine."Net Quantity (Base)" < 0);
    END;

    [External]
    PROCEDURE SetPurchLine@2(NewPurchLine@1000 : Record 39);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForPurchLine := NewPurchLine;

      CalcReservEntry.SetSource(
        DATABASE::"Purchase Line",ForPurchLine."Document Type",NewPurchLine."Document No.",NewPurchLine."Line No.",'',0);
      CalcReservEntry.SetItemData(
        NewPurchLine."No.",NewPurchLine.Description,NewPurchLine."Location Code",NewPurchLine."Variant Code",
        NewPurchLine."Qty. per Unit of Measure");
      IF NewPurchLine.Type <> NewPurchLine.Type::Item THEN
        CalcReservEntry."Item No." := '';
      CalcReservEntry."Expected Receipt Date" := NewPurchLine."Expected Receipt Date";
      CalcReservEntry."Shipment Date" := NewPurchLine."Expected Receipt Date";
      CalcReservEntry."Planning Flexibility" := NewPurchLine."Planning Flexibility";

      UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ForPurchLine."Outstanding Qty. (Base)") < 0);
    END;

    [External]
    PROCEDURE SetItemJnlLine@3(NewItemJnlLine@1000 : Record 83);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForItemJnlLine := NewItemJnlLine;

      CalcReservEntry.SetSource(
        DATABASE::"Item Journal Line",ForItemJnlLine."Entry Type",NewItemJnlLine."Journal Template Name",
        NewItemJnlLine."Line No.",NewItemJnlLine."Journal Batch Name",0);
      CalcReservEntry.SetItemData(
        NewItemJnlLine."Item No.",NewItemJnlLine.Description,NewItemJnlLine."Location Code",NewItemJnlLine."Variant Code",
        NewItemJnlLine."Qty. per Unit of Measure");
      CalcReservEntry."Expected Receipt Date" := NewItemJnlLine."Posting Date";
      CalcReservEntry."Shipment Date" := NewItemJnlLine."Posting Date";

      UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ForItemJnlLine."Quantity (Base)") < 0);
    END;

    [External]
    PROCEDURE SetProdOrderLine@9(NewProdOrderLine@1000 : Record 5406);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForProdOrderLine := NewProdOrderLine;

      CalcReservEntry.SetSource(
        DATABASE::"Prod. Order Line",ForProdOrderLine.Status,ForProdOrderLine."Prod. Order No.",0,'',NewProdOrderLine."Line No.");
      CalcReservEntry.SetItemData(
        NewProdOrderLine."Item No.",NewProdOrderLine.Description,NewProdOrderLine."Location Code",NewProdOrderLine."Variant Code",
        NewProdOrderLine."Qty. per Unit of Measure");
      CalcReservEntry."Expected Receipt Date" := NewProdOrderLine."Due Date";
      CalcReservEntry."Shipment Date" := NewProdOrderLine."Due Date";
      CalcReservEntry."Planning Flexibility" := NewProdOrderLine."Planning Flexibility";

      UpdateReservation(ForProdOrderLine."Remaining Qty. (Base)" < 0);
    END;

    [External]
    PROCEDURE SetProdOrderComponent@11(NewProdOrderComp@1000 : Record 5407);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForProdOrderComp := NewProdOrderComp;

      CalcReservEntry.SetSource(
        DATABASE::"Prod. Order Component",NewProdOrderComp.Status,NewProdOrderComp."Prod. Order No.",
        NewProdOrderComp."Line No.",'',NewProdOrderComp."Prod. Order Line No.");
      CalcReservEntry.SetItemData(
        NewProdOrderComp."Item No.",NewProdOrderComp.Description,NewProdOrderComp."Location Code",NewProdOrderComp."Variant Code",
        NewProdOrderComp."Qty. per Unit of Measure");
      CalcReservEntry."Expected Receipt Date" := NewProdOrderComp."Due Date";
      CalcReservEntry."Shipment Date" := NewProdOrderComp."Due Date";

      UpdateReservation(ForProdOrderComp."Remaining Qty. (Base)" > 0);
    END;

    [External]
    PROCEDURE SetAssemblyHeader@105(NewAssemblyHeader@1000 : Record 900);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForAssemblyHeader := NewAssemblyHeader;

      CalcReservEntry.SetSource(
        DATABASE::"Assembly Header",ForAssemblyHeader."Document Type",NewAssemblyHeader."No.",0,'',0);
      CalcReservEntry.SetItemData(
        NewAssemblyHeader."Item No.",NewAssemblyHeader.Description,NewAssemblyHeader."Location Code",NewAssemblyHeader."Variant Code",
        NewAssemblyHeader."Qty. per Unit of Measure");
      CalcReservEntry."Expected Receipt Date" := NewAssemblyHeader."Due Date";
      CalcReservEntry."Shipment Date" := NewAssemblyHeader."Due Date";

      UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ForAssemblyHeader."Remaining Quantity (Base)") < 0);
    END;

    [External]
    PROCEDURE SetAssemblyLine@106(NewAssemblyLine@1000 : Record 901);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForAssemblyLine := NewAssemblyLine;

      CalcReservEntry.SetSource(
        DATABASE::"Assembly Line",ForAssemblyLine."Document Type",NewAssemblyLine."Document No.",NewAssemblyLine."Line No.",'',0);
      CalcReservEntry.SetItemData(
        NewAssemblyLine."No.",NewAssemblyLine.Description,NewAssemblyLine."Location Code",NewAssemblyLine."Variant Code",
        NewAssemblyLine."Qty. per Unit of Measure");
      IF NewAssemblyLine.Type <> NewAssemblyLine.Type::Item THEN
        CalcReservEntry."Item No." := '';
      CalcReservEntry."Expected Receipt Date" := NewAssemblyLine."Due Date";
      CalcReservEntry."Shipment Date" := NewAssemblyLine."Due Date";

      UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ForAssemblyLine."Remaining Quantity (Base)") < 0);
    END;

    [External]
    PROCEDURE SetPlanningComponent@12(NewPlanningComponent@1000 : Record 99000829);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForPlanningComponent := NewPlanningComponent;

      CalcReservEntry.SetSource(
        DATABASE::"Planning Component",0,NewPlanningComponent."Worksheet Template Name",
        NewPlanningComponent."Line No.",NewPlanningComponent."Worksheet Batch Name",NewPlanningComponent."Worksheet Line No.");
      CalcReservEntry.SetItemData(
        NewPlanningComponent."Item No.",NewPlanningComponent.Description,NewPlanningComponent."Location Code",
        NewPlanningComponent."Variant Code",NewPlanningComponent."Qty. per Unit of Measure");
      CalcReservEntry."Expected Receipt Date" := NewPlanningComponent."Due Date";
      CalcReservEntry."Shipment Date" := NewPlanningComponent."Due Date";

      UpdateReservation(ForPlanningComponent."Net Quantity (Base)" > 0);
    END;

    [External]
    PROCEDURE SetItemLedgEntry@34(NewItemLedgEntry@1000 : Record 32);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForItemLedgEntry := NewItemLedgEntry;

      CalcReservEntry.SetSource(DATABASE::"Item Ledger Entry",0,'',NewItemLedgEntry."Entry No.",'',0);

      CalcReservEntry.SetItemData(
        NewItemLedgEntry."Item No.",NewItemLedgEntry.Description,NewItemLedgEntry."Location Code",NewItemLedgEntry."Variant Code",
        NewItemLedgEntry."Qty. per Unit of Measure");
      CalcReservEntry.CopyTrackingFromItemLedgEntry(NewItemLedgEntry);

      Positive := ForItemLedgEntry."Remaining Quantity" <= 0;
      IF Positive THEN BEGIN
        CalcReservEntry."Expected Receipt Date" := DMY2DATE(31,12,9999);
        CalcReservEntry."Shipment Date" := DMY2DATE(31,12,9999);
      END ELSE BEGIN
        CalcReservEntry."Expected Receipt Date" := 0D;
        CalcReservEntry."Shipment Date" := 0D;
      END;

      UpdateReservation(Positive);
    END;

    [External]
    PROCEDURE SetTransferLine@47(NewTransLine@1000 : Record 5741;Direction@1001 : 'Outbound,Inbound');
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForTransLine := NewTransLine;

      CalcReservEntry.SetSource(
        DATABASE::"Transfer Line",Direction,NewTransLine."Document No.",NewTransLine."Line No.",'',
        NewTransLine."Derived From Line No.");

      CASE Direction OF
        Direction::Outbound:
          BEGIN
            CalcReservEntry.SetItemData(
              NewTransLine."Item No.",NewTransLine.Description,NewTransLine."Transfer-from Code",NewTransLine."Variant Code",
              NewTransLine."Qty. per Unit of Measure");
            CalcReservEntry."Shipment Date" := NewTransLine."Shipment Date";
          END;
        Direction::Inbound:
          BEGIN
            CalcReservEntry.SetItemData(
              NewTransLine."Item No.",NewTransLine.Description,NewTransLine."Transfer-to Code",NewTransLine."Variant Code",
              NewTransLine."Qty. per Unit of Measure");
            CalcReservEntry."Expected Receipt Date" := NewTransLine."Receipt Date";
          END;
      END;

      UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ForTransLine."Outstanding Qty. (Base)") <= 0);
    END;

    [External]
    PROCEDURE SetServLine@48(NewServiceLine@1000 : Record 5902);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForServiceLine := NewServiceLine;

      CalcReservEntry.SetSource(
        DATABASE::"Service Line",ForServiceLine."Document Type",ForServiceLine."Document No.",NewServiceLine."Line No.",'',0);
      CalcReservEntry.SetItemData(
        NewServiceLine."No.",NewServiceLine.Description,NewServiceLine."Location Code",NewServiceLine."Variant Code",
        NewServiceLine."Qty. per Unit of Measure");
      IF NewServiceLine.Type <> NewServiceLine.Type::Item THEN
        CalcReservEntry."Item No." := '';
      CalcReservEntry."Expected Receipt Date" := NewServiceLine."Needed by Date";
      CalcReservEntry."Shipment Date" := NewServiceLine."Needed by Date";

      UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ForServiceLine."Outstanding Qty. (Base)") <= 0);
    END;

    [External]
    PROCEDURE SetJobJnlLine@20(NewJobJnlLine@1000 : Record 210);
    BEGIN
      CLEARALL;
      ForJobJnlLine := NewJobJnlLine;

      CalcReservEntry.SetSource(
        DATABASE::"Job Journal Line",ForJobJnlLine."Entry Type",NewJobJnlLine."Journal Template Name",NewJobJnlLine."Line No.",
        NewJobJnlLine."Journal Batch Name",0);
      CalcReservEntry.SetItemData(
        NewJobJnlLine."No.",NewJobJnlLine.Description,NewJobJnlLine."Location Code",NewJobJnlLine."Variant Code",
        NewJobJnlLine."Qty. per Unit of Measure");
      CalcReservEntry."Expected Receipt Date" := NewJobJnlLine."Posting Date";
      CalcReservEntry."Shipment Date" := NewJobJnlLine."Posting Date";

      UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ForJobJnlLine."Quantity (Base)") < 0);
    END;

    [External]
    PROCEDURE SetJobPlanningLine@71(NewJobPlanningLine@1000 : Record 1003);
    BEGIN
      CLEARALL;
      TempTrackingSpecification.DELETEALL;

      ForJobPlanningLine := NewJobPlanningLine;

      CalcReservEntry.SetSource(
        DATABASE::"Job Planning Line",ForJobPlanningLine.Status,NewJobPlanningLine."Job No.",
        NewJobPlanningLine."Job Contract Entry No.",'',0);
      CalcReservEntry.SetItemData(
        NewJobPlanningLine."No.",NewJobPlanningLine.Description,NewJobPlanningLine."Location Code",NewJobPlanningLine."Variant Code",
        NewJobPlanningLine."Qty. per Unit of Measure");
      IF NewJobPlanningLine.Type <> NewJobPlanningLine.Type::Item THEN
        CalcReservEntry."Item No." := '';
      CalcReservEntry."Expected Receipt Date" := NewJobPlanningLine."Planning Date";
      CalcReservEntry."Shipment Date" := NewJobPlanningLine."Planning Date";

      UpdateReservation((CreateReservEntry.SignFactor(CalcReservEntry) * ForJobPlanningLine."Remaining Qty. (Base)") <= 0);
    END;

    [External]
    PROCEDURE SalesLineUpdateValues@54(VAR CurrentSalesLine@1000 : Record 37;VAR QtyToReserve@1003 : Decimal;VAR QtyToReserveBase@1001 : Decimal;VAR QtyReservedThisLine@1004 : Decimal;VAR QtyReservedThisLineBase@1002 : Decimal);
    BEGIN
      WITH CurrentSalesLine DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          "Reserved Quantity" := -"Reserved Quantity";
          "Reserved Qty. (Base)" := -"Reserved Qty. (Base)";
        END;
        QtyReservedThisLine := "Reserved Quantity";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := "Outstanding Quantity" - "Reserved Quantity";
        QtyToReserveBase := "Outstanding Qty. (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE ReqLineUpdateValues@56(VAR CurrentReqLine@1000 : Record 246;VAR QtyToReserve@1003 : Decimal;VAR QtyToReserveBase@1001 : Decimal;VAR QtyReservedThisLine@1004 : Decimal;VAR QtyReservedThisLineBase@1002 : Decimal);
    BEGIN
      WITH CurrentReqLine DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        QtyReservedThisLine := "Reserved Quantity";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := Quantity - "Reserved Quantity";
        QtyToReserveBase := "Quantity (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE PurchLineUpdateValues@44(VAR CurrentPurchLine@1000 : Record 39;VAR QtyToReserve@1003 : Decimal;VAR QtyToReserveBase@1001 : Decimal;VAR QtyReservedThisLine@1004 : Decimal;VAR QtyReservedThisLineBase@1002 : Decimal);
    BEGIN
      WITH CurrentPurchLine DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          "Reserved Quantity" := -"Reserved Quantity";
          "Reserved Qty. (Base)" := -"Reserved Qty. (Base)";
        END;
        QtyReservedThisLine := "Reserved Quantity";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := "Outstanding Quantity" - "Reserved Quantity";
        QtyToReserveBase := "Outstanding Qty. (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE ProdOrderLineUpdateValues@15(VAR CurrentProdOrderLine@1000 : Record 5406;VAR QtyToReserve@1003 : Decimal;VAR QtyToReserveBase@1001 : Decimal;VAR QtyReservedThisLine@1004 : Decimal;VAR QtyReservedThisLineBase@1002 : Decimal);
    BEGIN
      WITH CurrentProdOrderLine DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        QtyReservedThisLine := "Reserved Quantity";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := "Remaining Quantity" - "Reserved Quantity";
        QtyToReserveBase := "Remaining Qty. (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE ProdOrderCompUpdateValues@16(VAR CurrentProdOrderComp@1000 : Record 5407;VAR QtyToReserve@1003 : Decimal;VAR QtyToReserveBase@1001 : Decimal;VAR QtyReservedThisLine@1004 : Decimal;VAR QtyReservedThisLineBase@1002 : Decimal);
    BEGIN
      WITH CurrentProdOrderComp DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        QtyReservedThisLine := "Reserved Qty. (Base)";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := "Remaining Quantity" - "Reserved Quantity";
        QtyToReserveBase := "Remaining Qty. (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE AssemblyHeaderUpdateValues@108(VAR CurrentAssemblyHeader@1000 : Record 900;VAR QtyToReserve@1001 : Decimal;VAR QtyToReserveBase@1003 : Decimal;VAR QtyReservedThisLine@1002 : Decimal;VAR QtyReservedThisLineBase@1004 : Decimal);
    BEGIN
      WITH CurrentAssemblyHeader DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        QtyReservedThisLine := "Reserved Quantity";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := "Remaining Quantity" - "Reserved Quantity";
        QtyToReserveBase := "Remaining Quantity (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE AssemblyLineUpdateValues@107(VAR CurrentAssemblyLine@1000 : Record 901;VAR QtyToReserve@1001 : Decimal;VAR QtyToReserveBase@1003 : Decimal;VAR QtyReservedThisLine@1002 : Decimal;VAR QtyReservedThisLineBase@1004 : Decimal);
    BEGIN
      WITH CurrentAssemblyLine DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        QtyReservedThisLine := "Reserved Quantity";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := "Remaining Quantity" - "Reserved Quantity";
        QtyToReserveBase := "Remaining Quantity (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE PlanningComponentUpdateValues@19(VAR CurrentPlanningComponent@1000 : Record 99000829;VAR QtyToReserve@1003 : Decimal;VAR QtyToReserveBase@1001 : Decimal;VAR QtyReservedThisLine@1005 : Decimal;VAR QtyReservedThisLineBase@1002 : Decimal);
    BEGIN
      WITH CurrentPlanningComponent DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        QtyReservedThisLine := "Reserved Quantity";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := 0;
        QtyToReserveBase := "Net Quantity (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE ItemLedgEntryUpdateValues@55(VAR CurrentItemLedgEntry@1000 : Record 32;VAR QtyToReserve@1001 : Decimal;VAR QtyReservedThisLine@1002 : Decimal);
    BEGIN
      WITH CurrentItemLedgEntry DO BEGIN
        CALCFIELDS("Reserved Quantity");
        QtyReservedThisLine := "Reserved Quantity";
        QtyToReserve := "Remaining Quantity" - "Reserved Quantity";
      END;
    END;

    [External]
    PROCEDURE ServiceInvLineUpdateValues@50(VAR CurrentServiceInvLine@1000 : Record 5902;VAR QtyToReserve@1003 : Decimal;VAR QtyToReserveBase@1001 : Decimal;VAR QtyReservedThisLine@1004 : Decimal;VAR QtyReservedThisLineBase@1002 : Decimal);
    BEGIN
      WITH CurrentServiceInvLine DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        QtyReservedThisLine := "Reserved Quantity";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := "Outstanding Quantity" - "Reserved Quantity";
        QtyToReserveBase := "Outstanding Qty. (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    [External]
    PROCEDURE TransferLineUpdateValues@49(VAR CurrentTransLine@1000 : Record 5741;VAR QtyToReserve@1004 : Decimal;VAR QtyToReserveBase@1001 : Decimal;VAR QtyReservedThisLine@1005 : Decimal;VAR QtyReservedThisLineBase@1002 : Decimal;Direction@1003 : 'Outbound,Inbound');
    BEGIN
      WITH CurrentTransLine DO
        CASE Direction OF
          Direction::Outbound:
            BEGIN
              CALCFIELDS("Reserved Quantity Outbnd.","Reserved Qty. Outbnd. (Base)");
              QtyReservedThisLine := "Reserved Quantity Outbnd.";
              QtyReservedThisLineBase := "Reserved Qty. Outbnd. (Base)";
              QtyToReserve := -"Outstanding Quantity" + "Reserved Quantity Outbnd.";
              QtyToReserveBase := -"Outstanding Qty. (Base)" + "Reserved Qty. Outbnd. (Base)";
            END;
          Direction::Inbound:
            BEGIN
              CALCFIELDS("Reserved Quantity Inbnd.","Reserved Qty. Inbnd. (Base)");
              QtyReservedThisLine := "Reserved Quantity Inbnd.";
              QtyReservedThisLineBase := "Reserved Qty. Inbnd. (Base)";
              QtyToReserve := "Outstanding Quantity" - "Reserved Quantity Inbnd.";
              QtyToReserveBase := "Outstanding Qty. (Base)" - "Reserved Qty. Inbnd. (Base)";
            END;
        END;
    END;

    [External]
    PROCEDURE JobPlanningLineUpdateValues@72(VAR CurrentJobPlanningLine@1000 : Record 1003;VAR QtyToReserve@1003 : Decimal;VAR QtyToReserveBase@1001 : Decimal;VAR QtyReservedThisLine@1004 : Decimal;VAR QtyReservedThisLineBase@1002 : Decimal);
    BEGIN
      WITH CurrentJobPlanningLine DO BEGIN
        CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
        QtyReservedThisLine := "Reserved Quantity";
        QtyReservedThisLineBase := "Reserved Qty. (Base)";
        QtyToReserve := "Remaining Qty." - "Reserved Quantity";
        QtyToReserveBase := "Remaining Qty. (Base)" - "Reserved Qty. (Base)";
      END;
    END;

    LOCAL PROCEDURE UpdateReservation@21(EntryIsPositive@1000 : Boolean);
    BEGIN
      CalcReservEntry2 := CalcReservEntry;
      GetItemSetup(CalcReservEntry);
      Positive := EntryIsPositive;
      CalcReservEntry2.SetPointerFilter;
      CallCalcReservedQtyOnPick;
    END;

    [External]
    PROCEDURE UpdateStatistics@7(VAR ReservSummEntry@1000 : Record 338;AvailabilityDate@1001 : Date;HandleItemTracking2@1006 : Boolean);
    VAR
      i@1002 : Integer;
      CurrentEntryNo@1003 : Integer;
      ValueArrayNo@1007 : Integer;
      CalcSumValue@1004 : Decimal;
    BEGIN
      CurrentEntryNo := ReservSummEntry."Entry No.";
      CalcReservEntry.TESTFIELD("Source Type");
      ReservSummEntry.DELETEALL;
      HandleItemTracking := HandleItemTracking2;
      IF HandleItemTracking2 THEN
        ValueArrayNo := 3;
      FOR i := 1 TO SetValueArray(ValueArrayNo) DO BEGIN
        CalcSumValue := 0;
        ReservSummEntry.INIT;
        ReservSummEntry."Entry No." := ValueArray[i];

        CASE ValueArray[i] OF
          1: // Item Ledger Entry
            UpdateItemLedgEntryStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue,HandleItemTracking2);
          12,16: // Purchase Order, Purchase Return Order
            UpdatePurchLineStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          32,36: // Sales Order, Sales Return Order
            UpdateSalesLineStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          63: // Firm Planned Prod. Order Line
            UpdateProdOrderLineStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          64: // Released Prod. Order Line
            UpdateProdOrderLineStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          73: // Firm Planned Component Line
            UpdateProdOrderCompStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          74: // Released Component Line
            UpdateProdOrderCompStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          101,102: // Transfer Line
            UpdateTransLineStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          110: // Service Line Order
            UpdateServLineStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          133: // Job Planning Line Order
            UpdateJobPlanningLineStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          141,142: // Assembly Header
            UpdateAssemblyHeaderStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          151,152: // AssemblyLine
            UpdateAssemblyLineStats(ReservSummEntry,AvailabilityDate,i,CalcSumValue);
          6500: // Item Tracking
            UpdateItemTrackingLineStats(ReservSummEntry,AvailabilityDate);
        END;
      END;
      IF NOT ReservSummEntry.GET(CurrentEntryNo) THEN;
    END;

    LOCAL PROCEDURE UpdateItemLedgEntryStats@69(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1003 : Decimal;HandleItemTracking2@1004 : Boolean);
    VAR
      LateBindingMgt@1005 : Codeunit 6502;
      ReservForm@1006 : Page 498;
      CurrReservedQtyBase@1007 : Decimal;
    BEGIN
      IF CalcItemLedgEntry.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF CalcItemLedgEntry.FINDSET THEN
          REPEAT
            CalcItemLedgEntry.CALCFIELDS("Reserved Quantity");
            ReservEntrySummary."Total Reserved Quantity" += CalcItemLedgEntry."Reserved Quantity";
            CalcSumValue += CalcItemLedgEntry."Remaining Quantity";
          UNTIL CalcItemLedgEntry.NEXT = 0;
        IF HandleItemTracking2 THEN
          IF ReservEntrySummary."Total Reserved Quantity" > 0 THEN
            ReservEntrySummary."Non-specific Reserved Qty." := LateBindingMgt.NonspecificReservedQty(CalcItemLedgEntry);

        IF CalcSumValue <> 0 THEN
          IF (CalcSumValue > 0) = Positive THEN BEGIN
            IF Location.GET(CalcItemLedgEntry."Location Code") AND
               (Location."Bin Mandatory" OR Location."Require Pick")
            THEN BEGIN
              CalcReservedQtyOnPick(TotalAvailQty,QtyAllocInWhse);
              QtyOnOutBound :=
                CreatePick.CheckOutBound(
                  CalcReservEntry."Source Type",CalcReservEntry."Source Subtype",
                  CalcReservEntry."Source ID",CalcReservEntry."Source Ref. No.",
                  CalcReservEntry."Source Prod. Order Line");
            END ELSE BEGIN
              QtyAllocInWhse := 0;
              QtyOnOutBound := 0;
            END;
            IF QtyAllocInWhse < 0 THEN
              QtyAllocInWhse := 0;
            ReservEntrySummary."Table ID" := DATABASE::"Item Ledger Entry";
            ReservEntrySummary."Summary Type" :=
              COPYSTR(CalcItemLedgEntry.TABLECAPTION,1,MAXSTRLEN(ReservEntrySummary."Summary Type"));
            ReservEntrySummary."Total Quantity" := CalcSumValue;
            ReservEntrySummary."Total Available Quantity" :=
              ReservEntrySummary."Total Quantity" - ReservEntrySummary."Total Reserved Quantity";

            CLEAR(ReservForm);
            ReservForm.SetReservEntry(CalcReservEntry);
            CurrReservedQtyBase := ReservForm.ReservedThisLine(ReservEntrySummary);
            IF (CurrReservedQtyBase <> 0) AND (QtyOnOutBound <> 0) THEN
              IF QtyOnOutBound > CurrReservedQtyBase THEN
                QtyOnOutBound := QtyOnOutBound - CurrReservedQtyBase
              ELSE
                QtyOnOutBound := 0;

            IF Location."Bin Mandatory" OR Location."Require Pick" THEN BEGIN
              IF TotalAvailQty + QtyOnOutBound < ReservEntrySummary."Total Available Quantity" THEN
                ReservEntrySummary."Total Available Quantity" := TotalAvailQty + QtyOnOutBound;
              ReservEntrySummary."Qty. Alloc. in Warehouse" := QtyAllocInWhse;
              ReservEntrySummary."Res. Qty. on Picks & Shipmts." := QtyReservedOnPickShip
            END ELSE BEGIN
              ReservEntrySummary."Qty. Alloc. in Warehouse" := 0;
              ReservEntrySummary."Res. Qty. on Picks & Shipmts." := 0
            END;
            IF NOT ReservEntrySummary.INSERT THEN
              ReservEntrySummary.MODIFY;
          END;
      END;
    END;

    LOCAL PROCEDURE UpdatePurchLineStats@73(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1003 : Decimal);
    BEGIN
      IF CalcPurchLine.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF CalcPurchLine.FINDSET THEN
          REPEAT
            CalcPurchLine.CALCFIELDS("Reserved Qty. (Base)");
            IF NOT CalcPurchLine."Special Order" THEN BEGIN
              ReservEntrySummary."Total Reserved Quantity" += CalcPurchLine."Reserved Qty. (Base)";
              CalcSumValue += CalcPurchLine."Outstanding Qty. (Base)";
            END;
          UNTIL CalcPurchLine.NEXT = 0;

        IF CalcSumValue <> 0 THEN
          WITH ReservEntrySummary DO
            IF (Positive = (CalcSumValue > 0)) AND (ValueArray[i] <> 16) OR
               (Positive = (CalcSumValue < 0)) AND (ValueArray[i] = 16)
            THEN BEGIN
              "Table ID" := DATABASE::"Purchase Line";
              "Summary Type" :=
                COPYSTR(
                  STRSUBSTNO('%1, %2',CalcPurchLine.TABLECAPTION,CalcPurchLine."Document Type"),
                  1,MAXSTRLEN("Summary Type"));
              IF ValueArray[i] = 16 THEN
                "Total Quantity" := -CalcSumValue
              ELSE
                "Total Quantity" := CalcSumValue;
              "Total Available Quantity" := "Total Quantity" - "Total Reserved Quantity";
              IF NOT INSERT THEN
                MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateSalesLineStats@74(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1004 : Decimal);
    BEGIN
      IF CalcSalesLine.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF CalcSalesLine.FINDSET THEN
          REPEAT
            CalcSalesLine.CALCFIELDS("Reserved Qty. (Base)");
            ReservEntrySummary."Total Reserved Quantity" -= CalcSalesLine."Reserved Qty. (Base)";
            CalcSumValue += CalcSalesLine."Outstanding Qty. (Base)";
          UNTIL CalcSalesLine.NEXT = 0;

        IF CalcSumValue <> 0 THEN
          WITH ReservEntrySummary DO
            IF (Positive = (CalcSumValue < 0)) AND (ValueArray[i] <> 36) OR
               (Positive = (CalcSumValue > 0)) AND (ValueArray[i] = 36)
            THEN BEGIN
              "Table ID" := DATABASE::"Sales Line";
              "Summary Type" :=
                COPYSTR(
                  STRSUBSTNO('%1, %2',CalcSalesLine.TABLECAPTION,CalcSalesLine."Document Type"),
                  1,MAXSTRLEN("Summary Type"));
              IF ValueArray[i] = 36 THEN
                "Total Quantity" := CalcSumValue
              ELSE
                "Total Quantity" := -CalcSumValue;
              "Total Available Quantity" := "Total Quantity" - "Total Reserved Quantity";
              IF NOT INSERT THEN
                MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateProdOrderLineStats@75(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1004 : Decimal);
    BEGIN
      IF CalcProdOrderLine.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF CalcProdOrderLine.FINDSET THEN
          REPEAT
            CalcProdOrderLine.CALCFIELDS("Reserved Qty. (Base)");
            ReservEntrySummary."Total Reserved Quantity" += CalcProdOrderLine."Reserved Qty. (Base)";
            CalcSumValue += CalcProdOrderLine."Remaining Qty. (Base)";
          UNTIL CalcProdOrderLine.NEXT = 0;

        IF CalcSumValue <> 0 THEN
          WITH ReservEntrySummary DO
            IF (CalcSumValue > 0) = Positive THEN BEGIN
              "Table ID" := DATABASE::"Prod. Order Line";
              IF "Entry No." = 63 THEN
                "Summary Type" := COPYSTR(STRSUBSTNO(Text000,CalcProdOrderLine.TABLECAPTION),1,MAXSTRLEN("Summary Type"))
              ELSE
                "Summary Type" := COPYSTR(STRSUBSTNO(Text001,CalcProdOrderLine.TABLECAPTION),1,MAXSTRLEN("Summary Type"));
              "Total Quantity" := CalcSumValue;
              "Total Available Quantity" := "Total Quantity" - "Total Reserved Quantity";
              IF NOT INSERT THEN
                MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateAssemblyHeaderStats@111(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1004 : Decimal);
    BEGIN
      IF CalcAssemblyHeader.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF CalcAssemblyHeader.FINDSET THEN
          REPEAT
            CalcAssemblyHeader.CALCFIELDS("Reserved Qty. (Base)");
            ReservEntrySummary."Total Reserved Quantity" += CalcAssemblyHeader."Reserved Qty. (Base)";
            CalcSumValue += CalcAssemblyHeader."Remaining Quantity (Base)";
          UNTIL CalcAssemblyHeader.NEXT = 0;

        IF CalcSumValue <> 0 THEN
          WITH ReservEntrySummary DO
            IF (CalcSumValue > 0) = Positive THEN BEGIN
              "Table ID" := DATABASE::"Assembly Header";
              "Summary Type" :=
                COPYSTR(
                  STRSUBSTNO('%1 %2',AssemblyTxt,CalcAssemblyHeader."Document Type"),
                  1,MAXSTRLEN("Summary Type"));
              "Total Quantity" := CalcSumValue;
              "Total Available Quantity" := "Total Quantity" - "Total Reserved Quantity";
              IF NOT INSERT THEN
                MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateAssemblyLineStats@112(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1004 : Decimal);
    BEGIN
      IF  CalcAssemblyLine.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF  CalcAssemblyLine.FINDSET THEN
          REPEAT
            CalcAssemblyLine.CALCFIELDS("Reserved Qty. (Base)");
            ReservEntrySummary."Total Reserved Quantity" -= CalcAssemblyLine."Reserved Qty. (Base)";
            CalcSumValue += CalcAssemblyLine."Remaining Quantity (Base)";
          UNTIL  CalcAssemblyLine.NEXT = 0;

        IF CalcSumValue <> 0 THEN
          WITH ReservEntrySummary DO
            IF CalcSumValue < 0 = Positive THEN BEGIN
              "Table ID" := DATABASE::"Assembly Line";
              "Summary Type" :=
                COPYSTR(
                  STRSUBSTNO('%1, %2',CalcAssemblyLine.TABLECAPTION,CalcAssemblyLine."Document Type"),
                  1,MAXSTRLEN("Summary Type"));
              "Total Quantity" := -CalcSumValue;
              "Total Available Quantity" := "Total Quantity" - "Total Reserved Quantity";
              IF NOT INSERT THEN
                MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateProdOrderCompStats@76(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1003 : Decimal);
    BEGIN
      IF CalcProdOrderComp.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF CalcProdOrderComp.FINDSET THEN
          REPEAT
            CalcProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
            ReservEntrySummary."Total Reserved Quantity" -= CalcProdOrderComp."Reserved Qty. (Base)";
            CalcSumValue += CalcProdOrderComp."Remaining Qty. (Base)";
          UNTIL CalcProdOrderComp.NEXT = 0;

        IF CalcSumValue <> 0 THEN
          WITH ReservEntrySummary DO
            IF (CalcSumValue < 0) = Positive THEN BEGIN
              "Table ID" := DATABASE::"Prod. Order Component";
              IF "Entry No." = 73 THEN
                "Summary Type" :=
                  COPYSTR(STRSUBSTNO(Text000,CalcProdOrderComp.TABLECAPTION),1,MAXSTRLEN("Summary Type"))
              ELSE
                "Summary Type" :=
                  COPYSTR(STRSUBSTNO(Text001,CalcProdOrderComp.TABLECAPTION),1,MAXSTRLEN("Summary Type"));
              "Total Quantity" := -CalcSumValue;
              "Total Available Quantity" := "Total Quantity" - "Total Reserved Quantity";
              IF NOT INSERT THEN
                MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateTransLineStats@77(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1004 : Decimal);
    BEGIN
      IF CalcTransLine.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF CalcTransLine.FINDSET THEN
          REPEAT
            CASE ValueArray[i] OF
              101:
                BEGIN
                  CalcTransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");
                  ReservEntrySummary."Total Reserved Quantity" -= CalcTransLine."Reserved Qty. Outbnd. (Base)";
                  CalcSumValue -= CalcTransLine."Outstanding Qty. (Base)";
                END;
              102:
                BEGIN
                  CalcTransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
                  ReservEntrySummary."Total Reserved Quantity" += CalcTransLine."Reserved Qty. Inbnd. (Base)";
                  CalcSumValue += CalcTransLine."Outstanding Qty. (Base)";
                END;
            END;
          UNTIL CalcTransLine.NEXT = 0;

        IF CalcSumValue <> 0 THEN
          WITH ReservEntrySummary DO
            IF (CalcSumValue > 0) = Positive THEN BEGIN
              "Table ID" := DATABASE::"Transfer Line";
              "Summary Type" :=
                COPYSTR(
                  STRSUBSTNO('%1, %2',CalcTransLine.TABLECAPTION,SELECTSTR(ValueArray[i] - 100,Text006)),
                  1,MAXSTRLEN("Summary Type"));
              "Total Quantity" := CalcSumValue;
              "Total Available Quantity" := "Total Quantity" - "Total Reserved Quantity";
              IF NOT INSERT THEN
                MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateServLineStats@78(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1003 : Decimal);
    BEGIN
      IF CalcServiceLine.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF CalcServiceLine.FINDSET THEN
          REPEAT
            CalcServiceLine.CALCFIELDS("Reserved Qty. (Base)");
            ReservEntrySummary."Total Reserved Quantity" -= CalcServiceLine."Reserved Qty. (Base)";
            CalcSumValue += CalcServiceLine."Outstanding Qty. (Base)";
          UNTIL CalcServiceLine.NEXT = 0;

        IF CalcSumValue <> 0 THEN
          WITH ReservEntrySummary DO
            IF (CalcSumValue < 0) = Positive THEN BEGIN
              "Table ID" := DATABASE::"Service Line";
              "Summary Type" :=
                COPYSTR(STRSUBSTNO('%1',CalcServiceLine.TABLECAPTION),1,MAXSTRLEN("Summary Type"));
              "Total Quantity" := -CalcSumValue;
              "Total Available Quantity" := "Total Quantity" - "Total Reserved Quantity";
              IF NOT INSERT THEN
                MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateJobPlanningLineStats@79(VAR ReservEntrySummary@1001 : Record 338;AvailabilityDate@1000 : Date;i@1002 : Integer;VAR CalcSumValue@1004 : Decimal);
    BEGIN
      IF CalcJobPlanningLine.READPERMISSION THEN BEGIN
        InitFilter(ValueArray[i],AvailabilityDate);
        IF CalcJobPlanningLine.FINDSET THEN
          REPEAT
            CalcJobPlanningLine.CALCFIELDS("Reserved Qty. (Base)");
            ReservEntrySummary."Total Reserved Quantity" -= CalcJobPlanningLine."Reserved Qty. (Base)";
            CalcSumValue += CalcJobPlanningLine."Remaining Qty. (Base)";
          UNTIL CalcJobPlanningLine.NEXT = 0;

        IF CalcSumValue <> 0 THEN
          WITH ReservEntrySummary DO
            IF (CalcSumValue < 0) = Positive THEN BEGIN
              "Table ID" := DATABASE::"Job Planning Line";
              "Summary Type" :=
                COPYSTR(
                  STRSUBSTNO('%1, %2',CalcJobPlanningLine.TABLECAPTION,CalcJobPlanningLine.Status),
                  1,MAXSTRLEN("Summary Type"));
              "Total Quantity" := -CalcSumValue;
              "Total Available Quantity" := "Total Quantity" - "Total Reserved Quantity";
              IF NOT INSERT THEN
                MODIFY;
            END;
      END;
    END;

    LOCAL PROCEDURE UpdateItemTrackingLineStats@80(VAR ReservEntrySummary@1002 : Record 338;AvailabilityDate@1001 : Date);
    VAR
      ReservEntry@1000 : Record 337;
    BEGIN
      ReservEntry.RESET;
      ReservEntry.SETCURRENTKEY(
        "Item No.","Source Type","Source Subtype","Reservation Status","Location Code",
        "Variant Code","Shipment Date","Expected Receipt Date","Serial No.","Lot No.");
      ReservEntry.SETRANGE("Item No.",CalcReservEntry."Item No.");
      ReservEntry.SETFILTER("Source Type",'<> %1',DATABASE::"Item Ledger Entry");
      ReservEntry.SETRANGE("Reservation Status",
        ReservEntry."Reservation Status"::Reservation,ReservEntry."Reservation Status"::Surplus);
      ReservEntry.SETRANGE("Location Code",CalcReservEntry."Location Code");
      ReservEntry.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
      IF Positive THEN
        ReservEntry.SETFILTER("Expected Receipt Date",'..%1',AvailabilityDate)
      ELSE
        ReservEntry.SETFILTER("Shipment Date",'>=%1',AvailabilityDate);
      ReservEntry.SetTrackingFilterFromReservEntry(CalcReservEntry);
      ReservEntry.SETRANGE(Positive,Positive);
      IF ReservEntry.FINDSET THEN
        REPEAT
          ReservEntry.SETRANGE("Source Type",ReservEntry."Source Type");
          ReservEntry.SETRANGE("Source Subtype",ReservEntry."Source Subtype");
          ReservEntrySummary.INIT;
          ReservEntrySummary."Entry No." := ReservEntry.SummEntryNo;
          ReservEntrySummary."Table ID" := ReservEntry."Source Type";
          ReservEntrySummary."Summary Type" :=
            COPYSTR(ReservEntry.TextCaption,1,MAXSTRLEN(ReservEntrySummary."Summary Type"));
          ReservEntrySummary."Source Subtype" := ReservEntry."Source Subtype";
          ReservEntrySummary."Serial No." := ReservEntry."Serial No.";
          ReservEntrySummary."Lot No." := ReservEntry."Lot No.";
          IF ReservEntry.FINDSET THEN
            REPEAT
              ReservEntrySummary."Total Quantity" += ReservEntry."Quantity (Base)";
              IF ReservEntry."Reservation Status" = ReservEntry."Reservation Status"::Reservation THEN
                ReservEntrySummary."Total Reserved Quantity" += ReservEntry."Quantity (Base)";
              IF CalcReservEntry.HasSamePointer(ReservEntry) THEN
                ReservEntrySummary."Current Reserved Quantity" += ReservEntry."Quantity (Base)";
            UNTIL ReservEntry.NEXT = 0;

          ReservEntrySummary."Total Available Quantity" :=
            ReservEntrySummary."Total Quantity" - ReservEntrySummary."Total Reserved Quantity";
          ReservEntrySummary.INSERT;
          ReservEntry.SETRANGE("Source Type");
          ReservEntry.SETRANGE("Source Subtype");
        UNTIL ReservEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE AutoReserve@5(VAR FullAutoReservation@1000 : Boolean;Description@1001 : Text[50];AvailabilityDate@1002 : Date;MaxQtyToReserve@1007 : Decimal;MaxQtyToReserveBase@1006 : Decimal);
    VAR
      RemainingQtyToReserve@1008 : Decimal;
      RemainingQtyToReserveBase@1003 : Decimal;
      i@1004 : Integer;
      StopReservation@1005 : Boolean;
    BEGIN
      CalcReservEntry.TESTFIELD("Source Type");

      IF CalcReservEntry."Source Type" IN [DATABASE::"Sales Line",DATABASE::"Purchase Line",DATABASE::"Service Line"] THEN
        StopReservation := NOT (CalcReservEntry."Source Subtype" IN [1,5]); // Only order and return order

      IF CalcReservEntry."Source Type" IN [DATABASE::"Assembly Line",DATABASE::"Assembly Header"] THEN
        StopReservation := NOT (CalcReservEntry."Source Subtype" = 1); // Only Assembly Order

      IF CalcReservEntry."Source Type" IN [DATABASE::"Prod. Order Line",DATABASE::"Prod. Order Component"]
      THEN
        StopReservation := CalcReservEntry."Source Subtype" < 2; // Not simulated or planned

      IF CalcReservEntry."Source Type" = DATABASE::"Sales Line" THEN
        IF (CalcReservEntry."Source Subtype" = 1) AND (ForSalesLine.Quantity < 0) THEN
          StopReservation := TRUE;

      IF CalcReservEntry."Source Type" = DATABASE::"Sales Line" THEN
        IF (CalcReservEntry."Source Subtype" = 5) AND (ForSalesLine.Quantity >= 0) THEN
          StopReservation := TRUE;

      IF StopReservation THEN BEGIN
        FullAutoReservation := TRUE;
        EXIT;
      END;

      CalculateRemainingQty(RemainingQtyToReserve,RemainingQtyToReserveBase);
      IF (MaxQtyToReserveBase <> 0) AND (ABS(MaxQtyToReserveBase) < ABS(RemainingQtyToReserveBase)) THEN BEGIN
        RemainingQtyToReserve := MaxQtyToReserve;
        RemainingQtyToReserveBase := MaxQtyToReserveBase;
      END;

      IF (RemainingQtyToReserveBase <> 0) AND
         HandleItemTracking AND
         ItemTrackingCode."SN Specific Tracking"
      THEN
        RemainingQtyToReserveBase := 1;
      FullAutoReservation := FALSE;

      IF RemainingQtyToReserveBase = 0 THEN BEGIN
        FullAutoReservation := TRUE;
        EXIT;
      END;

      FOR i := 1 TO SetValueArray(0) DO
        AutoReserveOneLine(ValueArray[i],RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate);

      FullAutoReservation := (RemainingQtyToReserveBase = 0);
    END;

    [External]
    PROCEDURE AutoReserveOneLine@4(ReservSummEntryNo@1018 : Integer;VAR RemainingQtyToReserve@1000 : Decimal;VAR RemainingQtyToReserveBase@1017 : Decimal;Description@1016 : Text[50];AvailabilityDate@1015 : Date);
    VAR
      Item@1004 : Record 27;
      Search@1007 : Text[1];
      NextStep@1008 : Integer;
    BEGIN
      CalcReservEntry.TESTFIELD("Source Type");

      IF RemainingQtyToReserveBase = 0 THEN
        EXIT;

      IF NOT Item.GET(CalcReservEntry."Item No.") THEN
        CLEAR(Item);

      CalcReservEntry.Lock;

      IF Positive THEN BEGIN
        Search := '+';
        NextStep := -1;
        IF Item."Costing Method" = Item."Costing Method"::LIFO THEN BEGIN
          InvSearch := '+';
          InvNextStep := -1;
        END ELSE BEGIN
          InvSearch := '-';
          InvNextStep := 1;
        END;
      END ELSE BEGIN
        Search := '-';
        NextStep := 1;
        InvSearch := '-';
        InvNextStep := 1;
      END;

      CASE ReservSummEntryNo OF
        1: // Item Ledger Entry
          AutoReserveItemLedgEntry(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate);
        12,
        16: // Purchase Line, Purchase Return Line
          AutoReservePurchLine(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate,
            Search,NextStep);
        21: // Requisition Line
          AutoReserveReqLine(ReservSummEntryNo,AvailabilityDate);
        31,
        32,
        36: // Sales Line, Sales Return Line
          AutoReserveSalesLine(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate,
            Search,NextStep);
        61,
        62,
        63,
        64: // Prod. Order
          AutoReserveProdOrderLine(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate,
            Search,NextStep);
        71,
        72,
        73,
        74: // Prod. Order Component
          AutoReserveProdOrderComp(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate,
            Search,NextStep);
        91: // Planning Component
          AutoReservePlanningComp(ReservSummEntryNo,AvailabilityDate);
        101,
        102: // Transfer
          AutoReserveTransLine(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate,
            Search,NextStep);
        110: // Service Line Order
          AutoReserveServLine(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate,
            Search,NextStep);
        133: // Job Planning Line Order
          AutoReserveJobPlanningLine(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate,
            Search,NextStep);
        142: // Assembly Header
          AutoReserveAssemblyHeader(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate,
            Search,NextStep);
        152: // Assembly Line
          AutoReserveAssemblyLine(ReservSummEntryNo,RemainingQtyToReserve,RemainingQtyToReserveBase,Description,AvailabilityDate,
            Search,NextStep);
      END;
    END;

    LOCAL PROCEDURE AutoReserveItemLedgEntry@114(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1000 : Decimal;VAR RemainingQtyToReserveBase@1004 : Decimal;Description@1003 : Text[50];AvailabilityDate@1002 : Date);
    VAR
      Location@1010 : Record 14;
      LateBindingMgt@1007 : Codeunit 6502;
      AllocationsChanged@1006 : Boolean;
      QtyThisLine@1009 : Decimal;
      QtyThisLineBase@1001 : Decimal;
    BEGIN
      IF NOT Location.GET(CalcReservEntry."Location Code") THEN
        CLEAR(Location);

      InitFilter(ReservSummEntryNo,AvailabilityDate);
      // Late Binding
      IF HandleItemTracking THEN
        AllocationsChanged :=
          LateBindingMgt.ReleaseForReservation3(CalcItemLedgEntry,CalcReservEntry,RemainingQtyToReserveBase);

      IF CalcItemLedgEntry.FIND(InvSearch) THEN BEGIN
        IF Location."Bin Mandatory" OR Location."Require Pick" THEN BEGIN
          QtyOnOutBound :=
            CreatePick.CheckOutBound(
              CalcReservEntry."Source Type",CalcReservEntry."Source Subtype",
              CalcReservEntry."Source ID",CalcReservEntry."Source Ref. No.",
              CalcReservEntry."Source Prod. Order Line") -
            CalcCurrLineReservQtyOnPicksShips(CalcReservEntry);
          IF AllocationsChanged THEN
            CalcReservedQtyOnPick(TotalAvailQty,QtyAllocInWhse); // If allocations have changed we must recalculate
        END;
        REPEAT
          CalcItemLedgEntry.CALCFIELDS("Reserved Quantity");
          IF (CalcItemLedgEntry."Remaining Quantity" -
              CalcItemLedgEntry."Reserved Quantity") <> 0
          THEN BEGIN
            IF ABS(CalcItemLedgEntry."Remaining Quantity" -
                 CalcItemLedgEntry."Reserved Quantity") > ABS(RemainingQtyToReserveBase)
            THEN BEGIN
              QtyThisLine := ABS(RemainingQtyToReserve);
              QtyThisLineBase := ABS(RemainingQtyToReserveBase);
            END ELSE BEGIN
              QtyThisLineBase :=
                CalcItemLedgEntry."Remaining Quantity" - CalcItemLedgEntry."Reserved Quantity";
              QtyThisLine := 0;
            END;
            IF IsSpecialOrder(CalcItemLedgEntry."Purchasing Code") OR (Positive = (QtyThisLineBase < 0)) THEN BEGIN
              QtyThisLineBase := 0;
              QtyThisLine := 0;
            END;

            IF (Location."Bin Mandatory" OR Location."Require Pick") AND
               (TotalAvailQty + QtyOnOutBound < QtyThisLineBase)
            THEN
              IF (TotalAvailQty + QtyOnOutBound) < 0 THEN BEGIN
                QtyThisLineBase := 0;
                QtyThisLine := 0
              END ELSE BEGIN
                QtyThisLineBase := TotalAvailQty + QtyOnOutBound;
                QtyThisLine := ROUND(QtyThisLineBase,0.00001);
              END;

            OnAfterCalcReservation(CalcReservEntry,CalcItemLedgEntry,ReservSummEntryNo,QtyThisLine);

            CallTrackingSpecification.InitTrackingSpecification(
              DATABASE::"Item Ledger Entry",0,'','',0,CalcItemLedgEntry."Entry No.",
              CalcItemLedgEntry."Variant Code",CalcItemLedgEntry."Location Code",
              CalcItemLedgEntry."Serial No.",CalcItemLedgEntry."Lot No.",
              CalcItemLedgEntry."Qty. per Unit of Measure");

            IF CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,0,
                 Description,0D,QtyThisLine,QtyThisLineBase,CallTrackingSpecification)
            THEN
              IF Location."Bin Mandatory" OR Location."Require Pick" THEN
                TotalAvailQty := TotalAvailQty - QtyThisLineBase;
          END;
        UNTIL (CalcItemLedgEntry.NEXT(InvNextStep) = 0) OR (RemainingQtyToReserveBase = 0);
      END;
    END;

    LOCAL PROCEDURE AutoReservePurchLine@81(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1008 : Decimal;VAR RemainingQtyToReserveBase@1004 : Decimal;Description@1003 : Text[50];AvailabilityDate@1002 : Date;Search@1001 : Text[1];NextStep@1000 : Integer);
    VAR
      QtyThisLine@1009 : Decimal;
      QtyThisLineBase@1007 : Decimal;
      ReservQty@1006 : Decimal;
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
      IF CalcPurchLine.FIND(Search) THEN
        REPEAT
          CalcPurchLine.CALCFIELDS("Reserved Qty. (Base)");
          IF NOT CalcPurchLine."Special Order" THEN BEGIN
            QtyThisLine := CalcPurchLine."Outstanding Quantity";
            QtyThisLineBase := CalcPurchLine."Outstanding Qty. (Base)";
          END;
          IF ReservSummEntryNo = 16 THEN // Return Order
            ReservQty := -CalcPurchLine."Reserved Qty. (Base)"
          ELSE
            ReservQty := CalcPurchLine."Reserved Qty. (Base)";
          IF (Positive = (QtyThisLineBase < 0)) AND (ReservSummEntryNo <> 16) OR
             (Positive = (QtyThisLineBase > 0)) AND (ReservSummEntryNo = 16)
          THEN BEGIN
            QtyThisLine := 0;
            QtyThisLineBase := 0;
          END;

          CallTrackingSpecification.InitTrackingSpecification(
            DATABASE::"Purchase Line",CalcPurchLine."Document Type",CalcPurchLine."Document No.",'',
            0,CalcPurchLine."Line No.",
            CalcPurchLine."Variant Code",CalcPurchLine."Location Code",
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
            CalcPurchLine."Qty. per Unit of Measure");

          CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,ReservQty,
            Description,CalcPurchLine."Expected Receipt Date",QtyThisLine,QtyThisLineBase,CallTrackingSpecification);
        UNTIL (CalcPurchLine.NEXT(NextStep) = 0) OR (RemainingQtyToReserveBase = 0);
    END;

    LOCAL PROCEDURE AutoReserveReqLine@82(ReservSummEntryNo@1005 : Integer;AvailabilityDate@1002 : Date);
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
    END;

    LOCAL PROCEDURE AutoReserveSalesLine@83(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1008 : Decimal;VAR RemainingQtyToReserveBase@1004 : Decimal;Description@1003 : Text[50];AvailabilityDate@1002 : Date;Search@1001 : Text[1];NextStep@1000 : Integer);
    VAR
      QtyThisLine@1009 : Decimal;
      QtyThisLineBase@1007 : Decimal;
      ReservQty@1006 : Decimal;
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
      IF CalcSalesLine.FIND(Search) THEN
        REPEAT
          CalcSalesLine.CALCFIELDS("Reserved Qty. (Base)");
          QtyThisLine := CalcSalesLine."Outstanding Quantity";
          QtyThisLineBase := CalcSalesLine."Outstanding Qty. (Base)";
          IF ReservSummEntryNo = 36 THEN // Return Order
            ReservQty := -CalcSalesLine."Reserved Qty. (Base)"
          ELSE
            ReservQty := CalcSalesLine."Reserved Qty. (Base)";
          IF (Positive = (QtyThisLineBase > 0)) AND (ReservSummEntryNo <> 36) OR
             (Positive = (QtyThisLineBase < 0)) AND (ReservSummEntryNo = 36)
          THEN BEGIN
            QtyThisLine := 0;
            QtyThisLineBase := 0;
          END;

          CallTrackingSpecification.InitTrackingSpecification(
            DATABASE::"Sales Line",CalcSalesLine."Document Type",CalcSalesLine."Document No.",'',
            0,CalcSalesLine."Line No.",CalcSalesLine."Variant Code",CalcSalesLine."Location Code",
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
            CalcSalesLine."Qty. per Unit of Measure");

          CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,ReservQty,
            Description,CalcSalesLine."Shipment Date",QtyThisLine,QtyThisLineBase,CallTrackingSpecification);
        UNTIL (CalcSalesLine.NEXT(NextStep) = 0) OR (RemainingQtyToReserveBase = 0);
    END;

    LOCAL PROCEDURE AutoReserveProdOrderLine@84(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1006 : Decimal;VAR RemainingQtyToReserveBase@1004 : Decimal;Description@1003 : Text[50];AvailabilityDate@1002 : Date;Search@1001 : Text[1];NextStep@1000 : Integer);
    VAR
      QtyThisLine@1009 : Decimal;
      QtyThisLineBase@1007 : Decimal;
      ReservQty@1008 : Decimal;
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
      IF CalcProdOrderLine.FIND(Search) THEN
        REPEAT
          CalcProdOrderLine.CALCFIELDS("Reserved Qty. (Base)");
          QtyThisLine := CalcProdOrderLine."Remaining Quantity";
          QtyThisLineBase := CalcProdOrderLine."Remaining Qty. (Base)";
          ReservQty := CalcProdOrderLine."Reserved Qty. (Base)";
          IF Positive = (QtyThisLineBase < 0) THEN BEGIN
            QtyThisLine := 0;
            QtyThisLineBase := 0;
          END;

          CallTrackingSpecification.InitTrackingSpecification(
            DATABASE::"Prod. Order Line",CalcProdOrderLine.Status,CalcProdOrderLine."Prod. Order No.",'',
            CalcProdOrderLine."Line No.",0,CalcProdOrderLine."Variant Code",CalcProdOrderLine."Location Code",
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
            CalcProdOrderLine."Qty. per Unit of Measure");

          CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,ReservQty,
            Description,CalcProdOrderLine."Due Date",QtyThisLine,QtyThisLineBase,CallTrackingSpecification);
        UNTIL (CalcProdOrderLine.NEXT(NextStep) = 0) OR (RemainingQtyToReserveBase = 0);
    END;

    LOCAL PROCEDURE AutoReserveProdOrderComp@85(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1008 : Decimal;VAR RemainingQtyToReserveBase@1004 : Decimal;Description@1003 : Text[50];AvailabilityDate@1002 : Date;Search@1001 : Text[1];NextStep@1000 : Integer);
    VAR
      QtyThisLine@1009 : Decimal;
      QtyThisLineBase@1007 : Decimal;
      ReservQty@1006 : Decimal;
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
      IF CalcProdOrderComp.FIND(Search) THEN
        REPEAT
          CalcProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
          QtyThisLine := CalcProdOrderComp."Remaining Quantity";
          QtyThisLineBase := CalcProdOrderComp."Remaining Qty. (Base)";
          ReservQty := CalcProdOrderComp."Reserved Qty. (Base)";
          IF Positive = (QtyThisLineBase > 0) THEN BEGIN
            QtyThisLine := 0;
            QtyThisLineBase := 0;
          END;

          CallTrackingSpecification.InitTrackingSpecification(
            DATABASE::"Prod. Order Component",CalcProdOrderComp.Status,CalcProdOrderComp."Prod. Order No.",'',
            CalcProdOrderComp."Prod. Order Line No.",CalcProdOrderComp."Line No.",
            CalcProdOrderComp."Variant Code",CalcProdOrderComp."Location Code",
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
            CalcProdOrderComp."Qty. per Unit of Measure");

          CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,ReservQty,
            Description,CalcProdOrderComp."Due Date",QtyThisLine,QtyThisLineBase,CallTrackingSpecification);
        UNTIL (CalcProdOrderComp.NEXT(NextStep) = 0) OR (RemainingQtyToReserveBase = 0);
    END;

    LOCAL PROCEDURE AutoReserveAssemblyHeader@110(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1006 : Decimal;VAR RemainingQtyToReserveBase@1004 : Decimal;Description@1003 : Text[50];AvailabilityDate@1002 : Date;Search@1001 : Text[1];NextStep@1000 : Integer);
    VAR
      QtyThisLine@1009 : Decimal;
      QtyThisLineBase@1007 : Decimal;
      ReservQty@1008 : Decimal;
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
      IF CalcAssemblyHeader.FIND(Search) THEN
        REPEAT
          CalcAssemblyHeader.CALCFIELDS("Reserved Qty. (Base)");
          QtyThisLine := CalcAssemblyHeader."Remaining Quantity";
          QtyThisLineBase := CalcAssemblyHeader."Remaining Quantity (Base)";
          ReservQty := CalcAssemblyHeader."Reserved Qty. (Base)";
          IF Positive = (QtyThisLineBase < 0) THEN BEGIN
            QtyThisLine := 0;
            QtyThisLineBase := 0;
          END;

          CallTrackingSpecification.InitTrackingSpecification(
            DATABASE::"Assembly Header",CalcAssemblyHeader."Document Type",CalcAssemblyHeader."No.",'',
            0,0,CalcAssemblyHeader."Variant Code",CalcAssemblyHeader."Location Code",
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
            CalcAssemblyHeader."Qty. per Unit of Measure");

          CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,ReservQty,
            Description,CalcAssemblyHeader."Due Date",QtyThisLine,QtyThisLineBase,CallTrackingSpecification);
        UNTIL (CalcAssemblyHeader.NEXT(NextStep) = 0) OR (RemainingQtyToReserveBase = 0);
    END;

    LOCAL PROCEDURE AutoReserveAssemblyLine@109(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1008 : Decimal;VAR RemainingQtyToReserveBase@1004 : Decimal;Description@1003 : Text[50];AvailabilityDate@1002 : Date;Search@1001 : Text[1];NextStep@1000 : Integer);
    VAR
      QtyThisLine@1009 : Decimal;
      QtyThisLineBase@1007 : Decimal;
      ReservQty@1006 : Decimal;
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
      IF CalcAssemblyLine.FIND(Search) THEN
        REPEAT
          CalcAssemblyLine.CALCFIELDS("Reserved Qty. (Base)");
          QtyThisLine := CalcAssemblyLine."Remaining Quantity";
          QtyThisLineBase := CalcAssemblyLine."Remaining Quantity (Base)";
          ReservQty := CalcAssemblyLine."Reserved Qty. (Base)";
          IF Positive = (QtyThisLineBase > 0) THEN BEGIN
            QtyThisLine := 0;
            QtyThisLineBase := 0;
          END;

          CallTrackingSpecification.InitTrackingSpecification(
            DATABASE::"Assembly Line",CalcAssemblyLine."Document Type",CalcAssemblyLine."Document No.",'',
            0,CalcAssemblyLine."Line No.",CalcAssemblyLine."Variant Code",CalcAssemblyLine."Location Code",
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
            CalcAssemblyLine."Qty. per Unit of Measure");

          CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,ReservQty,
            Description,CalcAssemblyHeader."Due Date",QtyThisLine,QtyThisLineBase,CallTrackingSpecification);
        UNTIL (CalcAssemblyLine.NEXT(NextStep) = 0) OR (RemainingQtyToReserveBase = 0);
    END;

    LOCAL PROCEDURE AutoReservePlanningComp@86(ReservSummEntryNo@1005 : Integer;AvailabilityDate@1002 : Date);
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
    END;

    LOCAL PROCEDURE AutoReserveTransLine@87(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1010 : Decimal;VAR RemainingQtyToReserveBase@1004 : Decimal;Description@1003 : Text[50];AvailabilityDate@1002 : Date;Search@1001 : Text[1];NextStep@1000 : Integer);
    VAR
      QtyThisLine@1011 : Decimal;
      QtyThisLineBase@1007 : Decimal;
      ReservQty@1006 : Decimal;
      LocationCode@1009 : Code[10];
      EntryDate@1008 : Date;
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
      IF CalcTransLine.FIND(Search) THEN
        REPEAT
          CASE ReservSummEntryNo OF
            101: // Outbound
              BEGIN
                CalcTransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");
                QtyThisLine := -CalcTransLine."Outstanding Quantity";
                QtyThisLineBase := -CalcTransLine."Outstanding Qty. (Base)";
                ReservQty := -CalcTransLine."Reserved Qty. Outbnd. (Base)";
                EntryDate := CalcTransLine."Shipment Date";
                LocationCode := CalcTransLine."Transfer-from Code";
                IF Positive = (QtyThisLineBase < 0) THEN BEGIN
                  QtyThisLine := 0;
                  QtyThisLineBase := 0;
                END;
              END;
            102: // Inbound
              BEGIN
                CalcTransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
                QtyThisLine := CalcTransLine."Outstanding Quantity";
                QtyThisLineBase := CalcTransLine."Outstanding Qty. (Base)";
                ReservQty := CalcTransLine."Reserved Qty. Inbnd. (Base)";
                EntryDate := CalcTransLine."Receipt Date";
                LocationCode := CalcTransLine."Transfer-to Code";
                IF Positive = (QtyThisLineBase < 0) THEN BEGIN
                  QtyThisLine := 0;
                  QtyThisLineBase := 0;
                END;
              END;
          END;

          CallTrackingSpecification.InitTrackingSpecification(
            DATABASE::"Transfer Line",ReservSummEntryNo - 101,CalcTransLine."Document No.",'',
            CalcTransLine."Derived From Line No.",CalcTransLine."Line No.",
            CalcTransLine."Variant Code",LocationCode,
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
            CalcTransLine."Qty. per Unit of Measure");

          CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,ReservQty,
            Description,EntryDate,QtyThisLine,QtyThisLineBase,CallTrackingSpecification);
        UNTIL (CalcTransLine.NEXT(NextStep) = 0) OR (RemainingQtyToReserveBase = 0);
    END;

    LOCAL PROCEDURE AutoReserveServLine@88(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1008 : Decimal;VAR RemainingQtyToReserveBase@1004 : Decimal;Description@1003 : Text[50];AvailabilityDate@1002 : Date;Search@1001 : Text[1];NextStep@1000 : Integer);
    VAR
      QtyThisLine@1009 : Decimal;
      QtyThisLineBase@1007 : Decimal;
      ReservQty@1006 : Decimal;
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
      IF CalcServiceLine.FIND(Search) THEN
        REPEAT
          CalcServiceLine.CALCFIELDS("Reserved Qty. (Base)");
          QtyThisLine := CalcServiceLine."Outstanding Quantity";
          QtyThisLineBase := CalcServiceLine."Outstanding Qty. (Base)";
          ReservQty := CalcServiceLine."Reserved Qty. (Base)";
          IF Positive = (QtyThisLineBase > 0) THEN BEGIN
            QtyThisLine := 0;
            QtyThisLineBase := 0;
          END;

          CallTrackingSpecification.InitTrackingSpecification(
            DATABASE::"Service Line",CalcServiceLine."Document Type",CalcServiceLine."Document No.",'',
            0,CalcServiceLine."Line No.",CalcServiceLine."Variant Code",CalcServiceLine."Location Code",
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
            CalcServiceLine."Qty. per Unit of Measure");

          CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,ReservQty,
            Description,CalcServiceLine."Needed by Date",QtyThisLine,QtyThisLineBase,CallTrackingSpecification);
        UNTIL (CalcServiceLine.NEXT(NextStep) = 0) OR (RemainingQtyToReserveBase = 0);
    END;

    LOCAL PROCEDURE AutoReserveJobPlanningLine@89(ReservSummEntryNo@1005 : Integer;VAR RemainingQtyToReserve@1008 : Decimal;VAR RemainingQtyToReserveBase@1002 : Decimal;Description@1001 : Text[50];AvailabilityDate@1000 : Date;Search@1006 : Text[1];NextStep@1007 : Integer);
    VAR
      QtyThisLine@1009 : Decimal;
      QtyThisLineBase@1003 : Decimal;
      ReservQty@1004 : Decimal;
    BEGIN
      InitFilter(ReservSummEntryNo,AvailabilityDate);
      IF CalcJobPlanningLine.FIND(Search) THEN
        REPEAT
          CalcJobPlanningLine.CALCFIELDS("Reserved Qty. (Base)");
          QtyThisLine := CalcJobPlanningLine."Remaining Qty.";
          QtyThisLineBase := CalcJobPlanningLine."Remaining Qty. (Base)";
          ReservQty := CalcJobPlanningLine."Reserved Qty. (Base)";
          IF Positive = (QtyThisLineBase > 0) THEN BEGIN
            QtyThisLine := 0;
            QtyThisLineBase := 0;
          END;

          CallTrackingSpecification.InitTrackingSpecification(
            DATABASE::"Job Planning Line",CalcJobPlanningLine.Status,CalcJobPlanningLine."Job No.",'',
            0,CalcJobPlanningLine."Job Contract Entry No.",
            CalcJobPlanningLine."Variant Code",CalcJobPlanningLine."Location Code",
            CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
            CalcJobPlanningLine."Qty. per Unit of Measure");

          CallCreateReservation(RemainingQtyToReserve,RemainingQtyToReserveBase,ReservQty,
            Description,CalcJobPlanningLine."Planning Date",QtyThisLine,QtyThisLineBase,CallTrackingSpecification);
        UNTIL (CalcJobPlanningLine.NEXT(NextStep) = 0) OR (RemainingQtyToReserveBase = 0);
    END;

    LOCAL PROCEDURE CallCreateReservation@158(VAR RemainingQtyToReserve@1016 : Decimal;VAR RemainingQtyToReserveBase@1015 : Decimal;ReservQty@1014 : Decimal;Description@1013 : Text[50];ExpectedDate@1012 : Date;QtyThisLine@1017 : Decimal;QtyThisLineBase@1011 : Decimal;TrackingSpecification@1170000000 : Record 336) ReservationCreated : Boolean;
    BEGIN
      IF QtyThisLineBase = 0 THEN
        EXIT;
      IF ABS(QtyThisLineBase - ReservQty) > 0 THEN BEGIN
        IF ABS(QtyThisLineBase - ReservQty) > ABS(RemainingQtyToReserveBase) THEN BEGIN
          QtyThisLine := RemainingQtyToReserve;
          QtyThisLineBase := RemainingQtyToReserveBase;
        END ELSE BEGIN
          QtyThisLineBase := QtyThisLineBase - ReservQty;
          QtyThisLine := ROUND(RemainingQtyToReserve / RemainingQtyToReserveBase * QtyThisLineBase,0.00001);
        END;
        CopySign(RemainingQtyToReserveBase,QtyThisLineBase);
        CopySign(RemainingQtyToReserve,QtyThisLine);
        CreateReservation(Description,ExpectedDate,QtyThisLine,QtyThisLineBase,TrackingSpecification);
        RemainingQtyToReserve := RemainingQtyToReserve - QtyThisLine;
        RemainingQtyToReserveBase := RemainingQtyToReserveBase - QtyThisLineBase;
        ReservationCreated := TRUE;
      END;
    END;

    [External]
    PROCEDURE CreateReservation@39(Description@1000 : Text[50];ExpectedDate@1001 : Date;Quantity@1011 : Decimal;QuantityBase@1002 : Decimal;TrackingSpecification@1003 : Record 336);
    BEGIN
      CalcReservEntry.TESTFIELD("Source Type");

      OnBeforeCreateReservation(TrackingSpecification,CalcReservEntry,CalcItemLedgEntry);

      CASE CalcReservEntry."Source Type" OF
        DATABASE::"Sales Line":
          BEGIN
            ReserveSalesLine.CreateReservationSetFrom(TrackingSpecification);
            ReserveSalesLine.CreateReservation(
              ForSalesLine,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForSalesLine.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Requisition Line":
          BEGIN
            ReserveReqLine.CreateReservationSetFrom(TrackingSpecification);
            ReserveReqLine.CreateReservation(
              ForReqLine,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForReqLine.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Purchase Line":
          BEGIN
            ReservePurchLine.CreateReservationSetFrom(TrackingSpecification);
            ReservePurchLine.CreateReservation(
              ForPurchLine,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForPurchLine.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Item Journal Line":
          BEGIN
            ReserveItemJnlLine.CreateReservationSetFrom(TrackingSpecification);
            ReserveItemJnlLine.CreateReservation(
              ForItemJnlLine,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForItemJnlLine.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Prod. Order Line":
          BEGIN
            ReserveProdOrderLine.CreateReservationSetFrom(TrackingSpecification);
            ReserveProdOrderLine.CreateReservation(
              ForProdOrderLine,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForProdOrderLine.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Prod. Order Component":
          BEGIN
            ReserveProdOrderComp.CreateReservationSetFrom(TrackingSpecification);
            ReserveProdOrderComp.CreateReservation(
              ForProdOrderComp,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForProdOrderComp.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Assembly Header":
          BEGIN
            AssemblyHeaderReserve.CreateReservationSetFrom(TrackingSpecification);
            AssemblyHeaderReserve.CreateReservation(
              ForAssemblyHeader,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForAssemblyHeader.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Assembly Line":
          BEGIN
            AssemblyLineReserve.CreateReservationSetFrom(TrackingSpecification);
            AssemblyLineReserve.CreateReservation(
              ForAssemblyLine,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForAssemblyLine.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Planning Component":
          BEGIN
            ReservePlanningComponent.CreateReservationSetFrom(TrackingSpecification);
            ReservePlanningComponent.CreateReservation(
              ForPlanningComponent,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForPlanningComponent.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Transfer Line":
          BEGIN
            ReserveTransLine.CreateReservationSetFrom(TrackingSpecification);
            ReserveTransLine.CreateReservation(
              ForTransLine,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.",
              CalcReservEntry."Source Subtype");
            ForTransLine.CALCFIELDS("Reserved Qty. Outbnd. (Base)");
            ForTransLine.CALCFIELDS("Reserved Qty. Inbnd. (Base)");
          END;
        DATABASE::"Service Line":
          BEGIN
            ReserveServiceInvLine.CreateReservationSetFrom(TrackingSpecification);
            ReserveServiceInvLine.CreateReservation(
              ForServiceLine,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForServiceLine.CALCFIELDS("Reserved Qty. (Base)");
          END;
        DATABASE::"Job Planning Line":
          BEGIN
            JobPlanningLineReserve.CreateReservationSetFrom(TrackingSpecification);
            JobPlanningLineReserve.CreateReservation(
              ForJobPlanningLine,Description,ExpectedDate,Quantity,QuantityBase,
              CalcReservEntry."Serial No.",CalcReservEntry."Lot No.");
            ForJobPlanningLine.CALCFIELDS("Reserved Qty. (Base)");
          END;
      END;
    END;

    [External]
    PROCEDURE DeleteReservEntries@30(DeleteAll@1000 : Boolean;DownToQuantity@1001 : Decimal);
    VAR
      CalcReservEntry4@1004 : Record 337;
      TrackingMgt@1002 : Codeunit 99000778;
      ReservMgt@1003 : Codeunit 99000845;
      QtyToReTrack@1005 : Decimal;
      QtyTracked@1006 : Decimal;
    BEGIN
      DeleteReservEntries2(DeleteAll,DownToQuantity,CalcReservEntry2);

      // Handle both sides of a req. line related to a transfer line:
      IF ((CalcReservEntry."Source Type" = DATABASE::"Requisition Line") AND
          (ForReqLine."Ref. Order Type" = ForReqLine."Ref. Order Type"::Transfer))
      THEN BEGIN
        CalcReservEntry4 := CalcReservEntry;
        CalcReservEntry4."Source Subtype" := 1;
        CalcReservEntry4.SetPointerFilter;
        DeleteReservEntries2(DeleteAll,DownToQuantity,CalcReservEntry4);
      END;

      IF DeleteAll THEN
        IF ((CalcReservEntry."Source Type" = DATABASE::"Requisition Line") AND
            (ForReqLine."Planning Line Origin" <> ForReqLine."Planning Line Origin"::" ")) OR
           (CalcReservEntry."Source Type" = DATABASE::"Planning Component")
        THEN BEGIN
          CalcReservEntry4.RESET;
          IF TrackingMgt.DerivePlanningFilter(CalcReservEntry2,CalcReservEntry4) THEN
            IF CalcReservEntry4.FINDFIRST THEN BEGIN
              QtyToReTrack := ReservMgt.SourceQuantity(CalcReservEntry4,TRUE);
              CalcReservEntry4.SETRANGE("Reservation Status",CalcReservEntry4."Reservation Status"::Reservation);
              IF NOT CalcReservEntry4.ISEMPTY THEN BEGIN
                CalcReservEntry4.CALCSUMS("Quantity (Base)");
                QtyTracked += CalcReservEntry4."Quantity (Base)";
              END;
              CalcReservEntry4.SETFILTER("Reservation Status",'<>%1',CalcReservEntry4."Reservation Status"::Reservation);
              CalcReservEntry4.SETFILTER("Item Tracking",'<>%1',CalcReservEntry4."Item Tracking"::None);
              IF NOT CalcReservEntry4.ISEMPTY THEN BEGIN
                CalcReservEntry4.CALCSUMS("Quantity (Base)");
                QtyTracked += CalcReservEntry4."Quantity (Base)";
              END;
              IF CalcReservEntry."Source Type" = DATABASE::"Planning Component" THEN
                QtyTracked := -QtyTracked;
              ReservMgt.DeleteReservEntries(QtyTracked = 0,QtyTracked);
              ReservMgt.AutoTrack(QtyToReTrack);
            END;
        END;
    END;

    [External]
    PROCEDURE DeleteReservEntries2@31(DeleteAll@1000 : Boolean;DownToQuantity@1001 : Decimal;VAR ReservEntry@1002 : Record 337);
    VAR
      CalcReservEntry4@1003 : Record 337;
      SurplusEntry@1004 : Record 337;
      DummyEntry@1005 : Record 337;
      ReqLine@1018 : Record 246;
      Status@1006 : 'Reservation,Tracking,Surplus,Prospect';
      QtyToRelease@1007 : Decimal;
      QtyTracked@1008 : Decimal;
      QtyToReleaseForLotSN@1017 : Decimal;
      CurrentQty@1016 : Decimal;
      CurrentSerialNo@1014 : Code[20];
      CurrentLotNo@1015 : Code[20];
      AvailabilityDate@1009 : Date;
      Release@1010 : 'Non-Inventory,Inventory';
      HandleItemTracking2@1013 : Boolean;
      SignFactor@1012 : Integer;
      QuantityIsValidated@1066 : Boolean;
    BEGIN
      ReservEntry.SETRANGE("Reservation Status");
      IF ReservEntry.ISEMPTY THEN
        EXIT;
      CurrentSerialNo := ReservEntry."Serial No.";
      CurrentLotNo := ReservEntry."Lot No.";
      CurrentQty := ReservEntry."Quantity (Base)";

      GetItemSetup(ReservEntry);
      ReservEntry.TESTFIELD("Source Type");
      ReservEntry.Lock;
      SignFactor := CreateReservEntry.SignFactor(ReservEntry);
      QtyTracked := QuantityTracked(ReservEntry);
      CurrentBinding := ReservEntry.Binding;
      CurrentBindingIsSet := TRUE;

      IF (ReservEntry."Source Type" = DATABASE::"Requisition Line") AND (DownToQuantity <> 0) THEN
        IF ReqLine.GET(ReservEntry."Source ID",ReservEntry."Source Batch Name",ReservEntry."Source Ref. No.") THEN
          DownToQuantity := DownToQuantity - ReqLine."Original Quantity";

      // Item Tracking:
      IF ItemTrackingCode."SN Specific Tracking" OR ItemTrackingCode."Lot Specific Tracking" OR
         (CurrentSerialNo <> '') OR (CurrentLotNo <> '')
      THEN BEGIN
        HandleItemTracking2 := TRUE;
        CASE ItemTrackingHandling OF
          ItemTrackingHandling::None:
            ReservEntry.SetTrackingFilter('','');
          ItemTrackingHandling::Match:
            BEGIN
              IF NOT ((CurrentSerialNo = '') AND (CurrentLotNo = '')) THEN BEGIN
                QtyToReleaseForLotSN := QuantityTracked2(ReservEntry);
                IF ABS(QtyToReleaseForLotSN) > ABS(CurrentQty) THEN
                  QtyToReleaseForLotSN := CurrentQty;
                DownToQuantity := (QtyTracked - QtyToReleaseForLotSN) * SignFactor;
                ReservEntry.SetTrackingFilter(CurrentSerialNo,CurrentLotNo);
              END ELSE
                DownToQuantity += CalcDownToQtySyncingToAssembly(ReservEntry);
            END;
        END;
      END;

      IF SignFactor * QtyTracked * DownToQuantity < 0 THEN
        DeleteAll := TRUE
      ELSE
        IF ABS(QtyTracked) < ABS(DownToQuantity) THEN
          EXIT;

      QtyToRelease := QtyTracked - (DownToQuantity * SignFactor);

      FOR Status := Status::Prospect DOWNTO Status::Reservation DO BEGIN
        ReservEntry.SETRANGE("Reservation Status",Status);
        IF ReservEntry.FINDSET AND (QtyToRelease <> 0) THEN
          CASE Status OF
            Status::Prospect:
              REPEAT
                IF (ABS(ReservEntry."Quantity (Base)") <= ABS(QtyToRelease)) OR DeleteAll THEN BEGIN
                  ReservEntry.DELETE;
                  SaveTrackingSpecification(ReservEntry,ReservEntry."Quantity (Base)");
                  QtyToRelease := QtyToRelease - ReservEntry."Quantity (Base)";
                END ELSE BEGIN
                  ReservEntry.VALIDATE("Quantity (Base)",ReservEntry."Quantity (Base)" - QtyToRelease);
                  ReservEntry.MODIFY;
                  SaveTrackingSpecification(ReservEntry,QtyToRelease);
                  QtyToRelease := 0;
                END;
              UNTIL (ReservEntry.NEXT = 0) OR ((NOT DeleteAll) AND (QtyToRelease = 0));
            Status::Surplus:
              REPEAT
                IF CalcReservEntry4.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive) THEN // Find related entry
                  ERROR(Text007);
                IF (ABS(ReservEntry."Quantity (Base)") <= ABS(QtyToRelease)) OR DeleteAll THEN BEGIN
                  ReservEngineMgt.CloseReservEntry(ReservEntry,FALSE,DeleteAll);
                  SaveTrackingSpecification(ReservEntry,ReservEntry."Quantity (Base)");
                  QtyToRelease := QtyToRelease - ReservEntry."Quantity (Base)";
                  IF NOT DeleteAll AND CalcReservEntry4.TrackingExists THEN BEGIN
                    CalcReservEntry4."Reservation Status" := CalcReservEntry4."Reservation Status"::Surplus;
                    CalcReservEntry4.INSERT;
                  END;
                  ModifyActionMessage(ReservEntry."Entry No.",0,TRUE); // Delete action messages
                END ELSE BEGIN
                  ReservEntry.VALIDATE("Quantity (Base)",ReservEntry."Quantity (Base)" - QtyToRelease);
                  ReservEntry.MODIFY;
                  SaveTrackingSpecification(ReservEntry,QtyToRelease);
                  ModifyActionMessage(ReservEntry."Entry No.",QtyToRelease,FALSE); // Modify action messages
                  QtyToRelease := 0;
                END;
              UNTIL (ReservEntry.NEXT = 0) OR ((NOT DeleteAll) AND (QtyToRelease = 0));
            Status::Tracking,Status::Reservation:
              FOR Release := Release::"Non-Inventory" TO Release::Inventory DO BEGIN
                // Release non-inventory reservations in first cycle
                REPEAT
                  CalcReservEntry4.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive); // Find related entry
                  IF (Release = Release::Inventory) = (CalcReservEntry4."Source Type" = DATABASE::"Item Ledger Entry") THEN BEGIN
                    IF (ABS(ReservEntry."Quantity (Base)") <= ABS(QtyToRelease)) OR DeleteAll THEN BEGIN
                      ReservEngineMgt.CloseReservEntry(ReservEntry,FALSE,DeleteAll);
                      SaveTrackingSpecification(ReservEntry,ReservEntry."Quantity (Base)");
                      QtyToRelease := QtyToRelease - ReservEntry."Quantity (Base)";
                    END ELSE BEGIN
                      ReservEntry.VALIDATE("Quantity (Base)",ReservEntry."Quantity (Base)" - QtyToRelease);
                      ReservEntry.MODIFY;
                      SaveTrackingSpecification(ReservEntry,QtyToRelease);

                      IF Item."Order Tracking Policy" <> Item."Order Tracking Policy"::None THEN BEGIN
                        IF CalcReservEntry4."Quantity (Base)" > 0 THEN
                          AvailabilityDate := CalcReservEntry4."Shipment Date"
                        ELSE
                          AvailabilityDate := CalcReservEntry4."Expected Receipt Date";

                        QtyToRelease := -MatchSurplus(CalcReservEntry4,SurplusEntry,-QtyToRelease,
                            CalcReservEntry4."Quantity (Base)" < 0,AvailabilityDate,Item."Order Tracking Policy");

                        // Make residual surplus record:
                        IF QtyToRelease <> 0 THEN BEGIN
                          MakeConnection(CalcReservEntry4,CalcReservEntry4,-QtyToRelease,2,
                            AvailabilityDate,CalcReservEntry4.Binding);
                          IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN BEGIN
                            CreateReservEntry.GetLastEntry(SurplusEntry); // Get the surplus-entry just inserted
                            IssueActionMessage(SurplusEntry,FALSE,DummyEntry);
                          END;
                        END;
                      END ELSE
                        IF ItemTrackingHandling = ItemTrackingHandling::None THEN
                          QuantityIsValidated := SaveItemTrackingAsSurplus(CalcReservEntry4,
                              -ReservEntry.Quantity,-ReservEntry."Quantity (Base)");

                      IF NOT QuantityIsValidated THEN
                        CalcReservEntry4.VALIDATE("Quantity (Base)",-ReservEntry."Quantity (Base)");

                      CalcReservEntry4.MODIFY;
                      QtyToRelease := 0;
                      QuantityIsValidated := FALSE;
                    END;
                  END;
                UNTIL (ReservEntry.NEXT = 0) OR ((NOT DeleteAll) AND (QtyToRelease = 0));
                IF NOT ReservEntry.FINDFIRST THEN // Rewind for second cycle
                  Release := Release::Inventory;
              END;
          END;
      END;

      IF HandleItemTracking2 THEN
        CheckQuantityIsCompletelyReleased(QtyToRelease,DeleteAll,CurrentSerialNo,CurrentLotNo,ReservEntry);
    END;

    [External]
    PROCEDURE CalculateRemainingQty@52(VAR RemainingQty@1000 : Decimal;VAR RemainingQtyBase@1001 : Decimal);
    BEGIN
      CalcReservEntry.TESTFIELD("Source Type");

      CASE CalcReservEntry."Source Type" OF
        DATABASE::"Sales Line":
          BEGIN
            ForSalesLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := ForSalesLine."Outstanding Quantity" - ABS(ForSalesLine."Reserved Quantity");
            RemainingQtyBase := ForSalesLine."Outstanding Qty. (Base)" - ABS(ForSalesLine."Reserved Qty. (Base)");
          END;
        DATABASE::"Requisition Line":
          BEGIN
            ForReqLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := 0;
            RemainingQtyBase := ForReqLine."Net Quantity (Base)" - ABS(ForReqLine."Reserved Qty. (Base)");
          END;
        DATABASE::"Purchase Line":
          BEGIN
            ForPurchLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := ForPurchLine."Outstanding Quantity" - ABS(ForPurchLine."Reserved Quantity");
            RemainingQtyBase := ForPurchLine."Outstanding Qty. (Base)" - ABS(ForPurchLine."Reserved Qty. (Base)");
          END;
        DATABASE::"Prod. Order Line":
          BEGIN
            ForProdOrderLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := ForProdOrderLine."Remaining Quantity" - ABS(ForProdOrderLine."Reserved Quantity");
            RemainingQtyBase := ForProdOrderLine."Remaining Qty. (Base)" - ABS(ForProdOrderLine."Reserved Qty. (Base)");
          END;
        DATABASE::"Prod. Order Component":
          BEGIN
            ForProdOrderComp.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := ForProdOrderComp."Remaining Quantity" - ABS(ForProdOrderComp."Reserved Quantity");
            RemainingQtyBase := ForProdOrderComp."Remaining Qty. (Base)" - ABS(ForProdOrderComp."Reserved Qty. (Base)");
          END;
        DATABASE::"Assembly Header":
          BEGIN
            ForAssemblyHeader.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := ForAssemblyHeader."Remaining Quantity" - ABS(ForAssemblyHeader."Reserved Quantity");
            RemainingQtyBase := ForAssemblyHeader."Remaining Quantity (Base)" - ABS(ForAssemblyHeader."Reserved Qty. (Base)");
          END;
        DATABASE::"Assembly Line":
          BEGIN
            ForAssemblyLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := ForAssemblyLine."Remaining Quantity" - ABS(ForAssemblyLine."Reserved Quantity");
            RemainingQtyBase := ForAssemblyLine."Remaining Quantity (Base)" - ABS(ForAssemblyLine."Reserved Qty. (Base)");
          END;
        DATABASE::"Planning Component":
          BEGIN
            ForPlanningComponent.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := 0;
            RemainingQtyBase := ForPlanningComponent."Net Quantity (Base)" - ABS(ForPlanningComponent."Reserved Qty. (Base)");
          END;
        DATABASE::"Transfer Line":
          CASE CalcReservEntry."Source Subtype" OF
            0: // Outbound
              BEGIN
                ForTransLine.CALCFIELDS("Reserved Quantity Outbnd.","Reserved Qty. Outbnd. (Base)");
                RemainingQty := ForTransLine."Outstanding Quantity" - ABS(ForTransLine."Reserved Quantity Outbnd.");
                RemainingQtyBase := ForTransLine."Outstanding Qty. (Base)" - ABS(ForTransLine."Reserved Qty. Outbnd. (Base)");
              END;
            1: // Inbound
              BEGIN
                ForTransLine.CALCFIELDS("Reserved Quantity Inbnd.","Reserved Qty. Inbnd. (Base)");
                RemainingQty := ForTransLine."Outstanding Quantity" - ABS(ForTransLine."Reserved Quantity Inbnd.");
                RemainingQtyBase := ForTransLine."Outstanding Qty. (Base)" - ABS(ForTransLine."Reserved Qty. Inbnd. (Base)");
              END;
          END;
        DATABASE::"Service Line":
          BEGIN
            ForServiceLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := ForServiceLine."Outstanding Quantity" - ABS(ForServiceLine."Reserved Quantity");
            RemainingQtyBase := ForServiceLine."Outstanding Qty. (Base)" - ABS(ForServiceLine."Reserved Qty. (Base)");
          END;
        DATABASE::"Job Planning Line":
          BEGIN
            ForJobPlanningLine.CALCFIELDS("Reserved Quantity","Reserved Qty. (Base)");
            RemainingQty := ForJobPlanningLine."Remaining Qty." - ABS(ForJobPlanningLine."Reserved Quantity");
            RemainingQtyBase := ForJobPlanningLine."Remaining Qty. (Base)" - ABS(ForJobPlanningLine."Reserved Qty. (Base)");
          END;
        ELSE
          ERROR(Text003);
      END;
    END;

    LOCAL PROCEDURE FieldFilterNeeded@6(VAR ReservEntry@1000 : Record 337;Field@1001 : 'Lot No.,Serial No.') : Boolean;
    BEGIN
      EXIT(FieldFilterNeeded2(ReservEntry,Positive,Field));
    END;

    [External]
    PROCEDURE FieldFilterNeeded2@42(VAR ReservEntry@1000 : Record 337;SearchForSupply@1001 : Boolean;Field@1002 : 'Lot No.,Serial No.') : Boolean;
    VAR
      ReservEntry2@1003 : Record 337;
      FieldValue@1004 : Code[20];
    BEGIN
      FieldFilter := '';

      FieldValue := '';
      GetItemSetup(ReservEntry);
      CASE Field OF
        0:
          BEGIN
            IF NOT ItemTrackingCode."Lot Specific Tracking" THEN
              EXIT(FALSE);
            FieldValue := ReservEntry."Lot No.";
          END;
        1:
          BEGIN
            IF NOT ItemTrackingCode."SN Specific Tracking" THEN
              EXIT(FALSE);
            FieldValue := ReservEntry."Serial No.";
          END;
        ELSE
          ERROR(Text004);
      END;

      // The field "Lot No." is used a foundation for building up the filter:

      IF FieldValue <> '' THEN BEGIN
        IF SearchForSupply THEN // Demand
          ReservEntry2.SETRANGE("Lot No.",FieldValue)
        ELSE // Supply
          ReservEntry2.SETFILTER("Lot No.",'%1|%2',FieldValue,'');
        FieldFilter := ReservEntry2.GETFILTER("Lot No.");
      END ELSE // FieldValue = ''
        IF SearchForSupply THEN // Demand
          EXIT(FALSE)
        ELSE
          FieldFilter := STRSUBSTNO('''%1''','');

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE FilterPlanningComponent@119(AvailabilityDate@1000 : Date);
    BEGIN
      WITH CalcPlanningComponent DO BEGIN
        RESET;
        SETCURRENTKEY("Item No.","Variant Code","Location Code","Due Date");
        SETRANGE("Item No.",CalcReservEntry."Item No.");
        SETRANGE("Variant Code",CalcReservEntry."Variant Code");
        SETRANGE("Location Code",CalcReservEntry."Location Code");
        SETFILTER("Due Date",GetAvailabilityFilter(AvailabilityDate));
        IF Positive THEN
          SETFILTER("Net Quantity (Base)",'<0')
        ELSE
          SETFILTER("Net Quantity (Base)",'>0');
      END;
    END;

    [External]
    PROCEDURE GetFieldFilter@8() : Text[80];
    BEGIN
      EXIT(FieldFilter);
    END;

    [External]
    PROCEDURE GetAvailabilityFilter@24(AvailabilityDate@1000 : Date) : Text[80];
    BEGIN
      EXIT(GetAvailabilityFilter2(AvailabilityDate,Positive));
    END;

    LOCAL PROCEDURE GetAvailabilityFilter2@41(AvailabilityDate@1000 : Date;SearchForSupply@1001 : Boolean) : Text[80];
    VAR
      ReservEntry2@1002 : Record 337;
    BEGIN
      IF SearchForSupply THEN
        ReservEntry2.SETFILTER("Expected Receipt Date",'..%1',AvailabilityDate)
      ELSE
        ReservEntry2.SETFILTER("Expected Receipt Date",'>=%1',AvailabilityDate);

      EXIT(ReservEntry2.GETFILTER("Expected Receipt Date"));
    END;

    [External]
    PROCEDURE CopySign@14(FromValue@1000 : Decimal;VAR ToValue@1001 : Decimal);
    BEGIN
      IF FromValue * ToValue < 0 THEN
        ToValue := -ToValue;
    END;

    LOCAL PROCEDURE InitFilter@23(EntryID@1000 : Integer;AvailabilityDate@1001 : Date);
    BEGIN
      CASE EntryID OF
        1:
          BEGIN // Item Ledger Entry
            CalcItemLedgEntry.RESET;
            CalcItemLedgEntry.SETCURRENTKEY("Item No.",Open,"Variant Code",Positive,"Location Code");
            CalcItemLedgEntry.SETRANGE("Item No.",CalcReservEntry."Item No.");
            CalcItemLedgEntry.SETRANGE(Open,TRUE);
            CalcItemLedgEntry.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcItemLedgEntry.SETRANGE(Positive,Positive);
            CalcItemLedgEntry.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcItemLedgEntry.SETRANGE("Drop Shipment",FALSE);
            IF FieldFilterNeeded2(CalcReservEntry,Positive,0) THEN
              CalcItemLedgEntry.SETFILTER("Lot No.",GetFieldFilter);
            IF FieldFilterNeeded2(CalcReservEntry,Positive,1) THEN
              CalcItemLedgEntry.SETFILTER("Serial No.",GetFieldFilter);
          END;
        12,16:
          BEGIN // Purchase Line
            CalcPurchLine.RESET;
            CalcPurchLine.SETCURRENTKEY(
              "Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date");
            CalcPurchLine.SETRANGE("Document Type",EntryID - 11);
            CalcPurchLine.SETRANGE(Type,CalcPurchLine.Type::Item);
            CalcPurchLine.SETRANGE("No.",CalcReservEntry."Item No.");
            CalcPurchLine.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcPurchLine.SETRANGE("Drop Shipment",FALSE);
            CalcPurchLine.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcPurchLine.SETFILTER("Expected Receipt Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive AND (EntryID <> 16) THEN
              CalcPurchLine.SETFILTER("Quantity (Base)",'>0')
            ELSE
              CalcPurchLine.SETFILTER("Quantity (Base)",'<0');
            CalcPurchLine.SETRANGE("Job No.",' ');
          END;
        21:
          BEGIN // Requisition Line
            CalcReqLine.RESET;
            CalcReqLine.SETCURRENTKEY(
              Type,"No.","Variant Code","Location Code","Sales Order No.","Planning Line Origin","Due Date");
            CalcReqLine.SETRANGE(Type,CalcReqLine.Type::Item);
            CalcReqLine.SETRANGE("No.",CalcReservEntry."Item No.");
            CalcReqLine.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcReqLine.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcReqLine.SETRANGE("Sales Order No.",'');
            CalcReqLine.SETFILTER("Due Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive THEN
              CalcReqLine.SETFILTER("Quantity (Base)",'>0')
            ELSE
              CalcReqLine.SETFILTER("Quantity (Base)",'<0');
          END;
        31,32,36:
          BEGIN // Sales Line
            CalcSalesLine.RESET;
            CalcSalesLine.SETCURRENTKEY(
              "Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date");
            CalcSalesLine.SETRANGE("Document Type",EntryID - 31);
            CalcSalesLine.SETRANGE(Type,CalcSalesLine.Type::Item);
            CalcSalesLine.SETRANGE("No.",CalcReservEntry."Item No.");
            CalcSalesLine.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcSalesLine.SETRANGE("Drop Shipment",FALSE);
            CalcSalesLine.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcSalesLine.SETFILTER("Shipment Date",GetAvailabilityFilter(AvailabilityDate));
            IF EntryID = 36 THEN
              IF Positive THEN
                CalcSalesLine.SETFILTER("Quantity (Base)",'>0')
              ELSE
                CalcSalesLine.SETFILTER("Quantity (Base)",'<0')
            ELSE
              IF Positive THEN
                CalcSalesLine.SETFILTER("Quantity (Base)",'<0')
              ELSE
                CalcSalesLine.SETFILTER("Quantity (Base)",'>0');
            CalcSalesLine.SETRANGE("Job No.",' ');
          END;
        61,62,63,64:
          BEGIN // Prod. Order
            CalcProdOrderLine.RESET;
            CalcProdOrderLine.SETCURRENTKEY(Status,"Item No.","Variant Code","Location Code","Due Date");
            CalcProdOrderLine.SETRANGE(Status,EntryID - 61);
            CalcProdOrderLine.SETRANGE("Item No.",CalcReservEntry."Item No.");
            CalcProdOrderLine.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcProdOrderLine.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcProdOrderLine.SETFILTER("Due Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive THEN
              CalcProdOrderLine.SETFILTER("Remaining Qty. (Base)",'>0')
            ELSE
              CalcProdOrderLine.SETFILTER("Remaining Qty. (Base)",'<0');
          END;
        71,72,73,74:
          BEGIN // Prod. Order Component
            CalcProdOrderComp.RESET;
            CalcProdOrderComp.SETCURRENTKEY(Status,"Item No.","Variant Code","Location Code","Due Date");
            CalcProdOrderComp.SETRANGE(Status,EntryID - 71);
            CalcProdOrderComp.SETRANGE("Item No.",CalcReservEntry."Item No.");
            CalcProdOrderComp.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcProdOrderComp.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcProdOrderComp.SETFILTER("Due Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive THEN
              CalcProdOrderComp.SETFILTER("Remaining Qty. (Base)",'<0')
            ELSE
              CalcProdOrderComp.SETFILTER("Remaining Qty. (Base)",'>0');
          END;
        91:
          FilterPlanningComponent(AvailabilityDate);
        101:
          BEGIN // Transfer, Outbound
            CalcTransLine.RESET;
            CalcTransLine.SETCURRENTKEY("Transfer-from Code");
            CalcTransLine.SETRANGE("Item No.",CalcReservEntry."Item No.");
            CalcTransLine.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcTransLine.SETRANGE("Transfer-from Code",CalcReservEntry."Location Code");
            CalcTransLine.SETFILTER("Shipment Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive THEN
              CalcTransLine.SETFILTER("Outstanding Qty. (Base)",'<0')
            ELSE
              CalcTransLine.SETFILTER("Outstanding Qty. (Base)",'>0');
          END;
        102:
          BEGIN // Transfer, Inbound
            CalcTransLine.RESET;
            CalcTransLine.SETCURRENTKEY("Transfer-to Code");
            CalcTransLine.SETRANGE("Item No.",CalcReservEntry."Item No.");
            CalcTransLine.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcTransLine.SETRANGE("Transfer-to Code",CalcReservEntry."Location Code");
            CalcTransLine.SETFILTER("Receipt Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive THEN
              CalcTransLine.SETFILTER("Outstanding Qty. (Base)",'>0')
            ELSE
              CalcTransLine.SETFILTER("Outstanding Qty. (Base)",'<0');
          END;
        110:
          BEGIN // Service Line
            CalcServiceLine.RESET;
            CalcServiceLine.SETCURRENTKEY(Type,"No.","Variant Code","Location Code","Needed by Date","Document Type");
            CalcServiceLine.SETRANGE(Type,CalcServiceLine.Type::Item);
            CalcServiceLine.SETRANGE("No.",CalcReservEntry."Item No.");
            CalcServiceLine.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcServiceLine.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcServiceLine.SETFILTER("Needed by Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive THEN
              CalcServiceLine.SETFILTER("Quantity (Base)",'<0')
            ELSE
              CalcServiceLine.SETFILTER("Quantity (Base)",'>0');
            CalcServiceLine.SETRANGE("Job No.",' ');
          END;
        133:
          BEGIN // Job Planning Line
            CalcJobPlanningLine.RESET;
            CalcJobPlanningLine.SETCURRENTKEY(Status,Type,"No.","Variant Code","Location Code","Planning Date");
            CalcJobPlanningLine.SETRANGE(Status,EntryID - 131);
            CalcJobPlanningLine.SETRANGE(Type,CalcJobPlanningLine.Type::Item);
            CalcJobPlanningLine.SETRANGE("No.",CalcReservEntry."Item No.");
            CalcJobPlanningLine.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcJobPlanningLine.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcJobPlanningLine.SETFILTER("Planning Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive THEN
              CalcJobPlanningLine.SETFILTER("Quantity (Base)",'<0')
            ELSE
              CalcJobPlanningLine.SETFILTER("Quantity (Base)",'>0');
          END;
        141,142:
          BEGIN // Assembly Header
            CalcAssemblyHeader.RESET;
            CalcAssemblyHeader.SETCURRENTKEY(
              "Document Type","Item No.","Variant Code","Location Code","Due Date");
            CalcAssemblyHeader.SETRANGE("Document Type",EntryID - 141);
            CalcAssemblyHeader.SETRANGE("Item No.",CalcReservEntry."Item No.");
            CalcAssemblyHeader.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcAssemblyHeader.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcAssemblyHeader.SETFILTER("Due Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive THEN
              CalcAssemblyHeader.SETFILTER("Remaining Quantity (Base)",'>0')
            ELSE
              CalcAssemblyHeader.SETFILTER("Remaining Quantity (Base)",'<0');
          END;
        151,152:
          BEGIN // Assembly Line
            CalcAssemblyLine.RESET;
            CalcAssemblyLine.SETCURRENTKEY(
              "Document Type",Type,"No.","Variant Code","Location Code","Due Date");
            CalcAssemblyLine.SETRANGE("Document Type",EntryID - 151);
            CalcAssemblyLine.SETRANGE(Type,CalcAssemblyLine.Type::Item);
            CalcAssemblyLine.SETRANGE("No.",CalcReservEntry."Item No.");
            CalcAssemblyLine.SETRANGE("Variant Code",CalcReservEntry."Variant Code");
            CalcAssemblyLine.SETRANGE("Location Code",CalcReservEntry."Location Code");
            CalcAssemblyLine.SETFILTER("Due Date",GetAvailabilityFilter(AvailabilityDate));
            IF Positive THEN
              CalcAssemblyLine.SETFILTER("Remaining Quantity (Base)",'<0')
            ELSE
              CalcAssemblyLine.SETFILTER("Remaining Quantity (Base)",'>0');
          END;
      END;
    END;

    LOCAL PROCEDURE SetValueArray@25(EntryStatus@1000 : 'Reservation,Tracking,Simulation') : Integer;
    BEGIN
      CLEAR(ValueArray);
      CASE EntryStatus OF
        0:
          BEGIN // Reservation
            ValueArray[1] := 1;
            ValueArray[2] := 12;
            ValueArray[3] := 16;
            ValueArray[4] := 32;
            ValueArray[5] := 36;
            ValueArray[6] := 63;
            ValueArray[7] := 64;
            ValueArray[8] := 73;
            ValueArray[9] := 74;
            ValueArray[10] := 101;
            ValueArray[11] := 102;
            ValueArray[12] := 110;
            ValueArray[13] := 133;
            ValueArray[14] := 142;
            ValueArray[15] := 152;
            EXIT(15);
          END;
        1:
          BEGIN // Order Tracking
            ValueArray[1] := 1;
            ValueArray[2] := 12;
            ValueArray[3] := 16;
            ValueArray[4] := 21;
            ValueArray[5] := 32;
            ValueArray[6] := 36;
            ValueArray[7] := 62;
            ValueArray[8] := 63;
            ValueArray[9] := 64;
            ValueArray[10] := 72;
            ValueArray[11] := 73;
            ValueArray[12] := 74;
            ValueArray[13] := 101;
            ValueArray[14] := 102;
            ValueArray[15] := 110;
            ValueArray[16] := 133;
            ValueArray[17] := 142;
            ValueArray[18] := 152;
            EXIT(18);
          END;
        2:
          BEGIN // Simulation order tracking
            ValueArray[1] := 31;
            ValueArray[2] := 61;
            ValueArray[3] := 71;
            EXIT(3);
          END;
        3:
          BEGIN // Item Tracking
            ValueArray[1] := 1;
            ValueArray[2] := 6500;
            EXIT(2);
          END;
      END;
    END;

    [External]
    PROCEDURE ClearSurplus@36();
    VAR
      ReservEntry2@1000 : Record 337;
    BEGIN
      CalcReservEntry.TESTFIELD("Source Type");
      ReservEntry2 := CalcReservEntry;
      ReservEntry2.SetPointerFilter;
      ReservEntry2.SETRANGE("Reservation Status",ReservEntry2."Reservation Status"::Surplus);
      // Item Tracking
      IF ItemTrackingHandling = ItemTrackingHandling::None THEN
        ReservEntry2.SetTrackingFilter('','');

      IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN BEGIN
        ReservEntry2.Lock;
        IF NOT ReservEntry2.FINDSET THEN
          EXIT;
        ActionMessageEntry.RESET;
        ActionMessageEntry.SETCURRENTKEY("Reservation Entry");
        REPEAT
          ActionMessageEntry.SETRANGE("Reservation Entry",ReservEntry2."Entry No.");
          ActionMessageEntry.DELETEALL;
        UNTIL ReservEntry2.NEXT = 0;
      END;

      ReservEntry2.SETRANGE(
        "Reservation Status",ReservEntry2."Reservation Status"::Surplus,ReservEntry2."Reservation Status"::Prospect);
      ReservEntry2.DELETEALL;
    END;

    LOCAL PROCEDURE QuantityTracked@28(VAR ReservEntry@1000 : Record 337) : Decimal;
    VAR
      ReservEntry2@1001 : Record 337;
      QtyTracked@1004 : Decimal;
    BEGIN
      ReservEntry2 := ReservEntry;
      ReservEntry2.SetPointerFilter;
      ReservEntry.COPYFILTER("Serial No.",ReservEntry2."Serial No.");
      ReservEntry.COPYFILTER("Lot No.",ReservEntry2."Lot No.");
      IF ReservEntry2.FINDFIRST THEN BEGIN
        ReservEntry.Binding := ReservEntry2.Binding;
        ReservEntry2.CALCSUMS("Quantity (Base)");
        QtyTracked := ReservEntry2."Quantity (Base)";
      END;
      EXIT(QtyTracked);
    END;

    LOCAL PROCEDURE QuantityTracked2@57(VAR ReservEntry@1000 : Record 337) : Decimal;
    VAR
      ReservEntry2@1001 : Record 337;
      QtyTracked@1004 : Decimal;
    BEGIN
      ReservEntry2 := ReservEntry;
      ReservEntry2.SetPointerFilter;
      ReservEntry2.SetTrackingFilterFromReservEntry(ReservEntry);
      ReservEntry2.SETRANGE("Reservation Status",
        ReservEntry2."Reservation Status"::Tracking,ReservEntry2."Reservation Status"::Prospect);
      IF NOT ReservEntry2.ISEMPTY THEN BEGIN
        ReservEntry2.CALCSUMS("Quantity (Base)");
        QtyTracked := ReservEntry2."Quantity (Base)";
      END;
      EXIT(QtyTracked);
    END;

    [External]
    PROCEDURE AutoTrack@27(TotalQty@1000 : Decimal);
    VAR
      SurplusEntry@1001 : Record 337;
      DummyEntry@1002 : Record 337;
      AvailabilityDate@1003 : Date;
      QtyToTrack@1004 : Decimal;
    BEGIN
      CalcReservEntry.TESTFIELD("Source Type");
      IF CalcReservEntry."Item No." = '' THEN
        EXIT;

      GetItemSetup(CalcReservEntry);
      IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::None THEN
        EXIT;

      IF CalcReservEntry."Source Type" IN [DATABASE::"Sales Line",DATABASE::"Purchase Line",DATABASE::"Service Line"] THEN
        IF NOT (CalcReservEntry."Source Subtype" IN [1,5]) THEN
          EXIT; // Only order, return order

      IF CalcReservEntry."Source Type" IN [DATABASE::"Prod. Order Line",DATABASE::"Prod. Order Component"]
      THEN
        IF CalcReservEntry."Source Subtype" = 0 THEN
          EXIT; // Not simulation

      CalcReservEntry.Lock;

      QtyToTrack := CreateReservEntry.SignFactor(CalcReservEntry) * TotalQty - QuantityTracked(CalcReservEntry);

      IF QtyToTrack = 0 THEN BEGIN
        UpdateDating;
        EXIT;
      END;

      QtyToTrack := MatchSurplus(CalcReservEntry,SurplusEntry,QtyToTrack,Positive,AvailabilityDate,Item."Order Tracking Policy");

      // Make residual surplus record:
      IF QtyToTrack <> 0 THEN BEGIN
        IF CurrentBindingIsSet THEN
          MakeConnection(CalcReservEntry,SurplusEntry,QtyToTrack,2,AvailabilityDate,CurrentBinding)
        ELSE
          MakeConnection(CalcReservEntry,SurplusEntry,QtyToTrack,2,AvailabilityDate,CalcReservEntry.Binding);
        IF Item."Order Tracking Policy" = Item."Order Tracking Policy"::"Tracking & Action Msg." THEN BEGIN // Issue Action Message
          CreateReservEntry.GetLastEntry(SurplusEntry); // Get the surplus-entry just inserted
          IssueActionMessage(SurplusEntry,TRUE,DummyEntry);
        END;
      END ELSE
        UpdateDating;
    END;

    [External]
    PROCEDURE MatchSurplus@40(VAR ReservEntry@1000 : Record 337;VAR SurplusEntry@1001 : Record 337;QtyToTrack@1002 : Decimal;SearchForSupply@1003 : Boolean;VAR AvailabilityDate@1004 : Date;TrackingPolicy@1005 : 'None,Tracking Only,Tracking & Action Msg.') : Decimal;
    VAR
      ReservEntry2@1009 : Record 337;
      Search@1006 : Text[1];
      NextStep@1007 : Integer;
      ReservationStatus@1008 : 'Reservation,Tracking';
    BEGIN
      IF QtyToTrack = 0 THEN
        EXIT;

      ReservEntry.Lock;
      SurplusEntry.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Reservation Status",
        "Shipment Date","Expected Receipt Date","Serial No.","Lot No.");
      SurplusEntry.SETRANGE("Item No.",ReservEntry."Item No.");
      SurplusEntry.SETRANGE("Variant Code",ReservEntry."Variant Code");
      SurplusEntry.SETRANGE("Location Code",ReservEntry."Location Code");
      SurplusEntry.SETRANGE("Reservation Status",SurplusEntry."Reservation Status"::Surplus);
      IF SearchForSupply THEN BEGIN
        AvailabilityDate := ReservEntry."Shipment Date";
        Search := '+';
        NextStep := -1;
        SurplusEntry.SETFILTER("Expected Receipt Date",GetAvailabilityFilter2(AvailabilityDate,SearchForSupply));
        SurplusEntry.SETFILTER("Quantity (Base)",'>0');
      END ELSE BEGIN
        AvailabilityDate := ReservEntry."Expected Receipt Date";
        Search := '-';
        NextStep := 1;
        SurplusEntry.SETFILTER("Shipment Date",GetAvailabilityFilter2(AvailabilityDate,SearchForSupply));
        SurplusEntry.SETFILTER("Quantity (Base)",'<0')
      END;
      IF FieldFilterNeeded2(ReservEntry,SearchForSupply,0) THEN
        SurplusEntry.SETFILTER("Lot No.",GetFieldFilter);
      IF FieldFilterNeeded2(ReservEntry,SearchForSupply,1) THEN
        SurplusEntry.SETFILTER("Serial No.",GetFieldFilter);
      IF SurplusEntry.FIND(Search) THEN
        REPEAT
          ReservationStatus := ReservationStatus::Tracking;
          IF ABS(SurplusEntry."Quantity (Base)") <= ABS(QtyToTrack) THEN BEGIN
            ReservEntry2 := SurplusEntry;
            MakeConnection(ReservEntry,SurplusEntry,-SurplusEntry."Quantity (Base)",ReservationStatus,
              AvailabilityDate,SurplusEntry.Binding);
            QtyToTrack := QtyToTrack + SurplusEntry."Quantity (Base)";
            SurplusEntry := ReservEntry2;
            SurplusEntry.DELETE;
            IF TrackingPolicy = TrackingPolicy::"Tracking & Action Msg." THEN
              ModifyActionMessage(SurplusEntry."Entry No.",0,TRUE); // Delete related Action Message
          END ELSE BEGIN
            SurplusEntry.VALIDATE("Quantity (Base)",SurplusEntry."Quantity (Base)" + QtyToTrack);
            SurplusEntry.MODIFY;
            MakeConnection(ReservEntry,SurplusEntry,QtyToTrack,ReservationStatus,AvailabilityDate,SurplusEntry.Binding);
            IF TrackingPolicy = TrackingPolicy::"Tracking & Action Msg." THEN
              ModifyActionMessage(SurplusEntry."Entry No.",QtyToTrack,FALSE); // Modify related Action Message
            QtyToTrack := 0;
          END;
        UNTIL (SurplusEntry.NEXT(NextStep) = 0) OR (QtyToTrack = 0);

      EXIT(QtyToTrack);
    END;

    LOCAL PROCEDURE MakeConnection@26(VAR FromReservEntry@1000 : Record 337;VAR ToReservEntry@1001 : Record 337;Quantity@1002 : Decimal;ReservationStatus@1003 : 'Reservation,Tracking,Surplus';AvailabilityDate@1004 : Date;Binding@1005 : ',Order-to-Order');
    VAR
      sign@1007 : Integer;
    BEGIN
      IF Quantity < 0 THEN
        ToReservEntry."Shipment Date" := AvailabilityDate
      ELSE
        ToReservEntry."Expected Receipt Date" := AvailabilityDate;

      CreateReservEntry.SetBinding(Binding);

      IF FromReservEntry."Planning Flexibility" <> FromReservEntry."Planning Flexibility"::Unlimited THEN
        CreateReservEntry.SetPlanningFlexibility(FromReservEntry."Planning Flexibility");

      sign := CreateReservEntry.SignFactor(FromReservEntry);
      CreateReservEntry.CreateReservEntryFor(
        FromReservEntry."Source Type",FromReservEntry."Source Subtype",FromReservEntry."Source ID",
        FromReservEntry."Source Batch Name",FromReservEntry."Source Prod. Order Line",FromReservEntry."Source Ref. No.",
        FromReservEntry."Qty. per Unit of Measure",
        0,sign * Quantity,
        FromReservEntry."Serial No.",FromReservEntry."Lot No.");
      CreateReservEntry.CreateReservEntryFrom(
        ToReservEntry."Source Type",ToReservEntry."Source Subtype",ToReservEntry."Source ID",ToReservEntry."Source Batch Name",
        ToReservEntry."Source Prod. Order Line",ToReservEntry."Source Ref. No.",ToReservEntry."Qty. per Unit of Measure",
        ToReservEntry."Serial No.",ToReservEntry."Lot No.");
      CreateReservEntry.SetApplyFromEntryNo(FromReservEntry."Appl.-from Item Entry");
      CreateReservEntry.SetApplyToEntryNo(FromReservEntry."Appl.-to Item Entry");
      CreateReservEntry.CreateEntry(
        FromReservEntry."Item No.",FromReservEntry."Variant Code",FromReservEntry."Location Code",
        FromReservEntry.Description,ToReservEntry."Expected Receipt Date",ToReservEntry."Shipment Date",0,ReservationStatus);
    END;

    [External]
    PROCEDURE ModifyUnitOfMeasure@29();
    BEGIN
      ReservEngineMgt.ModifyUnitOfMeasure(CalcReservEntry,CalcReservEntry."Qty. per Unit of Measure");
    END;

    [External]
    PROCEDURE MakeRoomForReservation@66(VAR ReservEntry@1000 : Record 337);
    VAR
      ReservEntry2@1001 : Record 337;
      TotalQuantity@1002 : Decimal;
    BEGIN
      TotalQuantity := SourceQuantity(ReservEntry,FALSE);
      ReservEntry2 := ReservEntry;
      ReservEntry2.SetPointerFilter;
      ItemTrackingHandling := ItemTrackingHandling::Match;
      DeleteReservEntries2(FALSE,TotalQuantity - (ReservEntry."Quantity (Base)" * CreateReservEntry.SignFactor(ReservEntry)),
        ReservEntry2);
    END;

    LOCAL PROCEDURE SaveTrackingSpecification@60(VAR ReservEntry@1000 : Record 337;QtyReleased@1001 : Decimal);
    BEGIN
      // Used when creating reservations.
      IF ItemTrackingHandling = ItemTrackingHandling::None THEN
        EXIT;
      IF NOT ReservEntry.TrackingExists THEN
        EXIT;
      TempTrackingSpecification.SetTrackingFilterFromReservEntry(ReservEntry);
      IF TempTrackingSpecification.FINDSET THEN BEGIN
        TempTrackingSpecification.VALIDATE("Quantity (Base)",
          TempTrackingSpecification."Quantity (Base)" + QtyReleased);
        TempTrackingSpecification.MODIFY;
      END ELSE BEGIN
        TempTrackingSpecification.TRANSFERFIELDS(ReservEntry);
        TempTrackingSpecification.VALIDATE("Quantity (Base)",QtyReleased);
        TempTrackingSpecification.INSERT;
      END;
      TempTrackingSpecification.RESET;
    END;

    [External]
    PROCEDURE CollectTrackingSpecification@64(VAR TargetTrackingSpecification@1001 : TEMPORARY Record 336) : Boolean;
    BEGIN
      // Used when creating reservations.
      TempTrackingSpecification.RESET;
      TargetTrackingSpecification.RESET;

      IF NOT TempTrackingSpecification.FINDSET THEN
        EXIT(FALSE);

      REPEAT
        TargetTrackingSpecification := TempTrackingSpecification;
        TargetTrackingSpecification.INSERT;
      UNTIL TempTrackingSpecification.NEXT = 0;

      TempTrackingSpecification.DELETEALL;

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE SourceQuantity@32(VAR ReservEntry@1000 : Record 337;SetAsCurrent@1001 : Boolean) : Decimal;
    BEGIN
      EXIT(GetSourceRecordValue(ReservEntry,SetAsCurrent,0));
    END;

    [External]
    PROCEDURE GetSourceRecordValue@62(VAR ReservEntry@1000 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1012 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    BEGIN
      WITH ReservEntry DO
        CASE "Source Type" OF
          DATABASE::"Item Ledger Entry":
            EXIT(GetSourceItemLedgEntryValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Sales Line":
            EXIT(GetSourceSalesLineValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Requisition Line":
            EXIT(GetSourceReqLineValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Purchase Line":
            EXIT(GetSourcePurchLineValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Item Journal Line":
            EXIT(GetSourceItemJnlLineValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Job Journal Line":
            EXIT(GetSourceJobJnlLineValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Prod. Order Line":
            EXIT(GetSourceProdOrderLineValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Prod. Order Component":
            EXIT(GetSourceProdOrderCompValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Assembly Header":
            EXIT(GetSourceAsmHeaderValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Assembly Line":
            EXIT(GetSourceAsmLineValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Planning Component":
            EXIT(GetSourcePlanningCompValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Transfer Line":
            EXIT(GetSourceTransLineValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Service Line":
            EXIT(GetSourceServLineValue(ReservEntry,SetAsCurrent,ReturnOption));
          DATABASE::"Job Planning Line":
            EXIT(GetSourceJobPlanningLineValue(ReservEntry,SetAsCurrent,ReturnOption));
        END;
    END;

    LOCAL PROCEDURE GetSourceItemLedgEntryValue@91(VAR ReservEntry@1003 : Record 337;SetAsCurrent@1002 : Boolean;ReturnOption@1001 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      ItemLedgEntry@1000 : Record 32;
    BEGIN
      ItemLedgEntry.GET(ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetItemLedgEntry(ItemLedgEntry);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(ItemLedgEntry."Remaining Quantity");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(ItemLedgEntry.Quantity);
      END;
    END;

    LOCAL PROCEDURE GetSourceSalesLineValue@92(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      SalesLine@1003 : Record 37;
    BEGIN
      SalesLine.GET(ReservEntry."Source Subtype",ReservEntry."Source ID",ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetSalesLine(SalesLine);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(SalesLine."Outstanding Qty. (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(SalesLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceReqLineValue@93(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      ReqLine@1003 : Record 246;
    BEGIN
      ReqLine.GET(ReservEntry."Source ID",ReservEntry."Source Batch Name",ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetReqLine(ReqLine);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(ReqLine."Net Quantity (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(ReqLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourcePurchLineValue@94(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      PurchLine@1003 : Record 39;
    BEGIN
      PurchLine.GET(ReservEntry."Source Subtype",ReservEntry."Source ID",ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetPurchLine(PurchLine);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(PurchLine."Outstanding Qty. (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(PurchLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceItemJnlLineValue@95(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      ItemJnlLine@1003 : Record 83;
    BEGIN
      ItemJnlLine.GET(ReservEntry."Source ID",ReservEntry."Source Batch Name",ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetItemJnlLine(ItemJnlLine);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(ItemJnlLine."Quantity (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(ItemJnlLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceJobJnlLineValue@96(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      JobJnlLine@1003 : Record 210;
    BEGIN
      JobJnlLine.GET(ReservEntry."Source ID",ReservEntry."Source Batch Name",ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetJobJnlLine(JobJnlLine);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(JobJnlLine."Quantity (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(JobJnlLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceProdOrderLineValue@98(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      ProdOrderLine@1003 : Record 5406;
    BEGIN
      ProdOrderLine.GET(ReservEntry."Source Subtype",ReservEntry."Source ID",ReservEntry."Source Prod. Order Line");
      IF SetAsCurrent THEN
        SetProdOrderLine(ProdOrderLine);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(ProdOrderLine."Remaining Qty. (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(ProdOrderLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceProdOrderCompValue@99(VAR ReservEntry@1003 : Record 337;SetAsCurrent@1002 : Boolean;ReturnOption@1001 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      ProdOrderComp@1000 : Record 5407;
    BEGIN
      ProdOrderComp.GET(
        ReservEntry."Source Subtype",
        ReservEntry."Source ID",
        ReservEntry."Source Prod. Order Line",
        ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetProdOrderComponent(ProdOrderComp);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(ProdOrderComp."Remaining Qty. (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(ProdOrderComp."Expected Qty. (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceAsmHeaderValue@116(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      AssemblyHeader@1003 : Record 900;
    BEGIN
      AssemblyHeader.GET(ReservEntry."Source Subtype",ReservEntry."Source ID");
      IF SetAsCurrent THEN
        SetAssemblyHeader(AssemblyHeader);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(AssemblyHeader."Remaining Quantity (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(AssemblyHeader."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceAsmLineValue@115(VAR ReservEntry@1003 : Record 337;SetAsCurrent@1002 : Boolean;ReturnOption@1001 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      AssemblyLine@1000 : Record 901;
    BEGIN
      AssemblyLine.GET(ReservEntry."Source Subtype",ReservEntry."Source ID",ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetAssemblyLine(AssemblyLine);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(AssemblyLine."Remaining Quantity (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(AssemblyLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourcePlanningCompValue@100(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      PlanningComponent@1003 : Record 99000829;
    BEGIN
      PlanningComponent.GET(
        ReservEntry."Source ID",ReservEntry."Source Batch Name",
        ReservEntry."Source Prod. Order Line",ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetPlanningComponent(PlanningComponent);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(PlanningComponent."Net Quantity (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(PlanningComponent."Expected Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceTransLineValue@101(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      TransLine@1003 : Record 5741;
    BEGIN
      TransLine.GET(ReservEntry."Source ID",ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetTransferLine(TransLine,ReservEntry."Source Subtype");
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(TransLine."Outstanding Qty. (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(TransLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceServLineValue@102(VAR ReservEntry@1002 : Record 337;SetAsCurrent@1001 : Boolean;ReturnOption@1000 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      ServLine@1003 : Record 5902;
    BEGIN
      ServLine.GET(ReservEntry."Source Subtype",ReservEntry."Source ID",ReservEntry."Source Ref. No.");
      IF SetAsCurrent THEN
        SetServLine(ServLine);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(ServLine."Outstanding Qty. (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(ServLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetSourceJobPlanningLineValue@103(VAR ReservEntry@1001 : Record 337;SetAsCurrent@1002 : Boolean;ReturnOption@1003 : 'Net Qty. (Base),Gross Qty. (Base)') : Decimal;
    VAR
      JobPlanningLine@1000 : Record 1003;
    BEGIN
      JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
      JobPlanningLine.SETRANGE("Job Contract Entry No.",ReservEntry."Source Ref. No.");
      JobPlanningLine.FINDFIRST;
      IF SetAsCurrent THEN
        SetJobPlanningLine(JobPlanningLine);
      CASE ReturnOption OF
        ReturnOption::"Net Qty. (Base)":
          EXIT(JobPlanningLine."Remaining Qty. (Base)");
        ReturnOption::"Gross Qty. (Base)":
          EXIT(JobPlanningLine."Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE GetItemSetup@33(VAR ReservEntry@1000 : Record 337);
    BEGIN
      IF ReservEntry."Item No." <> Item."No." THEN BEGIN
        Item.GET(ReservEntry."Item No.");
        IF Item."Item Tracking Code" <> '' THEN
          ItemTrackingCode.GET(Item."Item Tracking Code")
        ELSE
          ItemTrackingCode.INIT;
        GetPlanningParameters.AtSKU(SKU,ReservEntry."Item No.",
          ReservEntry."Variant Code",ReservEntry."Location Code");
        MfgSetup.GET;
      END;
    END;

    [External]
    PROCEDURE MarkReservConnection@35(VAR ReservEntry@1001 : Record 337;TargetReservEntry@1002 : Record 337) ReservedQuantity@1000 : Decimal;
    VAR
      ReservEntry2@1003 : Record 337;
      SignFactor@1004 : Integer;
    BEGIN
      IF NOT ReservEntry.FINDSET THEN
        EXIT;
      SignFactor := CreateReservEntry.SignFactor(ReservEntry);

      REPEAT
        IF ReservEntry2.GET(ReservEntry."Entry No.",NOT ReservEntry.Positive) THEN
          IF ((ReservEntry2."Source Type" = TargetReservEntry."Source Type") AND
              (ReservEntry2."Source Subtype" = TargetReservEntry."Source Subtype") AND
              (ReservEntry2."Source ID" = TargetReservEntry."Source ID") AND
              (ReservEntry2."Source Batch Name" = TargetReservEntry."Source Batch Name") AND
              (ReservEntry2."Source Prod. Order Line" = TargetReservEntry."Source Prod. Order Line") AND
              (ReservEntry2."Source Ref. No." = TargetReservEntry."Source Ref. No."))
          THEN BEGIN
            ReservEntry.MARK(TRUE);
            ReservedQuantity += ReservEntry."Quantity (Base)" * SignFactor;
          END;
      UNTIL ReservEntry.NEXT = 0;
      ReservEntry.MARKEDONLY(TRUE);
    END;

    LOCAL PROCEDURE IsSpecialOrder@121(PurchasingCode@1000 : Code[10]) : Boolean;
    VAR
      Purchasing@1001 : Record 5721;
    BEGIN
      IF PurchasingCode <> '' THEN
        IF Purchasing.GET(PurchasingCode) THEN
          EXIT(Purchasing."Special Order");

      EXIT(FALSE);
    END;

    [External]
    PROCEDURE IssueActionMessage@37(VAR SurplusEntry@1000 : Record 337;UseGlobalSettings@1001 : Boolean;AllDeletedEntry@1002 : Record 337);
    VAR
      ReservEntry@1003 : Record 337;
      ReservEntry2@1004 : Record 337;
      ReservEntry3@1005 : Record 337;
      ActionMessageEntry2@1006 : Record 99000849;
      NextEntryNo@1007 : Integer;
      FirstDate@1008 : Date;
      Found@1009 : Boolean;
      FreeBinding@1010 : Boolean;
      NoMoreData@1011 : Boolean;
      DateFormula@1012 : DateFormula;
    BEGIN
      SurplusEntry.TESTFIELD("Quantity (Base)");
      IF SurplusEntry."Reservation Status" < SurplusEntry."Reservation Status"::Surplus THEN
        SurplusEntry.FIELDERROR("Reservation Status");
      SurplusEntry.CALCFIELDS("Action Message Adjustment");
      IF SurplusEntry."Quantity (Base)" + SurplusEntry."Action Message Adjustment" = 0 THEN
        EXIT;

      ActionMessageEntry.RESET;

      IF ActionMessageEntry.FINDLAST THEN
        NextEntryNo := ActionMessageEntry."Entry No." + 1
      ELSE
        NextEntryNo := 1;

      ActionMessageEntry.INIT;
      ActionMessageEntry."Entry No." := NextEntryNo;

      IF SurplusEntry."Quantity (Base)" > 0 THEN BEGIN // Supply: Issue AM directly
        IF SurplusEntry."Planning Flexibility" = SurplusEntry."Planning Flexibility"::None THEN
          EXIT;
        IF NOT (SurplusEntry."Source Type" IN [DATABASE::"Prod. Order Line",DATABASE::"Purchase Line"])
        THEN
          EXIT;

        ActionMessageEntry.TransferFromReservEntry(SurplusEntry);
        ActionMessageEntry.Quantity := -(SurplusEntry."Quantity (Base)" + SurplusEntry."Action Message Adjustment");
        ActionMessageEntry.Type := ActionMessageEntry.Type::New;
        ReservEntry2 := SurplusEntry;
      END ELSE BEGIN // Demand: Find supply and issue AM
        CASE SurplusEntry.Binding OF
          SurplusEntry.Binding::" ":
            BEGIN
              IF UseGlobalSettings THEN BEGIN
                ReservEntry.COPY(SurplusEntry); // Copy filter and sorting
                ReservEntry.SETRANGE("Reservation Status"); // Remove filter on Reservation Status
              END ELSE BEGIN
                GetItemSetup(SurplusEntry);
                Positive := TRUE;
                ReservEntry.SETCURRENTKEY(
                  "Item No.","Variant Code","Location Code","Reservation Status",
                  "Shipment Date","Expected Receipt Date","Serial No.","Lot No.");
                ReservEntry.SETRANGE("Item No.",SurplusEntry."Item No.");
                ReservEntry.SETRANGE("Variant Code",SurplusEntry."Variant Code");
                ReservEntry.SETRANGE("Location Code",SurplusEntry."Location Code");
                ReservEntry.SETFILTER("Expected Receipt Date",GetAvailabilityFilter(SurplusEntry."Shipment Date"));
                IF FieldFilterNeeded(SurplusEntry,0) THEN
                  ReservEntry.SETFILTER("Lot No.",GetFieldFilter);
                IF FieldFilterNeeded(SurplusEntry,1) THEN
                  ReservEntry.SETFILTER("Serial No.",GetFieldFilter);
                ReservEntry.SETRANGE(Positive,TRUE);
              END;
              ReservEntry.SETRANGE(Binding,ReservEntry.Binding::" ");
              ReservEntry.SETRANGE("Planning Flexibility",ReservEntry."Planning Flexibility"::Unlimited);
              ReservEntry.SETFILTER("Source Type",'=%1|=%2',DATABASE::"Purchase Line",DATABASE::"Prod. Order Line");
            END;
          SurplusEntry.Binding::"Order-to-Order":
            BEGIN
              ReservEntry3 := SurplusEntry;
              ReservEntry3.SetPointerFilter;
              ReservEntry3.SETRANGE(
                "Reservation Status",ReservEntry3."Reservation Status"::Reservation,ReservEntry3."Reservation Status"::Tracking);
              ReservEntry3.SETRANGE(Binding,ReservEntry3.Binding::"Order-to-Order");
              IF ReservEntry3.FINDFIRST THEN BEGIN
                ReservEntry3.GET(ReservEntry3."Entry No.",NOT ReservEntry3.Positive);
                ReservEntry := ReservEntry3;
                ReservEntry.SETRECFILTER;
                Found := TRUE;
              END ELSE BEGIN
                Found := FALSE;
                FreeBinding := TRUE;
              END;
            END;
        END;

        ActionMessageEntry.Quantity := -(SurplusEntry."Quantity (Base)" + SurplusEntry."Action Message Adjustment");

        IF NOT FreeBinding THEN
          IF ReservEntry.FIND('+') THEN BEGIN
            IF AllDeletedEntry."Entry No." > 0 THEN // The supply record has been deleted and cannot be reused.
              REPEAT
                Found := NOT (
                              (AllDeletedEntry."Source Type" = ReservEntry."Source Type") AND
                              (AllDeletedEntry."Source Subtype" = ReservEntry."Source Subtype") AND
                              (AllDeletedEntry."Source ID" = ReservEntry."Source ID") AND
                              (AllDeletedEntry."Source Batch Name" = ReservEntry."Source Batch Name") AND
                              (AllDeletedEntry."Source Prod. Order Line" = ReservEntry."Source Prod. Order Line") AND
                              (AllDeletedEntry."Source Ref. No." = ReservEntry."Source Ref. No."));
                IF NOT Found THEN
                  NoMoreData := ReservEntry.NEXT(-1) = 0;
              UNTIL Found OR NoMoreData
            ELSE
              Found := TRUE;
          END;

        IF Found THEN BEGIN
          ActionMessageEntry.TransferFromReservEntry(ReservEntry);
          ActionMessageEntry.Type := ActionMessageEntry.Type::"Change Qty.";
          ReservEntry2 := ReservEntry;
        END ELSE BEGIN
          ActionMessageEntry."Location Code" := SurplusEntry."Location Code";
          ActionMessageEntry."Variant Code" := SurplusEntry."Variant Code";
          ActionMessageEntry."Item No." := SurplusEntry."Item No.";

          CASE SKU."Replenishment System" OF
            SKU."Replenishment System"::Purchase:
              ActionMessageEntry."Source Type" := DATABASE::"Purchase Line";
            SKU."Replenishment System"::"Prod. Order":
              ActionMessageEntry."Source Type" := DATABASE::"Prod. Order Line";
            SKU."Replenishment System"::Transfer:
              ActionMessageEntry."Source Type" := DATABASE::"Transfer Line";
            SKU."Replenishment System"::Assembly:
              ActionMessageEntry."Source Type" := DATABASE::"Assembly Header";
          END;

          ActionMessageEntry.Type := ActionMessageEntry.Type::New;
        END;
        ActionMessageEntry."Reservation Entry" := SurplusEntry."Entry No.";
      END;

      ReservEntry2.SetPointerFilter;
      ReservEntry2.SETRANGE(
        "Reservation Status",ReservEntry2."Reservation Status"::Reservation,ReservEntry2."Reservation Status"::Tracking);

      IF ReservEntry2."Source Type" <> DATABASE::"Item Ledger Entry" THEN
        IF ReservEntry2.FINDFIRST THEN BEGIN
          FirstDate := FindDate(ReservEntry2,0,TRUE);
          IF FirstDate <> 0D THEN BEGIN
            IF (FORMAT(MfgSetup."Default Dampener Period") = '') OR
               ((ReservEntry2.Binding = ReservEntry2.Binding::"Order-to-Order") AND
                (ReservEntry2."Reservation Status" = ReservEntry2."Reservation Status"::Reservation))
            THEN
              EVALUATE(MfgSetup."Default Dampener Period",'<0D>');

            EVALUATE(DateFormula,STRSUBSTNO('%1%2','-',FORMAT(MfgSetup."Default Dampener Period")));
            IF CALCDATE(DateFormula,FirstDate) > ReservEntry2."Expected Receipt Date" THEN BEGIN
              ActionMessageEntry2.SETCURRENTKEY(
                "Source Type","Source Subtype","Source ID","Source Batch Name","Source Prod. Order Line","Source Ref. No.");
              ActionMessageEntry2.SETRANGE("Source Type",ActionMessageEntry."Source Type");
              ActionMessageEntry2.SETRANGE("Source Subtype",ActionMessageEntry."Source Subtype");
              ActionMessageEntry2.SETRANGE("Source ID",ActionMessageEntry."Source ID");
              ActionMessageEntry2.SETRANGE("Source Batch Name",ActionMessageEntry."Source Batch Name");
              ActionMessageEntry2.SETRANGE("Source Prod. Order Line",ActionMessageEntry."Source Prod. Order Line");
              ActionMessageEntry2.SETRANGE("Source Ref. No.",ActionMessageEntry."Source Ref. No.");
              ActionMessageEntry2.SETRANGE(Quantity,0);
              ActionMessageEntry2.DELETEALL;
              ActionMessageEntry2.RESET;
              ActionMessageEntry2 := ActionMessageEntry;
              ActionMessageEntry2.Quantity := 0;
              ActionMessageEntry2."New Date" := FirstDate;
              ActionMessageEntry2.Type := ActionMessageEntry.Type::Reschedule;
              ActionMessageEntry2."Reservation Entry" := ReservEntry2."Entry No.";
              WHILE NOT ActionMessageEntry2.INSERT DO
                ActionMessageEntry2."Entry No." += 1;
              ActionMessageEntry."Entry No." := ActionMessageEntry2."Entry No." + 1;
            END;
          END;
        END;

      WHILE NOT ActionMessageEntry.INSERT DO
        ActionMessageEntry."Entry No." += 1;
    END;

    [External]
    PROCEDURE ModifyActionMessage@38(RelatedToEntryNo@1000 : Integer;Quantity@1001 : Decimal;Delete@1002 : Boolean);
    BEGIN
      ActionMessageEntry.RESET;
      ActionMessageEntry.SETCURRENTKEY("Reservation Entry");
      ActionMessageEntry.SETRANGE("Reservation Entry",RelatedToEntryNo);

      IF Delete THEN BEGIN
        ActionMessageEntry.DELETEALL;
        EXIT;
      END;
      ActionMessageEntry.SETRANGE("New Date",0D);

      IF ActionMessageEntry.FINDFIRST THEN BEGIN
        ActionMessageEntry.Quantity -= Quantity;
        IF ActionMessageEntry.Quantity = 0 THEN
          ActionMessageEntry.DELETE
        ELSE
          ActionMessageEntry.MODIFY;
      END;
    END;

    [External]
    PROCEDURE FindDate@43(VAR ReservEntry@1000 : Record 337;Which@1001 : 'Earliest Shipment,Latest Receipt';ReturnRecord@1002 : Boolean) : Date;
    VAR
      ReservEntry2@1003 : Record 337;
      LastDate@1004 : Date;
    BEGIN
      ReservEntry2.COPY(ReservEntry); // Copy filter and sorting

      IF NOT ReservEntry2.FINDSET THEN
        EXIT;

      CASE Which OF
        0:
          BEGIN
            LastDate := DMY2DATE(31,12,9999);
            REPEAT
              IF ReservEntry2."Shipment Date" < LastDate THEN BEGIN
                LastDate := ReservEntry2."Shipment Date";
                IF ReturnRecord THEN
                  ReservEntry := ReservEntry2;
              END;
            UNTIL ReservEntry2.NEXT = 0;
          END;
        1:
          BEGIN
            LastDate := 0D;
            REPEAT
              IF ReservEntry2."Expected Receipt Date" > LastDate THEN BEGIN
                LastDate := ReservEntry2."Expected Receipt Date";
                IF ReturnRecord THEN
                  ReservEntry := ReservEntry2;
              END;
            UNTIL ReservEntry2.NEXT = 0;
          END;
      END;
      EXIT(LastDate);
    END;

    LOCAL PROCEDURE UpdateDating@45();
    VAR
      FilterReservEntry@1000 : Record 337;
      ReservEntry2@1001 : Record 337;
    BEGIN
      IF CalcReservEntry2."Source Type" = DATABASE::"Planning Component" THEN
        EXIT;

      IF Item."Order Tracking Policy" <> Item."Order Tracking Policy"::"Tracking & Action Msg." THEN
        EXIT;

      IF CalcReservEntry2."Source Type" = DATABASE::"Requisition Line" THEN
        IF ForReqLine."Planning Line Origin" <> ForReqLine."Planning Line Origin"::" " THEN
          EXIT;

      FilterReservEntry := CalcReservEntry2;
      FilterReservEntry.SetPointerFilter;

      IF NOT FilterReservEntry.FINDFIRST THEN
        EXIT;

      IF CalcReservEntry2."Source Type" IN [DATABASE::"Prod. Order Line",DATABASE::"Purchase Line"]
      THEN
        ReservEngineMgt.ModifyActionMessageDating(FilterReservEntry)
      ELSE BEGIN
        IF FilterReservEntry.Positive THEN
          EXIT;
        FilterReservEntry.SETRANGE("Reservation Status",FilterReservEntry."Reservation Status"::Reservation,
          FilterReservEntry."Reservation Status"::Tracking);
        IF NOT FilterReservEntry.FINDSET THEN
          EXIT;
        REPEAT
          IF ReservEntry2.GET(FilterReservEntry."Entry No.",NOT FilterReservEntry.Positive) THEN
            ReservEngineMgt.ModifyActionMessageDating(ReservEntry2);
        UNTIL FilterReservEntry.NEXT = 0;
      END;
    END;

    [External]
    PROCEDURE ClearActionMessageReferences@46();
    VAR
      ActionMessageEntry2@1000 : Record 99000849;
    BEGIN
      ActionMessageEntry.RESET;
      ActionMessageEntry.FilterFromReservEntry(CalcReservEntry);
      IF ActionMessageEntry.FINDSET THEN
        REPEAT
          ActionMessageEntry2 := ActionMessageEntry;
          IF ActionMessageEntry2.Quantity = 0 THEN
            ActionMessageEntry2.DELETE
          ELSE BEGIN
            ActionMessageEntry2."Source Subtype" := 0;
            ActionMessageEntry2."Source ID" := '';
            ActionMessageEntry2."Source Batch Name" := '';
            ActionMessageEntry2."Source Prod. Order Line" := 0;
            ActionMessageEntry2."Source Ref. No." := 0;
            ActionMessageEntry2."New Date" := 0D;
            ActionMessageEntry2.MODIFY;
          END;
        UNTIL ActionMessageEntry.NEXT = 0;
    END;

    [External]
    PROCEDURE SetItemTrackingHandling@10(Mode@1000 : 'None,Allow deletion,Match');
    BEGIN
      ItemTrackingHandling := Mode;
    END;

    [External]
    PROCEDURE DeleteItemTrackingConfirm@65() : Boolean;
    BEGIN
      IF NOT ItemTrackingExist(CalcReservEntry2) THEN
        EXIT(TRUE);

      IF CONFIRM(Text011,FALSE,CalcReservEntry2."Item No.",CalcReservEntry2.TextCaption) THEN
        EXIT(TRUE);

      EXIT(FALSE);
    END;

    LOCAL PROCEDURE ItemTrackingExist@67(VAR ReservEntry@1000 : Record 337) : Boolean;
    VAR
      ReservEntry2@1001 : Record 337;
    BEGIN
      ReservEntry2.COPY(ReservEntry);
      ReservEntry2.SETFILTER("Item Tracking",'> %1',ReservEntry2."Item Tracking"::None);
      EXIT(NOT ReservEntry2.ISEMPTY);
    END;

    [External]
    PROCEDURE SetSerialLotNo@17(SerialNo@1001 : Code[20];LotNo@1000 : Code[20]);
    BEGIN
      CalcReservEntry."Serial No." := SerialNo;
      CalcReservEntry."Lot No." := LotNo;
    END;

    [External]
    PROCEDURE SetMatchFilter@51(VAR ReservEntry@1000 : Record 337;VAR FilterReservEntry@1001 : Record 337;SearchForSupply@1002 : Boolean;AvailabilityDate@1003 : Date);
    BEGIN
      FilterReservEntry.RESET;
      FilterReservEntry.SETCURRENTKEY(
        "Item No.","Variant Code","Location Code","Reservation Status",
        "Shipment Date","Expected Receipt Date","Serial No.","Lot No.");
      FilterReservEntry.SETRANGE("Item No.",ReservEntry."Item No.");
      FilterReservEntry.SETRANGE("Variant Code",ReservEntry."Variant Code");
      FilterReservEntry.SETRANGE("Location Code",ReservEntry."Location Code");
      FilterReservEntry.SETRANGE("Reservation Status",
        FilterReservEntry."Reservation Status"::Reservation,FilterReservEntry."Reservation Status"::Surplus);
      IF SearchForSupply THEN
        FilterReservEntry.SETFILTER("Expected Receipt Date",'..%1',AvailabilityDate)
      ELSE
        FilterReservEntry.SETFILTER("Shipment Date",'>=%1',AvailabilityDate);
      IF FieldFilterNeeded2(ReservEntry,SearchForSupply,0) THEN
        FilterReservEntry.SETFILTER("Lot No.",GetFieldFilter);
      IF FieldFilterNeeded2(ReservEntry,SearchForSupply,1) THEN
        FilterReservEntry.SETFILTER("Serial No.",GetFieldFilter);
      FilterReservEntry.SETRANGE(Positive,SearchForSupply);
    END;

    [External]
    PROCEDURE LookupLine@59(SourceType@1005 : Integer;SourceSubtype@1004 : Integer;SourceID@1003 : Code[20];SourceBatchName@1002 : Code[10];SourceProdOrderLine@1001 : Integer;SourceRefNo@1000 : Integer);
    VAR
      ItemLedgEntry@1020 : Record 32;
      SalesLine@1018 : Record 37;
      PurchLine@1016 : Record 39;
      ItemJnlLine@1015 : Record 83;
      ReqLine@1013 : Record 246;
      ProdOrderLine@1011 : Record 5406;
      ProdOrderComp@1010 : Record 5407;
      PlanningComponent@1009 : Record 99000829;
      ServLine@1006 : Record 5902;
      JobPlanningLine@1007 : Record 1003;
      AsmHeader@1008 : Record 900;
      AsmLine@1012 : Record 901;
    BEGIN
      CASE SourceType OF
        DATABASE::"Sales Line":
          BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type",SourceSubtype);
            SalesLine.SETRANGE("Document No.",SourceID);
            SalesLine.SETRANGE("Line No.",SourceRefNo);
            PAGE.RUN(PAGE::"Sales Lines",SalesLine);
          END;
        DATABASE::"Requisition Line":
          BEGIN
            ReqLine.RESET;
            ReqLine.SETRANGE("Worksheet Template Name",SourceID);
            ReqLine.SETRANGE("Journal Batch Name",SourceBatchName);
            ReqLine.SETRANGE("Line No.",SourceRefNo);
            PAGE.RUN(PAGE::"Requisition Lines",ReqLine);
          END;
        DATABASE::"Purchase Line":
          BEGIN
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type",SourceSubtype);
            PurchLine.SETRANGE("Document No.",SourceID);
            PurchLine.SETRANGE("Line No.",SourceRefNo);
            PAGE.RUN(PAGE::"Purchase Lines",PurchLine);
          END;
        DATABASE::"Item Journal Line":
          BEGIN
            ItemJnlLine.RESET;
            ItemJnlLine.SETRANGE("Journal Template Name",SourceID);
            ItemJnlLine.SETRANGE("Journal Batch Name",SourceBatchName);
            ItemJnlLine.SETRANGE("Line No.",SourceRefNo);
            ItemJnlLine.SETRANGE("Entry Type",SourceSubtype);
            PAGE.RUN(PAGE::"Item Journal Lines",ItemJnlLine);
          END;
        DATABASE::"Item Ledger Entry":
          BEGIN
            ItemLedgEntry.RESET;
            ItemLedgEntry.SETRANGE("Entry No.",SourceRefNo);
            PAGE.RUN(0,ItemLedgEntry);
          END;
        DATABASE::"Prod. Order Line":
          BEGIN
            ProdOrderLine.RESET;
            ProdOrderLine.SETRANGE(Status,SourceSubtype);
            ProdOrderLine.SETRANGE("Prod. Order No.",SourceID);
            ProdOrderLine.SETRANGE("Line No.",SourceProdOrderLine);
            PAGE.RUN(0,ProdOrderLine);
          END;
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrderComp.RESET;
            ProdOrderComp.SETRANGE(Status,SourceSubtype);
            ProdOrderComp.SETRANGE("Prod. Order No.",SourceID);
            ProdOrderComp.SETRANGE("Prod. Order Line No.",SourceProdOrderLine);
            ProdOrderComp.SETRANGE("Line No.",SourceRefNo);
            PAGE.RUN(0,ProdOrderComp);
          END;
        DATABASE::"Planning Component":
          BEGIN
            PlanningComponent.RESET;
            PlanningComponent.SETRANGE("Worksheet Template Name",SourceID);
            PlanningComponent.SETRANGE("Worksheet Batch Name",SourceBatchName);
            PlanningComponent.SETRANGE("Worksheet Line No.",SourceProdOrderLine);
            PlanningComponent.SETRANGE("Line No.",SourceRefNo);
            PAGE.RUN(0,PlanningComponent);
          END;
        DATABASE::"Service Line":
          BEGIN
            ServLine.RESET;
            ServLine.SETRANGE("Document Type",SourceSubtype);
            ServLine.SETRANGE("Document No.",SourceID);
            ServLine.SETRANGE("Line No.",SourceRefNo);
            PAGE.RUN(0,ServLine);
          END;
        DATABASE::"Job Planning Line":
          BEGIN
            JobPlanningLine.RESET;
            JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
            JobPlanningLine.SETRANGE("Job Contract Entry No.",SourceRefNo);
            PAGE.RUN(0,JobPlanningLine);
          END;
        DATABASE::"Assembly Header":
          BEGIN
            AsmHeader.RESET;
            AsmHeader.SETRANGE("Document Type",SourceSubtype);
            AsmHeader.SETRANGE("No.",SourceID);
            PAGE.RUN(PAGE::"Assembly Orders",AsmHeader);
          END;
        DATABASE::"Assembly Line":
          BEGIN
            AsmLine.RESET;
            AsmLine.SETRANGE("Document Type",SourceSubtype);
            AsmLine.SETRANGE("Document No.",SourceID);
            AsmLine.SETRANGE("Line No.",SourceRefNo);
            PAGE.RUN(PAGE::"Assembly Lines",AsmLine);
          END;
      END;
    END;

    [External]
    PROCEDURE LookupDocument@58(SourceType@1005 : Integer;SourceSubtype@1004 : Integer;SourceID@1003 : Code[20];SourceBatchName@1002 : Code[10];SourceProdOrderLine@1001 : Integer;SourceRefNo@1000 : Integer);
    VAR
      SalesHeader@1019 : Record 36;
      PurchHeader@1017 : Record 38;
      ReqLine@1006 : Record 246;
      ItemJnlLine@1009 : Record 83;
      ItemLedgEntry@1010 : Record 32;
      ProdOrder@1012 : Record 5405;
      TransHeader@1008 : Record 5740;
      ServiceHeader@1007 : Record 5900;
      Job@1013 : Record 167;
      AsmHeader@1011 : Record 900;
    BEGIN
      CASE SourceType OF
        DATABASE::"Sales Line":
          BEGIN
            SalesHeader.RESET;
            SalesHeader.SETRANGE("Document Type",SourceSubtype);
            SalesHeader.SETRANGE("No.",SourceID);
            CASE SourceSubtype OF
              0:
                PAGE.RUNMODAL(PAGE::"Sales Quote",SalesHeader);
              1:
                PAGE.RUNMODAL(PAGE::"Sales Order",SalesHeader);
              2:
                PAGE.RUNMODAL(PAGE::"Sales Invoice",SalesHeader);
              3:
                PAGE.RUNMODAL(PAGE::"Sales Credit Memo",SalesHeader);
              5:
                PAGE.RUNMODAL(PAGE::"Sales Return Order",SalesHeader);
            END;
          END;
        DATABASE::"Requisition Line":
          BEGIN
            ReqLine.RESET;
            ReqLine.SETRANGE("Worksheet Template Name",SourceID);
            ReqLine.SETRANGE("Journal Batch Name",SourceBatchName);
            ReqLine.SETRANGE("Line No.",SourceRefNo);
            PAGE.RUNMODAL(PAGE::"Requisition Lines",ReqLine);
          END;
        DATABASE::"Planning Component":
          BEGIN
            ReqLine.RESET;
            ReqLine.SETRANGE("Worksheet Template Name",SourceID);
            ReqLine.SETRANGE("Journal Batch Name",SourceBatchName);
            ReqLine.SETRANGE("Line No.",SourceProdOrderLine);
            PAGE.RUNMODAL(PAGE::"Requisition Lines",ReqLine);
          END;
        DATABASE::"Purchase Line":
          BEGIN
            PurchHeader.RESET;
            PurchHeader.SETRANGE("Document Type",SourceSubtype);
            PurchHeader.SETRANGE("No.",SourceID);
            CASE SourceSubtype OF
              0:
                PAGE.RUNMODAL(PAGE::"Purchase Quote",PurchHeader);
              1:
                PAGE.RUNMODAL(PAGE::"Purchase Order",PurchHeader);
              2:
                PAGE.RUNMODAL(PAGE::"Purchase Invoice",PurchHeader);
              3:
                PAGE.RUNMODAL(PAGE::"Purchase Credit Memo",PurchHeader);
              5:
                PAGE.RUNMODAL(PAGE::"Purchase Return Order",PurchHeader);
            END;
          END;
        DATABASE::"Item Journal Line":
          BEGIN
            ItemJnlLine.RESET;
            ItemJnlLine.SETRANGE("Journal Template Name",SourceID);
            ItemJnlLine.SETRANGE("Journal Batch Name",SourceBatchName);
            ItemJnlLine.SETRANGE("Line No.",SourceRefNo);
            ItemJnlLine.SETRANGE("Entry Type",SourceSubtype);
            PAGE.RUNMODAL(PAGE::"Item Journal Lines",ItemJnlLine);
          END;
        DATABASE::"Item Ledger Entry":
          BEGIN
            ItemLedgEntry.RESET;
            ItemLedgEntry.SETRANGE("Entry No.",SourceRefNo);
            PAGE.RUNMODAL(0,ItemLedgEntry);
          END;
        DATABASE::"Prod. Order Line",
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrder.RESET;
            ProdOrder.SETRANGE(Status,SourceSubtype);
            ProdOrder.SETRANGE("No.",SourceID);
            CASE SourceSubtype OF
              0:
                PAGE.RUNMODAL(PAGE::"Simulated Production Order",ProdOrder);
              1:
                PAGE.RUNMODAL(PAGE::"Planned Production Order",ProdOrder);
              2:
                PAGE.RUNMODAL(PAGE::"Firm Planned Prod. Order",ProdOrder);
              3:
                PAGE.RUNMODAL(PAGE::"Released Production Order",ProdOrder);
            END;
          END;
        DATABASE::"Transfer Line":
          BEGIN
            TransHeader.RESET;
            TransHeader.SETRANGE("No.",SourceID);
            PAGE.RUNMODAL(PAGE::"Transfer Order",TransHeader);
          END;
        DATABASE::"Service Line":
          BEGIN
            ServiceHeader.RESET;
            ServiceHeader.SETRANGE("Document Type",SourceSubtype);
            ServiceHeader.SETRANGE("No.",SourceID);
            IF SourceSubtype = 0 THEN
              PAGE.RUNMODAL(PAGE::"Service Quote",ServiceHeader)
            ELSE
              PAGE.RUNMODAL(PAGE::"Service Order",ServiceHeader);
          END;
        DATABASE::"Job Planning Line":
          BEGIN
            Job.RESET;
            Job.SETRANGE("No.",SourceID);
            PAGE.RUNMODAL(PAGE::"Job Card",Job)
          END;
        DATABASE::"Assembly Header",
        DATABASE::"Assembly Line":
          BEGIN
            AsmHeader.RESET;
            AsmHeader.SETRANGE("Document Type",SourceSubtype);
            AsmHeader.SETRANGE("No.",SourceID);
            CASE SourceSubtype OF
              0:
                ;
              1:
                PAGE.RUNMODAL(PAGE::"Assembly Order",AsmHeader);
              5:
                ;
            END;
          END;
      END;
    END;

    LOCAL PROCEDURE CallCalcReservedQtyOnPick@104();
    BEGIN
      IF Positive AND (CalcReservEntry."Location Code" <> '') THEN
        IF Location.GET(CalcReservEntry."Location Code") AND
           (Location."Bin Mandatory" OR Location."Require Pick")
        THEN
          CalcReservedQtyOnPick(TotalAvailQty,QtyAllocInWhse);
    END;

    LOCAL PROCEDURE CalcReservedQtyOnPick@63(VAR AvailQty@1004 : Decimal;VAR AllocQty@1001 : Decimal);
    VAR
      WhseActivLine@1003 : Record 5767;
      TempWhseActivLine2@1000 : TEMPORARY Record 5767;
      WhseAvailMgt@1009 : Codeunit 7314;
      PickQty@1007 : Decimal;
      QtyOnOutboundBins@1002 : Decimal;
      QtyOnInvtMovement@1005 : Decimal;
      QtyOnAssemblyBin@1006 : Decimal;
    BEGIN
      WITH CalcReservEntry DO BEGIN
        GetItemSetup(CalcReservEntry);
        Item.SETRANGE("Location Filter","Location Code");
        Item.SETRANGE("Variant Filter","Variant Code");
        IF "Lot No." <> '' THEN
          Item.SETRANGE("Lot No. Filter","Lot No.");
        IF "Serial No." <> '' THEN
          Item.SETRANGE("Serial No. Filter","Serial No.");
        Item.CALCFIELDS(
          Inventory,"Reserved Qty. on Inventory");

        WhseActivLine.SETCURRENTKEY(
          "Item No.","Bin Code","Location Code","Action Type","Variant Code",
          "Unit of Measure Code","Breakbulk No.","Activity Type","Lot No.","Serial No.");

        WhseActivLine.SETRANGE("Item No.","Item No.");
        IF Location."Bin Mandatory" THEN
          WhseActivLine.SETFILTER("Bin Code",'<>%1','');
        WhseActivLine.SETRANGE("Location Code","Location Code");
        WhseActivLine.SETFILTER(
          "Action Type",'%1|%2',WhseActivLine."Action Type"::" ",WhseActivLine."Action Type"::Take);
        WhseActivLine.SETRANGE("Variant Code","Variant Code");
        WhseActivLine.SETRANGE("Breakbulk No.",0);
        WhseActivLine.SETFILTER(
          "Activity Type",'%1|%2',WhseActivLine."Activity Type"::Pick,WhseActivLine."Activity Type"::"Invt. Pick");
        IF "Lot No." <> '' THEN
          WhseActivLine.SETRANGE("Lot No.","Lot No.");
        IF "Serial No." <> '' THEN
          WhseActivLine.SETRANGE("Serial No.","Serial No.");
        WhseActivLine.CALCSUMS("Qty. Outstanding (Base)");

        IF Location."Require Pick" THEN BEGIN
          QtyOnOutboundBins :=
            CreatePick.CalcQtyOnOutboundBins(
              "Location Code","Item No.","Variant Code","Lot No.","Serial No.",TRUE);

          QtyReservedOnPickShip :=
            WhseAvailMgt.CalcReservQtyOnPicksShips(
              "Location Code","Item No.","Variant Code",TempWhseActivLine2);

          QtyOnInvtMovement := CalcQtyOnInvtMovement(WhseActivLine);

          QtyOnAssemblyBin :=
            WhseAvailMgt.CalcQtyOnAssemblyBin("Location Code","Item No.","Variant Code","Lot No.","Serial No.");
        END;

        AllocQty :=
          WhseActivLine."Qty. Outstanding (Base)" + QtyOnInvtMovement + QtyOnOutboundBins + QtyOnAssemblyBin;
        PickQty := WhseActivLine."Qty. Outstanding (Base)" + QtyOnInvtMovement;

        AvailQty :=
          Item.Inventory - PickQty - QtyOnOutboundBins - QtyOnAssemblyBin -
          Item."Reserved Qty. on Inventory" + QtyReservedOnPickShip;
      END;
    END;

    LOCAL PROCEDURE SaveItemTrackingAsSurplus@1000000000(VAR ReservEntry@1000000004 : Record 337;NewQty@1001 : Decimal;NewQtyBase@1000000000 : Decimal) QuantityIsValidated : Boolean;
    VAR
      SurplusEntry@1000000003 : Record 337;
      CreateReservEntry2@1000000006 : Codeunit 99000830;
      QtyToSave@1000 : Decimal;
      QtyToSaveBase@1000000007 : Decimal;
      QtyToHandleThisLine@1000000002 : Decimal;
      QtyToInvoiceThisLine@1000000001 : Decimal;
      SignFactor@1000000005 : Integer;
    BEGIN
      QtyToSave := ReservEntry.Quantity - NewQty;
      QtyToSaveBase := ReservEntry."Quantity (Base)" - NewQtyBase;

      IF QtyToSaveBase = 0 THEN
        EXIT;

      IF ReservEntry."Item Tracking" = ReservEntry."Item Tracking"::None THEN
        EXIT;

      IF ReservEntry."Source Type" = DATABASE::"Item Ledger Entry" THEN
        EXIT;

      IF QtyToSaveBase * ReservEntry."Quantity (Base)" < 0 THEN
        ReservEntry.FIELDERROR("Quantity (Base)");

      SignFactor := ReservEntry."Quantity (Base)" / ABS(ReservEntry."Quantity (Base)");

      IF SignFactor * QtyToSaveBase > SignFactor * ReservEntry."Quantity (Base)" THEN
        ReservEntry.FIELDERROR("Quantity (Base)");

      QtyToHandleThisLine := ReservEntry."Qty. to Handle (Base)" - NewQtyBase;
      QtyToInvoiceThisLine := ReservEntry."Qty. to Invoice (Base)" - NewQtyBase;

      ReservEntry.VALIDATE("Quantity (Base)",NewQtyBase);

      IF SignFactor * QtyToHandleThisLine < 0 THEN BEGIN
        ReservEntry.VALIDATE("Qty. to Handle (Base)",ReservEntry."Qty. to Handle (Base)" + QtyToHandleThisLine);
        QtyToHandleThisLine := 0;
      END;

      IF SignFactor * QtyToInvoiceThisLine < 0 THEN BEGIN
        ReservEntry.VALIDATE("Qty. to Invoice (Base)",ReservEntry."Qty. to Invoice (Base)" + QtyToInvoiceThisLine);
        QtyToInvoiceThisLine := 0;
      END;

      QuantityIsValidated := TRUE;

      SurplusEntry := ReservEntry;
      SurplusEntry."Reservation Status" := SurplusEntry."Reservation Status"::Surplus;
      IF SurplusEntry.Positive THEN
        SurplusEntry."Shipment Date" := 0D
      ELSE
        SurplusEntry."Expected Receipt Date" := 0D;
      CreateReservEntry2.SetQtyToHandleAndInvoice(QtyToHandleThisLine,QtyToInvoiceThisLine);
      CreateReservEntry2.CreateRemainingReservEntry(SurplusEntry,QtyToSave,QtyToSaveBase);
    END;

    [External]
    PROCEDURE CalcIsAvailTrackedQtyInBin@61(ItemNo@1000 : Code[20];BinCode@1001 : Code[20];LocationCode@1002 : Code[10];VariantCode@1015 : Code[10];SourceType@1013 : Integer;SourceSubtype@1012 : Integer;SourceID@1011 : Code[20];SourceBatchName@1010 : Code[10];SourceProdOrderLine@1009 : Integer;SourceRefNo@1008 : Integer) : Boolean;
    VAR
      ReservationEntry@1007 : Record 337;
      WhseEntry@1014 : Record 7312;
      ItemTrackingMgt@1005 : Codeunit 6500;
      WhseSNRequired@1004 : Boolean;
      WhseLNRequired@1003 : Boolean;
    BEGIN
      ItemTrackingMgt.CheckWhseItemTrkgSetup(ItemNo,WhseSNRequired,WhseLNRequired,FALSE);
      IF NOT (WhseSNRequired OR WhseLNRequired) OR (BinCode = '') THEN
        EXIT(TRUE);

      ReservationEntry.SetSourceFilter(SourceType,SourceSubtype,SourceID,SourceRefNo,FALSE);
      ReservationEntry.SetSourceFilter2(SourceBatchName,SourceProdOrderLine);
      ReservationEntry.SETRANGE(Positive,FALSE);
      IF ReservationEntry.FINDSET THEN
        REPEAT
          IF ReservEntryPositiveTypeIsItemLedgerEntry(ReservationEntry."Entry No.") THEN BEGIN
            WhseEntry.SETCURRENTKEY("Item No.","Location Code","Variant Code","Bin Type Code");
            WhseEntry.SETRANGE("Item No.",ItemNo);
            WhseEntry.SETRANGE("Location Code",LocationCode);
            WhseEntry.SETRANGE("Bin Code",BinCode);
            WhseEntry.SETRANGE("Variant Code",VariantCode);
            IF ReservationEntry."Lot No." <> '' THEN
              WhseEntry.SETRANGE("Lot No.",ReservationEntry."Lot No.");
            IF ReservationEntry."Serial No." <> '' THEN
              WhseEntry.SETRANGE("Serial No.",ReservationEntry."Serial No.");
            WhseEntry.CALCSUMS("Qty. (Base)");
            IF WhseEntry."Qty. (Base)" < ABS(ReservationEntry."Quantity (Base)") THEN
              EXIT(FALSE);
          END;
        UNTIL ReservationEntry.NEXT = 0;

      EXIT(TRUE);
    END;

    LOCAL PROCEDURE CalcQtyOnInvtMovement@90(VAR WarehouseActivityLine@1000 : Record 5767) : Decimal;
    VAR
      xWarehouseActivityLine@1001 : Record 5767;
      OutstandingQty@1002 : Decimal;
    BEGIN
      xWarehouseActivityLine.COPY(WarehouseActivityLine);

      WarehouseActivityLine.SETRANGE("Activity Type",WarehouseActivityLine."Activity Type"::"Invt. Movement");
      IF WarehouseActivityLine.FIND('-') THEN
        REPEAT
          IF WarehouseActivityLine."Source Type" <> 0 THEN
            OutstandingQty += WarehouseActivityLine."Qty. Outstanding (Base)"
        UNTIL WarehouseActivityLine.NEXT = 0;

      WarehouseActivityLine.COPY(xWarehouseActivityLine);
      EXIT(OutstandingQty);
    END;

    LOCAL PROCEDURE ProdJnlLineEntry@53(ReservationEntry@1000 : Record 337) : Boolean;
    BEGIN
      WITH ReservationEntry DO
        EXIT(("Source Type" = DATABASE::"Item Journal Line") AND ("Source Subtype" = 6));
    END;

    LOCAL PROCEDURE CalcDownToQtySyncingToAssembly@97(ReservEntry@1001 : Record 337) : Decimal;
    VAR
      SynchronizingSalesLine@1000 : Record 37;
    BEGIN
      IF ReservEntry."Source Type" = DATABASE::"Sales Line" THEN BEGIN
        SynchronizingSalesLine.GET(ReservEntry."Source Subtype",ReservEntry."Source ID",ReservEntry."Source Ref. No.");
        IF (Item."Order Tracking Policy" <> Item."Order Tracking Policy"::None) AND
           (Item."Assembly Policy" = Item."Assembly Policy"::"Assemble-to-Order") AND
           (Item."Replenishment System" = Item."Replenishment System"::Assembly) AND
           (SynchronizingSalesLine."Quantity (Base)" = 0)
        THEN
          EXIT(ReservEntry."Quantity (Base)" * CreateReservEntry.SignFactor(ReservEntry));
      END;
    END;

    LOCAL PROCEDURE CalcCurrLineReservQtyOnPicksShips@118(ReservationEntry@1002 : Record 337) : Decimal;
    VAR
      ReservEntry@1000 : Record 337;
      WhseActivLine@1001 : Record 5767;
      WhseAvailMgt@1004 : Codeunit 7314;
      PickQty@1003 : Decimal;
    BEGIN
      WITH ReservEntry DO BEGIN
        PickQty := WhseAvailMgt.CalcRegisteredAndOutstandingPickQty(ReservationEntry,WhseActivLine);

        SetSourceFilter(
          ReservationEntry."Source Type",ReservationEntry."Source Subtype",
          ReservationEntry."Source ID",ReservationEntry."Source Ref. No.",FALSE);
        SETRANGE("Source Prod. Order Line",ReservationEntry."Source Prod. Order Line");
        SETRANGE("Reservation Status","Reservation Status"::Reservation);
        CALCSUMS("Quantity (Base)");
        IF -"Quantity (Base)" > PickQty THEN
          EXIT(PickQty);
        EXIT(-"Quantity (Base)");
      END;
    END;

    LOCAL PROCEDURE CheckQuantityIsCompletelyReleased@113(QtyToRelease@1000 : Decimal;DeleteAll@1001 : Boolean;CurrentSerialNo@1002 : Code[20];CurrentLotNo@1003 : Code[20];ReservEntry@1004 : Record 337);
    BEGIN
      IF QtyToRelease = 0 THEN
        EXIT;

      IF ItemTrackingHandling = ItemTrackingHandling::None THEN BEGIN
        IF DeleteAll THEN
          ERROR(Text010,ReservEntry."Item No.",ReservEntry.TextCaption);
        IF NOT ProdJnlLineEntry(ReservEntry) THEN
          ERROR(Text008,ReservEntry."Item No.",ReservEntry.TextCaption);
      END;

      IF ItemTrackingHandling = ItemTrackingHandling::Match THEN
        ERROR(Text009,CurrentSerialNo,CurrentLotNo,ABS(QtyToRelease));
    END;

    LOCAL PROCEDURE ReservEntryPositiveTypeIsItemLedgerEntry@120(ReservationEntryNo@1000 : Integer) : Boolean;
    VAR
      ReservationEntryPositive@1001 : Record 337;
    BEGIN
      IF ReservationEntryPositive.GET(ReservationEntryNo,TRUE) THEN
        EXIT(ReservationEntryPositive."Source Type" = DATABASE::"Item Ledger Entry");

      EXIT(TRUE);
    END;

    [External]
    PROCEDURE DeleteDocumentReservation@68(TableID@1002 : Integer;DocType@1003 : Option;DocNo@1004 : Code[20];HideValidationDialog@1005 : Boolean);
    VAR
      ReservEntry@1001 : Record 337;
      ReservEntry2@1000 : Record 337;
      RecRef@1008 : RecordRef;
      FieldRef@1007 : FieldRef;
      DocTypeCaption@1009 : Text;
      Confirmed@1006 : Boolean;
    BEGIN
      WITH ReservEntry DO BEGIN
        RESET;
        SETCURRENTKEY(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line","Reservation Status");
        IF TableID <> DATABASE::"Prod. Order Line" THEN BEGIN
          SETRANGE("Source Type",TableID);
          SETRANGE("Source Prod. Order Line",0);
        END ELSE
          SETFILTER("Source Type",'%1|%2',DATABASE::"Prod. Order Line",DATABASE::"Prod. Order Component");

        CASE TableID OF
          DATABASE::"Transfer Line":
            BEGIN
              SETRANGE("Source Subtype");
              DocTypeCaption := STRSUBSTNO(DeleteTransLineWithItemReservQst,DocNo);
            END;
          DATABASE::"Prod. Order Line":
            BEGIN
              SETRANGE("Source Subtype",DocType);
              RecRef.OPEN(TableID);
              FieldRef := RecRef.FIELDINDEX(1);
              DocTypeCaption :=
                STRSUBSTNO(DeleteProdOrderLineWithItemReservQst,SELECTSTR(DocType + 1,FieldRef.OPTIONCAPTION),DocNo);
            END;
          ELSE BEGIN
            SETRANGE("Source Subtype",DocType);
            RecRef.OPEN(TableID);
            FieldRef := RecRef.FIELDINDEX(1);
            DocTypeCaption :=
              STRSUBSTNO(DeleteDocLineWithItemReservQst,SELECTSTR(DocType + 1,FieldRef.OPTIONCAPTION),DocNo);
          END;
        END;

        SETRANGE("Source ID",DocNo);
        SETRANGE("Source Batch Name",'');
        SETFILTER("Item Tracking",'> %1',"Item Tracking"::None);
        IF ISEMPTY THEN
          EXIT;

        IF HideValidationDialog OR NOT GUIALLOWED THEN
          Confirmed := TRUE
        ELSE
          Confirmed := CONFIRM(DocTypeCaption,FALSE);

        IF NOT Confirmed THEN
          ERROR('');

        IF FINDSET THEN
          REPEAT
            ReservEntry2 := ReservEntry;
            ReservEntry2.ClearItemTrackingFields;
            ReservEntry2.MODIFY;
          UNTIL NEXT = 0;
      END;
    END;

    [Integration]
    LOCAL PROCEDURE OnAfterCalcReservation@128(VAR ReservEntry@1000 : Record 337;VAR ItemLedgEntry@1001 : Record 32;VAR ResSummEntryNo@1002 : Integer;VAR QtyThisLine@1003 : Decimal);
    BEGIN
    END;

    [Integration]
    LOCAL PROCEDURE OnBeforeCreateReservation@129(VAR TrkgSpec@1000 : Record 336;VAR ReservEntry@1001 : Record 337;VAR ItemLedgEntry@1002 : Record 32);
    BEGIN
    END;

    BEGIN
    END.
  }
}

