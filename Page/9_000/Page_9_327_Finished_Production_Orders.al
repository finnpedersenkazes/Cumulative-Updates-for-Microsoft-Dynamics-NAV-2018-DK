OBJECT Page 9327 Finished Production Orders
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
    CaptionML=[DAN=F‘rdige produktionsordrer;
               ENU=Finished Production Orders];
    SourceTable=Table5405;
    SourceTableView=WHERE(Status=CONST(Finished));
    PageType=List;
    CardPageID=Finished Production Order;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Pro&d.ordre;
                                 ENU=Pro&d. Order];
                      Image=Order }
      { 12      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Poster;
                                 ENU=E&ntries];
                      Image=Entries }
      { 13      ;3   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Vareposter;
                                 ENU=Item Ledger E&ntries];
                      ToolTipML=[DAN=Vis vareposterne for varen p† bilaget eller kladdelinjen.;
                                 ENU=View the item ledger entries of the item on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 38;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(No.);
                      Image=ItemLedger }
      { 27      ;3   ;Action    ;
                      CaptionML=[DAN=Kapacitetsposter;
                                 ENU=Capacity Ledger Entries];
                      ToolTipML=[DAN=Vis kapacitetsposterne for den involverede produktionsordre. Kapaciteten registreres enten som tid (operationstid, stoptid eller opstillingstid) eller som antal (spildantal eller afgangsantal).;
                                 ENU=View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5832;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(No.);
                      Image=CapacityLedger }
      { 28      ;3   ;Action    ;
                      CaptionML=[DAN=V‘rdiposter;
                                 ENU=Value Entries];
                      ToolTipML=[DAN=Vis v‘rdiposterne for varen p† bilags- eller kladdelinjen.;
                                 ENU=View the value entries of the item on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(No.);
                      Image=ValueLedger }
      { 33      ;3   ;Action    ;
                      CaptionML=[DAN=&Lagerposter;
                                 ENU=&Warehouse Entries];
                      ToolTipML=[DAN="F† vist historikken over antal, der er registreret for varen under lageraktiviteter. ";
                                 ENU="View the history of quantities that are registered for the item in warehouse activities. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7318;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.);
                      RunPageLink=Source Type=FILTER(83|5407),
                                  Source Subtype=FILTER(3|4|5),
                                  Source No.=FIELD(No.);
                      Image=BinLedger }
      { 29      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000838;
                      RunPageLink=Status=FIELD(Status),
                                  Prod. Order No.=FIELD(No.);
                      Image=ViewComments }
      { 30      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 32      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000816;
                      RunPageLink=Status=FIELD(Status),
                                  No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903759606;1 ;Action    ;
                      CaptionML=[DAN=Produktionsordre - detaljeret beregning;
                                 ENU=Prod. Order - Detail Calc.];
                      ToolTipML=[DAN=Vis en liste med systemets produktionsordrer. Listen viser de forventede kostpriser samt vareantallet pr. ordre eller pr. operation for en produktionsordre.;
                                 ENU=View a list of the production orders. This list contains the expected costs and the quantity per production order or per operation of a production order.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000768;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905556906;1 ;Action    ;
                      CaptionML=[DAN=Prod.ordre - forkalkuleret tid;
                                 ENU=Prod. Order - Precalc. Time];
                      ToolTipML=[DAN=Vis en liste med oplysninger om kapacitetsbehov, start- og sluttidspunkt, osv. - pr. operation, pr. produktionsordre og pr. produktionsordrelinje.;
                                 ENU=View a list of information about capacity requirement, starting and ending time, etc. per operation, per production order, or per production order line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000764;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906587906;1 ;Action    ;
                      CaptionML=[DAN=Produktionsordre - komponent og rute;
                                 ENU=Production Order - Comp. and Routing];
                      ToolTipML=[DAN=Vis oplysninger om komponenter og operationer i produktionsordrer. Ved frigivne produktionsordrer viser rapporten restantallet, hvis dele af antallet er bogf›rt som afgang.;
                                 ENU=View information about components and operations in production orders. For released production orders, the report shows the remaining quantity if parts of the quantity have been posted as output.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 5500;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903594306;1 ;Action    ;
                      Name=ProdOrderJobCard;
                      CaptionML=[DAN=Produktionsordre - jobkort;
                                 ENU=Production Order Job Card];
                      ToolTipML=[DAN=Vis en oversigt over igangv‘rende arbejde i forbindelse med en produktionsordre. Afgang, spildantal og genneml›bstid vises eller udskrives afh‘ngigt af operationen.;
                                 ENU=View a list of the work in progress of a production order. Output, Scrapped Quantity and Production Lead Time are shown or printed depending on the operation.];
                      ApplicationArea=#Manufacturing;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 ManuPrintReport.PrintProductionOrder(Rec,0);
                               END;
                                }
      { 1902850806;1 ;Action    ;
                      CaptionML=[DAN=Produktionsordre - plukliste;
                                 ENU=Production Order - Picking List];
                      ToolTipML=[DAN=Vis en detaljeret oversigt over, hvilke varer der skal plukkes til en bestemt produktionsordre, fra hvilken lokation (og placering, hvis lokationen anvender placeringer) de skal plukkes, og hvorn†r varerne skal v‘re klar til produktion.;
                                 ENU=View a detailed list of items that must be picked for a particular production order, from which location (and bin, if the location uses bins) they must be picked, and when the items are due for production.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000766;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902917606;1 ;Action    ;
                      Name=ProdOrderMaterialRequisition;
                      CaptionML=[DAN=Produktionsordre - materialerekvisition;
                                 ENU=Production Order - Material Requisition];
                      ToolTipML=[DAN=Vis en liste med materialebehovet pr. produktionsordre. Rapporten viser status for den p†g‘ldende produktionsordre, antallet af f‘rdigvarer og komponenter og de tilsvarende behov. Du kan ogs† se forfaldsdatoen og lokationskoden for hver enkelt komponent.;
                                 ENU=View a list of material requirements per production order. The report shows you the status of the production order, the quantity of end items and components with the corresponding required quantity. You can view the due date and location code of each component.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 ManuPrintReport.PrintProductionOrder(Rec,1);
                               END;
                                }
      { 1906372006;1 ;Action    ;
                      CaptionML=[DAN=Prod.ordreoversigt;
                                 ENU=Production Order List];
                      ToolTipML=[DAN=Vis en liste med samtlige produktionsordrer i dit system. Der vises eller udskrives oplysninger om ordrenumre, nummeret p† den vare, der skal produceres, start-/slutdato og andre oplysninger.;
                                 ENU=View a list of the production orders contained in the system. Information such as order number, number of the item to be produced, starting/ending date and other data are shown or printed.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000763;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903746906;1 ;Action    ;
                      Name=ProdOrderShortageList;
                      CaptionML=[DAN=Produktionsordre - mankoliste;
                                 ENU=Production Order - Shortage List];
                      ToolTipML=[DAN=Vis en liste med antallet af manglende varer pr. produktionsordre. Du f†r et overblik over lagerdisponeringen fra dags dato indtil en bestemt dato - f.eks. hvilke ordrer der endnu er †bne.;
                                 ENU=View a list of the missing quantity per production order. You are shown how the inventory development is planned from today until the set day - for example whether orders are still open.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 ManuPrintReport.PrintProductionOrder(Rec,2);
                               END;
                                }
      { 1901854406;1 ;Action    ;
                      CaptionML=[DAN=Prod.ordrestatistik;
                                 ENU=Production Order Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger om produktionsordrens direkte materiale- og kapacitetskostpriser og faste omkostninger samt dens kapacitetsbehov angivet som tidsenhed.;
                                 ENU=View statistical information about the production order's direct material and capacity costs and overhead as well as its capacity need in the time unit of measure.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000791;
                      Promoted=Yes;
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

    { 2   ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af produktionsordren.;
                           ENU=Specifies the description of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Source No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det rutenummer, der bruges til produktionsordren.;
                           ENU=Specifies the routing number used for this production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing No." }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen eller familien der skal produceres (produktionsantal).;
                           ENU=Specifies how many units of the item or the family to produce (production quantity).];
                ApplicationArea=#Manufacturing;
                SourceExpr=Quantity }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokationskode, som det f‘rdige produkt fra produktionsordren skal bogf›res til.;
                           ENU=Specifies the location code to which you want to post the finished product from this production order.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl‘ttet for produktionsordren.;
                           ENU=Specifies the starting time of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for produktionsordren.;
                           ENU=Specifies the starting date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl‘ttet for produktionsordren.;
                           ENU=Specifies the ending time of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for produktionsordren.;
                           ENU=Specifies the ending date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for produktionsordren.;
                           ENU=Specifies the due date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Assigned User ID" }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den faktiske f‘rdigg›relsesdato for en produktionsordre.;
                           ENU=Specifies the actual finishing date of a finished production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Finished Date";
                Visible=FALSE }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for produktionsordren.;
                           ENU=Specifies the status of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Status }

    { 65  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver s›gebeskrivelsen.;
                           ENU=Specifies the search description.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Description" }

    { 1102601000;2;Field  ;
                ToolTipML=[DAN=Angiver, hvorn†r produktionsordrekortet sidst blev ‘ndret.;
                           ENU=Specifies when the production order card was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified";
                Visible=FALSE }

    { 1102601002;2;Field  ;
                ToolTipML=[DAN=Angiver en placering, hvor du vil bogf›re de f‘rdige varer.;
                           ENU=Specifies a bin to which you want to post the finished items.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

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
    VAR
      ManuPrintReport@1000 : Codeunit 99000817;

    BEGIN
    END.
  }
}

