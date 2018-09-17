OBJECT Page 99000896 Available - Transfer Lines
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Disponibel - overflyt.linjer;
               ENU=Available - Transfer Lines];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5741;
    DataCaptionExpr=CaptionText;
    SourceTableView=SORTING(Document No.,Line No.);
    PageType=List;
    OnOpenPage=BEGIN
                 ReservEntry.TESTFIELD("Source Type");
                 IF NOT DirectionIsSet THEN
                   ERROR(Text000);
                 CASE Direction OF
                   Direction::Outbound:
                     BEGIN
                       SETFILTER("Shipment Date",ReservMgt.GetAvailabilityFilter(ReservEntry."Shipment Date"));
                       SETRANGE("Transfer-from Code",ReservEntry."Location Code");
                     END;
                   Direction::Inbound:
                     BEGIN
                       SETFILTER("Receipt Date",ReservMgt.GetAvailabilityFilter(ReservEntry."Shipment Date"));
                       SETRANGE("Transfer-to Code",ReservEntry."Location Code");
                     END;
                 END;

                 SETRANGE("Item No.",ReservEntry."Item No.");
                 SETRANGE("Variant Code",ReservEntry."Variant Code");
                 SETFILTER("Outstanding Qty. (Base)",'>0');
               END;

    OnAfterGetRecord=BEGIN
                       ReservMgt.TransferLineUpdateValues(Rec,QtyToReserve,QtyToReserveBase,QtyReservedThisLine,QtyReservedThisLineBase,Direction);
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 4       ;2   ;Action    ;
                      Name=Reserve;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n›dvendige m‘ngde p† den bilagslinje, som vinduet blev †bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Advanced;
                      Image=Reserve;
                      OnAction=BEGIN
                                 ReservEntry.LOCKTABLE;
                                 UpdateReservMgt;
                                 ReservMgt.TransferLineUpdateValues(Rec,QtyToReserve,QtyToReserveBase,QtyReservedThisLine,QtyReservedThisLineBase,Direction);
                                 ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine,NewQtyReservedThisLineBase);
                                 ReservMgt.CopySign(NewQtyReservedThisLine,QtyToReserve);
                                 ReservMgt.CopySign(NewQtyReservedThisLineBase,QtyToReserveBase);
                                 IF NewQtyReservedThisLineBase <> 0 THEN
                                   IF NewQtyReservedThisLineBase > QtyToReserveBase THEN
                                     CreateReservation(QtyToReserve,QtyToReserveBase)
                                   ELSE
                                     CreateReservation(NewQtyReservedThisLine,NewQtyReservedThisLineBase)
                                 ELSE
                                   ERROR(Text001);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=CancelReservation;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=&Annuller reservation;
                                 ENU=&Cancel Reservation];
                      ToolTipML=[DAN=Annuller reservationen, der findes p† den bilagslinje, som vinduet blev †bnet for.;
                                 ENU=Cancel the reservation that exists for the document line that you opened this window for.];
                      ApplicationArea=#Advanced;
                      Image=Cancel;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(Text002,FALSE) THEN
                                   EXIT;

                                 ReservEntry2.COPY(ReservEntry);
                                 ReserveTransLine.FilterReservFor(ReservEntry2,Rec,Direction);

                                 IF ReservEntry2.FIND('-') THEN BEGIN
                                   UpdateReservMgt;
                                   REPEAT
                                     ReservEngineMgt.CancelReservation(ReservEntry2);
                                   UNTIL ReservEntry2.NEXT = 0;

                                   UpdateReservFrom;
                                 END;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes fra.;
                           ENU=Specifies the code of the location that items are transferred from.];
                ApplicationArea=#Advanced;
                SourceExpr="Transfer-from Code" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, som varerne overflyttes til.;
                           ENU=Specifies the code of the location that the items are transferred to.];
                ApplicationArea=#Advanced;
                SourceExpr="Transfer-to Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date" }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du forventer, at den lokation, der overflyttes til, vil modtage varerne p† denne linje.;
                           ENU=Specifies the date that you expect the transfer-to location to receive the items on this line.];
                ApplicationArea=#Advanced;
                SourceExpr="Receipt Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet p† linjen anf›rt i basisenheder.;
                           ENU=Specifies the quantity on the line expressed in base units of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Quantity (Base)" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, der er reserveret p† den lokation, der overflyttes til, angivet i basisenheder.;
                           ENU=Specifies the quantity of the item reserved at the transfer-to location, expressed in base units of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Reserved Qty. Inbnd. (Base)" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, der er reserveret p† den lokation, der overflyttes fra, angivet i basisenheder.;
                           ENU=Specifies the quantity of the item reserved at the transfer-from location, expressed in the base unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Reserved Qty. Outbnd. (Base)" }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Disponibelt antal;
                           ENU=Available Quantity];
                ToolTipML=[DAN=Angiver antallet af den vare, der er tilg‘ngelig.;
                           ENU=Specifies the quantity of the item that is available.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=QtyToReserveBase;
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Aktuelt reserveret antal;
                           ENU=Current Reserved Quantity];
                ToolTipML=[DAN=Angiver antallet af den vare, der er reserveret for dokumenttypen.;
                           ENU=Specifies the quantity of the item that is reserved for the document type.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=ReservedThisLine;
                OnDrillDown=BEGIN
                              ReservEntry2.RESET;
                              ReserveTransLine.FilterReservFor(ReservEntry2,Rec,Direction);
                              ReservEntry2.SETRANGE("Reservation Status",ReservEntry2."Reservation Status"::Reservation);
                              ReservMgt.MarkReservConnection(ReservEntry2,ReservEntry);
                              PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry2);
                              UpdateReservFrom;
                              CurrPage.UPDATE;
                            END;
                             }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Der er ikke angivet en retning.;ENU=Direction has not been set.';
      Text001@1001 : TextConst 'DAN=Helt reserveret.;ENU=Fully reserved.';
      Text002@1002 : TextConst 'DAN=Skal reservationen annulleres?;ENU=Do you want to cancel the reservation?';
      Text003@1003 : TextConst 'DAN=Disponibelt antal er %1.;ENU=Available Quantity is %1.';
      AssemblyLine@1037 : Record 901;
      AssemblyHeader@1036 : Record 900;
      ReservEntry@1004 : Record 337;
      ReservEntry2@1005 : Record 337;
      SalesLine@1006 : Record 37;
      PurchLine@1007 : Record 39;
      ReqLine@1009 : Record 246;
      ProdOrderLine@1010 : Record 5406;
      ProdOrderComp@1011 : Record 5407;
      PlanningComponent@1012 : Record 99000829;
      TransLine@1013 : Record 5741;
      ServiceInvLine@1014 : Record 5902;
      JobPlanningLine@1032 : Record 1003;
      ReservMgt@1015 : Codeunit 99000845;
      ReservEngineMgt@1016 : Codeunit 99000831;
      ReserveSalesLine@1017 : Codeunit 99000832;
      ReserveReqLine@1018 : Codeunit 99000833;
      ReservePurchLine@1019 : Codeunit 99000834;
      ReserveProdOrderLine@1021 : Codeunit 99000837;
      ReserveProdOrderComp@1022 : Codeunit 99000838;
      ReservePlanningComponent@1023 : Codeunit 99000840;
      ReserveTransLine@1024 : Codeunit 99000836;
      ReserveServiceInvLine@1025 : Codeunit 99000842;
      JobPlanningLineReserve@1033 : Codeunit 1032;
      AssemblyLineReserve@1035 : Codeunit 926;
      AssemblyHeaderReserve@1034 : Codeunit 925;
      QtyToReserve@1026 : Decimal;
      QtyToReserveBase@1020 : Decimal;
      QtyReservedThisLine@1038 : Decimal;
      QtyReservedThisLineBase@1027 : Decimal;
      NewQtyReservedThisLine@1028 : Decimal;
      NewQtyReservedThisLineBase@1008 : Decimal;
      CaptionText@1029 : Text[80];
      Direction@1030 : 'Outbound,Inbound';
      DirectionIsSet@1031 : Boolean;

    [External]
    PROCEDURE SetSalesLine@24(VAR CurrentSalesLine@1000 : Record 37;CurrentReservEntry@1001 : Record 337);
    BEGIN
      CurrentSalesLine.TESTFIELD(Type,CurrentSalesLine.Type::Item);
      SalesLine := CurrentSalesLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetSalesLine(SalesLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReserveSalesLine.FilterReservFor(ReservEntry,SalesLine);
      CaptionText := ReserveSalesLine.Caption(SalesLine);
      SetInbound(ReservMgt.IsPositive);
    END;

    [External]
    PROCEDURE SetReqLine@23(VAR CurrentReqLine@1000 : Record 246;CurrentReservEntry@1001 : Record 337);
    BEGIN
      ReqLine := CurrentReqLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetReqLine(ReqLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReserveReqLine.FilterReservFor(ReservEntry,ReqLine);
      CaptionText := ReserveReqLine.Caption(ReqLine);
      SetInbound(ReservMgt.IsPositive);
    END;

    [External]
    PROCEDURE SetPurchLine@22(VAR CurrentPurchLine@1000 : Record 39;CurrentReservEntry@1001 : Record 337);
    BEGIN
      CurrentPurchLine.TESTFIELD(Type,CurrentPurchLine.Type::Item);
      PurchLine := CurrentPurchLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetPurchLine(PurchLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReservePurchLine.FilterReservFor(ReservEntry,PurchLine);
      CaptionText := ReservePurchLine.Caption(PurchLine);
      SetInbound(ReservMgt.IsPositive);
    END;

    [External]
    PROCEDURE SetProdOrderLine@19(VAR CurrentProdOrderLine@1000 : Record 5406;CurrentReservEntry@1001 : Record 337);
    BEGIN
      ProdOrderLine := CurrentProdOrderLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetProdOrderLine(ProdOrderLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReserveProdOrderLine.FilterReservFor(ReservEntry,ProdOrderLine);
      CaptionText := ReserveProdOrderLine.Caption(ProdOrderLine);
      SetInbound(ReservMgt.IsPositive);
    END;

    [External]
    PROCEDURE SetProdOrderComponent@18(VAR CurrentProdOrderComp@1000 : Record 5407;CurrentReservEntry@1001 : Record 337);
    BEGIN
      ProdOrderComp := CurrentProdOrderComp;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetProdOrderComponent(ProdOrderComp);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReserveProdOrderComp.FilterReservFor(ReservEntry,ProdOrderComp);
      CaptionText := ReserveProdOrderComp.Caption(ProdOrderComp);
      SetInbound(ReservMgt.IsPositive);
    END;

    [External]
    PROCEDURE SetPlanningComponent@15(VAR CurrentPlanningComponent@1000 : Record 99000829;CurrentReservEntry@1001 : Record 337);
    BEGIN
      PlanningComponent := CurrentPlanningComponent;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetPlanningComponent(PlanningComponent);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReservePlanningComponent.FilterReservFor(ReservEntry,PlanningComponent);
      CaptionText := ReservePlanningComponent.Caption(PlanningComponent);
      SetInbound(ReservMgt.IsPositive);
    END;

    [External]
    PROCEDURE SetTransferLine@3(VAR CurrentTransLine@1000 : Record 5741;CurrentReservEntry@1001 : Record 337;Direction@1002 : 'Outbound,Inbound');
    BEGIN
      TransLine := CurrentTransLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetTransferLine(TransLine,Direction);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReserveTransLine.FilterReservFor(ReservEntry,TransLine,Direction);
      CaptionText := ReserveTransLine.Caption(TransLine);
      SetInbound(ReservMgt.IsPositive);
    END;

    [External]
    PROCEDURE SetServiceInvLine@8(VAR CurrentServiceInvLine@1000 : Record 5902;CurrentReservEntry@1001 : Record 337);
    BEGIN
      CurrentServiceInvLine.TESTFIELD(Type,CurrentServiceInvLine.Type::Item);
      ServiceInvLine := CurrentServiceInvLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetServLine(ServiceInvLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReserveServiceInvLine.FilterReservFor(ReservEntry,ServiceInvLine);
      CaptionText := ReserveServiceInvLine.Caption(ServiceInvLine);
      SetInbound(ReservMgt.IsPositive);
    END;

    [External]
    PROCEDURE SetJobPlanningLine@4(VAR CurrentJobPlanningLine@1000 : Record 1003;CurrentReservEntry@1001 : Record 337);
    BEGIN
      CurrentJobPlanningLine.TESTFIELD(Type,CurrentJobPlanningLine.Type::Item);
      JobPlanningLine := CurrentJobPlanningLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetJobPlanningLine(JobPlanningLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      JobPlanningLineReserve.FilterReservFor(ReservEntry,JobPlanningLine);
      CaptionText := JobPlanningLineReserve.Caption(JobPlanningLine);
      SetInbound(ReservMgt.IsPositive);
    END;

    LOCAL PROCEDURE CreateReservation@14(ReserveQuantity@1005 : Decimal;ReserveQuantityBase@1000 : Decimal);
    VAR
      TrackingSpecification@1006 : Record 336;
      QtyThisLine@1001 : Decimal;
      ReservQty@1002 : Decimal;
      LocationCode@1003 : Code[10];
      EntryDate@1004 : Date;
    BEGIN
      CASE Direction OF
        Direction::Outbound:
          BEGIN
            CALCFIELDS("Reserved Qty. Outbnd. (Base)");
            QtyThisLine := "Outstanding Qty. (Base)";
            ReservQty := "Reserved Qty. Outbnd. (Base)";
            EntryDate := "Shipment Date";
            TESTFIELD("Transfer-from Code",ReservEntry."Location Code");
            LocationCode := "Transfer-from Code";
          END;
        Direction::Inbound:
          BEGIN
            CALCFIELDS("Reserved Qty. Inbnd. (Base)");
            QtyThisLine := "Outstanding Qty. (Base)";
            ReservQty := "Reserved Qty. Inbnd. (Base)";
            EntryDate := "Receipt Date";
            TESTFIELD("Transfer-to Code",ReservEntry."Location Code");
            LocationCode := "Transfer-to Code";
          END;
      END;

      IF QtyThisLine - ReservQty < ReserveQuantityBase THEN
        ERROR(Text003,QtyThisLine + ReservQty);

      TESTFIELD("Item No.",ReservEntry."Item No.");
      TESTFIELD("Variant Code",ReservEntry."Variant Code");

      UpdateReservMgt;
      TrackingSpecification.InitTrackingSpecification2(
        DATABASE::"Transfer Line",Direction,"Document No.",'',"Derived From Line No.","Line No.",
        "Variant Code",LocationCode,"Qty. per Unit of Measure");
      ReservMgt.CreateReservation(
        ReservEntry.Description,EntryDate,ReserveQuantity,ReserveQuantityBase,TrackingSpecification);
      UpdateReservFrom;
    END;

    LOCAL PROCEDURE UpdateReservFrom@17();
    BEGIN
      CASE ReservEntry."Source Type" OF
        DATABASE::"Sales Line":
          BEGIN
            SalesLine.FIND;
            SetSalesLine(SalesLine,ReservEntry);
          END;
        DATABASE::"Requisition Line":
          BEGIN
            ReqLine.FIND;
            SetReqLine(ReqLine,ReservEntry);
          END;
        DATABASE::"Purchase Line":
          BEGIN
            PurchLine.FIND;
            SetPurchLine(PurchLine,ReservEntry);
          END;
        DATABASE::"Prod. Order Line":
          BEGIN
            ProdOrderLine.FIND;
            SetProdOrderLine(ProdOrderLine,ReservEntry);
          END;
        DATABASE::"Prod. Order Component":
          BEGIN
            ProdOrderComp.FIND;
            SetProdOrderComponent(ProdOrderComp,ReservEntry);
          END;
        DATABASE::"Transfer Line":
          BEGIN
            TransLine.FIND;
            SetTransferLine(TransLine,ReservEntry,ReservEntry."Source Subtype");
          END;
        DATABASE::"Planning Component":
          BEGIN
            PlanningComponent.FIND;
            SetPlanningComponent(PlanningComponent,ReservEntry);
          END;
        DATABASE::"Job Planning Line":
          BEGIN
            JobPlanningLine.FIND;
            SetJobPlanningLine(JobPlanningLine,ReservEntry);
          END;
      END;
    END;

    LOCAL PROCEDURE UpdateReservMgt@13();
    BEGIN
      CLEAR(ReservMgt);
      CASE ReservEntry."Source Type" OF
        DATABASE::"Sales Line":
          ReservMgt.SetSalesLine(SalesLine);
        DATABASE::"Requisition Line":
          ReservMgt.SetReqLine(ReqLine);
        DATABASE::"Purchase Line":
          ReservMgt.SetPurchLine(PurchLine);
        DATABASE::"Prod. Order Line":
          ReservMgt.SetProdOrderLine(ProdOrderLine);
        DATABASE::"Prod. Order Component":
          ReservMgt.SetProdOrderComponent(ProdOrderComp);
        DATABASE::"Assembly Header":
          ReservMgt.SetAssemblyHeader(AssemblyHeader);
        DATABASE::"Assembly Line":
          ReservMgt.SetAssemblyLine(AssemblyLine);
        DATABASE::"Transfer Line":
          ReservMgt.SetTransferLine(TransLine,ReservEntry."Source Subtype");
        DATABASE::"Planning Component":
          ReservMgt.SetPlanningComponent(PlanningComponent);
        DATABASE::"Service Line":
          ReservMgt.SetServLine(ServiceInvLine);
        DATABASE::"Job Planning Line":
          ReservMgt.SetJobPlanningLine(JobPlanningLine);
      END;
    END;

    LOCAL PROCEDURE ReservedThisLine@2() : Decimal;
    BEGIN
      ReservEntry2.RESET;
      ReserveTransLine.FilterReservFor(ReservEntry2,Rec,Direction);
      ReservEntry2.SETRANGE("Reservation Status",ReservEntry2."Reservation Status"::Reservation);
      EXIT(ReservMgt.MarkReservConnection(ReservEntry2,ReservEntry));
    END;

    [External]
    PROCEDURE SetInbound@1(DirectionIsInbound@1000 : Boolean);
    BEGIN
      IF DirectionIsInbound THEN
        Direction := Direction::Inbound
      ELSE
        Direction := Direction::Outbound;
      DirectionIsSet := TRUE;
    END;

    [External]
    PROCEDURE SetAssemblyLine@5(VAR CurrentAsmLine@1002 : Record 901;CurrentReservEntry@1001 : Record 337);
    BEGIN
      CurrentAsmLine.TESTFIELD(Type,CurrentAsmLine.Type::Item);
      AssemblyLine := CurrentAsmLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetAssemblyLine(AssemblyLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      AssemblyLineReserve.FilterReservFor(ReservEntry,AssemblyLine);
      CaptionText := AssemblyLineReserve.Caption(AssemblyLine);
      SetInbound(ReservMgt.IsPositive);
    END;

    [External]
    PROCEDURE SetAssemblyHeader@7(VAR CurrentAsmHeader@1000 : Record 900;CurrentReservEntry@1001 : Record 337);
    BEGIN
      AssemblyHeader := CurrentAsmHeader;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetAssemblyHeader(AssemblyHeader);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      AssemblyHeaderReserve.FilterReservFor(ReservEntry,AssemblyHeader);
      CaptionText := AssemblyHeaderReserve.Caption(AssemblyHeader);
      SetInbound(ReservMgt.IsPositive);
    END;

    BEGIN
    END.
  }
}

