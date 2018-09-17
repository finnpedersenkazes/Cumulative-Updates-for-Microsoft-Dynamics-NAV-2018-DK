OBJECT Page 9087 Sales Line FactBox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Salgslinjedetaljer;
               ENU=Sales Line Details];
    SourceTable=Table37;
    PageType=CardPart;
    OnAfterGetRecord=BEGIN
                       CALCFIELDS("Reserved Quantity");
                     END;

    OnAfterGetCurrRecord=BEGIN
                           ClearSalesHeader;
                         END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 8   ;1   ;Field     ;
                Name=ItemNo;
                Lookup=No;
                CaptionML=[DAN=Varenr.;
                           ENU=Item No.];
                ToolTipML=[DAN=Angiver den vare, som h†ndteres p† salgslinjen.;
                           ENU=Specifies the item that is handled on the sales line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=ShowNo;
                OnDrillDown=BEGIN
                              SalesInfoPaneMgt.LookupItem(Rec);
                            END;
                             }

    { 13  ;1   ;Field     ;
                Name=Required Quantity;
                CaptionML=[DAN=P†kr‘vet antal;
                           ENU=Required Quantity];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, der er behov for p† salgslinjen.;
                           ENU=Specifies how many units of the item are required on the sales line.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr="Outstanding Quantity" - "Reserved Quantity" }

    { 12  ;1   ;Group     ;
                Name=Availability;
                CaptionML=[DAN=Disponering;
                           ENU=Availability];
                GroupType=Group }

    { 10  ;2   ;Field     ;
                Name=Shipment Date;
                CaptionML=[DAN=Afsendelsesdato;
                           ENU=Shipment Date];
                ToolTipML=[DAN=Angiver, hvorn†r varerne p† salgslinjen skal leveres.;
                           ENU=Specifies when the items on the sales line must be shipped.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SalesInfoPaneMgt.CalcAvailabilityDate(Rec) }

    { 3   ;2   ;Field     ;
                Name=Item Availability;
                DrillDown=Yes;
                CaptionML=[DAN=Varedisponering;
                           ENU=Item Availability];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† salgslinjen, der er tilg‘ngelige, p† lager eller p† vej f›r leveringsdatoen.;
                           ENU=Specifies how may units of the item on the sales line are available, in inventory or incoming before the shipment date.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=SalesInfoPaneMgt.CalcAvailability(Rec);
                OnDrillDown=BEGIN
                              ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByEvent);
                              CurrPage.UPDATE(TRUE);
                            END;
                             }

    { 1   ;2   ;Field     ;
                Name=Available Inventory;
                CaptionML=[DAN=Disponibel beholdning;
                           ENU=Available Inventory];
                ToolTipML=[DAN=Angiver det vareantal, som aktuelt findes p† lageret, og som ikke er reserveret til andre behov.;
                           ENU=Specifies the quantity of the item that is currently in inventory and not reserved for other demand.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=SalesInfoPaneMgt.CalcAvailableInventory(Rec) }

    { 2   ;2   ;Field     ;
                Name=Scheduled Receipt;
                CaptionML=[DAN=Fastlagt tilgang;
                           ENU=Scheduled Receipt];
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageordren der er indg†ende p† k›bsordrer, overflytningsordrer, modtageordrer, fastlagte produktionsordrer og frigivne produktionsordrer.;
                           ENU=Specifies how many units of the assembly component are inbound on purchase orders, transfer orders, assembly orders, firm planned production orders, and released production orders.];
                ApplicationArea=#Basic,#Suite;
                DecimalPlaces=0:5;
                SourceExpr=SalesInfoPaneMgt.CalcScheduledReceipt(Rec) }

    { 4   ;2   ;Field     ;
                Name=Reserved Receipt;
                CaptionML=[DAN=Reserveret modtagelse;
                           ENU=Reserved Receipt];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† salgslinjen der er reserveret p† indkommende leverancer.;
                           ENU=Specifies how many units of the item on the sales line are reserved on incoming receipts.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=SalesInfoPaneMgt.CalcReservedRequirements(Rec) }

    { 6   ;2   ;Field     ;
                Name=Gross Requirements;
                CaptionML=[DAN=Bruttobehov;
                           ENU=Gross Requirements];
                ToolTipML=[DAN=Angiver det afh‘ngige behov plus det uafh‘ngige behov for varen p† salgslinjen. Afh‘ngige behov stammer fra produktionsordrekomponenter fra alle statusser, montageordrekomponenter og planl‘gningslinjer. Uafh‘ngige behov stammer fra salgsordrer, overflytningsordrer, serviceordrer, sagsopgaver og produktionsforecasts.;
                           ENU=Specifies, for the item on the sales line, dependent demand plus independent demand. Dependent demand comes production order components of all statuses, assembly order components, and planning lines. Independent demand comes from sales orders, transfer orders, service orders, job tasks, and production forecasts.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=SalesInfoPaneMgt.CalcGrossRequirements(Rec) }

    { 9   ;2   ;Field     ;
                Name=Reserved Requirements;
                CaptionML=[DAN=Reserveret behov;
                           ENU=Reserved Requirements];
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen p† salgslinjen, der er reserveret p† eftersp›rgselsrecords.;
                           ENU=Specifies, for the item on the sales line, how many are reserved on demand records.];
                ApplicationArea=#Advanced;
                DecimalPlaces=0:5;
                SourceExpr=SalesInfoPaneMgt.CalcReservedDemand(Rec) }

    { 16  ;1   ;Group     ;
                Name=Item;
                CaptionML=[DAN=Vare;
                           ENU=Item];
                GroupType=Group }

    { 15  ;2   ;Field     ;
                Name=UnitofMeasureCode;
                CaptionML=[DAN=Enhedskode;
                           ENU=Unit of Measure Code];
                ToolTipML=[DAN=Angiver, hvilken m†leenhed der skal bruges til at angive v‘rdien i feltet Enhedspris p† salgslinjen.;
                           ENU=Specifies the unit of measure that is used to determine the value in the Unit Price field on the sales line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 14  ;2   ;Field     ;
                Name=Qty. per Unit of Measure;
                CaptionML=[DAN=Antal pr. enhed;
                           ENU=Qty. per Unit of Measure];
                ToolTipML=[DAN=Angiver et automatisk udfyldt nummer, hvis du har medtaget Salgsenhed p† varekortet og et antal i feltet Antal pr. enhed i vinduet Vareenhed.;
                           ENU=Specifies an auto-filled number if you have included Sales Unit of Measure on the item card and a quantity in the Qty. per Unit of Measure field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Qty. per Unit of Measure" }

    { 5   ;2   ;Field     ;
                Name=Substitutions;
                DrillDown=Yes;
                CaptionML=[DAN=Erstatninger;
                           ENU=Substitutions];
                ToolTipML=[DAN=Specificerer andre varer, der er konfigureret til at blive solgt i stedet for varen, hvis den ikke er tilg‘ngelig.;
                           ENU=Specifies other items that are set up to be traded instead of the item in case it is not available.];
                ApplicationArea=#Suite;
                SourceExpr=SalesInfoPaneMgt.CalcNoOfSubstitutions(Rec);
                OnDrillDown=BEGIN
                              CurrPage.SAVERECORD;
                              ShowItemSub;
                              CurrPage.UPDATE(TRUE);
                              AutoReserve;
                            END;
                             }

    { 7   ;2   ;Field     ;
                Name=SalesPrices;
                DrillDown=Yes;
                CaptionML=[DAN=Salgspriser;
                           ENU=Sales Prices];
                ToolTipML=[DAN=Angiver specialsalgspriser, som du giver, n†r bestemte betingelser er opfyldt, f.eks. debitor, m‘ngde eller slutdato. Prisaftalerne kan g‘lde for individuelle debitorer, for debitorgrupper, for alle debitorer eller for en kampagne.;
                           ENU=Specifies special sales prices that you grant when certain conditions are met, such as customer, quantity, or ending date. The price agreements can be for individual customers, for a group of customers, for all customers or for a campaign.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SalesInfoPaneMgt.CalcNoOfSalesPrices(Rec);
                OnDrillDown=BEGIN
                              ShowPrices;
                              CurrPage.UPDATE;
                            END;
                             }

    { 11  ;2   ;Field     ;
                Name=SalesLineDiscounts;
                DrillDown=Yes;
                CaptionML=[DAN=Salgslinjerabatter;
                           ENU=Sales Line Discounts];
                ToolTipML=[DAN=Angiver, hvor mange s‘rlige rabatter du giver til salgslinjen. V‘lg v‘rdien for at se salgslinjerabatterne.;
                           ENU=Specifies how many special discounts you grant for the sales line. Choose the value to see the sales line discounts.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=SalesInfoPaneMgt.CalcNoOfSalesLineDisc(Rec);
                OnDrillDown=BEGIN
                              ShowLineDisc;
                              CurrPage.UPDATE;
                            END;
                             }

  }
  CODE
  {
    VAR
      SalesHeader@1000 : Record 36;
      SalesPriceCalcMgt@1002 : Codeunit 7000;
      SalesInfoPaneMgt@1001 : Codeunit 7171;
      ItemAvailFormsMgt@1003 : Codeunit 353;

    LOCAL PROCEDURE ShowPrices@15();
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
    END;

    LOCAL PROCEDURE ShowLineDisc@16();
    BEGIN
      SalesHeader.GET("Document Type","Document No.");
      CLEAR(SalesPriceCalcMgt);
      SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
    END;

    LOCAL PROCEDURE ShowNo@29() : Code[20];
    BEGIN
      IF Type <> Type::Item THEN
        EXIT('');
      EXIT("No.");
    END;

    BEGIN
    END.
  }
}

