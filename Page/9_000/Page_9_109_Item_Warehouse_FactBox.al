OBJECT Page 9109 Item Warehouse FactBox
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varedetaljer - lager;
               ENU=Item Details - Warehouse];
    SourceTable=Table27;
    PageType=CardPart;
    OnAfterGetRecord=BEGIN
                       NetWeight;
                     END;

  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 19  ;1   ;Field     ;
                CaptionML=[DAN=Varenr.;
                           ENU=Item No.];
                ToolTipML=[DAN=Angiver nummeret p† varen.;
                           ENU=Specifies the number of the item.];
                ApplicationArea=#Suite;
                SourceExpr="No.";
                OnDrillDown=BEGIN
                              ShowDetails;
                            END;
                             }

    { 1   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver en entydig kode for varen, som er nyttig i et ADCS-system.;
                           ENU=Specifies a unique code for the item in terms that are useful for automatic data capture.];
                ApplicationArea=#Advanced;
                SourceExpr="Identifier Code" }

    { 3   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den enhed, som varen opbevares i p† lageret.;
                           ENU=Specifies the unit in which the item is held in inventory.];
                ApplicationArea=#Suite;
                SourceExpr="Base Unit of Measure" }

    { 5   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den enhed, som programmet bruger, n†r varen l‘gges p† lager.;
                           ENU=Specifies the code of the item unit of measure in which the program will put the item away.];
                ApplicationArea=#Warehouse;
                SourceExpr="Put-away Unit of Measure Code" }

    { 7   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den enhedskode, der bruges, n†r du k›ber varen.;
                           ENU=Specifies the unit of measure code used when you purchase the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Purch. Unit of Measure" }

    { 9   ;1   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan serie- eller lotnumre, der er knyttet til varen, spores i forsyningsk‘den.;
                           ENU=Specifies how serial or lot numbers assigned to the item are tracked in the supply chain.];
                ApplicationArea=#ItemTracking;
                SourceExpr="Item Tracking Code";
                OnDrillDown=VAR
                              ItemTrackCode@1001 : Record 6502;
                            BEGIN
                              ItemTrackCode.SETFILTER(Code,"Item Tracking Code");

                              PAGE.RUN(PAGE::"Item Tracking Code Card",ItemTrackCode);
                            END;
                             }

    { 11  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det udstyr, som lagermedarbejdere skal bruge til at h†ndtere varen.;
                           ENU=Specifies the code of the equipment that warehouse employees must use when handling the item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Special Equipment Code" }

    { 13  ;1   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du sidst har bogf›rt resultaterne af en lageropg›relse af varen p† varekladden.;
                           ENU=Specifies the date on which you last posted the results of a physical inventory for the item to the item ledger.];
                ApplicationArea=#Warehouse;
                SourceExpr="Last Phys. Invt. Date" }

    { 15  ;1   ;Field     ;
                CaptionML=[DAN=Nettov‘gt;
                           ENU=Net Weight];
                ToolTipML=[DAN=Angiver den samlede nettov‘gt af de varer, der skal leveres.;
                           ENU=Specifies the total net weight of the items that should be shipped.];
                ApplicationArea=#Suite;
                SourceExpr=NetWeight }

    { 17  ;1   ;Field     ;
                CaptionML=[DAN=Lagerklassekode;
                           ENU=Warehouse Class Code];
                ToolTipML=[DAN=Angiver den lagerklassekode, der definerer varen.;
                           ENU=Specifies the warehouse class code that defines the item.];
                ApplicationArea=#Warehouse;
                SourceExpr="Warehouse Class Code" }

  }
  CODE
  {

    LOCAL PROCEDURE ShowDetails@1102601001();
    BEGIN
      PAGE.RUN(PAGE::"Item Card",Rec);
    END;

    LOCAL PROCEDURE NetWeight@1102601000() : Decimal;
    VAR
      ItemBaseUOM@1102601000 : Record 5404;
    BEGIN
      IF ItemBaseUOM.GET("No.","Base Unit of Measure") THEN
        EXIT(ItemBaseUOM.Weight);

      EXIT(0);
    END;

    BEGIN
    END.
  }
}

