OBJECT Page 497 Reservation Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Reservationsposter;
               ENU=Reservation Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table337;
    DataCaptionExpr=TextCaption;
    PageType=List;
    OnModifyRecord=BEGIN
                     ReservEngineMgt.ModifyReservEntry(xRec,"Quantity (Base)",Description,TRUE);
                     EXIT(FALSE);
                   END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 61      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 64      ;2   ;Action    ;
                      Name=CancelReservation;
                      AccessByPermission=TableData 27=R;
                      CaptionML=[DAN=Annuller reservation;
                                 ENU=Cancel Reservation];
                      ToolTipML=[DAN=Annuller den valgte reservationspost.;
                                 ENU=Cancel the selected reservation entry.];
                      ApplicationArea=#Advanced;
                      Image=Cancel;
                      OnAction=VAR
                                 ReservEntry@1001 : Record 337;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReservEntry);
                                 IF ReservEntry.FIND('-') THEN
                                   REPEAT
                                     ReservEntry.TESTFIELD("Reservation Status","Reservation Status"::Reservation);
                                     ReservEntry.TESTFIELD("Disallow Cancellation",FALSE);
                                     IF CONFIRM(
                                          Text001,FALSE,ReservEntry."Quantity (Base)",
                                          ReservEntry."Item No.",ReservEngineMgt.CreateForText(Rec),
                                          ReservEngineMgt.CreateFromText(Rec))
                                     THEN BEGIN
                                       ReservEngineMgt.CancelReservation(ReservEntry);
                                       COMMIT;
                                     END;
                                   UNTIL ReservEntry.NEXT = 0;
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

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for reservationen.;
                           ENU=Specifies the status of the reservation.];
                ApplicationArea=#Advanced;
                SourceExpr="Reservation Status";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, der er reserveret i denne post.;
                           ENU=Specifies the number of the item that has been reserved in this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No.";
                Editable=FALSE }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE;
                Editable=FALSE }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationen for de varer, der er reserveret i posten.;
                           ENU=Specifies the Location of the items that have been reserved in the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code";
                Editable=FALSE }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver serienummeret for den vare, der h†ndteres p† bilagslinjen.;
                           ENU=Specifies the serial number of the item that is being handled on the document line.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Serial No.";
                Visible=FALSE;
                Editable=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lotnummeret for varen, der h†ndteres p† den tilknyttede bilagslinje.;
                           ENU=Specifies the lot number of the item that is being handled with the associated document line.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Lot No.";
                Visible=FALSE;
                Editable=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor de reserverede varer forventes at tilg† lageret.;
                           ENU=Specifies the date on which the reserved items are expected to enter inventory.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Receipt Date";
                Visible=FALSE;
                Editable=FALSE }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date";
                Visible=FALSE;
                Editable=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af den vare, der er reserveret i posten.;
                           ENU=Specifies the quantity of the item that has been reserved in the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Quantity (Base)";
                OnValidate=BEGIN
                             ReservEngineMgt.ModifyReservEntry(xRec,"Quantity (Base)",Description,FALSE);
                             QuantityBaseOnAfterValidate;
                           END;
                            }

    { 53  ;2   ;Field     ;
                CaptionML=[DAN=Reserveret til;
                           ENU=Reserved For];
                ToolTipML=[DAN=Angiver, hvilken linje eller post varerne er reserveret til.;
                           ENU=Specifies which line or entry the items are reserved for.];
                ApplicationArea=#Advanced;
                SourceExpr=ReservEngineMgt.CreateForText(Rec);
                Editable=FALSE;
                OnLookup=BEGIN
                           LookupReservedFor;
                         END;
                          }

    { 51  ;2   ;Field     ;
                Name=ReservedFrom;
                CaptionML=[DAN=Reserveret fra;
                           ENU=Reserved From];
                ToolTipML=[DAN=Angiver, hvilken linje eller post varerne er reserveret fra.;
                           ENU=Specifies which line or entry the items are reserved from.];
                ApplicationArea=#Advanced;
                SourceExpr=ReservEngineMgt.CreateFromText(Rec);
                Editable=FALSE;
                OnLookup=BEGIN
                           LookupReservedFrom;
                         END;
                          }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af reservationsposten.;
                           ENU=Specifies a description of the reservation entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description;
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken kildetype reservationsposten vedr›rer.;
                           ENU=Specifies for which source type the reservation entry is related to.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Type";
                Visible=FALSE;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken kildeundertype reservationsposten vedr›rer.;
                           ENU=Specifies which source subtype the reservation entry is related to.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Subtype";
                Visible=FALSE;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilket kilde-id reservationsposten vedr›rer.;
                           ENU=Specifies which source ID the reservation entry is related to.];
                ApplicationArea=#Advanced;
                SourceExpr="Source ID";
                Visible=FALSE;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kladdek›rselsnavnet, hvis reservationsposten vedr›rer en kladde- eller rekvisitionslinje.;
                           ENU=Specifies the journal batch name if the reservation entry is related to a journal or requisition line.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Batch Name";
                Visible=FALSE;
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et referencenummer til den linje, som reservationsposten vedr›rer.;
                           ENU=Specifies a reference number for the line, which the reservation entry is related to.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Ref. No.";
                Visible=FALSE;
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No.";
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor posten blev oprettet.;
                           ENU=Specifies the date on which the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Creation Date";
                Visible=FALSE;
                Editable=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v‘rdi, hvor ordresporingsposten g‘lder det antal, der er tilbage p† en bilagslinje efter en delvis bogf›ring.;
                           ENU=Specifies a value when the order tracking entry is for the quantity that remains on a document line after a partial posting.];
                ApplicationArea=#Advanced;
                SourceExpr="Transferred from Entry No.";
                Editable=FALSE }

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
      Text001@1000 : TextConst 'DAN=Vil du annullere reservation af %1 af varenr. %2, der er reserveret til %3 fra %4?;ENU=Cancel reservation of %1 of item number %2, reserved for %3 from %4?';
      ReservEngineMgt@1015 : Codeunit 99000831;

    LOCAL PROCEDURE LookupReservedFor@2();
    VAR
      ReservEntry@1000 : Record 337;
    BEGIN
      ReservEntry.GET("Entry No.",FALSE);
      LookupReserved(ReservEntry);
    END;

    LOCAL PROCEDURE LookupReservedFrom@3();
    VAR
      ReservEntry@1000 : Record 337;
    BEGIN
      ReservEntry.GET("Entry No.",TRUE);
      LookupReserved(ReservEntry);
    END;

    LOCAL PROCEDURE LookupReserved@1(ReservEntry@1000 : Record 337);
    VAR
      SalesLine@1003 : Record 37;
      ReqLine@1004 : Record 246;
      PurchLine@1005 : Record 39;
      ItemJnlLine@1006 : Record 83;
      ItemLedgEntry@1008 : Record 32;
      ProdOrderLine@1009 : Record 5406;
      ProdOrderComp@1010 : Record 5407;
      PlanningComponent@1011 : Record 99000829;
      ServLine@1012 : Record 5902;
      JobPlanningLine@1016 : Record 1003;
      TransLine@1013 : Record 5741;
      AssemblyHeader@1017 : Record 900;
      AssemblyLine@1018 : Record 901;
    BEGIN
      WITH ReservEntry DO
        CASE "Source Type" OF
          DATABASE::"Sales Line":
            BEGIN
              SalesLine.RESET;
              SalesLine.SETRANGE("Document Type","Source Subtype");
              SalesLine.SETRANGE("Document No.","Source ID");
              SalesLine.SETRANGE("Line No.","Source Ref. No.");
              PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine);
            END;
          DATABASE::"Requisition Line":
            BEGIN
              ReqLine.RESET;
              ReqLine.SETRANGE("Worksheet Template Name","Source ID");
              ReqLine.SETRANGE("Journal Batch Name","Source Batch Name");
              ReqLine.SETRANGE("Line No.","Source Ref. No.");
              PAGE.RUNMODAL(PAGE::"Requisition Lines",ReqLine);
            END;
          DATABASE::"Purchase Line":
            BEGIN
              PurchLine.RESET;
              PurchLine.SETRANGE("Document Type","Source Subtype");
              PurchLine.SETRANGE("Document No.","Source ID");
              PurchLine.SETRANGE("Line No.","Source Ref. No.");
              PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
            END;
          DATABASE::"Item Journal Line":
            BEGIN
              ItemJnlLine.RESET;
              ItemJnlLine.SETRANGE("Journal Template Name","Source ID");
              ItemJnlLine.SETRANGE("Journal Batch Name","Source Batch Name");
              ItemJnlLine.SETRANGE("Line No.","Source Ref. No.");
              ItemJnlLine.SETRANGE("Entry Type","Source Subtype");
              PAGE.RUNMODAL(PAGE::"Item Journal Lines",ItemJnlLine);
            END;
          DATABASE::"Item Ledger Entry":
            BEGIN
              ItemLedgEntry.RESET;
              ItemLedgEntry.SETRANGE("Entry No.","Source Ref. No.");
              PAGE.RUNMODAL(0,ItemLedgEntry);
            END;
          DATABASE::"Prod. Order Line":
            BEGIN
              ProdOrderLine.RESET;
              ProdOrderLine.SETRANGE(Status,"Source Subtype");
              ProdOrderLine.SETRANGE("Prod. Order No.","Source ID");
              ProdOrderLine.SETRANGE("Line No.","Source Prod. Order Line");
              PAGE.RUNMODAL(0,ProdOrderLine);
            END;
          DATABASE::"Prod. Order Component":
            BEGIN
              ProdOrderComp.RESET;
              ProdOrderComp.SETRANGE(Status,"Source Subtype");
              ProdOrderComp.SETRANGE("Prod. Order No.","Source ID");
              ProdOrderComp.SETRANGE("Prod. Order Line No.","Source Prod. Order Line");
              ProdOrderComp.SETRANGE("Line No.","Source Ref. No.");
              PAGE.RUNMODAL(0,ProdOrderComp);
            END;
          DATABASE::"Planning Component":
            BEGIN
              PlanningComponent.RESET;
              PlanningComponent.SETRANGE("Worksheet Template Name","Source ID");
              PlanningComponent.SETRANGE("Worksheet Batch Name","Source Batch Name");
              PlanningComponent.SETRANGE("Worksheet Line No.","Source Prod. Order Line");
              PlanningComponent.SETRANGE("Line No.","Source Ref. No.");
              PAGE.RUNMODAL(0,PlanningComponent);
            END;
          DATABASE::"Transfer Line":
            BEGIN
              TransLine.RESET;
              TransLine.SETRANGE("Document No.","Source ID");
              TransLine.SETRANGE("Line No.","Source Ref. No.");
              TransLine.SETRANGE("Derived From Line No.","Source Prod. Order Line");
              PAGE.RUNMODAL(0,TransLine);
            END;
          DATABASE::"Service Line":
            BEGIN
              ServLine.SETRANGE("Document Type","Source Subtype");
              ServLine.SETRANGE("Document No.","Source ID");
              ServLine.SETRANGE("Line No.","Source Ref. No.");
              PAGE.RUNMODAL(0,ServLine);
            END;
          DATABASE::"Job Planning Line":
            BEGIN
              JobPlanningLine.SETRANGE(Status,"Source Subtype");
              JobPlanningLine.SETRANGE("Job No.","Source ID");
              JobPlanningLine.SETRANGE("Job Contract Entry No.","Source Ref. No.");
              PAGE.RUNMODAL(0,JobPlanningLine);
            END;
          DATABASE::"Assembly Header":
            BEGIN
              AssemblyHeader.SETRANGE("Document Type","Source Subtype");
              AssemblyHeader.SETRANGE("No.","Source ID");
              PAGE.RUNMODAL(0,AssemblyHeader);
            END;
          DATABASE::"Assembly Line":
            BEGIN
              AssemblyLine.SETRANGE("Document Type","Source Subtype");
              AssemblyLine.SETRANGE("Document No.","Source ID");
              AssemblyLine.SETRANGE("Line No.","Source Ref. No.");
              PAGE.RUNMODAL(0,AssemblyLine);
            END;
        END;
    END;

    LOCAL PROCEDURE QuantityBaseOnAfterValidate@19029188();
    BEGIN
      CurrPage.UPDATE;
    END;

    BEGIN
    END.
  }
}

