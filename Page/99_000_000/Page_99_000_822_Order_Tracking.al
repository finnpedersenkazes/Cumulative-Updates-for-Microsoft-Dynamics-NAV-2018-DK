OBJECT Page 99000822 Order Tracking
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ordresporing;
               ENU=Order Tracking];
    SourceTable=Table99000799;
    DataCaptionExpr=TrackingMgt.GetCaption;
    PageType=Worksheet;
    OnInit=BEGIN
             UntrackedButtonEnable := TRUE;
           END;

    OnOpenPage=BEGIN
                 IF NOT Item.GET(CurrItemNo) THEN
                   CLEAR(Item);
                 TrackingMgt.FindRecords;
                 DemandedByVisible := TrackingMgt.IsSearchUp;
                 SuppliedByVisible := NOT TrackingMgt.IsSearchUp;

                 CurrUntrackedQuantity := CurrQuantity - TrackingMgt.TrackedQuantity;

                 UntrackedButtonEnable := IsPlanning;
               END;

    OnFindRecord=BEGIN
                   EXIT(TrackingMgt.FindRecord(Which,Rec));
                 END;

    OnNextRecord=BEGIN
                   EXIT(TrackingMgt.GetNextRecord(Steps,Rec));
                 END;

    OnAfterGetRecord=BEGIN
                       SuppliedbyOnFormat;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;Action    ;
                      Name=UntrackedButton;
                      CaptionML=[DAN=&Ikke-sporet antal;
                                 ENU=&Untracked Qty.];
                      ToolTipML=[DAN="Vis den del af det registrerede antal, der ikke direkte vedr›rer en eftersp›rgsel eller et udbud. ";
                                 ENU="View the part of the tracked quantity that is not directly related to a demand or supply. "];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Enabled=UntrackedButtonEnable;
                      Image=UntrackedQuantity;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Transparency.DrillDownUntrackedQty(TrackingMgt.GetCaption);
                               END;
                                }
      { 28      ;1   ;Action    ;
                      Name=Show;
                      CaptionML=[DAN=Vi&s;
                                 ENU=&Show];
                      ToolTipML=[DAN=Vis detaljer for ordresporing.;
                                 ENU=View the order tracking details.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 LookupName;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 27  ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 37  ;2   ;Field     ;
                CaptionML=[DAN=Varenr.;
                           ENU=Item No.];
                ToolTipML=[DAN=Angiver antallet af den vare, der er relateret til ordren.;
                           ENU=Specifies the number of the item related to the order.];
                ApplicationArea=#Advanced;
                SourceExpr=CurrItemNo;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Startdato;
                           ENU=Starting Date];
                ToolTipML=[DAN=Angiver startdatoen for den periode, som du vil spore ordren for.;
                           ENU=Specifies the starting date for the time period for which you want to track the order.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=StartingDate;
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Slutdato;
                           ENU=Ending Date];
                ToolTipML=[DAN=Angiver slutdatoen.;
                           ENU=Specifies the end date.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=EndingDate;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                Name=Total Quantity;
                CaptionML=[DAN=Antal;
                           ENU=Quantity];
                ToolTipML=[DAN=Angiver det udest†ende antal p† den linje, hvor du †bnede vinduet fra.;
                           ENU=Specifies the outstanding quantity on the line from which you opened the window.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=CurrQuantity + DerivedTrackingQty;
                Editable=FALSE }

    { 32  ;2   ;Field     ;
                Name=Untracked Quantity;
                CaptionML=[DAN=Ikkesporet antal;
                           ENU=Untracked Quantity];
                ToolTipML=[DAN=Angiver bel›bet for det antal, der ikke er direkte knyttet til et modsvarende behov eller en modsvarende forsyning ved ordresporing eller reservationer.;
                           ENU=Specifies the amount of the quantity not directly related to a countering demand or supply by order tracking or reservations.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=CurrUntrackedQuantity + DerivedTrackingQty;
                Editable=FALSE;
                OnDrillDown=BEGIN
                              IF NOT IsPlanning THEN
                                MESSAGE(Text001)
                              ELSE
                                Transparency.DrillDownUntrackedQty(TrackingMgt.GetCaption);
                            END;
                             }

    { 16  ;1   ;Group     ;
                Editable=FALSE;
                IndentationColumnName=SuppliedByIndent;
                IndentationControls=Name;
                GroupType=Repeater }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No.";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den linje, som varerne er sporet fra.;
                           ENU=Specifies the name of the line that the items are tracked from.];
                ApplicationArea=#Advanced;
                SourceExpr=Name;
                OnLookup=BEGIN
                           LookupName;
                         END;
                          }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kilden for det behov, som forsyningen spores fra.;
                           ENU=Specifies the source of the demand that the supply is tracked from.];
                ApplicationArea=#Advanced;
                SourceExpr="Demanded by";
                Visible=DemandedByVisible;
                OnLookup=BEGIN
                           LookupLine
                         END;
                          }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den forsyningskilde, der opfylder det behov, som du sporer fra, f.eks. en produktionsordrelinje.;
                           ENU=Specifies the source of the supply that fills the demand you track from, such as, a production order line.];
                ApplicationArea=#Advanced;
                SourceExpr="Supplied by";
                Visible=SuppliedByVisible;
                OnLookup=BEGIN
                           LookupLine;
                         END;
                          }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en datokonflikt i ordresporingsposterne for linjen.;
                           ENU=Specifies there is a date conflict in the order tracking entries for this line.];
                ApplicationArea=#Advanced;
                SourceExpr=Warning;
                Visible=FALSE }

    { 1   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for den linje, som varerne er sporet fra.;
                           ENU=Specifies the starting date of the line that the items are tracked from.];
                ApplicationArea=#Advanced;
                SourceExpr="Starting Date" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for den linje, som varerne er sporet fra.;
                           ENU=Specifies the ending date of the line that the items are tracked from.];
                ApplicationArea=#Advanced;
                SourceExpr="Ending Date" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet i basisenheder af den vare, der er blevet sporet i posten.;
                           ENU=Specifies the quantity, in the base unit of measure, of the item that has been tracked in this entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Quantity }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† bilaget er sendt eller leveret. En afsendelsesdato beregnes normalt ud fra en ›nsket leveringsdato plus leveringstiden.;
                           ENU=Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.];
                ApplicationArea=#Advanced;
                SourceExpr="Shipment Date";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor de sporede varer forventes at tilg† lageret.;
                           ENU=Specifies the date when the tracked items are expected to enter the inventory.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Receipt Date";
                Visible=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, der er sporet i denne post.;
                           ENU=Specifies the number of the item that has been tracked in this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No." }

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
      Item@1000 : Record 27;
      TrackingMgt@1016 : Codeunit 99000778;
      Transparency@1030 : Codeunit 99000856;
      CurrItemNo@1017 : Code[20];
      CurrQuantity@1018 : Decimal;
      CurrUntrackedQuantity@1019 : Decimal;
      StartingDate@1020 : Date;
      EndingDate@1021 : Date;
      DerivedTrackingQty@1028 : Decimal;
      IsPlanning@1029 : Boolean;
      Text001@1031 : TextConst 'DAN=Oplysninger om ikke-sporet antal er kun tilg‘ngelige for beregnede planl‘gningslinjer.;ENU=Information about untracked quantity is only available for calculated planning lines.';
      DemandedByVisible@19000447 : Boolean INDATASET;
      SuppliedByVisible@19035234 : Boolean INDATASET;
      UntrackedButtonEnable@19038303 : Boolean INDATASET;
      SuppliedByIndent@19043987 : Integer INDATASET;

    [External]
    PROCEDURE SetSalesLine@24(VAR CurrentSalesLine@1000 : Record 37);
    BEGIN
      TrackingMgt.SetSalesLine(CurrentSalesLine);

      CurrItemNo := CurrentSalesLine."No.";
      CurrQuantity := CurrentSalesLine."Outstanding Qty. (Base)";
      StartingDate := CurrentSalesLine."Shipment Date";
      EndingDate := CurrentSalesLine."Shipment Date";
    END;

    [External]
    PROCEDURE SetReqLine@23(VAR CurrentReqLine@1000 : Record 246);
    BEGIN
      TrackingMgt.SetReqLine(CurrentReqLine);

      CurrItemNo := CurrentReqLine."No.";
      CurrQuantity := CurrentReqLine."Quantity (Base)";
      StartingDate := CurrentReqLine."Due Date";
      EndingDate := CurrentReqLine."Due Date";

      IsPlanning := CurrentReqLine."Planning Line Origin" = CurrentReqLine."Planning Line Origin"::Planning;
      IF IsPlanning THEN
        Transparency.SetCurrReqLine(CurrentReqLine);
    END;

    [External]
    PROCEDURE SetPurchLine@22(VAR CurrentPurchLine@1000 : Record 39);
    BEGIN
      TrackingMgt.SetPurchLine(CurrentPurchLine);

      CurrItemNo := CurrentPurchLine."No.";
      CurrQuantity := CurrentPurchLine."Outstanding Qty. (Base)";

      StartingDate := CurrentPurchLine."Expected Receipt Date";
      EndingDate := CurrentPurchLine."Expected Receipt Date";
    END;

    [External]
    PROCEDURE SetProdOrderLine@19(VAR CurrentProdOrderLine@1000 : Record 5406);
    BEGIN
      TrackingMgt.SetProdOrderLine(CurrentProdOrderLine);

      CurrItemNo := CurrentProdOrderLine."Item No.";
      CurrQuantity := CurrentProdOrderLine."Remaining Qty. (Base)";
      StartingDate := CurrentProdOrderLine."Starting Date";
      EndingDate := CurrentProdOrderLine."Ending Date";
    END;

    [External]
    PROCEDURE SetProdOrderComponent@18(VAR CurrentProdOrderComp@1000 : Record 5407);
    BEGIN
      TrackingMgt.SetProdOrderComp(CurrentProdOrderComp);

      CurrItemNo := CurrentProdOrderComp."Item No.";
      CurrQuantity := CurrentProdOrderComp."Remaining Qty. (Base)";

      StartingDate := CurrentProdOrderComp."Due Date";
      EndingDate := CurrentProdOrderComp."Due Date";
    END;

    [External]
    PROCEDURE SetAsmHeader@8(VAR CurrentAsmHeader@1000 : Record 900);
    BEGIN
      TrackingMgt.SetAsmHeader(CurrentAsmHeader);

      CurrItemNo := CurrentAsmHeader."Item No.";
      CurrQuantity := CurrentAsmHeader."Remaining Quantity (Base)";

      StartingDate := CurrentAsmHeader."Due Date";
      EndingDate := CurrentAsmHeader."Due Date";
    END;

    [External]
    PROCEDURE SetAsmLine@9(VAR CurrentAsmLine@1000 : Record 901);
    BEGIN
      TrackingMgt.SetAsmLine(CurrentAsmLine);

      CurrItemNo := CurrentAsmLine."No.";
      CurrQuantity := CurrentAsmLine."Remaining Quantity (Base)";
      StartingDate := CurrentAsmLine."Due Date";
      EndingDate := CurrentAsmLine."Due Date";
    END;

    [External]
    PROCEDURE SetPlanningComponent@1(VAR CurrentPlanningComponent@1000 : Record 99000829);
    BEGIN
      TrackingMgt.SetPlanningComponent(CurrentPlanningComponent);

      CurrItemNo := CurrentPlanningComponent."Item No.";
      DerivedTrackingQty := CurrentPlanningComponent."Expected Quantity (Base)" - CurrentPlanningComponent."Net Quantity (Base)";
      CurrQuantity := CurrentPlanningComponent."Net Quantity (Base)";
      StartingDate := CurrentPlanningComponent."Due Date";
      EndingDate := CurrentPlanningComponent."Due Date";
    END;

    [External]
    PROCEDURE SetItemLedgEntry@4(VAR CurrentItemLedgEntry@1000 : Record 32);
    BEGIN
      TrackingMgt.SetItemLedgEntry(CurrentItemLedgEntry);

      CurrItemNo := CurrentItemLedgEntry."Item No.";
      CurrQuantity := CurrentItemLedgEntry."Remaining Quantity";
      StartingDate := CurrentItemLedgEntry."Posting Date";
      EndingDate := CurrentItemLedgEntry."Posting Date";
    END;

    [External]
    PROCEDURE SetMultipleItemLedgEntries@3(VAR TempItemLedgEntry@1001 : TEMPORARY Record 32;SourceType@1006 : Integer;SourceSubtype@1005 : Integer;SourceID@1004 : Code[20];SourceBatchName@1003 : Code[10];SourceProdOrderLine@1002 : Integer;SourceRefNo@1000 : Integer);
    BEGIN
      // Used from posted shipment and receipt with item tracking.

      TrackingMgt.SetMultipleItemLedgEntries(TempItemLedgEntry,SourceType,SourceSubtype,SourceID,
        SourceBatchName,SourceProdOrderLine,SourceRefNo);

      TempItemLedgEntry.CALCSUMS(TempItemLedgEntry."Remaining Quantity");

      CurrItemNo := TempItemLedgEntry."Item No.";
      CurrQuantity := TempItemLedgEntry."Remaining Quantity";
      StartingDate := TempItemLedgEntry."Posting Date";
      EndingDate := TempItemLedgEntry."Posting Date";
    END;

    [External]
    PROCEDURE SetServLine@6(VAR CurrentServLine@1000 : Record 5902);
    BEGIN
      TrackingMgt.SetServLine(CurrentServLine);

      CurrItemNo := CurrentServLine."No.";
      CurrQuantity := CurrentServLine."Outstanding Qty. (Base)";
      StartingDate := CurrentServLine."Needed by Date";
      EndingDate := CurrentServLine."Needed by Date";
    END;

    [External]
    PROCEDURE SetJobPlanningLine@7(VAR CurrentJobPlanningLine@1000 : Record 1003);
    BEGIN
      TrackingMgt.SetJobPlanningLine(CurrentJobPlanningLine);

      CurrItemNo := CurrentJobPlanningLine."No.";
      CurrQuantity := CurrentJobPlanningLine."Remaining Qty. (Base)";
      StartingDate := CurrentJobPlanningLine."Planning Date";
      EndingDate := CurrentJobPlanningLine."Planning Date";
    END;

    LOCAL PROCEDURE LookupLine@2();
    VAR
      ReservationMgt@1000 : Codeunit 99000845;
    BEGIN
      ReservationMgt.LookupLine("For Type","For Subtype","For ID","For Batch Name",
        "For Prod. Order Line","For Ref. No.");
    END;

    LOCAL PROCEDURE LookupName@5();
    VAR
      ReservationMgt@1000 : Codeunit 99000845;
    BEGIN
      ReservationMgt.LookupDocument("From Type","From Subtype","From ID","From Batch Name",
        "From Prod. Order Line","From Ref. No.");
    END;

    LOCAL PROCEDURE SuppliedbyOnFormat@19023034();
    BEGIN
      SuppliedByIndent := Level - 1;
    END;

    BEGIN
    END.
  }
}

