OBJECT Page 5726 Nonstock Item List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Katalogvareoversigt;
               ENU=Nonstock Item List];
    MultipleNewLines=No;
    SourceTable=Table5718;
    SourceTableView=SORTING(Vendor Item No.,Manufacturer Code)
                    ORDER(Ascending);
    PageType=List;
    CardPageID=Nonstock Item Card;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 1102601002;1 ;ActionGroup;
                      CaptionML=[DAN=K&atalogvare;
                                 ENU=Nonstoc&k Item];
                      Image=NonStockItem }
      { 1102601004;2 ;Action    ;
                      CaptionML=[DAN=Erstat&ninger;
                                 ENU=Substituti&ons];
                      ToolTipML=[DAN=F† vist erstatningsvarer, der er konfigureret til at blive solgt i stedet for varen.;
                                 ENU=View substitute items that are set up to be sold instead of the item.];
                      ApplicationArea=#Suite;
                      RunObject=Page 5716;
                      RunPageLink=Type=CONST(Nonstock Item),
                                  No.=FIELD(Entry No.);
                      Image=ItemSubstitution }
      { 1102601005;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Nonstock Item),
                                  No.=FIELD(Entry No.);
                      Image=ViewComments }
      { 1900000005;0 ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 1900294905;1 ;Action    ;
                      CaptionML=[DAN=Ny vare;
                                 ENU=New Item];
                      ToolTipML=[DAN=Opret et varekort, der er baseret p† lagervaren.;
                                 ENU=Create an item card based on the stockkeeping unit.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 30;
                      Promoted=Yes;
                      Image=NewItem;
                      PromotedCategory=New;
                      RunPageMode=Create }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1900907306;1 ;Action    ;
                      CaptionML=[DAN=Vare - stamoplysninger;
                                 ENU=Inventory - List];
                      ToolTipML=[DAN=F† vist oplysninger om varen, s†som navn, enhed, bogf›ringsgruppe, hyldenummer, kreditors varenummer, beregning af leveringstid, minimumslager og alternativt varenummer. Du kan ogs† se, om varen er blokeret.;
                                 ENU=View various information about the item, such as name, unit of measure, posting group, shelf number, vendor's item number, lead time calculation, minimum inventory, and alternate item number. You can also see if the item is blocked.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 701;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901091106;1 ;Action    ;
                      CaptionML=[DAN=Varedisponering;
                                 ENU=Inventory Availability];
                      ToolTipML=[DAN=Vis, udskriv eller gem en historikoversigt over lagertransaktioner pr. valgte varer, f.eks. for at beslutte, hvorn†r varerne skal indk›bes. Rapporten specificerer antallet af salgsordrer, k›bsordrer, restordrer fra kreditorer, minimumslageret og eventuelle genbestillinger.;
                                 ENU=View, print, or save a summary of historical inventory transactions with selected items, for example, to decide when to purchase the items. The report specifies quantity on sales order, quantity on purchase order, back orders from vendors, minimum inventory, and whether there are reorders.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 705;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906212206;1 ;Action    ;
                      CaptionML=[DAN=Vare - disponeringsoversigt;
                                 ENU=Inventory - Availability Plan];
                      ToolTipML=[DAN=Vis en liste over antallet af de enkelte varer fordelt p† henholdsvis debitor-, k›bs- og overflytningsordrer, samt det antal der er disponibelt p† lageret. Oversigten er inddelt i kolonner, der d‘kker seks perioder med angivne start- og slutdatoer, samt perioderne f›r og efter de p†g‘ldende seks perioder. Listen er praktisk ved planl‘gning af vareindk›b.;
                                 ENU=View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 707;
                      Promoted=Yes;
                      Image=ItemAvailability;
                      PromotedCategory=Report }
      { 1900430206;1 ;Action    ;
                      CaptionML=[DAN=Vare/leverand›rer;
                                 ENU=Item/Vendor Catalog];
                      ToolTipML=[DAN=Vis en oversigt over udvalgte varer med tilh›rende kreditorer. Der vises oplysninger om k›bspris, beregning af leveringstid og kreditorers varenummer.;
                                 ENU=View a list of the vendors for the selected items. For each combination of item and vendor, it shows direct unit cost, lead time calculation and the vendor's item number.];
                      ApplicationArea=#Advanced;
                      RunObject=Report 720;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1907253406;1 ;Action    ;
                      CaptionML=[DAN=Katalogvaresalg;
                                 ENU=Nonstock Item Sales];
                      ToolTipML=[DAN=F† vist en oversigt over varesalg for alle katalogvarer i en valgt periode. Den kan bruges til at gennemse en virksomheds salg af katalogvarer.;
                                 ENU=View a list of item sales for each nonstock item during a selected time period. It can be used to review a company's sale of nonstock items.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Report 5700;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905753506;1 ;Action    ;
                      CaptionML=[DAN=Erstatningsvarer;
                                 ENU=Item Substitutions];
                      ToolTipML=[DAN=Vis eller rediger alle stedfortr‘dervarer, der er konfigureret til at blive solgt i stedet for varen, hvis den ikke er tilg‘ngelig.;
                                 ENU=View or edit any substitute items that are set up to be traded instead of the item in case it is not available.];
                      ApplicationArea=#Suite;
                      RunObject=Report 5701;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det nummer, som kreditoren bruger til denne vare.;
                           ENU=Specifies the number that the vendor uses for this item.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor Item No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for producenten af katalogvaren.;
                           ENU=Specifies a code for the manufacturer of the nonstock item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Manufacturer Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det varenummer, som programmet har genereret til katalogvaren.;
                           ENU=Specifies the item number that the program has generated for this nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No.";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kreditor, du kan k›be katalogvaren af.;
                           ENU=Specifies the number of the vendor from whom you can purchase the nonstock item.];
                ApplicationArea=#Advanced;
                SourceExpr="Vendor No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af katalogvaren.;
                           ENU=Specifies a description of the nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† varens eller ressourcens enhed, f.eks. styk eller time.;
                           ENU=Specifies the name of the item or resource's unit of measure, such as piece or hour.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver listekostprisen eller kreditorens vejledende pris p† katalogvaren.;
                           ENU=Specifies the published cost or vendor list price for the nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Published Cost" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den pris, du har forhandlet dig frem til for katalogvaren.;
                           ENU=Specifies the price you negotiated to pay for the nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Negotiated Cost" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver prisen for ‚n enhed af varen eller ressourcen. Du kan angive en pris manuelt eller f† den angivet i henhold til feltet Avancepct.beregning p† det dertilh›rende kort.;
                           ENU=Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Unit Price" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver katalogvarens bruttov‘gt, inklusive v‘gten af en eventuel emballage.;
                           ENU=Specifies the gross weight, including the weight of any packaging, of the nonstock item.];
                ApplicationArea=#Advanced;
                SourceExpr="Gross Weight" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens nettov‘gt. V‘gten af eventuel emballage er ikke inkluderet.;
                           ENU=Specifies the net weight of the item. The weight of packaging materials is not included.];
                ApplicationArea=#Advanced;
                SourceExpr="Net Weight" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den vareskabelon, der blev brugt til denne katalogvare.;
                           ENU=Specifies the code for the item template used for this nonstock item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item Template Code" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor katalogvarekortet sidst blev ‘ndret.;
                           ENU=Specifies the date on which the nonstock item card was last modified.];
                ApplicationArea=#Advanced;
                SourceExpr="Last Date Modified" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver stregkoden for katalogvaren.;
                           ENU=Specifies the bar code of the nonstock item.];
                ApplicationArea=#Advanced;
                SourceExpr="Bar Code" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

