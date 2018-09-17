OBJECT Page 1872 Item Availability Check
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Kontrol af varebeholdning;
               ENU=Availability Check];
    SaveValues=No;
    MultipleNewLines=No;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table27;
    DelayedInsert=No;
    PopulateAllFields=No;
    SourceTableTemporary=No;
    AutoSplitKey=No;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Administrer;
                                ENU=New,Process,Report,Manage];
    ShowFilter=Yes;
    ActionList=ACTIONS
    {
      { 2       ;    ;ActionContainer;
                      Name=Action1;
                      ActionContainerType=RelatedInformation }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Administrer;
                                 ENU=&Manage] }
      { 8       ;2   ;Action    ;
                      Name=Page Item Card;
                      CaptionML=[DAN=Vare;
                                 ENU=Item];
                      ToolTipML=[DAN=Vis og rediger detaljerede oplysninger om varen.;
                                 ENU=View and edit detailed information for the item.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 30;
                      RunPageLink=No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                      Promoted=Yes;
                      PromotedIsBig=No;
                      Image=Item;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      RunPageMode=View }
      { 9       ;1   ;ActionGroup;
                      CaptionML=[DAN=Opret;
                                 ENU=Create] }
      { 10      ;2   ;Action    ;
                      Name=Purchase Invoice;
                      CaptionML=[DAN=Opret k›bsfaktura;
                                 ENU=Create Purchase Invoice];
                      ToolTipML=[DAN=Opret en ny k›bsfaktura.;
                                 ENU=Create a new purchase invoice.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=No;
                      Image=NewPurchaseInvoice;
                      PromotedCategory=New;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 PurchaseHeader@1000 : Record 38;
                                 PurchaseLine2@1001 : Record 39;
                                 Vendor@1002 : Record 23;
                               BEGIN
                                 IF "Vendor No." = '' THEN BEGIN
                                   IF NOT SelectVendor(Vendor) THEN
                                     EXIT;

                                   "Vendor No." := Vendor."No."
                                 END;
                                 PurchaseHeader.INIT;
                                 PurchaseHeader.VALIDATE("Document Type",PurchaseHeader."Document Type"::Invoice);
                                 PurchaseHeader.INSERT(TRUE);
                                 PurchaseHeader.VALIDATE("Buy-from Vendor No.","Vendor No.");
                                 PurchaseHeader.MODIFY(TRUE);

                                 PurchaseLine2.INIT;
                                 PurchaseLine2.VALIDATE("Document Type",PurchaseHeader."Document Type");
                                 PurchaseLine2.VALIDATE("Document No.",PurchaseHeader."No.");
                                 PurchaseLine2.VALIDATE("Line No.",10000);
                                 PurchaseLine2.INSERT(TRUE);

                                 PurchaseLine2.VALIDATE(Type,PurchaseLine2.Type::Item);
                                 PurchaseLine2.VALIDATE("No.","No.");

                                 PurchaseLine2.MODIFY(TRUE);
                                 PAGE.RUN(PAGE::"Purchase Invoice",PurchaseHeader);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                Name=Control1;
                ContainerType=ContentArea }

    { 6   ;1   ;Field     ;
                Name=Control2;
                ApplicationArea=#Basic,#Suite;
                CaptionClass=Heading }

    { 13  ;1   ;Group     ;
                CaptionML=[DAN=Lagerbeholdning;
                           ENU=Inventory];
                GroupType=Group }

    { 4   ;2   ;Field     ;
                Name=InventoryQty;
                ToolTipML=[DAN=Angiver det vareantal, som aktuelt findes p† lageret, og som ikke er reserveret til andre behov.;
                           ENU=Specifies the quantity of the item that is currently in inventory and not reserved for other demand.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=InventoryQty;
                CaptionClass=AvailableInventoryCaption;
                Editable=false }

    { 5   ;2   ;Field     ;
                Name=TotalQuantity;
                CaptionML=[DAN=Lagermangel;
                           ENU=Inventory Shortage];
                ToolTipML=[DAN="Angiver det samlede antal af den vare, der aktuelt findes p† lageret. Feltet I alt bruges til at beregne feltet Disponibel beholdning p† f›lgende m†de: Disponibel beholdning = I alt - Reserveret antal.";
                           ENU="Specifies the total quantity of the item that is currently in inventory. The Total Quantity field is used to calculate the Available Inventory field as follows: Available Inventory = Total Quantity - Reserved Quantity."];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=TotalQuantity;
                Editable=false }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Alle lokationer;
                           ENU=All locations];
                ToolTipML=[DAN=Angiver det samlede m‘ngde af varen, der aktuelt findes p† lager p† alle lokationer.;
                           ENU=Specifies the total quantity of the item that is currently in inventory at all locations.];
                ApplicationArea=#Location;
                DecimalPlaces=0:5;
                SourceExpr=Inventory;
                OnDrillDown=BEGIN
                              PAGE.RUNMODAL(PAGE::"Item Availability by Location",Rec)
                            END;
                             }

    { 3   ;1   ;Part      ;
                Name=AvailabilityCheckDetails;
                ApplicationArea=#Basic,#Suite;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page1873;
                Editable=FALSE;
                PartType=Page }

  }
  CODE
  {
    VAR
      TotalQuantity@1000 : Decimal;
      InventoryQty@1001 : Decimal;
      LocationCode@1004 : Code[10];
      Heading@1003 : Text;
      SelectVentorTxt@1002 : TextConst 'DAN=V‘lg en kreditor, du vil k›be hos.;ENU=Select a vendor to buy from.';
      AvailableInventoryLbl@1005 : TextConst 'DAN=Disponibel beholdning;ENU=Available Inventory';
      AvailableInventoryCaption@1006 : Text;

    [External]
    PROCEDURE PopulateDataOnNotification@1(VAR AvailabilityCheckNotification@1000 : Notification;ItemNo@1012 : Code[20];UnitOfMeasureCode@1011 : Code[20];InventoryQty@1010 : Decimal;GrossReq@1009 : Decimal;ReservedReq@1008 : Decimal;SchedRcpt@1007 : Decimal;ReservedRcpt@1006 : Decimal;CurrentQuantity@1005 : Decimal;CurrentReservedQty@1004 : Decimal;TotalQuantity@1003 : Decimal;EarliestAvailDate@1002 : Date;LocationCode@1001 : Code[10]);
    BEGIN
      AvailabilityCheckNotification.SETDATA('ItemNo',ItemNo);
      AvailabilityCheckNotification.SETDATA('UnitOfMeasureCode',UnitOfMeasureCode);
      AvailabilityCheckNotification.SETDATA('GrossReq',FORMAT(GrossReq));
      AvailabilityCheckNotification.SETDATA('ReservedReq',FORMAT(ReservedReq));
      AvailabilityCheckNotification.SETDATA('SchedRcpt',FORMAT(SchedRcpt));
      AvailabilityCheckNotification.SETDATA('ReservedRcpt',FORMAT(ReservedRcpt));
      AvailabilityCheckNotification.SETDATA('CurrentQuantity',FORMAT(CurrentQuantity));
      AvailabilityCheckNotification.SETDATA('CurrentReservedQty',FORMAT(CurrentReservedQty));
      AvailabilityCheckNotification.SETDATA('TotalQuantity',FORMAT(TotalQuantity));
      AvailabilityCheckNotification.SETDATA('InventoryQty',FORMAT(InventoryQty));
      AvailabilityCheckNotification.SETDATA('EarliestAvailDate',FORMAT(EarliestAvailDate));
      AvailabilityCheckNotification.SETDATA('LocationCode',LocationCode);
    END;

    [Internal]
    PROCEDURE InitializeFromNotification@4(AvailabilityCheckNotification@1000 : Notification);
    VAR
      GrossReq@1007 : Decimal;
      SchedRcpt@1006 : Decimal;
      ReservedReq@1005 : Decimal;
      ReservedRcpt@1004 : Decimal;
      CurrentQuantity@1003 : Decimal;
      CurrentReservedQty@1002 : Decimal;
      EarliestAvailDate@1001 : Date;
    BEGIN
      GET(AvailabilityCheckNotification.GETDATA('ItemNo'));
      SETRANGE("No.",AvailabilityCheckNotification.GETDATA('ItemNo'));
      EVALUATE(TotalQuantity,AvailabilityCheckNotification.GETDATA('TotalQuantity'));
      EVALUATE(InventoryQty,AvailabilityCheckNotification.GETDATA('InventoryQty'));
      EVALUATE(LocationCode,AvailabilityCheckNotification.GETDATA('LocationCode'));
      CurrPage.AvailabilityCheckDetails.PAGE.SetUnitOfMeasureCode(
        AvailabilityCheckNotification.GETDATA('UnitOfMeasureCode'));

      IF AvailabilityCheckNotification.GETDATA('GrossReq') <> '' THEN BEGIN
        EVALUATE(GrossReq,AvailabilityCheckNotification.GETDATA('GrossReq'));
        CurrPage.AvailabilityCheckDetails.PAGE.SetGrossReq(GrossReq);
      END;
      IF AvailabilityCheckNotification.GETDATA('ReservedReq') <> '' THEN BEGIN
        EVALUATE(ReservedReq,AvailabilityCheckNotification.GETDATA('ReservedReq'));
        CurrPage.AvailabilityCheckDetails.PAGE.SetReservedReq(ReservedReq);
      END;
      IF AvailabilityCheckNotification.GETDATA('SchedRcpt') <> '' THEN BEGIN
        EVALUATE(SchedRcpt,AvailabilityCheckNotification.GETDATA('SchedRcpt'));
        CurrPage.AvailabilityCheckDetails.PAGE.SetSchedRcpt(SchedRcpt);
      END;
      IF AvailabilityCheckNotification.GETDATA('ReservedRcpt') <> '' THEN BEGIN
        EVALUATE(ReservedRcpt,AvailabilityCheckNotification.GETDATA('ReservedRcpt'));
        CurrPage.AvailabilityCheckDetails.PAGE.SetReservedRcpt(ReservedRcpt);
      END;
      IF AvailabilityCheckNotification.GETDATA('CurrentQuantity') <> '' THEN BEGIN
        EVALUATE(CurrentQuantity,AvailabilityCheckNotification.GETDATA('CurrentQuantity'));
        CurrPage.AvailabilityCheckDetails.PAGE.SetCurrentQuantity(CurrentQuantity);
      END;
      IF AvailabilityCheckNotification.GETDATA('CurrentReservedQty') <> '' THEN BEGIN
        EVALUATE(CurrentReservedQty,AvailabilityCheckNotification.GETDATA('CurrentReservedQty'));
        CurrPage.AvailabilityCheckDetails.PAGE.SetCurrentReservedQty(CurrentReservedQty);
      END;
      IF AvailabilityCheckNotification.GETDATA('EarliestAvailDate') <> '' THEN BEGIN
        EVALUATE(EarliestAvailDate,AvailabilityCheckNotification.GETDATA('EarliestAvailDate'));
        CurrPage.AvailabilityCheckDetails.PAGE.SetEarliestAvailDate(EarliestAvailDate);
      END;

      IF LocationCode = '' THEN
        AvailableInventoryCaption := AvailableInventoryLbl
      ELSE
        AvailableInventoryCaption := STRSUBSTNO('%1 (%2)',AvailableInventoryLbl,LocationCode);
    END;

    [External]
    PROCEDURE SetHeading@21(Value@1000 : Text);
    BEGIN
      Heading := Value;
    END;

    LOCAL PROCEDURE SelectVendor@2(VAR Vendor@1000 : Record 23) : Boolean;
    VAR
      VendorList@1003 : Page 27;
    BEGIN
      VendorList.LOOKUPMODE(TRUE);
      VendorList.CAPTION(SelectVentorTxt);
      IF VendorList.RUNMODAL = ACTION::LookupOK THEN BEGIN
        VendorList.GETRECORD(Vendor);
        EXIT(TRUE);
      END;

      EXIT(FALSE);
    END;

    BEGIN
    END.
  }
}

