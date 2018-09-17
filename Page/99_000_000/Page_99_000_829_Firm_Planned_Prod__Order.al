OBJECT Page 99000829 Firm Planned Prod. Order
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Fastlagt produktionsordre;
               ENU=Firm Planned Prod. Order];
    SourceTable=Table5405;
    SourceTableView=WHERE(Status=CONST(Firm Planned));
    PageType=Document;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 59      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Ordre;
                                 ENU=O&rder];
                      Image=Order }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 99000838;
                      RunPageLink=Status=FIELD(Status),
                                  Prod. Order No.=FIELD(No.);
                      Image=ViewComments }
      { 60      ;2   ;Action    ;
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
                                 CurrPage.SAVERECORD;
                               END;
                                }
      { 67      ;2   ;Action    ;
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
      { 74      ;2   ;Action    ;
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 23      ;2   ;Action    ;
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
      { 24      ;2   ;Action    ;
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
      { 25      ;2   ;Action    ;
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
      { 36      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Opdater kostpris;
                                 ENU=&Update Unit Cost];
                      ToolTipML=[DAN=Opdater kostprisen for den overordnede vare pr. �ndringer til produktionsstyklisten eller ruten.;
                                 ENU=Update the cost of the parent item per changes to the production BOM or routing.];
                      ApplicationArea=#Manufacturing;
                      Image=UpdateUnitCost;
                      OnAction=VAR
                                 ProdOrder@1001 : Record 5405;
                               BEGIN
                                 ProdOrder.SETRANGE(Status,Status);
                                 ProdOrder.SETRANGE("No.","No.");

                                 REPORT.RUNMODAL(REPORT::"Update Unit Cost",TRUE,TRUE,ProdOrder);
                               END;
                                }
      { 71      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=K&opier produktionsordredok.;
                                 ENU=C&opy Prod. Order Document];
                      ToolTipML=[DAN=Kopi�r oplysninger fra en eksisterende produktionsordrerecord til en ny. Det kan g�res uanset produktionsordrens statustype. Du kan f.eks. kopiere fra en frigivet produktionsordre til en ny planlagt produktionsordre. Bem�rk, at du skal oprette den nye record, f�r du begynder at kopiere.;
                                 ENU=Copy information from an existing production order record to a new one. This can be done regardless of the status type of the production order. You can, for example, copy from a released production order to a new planned production order. Note that before you start to copy, you have to create the new record.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=CopyDocument;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CopyProdOrderDoc.SetProdOrder(Rec);
                                 CopyProdOrderDoc.RUNMODAL;
                                 CLEAR(CopyProdOrderDoc);
                               END;
                                }
      { 37      ;1   ;ActionGroup;
                      CaptionML=[DAN=U&dskriv;
                                 ENU=&Print];
                      Image=Print }
      { 45      ;2   ;Action    ;
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
      { 46      ;2   ;Action    ;
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
      { 47      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Mankoliste;
                                 ENU=Shortage List];
                      ToolTipML=[DAN=Vis en liste med antallet af manglende varer pr. produktionsordre. Rapporten giver et overblik over lagerdisponeringen fra dags dato indtil en bestemt dato - f.eks. hvilke ordrer der endnu er �bne.;
                                 ENU=View a list of the missing quantity per production order. The report shows how the inventory development is planned from today until the set day - for example whether orders are still open.];
                      ApplicationArea=#Manufacturing;
                      Image=Report;
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

    { 27  ;2   ;Field     ;
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
                Importance=Promoted }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende del i produktionsordrebeskrivelsen.;
                           ENU=Specifies an additional part of the production order description.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Description 2" }

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

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver s�gebeskrivelsen.;
                           ENU=Specifies the search description.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Search Description" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen eller familien der skal produceres (produktionsantal).;
                           ENU=Specifies how many units of the item or the family to produce (production quantity).];
                ApplicationArea=#Manufacturing;
                SourceExpr=Quantity;
                Importance=Promoted }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen for produktionsordren.;
                           ENU=Specifies the due date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date" }

    { 72  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Assigned User ID" }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn�r produktionsordrekortet sidst blev �ndret.;
                           ENU=Specifies when the production order card was last modified.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Last Date Modified" }

    { 26  ;1   ;Part      ;
                Name=ProdOrderLines;
                ApplicationArea=#Manufacturing;
                SubPageLink=Prod. Order No.=FIELD(No.);
                PagePartID=Page99000830;
                PartType=Page }

    { 1907170701;1;Group  ;
                CaptionML=[DAN=Plan;
                           ENU=Schedule] }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startklokkesl�ttet for produktionsordren.;
                           ENU=Specifies the starting time of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Importance=Promoted;
                OnValidate=BEGIN
                             StartingTimeOnAfterValidate;
                           END;
                            }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for produktionsordren.;
                           ENU=Specifies the starting date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date";
                Importance=Promoted;
                OnValidate=BEGIN
                             StartingDateOnAfterValidate;
                           END;
                            }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutklokkesl�ttet for produktionsordren.;
                           ENU=Specifies the ending time of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time";
                Importance=Promoted;
                OnValidate=BEGIN
                             EndingTimeOnAfterValidate;
                           END;
                            }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for produktionsordren.;
                           ENU=Specifies the ending date of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date";
                Importance=Promoted;
                OnValidate=BEGIN
                             EndingDateOnAfterValidate;
                           END;
                            }

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

    { 49  ;2   ;Field     ;
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

    LOCAL PROCEDURE StartingTimeOnAfterValidate@19008557();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE StartingDateOnAfterValidate@19020273();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE EndingTimeOnAfterValidate@19075483();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE EndingDateOnAfterValidate@19076447();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

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

