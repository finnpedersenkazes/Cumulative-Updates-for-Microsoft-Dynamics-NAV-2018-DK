OBJECT Page 5814 Item Charge Assignment (Sales)
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varegebyrtildeling (salg);
               ENU=Item Charge Assignment (Sales)];
    InsertAllowed=No;
    SourceTable=Table5809;
    DataCaptionExpr=DataCaption;
    DelayedInsert=Yes;
    PopulateAllFields=Yes;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Varegebyr;
                                ENU=New,Process,Report,Item Charge];
    OnOpenPage=BEGIN
                 FILTERGROUP(2);
                 SETRANGE("Document Type",SalesLine2."Document Type");
                 SETRANGE("Document No.",SalesLine2."Document No.");
                 SETRANGE("Document Line No.",SalesLine2."Line No.");
                 SETRANGE("Item Charge No.",SalesLine2."No.");
                 FILTERGROUP(0);
               END;

    OnAfterGetRecord=BEGIN
                       UpdateQty;
                     END;

    OnDeleteRecord=BEGIN
                     IF "Document Type" = "Applies-to Doc. Type" THEN BEGIN
                       SalesLine2.TESTFIELD("Shipment No.",'');
                       SalesLine2.TESTFIELD("Return Receipt No.",'');
                     END;
                   END;

    OnAfterGetCurrRecord=BEGIN
                           UpdateQtyAssgnt;
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 20      ;2   ;Action    ;
                      Name=GetShipmentLines;
                      AccessByPermission=TableData 110=R;
                      CaptionML=[DAN=Hent &salgsleverancelinjer;
                                 ENU=Get &Shipment Lines];
                      ToolTipML=[DAN=V‘lg flere leveringer til den samme debitor, fordi du vil kombinere dem p† ‚n faktura.;
                                 ENU=Select multiple shipments to the same customer because you want to combine them on one invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Shipment;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ItemChargeAssgntSales@1001 : Record 5809;
                                 ShipmentLines@1002 : Page 5824;
                               BEGIN
                                 SalesLine2.TESTFIELD("Qty. to Invoice");

                                 ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
                                 ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
                                 ItemChargeAssgntSales.SETRANGE("Document Line No.","Document Line No.");

                                 ShipmentLines.SETTABLEVIEW(SalesShptLine);
                                 IF ItemChargeAssgntSales.FINDLAST THEN
                                   ShipmentLines.InitializeSales(ItemChargeAssgntSales,SalesLine2."Sell-to Customer No.",UnitCost)
                                 ELSE
                                   ShipmentLines.InitializeSales(Rec,SalesLine2."Sell-to Customer No.",UnitCost);

                                 ShipmentLines.LOOKUPMODE(TRUE);
                                 ShipmentLines.RUNMODAL;
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=GetReturnReceiptLines;
                      AccessByPermission=TableData 6660=R;
                      CaptionML=[DAN=Hent &returvaremodt.linjer;
                                 ENU=Get &Return Receipt Lines];
                      ToolTipML=[DAN=V‘lg en bogf›rt k›bsreturvaremodtagelse for den vare, du vil tildele varegebyret til, f.eks. hvis du har modtaget en faktura for varegebyret, n†r du har bogf›rt den oprindelige k›bsreturvare.;
                                 ENU=Select a posted purchase return receipt for the item that you want to assign the item charge to, for example, if you received an invoice for the item charge after you posted the original purchase return.];
                      ApplicationArea=#Advanced;
                      Image=ReturnReceipt;
                      OnAction=VAR
                                 ItemChargeAssgntSales@1001 : Record 5809;
                                 ReceiptLines@1002 : Page 6667;
                               BEGIN
                                 ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
                                 ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
                                 ItemChargeAssgntSales.SETRANGE("Document Line No.","Document Line No.");

                                 ReceiptLines.SETTABLEVIEW(ReturnRcptLine);
                                 IF ItemChargeAssgntSales.FINDLAST THEN
                                   ReceiptLines.InitializeSales(ItemChargeAssgntSales,SalesLine2."Sell-to Customer No.",UnitCost)
                                 ELSE
                                   ReceiptLines.InitializeSales(Rec,SalesLine2."Sell-to Customer No.",UnitCost);

                                 ReceiptLines.LOOKUPMODE(TRUE);
                                 ReceiptLines.RUNMODAL;
                               END;
                                }
      { 33      ;2   ;Action    ;
                      Name=SuggestItemChargeAssignment;
                      AccessByPermission=TableData 5800=R;
                      CaptionML=[DAN=Foresl† vareg&ebyrtildeling;
                                 ENU=Suggest Item &Charge Assignment];
                      ToolTipML=[DAN="Brug en funktion, der tildeler og fordeler varegebyret, n†r bilaget indeholder mere end ‚n linje med typen Vare. Du kan v‘lge mellem fire distributionsmetoder. ";
                                 ENU="Use a function that assigns and distributes the item charge when the document has more than one line of type Item. You can select between four distribution methods. "];
                      ApplicationArea=#ItemCharges;
                      Promoted=Yes;
                      Image=Suggest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 AssignItemChargeSales@1001 : Codeunit 5807;
                               BEGIN
                                 AssignItemChargeSales.SuggestAssignment(SalesLine2,AssignableQty,AssignableAmount);
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

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den type bilag, som dette bilag eller denne kladdelinje udlignes med, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the type of the document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Applies-to Doc. Type";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det bilag, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Applies-to Doc. No.";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den linje p† bilaget, som dette bilag eller denne kladdelinje udlignes p†, n†r du bogf›rer, f.eks. til registrering af betaling.;
                           ENU=Specifies the number of the line on the document that this document or journal line will be applied to when you post, for example to register payment.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Applies-to Doc. Line No.";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varenummeret for den bilagslinje, som dette varegebyr er tildelt til.;
                           ENU=Specifies the item number on the document line that this item charge is assigned to.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Item No.";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† den bilagslinje, som dette varegebyr er tildelt til.;
                           ENU=Specifies a description of the item on the document line that this item charge is assigned to.];
                ApplicationArea=#ItemCharges;
                SourceExpr=Description }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varegebyret der tildeles bilagslinjen. Hvis bilaget indeholder mere end ‚n linje af typen Vare, afspejler dette antal den fordeling, du valgte under valg af handlingen Foresl† varegebyrtildeling.;
                           ENU=Specifies how many units of the item charge will be assigned to the document line. If the document has more than one line of type Item, then this quantity reflects the distribution that you selected when you chose the Suggest Item Charge Assignment action.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Qty. to Assign";
                OnValidate=BEGIN
                             IF SalesLine2.Quantity * "Qty. to Assign" < 0 THEN
                               ERROR(Text000,
                                 FIELDCAPTION("Qty. to Assign"),SalesLine2.FIELDCAPTION(Quantity));
                             QtytoAssignOnAfterValidate;
                           END;
                            }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varegebyret der skal tildeles til bilagslinjen.;
                           ENU=Specifies the number of units of the item charge will be the assigned to the document line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Qty. Assigned" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den v‘rdi for varegebyret, som bliver tildelt bilagslinjen.;
                           ENU=Specifies the value of the item charge that will be the assigned to the document line.];
                ApplicationArea=#ItemCharges;
                SourceExpr="Amount to Assign";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Bruttov‘gt;
                           ENU=Gross Weight];
                ToolTipML=[DAN=Angiver den oprindelige v‘gt af en enhed af varen. V‘rdien kan blive brugt til at udfylde toldpapirer og fragtbreve.;
                           ENU=Specifies the initial weight of one unit of the item. The value may be used to complete customs documents and waybills.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:4;
                BlankZero=Yes;
                SourceExpr=GrossWeight;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Rumfang;
                           ENU=Unit Volume];
                ToolTipML=[DAN=Angiver rumfanget for en enhed af varen. V‘rdien kan blive brugt til at udfylde toldpapirer og fragtbreve.;
                           ENU=Specifies the volume of one unit of the item. The value may be used to complete customs documents and waybills.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:4;
                BlankZero=Yes;
                SourceExpr=UnitVolume;
                Editable=FALSE }

    { 36  ;2   ;Field     ;
                CaptionML=[DAN=Lever antal (basis);
                           ENU=Qty. to Ship (Base)];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† bilagslinjen for denne varegebyrtildeling der endnu ikke er bogf›rt som leveret.;
                           ENU=Specifies how many units of the item on the documents line for this item charge assignment have not yet been posted as shipped.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=QtyToShipBase;
                Editable=FALSE }

    { 38  ;2   ;Field     ;
                CaptionML=[DAN=Leveret antal (basis);
                           ENU=Qty. Shipped (Base)];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† bilagslinjen for denne varegebyrtildeling der er bogf›rt som leveret.;
                           ENU=Specifies how many units of the item on the documents line for this item charge assignment have been posted as shipped.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=QtyShippedBase;
                Editable=FALSE }

    { 40  ;2   ;Field     ;
                CaptionML=[DAN=Ant. retur til modtag. (basis);
                           ENU=Return Qty. to Receive (Base)];
                ToolTipML=[DAN=Angiver en v‘rdi, hvis salgslinjen p† denne tildelingslinje angiver enheder, som ikke er blevet bogf›rt som en modtaget returnering fra debitoren.;
                           ENU=Specifies a value if the sales line on this assignment line Specifies units that have not been posted as a received return from your customer.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=QtyToRetReceiveBase;
                Editable=FALSE }

    { 42  ;2   ;Field     ;
                CaptionML=[DAN=Antal modtaget retur (basis);
                           ENU=Return Qty. Received (Base)];
                ToolTipML=[DAN=Angiver antallet af returnerede enheder, der er bogf›rt som modtaget, p† salgslinjen p† denne tildelingslinje.;
                           ENU=Specifies the number of returned units that have been posted as received on the sales line on this assignment line.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=QtyRetReceivedBase;
                Editable=FALSE }

    { 22  ;1   ;Group      }

    { 1900669001;2;Group  ;
                GroupType=FixedLayout }

    { 1901991801;3;Group  ;
                CaptionML=[DAN=Kan tildeles;
                           ENU=Assignable] }

    { 26  ;4   ;Field     ;
                CaptionML=[DAN=I alt (antal);
                           ENU=Total (Qty.)];
                ToolTipML=[DAN=Angiver det samlede antal for varegebyret, du kan tildele til den relaterede bilagslinje.;
                           ENU=Specifies the total quantity of the item charge that you can assign to the related document line.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=AssignableQty;
                Editable=FALSE }

    { 28  ;4   ;Field     ;
                CaptionML=[DAN=I alt (bel›b);
                           ENU=Total (Amount)];
                ToolTipML=[DAN=Angiver den samlede v‘rdi for varegebyret, du kan tildele til den relaterede bilagslinje.;
                           ENU=Specifies the total value of the item charge that you can assign to the related document line.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=AssignableAmount;
                Editable=FALSE }

    { 1903099001;3;Group  ;
                CaptionML=[DAN=Skal tildeles;
                           ENU=To Assign] }

    { 24  ;4   ;Field     ;
                CaptionML=[DAN=Antal, der skal tildeles;
                           ENU=Qty. to Assign];
                ToolTipML=[DAN=Angiver det samlede antal for varegebyret, du kan tildele til den relaterede bilagslinje.;
                           ENU=Specifies the total quantity of the item charge that you can assign to the related document line.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=TotalQtyToAssign;
                Editable=FALSE }

    { 29  ;4   ;Field     ;
                CaptionML=[DAN=Bel›b der skal tildeles;
                           ENU=Amount to Assign];
                ToolTipML=[DAN=Angiver den samlede v‘rdi for varegebyret, du kan tildele til den relaterede bilagslinje.;
                           ENU=Specifies the total value of the item charge that you can assign to the related document line.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=TotalAmountToAssign;
                Editable=FALSE }

    { 1901313401;3;Group  ;
                CaptionML=[DAN=Resttildeling;
                           ENU=Rem. to Assign] }

    { 23  ;4   ;Field     ;
                CaptionML=[DAN=Restantal (til tildeling);
                           ENU=Rem. Qty. to Assign];
                ToolTipML=[DAN=Angiver antallet af varegebyrer, som du endnu ikke har tildelt til varer i tildelingslinjerne.;
                           ENU=Specifies the quantity of the item charge that you have not yet assigned to items in the assignment lines.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=RemQtyToAssign;
                Editable=FALSE;
                Style=Unfavorable;
                StyleExpr=RemQtyToAssign <> 0 }

    { 30  ;4   ;Field     ;
                Name=RemAmountToAssign;
                CaptionML=[DAN=Restbel›b (tildeles);
                           ENU=Rem. Amount to Assign];
                ToolTipML=[DAN=Angiver v‘rdien af det antal for varegebyret, som endnu ikke er blevet tildelt.;
                           ENU=Specifies the value of the quantity of the item charge that has not yet been assigned.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=RemAmountToAssign;
                Editable=FALSE;
                Style=Unfavorable;
                StyleExpr=RemAmountToAssign <> 0 }

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
      Text000@1000 : TextConst 'DAN=Tegnet i %1 skal v‘re identisk med tegnet i %2 i varegebyret.;ENU=The sign of %1 must be the same as the sign of %2 of the item charge.';
      SalesLine@1001 : Record 37;
      SalesLine2@1002 : Record 37;
      ReturnRcptLine@1003 : Record 6661;
      SalesShptLine@1004 : Record 111;
      AssignableQty@1005 : Decimal;
      TotalQtyToAssign@1006 : Decimal;
      RemQtyToAssign@1007 : Decimal;
      AssignableAmount@1008 : Decimal;
      TotalAmountToAssign@1009 : Decimal;
      RemAmountToAssign@1010 : Decimal;
      QtyToRetReceiveBase@1011 : Decimal;
      QtyRetReceivedBase@1012 : Decimal;
      QtyToShipBase@1013 : Decimal;
      QtyShippedBase@1014 : Decimal;
      UnitCost@1015 : Decimal;
      GrossWeight@1021 : Decimal;
      UnitVolume@1018 : Decimal;
      DataCaption@1016 : Text[250];

    LOCAL PROCEDURE UpdateQtyAssgnt@2();
    VAR
      ItemChargeAssgntSales@1000 : Record 5809;
    BEGIN
      SalesLine2.CALCFIELDS("Qty. to Assign","Qty. Assigned");
      AssignableQty := SalesLine2."Qty. to Invoice" + SalesLine2."Quantity Invoiced" - SalesLine2."Qty. Assigned";

      IF AssignableQty <> 0 THEN
        UnitCost := AssignableAmount / AssignableQty
      ELSE
        UnitCost := 0;

      ItemChargeAssgntSales.RESET;
      ItemChargeAssgntSales.SETCURRENTKEY("Document Type","Document No.","Document Line No.");
      ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
      ItemChargeAssgntSales.SETRANGE("Document Line No.","Document Line No.");
      ItemChargeAssgntSales.CALCSUMS("Qty. to Assign","Amount to Assign");
      TotalQtyToAssign := ItemChargeAssgntSales."Qty. to Assign";
      TotalAmountToAssign := ItemChargeAssgntSales."Amount to Assign";

      RemQtyToAssign := AssignableQty - TotalQtyToAssign;
      RemAmountToAssign := AssignableAmount - TotalAmountToAssign;
    END;

    LOCAL PROCEDURE UpdateQty@1();
    BEGIN
      CASE "Applies-to Doc. Type" OF
        "Applies-to Doc. Type"::Order,"Applies-to Doc. Type"::Invoice:
          BEGIN
            SalesLine.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToShipBase := SalesLine."Qty. to Ship (Base)";
            QtyShippedBase := SalesLine."Qty. Shipped (Base)";
            QtyToRetReceiveBase := 0;
            QtyRetReceivedBase := 0;
            GrossWeight := SalesLine."Gross Weight";
            UnitVolume := SalesLine."Unit Volume";
          END;
        "Applies-to Doc. Type"::"Return Order","Applies-to Doc. Type"::"Credit Memo":
          BEGIN
            SalesLine.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToRetReceiveBase := SalesLine."Return Qty. to Receive (Base)";
            QtyRetReceivedBase := SalesLine."Return Qty. Received (Base)";
            QtyToShipBase := 0;
            QtyShippedBase := 0;
            GrossWeight := SalesLine."Gross Weight";
            UnitVolume := SalesLine."Unit Volume";
          END;
        "Applies-to Doc. Type"::"Return Receipt":
          BEGIN
            ReturnRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToRetReceiveBase := 0;
            QtyRetReceivedBase := ReturnRcptLine."Quantity (Base)";
            QtyToShipBase := 0;
            QtyShippedBase := 0;
            GrossWeight := SalesLine."Gross Weight";
            UnitVolume := SalesLine."Unit Volume";
          END;
        "Applies-to Doc. Type"::Shipment:
          BEGIN
            SalesShptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToRetReceiveBase := 0;
            QtyRetReceivedBase := 0;
            QtyToShipBase := 0;
            QtyShippedBase := SalesShptLine."Quantity (Base)";
            GrossWeight := SalesLine."Gross Weight";
            UnitVolume := SalesLine."Unit Volume";
          END;
      END;
    END;

    [External]
    PROCEDURE Initialize@3(NewSalesLine@1000 : Record 37;NewLineAmt@1001 : Decimal);
    BEGIN
      SalesLine2 := NewSalesLine;
      DataCaption := SalesLine2."No." + ' ' + SalesLine2.Description;
      AssignableAmount := NewLineAmt;
    END;

    LOCAL PROCEDURE QtytoAssignOnAfterValidate@19000177();
    BEGIN
      CurrPage.UPDATE(FALSE);
      UpdateQtyAssgnt;
    END;

    BEGIN
    END.
  }
}

