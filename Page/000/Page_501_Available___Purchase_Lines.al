OBJECT Page 501 Available - Purchase Lines
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    Permissions=TableData 39=rm;
    Editable=No;
    CaptionML=[DAN=Disponibel - k�bslinjer;
               ENU=Available - Purchase Lines];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table39;
    DataCaptionExpr=CaptionText;
    SourceTableView=SORTING(Document Type,Type,No.,Variant Code,Drop Shipment,Location Code,Expected Receipt Date);
    PageType=List;
    OnOpenPage=BEGIN
                 ReservEntry.TESTFIELD("Source Type");

                 SETRANGE("Document Type",CurrentSubType);
                 SETRANGE(Type,Type::Item);
                 SETRANGE("No.",ReservEntry."Item No.");
                 SETRANGE("Variant Code",ReservEntry."Variant Code");
                 SETRANGE("Job No.",'');
                 SETRANGE("Drop Shipment",FALSE);
                 SETRANGE("Location Code",ReservEntry."Location Code");

                 SETFILTER("Expected Receipt Date",ReservMgt.GetAvailabilityFilter(ReservEntry."Shipment Date"));

                 CASE CurrentSubType OF
                   0,1,2,4:
                     IF ReservMgt.IsPositive THEN
                       SETFILTER("Quantity (Base)",'>0')
                     ELSE
                       SETFILTER("Quantity (Base)",'<0');
                   3,5:
                     IF ReservMgt.IsPositive THEN
                       SETFILTER("Quantity (Base)",'<0')
                     ELSE
                       SETFILTER("Quantity (Base)",'>0');
                 END;
               END;

    OnAfterGetRecord=BEGIN
                       ReservMgt.PurchLineUpdateValues(Rec,QtyToReserve,QtyToReserveBase,QtyReservedThisLine,QtyReservedThisLineBase);
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 6500    ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p� bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 24      ;2   ;Action    ;
                      Name=Reserve;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n�dvendige m�ngde p� den bilagslinje, som vinduet blev �bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Advanced;
                      Image=Reserve;
                      OnAction=BEGIN
                                 ReservEntry.LOCKTABLE;
                                 UpdateReservMgt;
                                 ReservMgt.PurchLineUpdateValues(Rec,QtyToReserve,QtyToReserveBase,QtyReservedThisLine,QtyReservedThisLineBase);
                                 ReservMgt.CalculateRemainingQty(NewQtyReservedThisLine,NewQtyReservedThisLineBase);
                                 ReservMgt.CopySign(NewQtyReservedThisLineBase,QtyToReserveBase);
                                 ReservMgt.CopySign(NewQtyReservedThisLine,QtyToReserve);
                                 IF NewQtyReservedThisLineBase <> 0 THEN
                                   IF ABS(NewQtyReservedThisLineBase) > ABS(QtyToReserveBase) THEN
                                     CreateReservation(QtyToReserve,QtyToReserveBase)
                                   ELSE
                                     CreateReservation(NewQtyReservedThisLine,NewQtyReservedThisLineBase)
                                 ELSE
                                   ERROR(Text000);
                               END;
                                }
      { 25      ;2   ;Action    ;
                      Name=CancelReservation;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=&Annuller reservation;
                                 ENU=&Cancel Reservation];
                      ToolTipML=[DAN=Annuller reservationen, der findes p� den bilagslinje, som vinduet blev �bnet for.;
                                 ENU=Cancel the reservation that exists for the document line that you opened this window for.];
                      ApplicationArea=#Advanced;
                      Image=Cancel;
                      OnAction=BEGIN
                                 IF NOT CONFIRM(Text001,FALSE) THEN
                                   EXIT;

                                 ReservEntry2.COPY(ReservEntry);
                                 ReservePurchLine.FilterReservFor(ReservEntry2,Rec);

                                 IF ReservEntry2.FIND('-') THEN BEGIN
                                   UpdateReservMgt;
                                   REPEAT
                                     ReservEngineMgt.CancelReservation(ReservEntry2);
                                   UNTIL ReservEntry2.NEXT = 0;

                                   UpdateReservFrom;
                                 END;
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=ShowDocument;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=&Vis dokument;
                                 ENU=&Show Document];
                      ToolTipML=[DAN=�bn det bilag, som oplysningerne p� linjen stammer fra.;
                                 ENU=Open the document that the information on the line comes from.];
                      ApplicationArea=#Planning;
                      Image=View;
                      OnAction=VAR
                                 PageManagement@1000 : Codeunit 700;
                               BEGIN
                                 PurchHeader.GET("Document Type","Document No.");
                                 PageManagement.PageRun(PurchHeader);
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
                ToolTipML=[DAN=Angiver den dokumenttype, som du er ved at oprette.;
                           ENU=Specifies the type of document that you are about to create.];
                ApplicationArea=#Advanced;
                SourceExpr="Document Type" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bilagsnummeret.;
                           ENU=Specifies the document number.];
                ApplicationArea=#Advanced;
                SourceExpr="Document No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lokation, hvor varerne p� linjen bliver placeret.;
                           ENU=Specifies the code for the location where the items on the line will be located.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du forventer, at varerne er tilg�ngelige p� lageret.;
                           ENU=Specifies the date you expect the items to be available in your warehouse.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Receipt Date" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det udest�ende antal anf�rt i basisenhederne.;
                           ENU=Specifies the outstanding quantity expressed in the base units of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Outstanding Qty. (Base)" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det reserverede antal af varen specificeret i basisenheder.;
                           ENU=Specifies the reserved quantity of the item expressed in base units of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Reserved Qty. (Base)";
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                CaptionML=[DAN=Disponibelt antal;
                           ENU=Available Quantity];
                ToolTipML=[DAN=Angiver antallet af den vare, som kan reserveres.;
                           ENU=Specifies the quantity of the item that is available for reservation.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=QtyToReserveBase;
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                Name=ReservedThisLine;
                CaptionML=[DAN=Aktuelt reserveret antal;
                           ENU=Current Reserved Quantity];
                ToolTipML=[DAN=Angiver det antal af varen, som er reserveret fra k�bslinjen til den aktuelle linje eller post.;
                           ENU=Specifies the quantity of the item that is reserved from the purchase line, for the current line or entry.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=ReservedThisLine;
                OnDrillDown=BEGIN
                              ReservEntry2.RESET;
                              ReservePurchLine.FilterReservFor(ReservEntry2,Rec);
                              ReservEntry2.SETRANGE("Reservation Status",ReservEntry2."Reservation Status"::Reservation);
                              ReservMgt.MarkReservConnection(ReservEntry2,ReservEntry);
                              PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry2);
                              UpdateReservFrom;
                              CurrPage.UPDATE;
                            END;
                             }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Helt reserveret.;ENU=Fully reserved.';
      Text001@1001 : TextConst 'DAN=Skal reservationen annulleres?;ENU=Do you want to cancel the reservation?';
      Text003@1002 : TextConst 'DAN=Disponibelt antal er %1.;ENU=Available Quantity is %1.';
      ReservEntry@1003 : Record 337;
      ReservEntry2@1004 : Record 337;
      PurchHeader@1005 : Record 38;
      SalesLine@1006 : Record 37;
      PurchLine@1007 : Record 39;
      ReqLine@1009 : Record 246;
      ProdOrderLine@1010 : Record 5406;
      ProdOrderComp@1011 : Record 5407;
      PlanningComponent@1012 : Record 99000829;
      TransLine@1013 : Record 5741;
      ServiceInvLine@1014 : Record 5902;
      JobPlanningLine@1033 : Record 1003;
      AssemblyLine@1037 : Record 901;
      AssemblyHeader@1036 : Record 900;
      AssemblyLineReserve@1035 : Codeunit 926;
      AssemblyHeaderReserve@1034 : Codeunit 925;
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
      JobPlanningLineReserve@1032 : Codeunit 1032;
      QtyToReserve@1020 : Decimal;
      QtyToReserveBase@1026 : Decimal;
      QtyReservedThisLine@1038 : Decimal;
      QtyReservedThisLineBase@1027 : Decimal;
      NewQtyReservedThisLine@1008 : Decimal;
      NewQtyReservedThisLineBase@1028 : Decimal;
      CaptionText@1029 : Text[80];
      Direction@1030 : 'Outbound,Inbound';
      CurrentSubType@1031 : Option;

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
    END;

    [External]
    PROCEDURE SetProdOrderComponent@1(VAR CurrentProdOrderComp@1000 : Record 5407;CurrentReservEntry@1001 : Record 337);
    BEGIN
      ProdOrderComp := CurrentProdOrderComp;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetProdOrderComponent(ProdOrderComp);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReserveProdOrderComp.FilterReservFor(ReservEntry,ProdOrderComp);
      CaptionText := ReserveProdOrderComp.Caption(ProdOrderComp);
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
    END;

    [External]
    PROCEDURE SetTransferLine@16(VAR CurrentTransLine@1000 : Record 5741;CurrentReservEntry@1001 : Record 337;CurrDirection@1002 : 'Outbound,Inbound');
    BEGIN
      TransLine := CurrentTransLine;
      ReservEntry := CurrentReservEntry;
      Direction := CurrDirection;

      CLEAR(ReservMgt);
      ReservMgt.SetTransferLine(TransLine,Direction);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      ReserveTransLine.FilterReservFor(ReservEntry,TransLine,Direction);
      CaptionText := ReserveTransLine.Caption(TransLine);
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
    END;

    [External]
    PROCEDURE SetJobPlanningLine@3(VAR CurrentJobPlanningLine@1000 : Record 1003;CurrentReservEntry@1001 : Record 337);
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

    LOCAL PROCEDURE CreateReservation@14(ReservedQuantity@1001 : Decimal;ReserveQuantityBase@1000 : Decimal);
    VAR
      TrackingSpecification@1002 : Record 336;
    BEGIN
      CALCFIELDS("Reserved Qty. (Base)");
      IF (ABS("Outstanding Qty. (Base)") - ABS("Reserved Qty. (Base)")) < ReserveQuantityBase THEN
        ERROR(Text003,ABS("Outstanding Qty. (Base)") - "Reserved Qty. (Base)");

      TESTFIELD("Job No.",'');
      TESTFIELD("Drop Shipment",FALSE);
      TESTFIELD("No.",ReservEntry."Item No.");
      TESTFIELD("Variant Code",ReservEntry."Variant Code");
      TESTFIELD("Location Code",ReservEntry."Location Code");

      UpdateReservMgt;
      TrackingSpecification.InitTrackingSpecification2(
        DATABASE::"Purchase Line","Document Type","Document No.",'',0,"Line No.",
        "Variant Code","Location Code","Qty. per Unit of Measure");
      ReservMgt.CreateReservation(
        ReservEntry.Description,"Expected Receipt Date",ReservedQuantity,ReserveQuantityBase,TrackingSpecification);
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
            ServiceInvLine.FIND;
            SetServiceInvLine(ServiceInvLine,ReservEntry);
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
          ReservMgt.SetServLine(ServiceInvLine);
        DATABASE::"Job Planning Line":
          ReservMgt.SetJobPlanningLine(JobPlanningLine);
        DATABASE::"Assembly Line":
          ReservMgt.SetAssemblyLine(AssemblyLine);
        DATABASE::"Assembly Header":
          ReservMgt.SetAssemblyHeader(AssemblyHeader);
      END;
    END;

    LOCAL PROCEDURE ReservedThisLine@2() : Decimal;
    BEGIN
      ReservEntry2.RESET;
      IF ReservEntry."Source Type" = DATABASE::"Transfer Line" THEN
        ReservEntry."Source Subtype" := Direction;
      ReservePurchLine.FilterReservFor(ReservEntry2,Rec);
      ReservEntry2.SETRANGE("Reservation Status",ReservEntry2."Reservation Status"::Reservation);
      EXIT(ReservMgt.MarkReservConnection(ReservEntry2,ReservEntry));
    END;

    [External]
    PROCEDURE SetCurrentSubType@9(SubType@1000 : Option);
    BEGIN
      CurrentSubType := SubType;
    END;

    [External]
    PROCEDURE SetAssemblyLine@4(VAR CurrentAsmLine@1002 : Record 901;CurrentReservEntry@1001 : Record 337);
    BEGIN
      CurrentAsmLine.TESTFIELD(Type,CurrentAsmLine.Type::Item);
      AssemblyLine := CurrentAsmLine;
      ReservEntry := CurrentReservEntry;

      CLEAR(ReservMgt);
      ReservMgt.SetAssemblyLine(AssemblyLine);
      ReservEngineMgt.InitFilterAndSortingFor(ReservEntry,TRUE);
      AssemblyLineReserve.FilterReservFor(ReservEntry,AssemblyLine);
      CaptionText := AssemblyLineReserve.Caption(AssemblyLine);
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

    BEGIN
    END.
  }
}

