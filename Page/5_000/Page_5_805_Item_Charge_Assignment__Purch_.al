OBJECT Page 5805 Item Charge Assignment (Purch)
{
  OBJECT-PROPERTIES
  {
    Date=28-06-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23019;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varegebyrtildeling (k›b);
               ENU=Item Charge Assignment (Purch)];
    InsertAllowed=No;
    SourceTable=Table5805;
    DataCaptionExpr=DataCaption;
    DelayedInsert=Yes;
    PopulateAllFields=Yes;
    PageType=Worksheet;
    AutoSplitKey=Yes;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport‚r,Varegebyr;
                                ENU=New,Process,Report,Item Charge];
    OnOpenPage=BEGIN
                 FILTERGROUP(2);
                 SETRANGE("Document Type",PurchLine2."Document Type");
                 SETRANGE("Document No.",PurchLine2."Document No.");
                 SETRANGE("Document Line No.",PurchLine2."Line No.");
                 SETRANGE("Item Charge No.",PurchLine2."No.");
                 FILTERGROUP(0);
               END;

    OnAfterGetRecord=BEGIN
                       UpdateQty;
                     END;

    OnDeleteRecord=BEGIN
                     IF "Document Type" = "Applies-to Doc. Type" THEN BEGIN
                       PurchLine2.TESTFIELD("Receipt No.",'');
                       PurchLine2.TESTFIELD("Return Shipment No.",'');
                     END;
                   END;

    OnQueryClosePage=BEGIN
                       IF RemAmountToAssign <> 0 THEN
                         IF NOT CONFIRM(Text001,FALSE,RemAmountToAssign,"Document Type","Document No.") THEN
                           EXIT(FALSE);
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
                      Name=GetReceiptLines;
                      AccessByPermission=TableData 120=R;
                      CaptionML=[DAN=Hent &k›bsleverancelinjer;
                                 ENU=Get &Receipt Lines];
                      ToolTipML=[DAN=V‘lg en bogf›rt k›bsleverance for den vare, du vil tildele varegebyret til, f.eks. hvis du har modtaget en faktura for varegebyret, n†r du har bogf›rt den oprindelige k›bsleverance.;
                                 ENU=Select a posted purchase receipt for the item that you want to assign the item charge to, for example, if you received an invoice for the item charge after you posted the original purchase receipt.];
                      ApplicationArea=#ItemCharges;
                      Promoted=Yes;
                      Image=Receipt;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 ItemChargeAssgntPurch@1001 : Record 5805;
                                 ReceiptLines@1002 : Page 5806;
                               BEGIN
                                 PurchLine2.TESTFIELD("Qty. to Invoice");

                                 ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
                                 ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
                                 ItemChargeAssgntPurch.SETRANGE("Document Line No.","Document Line No.");

                                 ReceiptLines.SETTABLEVIEW(PurchRcptLine);
                                 IF ItemChargeAssgntPurch.FINDLAST THEN
                                   ReceiptLines.Initialize(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                                 ELSE
                                   ReceiptLines.Initialize(Rec,PurchLine2."Unit Cost");

                                 ReceiptLines.LOOKUPMODE(TRUE);
                                 ReceiptLines.RUNMODAL;
                               END;
                                }
      { 42      ;2   ;Action    ;
                      Name=GetTransferReceiptLines;
                      AccessByPermission=TableData 5740=R;
                      CaptionML=[DAN=Hent &overflytningskvit.linjer;
                                 ENU=Get &Transfer Receipt Lines];
                      ToolTipML=[DAN=V‘lg en bogf›rt overflytningsmodtagelse for den vare, du vil tildele varegebyret til, f.eks. hvis du har modtaget en faktura for varegebyret, n†r du har bogf›rt den oprindelige overflytningsmodtagelse.;
                                 ENU=Select a posted transfer receipt for the item that you want to assign the item charge to, for example, if you received an invoice for the item charge after you posted the original transfer receipt.];
                      ApplicationArea=#Advanced;
                      Image=TransferReceipt;
                      OnAction=VAR
                                 ItemChargeAssgntPurch@1001 : Record 5805;
                                 PostedTransferReceiptLines@1002 : Page 5759;
                               BEGIN
                                 ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
                                 ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
                                 ItemChargeAssgntPurch.SETRANGE("Document Line No.","Document Line No.");

                                 PostedTransferReceiptLines.SETTABLEVIEW(TransferRcptLine);
                                 IF ItemChargeAssgntPurch.FINDLAST THEN
                                   PostedTransferReceiptLines.Initialize(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                                 ELSE
                                   PostedTransferReceiptLines.Initialize(Rec,PurchLine2."Unit Cost");

                                 PostedTransferReceiptLines.LOOKUPMODE(TRUE);
                                 PostedTransferReceiptLines.RUNMODAL;
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=GetReturnShipmentLines;
                      AccessByPermission=TableData 6650=R;
                      CaptionML=[DAN=Hent retur&vareleverancelinjer;
                                 ENU=Get Return &Shipment Lines];
                      ToolTipML=[DAN=V‘lg en bogf›rt returvareleverance for den vare, du vil tildele varegebyret til, f.eks. hvis du har modtaget en faktura for varegebyret, n†r du har bogf›rt den oprindelige returvareleverance.;
                                 ENU=Select a posted return shipment for the item that you want to assign the item charge to, for example, if you received an invoice for the item charge after you posted the original return shipment.];
                      ApplicationArea=#Advanced;
                      Image=ReturnShipment;
                      OnAction=VAR
                                 ItemChargeAssgntPurch@1001 : Record 5805;
                                 ShipmentLines@1002 : Page 6657;
                               BEGIN
                                 ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
                                 ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
                                 ItemChargeAssgntPurch.SETRANGE("Document Line No.","Document Line No.");

                                 ShipmentLines.SETTABLEVIEW(ReturnShptLine);
                                 IF ItemChargeAssgntPurch.FINDLAST THEN
                                   ShipmentLines.Initialize(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                                 ELSE
                                   ShipmentLines.Initialize(Rec,PurchLine2."Unit Cost");

                                 ShipmentLines.LOOKUPMODE(TRUE);
                                 ShipmentLines.RUNMODAL;
                               END;
                                }
      { 43      ;2   ;Action    ;
                      Name=GetSalesShipmentLines;
                      AccessByPermission=TableData 110=R;
                      CaptionML=[DAN=&Hent salgsleverancelinjer;
                                 ENU=Get S&ales Shipment Lines];
                      ToolTipML=[DAN=V‘lg en bogf›rt salgsleverance for den vare, du vil tildele varegebyret til, f.eks. hvis du har modtaget en faktura for varegebyret, n†r du har bogf›rt den oprindelige salgsleverance.;
                                 ENU=Select a posted sales shipment for the item that you want to assign the item charge to, for example, if you received an invoice for the item charge after you posted the original sales shipment.];
                      ApplicationArea=#Advanced;
                      Image=SalesShipment;
                      OnAction=VAR
                                 ItemChargeAssgntPurch@1001 : Record 5805;
                                 SalesShipmentLines@1000 : Page 5824;
                               BEGIN
                                 ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
                                 ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
                                 ItemChargeAssgntPurch.SETRANGE("Document Line No.","Document Line No.");

                                 SalesShipmentLines.SETTABLEVIEW(SalesShptLine);
                                 IF ItemChargeAssgntPurch.FINDLAST THEN
                                   SalesShipmentLines.InitializePurchase(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                                 ELSE
                                   SalesShipmentLines.InitializePurchase(Rec,PurchLine2."Unit Cost");

                                 SalesShipmentLines.LOOKUPMODE(TRUE);
                                 SalesShipmentLines.RUNMODAL;
                               END;
                                }
      { 44      ;2   ;Action    ;
                      Name=GetReturnReceiptLines;
                      AccessByPermission=TableData 6660=R;
                      CaptionML=[DAN=Hent &returvaremodt.linjer;
                                 ENU=Get Ret&urn Receipt Lines];
                      ToolTipML=[DAN=V‘lg en bogf›rt returvaremodtagelse for den vare, du vil tildele varegebyret til, f.eks. hvis du har modtaget en faktura for varegebyret, n†r du har bogf›rt den oprindelige returvaremodtagelse.;
                                 ENU=Select a posted return receipt for the item that you want to assign the item charge to, for example, if you received an invoice for the item charge after you posted the original return receipt.];
                      ApplicationArea=#Advanced;
                      Image=ReturnReceipt;
                      OnAction=VAR
                                 ItemChargeAssgntPurch@1000 : Record 5805;
                                 ReturnRcptLines@1001 : Page 6667;
                               BEGIN
                                 ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
                                 ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
                                 ItemChargeAssgntPurch.SETRANGE("Document Line No.","Document Line No.");

                                 ReturnRcptLines.SETTABLEVIEW(ReturnRcptLine);
                                 IF ItemChargeAssgntPurch.FINDLAST THEN
                                   ReturnRcptLines.InitializePurchase(ItemChargeAssgntPurch,PurchLine2."Unit Cost")
                                 ELSE
                                   ReturnRcptLines.InitializePurchase(Rec,PurchLine2."Unit Cost");

                                 ReturnRcptLines.LOOKUPMODE(TRUE);
                                 ReturnRcptLines.RUNMODAL;
                               END;
                                }
      { 41      ;2   ;Action    ;
                      Name=SuggestItemChargeAssignment;
                      AccessByPermission=TableData 5800=R;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Foresl† vare&gebyrtildeling;
                                 ENU=Suggest &Item Charge Assignment];
                      ToolTipML=[DAN="Brug en funktion, der tildeler og fordeler varegebyret, n†r bilaget indeholder mere end ‚n linje med typen Vare. Du kan v‘lge mellem fire distributionsmetoder. ";
                                 ENU="Use a function that assigns and distributes the item charge when the document has more than one line of type Item. You can select between four distribution methods. "];
                      ApplicationArea=#ItemCharges;
                      Promoted=Yes;
                      Image=Suggest;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 AssignItemChargePurch@1001 : Codeunit 5805;
                               BEGIN
                                 AssignItemChargePurch.SuggestAssgnt(PurchLine2,AssignableQty,AssgntAmount);
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
                             IF PurchLine2.Quantity * "Qty. to Assign" < 0 THEN
                               ERROR(Text000,
                                 FIELDCAPTION("Qty. to Assign"),PurchLine2.FIELDCAPTION(Quantity));
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
                Name=<Gross Weight>;
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
                Name=<Unit Volume>;
                CaptionML=[DAN=Rumfang;
                           ENU=Unit Volume];
                ToolTipML=[DAN=Angiver rumfanget for en enhed af varen. V‘rdien kan blive brugt til at udfylde toldpapirer og fragtbreve.;
                           ENU=Specifies the volume of one unit of the item. The value may be used to complete customs documents and waybills.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:4;
                BlankZero=Yes;
                SourceExpr=UnitVolume;
                Editable=FALSE }

    { 33  ;2   ;Field     ;
                CaptionML=[DAN=Modtag antal (basis);
                           ENU=Qty. to Receive (Base)];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† bilagslinjen for denne varegebyrtildeling der endnu ikke er bogf›rt som modtaget.;
                           ENU=Specifies how many units of the item on the documents line for this item charge assignment have not yet been posted as received.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=QtyToReceiveBase;
                Editable=FALSE }

    { 35  ;2   ;Field     ;
                CaptionML=[DAN=Modtaget antal (basis);
                           ENU=Qty. Received (Base)];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† bilagslinjen for denne varegebyrtildeling der er bogf›rt som modtaget.;
                           ENU=Specifies how many units of the item on the documents line for this item charge assignment have been posted as received.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=QtyReceivedBase;
                Editable=FALSE }

    { 37  ;2   ;Field     ;
                CaptionML=[DAN=Lever antal (basis);
                           ENU=Qty. to Ship (Base)];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† bilagslinjen for denne varegebyrtildeling der endnu ikke er bogf›rt som leveret.;
                           ENU=Specifies how many units of the item on the documents line for this item charge assignment have not yet been posted as shipped.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=QtyToShipBase;
                Editable=FALSE }

    { 39  ;2   ;Field     ;
                CaptionML=[DAN=Leveret antal (basis);
                           ENU=Qty. Shipped (Base)];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† bilagslinjen for denne varegebyrtildeling der er bogf›rt som leveret.;
                           ENU=Specifies how many units of the item on the documents line for this item charge assignment have been posted as shipped.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                BlankZero=Yes;
                SourceExpr=QtyShippedBase;
                Editable=FALSE }

    { 22  ;1   ;Group      }

    { 1900669001;2;Group  ;
                GroupType=FixedLayout }

    { 1901652601;3;Group  ;
                CaptionML=[DAN=Kan tildeles;
                           ENU=Assignable] }

    { 23  ;4   ;Field     ;
                CaptionML=[DAN=I alt (antal);
                           ENU=Total (Qty.)];
                ToolTipML=[DAN=Angiver det samlede antal for varegebyret, du kan tildele til den relaterede bilagslinje.;
                           ENU=Specifies the total quantity of the item charge that you can assign to the related document line.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=AssignableQty;
                Editable=FALSE }

    { 30  ;4   ;Field     ;
                CaptionML=[DAN=I alt (bel›b);
                           ENU=Total (Amount)];
                ToolTipML=[DAN=Angiver den samlede v‘rdi for varegebyret, du kan tildele til den relaterede bilagslinje.;
                           ENU=Specifies the total value of the item charge that you can assign to the related document line.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=AssgntAmount;
                Editable=FALSE }

    { 1900545401;3;Group  ;
                CaptionML=[DAN=Skal tildeles;
                           ENU=To Assign] }

    { 25  ;4   ;Field     ;
                CaptionML=[DAN=Antal, der skal tildeles;
                           ENU=Qty. to Assign];
                ToolTipML=[DAN=Angiver det samlede antal for varegebyret, du kan tildele til den relaterede bilagslinje.;
                           ENU=Specifies the total quantity of the item charge that you can assign to the related document line.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=TotalQtyToAssign;
                Editable=FALSE }

    { 31  ;4   ;Field     ;
                CaptionML=[DAN=Bel›b der skal tildeles;
                           ENU=Amount to Assign];
                ToolTipML=[DAN=Angiver den samlede v‘rdi for varegebyret, du kan tildele til den relaterede bilagslinje.;
                           ENU=Specifies the total value of the item charge that you can assign to the related document line.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=TotalAmountToAssign;
                Editable=FALSE }

    { 1900295801;3;Group  ;
                CaptionML=[DAN=Resttildeling;
                           ENU=Rem. to Assign] }

    { 27  ;4   ;Field     ;
                CaptionML=[DAN=Restantal (til tildeling);
                           ENU=Rem. Qty. to Assign];
                ToolTipML=[DAN=Angiver den m‘ngde af varegebyret, som ikke er blevet tildelt endnu.;
                           ENU=Specifies the quantity of the item charge that has not yet been assigned.];
                ApplicationArea=#ItemCharges;
                DecimalPlaces=0:5;
                SourceExpr=RemQtyToAssign;
                Editable=FALSE;
                Style=Unfavorable;
                StyleExpr=RemQtyToAssign <> 0 }

    { 32  ;4   ;Field     ;
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
      PurchLine@1001 : Record 39;
      PurchLine2@1002 : Record 39;
      PurchRcptLine@1003 : Record 121;
      ReturnShptLine@1004 : Record 6651;
      TransferRcptLine@1019 : Record 5747;
      SalesShptLine@1017 : Record 111;
      ReturnRcptLine@1018 : Record 6661;
      AssignableQty@1005 : Decimal;
      TotalQtyToAssign@1006 : Decimal;
      RemQtyToAssign@1007 : Decimal;
      AssgntAmount@1008 : Decimal;
      TotalAmountToAssign@1009 : Decimal;
      RemAmountToAssign@1010 : Decimal;
      QtyToReceiveBase@1011 : Decimal;
      QtyReceivedBase@1012 : Decimal;
      QtyToShipBase@1013 : Decimal;
      QtyShippedBase@1014 : Decimal;
      DataCaption@1016 : Text[250];
      Text001@1020 : TextConst '@@@="%2 = Document Type, %3 = Document No.";DAN=Det restbel›b, der skal tildeles, er %1. Det skal v‘re nul, f›r du kan bogf›re %2 %3.\ \Er du sikker p†, at du vil lukke vinduet?;ENU=The remaining amount to assign is %1. It must be zero before you can post %2 %3.\ \Are you sure that you want to close the window?';
      GrossWeight@1021 : Decimal;
      UnitVolume@1015 : Decimal;

    LOCAL PROCEDURE UpdateQtyAssgnt@2();
    VAR
      ItemChargeAssgntPurch@1000 : Record 5805;
    BEGIN
      PurchLine2.CALCFIELDS("Qty. to Assign","Qty. Assigned");
      AssignableQty :=
        PurchLine2."Qty. to Invoice" + PurchLine2."Quantity Invoiced" - PurchLine2."Qty. Assigned";

      ItemChargeAssgntPurch.RESET;
      ItemChargeAssgntPurch.SETCURRENTKEY("Document Type","Document No.","Document Line No.");
      ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
      ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
      ItemChargeAssgntPurch.SETRANGE("Document Line No.","Document Line No.");
      ItemChargeAssgntPurch.CALCSUMS("Qty. to Assign","Amount to Assign");
      TotalQtyToAssign := ItemChargeAssgntPurch."Qty. to Assign";
      TotalAmountToAssign := ItemChargeAssgntPurch."Amount to Assign";

      RemQtyToAssign := AssignableQty - TotalQtyToAssign;
      RemAmountToAssign := AssgntAmount - TotalAmountToAssign;
    END;

    LOCAL PROCEDURE UpdateQty@1();
    BEGIN
      CASE "Applies-to Doc. Type" OF
        "Applies-to Doc. Type"::Order,"Applies-to Doc. Type"::Invoice:
          BEGIN
            PurchLine.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToReceiveBase := PurchLine."Qty. to Receive (Base)";
            QtyReceivedBase := PurchLine."Qty. Received (Base)";
            QtyToShipBase := 0;
            QtyShippedBase := 0;
            GrossWeight := PurchLine."Gross Weight";
            UnitVolume := PurchLine."Unit Volume";
          END;
        "Applies-to Doc. Type"::"Return Order","Applies-to Doc. Type"::"Credit Memo":
          BEGIN
            PurchLine.GET("Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToReceiveBase := 0;
            QtyReceivedBase := 0;
            QtyToShipBase := PurchLine."Return Qty. to Ship (Base)";
            QtyShippedBase := PurchLine."Return Qty. Shipped (Base)";
            GrossWeight := PurchLine."Gross Weight";
            UnitVolume := PurchLine."Unit Volume";
          END;
        "Applies-to Doc. Type"::Receipt:
          BEGIN
            PurchRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToReceiveBase := 0;
            QtyReceivedBase := PurchRcptLine."Quantity (Base)";
            QtyToShipBase := 0;
            QtyShippedBase := 0;
            GrossWeight := PurchRcptLine."Gross Weight";
            UnitVolume := PurchRcptLine."Unit Volume";
          END;
        "Applies-to Doc. Type"::"Return Shipment":
          BEGIN
            ReturnShptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToReceiveBase := 0;
            QtyReceivedBase := 0;
            QtyToShipBase := 0;
            QtyShippedBase := ReturnShptLine."Quantity (Base)";
            GrossWeight := ReturnShptLine."Gross Weight";
            UnitVolume := ReturnShptLine."Unit Volume";
          END;
        "Applies-to Doc. Type"::"Transfer Receipt":
          BEGIN
            TransferRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToReceiveBase := 0;
            QtyReceivedBase := TransferRcptLine.Quantity;
            QtyToShipBase := 0;
            QtyShippedBase := 0;
            GrossWeight := TransferRcptLine."Gross Weight";
            UnitVolume := TransferRcptLine."Unit Volume";
          END;
        "Applies-to Doc. Type"::"Sales Shipment":
          BEGIN
            SalesShptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToReceiveBase := 0;
            QtyReceivedBase := 0;
            QtyToShipBase := 0;
            QtyShippedBase := SalesShptLine."Quantity (Base)";
            GrossWeight := SalesShptLine."Gross Weight";
            UnitVolume := SalesShptLine."Unit Volume";
          END;
        "Applies-to Doc. Type"::"Return Receipt":
          BEGIN
            ReturnRcptLine.GET("Applies-to Doc. No.","Applies-to Doc. Line No.");
            QtyToReceiveBase := 0;
            QtyReceivedBase := ReturnRcptLine."Quantity (Base)";
            QtyToShipBase := 0;
            QtyShippedBase := 0;
            GrossWeight := ReturnRcptLine."Gross Weight";
            UnitVolume := ReturnRcptLine."Unit Volume";
          END;
      END;
    END;

    [External]
    PROCEDURE Initialize@3(NewPurchLine@1000 : Record 39;NewLineAmt@1001 : Decimal);
    BEGIN
      PurchLine2 := NewPurchLine;
      DataCaption := PurchLine2."No." + ' ' + PurchLine2.Description;
      AssgntAmount := NewLineAmt;
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

