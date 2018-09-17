OBJECT Page 1345 Sales Price and Line Discounts
{
  OBJECT-PROPERTIES
  {
    Date=26-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21836;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Salgspriser;
               ENU=Sales Prices];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table1304;
    PageType=List;
    SourceTableTemporary=Yes;
    OnNewRecord=BEGIN
                  IF ("Loaded Customer No." = GetLoadedCustNo) AND ("Loaded Item No." = GetLoadedItemNo) THEN
                    EXIT;

                  "Loaded Item No." := GetLoadedItemNo;
                  "Loaded Customer No." := GetLoadedCustNo;
                  "Loaded Price Group" := GetLoadedPriceGroup;
                  "Loaded Disc. Group" := GetLoadedDiscGroup;
                END;

    ActionList=ACTIONS
    {
      { 20      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 14      ;1   ;ActionGroup;
                      CaptionML=[DAN=Filtrering;
                                 ENU=Filtering] }
      { 17      ;1   ;Action    ;
                      CaptionML=[DAN=Vis kun aktuelle;
                                 ENU=Show Current Only];
                      ToolTipML=[DAN=Vis kun gyldige pris- og rabataftaler, hvor slutdatoerne ligger efter dags dato.;
                                 ENU=Show only valid price and discount agreements that have ending dates later than today's date.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ActivateDiscounts;
                      OnAction=BEGIN
                                 FilterToActualRecords
                               END;
                                }
      { 10      ;1   ;Action    ;
                      CaptionML=[DAN=Vis alle;
                                 ENU=Show All];
                      ToolTipML=[DAN=Vis alle pris- og rabataftaler, inklusive dem, hvor slutdatoerne ligger f�r dags dato.;
                                 ENU=Show all price and discount agreements, including those with ending dates earlier than today's date.];
                      ApplicationArea=#Basic,#Suite;
                      Image=DeactivateDiscounts;
                      OnAction=BEGIN
                                 RESET;
                               END;
                                }
      { 15      ;1   ;Action    ;
                      CaptionML=[DAN=Opdater data;
                                 ENU=Refresh Data];
                      ToolTipML=[DAN=Opdater salgspriser eller salgslinjerabatter med v�rdier, som andre brugere kan have tilf�jet for debitoren, efter du har �bnet vinduet.;
                                 ENU=Update sales prices or sales line discounts with values that other users may have added for the customer since you opened the window.];
                      ApplicationArea=#Basic,#Suite;
                      Image=RefreshLines;
                      OnAction=VAR
                                 Customer@1001 : Record 18;
                                 Item@1000 : Record 27;
                               BEGIN
                                 IF GetLoadedItemNo <> '' THEN
                                   IF Item.GET(GetLoadedItemNo) THEN BEGIN
                                     LoadDataForItem(Item);
                                     EXIT;
                                   END;
                                 IF Customer.GET(GetLoadedCustNo) THEN
                                   LoadDataForCustomer(Customer)
                               END;
                                }
      { 25      ;1   ;Action    ;
                      CaptionML=[DAN=Angiv specialpriser;
                                 ENU=Set Special Prices];
                      ToolTipML=[DAN=Angiv forskellige priser for de varer, du s�lger til debitoren. En varepris anf�res automatisk p� fakturalinjer, n�r de specificerede kriterier er blevet opfyldt, f.eks. debitor, m�ngde eller slutdato.;
                                 ENU=Set up different prices for items that you sell to the customer. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7002;
                      RunPageView=SORTING(Item No.);
                      RunPageLink=Item No.=FIELD(Loaded Item No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Price;
                      PromotedCategory=Process }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=Angiv specialrabatter;
                                 ENU=Set Special Discounts];
                      ToolTipML=[DAN=Angiv forskellige rabatter for de varer, du s�lger til debitoren. En varerabat anf�res automatisk p� fakturalinjer, n�r de specificerede kriterier er blevet opfyldt, f.eks. debitor, m�ngde eller slutdato.;
                                 ENU=Set up different discounts for items that you sell to the customer. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 7004;
                      RunPageView=SORTING(Type,Code);
                      RunPageLink=Type=CONST(Item),
                                  Code=FIELD(Loaded Item No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=LineDiscount;
                      PromotedCategory=Process }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om linjen g�lder for en salgspris eller en salgslinjerabat.;
                           ENU=Specifies if the line is for a sales price or a sales line discount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Type" }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgstype for pris eller rabat. Salgstypen definerer, om salgsprisen eller rabatten g�lder for en individuel debitor, for en debitorrabatgruppe, eller for alle debitorer.;
                           ENU=Specifies the sales type of the price or discount. The sales type defines whether the sales price or discount is for an individual customer, a customer discount group, or for all customers.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Sales Type" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver salgskoden for pris eller rabat. Salgskoden afh�nger af v�rdien i feltet Salgstype. Koden kan repr�sentere en individuel debitor, en debitorrabatgruppe eller alle debitorer.;
                           ENU=Specifies the sales code of the price or discount. The sales code depends on the value in the Sales Type field. The code can represent an individual customer, a customer discount group, or for all customers.];
                ApplicationArea=#All;
                SourceExpr="Sales Code";
                Visible=SalesCodeIsVisible;
                Enabled=SalesCodeIsVisible }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om rabatten er gyldig for en vare eller for en varerabatgruppe.;
                           ENU=Specifies if the discount is valid for an item or for an item discount group.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for salgslinjeprisen eller rabatten.;
                           ENU=Specifies a code for the sales line price or discount.];
                ApplicationArea=#All;
                SourceExpr=Code;
                Visible=CodeIsVisible;
                Enabled=CodeIsVisible }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m�les, f.eks. i enheder eller timer. Som standard inds�ttes v�rdien i feltet Basisenhed p� kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit of Measure Code" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal angives i salgsdokumentet for at garantere salgsprisen eller rabatten.;
                           ENU=Specifies the quantity that must be entered on the sales document to warrant the sales price or discount.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Minimum Quantity" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rabatprocent, der tildeles varen p� linjen.;
                           ENU=Specifies the discount percentage that is granted for the item on the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Line Discount %";
                Enabled="Line Type" = 1 }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for �n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f� den angivet i henhold til feltet Avancepct.beregning p� det dertilh�rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Price";
                Enabled="Line Type" = 2 }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som salgslinjerabatten er gyldig fra.;
                           ENU=Specifies the date from which the sales line discount is valid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Starting Date" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som salgslinjerabatten er gyldig til.;
                           ENU=Specifies the date to which the sales line discount is valid.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ending Date" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valuta, der skal bruges p� salgsdokumentlinjen for at garantere salgsprisen eller rabatten.;
                           ENU=Specifies the currency that must be used on the sales document line to warrant the sales price or discount.];
                ApplicationArea=#Advanced;
                SourceExpr="Currency Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om prisen, der er angivet, inkluderer moms.;
                           ENU=Specifies if the price that is granted includes VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="Price Includes VAT";
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en fakturarabat beregnes, n�r salgsprisen tilbydes.;
                           ENU=Specifies if an invoice discount will be calculated when the sales price is offered.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Invoice Disc.";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver momsvirksomhedsbogf�ringsgruppen for debitorer, som salgsprisen skal anvendes p�. Prisen er inkl. moms.;
                           ENU=Specifies the VAT business posting group for customers who you want to apply the sales price to. This price includes VAT.];
                ApplicationArea=#Advanced;
                SourceExpr="VAT Bus. Posting Gr. (Price)";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den variant, der skal bruges p� salgsdokumentlinjen for at garantere salgsprisen eller rabatten.;
                           ENU=Specifies the variant that must be used on the sales document line to warrant the sales price or discount.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om linjerabatter er tilladt.;
                           ENU=Specifies if line discounts are allowed.];
                ApplicationArea=#Advanced;
                SourceExpr="Allow Line Disc.";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      loadedItemNo@1001 : Code[20];
      loadedCustNo@1003 : Code[20];
      loadedPriceGroup@1002 : Code[20];
      loadedDiscGroup@1000 : Code[20];
      CodeIsVisible@1004 : Boolean;
      SalesCodeIsVisible@1005 : Boolean;

    [External]
    PROCEDURE InitPage@4(ForItem@1001 : Boolean);
    BEGIN
      IF ForItem THEN BEGIN
        CodeIsVisible := FALSE;
        SalesCodeIsVisible := TRUE;
      END ELSE BEGIN
        CodeIsVisible := TRUE;
        SalesCodeIsVisible := FALSE;
      END;
    END;

    [External]
    PROCEDURE LoadItem@1(Item@1000 : Record 27);
    BEGIN
      CLEAR(Rec);
      loadedItemNo := Item."No.";
      loadedDiscGroup := Item."Item Disc. Group";
      loadedPriceGroup := '';

      LoadDataForItem(Item);
    END;

    [External]
    PROCEDURE LoadCustomer@3(Customer@1000 : Record 18);
    BEGIN
      CLEAR(Rec);
      loadedCustNo := Customer."No.";
      loadedPriceGroup := Customer."Customer Price Group";
      loadedDiscGroup := Customer."Customer Disc. Group";

      LoadDataForCustomer(Customer);
    END;

    [External]
    PROCEDURE GetLoadedItemNo@2() : Code[20];
    BEGIN
      EXIT(loadedItemNo)
    END;

    [External]
    PROCEDURE GetLoadedCustNo@9() : Code[20];
    BEGIN
      EXIT(loadedCustNo)
    END;

    LOCAL PROCEDURE GetLoadedDiscGroup@8() : Code[20];
    BEGIN
      EXIT(loadedDiscGroup)
    END;

    LOCAL PROCEDURE GetLoadedPriceGroup@5() : Code[20];
    BEGIN
      EXIT(loadedPriceGroup)
    END;

    [External]
    PROCEDURE RunUpdatePriceIncludesVatAndPrices@6(IncludesVat@1000 : Boolean);
    VAR
      Item@1001 : Record 27;
    BEGIN
      Item.GET(loadedItemNo);
      UpdatePriceIncludesVatAndPrices(Item,IncludesVat);
    END;

    BEGIN
    END.
  }
}

