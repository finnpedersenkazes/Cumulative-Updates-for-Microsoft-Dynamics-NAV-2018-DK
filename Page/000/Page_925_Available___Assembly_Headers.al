OBJECT Page 925 Available - Assembly Headers
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Permissions=TableData 900=rm;
    CaptionML=[DAN=Disponible - montageoverskrifter;
               ENU=Available - Assembly Headers];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table900;
    DataCaptionExpr=CaptionText;
    SourceTableView=SORTING(Document Type,Item No.,Variant Code,Location Code,Due Date);
    PageType=List;
    OnOpenPage=BEGIN
                 ReservEntry.TESTFIELD("Source Type");

                 SETRANGE("Document Type",CurrentSubType);
                 SETRANGE("Item No.",ReservEntry."Item No.");
                 SETRANGE("Variant Code",ReservEntry."Variant Code");
                 SETRANGE("Location Code",ReservEntry."Location Code");
                 SETFILTER("Due Date",ReservMgt.GetAvailabilityFilter(ReservEntry."Shipment Date"));
                 IF ReservMgt.IsPositive THEN
                   SETFILTER("Remaining Quantity (Base)",'>0')
                 ELSE
                   SETFILTER("Remaining Quantity (Base)",'<0');
               END;

    OnAfterGetRecord=BEGIN
                       ReservMgt.AssemblyHeaderUpdateValues(Rec,QtyToReserve,QtyToReserveBase,QtyReservedThisLine,QtyReservedThisLineBase);
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 21      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
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
                      ApplicationArea=#Basic,#Suite;
                      Image=Reserve;
                      OnAction=BEGIN
                                 ReservEntry.LOCKTABLE;
                                 UpdateReservMgt;
                                 ReservMgt.AssemblyHeaderUpdateValues(Rec,QtyToReserve,QtyToReserveBase,QtyReservedThisLine,QtyReservedThisLineBase);
                                 ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine,NewQtyReservedThisLineBase);
                                 ReservMgt.CopySign(NewQtyReservedThisLine,QtyToReserve);
                                 ReservMgt.CopySign(NewQtyReservedThisLineBase,QtyToReserveBase);
                                 IF NewQtyReservedThisLineBase <> 0 THEN
                                   IF NewQtyReservedThisLineBase > QtyToReserveBase THEN
                                     CreateReservation(QtyToReserve,QtyToReserveBase)
                                   ELSE
                                     CreateReservation(NewQtyReservedThisLine,NewQtyReservedThisLineBase)
                                 ELSE
                                   ERROR(Text000);
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=CancelReservation;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=&Annuller reservation;
                                 ENU=&Cancel Reservation];
                      ToolTipML=[DAN=Annuller reservationen, der findes p† den bilagslinje, som vinduet blev †bnet for.;
                                 ENU=Cancel the reservation that exists for the document line that you opened this window for.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Cancel;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(Text001,FALSE) THEN
                                   EXIT;

                                 ReservEntry2.COPY(ReservEntry);
                                 AssemblyHeaderReserve.FilterReservFor(ReservEntry2,Rec);
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

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver montagedokumenttypen, som recorden repr‘senterer i ordremontagescenarier.;
                           ENU=Specifies the type of assembly document the record represents in assemble-to-order scenarios.];
                ApplicationArea=#Assembly;
                SourceExpr="Document Type" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, som du vil bogf›re afgangen af montageelementet for.;
                           ENU=Specifies the location to which you want to post output of the assembly item.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageelementet skal v‘re tilg‘ngeligt.;
                           ENU=Specifies the date when the assembled item is due to be available for use.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet, der mangler at blive bogf›rt som monteret afgang.;
                           ENU=Specifies how many units of the assembly item remain to be posted as assembled output.];
                ApplicationArea=#Assembly;
                SourceExpr="Remaining Quantity" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange montageelementer angivet i basisenheden der er reserveret til montageordrehovedet.;
                           ENU=Specifies how many assembly items, which are stated in the base unit of measure, are reserved for this assembly order header.];
                ApplicationArea=#Assembly;
                SourceExpr="Reserved Qty. (Base)";
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Disponibelt antal;
                           ENU=Available Quantity];
                ToolTipML=[DAN=Angiver antallet af den vare, der er tilg‘ngelig.;
                           ENU=Specifies the quantity of the item that is available.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr=QtyToReserveBase;
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                Name=ReservedThisLine;
                CaptionML=[DAN=Aktuelt reserveret antal;
                           ENU=Current Reserved Quantity];
                ToolTipML=[DAN=Angiver antallet af den vare, der er reserveret for dokumenttypen.;
                           ENU=Specifies the quantity of the item that is reserved for the document type.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr=ReservedThisLine;
                OnDrillDown=BEGIN
                              ReservEntry2.RESET;
                              AssemblyHeaderReserve.FilterReservFor(ReservEntry2,Rec);
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
      Text000@1000 : TextConst 'DAN=Helt reserveret.;ENU=Fully reserved.';
      Text001@1001 : TextConst 'DAN=Skal reservationen annulleres?;ENU=Do you want to cancel the reservation?';
      Text002@1002 : TextConst 'DAN=Disponibelt antal er %1.;ENU=Available Quantity is %1.';
      ReservEntry@1003 : Record 337;
      ReservEntry2@1004 : Record 337;
      SalesLine@1005 : Record 37;
      PurchLine@1006 : Record 39;
      ReqLine@1008 : Record 246;
      ProdOrderLine@1009 : Record 5406;
      ProdOrderComp@1010 : Record 5407;
      PlanningComponent@1011 : Record 99000829;
      TransLine@1012 : Record 5741;
      ServiceLine@1013 : Record 5902;
      JobPlanningLine@1030 : Record 1003;
      AssemblyLine@1032 : Record 901;
      AssemblyHeader@1033 : Record 900;
      ReservMgt@1014 : Codeunit 99000845;
      ReservEngineMgt@1015 : Codeunit 99000831;
      SalesLineReserve@1016 : Codeunit 99000832;
      ReqLineReserve@1017 : Codeunit 99000833;
      ProdOrderLineReserve@1020 : Codeunit 99000837;
      ProdOrderCompReserve@1021 : Codeunit 99000838;
      TransLineReserve@1023 : Codeunit 99000836;
      ServiceLineReserve@1036 : Codeunit 99000842;
      JobPlanningLineReserve@1031 : Codeunit 1032;
      AssemblyHeaderReserve@1034 : Codeunit 925;
      AssemblyLineReserve@1035 : Codeunit 926;
      PurchLineReserve@1046 : Codeunit 99000834;
      PlngComponentReserve@1047 : Codeunit 99000840;
      QtyToReserve@1025 : Decimal;
      QtyToReserveBase@1018 : Decimal;
      QtyReservedThisLine@1026 : Decimal;
      QtyReservedThisLineBase@1019 : Decimal;
      NewQtyReservedThisLine@1027 : Decimal;
      NewQtyReservedThisLineBase@1007 : Decimal;
      CaptionText@1028 : Text[80];
      CurrentSubType@1029 : Option;

    [External]
    PROCEDURE SetSalesLine@24(VAR CurrentSalesLine@1000 : Record 37;CurrentReservEntry@1001 : Record 337);
    BEGIN
      CurrentSalesLine.TESTFIELD(Type,CurrentSalesLine.Type::Item);
      SalesLine := CurrentSalesLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetSalesLine(SalesLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      SalesLineReserve.FilterReservFor(ReservEntry,SalesLine);
      CaptionText := SalesLineReserve.Caption(SalesLine);
    END;

    [External]
    PROCEDURE SetReqLine@23(VAR CurrentReqLine@1000 : Record 246;CurrentReservEntry@1001 : Record 337);
    BEGIN
      ReqLine := CurrentReqLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetReqLine(ReqLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReqLineReserve.FilterReservFor(ReservEntry,ReqLine);
      CaptionText := ReqLineReserve.Caption(ReqLine);
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
      PurchLineReserve.FilterReservFor(ReservEntry,PurchLine);
      CaptionText := PurchLineReserve.Caption(PurchLine);
    END;

    [External]
    PROCEDURE SetProdOrderLine@19(VAR CurrentProdOrderLine@1000 : Record 5406;CurrentReservEntry@1001 : Record 337);
    BEGIN
      ProdOrderLine := CurrentProdOrderLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetProdOrderLine(ProdOrderLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ProdOrderLineReserve.FilterReservFor(ReservEntry,ProdOrderLine);
      CaptionText := ProdOrderLineReserve.Caption(ProdOrderLine);
    END;

    [External]
    PROCEDURE SetProdOrderComponent@18(VAR CurrentProdOrderComp@1000 : Record 5407;CurrentReservEntry@1001 : Record 337);
    BEGIN
      ProdOrderComp := CurrentProdOrderComp;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetProdOrderComponent(ProdOrderComp);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ProdOrderCompReserve.FilterReservFor(ReservEntry,ProdOrderComp);
      CaptionText := ProdOrderCompReserve.Caption(ProdOrderComp);
    END;

    [External]
    PROCEDURE SetPlanningComponent@15(VAR CurrentPlanningComponent@1000 : Record 99000829;CurrentReservEntry@1001 : Record 337);
    BEGIN
      PlanningComponent := CurrentPlanningComponent;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetPlanningComponent(PlanningComponent);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      PlngComponentReserve.FilterReservFor(ReservEntry,PlanningComponent);
      CaptionText := PlngComponentReserve.Caption(PlanningComponent);
    END;

    [External]
    PROCEDURE SetTransferLine@16(VAR CurrentTransLine@1000 : Record 5741;CurrentReservEntry@1001 : Record 337;Direction@1002 : 'Outbound,Inbound');
    BEGIN
      TransLine := CurrentTransLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetTransferLine(TransLine,Direction);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      TransLineReserve.FilterReservFor(ReservEntry,TransLine,Direction);
      CaptionText := TransLineReserve.Caption(TransLine);
    END;

    [External]
    PROCEDURE SetServiceInvLine@8(VAR CurrentServiceLine@1000 : Record 5902;CurrentReservEntry@1001 : Record 337);
    BEGIN
      CurrentServiceLine.TESTFIELD(Type,CurrentServiceLine.Type::Item);
      ServiceLine := CurrentServiceLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetServLine(ServiceLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ServiceLineReserve.FilterReservFor(ReservEntry,ServiceLine);
      CaptionText := ServiceLineReserve.Caption(ServiceLine);
    END;

    [External]
    PROCEDURE SetJobPlanningLine@1(VAR CurrentJobPlanningLine@1000 : Record 1003;CurrentReservEntry@1001 : Record 337);
    BEGIN
      CurrentJobPlanningLine.TESTFIELD(Type,CurrentJobPlanningLine.Type::Item);
      JobPlanningLine := CurrentJobPlanningLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetJobPlanningLine(JobPlanningLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      JobPlanningLineReserve.FilterReservFor(ReservEntry,JobPlanningLine);
      CaptionText := JobPlanningLineReserve.Caption(JobPlanningLine);
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
    END;

    [External]
    PROCEDURE SetAssemblyLine@4(VAR CurrentAssemblyLine@1000 : Record 901;CurrentReservEntry@1001 : Record 337);
    BEGIN
      AssemblyLine := CurrentAssemblyLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetAssemblyLine(AssemblyLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      AssemblyLineReserve.FilterReservFor(ReservEntry,AssemblyLine);
      CaptionText := AssemblyLineReserve.Caption(AssemblyLine);
    END;

    LOCAL PROCEDURE CreateReservation@14(ReserveQuantity@1001 : Decimal;ReserveQuantityBase@1000 : Decimal);
    VAR
      TrackingSpecification@1002 : Record 336;
    BEGIN
      CALCFIELDS("Reserved Qty. (Base)");

      IF "Remaining Quantity (Base)" + "Reserved Qty. (Base)" < ReserveQuantityBase THEN
        ERROR(Text002,"Remaining Quantity (Base)" + "Reserved Qty. (Base)");

      TESTFIELD("Item No.",ReservEntry."Item No.");
      TESTFIELD("Variant Code",ReservEntry."Variant Code");
      TESTFIELD("Location Code",ReservEntry."Location Code");

      UpdateReservMgt;
      TrackingSpecification.InitTrackingSpecification2(
        DATABASE::"Assembly Header","Document Type","No." ,'',0,0,"Variant Code","Location Code","Qty. per Unit of Measure");
      ReservMgt.CreateReservation(
        ReservEntry.Description,"Due Date",ReserveQuantity,ReserveQuantityBase,TrackingSpecification);
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
        DATABASE::"Planning Component":
          BEGIN
            PlanningComponent.FIND;
            SetPlanningComponent(PlanningComponent,ReservEntry);
          END;
        DATABASE::"Transfer Line":
          BEGIN
            TransLine.FIND;
            SetTransferLine(TransLine,ReservEntry,ReservEntry."Source Subtype");
          END;
        DATABASE::"Service Line":
          BEGIN
            ServiceLine.FIND;
            SetServiceInvLine(ServiceLine,ReservEntry);
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
        DATABASE::"Planning Component":
          ReservMgt.SetPlanningComponent(PlanningComponent);
        DATABASE::"Transfer Line":
          ReservMgt.SetTransferLine(TransLine,ReservEntry."Source Subtype");
        DATABASE::"Service Line":
          ReservMgt.SetServLine(ServiceLine);
        DATABASE::"Job Planning Line":
          ReservMgt.SetJobPlanningLine(JobPlanningLine);
        DATABASE::"Assembly Line":
          ReservMgt.SetAssemblyLine(AssemblyLine);
      END;
    END;

    LOCAL PROCEDURE ReservedThisLine@2() : Decimal;
    BEGIN
      ReservEntry2.RESET;
      AssemblyHeaderReserve.FilterReservFor(ReservEntry2,Rec);
      ReservEntry2.SETRANGE("Reservation Status",ReservEntry2."Reservation Status"::Reservation);
      EXIT(ReservMgt.MarkReservConnection(ReservEntry2,ReservEntry));
    END;

    [External]
    PROCEDURE SetCurrentSubType@9(SubType@1000 : Option);
    BEGIN
      CurrentSubType := SubType;
    END;

    BEGIN
    END.
  }
}

