OBJECT Page 1328 Purch. Order From Sales Order
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opret k�bsordrer;
               ENU=Create Purchase Orders];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table246;
    PageType=Worksheet;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Varedisponering;
                                ENU=New,Process,Report,Item Availability];
    OnOpenPage=BEGIN
                 PlanForOrder;
               END;

    OnAfterGetRecord=VAR
                       Vendor@1000 : Record 23;
                     BEGIN
                       IF Vendor.GET("Supply From") THEN
                         VendorName := Vendor.Name
                       ELSE
                         VendorName := '';
                     END;

    OnQueryClosePage=BEGIN
                       IF CloseAction = ACTION::LookupOK THEN
                         ValidateSupplyFromVendor;
                     END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Indstil visning;
                                 ENU=Set View] }
      { 8       ;2   ;Action    ;
                      Name=ShowAll;
                      CaptionML=[DAN=Vis alle;
                                 ENU=Show All];
                      ToolTipML=[DAN=Vis linjer b�de for varer, der er fuldt tilg�ngelige, og varer, hvor et salgsantal ikke er tilg�ngeligt og skal k�bes.;
                                 ENU=Show lines both for items that are fully available and for items where a sales quantity is unavailable and must be purchased.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=ShowAllDocsIsEnable;
                      PromotedIsBig=Yes;
                      Image=AllLines;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 SetProcessedDocumentsVisibility(TRUE);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=ShowUnavailable;
                      CaptionML=[DAN=Vis utilg�ngelige;
                                 ENU=Show Unavailable];
                      ToolTipML=[DAN=Vis kun linjer for varer, hvor et salgsantal ikke er tilg�ngeligt og skal k�bes.;
                                 ENU=Show lines only for items where a sales quantity is unavailable and must be purchased.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Enabled=NOT ShowAllDocsIsEnable;
                      PromotedIsBig=Yes;
                      Image=Document;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=BEGIN
                                 SetProcessedDocumentsVisibility(FALSE);
                               END;
                                }
      { 19      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 18      ;1   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      Image=ItemAvailability }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=H�ndelse;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg�ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp�rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Event;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByEvent)
                               END;
                                }
      { 16      ;2   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Viser det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m�ned.;
                                 ENU=Show the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Suite;
                      Promoted=Yes;
                      Image=Period;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByPeriod)
                               END;
                                }
      { 15      ;2   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=ItemVariant;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByVariant)
                               END;
                                }
      { 14      ;2   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Promoted=Yes;
                      Image=Warehouse;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByLocation)
                               END;
                                }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F� vist tilg�ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p� tilg�ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=BOMLevel;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromReqLine(Rec,ItemAvailFormsMgt.ByBOM)
                               END;
                                }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Tidslinje;
                                 ENU=Timeline];
                      ToolTipML=[DAN=F� en grafisk visning af en vares planlagte lager baseret p� fremtidige udbuds- og eftersp�rgselsh�ndelser med eller uden planl�gningsforslag. Resultatet er en grafisk gengivelse af lagerprofilen.;
                                 ENU=Get a graphical view of an item's projected inventory based on future supply and demand events, with or without planning suggestions. The result is a graphical representation of the inventory profile.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=Timeline;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      Scope=Repeater;
                      OnAction=BEGIN
                                 ShowTimeline(Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Suite;
                SourceExpr="No.";
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=Quantity = 0 }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af k�bsordren.;
                           ENU=Specifies a description of the purchase order.];
                ApplicationArea=#Suite;
                SourceExpr=Description;
                Editable=FALSE;
                Style=Subordinate;
                StyleExpr=Quantity = 0 }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Antal i salgsordre;
                           ENU=Sales Order Quantity];
                ToolTipML=[DAN=Angiver det salgsordreantal, der vedr�rer varen p� k�bsordrelinjen.;
                           ENU=Specifies the sales order quantity relating to the purchase order line item.];
                ApplicationArea=#Suite;
                SourceExpr="Demand Quantity";
                Style=Subordinate;
                StyleExpr=Quantity = 0 }

    { 9   ;2   ;Field     ;
                Name=Vendor;
                CaptionML=[DAN=Kreditor;
                           ENU=Vendor];
                ToolTipML=[DAN=Angiver den kreditor, der skal levere varerne i k�bsordren.;
                           ENU=Specifies the vendor who will ship the items in the purchase order.];
                ApplicationArea=#Suite;
                SourceExpr=VendorName;
                Style=Subordinate;
                StyleExpr=Quantity = 0;
                OnValidate=VAR
                             Vendor@1000 : Record 23;
                           BEGIN
                             TESTFIELD("Replenishment System","Replenishment System"::Purchase);
                             VALIDATE("Supply From",Vendor.GetVendorNo(VendorName));
                             IF Vendor.GET("Supply From") THEN
                               VendorName := Vendor.Name
                             ELSE
                               VendorName := "Supply From";
                           END;

                OnLookup=VAR
                           Vendor@1000 : Record 23;
                         BEGIN
                           TESTFIELD("Replenishment System","Replenishment System"::Purchase);
                           IF NOT LookupVendor(Vendor,FALSE) THEN
                             EXIT;

                           VALIDATE("Supply From",Vendor."No.");
                           VendorName := Vendor.Name;
                         END;

                ShowMandatory=TRUE }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=K�bsantal;
                           ENU=Quantity to Purchase];
                ToolTipML=[DAN=Angiver det antal, der skal k�bes.;
                           ENU=Specifies the quantity to be purchased.];
                ApplicationArea=#Suite;
                SourceExpr=Quantity;
                Style=Strong }

  }
  CODE
  {
    VAR
      ItemAvailFormsMgt@1003 : Codeunit 353;
      OrderNo@1001 : Code[20];
      EntireOrderIsAvailableTxt@1002 : TextConst 'DAN=Alle varer p� salgsordren er tilg�ngelige.;ENU=All items on the sales order are available.';
      ShowAllDocsIsEnable@1000 : Boolean;
      VendorName@1004 : Text[50];
      CannotCreatePurchaseOrderWithoutVendorErr@1005 : TextConst 'DAN=Du kan ikke oprette k�bsordrer uden at angive en kreditor for alle linjer.;ENU=You cannot create purchase orders without specifying a vendor for all lines.';

    PROCEDURE SetSalesOrderNo@2(SalesOrderNo@1000 : Code[20]);
    BEGIN
      OrderNo := SalesOrderNo;
    END;

    LOCAL PROCEDURE PlanForOrder@3();
    VAR
      OrderPlanningMgt@1000 : Codeunit 5522;
      AllItemsAreAvailableNotification@1001 : Notification;
    BEGIN
      OrderPlanningMgt.PlanSpecificSalesOrder(Rec,OrderNo);
      SETRANGE(Level,1);

      SETFILTER("Replenishment System",'<>%1',"Replenishment System"::Purchase);
      IF FINDSET THEN
        REPEAT
          VALIDATE("Replenishment System","Replenishment System"::Purchase);
          MODIFY(TRUE);
        UNTIL NEXT = 0;
      SETRANGE("Replenishment System");

      SETFILTER(Quantity,'>%1',0);
      IF ISEMPTY THEN BEGIN
        AllItemsAreAvailableNotification.MESSAGE := EntireOrderIsAvailableTxt;
        AllItemsAreAvailableNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
        AllItemsAreAvailableNotification.SEND;
      END;
      SETRANGE(Quantity);
    END;

    LOCAL PROCEDURE SetProcessedDocumentsVisibility@1(ShowAll@1000 : Boolean);
    BEGIN
      FILTERGROUP(0);
      IF ShowAll THEN BEGIN
        SETRANGE("Needed Quantity");
        ShowAllDocsIsEnable := FALSE;
      END ELSE BEGIN
        SETFILTER("Needed Quantity",'>%1',0);
        ShowAllDocsIsEnable := TRUE;
      END;
    END;

    LOCAL PROCEDURE ValidateSupplyFromVendor@4();
    VAR
      RecordsWithoutSupplyFromVendor@1000 : Boolean;
    BEGIN
      SETRANGE("Supply From",'');
      SETFILTER(Quantity,'>%1',0);
      RecordsWithoutSupplyFromVendor := NOT ISEMPTY;
      SETRANGE("Supply From");
      SETRANGE(Quantity);
      IF RecordsWithoutSupplyFromVendor THEN
        ERROR(CannotCreatePurchaseOrderWithoutVendorErr);
    END;

    BEGIN
    END.
  }
}

