OBJECT Page 99000831 Released Production Order
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Frigivet produktionsordre;
               ENU=Released Production Order];
    SourceTable=Table5405;
    SourceTableView=WHERE(Status=CONST(Released));
    PageType=Document;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 55      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Poster;
                                 ENU=E&ntries];
                      Image=Entries }
      { 66      ;3   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Vareposter;
                                 ENU=Item Ledger E&ntries];
                      ToolTipML=[DAN=Vis vareposterne for varen p� bilaget eller kladdelinjen.;
                                 ENU=View the item ledger entries of the item on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 38;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(No.);
                      Image=ItemLedger }
      { 69      ;3   ;Action    ;
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
      { 70      ;3   ;Action    ;
                      CaptionML=[DAN=V�rdiposter;
                                 ENU=Value Entries];
                      ToolTipML=[DAN=Vis v�rdiposterne for varen p� bilags- eller kladdelinjen.;
                                 ENU=View the value entries of the item on the document or journal line.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Production),
                                  Order No.=FIELD(No.);
                      Image=ValueLedger }
      { 7300    ;3   ;Action    ;
                      CaptionML=[DAN=&Lagerposter;
                                 ENU=&Warehouse Entries];
                      ToolTipML=[DAN="F� vist historikken over antal, der er registreret for varen under lageraktiviteter. ";
                                 ENU="View the history of quantities that are registered for the item in warehouse activities. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7318;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.);
                      RunPageLink=Source Type=FILTER(83|5406|5407),
                                  Source Subtype=FILTER(3|4|5),
                                  Source No.=FIELD(No.);
                      Image=BinLedger }
      { 76      ;2   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr�de, projekt eller afdeling, som du kan tildele til salgs- og k�bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDocDim;
                               END;
                                }
      { 90      ;2   ;Action    ;
                      Name=Planning;
                      CaptionML=[DAN=&Planl�gning;
                                 ENU=Plannin&g];
                      ToolTipML=[DAN=Planl�g forsyningsordrer for produktionsordren ordre for ordre.;
                                 ENU=Plan supply orders for the production order order by order.];
                      ApplicationArea=#Planning;
                      Image=Planning;
                      OnAction=VAR
                                 OrderPlanning@1000 : Page 5522;
                               BEGIN
                                 OrderPlanning.SetProdOrder(Rec);
                                 OrderPlanning.RUNMODAL;
                               END;
                                }
      { 78      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F� vist statistiske oplysninger om recorden, f.eks. v�rdien af bogf�rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000816;
                      RunPageLink=Status=FIELD(Status),
                                  No.=FIELD(No.),
                                  Date Filter=FIELD(Date Filter);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 71      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000838;
                      RunPageLink=Status=FIELD(Status),
                                  Prod. Order No.=FIELD(No.);
                      Image=ViewComments }
      { 7301    ;2   ;Action    ;
                      CaptionML=[DAN=L�g-p�-lager/pluklinjer/bev�gelseslinjer;
                                 ENU=Put-away/Pick Lines/Movement Lines];
                      ToolTipML=[DAN=Vis oversigten over igangv�rende l�g-p�-lager-aktiviteter, pluk eller bev�gelser for ordren.;
                                 ENU=View the list of ongoing inventory put-aways, picks, or movements for the order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 5785;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No.,Unit of Measure Code,Action Type,Breakbulk No.,Original Breakbulk);
                      RunPageLink=Source Type=FILTER(5406|5407),
                                  Source Subtype=CONST(3),
                                  Source No.=FIELD(No.);
                      Image=PutawayLines }
      { 7302    ;2   ;Action    ;
                      CaptionML=[DAN=&Registrerede pluklinjer;
                                 ENU=Registered P&ick Lines];
                      ToolTipML=[DAN=Vis oversigten over lagerpluk, der er foretaget for ordren.;
                                 ENU=View the list of warehouse picks that have been made for the order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7364;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No.);
                      RunPageLink=Source Type=CONST(5407),
                                  Source Subtype=CONST(3),
                                  Source No.=FIELD(No.);
                      Image=RegisteredDocs }
      { 7303    ;2   ;Action    ;
                      CaptionML=[DAN=Reg. linjer for flytning (lager);
                                 ENU=Registered Invt. Movement Lines];
                      ToolTipML=[DAN=Vis oversigten over flytning (lager), der er foretaget for ordren.;
                                 ENU=View the list of inventory movements that have been made for the order.];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7387;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.,Source Line No.,Source Subline No.);
                      RunPageLink=Source Type=CONST(5407),
                                  Source Subtype=CONST(3),
                                  Source No.=FIELD(No.);
                      Image=RegisteredDocs }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 24      ;2   ;Action    ;
                      Name=RefreshProductionOrder;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Op&dater produktionsordre;
                                 ENU=Re&fresh Production Order];
                      ToolTipML=[DAN=Beregn �ndringer, der er foretaget i produktionsordrehovedet uden at inkludere produktsstyklisteniveauer. Funktionen beregner og initialiserer v�rdierne for komponentlinjer og rutelinjer baseret p� de stamdata, som er defineret i den tilknyttede produktionsstykliste i overensstemmelse med ordreantallet og forfaldsdatoen i produktionsordrehovedet.;
                                 ENU=Calculate changes made to the production order header without involving production BOM levels. The function calculates and initiates the values of the component lines and routing lines based on the master data defined in the assigned production BOM and routing, according to the order quantity and due date on the production order's header.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=Refresh;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ProdOrder@1001 : Record 5405;
                               BEGIN
                                 ProdOrder.SETRANGE(Status,Status);
                                 ProdOrder.SETRANGE("No.","No.");
                                 REPORT.RUNMODAL(REPORT::"Refresh Production Order",TRUE,TRUE,ProdOrder);
                               END;
                                }
      { 25      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=R&eplanl�g;
                                 ENU=Re&plan];
                      ToolTipML=[DAN=Beregn �ndringer, der er foretaget i komponenter og rutelinjer, herunder varer p� lavere produktionsstyklisteniveauer, som der muligvis oprettes nye produktionsordrer for.;
                                 ENU=Calculate changes made to components and routings lines including items on lower production BOM levels for which it may generate new production orders.];
                      ApplicationArea=#Planning;
                      Promoted=Yes;
                      Image=Replan;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ProdOrder@1001 : Record 5405;
                               BEGIN
                                 ProdOrder.SETRANGE(Status,Status);
                                 ProdOrder.SETRANGE("No.","No.");
                                 REPORT.RUNMODAL(REPORT::"Replan Production Order",TRUE,TRUE,ProdOrder);
                               END;
                                }
      { 53      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Skift st&atus;
                                 ENU=Change &Status];
                      ToolTipML=[DAN=Skift produktionsordren til en anden status, f.eks. frigivet.;
                                 ENU=Change the production order to another status, such as Released.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=ChangeStatus;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CurrPage.UPDATE;
                                 CODEUNIT.RUN(CODEUNIT::"Prod. Order Status Management",Rec);
                               END;
                                }
      { 57      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Opdater kostpris;
                                 ENU=&Update Unit Cost];
                      ToolTipML=[DAN=Opdater kostprisen for den overordnede vare pr. �ndringer til produktionsstyklisten eller ruten.;
                                 ENU=Update the cost of the parent item per changes to the production BOM or routing.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=UpdateUnitCost;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ProdOrder@1001 : Record 5405;
                               BEGIN
                                 ProdOrder.SETRANGE(Status,Status);
                                 ProdOrder.SETRANGE("No.","No.");

                                 REPORT.RUNMODAL(REPORT::"Update Unit Cost",TRUE,TRUE,ProdOrder);
                               END;
                                }
      { 72      ;2   ;Action    ;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n�dvendige m�ngde p� den bilagslinje, som vinduet blev �bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Manufacturing;
                      Image=Reserve;
                      OnAction=BEGIN
                                 CurrPage.ProdOrderLines.PAGE.PageShowReservation;
                               END;
                                }
      { 73      ;2   ;Action    ;
                      Name=OrderTracking;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil h�rende eftersp�rgsel. P� denne m�de kan du finde den oprindelige eftersp�rgsel, der medf�rte en specifik produktionsordre eller k�bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#Manufacturing;
                      Image=OrderTracking;
                      OnAction=BEGIN
                                 CurrPage.ProdOrderLines.PAGE.ShowTracking;
                               END;
                                }
      { 74      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=K&opier produktionsordredok.;
                                 ENU=C&opy Prod. Order Document];
                      ToolTipML=[DAN=Kopi�r oplysninger fra en eksisterende produktionsordrerecord til en ny. Det kan g�res uanset produktionsordrens statustype. Du kan f.eks. kopiere fra en frigivet produktionsordre til en ny planlagt produktionsordre. Bem�rk, at du skal oprette den nye record, f�r du begynder at kopiere.;
                                 ENU=Copy information from an existing production order record to a new one. This can be done regardless of the status type of the production order. You can, for example, copy from a released production order to a new planned production order. Note that before you start to copy, you have to create the new record.];
                      ApplicationArea=#Manufacturing;
                      Image=CopyDocument;
                      OnAction=BEGIN
                                 CopyProdOrderDoc.SetProdOrder(Rec);
                                 CopyProdOrderDoc.RUNMODAL;
                                 CLEAR(CopyProdOrderDoc);
                               END;
                                }
      { 5       ;1   ;ActionGroup;
                      CaptionML=[DAN=Lagersted;
                                 ENU=Warehouse];
                      Image=Worksheets }
      { 48      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret &l�g-p�-lager/pluk/bev�gelse;
                                 ENU=Create Inventor&y Put-away/Pick/Movement];
                      ToolTipML=[DAN=G�r dig klar til at oprette l�g-p�-lager-aktiviteter, pluk eller bev�gelser for den overordnede vare eller komponenter p� produktionsordren.;
                                 ENU=Prepare to create inventory put-aways, picks, or movements for the parent item or components on the production order.];
                      ApplicationArea=#Warehouse;
                      Image=CreatePutAway;
                      OnAction=BEGIN
                                 CreateInvtPutAwayPick;
                               END;
                                }
      { 80      ;2   ;Action    ;
                      CaptionML=[DAN=Opre&t indg. lageranmodning;
                                 ENU=Create I&nbound Whse. Request];
                      ToolTipML=[DAN=Giv besked til lagerstedet om, at de producerede varer er klar til at blive h�ndteret. Anmodningen muligg�r oprettelse af det p�kr�vede lagerdokument, f.eks. en l�g-p�-lager-aktivitet.;
                                 ENU=Signal to the warehouse that the produced items are ready to be handled. The request enables the creation of the require warehouse document, such as a put-away.];
                      ApplicationArea=#Warehouse;
                      Image=NewToDo;
                      OnAction=VAR
                                 WhseOutputProdRelease@1000 : Codeunit 7325;
                               BEGIN
                                 IF WhseOutputProdRelease.CheckWhseRqst(Rec) THEN
                                   MESSAGE(Text002)
                                 ELSE BEGIN
                                   CLEAR(WhseOutputProdRelease);
                                   IF WhseOutputProdRelease.Release(Rec) THEN
                                     MESSAGE(Text000)
                                   ELSE
                                     MESSAGE(Text001);
                                 END;
                               END;
                                }
      { 62      ;2   ;Action    ;
                      AccessByPermission=TableData 7302=R;
                      CaptionML=[DAN=Opret pluk (logistik);
                                 ENU=Create Whse. Pick];
                      ToolTipML=[DAN=G�r dig klar til at oprette lagerpluk for linjerne p� ordren. N�r du har valgt indstillinger og k�rer funktionen, oprettes der et lagerplukdokument for produktionsordrekomponenterne.;
                                 ENU=Prepare to create warehouse picks for the lines on the order. When you have selected options and you run the function, a warehouse pick document are created for the production order components.];
                      ApplicationArea=#Warehouse;
                      Image=CreateWarehousePick;
                      OnAction=BEGIN
                                 SetHideValidationDialog(FALSE);
                                 CreatePick(USERID,0,FALSE,FALSE,FALSE);
                               END;
                                }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      Image=Print }
      { 21      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Jobkort;
                                 ENU=Job Card];
                      ToolTipML=[DAN=Vis en oversigt over igangv�rende arbejde i forbindelse med en produktionsordre. Afgang, spildantal og genneml�bstid vises eller udskrives afh�ngigt af operationen.;
                                 ENU=View a list of the work in progress of a production order. Output, scrapped quantity, and production lead time are shown depending on the operation.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ManuPrintReport.PrintProductionOrder(Rec,0);
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Mat.&rekvisition;
                                 ENU=Mat. &Requisition];
                      ToolTipML=[DAN=Vis en liste med materialebehovet pr. produktionsordre. Rapporten viser status for den p�g�ldende produktionsordre, antallet af f�rdigvarer og komponenter og de tilsvarende behov. Du kan ogs� se forfaldsdatoen og lokationskoden for hver enkelt komponent.;
                                 ENU=View a list of material requirements per production order. The report shows you the status of the production order, the quantity of end items and components with the corresponding required quantity. You can view the due date and location code of each component.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ManuPrintReport.PrintProductionOrder(Rec,1);
                               END;
                                }
      { 46      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Mankoliste;
                                 ENU=Shortage List];
                      ToolTipML=[DAN=Vis en liste med antallet af manglende varer pr. produktionsordre. Rapporten giver et overblik over lagerdisponeringen fra dags dato indtil en bestemt dato - f.eks. hvilke ordrer der endnu er �bne.;
                                 ENU=View a list of the missing quantity per production order. The report shows how the inventory development is planned from today until the set day - for example whether orders are still open.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ManuPrintReport.PrintProductionOrder(Rec,2);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1906187306;1 ;Action    ;
                      CaptionML=[DAN=U.leverand�r - ordreoversigt;
                                 ENU=Subcontractor - Dispatch List];
                      ToolTipML=[DAN=Vis oversigten over materiale, der skal sendes til produktionsunderleverand�rer.;
                                 ENU=View the list of material to be sent to manufacturing subcontractors.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Report 99000789;
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
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 16  ;2   ;Field     ;
                Lookup=No;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No.";
                Importance=Promoted;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af produktionsordren.;
                           ENU=Specifies the description of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description;
                Importance=Promoted;
                QuickEntry=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del i produktionsordrebeskrivelsen.;
                           ENU=Specifies an additional part of the production order description.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Description 2";
                QuickEntry=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildetypen for produktionsordren.;
                           ENU=Specifies the source type of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Source Type";
                OnValidate=BEGIN
                             IF xRec."Source Type" <> "Source Type" THEN
                               "Source No." := '';
                           END;
                            }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� det kildebilag, som posten stammer fra.;
                           ENU=Specifies the number of the source document that the entry originates from.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Source No." }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver s�gebeskrivelsen.;
                           ENU=Specifies the search description.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Description";
                QuickEntry=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen eller familien der skal produceres (produktionsantal).;
                           ENU=Specifies how many units of the item or the family to produce (production quantity).];
                ApplicationArea=#Manufacturing;
                SourceExpr=Quantity;
                Importance=Promoted }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for produktionsordren.;
                           ENU=Specifies the due date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date" }

    { 68  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Assigned User ID";
                QuickEntry=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogf�res under transaktioner - eksempelvis en debitor, som er erkl�ret insolvent, eller en vare, som er sat i karant�ne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Blocked;
                QuickEntry=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r produktionsordrekortet sidst blev �ndret.;
                           ENU=Specifies when the production order card was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified";
                QuickEntry=FALSE }

    { 26  ;1   ;Part      ;
                Name=ProdOrderLines;
                ApplicationArea=#Manufacturing;
                SubPageLink=Prod. Order No.=FIELD(No.);
                PagePartID=Page99000832;
                PartType=Page }

    { 1907170701;1;Group  ;
                CaptionML=[DAN=Plan;
                           ENU=Schedule] }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl�ttet for produktionsordren.;
                           ENU=Specifies the starting time of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Importance=Promoted }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for produktionsordren.;
                           ENU=Specifies the starting date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date";
                Importance=Promoted }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl�ttet for produktionsordren.;
                           ENU=Specifies the ending time of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time";
                Importance=Promoted }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for produktionsordren.;
                           ENU=Specifies the ending date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date";
                Importance=Promoted }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogf�ring;
                           ENU=Posting] }

    { 81  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver links mellem forretningstransaktioner, som er lavet til varen, og en lagerkonto i finansposterne for at samle bel�bene for denne varetype i en gruppe.;
                           ENU=Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Inventory Posting Group";
                Importance=Promoted }

    { 83  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens produkttype for at knytte transaktioner, der er foretaget for denne vare, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the item's product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Gen. Prod. Posting Group" }

    { 85  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kreditorens eller kundens handelstype for at knytte transaktioner, der er foretaget for denne forretningspartner, til den relevante finanskonto i overensstemmelse med den generelle bogf�ringsops�tning.;
                           ENU=Specifies the vendor's or customer's trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Gen. Bus. Posting Group" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                OnValidate=BEGIN
                             ShortcutDimension1CodeOnAfterV;
                           END;
                            }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops�tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                OnValidate=BEGIN
                             ShortcutDimension2CodeOnAfterV;
                           END;
                            }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokationskode, som det f�rdige produkt fra produktionsordren skal bogf�res til.;
                           ENU=Specifies the location code to which you want to post the finished product from this production order.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted }

    { 88  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en placering, hvor du vil bogf�re de f�rdige varer.;
                           ENU=Specifies a bin to which you want to post the finished items.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Importance=Promoted }

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
      CopyProdOrderDoc@1000 : Report 99003802;
      ManuPrintReport@1001 : Codeunit 99000817;
      Text000@1002 : TextConst 'DAN=Der er oprettet indg�ende lager.;ENU=Inbound Whse. Requests are created.';
      Text001@1003 : TextConst 'DAN=Der er ikke oprettet indg�ende lageranmodninger.;ENU=No Inbound Whse. Request is created.';
      Text002@1004 : TextConst 'DAN=Der er allerede oprettet indg�ende lageranmodninger.;ENU=Inbound Whse. Requests have already been created.';

    LOCAL PROCEDURE ShortcutDimension1CodeOnAfterV@19029405();
    BEGIN
      CurrPage.ProdOrderLines.PAGE.UpdateForm(TRUE);
    END;

    LOCAL PROCEDURE ShortcutDimension2CodeOnAfterV@19008725();
    BEGIN
      CurrPage.ProdOrderLines.PAGE.UpdateForm(TRUE);
    END;

    BEGIN
    END.
  }
}

